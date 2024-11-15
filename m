Return-Path: <kvm+bounces-31965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9D69CF5FC
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D9A1B36E5F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BF61E5723;
	Fri, 15 Nov 2024 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSw1DsvS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13FB15FD13;
	Fri, 15 Nov 2024 20:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702042; cv=none; b=aM9z60ziUF7lL7bgcAe0Vw0kZPGSnc3LJAaw412A9TbFWlsmfm4PSYVeMPIZ01cl68aJxOdIe5xKI177i7/USrtpB5j6OXGYAPua441RSW3T2H2ycUvgSNhVzlHjWbKnD4i8LOQjtKn4h/TVjCXCN2+uyfIRj9ZXATT5WkWJw6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702042; c=relaxed/simple;
	bh=gBg3L2e5m3DkycRmAJj5P8rPfMkozkulXEtGKjJJvKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgbtDf2usXMCmUfjnjQ/huILtltC9Z8EqbEU83sSJM/+0pXozYkVZtcC0gpq6gVfEB47adfvfTn3mRQt8xopA2zAAd2vpwks/sBWz1K28iknpbpa8yaI98uShcUrArIJGa0LKuhWUkXy5UNtCbj60wmmG7PjgaA3xUvR0E4mvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSw1DsvS; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731702041; x=1763238041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gBg3L2e5m3DkycRmAJj5P8rPfMkozkulXEtGKjJJvKE=;
  b=SSw1DsvSvtEetgjxt58v8MI0Hgordjf6xrr8s7IfWI6wnbKoCMoUb5K2
   kYglAHntGk9zOext5lAuXsImVaO0GqryV97Jw4toUXqVy6PEK0Jtudknu
   GWv7WRvDA4tuiqybVnyxKtPI9g9YECWF1E4sEVdIEnDGSixofL9fDLKmZ
   Xw1QGVJvSRmm4HJ02w6QPYpgkABT97tflw7ChZZq0pEXdCnmjj39Qxg4b
   vxgrWv3Lmq5p9u+d/Jsk2A4RJLmaYc/cLYZs4HQq9/1nxHWU6yLtZ6Y5z
   mKQB0OoKor9ddyCTvZUOfeOyqguaaHDwgteNU88nbPZYs4FJDONifSnHJ
   A==;
X-CSE-ConnectionGUID: KCPExCWmQbCQmyuxgFMpiA==
X-CSE-MsgGUID: rZL1+UNKR7esh4R5SK3l5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="54228327"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="54228327"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:40 -0800
X-CSE-ConnectionGUID: qw4oD8xFRu+MZzD9gRAiHw==
X-CSE-MsgGUID: 8601D9pbRNu0hJbNv7Q+sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93599393"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:39 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@intel.com
Cc: isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	x86@kernel.org,
	adrian.hunter@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
Date: Fri, 15 Nov 2024 12:20:22 -0800
Message-ID: <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

The TDX module provides SEAMCALLs to hand pages to the TDX module for
storing TDX controlled state. SEAMCALLs that operate on this state are
directed to the appropriate TD VM using references to the pages originally
provided for managing the TD's state. So the host kernel needs to track
these pages, both as an ID for specifying which TD to operate on, and to
allow them to be eventually reclaimed. The TD VM associated pages are
called TDR (Trust Domain Root) and TDCS (Trust Domain Control Structure).

Introduce "struct tdx_td" for holding references to pages provided to the
TDX module for this TD VM associated state. Don't plan for any TD
associated state that is controlled by KVM to live in this struct. Only
expect it to hold data for concepts specific to the TDX architecture, for
which there can't already be preexisting storage for in KVM.

Add both the TDR page and an array of TDCS pages, even though the SEAMCALL
wrappers will only need to know about the TDR pages for directing the
SEAMCALLs to the right TD. Adding the TDCS pages to this struct will let
all of the TD VM associated pages handed to the TDX module be tracked in
one location. For a type to specify physical pages, use KVM's hpa_t type.
Do this for KVM's benefit This is the common type used to hold physical
addresses in KVM, so will make interoperability easier.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
SEAMCALL RFC:
 - Introduce struct tdx_td to use instead of raw TDR u64

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
---
 arch/x86/include/asm/tdx.h  |  9 +++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 22 ++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 16 +++++++++-------
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d33e46d53d59..ebee4260545f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -34,6 +34,7 @@
 
 #include <uapi/asm/mce.h>
 #include "tdx_global_metadata.h"
+#include <linux/kvm_types.h>
 
 /*
  * Used by the #VE exception handler to gather the #VE exception
@@ -121,6 +122,14 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 int tdx_guest_keyid_alloc(void);
 void tdx_guest_keyid_free(unsigned int keyid);
+
+struct tdx_td {
+	hpa_t tdr;
+	hpa_t *tdcs;
+};
+
+u64 tdh_mng_key_config(struct tdx_td *td);
+u64 tdh_mng_key_freeid(struct tdx_td *td);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b883c1a4b002..20eb756b41de 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1562,3 +1562,25 @@ void tdx_guest_keyid_free(unsigned int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
+
+u64 tdh_mng_key_config(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+	};
+
+	return seamcall(TDH_MNG_KEY_CONFIG, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_key_config);
+
+
+u64 tdh_mng_key_freeid(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+	};
+
+	return seamcall(TDH_MNG_KEY_FREEID, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
+
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


