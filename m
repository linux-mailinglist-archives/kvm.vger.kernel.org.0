Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4249D6B649C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCLKAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjCLJ7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFC955079
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615129; x=1710151129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QcCzJPiJB6CH3hvKLxjC1mAnUN4IHqeWdqOvVb/xrjI=;
  b=XlmQkwZoNsvRIaLXSOTQw01aw1183neHxXrsg1UAonIB0azpHofr2Ht4
   IFI4RWRugNP7+m0e+IcxFxCfcz2knb6paODUe8wzYVTcN3J1F2BIxFUtY
   gd4t4QcGDl6IpsY9fM2MHMgSQR24LzAmGbTdtlU+QTe+Feb9TLj9Wab9A
   VwwvaNe0SdE6d9Tb/4TtVEPx8LivKZEkwwAu9e9C5TmrqUO5qsFMQzFEs
   WBpXRbsFlv4Tz8xS8NuV0zCRIvaAwZOt8PxY1FjDBpryTfDBhsLQnAA5z
   oVl6eBhLm1LKTZzJoTezTuzsTTSnzxeGbvrlccv6XymPvOKGuTywXGWIS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344705"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344705"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627342"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627342"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:58 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 07/13] pkvm: x86: Initialize ept_zero_check
Date:   Mon, 13 Mar 2023 02:03:39 +0800
Message-Id: <20230312180345.1778588-8-jason.cj.chen@intel.com>
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

ept_zero_check is used to check if a pte entry has any reserved
bits set, or has any unsupported bit combinations. This is helpful to
check if this entry can cause EPT misconfig or not during shadowing in
the later patch.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c | 47 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h |  7 +++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 641b8252071e..823e255de155 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -26,6 +26,7 @@ static struct pkvm_pgtable host_ept;
 static pkvm_spinlock_t host_ept_lock = __PKVM_SPINLOCK_UNLOCKED;
 
 static struct hyp_pool shadow_ept_pool;
+static struct rsvd_bits_validate ept_zero_check;
 
 static void flush_tlb_noop(void) { };
 static void *host_ept_zalloc_page(void)
@@ -151,16 +152,62 @@ int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
 	return pkvm_pgtable_unmap(&host_ept, vaddr_start, phys_start, size);
 }
 
+static void reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
+				      u64 pa_bits_rsvd, bool execonly,
+				      int huge_page_level)
+{
+	u64 high_bits_rsvd = pa_bits_rsvd & rsvd_bits(0, 51);
+	u64 large_1g_rsvd = 0, large_2m_rsvd = 0;
+	u64 bad_mt_xwr;
+
+	if (huge_page_level < PG_LEVEL_1G)
+		large_1g_rsvd = rsvd_bits(7, 7);
+	if (huge_page_level < PG_LEVEL_2M)
+		large_2m_rsvd = rsvd_bits(7, 7);
+
+	rsvd_check->rsvd_bits_mask[0][4] = high_bits_rsvd | rsvd_bits(3, 7);
+	rsvd_check->rsvd_bits_mask[0][3] = high_bits_rsvd | rsvd_bits(3, 7);
+	rsvd_check->rsvd_bits_mask[0][2] = high_bits_rsvd | rsvd_bits(3, 6) | large_1g_rsvd;
+	rsvd_check->rsvd_bits_mask[0][1] = high_bits_rsvd | rsvd_bits(3, 6) | large_2m_rsvd;
+	rsvd_check->rsvd_bits_mask[0][0] = high_bits_rsvd;
+
+	/* large page */
+	rsvd_check->rsvd_bits_mask[1][4] = rsvd_check->rsvd_bits_mask[0][4];
+	rsvd_check->rsvd_bits_mask[1][3] = rsvd_check->rsvd_bits_mask[0][3];
+	rsvd_check->rsvd_bits_mask[1][2] = high_bits_rsvd | rsvd_bits(12, 29) | large_1g_rsvd;
+	rsvd_check->rsvd_bits_mask[1][1] = high_bits_rsvd | rsvd_bits(12, 20) | large_2m_rsvd;
+	rsvd_check->rsvd_bits_mask[1][0] = rsvd_check->rsvd_bits_mask[0][0];
+
+	bad_mt_xwr = 0xFFull << (2 * 8);	/* bits 3..5 must not be 2 */
+	bad_mt_xwr |= 0xFFull << (3 * 8);	/* bits 3..5 must not be 3 */
+	bad_mt_xwr |= 0xFFull << (7 * 8);	/* bits 3..5 must not be 7 */
+	bad_mt_xwr |= REPEAT_BYTE(1ull << 2);	/* bits 0..2 must not be 010 */
+	bad_mt_xwr |= REPEAT_BYTE(1ull << 6);	/* bits 0..2 must not be 110 */
+	if (!execonly) {
+		/* bits 0..2 must not be 100 unless VMX capabilities allow it */
+		bad_mt_xwr |= REPEAT_BYTE(1ull << 4);
+	}
+	rsvd_check->bad_mt_xwr = bad_mt_xwr;
+}
+
 int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap,
 		void *ept_pool_base, unsigned long ept_pool_pages)
 {
 	unsigned long pfn = __pkvm_pa(ept_pool_base) >> PAGE_SHIFT;
 	int ret;
+	u8 pa_bits;
 
 	ret = hyp_pool_init(&host_ept_pool, pfn, ept_pool_pages, 0);
 	if (ret)
 		return ret;
 
+	pa_bits = get_max_physaddr_bits();
+	if (!pa_bits)
+		return -EINVAL;
+	reset_rsvds_bits_mask_ept(&ept_zero_check, rsvd_bits(pa_bits, 63),
+				  vmx_has_ept_execute_only(),
+				  fls(cap->allowed_pgsz) - 1);
+
 	pkvm_hyp->host_vm.ept = &host_ept;
 	return pkvm_pgtable_init(&host_ept, &host_ept_mm_ops, &ept_ops, cap, true);
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index 13405166bccf..3282f228964d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -6,6 +6,8 @@
 #ifndef __PKVM_VMX_H
 #define __PKVM_VMX_H
 
+#include "pkvm_hyp.h"
+
 static inline bool vmx_ept_capability_check(u32 bit)
 {
 	struct vmx_capability *vmx_cap = &pkvm_hyp->vmx_cap;
@@ -33,6 +35,11 @@ static inline bool vmx_has_invept_context(void)
 	return vmx_ept_capability_check(VMX_EPT_EXTENT_CONTEXT_BIT);
 }
 
+static inline bool vmx_has_ept_execute_only(void)
+{
+	return vmx_ept_capability_check(VMX_EPT_EXECUTE_ONLY_BIT);
+}
+
 static inline u64 pkvm_construct_eptp(unsigned long root_hpa, int level)
 {
 	u64 eptp = 0;
-- 
2.25.1

