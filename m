Return-Path: <kvm+bounces-48575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BA3ACF596
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E053E3AE6A0
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DBBD278E5A;
	Thu,  5 Jun 2025 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I0RLEvct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126A718C06
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145422; cv=none; b=YvMhrvexHRztTZnCGOmI/1z/4zN7+6S9UrhsDZzgNwmsqf6qjHvOCVB2SMMrhXFWMYHMHmj3d3FpC591DHTO8m5zbZ5IgWW1yGzVIbut05wS9Nk7b9fYhYm4S3WyTyd/3tkx1LIhfrR6UoZclEc21DIqVJdumRZBrv0Dc3p8qZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145422; c=relaxed/simple;
	bh=6IbE76cGNJM5qHpMo9ixtF0wChLEBepSlKgRGQcpAhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BZi5hP4BpdTe7tK7MJElrscypf3Pfa4ElwRvMr0IfOrRHFzNr1804na90UNNtVJTsd9sY8+SqCcPP0fy7DXZZTI3tvLLtkn2Vhtrl1urnXjqt7Lp7OpgYhzsOB2m++CzkSMhu3y0UBzkjbDW+FP1tqC0bnZOo6sC0Yb0dWjfMWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I0RLEvct; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-47e9fea29easo40901cf.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 10:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749145419; x=1749750219; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z2CqoZ0AEAzoUtqdrcArln2L/gsL8eatF4pYDcOE/Uc=;
        b=I0RLEvctApZE5sju6xDInANy1WgORJNS/pnEbeshI0QhIUtGUog3gld9Ex96ZX03Xu
         BStrDE1tFCwhhG/wKFnMVG8XDERttJRt02uzduRRTe83Ndorfb8ai1S3ysQR7sSx1Imn
         EqmZl59W456Xj454p8HdpyosoeeyNQNs3YSKRrmdziDUEH1AynJJjqsGZQhGE3N4S86e
         Z699uLhVTHoj4s85VUP1AaLzhG6OjOuSDWUFeKL/GgWnggwnX+fRneHScZo4unAUSrvY
         DsSLOVIsCHjeT4l5cuRPn/WqGtMTs0EjcdYIXs78ueqogLE7KCu7Eq1h2njN0cYy/gzI
         DfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749145419; x=1749750219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2CqoZ0AEAzoUtqdrcArln2L/gsL8eatF4pYDcOE/Uc=;
        b=V7hMnwp1MhyQ2FSCeeb13x2OekqJ5CasTQLUCR31ALH6DdZwrQpdNGxsX2IPLV1jez
         So/RZqZEwI4jaK0aomepMmWrVRBhC1XpVvTrFDdEkMEtKMcj4PWRdBMlv3UN38C9ozDY
         LdapsNbpXpsiQU+0CunR3XG76U9c8fcxQ90MXYh9TUd4qfbd8nXNsYV68Y6/r9Cljqxk
         x57bM8BaSvMQO1juQtNoWhk9lGRosajIgfS4cVIltS1O2WEIp+T38YGtO0suoCZS9Pnw
         dn3N9XLYf/6eYYdIgPruFVGk6s0/MtUJ6NyOSJYA2RwKZxZWZv8blZZRY8yPAZKRp3qM
         ZPLQ==
X-Gm-Message-State: AOJu0YykLe5BnosVD8j6JG2Tu2L7srBY6N+cTpNTabN3K9mejn40+Pl3
	Gu9kxG9jxX27Z+f4igyUpneB0kQW2OOmevAacR+zuWo55S3MY8MCLC5o7QAmwFH1qIqXfgw+uU4
	pfMk0/thYw8R8KDVpC1oyyHR/5sUg8XR91V76k8dZ
X-Gm-Gg: ASbGncsZyyEzJLX+PM6T3AM/sfqd+iQXR9RNNzj9VyZ3eNvJJ8GK6hjGaFSiAROxDOP
	uDl8LBz4iyzjh5+d3WacUYARFahGe5+nKX9W/X21pRTCDrQc7ls5iGNgqN1ij06CzuhGqHkWblQ
	4ala2pVJIA264qXrwDwEJlosJ2VATAzJRVrq7jT0bvK28=
X-Google-Smtp-Source: AGHT+IExAG9FOhA/JYGGXSBKDCzqV2Xo5C2y6Ta3UELn/eRIfFUiL+Rqeg9GPUYw/hiNAJoKYymR8PDaqjOB4BS/zFM=
X-Received: by 2002:ac8:5c8f:0:b0:494:763e:d971 with SMTP id
 d75a77b69052e-4a5b0e31c8bmr4317101cf.23.1749145418575; Thu, 05 Jun 2025
 10:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com> <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
 <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com>
In-Reply-To: <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 18:43:02 +0100
X-Gm-Features: AX0GCFvljLgP25GVDAuLamDWQ4LY_vKhcAYVWztfS80gbr2QcR5zJxfpTOOCjHo
Message-ID: <CA+EHjTw-dgn+QbHd5aCxjLXCGamx7eTr75qcFm+o16qyVydnBQ@mail.gmail.com>
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

On Thu, 5 Jun 2025 at 18:35, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 18:11, Fuad Tabba wrote:
> > On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 05.06.25 17:37, Fuad Tabba wrote:
> >>> Define the architecture-specific macro to enable shared memory support
> >>> in guest_memfd for relevant software-only VM types, specifically
> >>> KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
> >>>
> >>> Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
> >>> enabled.
> >>>
> >>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/x86/include/asm/kvm_host.h | 10 ++++++++++
> >>>    arch/x86/kvm/Kconfig            |  1 +
> >>>    arch/x86/kvm/x86.c              |  3 ++-
> >>>    3 files changed, 13 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>> index 709cc2a7ba66..ce9ad4cd93c5 100644
> >>> --- a/arch/x86/include/asm/kvm_host.h
> >>> +++ b/arch/x86/include/asm/kvm_host.h
> >>> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >>>
> >>>    #ifdef CONFIG_KVM_GMEM
> >>>    #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> >>> +
> >>> +/*
> >>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> >>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> >>> + */
> >>> +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> >>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> >>> +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> >>> +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >>>    #else
> >>>    #define kvm_arch_supports_gmem(kvm) false
> >>> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >>>    #endif
> >>>
> >>>    #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> >>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> >>> index b37258253543..fdf24b50af9d 100644
> >>> --- a/arch/x86/kvm/Kconfig
> >>> +++ b/arch/x86/kvm/Kconfig
> >>> @@ -47,6 +47,7 @@ config KVM_X86
> >>>        select KVM_GENERIC_HARDWARE_ENABLING
> >>>        select KVM_GENERIC_PRE_FAULT_MEMORY
> >>>        select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> >>> +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
> >>>        select KVM_WERROR if WERROR
> >>
> >> Is $subject and this still true, given that it's now also supported for
> >> KVM_X86_DEFAULT_VM?
> >
> > True, just not the whole truth :)
> >
> > I guess a better one would be, for Software VMs (remove protected)?
>
> Now I am curious, what is a Hardware VM? :)

The opposite of a software one! ;) i.e., hardware-supported CoCo,
e.g., TDX, CCA...

Cheers,
/fuad
> --
> Cheers,
>
> David / dhildenb
>

