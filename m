Return-Path: <kvm+bounces-46076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814DFAB190D
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 17:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1689527ED6
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 15:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D7D230268;
	Fri,  9 May 2025 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0rohQAp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C6E22F767
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746805297; cv=none; b=b3ToVTnVvETh8yZjEJ51ri4Mnlb8k9w8VhtBmVQAZSVOqJg/g6f/aWJDo7Jy90qY6GZS/upo8UFsQFxG9LlYH2nJAkhv7xLjiKteOz/I1GXdjHQShRPj3G9AgsxT8FB2GVMD9/OV5OrVg9AhFuH3scpwsQdFbX+yDqzVCjQuicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746805297; c=relaxed/simple;
	bh=sMlOsAcPMDQnG76K9gaoPjvfiOA/fEIKbIGRNrknf0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+HPYzaMI0uY/6n+hMwfE/bTGwuEPafTqj/qvY3YI5m91goopFi3epE4E8D4rSWo0GtJjprDn/XBF40uXxpCHUGtd26MvWlHAcP0K0bGhVhstFrw/D2o+Fi06EWRtfiaOL7wPUWXHAieLRl51EJSXMwiTNK0+2J+0iUBLxfvqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0rohQAp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746805293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOLaybYm4U7uIKxuBSKD+ubf4Ws7sD4/jVMWvakjmJ0=;
	b=W0rohQApZwjj4iPRRpb8EZ27apq/wybbol+OcpStCAvnyI/7rdjIU+SpC0a1CktIhDaVFH
	SoZlFpF4WdSjFLEACOUmXK/xcti6cPGzvyZRBXFjDV4AOzvn9gw5xX+78v5IIkgtpwBt+0
	T6rAka3qFKAW6dthamogcyk/TSTj9VU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-QDk1hd2CPmimFybgeAVwnQ-1; Fri, 09 May 2025 11:41:30 -0400
X-MC-Unique: QDk1hd2CPmimFybgeAVwnQ-1
X-Mimecast-MFC-AGG-ID: QDk1hd2CPmimFybgeAVwnQ_1746805289
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-39c2da64df9so1014192f8f.0
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 08:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746805289; x=1747410089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOLaybYm4U7uIKxuBSKD+ubf4Ws7sD4/jVMWvakjmJ0=;
        b=Qlh2JKSOFaa/rHrr+m83vhSc9I5ORCBUgYvV7CME1NwiOI5IQ7CNPv0njhyPtzxp+U
         AS11zMjsX2V5f8n8Xk+qfXEWpN6AYkfboFDGpdswwfFc4XsDt22eFSBI5cjQRvyDs3Fu
         V22Rbc9UNLYMz+592kM5M9Pz4Ye1jR8rnilBwP1cbVElT1bVEeU0sTzrI4x2g209X8n2
         GGAwzBS7V0sAbzY9RxImoFthu39iRUAutThO34UxKdwq+k8ye8X4ydRDbrU8Rxz8VKf2
         HoKxOwEBiJQmMBwQvaLh6vD9Qd/eex8iyvg5NhHm7qkcw5J4P1ERhF6YR+KUCb5JQxrR
         xHow==
X-Forwarded-Encrypted: i=1; AJvYcCWMGNukUI4FjeJ3vbw1mdsyp+J926YIc9YnuXJpt4DmFCOP57xi6gwzoB8Qpqh0RrZYB5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOVQTuYoh3kd3nAFGAk6itA9b3R5li+4sMssci2Zhg3nx6bEJU
	0KqwqgOzOGRuY2WjMzcKLhkxhBa15Ce2Hd2wjYCAPsAS6kekdiRQI9VIq3VFLf4ZDnIcA7+Mftv
	SB+JbSi4DX0XpG8mUKJ4r5c77x+W0BzlK8gn4sYHeYpFXYz7sng==
X-Gm-Gg: ASbGncu3Uf9GXUTf/dZvVYZBC/13STAdHxJ05L6KhivHXJoTqnpLDEsIptHVAKBNfVP
	uL/NcfDX/6+YU600iUvwyjxsZl6SczwPmNRSQj6I3O9ZU3IqIRoPVco6j5A2hzWvt0oLEaBzTH6
	QBwz9L4P3mWmjmzSmmaBrw7KwNZsrRdtWWhDSSwSfquioWK1O9R1w3ljHIDyiMa0wgnA+DT7I0t
	6tig5nwFamYoIBjdH0cfk7YdXZlN4WZhN08h+v8+Ywz2/TZKoD/NSkLD9gNIYN/SICCP3Hq2qlm
	1T3ebq1mfopPJYj4uGbixQLbNHqzieK+
X-Received: by 2002:a5d:5984:0:b0:3a0:a0d1:1131 with SMTP id ffacd0b85a97d-3a1f643ab18mr3673892f8f.7.1746805289152;
        Fri, 09 May 2025 08:41:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeXwnOQIA5iqmq6aNcokUi8KYZ3Caz1PT8VQbuQhO6YtpVywVdoQp89AyDaZzMhCBLxiiXHw==
X-Received: by 2002:a5d:5984:0:b0:3a0:a0d1:1131 with SMTP id ffacd0b85a97d-3a1f643ab18mr3673848f8f.7.1746805288681;
        Fri, 09 May 2025 08:41:28 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ecaeasm3581262f8f.28.2025.05.09.08.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 08:41:28 -0700 (PDT)
Date: Fri, 9 May 2025 17:41:25 +0200
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
Subject: Re: [PATCH v4 07/27] hw/i386/x86: Remove
 X86MachineClass::fwcfg_dma_enabled field
Message-ID: <20250509174125.41bc03a3@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-8-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-8-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:30 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The X86MachineClass::fwcfg_dma_enabled boolean was only used
> by the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
> removed. Remove it and simplify.
>=20
> 'multiboot.bin' isn't used anymore, we'll remove it in the
> next commit.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  include/hw/i386/x86.h | 2 --
>  hw/i386/microvm.c     | 3 ---
>  hw/i386/multiboot.c   | 7 +------
>  hw/i386/x86-common.c  | 3 +--
>  hw/i386/x86.c         | 2 --
>  5 files changed, 2 insertions(+), 15 deletions(-)
>=20
> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
> index fc460b82f82..29d37af11e6 100644
> --- a/include/hw/i386/x86.h
> +++ b/include/hw/i386/x86.h
> @@ -29,8 +29,6 @@
>  struct X86MachineClass {
>      MachineClass parent;
> =20
> -    /* use DMA capable linuxboot option rom */
> -    bool fwcfg_dma_enabled;
>      /* CPU and apic information: */
>      bool apic_xrupt_override;
>  };
> diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
> index e0daf0d4fc3..b1262fb1523 100644
> --- a/hw/i386/microvm.c
> +++ b/hw/i386/microvm.c
> @@ -637,7 +637,6 @@ GlobalProperty microvm_properties[] =3D {
> =20
>  static void microvm_class_init(ObjectClass *oc, const void *data)
>  {
> -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(oc);
>      MicrovmMachineClass *mmc =3D MICROVM_MACHINE_CLASS(oc);
>      MachineClass *mc =3D MACHINE_CLASS(oc);
>      HotplugHandlerClass *hc =3D HOTPLUG_HANDLER_CLASS(oc);
> @@ -671,8 +670,6 @@ static void microvm_class_init(ObjectClass *oc, const=
 void *data)
>      hc->unplug_request =3D microvm_device_unplug_request_cb;
>      hc->unplug =3D microvm_device_unplug_cb;
> =20
> -    x86mc->fwcfg_dma_enabled =3D true;
> -
>      object_class_property_add(oc, MICROVM_MACHINE_RTC, "OnOffAuto",
>                                microvm_machine_get_rtc,
>                                microvm_machine_set_rtc,
> diff --git a/hw/i386/multiboot.c b/hw/i386/multiboot.c
> index 6e6b96bc345..bfa7e8f1e83 100644
> --- a/hw/i386/multiboot.c
> +++ b/hw/i386/multiboot.c
> @@ -153,7 +153,6 @@ int load_multiboot(X86MachineState *x86ms,
>                     int kernel_file_size,
>                     uint8_t *header)
>  {
> -    bool multiboot_dma_enabled =3D X86_MACHINE_GET_CLASS(x86ms)->fwcfg_d=
ma_enabled;
>      int i, is_multiboot =3D 0;
>      uint32_t flags =3D 0;
>      uint32_t mh_entry_addr;
> @@ -402,11 +401,7 @@ int load_multiboot(X86MachineState *x86ms,
>      fw_cfg_add_bytes(fw_cfg, FW_CFG_INITRD_DATA, mb_bootinfo_data,
>                       sizeof(bootinfo));
> =20
> -    if (multiboot_dma_enabled) {
> -        option_rom[nb_option_roms].name =3D "multiboot_dma.bin";
> -    } else {
> -        option_rom[nb_option_roms].name =3D "multiboot.bin";

shouldn't we remove "multiboot.bin" as well?

> -    }
> +    option_rom[nb_option_roms].name =3D "multiboot_dma.bin";
>      option_rom[nb_option_roms].bootindex =3D 0;
>      nb_option_roms++;
> =20
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index 1b0671c5239..27254a0e9f1 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -634,7 +634,6 @@ void x86_load_linux(X86MachineState *x86ms,
>                      int acpi_data_size,
>                      bool pvh_enabled)
>  {
> -    bool linuxboot_dma_enabled =3D X86_MACHINE_GET_CLASS(x86ms)->fwcfg_d=
ma_enabled;
>      uint16_t protocol;
>      int setup_size, kernel_size, cmdline_size;
>      int dtb_size, setup_data_offset;
> @@ -993,7 +992,7 @@ void x86_load_linux(X86MachineState *x86ms,
> =20
>      option_rom[nb_option_roms].bootindex =3D 0;
>      option_rom[nb_option_roms].name =3D "linuxboot.bin";
> -    if (linuxboot_dma_enabled && fw_cfg_dma_enabled(fw_cfg)) {
> +    if (fw_cfg_dma_enabled(fw_cfg)) {
>          option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";
>      }
>      nb_option_roms++;
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index f80533df1c5..dbf104d60af 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -375,14 +375,12 @@ static void x86_machine_initfn(Object *obj)
>  static void x86_machine_class_init(ObjectClass *oc, const void *data)
>  {
>      MachineClass *mc =3D MACHINE_CLASS(oc);
> -    X86MachineClass *x86mc =3D X86_MACHINE_CLASS(oc);
>      NMIClass *nc =3D NMI_CLASS(oc);
> =20
>      mc->cpu_index_to_instance_props =3D x86_cpu_index_to_props;
>      mc->get_default_cpu_node_id =3D x86_get_default_cpu_node_id;
>      mc->possible_cpu_arch_ids =3D x86_possible_cpu_arch_ids;
>      mc->kvm_type =3D x86_kvm_type;
> -    x86mc->fwcfg_dma_enabled =3D true;
>      nc->nmi_monitor_handler =3D x86_nmi;
> =20
>      object_class_property_add(oc, X86_MACHINE_SMM, "OnOffAuto",


