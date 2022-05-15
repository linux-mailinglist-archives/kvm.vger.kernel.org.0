Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C1B5278E2
	for <lists+kvm@lfdr.de>; Sun, 15 May 2022 19:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiEORRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 May 2022 13:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiEORRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 May 2022 13:17:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEBCDFD6;
        Sun, 15 May 2022 10:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652635038; x=1684171038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KYPpmCqaYm6PKBzjbAt+0LaUtQHugFCcWHEHTiJmM2s=;
  b=Sciz8hZdL/lz/15RjHYKnopqOyjc9a2lm2LWiNPk25hsRexurrv/B7f8
   q5Cb7EL3HrSoWmxsFXK/BRB8CwTHPAfnrWZwZ94BaSB2SgovII8LQQemn
   aqwMkcnGPtWtz20FzL4W9ezRe+QV0gB6CkfkxdFH9sA77kbTY1/TM4aND
   TsuyBOX4fHZAK0GXXmSKwvEif+ak+tufr1gIIAP0+ZDnCIknQldLiHFo/
   h9ehN4GLOXKO+S4wK6TjphM/fS6kS0Kwf5901/wwqzRUo+4QfDaG8Ix5C
   6w2077njf6xTns5o+Vs9p00XNBe8aj6B6y/q+tVfrsj1KmtYcpNY072IC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="333719481"
X-IronPort-AV: E=Sophos;i="5.91,228,1647327600"; 
   d="scan'208";a="333719481"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 10:17:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,228,1647327600"; 
   d="scan'208";a="544016288"
Received: from tower.bj.intel.com ([10.238.157.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 10:17:12 -0700
From:   Yanfei Xu <yanfei.xu@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest
Date:   Mon, 16 May 2022 01:16:33 +0800
Message-Id: <20220515171633.902901-1-yanfei.xu@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kernel handles the vm-exit caused by external interrupts and PMI,
it always set a type of kvm_intr_type to handling_intr_from_guest to
tell if it's dealing an IRQ or NMI.
However, the further type judgment is missing in kvm_arch_pmi_in_guest().
It could make the PMI of intel_pt wrongly considered it comes from a
guest once the PMI breaks the handling of vm-exit of external interrupts.

Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 8 +++++++-
 arch/x86/kvm/x86.h              | 6 ------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ff36610af6a..308cf19f123d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1582,8 +1582,14 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
+enum kvm_intr_type {
+	/* Values are arbitrary, but must be non-zero. */
+	KVM_HANDLING_IRQ = 1,
+	KVM_HANDLING_NMI,
+};
+
 #define kvm_arch_pmi_in_guest(vcpu) \
-	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
+	((vcpu) && (vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)
 
 void kvm_mmu_x86_module_init(void);
 int kvm_mmu_vendor_module_init(void);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 588792f00334..3bdf1bc76863 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -344,12 +344,6 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-enum kvm_intr_type {
-	/* Values are arbitrary, but must be non-zero. */
-	KVM_HANDLING_IRQ = 1,
-	KVM_HANDLING_NMI,
-};
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
 					enum kvm_intr_type intr)
 {
-- 
2.32.0

