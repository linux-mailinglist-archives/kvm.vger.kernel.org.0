Return-Path: <kvm+bounces-9693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F80866CF6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FACD1F26BED
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E350B64CC6;
	Mon, 26 Feb 2024 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWIjBoO6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5861691;
	Mon, 26 Feb 2024 08:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936109; cv=none; b=affIA8d/ZYFA2eF8wWTb3kHFNl3QwL8F2jBf71xDg8P1gjMQBEMUSJwHxzRsuRljpvS4Zeol4rnKvEIkLxWnWtSGJseqVTAdKJbdVC10gxsdhAH4Q1bqu5mTuQQvWIp8IDiXJLH1hJ83QEVauKcqvNIo2AhQ3wrXvfYyaY0FTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936109; c=relaxed/simple;
	bh=mBPPHS+6lnLS94iBXvUmiGc7FJFyMVT0Ja3kQbVsMDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrM2FezaNOj9vgmlrQxznU+cIbE4B/HUJ82wZ6LFyMAy8dPGiNltk/P76gAqguQtlwLhWiV5+mj+3m5cwNlTSZjVhQSEKezjhkdhisOcblyC7klbhjSrdV2K+pWYaCUI0XzaXs7h7Vqq6lP1a4IOJa8/KAvjrBletvcjynZAelg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OWIjBoO6; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936106; x=1740472106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mBPPHS+6lnLS94iBXvUmiGc7FJFyMVT0Ja3kQbVsMDM=;
  b=OWIjBoO6vIdzlfkl7eKa0Kv4NslV+wxRp7//Lv40urC+sBUsthqLIi0r
   8lB9C7dNSoJlan7qyJ2zeK27wXPaZYj1pAsF0x+LiU1tffIPmilJwjXwh
   rLkZaGb3e59p8FA70F+WL9zOg9jIPbY96AoC7Y2gOHCInUnobis4QIxvi
   hl5pHEKYyZY5XsuVDBdfXuv0qVm9ffPRLGUH/CMlUx9ZX+/vCAjIbuYKx
   U5sG/VfzeSKkuRIMHqzVz16gU5kGZ3EJRu2lw3oqdXqzIUgRRWEljv0aZ
   y6DUs+GWSyZytwRdJAGaQq69P76v5tRdaKTCD0UllZxlyFWJ5/Y2eTkhT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069455"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069455"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272376"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:26 -0800
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
Subject: [PATCH v19 068/130] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date: Mon, 26 Feb 2024 00:26:10 -0800
Message-Id: <d705a6c6a81246a77f83befd1865d0c4194b2d28.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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

Retry TDX TDH.MEM.* API on the error because the error is a rare event
caused by zero-step attack mitigation.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- fix typo TDG.VP.ENTER => TDH.VP.ENTER,
  TDX_OPRRAN_BUSY => TDX_OPERAND_BUSY
- drop the description on TDH.VP.ENTER as this patch doesn't touch
  TDH.VP.ENTER
---
 arch/x86/kvm/vmx/tdx_ops.h | 48 +++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index d80212b1daf3..e5c069b96126 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -44,6 +44,36 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
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
@@ -66,7 +96,7 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 	};
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_ADD, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
@@ -79,7 +109,7 @@ static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 	};
 
 	clflush_cache_range(__va(page), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_SEPT_ADD, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in, out);
 }
 
 static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
@@ -90,7 +120,7 @@ static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_SEPT_RD, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_RD, &in, out);
 }
 
 static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
@@ -101,7 +131,7 @@ static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_SEPT_REMOVE, &in, out);
 }
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
@@ -125,7 +155,7 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	};
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, &in, out);
 }
 
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
@@ -138,7 +168,7 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	};
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	return tdx_seamcall(TDH_MEM_PAGE_AUG, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
@@ -149,7 +179,7 @@ static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, &in, out);
 }
 
 static inline u64 tdh_mng_key_config(hpa_t tdr)
@@ -299,7 +329,7 @@ static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &in, out);
 }
 
 static inline u64 tdh_sys_lp_shutdown(void)
@@ -327,7 +357,7 @@ static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
 		.rdx = tdr,
 	};
 
-	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, &in, out);
+	return tdx_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, &in, out);
 }
 
 static inline u64 tdh_phymem_cache_wb(bool resume)
-- 
2.25.1


