Return-Path: <kvm+bounces-56270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A2AB3B836
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 278057AA354
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4BF3081BA;
	Fri, 29 Aug 2025 10:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7lb7irz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B5530504C;
	Fri, 29 Aug 2025 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462158; cv=none; b=WeaaCoup1IdA40Hf67UXmjvwtddPrsF65vnCuMTOjFA2IKFfQ+Fx1ibbkhrxLQ+Q3NUjs0AR0RjHiXkOBC6pGM9dmmBjPBsh8YCcHekJEEdtYty1FFnNrUNazVmVQ5xxg5ZWpdOzYz3pRMiI0Cf6fqGNegxt9sNRzZPtwzNz4uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462158; c=relaxed/simple;
	bh=4QpS6sW814ov2VbrGGMcXn9/44aV6nOmTEk2x4dtQ9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ub1WKUgG5KYXZoKiVA3yt/fPyNEI+/HxiNZUFVM0/h51b8NbBZdy/0zgjI7x6zSUYG6ftB4GI5MBh9sOLcB8cmZMsHCHN7O2pWIafY+4JyTjvBAqJGKDfw0Ys+5EH4nqmCKz01EIajCWpJvsgl1DxeDDxw4LepYYFR9ACedTXcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7lb7irz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92F0C4CEF0;
	Fri, 29 Aug 2025 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756462157;
	bh=4QpS6sW814ov2VbrGGMcXn9/44aV6nOmTEk2x4dtQ9A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p7lb7irzUQj1UXV3WvaUOWMSPaIux24blJMNGD3V/kmN49aPyVGqIqQreXbXQjJZR
	 QV5tUWa/xdwOTZTL/cRFwKio/QlbBJ1sgrQ8hrQb8mvcXJWB9RID85WITEJSOT6UPT
	 fLnp+Bv0Bkjmr3eb/KDHKLs871PkxMn/mqThZyzBIkt+08lMPzFVpAqyyGDqQiTwNe
	 Be18ArlYN+XNHK+eHuqk1W1Hr55J7+8f5qsidgpB1YEbl4uPPMQmoTDXTE/rUGVnb+
	 Zn2mthDIsoi+p/07ZUlYlqOr8ECVcJVzcIb9RsryNG88tKokuYhFwH+yt0d38CPDdS
	 hJxtGGwRcu5lQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb78f5df4so324969166b.1;
        Fri, 29 Aug 2025 03:09:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVWP+9+WSl6n0bIv/KSyjz0PV1h+tM/PM1mf+Owb1QFRIFCd2RMl7LwU6lPBBIDHXsgkpg=@vger.kernel.org, AJvYcCWySUB5k4t+ES7HahySPwPgRive2aiIGa+lq1Fm890cvBvkbIfXilRVI/5hC5HL7hZx+/DHeKy1Gllrvq7h@vger.kernel.org
X-Gm-Message-State: AOJu0YwQs8afI2ZL9rNUmBWCPuk//xVDdCPbfQZLWxRfPW3SAo9Zcz/M
	6YTBsmEAzrwTAkU7p3LXKUvYcTIpQqQdVpZabY/E3f53rTeRz+bBTyJc+AU3cjKPNGKUlVP/RtO
	klH+XlWDgco+b3hRyeMrPm5ayJug6JYo=
X-Google-Smtp-Source: AGHT+IHuZ2WwOouG49QLK1d9QUo7J8C1hjI3CMBSYA+Xwt69N4cideZr4b/M61Yq5C2Zk3pkiXp5bke/Q/F24EYuugI=
X-Received: by 2002:a17:906:40c5:b0:aff:a3e:fcb1 with SMTP id
 a640c23a62f3a-aff0a3efddamr139484866b.54.1756462156441; Fri, 29 Aug 2025
 03:09:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826033514.972480-1-maobibo@loongson.cn>
In-Reply-To: <20250826033514.972480-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 29 Aug 2025 18:09:03 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4GeBYBNLq6w6W5aj+kUWQacJmNnkwB5uL_jVQNKMtCTw@mail.gmail.com>
X-Gm-Features: Ac12FXyjkUzRlsg2RqdCQYHPHzTDAr74NmNHrwXO9jEPPvyTYvZFuAGWixqPKHk
Message-ID: <CAAhV-H4GeBYBNLq6w6W5aj+kUWQacJmNnkwB5uL_jVQNKMtCTw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add PTW feature detection on 3C6000 host
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.


Huacai

On Tue, Aug 26, 2025 at 11:35=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With 3C6000 hardware platform, hardware page table walking(PTW) features
> is supported on host. Here add this feature detection on KVM host.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/uapi/asm/kvm.h | 1 +
>  arch/loongarch/kvm/vcpu.c             | 2 ++
>  arch/loongarch/kvm/vm.c               | 4 ++++
>  3 files changed, 7 insertions(+)
>
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index 5f354f5c6847..57ba1a563bb1 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -103,6 +103,7 @@ struct kvm_fpu {
>  #define  KVM_LOONGARCH_VM_FEAT_PMU             5
>  #define  KVM_LOONGARCH_VM_FEAT_PV_IPI          6
>  #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    7
> +#define  KVM_LOONGARCH_VM_FEAT_PTW             8
>
>  /* Device Control API on vcpu fd */
>  #define KVM_LOONGARCH_VCPU_CPUCFG      0
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index ce478151466c..9c802f7103c6 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -680,6 +680,8 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>                         *v |=3D CPUCFG2_ARMBT;
>                 if (cpu_has_lbt_mips)
>                         *v |=3D CPUCFG2_MIPSBT;
> +               if (cpu_has_ptw)
> +                       *v |=3D CPUCFG2_PTW;
>
>                 return 0;
>         case LOONGARCH_CPUCFG3:
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index edccfc8c9cd8..a49b1c1a3dd1 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -146,6 +146,10 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, =
struct kvm_device_attr *attr
>                 if (kvm_pvtime_supported())
>                         return 0;
>                 return -ENXIO;
> +       case KVM_LOONGARCH_VM_FEAT_PTW:
> +               if (cpu_has_ptw)
> +                       return 0;
> +               return -ENXIO;
>         default:
>                 return -ENXIO;
>         }
> --
> 2.39.3
>

