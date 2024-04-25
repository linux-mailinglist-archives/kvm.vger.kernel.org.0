Return-Path: <kvm+bounces-15932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A55D18B2446
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 315EF1F23A9E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0EA414A0BF;
	Thu, 25 Apr 2024 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VJ1qky3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B114A4CC
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714056286; cv=none; b=eP/82XLNfmRqVKyGd0csK0VQiF5v5SCvoAPSu9PBv5sf4CTfUIZq299qCIhnK6GR7GHD693aSDPB1nZ7CqV4/pIXGnWH40zJZjwAwG2aFgCKHKTv+RCrlBQdKyiaxcPa/l1dBp8xw5gY2RBUGoXqdPI7PHI5gd1RWJ0iBckOU9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714056286; c=relaxed/simple;
	bh=1Vynxfx2D6956dodx3vvYuxa6Pa4BDwN4tyUYPevkxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=syCAghAbnjEuKPk0QfPhLu9ciqF6BR3vmRWb0MvQr0ZCBhGGc28zKtBG3uLCvfbghTzfcGnTeOiYHiMFU1n//GZWusq/BtBKE1LKAkWt1bkn6FUK2G5Ne2pdycN9RO6g7vptT6xwlUwx2e5SRN/GdI7C1+YgZlIbl8OoeyItmps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VJ1qky3h; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-617d25b2bc4so11317247b3.2
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714056284; x=1714661084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4XHxss7Od+OfkSKxerbEin0D4Y8XCvJwoXzpIRakjY4=;
        b=VJ1qky3h1hb7Qmq1/+wl5GfYGdF6oJPGsflcUutkn5UXfZEEagqpnDm9pMUTqNx3o9
         TXFN79QM61rXvNmvEd2t/76mHNytCyKtpy92bzQEUbT4i+l60gmqRdc9OWulTU+YwXk2
         2G9FfGQ7gvxr5AziX3E2GOn+WdBDJtuOGnaBYLqy5wyRwMXY/FtBHMxDMWyTujhQ0YPN
         Tg3xHZPeT1EzVS2h8cNmUh5lkrvcki3ogW3+TZY5nNXUjK+brsRk1PT+fSrU2cSCDa/x
         qxxpdDjvQBVZ9ZkLrUhIkwhZz34Daf9nYaxL6i8trZGAM63VWiqifbOWkSfDfZu7J2Ln
         7o0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714056284; x=1714661084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4XHxss7Od+OfkSKxerbEin0D4Y8XCvJwoXzpIRakjY4=;
        b=LZiq1UcWff9pMbbH5JeuOaS1z+N70KUv4oDBTYVFhwbo1k4Bnsp8qhX6ES7Ipfa4p8
         HsZGvubzAOoIVG2xvq7cTz1fvQpz54HbMzi8anWWPe0Hg3RnAEO/+Z7rGDQooBYS2m2M
         PNZQl119YaU0B+5ji9i839mKPNmHCx88toYvxXeT5VjOek7EHLSgodXvLfOHhw9+gXy7
         Utnz7lYDyvxdRQnjLTdR7Ft8IOyMgXh+5Cpyv7AmBK9atG/UTPScvwZnH1W43xaFOKWc
         j5rtKBklNYGQXtlFRRbeHTlOReGYB+NgDXtb4W/82pHnH7JChIWbw+UVmNlvcZRHlBVo
         1Ohg==
X-Gm-Message-State: AOJu0YyntW/yQvK4kLmZ9ixYQOzqyg4E4LZMZ7BTqqrDNlL/e10MfOyl
	cu80jsk8o4vdQcLiphQ87SAG7TeGAHk2HBwdQXoYTa0cFB2eo2SJ/ynmc2luOQVRj8IHAI83XNA
	+Rcn/RGMdtLf9/1PRNXV1Ygn68QjDleJyVbN6
X-Google-Smtp-Source: AGHT+IHcmWwxfbEJpizD95GcdNN5E+9J6MenReSgJkZTNHD/sQZ17A8KpqOihrS1Id2Tb8PVty4NllCeLHZvLqz87Cw=
X-Received: by 2002:a05:690c:600a:b0:618:92bd:9334 with SMTP id
 hf10-20020a05690c600a00b0061892bd9334mr6616886ywb.43.1714056284262; Thu, 25
 Apr 2024 07:44:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com> <20240412084309.1733783-43-steven.price@arm.com>
In-Reply-To: <20240412084309.1733783-43-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Apr 2024 15:44:07 +0100
Message-ID: <CA+EHjTyGcO=-EdFE75g5DwBKosKWUdmg7CB8VAr1w78C=2PCww@mail.gmail.com>
Subject: Re: [PATCH v2 42/43] arm64: kvm: Expose support for private memory
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 12, 2024 at 9:44=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> Select KVM_GENERIC_PRIVATE_MEM and provide the necessary support
> functions.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>  arch/arm64/kvm/Kconfig            |  1 +
>  arch/arm64/kvm/arm.c              |  5 +++++
>  arch/arm64/kvm/mmu.c              | 19 +++++++++++++++++++
>  4 files changed, 29 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 902923402f6e..93de7f5009fe 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1259,6 +1259,10 @@ static inline bool kvm_vm_is_protected(struct kvm =
*kvm)
>         return false;
>  }
>
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +bool kvm_arch_has_private_mem(struct kvm *kvm);
> +#endif
> +

I think it might be better to define kvm_arch_has_private_mem() for
both cases, whether KVM_PRIVATE_MEM is enabled or not, similar to the
way it's defined in arch/x86/include/asm/kvm_host.h

>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 58f09370d17e..8da57e74c86a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,7 @@ menuconfig KVM
>         select HAVE_KVM_VCPU_RUN_PID_CHANGE
>         select SCHED_INFO
>         select GUEST_PERF_EVENTS if PERF_EVENTS
> +       select KVM_GENERIC_PRIVATE_MEM

I don't think this should be enabled by default, but should depend on
whether RME is configured. That said, I can't find the config option
for RME...

>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2dd014d3c366..a66d0a6eb4fa 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -89,6 +89,11 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>         return kvm_vcpu_exiting_guest_mode(vcpu) =3D=3D IN_GUEST_MODE;
>  }
>
> +bool kvm_arch_has_private_mem(struct kvm *kvm)
> +{
> +       return kvm_is_realm(kvm);
> +}
> +

Related to my earlier comment on kvm_arch_has_private_mem(), and
considering how often this function is called, wouldn't it be better
to define this in a way similar to arch/x86/include/asm/kvm_host.h ?


>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                             struct kvm_enable_cap *cap)
>  {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 48c957e21c83..808bceebad4d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2171,6 +2171,25 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm=
,
>         return ret;
>  }

The following two functions should be gated by

#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES


> +bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> +                                       struct kvm_gfn_range *range)
> +{
> +       WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm));
> +       return false;
> +}
> +
> +bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> +                                        struct kvm_gfn_range *range)
> +{
> +       WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm));

I think this should return here, not just warn.

Cheers,
/fuad

> +
> +       if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +               range->only_shared =3D true;
> +       kvm_unmap_gfn_range(kvm, range);
> +
> +       return false;
> +}
> +
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot=
)
>  {
>  }
> --
> 2.34.1
>

