Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413D65F08C0
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiI3KWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiI3KTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B2C1ED6D3;
        Fri, 30 Sep 2022 03:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533150; x=1696069150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nO1ijqoPoZDVCg8xW46SAmH84xl5I/lJVGDucBYjzBo=;
  b=ib7u67QcvTDItZ63ml2kJggQDqqMIgkbGlhfyE+f/EzMkik4ZOYY94Az
   0YlNfTTM2iMCZzbK1LqDEHTooG6t3VURlR5O2JgJudIJIAcKIQoTUeY6a
   3rMpK/X0zqa3IuMbgpTxmqBwTnc0k3FP5oJxVc8a6X2BQNOODZxa0x78m
   JMaJfQlPgJOc18EmRW8tPMcde1J34qRJFCR2P6Zog9oaFiwd75V9Ge5ar
   Iv2J1FZXBCwvpitVA0XYnIpIJPcbmqYlgRhAGD/fZxPaLx8lZaq/rgLv4
   RWYn3/Ewq97rZq8wqt02J21dqCSB6o4UG3/or4KEz+Bpo8++i4l7DIeYE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540156"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540156"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807782"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807782"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:05 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>, Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v9 085/105] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date:   Fri, 30 Sep 2022 03:18:19 -0700
Message-Id: <4c02bb911cfe94001b925d10a613ff61159ee7f4.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
get the lock.  TDX KVM uses kvm_tdx::seamcall_lock spinlock at OS/VMM layer
to avoid contention inside the TDX module.

TDH.VP.ENTER is an exception with zero-step attack mitigation.  Normally
TDH.VP.ENTER uses only TD vcpu resources and it doesn't cause contention.
When a zero-step attack is suspected, it obtains a secure EPT tree lock and
tracks the GPAs causing a secure EPT fault.  Thus TDG.VP.ENTER may result
in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT.  Also TDH.MEM.* SEAMCALLs may
result in TDX_OPERAN_BUSY | TDX_OPERAND_ID_SEPT because TDH.VP.ENTER is not
protected with seamcall_lock.

Retry TDX TDH.MEM.* API and TDH.VP.ENTER on the error because the error is
a rare event caused by zero-step attack mitigation and spinlock can not be
used for TDH.VP.ENTER due to indefinite time execution.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c     |  4 ++++
 arch/x86/kvm/vmx/tdx_ops.h | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cd62a9f42ed0..977f0cc56ab8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1019,6 +1019,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
index 8cc2f01c509b..a50bc1445cc2 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -18,6 +18,26 @@
 
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 
+/*
+ * Although seamcal_lock protects seamcall to avoid contention inside the TDX
+ * module, it doesn't protect TDH.VP.ENTER.  With zero-step attack mitigation,
+ * TDH.VP.ENTER may rarely acquire SEPT lock and release it when zero-step
+ * attack is suspected.  It results in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT
+ * with TDH.MEM.* operation.  (TDH.MEM.TRACK is an exception.)  Because such
+ * error is rare event, just retry on those TDH.MEM operations and TDH.VP.ENTER.
+ */
+static inline u64 seamcall_sept_retry(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+				      struct tdx_module_output *out)
+{
+	u64 ret;
+
+	do {
+		ret = __seamcall(op, rcx, rdx, r8, r9, out);
+	} while (unlikely(ret == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)));
+
+	return ret;
+}
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
@@ -28,14 +48,15 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return __seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	return seamcall_sept_retry(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(page), PAGE_SIZE);
-	return __seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+	return seamcall_sept_retry(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0,
+				   out);
 }
 
 static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
@@ -61,13 +82,14 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return __seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	return seamcall_sept_retry(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept_retry(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0,
+				   out);
 }
 
 static inline u64 tdh_mng_key_config(hpa_t tdr)
@@ -149,7 +171,8 @@ static inline u64 tdh_phymem_page_reclaim(hpa_t page,
 static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept_retry(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0,
+				   out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -165,7 +188,8 @@ static inline u64 tdh_mem_track(hpa_t tdr)
 static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 					struct tdx_module_output *out)
 {
-	return __seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+	return seamcall_sept_retry(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0,
+				   out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1

