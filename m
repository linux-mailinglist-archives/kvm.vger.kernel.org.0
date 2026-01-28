Return-Path: <kvm+bounces-69423-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIKuHZeSemlC8AEAu9opvQ
	(envelope-from <kvm+bounces-69423-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:49:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1918BA9C14
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 015503032F57
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEF73446B1;
	Wed, 28 Jan 2026 22:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XG93ZnWk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4F724CEEA
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 22:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769640583; cv=none; b=pglsfo6eayCASVZNALjjCwxFkJOTdOdj4zRuqvMNhgyY7RyMSkXLJ/V+jJS3odbOEoqe9iKcefIIl4AeCf5bRJrrnqyUkMIIt08NmkEupUYmqAaFfJU51lXHMOO1KYvuwVqZL1AK3435mjoL5Tp0bEIgae3TwPrpGFt+rQPSskU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769640583; c=relaxed/simple;
	bh=JgAcLIui5SNk1HNnuaPY1saV4brsqp4/LmgmrbX1XQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e6EM3qE37yRkohDks59fegm8ZMFN4538pB3stxZOVofQgjGqx87nOnIyryKC987XSns2Qeyx59e1X9nUP3/n6HBM4RDzZk6YS1YKKC3Abz+goBxpnSvXjyqqyozErnHTMOPVtjzAsYr+rLEYKjVmDYePisXykQBo+1G9ODEsW/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XG93ZnWk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a773db3803so2725155ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 14:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769640581; x=1770245381; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0OatpOX27d21R9fnoRjtd+qwhlLEPdTsoYiGzPM5l84=;
        b=XG93ZnWk/nuNN0Q4YinAo5E6QfOcRQIGgziu2LO56lY9hvuNENbXES30ANcUd0WBxv
         kswGgLFtboRR7EQ/LMPK8Q+ZyGd2W8ant1tkIAsu4+/crBUfC/3yQdDq8XKdRSashbD2
         mPFgJx47LWeiKnTVPJOa9wBHxmXD51JWxa6L3s3MbzrWZQs2yPx+LCcb//+zr0OZNOMq
         PZf/lqxvHxUZRXqAhEloqfm8bjpsnn01PenflAjhqhYV1HfmtLnWJ5DIW+GSqnlpkUW/
         LY5+iQRbd4iKkXEQIgordXQjZf2rPurKkWpU/e5OPUjirAFlisg4JqJEFSNknnQLs6gr
         clzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769640581; x=1770245381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0OatpOX27d21R9fnoRjtd+qwhlLEPdTsoYiGzPM5l84=;
        b=o3pcfZsTavRZ1WzuD6h6i5LcKI5/3+7DZWsKzgTrJofdyZVDKPGnckBguL0VnsRx3d
         jNVuP8Dkegba70pfd7NiZe5DmEi+vjpSX0v6nKd/N8cBWjQeoETbmu4aNiFBvdCywbas
         tLZza4iVehfOZbKXwKOitMCChc7cIkZUv7Mht1yTbX3HkbMcDmaJJVfsGCbsYdxBcSHh
         Ig1x7w0lyj40ApCVEtS7L4GLURpoBZ1sAlM04Pfe3gCw6Ted25Wxg5BYEn76DAHIs6Yq
         ascGZI/GiCjZBvzS92oErthB0X1JnU7C/4QOeSe9vNPTBDvEKtWjtF4bnx/aIbE0TZZj
         qqeA==
X-Forwarded-Encrypted: i=1; AJvYcCX5hCuF/LX5KN6zBZfYYtNBEwZ0DZRoZsLXkOyNkIz04B/sEfFg63CxHaNYWuNILMNSwj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHZ3TPL6u+w0mtfQNOITE22VmL0sA0ZitAqK7SyQZfcx4EfNTK
	lOYceY+El36Aje9g2uxe6q7YTAXbJIEGmINh8Ffw2Fw4rl2787jOBuCT3m9PdZzdGFAOttPfMTN
	08CX2Hw==
X-Received: from pjbco6.prod.google.com ([2002:a17:90a:fe86:b0:352:f6a6:5a51])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a0e:b0:2a7:a9e4:babc
 with SMTP id d9443c01a7336-2a870e57ab8mr66687085ad.61.1769640580694; Wed, 28
 Jan 2026 14:49:40 -0800 (PST)
Date: Wed, 28 Jan 2026 14:49:39 -0800
In-Reply-To: <20260106101849.24889-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106101849.24889-1-yan.y.zhao@intel.com>
Message-ID: <aXqSg2nUSYJMbcXT@google.com>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69423-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[redhat.com,vger.kernel.org,kernel.org,intel.com,google.com,amd.com,suse.cz,suse.com,gmail.com,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[29];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 1918BA9C14
X-Rspamd-Action: no action

On Tue, Jan 06, 2026, Yan Zhao wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Introduce SEAMCALL wrapper tdh_mem_page_demote() to invoke
> TDH_MEM_PAGE_DEMOTE, which splits a 2MB or a 1GB mapping in S-EPT into
> 512 4KB or 2MB mappings respectively.
> 
> SEAMCALL TDH_MEM_PAGE_DEMOTE walks the S-EPT to locate the huge mapping to
> split and add a new S-EPT page to hold the 512 smaller mappings.
> 
> Parameters "gpa" and "level" specify the huge mapping to split, and
> parameter "new_sept_page" specifies the 4KB page to be added as the S-EPT
> page. Invoke tdx_clflush_page() before adding the new S-EPT page
> conservatively to prevent dirty cache lines from writing back later and
> corrupting TD memory.
> 
> tdh_mem_page_demote() may fail, e.g., due to S-EPT walk error. Callers must
> check function return value and can retrieve the extended error info from
> the output parameters "ext_err1", and "ext_err2".
> 
> The TDX module has many internal locks. To avoid staying in SEAM mode for
> too long, SEAMCALLs return a BUSY error code to the kernel instead of
> spinning on the locks. Depending on the specific SEAMCALL, the caller may
> need to handle this error in specific ways (e.g., retry). Therefore, return
> the SEAMCALL error code directly to the caller without attempting to handle
> it in the core kernel.
> 
> Enable tdh_mem_page_demote() only on TDX modules that support feature
> TDX_FEATURES0.ENHANCE_DEMOTE_INTERRUPTIBILITY, which does not return error
> TDX_INTERRUPTED_RESTARTABLE on basic TDX (i.e., without TD partition) [2].
> 
> This is because error TDX_INTERRUPTED_RESTARTABLE is difficult to handle.
> The TDX module provides no guaranteed maximum retry count to ensure forward
> progress of the demotion. Interrupt storms could then result in a DoS if
> host simply retries endlessly for TDX_INTERRUPTED_RESTARTABLE. Disabling
> interrupts before invoking the SEAMCALL also doesn't work because NMIs can
> also trigger TDX_INTERRUPTED_RESTARTABLE. Therefore, the tradeoff for basic
> TDX is to disable the TDX_INTERRUPTED_RESTARTABLE error given the
> reasonable execution time for demotion. [1]
> 
> Link: https://lore.kernel.org/kvm/99f5585d759328db973403be0713f68e492b492a.camel@intel.com [1]
> Link: https://lore.kernel.org/all/fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com [2]
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---

This is ridiculous.  The DEMOTE API is spread across three patches:

  Add SEAMCALL wrapper tdh_mem_page_demote()
  Add/Remove DPAMT pages for guest private memory to demote
  Pass guest memory's PFN info to demote for updating pamt_refcount

with significant changes between the "add wrapper" and when the API is actually
usable.  Even worse, it's wired up in KVM before it's finalized, and so those
changes mean touching KVM code.

And to top things off, "Add/Remove DPAMT pages for guest private memory to demote"
includes a non-trivial refactoring and code movement of MAX_TDX_ARG_SIZE() and
dpamt_args_array_ptr().

This borderline unreviewable.  It took me literally more than a day to wrap my
head around what actually needs to happen for DEMOTE, what patch was doing what,
at what point in the series DEMOTE actually became usable, etc.

I get that y'all are juggling multiple intertwined series, but spraying them all
at upstream without any apparent rhyme or reason does not work.  Figure out
priorities, pick an ordering, and make it happen.

In the end, this fits nicely into *one* patch, with significantly fewer lines
changed overall.

E.g.

---
 arch/x86/include/asm/tdx.h  |  9 ++++++
 arch/x86/virt/vmx/tdx/tdx.c | 58 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 68 insertions(+)

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
index 6a2871e83761..97016b3e26b8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1874,6 +1874,64 @@ static u64 *dpamt_args_array_ptr_r12(struct tdx_module_array_args *args)
 	return &args->args_array[TDX_ARG_INDEX(r12)];
 }
 
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, enum pg_level level, u64 pfn,
+			struct page *new_sp, struct tdx_pamt_cache *pamt_cache,
+			u64 *ext_err1, u64 *ext_err2)
+{
+	bool dpamt = tdx_supports_dynamic_pamt(&tdx_sysinfo) && level == PG_LEVEL_2M;
+	u64 guest_memory_pamt_page[MAX_TDX_ARGS(r12)];
+	struct tdx_module_array_args args = {
+		.args.rcx = gpa | pg_level_to_tdx_sept_level(level),
+		.args.rdx = tdx_tdr_pa(td),
+		.args.r8 = page_to_phys(new_sp),
+	};
+	u64 ret;
+
+	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
+		return TDX_SW_ERROR;
+
+	if (dpamt) {
+		u64 *args_array = dpamt_args_array_ptr_r12(&args);
+
+		if (alloc_pamt_array(guest_memory_pamt_page, pamt_cache))
+			return TDX_SW_ERROR;
+
+		/*
+		 * Copy PAMT page PAs of the guest memory into the struct per the
+		 * TDX ABI
+		 */
+		memcpy(args_array, guest_memory_pamt_page,
+		       tdx_dpamt_entry_pages() * sizeof(*args_array));
+	}
+
+	/* Flush the new S-EPT page to be added */
+	tdx_clflush_page(new_sp);
+
+	ret = seamcall_saved_ret(TDH_MEM_PAGE_DEMOTE, &args.args);
+
+	*ext_err1 = args.args.rcx;
+	*ext_err2 = args.args.rdx;
+
+	if (dpamt) {
+		if (ret) {
+			free_pamt_array(guest_memory_pamt_page);
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

base-commit: 0f969bc3e7a9aa441122ad51bc2ff220a200b88e
-- 


