Return-Path: <kvm+bounces-39363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2903A46B79
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61AD0188BF61
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2C725A327;
	Wed, 26 Feb 2025 19:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8Y8Ib4L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B952571CD
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599742; cv=none; b=g5QeP6Yy1EyuOxVHDd9It2U0/rOMHnE0duMKL839T08ucfevJOMRUve2XBuolrVEZg3I38Adn8mLZL1po+6Ljesieffa2IYwwFwCcHBnjEi1fP0YexEJmPAcNvIbt97uxxoQ7rk6yJlwE7e/03AVhgSxhempWo0ve9MjCes4xzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599742; c=relaxed/simple;
	bh=sYx/6K5vDru02E+Mf4LrVmRr9RA+zqWpw7JOiH3Nn60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbHx6XKMyC40Ph6ebUz75XhIYXrwPNULHxE6D0yUx8WOBNOhxGKrXmc4fbVkmYPzrm4GrwLXG/glkwWfNFa5nskRTa0Thlsyq+GqLjhKaAcLvj9xTWyjoh4bmEBEvSHTbL7ls1fKxK5oAvkLlXnOcoY07MFEG5ZXku7lXzu2oUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X8Y8Ib4L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGMNYwK+DMBvIbrkBLbVZGsRhYd/8K9rSpyWxEelhqc=;
	b=X8Y8Ib4LlViuBMAlArpT7o4RoK+RN6gfFh2HxnCh8isUVKzaIQf2klyoVBNVGQaIrjkluY
	bFlJVkHYMbNKV0fOXYlz4t7fICBg8ZV967YdQa8angbBHcHn7wi1DPnY2x4vlwXiBNZ697
	xf13vTXM7uXxDQAujI1X8GIIbxdUvew=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-287-SC_vgo1MMGONY6MNiHRUsQ-1; Wed,
 26 Feb 2025 14:55:34 -0500
X-MC-Unique: SC_vgo1MMGONY6MNiHRUsQ-1
X-Mimecast-MFC-AGG-ID: SC_vgo1MMGONY6MNiHRUsQ_1740599733
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECF271800875;
	Wed, 26 Feb 2025 19:55:32 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 938561944D02;
	Wed, 26 Feb 2025 19:55:31 +0000 (UTC)
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
Subject: [PATCH 01/29] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
Date: Wed, 26 Feb 2025 14:55:01 -0500
Message-ID: <20250226195529.2314580-2-pbonzini@redhat.com>
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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  7 ++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7dd71ca3eb57..5c9bdf68002c 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -147,7 +147,6 @@ struct tdx_vp {
 	struct page **tdcx_pages;
 };
 
-
 static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
 {
 	u64 ret;
@@ -157,10 +156,16 @@ static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
 	ret |= (u64)hkid << boot_cpu_data.x86_phys_bits;
 
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
index 3a272e9ff2ca..506a75fbac0b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1529,6 +1529,25 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
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
index da384387d4eb..f3e37df4c63a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,6 +15,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
-- 
2.43.5



