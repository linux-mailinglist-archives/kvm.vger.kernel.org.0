Return-Path: <kvm+bounces-66256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FBCCCBF7E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 70064305B1D6
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 13:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2E8325483;
	Thu, 18 Dec 2025 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/U93GAB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDEngMiL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9DD2E2DFB
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 13:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766063824; cv=none; b=Ub5c0faJktbpxqv0XvzBkK/IdCwREueCT19qifSYKB0JTxpsMsu0CegxoyPctIYx4lTjm4B39mij8yyw2D/JPgkZfqN6Dz5ECeqpPy9da/QDA/7NpCh8WiXqUtB0gt7giwOT97f22Y3vOoNboplQx2ioEig1xvgSTbdWJ60Ufog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766063824; c=relaxed/simple;
	bh=FMrYXDIcT8W61zOBuclA60KdyQywVUCtOd/OnTmnIBs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXbs3a4IokcezaNEaRL3oNoCmwzVbkNkUDwRz+tCJVY6UFqHZhtJEp80ktiRoQOgndsubWbn7O69Tz6x8MosiOUMABg7jRU2cuYRmmXYcE2IdE0ZnLYTBouIsXlnzTkRpWrFxA33nlfvedngsvfZYg92l9hgzA+d3jumq/f7YlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/U93GAB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDEngMiL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766063820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6j7TiY365GJDQffnjJjAGK4FQJdyrblUZ9cP/4dJY4=;
	b=D/U93GAB46IQJjsdyo1n/ho7cOWS7u7G+nQQTjUOO5eqKrjrH9vnN7/6TtqnocMgB6mvVK
	PzoPZjU62ZtJxCZ4/q+dAzCy2nlBBHR+yeMRoh9aENoKB+PWCovjU+SpbOkL3IQ7DM0nP3
	iRJWQ06hRtY666zQ1MXs3v775pUX3SI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-Qhf7RSvFORO7F4vFHWoTPw-1; Thu, 18 Dec 2025 08:16:59 -0500
X-MC-Unique: Qhf7RSvFORO7F4vFHWoTPw-1
X-Mimecast-MFC-AGG-ID: Qhf7RSvFORO7F4vFHWoTPw_1766063818
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f5dcd4d3so356921f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 05:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766063818; x=1766668618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6j7TiY365GJDQffnjJjAGK4FQJdyrblUZ9cP/4dJY4=;
        b=HDEngMiLl4HO0vKEDxQlcNl7PBUYMchaLx7hDGQ+IwAQVuC8U0JkZqmPdK6v7VVEg6
         grGW8P9IGkZ0To23PHw4UV2ag7QdNmDaMTM9l1hbSMtYiLxNcq+a0FjUrHihRSFMfd9p
         e9935ATlfZGBMP1h+maTFhsWISydsjJdo9OgwCjlTrPcLybCivo1VR65n1OvQhDex5CI
         L93r3bxPqLVdiiJO3BDPHDE5NGO4lDjciC/283XDIy0DZd1lb/1QPO18R3TC5qlq3YOF
         mwAr3Jg74ZrBOW+lA+sfX0T5KFHOyL97Pw4364jtyYVMgiYOjOEKpw1aJVkpgKIjRpXi
         Dkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766063818; x=1766668618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6j7TiY365GJDQffnjJjAGK4FQJdyrblUZ9cP/4dJY4=;
        b=Fnko8xRCBaMJ8OqO3zrMPezVp5nFLnPKgTyYDFN3xYsARqXSUIZ/tekN85D5rT/VMM
         Oux4crsRLGGMnGC8x1S7WM/TYLW3q6PxJgeKC7i3+AIzAgMGXjdPWQr721My0sqB+h1w
         Hc2i1Ys7IRpR1f8B7v4Glm7xIPpwpNaC2qZ7K2HDJ2QeqHu4zejrbtgQ2BGlV/XJuIi3
         JSX/BvprH/7tqSZvM7UrZqpCmExqcsdGkwKVRAjGgfdAmKjYrdlPjYmdtuTQ4qAqnJVn
         ynhiZzFM14fvS2zRarkzTXxLRt5Jim13P6q1PptZtTZTi8xYUfzcc1NS31OyvZKqPdu9
         zyGA==
X-Forwarded-Encrypted: i=1; AJvYcCUpdizoEGUWDyes9lY+j9tlBasAOJYZXeK6pL9EV4rHGa5OHvjdJXHkSw4nQR1JAuOHSZA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3I+wcRSFDG1t+mfDc0dt+g3L3A9GfG852HsyT52n1IAe98Iuw
	g+V+888PXu+ip7KN/8g1SSKZp774vetvWODNpQ/NUggx/YgM/k1JUCx35LchSSDQ3Njs3FizHtC
	VY1NN7VBYyaqfZQ1R7MPmMNDPAirMxwFOiMxAU3rVPjeROcQbQR+xkQ==
X-Gm-Gg: AY/fxX7tu/qCBnh3htJI+EdTxQQ4mPdi4wi1b6//joeuKzRHNcfA/tXF1pM0vWGhkka
	3FYtRd1iBlVGTjKUnu/NRQVHCTPUQlexJWRM6JFIR5jO1RV0RAR2zzkcVmXSKDAkj6HldtPD8VJ
	5S5DKTldia7oVs3FVvKMBAdbTtu855Q9v7g4WA65ZRsk3/SA8YH4StwjYfib+1M7QA9FQx0wrur
	VRTHkGAqXK+zMMVswZthTwCjjTWQQQ841Zyw5zNClAYMpmSpIr/lYCbScVTA1EQxb44QPTWvKkz
	x8IUHxZzAoWZVmK1VeHVq7oPHJKVf3qSJHhawBzM5U0qWg5eEzMHu3cpuU7JC+3AxRoydA==
X-Received: by 2002:a05:6000:1848:b0:431:cf0:2e8b with SMTP id ffacd0b85a97d-432448ac61dmr3316974f8f.29.1766063818306;
        Thu, 18 Dec 2025 05:16:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFzPRYLdA9aqkfme3vftsM2x6w3AnDICmu456zKjmpq+1pcYRrN040I6jJAyyDJQTi4+yLLEw==
X-Received: by 2002:a05:6000:1848:b0:431:cf0:2e8b with SMTP id ffacd0b85a97d-432448ac61dmr3316909f8f.29.1766063817795;
        Thu, 18 Dec 2025 05:16:57 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432449986f1sm5011202f8f.29.2025.12.18.05.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:16:57 -0800 (PST)
Date: Thu, 18 Dec 2025 14:16:54 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas
 Huth <thuth@redhat.com>, qemu-devel@nongnu.org, devel@lists.libvirt.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, Richard
 Henderson <richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, Eduardo
 Habkost <eduardo@habkost.net>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai
 Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark
 Cave-Ayland <mark.caveayland@nutanix.com>, BALATON Zoltan
 <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>, Jiri Denemark
 <jdenemar@redhat.com>
Subject: Re: [PATCH v5 17/28] hw/i386/pc: Remove pc_compat_2_6[] array
Message-ID: <20251218141654.5862533b@imammedo>
In-Reply-To: <20251202162835.3227894-18-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-18-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:24 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The pc_compat_2_6[] array was only used by the pc-q35-2.6
> and pc-i440fx-2.6 machines, which got removed. Remove it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/i386/pc.c         | 8 --------
>  include/hw/i386/pc.h | 3 ---
>  2 files changed, 11 deletions(-)
>=20
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 2e315414aeaf..85d12f8d0389 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -263,14 +263,6 @@ GlobalProperty pc_compat_2_7[] =3D {
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
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 698e3fb84af0..f8f317aee197 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -295,9 +295,6 @@ extern const size_t pc_compat_2_8_len;
>  extern GlobalProperty pc_compat_2_7[];
>  extern const size_t pc_compat_2_7_len;
> =20
> -extern GlobalProperty pc_compat_2_6[];
> -extern const size_t pc_compat_2_6_len;
> -
>  #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
>      static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
>                                                   const void *data) \


