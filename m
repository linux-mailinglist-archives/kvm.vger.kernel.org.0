Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AFF6B64B2
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCLKBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCLKBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:01:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C75D3B230
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 03:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615206; x=1710151206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YRheXSo/nKLE2uNvdJcOougp9+CEOZQwsxyP+V2rrWY=;
  b=Edz0mOgaNtUBNhZanUH78rkmjGMnZyXdn3bN+9FxkevGuK+REuWag28L
   ZKKDZ7nNR8VBVbLwikHLo1wqZmiOhrMwwEawDOt6uLP7lelcGoCIPqrri
   0ywUz/LdD1avmoZJTHv0RJtgAdOPQspZJKOk/NfVt1le1LvZLUkNclP4x
   FueJ3230ItRP05gBxpJ9y0flImBkDvsd8sdeTi5UWi3s6HiPpwES/ZkM6
   wDlDiB0syebbnAUy3cLr2xHqLXGLyWONCRJ3Bu+1ujLcMoi4Dw8OFHteG
   NKN02m/eN+McMsZvIaqJK4kFNeD+KeYcISuc7D8xJGOvqocGOHE0cU9Ec
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344763"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344763"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627568"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627568"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:34 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-7 12/12] pkvm: x86: Use page state API in shadow EPT for normal VM
Date:   Mon, 13 Mar 2023 02:04:15 +0800
Message-Id: <20230312180415.1778669-13-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add map_leaf & free_leaf override helper functions for shadow EPT, and
use page state API in these helper functions to support shadow EPT
invalidation, destroy and EPT violation for normal VM.

When map a page for a normal VM in shadow EPT, use the share API to mark
this page is shared which is previously owned by the host VM but now is
shared between the host VM and the normal VM. And when invalidate or
destroy shadow EPT, mark this page as unshared which means owned by the
host VM again.

Under the state machine of page state transition, pKVM does not support
multiple guest pages mapping to same host page, it's conflict with KSM,
so just disable it under pKVM Kconfig.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/ept.c | 60 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/pkvm/hyp/ept.h |  1 +
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c2f66d3eef37..3eb7a2624245 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -91,6 +91,7 @@ config PKVM_INTEL
 	bool "pKVM for Intel processors support"
 	depends on KVM_INTEL=y
 	depends on X86_64
+	depends on !KSM
 	help
 	  Provides support for pKVM on Intel processors.
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 9e5aeb8b239e..f942e2e7f3d8 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -317,6 +317,58 @@ static struct pkvm_mm_ops shadow_ept_mm_ops = {
 	.flush_tlb = flush_tlb_noop,
 };
 
+static int pkvm_shadow_ept_map_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr, int level,
+				    void *ptep, struct pgt_flush_data *flush_data, void *arg)
+{
+	struct pkvm_pgtable_map_data *data = arg;
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	unsigned long level_size = pgt_ops->pgt_level_to_size(level);
+	unsigned long map_phys = data->phys & PAGE_MASK;
+	int ret;
+
+	/*
+	 * It is possible that another CPU just created same mapping when
+	 * multiple EPT violations happen on different CPUs.
+	 */
+	if (!pgt_ops->pgt_entry_present(ptep)) {
+		ret = __pkvm_host_share_guest(map_phys, pgt, vaddr, level_size, data->prot);
+		if (ret)
+			return ret;
+	}
+
+	/* Increase the physical address for the next mapping */
+	data->phys += level_size;
+
+	return 0;
+}
+
+static int pkvm_shadow_ept_free_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr, int level,
+				     void *ptep, struct pgt_flush_data *flush_data, void *arg)
+{
+	unsigned long phys = pgt->pgt_ops->pgt_entry_to_phys(ptep);
+	unsigned long size = pgt->pgt_ops->pgt_level_to_size(level);
+
+	if (pgt->pgt_ops->pgt_entry_present(ptep)) {
+		int ret;
+
+		/*
+		 * The pgtable_free_cb in this current page walker is still walking
+		 * the shadow EPT so cannot allow the  __pkvm_host_unshare_guest()
+		 * release shadow EPT table pages.
+		 *
+		 * The table pages will be freed later by the pgtable_free_cb itself.
+		 */
+		pgt->mm_ops->get_page(ptep);
+		ret = __pkvm_host_unshare_guest(phys, pgt, vaddr, size);
+		pgt->mm_ops->put_page(ptep);
+		flush_data->flushtlb |= true;
+
+		return ret;
+	}
+
+	return 0;
+}
+
 void pkvm_invalidate_shadow_ept(struct shadow_ept_desc *desc)
 {
 	struct pkvm_shadow_vm *vm = sept_desc_to_shadow_vm(desc);
@@ -328,7 +380,7 @@ void pkvm_invalidate_shadow_ept(struct shadow_ept_desc *desc)
 	if (!is_valid_eptp(desc->shadow_eptp))
 		goto out;
 
-	pkvm_pgtable_unmap(sept, 0, size, NULL);
+	pkvm_pgtable_unmap(sept, 0, size, pkvm_shadow_ept_free_leaf);
 
 	flush_ept(desc->shadow_eptp);
 out:
@@ -343,7 +395,7 @@ void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc)
 	pkvm_spin_lock(&vm->lock);
 
 	if (desc->shadow_eptp) {
-		pkvm_pgtable_destroy(sept, NULL);
+		pkvm_pgtable_destroy(sept, pkvm_shadow_ept_free_leaf);
 
 		flush_ept(desc->shadow_eptp);
 
@@ -459,8 +511,10 @@ pkvm_handle_shadow_ept_violation(struct shadow_vcpu_state *shadow_vcpu, u64 l2_g
 		unsigned long level_size = pgt_ops->pgt_level_to_size(level);
 		unsigned long gpa = ALIGN_DOWN(l2_gpa, level_size);
 		unsigned long hpa = ALIGN_DOWN(host_gpa2hpa(phys), level_size);
+		u64 prot = gprot & EPT_PROT_MASK;
 
-		if (!pkvm_pgtable_map(sept, gpa, hpa, level_size, 0, gprot, NULL))
+		if (!pkvm_pgtable_map(sept, gpa, hpa, level_size, 0,
+					prot, pkvm_shadow_ept_map_leaf))
 			ret = PKVM_HANDLED;
 	}
 out:
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index 9d7d2c2f9be3..2ad2fab4a88d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -11,6 +11,7 @@
 				(MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT))
 #define HOST_EPT_DEF_MMIO_PROT	(VMX_EPT_RWX_MASK |				\
 				(MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT))
+#define EPT_PROT_MASK		(VMX_EPT_RWX_MASK | VMX_EPT_MT_MASK | VMX_EPT_IPAT_BIT)
 
 enum sept_handle_ret {
 	PKVM_NOT_HANDLED,
-- 
2.25.1

