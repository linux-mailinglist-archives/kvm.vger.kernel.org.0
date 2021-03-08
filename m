Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD260331524
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCHRrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:47:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhCHRq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 12:46:56 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2450165296;
        Mon,  8 Mar 2021 17:46:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lJJxy-000OD8-8a; Mon, 08 Mar 2021 17:46:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Date:   Mon,  8 Mar 2021 17:46:43 +0000
Message-Id: <20210308174643.761100-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 has forever used a 40bit default IPA space, partially
due to its 32bit heritage (where the only choice is 40bit).

However, there are implementations in the wild that have a *cough*
much smaller *cough* IPA space, which leads to a misprogramming of
VTCR_EL2, and a guest that is stuck on its first memory access
if userspace dares to ask for the default IPA setting (which most
VMMs do).

Instead, cap the default IPA size to what the host can actually
do, and spit out a one-off message on the console. The boot warning
is turned into a more meaningfull message, and the new behaviour
is also documented.

Although this is a userspace ABI change, it doesn't really change
much for userspace:

- the guest couldn't run before this change, while it now has
  a chance to if the memory range fits the reduced IPA space

- a memory slot that was accepted because it did fit the default
  IPA space but didn't fit the HW constraints is now properly
  rejected

The other thing that's left doing is to convince userspace to
actually use the IPA space setting instead of relying on the
antiquated default.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 13 +++++++------
 arch/arm64/kvm/reset.c         | 12 ++++++++----
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aed52b0fc16e..80c710035f31 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -158,12 +158,13 @@ flag KVM_VM_MIPS_VZ.
 
 
 On arm64, the physical address size for a VM (IPA Size limit) is limited
-to 40bits by default. The limit can be configured if the host supports the
-extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
+to 40bits by default, though capped to the host's limit. The VM's own
+limit can be configured if the host supports the extension
+KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
 KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
-identifier, where IPA_Bits is the maximum width of any physical
-address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
-machine type identifier.
+identifier, where IPA_Bits is the maximum width of any physical address
+used by the VM. The IPA_Bits is encoded in bits[7-0] of the machine type
+identifier.
 
 e.g, to configure a guest to use 48bit physical address size::
 
@@ -172,7 +173,7 @@ e.g, to configure a guest to use 48bit physical address size::
 The requested size (IPA_Bits) must be:
 
  ==   =========================================================
-  0   Implies default size, 40bits (for backward compatibility)
+  0   Implies default size, 40bits or less (for backward compatibility)
   N   Implies N bits, where N is a positive integer such that,
       32 <= N <= Host_IPA_Limit
  ==   =========================================================
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 47f3f035f3ea..1f22b36a0eff 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -324,10 +324,9 @@ int kvm_set_ipa_limit(void)
 	}
 
 	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
-	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
-	     "KVM IPA Size Limit (%d bits) is smaller than default size\n",
-	     kvm_ipa_limit);
-	kvm_info("IPA Size Limit: %d bits\n", kvm_ipa_limit);
+	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
+		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
+		  " (Reduced IPA size, limited VM compatibility)" : ""));
 
 	return 0;
 }
@@ -356,6 +355,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 			return -EINVAL;
 	} else {
 		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("Userspace using unsupported default IPA limit, capping to %d bits\n",
+				     kvm_ipa_limit);
+			phys_shift = kvm_ipa_limit;
+		}
 	}
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-- 
2.30.0

