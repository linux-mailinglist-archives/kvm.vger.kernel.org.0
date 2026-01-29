Return-Path: <kvm+bounces-69481-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oPdmLpu3emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69481-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:27:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1837AABCB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3B1D308B575
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0444E36405A;
	Thu, 29 Jan 2026 01:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYewLBo8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127E134FF4C
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649387; cv=none; b=pq99chQTltz3EeL9Qg9PAoxo+iPIF82En3EWbAn60LnthB8HTJYYrEjZv8Z3coCpoujnIsUPdR9Zn4zEVBf1s8zo9+sC3jg6onhjysxqqwn8ukfIxF5f8qRrS2xEbi8O3WWdrTeWbtgC5CKkOf4IvMK9zCZOw3dp7w7KeU9NwcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649387; c=relaxed/simple;
	bh=w/nijrur6jKEFCzBZzrCq8D2hM1PQMnPJT4Mk6V/KUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ML+W/BzoHxPnTqBdnkEN/P+RbkP/yBoT8pttQZ17rtjLt88A8MT9HpHSR+/nJ//PGWvzO4M+Uc8qApBbhnCJGz0N/gYEnZdabSb44j6Z+tUveV90asK8El7sT5nSVaTwymGb8Pqk/WbNrerDQ+XWYwoXtXGH2ZyyRVOYXEWCUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYewLBo8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso427072a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649384; x=1770254184; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WpiUmsPu8uA5hilip45Z70pJh5rqhfxSEKqO7V+kAwg=;
        b=tYewLBo8XzGaATkK7wHfDeOSKsmQ7niTxv1tSAQNaRDcSCQ33p0V7Pr6QeQlXfxhyE
         xhuogJAXL5sz0hBv5uYzPFodLsYvs9eMHR1lvD/YjX944qqKFx7obE6f9XtAROrNhE01
         njwuLkt2N8jfFewUGKoucgeLoeONJThzLT9WIpXaJ2ALnInFtCgt2VX8EIzUVKnjqxJF
         fHE6RYUP3PIX1+ay93Z/E42PdyVwURHOg3zxqONRojgyOOX8l4O4iCdYEqFFy/P7PYHh
         rIa31KghUMTFPKeZAP3aQ9fZX5Wf2c8d7JgugnAV2I/0GeEPC8qYUTdJD4fuN7xY1l+M
         c2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649384; x=1770254184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpiUmsPu8uA5hilip45Z70pJh5rqhfxSEKqO7V+kAwg=;
        b=W0ZeX0yWtQHf7AMgfojHmslW9z/pd9F/XS0zDWISLkIzFVf1PqKsQViKmsC8alPgMK
         FwaUYtNUeUOo0Q4fep/q2T3iqSJNxOvzAZ/tDOeab87gXXzjWQiC6fMrenedWvoI0Vg9
         J9Ia+5n4zagkIZHVwusbdwDOGunuk1NpbR8UPS/Ouh8nnsb9VjpvN5YYHzauxPnagrac
         U9wqky7hTsakSVg83SBTrD9yn62paus9BW2zSZToUbFPCZYALSCk12E2I4bT2zbx2tem
         efBDbEt8+4RYhMLRVsHNaXY5Y309SeRJyVm1jikyhonYCzYN1Cs7c55qwFe4Xe4xqwMF
         uRFA==
X-Forwarded-Encrypted: i=1; AJvYcCUdhKkKZphsWn6FmASsBCIElUu29OyIg8+hJd2lTgoPs9jZ5+luN3Z+Y8nAHSiEx/DrKRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpqTFzGh/Zt+KK4tBrn9gqQzTCFyO6TCSo4EtLzcs50+aF/KBi
	fBDyhHy+rQsGt58RQlGEzRBb/WZlf2eEo1AxonkQXrZJz6v7lBo5q67MNR/6EheNBaBDc+YQ10V
	2FbB8Xw==
X-Received: from pjbbo7.prod.google.com ([2002:a17:90b:907:b0:34a:b143:87d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c2:b0:352:dbcc:d74c
 with SMTP id 98e67ed59e1d1-35429a8deb5mr979193a91.15.1769649384396; Wed, 28
 Jan 2026 17:16:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:02 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-31-seanjc@google.com>
Subject: [RFC PATCH v5 30/45] x86/virt/tdx: Add API to demote a 2MB mapping to
 512 4KB mappings
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69481-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B1837AABCB
X-Rspamd-Action: no action

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce SEAMCALL wrapper tdh_mem_page_demote() to invoke
TDH_MEM_PAGE_DEMOTE, which splits a 2MB or a 1GB mapping in S-EPT into
512 4KB or 2MB mappings respectively.  TDH_MEM_PAGE_DEMOTE walks the
S-EPT to locate the huge entry/mapping to split, and replaces the huge
entry with a new S-EPT page table containing the equivalent 512 smaller
mappings.

Parameters "gpa" and "level" specify the huge mapping to split, and
parameter "new_sept_page" specifies the 4KB page to be added as the S-EPT
page. Invoke tdx_clflush_page() before adding the new S-EPT page
conservatively to prevent dirty cache lines from writing back later and
corrupting TD memory.

tdh_mem_page_demote() may fail, e.g., due to S-EPT walk error. Callers must
check function return value and can retrieve the extended error info from
the output parameters "ext_err1", and "ext_err2".

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs return a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller may
need to handle this error in specific ways (e.g., retry). Therefore, return
the SEAMCALL error code directly to the caller without attempting to handle
it in the core kernel.

Enable tdh_mem_page_demote() only on TDX modules that support feature
TDX_FEATURES0.ENHANCE_DEMOTE_INTERRUPTIBILITY, which does not return error
TDX_INTERRUPTED_RESTARTABLE on basic TDX (i.e., without TD partition) [2].

This is because error TDX_INTERRUPTED_RESTARTABLE is difficult to handle.
The TDX module provides no guaranteed maximum retry count to ensure forward
progress of the demotion. Interrupt storms could then result in a DoS if
host simply retries endlessly for TDX_INTERRUPTED_RESTARTABLE. Disabling
interrupts before invoking the SEAMCALL also doesn't work because NMIs can
also trigger TDX_INTERRUPTED_RESTARTABLE. Therefore, the tradeoff for basic
TDX is to disable the TDX_INTERRUPTED_RESTARTABLE error given the
reasonable execution time for demotion. [1]

Allocate (or dequeue from the cache) PAMT pages when Dynamic PAMT is
enabled, as TDH.MEM.PAGE.DEMOTE takes a DPAMT page pair in R12 and R13, to
store physical memory metadata for the 2MB guest private memory (after a
successful split).  Take care to use seamcall_saved_ret() to handle
registers above R11.

Free the Dynamic PAMT pages after SEAMCALL TDH_MEM_PAGE_DEMOTE fails since
the guest private memory is still mapped at 2MB level.

Link: https://lore.kernel.org/kvm/99f5585d759328db973403be0713f68e492b492a.camel@intel.com [1]
Link: https://lore.kernel.org/all/fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com [2]
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: squash all demote support into a single patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  |  9 +++++++
 arch/x86/virt/vmx/tdx/tdx.c | 54 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 64 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 50feea01b066..483441de7fe0 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -15,6 +15,7 @@
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
 #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
+#define TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY	BIT_ULL(51)
 
 #ifndef __ASSEMBLER__
 
@@ -140,6 +141,11 @@ static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 	return sysinfo->features.tdx_features0 & TDX_FEATURES0_DYNAMIC_PAMT;
 }
 
+static inline bool tdx_supports_demote_nointerrupt(const struct tdx_sys_info *sysinfo)
+{
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY;
+}
+
 /* Simple structure for pre-allocating Dynamic PAMT pages outside of locks. */
 struct tdx_pamt_cache {
 	struct list_head page_list;
@@ -240,6 +246,9 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, enum pg_level level, u64 pfn,
+			struct page *new_sp, struct tdx_pamt_cache *pamt_cache,
+			u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index cff325fdec79..823ec092b4e4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1841,6 +1841,9 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_mng_rd);
 
+static int alloc_pamt_array(u64 *pa_array, struct tdx_pamt_cache *cache);
+static void free_pamt_array(u64 *pa_array);
+
 /* Number PAMT pages to be provided to TDX module per 2M region of PA */
 static int tdx_dpamt_entry_pages(void)
 {
@@ -1885,6 +1888,57 @@ static void dpamt_copy_regs_array(struct tdx_module_args *args, void *reg,
  */
 #define MAX_NR_DPAMT_ARGS (sizeof(struct tdx_module_args) / sizeof(u64))
 
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, enum pg_level level, u64 pfn,
+			struct page *new_sp, struct tdx_pamt_cache *pamt_cache,
+			u64 *ext_err1, u64 *ext_err2)
+{
+	bool dpamt = tdx_supports_dynamic_pamt(&tdx_sysinfo) && level == PG_LEVEL_2M;
+	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
+	struct tdx_module_args args = {
+		.rcx = gpa | pg_level_to_tdx_sept_level(level),
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(new_sp),
+	};
+	u64 ret;
+
+	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
+		return TDX_SW_ERROR;
+
+	if (dpamt) {
+		if (alloc_pamt_array(pamt_pa_array, pamt_cache))
+			return TDX_SW_ERROR;
+
+		dpamt_copy_to_regs(&args, r12, pamt_pa_array);
+	}
+
+	/* Flush the new S-EPT page to be added */
+	tdx_clflush_page(new_sp);
+
+	ret = seamcall_saved_ret(TDH_MEM_PAGE_DEMOTE, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	if (dpamt) {
+		if (ret) {
+			free_pamt_array(pamt_pa_array);
+		} else {
+			/*
+			 * Set the PAMT refcount for the guest private memory,
+			 * i.e. for the hugepage that was just demoted to 512
+			 * smaller pages.
+			 */
+			atomic_t *pamt_refcount;
+
+			pamt_refcount = tdx_find_pamt_refcount(pfn);
+			WARN_ON_ONCE(atomic_cmpxchg_release(pamt_refcount, 0,
+							    PTRS_PER_PMD));
+		}
+	}
+	return ret;
+}
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_page_demote);
+
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 096c78a1d438..a6c0fa53ece9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -24,6 +24,7 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
+#define TDH_MEM_PAGE_DEMOTE		15
 #define TDH_MR_EXTEND			16
 #define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
-- 
2.53.0.rc1.217.geba53bf80e-goog


