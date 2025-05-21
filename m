Return-Path: <kvm+bounces-47257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C23CBABF19F
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 12:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C4B173279
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906D625E446;
	Wed, 21 May 2025 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEoOn2H7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E79825DB1C
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747823394; cv=none; b=qKE1i3u0Ye0XuZQdTPVhni4IzGYWmU2ctLDnPhAqqvilWBA/g6aq33dLtOdxSqsRAW3faQ9b7J7kSuQVMD6eJWQ7b9nNYAwv66v04RvcJiGxeUH0MWarn51YlzSjQmN9O63gLg0HmnOs3ccN9vVv9XVSFFdQxKAn7T3EsLSAMqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747823394; c=relaxed/simple;
	bh=ZkHj+kg61/z+IEwlQ0+ggT4xnMCs60FN/wXZNGb2mFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nRLGU5c0xGVNCyJFQgELNYYBQY+10tNBUpAv6Alq4um0DAnEoDcj6OQBLj9X7Mt4fPR20oZEAoHXvhCbsxCWNxkFSVF9OX461MH9LVLTNlpsu1zZJUsdIt6Ladnz6vMLp5UNo7+brhhYz4CZpm9oMCyCxn0VgHbfZsiEoovAC4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mEoOn2H7; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-48b7747f881so1389191cf.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 03:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747823392; x=1748428192; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LS/q/Xqm57jDra6kJD1/9ABO+ZjNU6M5tBzG/N+TE04=;
        b=mEoOn2H7BBhhLviGe2SUYcsYYcwrtx8U/E7A7D/hBLU2w4P04xshuSCg2HQA8+898O
         uaKjCPgae+4UBV2yhn/nJh8N71gAKzDzgTGAtG8PteUmsxFsHvtvCgY2rME0gjNauCnK
         idyHdOCrQrF1fHDESPJfMz4mE/2Bg1j+ZekMGBv23Gdl49vI6qMlqwFS+tYGjAJVyK3n
         +XiKIz2P4uKmimmTkT5vLGlYEeqzbHyBLg9EEMx7aCYmiB17F9oSpzQmKCZW/PtubTWu
         DMAedDujhIOXE/sLkyw8gHmmRyA/z3iYp94G5/NlfmNL9BJUindlzt1txXH/OPVYZcJB
         8FRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747823392; x=1748428192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LS/q/Xqm57jDra6kJD1/9ABO+ZjNU6M5tBzG/N+TE04=;
        b=avrO3W6ZWmImHRt8c15co9G799HM30c6PXT3MFswAR0Fu0R2rJfTHQ+ZgBNAm2+XGL
         idMLUJMIpRoBE4cH18eBx0l4/SlTWzlql+G2aLyee5gQ1YoPa2gTv6Z48qi6nC49nVxy
         MkTms7Wxq0aHHegDlpsCKld0OdgLUVOjDJa2/QIDspZMnq5t9fH/zsY9PCGCRnIaFrv+
         6IaY+qM17HaWK/MB185DZWsD9x7kOcCZlHKbk4lUOGMspJXfqY4zpy+1uBhcdk+4yQrL
         gCRCZJNKjzTc/57t1ed/tNG4PLQZSyFNLEQUpygioA3mACoD1Mr97HysixwQ059MG6Ha
         rcHA==
X-Gm-Message-State: AOJu0Yxwd1DK3X8+bps1mfFZb3oy3iv5KsMHNlnW9ESM/KRqe6OIswR/
	P45R3cvgzFtdJyj9qA59N3+psFvU/HNfBHEfvi8w3YpskSOz/KC+OFn47EmWgeCU9FLY4DPwsO6
	U5d6gssqnjXUaVIUfyWOwtVPIJhpQtwsdMkQ7fSeN
X-Gm-Gg: ASbGncs73MbJtRrWEJQbLoq9L+P8pHtrKO0iHulNvaUQVnPYSy5LSHQhPsaoEGrol4n
	644QYmyfvmiYlkFRuvHKygAchCN91qG8UcLsR9+D4pPfk8wqGYXxrFB5OYWC/t8qKjoWq61K/Xm
	jRNGbabI0ep/IpFSMcFglq6ZyWyg1prwzkSvPbRrkAlBTUSO9xYAU6D3aiCareVaeGj5jqQand
X-Google-Smtp-Source: AGHT+IFa/+nuwKHhuv405C1/QA7LzwIHaKLgKUa3xINuyOP9FO1wNH6D98dRYDdnD5Y6pR5oYmZ/tiws31p6X75UxrY=
X-Received: by 2002:ac8:5946:0:b0:480:1561:837f with SMTP id
 d75a77b69052e-4958cd27020mr15929471cf.8.1747823391740; Wed, 21 May 2025
 03:29:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-15-tabba@google.com>
 <2084504e-2a11-404a-bbe8-930384106f53@redhat.com> <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
 <d5983511-6de3-42cb-9c2f-4a0377ea5e2d@redhat.com>
In-Reply-To: <d5983511-6de3-42cb-9c2f-4a0377ea5e2d@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 May 2025 11:29:14 +0100
X-Gm-Features: AX0GCFtp1C5WS7koE3vXh__qYSYt1ZsWt-4VJOAZFQTaZFrfaysMtz-msa--LUE
Message-ID: <CA+EHjTxhirJDCR4hdTt4-FJ+vo9986PE-CGwikN8zN_1H1q5jQ@mail.gmail.com>
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

On Wed, 21 May 2025 at 11:26, David Hildenbrand <david@redhat.com> wrote:
>
> On 21.05.25 12:12, Fuad Tabba wrote:
> > Hi David,
> >
> > On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 13.05.25 18:34, Fuad Tabba wrote:
> >>> Enable mapping guest_memfd in arm64. For now, it applies to all
> >>> VMs in arm64 that use guest_memfd. In the future, new VM types
> >>> can restrict this via kvm_arch_gmem_supports_shared_mem().
> >>>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >>>    arch/arm64/kvm/Kconfig            |  1 +
> >>>    2 files changed, 11 insertions(+)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>> index 08ba91e6fb03..2514779f5131 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
> >>>        return true;
> >>>    }
> >>>
> >>> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >>> +{
> >>> +     return IS_ENABLED(CONFIG_KVM_GMEM);
> >>> +}
> >>> +
> >>> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> >>> +{
> >>> +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
> >>> +}
> >>> +
> >>>    #endif /* __ARM64_KVM_HOST_H__ */
> >>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> >>> index 096e45acadb2..8c1e1964b46a 100644
> >>> --- a/arch/arm64/kvm/Kconfig
> >>> +++ b/arch/arm64/kvm/Kconfig
> >>> @@ -38,6 +38,7 @@ menuconfig KVM
> >>>        select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >>>        select SCHED_INFO
> >>>        select GUEST_PERF_EVENTS if PERF_EVENTS
> >>> +     select KVM_GMEM_SHARED_MEM
> >>>        help
> >>>          Support hosting virtualized guest machines.
> >>>
> >>
> >> Do we have to reject somewhere if we are given a guest_memfd that was
> >> *not* created using the SHARED flag? Or will existing checks already
> >> reject that?
> >
> > We don't reject, but I don't think we need to. A user can create a
> > guest_memfd that's private in arm64, it would just be useless.
>
> But the arm64 fault routine would not be able to handle that properly, no?

Actually it would. The function user_mem_abort() doesn't care whether
it's private or shared. It would fault it into the guest correctly
regardless.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

