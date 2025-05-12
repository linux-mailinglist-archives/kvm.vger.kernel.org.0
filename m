Return-Path: <kvm+bounces-46187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC4BAB3BFA
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF6A81795C8
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005EF217701;
	Mon, 12 May 2025 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QiM6zOCv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7964A22FF37
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063484; cv=none; b=U+s8m9p8hTyYXA6s+EW0Qw6WMmvsN0ltbOK9wE7Is4k55CeAFnTETb4ARrAyW4dG2OIhKYOA25yP1da7/6rorQf7K1lZTvik6xe5ulHN8ki+GabZ9PYWEA0DUUe5oubddFCQu73U+EnAiE8aTMT18dP5neYG4UTxVFmJQDC61zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063484; c=relaxed/simple;
	bh=vH266j5hHgeV7VIVyG6DV3JLoILm7xcpcQgFEFrLW2g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAu/FLibJfeKFMgPFVH3Sez0ZW9o3l5lUhHwZuCY6PdKQF/EqOzSlDjV9YmmI0eH8nrs8Gd5y1wnTVE7ik+XkYmWP083TgqQO506BimVTi4UvoYdM4O+H3nhnKZjN8sajnxTUHvx8AKB+MV97ZBl0eS/+QhZ15zJ5YSHk9isf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QiM6zOCv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747063481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0uPxPAlbokCBFELfvxkftEEGEGO3nEqu1EeO7daiHGU=;
	b=QiM6zOCvn+gjK3h6rbADrk4chqyPE4rGjH6g9+UajnGUgkzP9Uv22tha0a8Xf7bd+dh+u7
	HUd+Rvp4/Jw8kG8FbivpEhpdjj2LW9WCh2shyWP5R+TEmjqFZD6mxCMxuZ5jo7JgoiUenE
	L7ojPFyzOm4C18ja4wg3oCH0r0GJ5BM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-nNWtjf9YOAW6dqPeChMT6w-1; Mon, 12 May 2025 11:24:40 -0400
X-MC-Unique: nNWtjf9YOAW6dqPeChMT6w-1
X-Mimecast-MFC-AGG-ID: nNWtjf9YOAW6dqPeChMT6w_1747063479
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so23752575e9.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 08:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747063479; x=1747668279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0uPxPAlbokCBFELfvxkftEEGEGO3nEqu1EeO7daiHGU=;
        b=iLLswH8ni/uwhDoFg/bNhqmPWp9bvskWuCi1OveRQUokmRlPVtgbl2FP5MKf51bQ+S
         nueZBt6YMXgEA03KP5+fmk88ctuQxtwzb7sBajT0PvzryJt1jZGQhBSvmhuqqhYEjRtZ
         9hAkrvpgIq1VFKd9YHpg4SBrKNmsNvfRQRRDOLpWsxPEFQ+9qEK0jg95rjH3GxYrEa+g
         2pWydfqdMWMYcAySluRo1P7NdPAcOYNofNjMu7+M9LvVTqfV0q6eEqGapT8G5tF5J+Tp
         jk4CfvMLZ7itP5WdwX9QBa0qlQ5D7aGJdtg7XbdbNocDCRqf36xqylPJxJpFf3eNyjn8
         SD4g==
X-Forwarded-Encrypted: i=1; AJvYcCVetd4O3gPc6YJh8htNMAVnolkj7zJRdW5y6N4DWcXRrqIkxcXBCAF9qI3xWU0DTQgymoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgaE6ZmkHovlkr7tfIv0nBSSs3Rm52PxmDNCvGOi0bVE3/IPcU
	DYoLvCgMNbqIlqn6P/eCcpmgW2fxc2LvDBrwMrcRfuQ8JugFBibEGPnQWqDNUtlw0aNvUB5ou5W
	kqMUSfoFuPnlg1XdfMaDHzIvnt/G6LTlARx5uXXBLQ96V31Ibzw==
X-Gm-Gg: ASbGncuz0raoxnfVoSqn1XPhX8xzmJgya5M1xVQwTkcM/W8PpKOYVnGCukbMplFL6in
	VC72jdK5gAbZy1L/M48+69G2AsiBuanLQaFdYxD3l/rEaxu6zXVkV7sMRFGkK7CRYKN0xOjTmtz
	P79Podyzm2EBYB/JXT8njHT/HCh7GCD0SdTqxQqe8F0z90npqbruSZYSfaQzRt5UKboVeN5Bt67
	yOpfYbFKhJW4zWkTueYEC/C+jdhSgqRphOzA6TDpJ0T/XVRGO1fb1MTSwqInOlc3xYjfwXFSxwe
	R/XGPA6Gtx9U17DDjOjHhlkGWe2F3EFL
X-Received: by 2002:a05:6000:1868:b0:3a0:b392:c2f with SMTP id ffacd0b85a97d-3a1f648782cmr10140800f8f.44.1747063479025;
        Mon, 12 May 2025 08:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRwsDfeYtYF+7qmQcCxF1BK6h492q4dwhfvDuSeqqhilSyAsRupcamC17OhxBDNUZGCm4Q8g==
X-Received: by 2002:a05:6000:1868:b0:3a0:b392:c2f with SMTP id ffacd0b85a97d-3a1f648782cmr10140783f8f.44.1747063478678;
        Mon, 12 May 2025 08:24:38 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aeb26sm173676635e9.29.2025.05.12.08.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 08:24:38 -0700 (PDT)
Date: Mon, 12 May 2025 17:24:35 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Zhao Liu
 <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Jason
 Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 13/27] target/i386/cpu: Remove
 CPUX86State::fill_mtrr_mask field
Message-ID: <20250512172435.6ad4cbbc@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-14-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-14-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:36 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The CPUX86State::fill_mtrr_mask boolean was only disabled
> for the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
> removed. Being now always %true, we can remove it and simplify
> kvm_get_msrs().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/i386/cpu.h     |  3 ---
>  target/i386/cpu.c     |  1 -
>  target/i386/kvm/kvm.c | 10 +++-------
>  3 files changed, 3 insertions(+), 11 deletions(-)
>=20
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 06817a31cf9..7585407da54 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2253,9 +2253,6 @@ struct ArchCPU {
>      /* Enable auto level-increase for Intel Processor Trace leave */
>      bool intel_pt_auto_level;
> =20
> -    /* if true fill the top bits of the MTRR_PHYSMASKn variable range */
> -    bool fill_mtrr_mask;
> -
>      /* if true override the phys_bits value with a value read from the h=
ost */
>      bool host_phys_bits;
> =20
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 6fe37f71b1e..fb505d13122 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8810,7 +8810,6 @@ static const Property x86_cpu_properties[] =3D {
>      DEFINE_PROP_UINT32("guest-phys-bits", X86CPU, guest_phys_bits, -1),
>      DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
>      DEFINE_PROP_UINT8("host-phys-bits-limit", X86CPU, host_phys_bits_lim=
it, 0),
> -    DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),

same as previous patch, deprecate 1st then remove

>      DEFINE_PROP_UINT32("level-func7", X86CPU, env.cpuid_level_func7,
>                         UINT32_MAX),
>      DEFINE_PROP_UINT32("level", X86CPU, env.cpuid_level, UINT32_MAX),
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index c9a3c02e3e3..87edce99e85 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4635,13 +4635,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>       * we're migrating to.
>       */
> =20
> -    if (cpu->fill_mtrr_mask) {
> -        QEMU_BUILD_BUG_ON(TARGET_PHYS_ADDR_SPACE_BITS > 52);
> -        assert(cpu->phys_bits <=3D TARGET_PHYS_ADDR_SPACE_BITS);
> -        mtrr_top_bits =3D MAKE_64BIT_MASK(cpu->phys_bits, 52 - cpu->phys=
_bits);
> -    } else {
> -        mtrr_top_bits =3D 0;
> -    }
> +    QEMU_BUILD_BUG_ON(TARGET_PHYS_ADDR_SPACE_BITS > 52);
> +    assert(cpu->phys_bits <=3D TARGET_PHYS_ADDR_SPACE_BITS);
> +    mtrr_top_bits =3D MAKE_64BIT_MASK(cpu->phys_bits, 52 - cpu->phys_bit=
s);
> =20
>      for (i =3D 0; i < ret; i++) {
>          uint32_t index =3D msrs[i].index;


