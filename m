Return-Path: <kvm+bounces-45869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C5AAAFBA5
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A96B1BC016C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CE722CBF6;
	Thu,  8 May 2025 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BZs5/35t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A628984D13
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711589; cv=none; b=Ur0TXR1xVGaZvxWbmtKvm4Zqq/iRMGONknLYRXjnOUPbiLKQlsEv5+6Cj+kiRcDBZ9Jfshf8s4NPqoGh5dkxFrXuMABG0nUCtw0z4l9z4B3JIoGDqPoAKrQroX++M2kPjBdxsC9Ckac2FgjN838svpdCjWdgE3eaidnV1c47550=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711589; c=relaxed/simple;
	bh=ToJvX7xqfillul4ARnHgL1+z1iUkWxpxzlErCyzmk8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlrLHXmkaedpzF11U6XBoTua0MagiohP1uK5O/z1CueYZvGy1Cd8zRNEALA7AA+d0NjjEyX3mLzVGnWwVH6OrTyMy8qVIstN7Hs2h3fZhfvqjmYrQhdn2KwdFXC7R2QA2VwVCtgfGAJNQaoqK1lsYgBDlYE+/PRiHJA6rhUsRxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BZs5/35t; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b1ff9b276c2so460571a12.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711587; x=1747316387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LkeIBMUss+wtjS4ebn41wnF/9BG8kxWBr1hV0emyy84=;
        b=BZs5/35tw0hp1T24kMYq07eWBwGciEi2XFUAMi7QS9P6XKC9RjbGQ9qfTIA/Q6At2Z
         nvb1s4zAFeASSgb4Ki+e+efnahLmiXUBjp/dOG9qLeg7Ie8H6SIBafiTG8sGIYN/Ih2q
         p79jjPNiGiXAYNGA7ILBpIDGZR/bwabeaMzR5CJUGIIySbVRFtYxX0q+5QQimW7N7azC
         TBcgwrAzRi29A0dcU1R7ULJ/3Ybc6ZtbcXefJXzk67Z/D2G3k3Jn3uBxyPfgtx2AiqN1
         vYp3am9F+2LVfH1zEhAbIpemg/pMucFpuCaTrtpX87FeLwsS848OdtVdKq2SMbi2Gp70
         OFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711587; x=1747316387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LkeIBMUss+wtjS4ebn41wnF/9BG8kxWBr1hV0emyy84=;
        b=YripGeBIjc+8sLMnIFvGff1YmwE1f9XojjB1cbD8aGhGfYr3iIlgLvyv0Ipv9bC4tT
         jjbfQ12w0xAUMcdKc3W66Cx9H6lM1pLA3vgP/3CIei7FWU9nTGrj8BqwAgbh/3sNHR72
         V3ZxACN3OmSV8uoxIr/PVPnpnMaO4utgq/9727IRaYxU3omBOGh7qp6aLDdBE+34BGBQ
         M3/wbScF+KNs3BY9HcoYS+4oChHQWgA38wgOkczNM2YEx0KtBnNa1yPyGab85ZTQThd8
         F4wFMXAthKs4hMRsDzEHkp3hG+rC38UKBN2zLF6C23WqDFdqgcX88dJKLXWh/uE/vvz2
         qjJw==
X-Forwarded-Encrypted: i=1; AJvYcCWm+kdd+yJbW4sDBXgO2qbxJUAMgPOskjZP4C/3scon3yfW0mEM/WVckyGKewXhsGY536I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytq+4KRxP5I54x+SBHGa+OPjQ4AetSMGeyd/7UoTZQL67IUAjD
	MD17yKrY5W3U6U5qVhdZTRX+DWSCLROb8ZPHoqdX5Am+JqOZeCkAFP2w+zxOHes=
X-Gm-Gg: ASbGncs0WP9EWywS0PAzG0BmppECCvm3rHwwdkSw1KF/PIFWx9GTA7O42le0tUCnZt7
	Wagm0p09fNMQOwDOjNglQXoxGN7tgwY13UPjivCU1Vg8iNlpObp63iSImtEN7+kJFbvTG7Z9kq4
	yv78Yngoxz1SK/DbqiQwAcNVRIp4SgBWSlzZdJleZ0ADGn7RFHNHPovIaTg2ZkDRMei6VJzrn8I
	cTR2waRDNMrM2oBpar1ZZRQxuMvVSEy0SF+uneecTKtX7U13R4Y9Z2kXylDT4XvmLXvYLVGIHT9
	dKhUxk/VT5j/wFy3Nj+OaphEfCb16CJTB4LtAGZFue2VASD0EHYCNmVC3Nj/uoQyDzZBs8O3FVz
	gbUWudg9Dfqvbxug=
X-Google-Smtp-Source: AGHT+IEb+XvkV5eLr6ZekeS+qXcEJ9g0pF4pUOL46KSFBDzr+sgJmqbyPKXhnQX7SMjFaB4MIczeaw==
X-Received: by 2002:a17:90b:3803:b0:2fe:9783:afd3 with SMTP id 98e67ed59e1d1-30b28cec4d7mr5237370a91.2.1746711586707;
        Thu, 08 May 2025 06:39:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d5341dsm2150592a91.21.2025.05.08.06.39.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:39:46 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v4 10/27] hw/i386/pc: Remove linuxboot.bin
Date: Thu,  8 May 2025 15:35:33 +0200
Message-ID: <20250508133550.81391-11-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

All PC machines now use the linuxboot_dma.bin binary,
we can remove the non-DMA version (linuxboot.bin).

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/pc.c                  |   3 +-
 pc-bios/meson.build           |   1 -
 pc-bios/optionrom/Makefile    |   2 +-
 pc-bios/optionrom/linuxboot.S | 195 ----------------------------------
 4 files changed, 2 insertions(+), 199 deletions(-)
 delete mode 100644 pc-bios/optionrom/linuxboot.S

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 524d2fd98e8..4e6fe68e2e0 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -654,8 +654,7 @@ void xen_load_linux(PCMachineState *pcms)
 
     x86_load_linux(x86ms, fw_cfg, PC_FW_DATA, pcmc->pvh_enabled);
     for (i = 0; i < nb_option_roms; i++) {
-        assert(!strcmp(option_rom[i].name, "linuxboot.bin") ||
-               !strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
+        assert(!strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
                !strcmp(option_rom[i].name, "pvh.bin") ||
                !strcmp(option_rom[i].name, "multiboot_dma.bin"));
         rom_add_option(option_rom[i].name, option_rom[i].bootindex);
diff --git a/pc-bios/meson.build b/pc-bios/meson.build
index f2d4dc416a4..39a7fea332e 100644
--- a/pc-bios/meson.build
+++ b/pc-bios/meson.build
@@ -63,7 +63,6 @@ blobs = [
   'efi-vmxnet3.rom',
   'qemu-nsis.bmp',
   'multiboot_dma.bin',
-  'linuxboot.bin',
   'linuxboot_dma.bin',
   'kvmvapic.bin',
   'pvh.bin',
diff --git a/pc-bios/optionrom/Makefile b/pc-bios/optionrom/Makefile
index 1183ef88922..e694c7aac00 100644
--- a/pc-bios/optionrom/Makefile
+++ b/pc-bios/optionrom/Makefile
@@ -2,7 +2,7 @@ include config.mak
 SRC_DIR := $(TOPSRC_DIR)/pc-bios/optionrom
 VPATH = $(SRC_DIR)
 
-all: multiboot_dma.bin linuxboot.bin linuxboot_dma.bin kvmvapic.bin pvh.bin
+all: multiboot_dma.bin linuxboot_dma.bin kvmvapic.bin pvh.bin
 # Dummy command so that make thinks it has done something
 	@true
 
diff --git a/pc-bios/optionrom/linuxboot.S b/pc-bios/optionrom/linuxboot.S
deleted file mode 100644
index ba821ab922d..00000000000
--- a/pc-bios/optionrom/linuxboot.S
+++ /dev/null
@@ -1,195 +0,0 @@
-/*
- * Linux Boot Option ROM
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- *
- * Copyright Novell Inc, 2009
- *   Authors: Alexander Graf <agraf@suse.de>
- *
- * Based on code in hw/pc.c.
- */
-
-#include "optionrom.h"
-
-#define BOOT_ROM_PRODUCT "Linux loader"
-
-BOOT_ROM_START
-
-run_linuxboot:
-
-	cli
-	cld
-
-	jmp		copy_kernel
-boot_kernel:
-
-	read_fw		FW_CFG_SETUP_ADDR
-
-	mov		%eax, %ebx
-	shr		$4, %ebx
-
-	/* All segments contain real_addr */
-	mov		%bx, %ds
-	mov		%bx, %es
-	mov		%bx, %fs
-	mov		%bx, %gs
-	mov		%bx, %ss
-
-	/* CX = CS we want to jump to */
-	add		$0x20, %bx
-	mov		%bx, %cx
-
-	/* SP = cmdline_addr-real_addr-16 */
-	read_fw		FW_CFG_CMDLINE_ADDR
-	mov		%eax, %ebx
-	read_fw		FW_CFG_SETUP_ADDR
-	sub		%eax, %ebx
-	sub		$16, %ebx
-	mov		%ebx, %esp
-
-	/* Build indirect lret descriptor */
-	pushw		%cx		/* CS */
-	xor		%ax, %ax
-	pushw		%ax		/* IP = 0 */
-
-	/* Clear registers */
-	xor		%eax, %eax
-	xor		%ebx, %ebx
-	xor		%ecx, %ecx
-	xor		%edx, %edx
-	xor		%edi, %edi
-	xor		%ebp, %ebp
-
-	/* Jump to Linux */
-	lret
-
-
-copy_kernel:
-	/* Read info block in low memory (0x10000 or 0x90000) */
-	read_fw		FW_CFG_SETUP_ADDR
-	shr		$4, %eax
-	mov		%eax, %es
-	xor		%edi, %edi
-	read_fw_blob_addr32_edi(FW_CFG_SETUP)
-
-	cmpw            $0x203, %es:0x206      // if protocol >= 0x203
-	jae             1f                     // have initrd_max
-	movl            $0x37ffffff, %es:0x22c // else assume 0x37ffffff
-1:
-
-	/* Check if using kernel-specified initrd address */
-	read_fw		FW_CFG_INITRD_ADDR
-	mov		%eax, %edi             // (load_kernel wants it in %edi)
-	read_fw		FW_CFG_INITRD_SIZE     // find end of initrd
-	add		%edi, %eax
-	xor		%es:0x22c, %eax        // if it matches es:0x22c
-	and		$-4096, %eax           // (apart from padding for page)
-	jz		load_kernel            // then initrd is not at top
-					       // of memory
-
-	/* pc.c placed the initrd at end of memory.  Compute a better
-	 * initrd address based on e801 data.
-	 */
-	mov		$0xe801, %ax
-	xor		%cx, %cx
-	xor		%dx, %dx
-	int		$0x15
-
-	/* Output could be in AX/BX or CX/DX */
-	or		%cx, %cx
-	jnz		1f
-	or		%dx, %dx
-	jnz		1f
-	mov		%ax, %cx
-	mov		%bx, %dx
-1:
-
-	or		%dx, %dx
-	jnz		2f
-	addw		$1024, %cx            /* add 1 MB */
-	movzwl		%cx, %edi
-	shll		$10, %edi             /* convert to bytes */
-	jmp		3f
-
-2:
-	addw		$16777216 >> 16, %dx  /* add 16 MB */
-	movzwl		%dx, %edi
-	shll		$16, %edi             /* convert to bytes */
-
-3:
-	read_fw         FW_CFG_INITRD_SIZE
-	subl            %eax, %edi
-	andl            $-4096, %edi          /* EDI = start of initrd */
-	movl		%edi, %es:0x218       /* put it in the header */
-
-load_kernel:
-	/* We need to load the kernel into memory we can't access in 16 bit
-	   mode, so let's get into 32 bit mode, write the kernel and jump
-	   back again. */
-
-	/* Reserve space on the stack for our GDT descriptor. */
-	mov             %esp, %ebp
-	sub             $16, %esp
-
-	/* Now create the GDT descriptor */
-	movw		$((3 * 8) - 1), -16(%bp)
-	mov		%cs, %eax
-	movzwl		%ax, %eax
-	shl		$4, %eax
-	addl		$gdt, %eax
-	movl		%eax, -14(%bp)
-
-	/* And load the GDT */
-	data32 lgdt	-16(%bp)
-	mov		%ebp, %esp
-
-	/* Get us to protected mode now */
-	mov		$1, %eax
-	mov		%eax, %cr0
-
-	/* So we can set ES to a 32-bit segment */
-	mov		$0x10, %eax
-	mov		%eax, %es
-
-	/* We're now running in 16-bit CS, but 32-bit ES! */
-
-	/* Load kernel and initrd */
-	read_fw_blob_addr32_edi(FW_CFG_INITRD)
-	read_fw_blob_addr32(FW_CFG_KERNEL)
-	read_fw_blob_addr32(FW_CFG_CMDLINE)
-
-	/* And now jump into Linux! */
-	mov		$0, %eax
-	mov		%eax, %cr0
-
-	/* ES = CS */
-	mov		%cs, %ax
-	mov		%ax, %es
-
-	jmp		boot_kernel
-
-/* Variables */
-
-.align 4, 0
-gdt:
-	/* 0x00 */
-.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-
-	/* 0x08: code segment (base=0, limit=0xfffff, type=32bit code exec/read, DPL=0, 4k) */
-.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x9a, 0xcf, 0x00
-
-	/* 0x10: data segment (base=0, limit=0xfffff, type=32bit data read/write, DPL=0, 4k) */
-.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0xcf, 0x00
-
-BOOT_ROM_END
-- 
2.47.1


