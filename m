Return-Path: <kvm+bounces-47253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EE4ABF11D
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 12:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AFDD8E12E3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B308C25B1FC;
	Wed, 21 May 2025 10:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hFGQbFua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549B725C71B
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 10:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747822397; cv=none; b=CrVZtXokvT0sLWODX8ogMIOtSqlWDgy+6oxL3ZTkGhzF/VlTs6Kw0AtpE8VNnTqEZKO9sZqHLtVTS0pNXZZu2gNhP7uYHNFF/BsKu+Frul+OB2qSZEkyFOcNGJUJ866qPItcSnYDRT3Hyz4xsYaj6191vpzW11JlzsqxxHWNGCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747822397; c=relaxed/simple;
	bh=m83btPvFhxbMayVbe9ilisXmcIu5rZKCaqS5e/Ewk9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A7+9tOECOJtDsTxn6RPf/ub8FLlkLm9q5TbeDj60PIRKbMeYyYEVXkRJjtQDQ52Rq2DdaDwyfWSaNF91NnToJA9nT8bKElsKutVVbYEuIianTvIFahwRyOyMqg+JbbXeQSyzYAEBL4HOjlA0tQar6rq3pQPA9tUI2x/L90BSqG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hFGQbFua; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-47e9fea29easo1628201cf.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 03:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747822395; x=1748427195; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d5QSndPkKAQ5vtrh+loQIW/5wevzzB6SrBoHRCKbDvk=;
        b=hFGQbFua/9mHiQlDSpGBT6Q0/mr3vnnP1nJAygPkwpsVAdclFbyVJ4/iS2xhJxCjwu
         GArUgUgyCjVBU37FmM5ZQadHlB8WQKtWrqHnDUBmy5W5ZVGF0lfhmTjIV71ySbjBoYH2
         3zn2+aaGS48JPTe+Z6S3toUaKe2qxOgMKxkXHXq0R1fVTaNoouz3MeEhqWyUyS5H3qHf
         VPCPpTbwdAp2WU96BQxSF2KpHnnJ6uu2M03AbjoDIeOzcx08ig/s9iUkE4G6Sg7kdmvK
         az2nNLJHKQtXMYPOCQxMApUxKPj2H42dt76wtjrE39MSRWUoSGzKWS2oTX5oZdA3jPsP
         I0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747822395; x=1748427195;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d5QSndPkKAQ5vtrh+loQIW/5wevzzB6SrBoHRCKbDvk=;
        b=wQkBnIDrS3GAdypDvLL76k3QjnzaV27w7uZ+fvimjA48QVN7j0T8Z8U8l/6yfblRM+
         C8E7ZBgBLLIZQky78TFG1B3rKf5BQs2Q3CzHYU3fjmojjszD/ezMRbf/4RYss1XorrYz
         a/ie/LutI8KbY1ZSkeSdFaaf5QbR9pX4ewjzVQ7munymYTMX3zMTQSKsteebYT/Yez0i
         PunSFcKB4mDW/O7w99bsuMyJhTj6JHjWu/XirGsXgGCw1oeKMqouDKZq3Z2koqknepEz
         UnldKyR2z13RhiSjWczFLTwRL1IO1MNO+Yw7NrqxyAA3GQ30+H92WgFavH2oVyahPDlP
         TgDA==
X-Gm-Message-State: AOJu0YxrNXI88NP0RBuHsxvw2fpmFF+Lvw19oFxbUndI8Jax7UQ7IZyW
	3SISLiE0oeAtQPdYkZFxHz7OFXQkTNt8FXs/HSJ2gPPCnyihih1uj+tsqSAhdgi2WV8uAWViEf5
	B0iw0k8jwjv8e4Bz5nOIgzhKyEbsXsGsoqT6feCn1
X-Gm-Gg: ASbGnctdt5wKjlKcybBxDWogqkx8t8G7LvT2HnddYcc0iRY8uQVU0im1DgbpOYJtnA5
	CCtfeTylweVepAbj1rg7JSuQb9zWQC6hfA2ty8XeMpm3zl7hDcpcnSIi/+QuRvG6rH5yhxaPv3k
	beJUx5H/gU8bFnwmZhnDvEXtQbP1nY4ehsRJd0X3C174m/uF1mYCVDYfbReB+QZxnRreyy3VYD
X-Google-Smtp-Source: AGHT+IFBSwGTdaQw/b8ps6ywr/tb178e/gz6GEZe1xfE1CXyjCsW9YbGLGngSw4suyfsuW4AGbCdMTzW2uSsF1TF0qk=
X-Received: by 2002:a05:622a:1826:b0:494:af4b:59fd with SMTP id
 d75a77b69052e-49595d52c6emr16768151cf.18.1747822394826; Wed, 21 May 2025
 03:13:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-15-tabba@google.com>
 <2084504e-2a11-404a-bbe8-930384106f53@redhat.com>
In-Reply-To: <2084504e-2a11-404a-bbe8-930384106f53@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 May 2025 11:12:37 +0100
X-Gm-Features: AX0GCFs6mm4R5LsozR4hLz8YIdTF39WQ3BoVlZqAx_u_jdRTh6jdrQkuKqVFCts
Message-ID: <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
Subject: Re: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
>
> On 13.05.25 18:34, Fuad Tabba wrote:
> > Enable mapping guest_memfd in arm64. For now, it applies to all
> > VMs in arm64 that use guest_memfd. In the future, new VM types
> > can restrict this via kvm_arch_gmem_supports_shared_mem().
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >   arch/arm64/kvm/Kconfig            |  1 +
> >   2 files changed, 11 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 08ba91e6fb03..2514779f5131 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
> >       return true;
> >   }
> >
> > +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> > +{
> > +     return IS_ENABLED(CONFIG_KVM_GMEM);
> > +}
> > +
> > +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> > +{
> > +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
> > +}
> > +
> >   #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 096e45acadb2..8c1e1964b46a 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -38,6 +38,7 @@ menuconfig KVM
> >       select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >       select SCHED_INFO
> >       select GUEST_PERF_EVENTS if PERF_EVENTS
> > +     select KVM_GMEM_SHARED_MEM
> >       help
> >         Support hosting virtualized guest machines.
> >
>
> Do we have to reject somewhere if we are given a guest_memfd that was
> *not* created using the SHARED flag? Or will existing checks already
> reject that?

We don't reject, but I don't think we need to. A user can create a
guest_memfd that's private in arm64, it would just be useless.

Cheers,
/fuad
> --
> Cheers,
>
> David / dhildenb
>

