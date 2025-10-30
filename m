Return-Path: <kvm+bounces-61488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9951BC20FE2
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBE0D462697
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB013655CE;
	Thu, 30 Oct 2025 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V6RI6+4t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6BE3644B5
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838939; cv=none; b=f2LR0vzpwUzVcgul18ZjLHfLXKIocfdIwUpqSgPkBwePOh/lerA4JOd7mSwj2NAJHx78+5lcpNOlZl9Qrcd1Z9Zuls3IorRZRJGTTd28V3B8X8Fu1lRyhSpK3sIAm16wBaFj4peoqtE57PGt/c1/1Gn+TgYxUEkuAF8nudv1LdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838939; c=relaxed/simple;
	bh=tPLSh1Nack6/mlsb5TvR5r4ty95ffd0oclqv3baf8GE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uNi3KifkNq7T8Hfp+wAk/nj3z0XTH2U3ZHI1o7i3krqDJGHW/47Xs8C/m0YjsFIwwEGzCdg8kGjJExSxGrVzK1bzUVUsOdIe+FjENsV3CDUyme593+nu/JcFg8I4p39UaGYb1Qm5/tRdWUEnHnqnkIlTYMWevax2hqVZIEfztVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V6RI6+4t; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34077439124so587358a91.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 08:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761838937; x=1762443737; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BjaQTDNF4EehAJHB3kVTHfbKWwrjG7+K6V2RXZBE+2E=;
        b=V6RI6+4tN1q+RE4u2l0k7qUYLW86m/p2TohuqjrUlC6sRs2BJiutsplqXgsey/e+/S
         yQwWx3zZASSC9M2H4DiNiY/zqDt6HJTxslpEoeURcofg9NnbEFGroppVzxR6Jp77lg+i
         C9eLoFz47Tur0Cl+KwnlhJSCI5omt5b4wquLfI0MBAmwO6KP+5zuMA1B/0z5MzN/JESC
         ZaFhKh+fMPjNAGmE3uvn0VfvmpBZ52rzwzxzKq+mrQ6AaJQPIw32WK69vAtV4Cew87GX
         ZKu/TDZM19cFOPHLxB2vESvKczktRRDv6Sl4UV/tzTVhflf7D2S71Bp4H2FsmZ9t+MoR
         eMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761838937; x=1762443737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BjaQTDNF4EehAJHB3kVTHfbKWwrjG7+K6V2RXZBE+2E=;
        b=tvwZ8mEU6YZjmZyT2/G8OVxxYIYgF0S9WhPGyhMjPS0/vWQUy/Ywp8bdH/habZ18Mp
         zncSQGfMl4tZqgQYzCyd1XVvrTIy5DhbWNT8S6UmSUu8O3+9gGH19X6931fNGCQlc+sI
         v1myzMNeJIgR4j4qkUv6ZBrRJvQbr+xbedYta6EeFARi+Ig+XkVV9rceHgStvLr4GHwL
         aWqrpF3le5fs3YaDkg71l7boEr/FhCQHpbgNVNhbsMCzxjXMr9XrFdG58vo4rPavTN8v
         Uw956FY+UZr+/2/+bWMB7dwnM/Ny/CLcWuW84Vjk45biDTV+VN9SBKlwhNrN5b9XZsgD
         VaMw==
X-Forwarded-Encrypted: i=1; AJvYcCVWr3HX++qA6hG9vIGmS5wGhTWgwo0mjTHnqxX/qeHzF3+huVrB4YQYLXSnBsAByyIF+64=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv2Zxs/2U6kB1BwN/FSffn5KWAG+p9oojjRXnYDDm6TMy6CpFW
	ngBhFuBOR4zocHwjWhd8Bd2KfOWIgxnxmHSiiayymptOMYxZvCrvbF95oOe+EhP2O9egVvmzPf3
	R7PB6qA==
X-Google-Smtp-Source: AGHT+IFWo9nXsfjT/jZ5tjtogOz47xLpqsmmNwGOrMge/M/YIN/rmVBmzYWsRiUIFgJbfI6t/6HD0fLSS8w=
X-Received: from pjtz19.prod.google.com ([2002:a17:90a:cb13:b0:33b:cf89:6fe6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2583:b0:33b:dbdc:65f2
 with SMTP id 98e67ed59e1d1-34083074799mr165119a91.22.1761838936708; Thu, 30
 Oct 2025 08:42:16 -0700 (PDT)
Date: Thu, 30 Oct 2025 08:42:14 -0700
In-Reply-To: <4f8c63f8-6b5f-40a2-bc7e-34c4ccd30593@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
 <aPY_yC45suT8sn8F@google.com> <872c17f3-9ded-46b2-a036-65fc2abaf2e6@intel.com>
 <aPZKVaUT9GZbPHBI@google.com> <4f8c63f8-6b5f-40a2-bc7e-34c4ccd30593@intel.com>
Message-ID: <aQOHVuiM51Fy064y@google.com>
Subject: Re: [PATCH] x86/virt/tdx: Use precalculated TDVPR page physical address
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Thomas Huth <thuth@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Dave Hansen wrote:
> On 10/20/25 07:42, Sean Christopherson wrote:
> ...
> > If some form of type safety is the goal, why not do something like this?
> > 
> >   typedef void __private *tdx_page_t;
> > 
> > Or maybe even define a new address space.
> > 
> >   # define __tdx __attribute__((noderef, address_space(__tdx)))
> 
> Sean,
> 
> I hacked up a TDX physical address namespace for sparse. It's not awful.
> It doesn't make the .c files any uglier (or prettier really). It
> definitely adds code because it needs a handful of conversion functions.
> But those are all one-liner functions.
> 
> Net, this approach seems to add a few conversion functions versus the
> 'struct page' approach. That's because there are at least a couple of
> places that *need* a 'struct page' like tdx_unpin().

tdx_unpin() is going away[*] in v6.19 (hopefully; I'll post the next version today).
In fact, that rework eliminates a handful of the helpers that are needed, and in
general can help clean things up.

[*] https://lore.kernel.org/all/20251017003244.186495-8-seanjc@google.com

> There's some wonkiness in this like using virtual addresses to back the
> "paddr" type. I did that so we could still do NULL checks instead of

I really, really, REALLY don't like the tdx_paddr_t nomenclature.  It's obviously
not a physical address, KVM uses "paddr" to track actual physical address (and
does so heavily in selftests), and I don't like that it drops the "page" aspect
of things, i.e. loses the detail that the TDX-Module _only_ works with 4KiB pages.

IMO, "tdx_page_t page" is a much better fit, as it's roughly analogous to
"struct page *page", and which should be a familiar pattern for readers and thus
more intuitive.

> keeping some explicit "invalid paddr" value. It's hidden in the helpers
> and not exposed to the users, but it is weird for sure. The important
> part isn't what the type is in the end, it's that something is making it
> opaque.
> 
> This can definitely be taken further like getting rid of
> tdx->vp.tdvpr_pa precalcuation. But it's mostly a straight s/struct page
> */tdx_paddr_t/ replacement.
> 
> I'm not looking at this and jumping up and down for how much better it
> makes the code. It certainly *can* find a few things by leveraging
> sparse. But, honestly, after seeing that nobody runs or cares about
> sparse on this code, it's hard to take it seriously.

Yeah, utilizing sparse can be difficult, because it's so noisy.  My tactic is to
rely on the bots to detect _new_ warnings, but for whateer reason that approach
didn't work for TDX, probably because so much code came in all at once.  In theory,
if we get the initial support right, then the bots will help keep things clean.

> Was this generally what you had in mind? Should I turn this into a real
> series?

More or less, ya.

> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 6b338d7f01b7d..644b53bcfdfed 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -37,6 +37,7 @@
>  #include <uapi/asm/mce.h>
>  #include <asm/tdx_global_metadata.h>
>  #include <linux/pgtable.h>
> +#include <linux/mm.h>
>  
>  /*
>   * Used by the #VE exception handler to gather the #VE exception
> @@ -154,15 +155,61 @@ int tdx_guest_keyid_alloc(void);
>  u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> -void tdx_quirk_reset_page(struct page *page);
> +struct tdx_paddr;

Maybe "struct tdx_module_page", to hint to readers that these pages are ultimately
used by the TDX-Module?  Not sure if that's better or worse than e.g. "struct tdx_page".

> +#if defined(__CHECKER__)
> +#define __tdx __attribute__((noderef, address_space(__tdx)))
> +#else
> +#define __tdx
> +#endif
> +typedef struct tdx_paddr __tdx * tdx_paddr_t;
> +
> +static inline tdx_paddr_t tdx_alloc_page(gfp_t gfp_flags)
> +{
> +	return (__force tdx_paddr_t)kmalloc(PAGE_SIZE, gfp_flags);

Is it worth going through alloc_page()?  I'm not entirely clear on whether there's
a meaningful difference in the allocator.  If so, this can be:

	struct page *page = alloc_page(gfp_flags);

	return (__force tdx_page_t)(page ? page_to_virt(page) : NULL);

> +}
> +
> +static inline void tdx_free_page(tdx_paddr_t paddr)
> +{
> +	kfree((__force void *)paddr);
> +}
> +
> +static inline phys_addr_t tdx_paddr_to_phys(tdx_paddr_t paddr)
> +{
> +	// tdx_paddr_t is actually a virtual address to kernel memory:
> +	return __pa((__force void *)paddr);

To eliminate a few of the open-coded __force, what if we add an equivalent to
rcu_dereference()?  That seems to work well with the tdx_page_t concept, e.g.

static inline tdx_page_t tdx_alloc_page(gfp_t gfp_flags)
{
	struct page *page = alloc_page(gfp_flags);

	return (__force tdx_page_t)(page ? page_to_virt(page) : NULL);
}

static inline struct tdx_module_page *tdx_page_dereference(tdx_page_t page)
{
	return (__force struct tdx_module_page *)page;
}

static inline void tdx_free_page(tdx_page_t page)
{
	free_page((unsigned long)tdx_page_dereference(page));
}

static inline phys_addr_t tdx_page_to_phys(tdx_page_t page)
{
	return __pa(tdx_page_dereference(page));
}

static inline tdx_page_t tdx_phys_to_page(phys_addr_t pa)
{
	return (__force tdx_page_t)phys_to_virt(pa);
}

> @@ -1872,13 +1872,13 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>  	 * The HKID assigned to this TD was already freed and cache was
>  	 * already flushed. We don't have to flush again.
>  	 */
> -	return tdx_reclaim_page(virt_to_page(private_spt));
> +	return tdx_reclaim_page(tdx_virt_to_paddr(private_spt));

Rather than cast, I vote to change kvm_mmu_page.external_spt to a tdx_page_t.
There's already a comment above the field calling out that its used by TDX, I
don't see any reason to add a layer of indirection there.  That helps eliminate
a helper or two.

	tdx_page_t external_spt;

>  }
>  
>  static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  					enum pg_level level, kvm_pfn_t pfn)
>  {
> -	struct page *page = pfn_to_page(pfn);
> +	tdx_paddr_t paddr = tdx_page_to_paddr(pfn_to_page(pfn));
>  	int ret;

Rather than do pfn_to_page() => tdx_page_to_paddr(), we can go straight to
tdx_phys_to_page() and avoid another helper or two.

And with the rework, it's gets even a bit more cleaner, because the KVM API takes
in a mirror_spte instead of a raw pfn.  Then KVM can have:

static tdx_page_t tdx_mirror_spte_to_page(u64 mirror_spte)
{
	return tdx_phys_to_page(spte_to_pfn(mirror_spte) << PAGE_SHIFT);
}

and this code becomes

static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
				     enum pg_level level, u64 mirror_spte)
{
	tdx_page_t page = tdx_mirror_spte_to_page(mirror_spte);

	...

Compile tested only on top of the rework, and I didn't check sparse yet.

---
 arch/x86/include/asm/kvm_host.h |  4 +-
 arch/x86/include/asm/tdx.h      | 65 +++++++++++++++++++++------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/vmx/tdx.c          | 80 +++++++++++++++++----------------
 arch/x86/virt/vmx/tdx/tdx.c     | 36 +++++++--------
 5 files changed, 114 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9f9839bbce13..9129108dc99c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1842,14 +1842,14 @@ struct kvm_x86_ops {
 
 	/* Update external mapping with page table link. */
 	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				void *external_spt);
+				 tdx_page_t external_spt);
 	/* Update the external page table from spte getting set. */
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 u64 mirror_spte);
 
 	/* Update external page tables for page table about to be freed. */
 	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				 void *external_spt);
+				 tdx_page_t external_spt);
 
 	/* Update external page table from spte getting removed, and flush TLB. */
 	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6b338d7f01b7..270018027a25 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -36,7 +36,9 @@
 
 #include <uapi/asm/mce.h>
 #include <asm/tdx_global_metadata.h>
+#include <linux/io.h>
 #include <linux/pgtable.h>
+#include <linux/mm.h>
 
 /*
  * Used by the #VE exception handler to gather the #VE exception
@@ -154,15 +156,50 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
-void tdx_quirk_reset_page(struct page *page);
+struct tdx_module_page;
+#if defined(__CHECKER__)
+#define __tdx __attribute__((noderef, address_space(__tdx)))
+#else
+#define __tdx
+#endif
+typedef struct tdx_module_page __tdx * tdx_page_t;
+
+static inline tdx_page_t tdx_alloc_page(gfp_t gfp_flags)
+{
+	struct page *page = alloc_page(gfp_flags);
+
+	return (__force tdx_page_t)(page ? page_to_virt(page) : NULL);
+}
+
+static inline struct tdx_module_page *tdx_page_dereference(tdx_page_t page)
+{
+	return (__force struct tdx_module_page *)page;
+}
+
+static inline void tdx_free_page(tdx_page_t page)
+{
+	free_page((unsigned long)tdx_page_dereference(page));
+}
+
+static inline phys_addr_t tdx_page_to_phys(tdx_page_t page)
+{
+	return __pa(tdx_page_dereference(page));
+}
+
+static inline tdx_page_t tdx_phys_to_page(phys_addr_t pa)
+{
+	return (__force tdx_page_t)phys_to_virt(pa);
+}
+
+void tdx_quirk_reset_page(tdx_page_t page);
 
 struct tdx_td {
 	/* TD root structure: */
-	struct page *tdr_page;
+	tdx_page_t tdr_page;
 
 	int tdcs_nr_pages;
 	/* TD control structure: */
-	struct page **tdcs_pages;
+	tdx_page_t *tdcs_pages;
 
 	/* Size of `tdcx_pages` in struct tdx_vp */
 	int tdcx_nr_pages;
@@ -170,19 +207,19 @@ struct tdx_td {
 
 struct tdx_vp {
 	/* TDVP root page */
-	struct page *tdvpr_page;
+	tdx_page_t tdvpr_page;
 	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
 	phys_addr_t tdvpr_pa;
 
 	/* TD vCPU control structure: */
-	struct page **tdcx_pages;
+	tdx_page_t *tdcx_pages;
 };
 
-static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
+static inline u64 mk_keyed_paddr(u16 hkid, tdx_page_t page)
 {
 	u64 ret;
 
-	ret = page_to_phys(page);
+	ret = tdx_page_to_phys(page);
 	/* KeyID bits are just above the physical address bits: */
 	ret |= (u64)hkid << boot_cpu_data.x86_phys_bits;
 
@@ -196,11 +233,11 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
 }
 
 u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
-u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
-u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
-u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
-u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mng_addcx(struct tdx_td *td, tdx_page_t tdcs_page);
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, tdx_page_t page, struct page *source, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, tdx_page_t page, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_vp_addcx(struct tdx_vp *vp, tdx_page_t tdcx_page);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, tdx_page_t page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
@@ -215,12 +252,12 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_phymem_page_reclaim(tdx_page_t page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, tdx_page_t page);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 73cdcbccc89e..144f46b93b5e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -110,7 +110,7 @@ struct kvm_mmu_page {
 		 * Page table page of external PT.
 		 * Passed to TDX module, not accessed by KVM.
 		 */
-		void *external_spt;
+		tdx_page_t external_spt;
 	};
 	union {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ae43974d033c..5a8a5d50b529 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -324,7 +324,7 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 })
 
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
-static int __tdx_reclaim_page(struct page *page)
+static int __tdx_reclaim_page(tdx_page_t page)
 {
 	u64 err, rcx, rdx, r8;
 
@@ -341,7 +341,7 @@ static int __tdx_reclaim_page(struct page *page)
 	return 0;
 }
 
-static int tdx_reclaim_page(struct page *page)
+static int tdx_reclaim_page(tdx_page_t page)
 {
 	int r;
 
@@ -357,7 +357,7 @@ static int tdx_reclaim_page(struct page *page)
  * private KeyID.  Assume the cache associated with the TDX private KeyID has
  * been flushed.
  */
-static void tdx_reclaim_control_page(struct page *ctrl_page)
+static void tdx_reclaim_control_page(tdx_page_t ctrl_page)
 {
 	/*
 	 * Leak the page if the kernel failed to reclaim the page.
@@ -366,7 +366,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
 	if (tdx_reclaim_page(ctrl_page))
 		return;
 
-	__free_page(ctrl_page);
+	tdx_free_page(ctrl_page);
 }
 
 struct tdx_flush_vp_arg {
@@ -603,7 +603,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 
 	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
 
-	__free_page(kvm_tdx->td.tdr_page);
+	tdx_free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 }
 
@@ -898,7 +898,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	}
 	if (tdx->vp.tdvpr_page) {
 		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
-		tdx->vp.tdvpr_page = 0;
+		tdx->vp.tdvpr_page = NULL;
 		tdx->vp.tdvpr_pa = 0;
 	}
 
@@ -1622,7 +1622,7 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 }
 
 static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-			    kvm_pfn_t pfn)
+			    tdx_page_t page)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err, entry, level_state;
@@ -1634,8 +1634,8 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 	    KVM_BUG_ON(!kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
-			       kvm_tdx->page_add_src, &entry, &level_state);
+	err = tdh_mem_page_add(&kvm_tdx->td, gpa, page, kvm_tdx->page_add_src,
+			       &entry, &level_state);
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
@@ -1646,11 +1646,10 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 }
 
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
-			    enum pg_level level, kvm_pfn_t pfn)
+			    enum pg_level level, tdx_page_t page)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	struct page *page = pfn_to_page(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 entry, level_state;
 	u64 err;
@@ -1665,11 +1664,16 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static tdx_page_t tdx_mirror_spte_to_page(u64 mirror_spte)
+{
+	return tdx_phys_to_page(spte_to_pfn(mirror_spte) << PAGE_SHIFT);
+}
+
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, u64 mirror_spte)
 {
+	tdx_page_t page = tdx_mirror_spte_to_page(mirror_spte);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
@@ -1691,21 +1695,20 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * the VM image via KVM_TDX_INIT_MEM_REGION; ADD the page to the TD.
 	 */
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
-		return tdx_mem_page_add(kvm, gfn, level, pfn);
+		return tdx_mem_page_add(kvm, gfn, level, page);
 
-	return tdx_mem_page_aug(kvm, gfn, level, pfn);
+	return tdx_mem_page_aug(kvm, gfn, level, page);
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, void *private_spt)
+				     enum pg_level level, tdx_page_t private_spt)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *page = virt_to_page(private_spt);
 	u64 err, entry, level_state;
 
-	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
-			       &level_state);
+	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level,
+			       private_spt, &entry, &level_state);
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
@@ -1762,7 +1765,7 @@ static void tdx_track(struct kvm *kvm)
 }
 
 static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, void *private_spt)
+				     enum pg_level level, tdx_page_t private_spt)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
@@ -1781,13 +1784,13 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * The HKID assigned to this TD was already freed and cache was
 	 * already flushed. We don't have to flush again.
 	 */
-	return tdx_reclaim_page(virt_to_page(private_spt));
+	return tdx_reclaim_page(private_spt);
 }
 
 static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 					 enum pg_level level, u64 mirror_spte)
 {
-	struct page *page = pfn_to_page(spte_to_pfn(mirror_spte));
+	tdx_page_t page = tdx_mirror_spte_to_page(mirror_spte);
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -2390,8 +2393,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages;
-	struct page **tdcs_pages = NULL;
-	struct page *tdr_page;
+	tdx_page_t *tdcs_pages = NULL;
+	tdx_page_t tdr_page;
 	int ret, i;
 	u64 err, rcx;
 
@@ -2409,7 +2412,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = tdx_alloc_page(GFP_KERNEL);
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2422,7 +2425,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = tdx_alloc_page(GFP_KERNEL);
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2541,7 +2544,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	/* Only free pages not yet added, so start at 'i' */
 	for (; i < kvm_tdx->td.tdcs_nr_pages; i++) {
 		if (tdcs_pages[i]) {
-			__free_page(tdcs_pages[i]);
+			tdx_free_page(tdcs_pages[i]);
 			tdcs_pages[i] = NULL;
 		}
 	}
@@ -2560,15 +2563,15 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 free_tdcs:
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
 		if (tdcs_pages[i])
-			__free_page(tdcs_pages[i]);
+			tdx_free_page(tdcs_pages[i]);
 	}
 	kfree(tdcs_pages);
 	kvm_tdx->td.tdcs_pages = NULL;
 
 free_tdr:
 	if (tdr_page)
-		__free_page(tdr_page);
-	kvm_tdx->td.tdr_page = 0;
+		tdx_free_page(tdr_page);
+	kvm_tdx->td.tdr_page = NULL;
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -2893,11 +2896,11 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	struct page *page;
+	tdx_page_t page;
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL);
+	page = tdx_alloc_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2907,7 +2910,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	 * entry via tdh_vp_enter(). Precalculate and store it instead
 	 * of doing it at runtime later.
 	 */
-	tdx->vp.tdvpr_pa = page_to_phys(tdx->vp.tdvpr_page);
+	tdx->vp.tdvpr_pa = tdx_page_to_phys(tdx->vp.tdvpr_page);
 
 	tdx->vp.tdcx_pages = kcalloc(kvm_tdx->td.tdcx_nr_pages, sizeof(*tdx->vp.tdcx_pages),
 			       	     GFP_KERNEL);
@@ -2917,7 +2920,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		page = alloc_page(GFP_KERNEL);
+		page = tdx_alloc_page(GFP_KERNEL);
 		if (!page) {
 			ret = -ENOMEM;
 			goto free_tdcx;
@@ -2939,7 +2942,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 			 * method, but the rest are freed here.
 			 */
 			for (; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-				__free_page(tdx->vp.tdcx_pages[i]);
+				tdx_free_page(tdx->vp.tdcx_pages[i]);
 				tdx->vp.tdcx_pages[i] = NULL;
 			}
 			return -EIO;
@@ -2957,7 +2960,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 free_tdcx:
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
 		if (tdx->vp.tdcx_pages[i])
-			__free_page(tdx->vp.tdcx_pages[i]);
+			tdx_free_page(tdx->vp.tdcx_pages[i]);
 		tdx->vp.tdcx_pages[i] = NULL;
 	}
 	kfree(tdx->vp.tdcx_pages);
@@ -2965,8 +2968,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 
 free_tdvpr:
 	if (tdx->vp.tdvpr_page)
-		__free_page(tdx->vp.tdvpr_page);
-	tdx->vp.tdvpr_page = 0;
+		tdx_free_page(tdx->vp.tdvpr_page);
+	tdx->vp.tdvpr_page = NULL;
 	tdx->vp.tdvpr_pa = 0;
 
 	return ret;
@@ -3004,7 +3007,8 @@ static int tdx_vcpu_get_cpuid_leaf(struct kvm_vcpu *vcpu, u32 leaf, int *entry_i
 
 static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
-	struct kvm_cpuid2 __user *output, *td_cpuid;
+	struct kvm_cpuid2 __user *output;
+	struct kvm_cpuid2 *td_cpuid;
 	int r = 0, i = 0, leaf;
 	u32 level;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eac403248462..1429dbe4da85 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -658,9 +658,9 @@ static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 	mb();
 }
 
-void tdx_quirk_reset_page(struct page *page)
+void tdx_quirk_reset_page(tdx_page_t page)
 {
-	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
+	tdx_quirk_reset_paddr(tdx_page_to_phys(page), PAGE_SIZE);
 }
 EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
 
@@ -1501,7 +1501,7 @@ EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
 static inline u64 tdx_tdr_pa(struct tdx_td *td)
 {
-	return page_to_phys(td->tdr_page);
+	return tdx_page_to_phys(td->tdr_page);
 }
 
 /*
@@ -1510,9 +1510,9 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
  * Be conservative and make the code simpler by doing the CLFLUSH
  * unconditionally.
  */
-static void tdx_clflush_page(struct page *page)
+static void tdx_clflush_page(tdx_page_t page)
 {
-	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
+	clflush_cache_range(tdx_page_dereference(page), PAGE_SIZE);
 }
 
 noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
@@ -1523,10 +1523,10 @@ noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_enter);
 
-u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
+u64 tdh_mng_addcx(struct tdx_td *td, tdx_page_t tdcs_page)
 {
 	struct tdx_module_args args = {
-		.rcx = page_to_phys(tdcs_page),
+		.rcx = tdx_page_to_phys(tdcs_page),
 		.rdx = tdx_tdr_pa(td),
 	};
 
@@ -1535,12 +1535,12 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
-u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, tdx_page_t page, struct page *source, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
 		.rcx = gpa,
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = tdx_page_to_phys(page),
 		.r9 = page_to_phys(source),
 	};
 	u64 ret;
@@ -1555,12 +1555,12 @@ u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_add);
 
-u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, tdx_page_t page, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
 		.rcx = gpa | level,
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = tdx_page_to_phys(page),
 	};
 	u64 ret;
 
@@ -1574,10 +1574,10 @@ u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u
 }
 EXPORT_SYMBOL_GPL(tdh_mem_sept_add);
 
-u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
+u64 tdh_vp_addcx(struct tdx_vp *vp, tdx_page_t tdcx_page)
 {
 	struct tdx_module_args args = {
-		.rcx = page_to_phys(tdcx_page),
+		.rcx = tdx_page_to_phys(tdcx_page),
 		.rdx = vp->tdvpr_pa,
 	};
 
@@ -1586,12 +1586,12 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, tdx_page_t page, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
 		.rcx = gpa | level,
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = tdx_page_to_phys(page),
 	};
 	u64 ret;
 
@@ -1794,10 +1794,10 @@ EXPORT_SYMBOL_GPL(tdh_vp_init);
  * So despite the names, they must be interpted specially as described by the spec. Return
  * them only for error reporting purposes.
  */
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
+u64 tdh_phymem_page_reclaim(tdx_page_t page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
 {
 	struct tdx_module_args args = {
-		.rcx = page_to_phys(page),
+		.rcx = tdx_page_to_phys(page),
 	};
 	u64 ret;
 
@@ -1858,7 +1858,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
 
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, tdx_page_t page)
 {
 	struct tdx_module_args args = {};
 

base-commit: 0da566344bd6586a7c358ab4e19417748e7b0feb
--

