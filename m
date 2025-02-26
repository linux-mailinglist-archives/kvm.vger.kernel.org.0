Return-Path: <kvm+bounces-39370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84ACFA46B87
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AE7816CC13
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B88256C92;
	Wed, 26 Feb 2025 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DqlqGblx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6783325E464
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599752; cv=none; b=qaOcPN9Fv//c8Xyw7GNwTBInQzXSeTVt95pO0fOL8KvscfqCXxFWaYQOyIb4rn+pAGQ9HinOjB+DQBuCvDZn/bKnBMtAfP9M9d78cBV5mN1/nW1lAxjagJ4+FdMMnOcEyW3RKEmaHG50iNI6bNiVsQM12dII2x4Vnky96oFi1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599752; c=relaxed/simple;
	bh=SgOv0fw3vHtFfJ2YGZZ6UgQ2qqF9BvchJF3sQC8YzpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=thtibgxcf2rzWlZu3gdWG0MfrHvW7unOYBNzqhqNWrLiLZmNEmPMRM7dW8JmHnYUM0l/JNK0wmzxmZpmK6rvfQ1ZN3g6RMoHRE2LpvAfmSTOP9fLAeMtT4kG2xSFtZUCN8mLBKPgELNS1+x2aS/BBBjN4wBow9cn05b8qoLO9pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DqlqGblx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JHjkXoSefLFcMkYSnNMyUsdXOnSEL8i7jCTLIkwclzg=;
	b=DqlqGblxdStmz+mNBjT2bMOtDkVfuMEfFzcXjDGd+Zd4lUSgXWY1ikxbT3DfPonp8YhTIA
	CERCP0PeOL3eKT9ZSH0MkOE2Z4m8wRfLD+lSXzQtshP65trnuj3ByJFTToaXCmlfC8X4zQ
	XmHF68CU/RSSIFeN2TssZBnuDJLwCug=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-k_iTaRYMNJyuPloGVeYN8Q-1; Wed,
 26 Feb 2025 14:55:38 -0500
X-MC-Unique: k_iTaRYMNJyuPloGVeYN8Q-1
X-Mimecast-MFC-AGG-ID: k_iTaRYMNJyuPloGVeYN8Q_1740599736
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 142971800878;
	Wed, 26 Feb 2025 19:55:36 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C719D1944D02;
	Wed, 26 Feb 2025 19:55:34 +0000 (UTC)
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
Subject: [PATCH 03/29] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
Date: Wed, 26 Feb 2025 14:55:03 -0500
Message-ID: <20250226195529.2314580-4-pbonzini@redhat.com>
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

TDX module defines a TLB tracking protocol to make sure that no logical
processor holds any stale Secure EPT (S-EPT or SEPT) TLB translations for a
given TD private GPA range. After a successful TDH.MEM.RANGE.BLOCK,
TDH.MEM.TRACK, and kicking off all vCPUs, TDX module ensures that the
subsequent TDH.VP.ENTER on each vCPU will flush all stale TLB entries for
the specified GPA ranges in TDH.MEM.RANGE.BLOCK. Wrap the
TDH.MEM.RANGE.BLOCK with tdh_mem_range_block() and TDH.MEM.TRACK with
tdh_mem_track() to enable the kernel to assist the TDX module in TLB
tracking management.

The caller of tdh_mem_range_block() needs to specify "GPA" and "level" to
request the TDX module to block the subsequent creation of TLB translation
for a GPA range. This GPA range can correspond to a SEPT page or a TD
private page at any level.

Contentions and errors are possible with the SEAMCALL TDH.MEM.RANGE.BLOCK.
Therefore, the caller of tdh_mem_range_block() needs to check the function
return value and retrieve extended error info from the function output
params.

Upon TDH.MEM.RANGE.BLOCK success, no new TLB entries will be created for
the specified private GPA range, though the existing TLB translations may
still persist.  TDH.MEM.TRACK will then advance the TD's epoch counter to
ensure TDX module will flush TLBs in all vCPUs once the vCPUs re-enter
the TD. TDH.MEM.TRACK will fail to advance TD's epoch counter if there
are vCPUs still running in non-root mode at the previous TD epoch counter.
So to ensure private GPA translations are flushed, callers must first call
tdh_mem_range_block(), then tdh_mem_track(), and lastly send IPIs to kick
all the vCPUs and force them to re-enter, thus triggering the TLB flush.

Don't export a single operation and instead export functions that just
expose the block and track operations; this is for a couple reasons:

1. The vCPU kick should use KVM's functionality for doing this, which can better
target sending IPIs to only the minimum required pCPUs.

2. tdh_mem_track() doesn't need to be executed if a vCPU has not entered a TD,
which is information only KVM knows.

3. Leaving the operations separate will allow for batching many
tdh_mem_range_block() calls before a tdh_mem_track(). While this batching will
not be done initially by KVM, it demonstrates that keeping mem block and track
as separate operations is a generally good design.

Contentions are also possible in TDH.MEM.TRACK. For example, TDH.MEM.TRACK
may contend with TDH.VP.ENTER when advancing the TD epoch counter.
tdh_mem_track() does not provide the retries for the caller. Callers can
choose to avoid contentions or retry on their own.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073648.22143-1-yan.y.zhao@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9f978db2560f..cc050cc1367a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -169,6 +169,7 @@ u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
@@ -181,6 +182,7 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4ae10246260e..f920754bb35e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1599,6 +1599,23 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
 
+u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_range_block);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1761,6 +1778,16 @@ u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
 
+u64 tdh_mem_track(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+	};
+
+	return seamcall(TDH_MEM_TRACK, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mem_track);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 5879bdb0045f..104c97abf264 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 #define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
 #define TDH_MEM_PAGE_AUG		6
+#define TDH_MEM_RANGE_BLOCK		7
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
@@ -36,6 +37,7 @@
 #define TDH_SYS_RD			34
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
+#define TDH_MEM_TRACK			38
 #define TDH_PHYMEM_CACHE_WB		40
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
-- 
2.43.5



