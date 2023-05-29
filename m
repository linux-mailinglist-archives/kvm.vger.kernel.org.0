Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22837142F4
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjE2E05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjE2EZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E47FE54;
        Sun, 28 May 2023 21:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334224; x=1716870224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=goI57K85dZSQkK63NtQojDFIL0iFIo96+YM33QbNRuc=;
  b=CRSZVKsZDk28raWY/hXF6pzcu5Sez6NjHSgTxEGOROYKSd2S0Y4GUzBH
   M3gO1FU3tAV15ZzcJ9Eap3jp3KmBP1vFZkI39NQhMhcHHL1pWiJHBREFi
   hyYerDlxhOKIM+UWqqFUUdUjcvqFQHjd5SH0/McZvE3HtpfmY3fDgVfpx
   xnqG7F08O03ToLYIsoEabfYRSrygR/OtlMTuyHRbceW1Q+eD9hGBHLhXu
   LSsaOZlzHnZ1irRB2ksnJr0i3MROtHt9hwroLJ1dCY7+vsznIFq5iVLsk
   M62rkdxtnlIn+u+mf2RHFXtxB0JAmVqyYOSw1WRwPFqhzB4A1gSIegzKW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966039"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966039"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784347"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784347"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:19 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v14 053/113] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date:   Sun, 28 May 2023 21:19:35 -0700
Message-Id: <e02bb5e6a725dd3b5a99ec823f9c23c1da7b8888.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

TDX module internally uses locks to protect internal resources.  It tries
to acquire the locks.  If it fails to obtain the lock, it returns
TDX_OPERAND_BUSY error without spin because its execution time limitation.

TDX SEAMCALL API reference describes what resources are used.  It's known
which TDX SEAMCALL can cause contention with which resources.  VMM can
avoid contention inside the TDX module by avoiding contentious TDX SEAMCALL
with, for example, spinlock.  Because OS knows better its process
scheduling and its scalability, a lock at OS/VMM layer would work better
than simply retrying TDX SEAMCALLs.

TDH.MEM.* API except for TDH.MEM.TRACK operates on a secure EPT tree and
the TDX module internally tries to acquire the lock of the secure EPT tree.
They return TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT in case of failure to
get the lock.  TDX KVM allows sept callbacks to return error so that TDP
MMU layer can retry.

TDH.VP.ENTER is an exception with zero-step attack mitigation.  Normally
TDH.VP.ENTER uses only TD vcpu resources and it doesn't cause contention.
When a zero-step attack is suspected, it obtains a secure EPT tree lock and
tracks the GPAs causing a secure EPT fault.  Thus TDG.VP.ENTER may result
in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT.  Also TDH.MEM.* SEAMCALLs may
result in TDX_OPERAN_BUSY | TDX_OPERAND_ID_SEPT.

Retry TDX TDH.MEM.* API and TDH.VP.ENTER on the error because the error is
a rare event caused by zero-step attack mitigation and spinlock can not be
used for TDH.VP.ENTER due to indefinite time execution.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_ops.h | 42 ++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 5d9b28b21cf0..cb23cb0fe28f 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -38,6 +38,36 @@ static inline u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 #endif
 
+/*
+ * TDX module acquires its internal lock for resources.  It doesn't spin to get
+ * locks because of its restrictions of allowed execution time.  Instead, it
+ * returns TDX_OPERAND_BUSY with an operand id.
+ *
+ * Multiple VCPUs can operate on SEPT.  Also with zero-step attack mitigation,
+ * TDH.VP.ENTER may rarely acquire SEPT lock and release it when zero-step
+ * attack is suspected.  It results in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT
+ * with TDH.MEM.* operation.  Note: TDH.MEM.TRACK is an exception.
+ *
+ * Because TDP MMU uses read lock for scalability, spin lock around SEAMCALL
+ * spoils TDP MMU effort.  Retry several times with the assumption that SEPT
+ * lock contention is rare.  But don't loop forever to avoid lockup.  Let TDP
+ * MMU retry.
+ */
+#define TDX_ERROR_SEPT_BUSY    (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
+
+static inline u64 kvm_seamcall_sept(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+				    struct tdx_module_output *out)
+{
+#define SEAMCALL_RETRY_MAX     16
+	int retry = SEAMCALL_RETRY_MAX;
+	u64 ret;
+
+	do {
+		ret = kvm_seamcall(op, rcx, rdx, r8, r9, out);
+	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
+	return ret;
+}
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
@@ -48,14 +78,14 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return kvm_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	return kvm_seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(page), PAGE_SIZE);
-	return kvm_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+	return kvm_seamcall_sept(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
 }
 
 static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
@@ -81,13 +111,13 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return kvm_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	return kvm_seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return kvm_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+	return kvm_seamcall_sept(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_mng_key_config(hpa_t tdr)
@@ -169,7 +199,7 @@ static inline u64 tdh_phymem_page_reclaim(hpa_t page,
 static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return kvm_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+	return kvm_seamcall_sept(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -185,7 +215,7 @@ static inline u64 tdh_mem_track(hpa_t tdr)
 static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 					struct tdx_module_output *out)
 {
-	return kvm_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+	return kvm_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1

