Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D242F6B6494
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCLJ7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCLJ7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3143206A4
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615091; x=1710151091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8hxBql324h4FzRUdcnm0r0ubOiN0CPhpNEMnqTxPu7E=;
  b=l8Crx9tJ0VfePg+tl9ww4xEObhXj4jQinL4PJ8aYojSZvf35TEDphDTt
   zA4fCIiCW4G8h+c4JweHJfeRqsv9/6VWqLq5BKV0KEzQR4zSNv9R5Kwy1
   tA4fVDWts6M7ZgBJPkckLN8qLrHpQCNgZX/52dPYPyHMtcFWqKvbEXkB5
   vyNpZ1zjRWOMA90bZYdPqtb9JsLqrADhOuczJqajx4V2O4WlS5cfEZgfu
   2G/cy5p5upgORuNIZosH3t79YcmrLotFbp9kv912DNKxk0SZojt6i8hXi
   Xwj6YQ+08QfWnJKZbBUd1XU8SjZer2CcF2xiaerPhhqAR78MNVGIJ6rlw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344685"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344685"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627306"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627306"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:53 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 03/13] pkvm: x86: Initialize the shadow EPT pool
Date:   Mon, 13 Mar 2023 02:03:35 +0800
Message-Id: <20230312180345.1778588-4-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

Shadow EPT pool is the memory pool to allocate the memory for the shadow
EPT paging structure pages. When destroy a shadow EPT, these pages will
be put back to this pool again.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c           |  9 +++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h           |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 13 +++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index b0a542b47e83..14bc8f4429db 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -24,6 +24,8 @@ static struct hyp_pool host_ept_pool;
 static struct pkvm_pgtable host_ept;
 static pkvm_spinlock_t host_ept_lock = __PKVM_SPINLOCK_UNLOCKED;
 
+static struct hyp_pool shadow_ept_pool;
+
 static void flush_tlb_noop(void) { };
 static void *host_ept_zalloc_page(void)
 {
@@ -221,3 +223,10 @@ int handle_host_ept_violation(unsigned long gpa)
 	pkvm_spin_unlock(&host_ept_lock);
 	return ret;
 }
+
+int pkvm_shadow_ept_pool_init(void *ept_pool_base, unsigned long ept_pool_pages)
+{
+	unsigned long pfn = __pkvm_pa(ept_pool_base) >> PAGE_SHIFT;
+
+	return hyp_pool_init(&shadow_ept_pool, pfn, ept_pool_pages, 0);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index d517bf8ec169..c4ad5c269d5c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -17,5 +17,6 @@ int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
 int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap, void *ept_pool_base,
 		unsigned long ept_pool_pages);
 int handle_host_ept_violation(unsigned long gpa);
+int pkvm_shadow_ept_pool_init(void *ept_pool_base, unsigned long ept_pool_pages);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index c16b53b7bcd0..8d52a20f6497 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -23,6 +23,7 @@
 void *pkvm_mmu_pgt_base;
 void *pkvm_vmemmap_base;
 void *host_ept_pgt_base;
+static void *shadow_ept_base;
 
 static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 {
@@ -49,6 +50,12 @@ static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 	if (!host_ept_pgt_base)
 		return -ENOMEM;
 
+	nr_pages = pkvm_shadow_ept_pgtable_pages(PKVM_MAX_NORMAL_VM_NUM +
+						 PKVM_MAX_PROTECTED_VM_NUM);
+	shadow_ept_base = pkvm_early_alloc_contig(nr_pages);
+	if (!shadow_ept_base)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -291,6 +298,12 @@ int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 
 	pkvm_init_nest();
 
+	ret = pkvm_shadow_ept_pool_init(shadow_ept_base,
+					pkvm_shadow_ept_pgtable_pages(PKVM_MAX_NORMAL_VM_NUM +
+								      PKVM_MAX_PROTECTED_VM_NUM));
+	if (ret)
+		goto out;
+
 	pkvm_init = true;
 
 switch_pgt:
-- 
2.25.1

