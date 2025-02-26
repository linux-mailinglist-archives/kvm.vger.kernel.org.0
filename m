Return-Path: <kvm+bounces-39364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CDB5A46B7A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2369A16B883
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C2725B692;
	Wed, 26 Feb 2025 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbW7gwp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AE725A320
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599745; cv=none; b=XeZuM6WpTibkXOa0JyoPxf9r41G1QyF8Tgyl2cTVed4T5/LyCohLVM1rDgJEXkGLJ895UUBd0XEDN9zfHWIVOI9UBgDsSa2+yClPOp59/UeSOUsNBzjE6aRMmuby827pqMcmo1b0ZgbexCkOg9L7j8qyOyoXrCNjvPWRh/6O09g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599745; c=relaxed/simple;
	bh=IbNbJszvUGVVZtYAdISc6Z9mXYMEZwAPM9i5/O82g2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5qyYJc96xCzrTimvc2bZOJMYUyHp52kLACtbaMaO9EW6AEGHztCmKUpihSMHg1QNKOJaM4aW6SNyT/VrSPlw9gB7UlyaZPMxfmNvrIAcjuezWP7FuFNl6PzSePdhWcOu26E+tdQtAUHjgvdnnVHX3bh6fNCdaapkZcQYVeJv/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VbW7gwp7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TB1VFAvS7oUVC+j7J7lR5YPE1WZnSPUBC9SnonylGF4=;
	b=VbW7gwp7KJDFbnvq0dE7Gjdd8VWala2lJAH10tc1c0jZMqgV2VlxFzpsZVytoxnBDQ5kVp
	gfyR8W7V8Wsy2Zh9jLE5XN6YGC7DbY8VBSt2r6qbgt0ARdJ+OZ2BCzNKN+1p2l4KqxIAfY
	w6EXbMpLATShjsiwEelZ9PNAEqvR6qU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-xp5hir62NXKGbVx6Xe1Zdg-1; Wed,
 26 Feb 2025 14:55:36 -0500
X-MC-Unique: xp5hir62NXKGbVx6Xe1Zdg-1
X-Mimecast-MFC-AGG-ID: xp5hir62NXKGbVx6Xe1Zdg_1740599734
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 902B21800873;
	Wed, 26 Feb 2025 19:55:34 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2EC981944D02;
	Wed, 26 Feb 2025 19:55:33 +0000 (UTC)
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
Subject: [PATCH 02/29] x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
Date: Wed, 26 Feb 2025 14:55:02 -0500
Message-ID: <20250226195529.2314580-3-pbonzini@redhat.com>
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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5c9bdf68002c..9f978db2560f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -165,8 +165,10 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
 }
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 506a75fbac0b..4ae10246260e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1529,6 +1529,26 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(page),
+		.r9 = page_to_phys(source),
+	};
+	u64 ret;
+
+	tdx_clflush_page(page);
+	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_add);
+
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
@@ -1560,6 +1580,25 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(page),
+	};
+	u64 ret;
+
+	tdx_clflush_page(page);
+	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index f3e37df4c63a..5879bdb0045f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,8 +15,10 @@
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



