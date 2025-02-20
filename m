Return-Path: <kvm+bounces-38731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA5EDA3E1DA
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D134A19C1A7A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFA5213E87;
	Thu, 20 Feb 2025 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5eJENp2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E7212D66
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071182; cv=none; b=fbadyJZQBRKhcjiYJxyrmTKGk6QuUGUym/G+zgWsHcb4G3xHn1Y5X1Hq+I/Ts0jt7dn/JlDkK/rB0W+B0RaAj24OZ1qWc0PpG66gYiZyZMScE2nFms3Gcec/XEIom/wbGeq3CADHwhGAd2+i/UybX0Rkbb+jWaenPMVGx3sBBFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071182; c=relaxed/simple;
	bh=C11cFM17yzoQCRgS9TdGJ9DHeg6lvLv0JX89cC8cj/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2Lqcf/RkMos6RSPaDbezm44a5FMNezZtizuRjy2pZQMp2Jphnf4g1Caod0esT4jI5Ym9i7JKOJFd22TYifG0GMoN//n+fJGGEwGIpjxma9fKD8gaawtLhdWUASo0Bejz+Lmp7vD4qJZwtxGi52IJ/GVsLpfOXuhxpBit86l42U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e5eJENp2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hB4wLHar9EB7VrqR/GY4wk+BmJM+LvI82FrpGT858TU=;
	b=e5eJENp2N0VEePYTZteYouwnQFz5WNJM538mtuG5dRKGHXRAxOYhKf29vkrYLo8q4G+rrD
	m4YVDz4tCOETxEIJaaMlvAveXYE5ZC0+Fu3mmqvTk0YlmQ1RxqlZIsbsO2WZXv+x4zvtR1
	FtPLb2RPpXy8Cpx+oO75rEj5rnS3n1Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-V34fs54nO9ONpxb5hS7c6w-1; Thu,
 20 Feb 2025 12:06:14 -0500
X-MC-Unique: V34fs54nO9ONpxb5hS7c6w-1
X-Mimecast-MFC-AGG-ID: V34fs54nO9ONpxb5hS7c6w_1740071172
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F2FC1800875;
	Thu, 20 Feb 2025 17:06:12 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 853D31800D9E;
	Thu, 20 Feb 2025 17:06:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 03/30] x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
Date: Thu, 20 Feb 2025 12:05:37 -0500
Message-ID: <20250220170604.2279312-4-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. It defines various control structures that hold state for
virtualized components of the TD (i.e. VMs or vCPUs) These control
structures are stored in pages given to the TDX module and encrypted
with either the global KeyID or the guest KeyIDs.

To manipulate these control structures the TDX module defines a few
SEAMCALLs. KVM will use these during the process of creating a vCPU as
follows:

1) Call TDH.VP.CREATE to create a TD vCPU Root (TDVPR) page for each
   vCPU.

2) Call TDH.VP.ADDCX to add per-vCPU control pages (TDCX) for each vCPU.

3) Call TDH.VP.INIT to initialize the TDCX for each vCPU.

To reclaim these pages for use by the kernel other SEAMCALLs are needed,
which will be added in future patches.

Export functions to allow KVM to make these SEAMCALLs. Export two
variants for TDH.VP.CREATE, in order to support the planned logic of KVM
to support TDX modules with and without the ENUM_TOPOLOGY feature. If
KVM can drop support for the !ENUM_TOPOLOGY case, this could go down a
single version. Leave that for later discussion.

The TDX module provides SEAMCALLs to hand pages to the TDX module for
storing TDX controlled state. SEAMCALLs that operate on this state are
directed to the appropriate TD vCPU using references to the pages
originally provided for managing the vCPU's state. So the host kernel
needs to track these pages, both as an ID for specifying which vCPU to
operate on, and to allow them to be eventually reclaimed. The vCPU
associated pages are called TDVPR (Trust Domain Virtual Processor Root)
and TDCX (Trust Domain Control Extension).

Introduce "struct tdx_vp" for holding references to pages provided to the
TDX module for the TD vCPU associated state. Don't plan for any vCPU
associated state that is controlled by KVM to live in this struct. Only
expect it to hold data for concepts specific to the TDX architecture, for
which there can't already be preexisting storage for in KVM.

Add both the TDVPR page and an array of TDCX pages, even though the
SEAMCALL wrappers will only need to know about the TDVPR pages for
directing the SEAMCALLs to the right vCPU. Adding the TDCX pages to this
struct will let all of the vCPU associated pages handed to the TDX module be
tracked in one location. For a type to specify physical pages, use KVM's
hpa_t type. Do this for KVM's benefit This is the common type used to hold
physical addresses in KVM, so will make interoperability easier.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-ID: <20241203010317.827803-4-rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  | 14 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 43 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 11 ++++++++++
 3 files changed, 68 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6ba3b806e880..f783d5f1a0e1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -127,13 +127,27 @@ struct tdx_td {
 	int tdcs_nr_pages;
 	/* TD control structure: */
 	struct page **tdcs_pages;
+
+	/* Size of `tdcx_pages` in struct tdx_vp */
+	int tdcx_nr_pages;
+};
+
+struct tdx_vp {
+	/* TDVP root page */
+	struct page *tdvpr_page;
+
+	/* TD vCPU control structure: */
+	struct page **tdcx_pages;
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ce4b1e96c5b0..e55570575f22 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -5,6 +5,7 @@
  * Intel Trusted Domain Extensions (TDX) support
  */
 
+#include "asm/page_types.h"
 #define pr_fmt(fmt)	"virt/tdx: " fmt
 
 #include <linux/types.h>
@@ -1462,6 +1463,11 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_phys(td->tdr_page);
 }
 
+static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
+{
+	return page_to_phys(td->tdvpr_page);
+}
+
 /*
  * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
  * a CLFLUSH of pages is required before handing them to the TDX module.
@@ -1485,6 +1491,18 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_phys(tdcx_page),
+		.rdx = tdx_tdvpr_pa(vp),
+	};
+
+	tdx_clflush_page(tdcx_page);
+	return seamcall(TDH_VP_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1507,6 +1525,18 @@ u64 tdh_mng_create(struct tdx_td *td, u16 hkid)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_create);
 
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
+		.rdx = tdx_tdr_pa(td),
+	};
+
+	tdx_clflush_page(vp->tdvpr_page);
+	return seamcall(TDH_VP_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_create);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1532,3 +1562,16 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_mng_init);
+
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
+		.rdx = initial_rcx,
+		.r8 = x2apicid,
+	};
+
+	/* apicid requires version == 1. */
+	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 0861c3f09576..f0464f7d9780 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,10 +16,13 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
+#define TDH_VP_CREATE			10
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
+#define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
@@ -28,6 +31,14 @@
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_SYS_CONFIG			45
 
+/*
+ * SEAMCALL leaf:
+ *
+ * Bit 15:0	Leaf number
+ * Bit 23:16	Version number
+ */
+#define TDX_VERSION_SHIFT		16
+
 /* TDX page types */
 #define	PT_NDA		0x0
 #define	PT_RSVD		0x1
-- 
2.43.5



