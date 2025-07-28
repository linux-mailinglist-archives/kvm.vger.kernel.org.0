Return-Path: <kvm+bounces-53582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC93CB14409
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 23:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6993542087
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 21:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10C2274671;
	Mon, 28 Jul 2025 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f3kNuzTP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E30A1E5B7E
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753739345; cv=none; b=YzxzruXzMnXtPeipLQSJrGu4GIv5zKBU/XE+ejIa97qM5tQr2XethodjN0ZlejjQIoUgYsExLJKC3V8WFyhdHlnu6iAhV1nx7OpKTGVcmr+xUPvnawoATBxJC+T5UYPZJnRJQZ1hwOIHZEDIdEbOV7PCwtiW1CpCfrjEbEIQsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753739345; c=relaxed/simple;
	bh=8tmNEDk1108qFbcscn3yK9EMsFQJwypelzVi8awwSn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhK1k6oroMcFCEaJuhYGKkN+ezxTYozCYbxyjXjgkuzGEi2Jh+aPcOobLDi1MrAJUaqiXn2V8vc2FGgXa+l2s4a4aDti2z5d9VG7FdKZMdKltVRaA2BHsTeE1yHGN+HlAORHU4YqErIl19XqJzOWuJ7+wuWvItZOSC9Jq7XPjLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f3kNuzTP; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e8e19112e8fso721025276.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 14:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753739342; x=1754344142; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNYkKUMqh3Q6zlk7zublZCSOOzAw8JNXG0Uwfynmfio=;
        b=f3kNuzTPhTA6Wxt2pvE2IbDOhuG99OwMw6b7DluWlujcsO8WiPESWk9O4F1taR2LDi
         b0iMKhDlpyUARpSHk43H8WLbgFCe/r01XQNdZca2UZcm6PQpjYw3gVqrIPGIbR33zWQc
         A8PqZGCs9vgvKae6wo2TFjrT7ncuocHBLNJ7OgNYVifQ1xmJ2Heu+a25I+6Lm/VW250Y
         Qreq5PRJjdP8Knt58GiwvNdcFYekmPEXg7zIY+VpvJjs6iwXcaQ9RX2nMYDvwUvrpEUn
         Nums49H1XXdWkmkmeDnfHfdZ8PJ3lmmmfkRd7mP0tUS1HyIIJU7SuPdIZZ+GGvYCX2sy
         ol7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753739342; x=1754344142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNYkKUMqh3Q6zlk7zublZCSOOzAw8JNXG0Uwfynmfio=;
        b=Xza5oZNjaqgwqK7T/qXFcGOEMcNmqxUJD7Iig/eEN/acPPav1OJ/OOODstSt5icdX8
         YjVdCuwS8J1NWvSqJBpnkAMj9qWUIJacOKI4S7qXu0N65P6tMimh2xxsROSVP+WRWHGa
         me0uQ5jTjKoOzwPIiKjQ0mzBpfoALSfxCttc1Gr6x8nXQR+Swv1N+NIPjaSqpMbUUr7J
         evDYv4AiOPAVpRZXlujrD7cgCtxXiJwGQpkwnGH6X6auYmN0dmZmtsHaL1QlOLO9DKEk
         81Nj8GooG4chEfRRtLpGN7Smz10z9PtuEGyRWdRKLuTOxnCJz7dSUavuEDzq3jbOZRws
         7aYw==
X-Forwarded-Encrypted: i=1; AJvYcCV2i3GXjHVIg+PS59PcEtvGuz/nriLZ1SK+hCzmCL6gbn6MzgpS5gIMD2w1USw3mGrpiAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7H4yeoXubwBLZbFDtVoMsPoFzlqMHIn76d1zUn7NeBgE7slIC
	Ah/mwz+rEFa3atNh3N1/2CU2jmCZI47LTRkpDyDIJMkORTyYBmJ5NtPhaLUD7X2rKyi2ACQyMhD
	FbYs/I4slhE5j4cbWU+yxqBdgWNi1Z2tZtUUlxDWw
X-Gm-Gg: ASbGncsaJVMup0k6jGfruhwFYklgnfiweRy9hiaxIINENA9ofjrRVJr0gcWEZ2V4IlV
	R2ZS0W2W9ngG09tMK+01+i3LfiRGq6SdgytlMOqe7A9/3Ib9tPCdygq1gyo4Qsl+HtOhPncfPir
	jnaTmr5E0XhFSbyoPLw3IUye5X2OGa/iVCTdyLtFAm4A1QcXSyIJjrLACqOc4gHD/SEog5+Eb1D
	7v3jQoHV+sEPdO+KY3zWuQ79cwR4IF2HagbOs24aWkUwbhx
X-Google-Smtp-Source: AGHT+IE2mYs4r6noXBQXIYVkMmGAdIWN2/QiECNIyFYTZbPmpXx9oohnPh0CVYDcsueX6RTXa46JQAWjagLlqUnsgYU=
X-Received: by 2002:a05:6902:158b:b0:e8d:e898:9c46 with SMTP id
 3f1490d57ef6-e8df11de957mr14432049276.25.1753739342131; Mon, 28 Jul 2025
 14:49:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
 <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
 <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com> <aIft7sUk_w8rV2DB@google.com>
In-Reply-To: <aIft7sUk_w8rV2DB@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Jul 2025 14:48:26 -0700
X-Gm-Features: Ac12FXylAHsC6PnOs8l0sIEXzKpV-hGp0OFEgDGoMNOHrpfgSioRTxQz2Qw5R5w
Message-ID: <CADrL8HWE+TQ8Vm1a=eb5ZKo2+zeeE-b8-PUXLOS0g5KuJ5kfZQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 2:38=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 28, 2025, David Matlack wrote:
> > On Mon, Jul 28, 2025 at 11:08=E2=80=AFAM James Houghton <jthoughton@goo=
gle.com> wrote:
> > > On Wed, Jul 23, 2025 at 1:35=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > > @@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(stru=
ct kvm *kvm,
> > > > >       rcu_read_lock();
> > > > >
> > > > >       for ( ; to_zap; --to_zap) {
> > > > > -             if (list_empty(nx_huge_pages))
> > > > > +#ifdef CONFIG_X86_64
> > > >
> > > > These #ifdefs still make me sad, but I also still think they're the=
 least awful
> > > > solution.  And hopefully we will jettison 32-bit sooner than later =
:-)
> > >
> > > Yeah I couldn't come up with anything better. :(
> >
> > Could we just move the definition of tdp_mmu_pages_lock outside of
> > CONFIG_X86_64? The only downside I can think of is slightly larger kvm
> > structs for 32-bit builds.
>
> Hmm, I was going to say "no, because we'd also need to do spin_lock_init(=
)", but
> obviously spin_(un)lock() will only ever be invoked for 64-bit kernels.  =
I still
> don't love the idea of making tdp_mmu_pages_lock visible outside of CONFI=
G_X86_64,
> it feels like we're just asking to introduce (likely benign) bugs.
>
> Ugh, and I just noticed this as well:
>
>   #ifndef CONFIG_X86_64
>   #define KVM_TDP_MMU -1
>   #endif
>
> Rather than expose kvm->arch.tdp_mmu_pages_lock, what about using a singl=
e #ifdef
> section to bury both is_tdp_mmu and a local kvm->arch.tdp_mmu_pages_lock =
pointer?

SGTM.

>
> Alternatively, we could do:
>
>         const bool is_tdp_mmu =3D IS_ENABLED(CONFIG_X86_64) && mmu_type !=
=3D KVM_SHADOW_MMU;

I tried something like this before and it didn't work; my compiler
still complained. Maybe I didn't do it quite right...

>
> to avoid referencing KVM_TDP_MMU, but that's quite ugly.  Overall, I thin=
k the
> below strikes the best balance between polluting the code with #ifdefs, a=
nd
> generating robust code.
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 52bf6a886bfd..c038d7cd187d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1372,10 +1372,6 @@ enum kvm_mmu_type {
>         KVM_NR_MMU_TYPES,
>  };
>
> -#ifndef CONFIG_X86_64
> -#define KVM_TDP_MMU -1
> -#endif
> -
>  struct kvm_arch {
>         unsigned long n_used_mmu_pages;
>         unsigned long n_requested_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a6a1fb42b2d1..e2bde6a5e346 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7624,8 +7624,14 @@ static bool kvm_mmu_sp_dirty_logging_enabled(struc=
t kvm *kvm,
>  static void kvm_recover_nx_huge_pages(struct kvm *kvm,
>                                       const enum kvm_mmu_type mmu_type)
>  {
> +#ifdef CONFIG_X86_64
> +       const bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> +       spinlock_t *tdp_mmu_pages_lock =3D &kvm->arch.tdp_mmu_pages_lock;
> +#else
> +       const bool is_tdp_mmu =3D false;
> +       spinlock_t *tdp_mmu_pages_lock =3D NULL;
> +#endif
>         unsigned long to_zap =3D nx_huge_pages_to_zap(kvm, mmu_type);
> -       bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
>         struct list_head *nx_huge_pages;
>         struct kvm_mmu_page *sp;
>         LIST_HEAD(invalid_list);
> @@ -7648,15 +7654,12 @@ static void kvm_recover_nx_huge_pages(struct kvm =
*kvm,
>         rcu_read_lock();
>
>         for ( ; to_zap; --to_zap) {
> -#ifdef CONFIG_X86_64
>                 if (is_tdp_mmu)
> -                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -#endif
> +                       spin_lock(tdp_mmu_pages_lock);
> +
>                 if (list_empty(nx_huge_pages)) {
> -#ifdef CONFIG_X86_64
>                         if (is_tdp_mmu)
> -                               spin_unlock(&kvm->arch.tdp_mmu_pages_lock=
);
> -#endif
> +                               spin_unlock(tdp_mmu_pages_lock);
>                         break;
>                 }
>
> @@ -7675,10 +7678,8 @@ static void kvm_recover_nx_huge_pages(struct kvm *=
kvm,
>
>                 unaccount_nx_huge_page(kvm, sp);
>
> -#ifdef CONFIG_X86_64
>                 if (is_tdp_mmu)
> -                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> -#endif
> +                       spin_unlock(tdp_mmu_pages_lock);
>
>                 /*
>                  * Do not attempt to recover any NX Huge Pages that are b=
eing
> --

LGTM! Thanks Sean.

