Return-Path: <kvm+bounces-66181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43367CC856B
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 25D7730894B3
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B57E33B95B;
	Wed, 17 Dec 2025 14:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5TLZLLH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVgJYnwP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73258264A86
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765983345; cv=none; b=XCmyoj+xuPjlOzjxyGW9QpyeCxVV/NKRoLtalq31n64SmXoYAqIdncyEEGIocH6jGr6lAc/N7U4H5vMFB0p12PkZnBiyA8Q4gmcTki2pejU3oVSFyVMF40Teh2w8vTMewJOZClbUWfyKHU+MV7sKO/jnApH62PW9WjY7Zb9Q50M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765983345; c=relaxed/simple;
	bh=k83Nh2Ij2scPaPLZV6ZP30MdO1TKpn4sxO6Og1GUlOU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKIoRPZBukVDYSyCVjx5TFirukzkSXPhsKwvjoq5xEdrjm/LGcw5yUWjiX/Ns5D4+XyT55/1PBIDiqEBMdPtCY4EnO8skylk3U3zaDY4k0i7POMlgbUgtFwg9lVoO/H3gN7DGO864I9ft09D4yh26KvUGMMkKnODuOx7Kz6tvII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5TLZLLH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVgJYnwP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765983337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hmf5VC+b3x+LaGkm+jOlklLFunTAIeNMxOXVsFoA2R4=;
	b=h5TLZLLH4DDu7Xg7NK06xkGLVbi2ciWg7Pi5LK/3/TYMGepbiuokL5p8DXMcBtNq8kOoWF
	E+mYGphyRc1acOiX47/JtHsG+XghDk1nndTztWxkuQp3jMajDrhP0jjtXyFL+wQAgk5eUx
	0GSB9B1kSo9HeDpSc01s7guBmscRELM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-QTpZMNxOMqyjuewsdHrALA-1; Wed, 17 Dec 2025 09:55:36 -0500
X-MC-Unique: QTpZMNxOMqyjuewsdHrALA-1
X-Mimecast-MFC-AGG-ID: QTpZMNxOMqyjuewsdHrALA_1765983335
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so65093605e9.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765983335; x=1766588135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmf5VC+b3x+LaGkm+jOlklLFunTAIeNMxOXVsFoA2R4=;
        b=DVgJYnwPRgA2jNAQgJV7pmtNpXoobifwmrEYRKBPZSKLPViE74jWOKUQREv6SZhISv
         Zpqpib1KrDxGelvyxhYwoSuyX21tKg3YigPqRd3wahR+xNaBCEMcwb2X+O5UXbTeRNRO
         SHh2M7eBPBKk5T9dWhda1Vlfyj4GHmq9rbDKCPuHrJxp8rEpzLEZXMMpEq32vcJNkQY+
         edNaupcKhIP2s+OmGZVkLREygie5+YPdTbtUsuLujD7d1hl+9lD59ShURuSvqHzWLtYe
         ZuNTLU0AuX/vAG8/7kZ7+pzZ8pv1PC4u/CV3TcBV8wqE0bW07aNogh3yq4TSzTdoFfJF
         f3hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765983335; x=1766588135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hmf5VC+b3x+LaGkm+jOlklLFunTAIeNMxOXVsFoA2R4=;
        b=s85XfJ+gEMF5p7Jc9/NXM7d0QXw4gI6QA7VlVQXzNv3+Z87+eG+kzym8aRagcEjnoj
         WfnIqKrMpKfPye2Vkyln8eSrFoNasLvfFTuE9OkgIur0BErqfkZPW4agBR5bb6QvUE3r
         MZia1vnNTOiTDHGtyqLtPBDDuVXsBFb0ufdb7/OUq2HwZDOS/WhNzYRe7+BzQmfrpYnb
         sOuP1+rss8Z1WPiLzaUbNWH+PuCMhiHjH4L18WLoSqcRnRVt4KDWK2a/w9Mip09NwxBi
         ry37/h1izd3kbgr68WywW+VDk/gzn7/jMgZuXAiUNHFC4RoUVKdD7yrytWAXq0dMi5w3
         TY8g==
X-Forwarded-Encrypted: i=1; AJvYcCVcvCkXOT0LjgyibPFVJj7tVg32XYUr6VckY3oF9JErzBAgi8gLJhVJ3CIaNI6MOYKiO3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhiSQi8JAD/2tLznadfABibnR8LwnZm22qDWJnKLYKQ6jybuUk
	H2rgu7cusC9Hlbfk38bOP7ECDY0IIKIirclLPZVtruQB1ggLzsqx13LzTEiJmmUQfktXUKgjGx/
	1W7xr2iGXOjfIPcYs5G/Ptd9s0lzKBgTpPU51Ou8A28j2fmAXnEgjJg==
X-Gm-Gg: AY/fxX6s5u4TTtr90jtCDlGRohBlY3O551WTtBhvfQ/Ee4kco2HAL9riTobK4481NtQ
	wIRspZaY/WjgPUogLd2MgiYy57/+idT8J7bzTIq/qXQRF2aEjJxuBrk24eg6Ws4gp+GD0ZdGBxI
	jvqYowVdpDOJTyBPnwMdOW4TR6RZhYNB4A5xM52aMTEQKRD+mCL+a6KT49RIyEelyfU1MNCFa0P
	nm/dri97yq9UtlbF6/5gDvqSsmh/tv/fmVaCvWZdpxAptVNu5KpKKv9udGPrZBj2A5bATlCiffK
	nudzofAcwCp5fF/EIHjNEa+qJzYpoNeHQMAQ0pmh+YBDK74SqXe+SLEfg5cWyFkyZjyMTQ==
X-Received: by 2002:a05:600c:528a:b0:47b:d949:9ba9 with SMTP id 5b1f17b1804b1-47bd9499cf6mr51863195e9.13.1765983334933;
        Wed, 17 Dec 2025 06:55:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCgPp3Zk8qHTNA+WDCbAp3YDWWtS6/6R+MJ8UYvQwsCNZi3scFHvl7ITonyEAWnlTi/e7hIQ==
X-Received: by 2002:a05:600c:528a:b0:47b:d949:9ba9 with SMTP id 5b1f17b1804b1-47bd9499cf6mr51862785e9.13.1765983334482;
        Wed, 17 Dec 2025 06:55:34 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310ade7c4asm5149594f8f.28.2025.12.17.06.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:55:34 -0800 (PST)
Date: Wed, 17 Dec 2025 15:55:30 +0100
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
Subject: Re: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
Message-ID: <20251217155530.3353e904@imammedo>
In-Reply-To: <20251202162835.3227894-17-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-17-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:23 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> All machines now use the linuxboot_dma.bin binary, so it's safe to
> remove the non-DMA version (linuxboot.bin).

after applying this patch:

git grep linuxboot.bin

    option_rom[nb_option_roms].bootindex =3D 0;                            =
       =20
    option_rom[nb_option_roms].name =3D "linuxboot.bin";                   =
       =20
    if (fw_cfg_dma_enabled(fw_cfg)) {                                      =
     =20
        option_rom[nb_option_roms].name =3D "linuxboot_dma.bin";           =
       =20
    }       =20

perhaps it should be fixed in previous patch

>=20
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v4:
>  * Update commit message: not only pc, but also microvm enables
>    DMA for FwCfgState (in microvm_memory_init).
> ---
>  hw/i386/pc.c                  |   3 +-
>  pc-bios/meson.build           |   1 -
>  pc-bios/optionrom/Makefile    |   2 +-
>  pc-bios/optionrom/linuxboot.S | 195 ----------------------------------
>  4 files changed, 2 insertions(+), 199 deletions(-)
>  delete mode 100644 pc-bios/optionrom/linuxboot.S
>=20
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 9d88d4a5207a..2e315414aeaf 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -666,8 +666,7 @@ void xen_load_linux(PCMachineState *pcms)
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
> index efe45c16705d..2f470ed12942 100644
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
> index 1183ef889228..e694c7aac007 100644
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
> index ba821ab922da..000000000000
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


