Return-Path: <kvm+bounces-22063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 899489393DF
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 20:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 429D0281B99
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 18:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7088D17083F;
	Mon, 22 Jul 2024 18:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZhZQ7C8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CF716EBF0
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721674223; cv=none; b=HOxpSn0F1dfXuN5x0BZ3D3CjFWgnWH7uRPEVwL1TT88EE56j1jhvzqhFHM0nmRIv9+3oGyGUIB58zsLgewOu23clpU/VsSQZ7oQOyZwgXWby9dG2fRghR+3IBRobLTGYRi6eo42ztsP8INsF7QMhDeyqI9SMXMty+jD1fYkSYrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721674223; c=relaxed/simple;
	bh=xMxEqERAvBfyqmA6EfJsI/uZzi3JDM0LJAin6wOenoE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=e5g6aSFkpREfq2qtxuCOZykq/zSezLXd8EkeORSJQzsT+ZwfS1N15N2vQFqnVL8nEd4ZUAC32o9K+lI3HAC/4mrQT8/n2/wmqRo/s1yt9GwhSTLYIrxJigtGLlN/iSZ0qvweEtOgwIZKUorjGIVr0NykhHJ7d+GPly+v796om+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZhZQ7C8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4070BC4AF0D
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 18:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721674223;
	bh=xMxEqERAvBfyqmA6EfJsI/uZzi3JDM0LJAin6wOenoE=;
	h=From:To:Subject:Date:From;
	b=KZhZQ7C87aBtYcJvVC/+nvyKfYA0WmPN/FganWQChOCQJvnF5Aoi22SWu5eonmKjs
	 q5QMbDyjsz3GhPJNlm252y856cY/s++Ll/xaX5psDy0YJM0rsg7QJM7jqVxlSoPgV9
	 W31IqWl5XNeFq1Xb83IXsCapi3PAeKOQqG1Y0bTy/NoPK/vaDTEbeyBAhNlsn3dg6l
	 xeeJt2XqupxBz6DgijogmdjX3Ru4QfrZWviSjXZapu/C4zgrWUrMPmH2ERWfBgn96o
	 YtldP6r+TyuHI3ksVqF0zTEDQ3GR3+3kXTPvJQOkagXj5KzCOYhbGNbETtfjgvdPD3
	 cDeluOVnxesog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 333BAC53B73; Mon, 22 Jul 2024 18:50:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] New: kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Mon, 22 Jul 2024 18:50:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ununpta@mailto.plus
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219085-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

            Bug ID: 219085
           Summary: kvm_spurious_fault in L1 when running a nested kvm
                    instance on AMD Opteron_G5_qemu L0
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ununpta@mailto.plus
        Regression: No

Hello,

when I try to run `qemu-system-x86_64 -accel kvm` in L1 bash in linux kvm g=
uest
with kernel 6.10.0 x86_64, I get this message in L1 guest:

[  104.446685] kvm_amd: Nested Virtualization enabled
[  104.446688] kvm_amd: Nested Paging disabled
[  104.446690] kvm_amd: PMU virtualization is disabled
[  112.940705] clocksource: timekeeping watchdog on CPU0: hpet wd-wd read-b=
ack
delay of 50500ns
[  112.940746] clocksource: wd-tsc-wd read-back delay of 1385000ns, clock-s=
kew
test skipped!
[  355.714362] unchecked MSR access error: WRMSR to 0xc0000080 (tried to wr=
ite
0x0000000000001d01) at rIP: 0xffffffff9228a274 (native_write_msr+0x4/0x20)
[  355.714373] Call Trace:
[  355.714376]  <TASK>
[  355.714379]  ? ex_handler_msr+0xd3/0x150
[  355.714381]  ? fixup_exception+0x276/0x2e0
[  355.714383]  ? exc_general_protection+0x14f/0x440
[  355.714388]  ? asm_exc_general_protection+0x22/0x30
[  355.714391]  ? native_write_msr+0x4/0x20
[  355.714397]  svm_hardware_enable+0xd5/0x2f0 [kvm_amd]
[  355.714405]  kvm_arch_hardware_enable+0xc7/0x280 [kvm]
[  355.714469]  hardware_enable_nolock+0x1d/0x50 [kvm]
[  355.714489]  smp_call_function_many_cond+0xcf/0x4d0
[  355.714494]  ? kmalloc_trace_noprof+0x2c8/0x2f0
[  355.714497]  ? __pfx_hardware_enable_nolock+0x10/0x10 [kvm]
[  355.714516]  on_each_cpu_cond_mask+0x20/0x40
[  355.714517]  kvm_dev_ioctl+0x815/0xb40 [kvm]
[  355.714538]  __x64_sys_ioctl+0x93/0xd0
[  355.714542]  do_syscall_64+0x7e/0x190
[  355.714545]  ? kvm_dev_ioctl+0x2fb/0xb40 [kvm]
[  355.714564]  ? __schedule+0x3f3/0xb40
[  355.714566]  ? syscall_exit_to_user_mode+0x73/0x200
[  355.714567]  ? do_syscall_64+0x8a/0x190
[  355.714568]  ? do_syscall_64+0x8a/0x190
[  355.714569]  ? tomoyo_init_request_info+0x95/0xc0
[  355.714573]  ? tomoyo_path_number_perm+0x88/0x200
[  355.714576]  ? kvm_dev_ioctl+0x2fb/0xb40 [kvm]
[  355.714595]  ? syscall_exit_to_user_mode+0x73/0x200
[  355.714597]  ? syscall_exit_to_user_mode+0x73/0x200
[  355.714598]  ? do_syscall_64+0x8a/0x190
[  355.714599]  ? __count_memcg_events+0x54/0xf0
[  355.714601]  ? __rseq_handle_notify_resume+0xa4/0x4f0
[  355.714604]  ? handle_mm_fault+0xaa/0x320
[  355.714608]  ? restore_fpregs_from_fpstate+0x38/0x90
[  355.714611]  ? switch_fpu_return+0x4b/0xc0
[  355.714612]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  355.714614] RIP: 0033:0x7fb24aab7c5b
[  355.714616] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00
00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c=
2 3d
00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  355.714617] RSP: 002b:00007ffee1205880 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  355.714619] RAX: ffffffffffffffda RBX: 000000000000ae01 RCX:
00007fb24aab7c5b
[  355.714620] RDX: 0000000000000000 RSI: 000000000000ae01 RDI:
000000000000000a
[  355.714620] RBP: 000055b5ba0d2160 R08: 00007fb24ab8cc68 R09:
0000000000000006
[  355.714621] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  355.714621] R13: 00007ffee1205b80 R14: 0000000000000000 R15:
00007ffee1205ac0
[  355.714622]  </TASK>
[  355.880539] ------------[ cut here ]------------
[  355.880542] kernel BUG at arch/x86/kvm/x86.c:510!
[  355.880548] Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  355.880551] CPU: 0 PID: 1550 Comm: qemu-system-x86 Not tainted 6.10.0 #8
[  355.880553] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
edk2-stable202402-prebuilt.qemu.org 02/14/2024
[  355.880554] RIP: 0010:kvm_spurious_fault+0xe/0x10 [kvm]
[  355.880584] Code: 00 00 85 c0 0f 95 c0 e9 90 79 e7 d1 90 90 90 90 90 90 =
90
90 90 90 90 90 90 90 90 90 80 3d f9 1c 02 00 00 74 05 e9 72 79 e7 d1 <0f> 0=
b 90
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 90 e9 59
[  355.880586] RSP: 0018:ffffb618806fbc38 EFLAGS: 00010246
[  355.880587] RAX: 00000001025d0000 RBX: ffff94884d6c99b0 RCX:
0000000000000027
[  355.880588] RDX: 0000000000000003 RSI: 000000000188d000 RDI:
ffff94884d6c99b0
[  355.880589] RBP: 0000000000038060 R08: 0000000000000001 R09:
0000000000000027
[  355.880590] R10: 0000000000000001 R11: 0000000000400dc0 R12:
ffff9488bbc38060
[  355.880590] R13: 0000000000000000 R14: ffff9488411da000 R15:
0000000000000000
[  355.880591] FS:  00007fb2390006c0(0000) GS:ffff9488bbc00000(0000)
knlGS:0000000000000000
[  355.880592] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  355.880593] CR2: 00007fbe78a5e030 CR3: 000000010d630000 CR4:
0000000000350ef0
[  355.880595] Call Trace:
[  355.880598]  <TASK>
[  355.880599]  ? die+0x32/0x80
[  355.880603]  ? do_trap+0xd9/0x100
[  355.880605]  ? kvm_spurious_fault+0xe/0x10 [kvm]
[  355.880627]  ? do_error_trap+0x6a/0x90
[  355.880628]  ? kvm_spurious_fault+0xe/0x10 [kvm]
[  355.880648]  ? exc_invalid_op+0x4c/0x60
[  355.880652]  ? kvm_spurious_fault+0xe/0x10 [kvm]
[  355.880672]  ? asm_exc_invalid_op+0x16/0x20
[  355.880675]  ? kvm_spurious_fault+0xe/0x10 [kvm]
[  355.880695]  svm_prepare_switch_to_guest+0xe4/0x160 [kvm_amd]
[  355.880701]  kvm_arch_vcpu_ioctl_run+0x441/0x15b0 [kvm]
[  355.880729]  kvm_vcpu_ioctl+0x23d/0x6f0 [kvm]
[  355.880749]  ? check_preempt_wakeup_fair+0x136/0x1d0
[  355.880753]  __x64_sys_ioctl+0x93/0xd0
[  355.880757]  do_syscall_64+0x7e/0x190
[  355.880760]  ? wake_up_q+0x4a/0x90
[  355.880762]  ? futex_wake+0x155/0x190
[  355.880765]  ? do_futex+0xeb/0x1c0
[  355.880766]  ? __x64_sys_futex+0x8e/0x1d0
[  355.880767]  ? syscall_exit_to_user_mode+0x73/0x200
[  355.880769]  ? syscall_exit_to_user_mode+0x73/0x200
[  355.880770]  ? do_syscall_64+0x8a/0x190
[  355.880771]  ? do_syscall_64+0x8a/0x190
[  355.880772]  ? exc_page_fault+0x72/0x170
[  355.880773]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  355.880775] RIP: 0033:0x7fb24aab7c5b
[  355.880776] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00
00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c=
2 3d
00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  355.880777] RSP: 002b:00007fb238fff530 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  355.880778] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007fb24aab7c5b
[  355.880779] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000000c
[  355.880780] RBP: 000055b5ba0d7e60 R08: 000055b5b32412d0 R09:
0000000000000000
[  355.880780] R10: 00007fb24ab2bf70 R11: 0000000000000246 R12:
0000000000000000
[  355.880781] R13: 0000000000000007 R14: 00007ffee1205360 R15:
00007fb238800000
[  355.880782]  </TASK>
[  355.880783] Modules linked in: kvm_amd ccp kvm qrtr rfkill binfmt_misc
nls_ascii nls_cp437 vfat fat crc32_pclmul ghash_clmulni_intel sha512_ssse3
sha256_ssse3 sha1_ssse3 aesni_intel crypto_simd iTCO_wdt cryptd intel_pmc_b=
xt
joydev iTCO_vendor_support pcspkr watchdog button sg evdev serio_raw parpor=
t_pc
ppdev lp parport fuse loop efi_pstore dm_mod configfs qemu_fw_cfg ip_tables
x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic efivarfs rai=
d10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c
crc32c_generic xor raid6_pq raid1 raid0 md_mod hid_generic usbhid bochs
drm_vram_helper hid sd_mod t10_pi drm_kms_helper crc64_rocksoft crc64
crc_t10dif crct10dif_generic drm_ttm_helper ttm ahci libahci ehci_pci uhci_=
hcd
virtio_scsi libata ehci_hcd scsi_mod e1000e psmouse usbcore virtio_pci virt=
io
virtio_pci_legacy_dev virtio_pci_modern_dev crct10dif_pclmul crct10dif_comm=
on
crc32c_intel drm virtio_ring i2c_i801 lpc_ich usb_common scsi_common i2c_sm=
bus
[last unloaded: ccp]
[  355.880835] ---[ end trace 0000000000000000 ]---
[  355.884034] RIP: 0010:kvm_spurious_fault+0xe/0x10 [kvm]
[  355.884060] Code: 00 00 85 c0 0f 95 c0 e9 90 79 e7 d1 90 90 90 90 90 90 =
90
90 90 90 90 90 90 90 90 90 80 3d f9 1c 02 00 00 74 05 e9 72 79 e7 d1 <0f> 0=
b 90
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 90 e9 59
[  355.884062] RSP: 0018:ffffb618806fbc38 EFLAGS: 00010246
[  355.884063] RAX: 00000001025d0000 RBX: ffff94884d6c99b0 RCX:
0000000000000027
[  355.884064] RDX: 0000000000000003 RSI: 000000000188d000 RDI:
ffff94884d6c99b0
[  355.884064] RBP: 0000000000038060 R08: 0000000000000001 R09:
0000000000000027
[  355.884065] R10: 0000000000000001 R11: 0000000000400dc0 R12:
ffff9488bbc38060
[  355.884066] R13: 0000000000000000 R14: ffff9488411da000 R15:
0000000000000000
[  355.884066] FS:  00007fb2390006c0(0000) GS:ffff9488bbc00000(0000)
knlGS:0000000000000000
[  355.884067] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  355.884068] CR2: 00007fbe78a5e030 CR3: 000000010d630000 CR4:
0000000000350ef0
[  355.884069] note: qemu-system-x86[1550] exited with preempt_count 1

If I run `qemu-system-x86_64 -accel tcg` in L1 bash, it correctly boots into
qemu BIOS.

Any ideas about what could have caused it?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

