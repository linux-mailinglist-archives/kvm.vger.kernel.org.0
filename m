Return-Path: <kvm+bounces-55339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC86EB302CF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DCDC1BC6889
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 19:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C902F34AB14;
	Thu, 21 Aug 2025 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qaB5aa6/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57D77FBAC
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 19:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755804124; cv=none; b=LH+SN+wppUIdgjZUQ1X+ZDlUNR1Rlj2IOrAEHYzw2PwonJzAQ5PJyluwqWPEuUpBfugwQnJa6IgLfevlphYtJtzWbfBBB5DDaxsbz39M/JEYdvpY4ssdN+pj7UfeLTndY0pakKm9RUfC9ZrRqHTo5rJiVUW4Wj33s6sAOWlGlYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755804124; c=relaxed/simple;
	bh=hKjV3Bdfa+3lPnicmtByd+iT0qEQfKA6FCL7/PvnH14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+x17sZOysgH8sDqwHgI5IStmgM2AVaGRFh9qyeotIqEEMuElQZRkr86ypJ/oRzs3lbeQEFpA8xNaLGYGaQXhz8GGGuyxIo9ZcbTSpOy6K5rrJb6XzpLBHWa5IEIBSBed01ZcgytaOzIOOklvKqrghEKIAA245yFLpnZI5z4gtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qaB5aa6/; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso72241cf.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 12:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755804120; x=1756408920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ilc50mPVGrwfo+k7PZHzZeT1zp8dvAwV807vh9LnQD8=;
        b=qaB5aa6/4joBtFbkUpSpQZKdKcPDpXCi5OoHBWIQAMytX+qrMyEjBxXj0Yh1FKBkBJ
         sjjgLeZilZdvwfOiyhHpK9wcEOsKjXekN2tMPY8slEsp6LApTiB9lTHrekqHFydRhb0E
         nRBIlIfwhRCezb52IIBN3z3wulWtx+ADB3DxWwduLAUGSII84VZthseZ7WNaTRDiL2mo
         5KnUAIUk1rtxToqsUZWUG0phwK6WS5IgpvratzX7/m3FJpX5PaPX2hUvy3Pt/mO4AJZM
         tKt17RtC9p0W4BR3tipB2MQm6++Y4bgrIHwbH8ssYH7Q5sP4VVLdu1QloiPqd/krpvy8
         jG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755804120; x=1756408920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ilc50mPVGrwfo+k7PZHzZeT1zp8dvAwV807vh9LnQD8=;
        b=aUoaMykraxCrxzNfjgaisfKdZ7QlY2A8blD8OCo2sH8L+DkGrAiNVFszcS1BfeO6MF
         4KMpIA0R5Svtx67V2IKiZQUx2wZ3RsrYZw9i7OJHSq7ejzJ6x/RYr+UOBrZPammIeb6c
         6Pvdt7kCsYho+6s+OWdixPwivTsWnoOK6mERzFwGleERa25vPi7ajORu5xWk5ZARxksw
         TghTlM/b/NMw3X55kSEBBPuUMYRE0fHJkveRcQGBd3P922/hEAg06t+uQjvjrqo/Rjgj
         QgVkIWTzRp3zqUlbwsyKPa70RWoRxK7ialHnTqH/LuVnwxCDyUW6PtzjxPAFEgT+9+eO
         msqg==
X-Forwarded-Encrypted: i=1; AJvYcCUFUsVmiBhzCy4/hVWQ6RMX73jvR76DU421kufDUxObb5TRmpt37Ih/hYG0/NMg7bepWx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDr+8Ga0gryHuXadnasV5xShBTDMhsGSY/75xxtge4YsT6BoGW
	3MSoWO0xp10jg/1EKLNBYD2ZsdF9ZyCU3rk/Mq5tQVteC4tgTgYtHPm8bb87GHKWh6WhfLnVXQz
	eyXx+e6aS37DKhgRzcVu7ttYSUWFyQr7vfWlRCJFq
X-Gm-Gg: ASbGnctqVXiOiNwMSHhsThMg0q0Grhz4Mx9kYSPNG7xqDOuye1dydPGkARYUdrN5y6l
	zmN4gby1XP7+zNUCxaJl9KvUff1j1bmX2gwBRrycNW5U72rVe0V8E9GPkDejz7JVvGG3rq9MCTO
	ZwgbUziNMQGWSBCQwaJeiAGgqyw+ngibFxGZnNhi1yDa9G2Q8AMPL0bi+A40X+bOPgjeFSs6CgX
	VJkFoOpsQmy2HR96TkgXG+F0HVSX4GbAuhYvSGkM1i4zf0MCcK4vizuzw==
X-Google-Smtp-Source: AGHT+IEfSQSRZKTmvco6JeYeQU6/BI51GtHOl5P8UiOFcRQ1UL7CTs/n9GMqAQJ/KofHvStmBAuUDbtTK0h93IsHqY4=
X-Received: by 2002:a05:622a:860c:b0:4ab:3a34:317a with SMTP id
 d75a77b69052e-4b2aaff5aecmr374371cf.17.1755804119341; Thu, 21 Aug 2025
 12:21:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com> <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 21 Aug 2025 14:21:47 -0500
X-Gm-Features: Ac12FXyTJoAPd-OPdCjI8iU_xiRJBgChDEsznpBOvEolzcRHN3gqj2WyAmgSbJ4
Message-ID: <CAAhR5DGGWss4jovHETYmBeK1gze04LR9c8Dcd2oMpCC3SnMDgQ@mail.gmail.com>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 2:16=E2=80=AFPM Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> There are two distinct cases when the kernel needs to allocate PAMT
> memory in the fault path: for SEPT page tables in tdx_sept_link_private_s=
pt()
> and for leaf pages in tdx_sept_set_private_spte().
>
> These code paths run in atomic context. Use a pre-allocated per-VCPU
> pool for memory allocations.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/include/asm/tdx.h  |  4 ++++
>  arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++-----
>  arch/x86/virt/vmx/tdx/tdx.c | 21 +++++++++++++------
>  virt/kvm/kvm_main.c         |  1 +
>  4 files changed, 55 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 47092eb13eb3..39f8dd7e0f06 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -116,6 +116,10 @@ u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>
>  int tdx_nr_pamt_pages(void);
> +int tdx_pamt_get(struct page *page, enum pg_level level,
> +                struct page *(alloc)(void *data), void *data);
> +void tdx_pamt_put(struct page *page, enum pg_level level);
> +
>  struct page *tdx_alloc_page(void);
>  void tdx_free_page(struct page *page);
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 36c3c9f8a62c..bc9bc393f866 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1537,11 +1537,26 @@ static int tdx_mem_page_record_premap_cnt(struct =
kvm *kvm, gfn_t gfn,
>         return 0;
>  }
>
> +static struct page *tdx_alloc_pamt_page_atomic(void *data)
> +{
> +       struct kvm_vcpu *vcpu =3D data;
> +       void *p;
> +
> +       p =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.pamt_page_cache);
> +       return virt_to_page(p);
> +}
> +
>  int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>                               enum pg_level level, kvm_pfn_t pfn)
>  {
> +       struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
>         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
>         struct page *page =3D pfn_to_page(pfn);
> +       int ret;
> +
> +       ret =3D tdx_pamt_get(page, level, tdx_alloc_pamt_page_atomic, vcp=
u);
> +       if (ret)
> +               return ret;

tdx_pamt_get() can return non-zero value in case of success e.g.
returning 1 in case tdx_pamt_add() lost the race. Shouldn't we check
for (ret < 0) here and below cases?

>
>         /* TODO: handle large pages. */
>         if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> @@ -1562,10 +1577,16 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gf=
n_t gfn,
>          * barrier in tdx_td_finalize().
>          */
>         smp_rmb();
> -       if (likely(kvm_tdx->state =3D=3D TD_STATE_RUNNABLE))
> -               return tdx_mem_page_aug(kvm, gfn, level, page);
>
> -       return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> +       if (likely(kvm_tdx->state =3D=3D TD_STATE_RUNNABLE))
> +               ret =3D tdx_mem_page_aug(kvm, gfn, level, page);
> +       else
> +               ret =3D tdx_mem_page_record_premap_cnt(kvm, gfn, level, p=
fn);
> +
> +       if (ret)
> +               tdx_pamt_put(page, level);
> +
> +       return ret;
>  }
>
>  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> @@ -1622,17 +1643,26 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gf=
n_t gfn,
>                               enum pg_level level, void *private_spt)
>  {
>         int tdx_level =3D pg_level_to_tdx_sept_level(level);
> -       gpa_t gpa =3D gfn_to_gpa(gfn);
> +       struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
>         struct page *page =3D virt_to_page(private_spt);
> +       gpa_t gpa =3D gfn_to_gpa(gfn);
>         u64 err, entry, level_state;
> +       int ret;
> +
> +       ret =3D tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_atomi=
c, vcpu);
> +       if (ret)
> +               return ret;
>
>         err =3D tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, pa=
ge, &entry,
>                                &level_state);
> -       if (unlikely(tdx_operand_busy(err)))
> +       if (unlikely(tdx_operand_busy(err))) {
> +               tdx_pamt_put(page, PG_LEVEL_4K);
>                 return -EBUSY;
> +       }
>
>         if (KVM_BUG_ON(err, kvm)) {
>                 pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state)=
;
> +               tdx_pamt_put(page, PG_LEVEL_4K);
>                 return -EIO;
>         }
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4f9eaba4af4a..d4b50b6428fa 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -2067,10 +2067,16 @@ static void tdx_free_pamt_pages(struct list_head =
*pamt_pages)
>         }
>  }
>
> -static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
> +static int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
> +                                struct page *(alloc)(void *data), void *=
data)
>  {
>         for (int i =3D 0; i < tdx_nr_pamt_pages(); i++) {
> -               struct page *page =3D alloc_page(GFP_KERNEL);
> +               struct page *page;
> +
> +               if (alloc)
> +                       page =3D alloc(data);
> +               else
> +                       page =3D alloc_page(GFP_KERNEL);
>                 if (!page)
>                         goto fail;
>                 list_add(&page->lru, pamt_pages);
> @@ -2115,7 +2121,8 @@ static int tdx_pamt_add(atomic_t *pamt_refcount, un=
signed long hpa,
>         return 0;
>  }
>
> -static int tdx_pamt_get(struct page *page, enum pg_level level)
> +int tdx_pamt_get(struct page *page, enum pg_level level,
> +                struct page *(alloc)(void *data), void *data)
>  {
>         unsigned long hpa =3D page_to_phys(page);
>         atomic_t *pamt_refcount;
> @@ -2134,7 +2141,7 @@ static int tdx_pamt_get(struct page *page, enum pg_=
level level)
>         if (atomic_inc_not_zero(pamt_refcount))
>                 return 0;
>
> -       if (tdx_alloc_pamt_pages(&pamt_pages))
> +       if (tdx_alloc_pamt_pages(&pamt_pages, alloc, data))
>                 return -ENOMEM;
>
>         ret =3D tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
> @@ -2143,8 +2150,9 @@ static int tdx_pamt_get(struct page *page, enum pg_=
level level)
>
>         return ret >=3D 0 ? 0 : ret;
>  }
> +EXPORT_SYMBOL_GPL(tdx_pamt_get);
>
> -static void tdx_pamt_put(struct page *page, enum pg_level level)
> +void tdx_pamt_put(struct page *page, enum pg_level level)
>  {
>         unsigned long hpa =3D page_to_phys(page);
>         atomic_t *pamt_refcount;
> @@ -2179,6 +2187,7 @@ static void tdx_pamt_put(struct page *page, enum pg=
_level level)
>
>         tdx_free_pamt_pages(&pamt_pages);
>  }
> +EXPORT_SYMBOL_GPL(tdx_pamt_put);
>
>  struct page *tdx_alloc_page(void)
>  {
> @@ -2188,7 +2197,7 @@ struct page *tdx_alloc_page(void)
>         if (!page)
>                 return NULL;
>
> -       if (tdx_pamt_get(page, PG_LEVEL_4K)) {
> +       if (tdx_pamt_get(page, PG_LEVEL_4K, NULL, NULL)) {
>                 __free_page(page);
>                 return NULL;
>         }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eec82775c5bf..6add012532a0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -436,6 +436,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memor=
y_cache *mc)
>         BUG_ON(!p);
>         return p;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
>  #endif
>
>  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsign=
ed id)
> --
> 2.47.2
>
>

