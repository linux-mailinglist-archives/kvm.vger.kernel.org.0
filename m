Return-Path: <kvm+bounces-34451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CF89FF365
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7877A18823C9
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82861191496;
	Wed,  1 Jan 2025 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Idn7jQDf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02CA18FC65
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717826; cv=none; b=NSWV2BSzbE1Yhpp57Ptg4Abx63vgizK+HPd3xfhPRkSwXaVGZlqxTUPkYAi+cAthmdMyUtgS2dhEPRV4A9dlD8XRuoZlUqzSoQdhscGt1exxnzrfeLt+fUiTUD2YFwZYlKBK+FvQrLUlspnQtd31TQbkciMuswGjAUnJjNabYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717826; c=relaxed/simple;
	bh=APleLdyKbS/le48vxg10Xu1Sz7xpuhYD3HuKhP+YZEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ipmtn+tb9EWBF0flfY70KdtQ+ubACa75ved/BEJ9zNFnqEw1a0VNHhV1FHzrMOkeovHJmWfiQPuTMtqvJQgf9hFbReRixAm02/WgvcqTNFORmYVNKl+6hTeeikrCf1goatbnW9oNf1lDD5v5/ftKeKwv/abUiRCuVhoGLAXSQaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Idn7jQDf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dA881u9qbELe0yReabzafUih88+bu5hPtXSW1bcgHR8=;
	b=Idn7jQDfGncuZfdfAQw3r4GtTXD8egx9qhk8RV0b36qG5rYpWJcYHEV1GxSm4lN0heL9f/
	3wKmyrAR6fPcu2pTfVBQ7ke45aN3eLzreX8tOaMvGJeTfD7t97/5DErAGhi1YvOaAtOtme
	l9sTrXteTnLwrbQ/e9lyWgO64Tv27hM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-rLPrRNVoNcuDulW6kM6uLA-1; Wed,
 01 Jan 2025 02:50:20 -0500
X-MC-Unique: rLPrRNVoNcuDulW6kM6uLA-1
X-Mimecast-MFC-AGG-ID: rLPrRNVoNcuDulW6kM6uLA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C9A7195609F;
	Wed,  1 Jan 2025 07:50:19 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D3CF83000197;
	Wed,  1 Jan 2025 07:50:17 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
Date: Wed,  1 Jan 2025 02:49:56 -0500
Message-ID: <20250101074959.412696-11-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-1-pbonzini@redhat.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX architecture introduces the concept of private GPA vs shared GPA,
depending on the GPA.SHARED bit. The TDX module maintains a single Secure
EPT (S-EPT or SEPT) tree per TD to translate TD's private memory accessed
using a private GPA. Wrap the SEAMCALL TDH.MEM.PAGE.REMOVE with
tdh_mem_page_remove() and TDH_PHYMEM_PAGE_WBINVD with
tdh_phymem_page_wbinvd_hkid() to unmap a TD private page from the SEPT,
remove the TD private page from the TDX module and flush cache lines to
memory after removal of the private page.

Callers should specify "GPA" and "level" when calling tdh_mem_page_remove()
to indicate to the TDX module which TD private page to unmap and remove.

TDH.MEM.PAGE.REMOVE may fail, and the caller of tdh_mem_page_remove() can
check the function return value and retrieve extended error information
from the function output parameters. Follow the TLB tracking protocol
before calling tdh_mem_page_remove() to remove a TD private page to avoid
SEAMCALL failure.

After removing a TD's private page, the TDX module does not write back and
invalidate cache lines associated with the page and the page's keyID (i.e.,
the TD's guest keyID). Therefore, provide tdh_phymem_page_wbinvd_hkid() to
allow the caller to pass in the TD's guest keyID and invoke
TDH_PHYMEM_PAGE_WBINVD to perform this action.

Before reusing the page, the host kernel needs to map the page with keyID 0
and invoke movdir64b() to convert the TD private page to a normal shared
page.

TDH.MEM.PAGE.REMOVE and TDH_PHYMEM_PAGE_WBINVD may meet contentions inside
the TDX module for TDX's internal resources. To avoid staying in SEAM mode
for too long, TDX module will return a BUSY error code to the kernel
instead of spinning on the locks. The caller may need to handle this error
in specific ways (e.g., retry). The wrappers return the SEAMCALL error code
directly to the caller. Don't attempt to handle it in the core kernel.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073658.22157-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f0b7b7b7d506..74938f725481 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -157,8 +157,10 @@ u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *tdr);
+u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
+u64 tdh_phymem_page_wbinvd_hkid(u64 hpa, u64 hkid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7e6f30d0a14..cde55e9b3280 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1761,6 +1761,23 @@ u64 tdh_mem_track(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_track);
 
+u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_remove);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
 	struct tdx_module_args args = {
@@ -1780,3 +1797,13 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
+
+u64 tdh_phymem_page_wbinvd_hkid(u64 hpa, u64 hkid)
+{
+	struct tdx_module_args args = {};
+
+	args.rcx = hpa | (hkid << boot_cpu_data.x86_phys_bits);
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4b0ad536afd9..d49cdd9b0577 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -33,6 +33,7 @@
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_VP_RD			26
 #define TDH_PHYMEM_PAGE_RECLAIM		28
+#define TDH_MEM_PAGE_REMOVE		29
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
-- 
2.43.5



