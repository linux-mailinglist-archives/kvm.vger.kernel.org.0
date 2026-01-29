Return-Path: <kvm+bounces-69466-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHjpKzq1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69466-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A79BAA959
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B4BA43023013
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469CC320CB1;
	Thu, 29 Jan 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wv0RMrEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B67331A44
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649361; cv=none; b=jegLMfUfBtjj6OskDB0PXhYe21R8YD5Qk/D+g6/zFsLdV9Fv3nSMZm/gAoSeW1f0ZJy9Qm9lG63b4iTWDNdGcpSVZEAgHZtCzCq2MJHGa8dGaKPVotlcK+FSYfmVGVWoI9k1USkuiAliv9s3o9FHhegZVF9PThg9Qe6M2X1mDaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649361; c=relaxed/simple;
	bh=+qNafrKEDMrDmnSzhO+7B/CncJYata4dM8nSNluXeFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IbIdzgd3zZDfm6OZ971Au3vAjHInzzzW/eoZvw99qwJez6YlmQ8XJNYrY2td55yupfrtGyusAX7ku1+u4d2fDM3ssP1pFFMqMH5DL++ZxGj9I+yI50Aok9HrYAd/1KXQeEPr+zr8T4f+J73AQycUBwqYNIXRbY+EcKi2aOBFJos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wv0RMrEO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso828115a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649358; x=1770254158; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAsPNO0+ZutAYPgOffflP5U84vjSbbQ0NN/8afdydvg=;
        b=wv0RMrEOlMYU3OWc/M+iR+p8VFpTq/9WufSQnfKhOb5RDEPfXQuTHWdITYSW9L5z5n
         spiDHoMiHZFwkAPMk2fGYfIeJdTt6yBEjRoF6D/2B6vCrk1SnassJjAM2eavkR7dRqVK
         MQXrW0da3tw2iWlDb3t8IZ2Il03SkdzRSxxAVQy/ZSUsv8iqkiuypn/bM0yVIJYkqPsN
         sBRAFA4pRwwNpJA/gFcMbDZ195G6EPAJLe2/NwiHGP4XQ9zOkD8V4QsIIGW5RjpCAzi+
         kaZGcU1tR1jeooYVJln9Cnd3d2d0KrAybLioleE1Oz/yQd82BC3gZquD+Rv2T9V61cyg
         eVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649358; x=1770254158;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QAsPNO0+ZutAYPgOffflP5U84vjSbbQ0NN/8afdydvg=;
        b=QVnrzZji7hGOmsYMhzGE+V7k1rFqMCqtlmK7YczVR6P1t1xzfLUyn8AGkcn/L9Solj
         9pkMF5v2HG1nVs7gFkjc1y4u5KaBlQII7Wv6AZW9ZGlasD9RtoM8y1N8t7v1c86dxYYf
         2YNQ0xyfqLmlll3q0HN/J+t5iijBsSJR7yUrfmb1lOCXOSxLu3DziJGIDbFKAQKB8ExC
         fLhoZuIODxnZEA+zhJwl4vnj3BHt/AP/aUKCe6uJ8wbtpB0bZvJsCj4904cAGGYQE+2F
         vHoDNGzUt2Ex5Aw3DTWT4q7tE9b4N3CroDo/klNI8PSg2sWy0OaFS5D8P1vYlVWEsdXh
         mFoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWakksu6ZQs9hJym1d8yckvzTvPVetvC1B/0vqcgFPtPYBZQf3rT8eagJ4ZHnOVMzdqJgU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuh2/MWBFsJ3eyWkUTRe1UjJQ7e6cilQ4ABEeUPwB+s0Loc2P7
	8huVUjjwBEwRRg6w5yIpnIuDXzLCGMBR+PcEwG/3mcyRcM0kfyvRT9/T/qvQ7qnDu/0++uNLWip
	DErEH0g==
X-Received: from pjbbh4.prod.google.com ([2002:a17:90b:484:b0:34c:dd6d:b10e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5408:b0:34c:253d:581d
 with SMTP id 98e67ed59e1d1-353fece3407mr6693122a91.9.1769649358000; Wed, 28
 Jan 2026 17:15:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:48 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-17-seanjc@google.com>
Subject: [RFC PATCH v5 16/45] x86/virt/tdx: Add tdx_alloc/free_control_page() helpers
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69466-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9A79BAA959
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Add helpers to use when allocating or preparing pages that are gifted to
the TDX-Module for use as control/S-EPT pages, and thus need DPAMT backing.
Make them handle races internally for the case of multiple callers trying
operate on the same 2MB range simultaneously.

While the TDX initialization code in arch/x86 uses pages with 2MB
alignment, KVM will need to hand 4KB pages for it to use. Under DPAMT,
these pages will need DPAMT backing 4KB backing.

Add tdx_alloc_control_page() and tdx_free_control_page() to handle both
page allocation and DPAMT installation. Make them behave like normal
alloc/free functions where allocation can fail in the case of no memory,
but free (with any necessary DPAMT release) always succeeds. Do this so
they can support the existing TDX flows that require cleanups to succeed.
Also create tdx_pamt_put()/tdx_pamt_get() to handle installing DPAMT 4KB
backing for pages that are already allocated (such as external page tables,
or S-EPT pages).

Allocate the pages as GFP_KERNEL_ACCOUNT based on that the allocations
will be easily user triggerable.

Since the source of these pages is the page allocator, multiple TDs could
each get 4KB pages that are covered by the same 2MB range. When this
happens only one page pair needs to be installed to cover the 2MB range.
Similarly, when one page is freed, the DPAMT backing cannot be freed until
all TDX pages in the range are no longer in use. Have the helpers manage
these races internally.

So the requirements are that:

1. Free path cannot fail (i.e. no TDX module BUSY errors).
2. Allocation paths need to handle finding that DPAMT backing is already
   installed, and only return an error in the case of no memory, not in the
   case of losing races with other=E2=80=99s trying to operate on the same =
DPAMT
   range.
3. Free paths cannot fail, and also need to clean up the DPAMT backing
   when the last page in the 2MB range is no longer needed by TDX.

Previous changes allocated refcounts to be used to track how many 4KB
pages are in use by TDX for each 2MB region. So update those inside the
helpers and use them to decide when to actually install the DPAMT backing
pages.

tdx_pamt_put() needs to guarantee the DPAMT is installed before returning
so that racing threads don=E2=80=99t tell the TDX module to operate on the =
page
before it=E2=80=99s installed. Take a lock while adjusting the refcount and=
 doing
the actual TDH.PHYMEM.PAMT.ADD/REMOVE to make sure these happen
atomically. The lock is heavyweight, but will be optimized in future
changes. Just do the simple solution before any complex improvements.

TDH.PHYMEM.PAMT.ADD/REMOVE take exclusive locks at the granularity each
2MB range. A simultaneous attempt to operate on the same 2MB region would
result in a BUSY error code returned from the SEAMCALL. Since the
invocation of SEAMCALLs are behind a lock, this won=E2=80=99t conflict.

Besides the contention between TDH.PHYMEM.PAMT.ADD/REMOVE, many other
SEAMCALLs take the same 2MB granularity locks as shared. This means any
attempt to operate on the page by the TDX module while simultaneously
doing PAMT.ADD/REMOVE will result in a BUSY error. This should not happen,
as the PAMT pages always has to be installed before giving the pages to
the TDX module anyway.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  |  24 +++-
 arch/x86/virt/vmx/tdx/tdx.c | 264 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |   2 +
 3 files changed, 289 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 57d5f07e3735..fa29be18498c 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -16,6 +16,7 @@
=20
 #include <uapi/asm/mce.h>
 #include <asm/tdx_global_metadata.h>
+#include <linux/mm.h>
 #include <linux/pgtable.h>
=20
 /*
@@ -135,11 +136,32 @@ static inline bool tdx_supports_dynamic_pamt(const st=
ruct tdx_sys_info *sysinfo)
 	return false; /* To be enabled when kernel is ready */
 }
=20
+void tdx_quirk_reset_page(struct page *page);
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
=20
-void tdx_quirk_reset_page(struct page *page);
+struct page *__tdx_alloc_control_page(gfp_t gfp);
+void __tdx_free_control_page(struct page *page);
+
+static inline unsigned long tdx_alloc_control_page(gfp_t gfp)
+{
+	struct page *page =3D __tdx_alloc_control_page(gfp);
+
+	if (!page)
+		return 0;
+
+	return (unsigned long)page_address(page);
+}
+
+static inline void tdx_free_control_page(unsigned long addr)
+{
+	if (!addr)
+		return;
+
+	__tdx_free_control_page(virt_to_page(addr));
+}
=20
 struct tdx_td {
 	/* TD root structure: */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f6e80aba5895..682c8a228b53 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1824,6 +1824,50 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *da=
ta)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_mng_rd);
=20
+/* Number PAMT pages to be provided to TDX module per 2M region of PA */
+static int tdx_dpamt_entry_pages(void)
+{
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
+}
+
+/*
+ * For SEAMCALLs that pass a bundle of pages, the TDX spec treats the regi=
sters
+ * like an array, as they are ordered in the struct.  The effective array =
size
+ * is (obviously) limited by the number or registers, relative to the star=
ting
+ * register.  Fill the register array at a given starting register, with s=
anity
+ * checks to avoid overflowing the args structure.
+ */
+static void dpamt_copy_regs_array(struct tdx_module_args *args, void *reg,
+				  u64 *pamt_pa_array, bool copy_to_regs)
+{
+	int size =3D tdx_dpamt_entry_pages() * sizeof(*pamt_pa_array);
+
+	if (WARN_ON_ONCE(reg + size > (void *)args) + sizeof(*args))
+		return;
+
+	/* Copy PAMT page PA's to/from the struct per the TDX ABI. */
+	if (copy_to_regs)
+		memcpy(reg, pamt_pa_array, size);
+	else
+		memcpy(pamt_pa_array, reg, size);
+}
+
+#define dpamt_copy_from_regs(dst, args, reg)	\
+	dpamt_copy_regs_array(args, &(args)->reg, dst, false)
+
+#define dpamt_copy_to_regs(args, reg, src)	\
+	dpamt_copy_regs_array(args, &(args)->reg, src, true)
+
+/*
+ * When declaring PAMT arrays on the stack, use the maximum theoretical nu=
mber
+ * of entries that can be squeezed into a SEAMCALL, as stack allocations a=
re
+ * practically free, i.e. any wasted space is a non-issue.
+ */
+#define MAX_NR_DPAMT_ARGS (sizeof(struct tdx_module_args) / sizeof(u64))
+
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2=
)
 {
 	struct tdx_module_args args =3D {
@@ -2020,6 +2064,226 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct pa=
ge *page)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_hkid);
=20
+static int alloc_pamt_array(u64 *pa_array)
+{
+	struct page *page;
+	int i;
+
+	for (i =3D 0; i < tdx_dpamt_entry_pages(); i++) {
+		page =3D alloc_page(GFP_KERNEL_ACCOUNT);
+		if (!page)
+			goto err;
+		pa_array[i] =3D page_to_phys(page);
+	}
+
+	return 0;
+err:
+	/*
+	 * Zero the rest of the array to help with
+	 * freeing in error paths.
+	 */
+	for (; i < tdx_dpamt_entry_pages(); i++)
+		pa_array[i] =3D 0;
+	return -ENOMEM;
+}
+
+static void free_pamt_array(u64 *pa_array)
+{
+	for (int i =3D 0; i < tdx_dpamt_entry_pages(); i++) {
+		if (!pa_array[i])
+			break;
+
+		/*
+		 * Reset pages unconditionally to cover cases
+		 * where they were passed to the TDX module.
+		 */
+		tdx_quirk_reset_paddr(pa_array[i], PAGE_SIZE);
+
+		__free_page(phys_to_page(pa_array[i]));
+	}
+}
+
+/*
+ * Calculate the arg needed for operating on the DPAMT backing for
+ * a given 4KB page.
+ */
+static u64 pamt_2mb_arg(struct page *page)
+{
+	unsigned long hpa_2mb =3D ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
+
+	return hpa_2mb | TDX_PS_2M;
+}
+
+/*
+ * Add PAMT backing for the given page. Return's negative error code
+ * for kernel side error conditions (-ENOMEM) and 1 for TDX Module
+ * error. In the case of TDX module error, the return code is stored
+ * in tdx_err.
+ */
+static u64 tdh_phymem_pamt_add(struct page *page, u64 *pamt_pa_array)
+{
+	struct tdx_module_args args =3D {
+		.rcx =3D pamt_2mb_arg(page)
+	};
+
+	dpamt_copy_to_regs(&args, rdx, pamt_pa_array);
+
+	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
+}
+
+/* Remove PAMT backing for the given page. */
+static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
+{
+	struct tdx_module_args args =3D {
+		.rcx =3D pamt_2mb_arg(page),
+	};
+	u64 ret;
+
+	ret =3D seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args);
+	if (ret)
+		return ret;
+
+	dpamt_copy_from_regs(pamt_pa_array, &args, rdx);
+	return 0;
+}
+
+/* Serializes adding/removing PAMT memory */
+static DEFINE_SPINLOCK(pamt_lock);
+
+/* Bump PAMT refcount for the given page and allocate PAMT memory if neede=
d */
+static int tdx_pamt_get(struct page *page)
+{
+	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
+	atomic_t *pamt_refcount;
+	u64 tdx_status;
+	int ret;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	ret =3D alloc_pamt_array(pamt_pa_array);
+	if (ret)
+		goto out_free;
+
+	pamt_refcount =3D tdx_find_pamt_refcount(page_to_pfn(page));
+
+	scoped_guard(spinlock, &pamt_lock) {
+		/*
+		 * If the pamt page is already added (i.e. refcount >=3D 1),
+		 * then just increment the refcount.
+		 */
+		if (atomic_read(pamt_refcount)) {
+			atomic_inc(pamt_refcount);
+			goto out_free;
+		}
+
+		/* Try to add the pamt page and take the refcount 0->1. */
+		tdx_status =3D tdh_phymem_pamt_add(page, pamt_pa_array);
+		if (WARN_ON_ONCE(!IS_TDX_SUCCESS(tdx_status))) {
+			ret =3D -EIO;
+			goto out_free;
+		}
+
+		atomic_inc(pamt_refcount);
+	}
+
+	return 0;
+
+out_free:
+	/*
+	 * pamt_pa_array is populated or zeroed up to tdx_dpamt_entry_pages()
+	 * above. free_pamt_array() can handle either case.
+	 */
+	free_pamt_array(pamt_pa_array);
+	return ret;
+}
+
+/*
+ * Drop PAMT refcount for the given page and free PAMT memory if it is no
+ * longer needed.
+ */
+static void tdx_pamt_put(struct page *page)
+{
+	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
+	atomic_t *pamt_refcount;
+	u64 tdx_status;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	pamt_refcount =3D tdx_find_pamt_refcount(page_to_pfn(page));
+
+	scoped_guard(spinlock, &pamt_lock) {
+		/*
+		 * If the there are more than 1 references on the pamt page,
+		 * don't remove it yet. Just decrement the refcount.
+		 */
+		if (atomic_read(pamt_refcount) > 1) {
+			atomic_dec(pamt_refcount);
+			return;
+		}
+
+		/* Try to remove the pamt page and take the refcount 1->0. */
+		tdx_status =3D tdh_phymem_pamt_remove(page, pamt_pa_array);
+
+		/*
+		 * Don't free pamt_pa_array as it could hold garbage when
+		 * tdh_phymem_pamt_remove() fails.  Don't panic/BUG_ON(), as
+		 * there is no risk of data corruption, but do yell loudly as
+		 * failure indicates a kernel bug, memory is being leaked, and
+		 * the dangling PAMT entry may cause future operations to fail.
+		 */
+		if (WARN_ON_ONCE(!IS_TDX_SUCCESS(tdx_status)))
+			return;
+
+		atomic_dec(pamt_refcount);
+	}
+
+	/*
+	 * pamt_pa_array is populated up to tdx_dpamt_entry_pages() by the TDX
+	 * module with pages, or remains zero inited. free_pamt_array() can
+	 * handle either case. Just pass it unconditionally.
+	 */
+	free_pamt_array(pamt_pa_array);
+}
+
+/*
+ * Return a page that can be gifted to the TDX-Module for use as a "contro=
l"
+ * page, i.e. pages that are used for control and S-EPT structures for a g=
iven
+ * TDX guest, and bound to said guest's HKID and thus obtain TDX protectio=
ns,
+ * including PAMT tracking.
+ */
+struct page *__tdx_alloc_control_page(gfp_t gfp)
+{
+	struct page *page;
+
+	page =3D alloc_page(gfp);
+	if (!page)
+		return NULL;
+
+	if (tdx_pamt_get(page)) {
+		__free_page(page);
+		return NULL;
+	}
+
+	return page;
+}
+EXPORT_SYMBOL_FOR_KVM(__tdx_alloc_control_page);
+
+/*
+ * Free a page that was gifted to the TDX-Module for use as a control/S-EP=
T
+ * page. After this, the page is no longer protected by TDX.
+ */
+void __tdx_free_control_page(struct page *page)
+{
+	if (!page)
+		return;
+
+	tdx_pamt_put(page);
+	__free_page(page);
+}
+EXPORT_SYMBOL_FOR_KVM(__tdx_free_control_page);
+
 #ifdef CONFIG_KEXEC_CORE
 void tdx_cpu_flush_cache_for_kexec(void)
 {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..46c4214b79fb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,8 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_PHYMEM_PAMT_ADD		58
+#define TDH_PHYMEM_PAMT_REMOVE		59
=20
 /*
  * SEAMCALL leaf:
--=20
2.53.0.rc1.217.geba53bf80e-goog


