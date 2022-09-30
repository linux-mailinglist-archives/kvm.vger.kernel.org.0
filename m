Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651225F087D
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiI3KUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiI3KTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA08F15ED3C;
        Fri, 30 Sep 2022 03:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533140; x=1696069140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dbcgdh/LKzhol7ZEIFT7uC8aHwK+z6qgswQmkF6mbW4=;
  b=PRyF3d2zHeNvY9HTqKp52Ncf+Hh4BbGoxMdWTNtIjg/H9OYIc7H2psxV
   m9CxAeL8gHvkecRiyenhoKjQzJxGgdLWveR791TjhfIvWN/ANI1/hBgtK
   T0Gidv6wmNDgKjoXHkwdgmRjyL8jRFUoIiPSnRnCE3JGqffx92uBvxdW8
   tmoH+VJQkZJso+hyGcH+D5BLPQi9vYVI5rtsX/k9dprwSk9iqbaNBKw26
   +PP4Wj+e8ETIcudCLalLUX5/9TFJT81r40DuCJPeiyND/b9W0Rt5kKbPW
   m+OwUDL2D+MzVWZN+8i4GQyhvVaYZiXzXUVd5YJcS8+tOkJJ54opJdI2t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870083"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870083"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807593"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807593"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v9 028/105] KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
Date:   Fri, 30 Sep 2022 03:17:22 -0700
Message-Id: <98006089a38c9521d666bd074f7b99c68604a934.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 531f04e36904..fc28bf9c0552 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1366,6 +1366,10 @@ struct kvm_arch {
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
index c94b620bf94b..000a0a6ac815 100644
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
index 10b0ac09bd00..af99a46d1e75 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -784,6 +784,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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

