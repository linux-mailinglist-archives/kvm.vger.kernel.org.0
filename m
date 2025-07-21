Return-Path: <kvm+bounces-53014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C066B0C92F
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC274543F7D
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5002E0B60;
	Mon, 21 Jul 2025 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1nNTy1lI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF4B70838
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753117277; cv=none; b=SWnoxdlZBk6eKGEtkwwvKMsY+kYpNrZvZoUH67t4Ww1OPqA2uW05u3ZDDTFHzl1Vb8d1+AUvgGmwUjTLKfRJKr9dpCGwWlM+fEAby3s1jrh18zG3wSAjhPzSzxt1UnEUS0jDskGiMF9fft5PzlTARPb0rMdf9aImGWxW9aUUsco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753117277; c=relaxed/simple;
	bh=nJ55EMQUPVLja/Qbkea12G4WKE4JetlEY4Fh5E8peDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f9DH7rKkZlceaeUWeK9qwiOhjt9u1Lms5zG8uUw/KXKgzRKZ6pGggndUthsTmastelAnWfLTZFElwh0KCklzDZu+apvWBsFlC2TNKoIPI7DDM48QxIJ3SjKDokALur+33HLSMNd6GqxR3NN2K44YgcUjURuPwYJkizd7ChW+FMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1nNTy1lI; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso25401cf.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 10:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753117274; x=1753722074; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vt9ZwUF3fGDVyxUTkyz5qBpDl9or2ldYVWFaw2AS4MQ=;
        b=1nNTy1lIj1DHahmeTWwMvBlJefNYx0UFSCIIbWQ1ElWtKUeaLVMsoLkkU1rm81bL3A
         zbLrCjjd05rFmjEeIVA5bZTXSre7gN6oejv0TWpINB0BHJlc/h5bAIakpb6+qGB7mW1u
         kpvc8HejQKx/TU2+UK3FjpuyWDB8wlwBpn67EbvYR/hFCnxg3hbxBLWlbfUwIZlGJ/8/
         RO37SUw/O+gMMgRgA5whLW5dpTC+jEODF5ojmpkVAUazNoXxPpll+1/FGNgHhafYutfB
         B1SqdaRuXWHcOW2OCddJVbYO0BL8+f4XaMLt5ZIpia+F8DxS6ZAvNwicAvrk8lqTgfYT
         xNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753117274; x=1753722074;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vt9ZwUF3fGDVyxUTkyz5qBpDl9or2ldYVWFaw2AS4MQ=;
        b=mkfjnj0AjDPQmQz8Fv4xj9qPAvjpJClm3SohF3MVBMmVLXUC2p02ROAXvTMDvbt9A5
         tB8csrspNSahzdEHwV0p0soqJvnR0FU2hqcB9HpSnFO/Fb+Eoacr9gOjyhufZISJDvpI
         1RNJE5vR66+rv3gHsR6cIoBYP7xpsL+gxdmceMuwlqZ6Q0Jh7SW/XkOf0L1snn7cREqU
         R12jf0lVc1DvJlb6+jZcKBF29TD4A038kTm/6XFN7f+78B+3dAI0Rw30XH5Uma16vJ+m
         krm6edQSFLkWOQr/d15JXAhMK+UoMraUJxDyuTOhWwXlruD/FKGILYVXVWTCIzn/FOBh
         5Rrw==
X-Gm-Message-State: AOJu0YySS+G9PW6hWEtoyQuBBvcbCk+6cHWIDdwWOt62hW9ZG2yhZcvU
	DRnZ7uuMMGom4QEssmaKLF8U/B1hZ0+RhOMR2d6Mo9VzmAVxTZIVuZmpslTwcYIlFdL5JT8P/3V
	BjBOnXNxx/VgTOEX6q9SpuKc2Teb/Letm8nU1XGzd
X-Gm-Gg: ASbGncunm3q4XX5xZBilBqlAPTpEwCGv9z6VMnDu3A7uz4AxJAUjjaBffcOGWOdIBHO
	Nn1w8B5SF8F1L/VrYdBUXfF6GC2UXvom1yDApaKtxBfe+R2UZD0o5jgFVWBhQvxSChap4p2oVk4
	oYlQMb/YPV7iS4eiJckvfvb5NXOjQbsJuzzwJmgFbrKyJ8oZQEDiahQ75PsLL6xmQPeCRyfY1ml
	OAE9nc=
X-Google-Smtp-Source: AGHT+IE77xfZzLtUStJio5/gr2Lddfq0kwmTtubIneVZ36yQE9cl1kxCYy+WewT5qhlZD3J2u42dfcUp/sDkWx810Uk=
X-Received: by 2002:a05:622a:58cf:b0:4a4:d827:7f93 with SMTP id
 d75a77b69052e-4ae5b42ef1dmr687911cf.0.1753117273637; Mon, 21 Jul 2025
 10:01:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-5-tabba@google.com>
 <aH5uqeQqvzgJOCN0@google.com>
In-Reply-To: <aH5uqeQqvzgJOCN0@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 18:00:36 +0100
X-Gm-Features: Ac12FXwew5QLfnZj03go8Mjw4g5wc-UoRbU-fCLWG340Dw64JFHDBfVakMGYyDc
Message-ID: <CA+EHjTw766UKoLVoxGWDS2adq4m0TWsxwTWMGsjMK=qkSx4iCQ@mail.gmail.com>
Subject: Re: [PATCH v15 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
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

Hi Sean,

On Mon, 21 Jul 2025 at 17:45, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > Introduce a new boolean member, supports_gmem, to kvm->arch.
> >
> > Previously, the has_private_mem boolean within kvm->arch was implicitly
> > used to indicate whether guest_memfd was supported for a KVM instance.
> > However, with the broader support for guest_memfd, it's not exclusively
> > for private or confidential memory. Therefore, it's necessary to
> > distinguish between a VM's general guest_memfd capabilities and its
> > support for private memory.
> >
> > This new supports_gmem member will now explicitly indicate guest_memfd
> > support for a given VM, allowing has_private_mem to represent only
> > support for private memory.
> >
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> NAK, this introduces unnecessary potential for bugs, e.g. KVM will get a false
> negative if kvm_arch_supports_gmem() is invoked before kvm_x86_ops.vm_init().
>
> Patch 2 makes this a moot point because kvm_arch_supports_gmem() can simply go away.

Just to reiterate, this is a NAK to the whole patch (which if I recall
correctly, you had suggested), since the newer patch that you propose
makes this patch, and the function kvm_arch_supports_gmem()
unnecessary.

Fewer patches is fine by me :)

Thanks,
/fuad

> > ---
> >  arch/x86/include/asm/kvm_host.h | 3 ++-
> >  arch/x86/kvm/svm/svm.c          | 1 +
> >  arch/x86/kvm/vmx/tdx.c          | 1 +
> >  arch/x86/kvm/x86.c              | 4 ++--
> >  4 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index bde811b2d303..938b5be03d33 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1348,6 +1348,7 @@ struct kvm_arch {
> >       u8 mmu_valid_gen;
> >       u8 vm_type;
> >       bool has_private_mem;
> > +     bool supports_gmem;
> >       bool has_protected_state;
> >       bool pre_fault_allowed;
> >       struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> > @@ -2277,7 +2278,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >  #ifdef CONFIG_KVM_GMEM
> >  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> > -#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
> > +#define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
> >  #else
> >  #define kvm_arch_has_private_mem(kvm) false
> >  #define kvm_arch_supports_gmem(kvm) false
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index ab9b947dbf4f..d1c484eaa8ad 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5181,6 +5181,7 @@ static int svm_vm_init(struct kvm *kvm)
> >               to_kvm_sev_info(kvm)->need_init = true;
> >
> >               kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
> > +             kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
> >               kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
> >       }
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index f31ccdeb905b..a3db6df245ee 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -632,6 +632,7 @@ int tdx_vm_init(struct kvm *kvm)
> >
> >       kvm->arch.has_protected_state = true;
> >       kvm->arch.has_private_mem = true;
> > +     kvm->arch.supports_gmem = true;
> >       kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
> >
> >       /*
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 357b9e3a6cef..adbdc2cc97d4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12780,8 +12780,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >               return -EINVAL;
> >
> >       kvm->arch.vm_type = type;
> > -     kvm->arch.has_private_mem =
> > -             (type == KVM_X86_SW_PROTECTED_VM);
> > +     kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
> > +     kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> >       /* Decided by the vendor code for other VM types.  */
> >       kvm->arch.pre_fault_allowed =
> >               type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >

