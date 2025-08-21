Return-Path: <kvm+bounces-55416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EE5B3092B
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7377E7BAFBE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6752EA744;
	Thu, 21 Aug 2025 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hcbWDMtK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EBA2DEA75
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815110; cv=none; b=YDsm8GPUvq5ECB5hEIaehevKyiuoopN3P5+cf6x76Z5M+wgoGjREJ7Ugj6olmsaruikHYzddgF8BsOQ8BBOfuemqna8zW36Dc3K/pp7aROCoRXxpvcN1PB59sYCRI1dS06hU44zF4ZrbAkQ1n426u1KorCVTL75gxGYuYliBrpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815110; c=relaxed/simple;
	bh=2QZ6zrGsjLlalDpBAkIdTyTLIFs2ej9WDspfuVcDGhc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aT9foV4Wv5iZwzMNniXo+T9r5oA0cpp6KqPfwiYvX8K3snti2QSt5OTgHco5Q29dEUW7JNvHqyk/wDgIPKpJTN8eCJmCrOk/Gfmz8084OwQgJS1xNz2EZO6htKifA3ge/yHqFobMFgZ+sM3eM9ES0C0hBjQZa4cISU26DjxQG6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hcbWDMtK; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b12b123e48so114721cf.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 15:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755815107; x=1756419907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyJPOCeYTYQJhT7dlpclxs9aP7FdE4Az1oLgPLGKt4w=;
        b=hcbWDMtKcwCiAK2vEo72D+nw0t8h/2iq/28WxrJ6H/8jNDB3zkfjgPO+KUqd8SbI5Q
         I+l1OUpFc2TEU2nXcAb8Z2dtu1lBF9ocBZB5SVE2fabENmbtnZ2Pp8btxI2kE6JyiPZn
         SbahA16owkCCovCnLDeqpV7AZiF3vy9GUZf0D3zGo5B8sEtCzsA6WHO3GsNxTb8j5QRR
         vhfs8wcsqwrC93fpdgoShnxd2ORXBXD78EHVySSMOg4LpuvUi5R+pK0lTOkFuIEnCoBW
         lpch+TiRQm1U2ZO4WbDG3vWOKv7tP46nYmn4wMwDB9hmAmK7QR6Hi6U7EtDTvA3vmiS8
         0n9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755815107; x=1756419907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyJPOCeYTYQJhT7dlpclxs9aP7FdE4Az1oLgPLGKt4w=;
        b=Y8gTquZydG6oMXR1kqOK9weRd8ePGn0DEfD++RxnhtqDKHTvFRF1WB0q/k9o1KNLV9
         j9EYOW++tKXKlC2DRJ0hyqOzbaP+WMCMf0D72SS83QFaJUz+UlS0hrMFkbFPkbcfg4Ke
         cwsb/tuJr2X+x87o9WE2EkCRnnRQMlbkA9Z7WHfGQXR/z0UU70v/gjG6ZIkK5URZOzdA
         cD2BAcExXpnjxf8GupVU9ttIUSNqX4HttSU1xq/JArpzKym4iE3UL2talv9Ouk6r17gU
         SRMXJ70xIlrYMB0DQt3egmzXsudepXTa0F0sufCUPLZEeCpvyvvOTuh/0bnnwdWE4Kb0
         EHsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVEx+8DynIgq2aGbZo3d95SuuZ14tPfYFjb92ev1hTLwoX/mvdmJBP2kAAX+sbAfjSabc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA5DonyuZFtf3w9dFP0rcJZaJzqZxo7SFX8IuyUA+PPplVlWu2
	6YhbO4+dK0yYPbme2M6bXcm72jidC2OMXXHQiD92MvPttGHboAT264lmI/uwu0c6YA1FdgZ2eh6
	16hAo6uMx0l/KJUi0Ude9e5YYiPgFXZnevWMyBmq9
X-Gm-Gg: ASbGncsVZ7Myt8TeGSWRzXDfKjhPqKkPwv/IXMJY8CU7+uSv0AAKZGY1o4/NnBO7YWW
	x605y8ApREyrW0xXUsXuMWqv1VOZpcTazWwTorrSY2ajsZbivOFxtX8CpCSDmJXyYD5Hcnzc3WL
	U/OTWLptQJJrS4Nm+cna3TavGGEe5Uv5V1EeL8WREdHAswMlNgZRB3rzfz0f5gKLoub7De0Uhic
	bZv/nIBunRCDqI6rcy0qFQu5A5zZshgBfvjW+MBOUSVD9Q=
X-Google-Smtp-Source: AGHT+IEcy4+hFqm23pXRb+RvKPGCQLtlYExIO1aHI4T543x2s/ScIKdzGvuD9BdYomQcE7NRMDmcT74jIYHmn9egUfU=
X-Received: by 2002:ac8:7e93:0:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4b2aadb0202mr1614191cf.6.1755815107099; Thu, 21 Aug 2025
 15:25:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-5-sagis@google.com>
 <68a797031c5a6_2be23a29461@iweiny-mobl.notmuch>
In-Reply-To: <68a797031c5a6_2be23a29461@iweiny-mobl.notmuch>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 21 Aug 2025 17:24:56 -0500
X-Gm-Features: Ac12FXz2rEi3VHKQY81VoTu_wRJptAg-XMmMaS1bVIFyacnt7S54GNWkrdLENto
Message-ID: <CAAhR5DG6EDP=25-SrmBnbKYbrwH=bCP2f6OPO8KE=oXQxVBXbQ@mail.gmail.com>
Subject: Re: [PATCH v9 04/19] KVM: selftests: Expose function to allocate
 guest vCPU stack
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 4:58=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Sagi Shahar wrote:
>
> [snip]
>
> > diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/te=
sting/selftests/kvm/lib/x86/processor.c
> > index b2a4b11ac8c0..1eae92957456 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> > @@ -687,12 +687,9 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vc=
pu, void *guest_code)
> >       vcpu_regs_set(vcpu, &regs);
> >  }
> >
> > -struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
> > +vm_vaddr_t kvm_allocate_vcpu_stack(struct kvm_vm *vm)
> >  {
> > -     struct kvm_mp_state mp_state;
> > -     struct kvm_regs regs;
> >       vm_vaddr_t stack_vaddr;
> > -     struct kvm_vcpu *vcpu;
> >
> >       stack_vaddr =3D __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpages=
ize(),
> >                                      DEFAULT_GUEST_STACK_VADDR_MIN,
> > @@ -713,6 +710,15 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *v=
m, uint32_t vcpu_id)
> >                   "__vm_vaddr_alloc() did not provide a page-aligned ad=
dress");
> >       stack_vaddr -=3D 8;
> >
> > +     return stack_vaddr;
> > +}
> > +
> > +struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
> > +{
> > +     struct kvm_mp_state mp_state;
> > +     struct kvm_regs regs;
> > +     struct kvm_vcpu *vcpu;
> > +
> >       vcpu =3D __vm_vcpu_add(vm, vcpu_id);
> >       vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
> >       vcpu_init_sregs(vm, vcpu);
> > @@ -721,7 +727,8 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm=
, uint32_t vcpu_id)
> >       /* Setup guest general purpose registers */
> >       vcpu_regs_get(vcpu, &regs);
> >       regs.rflags =3D regs.rflags | 0x2;
> > -     regs.rsp =3D stack_vaddr;
> > +     if (vm->type !=3D KVM_X86_TDX_VM)
> > +             regs.rsp =3D kvm_allocate_vcpu_stack(vm);
>
> At this point in the series vm->type can't be KVM_X86_TDX_VM correct?
>
> So that makes this safe during bisect?
>

I double checked and no one is creating VMs with KVM_X86_TDX_VM. The
first test that sets KVM_X86_TDX_VM is the last patch in the series.

> Ira
>
> >       vcpu_regs_set(vcpu, &regs);
> >
> >       /* Setup the MP state */
> > --
> > 2.51.0.rc1.193.gad69d77794-goog
> >
>
>

