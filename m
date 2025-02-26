Return-Path: <kvm+bounces-39322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A5CA4695C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCA7A7ABF53
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF66B238140;
	Wed, 26 Feb 2025 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRHwPSA3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FE32376F8
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593714; cv=none; b=VHK2BA8Fn0V81l8Jl0BK5Ck/8mpQOuzAPH6BF3ofzLUWrd8WKqxrBorxqVUQ/z2DwliS89ejRYSzk+53g1VG/hZzW/2BEM14Pc0mDEhYq24g2NWl1/GsSJbHkl7/QBo2AnWvThBLksz3Piyzncmp6RHHcyld61EOtHMcD3flSqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593714; c=relaxed/simple;
	bh=wY1Pb1vPVwTQHEMlUj9j3SJ4mM5BlX9vgSFEdokefKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIlNDMCTMq9iS24uSL6NYp6YggnuY00Kxpih2xe5ysvDAkiWN+s5zknyWuT2QkVW68TrA6RJa7eSbbFneoxl0K8vKLlaetzG+5ES3WgPnkpgxPEHbiPLNy/7l8DD0G2r2nOggacWUtNUwRGF92j7L+9UxUF4o5FOpdz6GSI5Gm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRHwPSA3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oCnObeshrys+iNedWnjUTWZfkadynDg4c9xMBwTmFtA=;
	b=dRHwPSA3xPoCJhRwxFB3/DULpsRd1Tz0KcN84RYqBGchxiuC1eO/rc88lrhymcnsTe3h4n
	Dwig5413SPbOW0x8XXY8wbTG/mSiaflW6nwft+IC1IfM2pieITKJyRgXWRGc3D+c5RiMyb
	CUGUMYFT4A8q5PXXM58ymQvH/n0EEJg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-rElfOjuBPo6rl5ziuTPIfw-1; Wed,
 26 Feb 2025 13:15:08 -0500
X-MC-Unique: rElfOjuBPo6rl5ziuTPIfw-1
X-Mimecast-MFC-AGG-ID: rElfOjuBPo6rl5ziuTPIfw_1740593706
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C0C81800988;
	Wed, 26 Feb 2025 18:15:06 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04653196B087;
	Wed, 26 Feb 2025 18:15:04 +0000 (UTC)
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
Subject: [PATCH 07/33] x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
Date: Wed, 26 Feb 2025 13:14:26 -0500
Message-ID: <20250226181453.2311849-8-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. The TDX module uses pages provided by the host for both control
structures and for TD guest pages. These pages are encrypted using the
MK-TME encryption engine, with its special requirements around cache
invalidation. For its own security, the TDX module ensures pages are
flushed properly and track which usage they are currently assigned. For
creating and tearing down TD VMs and vCPUs KVM will need to use the
TDH.PHYMEM.PAGE.RECLAIM, TDH.PHYMEM.CACHE.WB, and TDH.PHYMEM.PAGE.WBINVD
SEAMCALLs.

Add tdh_phymem_page_reclaim() to enable KVM to call
TDH.PHYMEM.PAGE.RECLAIM to reclaim the page for use by the host kernel.
This effectively resets its state in the TDX module's page tracking
(PAMT), if the page is available to be reclaimed. This will be used by KVM
to reclaim the various types of pages owned by the TDX module. It will
have a small wrapper in KVM that retries in the case of a relevant error
code. Don't implement this wrapper in arch/x86 because KVM's solution
around retrying SEAMCALLs will be better located in a single place.

Add tdh_phymem_cache_wb() to enable KVM to call TDH.PHYMEM.CACHE.WB to do
a cache write back in a way that the TDX module can verify, before it
allows a KeyID to be freed. The KVM code will use this to have a small
wrapper that handles retries. Since the TDH.PHYMEM.CACHE.WB operation is
interruptible, have tdh_phymem_cache_wb() take a resume argument to pass
this info to the TDX module for restarts. It is worth noting that this
SEAMCALL uses a SEAM specific MSR to do the write back in sections. In
this way it does export some new functionality that affects CPU state.

Add tdh_phymem_page_wbinvd_tdr() to enable KVM to call
TDH.PHYMEM.PAGE.WBINVD to do a cache write back and invalidate of a TDR,
using the global KeyID. The underlying TDH.PHYMEM.PAGE.WBINVD SEAMCALL
requires the related KeyID to be encoded into the SEAMCALL args. Since the
global KeyID is not exposed to KVM, a dedicated wrapper is needed for TDR
focused TDH.PHYMEM.PAGE.WBINVD operations.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-ID: <20241203010317.827803-5-rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  | 17 +++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 62 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f783d5f1a0e1..ea26d79ec9d9 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -33,6 +33,7 @@
 #ifndef __ASSEMBLY__
 
 #include <uapi/asm/mce.h>
+#include <linux/pgtable.h>
 
 /*
  * Used by the #VE exception handler to gather the #VE exception
@@ -140,6 +141,19 @@ struct tdx_vp {
 	struct page **tdcx_pages;
 };
 
+
+static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
+{
+	u64 ret;
+
+	ret = page_to_phys(page);
+	/* KeyID bits are just above the physical address bits: */
+	ret |= (u64)hkid << boot_cpu_data.x86_phys_bits;
+
+	return ret;
+
+}
+
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
@@ -148,6 +162,9 @@ u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
+u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_phymem_cache_wb(bool resume);
+u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e55570575f22..2350d25b4ca3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1575,3 +1575,45 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init);
+
+/*
+ * TDX ABI defines output operands as PT, OWNER and SIZE. These are TDX defined fomats.
+ * So despite the names, they must be interpted specially as described by the spec. Return
+ * them only for error reporting purposes.
+ */
+u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_phys(page),
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
+
+	*tdx_pt = args.rcx;
+	*tdx_owner = args.rdx;
+	*tdx_size = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
+
+u64 tdh_phymem_cache_wb(bool resume)
+{
+	struct tdx_module_args args = {
+		.rcx = resume ? 1 : 0,
+	};
+
+	return seamcall(TDH_PHYMEM_CACHE_WB, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
+
+u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
+{
+	struct tdx_module_args args = {};
+
+	args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index f0464f7d9780..7a15c9afcdfa 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -24,11 +24,14 @@
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_PHYMEM_PAGE_RECLAIM		28
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
+#define TDH_PHYMEM_CACHE_WB		40
+#define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_SYS_CONFIG			45
 
 /*
-- 
2.43.5



