Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C326B6491
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjCLJ7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCLJ7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534C11E293
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615090; x=1710151090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y/eRz+jDMXs5GHhsszH9SB2C6rHFchj6JUBEnnD0t00=;
  b=SCNd4zyDPV3vWFeyOqK9p/kh9+Y4UM7cfm/4IINnsL6HTc9ljIbJ9QHE
   s0AmsYTQsv4bStHg5s8CY56HsSlw5edcYApHw9FTC6+cpWxeK7Iuoz9sa
   Qav7JTENmo48D84OoHX5cxGPoj3ZgoCRSYFv1i7wZnSpE+BNPdunNZNDf
   /Y+Mxu4+PY5yOTWY4CE5jhTshU6lj2VkpaTjKgAIciWd8psBQqqZRnowA
   rjPFKbda8ZpYxwftiRPgYJIB+K1EjVyxavUAyC196DVkrBC/BC5FQ1hEj
   DYh1xWI/LX5B/MzUX7tt3tASmx1wNlggAdhwEPcTbnYLhsUrBeC6pnW1h
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344683"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344683"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627302"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627302"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:52 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-6 02/13] pkvm: x86: init: Reserve memory for shadow EPT
Date:   Mon, 13 Mar 2023 02:03:34 +0800
Message-Id: <20230312180345.1778588-3-jason.cj.chen@intel.com>
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

Shadow EPT pages are from the reserved memory of pKVM. The size for
Shadow EPT pages is calculated based on the number of supported VMs
(both normal VM and protected VM), with several assumptions:

- there is no shared memory between each VMs (normal or protected).
- all VMs total memory size is not larger than the platform memory size.
- the virtual MMIO range for each VM is not larger than 1G.

which makes the reserved memory size is calculable and predictable.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h   | 34 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c |  1 +
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 4e9531d88417..0712ef34b95b 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -131,6 +131,40 @@ static inline int hyp_pre_reserve_check(void)
 	return 0;
 }
 
+/*
+ * Calculate the total pages for shadow EPT with assumptions:
+ * 1. there is no shared memory between each VMs (normal or protected).
+ * 2. all VMs total memory size is no larger than the platform memory size.
+ * 3. the virtual MMIO range for each VM is no larger than 1G.
+ */
+static inline unsigned long pkvm_shadow_ept_pgtable_pages(int nr_vm)
+{
+	unsigned long pgtable_pages = __pkvm_pgtable_total_pages();
+	unsigned long res;
+
+	res = pgtable_pages;
+
+	/*
+	 * Above 'res' covered enough pages for a shadow EPT to create all
+	 * possible levels mapping for the whole platform memory size. The pages
+	 * reserved for lvl-1 mapping (usually 4K size) actually can be shared
+	 * among all VM shadow EPTs as their occupied memory are partitioned
+	 * according to the assumption. While for lvl-2,3,4 or possible lvl-5
+	 * mappings, above 'res' pages only covered for one shadow EPT, we need
+	 * reserve more for other 'nr_vm -1' VMs.
+	 *
+	 * The lvl-2 to lvl-5 pages for one VM's shadow EPT can be approximately
+	 * got by:
+	 *     __pkvm_pgtable_total_pages()/PTRS_PER_PTE
+	 */
+	res += DIV_ROUND_UP(pgtable_pages, PTRS_PER_PTE) * (nr_vm - 1);
+
+	/* Allow 1 GiB for MMIO mappings for each VM */
+	 res += __pkvm_pgtable_max_pages(SZ_1G >> PAGE_SHIFT) * nr_vm;
+
+	return res;
+}
+
 u64 hyp_total_reserve_pages(void);
 
 int pkvm_init_shadow_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 90d7cddde9ef..e5eab94f3e5e 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -41,6 +41,7 @@ u64 hyp_total_reserve_pages(void)
 	total += pkvm_vmemmap_pages(PKVM_VMEMMAP_ENTRY_SIZE);
 	total += pkvm_mmu_pgtable_pages();
 	total += host_ept_pgtable_pages();
+	total += pkvm_shadow_ept_pgtable_pages(PKVM_MAX_VM_NUM);
 
 	return total;
 }
-- 
2.25.1

