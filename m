Return-Path: <kvm+bounces-48580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35838ACF695
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 20:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7ACE3189D99B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992641F099A;
	Thu,  5 Jun 2025 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="af2SaE7h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315ED1DB546
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749148234; cv=none; b=R0p8qcZWaWxwn54rIq7DCzy8JTRvmadmIDg7DGa6f/6RYCMeTgEwyBxVFKNY6lvLAVYOvQyCg19CMT4l7ulMDO8IJlLSPhXOk+h/0otbkSxs+v2nAbWqTpEjJKwHqabsz6bEHdhyz0PaKJHz2rwslCdoal3xr8VLyRC2n22pphQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749148234; c=relaxed/simple;
	bh=LnyQlmsP5i9Gpf9tYX7BjcukxJuRTi2gzqGvRKTWTn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlyjLdElE+wbHhKUuAXLns3DV1wBtDpWzikbeyqP4sCCoHtur0h2Kq16hGcLkyqAswSwbQ3WUgpbpEqiq2R1sLGm7ZSKhhVf5tMmkjgGTlFSihqMqtfem6Q+Ev8Dtod/0DaZvZtm3n6zRI5cZPNvarflKd21z51N0yYXYXZT3g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=af2SaE7h; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4a5ac8fae12so64641cf.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 11:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749148231; x=1749753031; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4HrdqA/k41LxSYTdKh0OWWXzlPloxAg6qTNcrag1JWY=;
        b=af2SaE7hIFovqmOCgjMSqeULLS/l9OZP0jRIDDJeEUtNMvkYIHgfAMZrR39g/KFqHG
         YJZRzgjVB1FN4e4EZYlNYFrZkoxdiHJjbkxTjwjNhRL7KkZ+Wrip7/ffwl324z6dIrPR
         Fn97Kk2QWCVQVeQCaHec6ci8PFVo8RPX21qXWALnq/c0cv3lhe0GPvZgy37o38AZ8aie
         AJwCvlCqr3AAulquP+wucKoptTJ4UkmY6eUpamWMA7AwDtg5hoSjcX1nUCxn+mySnXFP
         qoVA2P7+03q85YE/p23qPayJtse6GNtA5OnJzamqzlP45TTvVZFMgKAXnJ7ZvC8yzQBf
         UXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749148231; x=1749753031;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HrdqA/k41LxSYTdKh0OWWXzlPloxAg6qTNcrag1JWY=;
        b=ZFg3f7KwGrDDlOTwF+1Pr9tevZgqrTdDmDK+06VuJMXLMQHYCroYNaJfMj2k2gKykT
         dg99JZQ3drDXFh3weBFB+IyI8JoUCLax7Nc432wdRVqFaycwnDg37iL6gkNU6laXNUwE
         CwktfkTWpr+X5v/dW7o4L2DarSoDuLJC4oUBfuwONWGZR/CcwHumGcHoSPEf/OffyfCr
         sxPXdevC7ERxvoETHgtLnoBqHl+eHsQHf7JfUSgy9P0uHKTyYHKT37PMryQmQ4XitgZQ
         M2jNkkofOk3vtSdNIEALKCAzaTqQLeGvs46FUBHpQfLRJxxVR78Dj3vayCBp8z0KjrGg
         JtWg==
X-Gm-Message-State: AOJu0Ywr8fWOPNcQ08sPZccKeQ52RTLT0/mWlwzF9X68vCtPprdvpeK8
	qhO9JF4KOw+W4UWWdhHPa9ET9YDlxSIqoVfcI0DvLI87HGvuyAnEPoernv/WGk+55IeJ5lR9bfK
	u3PG0JUR1eXODo1J5+jNAk7fPMS5Um+aqxMTmkSJ+
X-Gm-Gg: ASbGncuQH8jeCrVWg1OA+ySV3p/cmqdrupS3+9KRvoMJYiMGqyAhWacIpQq8T6ZeVCl
	dWadz9LOoUCENGVVWEDCA2lMh2MtKB6WaAoI7qNx/4+XBv7eBCYDaqTS7OCfBQLices6F2ewx5m
	h4IVOS+x4cc6LlKiQsRnm0vhPzhesk7kSRzPSVo3lZgmI=
X-Google-Smtp-Source: AGHT+IH7FgESvCVozX/CiDB6ulbbev2isNZ+Soh9txr1mG6fDd4w52Z5DJcOcfE45agVq/Nr3QCWQsAjORWdDsJL18w=
X-Received: by 2002:ac8:41c4:0:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4a5baa649ccmr283761cf.10.1749148230605; Thu, 05 Jun 2025
 11:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com> <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
 <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com> <CA+EHjTw-dgn+QbHd5aCxjLXCGamx7eTr75qcFm+o16qyVydnBQ@mail.gmail.com>
 <637ffae1-a61e-4d68-8332-9ec11a3a78d4@redhat.com>
In-Reply-To: <637ffae1-a61e-4d68-8332-9ec11a3a78d4@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 19:29:53 +0100
X-Gm-Features: AX0GCFsQbfhZC_FlYPxk85rO768zb9vVPjsu-8YXphOrtD0BhntZritMMuHZreE
Message-ID: <CA+EHjTyxJ3VKqPF_9oswYAcbrJM3_MiYoExe6-Dx8A+0bZa+nQ@mail.gmail.com>
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

On Thu, 5 Jun 2025 at 18:45, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 19:43, Fuad Tabba wrote:
> > On Thu, 5 Jun 2025 at 18:35, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 05.06.25 18:11, Fuad Tabba wrote:
> >>> On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
> >>>>
> >>>> On 05.06.25 17:37, Fuad Tabba wrote:
> >>>>> Define the architecture-specific macro to enable shared memory support
> >>>>> in guest_memfd for relevant software-only VM types, specifically
> >>>>> KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
> >>>>>
> >>>>> Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
> >>>>> enabled.
> >>>>>
> >>>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>>> ---
> >>>>>     arch/x86/include/asm/kvm_host.h | 10 ++++++++++
> >>>>>     arch/x86/kvm/Kconfig            |  1 +
> >>>>>     arch/x86/kvm/x86.c              |  3 ++-
> >>>>>     3 files changed, 13 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>>> index 709cc2a7ba66..ce9ad4cd93c5 100644
> >>>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>>> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >>>>>
> >>>>>     #ifdef CONFIG_KVM_GMEM
> >>>>>     #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> >>>>> +
> >>>>> +/*
> >>>>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> >>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> >>>>> + */
> >>>>> +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> >>>>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> >>>>> +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> >>>>> +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >>>>>     #else
> >>>>>     #define kvm_arch_supports_gmem(kvm) false
> >>>>> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >>>>>     #endif
> >>>>>
> >>>>>     #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> >>>>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> >>>>> index b37258253543..fdf24b50af9d 100644
> >>>>> --- a/arch/x86/kvm/Kconfig
> >>>>> +++ b/arch/x86/kvm/Kconfig
> >>>>> @@ -47,6 +47,7 @@ config KVM_X86
> >>>>>         select KVM_GENERIC_HARDWARE_ENABLING
> >>>>>         select KVM_GENERIC_PRE_FAULT_MEMORY
> >>>>>         select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> >>>>> +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
> >>>>>         select KVM_WERROR if WERROR
> >>>>
> >>>> Is $subject and this still true, given that it's now also supported for
> >>>> KVM_X86_DEFAULT_VM?
> >>>
> >>> True, just not the whole truth :)
> >>>
> >>> I guess a better one would be, for Software VMs (remove protected)?
> >>
> >> Now I am curious, what is a Hardware VM? :)
> >
> > The opposite of a software one! ;) i.e., hardware-supported CoCo,
> > e.g., TDX, CCA...
>
> So, you mean a sofware VM is ... just an ordinary VM? :P
>
> "KVM: x86: Enable guest_memfd shared memory for ordinary (non-CoCo) VMs" ?
>
> But, whatever you prefer :)

This sounds better. I was thrown off by the KVM_SW_PROTECTED_VM type :)

/fuad

> --
> Cheers,
>
> David / dhildenb
>

