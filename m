Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEF61286C
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJ3GcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiJ3Ga2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:30:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92935B10;
        Sat, 29 Oct 2022 23:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111093; x=1698647093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wfEchl1NiccXT0JGjR9Y16+RK9hpFyG15uj0MzcaKCQ=;
  b=DhoQUeHkhWytmt42GO3dsxZ+ckZEpEep7V0kVarpePTEZ/BtiTr6NhZt
   n07Bcd0tnre0RE2PtBGz8nPIA2ukzn3mAlSPyOHcsp8MMB0iPObmgWn7y
   FiUfIJIN/VB48wktOqZ/uEoO5lm8UeMZg39zjr9KKOCd+yw1Fy0jn6iMT
   wt/Q6QcSP1YQonqWVYKE3+/HT7BfpJZQYDgCRJ8xk34/4qO5KdMhuBskl
   ayNaP6fwm1mfpEFNB/F/HN8YmgKpznNSqKEr/XqXdi6R/iSn198QnvoJE
   SmjmbsBPyWqD3u+3Da+DJFXMOJq0RTuWc1TH9XfUC5wnqAxlSwCPUZV+D
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037204"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037204"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393125"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393125"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v10 088/108] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date:   Sat, 29 Oct 2022 23:23:29 -0700
Message-Id: <c27dbc2238786708db5d2efdc2c1ea181039dc15.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c     |  4 ++++
 arch/x86/kvm/vmx/tdx_ops.h | 42 +++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b0b193cc180e..088e98232227 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1050,6 +1050,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
 
+	/* See the comment of tdh_sept_seamcall(). */
+	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))
+		return 1;
+
 	if (unlikely(exit_reason.non_recoverable || exit_reason.error)) {
 		if (exit_reason.basic == EXIT_REASON_TRIPLE_FAULT)
 			return tdx_handle_triple_fault(vcpu);
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 35e285ae6f9e..86330d0e4b22 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -18,7 +18,35 @@
 
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 
-#define TDX_ERROR_SEPT_BUSY	(TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
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
+static inline u64 seamcall_sept(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+				struct tdx_module_output *out)
+{
+#define SEAMCALL_RETRY_MAX     16
+	int retry = SEAMCALL_RETRY_MAX;
+	u64 ret;
+
+	do {
+		ret = __seamcall(op, rcx, rdx, r8, r9, out);
+	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
+	return ret;
+}
 
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
@@ -30,14 +58,14 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return __seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	return seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(page), PAGE_SIZE);
-	return __seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+	return seamcall_sept(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
 }
 
 static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
@@ -63,13 +91,13 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return __seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	return seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_mng_key_config(hpa_t tdr)
@@ -151,7 +179,7 @@ static inline u64 tdh_phymem_page_reclaim(hpa_t page,
 static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -167,7 +195,7 @@ static inline u64 tdh_mem_track(hpa_t tdr)
 static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 					struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1

