Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4545A58BD52
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbiHGWEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiHGWDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:03:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167F19FEB;
        Sun,  7 Aug 2022 15:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909763; x=1691445763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rMS/jes3ulTGlS+lCBjKfl2qZrmtV++3vHYTl2xsko=;
  b=jh/nndgi3wIO/cA9NQfRGyD3rR8aBjucevaKents9bagCNanfDEyaWMM
   RktCxPNObIfr3AwilT23E/xM4lkVhpWJJNWKDGY9Vi70XR1qV2UJpXx0O
   m67Iqc+yPgmi6jJ3YOK+QksoKYzuqGUDLPDmF9mrNFU9NE9M8KgFOWmhK
   ql6CkvOu7QycTb7flUUM0PCMeOfbsCx6mTsBTvEDMFKvabGdf8xCk3QYM
   75EoymEYb+x+j2TsS+ARVY3WIZeAfUc9H/vYKu0cHZthAliq4aPUYwQNT
   iunQFRXggHWwQ/jABTqJEQjO3HWzlHjJwcyDkJDQr5OQsvmC4+FhsSdhG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224105"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224105"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682532"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:33 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 030/103] KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
Date:   Sun,  7 Aug 2022 15:01:15 -0700
Message-Id: <97e6f89f0460ac0b29392528e848cca2458b54c9.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
GPA.shared is set, GPA is covered by the existing conventional EPT pointed
by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
VMM has to issue SEAMCALLs to operate.

Add a member to remember GPA shared bit for each guest TDs, add address
conversion functions between private GPA and shared GPA and test if GPA
is private.

Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
the new member to remember GPA shared bit is guaranteed to be zero with
this patch unless it's initialized explicitly.

Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c          |  5 +++++
 3 files changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e856abbe80ab..6787d5214fd8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1358,6 +1358,10 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	gfn_t gfn_shared_mask;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index a99acec925eb..df9f79ee07d4 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -276,4 +276,36 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
+static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	return kvm->arch.gfn_shared_mask;
+#else
+	return 0;
+#endif
+}
+
+static inline gfn_t kvm_gfn_shared(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn | kvm_gfn_shared_mask(kvm);
+}
+
+static inline gfn_t kvm_gfn_private(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn & ~kvm_gfn_shared_mask(kvm);
+}
+
+static inline gpa_t kvm_gpa_private(const struct kvm *kvm, gpa_t gpa)
+{
+	return gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(kvm));
+}
+
+static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
+{
+	gfn_t mask = kvm_gfn_shared_mask(kvm);
+
+	return mask && !(gpa_to_gfn(gpa) & mask);
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 37272fe1e69f..36d2127cb7b7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -753,6 +753,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->xfam = td_params->xfam;
 	kvm->max_vcpus = td_params->max_vcpus;
 
+	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
+	else
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
+
 out:
 	/* kfree() accepts NULL. */
 	kfree(init_vm);
-- 
2.25.1

