Return-Path: <kvm+bounces-939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF8B7E428A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE3DB1C20DEB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAD534CE4;
	Tue,  7 Nov 2023 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MCsoRmaz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D9D31A8F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:59:29 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED033242;
	Tue,  7 Nov 2023 06:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369145; x=1730905145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgs5wi7ZMeEhbaMFUd4+BfODjA6FoTySEiCzmdzlcyY=;
  b=MCsoRmaz07RmI+kFNh1CSCWngqEQ4fju5GLvkzVNhYn6F8Gcj5EYZeBG
   fWwoHWZkDPbKQ/6H0R0E8XUQXo9ibji8suwGSpOYD6AxKALdQ7L4BeZJ2
   5U/6o5ghZiHa7xlK3FHyezct4V6CpfWYItVsK5fOrQQ9kOnKx3zVvYHB9
   VJlsSahsqYRfQzNUw4deMMTYbUp9jAvZVAZf/yFIIH35NDCRMkSYXbEu0
   Kjp4WTNFA0gmVIj98H/nOZXxJrdtjSNWH0RzbKwCM00SMP8CsGgMKPBpb
   EFyj4D7W3Sxt5heDl0hJFupbVNnR6yAlfLGo5+KwxMaZbiRZRm4RFq7ik
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462352"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462352"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851410"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:14 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v17 053/116] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date: Tue,  7 Nov 2023 06:56:19 -0800
Message-Id: <50146c34636f31fd4273f5e11feb5bc0f1341ced.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 arch/x86/kvm/vmx/tdx_ops.h | 48 +++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index c9f74b2400a7..fd73a1731bf8 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -62,6 +62,36 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
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
+static inline u64 tdx_seamcall_sept(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+				    struct tdx_module_args *out)
+{
+#define SEAMCALL_RETRY_MAX     16
+	int retry = SEAMCALL_RETRY_MAX;
+	u64 ret;
+
+	do {
+		ret = tdx_seamcall(op, rcx, rdx, r8, r9, out);
+	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
+	return ret;
+}
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
@@ -72,26 +102,26 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 				   struct tdx_module_args *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				   struct tdx_module_args *out)
 {
 	clflush_cache_range(__va(page), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
 }
 
 static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
 				  struct tdx_module_args *out)
 {
-	return tdx_seamcall(TDH_MEM_SEPT_RD, gpa | level, tdr, 0, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_RD, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_args *out)
 {
-	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
@@ -104,20 +134,20 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 					struct tdx_module_args *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				   struct tdx_module_args *out)
 {
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_args *out)
 {
-	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_mng_key_config(hpa_t tdr)
@@ -199,7 +229,7 @@ static inline u64 tdh_phymem_page_reclaim(hpa_t page,
 static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 				      struct tdx_module_args *out)
 {
-	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -215,7 +245,7 @@ static inline u64 tdh_mem_track(hpa_t tdr)
 static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 					struct tdx_module_args *out)
 {
-	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+	return tdx_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1


