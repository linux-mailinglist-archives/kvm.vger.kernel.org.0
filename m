Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C836359F
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGIMZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:37 -0400
Received: from foss.arm.com ([217.140.110.172]:42738 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfGIMZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3516E152F;
        Tue,  9 Jul 2019 05:25:36 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 673BA3F59C;
        Tue,  9 Jul 2019 05:25:34 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/18] KVM: arm64: Skip more of the SError vaxorcism
Date:   Tue,  9 Jul 2019 13:24:57 +0100
Message-Id: <20190709122507.214494-9-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
References: <20190709122507.214494-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

During __guest_exit() we need to consume any SError left pending by the
guest so it doesn't contaminate the host. With v8.2 we use the
ESB-instruction. For systems without v8.2, we use dsb+isb and unmask
SError. We do this on every guest exit.

Use the same dsb+isr_el1 trick, this lets us know if an SError is pending
after the dsb, allowing us to skip the isb and self-synchronising PSTATE
write if its not.

This means SError remains masked during KVM's world-switch, so any SError
that occurs during this time is reported by the host, instead of causing
a hyp-panic.

As we're benchmarking this code lets polish the layout. If you give gcc
likely()/unlikely() hints in an if() condition, it shuffles the generated
assembly so that the likely case is immediately after the branch. Lets
do the same here.

Signed-off-by: James Morse <james.morse@arm.com>

Changes since v2:
 * Added isb after the dsb to prevent an early read

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/entry.S | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 5e25cc0e6aab..e5cc8d66bf53 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -151,8 +151,16 @@ alternative_if ARM64_HAS_RAS_EXTN
 	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
 1:	ret
 alternative_else
-	// If we have a pending asynchronous abort, now is the
-	// time to find out. From your VAXorcist book, page 666:
+	dsb	sy		// Synchronize against in-flight ld/st
+	isb			// Prevent an early read of side-effect free ISR
+	mrs	x2, isr_el1
+	tbnz	x2, #8, 2f	// ISR_EL1.A
+	ret
+	nop
+2:
+alternative_endif
+	// We know we have a pending asynchronous abort, now is the
+	// time to flush it out. From your VAXorcist book, page 666:
 	// "Threaten me not, oh Evil one!  For I speak with
 	// the power of DEC, and I command thee to show thyself!"
 	mrs	x2, elr_el2
@@ -160,9 +168,7 @@ alternative_else
 	mrs	x4, spsr_el2
 	mov	x5, x0
 
-	dsb	sy		// Synchronize against in-flight ld/st
 	msr	daifclr, #4	// Unmask aborts
-alternative_endif
 
 	// This is our single instruction exception window. A pending
 	// SError is guaranteed to occur at the earliest when we unmask
-- 
2.20.1

