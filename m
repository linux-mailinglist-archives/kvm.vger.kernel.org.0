Return-Path: <kvm+bounces-66174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB16CC8547
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 026A43015589
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C839393DF4;
	Wed, 17 Dec 2025 14:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YG37dGiK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZqOommqU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0085D38C647
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980476; cv=none; b=hMciMdHXaglePxjLawQe75ZzRnqZG1sVshr1fgWNRPT96TiBC+ilUnVFsimH63nz+fxo1oCplRlOL4ZC32kbJq2W39r167N7l2QajG7QecDYvp31YjTeDJhTm23UzIcjC3Gyi+Q+CwkOdC6vvx+KMrmMb7WE6PxW17PZOigwNM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980476; c=relaxed/simple;
	bh=T1VdTu+evdRFXsQyo3f+aFcCIUVAkctTP4WtyXiBNIs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dhh1LWH3AlU5NbukRfoJenmHskXWltBnerzl5fy/N0zBHyzzvIfoB98/IxhDAsUmhPQn+UYMjWFgJrxTkAAFBExxGsQfoNwb2b3L7X64UUJcJHyr7TOg8Kf9BpyfmHdTfbRymj1kn8mu50y55f+ieLWFetAPuwh7jghONN1R75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YG37dGiK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZqOommqU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765980473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aljhJcWsDJ3PFFfYqiQ4P5tji0PBbRIzCHEZWg9XRYg=;
	b=YG37dGiK045dBPgfmpqnxZPQ54Ddk6xUZOxxoUGr8Z8VVnhIOtswDF6mGpqcOQsRipWl+c
	b0srEREXuBI4a1t05CgJJFQJYD9mBqRnSQSpFVJdSlPSI6KHO2tKzRYl2AMPV/FS0TkViZ
	LyXgJrhRmzIfTcqVX5PXzrB+R6Z07QM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-vf7gLnTxOkSNWDL5V22J2w-1; Wed, 17 Dec 2025 09:07:51 -0500
X-MC-Unique: vf7gLnTxOkSNWDL5V22J2w-1
X-Mimecast-MFC-AGG-ID: vf7gLnTxOkSNWDL5V22J2w_1765980470
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43065ad16a8so2221521f8f.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765980470; x=1766585270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aljhJcWsDJ3PFFfYqiQ4P5tji0PBbRIzCHEZWg9XRYg=;
        b=ZqOommqUdUEqGPbKf7T99UC19eEoealIauypDEJW4M/zpn3YNRXxY6L8O1FNLZ1Y/g
         DIoW68dgjWhSJ98QTTueuDVJdEJzYbI959eCtYafX5f4BVkypjiSVXz5pA4d5+cOWeNU
         sfAZLhwgzU6kjm4hqTa/w2T4OobZqGB7KAgpyAe2gItB7oCWoy/AesZoaxnw1Rs+qLTy
         clzgA4TlSqfZepOeOUyrTaBVy3kqhsiDUv19EwcV+yHoBMWSYYkk75sP59l2/DMTRxgP
         hKFQuTqlb4RapOuN7xqicuVrkCSGme9I2dRlcSV0dU3CZEOv4thra+uW7nmnFrzCEvgY
         98Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765980470; x=1766585270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aljhJcWsDJ3PFFfYqiQ4P5tji0PBbRIzCHEZWg9XRYg=;
        b=t8RwgGxu5RJIfW/58VpxdvmOwmXPz6Bgzp8ns6P1OLq+iO/1opjIsZ0eub0sdfZ+NH
         ft3N5lpodB8f247g7zrLAZzjenWVKkj1GoBbYQu8pTpDmO//3Y3b0o+2y/U7ZnEoEJEF
         AEXFQRcW6D9rsJr599yevHfIJzL/5KnxAT/WzgPdYDskk2vtnjjZ8WMRU4TPeAEGxa//
         nwQixUcyeFyfS07fL64pn76GMWswmZKQlCq8MSHxek6st8tgokSRx+egZkG/khfwkCIt
         N/yQDwfIarES8NETKwok+l09rnUhAqYZWB8MIp+4rluurVpgo4R7uHAHQYLe6O7puwpX
         ErDA==
X-Forwarded-Encrypted: i=1; AJvYcCW8GUp+Eyrt5KbwChrUq8x1iOPecFSnrWCn3fNPZpLNbtZ3tq7BxEABJf/DHLdbqw6paq8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1dmIvSq0EIfZ4ak8S3vOUCGW++fjyFgWsSrJWADTYa8mzh/0p
	dK5cP2u+jmDnvc41yCR7Xz6IfvZsGXEnzlRQQGt2L7K4f5kRsE4ZlvF7Ka20uSpdXGy1+8kXuzW
	C1/bPpKCRGCmVsGpDIclAKwACtwyK8hC3J+TOXwaj1d0lnYNDLd3nrQ==
X-Gm-Gg: AY/fxX6PYiweKVm8ufE1DxVQfAuoFnHkUS4hajSpwR7P1fP7bd5/hJGewHsV8nqlwAU
	AE9fdNK0VSLP0JiJkEwtSqMmxOe+egZ5zE8++UtQZJKGXgbPgNpgzazIboLrKsF7uxVa57id/FU
	lPZ7Wm+lpOVyEkYVqaBI/LwXy7NNNaXh5p5O0XAiObZc70X4P8TtvXyuTC7uaGwxb3+AZfWIum5
	zhbKxYq4uDXr1F4twGdomVYvbr4MhyzyM6Bp9tfIeUqJi0Pt5O6KGQbhQ96UXj8gkuOYSWMkKVv
	+ze0NX5004/dfczCopRTn/fXQhN0udwtYGBx8HOixRZ0ko53z38dgfm7xTrIrfu9p+ycUg==
X-Received: by 2002:a05:6000:230f:b0:430:fa9a:75a with SMTP id ffacd0b85a97d-430fa9a0d44mr13417673f8f.62.1765980470130;
        Wed, 17 Dec 2025 06:07:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpXoLJz1298FbluPk6Xn1ITwdOxZzapjcXfhQvPzVc4SMQoEloQ6OJ4+yK0Lg6SKLVv9uCjQ==
X-Received: by 2002:a05:6000:230f:b0:430:fa9a:75a with SMTP id ffacd0b85a97d-430fa9a0d44mr13417644f8f.62.1765980469532;
        Wed, 17 Dec 2025 06:07:49 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310adad192sm5220905f8f.14.2025.12.17.06.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:07:49 -0800 (PST)
Date: Wed, 17 Dec 2025 15:07:47 +0100
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
Subject: Re: [PATCH v5 14/28] hw/i386/pc: Remove multiboot.bin
Message-ID: <20251217150747.13d77fab@imammedo>
In-Reply-To: <20251202162835.3227894-15-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-15-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:21 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> All PC machines now use the multiboot_dma.bin binary,
> we can remove the non-DMA version (multiboot.bin).
>=20
> This doesn't change multiboot_dma binary file.
>=20
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
> Changes since v4:
>  * There's a recent change for multiboot.S: commit 4c8f69b94839.
>    Rebase this patch on that.
> ---
>  hw/i386/pc.c                      |   1 -
>  pc-bios/meson.build               |   1 -
>  pc-bios/multiboot.bin             | Bin 1024 -> 0 bytes
>  pc-bios/optionrom/Makefile        |   2 +-
>  pc-bios/optionrom/multiboot.S     | 232 -----------------------------
>  pc-bios/optionrom/multiboot_dma.S | 234 +++++++++++++++++++++++++++++-
>  pc-bios/optionrom/optionrom.h     |   4 -
>  7 files changed, 233 insertions(+), 241 deletions(-)
>  delete mode 100644 pc-bios/multiboot.bin
>  delete mode 100644 pc-bios/optionrom/multiboot.S
>=20
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 2b8d3982c4a0..9d88d4a5207a 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -669,7 +669,6 @@ void xen_load_linux(PCMachineState *pcms)
>          assert(!strcmp(option_rom[i].name, "linuxboot.bin") ||
>                 !strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
>                 !strcmp(option_rom[i].name, "pvh.bin") ||
> -               !strcmp(option_rom[i].name, "multiboot.bin") ||
>                 !strcmp(option_rom[i].name, "multiboot_dma.bin"));
>          rom_add_option(option_rom[i].name, option_rom[i].bootindex);
>      }
> diff --git a/pc-bios/meson.build b/pc-bios/meson.build
> index 9260aaad78e8..efe45c16705d 100644
> --- a/pc-bios/meson.build
> +++ b/pc-bios/meson.build
> @@ -62,7 +62,6 @@ blobs =3D [
>    'efi-e1000e.rom',
>    'efi-vmxnet3.rom',
>    'qemu-nsis.bmp',
> -  'multiboot.bin',
>    'multiboot_dma.bin',
>    'linuxboot.bin',
>    'linuxboot_dma.bin',
> diff --git a/pc-bios/multiboot.bin b/pc-bios/multiboot.bin
> deleted file mode 100644
> index e772713c95749bee82c20002b50ec6d05b2d4987..0000000000000000000000000=
000000000000000
> GIT binary patch
> literal 0
> HcmV?d00001
>=20
> literal 1024
> zcmeHFF-Tic6utlZQ$OjD#Hxcx2u0GNQv6GySOkZR(ulaX<>%N!Y#>cWhY}nf36J7X
> zN(%*X6NHY>xcqO11dG^02a8L@B~ihln|%1*|7(haWa`)l@80w7;U4Ziyv0rZ8{K-w =20
> zX(Ib3tLZ)RgZ}w1ei{~QEqQq9q1J-iHc<Nk_t=3D0qf%XfPZVHw2DY#ujc2P|}*P%6X
> z5J{pPlX4<yP&N5pXK;s@UhB~&!E&UdqEwGZF6xQMIcu9YL#zeSRCoLGt{Nh+08t>}
> z{m%E-b32A??+@XljSYirtWObwngi<ymS1Ta*dFGMp;8@=3D_3Z52!v09{UU~`QnFsB_
> z7BiEC)uZxH%SW9kPWCicN{_iUjmk<~D^H|R%@|m9%43Woc(Pkeq%n{&8ND5Z*tPt#
> zJua+xXAQhN4K(1MMs0{u_6sp>l#NmvPZ7KC<lsLdQgMFC@A6POvMoDMgW=3DM+K;T<o
> zTkpnNq6x*`vM0CGE>t40l-CQ}*)y<y--c)(x}o&1TMzwX+ToGS@VER4zR&s70fl+( =20
> qI)9<-H_-!n#lLJmGq*^~<$US&%R-@)$`@YPx#A6#|L`9<;9UXPG71m?
>=20
> diff --git a/pc-bios/optionrom/Makefile b/pc-bios/optionrom/Makefile
> index 30d07026c790..1183ef889228 100644
> --- a/pc-bios/optionrom/Makefile
> +++ b/pc-bios/optionrom/Makefile
> @@ -2,7 +2,7 @@ include config.mak
>  SRC_DIR :=3D $(TOPSRC_DIR)/pc-bios/optionrom
>  VPATH =3D $(SRC_DIR)
> =20
> -all: multiboot.bin multiboot_dma.bin linuxboot.bin linuxboot_dma.bin kvm=
vapic.bin pvh.bin
> +all: multiboot_dma.bin linuxboot.bin linuxboot_dma.bin kvmvapic.bin pvh.=
bin
>  # Dummy command so that make thinks it has done something
>  	@true
> =20
> diff --git a/pc-bios/optionrom/multiboot.S b/pc-bios/optionrom/multiboot.S
> deleted file mode 100644
> index c95e35c9cb62..000000000000
> --- a/pc-bios/optionrom/multiboot.S
> +++ /dev/null
> @@ -1,232 +0,0 @@
> -/*
> - * Multiboot Option ROM
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
> - */
> -
> -#include "optionrom.h"
> -
> -#define BOOT_ROM_PRODUCT "multiboot loader"
> -
> -#define MULTIBOOT_MAGIC		0x2badb002
> -
> -#define GS_PROT_JUMP		0
> -#define GS_GDT_DESC		6
> -
> -
> -BOOT_ROM_START
> -
> -run_multiboot:
> -
> -	cli
> -	cld
> -
> -	mov		%cs, %eax
> -	shl		$0x4, %eax
> -
> -	/* set up a long jump descriptor that is PC relative */
> -
> -	/* move stack memory to %gs */
> -	mov		%ss, %ecx
> -	shl		$0x4, %ecx
> -	mov		%esp, %ebx
> -	add		%ebx, %ecx
> -	sub		$0x20, %ecx
> -	sub		$0x30, %esp
> -	shr		$0x4, %ecx
> -	mov		%cx, %gs
> -
> -	/* now push the indirect jump descriptor there */
> -	mov		(prot_jump), %ebx
> -	add		%eax, %ebx
> -	movl		%ebx, %gs:GS_PROT_JUMP
> -	mov		$8, %bx
> -	movw		%bx, %gs:GS_PROT_JUMP + 4
> -
> -	/* fix the gdt descriptor to be PC relative */
> -	movw		(gdt_desc), %bx
> -	movw		%bx, %gs:GS_GDT_DESC
> -	movl		(gdt_desc+2), %ebx
> -	add		%eax, %ebx
> -	movl		%ebx, %gs:GS_GDT_DESC + 2
> -
> -	xor		%eax, %eax
> -	mov		%eax, %es
> -
> -	/* Read the bootinfo struct into RAM */
> -	read_fw_blob_dma(FW_CFG_INITRD)
> -
> -	/* FS =3D bootinfo_struct */
> -	read_fw		FW_CFG_INITRD_ADDR
> -	shr		$4, %eax
> -	mov		%ax, %fs
> -
> -	/* Account for the EBDA in the multiboot structure's e801
> -	 * map.
> -	 */
> -	int		$0x12
> -	cwtl
> -	movl		%eax, %fs:4
> -
> -	/* ES =3D mmap_addr */
> -	mov 		%fs:48, %eax
> -	shr		$4, %eax
> -	mov		%ax, %es
> -
> -	/* Initialize multiboot mmap structs using int 0x15(e820) */
> -	xor		%ebx, %ebx
> -	/* Start storing mmap data at %es:0 */
> -	xor		%edi, %edi
> -
> -mmap_loop:
> -	/* The multiboot entry size has offset -4, so leave some space */
> -	add		$4, %di
> -	/* entry size (mmap struct) & max buffer size (int15) */
> -	movl		$20, %ecx
> -	/* e820 */
> -	movl		$0x0000e820, %eax
> -	/* 'SMAP' magic */
> -	movl		$0x534d4150, %edx
> -	int		$0x15
> -
> -mmap_check_entry:
> -	/* Error or last entry already done? */
> -	jb		mmap_done
> -
> -mmap_store_entry:
> -	/* store entry size */
> -	/* old as(1) doesn't like this insn so emit the bytes instead:
> -	movl		%ecx, %es:-4(%edi)
> -	*/
> -	.dc.b		0x26,0x67,0x66,0x89,0x4f,0xfc
> -
> -	/* %edi +=3D entry_size, store as mbs_mmap_length */
> -	add		%ecx, %edi
> -	movw		%di, %fs:0x2c
> -
> -	/* Continuation value 0 means last entry */
> -	test		%ebx, %ebx
> -	jnz		mmap_loop
> -
> -mmap_done:
> -	/* Calculate upper_mem field: The amount of memory between 1 MB and
> -	   the first upper memory hole. Get it from the mmap. */
> -	xor		%di, %di
> -	mov		$0x100000, %edx
> -upper_mem_entry:
> -	cmp		%fs:0x2c, %di
> -	je		upper_mem_done
> -	add		$4, %di
> -
> -	/* Skip if type !=3D 1 */
> -	cmpl		$1, %es:16(%di)
> -	jne		upper_mem_next
> -
> -	/* Skip if > 4 GB */
> -	movl		%es:4(%di), %eax
> -	test		%eax, %eax
> -	jnz		upper_mem_next
> -
> -	/* Check for contiguous extension (base <=3D %edx < base + length) */
> -	movl		%es:(%di), %eax
> -	cmp		%eax, %edx
> -	jb		upper_mem_next
> -	addl		%es:8(%di), %eax
> -	cmp		%eax, %edx
> -	jae		upper_mem_next
> -
> -	/* If so, update %edx, and restart the search (mmap isn't ordered) */
> -	mov		%eax, %edx
> -	xor		%di, %di
> -	jmp		upper_mem_entry
> -
> -upper_mem_next:
> -	addl		%es:-4(%di), %edi
> -	jmp		upper_mem_entry
> -
> -upper_mem_done:
> -	sub		$0x100000, %edx
> -	shr		$10, %edx
> -	mov		%edx, %fs:0x8
> -
> -real_to_prot:
> -	/* Load the GDT before going into protected mode */
> -lgdt:
> -	data32 lgdt	%gs:GS_GDT_DESC
> -
> -	/* get us to protected mode now */
> -	movl		$1, %eax
> -	movl		%eax, %cr0
> -
> -	/* the LJMP sets CS for us and gets us to 32-bit */
> -ljmp:
> -	data32 ljmp	*%gs:GS_PROT_JUMP
> -
> -prot_mode:
> -.code32
> -
> -	/* initialize all other segments */
> -	movl		$0x10, %eax
> -	movl		%eax, %ss
> -	movl		%eax, %ds
> -	movl		%eax, %es
> -	movl		%eax, %fs
> -	movl		%eax, %gs
> -
> -	/* Read the kernel and modules into RAM */
> -	read_fw_blob_dma(FW_CFG_KERNEL)
> -
> -	/* Jump off to the kernel */
> -	read_fw		FW_CFG_KERNEL_ENTRY
> -	mov		%eax, %ecx
> -
> -	/* EBX contains a pointer to the bootinfo struct */
> -	read_fw		FW_CFG_INITRD_ADDR
> -	movl		%eax, %ebx
> -
> -	/* EAX has to contain the magic */
> -	movl		$MULTIBOOT_MAGIC, %eax
> -ljmp2:
> -	jmp		*%ecx
> -
> -/* Variables */
> -.align 4, 0
> -prot_jump:	.long prot_mode
> -		.short 8
> -
> -.align 8, 0
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
> -	/* 0x18: code segment (base=3D0, limit=3D0x0ffff, type=3D16bit code exe=
c/read/conf, DPL=3D0, 1b) */
> -.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x9e, 0x00, 0x00
> -
> -	/* 0x20: data segment (base=3D0, limit=3D0x0ffff, type=3D16bit data rea=
d/write, DPL=3D0, 1b) */
> -.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0x00, 0x00
> -
> -gdt_desc:
> -.short	(5 * 8) - 1
> -.long	gdt
> -
> -BOOT_ROM_END
> diff --git a/pc-bios/optionrom/multiboot_dma.S b/pc-bios/optionrom/multib=
oot_dma.S
> index d809af3e23fc..c95e35c9cb62 100644
> --- a/pc-bios/optionrom/multiboot_dma.S
> +++ b/pc-bios/optionrom/multiboot_dma.S
> @@ -1,2 +1,232 @@
> -#define USE_FW_CFG_DMA 1
> -#include "multiboot.S"
> +/*
> + * Multiboot Option ROM
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * Copyright Novell Inc, 2009
> + *   Authors: Alexander Graf <agraf@suse.de>
> + */
> +
> +#include "optionrom.h"
> +
> +#define BOOT_ROM_PRODUCT "multiboot loader"
> +
> +#define MULTIBOOT_MAGIC		0x2badb002
> +
> +#define GS_PROT_JUMP		0
> +#define GS_GDT_DESC		6
> +
> +
> +BOOT_ROM_START
> +
> +run_multiboot:
> +
> +	cli
> +	cld
> +
> +	mov		%cs, %eax
> +	shl		$0x4, %eax
> +
> +	/* set up a long jump descriptor that is PC relative */
> +
> +	/* move stack memory to %gs */
> +	mov		%ss, %ecx
> +	shl		$0x4, %ecx
> +	mov		%esp, %ebx
> +	add		%ebx, %ecx
> +	sub		$0x20, %ecx
> +	sub		$0x30, %esp
> +	shr		$0x4, %ecx
> +	mov		%cx, %gs
> +
> +	/* now push the indirect jump descriptor there */
> +	mov		(prot_jump), %ebx
> +	add		%eax, %ebx
> +	movl		%ebx, %gs:GS_PROT_JUMP
> +	mov		$8, %bx
> +	movw		%bx, %gs:GS_PROT_JUMP + 4
> +
> +	/* fix the gdt descriptor to be PC relative */
> +	movw		(gdt_desc), %bx
> +	movw		%bx, %gs:GS_GDT_DESC
> +	movl		(gdt_desc+2), %ebx
> +	add		%eax, %ebx
> +	movl		%ebx, %gs:GS_GDT_DESC + 2
> +
> +	xor		%eax, %eax
> +	mov		%eax, %es
> +
> +	/* Read the bootinfo struct into RAM */
> +	read_fw_blob_dma(FW_CFG_INITRD)
> +
> +	/* FS =3D bootinfo_struct */
> +	read_fw		FW_CFG_INITRD_ADDR
> +	shr		$4, %eax
> +	mov		%ax, %fs
> +
> +	/* Account for the EBDA in the multiboot structure's e801
> +	 * map.
> +	 */
> +	int		$0x12
> +	cwtl
> +	movl		%eax, %fs:4
> +
> +	/* ES =3D mmap_addr */
> +	mov 		%fs:48, %eax
> +	shr		$4, %eax
> +	mov		%ax, %es
> +
> +	/* Initialize multiboot mmap structs using int 0x15(e820) */
> +	xor		%ebx, %ebx
> +	/* Start storing mmap data at %es:0 */
> +	xor		%edi, %edi
> +
> +mmap_loop:
> +	/* The multiboot entry size has offset -4, so leave some space */
> +	add		$4, %di
> +	/* entry size (mmap struct) & max buffer size (int15) */
> +	movl		$20, %ecx
> +	/* e820 */
> +	movl		$0x0000e820, %eax
> +	/* 'SMAP' magic */
> +	movl		$0x534d4150, %edx
> +	int		$0x15
> +
> +mmap_check_entry:
> +	/* Error or last entry already done? */
> +	jb		mmap_done
> +
> +mmap_store_entry:
> +	/* store entry size */
> +	/* old as(1) doesn't like this insn so emit the bytes instead:
> +	movl		%ecx, %es:-4(%edi)
> +	*/
> +	.dc.b		0x26,0x67,0x66,0x89,0x4f,0xfc
> +
> +	/* %edi +=3D entry_size, store as mbs_mmap_length */
> +	add		%ecx, %edi
> +	movw		%di, %fs:0x2c
> +
> +	/* Continuation value 0 means last entry */
> +	test		%ebx, %ebx
> +	jnz		mmap_loop
> +
> +mmap_done:
> +	/* Calculate upper_mem field: The amount of memory between 1 MB and
> +	   the first upper memory hole. Get it from the mmap. */
> +	xor		%di, %di
> +	mov		$0x100000, %edx
> +upper_mem_entry:
> +	cmp		%fs:0x2c, %di
> +	je		upper_mem_done
> +	add		$4, %di
> +
> +	/* Skip if type !=3D 1 */
> +	cmpl		$1, %es:16(%di)
> +	jne		upper_mem_next
> +
> +	/* Skip if > 4 GB */
> +	movl		%es:4(%di), %eax
> +	test		%eax, %eax
> +	jnz		upper_mem_next
> +
> +	/* Check for contiguous extension (base <=3D %edx < base + length) */
> +	movl		%es:(%di), %eax
> +	cmp		%eax, %edx
> +	jb		upper_mem_next
> +	addl		%es:8(%di), %eax
> +	cmp		%eax, %edx
> +	jae		upper_mem_next
> +
> +	/* If so, update %edx, and restart the search (mmap isn't ordered) */
> +	mov		%eax, %edx
> +	xor		%di, %di
> +	jmp		upper_mem_entry
> +
> +upper_mem_next:
> +	addl		%es:-4(%di), %edi
> +	jmp		upper_mem_entry
> +
> +upper_mem_done:
> +	sub		$0x100000, %edx
> +	shr		$10, %edx
> +	mov		%edx, %fs:0x8
> +
> +real_to_prot:
> +	/* Load the GDT before going into protected mode */
> +lgdt:
> +	data32 lgdt	%gs:GS_GDT_DESC
> +
> +	/* get us to protected mode now */
> +	movl		$1, %eax
> +	movl		%eax, %cr0
> +
> +	/* the LJMP sets CS for us and gets us to 32-bit */
> +ljmp:
> +	data32 ljmp	*%gs:GS_PROT_JUMP
> +
> +prot_mode:
> +.code32
> +
> +	/* initialize all other segments */
> +	movl		$0x10, %eax
> +	movl		%eax, %ss
> +	movl		%eax, %ds
> +	movl		%eax, %es
> +	movl		%eax, %fs
> +	movl		%eax, %gs
> +
> +	/* Read the kernel and modules into RAM */
> +	read_fw_blob_dma(FW_CFG_KERNEL)
> +
> +	/* Jump off to the kernel */
> +	read_fw		FW_CFG_KERNEL_ENTRY
> +	mov		%eax, %ecx
> +
> +	/* EBX contains a pointer to the bootinfo struct */
> +	read_fw		FW_CFG_INITRD_ADDR
> +	movl		%eax, %ebx
> +
> +	/* EAX has to contain the magic */
> +	movl		$MULTIBOOT_MAGIC, %eax
> +ljmp2:
> +	jmp		*%ecx
> +
> +/* Variables */
> +.align 4, 0
> +prot_jump:	.long prot_mode
> +		.short 8
> +
> +.align 8, 0
> +gdt:
> +	/* 0x00 */
> +.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
> +
> +	/* 0x08: code segment (base=3D0, limit=3D0xfffff, type=3D32bit code exe=
c/read, DPL=3D0, 4k) */
> +.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x9a, 0xcf, 0x00
> +
> +	/* 0x10: data segment (base=3D0, limit=3D0xfffff, type=3D32bit data rea=
d/write, DPL=3D0, 4k) */
> +.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0xcf, 0x00
> +
> +	/* 0x18: code segment (base=3D0, limit=3D0x0ffff, type=3D16bit code exe=
c/read/conf, DPL=3D0, 1b) */
> +.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x9e, 0x00, 0x00
> +
> +	/* 0x20: data segment (base=3D0, limit=3D0x0ffff, type=3D16bit data rea=
d/write, DPL=3D0, 1b) */
> +.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0x00, 0x00
> +
> +gdt_desc:
> +.short	(5 * 8) - 1
> +.long	gdt
> +
> +BOOT_ROM_END
> diff --git a/pc-bios/optionrom/optionrom.h b/pc-bios/optionrom/optionrom.h
> index 7bcdf0eeb240..2e6e2493f83f 100644
> --- a/pc-bios/optionrom/optionrom.h
> +++ b/pc-bios/optionrom/optionrom.h
> @@ -117,16 +117,12 @@
>   *
>   * Clobbers: %eax, %edx, %es, %ecx, %edi and adresses %esp-20 to %esp
>   */
> -#ifdef USE_FW_CFG_DMA
>  #define read_fw_blob_dma(var)                           \
>          read_fw         var ## _SIZE;                   \
>          mov             %eax, %ecx;                     \
>          read_fw         var ## _ADDR;                   \
>          mov             %eax, %edi ;                    \
>          read_fw_dma     var ## _DATA, %ecx, %edi
> -#else
> -#define read_fw_blob_dma(var) read_fw_blob(var)
> -#endif
> =20
>  #define read_fw_blob_pre(var)                           \
>          read_fw         var ## _SIZE;                   \


