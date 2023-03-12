Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F426B64A9
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCLKBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCLKAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:35 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC6C252AB
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615182; x=1710151182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WKunSR+Dt2/zTBJaE0+Q6zjIMvvKdZpTEJk9FSUYNG0=;
  b=i5SrViRrnEqSYAMDPlwliDUM1k9/ommS1WYhZmBTM8J3ZeUdbiZ6v0Lt
   sXT8+d/4WWSWVSRx7/FdAnPsivKU4g1W6TLR7FdcMaJ71Yb5BOHQ52UuH
   1UXcmo0ZIe9F3WHWw9CFL5XJTSXKedZ8+bAynmzpaPjjBmNZYWRTakqg1
   fBVG8PzqOA1e79OZ4zzg1LNwasErkMtJpTPDGsbCIiu+qrux2psKPFN3T
   MslrkncDE0VRkCtKxlRCx45/q7w7yP6yH28TCI1RM6fpF2y3fu+Ap4Fig
   5qJtM13emctmcR6j/CENgPdpMfVSrXQnFIslc4KGayn+PLhKKRQoosLIK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344755"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344755"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627515"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627515"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:25 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-7 05/12] pkvm: x86: Expose host EPT lock
Date:   Mon, 13 Mar 2023 02:04:08 +0800
Message-Id: <20230312180415.1778669-6-jason.cj.chen@intel.com>
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

From: Shaoqin Huang <shaoqin.huang@intel.com>

pKVM already has host EPT lock which is used to protect host EPT
violation. such lock will be used for other use cases in page state
management in the future.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c | 16 +++++++++++++---
 arch/x86/kvm/vmx/pkvm/hyp/ept.h |  2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 2a4d6cc7fa81..f7d3510cf0e2 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -24,7 +24,7 @@
 
 static struct hyp_pool host_ept_pool;
 static struct pkvm_pgtable host_ept;
-static pkvm_spinlock_t host_ept_lock = __PKVM_SPINLOCK_UNLOCKED;
+static pkvm_spinlock_t _host_ept_lock = __PKVM_SPINLOCK_UNLOCKED;
 
 static struct hyp_pool shadow_ept_pool;
 static struct rsvd_bits_validate ept_zero_check;
@@ -153,6 +153,16 @@ int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
 	return pkvm_pgtable_unmap_safe(&host_ept, vaddr_start, phys_start, size);
 }
 
+void host_ept_lock(void)
+{
+	pkvm_spin_lock(&_host_ept_lock);
+}
+
+void host_ept_unlock(void)
+{
+	pkvm_spin_unlock(&_host_ept_lock);
+}
+
 static void reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
 				      u64 pa_bits_rsvd, bool execonly,
 				      int huge_page_level)
@@ -227,7 +237,7 @@ int handle_host_ept_violation(unsigned long gpa)
 		return -EPERM;
 	}
 
-	pkvm_spin_lock(&host_ept_lock);
+	pkvm_spin_lock(&_host_ept_lock);
 
 	pkvm_pgtable_lookup(&host_ept, gpa, &hpa, NULL, &level);
 	if (hpa != INVALID_ADDR) {
@@ -269,7 +279,7 @@ int handle_host_ept_violation(unsigned long gpa)
 			 __func__, gpa);
 	}
 out:
-	pkvm_spin_unlock(&host_ept_lock);
+	pkvm_spin_unlock(&_host_ept_lock);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index f63538368746..9d7d2c2f9be3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -18,6 +18,8 @@ enum sept_handle_ret {
 	PKVM_INJECT_EPT_MISC,
 };
 
+void host_ept_lock(void);
+void host_ept_unlock(void);
 int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size, int pgsz_mask, u64 prot);
 int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
-- 
2.25.1

