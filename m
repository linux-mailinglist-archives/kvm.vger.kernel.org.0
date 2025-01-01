Return-Path: <kvm+bounces-34443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC2D9FF355
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AF24161614
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5171D13C682;
	Wed,  1 Jan 2025 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYvdtHw/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704426289
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717815; cv=none; b=QO4F1+LZicuYZBmP4XEHfh+RnBPQZyCqdSnO7/1wE4Xb3c8OHezCzuZGRBHRpAjxS9rU7wfMyQjW67gw5nwPaIZAQ/RNfFer+x5TK+wM5QiflWoOo5TeFWMHc3C6vKawD/xwbSUssN52OFK6emd9BLsmL2+RU8bKJUXOwQ+HuUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717815; c=relaxed/simple;
	bh=DBIDHG2g55wdDC0zmQ8wNOSdRYD55/Yiw2V5DnPbfYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lCE6rh7kN7EMnLlpwa1MzVO9z0xGrep0xtI7VJOQEKVmJSY1Gca6QORSbHsk0gWXPa+O6UePb32JL9LKPhBze2vzIAElFe9QQWcimo9Hh1m688eRPca5wVEz/9bdJagQx17fvf/QC9jyYPaICpHAlFeg/ACAnXqDycpuN88eMwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYvdtHw/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYhmVD51OGz1UiRdMdQtWmNM3cUplPyrwp/zCGC6t6c=;
	b=OYvdtHw/HqGk0skRQJcYzTlglmXEk0fkUEkOoN1uzfK9k9TAl0OqxLlpQo601jOzxGRS6k
	kaxmovXMthvz+m/sHU1N/aUVXWCHB4+eRp5L81cJsoJ4PYEc9fAedoMzNM2sCQBOZBE5y4
	H8G/GLWrMLW7oxN5CDVwi9yqOEpT/XM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-loUzmLCJOj6D7je7kL5K8A-1; Wed,
 01 Jan 2025 02:50:07 -0500
X-MC-Unique: loUzmLCJOj6D7je7kL5K8A-1
X-Mimecast-MFC-AGG-ID: loUzmLCJOj6D7je7kL5K8A
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F30DE19560A2;
	Wed,  1 Jan 2025 07:50:05 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4BD491956052;
	Wed,  1 Jan 2025 07:50:04 +0000 (UTC)
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
Subject: [PATCH 02/13] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
Date: Wed,  1 Jan 2025 02:49:48 -0500
Message-ID: <20250101074959.412696-3-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5045ab1c3d5b..425d282834e0 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -126,8 +126,11 @@ struct tdx_td {
 	struct page **tdcs_pages;
 };
 
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
+u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 55842d5b9474..c180551ecce3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1462,6 +1462,29 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_pfn(td->tdr_page) << PAGE_SHIFT;
 }
 
+/*
+ * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
+ * a CLFLUSH of pages is required before handing them to the TDX module.
+ * Be conservative and make the code simpler by doing the CLFLUSH
+ * unconditionally.
+ */
+static void tdx_clflush_page(struct page *tdr)
+{
+	clflush_cache_range(page_to_virt(tdr), PAGE_SIZE);
+}
+
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_pfn(tdcs_page) << PAGE_SHIFT,
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
 
+u64 tdh_mng_create(struct tdx_td *td, u64 hkid)
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



