Return-Path: <kvm+bounces-52139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D74D5B01A55
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D9F55A6AC9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 11:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC45289E04;
	Fri, 11 Jul 2025 11:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+iNk6mf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919E81F12F4
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 11:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752232200; cv=none; b=jYsSyZ8ouLs5I5/Dag1xyBcg3GGqiiPuJ6r+B2LH00vvA7C4wJmv/aIrp5WQipzyRiIrk46xYxvGcCR+GlI+PFBiIIO40XsPSxLBJgb9eBzdSQviWfTI52LIuwrsJRrI+nltDpP/jOMc/Cho8Z9+QOArZzmVdAD67L90hoT70IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752232200; c=relaxed/simple;
	bh=85A02jJf5WEx+s1nM2l46kcEE5hoPxUVck5YTP4i3e0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C/tNi0F6Lub/FFEaoFWeXAuTmS3u6lXg+IK08/N1ldqm4IhMJN8gVw70y18dwA6su0JHZ62pBMowpSuBXWcT+n6gbe3HqlNqR4olv4tNOvilrYqBA/js5qozTmyuWwe5MuZRKumvMj1nUMxpajOjCvvjyqiYrLdDX7I653Paycg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a+iNk6mf; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aa2cbc016dso122701cf.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 04:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752232196; x=1752836996; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1adRS81oh+n8n4i/QBjxAv/fs2/9/zd1hp4GUeUvO78=;
        b=a+iNk6mf9OzMZiiC7K3OJbaPq4LJEXN4qlhfB27wIswkFp0JXlkYUv/Ovd7TGvru+P
         4mENohTo0D1yUfRMFw0dzLmAY6qPM90Xt2aqU+7rxMp9NkRKwdi+uY0qIrQkAClEOqkr
         DgyUsnRTKx/tX8tF6F8O+3I++QyOI3YEoGQOgi4BTyH0tFFggHf/zMfj3L3moVC1WvRR
         0HuuQ0RosOMpq4lgRDGXy6R1XbETaGeKx7gvEGHk0utphWUwvGc25V5eUbVvr0ZRfWmF
         7O91A7OhQ0S/11SQZdFGt66OT2EZfA7WI2H2s+P1ZK0O6xOy/RizmtqubEuCOqrUupD/
         Puug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752232196; x=1752836996;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1adRS81oh+n8n4i/QBjxAv/fs2/9/zd1hp4GUeUvO78=;
        b=K5BrdBUZFUjDlKA3TNkrCr7igVyORAWGKUcRA2NEi73lhwjCOhdvXahX479PT25dpB
         HgFstX2e9UdozSwR/hcHF3uhEMm8Qr7JS2DVlKcBNTOzsPgYppJgOAod7pdZ8+P/6f9n
         jDBMsxvl9N7NsrhS4uN4M8v9IY6SyMCpBNenPKxktQUIipOWj3BbRxWNq//YO/E21GLt
         ZLQyEuT8Gp/wCYpxAn9tHE5ZFmfNUCalcE6nbE2ZfWWMjSdvWEkF0HxUBHzONDC4h74d
         9vqsdBmFFdKlX6OLMZt4etPtBjkGj9cJuYiONn2ZoczGp1KXtX2qNkNOqMqXpPeM9Cy8
         FIEA==
X-Gm-Message-State: AOJu0YyRIeL2w/dZdC68tL3HCRRoXNKkIuGAL/2hR11RKKxRBc8FZCdG
	N7IoC+3on4aO5FJIYr7cqQfGMk/qO33EGm97oBk9TCkSGutTJi2vDlvnuCQrrCd5AtBi/sXDBN0
	RJLnYBInIzVMxbEapKL5I2HqAg7uSruIHSWOpoJRZ
X-Gm-Gg: ASbGncsDNZHEPi3mM/SSwfBv+nCkyYe7tDTM3sGblh/ktB5fWrqTchSiUPu801oJ1ET
	lW9PvV8k8bfmpcVp5ETrxYOsbwO8/t49/VOMWEzFNszBWEWbVxWq8ezmee/0oYtjLpsck2sExTf
	ydDiegi5YsMIbuBH1BliL9GQHtg8SRwC4sfg1eOycwVcn/WuGYlRe4rJLnvYJUf0y7riMbWeQRv
	5qQZUE=
X-Google-Smtp-Source: AGHT+IGBKlguTczLsGN7D7jbMA8nnKKR5d3w/jJqmzY0oTVBdGcJ/buS8qD/dIqG5s4GGMRAPLRGdxeOmdIRAnouGp8=
X-Received: by 2002:a05:622a:a916:b0:4a9:8b69:6537 with SMTP id
 d75a77b69052e-4a9fbf275d9mr2923021cf.22.1752232195939; Fri, 11 Jul 2025
 04:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com> <20250709105946.4009897-15-tabba@google.com>
 <6fc1edd4-8a3c-4cba-8779-461a16b5126e@redhat.com>
In-Reply-To: <6fc1edd4-8a3c-4cba-8779-461a16b5126e@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 12:09:19 +0100
X-Gm-Features: Ac12FXzb-fN6GfwAX5mOcl0uP18BvI0qeajeteMMtilzL-SP9ogjqoPftjSQs3k
Message-ID: <CA+EHjTyX5BEFUSBh0HFgrpfu16MprZuYiSp6N8mDt1C5XyYYwA@mail.gmail.com>
Subject: Re: [PATCH v13 14/20] KVM: x86: Enable guest_memfd mmap for default
 VM type
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

Hi David,

On Fri, 11 Jul 2025 at 10:45, David Hildenbrand <david@redhat.com> wrote:
>
> On 09.07.25 12:59, Fuad Tabba wrote:
> > Enable host userspace mmap support for guest_memfd-backed memory when
> > running KVM with the KVM_X86_DEFAULT_VM type:
> >
> > * Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
> >    the architecture-specific kvm_arch_supports_gmem_mmap() macro,
> >    specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
> >    This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
> >    the default VM type can leverage guest_memfd mmap functionality on
> >    x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
> >    primarily for private memory and rely on hardware-enforced privacy,
> >    from accidentally exposing guest memory via host userspace mappings.
> >
> > * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
> >    CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
> >    This ensures that the necessary code for guest_memfd mmap support
> >    (introduced earlier) is compiled into the kernel for x86. This Kconfig
> >    option acts as a system-wide gate for the guest_memfd mmap capability.
> >    It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
> >    and then layers the mmap capability on top specifically for the
> >    default VM.
> >
> > These changes make guest_memfd a more versatile memory backing for
> > standard KVM guests, allowing VMMs to use a unified guest_memfd model
> > for both private (CoCo) and non-private (default) VMs. This is a
> > prerequisite for use cases such as running Firecracker guests entirely
> > backed by guest_memfd and implementing direct map removal for non-CoCo
> > VMs.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 9 +++++++++
> >   arch/x86/kvm/Kconfig            | 1 +
> >   arch/x86/kvm/x86.c              | 3 ++-
> >   3 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 4c764faa12f3..4c89feaa1910 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2273,9 +2273,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >   #ifdef CONFIG_KVM_GMEM
> >   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> >   #define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_mmap(kvm)             \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> > +      (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
> >   #else
> >   #define kvm_arch_has_private_mem(kvm) false
> >   #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_supports_gmem_mmap(kvm) false
> >   #endif
> >
> >   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index df1fdbb4024b..239637b663dc 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -47,6 +47,7 @@ config KVM_X86
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_PRE_FAULT_MEMORY
> >       select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> > +     select KVM_GMEM_SUPPORTS_MMAP
> >       select KVM_WERROR if WERROR
>
> Given the error, likely we want to limit to 64BIT.
>
> select KVM_GMEM_SUPPORTS_MMAP if X86_64

Will do.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

