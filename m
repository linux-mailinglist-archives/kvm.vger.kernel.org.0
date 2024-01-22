Return-Path: <kvm+bounces-6631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E52C8377FA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:03:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9192028B934
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BADB6169A;
	Mon, 22 Jan 2024 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="joOy3cC2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B560DE4;
	Mon, 22 Jan 2024 23:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967745; cv=none; b=CxFF8DEJJyyZV+WuMbG0YSfkgyZ2usw+QXMGgeGdwsfx4jvaD8pnnwRKXM7UK8fQYM2+MebMxg+el8Waafep1saTeps8wL3Vp2zxnD6Is9P5X7Pos47MEJnABi7zxoOxtKSBm4uTpeFz9eAjtQjp/V708a/JZspFsIfAr2gmWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967745; c=relaxed/simple;
	bh=n73/5UOAhzQ9QyTV4Ct+NOyk/hG8SoHeEMqddbIaAF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p4ZvctrM/lMjyA6GWhqwGYKT97ZPCMcm9urpVwIvzDepna24qi7jJKl4SWcmy1CCfojpltqcyEH2Ept87wxRHWl0pYpU7lIubZLBDA5WFzpW99YMMQQ7qDhfiZnKdAxjPT4bpPuTdQhd2+Qlgea67/8tuILNEksKSs4skej6eVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=joOy3cC2; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967744; x=1737503744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n73/5UOAhzQ9QyTV4Ct+NOyk/hG8SoHeEMqddbIaAF0=;
  b=joOy3cC2tSphWQkOJlOqrxMDmqeraQ/F0aWgBlk2iVV/lDPp8OUdkAyo
   +o/QBmpkgBRKxX1ImnJrYNyu9hw5W6AM/9TktCu0KumzvFnHepXS6w5JD
   XBlxO9szfFI9LlBAWNv8TubMUWj2jhKfGEhZCzzKBoTMI7GAxvwMKmZ3g
   wSULgH3PkWlVSdoW/c84yHgL8qYIwpowWZCTVlsfoWVgly2Oyd0oYU5ID
   kdJsrxN17dL8+310zgXrm2GacHYIlC4uQE7p/5cJP7vUph7oVc3v96Orv
   lGs910nULRVYI4Fxa6nuD2osdWk4GszxvvikkXxIhZik2atVV/5hsqlXb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016431"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016431"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468184"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:34 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v18 058/121] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date: Mon, 22 Jan 2024 15:53:34 -0800
Message-Id: <d854fa4415ca6d2b5d055d0b29b147a5cdf232f7.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index cd12e9c2a421..53a6c3f692b0 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -52,6 +52,36 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
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
+static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in,
+				    struct tdx_module_args *out)
+{
+#define SEAMCALL_RETRY_MAX     16
+	int retry = SEAMCALL_RETRY_MAX;
+	u64 ret;
+
+	do {
+		ret = tdx_seamcall(op, in, out);
+	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
+	return ret;
+}
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	struct tdx_module_args in = {
@@ -74,7 +104,7 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 	};
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_ADD, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
@@ -87,7 +117,7 @@ static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 	};
 
 	clflush_cache_range(__va(page), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_SEPT_ADD, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in, out);
 }
 
 static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
@@ -98,7 +128,7 @@ static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_SEPT_RD, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_RD, &in, out);
 }
 
 static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
@@ -109,7 +139,7 @@ static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_REMOVE, &in, out);
 }
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
@@ -133,7 +163,7 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	};
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, &in, out);
 }
 
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
@@ -146,7 +176,7 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	};
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_AUG, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
@@ -157,7 +187,7 @@ static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, &in, out);
 }
 
 static inline u64 tdh_mng_key_config(hpa_t tdr)
@@ -307,7 +337,7 @@ static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &in, out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -335,7 +365,7 @@ static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, &in, out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1


