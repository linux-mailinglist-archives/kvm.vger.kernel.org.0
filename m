Return-Path: <kvm+bounces-35565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA3FA12843
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D5293A8A2D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666A71ACEC4;
	Wed, 15 Jan 2025 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZftukMM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA12166F1B
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957370; cv=none; b=em9G7GeOdaV6wg2rX14mNh58H0V/7ie2c+IbxlGOy5PS+YfodvzoYgcuAqPnQaYtZMcAa1ioF+Ng+EhHjN1N+1NGZGjMK0pOZYvKZm3yO04FAPI/KaOcDbsWY/eKNxQV5ZH9PWF4PvxwltFDKzvdKeda9FSPEx+oLXuL+T92yt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957370; c=relaxed/simple;
	bh=f0vqu9hxWyD0iW/DCj8b796SvEJLKcz/PbNqE54edjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddREnBKq+hjhV/sQIbOKukh6CDTUbobD8UBvTcZtdCPRsnQXLab1QGjuVZh60Q1PXJn0r0xGlaGxH/vm2gr/oaQAbF/EY9BwRfHPC2lOhG7VYmHfEXDiYjPNXPFL7AHGP7WGbihtTsf6PqyYPoavdIQZ4iaIfObJfqo8aVsO+Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QZftukMM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736957366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7l5sK31vDvCf9op+U02sdsQmtsjctlyeq/TsXPvieM=;
	b=QZftukMMywZTtvhPRceBsQPFmj2Svf+bAj3kgnki/Dq5qDvRggzaKIT1ScS0gK2uEI9rmb
	hgqTeMDxIhA6VnTgEIsUZo6sFpKMKf9eJ923V55iWeBu2OxlAtPYEjWi/32hDrzz8GHPTP
	BLGrf+IZdF8tR6tlFHAeN6EaBDUlKWQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-v4aDe_aDNF--RgDMD1wcOw-1; Wed,
 15 Jan 2025 11:09:20 -0500
X-MC-Unique: v4aDe_aDNF--RgDMD1wcOw-1
X-Mimecast-MFC-AGG-ID: v4aDe_aDNF--RgDMD1wcOw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 765D11955F79;
	Wed, 15 Jan 2025 16:09:18 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 101D430001BE;
	Wed, 15 Jan 2025 16:09:16 +0000 (UTC)
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
Subject: [PATCH v3 02/14] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
Date: Wed, 15 Jan 2025 11:09:00 -0500
Message-ID: <20250115160912.617654-3-pbonzini@redhat.com>
In-Reply-To: <20250115160912.617654-1-pbonzini@redhat.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

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

For SEAMCALLs that give a page to the TDX module to be encrypted, CLFLUSH
the page mapped with KeyID 0, such that any dirty cache lines don't write
back later and clobber TD memory or control structures. Don't worry about
the other MK-TME KeyIDs because the kernel doesn't use them. The TDX docs
specify that this flush is not needed unless the TDX module exposes the
CLFLUSH_BEFORE_ALLOC feature bit. Be conservative and always flush. Add a
helper function to facilitate this.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-ID: <20241203010317.827803-3-rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5045ab1c3d5b..131356bed6f5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -126,8 +126,11 @@ struct tdx_td {
 	struct page **tdcs_pages;
 };
 
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
+u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1ffbdb840004..ce4b1e96c5b0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1462,6 +1462,29 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_phys(td->tdr_page);
 }
 
+/*
+ * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
+ * a CLFLUSH of pages is required before handing them to the TDX module.
+ * Be conservative and make the code simpler by doing the CLFLUSH
+ * unconditionally.
+ */
+static void tdx_clflush_page(struct page *page)
+{
+	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
+}
+
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_phys(tdcs_page),
+		.rdx = tdx_tdr_pa(td),
+	};
+
+	tdx_clflush_page(tdcs_page);
+	return seamcall(TDH_MNG_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1472,6 +1495,18 @@ u64 tdh_mng_key_config(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_config);
 
+u64 tdh_mng_create(struct tdx_td *td, u16 hkid)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+		.rdx = hkid,
+	};
+
+	tdx_clflush_page(td->tdr_page);
+	return seamcall(TDH_MNG_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_create);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1481,3 +1516,19 @@ u64 tdh_mng_key_freeid(struct tdx_td *td)
 	return seamcall(TDH_MNG_KEY_FREEID, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
+
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+		.rdx = td_params,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_INIT, &args);
+
+	*extended_err = args.rcx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mng_init);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 5579317f67ab..0861c3f09576 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,8 +15,11 @@
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
2.43.5



