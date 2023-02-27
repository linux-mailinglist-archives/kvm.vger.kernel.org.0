Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A606A3CC1
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjB0I1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjB0I0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:26:06 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB291D90C;
        Mon, 27 Feb 2023 00:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486277; x=1709022277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hdxwm7yMgHpzCli9IIsSaeTMsG08HLO4AGUK13v/zFo=;
  b=WDIUTQGDmppkW3CPRVbwan9XnFwukzrhOsQ0Ai0KoBNbi4gFMs99jcsu
   uppbn3hLsqgq/QzpEuHcxrcz52Pz4JzZVzTlMOQLtZ+bE3Lhzb+VhavEo
   PjCG1fzCdd36jLm69iZ0WWMeQEMlWXtWcNbf47xe4guzP9FMuyLQGn0NM
   3izR2pVCncWRqCZbRS4Fq3oQMEMj94qBjGWeG2qlXHqXqb9qbYjOew5Eb
   uXLAcjgHWyl59gnlSzE8/3Ax3uZr0aZGP9tXflWlZaKuo33zcUL9ZoVdk
   yaXOV/mE2Ek4YdLHPRBxmdtfXfYk0YM0CzKeV1eNjKU1XV/EhoSKhIWUT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608854"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608854"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242216"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242216"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:09 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v12 048/106] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date:   Mon, 27 Feb 2023 00:22:47 -0800
Message-Id: <91c327b370bf5e44df4d254bd0f3408efacc5c09.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 8cc2f01c509b..86330d0e4b22 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -18,6 +18,36 @@
 
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 
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
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
@@ -28,14 +58,14 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
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
@@ -61,13 +91,13 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
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
@@ -149,7 +179,7 @@ static inline u64 tdh_phymem_page_reclaim(hpa_t page,
 static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -165,7 +195,7 @@ static inline u64 tdh_mem_track(hpa_t tdr)
 static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 					struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1

