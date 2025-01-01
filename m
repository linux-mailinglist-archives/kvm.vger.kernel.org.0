Return-Path: <kvm+bounces-34438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 438169FF34B
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58FBA3A1A23
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0C115C14B;
	Wed,  1 Jan 2025 07:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYQIG0gt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2341A186607
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716670; cv=none; b=qePYi8mYfPEc5M4KZCtNP26m9S5oPAVhopL6UDTA9702Kg/7hpLdynFhfyfoSwkDHcXu64ilj3yei3Bd3ocke5VBTLqbiA/rdsbBUmXXmEXX4dVYgNth4MpqGUrQ4rCuRtOec0xtKeUfC0DySUncUBx9EqGnHMZWY3a/x6yPdV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716670; c=relaxed/simple;
	bh=kjt4jDA18JRGY65iculE0es/LYGSj9jJ1W4yuyfrbhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j1c94aSMTTxvt1T7yBKEA4qrZU3SyztbMbj2k0WFkIumkYVZiIrQCMk3S3nelLReJgHPUssl3M8G0vHvZn0tnksPIBFym6h+SIFC9OTrt5tUZGvYJe7dSFpFFtZW9aNkhpOdsiDg0dDHTbxt0JB5l/j/LZFCnYl0QBXCSx/0wWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYQIG0gt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBiaN5nKnEfniLaJyCSicv4T4oO5E4pGxaK0pKWBwug=;
	b=IYQIG0gtSbWuH1c/mHMTl+ugZdJ8oUy8KTJUq30b9hmF0m6xD81Q70DOEv6Ajy6C/0Eja+
	bdDwbSU+fhxW8iKi9oLneCQMz/0TWvzWcB43KdwQf3Ui/AZJEWdCWzIHegl9v1scrFbTEu
	KgAkxwcJcRKURIgKGrpffMLgOKYENkY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-ZvY_aS16OP2zQNgbqMldig-1; Wed,
 01 Jan 2025 02:31:03 -0500
X-MC-Unique: ZvY_aS16OP2zQNgbqMldig-1
X-Mimecast-MFC-AGG-ID: ZvY_aS16OP2zQNgbqMldig
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6126419560BE;
	Wed,  1 Jan 2025 07:31:02 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2FD4519560AA;
	Wed,  1 Jan 2025 07:31:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 08/11] x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
Date: Wed,  1 Jan 2025 02:30:44 -0500
Message-ID: <20250101073047.402099-9-pbonzini@redhat.com>
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
index 1710f983f23c..51784ad1ff31 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -129,8 +129,10 @@ struct tdx_vp {
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs);
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4f8b8be172f2..6db40f1d7a4f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1480,6 +1480,26 @@ u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = td->tdr,
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
@@ -1511,6 +1531,25 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = td->tdr,
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



