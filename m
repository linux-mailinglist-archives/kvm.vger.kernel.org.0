Return-Path: <kvm+bounces-34449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF389FF362
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D5491882804
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7542E13FEE;
	Wed,  1 Jan 2025 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F3So+y/G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA66E18801A
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717823; cv=none; b=YMXkpBG82U/fewWxiNHrMb1Sj6vxm7AIWy1a9tNEBWILZD7CahnN7nVF0vsXbPHQDZ032EAWhoI/9N0lXAk9J+nRe/Py6/R3eHIFG1MOtBWeqw44cDfrmLRmfrPMhnEojdAPyAzZwvkehJP+cUB6eIOjBDExyfPpEIe7RekqJm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717823; c=relaxed/simple;
	bh=IPRDT60qYeyjDg6kEX/RmTx1JqrskVeSNd53jNg0n44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rhYSMMy8XnrOGg+Gp5mUBLclqIdsgNqIvdef27xwW3ipnStLYrWmCmwtrGcE6tV/ojf4vnuWp9mbHjuVbW83iWdWcpKHG8WlvN1Wv2B2GtIMGALAoAWPclx0sU6lnTr/RqJPeMRN5SMwXxEBwEF9a7VJNak+jFL4fWBrE8tOnew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F3So+y/G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BPjnA6vlxzb0DFpx8G/MY6zj56w63CF0wD1xrW9DDwg=;
	b=F3So+y/G+Wv8dUeeAvJYTnNMUdI3WqkcWGzs0bMuYrvt5kr4BLqgC7nuDNTZ1KC12qdyqZ
	bVdu4JYT2UXwkU/v5hWynsQduwVpg7WundH0B1uY2vUvcSNNsz5G/yqYzIK38uj4j0yzKJ
	JadHokDOiEe6T4wxTrNg4XCkMMqwyfA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-_pB1zOTENtC2ARoJwiB5xQ-1; Wed,
 01 Jan 2025 02:50:15 -0500
X-MC-Unique: _pB1zOTENtC2ARoJwiB5xQ-1
X-Mimecast-MFC-AGG-ID: _pB1zOTENtC2ARoJwiB5xQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A2211956095;
	Wed,  1 Jan 2025 07:50:14 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC7FF1956052;
	Wed,  1 Jan 2025 07:50:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
Date: Wed,  1 Jan 2025 02:49:53 -0500
Message-ID: <20250101074959.412696-8-pbonzini@redhat.com>
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
index 8fc1836c5d09..9e0c60a41d5d 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -138,6 +138,7 @@ struct tdx_vp {
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 986b58b63121..a97a470dda23 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1491,6 +1491,25 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
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



