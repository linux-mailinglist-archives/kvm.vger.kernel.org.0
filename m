Return-Path: <kvm+bounces-30083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F279B6C93
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF86EB23390
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D3D217919;
	Wed, 30 Oct 2024 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l24PXbhi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9DD2144C9;
	Wed, 30 Oct 2024 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314862; cv=none; b=QgSDU3lVNPZ48o3ywlO6WJIzyo4ODw/mW5ywjbq6vzb/9QKyx3EA2Kuq/reGe2Q6pq48mSxXzhnPTSTIX8y6VB1Iv61V/BZ/rSN5PBa+yKJwo6Fb163jpLFo42xfn8ns+R2Ucc+6JreMQVchCRGbY/RmzOmJxRdYEVisQCRE5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314862; c=relaxed/simple;
	bh=CiSo38Rz8D/47DL/LqhUW7zxwMDCBDtJIrYv9FERmIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6bd0Q3y2lg9cmCnkbRrW44zFQPrvEKUWhLFVwEmjYMoiZIQhE/4XNSC+JY9yZb+KJpxo4QgboWGzMzSvLXlApQssXm3+diSLtY8VmDHaWVN1s8KPwb+QwOYMu9JOtmzMtrSWXzgE75mAwTNAOa5fzMyc7uXG7Cg9cMmwvgbgeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l24PXbhi; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314860; x=1761850860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CiSo38Rz8D/47DL/LqhUW7zxwMDCBDtJIrYv9FERmIY=;
  b=l24PXbhiU7zIrxThO5rmp4aQR1QbugDuHExx2XDZF1xw7K3YeaWSQu3Z
   PPPU5DBW7cLq4mWRijSjMH3c1Aj0pqSJn8lVjlUAuQs4Y7+691wB22tl4
   6D/YBev8GKfUqMb1GVPz5ogSW5/jmat2BzacKbI6LZJ1tBl3VMBm2Mngq
   LYdyFlhNM0Sw/7txcV6EpOlUnsuXhQQR4ICCEfTwodAjlgmkEMXiDnZ8e
   HB/kdeQviia75G0dDGGEFeQUman82eM5iR0REWlm2DJK7U/BmDxhID22N
   2GibhpkMUjKsgyqF5qLqp9xqBpj359URtQWVPp0IxqNodWM943SuRQqIU
   w==;
X-CSE-ConnectionGUID: oxQ+PN7HRUOrgqGZWhTyTQ==
X-CSE-MsgGUID: h2k15WMdRIWJp/IPXAOfwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678732"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678732"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:57 -0700
X-CSE-ConnectionGUID: 7spFaC6LQ2GIQ3AxxXTuWA==
X-CSE-MsgGUID: C4WTCg4RQcKMTbXdbrI9TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499335"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:56 -0700
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
Subject: [PATCH v2 05/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
Date: Wed, 30 Oct 2024 12:00:18 -0700
Message-ID: <20241030190039.77971-6-rick.p.edgecombe@intel.com>
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

Intel TDX protects guest VMs from malicious host and certain physical
attacks. Pre-TDX Intel hardware has support for a memory encryption
architecture called MK-TME, which repurposes several high bits of
physical address as "KeyID". TDX ends up with reserving a sub-range of
MK-TME KeyIDs as "TDX private KeyIDs".

Like MK-TME, these KeyIDs can be associated with an ephemeral key. For TDX
this association is done by the TDX module. It also has its own tracking
for which KeyIDs are in use. To do this ephemeral key setup and manipulate
the TDX module's internal tracking, KVM will use the following SEAMCALLs:
 TDH.MNG.KEY.CONFIG: Mark the KeyID as in use, and initialize its
                     ephemeral key.
 TDH.MNG.KEY.FREEID: Mark the KeyID as not in use.

These SEAMCALLs both operate on TDR structures, which are setup using the
previously added TDH.MNG.CREATE SEAMCALL. KVM's use of these operations
will go like:
 - tdx_guest_keyid_alloc()
 - Initialize TD and TDR page with TDH.MNG.CREATE (not yet-added), passing
   KeyID
 - TDH.MNG.KEY.CONFIG to initialize the key
 - TD runs, teardown is started
 - TDH.MNG.KEY.FREEID
 - tdx_guest_keyid_free()

Don't try to combine the tdx_guest_keyid_alloc() and TDH.MNG.KEY.CONFIG
operations because TDH.MNG.CREATE and some locking need to be done in the
middle. Don't combine TDH.MNG.KEY.FREEID and tdx_guest_keyid_free() so they
are symmetrical with the creation path.

So implement tdh_mng_key_config() and tdh_mng_key_freeid() as separate
functions than tdx_guest_keyid_alloc() and tdx_guest_keyid_free().

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
 arch/x86/include/asm/tdx.h  |  4 ++++
 arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 16 +++++++++-------
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d33e46d53d59..9897335a8e2f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -121,6 +121,10 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 int tdx_guest_keyid_alloc(void);
 void tdx_guest_keyid_free(unsigned int keyid);
+
+/* SEAMCALL wrappers for creating/destroying/running TDX guests */
+u64 tdh_mng_key_config(u64 tdr);
+u64 tdh_mng_key_freeid(u64 tdr);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b883c1a4b002..c42eab8cc069 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1562,3 +1562,23 @@ void tdx_guest_keyid_free(unsigned int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
+
+u64 tdh_mng_key_config(u64 tdr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+	};
+
+	return seamcall(TDH_MNG_KEY_CONFIG, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_key_config);
+
+u64 tdh_mng_key_freeid(u64 tdr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+	};
+
+	return seamcall(TDH_MNG_KEY_FREEID, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 9b708a8fb568..95002e7ff4c5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -17,13 +17,15 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
-#define TDH_PHYMEM_PAGE_RDMD	24
-#define TDH_SYS_KEY_CONFIG	31
-#define TDH_SYS_INIT		33
-#define TDH_SYS_RD		34
-#define TDH_SYS_LP_INIT		35
-#define TDH_SYS_TDMR_INIT	36
-#define TDH_SYS_CONFIG		45
+#define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_KEY_FREEID		20
+#define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_SYS_KEY_CONFIG		31
+#define TDH_SYS_INIT			33
+#define TDH_SYS_RD			34
+#define TDH_SYS_LP_INIT			35
+#define TDH_SYS_TDMR_INIT		36
+#define TDH_SYS_CONFIG			45
 
 /* TDX page types */
 #define	PT_NDA		0x0
-- 
2.47.0


