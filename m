Return-Path: <kvm+bounces-30084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B27969B6C95
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 257CDB23599
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AD9213EE0;
	Wed, 30 Oct 2024 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aIICdekM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1E7205AC7;
	Wed, 30 Oct 2024 19:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314865; cv=none; b=DtntZqHyB9jlFbMLFBbG2AHmRR+naqgJk4Y+2Tkvj8RkriJw3lZWQ3v9P9W4J/+SYWvcPzYFhc8MkPbuHzYz3Q0j7GHGPQcSi0tbt2Iag6ZWWgJhpI4iCPJ2QftwaXQJjAqOsMBbaKpMKyo1AWg9XyPch8xlgEq26F8Z+Wp5048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314865; c=relaxed/simple;
	bh=6ROfy2DDXp7OY67erwalEx4mAjPzBIrJaF6l96Cx5xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHx6Zn/VptgIAzi1OEouNn2lQzMh8w7P8wO0GcEahJGNAIi7PZT8GNI/7f6lKyYGbWVm/vzJHYX07rX8uQ76g+xG2PSmGUA9VnyHsXNTsiLbnuEn1ZJxv36oIS4B2cJTkg2LZSlqE+s4YN+wQGHZrlyW65kkQKPo8KhgjFx/qBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aIICdekM; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314861; x=1761850861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ROfy2DDXp7OY67erwalEx4mAjPzBIrJaF6l96Cx5xA=;
  b=aIICdekM7RUKXNIrsWHoWDKhRacSTGrJrn62GP/x4i5wdOqsM3max6UN
   vV29f78d3bzcKsgsujq1PYHK8LWJ3UCm4OYaSvpWFYquiFPqCIwMVFd8V
   266lE4s5wuvIBK5ThXyuLbdsrJ7Sk7CnGBErtUc8HoYCWTs6RonQuMdb/
   bmGPWfrE0fr2Cyn2C55vaoUKKrh9qPJ05D54vfZ+/sDpX8DZ+EAZccL7A
   xrBaswBqwriOZ8MJcHGRcHXPO9Zm5IssM34P1mTGGcO7wDEjSRO9Wxqh3
   rXDGNgvk5VlJRkULrYW5UT5ne/b6uCy/ttFYuDQbmvCQI4kRHssUctV+o
   w==;
X-CSE-ConnectionGUID: 2GbWuA2JSYK8ns9mqnkQoQ==
X-CSE-MsgGUID: EwqkGwTvSLOCDZ7QPpWANg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678740"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678740"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:57 -0700
X-CSE-ConnectionGUID: bJgxID0XQYC7InQBpOZYGw==
X-CSE-MsgGUID: QSoVWIl+QMa7TV5WD2yQpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499341"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:57 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v2 06/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
Date: Wed, 30 Oct 2024 12:00:19 -0700
Message-ID: <20241030190039.77971-7-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Intel TDX protects guest VMs from malicious hosts and certain physical
attacks. It defines various control structures that hold state for things
like TDs or vCPUs. These control structures are stored in pages given to
the TDX module and encrypted with either the global KeyID or the guest
KeyIDs.

To manipulate these control structures the TDX module defines a few
SEAMCALLs. KVM will use these during the process of creating a TD as
follows:

1) Allocate a unique TDX KeyID for a new guest.

1) Call TDH.MNG.CREATE to create a "TD Root" (TDR) page, together with
   the new allocated KeyID. Unlike the rest of the TDX guest, the TDR
   page is crypto-protected by the 'global KeyID'.

2) Call the previously added TDH.MNG.KEY.CONFIG on each package to
   configure the KeyID for the guest. After this step, the KeyID to
   protect the guest is ready and the rest of the guest will be protected
   by this KeyID.

3) Call TDH.MNG.ADDCX to add TD Control Structure (TDCS) pages.

4) Call TDH.MNG.INIT to initialize the TDCS.

To reclaim these pages for use by the kernel other SEAMCALLs are needed,
which will be added in future patches.

Add tdh_mng_addcx(), tdh_mng_create() and tdh_mng_init() to export these
SEAMCALLs so that KVM can use them to create TDs.

For SEAMCALLs that give a page to the TDX module to be encrypted, clflush
the page mapped with KeyID 0, such that any dirty cache lines don't write
back later and clobber TD memory or control structures. Don't worry about
the other MK-TME KeyIDs because the kernel doesn't use them. The TDX docs
specify that this flush is not needed unless the TDX module exposes the
CLFLUSH_BEFORE_ALLOC feature bit. Be conservative and aways flush.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
uAPI breakout v2:
 - Change to use 'u64' as function parameter to prepare to move
   SEAMCALL wrappers to arch/x86. (Kai)
 - Split to separate patch
 - Move SEAMCALL wrappers from KVM to x86 core;
 - Move TDH_xx macros from KVM to x86 core;
 - Re-write log

uAPI breakout v1:
 - Make argument to C wrapper function struct kvm_tdx * or
   struct vcpu_tdx * .(Sean)
 - Drop unused helpers (Kai)
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)

v19:
 - Update the commit message to match the patch by Yuan
 - Use seamcall() and seamcall_ret() by paolo

v18:
 - removed stub functions for __seamcall{,_ret}()
 - Added Reviewed-by Binbin
 - Make tdx_seamcall() use struct tdx_module_args instead of taking
  each inputs.

v16:
 - use struct tdx_module_args instead of struct tdx_module_output
 - Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1.
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 45 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9897335a8e2f..9d19ca33e884 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -123,8 +123,11 @@ int tdx_guest_keyid_alloc(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
+u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
 u64 tdh_mng_key_config(u64 tdr);
+u64 tdh_mng_create(u64 tdr, u64 hkid);
 u64 tdh_mng_key_freeid(u64 tdr);
+u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c42eab8cc069..16122fd552ff 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1563,6 +1563,18 @@ void tdx_guest_keyid_free(unsigned int keyid)
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
+u64 tdh_mng_addcx(u64 tdr, u64 tdcs)
+{
+	struct tdx_module_args args = {
+		.rcx = tdcs,
+		.rdx = tdr,
+	};
+
+	clflush_cache_range(__va(tdcs), PAGE_SIZE);
+	return seamcall(TDH_MNG_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_addcx);
+
 u64 tdh_mng_key_config(u64 tdr)
 {
 	struct tdx_module_args args = {
@@ -1573,6 +1585,17 @@ u64 tdh_mng_key_config(u64 tdr)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_config);
 
+u64 tdh_mng_create(u64 tdr, u64 hkid)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+		.rdx = hkid,
+	};
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	return seamcall(TDH_MNG_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_create);
+
 u64 tdh_mng_key_freeid(u64 tdr)
 {
 	struct tdx_module_args args = {
@@ -1582,3 +1605,19 @@ u64 tdh_mng_key_freeid(u64 tdr)
 	return seamcall(TDH_MNG_KEY_FREEID, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
+
+u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+		.rdx = td_params,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_INIT, &args);
+
+	*rcx = args.rcx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mng_init);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 95002e7ff4c5..b9287304f372 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -17,8 +17,11 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_MNG_ADDCX			1
 #define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_CREATE			9
 #define TDH_MNG_KEY_FREEID		20
+#define TDH_MNG_INIT			21
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
-- 
2.47.0


