Return-Path: <kvm+bounces-8545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7798510FB
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F36AB22DD1
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 10:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE1D38DE3;
	Mon, 12 Feb 2024 10:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iY6tXVjr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC9383AA
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 10:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707734088; cv=none; b=gwVHR5yMQJ5O/KtBp1mRQmlqzeLK5viMjPuh++oj7X/Hikqrm7WSfYyde8jBB7xvVKwNE3/pHZFpzOvMTEioAAUpO33xoM60DYVDTZNXJb14VJ0TrsAt1f7G6/L0xqa9VfvJiuslKyGiKedMnRVlO7mUlgeUR8cNpXP9sSUdUQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707734088; c=relaxed/simple;
	bh=EoFkIvo0jVT7iACpJyA0SYfSyvqCf8/ZdX+R+C/HGAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MZDldCLqWLM1/4F8cb1l3cG/bX5wewYujz2istnNnnqtyaHfK1f0qFwYxMc9VALvCtp5V6KSi2CCAc0lWPznBswCki3QnRzmTOxb/uMTTjfDZqya23i3vf5xF1rrR6cfiornGAbN7YtjV6I1tBvibNBDOP+ag22kxMjYOrIBezU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iY6tXVjr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707734085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgpAN4/fM2uvng00mD2oqsBNpUIMHVV2+w/F9N6+DNQ=;
	b=iY6tXVjrtklgXFCckOxwi4Hpy//bch5DOrjWBJa6hZmO56xJJXk/lf1rHuUFSWqwhN1jSo
	UJQW5vZVhha2bhkO/Bby0z9pupgqxgn0xO6yuZ0gw5oskkMZjIoQ8FUT5/g8yfcEEH7FyG
	v5wANCtFXLbRw9Li4grzcO6vgJI11yQ=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-nJcp8mzTNeOVE7m5oeDJPg-1; Mon, 12 Feb 2024 05:34:43 -0500
X-MC-Unique: nJcp8mzTNeOVE7m5oeDJPg-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-46d256241c1so940155137.0
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 02:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707734082; x=1708338882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgpAN4/fM2uvng00mD2oqsBNpUIMHVV2+w/F9N6+DNQ=;
        b=WcVBxKUxCay3nLAURyASS9XhJpUP6iAkKgx+ZyrhrpJ1DITsPIXdKAV/4V/I93gala
         VUSfTPP39L5WMw1utq888GhzPS06Xv59/s9rV69Hf9JLXb9dIdandPsZIuWx/3SXp8z0
         5EleHRoGL2auNxWgvr2FlzkxfxNr85ndpA3xCSzp5tIPNASbWRHut9g2dNlaHQSflvQD
         IwTj4gj35cHZut6I7JouppMt3MaMotPUUcTNcIuZfHOLDQ5ve95/ojvBEBzfdU3kMT3n
         SpyzzGMOXw1S9UaOiafrwrF4L0bKZTf9xYvYI9sUbHKgnI+GxVoxQGJWJP15YdStsiq/
         UTPA==
X-Gm-Message-State: AOJu0YxKIe54tB13rZ7QFMCqjr6UK8AzEjnMYmoXZWNTf2RTqt9HFnbx
	yM7d7gEy1hqqBVOykj5UB5PYyP4n5lvVqOAQjQ+Gfb1kw1V+YPbAPCePGkyIeWIcSF8uPCD1Y0z
	IR9NidMCO1AHCBpkmhwbWIp8rIe1rW0uD9EgSilJyYcTsFX31cAEKhEgSK7vf4UmakQo23g9wgF
	RFXYYBakiUe6QHpg19muOjQu7C
X-Received: by 2002:a05:6102:116f:b0:46d:2d95:5c15 with SMTP id k15-20020a056102116f00b0046d2d955c15mr3800831vsg.13.1707734081984;
        Mon, 12 Feb 2024 02:34:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMKwEPA7aCJ3CTH/U8+IoQs6Vt+T3sXtGQG3F/44PHdppD0ZaTuixrHMSXjQ4m9T3C19OL3I7hoVosabGmzsI=
X-Received: by 2002:a05:6102:116f:b0:46d:2d95:5c15 with SMTP id
 k15-20020a056102116f00b0046d2d955c15mr3800789vsg.13.1707734080219; Mon, 12
 Feb 2024 02:34:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com> <d99863c474b8a3d9e413fbf940bf6891d2ce319e.1705965635.git.isaku.yamahata@intel.com>
In-Reply-To: <d99863c474b8a3d9e413fbf940bf6891d2ce319e.1705965635.git.isaku.yamahata@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Feb 2024 11:34:28 +0100
Message-ID: <CABgObfbu1-Ok607uYdo4DzwZf8ZGVQnvHU+y9_M1Zae55K5xwQ@mail.gmail.com>
Subject: Re: [PATCH v18 041/121] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com, 
	Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 12:55=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX requires special handling to support large private page.  For
> simplicity, only support 4K page for TD guest for now.  Add per-VM maximu=
m
> page level support to support different maximum page sizes for TD guest a=
nd
> conventional VMX guest.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>

Please reimplement this on top of "KVM: x86: Add gmem hook for
determining max NPT mapping level" from the SEV-SNP series.

Paolo


> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 2 ++
>  arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 430d7bd7c37c..313519edd79e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1283,6 +1283,7 @@ struct kvm_arch {
>         unsigned long n_requested_mmu_pages;
>         unsigned long n_max_mmu_pages;
>         unsigned int indirect_shadow_pages;
> +       int tdp_max_page_level;
>         u8 mmu_valid_gen;
>         struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>         struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 54d4c8f1ba68..e93bc16a5e9b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6307,6 +6307,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>
>         kvm->arch.split_desc_cache.kmem_cache =3D pte_list_desc_cache;
>         kvm->arch.split_desc_cache.gfp_zero =3D __GFP_ZERO;
> +
> +       kvm->arch.tdp_max_page_level =3D KVM_MAX_HUGEPAGE_LEVEL;
>  }
>
>  static void mmu_free_vm_memory_caches(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_inter=
nal.h
> index 0443bfcf5d9c..2b9377442927 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -296,7 +296,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vc=
pu *vcpu, gpa_t cr2_or_gpa,
>                 .nx_huge_page_workaround_enabled =3D
>                         is_nx_huge_page_enabled(vcpu->kvm),
>
> -               .max_level =3D KVM_MAX_HUGEPAGE_LEVEL,
> +               .max_level =3D vcpu->kvm->arch.tdp_max_page_level,
>                 .req_level =3D PG_LEVEL_4K,
>                 .goal_level =3D PG_LEVEL_4K,
>         };
> --
> 2.25.1
>


