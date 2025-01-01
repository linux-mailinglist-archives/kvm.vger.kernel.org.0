Return-Path: <kvm+bounces-34433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C42F9FF33D
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D91B1881091
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1D02941C;
	Wed,  1 Jan 2025 07:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wt/hjQFX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0627DA9C
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716663; cv=none; b=DYU/Vb+Uk24tNyfNrJhwWUvL58ebPUcvRagWaLYyJbAdaq2IoT8ZIfu0UH+gccAil4ql495I25aaLoI9nAgsFMZvX8Ofv14Uc8NHTNZpbvZHcTmBjdeprJL/LGsNcltGrCISrW0oO5FDJPpxBchkYt9DZstJz5yfu3NcSCbtx5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716663; c=relaxed/simple;
	bh=YV3tlLFJ4d22wUQuTug01QmpMmRCqKok41083jdSNM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q70w/YOShu2emOrEZaHhc+BXBzf28q1v/sA0ryWXO8KGK+1JGWh0cz2ZLbWj8MetfQ8HbvEVfjupSrM1sBdODkRrJaaj0MYRi1tovGDFT8t5zh3dVuvW19592Xpi649Wlqoh1fyD5TMEo0d3z0YKkZy3KYsyYAdqKj8JjkcAZ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wt/hjQFX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XQbHJxV7k4sRDWNZ0VjaUU3W5oIqLBh70bQ8m/JpyM=;
	b=Wt/hjQFXbyJaqSqHq18K+O8UJ0Q42v1O7PiNvuPyTBeUvjtB9EFjQGF8QmAjpzLWegfOR3
	MIfrV0XVCTTEYwOH8ZLjFf2nr6QYIyB2OrVSYVtvjq6GA8HZqpHuYSkgVkFUKBLy7DHyOE
	u32dX1LO5D9XF0w0bEzP2tAw6yss77Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-NcHBqrTfOK2SsqJKK4mfwg-1; Wed,
 01 Jan 2025 02:30:57 -0500
X-MC-Unique: NcHBqrTfOK2SsqJKK4mfwg-1
X-Mimecast-MFC-AGG-ID: NcHBqrTfOK2SsqJKK4mfwg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DFA8195608F;
	Wed,  1 Jan 2025 07:30:56 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9517119560AA;
	Wed,  1 Jan 2025 07:30:54 +0000 (UTC)
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
Subject: [PATCH 04/11] x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
Date: Wed,  1 Jan 2025 02:30:40 -0500
Message-ID: <20250101073047.402099-5-pbonzini@redhat.com>
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
Message-ID: <20241115202028.1585487-5-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 1249796d3578..063b6e0b1899 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -137,6 +137,9 @@ u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
+u64 tdh_phymem_page_reclaim(hpa_t page, u64 *page_type, u64 *page_owner, u64 *page_size);
+u64 tdh_phymem_cache_wb(bool resume);
+u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9111dab5a05b..dd2cf3c87db1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1575,3 +1575,40 @@ u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init_apicid);
+
+u64 tdh_phymem_page_reclaim(hpa_t page, u64 *page_type, u64 *page_owner, u64 *page_size)
+{
+	struct tdx_module_args args = {
+		.rcx = page,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
+
+	*page_type = args.rcx;
+	*page_owner = args.rdx;
+	*page_size = args.r8;
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
+	args.rcx = td->tdr | ((u64)tdx_global_keyid << boot_cpu_data.x86_phys_bits);
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



