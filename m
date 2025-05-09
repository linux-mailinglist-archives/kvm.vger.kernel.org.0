Return-Path: <kvm+bounces-46079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A045AB19D3
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 18:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25B8B544DE6
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 16:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D1223AE84;
	Fri,  9 May 2025 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IlL0kwck"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D99233736
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746806460; cv=none; b=ZgcDadgrfEWngsJkPZHX2o1PdqQJGUnSmEnAsZw66PIZbKPmGcg9RO339CY0aKoPNnFmJkW4vRtKnhQV3DInLoA/YZ9i/RQEgWqbqu0v4483AHD/dDRXxuyCR8F4rBTaNpm3xkAGtIiY6rzIDjwEnxIOSD0c40wXORCzlUv5x34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746806460; c=relaxed/simple;
	bh=ejGTsIZ9WkoPlOPa1D32gDUePhlXnCSw6if/wAd1jdE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fey7QKGWyjNYHIZQ/uo8WNdZux80hcNXXVJOIPXYSs3aANMJpTX8Qgiv3/PYffsg/ksHa1OR743aG8f0TJtgyVPAp0LKrZMIXXSyckE5vM86B0i6CXmuLnWbMZeMMt9slaK/myKzJ96QiZEY/NDZFBe5X10flQYK843kWPOhjZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IlL0kwck; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746806457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pp1R+sHe0G6QXL8IYhdEIVqTNgya/k6FcsiXO1F4Qzc=;
	b=IlL0kwckLF2DGQk6RDcWiCUZ9RG1YhMxHSR4WnPRR1IdhR3MVVU4rJtVu7i/q47zM6Ca56
	myom9M4VpcFlYaQzjvw3L+gmXO+0+2TH84KgaP5DayLldAe3b97niwptl+v0FMgPA3MtVl
	SPahupRyLiv0eg/WA6n2nAfsZ+q9fEM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-BBQuMOE7OO-JE4dGeN9qRA-1; Fri, 09 May 2025 12:00:56 -0400
X-MC-Unique: BBQuMOE7OO-JE4dGeN9qRA-1
X-Mimecast-MFC-AGG-ID: BBQuMOE7OO-JE4dGeN9qRA_1746806455
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so15296965e9.1
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 09:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746806454; x=1747411254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pp1R+sHe0G6QXL8IYhdEIVqTNgya/k6FcsiXO1F4Qzc=;
        b=H8gPuVhJJbiMqmwior4xu5fXpqeEVzud+FOt7mAqUlaek9v89lQRq9VTVm+Zch+OaE
         ttkzFBM5zJ3BUrus+aM6SzLxWhd9ljseGchAKztYu6nEEmtXlP9iuUgpzsTcBvxJlmlC
         yOUgv7t4FRYhJYop0FuJBmYi/ZkrW9EY6so43v3jp3SxOpMdG0DVM+0w5Hlh58/039BK
         PeiyPaN3jcD8SU714lxAUQNTO/32WoTK9qHKcg5AIkQ2cy7YtwNEVkKo5dpJJ+EPc+l0
         3MZAtSze5d7/pspoS/27VF5yPian/k9h05EGh4jNx4LE96Ib/h/NksuEEWSrkCL3mmiH
         Mtcw==
X-Forwarded-Encrypted: i=1; AJvYcCXMyr9Z3ZgzLUqhyzZVgMWfLYbcXWim0wK1JhFHGwf4a9O+mWWjCGFn6Yl8lFrAqdfjEKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPzzxfr96HU26OY5W4g0YT/B3BrqPxQI5h0JdlW7zOJ1pQDAVW
	LRrEp2o015IdCBz0sgJNWAxEQWipoYQONGpRQqQSSBIfSXM4n//oO1fotFWxXlvzgtiRUTW1M+I
	h+WcL1tgoBZ37GsdrdTyh898z4ouEFwACFKzURkPUmHJNNIcz5A==
X-Gm-Gg: ASbGnctDPwqtNppnHvnaOMCxj378BICIELuHuGDo8Rr8pnsQ2G8TCUSe7DTaOFhmOiB
	l9sfl/7jaRfKvBKKrArbRfEDZUNFWXpKTg/QOR5V45AXYemNMqvlLR3y1PPpfxYF/l9wZ5sywQa
	8ejBRn2QAoU0xTLVpq67CwHKh6Z5rquIKdkswsUbykj1YBSxEPiWTNIYGdHxW4GoVnnjP08jqnQ
	2mA6EFDXi5GubnaEh2thNt6Tit9Ng27cMSQmtr82so7H7apkVpEy1vZO7pONj5yLBzT4bRyo5Oh
	rPTUbfbn2DW6kdYUdhxl40QP1uzArTzS
X-Received: by 2002:a05:600c:699a:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-442d6d18b4dmr37308385e9.7.1746806454580;
        Fri, 09 May 2025 09:00:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHS6pTd6+VJXAdfrY7kXu0jP714J0Kn35h7fvaLNzrQyXsYvefWneKyFITxNj+O58PDLW9NnQ==
X-Received: by 2002:a05:600c:699a:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-442d6d18b4dmr37307645e9.7.1746806454010;
        Fri, 09 May 2025 09:00:54 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67df5ecsm33860625e9.9.2025.05.09.09.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 09:00:53 -0700 (PDT)
Date: Fri, 9 May 2025 18:00:50 +0200
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
Subject: Re: [PATCH v4 09/27] hw/nvram/fw_cfg: Remove
 fw_cfg_io_properties::dma_enabled
Message-ID: <20250509180050.0b91cef1@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-10-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-10-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:32 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> Now than all calls to fw_cfg_init_io_dma() pass DMA arguments,
> the 'dma_enabled' of the TYPE_FW_CFG_IO type is not used anymore.
> Remove it, simplifying fw_cfg_init_io_dma() and fw_cfg_io_realize().
>=20
> Note, we can not remove the equivalent in fw_cfg_mem_properties[]
> because it is still used in HPPA and MIPS Loongson3 machines:
>=20
>   $ git grep -w fw_cfg_init_mem_nodma
>   hw/hppa/machine.c:204:    fw_cfg =3D fw_cfg_init_mem_nodma(addr, addr +=
 4, 1);
>   hw/mips/loongson3_virt.c:289:    fw_cfg =3D fw_cfg_init_mem_nodma(cfg_a=
ddr, cfg_addr + 8, 8);
>=20
> 'linuxboot.bin' isn't used anymore, we'll remove it in the
> next commit.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  hw/i386/fw_cfg.c     |  5 +----
>  hw/i386/x86-common.c |  5 +----
>  hw/nvram/fw_cfg.c    | 26 ++++++++------------------
>  3 files changed, 10 insertions(+), 26 deletions(-)
>=20
> diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
> index 5c0bcd5f8a9..1fe084fd720 100644
> --- a/hw/i386/fw_cfg.c
> +++ b/hw/i386/fw_cfg.c
> @@ -221,10 +221,7 @@ void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw=
_cfg)
>       * of the i/o region used is FW_CFG_CTL_SIZE; when using DMA, the
>       * DMA control register is located at FW_CFG_DMA_IO_BASE + 4
>       */
> -    Object *obj =3D OBJECT(fw_cfg);
> -    uint8_t io_size =3D object_property_get_bool(obj, "dma_enabled", NUL=
L) ?
> -        ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t) :
> -        FW_CFG_CTL_SIZE;
> +    uint8_t io_size =3D ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t=
);
>      Aml *dev =3D aml_device("FWCF");
>      Aml *crs =3D aml_resource_template();
> =20
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index 27254a0e9f1..ee594364415 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -991,10 +991,7 @@ void x86_load_linux(X86MachineState *x86ms,
>      }
> =20
>      option_rom[nb_option_roms].bootindex =3D 0;
> -    option_rom[nb_option_roms].name =3D "linuxboot.bin";
> -    if (fw_cfg_dma_enabled(fw_cfg)) {
> -        option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";
> -    }
> +    option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";
>      nb_option_roms++;
>  }
> =20
> diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
> index 51b028b5d0a..ef976a4bce2 100644
> --- a/hw/nvram/fw_cfg.c
> +++ b/hw/nvram/fw_cfg.c
> @@ -1026,12 +1026,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, ui=
nt32_t dma_iobase,
>      FWCfgIoState *ios;
>      FWCfgState *s;
>      MemoryRegion *iomem =3D get_system_io();
> -    bool dma_requested =3D dma_iobase && dma_as;
> =20
> +    assert(dma_iobase);
>      dev =3D qdev_new(TYPE_FW_CFG_IO);
> -    if (!dma_requested) {
> -        qdev_prop_set_bit(dev, "dma_enabled", false);
> -    }
> =20
>      object_property_add_child(OBJECT(qdev_get_machine()), TYPE_FW_CFG,
>                                OBJECT(dev));
> @@ -1042,13 +1039,10 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, u=
int32_t dma_iobase,
>      memory_region_add_subregion(iomem, iobase, &ios->comb_iomem);
> =20
>      s =3D FW_CFG(dev);
> -
> -    if (s->dma_enabled) {
> -        /* 64 bits for the address field */
> -        s->dma_as =3D dma_as;
> -        s->dma_addr =3D 0;
> -        memory_region_add_subregion(iomem, dma_iobase, &s->dma_iomem);
> -    }
> +    /* 64 bits for the address field */
> +    s->dma_as =3D dma_as;
> +    s->dma_addr =3D 0;
> +    memory_region_add_subregion(iomem, dma_iobase, &s->dma_iomem);
> =20
>      return s;
>  }
> @@ -1185,8 +1179,6 @@ static void fw_cfg_file_slots_allocate(FWCfgState *=
s, Error **errp)
>  }
> =20
>  static const Property fw_cfg_io_properties[] =3D {
> -    DEFINE_PROP_BOOL("dma_enabled", FWCfgIoState, parent_obj.dma_enabled,
> -                     true),

in 7/27 you still have, fw_cfg_dma_enabled(fw_cfg) which works around
now missing property (in IO case) in obscure way.
that is also used in bios_linker_loader_can_write_pointer().

It would be better to get rid of fw_cfg_dma_enabled() as well
or keep property as RO and replace fw_cfg_dma_enabled() with property
accessor if both calls can happen on nondma path                     =20


>      DEFINE_PROP_UINT16("x-file-slots", FWCfgIoState, parent_obj.file_slo=
ts,
>                         FW_CFG_FILE_SLOTS_DFLT),
>  };
> @@ -1207,11 +1199,9 @@ static void fw_cfg_io_realize(DeviceState *dev, Er=
ror **errp)
>      memory_region_init_io(&s->comb_iomem, OBJECT(s), &fw_cfg_comb_mem_op=
s,
>                            FW_CFG(s), "fwcfg", FW_CFG_CTL_SIZE);
> =20
> -    if (FW_CFG(s)->dma_enabled) {
> -        memory_region_init_io(&FW_CFG(s)->dma_iomem, OBJECT(s),
> -                              &fw_cfg_dma_mem_ops, FW_CFG(s), "fwcfg.dma=
",
> -                              sizeof(dma_addr_t));
> -    }
> +    memory_region_init_io(&FW_CFG(s)->dma_iomem, OBJECT(s),
> +                          &fw_cfg_dma_mem_ops, FW_CFG(s), "fwcfg.dma",
> +                          sizeof(dma_addr_t));
> =20
>      fw_cfg_common_realize(dev, errp);
>  }


