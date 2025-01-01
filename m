Return-Path: <kvm+bounces-34432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6109FF33F
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02AEA3A0FAA
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7D814F9C4;
	Wed,  1 Jan 2025 07:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cW8MI+xN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4972A3B1A4
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716662; cv=none; b=oakWDIv1DTRCFEpDFDw0sqk9aSl5PWaU98Ampn5SCnv3iNr4eb9qCAUqeXGba1HKozMTjMu5OCjMaPVtEh4nldlPk5Pl6ENpxi9tv0BC6SMyobw4dPvoRT8ShmicRl3H5ye1WrxxSQlEhzjvJu0vS/qJv8Y6vZ+wCHwev4RI/e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716662; c=relaxed/simple;
	bh=O9rwLDqr8dOcrlZUSsubx4DqFc4WXPGeIvC+UEQStlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdDh0HyiKZUoWPZLcrT6vtek5lUA+Ewnuys0VUG5zyopaQwjuHfuQkBhmGMsd6J84BTD9WGk8H8JSoJj612jOseo+qhQ0WNlyKy6siX0UjIlkuizNFASR7FwxFpAbTuIZm7xzZDq4JVtnmM3gZ4By5hgjA8Vb3vYoepI5uP9zpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cW8MI+xN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3M7a3ke7yNtrCHdCErUKCZWhv2u02V8K8geR4klPdA=;
	b=cW8MI+xNqov1ekYHTWOIoxEszyJWM5XdGSpr4ulWzx7UQGkOTD+PuBGdYTh5+iYh0GSlAS
	gxCKJ1TWzLEkX+b4LRClFTVpHIVaZQh9dPUG1MsPzHHdnTs+xOodVWsuxVHJoG19mP9iSq
	r3+Eb5b4kJ2Ia0RkpeFr3r4doj3YVTM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-4PaDYQhpPsal2rCsooznJQ-1; Wed,
 01 Jan 2025 02:30:55 -0500
X-MC-Unique: 4PaDYQhpPsal2rCsooznJQ-1
X-Mimecast-MFC-AGG-ID: 4PaDYQhpPsal2rCsooznJQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61F1D195608A;
	Wed,  1 Jan 2025 07:30:54 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA32F19560AA;
	Wed,  1 Jan 2025 07:30:52 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 03/11] x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
Date: Wed,  1 Jan 2025 02:30:39 -0500
Message-ID: <20250101073047.402099-4-pbonzini@redhat.com>
In-Reply-To: <20250101073047.402099-1-pbonzini@redhat.com>
References: <20250101073047.402099-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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
Message-ID: <20241115202028.1585487-4-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  9 +++++++
 arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 11 +++++++++
 3 files changed, 67 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 8aadd3d67a6d..1249796d3578 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -123,11 +123,20 @@ struct tdx_td {
 	hpa_t *tdcs;
 };
 
+struct tdx_vp {
+	hpa_t tdvpr;
+	hpa_t *tdcx;
+};
+
 u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs);
+u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
+u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 849b7063021c..9111dab5a05b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1480,6 +1480,18 @@ u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx)
+{
+	struct tdx_module_args args = {
+		.rcx = tdcx,
+		.rdx = vp->tdvpr,
+	};
+
+	tdx_clflush_page(tdcx);
+	return seamcall(TDH_VP_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1502,6 +1514,17 @@ u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_create);
 
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = td->tdr,
+	};
+
+	tdx_clflush_page(vp->tdvpr);
+	return seamcall(TDH_VP_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_create);
 
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
@@ -1528,3 +1551,27 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_mng_init);
+
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = initial_rcx,
+	};
+
+	return seamcall(TDH_VP_INIT, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init);
+
+u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = initial_rcx,
+		.r8 = x2apicid,
+	};
+
+	/* apicid requires version == 1. */
+	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init_apicid);
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



