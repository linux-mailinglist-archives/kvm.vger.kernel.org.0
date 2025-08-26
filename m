Return-Path: <kvm+bounces-55791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDEBB373DE
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 22:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C92591BA4495
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 20:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861B72F5329;
	Tue, 26 Aug 2025 20:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tq9Mp4jX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6A2285C97
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756240241; cv=none; b=ju7/QX9Oolp6eCvCco+Vvq2dKaO9p3W5EbSm/jXlz5zpIiwm9bK4l55Wdodk84/teWnHXT0sEdLqUFkWFaGm8gDpDLtBJ5wymlWuqX1Gwdedka9TcSouBv9Ee2o5ApRGd4/eNjVXYVFsfNsFZuB5zp85NKKQpP93vTnCZClnzeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756240241; c=relaxed/simple;
	bh=dWpaw+5IK+faLL3HzEwBYWrdV1DKLv9aeK98Eb/3Bcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i//O2rieTKSW2486YG+9ypwZ1DXP5upJOpO5yNvT7OC68YjdsRV6O3fiKJR0Eyb3MGC+yz9ZIwIqCExg32erPxe0oM+WHyxzD6Ah8K/97BCui9GPPyaMM4QdKc9Oxw5tIn3NjV6uDSpxRbgPRc24/cjvLgKX3myux7N4TgSM3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tq9Mp4jX; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b2dc20aebbso124561cf.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 13:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756240239; x=1756845039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NivCtX5VVCQOwctlprydiQ2y64E7oPKjSGk2dbkglQ=;
        b=Tq9Mp4jXZkGffOrZZJxfggfM1SBX2EtierahX67SbSeT3Yc8chGMPV7ZkZSQiFgv3j
         pAH+hWZ6A7w3qyNGfyicavXbtrJmVp1E2s7eAhTgHhaCarrjvhvOuXXsn+Hc2ugQKK4m
         EBEaelsnylLTD/d2Ps+2JRyHttuXZLOsEH+aKEX2QTOO2loKgFPg7DP2lRWuOF4UCVTM
         XDiFvrIN37DLnu221Ye/EYmBHTKSzBHEU8vFT+XlnuOXHzAONyJsKIje5DdfoAdm2dQf
         oj+BQxsk/MlHqxecFXsHmYWooAJf2n9dWF0kQCxA3BhIz+OnTyT2cQvljcKZ6BKjuq/B
         N4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756240239; x=1756845039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NivCtX5VVCQOwctlprydiQ2y64E7oPKjSGk2dbkglQ=;
        b=L6tGh9LH53aMW63Z5tmbA+6vdUnmKlfTrU3TL5RPt+xIZo/lP87+W+k7U2dSzCTK44
         QHn+LZOAANH93MZDdktxrD8Z4qGEO2yiNhvCCJorBspRMzc6H8jfGK8J7ITOJOksusGi
         XyypteALMY0qP3yqlxZRzYdx3eF3SZNjegc0HdUPqYprxtM1B2s2hegW9awB2bdMsGtB
         8x1FLnFFXJJd7fazGWzyXKBsztIfV9jRCqmdd+O3+J7nLSgKGqxIBNAA/SXvdathP0i0
         CbbtGRDuu249PdX9V4VacW/zTrAXts+8qZnvx9ZUV/MufeFuDCQ0uPwmXkyawn6oeOAX
         qT8A==
X-Forwarded-Encrypted: i=1; AJvYcCXiJZ698udPTVgdOpRwM6hsZe8bKXTSubjb3/d9Da1XlK2HhxvZBuh96+Rjko1gH3dW2Y4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx59e6jLCSYhTgqZWrl2ncqEBvlmWmK3k3IfGDrPVVzh8eEhVmU
	DbSFbtfmcdTTcnREp65cUS2eSz9NnvTrxzIqYyc2Rym6Mef0ncZW/YqkeA6+ylf/vmXodrEQwZr
	GPilhUhrnxA4rFkxjzNtDLu4LC/ZhyulXPDRoejoM
X-Gm-Gg: ASbGncshaQ6UyefAGbY409mdZkubsv4mtd677SUFOhrXclt6XkH7bWpABAAQM72Czpm
	LbxsyP5iobH+u7Fzd16trWFbaAYm6IVyiv6g92mCm/DaL069jwbnUUZj1eaZRDqwnkH3bbc0r9E
	/08MwKO0VFrEzlcqNyjuq0EISlqndsvNwdRHqJV/IlllMB44FTU6guUl2KltOwbP3BdCAIbwbYJ
	EUuPIezfqi7OkY47V4iOztTzSjOQ1iWgD3NOsnZrtg1VSHwhiP2d0h2PQ==
X-Google-Smtp-Source: AGHT+IEL45FJ6C194aidsP5pgQHqoHHDUuhtRlEDTjKfdI4ez+CYTV0dWOx7Th8KWxoUAD969ZMn2roqrW1KFRyGIUE=
X-Received: by 2002:a05:622a:1116:b0:4b0:8318:a95 with SMTP id
 d75a77b69052e-4b2e1d2850cmr8109911cf.8.1756240238481; Tue, 26 Aug 2025
 13:30:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-16-sagis@google.com>
 <aK3vZ5HuKKeFuuM4@google.com> <68ae1604a387c_300e8f2947e@iweiny-mobl.notmuch> <CAAhR5DHPMPOb2XCJodyNMf2RTQfTZpAaCGMg6WeWxSWPLtkO4Q@mail.gmail.com>
In-Reply-To: <CAAhR5DHPMPOb2XCJodyNMf2RTQfTZpAaCGMg6WeWxSWPLtkO4Q@mail.gmail.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 26 Aug 2025 15:30:27 -0500
X-Gm-Features: Ac12FXwbbMM7pQh_4Keas2PDt_6Fce4xe48eDBxubuYMDZnlgdFtNq-3iaBrnyg
Message-ID: <CAAhR5DGeTQ4G-w2o5YCvNWkZZWFcXe=6rro+RcfhR18-4sT+PQ@mail.gmail.com>
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

On Tue, Aug 26, 2025 at 3:29=E2=80=AFPM Sagi Shahar <sagis@google.com> wrot=
e:
>
> On Tue, Aug 26, 2025 at 3:14=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> w=
rote:
> >
> > Sean Christopherson wrote:
> > > On Wed, Aug 20, 2025, Sagi Shahar wrote:
> > > > TDX require special handling for VM and VCPU initialization for var=
ious
> > > > reasons:
> > > > - Special ioctlss for creating VM and VCPU.
> > > > - TDX registers are inaccessible to KVM.
> > > > - TDX require special boot code trampoline for loading parameters.
> > > > - TDX only supports KVM_CAP_SPLIT_IRQCHIP.
> > >
> > > Please split this up and elaborate at least a little bit on why each =
flow needs
> > > special handling for TDX.  Even for someone like me who is fairly fam=
iliar with
> > > TDX, there's too much "Trust me bro" and not enough explanation of wh=
y selftests
> > > really need all of these special paths for TDX.
> > >
> > > At least four patches, one for each of your bullet points.  Probably =
5 or 6, as
> > > I think the CPUID handling warrants its own patch.
> > >
> > > > Hook this special handling into __vm_create() and vm_arch_vcpu_add(=
)
> > > > using the utility functions added in previous patches.
> > > >
> > > > Signed-off-by: Sagi Shahar <sagis@google.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/lib/kvm_util.c    | 24 ++++++++-
> > > >  .../testing/selftests/kvm/lib/x86/processor.c | 49 ++++++++++++++-=
----
> > > >  2 files changed, 61 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/tes=
ting/selftests/kvm/lib/kvm_util.c
> > > > index b4c8702ba4bd..d9f0ff97770d 100644
> > > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > > @@ -4,6 +4,7 @@
> > > >   *
> > > >   * Copyright (C) 2018, Google LLC.
> > > >   */
> > > > +#include "tdx/tdx_util.h"
> > > >  #include "test_util.h"
> > > >  #include "kvm_util.h"
> > > >  #include "processor.h"
> > > > @@ -465,7 +466,7 @@ void kvm_set_files_rlimit(uint32_t nr_vcpus)
> > > >  static bool is_guest_memfd_required(struct vm_shape shape)
> > > >  {
> > > >  #ifdef __x86_64__
> > > > -   return shape.type =3D=3D KVM_X86_SNP_VM;
> > > > +   return (shape.type =3D=3D KVM_X86_SNP_VM || shape.type =3D=3D K=
VM_X86_TDX_VM);
> > > >  #else
> > > >     return false;
> > > >  #endif
> > > > @@ -499,6 +500,12 @@ struct kvm_vm *__vm_create(struct vm_shape sha=
pe, uint32_t nr_runnable_vcpus,
> > > >     for (i =3D 0; i < NR_MEM_REGIONS; i++)
> > > >             vm->memslots[i] =3D 0;
> > > >
> > > > +   if (is_tdx_vm(vm)) {
> > > > +           /* Setup additional mem regions for TDX. */
> > > > +           vm_tdx_setup_boot_code_region(vm);
> > > > +           vm_tdx_setup_boot_parameters_region(vm, nr_runnable_vcp=
us);
> > > > +   }
> > > > +
> > > >     kvm_vm_elf_load(vm, program_invocation_name);
> > > >
> > > >     /*
> > > > @@ -1728,11 +1735,26 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_=
paddr_t gpa)
> > > >     return (void *) ((uintptr_t) region->host_alias + offset);
> > > >  }
> > > >
> > > > +static bool is_split_irqchip_required(struct kvm_vm *vm)
> > > > +{
> > > > +#ifdef __x86_64__
> > > > +   return is_tdx_vm(vm);
> > > > +#else
> > > > +   return false;
> > > > +#endif
> > > > +}
> > > > +
> > > >  /* Create an interrupt controller chip for the specified VM. */
> > > >  void vm_create_irqchip(struct kvm_vm *vm)
> > > >  {
> > > >     int r;
> > > >
> > > > +   if (is_split_irqchip_required(vm)) {
> > > > +           vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
> > > > +           vm->has_irqchip =3D true;
> > > > +           return;
> > > > +   }
> > >
> > > Ugh.  IMO, this is a KVM bug.  Allowing KVM_CREATE_IRQCHIP for a TDX =
VM is simply
> > > wrong.  It _can't_ work.  Waiting until KVM_CREATE_VCPU to fail setup=
 is terrible
> > > ABI.
> > >
> > > If we stretch the meaning of ENOTTY a bit and return that when trying=
 to create
> > > a fully in-kernel IRQCHIP for a TDX VM, then the selftests code Just =
Works thanks
> > > to the code below, which handles the scenario where KVM was be built =
without
> >          ^^^^^^^^^^
> >
> > I'm not following.  Was there supposed to be a patch attached?
> >
>
> I think Sean refers to the original implementation which was out of
> the scope for the git diff so it was left out of the patch:
>
> /*
>  * Allocate a fully in-kernel IRQ chip by default, but fall back to a
>  * split model (x86 only) if that fails (KVM x86 allows compiling out
>  * support for KVM_CREATE_IRQCHIP).
>  */
> r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
> if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
>         vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
> else
>         TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
>
> /*
>  * Allocate a fully in-kernel IRQ chip by default, but fall back to a
>  * split model (x86 only) if that fails (KVM x86 allows compiling out
>  * support for KVM_CREATE_IRQCHIP).
>  */
> r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
> if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
> vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
> else
> TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
> /*
> * Allocate a fully in-kernel IRQ chip by default, but fall back to a
> * split model (x86 only) if that fails (KVM x86 allows compiling out
> * support for KVM_CREATE_IRQCHIP).
> */
> r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
> if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
> vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
> else
> TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
>

Sorry, I messed up the paste somehow:

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

> > Ira
> >
> > > support for in-kernel I/O APIC (and PIC and PIT).
> >
> >

