Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BA8647A26
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiLHXgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiLHXgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:36:08 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9677E6FF0F;
        Thu,  8 Dec 2022 15:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542562; x=1702078562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zWuGHJKvb2rhePR8KFWGDOd9HnNPDNaoiycd/Rf+gtg=;
  b=LyZ1e3/bN0YMeDdzoaIemiu61PXZQAQ+UECywFsJgp+ckjz1Oy1Fwhaa
   UUoZ6ixKHQKTnp4ngMk0Jpkrgo/+O54HKi8LI9ZFSdgazY5eZ/lm3SLy2
   aCGLMWTzmOj7LdQBSQrweusLIb4oOvI+1icapYyuavoROnx5yJX4f+8Ly
   fn2n8v1Iszk8iYZtjTwOp5WXlzQ/y5lcvN++aAHz4m6Yja0WaMSamcIwF
   vq9ditkIlAQ50Nziwgne0Zjn4UGHMRzv9zKWP4ri9jrxhYeCdFUqL57QH
   JoRq1Pr38SmjkDhSGwhWiB+QyOGNZanx8wwaQo1H+ZJ8k5Rm1q3p+CDo4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586561"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586561"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677951029"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677951029"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:00 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 13/15] KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
Date:   Thu,  8 Dec 2022 15:35:48 -0800
Message-Id: <eb47ea273ecde97ab5aa20b9cffb2d236fea26c7.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement merge_private_stp callback.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c       | 70 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h  |  1 +
 arch/x86/kvm/vmx/tdx_errno.h |  2 ++
 arch/x86/kvm/vmx/tdx_ops.h   |  6 ++++
 4 files changed, 79 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ce7026136334..f20e931cf983 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1487,6 +1487,47 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_merge_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_output out;
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	err = tdh_mem_page_promote(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
+	if (err == TDX_ERROR_SEPT_BUSY)
+		return -EAGAIN;
+	if (err == TDX_EPT_INVALID_PROMOTE_CONDITIONS)
+		/*
+		 * Some pages are accepted, some pending.  Need to wait for TD
+		 * to accept all pages.  Tell it the caller.
+		 */
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_PROMOTE, err, &out);
+		return -EIO;
+	}
+	WARN_ON_ONCE(out.rcx != __pa(private_spt));
+
+	/*
+	 * TDH.MEM.PAGE.PROMOTE frees the Secure-EPT page for the lower level.
+	 * Flush cache for reuse.
+	 */
+	do {
+		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(__pa(private_spt),
+							     to_kvm_tdx(kvm)->hkid));
+	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				      enum pg_level level)
 {
@@ -1556,6 +1597,33 @@ static void tdx_track(struct kvm_tdx *kvm_tdx)
 
 }
 
+static int tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_output out;
+	u64 err;
+
+	do {
+		err = tdh_mem_range_unblock(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
+
+		/*
+		 * tdh_mem_range_block() is accompanied with tdx_track() via kvm
+		 * remote tlb flush.  Wait for the caller of
+		 * tdh_mem_range_block() to complete TDX track.
+		 */
+	} while (err == (TDX_TLB_TRACKING_NOT_DONE | TDX_OPERAND_ID_SEPT));
+	if (err == TDX_ERROR_SEPT_BUSY)
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_RANGE_UNBLOCK, err, &out);
+		return -EIO;
+	}
+	return 0;
+}
+
 static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
@@ -2681,9 +2749,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
 	x86_ops->split_private_spt = tdx_sept_split_private_spt;
+	x86_ops->merge_private_spt = tdx_sept_merge_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
+	x86_ops->unzap_private_spte = tdx_sept_unzap_private_spte;
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 508d9a1139ce..3a3c9c608bf0 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -29,6 +29,7 @@
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
+#define TDH_MEM_PAGE_PROMOTE		23
 #define TDH_VP_RD			26
 #define TDH_MNG_KEY_RECLAIMID		27
 #define TDH_PHYMEM_PAGE_RECLAIM		28
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 389b1b53da25..74a5777c05f1 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -19,6 +19,8 @@
 #define TDX_KEY_CONFIGURED			0x0000081500000000ULL
 #define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
+#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000ULL
+#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000ULL
 
 /*
  * TDG.VP.VMCALL Status Codes (returned in R10)
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 60cbc7f94b18..5d2d0b1eed28 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -140,6 +140,12 @@ static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t pag
 	return seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
 }
 
+static inline u64 tdh_mem_page_promote(hpa_t tdr, gpa_t gpa, int level,
+				       struct tdx_module_output *out)
+{
+	return seamcall_sept(TDH_MEM_PAGE_PROMOTE, gpa | level, tdr, 0, 0, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_output *out)
 {
-- 
2.25.1

