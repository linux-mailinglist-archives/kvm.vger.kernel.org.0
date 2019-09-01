Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD611A4C39
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2019 23:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbfIAVNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 17:13:02 -0400
Received: from foss.arm.com ([217.140.110.172]:46442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbfIAVNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 17:13:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E29DE15A2;
        Sun,  1 Sep 2019 14:13:00 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABBDD3F77D;
        Sun,  1 Sep 2019 14:12:59 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 3/3] arm64: KVM: Kill hyp_alternate_select()
Date:   Sun,  1 Sep 2019 22:12:37 +0100
Message-Id: <20190901211237.11673-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190901211237.11673-1-maz@kernel.org>
References: <20190901211237.11673-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hyp_alternate_select() is now completely unused. Goodbye.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 86825aa20852..97f21cc66657 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -47,30 +47,6 @@
 #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
 #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
 
-/**
- * hyp_alternate_select - Generates patchable code sequences that are
- * used to switch between two implementations of a function, depending
- * on the availability of a feature.
- *
- * @fname: a symbol name that will be defined as a function returning a
- * function pointer whose type will match @orig and @alt
- * @orig: A pointer to the default function, as returned by @fname when
- * @cond doesn't hold
- * @alt: A pointer to the alternate function, as returned by @fname
- * when @cond holds
- * @cond: a CPU feature (as described in asm/cpufeature.h)
- */
-#define hyp_alternate_select(fname, orig, alt, cond)			\
-typeof(orig) * __hyp_text fname(void)					\
-{									\
-	typeof(alt) *val = orig;					\
-	asm volatile(ALTERNATIVE("nop		\n",			\
-				 "mov	%0, %1	\n",			\
-				 cond)					\
-		     : "+r" (val) : "r" (alt));				\
-	return val;							\
-}
-
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
-- 
2.20.1

