Return-Path: <kvm+bounces-19021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B6F8FF198
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FB011F25846
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBA2198841;
	Thu,  6 Jun 2024 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MoKq+Bje"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A0A196D9C
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690011; cv=none; b=D//E7/u6VW7HH/AfE+wrtlQ6XhdEULXEiQr8zwLTjGL2GpWzK6s33bPwDbgfIjkfDKPMEyCeHVeW+BpYZVSyVsgtgf7WCJJxomFhG4eLisAlm/xZjA+85mYjo9g7n3YWVjWuDQ98sumZvh79sebMLbiw/EpRCyJFI8ZnqUQgrdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690011; c=relaxed/simple;
	bh=xtP+8AIj85C1/WgIWPRNG4p8BLG3rnAPCNR1vfpZHEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n0BuYI2qkhNxopqUiJV1rs4J3QQd2T+I3Sv0QMqm6XYJHoYYPcjEN/4LoMsJlv++DqNWbX7Z1eFExqKvpgxTiAWbLLWL7q6Fri+huRDET85U4DZbHVLgfpsP+cQuAWdz7s6KPvvpzvNtxedJuKX108l7DHGxsFe83rLQqo5Rh8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MoKq+Bje; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717690008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AqdpCvnzMbEvDLDb+VyMlSvq06RVNzNNqxG9y9taPwg=;
	b=MoKq+BjeGWkKrxSLukD+ZdnRl/j02wRGTHQOam/vngTdjRKUdQUcukZ6PP9fpOd3Cqg5Jo
	nULTz/bNrClte54VqFRMTVUKeDoRvNr9VeDECQj6QsOT2G6TdTQBZXZHWRCHx8lkcG7rSi
	cDhsnHX6ceIuI5na6o1XOV+O3MqgLzg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-HZaJMrrPORCn37ohg_eD0Q-1; Thu, 06 Jun 2024 12:06:47 -0400
X-MC-Unique: HZaJMrrPORCn37ohg_eD0Q-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35dceae6283so1064164f8f.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 09:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717690005; x=1718294805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AqdpCvnzMbEvDLDb+VyMlSvq06RVNzNNqxG9y9taPwg=;
        b=LdZ4m5rpQxBY45rpjXtfDDiiL2RVHrTvTtW/6psrLGNN9pjanDIh3TlpO4+7JK6pWM
         EhqNawGE9V0W+qUqaPA7M70rW/u0vj5/bCrCNnRwKCVoB7LEzLBtUAs7KZaHOk2yrdCb
         ngyaI/mF58mh6uQnCYhmjJ02rzleebeLDH1RrPQxLIDJ/+FeJvjGnsyVqIFqDHvAgIGt
         KS2gYxnmiaaLu3YpgE+qqeqtdtrUhMEGTkoKj8uwfnX6D00aruwVje7vdgN0xQEsfvUV
         kwiRlkyqQn9W98372cizygTFd6OOA1ClSCLpmd6TSVUC+IKQxxgbhJo+dUziU8s7EeTj
         wzlg==
X-Forwarded-Encrypted: i=1; AJvYcCVoaQptcbn7xa1MB7PwXlROJM8UWuqkWfTG7uoiLwstupj+ZdOAKZ/Qsj+xsQfhzvL/NdDIoITmCXIixZgOd6vkFGMo
X-Gm-Message-State: AOJu0YwMiP8sRJ2dvIGgeliT1IgxENCsPniTAeAF603GfpOY87WOa+Lh
	WkbFcTSw9DVyqcFym+B+zRr2puRnfaefINIxRo9hIe1FHKZ3hK9kEU5EeaNIZSSqoKYsjOnA4Hg
	xoIGV4QevmpdYVvWsmYNOX+0AKHqOpo2kwdXne78aDvFa7SWnHsxh6gnQSpjXlcM1DlTY8sTvaO
	HPP7MDIKUuTItc4IM0ZXJp821Hhx+GBDc9
X-Received: by 2002:a5d:5750:0:b0:356:49a8:7e0a with SMTP id ffacd0b85a97d-35efed1d686mr56107f8f.11.1717690005381;
        Thu, 06 Jun 2024 09:06:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtuK4uojIq+VZLW+UvPNBI/OVsp0turKI0UvFa+AeYkiz/Gn3dzwmCpJcFa5pu3JCGHmlZTb7NXLe0DqqOEt8=
X-Received: by 2002:a5d:5750:0:b0:356:49a8:7e0a with SMTP id
 ffacd0b85a97d-35efed1d686mr56090f8f.11.1717690004987; Thu, 06 Jun 2024
 09:06:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-5-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-5-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Jun 2024 18:06:33 +0200
Message-ID: <CABgObfa1xtZkGizNf=YrMYSo29v==qijMQJ-mZvobniS6-7OLw@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] KVM: x86/mmu: Add a new mirror_pt member for
 union kvm_mmu_page_role
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Introduce a "mirror_pt" member to the kvm_mmu_page_role union to identify
> SPTEs associated with the mirrored EPT.
>
> The TDX module maintains the private half of the EPT mapped in the TD in
> its protected memory. KVM keeps a copy of the private GPAs in a mirrored
> EPT tree within host memory. This "mirror_pt" attribute enables vCPUs to
> find and get the root page of mirrored EPT from the MMU root list for a
> guest TD. This also allows KVM MMU code to detect changes in mirrored EPT
> according to the "mirror_pt" mmu page role and propagate the changes to
> the private EPT managed by TDX module.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU Prep v2:
>  - Rename private -> mirrored
>
> TDX MMU Prep:
> - Remove warning and NULL check in is_private_sptep() (Rick)
> - Update commit log (Yan)
>
> v19:
> - Fix is_private_sptep() when NULL case.
> - drop CONFIG_KVM_MMU_PRIVATE
> ---
>  arch/x86/include/asm/kvm_host.h | 13 ++++++++++++-
>  arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
>  arch/x86/kvm/mmu/spte.h         |  5 +++++
>  3 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 250899a0239b..084f4708aff1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -351,7 +351,8 @@ union kvm_mmu_page_role {
>                 unsigned ad_disabled:1;
>                 unsigned guest_mode:1;
>                 unsigned passthrough:1;
> -               unsigned :5;
> +               unsigned mirror_pt:1;

"is_mirror".

> +               unsigned :4;
>
>                 /*
>                  * This is left at the top of the word so that
> @@ -363,6 +364,16 @@ union kvm_mmu_page_role {
>         };
>  };
>
> +static inline bool kvm_mmu_page_role_is_mirror(union kvm_mmu_page_role r=
ole)
> +{
> +       return !!role.mirror_pt;
> +}
> +
> +static inline void kvm_mmu_page_role_set_mirrored(union kvm_mmu_page_rol=
e *role)
> +{
> +       role->mirror_pt =3D 1;
> +}

Not needed, remove it.

>  /*
>   * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking propert=
ies
>   * relevant to the current MMU configuration.   When loading CR0, CR4, o=
r EFER,
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_inter=
nal.h
> index faef40a561f9..6d82e389cd65 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -157,6 +157,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_=
page *sp)
>         return kvm_mmu_role_as_id(sp->role);
>  }
>
> +static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
> +{
> +       return kvm_mmu_page_role_is_mirror(sp->role);
> +}

e.g. "return sp->role.is_mirror".

>  static inline void *kvm_mmu_mirrored_spt(struct kvm_mmu_page *sp)
>  {
>         return sp->mirrored_spt;

This one is also unnecessary BTW.

Otherwise looks good.

Paolo

> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 5dd5405fa07a..b3c065280ba1 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -265,6 +265,11 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t =
root)
>         return spte_to_child_sp(root);
>  }
>
> +static inline bool is_mirror_sptep(u64 *sptep)
> +{
> +       return is_mirror_sp(sptep_to_sp(sptep));
> +}
> +
>  static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
>         return (spte & shadow_mmio_mask) =3D=3D kvm->arch.shadow_mmio_val=
ue &&
> --
> 2.34.1
>


