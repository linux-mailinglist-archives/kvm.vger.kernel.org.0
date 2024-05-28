Return-Path: <kvm+bounces-18230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D73E58D22BA
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DE5B2869D7
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9657E4437A;
	Tue, 28 May 2024 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVYxFiR7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F33E219F9
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716918220; cv=none; b=HrClqm2uh/1HNASU54N/JNkmkg1k7/IuUezC2Ch39PquQM4roK3EROlxuY+J7AdLPkiFmXTmL/Yi07HhkCzvhhrY3vwi8Wc5qkhT9hZfehWkUK2MMj+v2QuS8ujkYVXvP1Y0tRfMdpUkw2eOAKl+jYi/6JLQRwOLsavE6kfFvlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716918220; c=relaxed/simple;
	bh=5ss+AAnDNgpFoZHquQjyHRTVRnwByHqRQ9kN4FAyIBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AmR2CC9TdIZAhCQo2TQAJEFGMQAQ7lQGxOxZTgkJ/IAJROlfBJvNSqfCBlYU/L0Q1bh0buZybdNh3L4gxv+OVjbUk6XhJcr9clK2hH9CAWlpDn8kM/ZW/kFqyNhshV2LN6iKAC/OGyQedDAE9XDXcsCRiTcUGJVxFlnd0sthDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVYxFiR7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716918218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BgC1mBmX/uzbi9oKpLMQ8UHWTdsyAuGhZK7pefKFgjk=;
	b=FVYxFiR7vuapVfduGKV7y1zTQTQzLEHEk/bt21PvWk3Wtn9oN7CG/taz61XHppzIuLohpr
	sAPC2BfM9HX3gKGrvv79O9R0k8AUsvlOynFgrzy23xembVIc7lSRK0tkcuGd4baKTmzvOj
	KwlAASihzzxe42uvefsE2bJXUdtUM7Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-SKSVE-fAMLCTN4sonjZ0GA-1; Tue, 28 May 2024 13:43:34 -0400
X-MC-Unique: SKSVE-fAMLCTN4sonjZ0GA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42117a61bccso7939355e9.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716918213; x=1717523013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BgC1mBmX/uzbi9oKpLMQ8UHWTdsyAuGhZK7pefKFgjk=;
        b=N6tN26I3BrI89xzelS+Pc8x9kXD6UX3EPN/jWxrfFKMLpuZP1NVZx2ZgDGwhpthJjZ
         F4/PNzisV0uHfY3GeQuccoEZt0ETWoqih/P6tBFp//LZgh+E5LbldtZJNtc8foVq96uf
         Ws51emCpJhX9Kp7KlDTqe1mYn9g1VvthREpnwk5ePV7XmhHwIutWog7cCFT9XD8Px6gm
         o6qadYQ+dDkqtwiieW9/PSHLPK3esgCPHQEBSo8wqncw7DmaqVM/YjXsYfb2fO58Zd/o
         ZtrWRpz+cG4ewS7jId+iXrPuI1Eks/kLWp+OKxUZVYkCGuPpHV14Rfbu1snxbASWUmJI
         iX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3Jys20fx52FSKb7e9wynTACjwZRT0TKkaFOTdh4QMXuH4/cZWdQZz1rV+7aVYY4JD5IHEEZVBcZjQVECyPyR07Ygm
X-Gm-Message-State: AOJu0YxJmO948vr1kykDZBDFRZhu2auuc6Y3vN1T/4dbguFouAF1S4+d
	CYl162tC6Lcij9wueD8bqp+xMinWlg+ntPraHvXtKiEsCSyUwtu/UJ8B7vtvYgBXXpTaFVakMqf
	HkXUQRVk/PabD+dB3mj5BduQT7D5fNUpOpidsO76iGbqhUiEBJmvlLyDsFpTaqydtLYo6CbJm9e
	uT+OKgNn2zFFY3Bi8e3ZYlK2G0
X-Received: by 2002:a5d:5692:0:b0:34c:9a24:7a40 with SMTP id ffacd0b85a97d-3552fe19565mr8133820f8f.56.1716918213729;
        Tue, 28 May 2024 10:43:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF331e0QppI8ltPGCBE9BOpld9BHKKJ4O1No2M3EWSNTxEDCrihDkeZIocL+V45WCsid2VaNJL704Yanbx2wZA=
X-Received: by 2002:a5d:5692:0:b0:34c:9a24:7a40 with SMTP id
 ffacd0b85a97d-3552fe19565mr8133794f8f.56.1716918213277; Tue, 28 May 2024
 10:43:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com> <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com> <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com> <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com> <20240520233227.GA29916@ls.amr.corp.intel.com>
In-Reply-To: <20240520233227.GA29916@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 19:43:20 +0200
Message-ID: <CABgObfZSdXLwH4cMZGz5KmqxVM04pg7RMyRUs6bT8tXFWRUURA@mail.gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 1:32=E2=80=AFAM Isaku Yamahata <isaku.yamahata@inte=
l.com> wrote:
> +static void vt_adjust_max_pa(void)
> +{
> +       u64 tme_activate;
> +
> +       mmu_max_gfn =3D __kvm_mmu_max_gfn();
> +       rdmsrl(MSR_IA32_TME_ACTIVATE, tme_activate);
> +       if (!(tme_activate & TME_ACTIVATE_LOCKED) ||
> +           !(tme_activate & TME_ACTIVATE_ENABLED))
> +               return;
> +
> +       mmu_max_gfn -=3D (gfn_t)TDX_RESERVED_KEYID_BITS(tme_activate);

This would be be >>=3D, not "-=3D". But I think this should not look at
TME MSRs directly, instead it can use boot_cpu_data.x86_phys_bits. You
can use it instead of shadow_phys_bits in __kvm_mmu_max_gfn() and then
VMX does not need any adjustment.

That said, this is not a bugfix, it's just an optimization.

Paolo

> +       }
>
>  out:
>         /* kfree() accepts NULL. */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7f89405c8bc4..c519bb9c9559 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12693,6 +12693,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
>         if (ret)
>                 goto out;
>
> +       kvm->arch.mmu_max_gfn =3D __kvm_mmu_max_gfn();
>         kvm_mmu_init_vm(kvm);
>
>         ret =3D static_call(kvm_x86_vm_init)(kvm);
> @@ -13030,7 +13031,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
>                 return -EINVAL;
>
>         if (change =3D=3D KVM_MR_CREATE || change =3D=3D KVM_MR_MOVE) {
> -               if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn()=
)
> +               if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn(k=
vm))
>                         return -EINVAL;
>
>  #if 0
>
> --
> Isaku Yamahata <isaku.yamahata@intel.com>
>


