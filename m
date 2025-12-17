Return-Path: <kvm+bounces-66180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F156CCC84FF
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D593F3066AEB
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9CD37C0E4;
	Wed, 17 Dec 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YbDzhsGW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hGqWn+Fj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C232E748
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765983146; cv=none; b=cqUd2uTk2CuycOw8oNHGX9TlKZpLiyIehaRfAYxj+YfcE46cQpgGPmrB4A1Y2EYrPfe0a+wRz5XxbpitNkBkhFUFbweENv7SAeHdauuwqruxXoVMqNevrTxIPT+tZEfpEuRIA+0PkYHOXg0WhLbDteQdqYQqZ2YQ2R0wBa9XoM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765983146; c=relaxed/simple;
	bh=Scvugl7UHxlJ25JOKnqPA1LUYtF1dRlYgJhwYZ1KXbw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/JzNsqnjHpTHGenTSJpc7XO+MsqGnILpVs/lH9H0tICV3eReS/gcK2IEVGv5jtrcfoh8LkHLk0Xj2SHDLNyHjQ3sJtiiVWtmN+pNz6UFkmjga/La7ifs1AcfX8a8dmKuyjinl0FjnGH/DEXCV5/fme7GBe9J5MUqj7O0CC9aMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YbDzhsGW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hGqWn+Fj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765983142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gL5F3xHBPmKGkcE8K+DR/FS+dwcTcYAQDkDaOW4jcUU=;
	b=YbDzhsGW6ON1rsok65tW6CEc9C7N1+lfDMsVW7pMKI9wcCPKbJTVmqYIvYWb1Nq9LvrV6W
	fv0dOjXIXjXp4VTMCoG90H2ac82kwe2dMDObJyZijGWbW/4YyKPtOukYY5h6OHinXT5tDN
	XPEcyLNrjRle8GxNBaEM78BM8hH0Eac=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-5631PYPePLqJw8N0ECNnPg-1; Wed, 17 Dec 2025 09:52:21 -0500
X-MC-Unique: 5631PYPePLqJw8N0ECNnPg-1
X-Mimecast-MFC-AGG-ID: 5631PYPePLqJw8N0ECNnPg_1765983140
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-430f4609e80so2461540f8f.3
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765983140; x=1766587940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL5F3xHBPmKGkcE8K+DR/FS+dwcTcYAQDkDaOW4jcUU=;
        b=hGqWn+Fj7o5zM2ri3P5Z479u3jGEnw4yJKrR/OkX6CO1vRz4gUqXA9in7/gWI0ETuV
         VfG3q8rDg0zXlpd+nHR+OY+9MtbqHKo/wU2eHegNrzoK72TbsWA4eK39R9Y+lyhvHtht
         wOLs4z+h2NlH0q4uDLoEgYdb7Mx/vvrgEtR9Se/nBWz9HubvjMugNZ65kZGOWEuQr3He
         H9M7EAHXOjwo6jirocGM0MtFEiUpFyzGQIiFJDIFTSn/5TQYTaxOFuaoqFmkDmIhQQmU
         AglSbaMi9ifWdxsEDfnfbUxv+T+mtBQeYlqQtPn66YmGjuZYEnJdzUtGAY7K5GBAMBve
         KlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765983140; x=1766587940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gL5F3xHBPmKGkcE8K+DR/FS+dwcTcYAQDkDaOW4jcUU=;
        b=m0/iOYqtuJY+0JWK1njMmfurRuvDkJAgHzh9h69WAVwdaB6TnQ2t5XOCvcMs5m6orW
         B0chPGiNdkDyqHtTwDpZvM47oaRWgeoSaJldv9aGH4A5ucdxNN/1yJZDGi79MHBpMzDK
         pJIzJgzd1Ao3S+61F+Nh9qbDFBQPCQJpFb6WhE0P2D4eAYbYs5OL++wuDKvDpqHuPJDy
         +7l6sf1iB5SNgTCBspu8DiHlpld/IjL4ZHCN7zoUv8KAcrScr1pLtOtFKN/eiDUUg8D8
         yAJXbO7hSrv7xvDSFtBgnG6ENRibKSXWV03Gzsh0/ytgDDHsZ1liLw2qSZpU3W4EeLgu
         dP2w==
X-Forwarded-Encrypted: i=1; AJvYcCUKm9mwawm7Je7FtcC/FTRQL8eKrB3A5XjxIYU4usfAvps/vulXt1Rd9Adx0sR9ojjURl8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/M8/gjjp+Iov/981GfuI1w2Qd3Olzsrn44dGEcbbTnexobLVp
	8MX+eeedKGvmVAUtzrRe0mD5PrC+4ib4+olLilect8vV0ZO09WVVIxdhp8zBnjrJcET+kEWdnok
	2d9bL81SU3PItLgYPhpyJvvh/ozsfARSH4xQHDddpsFmoXWdbHtN2Uw==
X-Gm-Gg: AY/fxX4AR6lF5VYUKyzrNfTcKYcIqejHWHj/b1S7lsdivPz3oMggePMcUL/PxsBD75S
	tbzGJVZ+PzGqcZYktAUZ94oYx7SOunJD9LeaJK5KW0ByZ+UQqd4YFnonrfW76+GsloX8+txEiQ8
	jYiasaqeWR3Zpvvy/gKLOn8kTqnpfPag+re11aHxPPUCrZ4xLkkxoRvyOpItcpidTMXSRTwYyk1
	v5lee6APJ7W68uZsFSN3NZbZ/VjUswm41EziGik0MDW6JBU2gDVr9mBxPe88iIMNvXZiM/0sL8o
	ERa1Eewxo1Vn61KU/Xobtxr/X2gdQysOVySD2AZ5tYsmJtPURW+Y9zaZZ3Lr1vnhf6leWA==
X-Received: by 2002:a05:6000:178e:b0:430:f449:5f18 with SMTP id ffacd0b85a97d-430f44963b3mr14983579f8f.46.1765983140159;
        Wed, 17 Dec 2025 06:52:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+T+nY6wdecLEHnqIBz7uHvoT/b3jDw2zvtR6NcYuLs8ihAOzxrKiDhxv5l3pTSsf/IxR8dQ==
X-Received: by 2002:a05:6000:178e:b0:430:f449:5f18 with SMTP id ffacd0b85a97d-430f44963b3mr14983519f8f.46.1765983139554;
        Wed, 17 Dec 2025 06:52:19 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310adeee0esm5283851f8f.29.2025.12.17.06.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:52:19 -0800 (PST)
Date: Wed, 17 Dec 2025 15:52:14 +0100
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
Subject: Re: [PATCH v5 15/28] hw/i386: Assume fw_cfg DMA is always enabled
Message-ID: <20251217155214.71be5008@imammedo>
In-Reply-To: <20251202162835.3227894-16-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-16-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:22 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> Now all calls of x86 machines to fw_cfg_init_io_dma() pass DMA
> arguments, so the FWCfgState (FWCfgIoState) created by x86 machines
> enables DMA by default.
>=20
> Although other callers of fw_cfg_init_io_dma() besides x86 also pass
> DMA arguments to create DMA-enabled FwCfgIoState, the "dma_enabled"
> property of FwCfgIoState cannot yet be removed, because Sun4u and Sun4v
> still create DMA-disabled FwCfgIoState (bypass fw_cfg_init_io_dma()) in
> sun4uv_init() (hw/sparc64/sun4u.c).
>=20
> Maybe reusing fw_cfg_init_io_dma() for them would be a better choice, or
> adding fw_cfg_init_io_nodma(). However, before that, first simplify the
> handling of FwCfgState in x86.
>=20
> Considering that FwCfgIoState in x86 enables DMA by default, remove the
> handling for DMA-disabled cases and replace DMA checks with assertions
> to ensure that the default DMA-enabled setting is not broken.
>=20
> Then 'linuxboot.bin' isn't used anymore, and it will be removed in the
> next commit.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v4:
>  * Keep "dma_enabled" property in fw_cfg_io_properties[].
>  * Replace DMA checks with assertions for x86 machines.
> ---
>  hw/i386/fw_cfg.c     | 16 ++++++++--------
>  hw/i386/x86-common.c |  6 ++----
>  2 files changed, 10 insertions(+), 12 deletions(-)
>=20
> diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
> index 5c0bcd5f8a9f..5670e8553eaa 100644
> --- a/hw/i386/fw_cfg.c
> +++ b/hw/i386/fw_cfg.c
> @@ -215,18 +215,18 @@ void fw_cfg_build_feature_control(MachineState *ms,=
 FWCfgState *fw_cfg)
>  #ifdef CONFIG_ACPI
>  void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw_cfg)
>  {
> +    uint8_t io_size;
> +    Aml *dev =3D aml_device("FWCF");
> +    Aml *crs =3D aml_resource_template();
> +
>      /*
>       * when using port i/o, the 8-bit data register *always* overlaps
>       * with half of the 16-bit control register. Hence, the total size
> -     * of the i/o region used is FW_CFG_CTL_SIZE; when using DMA, the
> -     * DMA control register is located at FW_CFG_DMA_IO_BASE + 4
> +     * of the i/o region used is FW_CFG_CTL_SIZE; And the DMA control
> +     * register is located at FW_CFG_DMA_IO_BASE + 4
>       */
> -    Object *obj =3D OBJECT(fw_cfg);
> -    uint8_t io_size =3D object_property_get_bool(obj, "dma_enabled", NUL=
L) ?
> -        ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t) :
> -        FW_CFG_CTL_SIZE;
> -    Aml *dev =3D aml_device("FWCF");
> -    Aml *crs =3D aml_resource_template();
> +    assert(fw_cfg_dma_enabled(fw_cfg));

this was supposed to be machine agnostic, but given that it only used by x86
it shouldn't cause issues, so

Acked-by: Igor Mammedov <imammedo@redhat.com>


> +    io_size =3D ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t);
> =20
>      aml_append(dev, aml_name_decl("_HID", aml_string("QEMU0002")));
> =20
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index 1ee55382dab8..e8dc4d903bd6 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -1002,10 +1002,8 @@ void x86_load_linux(X86MachineState *x86ms,
>      }
> =20
>      option_rom[nb_option_roms].bootindex =3D 0;
> -    option_rom[nb_option_roms].name =3D "linuxboot.bin";
> -    if (fw_cfg_dma_enabled(fw_cfg)) {
> -        option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";
> -    }
> +    assert(fw_cfg_dma_enabled(fw_cfg));
> +    option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";
>      nb_option_roms++;
>  }
> =20


