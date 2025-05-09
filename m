Return-Path: <kvm+bounces-46080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3781AB19ED
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 18:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F908A28078
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 16:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCF72343C0;
	Fri,  9 May 2025 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/JovYfL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21162A1BB
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746806662; cv=none; b=d4ohTko27XAZOmqilPMombHSnf+4f9+/2/1yrVD3fPZF41BE3B6dWuhKCaCmtTOtBSzwV9Qtqf9TAYJMhLnz9Z2z5wwurb87taV/YZ8q9fYQ8pN6cUzrSofd1mqm5oHJwlRr2GsbMOA48m3zXAe0tM2WeXmZA8LJXzMEN+8zGhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746806662; c=relaxed/simple;
	bh=XBf4pMOihcg+OiiRoELLoYXyEIkmJ6XM/gbQEDTjqpI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i5pNdlYFV5BwLCjRXYFMytU3miPnuWFswI8D901+zetssXlKhRuNeLlyzFeNmbbFU5vN3uVds4o8YIAJ+phkVgwk5lcMpCpHcbXPHu9fK0kZ/cWyJ4jqz++iLwZxO17OkSGUVIJrwZES5gpAXfTW0Zuj8QMyZCkwPnB8Rq1ycwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/JovYfL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746806659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9SGTty9vioSZ28fB68+a+8ZO7FqN4j+nQiW9zGlb68=;
	b=a/JovYfLtIaHNBOe3KXsjRReSVZvQd6WGyzjFjThVU2ZJAon8sHklNwsnQLeEHM7NGD61r
	mDdPau/dSB823q2BLM3cCU4Rndt0Fq72V8NL3e27qo1vDx8uav/DkfV7UwrkQ2jGKuvkjl
	Mt+uUlcnDQncAqD9ZI+3GTvpLLzDWMw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-g21MiOnKOWu-8_W6h3Ra4w-1; Fri, 09 May 2025 12:04:18 -0400
X-MC-Unique: g21MiOnKOWu-8_W6h3Ra4w-1
X-Mimecast-MFC-AGG-ID: g21MiOnKOWu-8_W6h3Ra4w_1746806657
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a1f7204d72so520631f8f.0
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 09:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746806656; x=1747411456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9SGTty9vioSZ28fB68+a+8ZO7FqN4j+nQiW9zGlb68=;
        b=jm7Y+++ZK1m1LFRAquuNCnVyFqoWpU0qkvDF33TBACCmfICGM0pCbHnO+ksd3ZTxj2
         fvWkNFuMuZBFSDHOPpkVivT9v0ilp5XQV+31cJZzhLjy45Lv12uXbb5QEPE9Bqx6//yc
         emb4S0ykPYNCy6K7o7sds/OsLrvZDMLo6xh6LzD4LKSfj4zG8tgNQT+BBKn4Ry9U+3Fb
         dwe9zRguPIlgYLTP7blZGGZBWbh5JqI5tK9Kd7joiMm7mruIG2Dmo9M196wW7TLML66r
         4WKhQ6TFrahklrA2DGyl8U6oBEHwPbLtk5mqOhsg45HyLkxNQmr1+rk2iYvGCcMdPL9d
         iNtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq2QRq695H1qqT5fVxdVMdgMqiSIZJmjkF6oSvRQBN9SjDkh8S1HKHTCv8cx99jT4jSv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YypeD+cppXuFwHG6ayNuFqEWdgTTMm64tJBNm/mZP5c00bQ4HHe
	uSRaRPqFTCbNYdODgPRbVoTAKZsgBvbN9aUKBmvPQv+zehGcktxIsHVzgHtpMLuaU1O5eoShFRa
	uvJSDRoPlMBYdLUhrncgRis26L/WvFmhO7gcbrplxwFkHUf/pDs/yEJnJvyJC
X-Gm-Gg: ASbGnctbYZBEgtWI0HiGcg9BIcGBEXAhfElzoZM25zamCnH6OffPFfPH3N0tssFKMXX
	ormpD2lZOVOBqpz9thkvaD1XiI2fTxe0Ctcv2oFVpn8kIKI1DOcPTFnXpxbQNs1uMGARrHe3KCI
	nYwNdmur2WnSy2ZaZcRVTw5pw6t0EijKHIHZaxYJ5vKSXqgy+sbAByQDqTW5HhHpCFK0/5U7zEF
	qwn58DHBZ4N8xy1O2owyCwrf8jOntsmJXXiFLy5seKBJClVbox/CUg3U+Q1AQYsXFa3fFOtd2lQ
	ULpLtHWDKu6gztk9ffyDr/mfQicZSVGj
X-Received: by 2002:a05:6000:3113:b0:39c:1f0e:95af with SMTP id ffacd0b85a97d-3a1f64279d3mr3602014f8f.3.1746806656218;
        Fri, 09 May 2025 09:04:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6cQYF6EWJWz+6FcQdM7QsRdpFYn7ZHkZ4Tmns/dMEuuVwt/TrFHlK5zhhQj3FktvxJlzsog==
X-Received: by 2002:a05:6000:3113:b0:39c:1f0e:95af with SMTP id ffacd0b85a97d-3a1f64279d3mr3601929f8f.3.1746806655504;
        Fri, 09 May 2025 09:04:15 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2d2d3sm3674769f8f.63.2025.05.09.09.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 09:04:15 -0700 (PDT)
Date: Fri, 9 May 2025 18:04:11 +0200
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
 Wang <jasowang@redhat.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 10/27] hw/i386/pc: Remove linuxboot.bin
Message-ID: <20250509180411.10f6e683@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-11-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-11-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:33 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> All PC machines now use the linuxboot_dma.bin binary,
> we can remove the non-DMA version (linuxboot.bin).
>=20
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  hw/i386/pc.c                  |   3 +-


linuxboot.bin is referenced in a few more files:

hw/i386/x86-common.c:    option_rom[nb_option_roms].name =3D "linuxboot.bin=
";
hw/nvram/fw_cfg.c:    { "genroms/linuxboot.bin", 60 },

are you sure we should keep it there?

>  pc-bios/meson.build           |   1 -
>  pc-bios/optionrom/Makefile    |   2 +-
>  pc-bios/optionrom/linuxboot.S | 195 ----------------------------------
>  4 files changed, 2 insertions(+), 199 deletions(-)
>  delete mode 100644 pc-bios/optionrom/linuxboot.S
>=20
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 524d2fd98e8..4e6fe68e2e0 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -654,8 +654,7 @@ void xen_load_linux(PCMachineState *pcms)
> =20
>      x86_load_linux(x86ms, fw_cfg, PC_FW_DATA, pcmc->pvh_enabled);
>      for (i =3D 0; i < nb_option_roms; i++) {
> -        assert(!strcmp(option_rom[i].name, "linuxboot.bin") ||
> -               !strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
> +        assert(!strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
>                 !strcmp(option_rom[i].name, "pvh.bin") ||
>                 !strcmp(option_rom[i].name, "multiboot_dma.bin"));
>          rom_add_option(option_rom[i].name, option_rom[i].bootindex);
> diff --git a/pc-bios/meson.build b/pc-bios/meson.build
> index f2d4dc416a4..39a7fea332e 100644
> --- a/pc-bios/meson.build
> +++ b/pc-bios/meson.build
> @@ -63,7 +63,6 @@ blobs =3D [
>    'efi-vmxnet3.rom',
>    'qemu-nsis.bmp',
>    'multiboot_dma.bin',
> -  'linuxboot.bin',
>    'linuxboot_dma.bin',
>    'kvmvapic.bin',
>    'pvh.bin',
> diff --git a/pc-bios/optionrom/Makefile b/pc-bios/optionrom/Makefile
> index 1183ef88922..e694c7aac00 100644
> --- a/pc-bios/optionrom/Makefile
> +++ b/pc-bios/optionrom/Makefile
> @@ -2,7 +2,7 @@ include config.mak
>  SRC_DIR :=3D $(TOPSRC_DIR)/pc-bios/optionrom
>  VPATH =3D $(SRC_DIR)
> =20
> -all: multiboot_dma.bin linuxboot.bin linuxboot_dma.bin kvmvapic.bin pvh.=
bin
> +all: multiboot_dma.bin linuxboot_dma.bin kvmvapic.bin pvh.bin
>  # Dummy command so that make thinks it has done something
>  	@true
> =20
> diff --git a/pc-bios/optionrom/linuxboot.S b/pc-bios/optionrom/linuxboot.S
> deleted file mode 100644
> index ba821ab922d..00000000000
> --- a/pc-bios/optionrom/linuxboot.S
> +++ /dev/null
> @@ -1,195 +0,0 @@
> -/*
> - * Linux Boot Option ROM
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
> - *
> - * Copyright Novell Inc, 2009
> - *   Authors: Alexander Graf <agraf@suse.de>
> - *
> - * Based on code in hw/pc.c.
> - */
> -
> -#include "optionrom.h"
> -
> -#define BOOT_ROM_PRODUCT "Linux loader"
> -
> -BOOT_ROM_START
> -
> -run_linuxboot:
> -
> -	cli
> -	cld
> -
> -	jmp		copy_kernel
> -boot_kernel:
> -
> -	read_fw		FW_CFG_SETUP_ADDR
> -
> -	mov		%eax, %ebx
> -	shr		$4, %ebx
> -
> -	/* All segments contain real_addr */
> -	mov		%bx, %ds
> -	mov		%bx, %es
> -	mov		%bx, %fs
> -	mov		%bx, %gs
> -	mov		%bx, %ss
> -
> -	/* CX =3D CS we want to jump to */
> -	add		$0x20, %bx
> -	mov		%bx, %cx
> -
> -	/* SP =3D cmdline_addr-real_addr-16 */
> -	read_fw		FW_CFG_CMDLINE_ADDR
> -	mov		%eax, %ebx
> -	read_fw		FW_CFG_SETUP_ADDR
> -	sub		%eax, %ebx
> -	sub		$16, %ebx
> -	mov		%ebx, %esp
> -
> -	/* Build indirect lret descriptor */
> -	pushw		%cx		/* CS */
> -	xor		%ax, %ax
> -	pushw		%ax		/* IP =3D 0 */
> -
> -	/* Clear registers */
> -	xor		%eax, %eax
> -	xor		%ebx, %ebx
> -	xor		%ecx, %ecx
> -	xor		%edx, %edx
> -	xor		%edi, %edi
> -	xor		%ebp, %ebp
> -
> -	/* Jump to Linux */
> -	lret
> -
> -
> -copy_kernel:
> -	/* Read info block in low memory (0x10000 or 0x90000) */
> -	read_fw		FW_CFG_SETUP_ADDR
> -	shr		$4, %eax
> -	mov		%eax, %es
> -	xor		%edi, %edi
> -	read_fw_blob_addr32_edi(FW_CFG_SETUP)
> -
> -	cmpw            $0x203, %es:0x206      // if protocol >=3D 0x203
> -	jae             1f                     // have initrd_max
> -	movl            $0x37ffffff, %es:0x22c // else assume 0x37ffffff
> -1:
> -
> -	/* Check if using kernel-specified initrd address */
> -	read_fw		FW_CFG_INITRD_ADDR
> -	mov		%eax, %edi             // (load_kernel wants it in %edi)
> -	read_fw		FW_CFG_INITRD_SIZE     // find end of initrd
> -	add		%edi, %eax
> -	xor		%es:0x22c, %eax        // if it matches es:0x22c
> -	and		$-4096, %eax           // (apart from padding for page)
> -	jz		load_kernel            // then initrd is not at top
> -					       // of memory
> -
> -	/* pc.c placed the initrd at end of memory.  Compute a better
> -	 * initrd address based on e801 data.
> -	 */
> -	mov		$0xe801, %ax
> -	xor		%cx, %cx
> -	xor		%dx, %dx
> -	int		$0x15
> -
> -	/* Output could be in AX/BX or CX/DX */
> -	or		%cx, %cx
> -	jnz		1f
> -	or		%dx, %dx
> -	jnz		1f
> -	mov		%ax, %cx
> -	mov		%bx, %dx
> -1:
> -
> -	or		%dx, %dx
> -	jnz		2f
> -	addw		$1024, %cx            /* add 1 MB */
> -	movzwl		%cx, %edi
> -	shll		$10, %edi             /* convert to bytes */
> -	jmp		3f
> -
> -2:
> -	addw		$16777216 >> 16, %dx  /* add 16 MB */
> -	movzwl		%dx, %edi
> -	shll		$16, %edi             /* convert to bytes */
> -
> -3:
> -	read_fw         FW_CFG_INITRD_SIZE
> -	subl            %eax, %edi
> -	andl            $-4096, %edi          /* EDI =3D start of initrd */
> -	movl		%edi, %es:0x218       /* put it in the header */
> -
> -load_kernel:
> -	/* We need to load the kernel into memory we can't access in 16 bit
> -	   mode, so let's get into 32 bit mode, write the kernel and jump
> -	   back again. */
> -
> -	/* Reserve space on the stack for our GDT descriptor. */
> -	mov             %esp, %ebp
> -	sub             $16, %esp
> -
> -	/* Now create the GDT descriptor */
> -	movw		$((3 * 8) - 1), -16(%bp)
> -	mov		%cs, %eax
> -	movzwl		%ax, %eax
> -	shl		$4, %eax
> -	addl		$gdt, %eax
> -	movl		%eax, -14(%bp)
> -
> -	/* And load the GDT */
> -	data32 lgdt	-16(%bp)
> -	mov		%ebp, %esp
> -
> -	/* Get us to protected mode now */
> -	mov		$1, %eax
> -	mov		%eax, %cr0
> -
> -	/* So we can set ES to a 32-bit segment */
> -	mov		$0x10, %eax
> -	mov		%eax, %es
> -
> -	/* We're now running in 16-bit CS, but 32-bit ES! */
> -
> -	/* Load kernel and initrd */
> -	read_fw_blob_addr32_edi(FW_CFG_INITRD)
> -	read_fw_blob_addr32(FW_CFG_KERNEL)
> -	read_fw_blob_addr32(FW_CFG_CMDLINE)
> -
> -	/* And now jump into Linux! */
> -	mov		$0, %eax
> -	mov		%eax, %cr0
> -
> -	/* ES =3D CS */
> -	mov		%cs, %ax
> -	mov		%ax, %es
> -
> -	jmp		boot_kernel
> -
> -/* Variables */
> -
> -.align 4, 0
> -gdt:
> -	/* 0x00 */
> -.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
> -
> -	/* 0x08: code segment (base=3D0, limit=3D0xfffff, type=3D32bit code exe=
c/read, DPL=3D0, 4k) */
> -.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x9a, 0xcf, 0x00
> -
> -	/* 0x10: data segment (base=3D0, limit=3D0xfffff, type=3D32bit data rea=
d/write, DPL=3D0, 4k) */
> -.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0xcf, 0x00
> -
> -BOOT_ROM_END


