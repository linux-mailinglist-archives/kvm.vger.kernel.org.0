Return-Path: <kvm+bounces-35568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18637A1284A
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A67D3A8CE8
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999AB1D5ACD;
	Wed, 15 Jan 2025 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/4gJoP/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29B1A8F61
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957373; cv=none; b=YA3OGT8SLWEAs8mmq+EFU9/6bRpIIz+rULM11rMK7sLhZCcgf1af/iVQdtnkibXujo8ZQ8/FlwFVrml+RjZ/Y0sk1qCVDYU5ULFhzY5iBq28mm242Xsvy8+Zn2U3l9G33LOPsJAifDhFiuXxTvC3/Wz3XBMtHlzZOGY/7zC/GNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957373; c=relaxed/simple;
	bh=h1UttIEC386EP1mIPiIQo5HxmuVVcTY1+JhNV7VMiXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ou5snpxf3gM2cTbJC717bwO+4wy0IF0I+gjQd/C4Bge/QoqKGE7ks8OOisqY7kzS+JZpaKZVXx/G/Kayo6yNXU8vXDn1NJ3UqpjS+3X5dNTNezExm2c0F1PnyDkMY0H5HPulWY3tvvtoMcOzxkHK1CGSLNkItI+Fpt1mE4aCI5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S/4gJoP/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736957369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+rWN8wW5HmFcP/0LsBDIhnB7Fn0K8Q9xiLc7Myko4k=;
	b=S/4gJoP/jfr12e5b5oDllywMYxHidsaw8CF6+wIkUkCCzc570cM848ApUbdfjkmFbbqvCB
	urg6UvcoIMnhU1wVJa6f+FQ+2Epx0AE+oJlhyLKbLpYMpM8riUkKaZUe9XRF0vpH3FFjpn
	RyV+Xw4tcAhwz2z85NBjAaGUo6U40Ys=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-7IIiT96VO8yaYz81MpKLnA-1; Wed,
 15 Jan 2025 11:09:28 -0500
X-MC-Unique: 7IIiT96VO8yaYz81MpKLnA-1
X-Mimecast-MFC-AGG-ID: 7IIiT96VO8yaYz81MpKLnA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 867B7195605F;
	Wed, 15 Jan 2025 16:09:26 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57CAC3003FD1;
	Wed, 15 Jan 2025 16:09:25 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 07/14] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
Date: Wed, 15 Jan 2025 11:09:05 -0500
Message-ID: <20250115160912.617654-8-pbonzini@redhat.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX architecture introduces the concept of private GPA vs shared GPA,
depending on the GPA.SHARED bit. The TDX module maintains a Secure EPT
(S-EPT or SEPT) tree per TD for private GPA to HPA translation. Wrap the
TDH.MEM.SEPT.ADD SEAMCALL with tdh_mem_sept_add() to provide pages to the
TDX module for building a TD's SEPT tree. (Refer to these pages as SEPT
pages).

Callers need to allocate and provide a normal page to tdh_mem_sept_add(),
which then passes the page to the TDX module via the SEAMCALL
TDH.MEM.SEPT.ADD. The TDX module then installs the page into SEPT tree and
encrypts this SEPT page with the TD's guest keyID. The kernel cannot use
the SEPT page until after reclaiming it via TDH.MEM.SEPT.REMOVE or
TDH.PHYMEM.PAGE.RECLAIM.

Before passing the page to the TDX module, tdh_mem_sept_add() performs a
CLFLUSH on the page mapped with keyID 0 to ensure that any dirty cache
lines don't write back later and clobber TD memory or control structures.
Don't worry about the other MK-TME keyIDs because the kernel doesn't use
them. The TDX docs specify that this flush is not needed unless the TDX
module exposes the CLFLUSH_BEFORE_ALLOC feature bit. Do the CLFLUSH
unconditionally for two reasons: make the solution simpler by having a
single path that can handle both !CLFLUSH_BEFORE_ALLOC and
CLFLUSH_BEFORE_ALLOC cases. Avoid wading into any correctness uncertainty
by going with a conservative solution to start.

Callers should specify "GPA" and "level" for the TDX module to install the
SEPT page at the specified position in the SEPT. Do not include the root
page level in "level" since TDH.MEM.SEPT.ADD can only add non-root pages to
the SEPT. Ensure "level" is between 1 and 3 for a 4-level SEPT or between 1
and 4 for a 5-level SEPT.

Call tdh_mem_sept_add() during the TD's build time or during the TD's
runtime. Check for errors from the function return value and retrieve
extended error info from the function output parameters.

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs returns a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller
may need to handle this error in specific ways (e.g., retry). Therefore,
return the SEAMCALL error code directly to the caller. Don't attempt to
handle it in the core kernel.

TDH.MEM.SEPT.ADD effectively manages two internal resources of the TDX
module: it installs page table pages in the SEPT tree and also updates the
TDX module's page metadata (PAMT). Don't add a wrapper for the matching
SEAMCALL for removing a SEPT page (TDH.MEM.SEPT.REMOVE) because KVM, as the
only in-kernel user, will only tear down the SEPT tree when the TD is being
torn down. When this happens it can just do other operations that reclaim
the SEPT pages for the host kernels to use, update the PAMT and let the
SEPT get trashed.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073624.22114-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  7 ++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 1d84cf8e2abe..1be640718692 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -137,7 +137,6 @@ struct tdx_vp {
 	struct page **tdcx_pages;
 };
 
-
 static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
 {
 	u64 ret;
@@ -147,10 +146,16 @@ static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
 	ret |= hkid << boot_cpu_data.x86_phys_bits;
 	
 	return ret;
+}
 
+static inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+        WARN_ON_ONCE(level == PG_LEVEL_NONE);
+        return level - 1;
 }
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 83fc01bfd55d..77f9c9c2514c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1491,6 +1491,25 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(page),
+	};
+	u64 ret;
+
+	tdx_clflush_page(page);
+	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_sept_add);
+
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 62cb7832c42d..308d3aa565d7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,6 +16,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
-- 
2.43.5



