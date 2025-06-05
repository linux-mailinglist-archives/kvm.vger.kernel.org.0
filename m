Return-Path: <kvm+bounces-48573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CE5ACF556
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BA943ABA5E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE46C278152;
	Thu,  5 Jun 2025 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1+nRuE/a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4E13D521
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749144449; cv=none; b=vAYoFSsRP+UeXihhiqmFHbdpM3Nsijqi6hveoB5AxP3528Mtmj3VAz42Z9tU9tlTtWD7dSPlZV2TA58saW2bB1QDN+ozBWQ4u38WbWJxNAqt+PigPB0XhePBCcMy3H5kc9ugtKdmH88IRhEL2bBcAHphjVoHPbhByb7lQ0qsJ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749144449; c=relaxed/simple;
	bh=ypTCgnGwg5IbrjzUHrWEmJaTyMcNWrNCp7q14fmj92w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GApHe1fhWFv6JG2Xd80J1rO7U/TXLquReHghRdAB/LmKSLyPcOFwBJ2RxSoC+6Pm0nknO6MfRafZJ9oxOdZ3GiIKIGfiKSLx0rSvGZmCf8dDEKWF2hlXVT1cJcDaG16D6LVPaTXCQ6EziHb8/DEEYMgOL+S4P9EL7/tN3k4PQc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1+nRuE/a; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-70f862dbeaeso14445617b3.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 10:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749144447; x=1749749247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqnn2BaHL5jjvXNbCDh0HtrOgixx6puwO+NS1bohbRc=;
        b=1+nRuE/aCHG0mIfJVApShADo9kF5uWQn5nwCbwE7MZwwdSGtIM0pVfIFVa4EpwZ2gj
         OhW1dApT2qMyLmHV7QM6ZyMSYlFtqhb0g6zZSRrIYrHf4OIxILGihligPusI4njTuANn
         pbfnoXkYsGAtOMCtoX9OAKCFnl4s9ENjVPEZ+TzW3/HpE7GN9XqTMe4+YIm4i62Ts57S
         RuIP5f8F7vfpFDF8/KauedORNxH5vRjIh18sIyGNISV6+ObNCXuYAoBKM85Im9iUwGS4
         ddMJCL8YMeDHgyYDiJVGl1AhbF10m7l3Qa91LLp3StpN0KrH9rU/IYQaNKGviPl2O4hC
         7Pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749144447; x=1749749247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqnn2BaHL5jjvXNbCDh0HtrOgixx6puwO+NS1bohbRc=;
        b=SDp5eGh8xrY6+HC44uYOPL+SSGwONcN6lUJ2Y+5jfNWGBoHew1Bo1EbDBvrdUaFn5T
         0mBcm2FELZsF6Epg3V6toLOuq/HIztHQ01OKQGe4n8898CbbEKW7xjesrBMZg6Awu5Xa
         Vt+LncwbwJv7+oWGihjrHLKuJy2yla2rJOFzpG4t61//rscfGABZBzYeXfhsXCfYv8wr
         Ba0wQKmRU9Dd2FoRrYuJIB1H/oUqNaKRoiCe5ptMuh71dEZJtQBjAqxUfW0SzOBg9ZtX
         VTWFXdiuDzhYvB54ZjXODAFGag+SWdFCazmw0Z05WP5Q3KSjVnjoq1hqSMvVQxrzhX0e
         02BA==
X-Gm-Message-State: AOJu0YwTq7M8lgEyeRYV1CvA7Y+pPfknxrJL7DsniXDtN/pW6vtjCXK0
	GGZiQY1U2ZC0tg5pjQQMXYewV8oiulX6ufRAsNep4OoiuTxMCY8w+dyQsBw2mriy/oLDzTxj3x6
	m4/weTm7OdYPtWg9Tp4je10/2Ma5vkZJktAZ9jb24
X-Gm-Gg: ASbGnct5uscS1rPAKF9veKxKlZgHRuY1NHJoN6+hP58pEpM8yz8YKFsY3vdlJDP2JQ2
	OqCsdwUXvWC6lwfnZmZYn/64tNi9e0Yqi09PSVrN1wpNFyLi/KJcdV5ct1lhE0dScJzMHoEgukh
	KSazX4wqZqkohm13ZSvZC3eu6zKS2A93wqmRzSToaUbSiwzLsoiLDZVL9QlrL9pq24kKxKdjfMa
	A==
X-Google-Smtp-Source: AGHT+IHn5/wKNbQI7vSalTh67RacBOPcQxELVMGr9+xQc8VXWu2LJeEyltIok2m0x5MIgx3zLGdGw/XrfKms7dj72v4=
X-Received: by 2002:a05:690c:998b:b0:70c:d256:e7fc with SMTP id
 00721157ae682-710f76860c0mr3864297b3.21.1749144446771; Thu, 05 Jun 2025
 10:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-16-tabba@google.com>
In-Reply-To: <20250605153800.557144-16-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Jun 2025 10:26:51 -0700
X-Gm-Features: AX0GCFsB1VCQwR2A3HvXMZ_dWbE-qcPDzOfRtnENxU5ylhm95m2ctpABU2Dvxt4
Message-ID: <CADrL8HUaHAD2Gp7k2uRAper2aMmem39dM9e=ydKMAqvJ=eDxKw@mail.gmail.com>
Subject: Re: [PATCH v11 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote:
>
> Enable the host mapping of guest_memfd-backed memory on arm64.
>
> This applies to all current arm64 VM types that support guest_memfd.
> Future VM types can restrict this behavior via the
> kvm_arch_gmem_supports_shared_mem() hook if needed.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  arch/arm64/kvm/Kconfig            | 1 +
>  arch/arm64/kvm/mmu.c              | 7 +++++++
>  3 files changed, 13 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 08ba91e6fb03..8add94929711 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1593,4 +1593,9 @@ static inline bool kvm_arch_has_irq_bypass(void)
>         return true;
>  }
>
> +#ifdef CONFIG_KVM_GMEM
> +#define kvm_arch_supports_gmem(kvm) true
> +#define kvm_arch_supports_gmem_shared_mem(kvm) IS_ENABLED(CONFIG_KVM_GME=
M_SHARED_MEM)
> +#endif

Thanks!

> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 096e45acadb2..8c1e1964b46a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -38,6 +38,7 @@ menuconfig KVM
>         select HAVE_KVM_VCPU_RUN_PID_CHANGE
>         select SCHED_INFO
>         select GUEST_PERF_EVENTS if PERF_EVENTS
> +       select KVM_GMEM_SHARED_MEM
>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f14925fe6144..19aca1442bbf 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2281,6 +2281,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm=
,
>         if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu=
) >> PAGE_SHIFT))
>                 return -EFAULT;
>
> +       /*
> +        * Only support guest_memfd backed memslots with shared memory, s=
ince
> +        * there aren't any CoCo VMs that support only private memory on =
arm64.
> +        */
> +       if (kvm_slot_has_gmem(new) && !kvm_gmem_memslot_supports_shared(n=
ew))
> +               return -EINVAL;
> +
>         hva =3D new->userspace_addr;
>         reg_end =3D hva + (new->npages << PAGE_SHIFT);
>
> --
> 2.49.0.1266.g31b7d2e469-goog
>

