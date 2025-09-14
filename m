Return-Path: <kvm+bounces-57500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D09BB56438
	for <lists+kvm@lfdr.de>; Sun, 14 Sep 2025 03:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B8D91A22D17
	for <lists+kvm@lfdr.de>; Sun, 14 Sep 2025 01:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB3E23B62B;
	Sun, 14 Sep 2025 01:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rm3eVyeW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D1A1FDE39
	for <kvm@vger.kernel.org>; Sun, 14 Sep 2025 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757815041; cv=none; b=dVfvnBZ4J8dJs3p3JSxC2gsYgkmIGYFZX6DTJQqrTKU8T+HPbkmgjHlKTI3rArWOuVUH6iHVORBFMDmXYUi5449MEkUrVZ5oMlgpm0jrmlbp5/TKJ7Sni472/KYr6k4XlI5LVPH+0UjXmWq3ZMv57QFmb04u2tWNDDE82mpoe98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757815041; c=relaxed/simple;
	bh=2bA54a8XQO3oplu+GpK3brlzTVegVik1P3OTH4QDtaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PTyLbGG75eXIW7u70JkZocPUNLT3Owootmtu5AgGwTCG1oieTHc70o+hbTGa5S0sKU5y92NapFKOdvHMLor+3dWiV+D3cX3JEl+WKeyfKNMNWAz7Flr1fF3iHmSRMkKTPbfnRp0BmsWYca0r8z6S126WLSCw3AtBiqke3WhXdyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rm3eVyeW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF2CC4CEF7
	for <kvm@vger.kernel.org>; Sun, 14 Sep 2025 01:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757815041;
	bh=2bA54a8XQO3oplu+GpK3brlzTVegVik1P3OTH4QDtaA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Rm3eVyeWLB90tjDfWg4cd/8Go+FYh4GNgJ1W6mCc90EgnEawb6rEmy85Gc2qk363q
	 7fkERHY/yaKy0MFH3jz6eGDHtw2DW40CUoz7fqxmKVJ8xERjRWA4kDe862vX/bj7G1
	 ynMp7dssLS3BO2so51EkIylPmSxKqIdytEiA3f9NihGSsLojIvukfGIYA126ZXvzZ4
	 gJ3guL1jlqUTzll1FgnsMcUn+aPikz9M5Cb0UOrVQVSzLHlZcquIewKvgz9Sgs9ZNk
	 rRMVUahfCoMFBLuf1UW3uEEdh/ClhwEMn/Y/179kr883A079sMr8yeCi8dtFmmGvYm
	 HHNUaACLchAxA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b079c13240eso501640966b.1
        for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 18:57:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU3qTubuFSuBdjx5WoPaRj/p+ObGhF5KRwU9Yar6sNq88HM8RD/qDaPeIU5+wrFm3U/tic=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0+GBCp8JVn1PA10MGZ+87ypqTImpgw3QkDq2qxQ7UbvW2g7S6
	Bx0Y3oair+E+hYe64inBaGFhV9PBh0C3Eq09sdIvEDt4wUjI5gsuA2VjufjDsRHPJvUiX/5UU2l
	FG+3La8UYAvNXOgX3WrRPFz1+OEOUrKw=
X-Google-Smtp-Source: AGHT+IFfNmQmnqGZYX0ngUS0c2d+ly5r+Z8sFAk/gU9hnaLKvZrHmV0tDaiOU94759FUb8SGhbBwfAAm52QYlnu9vvg=
X-Received: by 2002:a17:907:3e9f:b0:b04:a1ec:d06f with SMTP id
 a640c23a62f3a-b07c35bcc13mr854776466b.25.1757815039974; Sat, 13 Sep 2025
 18:57:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910071429.3925025-1-maobibo@loongson.cn>
In-Reply-To: <20250910071429.3925025-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 14 Sep 2025 09:57:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
X-Gm-Features: Ac12FXzfN2bNWTNhJRbB-SLTolLXMjAH5r5IpQVt22wgOskPBdaWpLkZgPjmVEs
Message-ID: <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix VM migration failure with PTW enabled
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Sep 10, 2025 at 3:14=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> With PTW disabled system, bit Dirty is HW bit for page writing, however
> with PTW enabled system, bit Write is HW bit for page writing. Previously
> bit Write is treated as SW bit to record page writable attribute for fast
> page fault handling in the secondary MMU, however with PTW enabled machin=
e,
> this bit is used by HW already.
>
> Here define KVM_PAGE_SOFT_WRITE with SW bit _PAGE_MODIFIED, so that it ca=
n
> work on both PTW disabled and enabled machines. And with HW write bit, bo=
th
> bit Dirty and Write is set or clear.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_mmu.h | 20 ++++++++++++++++----
>  arch/loongarch/kvm/mmu.c             |  8 ++++----
>  2 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/includ=
e/asm/kvm_mmu.h
> index 099bafc6f797..efcd593c42b1 100644
> --- a/arch/loongarch/include/asm/kvm_mmu.h
> +++ b/arch/loongarch/include/asm/kvm_mmu.h
> @@ -16,6 +16,13 @@
>   */
>  #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
>
> +/*
> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
> + * kernel, on secondary MMU it records page writable in order to fast
> + * path handling
> + */
> +#define KVM_PAGE_SOFT_WRITE    _PAGE_MODIFIED
KVM_PAGE_WRITEABLE is more suitable.

> +
>  #define _KVM_FLUSH_PGTABLE     0x1
>  #define _KVM_HAS_PGMASK                0x2
>  #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) | pgprot_val(pr=
ot))
> @@ -52,11 +59,16 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_p=
te_t val)
>         WRITE_ONCE(*ptep, val);
>  }
>
> -static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRIT=
E; }
> -static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRT=
Y; }
> +static inline int kvm_pte_soft_write(kvm_pte_t pte) { return pte & KVM_P=
AGE_SOFT_WRITE; }
The same, kvm_pte_mkwriteable() is more suitable.

> +static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & __WRITEABL=
E; }
_PAGE_DIRTY and _PAGE_WRITE are always set/cleared at the same time,
so the old version still works.

>  static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCE=
SSED; }
>  static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE;=
 }
>
> +static inline kvm_pte_t kvm_pte_mksoft_write(kvm_pte_t pte)
> +{
> +       return pte | KVM_PAGE_SOFT_WRITE;
> +}
> +
>  static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>  {
>         return pte | _PAGE_ACCESSED;
> @@ -69,12 +81,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t pte)
>
>  static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
>  {
> -       return pte | _PAGE_DIRTY;
> +       return pte | __WRITEABLE;
>  }
>
>  static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
>  {
> -       return pte & ~_PAGE_DIRTY;
> +       return pte & ~__WRITEABLE;
>  }
>
>  static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index ed956c5cf2cc..68749069290f 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, u=
nsigned long gpa, bool writ
>         /* Track access to pages marked old */
>         new =3D kvm_pte_mkyoung(*ptep);
>         if (write && !kvm_pte_dirty(new)) {
> -               if (!kvm_pte_write(new)) {
> +               if (!kvm_pte_soft_write(new)) {
>                         ret =3D -EFAULT;
>                         goto out;
>                 }
> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsign=
ed long gpa, bool write)
>                 prot_bits |=3D _CACHE_SUC;
>
>         if (writeable) {
> -               prot_bits |=3D _PAGE_WRITE;
> +               prot_bits =3D kvm_pte_mksoft_write(prot_bits);
>                 if (write)
> -                       prot_bits |=3D __WRITEABLE;
> +                       prot_bits =3D kvm_pte_mkdirty(prot_bits);
>         }
>
>         /* Disable dirty logging on HugePages */
> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsign=
ed long gpa, bool write)
>         kvm_release_faultin_page(kvm, page, false, writeable);
>         spin_unlock(&kvm->mmu_lock);
>
> -       if (prot_bits & _PAGE_DIRTY)
> +       if (kvm_pte_dirty(prot_bits))
>                 mark_page_dirty_in_slot(kvm, memslot, gfn);
>
>  out:
To save time, I just change the whole patch like this, you can confirm
whether it woks:

diff --git a/arch/loongarch/include/asm/kvm_mmu.h
b/arch/loongarch/include/asm/kvm_mmu.h
index 099bafc6f797..882f60c72b46 100644
--- a/arch/loongarch/include/asm/kvm_mmu.h
+++ b/arch/loongarch/include/asm/kvm_mmu.h
@@ -16,6 +16,13 @@
  */
 #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)

+/*
+ * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
+ * kernel, on secondary MMU it records page writable in order to fast
+ * path handling
+ */
+#define KVM_PAGE_WRITEABLE     _PAGE_MODIFIED
+
 #define _KVM_FLUSH_PGTABLE     0x1
 #define _KVM_HAS_PGMASK                0x2
 #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) |
pgprot_val(prot))
@@ -56,6 +63,7 @@ static inline int kvm_pte_write(kvm_pte_t pte) {
return pte & _PAGE_WRITE; }
 static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte &
_PAGE_DIRTY; }
 static inline int kvm_pte_young(kvm_pte_t pte) { return pte &
_PAGE_ACCESSED; }
 static inline int kvm_pte_huge(kvm_pte_t pte) { return pte &
_PAGE_HUGE; }
+static inline int kvm_pte_writeable(kvm_pte_t pte) { return pte &
KVM_PAGE_WRITEABLE; }

 static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
 {
@@ -69,12 +77,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t
pte)

 static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
 {
-       return pte | _PAGE_DIRTY;
+       return pte | __WRITEABLE;
 }

 static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
 {
-       return pte & ~_PAGE_DIRTY;
+       return pte & ~__WRITEABLE;
 }

 static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
@@ -87,6 +95,11 @@ static inline kvm_pte_t kvm_pte_mksmall(kvm_pte_t
pte)
        return pte & ~_PAGE_HUGE;
 }

+static inline kvm_pte_t kvm_pte_mkwriteable(kvm_pte_t pte)
+{
+       return pte | KVM_PAGE_WRITEABLE;
+}
+
 static inline int kvm_need_flush(kvm_ptw_ctx *ctx)
 {
        return ctx->flag & _KVM_FLUSH_PGTABLE;
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ed956c5cf2cc..7c8143e79c12 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu
*vcpu, unsigned long gpa, bool writ
        /* Track access to pages marked old */
        new =3D kvm_pte_mkyoung(*ptep);
        if (write && !kvm_pte_dirty(new)) {
-               if (!kvm_pte_write(new)) {
+               if (!kvm_pte_writeable(new)) {
                        ret =3D -EFAULT;
                        goto out;
                }
@@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
unsigned long gpa, bool write)
                prot_bits |=3D _CACHE_SUC;

        if (writeable) {
-               prot_bits |=3D _PAGE_WRITE;
+               prot_bits =3D kvm_pte_mkwriteable(prot_bits);
                if (write)
-                       prot_bits |=3D __WRITEABLE;
+                       prot_bits =3D kvm_pte_mkdirty(prot_bits);
        }

        /* Disable dirty logging on HugePages */
@@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
unsigned long gpa, bool write)
        kvm_release_faultin_page(kvm, page, false, writeable);
        spin_unlock(&kvm->mmu_lock);

-       if (prot_bits & _PAGE_DIRTY)
+       if (kvm_pte_dirty(prot_bits))
                mark_page_dirty_in_slot(kvm, memslot, gfn);

 out:

Huacai

>
> base-commit: 9dd1835ecda5b96ac88c166f4a87386f3e727bd9
> --
> 2.39.3
>
>

