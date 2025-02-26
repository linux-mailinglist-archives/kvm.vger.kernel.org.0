Return-Path: <kvm+bounces-39365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B537FA46B7D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A6867A8A3C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06923256C66;
	Wed, 26 Feb 2025 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijpD4lXD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A82C2566EB
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599746; cv=none; b=NJQ+3FxOa/tHRisRztJcv0WeSRuKD+egKoJRP/7MDGFYean5cte4HFr5WIqHkWRZOVKZiNlejVFxs07GMzDfw8UkA1e3hbZYTKg8AYfu5penSJ7GSO3AQ0jtUmsdoAOTX1c0z5yOyxKG7kjm8X1f9DBPGlcxCkY2xFF90SdjosA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599746; c=relaxed/simple;
	bh=u/sdQab8lXWKkMan8BUKA5i227KDtYwYUiBcjZtQ8uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pY2ePcG5T2AIzGCVYvtgfrjilIemaBr5nKKU3UInC010AJd2CT2fZ0hsCaujtw98tm2JL+e2gCN3uJVu2h/coGwFA82slC89j956dxaWwPU6eN0Ftj+f1irVCTq8aBah84xqte7ktuS4GsgeUhNPbFEAKDgAZXxcTuaRPlmUHjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijpD4lXD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNiS9NTbnI64NJwk0LUGNPvpim6dJ6JJAvupdTT7DPg=;
	b=ijpD4lXDDO0mE9SFaX2W4E0jWXgxefPKas3JtUup2Oh1A+pze54UHqRit1xfoBAxmRGKfJ
	/Xcuk+dKInZht0v8f6rcCpUiYBy14+dx5iPF6EPQpRf9mmBdyw8zQWbfxRRCUAm78wobfk
	0DbpEOm+kwhR3tJJjGSq5uk1oBeJCGM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-JvjRQYaaNQaO1Q1icRShmQ-1; Wed,
 26 Feb 2025 14:55:39 -0500
X-MC-Unique: JvjRQYaaNQaO1Q1icRShmQ-1
X-Mimecast-MFC-AGG-ID: JvjRQYaaNQaO1Q1icRShmQ_1740599737
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A1B21903089;
	Wed, 26 Feb 2025 19:55:37 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A579196ADAB;
	Wed, 26 Feb 2025 19:55:36 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 04/29] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
Date: Wed, 26 Feb 2025 14:55:04 -0500
Message-ID: <20250226195529.2314580-5-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index cc050cc1367a..28d25d1bfa96 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -183,8 +183,10 @@ u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *tdr);
+u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f920754bb35e..ffa0f6b8254d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1788,6 +1788,23 @@ u64 tdh_mem_track(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_track);
 
+u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_remove);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
 	struct tdx_module_args args = {
@@ -1807,3 +1824,13 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
+
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
+{
+	struct tdx_module_args args = {};
+
+	args.rcx = mk_keyed_paddr(hkid, page);
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 104c97abf264..c9bea023f2b4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -32,6 +32,7 @@
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_VP_RD			26
 #define TDH_PHYMEM_PAGE_RECLAIM		28
+#define TDH_MEM_PAGE_REMOVE		29
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
-- 
2.43.5



