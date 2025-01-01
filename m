Return-Path: <kvm+bounces-34448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8D39FF363
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA22D3A1F5F
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E3A18D65E;
	Wed,  1 Jan 2025 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpkiSGjY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAB8187FE4
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717823; cv=none; b=W98HciY4nxgAfhee/Gza/dv2X6seyeAqx/Q2NojPNX/XRO6BGQLxFjMet8aaZGeIyH3B9UdTWsDmgLQt3EFJiUpbmBJMlx44rxyI1fi657BsVRDh5uqid7OrMMqMLkiQROWHy78eRVisvRO3veuOcJggwABk2HfMWw9YpNf/15w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717823; c=relaxed/simple;
	bh=1ZPyBfzyUmFexaPMZL0UVprdU4lScQAP9N4PL6Ml3R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3aqBC6JENR0zhYj2Lzqv6jTxz84Ky1/pdi7BXszW+Vy8ciWZxkATGi1knvd8i5bB6QANv11iT616L5n5V/cAEGB5hIBA6RrfxT2q4KSwBbQl67nojy5jHuAdDsVwpPei9WAKGZeYkSkTcYi90qbd+MCfoMYYKz1tJ40IinBBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpkiSGjY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=igDYhWLTpaFcU9whlv3PV9tOX18fJcXw0tzfiBk1oAg=;
	b=bpkiSGjYTWk0btR3gVFKI3yxjHAD3IigSfqAS9LAJjmC8HYQ3usDGvl1Dv1SfcRC4g34F+
	1VQvPSEKBkp2r7MHhTT2Lvb9rqy3AkOhpD2RS0bZ3hWvQbH5qkZe6Cfblr2uAjor2ultvF
	9aSsMpZPkGdvqCfioVvWn8YcBxf8sOo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-LzW7OLKqMryBgcXydkPVhQ-1; Wed,
 01 Jan 2025 02:50:17 -0500
X-MC-Unique: LzW7OLKqMryBgcXydkPVhQ-1
X-Mimecast-MFC-AGG-ID: LzW7OLKqMryBgcXydkPVhQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 814DD19560BE;
	Wed,  1 Jan 2025 07:50:15 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F4CC1956052;
	Wed,  1 Jan 2025 07:50:14 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
Date: Wed,  1 Jan 2025 02:49:54 -0500
Message-ID: <20250101074959.412696-9-pbonzini@redhat.com>
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
(S-EPT or SEPT) tree per TD to translate TD's private memory accessed
using a private GPA. Wrap the SEAMCALL TDH.MEM.PAGE.ADD with
tdh_mem_page_add() and TDH.MEM.PAGE.AUG with tdh_mem_page_aug() to add TD
private pages and map them to the TD's private GPAs in the SEPT.

Callers of tdh_mem_page_add() and tdh_mem_page_aug() allocate and provide
normal pages to the wrappers, who further pass those pages to the TDX
module. Before passing the pages to the TDX module, tdh_mem_page_add() and
tdh_mem_page_aug() perform a CLFLUSH on the page mapped with keyID 0 to
ensure that any dirty cache lines don't write back later and clobber TD
memory or control structures. Don't worry about the other MK-TME keyIDs
because the kernel doesn't use them. The TDX docs specify that this flush
is not needed unless the TDX module exposes the CLFLUSH_BEFORE_ALLOC
feature bit. Do the CLFLUSH unconditionally for two reasons: make the
solution simpler by having a single path that can handle both
!CLFLUSH_BEFORE_ALLOC and CLFLUSH_BEFORE_ALLOC cases. Avoid wading into any
correctness uncertainty by going with a conservative solution to start.

Call tdh_mem_page_add() to add a private page to a TD during the TD's build
time (i.e., before TDH.MR.FINALIZE). Specify which GPA the 4K private page
will map to. No need to specify level info since TDH.MEM.PAGE.ADD only adds
pages at 4K level. To provide initial contents to TD, provide an additional
source page residing in memory managed by the host kernel itself (encrypted
with a shared keyID). The TDX module will copy the initial contents from
the source page in shared memory into the private page after mapping the
page in the SEPT to the specified private GPA. The TDX module allows the
source page to be the same page as the private page to be added. In that
case, the TDX module converts and encrypts the source page as a TD private
page.

Call tdh_mem_page_aug() to add a private page to a TD during the TD's
runtime (i.e., after TDH.MR.FINALIZE). TDH.MEM.PAGE.AUG supports adding
huge pages. Specify which GPA the private page will map to, along with
level info embedded in the lower bits of the GPA. The TDX module will
recognize the added page as the TD's private page after the TD's acceptance
with TDCALL TDG.MEM.PAGE.ACCEPT.

tdh_mem_page_add() and tdh_mem_page_aug() may fail. Callers can check
function return value and retrieve extended error info from the function
output parameters.

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs returns a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller
may need to handle this error in specific ways (e.g., retry). Therefore,
return the SEAMCALL error code directly to the caller. Don't attempt to
handle it in the core kernel.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073636.22129-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9e0c60a41d5d..32f3981d56c5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -138,8 +138,10 @@ struct tdx_vp {
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a97a470dda23..f39197d4eafc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1491,6 +1491,26 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = hpa,
+		.r9 = source,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_add);
+
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
 {
 	struct tdx_module_args args = {
@@ -1522,6 +1542,25 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = hpa,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 308d3aa565d7..80e6ef006085 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,8 +16,10 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_MEM_PAGE_ADD		2
 #define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
+#define TDH_MEM_PAGE_AUG		6
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
-- 
2.43.5



