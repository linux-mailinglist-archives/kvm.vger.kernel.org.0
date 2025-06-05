Return-Path: <kvm+bounces-48557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C31D1ACF3DB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3407189C892
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430EE20D4F9;
	Thu,  5 Jun 2025 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W87IsDVL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA581E834B
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749139924; cv=none; b=fVUwADqZ6vtN9sNfdduZrgDiYVZYsA4LBTJw1/zbUMCLhoYr+IZgGdNyjpabIooijkNHCDzAlYWUT/rkixM+JLHogiBvVNMkO9eGze3ivwsOpQv0yXFKQyUXOh/OTJiVjtPqMWO6cJ+pTZIgZ+CzZlEeJs6ACNFqI/mr9ai7CmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749139924; c=relaxed/simple;
	bh=6lOtFIHKrjKKY2yPe3PXFI2Tfr8nvEQlzUWoA9G5Tr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WtOY8XibiKcyQTnuJVThNbC66iOoFKLnh+80geJkjFLYq+On4qis6X5lR8UmuB2/L1jCnTTV6er4B6vUTf4upiU7Z8d5pctRDId4pkUDfNuh1TAK3vjSQFlxUsh2fVBwwiu/HAlL8sAmWqO90l9ekgOtDtcYKp1FhA14FV7aj3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W87IsDVL; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a5ac8fae12so745411cf.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 09:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749139922; x=1749744722; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AVQTBJlbhCkTd304Z8LDEkMLDfW8IzBGu64gE9FirnM=;
        b=W87IsDVLiSz3tkY8DX+o0s2VukksrL3OZZ6zDA9BTK+mjdu1zXx4TF3ZkU34ELr6f6
         xzH7JHxq0829OXmn8Q6MLarC3D8EEHwRGt3W3fce8sHrcb/ewC/BnCpGaxt3r+JeBb0C
         vzw+ewJmXh/nWjmuH4RCqGe0GXQJlNCdm4jL/f5twWtGjawqk1IV2S0TR7iVG5Pp/cun
         cw0Dh2xiTFO093lvQW8jhiJqCnx3U/V27/m/Pd+jD6JZSgigogqMA+YTgQCw+EBsYGwp
         iaF1B8dazSVVLI3uQTB9zi7qJaeQ4dsPbVFjy5majc31/zZP4/8i4Uu9PHy/lFsCbdPR
         zgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749139922; x=1749744722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVQTBJlbhCkTd304Z8LDEkMLDfW8IzBGu64gE9FirnM=;
        b=iz+T3Vyn5alo0wtXY32cPAclJZP5AcZKXi2j3ao8D0KMkOhBci/9on3YK7bNE15oG6
         vliZojJIlhiCBGpBZHHTDH5T4pfqAftS7t45JCwiO06HQ0/O7RQgsH6JQphmk6NO8gs+
         NQbE30V3m930omu3XcEnZ+L1qgdRcIwBj49fmhDX9f2YIzINF5jrXB4axI5IXROhPskv
         PrPDwycCMTG4fFrg1nrP46SqaBFtxMF1TqhPwvJwIpZ+5Ix+Ubh0g2rI2YUei2tW5YI4
         BeEt9/kLYfG/im7rp2i3EzQwxl9OPaudFPTjaxAR2EKE0R1RE/tTbRbeFgW14SqVxejq
         bUgQ==
X-Gm-Message-State: AOJu0YyhkXHMtuvb7+lrdgqPT8SV4qWZ1efxQ7o9+DsE+1/XuY8mSsfA
	/T9H76+X5cZ0qIDqplq4XOk4+WdI3DpUFPpVvOCm5gZLoEA+DUpz12mDfC9PFkvYgcywAhTd3qW
	opZcfQdihqqNogAcVtejfKaWj+wniUmnviGETICTE
X-Gm-Gg: ASbGncsT8L/90R8OCuChCOTO78HQRSlixDGrqnVZE93INeWIj4lHLTi4Wfi6+ECYda7
	2FdAL4LxlmgNt0wWTo/gx6RVYGBeLghhBXAfunFB0Syz3DC9VcIPpRdftSjTGDN0FTLksWBfrIM
	LRqbPJ9seSwAGJWRmC6BgQSi5IUbW89kq5BFRNJsjVB+s=
X-Google-Smtp-Source: AGHT+IGW1AVosxjNsFSIObbIwdEXbd942cmJ5pLbHiwd321kOxoWe+7++7JtO3HfWK1XkI6NzVd1UixGjAX3NzyuEHY=
X-Received: by 2002:a05:622a:1e19:b0:486:a185:3136 with SMTP id
 d75a77b69052e-4a5af3be5femr4553531cf.14.1749139911983; Thu, 05 Jun 2025
 09:11:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com>
In-Reply-To: <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 17:11:15 +0100
X-Gm-Features: AX0GCFvM0cIQHeoKF8w2gaIC3qDuLSImbI5TRY95h3Mg5SfZMXcAsghCvn7NJBM
Message-ID: <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
Subject: Re: [PATCH v11 12/18] KVM: x86: Enable guest_memfd shared memory for
 SW-protected VMs
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 17:37, Fuad Tabba wrote:
> > Define the architecture-specific macro to enable shared memory support
> > in guest_memfd for relevant software-only VM types, specifically
> > KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
> >
> > Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
> > enabled.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 10 ++++++++++
> >   arch/x86/kvm/Kconfig            |  1 +
> >   arch/x86/kvm/x86.c              |  3 ++-
> >   3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 709cc2a7ba66..ce9ad4cd93c5 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >   #ifdef CONFIG_KVM_GMEM
> >   #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> > +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> > +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >   #else
> >   #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >   #endif
> >
> >   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index b37258253543..fdf24b50af9d 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -47,6 +47,7 @@ config KVM_X86
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_PRE_FAULT_MEMORY
> >       select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> > +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
> >       select KVM_WERROR if WERROR
>
> Is $subject and this still true, given that it's now also supported for
> KVM_X86_DEFAULT_VM?

True, just not the whole truth :)

I guess a better one would be, for Software VMs (remove protected)?

/fuad
> --
> Cheers,
>
> David / dhildenb
>

