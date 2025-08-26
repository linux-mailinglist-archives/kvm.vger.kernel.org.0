Return-Path: <kvm+bounces-55790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AEB8B373D4
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 22:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A5C5363420
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 20:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A001371EBF;
	Tue, 26 Aug 2025 20:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R6kmtMzm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA845338F40
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 20:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756240183; cv=none; b=kDakk48pTRdVf7z/bxfdgV6vUVrhDuyiszjLM2qR4KmuEMnLFq7SL3VgmXM+EZjR2XAdJ5a+cQERNPvqRV2tx/xTPVkY/UsL6ZjYus8ngwYPDJ25kre32sj8k1sWJP+BgIatskCD4Kwcup0ghH+rJCCRM/1cj7o+pFanI55XvzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756240183; c=relaxed/simple;
	bh=H0meGH/ZSIq+QjBVPczsfuW+8V+2uGvtAWeNY4II8fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiY3jiiTIQ0z1SPCxGBWCJbjVU7+nQ/N3Gh/bUFUwUXOqAdrOnJosym+cuZEAoMyqK3JEG3HJq7I78W0D04iFLA90h1DGNkBBqHxKnw/YD4QXQc0rWV/qxv0/EmHifqYC7a7c80t0FA9l/T/49XLGtyEHtxMlPJQZmp8OsGMFZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R6kmtMzm; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b2dc20aebbso124221cf.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 13:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756240180; x=1756844980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGklcsckZnycLXQ8v59Q73d4XcLOGz3ZB2f2pW6BmqM=;
        b=R6kmtMzm/To+8rTSoaM0n9UE2N3mMt5aWWYQ9o5wNf64KlXAQqN/D13kGylfj9D1xT
         pyBmXhC9F8b6J12ppZ2nU+o+QWEeExOlZGmuy9G3swkQQkmzp/4KOZwCKRIUtYazLdz+
         L8WAlKmPMeGiMvSJ9vttosXY+u4uGM9Kuxp3juF0nr0u8jdnV07/i2HsLCxFH402M2Q6
         pooBEFTyt++ME0Jpj2FdyN1xG+rh5SgAa0Kqd+eE2PqTC1u7v5UI2ONy8ySW3OnMc3cU
         t4+bBawYlNTIj/9/z4vL9xGSAKSzXwchhwGB4kW9fJxt+V7/BlqbPzlyt4Eqh6M5/EF3
         oQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756240180; x=1756844980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGklcsckZnycLXQ8v59Q73d4XcLOGz3ZB2f2pW6BmqM=;
        b=uVH8GKI8jkwQIfxp8PAqwLpeKTjduYES/3HPY5VPd26adL3VHYSnyH6ntIkBhiuTB2
         MRIJzrlGqZ8DvdX547TVGguO71SjI/0MjZmr9buARSs4YeHFhZLZxmyhwOwCSaoxz3VB
         0Vj6YA8k2X/T8QTRmuSFmaQ1D2IysqiSGtNeCm1QZU88iKProccB1HCythLkcRoLXom/
         M7BMqUnqXlnRGEOpKiLAjo9x69w9LoTglNrcY51IZu4GKA/UuwmtI/0yqhZuSCHIpRC1
         Fw7eb/ozeXEF80H4Vm/pJOLX1FdwFXjzxP5agWKABnip0d1F6zbGnxNu0c8E21xDonu8
         C2vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuFnbP8fJSnkKkbSMFjlLSEOiYCRt77qa5vrn093TvH0G2Hhby3fHN1mN3EIw34doAQIU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHsByhuQ0KM8rLI2zFVq1XfkX83kr8YdzAeET7uD5vPWkk1fip
	9tjpLYLh3mQz/wFnyLRFw+psSqYZpZdG8vPGwBvrNRuOxC7Gn6Wtm+IvEUMkOdl/XKwvpF10ttS
	XHVhaxVo7XJ7/hvHls2OiP7z5b3KwM/yZX7CCITz8
X-Gm-Gg: ASbGnctMA9ZhHGBu4IiYYF7y4ITYxNpZGpUJvZPQ1CEIGE54Nmzyt/f65qRgl2YTgP+
	N+WI82FM1afIpAYs/krzTjVithsQM1TPsgbBTV82ssG25nWcXUksYe+7rzIFssJJTGUFbOOnWP+
	/+aTPiHgnIOTRGrkiGUlE3sSfFuqfN4zZyzkiW1ubnxCCdgCcC4Mx3PWBf6OhSwXlGYRTUGw/Au
	nTjQN5XXsThtdxdUn9H9zX5f8N0bSUxcQMMHiw5gHZb7skWsWgLG/bLlw==
X-Google-Smtp-Source: AGHT+IEHOQk1sWwHD1cKD8+QqW+nxWvNVN9mCzhggckX5n0gDLLPC/qrllBed/EbQv8l6hMELcCbF6ojKTW9CqC7xro=
X-Received: by 2002:a05:622a:4d97:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4b2ecb6edecmr2721281cf.1.1756240179507; Tue, 26 Aug 2025
 13:29:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-16-sagis@google.com>
 <aK3vZ5HuKKeFuuM4@google.com> <68ae1604a387c_300e8f2947e@iweiny-mobl.notmuch>
In-Reply-To: <68ae1604a387c_300e8f2947e@iweiny-mobl.notmuch>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 26 Aug 2025 15:29:28 -0500
X-Gm-Features: Ac12FXz22mzFl3kMkPztCJvbyJO0AnvzFVkaIOQ3_J07KFwMWuTK-i8q7O91CqI
Message-ID: <CAAhR5DHPMPOb2XCJodyNMf2RTQfTZpAaCGMg6WeWxSWPLtkO4Q@mail.gmail.com>
Subject: Re: [PATCH v9 15/19] KVM: selftests: Hook TDX support to vm and vcpu creation
To: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 3:14=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Sean Christopherson wrote:
> > On Wed, Aug 20, 2025, Sagi Shahar wrote:
> > > TDX require special handling for VM and VCPU initialization for vario=
us
> > > reasons:
> > > - Special ioctlss for creating VM and VCPU.
> > > - TDX registers are inaccessible to KVM.
> > > - TDX require special boot code trampoline for loading parameters.
> > > - TDX only supports KVM_CAP_SPLIT_IRQCHIP.
> >
> > Please split this up and elaborate at least a little bit on why each fl=
ow needs
> > special handling for TDX.  Even for someone like me who is fairly famil=
iar with
> > TDX, there's too much "Trust me bro" and not enough explanation of why =
selftests
> > really need all of these special paths for TDX.
> >
> > At least four patches, one for each of your bullet points.  Probably 5 =
or 6, as
> > I think the CPUID handling warrants its own patch.
> >
> > > Hook this special handling into __vm_create() and vm_arch_vcpu_add()
> > > using the utility functions added in previous patches.
> > >
> > > Signed-off-by: Sagi Shahar <sagis@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/lib/kvm_util.c    | 24 ++++++++-
> > >  .../testing/selftests/kvm/lib/x86/processor.c | 49 ++++++++++++++---=
--
> > >  2 files changed, 61 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testi=
ng/selftests/kvm/lib/kvm_util.c
> > > index b4c8702ba4bd..d9f0ff97770d 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -4,6 +4,7 @@
> > >   *
> > >   * Copyright (C) 2018, Google LLC.
> > >   */
> > > +#include "tdx/tdx_util.h"
> > >  #include "test_util.h"
> > >  #include "kvm_util.h"
> > >  #include "processor.h"
> > > @@ -465,7 +466,7 @@ void kvm_set_files_rlimit(uint32_t nr_vcpus)
> > >  static bool is_guest_memfd_required(struct vm_shape shape)
> > >  {
> > >  #ifdef __x86_64__
> > > -   return shape.type =3D=3D KVM_X86_SNP_VM;
> > > +   return (shape.type =3D=3D KVM_X86_SNP_VM || shape.type =3D=3D KVM=
_X86_TDX_VM);
> > >  #else
> > >     return false;
> > >  #endif
> > > @@ -499,6 +500,12 @@ struct kvm_vm *__vm_create(struct vm_shape shape=
, uint32_t nr_runnable_vcpus,
> > >     for (i =3D 0; i < NR_MEM_REGIONS; i++)
> > >             vm->memslots[i] =3D 0;
> > >
> > > +   if (is_tdx_vm(vm)) {
> > > +           /* Setup additional mem regions for TDX. */
> > > +           vm_tdx_setup_boot_code_region(vm);
> > > +           vm_tdx_setup_boot_parameters_region(vm, nr_runnable_vcpus=
);
> > > +   }
> > > +
> > >     kvm_vm_elf_load(vm, program_invocation_name);
> > >
> > >     /*
> > > @@ -1728,11 +1735,26 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_pa=
ddr_t gpa)
> > >     return (void *) ((uintptr_t) region->host_alias + offset);
> > >  }
> > >
> > > +static bool is_split_irqchip_required(struct kvm_vm *vm)
> > > +{
> > > +#ifdef __x86_64__
> > > +   return is_tdx_vm(vm);
> > > +#else
> > > +   return false;
> > > +#endif
> > > +}
> > > +
> > >  /* Create an interrupt controller chip for the specified VM. */
> > >  void vm_create_irqchip(struct kvm_vm *vm)
> > >  {
> > >     int r;
> > >
> > > +   if (is_split_irqchip_required(vm)) {
> > > +           vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
> > > +           vm->has_irqchip =3D true;
> > > +           return;
> > > +   }
> >
> > Ugh.  IMO, this is a KVM bug.  Allowing KVM_CREATE_IRQCHIP for a TDX VM=
 is simply
> > wrong.  It _can't_ work.  Waiting until KVM_CREATE_VCPU to fail setup i=
s terrible
> > ABI.
> >
> > If we stretch the meaning of ENOTTY a bit and return that when trying t=
o create
> > a fully in-kernel IRQCHIP for a TDX VM, then the selftests code Just Wo=
rks thanks
> > to the code below, which handles the scenario where KVM was be built wi=
thout
>          ^^^^^^^^^^
>
> I'm not following.  Was there supposed to be a patch attached?
>

I think Sean refers to the original implementation which was out of
the scope for the git diff so it was left out of the patch:

/*
 * Allocate a fully in-kernel IRQ chip by default, but fall back to a
 * split model (x86 only) if that fails (KVM x86 allows compiling out
 * support for KVM_CREATE_IRQCHIP).
 */
r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
        vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
else
        TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);

/*
 * Allocate a fully in-kernel IRQ chip by default, but fall back to a
 * split model (x86 only) if that fails (KVM x86 allows compiling out
 * support for KVM_CREATE_IRQCHIP).
 */
r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
else
TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
/*
* Allocate a fully in-kernel IRQ chip by default, but fall back to a
* split model (x86 only) if that fails (KVM x86 allows compiling out
* support for KVM_CREATE_IRQCHIP).
*/
r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
else
TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);

> Ira
>
> > support for in-kernel I/O APIC (and PIC and PIT).
>
>

