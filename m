Return-Path: <kvm+bounces-34436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7EC9FF349
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE51E3A2E9A
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D85B189916;
	Wed,  1 Jan 2025 07:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaZIkhLP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596DB1684A4
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716668; cv=none; b=CMFqI/wtT80qb2N/HBCbjXTc/EAA3246F4gjxufJmE7SeQM3gyaXTX4ru5TlZQ55agdgj8kayvkER04pPTXT0LrdhrtYFypID3BWUwcWEZZOXt6sO8rN0Mr+UEG5MK45g1fv1XHG75jrL18befnlUxMIQwvo5vga8blp/O3e0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716668; c=relaxed/simple;
	bh=SjtG/4kMXa7OZbe95TuaJbNKSWikdVBCO++lCDYwx9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UqE0FkeMOqFs1WhGgZM9gXwg8SSpvvz3MOQP21laNEBCEFimxDPXGNuZS7IBUDC7znNwb7tcS/V/LajQ1VCTYfwGcfxNFDDoNaojEMZvaMd/I8cp9/AMIltLqkTnlnv8aST+17XRkONTZGQx6V/LBJta5WbL19yI0BorKuk9jUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AaZIkhLP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTKbHffS/zlI2X/N8jLjkTgSPNo4fUrIBOHOaKV0tco=;
	b=AaZIkhLPFgoXMTZqZNTp/Ncw6J/Ti2lzM9j4KdKb0fAed6reeJjwq6IZW+3HMM9rla0Fin
	nvSLdA59d7Mx1WDKZKad6HybVWGnrRoGUgSc78MdKFfgDnw5qi30raovnHBuJY72Zwhcb6
	2IeVxsFzReRBOJKjhVBK7oRKSbTgHcc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-J6OrR2QbPRWcbh-tRYo8XQ-1; Wed,
 01 Jan 2025 02:31:02 -0500
X-MC-Unique: J6OrR2QbPRWcbh-tRYo8XQ-1
X-Mimecast-MFC-AGG-ID: J6OrR2QbPRWcbh-tRYo8XQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F196519560AE;
	Wed,  1 Jan 2025 07:31:00 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF46419560AD;
	Wed,  1 Jan 2025 07:30:59 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 07/11] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
Date: Wed,  1 Jan 2025 02:30:43 -0500
Message-ID: <20250101073047.402099-8-pbonzini@redhat.com>
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
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5c6752765074..1710f983f23c 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -129,6 +129,7 @@ struct tdx_vp {
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs);
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 78719830cfef..4f8b8be172f2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1480,6 +1480,25 @@ u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = td->tdr,
+		.r8 = hpa,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_sept_add);
+
 u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx)
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



