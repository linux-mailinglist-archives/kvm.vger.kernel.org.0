Return-Path: <kvm+bounces-19023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CFF8FF1F0
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5557A1F265B6
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CA619AA7C;
	Thu,  6 Jun 2024 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6uWyA8D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20C119AA40
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690271; cv=none; b=gvW9cYfK+b0EL4Q7PepuQOGUu3CCAl7ADJPftRvsLcZNEL4GVa3ClEoo38ntHlBMpfm1vrUkhPQRkU1E8CVI/E3KcD8eCkt9a0pnCVqV6k0nUOPSPF4cR9Ckw3NNxq4NjwqZlAUdN9XQq3xcV4xRHv3U50GvVY+ertoR2G/YZ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690271; c=relaxed/simple;
	bh=C6xOxQ9P1I2nAifuPJPu4NYJEtpJMNEvDpiLCEcU+FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jp8K7Mkvcw6UTYwWU2u/i0eZ22suPn1SjRh8HvU4BCM6b4KINrSKlvMO6hVCoa1xAieyRuch1ZGlhj4Aclvz0PdbHqia1Xm3Iw/rge7CaoCyoP7Gw2PRf6D+3hqEWCeWNH4q7GdxnNq+wwoNnt5UXnkBbtc9MVUmLvnEGKZUheA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6uWyA8D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717690268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bMxHuzTNqwoExnxxNXUTJ+We8jv8Inb+JPwzg5VCJYY=;
	b=G6uWyA8DtcP7zlhbNL9P9ZGVDsnOPiTpL7epzU19i8pchr17h8A6zptLExh23iCgh8Acea
	rEaYZevs24SFuePhO4m5lQ1L5lVOt4YAbmh8Bwzs8uIELoZP2f7Ps/BP7LvslDh8uliOim
	V0S8LYTxUwpE99mAWTVLrgr/+TGQLJE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-M5doPWGdPWSt6m3oEi7UcQ-1; Thu, 06 Jun 2024 12:11:07 -0400
X-MC-Unique: M5doPWGdPWSt6m3oEi7UcQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-35e521885e5so873832f8f.3
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 09:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717690261; x=1718295061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMxHuzTNqwoExnxxNXUTJ+We8jv8Inb+JPwzg5VCJYY=;
        b=c78S4flFZD6zT1tg5Gzsrw89BH3qjI6MFgT28bjm6ZaMTgQ+bnTqjkfdBoRD2IV3sn
         g1BMY+NrMtLhc34iR0sb/QkGD2WMtbkwdbW9IbD0fMZrzjCVz2ZFL/OYVgNXDLKb6v1r
         bO/70Wpn8uLffUjGI1KIz33bx7mTPorzhJy+tS81Mj4nmOPqYe696ZesJ3IIDywo/KYi
         nLAunSiAYG+KPGFVke+AtbJYLdez9LPrR6RipfqnmjwfyalXOyxsoNxAsPG9irfJkmNd
         lSNz4M1UUn1d3TE0P3A/lZm0pGFoddCaYXuSXjzAwxJRi2a2+yDRK8lwOczLTJlDSqt3
         3Pjw==
X-Forwarded-Encrypted: i=1; AJvYcCXNi3Dyi2v3cX0s24XEBBDQ/5hPCm0/KFZlVjNnuA6fx5r/nLpjUlCcaEasE3DU53uJSZSRlNILf4mGg04prtMz76RX
X-Gm-Message-State: AOJu0YwHt1qe0nXwPmrU6/JHv+cWJ+lkS2UW6wXOZDEZkNV8fDuDVXjF
	3F0DU8n24SfVRRgt17KWd0nlFuaEDNdMNWDhKow3/j+oeqRMUZNrU3HOk6P3aBXS1hCNA5Zmv8B
	VufvsAbm+7ZGjDoTWXTCfAqyzvgtffNxzvNmlRxfQr8zOLmI4GLfpc7B9uQZsEN8+bzanOf59EA
	/w2Ice7xZuU+wil2ykhwQPtW4A
X-Received: by 2002:a5d:4a10:0:b0:35e:f25f:6c9 with SMTP id ffacd0b85a97d-35efea7e179mr96640f8f.0.1717690261394;
        Thu, 06 Jun 2024 09:11:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1Es/YGWhv/S13Xa529CXDzdBf9/542vQsdMCXTwyiGCXBRAw5/xXSrsUeTWLoCWoMiQ8MJfY8HjgEvFhux/g=
X-Received: by 2002:a5d:4a10:0:b0:35e:f25f:6c9 with SMTP id
 ffacd0b85a97d-35efea7e179mr96619f8f.0.1717690261123; Thu, 06 Jun 2024
 09:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-6-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-6-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Jun 2024 18:10:49 +0200
Message-ID: <CABgObfYgF9gcokAg2gOjXqfuxj_oDBmEu4HfDaRc0CLSkmWhoA@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root()
 return void
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> The kvm_tdp_mmu_alloc_root() function currently always returns 0. This
> allows for the caller, mmu_alloc_direct_roots(), to call
> kvm_tdp_mmu_alloc_root() and also return 0 in one line:
>    return kvm_tdp_mmu_alloc_root(vcpu);
>
> So it is useful even though the return value of kvm_tdp_mmu_alloc_root()
> is always the same. However, in future changes, kvm_tdp_mmu_alloc_root()
> will be called twice in mmu_alloc_direct_roots(). This will force the
> first call to either awkwardly handle the return value that will always
> be zero or ignore it. So change kvm_tdp_mmu_alloc_root() to return void.
> Do it in a separate change so the future change will be cleaner.
>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
> TDX MMU Prep:
>  - New patch
> ---
>  arch/x86/kvm/mmu/mmu.c     | 6 ++++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
>  arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5070ba7c6e89..12178945922f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3700,8 +3700,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu =
*vcpu)
>         unsigned i;
>         int r;
>
> -       if (tdp_mmu_enabled)
> -               return kvm_tdp_mmu_alloc_root(vcpu);
> +       if (tdp_mmu_enabled) {
> +               kvm_tdp_mmu_alloc_root(vcpu);
> +               return 0;
> +       }
>
>         write_lock(&vcpu->kvm->mmu_lock);
>         r =3D make_mmu_pages_available(vcpu);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e7cd4921afe7..2770230a5636 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -224,7 +224,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page=
 *child_sp,
>         tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
>  }
>
> -int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> +void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_mmu *mmu =3D vcpu->arch.mmu;
>         union kvm_mmu_page_role role =3D mmu->root_role;
> @@ -285,7 +285,6 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
>          */
>         mmu->root.hpa =3D __pa(root->spt);
>         mmu->root.pgd =3D 0;
> -       return 0;
>  }
>
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 58b55e61bd33..437ddd4937a9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -10,7 +10,7 @@
>  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>
> -int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
> +void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
>
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page=
 *root)
>  {
> --
> 2.34.1
>


