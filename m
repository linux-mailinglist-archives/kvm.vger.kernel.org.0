Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC11463595
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfGIMZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:27 -0400
Received: from foss.arm.com ([217.140.110.172]:42670 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfGIMZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C08F150C;
        Tue,  9 Jul 2019 05:25:26 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6014C3F59C;
        Tue,  9 Jul 2019 05:25:24 -0700 (PDT)
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
Subject: [PATCH 03/18] KVM: arm64: Make indirect vectors preamble behaviour symmetric
Date:   Tue,  9 Jul 2019 13:24:52 +0100
Message-Id: <20190709122507.214494-4-marc.zyngier@arm.com>
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

The KVM indirect vectors support is a little complicated. Different CPUs
may use different exception vectors for KVM that are generated at boot.
Adding new instructions involves checking all the possible combinations
do the right thing.

To make changes here easier to review lets state what we expect of the
preamble:
  1. The first vector run, must always run the preamble.
  2. Patching the head or tail of the vector shouldn't remove
     preamble instructions.

Today, this is easy as we only have one instruction in the preamble.
Change the unpatched tail of the indirect vector so that it always
runs this, regardless of patching.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 318a2f3996fc..a911b8ffc0f3 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -275,7 +275,7 @@ ENDPROC(__kvm_hyp_vector)
 /*
  * The default sequence is to directly branch to the KVM vectors,
  * using the computed offset. This applies for VHE as well as
- * !ARM64_HARDEN_EL2_VECTORS.
+ * !ARM64_HARDEN_EL2_VECTORS. The first vector must always run the preamble.
  *
  * For ARM64_HARDEN_EL2_VECTORS configurations, this gets replaced
  * with:
@@ -291,8 +291,8 @@ ENDPROC(__kvm_hyp_vector)
  * See kvm_patch_vector_branch for details.
  */
 alternative_cb	kvm_patch_vector_branch
-	b	__kvm_hyp_vector + (1b - 0b)
-	nop
+	stp	x0, x1, [sp, #-16]!
+	b	__kvm_hyp_vector + (1b - 0b + KVM_VECTOR_PREAMBLE)
 	nop
 	nop
 	nop
-- 
2.20.1

