Return-Path: <kvm+bounces-65140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 33938C9C1BA
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C26D9349BED
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E8728935A;
	Tue,  2 Dec 2025 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lm9OtMmU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1047289824
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691594; cv=none; b=stetnxLFRTI5WTxhFZ4DzHP+06aFrY449Wjv2gdNWfdn2sVLgwShAEqXwTeVybenzVP2uVWkV1d0Xu/ixIPPoe878X91cvMVKnu+26JoKliS3/tr4NGMNajb4Hjr4j/cYq4oKgHgHL6CeIkVp38qyvYsgSmsuJyNQwv6f/vaggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691594; c=relaxed/simple;
	bh=8x9iEny3yMGUyVfEpO6R5L2YLFa9TzCWNYtSEp91HTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MznIbkqyp6CZ+65zfqHnX06eHsOliAhKGb/qwqYufHRebXYLskSSmsi8qpW1y/bnd1uTCh4LrNR11+5knyKgdm4fj5qYkW2N3Y0UaDXyC0Shbix1yN/Ef2cYLgfIPMl/ZYPsKa79e4z7gI/rTR98kcPzdnkMdnAvnEiOm1GCLBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lm9OtMmU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691593; x=1796227593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8x9iEny3yMGUyVfEpO6R5L2YLFa9TzCWNYtSEp91HTM=;
  b=lm9OtMmUEm+ahJowsr8HCBCmLgi/aSb6O1OtQYwyuPwdnRaN4WcNc9gQ
   bgCKimpOETNfEZ1hbGoEW9v3vxt0Lr/Udi/qFSD2VgchCgLSAJp8kOe2I
   kEvLjR1Ak1V76QXHt9Pc+Ecwt4zg1acGEaQBvg7xtC0xWj3kWeKXar9mW
   iZXj6Uv/EEHk2+HWzCQ5YVcMawiBqTDLuYDMt0yu1JUKydlhkOVlWJne5
   qnTlgpSRvDxiRpN30NFbop2Ws5FjX+eItvP1pnhs5IXxy4jzhNJ2qdbVk
   OHHE2wm5L0s35kvK3jgB+dFHq7jaduLGkU5mH5lQXQfp/FbleEIoLQSXz
   A==;
X-CSE-ConnectionGUID: 7Dl4C1gKRtmPLV5sZkTG0g==
X-CSE-MsgGUID: gGY38XE8StutdOyEVP03SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142763"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142763"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:06:32 -0800
X-CSE-ConnectionGUID: P/9xWGnyTGWx0/LRSRgB1w==
X-CSE-MsgGUID: SkfhYdF6Q2eRTuTSoBqPuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537606"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:06:23 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
Date: Wed,  3 Dec 2025 00:28:23 +0800
Message-Id: <20251202162835.3227894-17-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

All machines now use the linuxboot_dma.bin binary, so it's safe to
remove the non-DMA version (linuxboot.bin).

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v4:
 * Update commit message: not only pc, but also microvm enables
   DMA for FwCfgState (in microvm_memory_init).
---
 hw/i386/pc.c                  |   3 +-
 pc-bios/meson.build           |   1 -
 pc-bios/optionrom/Makefile    |   2 +-
 pc-bios/optionrom/linuxboot.S | 195 ----------------------------------
 4 files changed, 2 insertions(+), 199 deletions(-)
 delete mode 100644 pc-bios/optionrom/linuxboot.S

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 9d88d4a5207a..2e315414aeaf 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -666,8 +666,7 @@ void xen_load_linux(PCMachineState *pcms)
 
     x86_load_linux(x86ms, fw_cfg, PC_FW_DATA, pcmc->pvh_enabled);
     for (i = 0; i < nb_option_roms; i++) {
-        assert(!strcmp(option_rom[i].name, "linuxboot.bin") ||
-               !strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
+        assert(!strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
                !strcmp(option_rom[i].name, "pvh.bin") ||
                !strcmp(option_rom[i].name, "multiboot_dma.bin"));
         rom_add_option(option_rom[i].name, option_rom[i].bootindex);
diff --git a/pc-bios/meson.build b/pc-bios/meson.build
index efe45c16705d..2f470ed12942 100644
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
index 1183ef889228..e694c7aac007 100644
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
index ba821ab922da..000000000000
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
2.34.1


