Return-Path: <kvm+bounces-7133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7475783D7B9
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE1BD1F30BF4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F070433CD9;
	Fri, 26 Jan 2024 09:41:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B65E1A731;
	Fri, 26 Jan 2024 09:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706262061; cv=none; b=FflsAaCHussdHHJtTqFRsqlAZ3al2vF0AvD/U2mYtXQ/7AbB0GazcyfSsKxePEdS6yP5WsEJFVgOOdoQlfP0jhCG5ai1vOS7HErxhWnU6dm4uz6QxTy3DoDLbk4VmnXpYC6T91lB0eUwNYpdZljTPLlyfM4WUprl7g/wZfzEoEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706262061; c=relaxed/simple;
	bh=v5UliB1XJr2eGK6/2fCTcRjSdUOtwLJz82Jeir1lThU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pZ29aZoiZosL7ofnGLHUSsOB1EC9IxOGK6Cflz2rZbyGTj/D/9/opdX4Ij8NxAeze2bCaRi+iAIhv7853M5QVRDa1voNaN+uTWKbcs+/rT/PUJjy7pRp0SEJQhysgyOFzFRiPqkhyqABDpZRjldRT3PhYeBaw5bMMh0nFCXuMSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: by air.basealt.ru (Postfix, from userid 490)
	id 7C9A72F20226; Fri, 26 Jan 2024 09:40:49 +0000 (UTC)
X-Spam-Level: 
Received: from shell.ipa.basealt.ru (unknown [176.12.98.74])
	by air.basealt.ru (Postfix) with ESMTPSA id E65202F20247;
	Fri, 26 Jan 2024 09:40:24 +0000 (UTC)
From: oficerovas@altlinux.org
To: oficerovas@altlinux.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kovalev@altlinux.org
Subject: [PATCH 0/2] kvm: fix kmalloc bug in kvm_arch_prepare_memory_region on 5.10 stable kernel
Date: Fri, 26 Jan 2024 12:40:21 +0300
Message-ID: <20240126094023.2677376-1-oficerovas@altlinux.org>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexander Ofitserov <oficerovas@altlinux.org>

Syzkaller hit 'WARNING: kmalloc bug in kvm_arch_prepare_memory_region' bug.

This bug is not a vulnerability and is reproduced only when running with root privileges
for stable 5.10 kernel.

Bug fixed by backported commits in next two patches.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 315 at mm/util.c:618 kvmalloc_node+0x163/0x170 mm/util.c:618
Modules linked in: ide_cd_mod cdrom ide_gd_mod ata_generic pata_acpi ata_piix libata scsi_mod ide_pci_generic ppdev joydev kvm_amd ccp kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd bochs_drm cryptd af_packet drm_vram_helper glue_helper drm_ttm_helper ttm psmouse evdev pcspkr drm_kms_helper input_leds piix cec ide_core rc_core intel_agp i2c_piix4 serio_raw intel_gtt parport_pc parport floppy tiny_power_button qemu_fw_cfg button sch_fq_codel drm fuse dm_mod binfmt_misc efi_pstore virtio_rng rng_core ip_tables x_tables autofs4
CPU: 1 PID: 315 Comm: syz-executor319 Not tainted 5.10.198-std-def-alt1 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-alt1 04/01/2014
RIP: 0010:kvmalloc_node+0x163/0x170 mm/util.c:618
Code: ed 41 81 cd 00 20 01 00 e9 6c ff ff ff e8 f5 f1 d0 ff 81 e5 00 20 00 00 31 ff 89 ee e8 16 ee d0 ff 85 ed 75 cc e8 dd f1 d0 ff <0f> 0b e9 e4 fe ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 fd
RSP: 0018:ffff8881034c78a0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000010101640 RCX: ffffffff817bff9a
RDX: ffff8881185e0240 RSI: ffffffff817bffa3 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8881034c7ac8
R10: 0000000000000000 R11: 0000000000000001 R12: 000000008080b200
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8881034c7ab0
FS:  00007f4ee2a3d740(0000) GS:ffff888140280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000008 CR3: 0000000130906000 CR4: 0000000000750ee0
PKRU: 55555554
Call Trace:
 kvm_arch_prepare_memory_region+0x141/0x5c0 [kvm]
 kvm_set_memslot+0x522/0x13d0 [kvm]
 __kvm_set_memory_region+0xb32/0xfe0 [kvm]
 kvm_vm_ioctl+0x6b7/0x1cd0 [kvm]
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x19f/0x210 fs/ioctl.c:739
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x62/0xc7
RIP: 0033:0x7f4ee2b3ad49
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ef 70 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007fffa9df3428 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000056092b108330 RCX: 00007f4ee2b3ad49
RDX: 00000000200000c0 RSI: 000000004020ae46 RDI: 0000000000000004
RBP: 0000000000000000 R08: 000056092b108330 R09: 000056092b108330
R10: 000056092b108330 R11: 0000000000000246 R12: 000056092b108240
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
irq event stamp: 19075
hardirqs last  enabled at (19085): [<ffffffff813489c0>] console_unlock+0xa40/0xca0 kernel/printk/printk.c:2561
hardirqs last disabled at (19092): [<ffffffff81348643>] console_unlock+0x6c3/0xca0 kernel/printk/printk.c:2476
softirqs last  enabled at (19108): [<ffffffff836011d2>] asm_call_irq_on_stack+0x12/0x20
softirqs last disabled at (19101): [<ffffffff836011d2>] asm_call_irq_on_stack+0x12/0x20
---[ end trace c4463afe05024b06 ]---


Syzkaller reproducer:
# {Threaded:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: Leak:false NetInjection:false NetDevices:false NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false VhciInjection:false Wifi:false IEEE802154:false Sysctl:false UseTmpDir:false HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false Fault:false FaultCall:0 FaultNth:0}}
r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
connect$pppl2tp(0xffffffffffffffff, &(0x7f00000000c0)=@pppol2tp={0x18, 0x1, {0x0, 0xffffffffffffffff, {0x2, 0x0, @rand_addr=0x64010101}}}, 0x26)
r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
ioctl$KVM_CREATE_DEVICE(r1, 0x4020ae46, &(0x7f00000000c0))


C reproducer:
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE 

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

uint64_t r[2] = {0xffffffffffffffff, 0xffffffffffffffff};

int main(void)
{
		syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
	syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
	syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
				intptr_t res = 0;
memcpy((void*)0x20000000, "/dev/kvm\000", 9);
	res = syscall(__NR_openat, 0xffffffffffffff9cul, 0x20000000ul, 0ul, 0ul);
	if (res != -1)
		r[0] = res;
*(uint16_t*)0x200000c0 = 0x18;
*(uint32_t*)0x200000c2 = 1;
*(uint32_t*)0x200000c6 = 0;
*(uint32_t*)0x200000ca = -1;
*(uint16_t*)0x200000ce = 2;
*(uint16_t*)0x200000d0 = htobe16(0);
*(uint32_t*)0x200000d2 = htobe32(0x64010101);
*(uint16_t*)0x200000de = 0;
*(uint16_t*)0x200000e0 = 0;
*(uint16_t*)0x200000e2 = 0;
*(uint16_t*)0x200000e4 = 0;
	syscall(__NR_connect, -1, 0x200000c0ul, 0x26ul);
	res = syscall(__NR_ioctl, r[0], 0xae01, 0ul);
	if (res != -1)
		r[1] = res;
*(uint32_t*)0x200000c0 = 0;
*(uint32_t*)0x200000c8 = 0;
	syscall(__NR_ioctl, r[1], 0x4020ae46, 0x200000c0ul);
	return 0;
}

[PATCH 1/2] mm: vmalloc: introduce array allocation functions
[PATCH 2/2] KVM: use __vcalloc for very large allocations

-- 
2.42.1

