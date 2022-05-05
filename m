Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9D451C77F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358767AbiEESXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383196AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5338DA9;
        Thu,  5 May 2022 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774552; x=1683310552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h813y3dEF676rU6qIUTQNIYMn233TjmsldMLS/ofG4A=;
  b=NhjCzpdOuT8ommU+JsCv0cUJBr4IbzsiAuYbKrjNaOKa9nuoi0XKtyeO
   HZLY3K/aY/9WdBIFf9vCgRHxseu5ChMqZvg3xw68Mcbt9LZY4ytoXwh2Z
   4drzjvM0R5evYp6Cvc0JvGyJDmklnDYdaS7/CqFD6B41E0rbY4mdQZ8iY
   jM6GnybT7FfMaixizDSXTOnO1kxxCjYKsbCaRGNsoRKqfG3jvq4KpDzMN
   5ZpPWJxInorBbk/hl2RnrTR3horq4eXjMEcTPSao6evHEdZR8/oUS+Rr3
   6SSNigObRkV+eiOFGvk9aCMvqwWFAk1Cu+RRAsIsGGLmABsEC0/aJRpI/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742015"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742015"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083250"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:44 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 034/104] KVM: x86/mmu: Add address conversion functions for TDX shared bits
Date:   Thu,  5 May 2022 11:14:28 -0700
Message-Id: <38c30f2c5ad6f9ca018c3e990f244c9b67ef10cb.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

TDX repurposes one GPA bits (51 bit or 47 bit based on configuration) to
indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
GPA.shared is set, GPA is converted existing conventional EPT pointed by
EPTP.  If GPA.shared bit is cleared, GPA is converted by Secure-EPT(S-EPT)
TDX module manages.  VMM has to issue SEAM call to TDX module to operate on
S-EPT.  e.g. populating/zapping guest page or shadow page by TDH.PAGE.{ADD,
REMOVE} for guest page, TDH.PAGE.SEPT.{ADD, REMOVE} S-EPT etc.

Several hooks needs to be added to KVM MMU to support TDX.  Add a function
to check if KVM MMU is running for TDX and several functions for address
conversation between private-GPA and shared-GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu.c          |  6 ++++--
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 60a97ae55972..88fd3fd3e1a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1251,7 +1251,9 @@ struct kvm_arch {
 	 */
 	u32 max_vcpu_ids;
 
+#ifdef CONFIG_KVM_MMU_PRIVATE
 	gfn_t gfn_shared_mask;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7e258cc94152..3647035a147e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -373,4 +373,36 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
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
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 909372762363..d1c37295bb6e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -264,8 +264,10 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 {
 	int ret = -ENOTSUPP;
 
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
+	if (range && kvm_available_flush_tlb_with_range()) {
+		/* Callback should flush both private GFN and shared GFN. */
 		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
+	}
 
 	if (ret)
 		kvm_flush_remote_tlbs(kvm);
@@ -4048,7 +4050,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	unsigned long mmu_seq;
 	int r;
 
-	fault->gfn = fault->addr >> PAGE_SHIFT;
+	fault->gfn = gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
 	if (page_fault_handle_page_track(vcpu, fault))
-- 
2.25.1

