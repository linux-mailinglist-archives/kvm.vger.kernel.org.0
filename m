Return-Path: <kvm+bounces-21397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B3D92E265
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 10:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A7C71C2154D
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 08:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE2215D5A4;
	Thu, 11 Jul 2024 08:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NUXIMxpP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A2315B143
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 08:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720686661; cv=none; b=ZzRO8OmL/LwMbRGQH0bB9bCRXhuEzpcXNkcDQSHwezgjikrPbtoROuWHZw36xGrhllhFhve3MAwvHQzUvSQENfnUuDgGtzuuB0pwBkCVxU+RQzPms4ITvYZiFK8kstQ/v3Dn/l6z/xkF7xHmTOra8r7mtyvzByw9fLFFbzfBAk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720686661; c=relaxed/simple;
	bh=vq/fsSFpj4lf62kfSjY69N/eyTlPYqc7EZyIMw8xTZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bz75EudXCkjPkB46hn6D9U8W6L0Q/RVHNgDmPh/+lsRqVD6CptcjJX9n3UyalUsh+axllTcx1pc2zZIy706yiIxMi1Xip2CZG5qfjGinSyptAqqjIE9sOGOcZQu9F7ZRFCZb223b7jqdi+kInvfqfZR61vS/WPHEx2Ibn8D5HKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NUXIMxpP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720686658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btXtWBcxdT6FJlBZbVF8gxUbmtiHEm3rZNQvGlu5PqE=;
	b=NUXIMxpPnq4E6cnpc0lA1W7uwJFzfwVbSpff4+FxWNvc3t7m13pYV71SLYwaL6LjyPSQT8
	eLfaG/cuifTpjYzePtNC3uTdB68BvCclxpJ4rDuo8fpMu2oYFB5ddIbE4wuZy6mv5Xp0ls
	boWQbKyiyPXeGCjTOL+kiSxOMcm/gMI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-sFeodfp2N-uCy1Yi8f36rg-1; Thu, 11 Jul 2024 04:30:54 -0400
X-MC-Unique: sFeodfp2N-uCy1Yi8f36rg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-36795e2ce86so411911f8f.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 01:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720686653; x=1721291453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btXtWBcxdT6FJlBZbVF8gxUbmtiHEm3rZNQvGlu5PqE=;
        b=LUWWM0s+X7Iuapy1QkYxkGwXjvK0pfsEoOY09p6tgqnPUrTcr9nVOjbQwm51BWVqfu
         XQkBc3dMy/I/m5DFuLLMjTfCwGfutlt9JwFSAdeRgcfzDMgZ0foLabF8jJ8kfWhItTu8
         PoEX6kL4COqzDR+2LwZ/x1/u2Wl1sVa2ATVN0p096cuWrOmdHtzpLb/zm5iV8aizL3Qa
         63NKcxC2ihoC6xktS6s/FqeEsIEfoyRop98RlivvKEejbZBxe9kTi3Mw2yIlYl0k3sR2
         qkbgz56/lG2EOv23QW2O8+RJUBivYev0QEWodQ42V9OvxrriHbalP5OayUNagtddkCXo
         ZEYA==
X-Forwarded-Encrypted: i=1; AJvYcCWKqdu+OOKB2w4P3dC6D7OjQ1MAHE1NWx4d/6cAhNZI7K7Qdm2qw8YA7hvezWOfPkuplogzujgS3d8OFouC2HL+XhYJ
X-Gm-Message-State: AOJu0YwRQtkawmYXgs5h1Vx3Um27CtNCZzoDwTQxQgG170bZ84Fy8/dE
	Ck2oKfcLih6ds+3IZahQSpYftS3ffJQ4IVvGe/PGh8mV//f72l1iiHOP6Tohz20wjNCzE9kt/H3
	SfR8JH3OXM1nooRH3R+f9fL5EC+lsdeFrXPYUKeWqIjSgJT80eHfliYUIwFW6tQGhL67VHMIEqk
	0Cn/yQSsZY2XCCrkhtjd0qAGTu
X-Received: by 2002:a5d:58f1:0:b0:367:8900:c621 with SMTP id ffacd0b85a97d-367ceaca897mr5750899f8f.56.1720686653569;
        Thu, 11 Jul 2024 01:30:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQE2zYNCu9jnbKuJ1vYypQltqtn1W53LvxLUbv4GeYPR8FiICVkKa9B4B4Tli9UJizVyY3iyXiiUMPse135wM=
X-Received: by 2002:a5d:58f1:0:b0:367:8900:c621 with SMTP id
 ffacd0b85a97d-367ceaca897mr5750879f8f.56.1720686653218; Thu, 11 Jul 2024
 01:30:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710174031.312055-1-pbonzini@redhat.com> <20240710174031.312055-7-pbonzini@redhat.com>
 <cd52fe00-b57b-495c-b55c-54fd381f7c66@linux.intel.com>
In-Reply-To: <cd52fe00-b57b-495c-b55c-54fd381f7c66@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Jul 2024 10:30:41 +0200
Message-ID: <CABgObfZfyWzKRafPVcTyQ23oO=aAkc7Pmg8En4412J0vx1WotQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, seanjc@google.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 7:37=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> On 7/11/2024 1:40 AM, Paolo Bonzini wrote:
> > Wire KVM_PRE_FAULT_MEMORY ioctl to __kvm_mmu_do_page_fault() to populat=
e guest
>
> __kvm_mmu_do_page_fault() -> kvm_mmu_do_page_fault()
>
> > memory.  It can be called right after KVM_CREATE_VCPU creates a vCPU,
> > since at that point kvm_mmu_create() and kvm_init_mmu() are called and
> > the vCPU is ready to invoke the KVM page fault handler.
> >
> > The helper function kvm_mmu_map_tdp_page take care of the logic to
>
> kvm_mmu_map_tdp_page -> kvm_tdp_map_page()?

Yes, will fix.

> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 80e5afde69f4..4287a8071a3a 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -44,6 +44,7 @@ config KVM
> >       select KVM_VFIO
> >       select HAVE_KVM_PM_NOTIFIER if PM
> >       select KVM_GENERIC_HARDWARE_ENABLING
> > +     select KVM_GENERIC_PRE_FAULT_MEMORY
> >       select KVM_WERROR if WERROR
> >       help
> >         Support hosting fully virtualized guest machines using hardware
> [...]
> > index ba0ad76f53bc..a6968eadd418 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4705,6 +4705,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> >       case KVM_CAP_MEMORY_FAULT_INFO:
> >               r =3D 1;
> >               break;
> > +     case KVM_CAP_PRE_FAULT_MEMORY:
> > +             r =3D tdp_enabled;
> > +             break;
> If !CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY, this should return 0.

This is x86-specific code and it CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
is always selected by CONFIG_KVM on x86 (that is, it does not depend
on TDX or anything else).

Paolo


