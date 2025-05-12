Return-Path: <kvm+bounces-46144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 499F3AB3162
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 10:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9875D1681C5
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 08:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394602586E7;
	Mon, 12 May 2025 08:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJ9V0/OM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B2F257AD8
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 08:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747037961; cv=none; b=qMJaHBMNoXXBvS5fdFbgsaaWEC99tkEIFS455D2vwVk/XpXBtRyMyT3BWatFAxl3055cfwS/mQX2iSS0Bj1uf64Jq8C/bhje7xmSzEFV+hZaTl1ptdHbO20r1qu+j59Ack3pbnsplB0dWRs4PcQp010WFCRZkfmZWAMcBbmunug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747037961; c=relaxed/simple;
	bh=Q+ufGwWbCFYH5RyE+M42tQyCjIWeyU3Z7hRilnJt7Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEr9iDBdx32fUIOETvYJGT9Q8Y9x5QYhX9k7omujIUGiFjf1/Ujt2Was+03mRcy7z0c89WgL0o9sWEv1W+Ue+aDRSqtOnhtju1DOoCi6x8NaSm8O9ANALDCQ0CNwYY6/6L1rc7420BWPTndJFvoxRggBWBcJWfxes7tHzA0F92o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJ9V0/OM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747037958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2fvSZBSz7SW+rN/UmgDYVlAuf9XOlhIq2nJC4JEI3cs=;
	b=BJ9V0/OMdwJUs5GDKQuX1TO8YIEiDxkd5hDcGN6/JnQCIQX3fDjTdoD8wx5eG4IHcXAb5L
	ZcuDZNlxjRO9KDm8EtZBMYv9pkjrstYGrXxVZABpjQ63kigq8ozM/KLjoggeVxIwTzp+El
	XiMhUNVPrHcSbVdcp3N+m117ZDOvNWM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-gazoLOVyN_SL7PigrR4yRw-1; Mon, 12 May 2025 04:19:16 -0400
X-MC-Unique: gazoLOVyN_SL7PigrR4yRw-1
X-Mimecast-MFC-AGG-ID: gazoLOVyN_SL7PigrR4yRw_1747037955
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a0b9bbfa5dso1340483f8f.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 01:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747037955; x=1747642755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2fvSZBSz7SW+rN/UmgDYVlAuf9XOlhIq2nJC4JEI3cs=;
        b=VEKk15oKFUc6O4CotulV0h89P8UdGymwqqJ7zvb//Z/N+g+3/2QXfoFT2jme45MP1e
         A0d7m3Gt4AlpPMPH2Ep/PtONB92MmbdEwyCM5S4AoMXJWUprPT0sYo1H3CgHY9TLulP+
         keDdF0UTCc7cjSk062C6FA8dM6S3xGdjwlfPffINcAHkr7V5ey8CXAK8AX9qsC1yqdsF
         9S5dYd/buMR2ipCxt7BqY34KNKoYWI73PxQk1Ixxu2YL8E7JLnqIwx5Ye6oN6ijrFL/X
         lv6CUcFdzLwjf0yv4S2G/rk8Nnw4yF068JIWeseb/LQJpxvduGK17nPuSlXEKYhZ1bJ3
         7RYg==
X-Forwarded-Encrypted: i=1; AJvYcCVQbtQAo1Yybxk2qjNXS9Nuu13Sy4D/NauzTHSf9tBmLO7ZtWExLsLig/IuXyenq9HSOCI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz9/18pyC2A9Ob6xo2jDGbmyRjK3zd7HaLahrWazyZLmJ4PipS
	Zw3hKwstqwjCMjx47bs7OPeGysZNgVcncrzU4ugBGaDnZ5QE+KIEjP+qcbwuWPuWwqD5JJI092m
	m0dvpngsZuUwDKS312TnjpghejdbdXDio+u3vVP+iUSc8ZWXLpA==
X-Gm-Gg: ASbGncvXVPq515zU8nqUaCoWoHIrNrkFNmeBYycDEoYXjbOMveKlO7e1VOgXUOp6Qxu
	WXH2QJtV60Ws8s0FMwARnY4gIVixDafseqIvw+EYigY+StM8bk64FNEiAxmHJdYbeLepKVQAXhY
	E1SWEgjeseuDBTSkspnm8Pka4Hh++5PLNHSWvL65BACcXulmQJ5Kj1hDezQlGJ1Peqv30iE6AD9
	UawIUGZuYJERLEKt5WMfVwwXzyWjEEvyS44lieDVOvdjB7e4L5hTHRDvSNBZfykY+jAvnwQ7sOh
	Y5nCMLQyAm2neerY/usmY/JKlT0YxxTE
X-Received: by 2002:a05:6000:401e:b0:3a0:aee0:c647 with SMTP id ffacd0b85a97d-3a1f64374e1mr9506408f8f.17.1747037955351;
        Mon, 12 May 2025 01:19:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgHeilnFjVtlzQeFAWYCb/Ncwx/SQ6IkBm/EN6BrcPThYXSIr2QrCJWo6KgNXFdjoS9BV4Tg==
X-Received: by 2002:a05:6000:401e:b0:3a0:aee0:c647 with SMTP id ffacd0b85a97d-3a1f64374e1mr9506370f8f.17.1747037954950;
        Mon, 12 May 2025 01:19:14 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d6858626sm118499335e9.27.2025.05.12.01.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 01:19:14 -0700 (PDT)
Date: Mon, 12 May 2025 10:19:12 +0200
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
 Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 11/27] hw/i386/pc: Remove pc_compat_2_6[] array
Message-ID: <20250512101912.6900beaf@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-12-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-12-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:34 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The pc_compat_2_6[] array was only used by the pc-q35-2.6
> and pc-i440fx-2.6 machines, which got removed. Remove it.

see my comment in 1/27

>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  include/hw/i386/pc.h | 3 ---
>  hw/i386/pc.c         | 8 --------
>  2 files changed, 11 deletions(-)
>=20
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index a3de3e9560d..4fb2033bc54 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -292,9 +292,6 @@ extern const size_t pc_compat_2_8_len;
>  extern GlobalProperty pc_compat_2_7[];
>  extern const size_t pc_compat_2_7_len;
> =20
> -extern GlobalProperty pc_compat_2_6[];
> -extern const size_t pc_compat_2_6_len;
> -
>  #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
>      static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
>                                                   const void *data) \
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 4e6fe68e2e0..65a11ea8f99 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -251,14 +251,6 @@ GlobalProperty pc_compat_2_7[] =3D {
>  };
>  const size_t pc_compat_2_7_len =3D G_N_ELEMENTS(pc_compat_2_7);
> =20
> -GlobalProperty pc_compat_2_6[] =3D {
> -    { TYPE_X86_CPU, "cpuid-0xb", "off" },
> -    { "vmxnet3", "romfile", "" },
> -    { TYPE_X86_CPU, "fill-mtrr-mask", "off" },
> -    { "apic-common", "legacy-instance-id", "on", }
> -};
> -const size_t pc_compat_2_6_len =3D G_N_ELEMENTS(pc_compat_2_6);
> -
>  /*
>   * @PC_FW_DATA:
>   * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables


