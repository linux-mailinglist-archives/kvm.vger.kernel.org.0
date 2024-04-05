Return-Path: <kvm+bounces-13750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7EA89A5AD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF0B62828BD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 20:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5321C6A8;
	Fri,  5 Apr 2024 20:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKgqIZQb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED71CF92
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 20:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712349196; cv=none; b=ClAajPF041n6OBUo4cXVygZrZXhSDr/FRr9bhx3Pnnz5q3vi79RmE1+nqNbNTfO+Yze8K/p0v9p6vm+gaeIxbftOl9zMVa5A9hYXJqP1nS17UlG3IsRDto8aeVS/jR82tXVQauCmA68ATYuepDAgzgevgNPbmnWjmhym5syz0+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712349196; c=relaxed/simple;
	bh=0Yet2BrezELaKE50M1gPTmg/6ZWUpKBkysK2FaqOuik=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=T5bYz09nqY5e3B1jMmeyjC26ZuFC2ZRlEt4oU507Xl3BZ5hrBZlk18zeWsdRuHCkWLlHgJ905BagSgnLuj3O4bk0Ws+D4iQXIoWQTDVrvU3HL5UvOA4R6NSnMN2YAZ6tcPunby9E4D74nm+acRz0J+fdWUSkR+mVk9DsALhvvdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKgqIZQb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D198C43390
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 20:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712349196;
	bh=0Yet2BrezELaKE50M1gPTmg/6ZWUpKBkysK2FaqOuik=;
	h=From:To:Subject:Date:From;
	b=hKgqIZQbiMp2ldhqwIPcFN5KYpUnH35UNgw7snBMoziyxINUSCsRW3xKJ7ZNW2rY/
	 Od+zvhnMTrJ4QjruagRPrtr6SB6ev8Cdfs3uCs8QmVIDY9XVFeeRg2qiyfAfSavx6g
	 bUf0XlEIPiw0Nsg/VIZcPAxhVihJWd14WXm1aEONHCgzgD4O6bisIWP7H8y7mtiRrq
	 ngBHDU63QFeLp+tSKTv2y1oE1C2CYOXhAISclj209yhPflJmq0MG9i5IMLi0l2UsP/
	 ANYorpFBTfR1Pv9RUeb3VnT0Bo3Cf+RquYoSYvxhMnXdfde+t9KzFt1bhGZqOydZD2
	 qJDCfo4wdc69Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 40127C53BD3; Fri,  5 Apr 2024 20:33:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218684] New: CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
Date: Fri, 05 Apr 2024 20:33:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: frantisek@sumsal.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218684-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218684

            Bug ID: 218684
           Summary: CPU soft lockups in KVM VMs on kernel 6.x after
                    switching hypervisor from C8S to C9S
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: frantisek@sumsal.cz
        Regression: No

Hey!

I'm currently in the middle of moving some of our hypervisors for upstream
systemd CI from CentOS Stream 8 to CentOS Stream 9 (as the former will go E=
OL
soon), and started hitting soft lockups on the guest machines (Arch Linux, =
both
with "stock" kernel and mainline one).

The hypervisors are AWS EC2 C5n Metal instances [0] running CentOS Stream,
which then run Arch Linux (KVM) VMs (using libvirt via Vagrant) - cpuinfo f=
rom
one of the guests is at [1].

The "production" hypervisors currently run CentOS Stream 8 (kernel
4.18.0-548.el8.x86_64) and everything is fine. However, after trying to upg=
rade
a couple of them to CentOS Stream 9 (kernel 5.14.0-432.el9.x86_64) the gues=
ts
started exhibiting frequent soft lockups when running just the systemd unit
test suite.

I played around with the kernel version inside the guest and it doesn't see=
m to
make a difference - I could reproduce the issue with kernels 6.6.24-1
(linux-lts), 6.8.2.arch2-1 (linux), and 6.9.0-rc2-1-mainline (linux-mainlin=
e).

One example with the mainline kernel on the guest:
[   58.800435] (sh)[5787]: Found cgroup2 on /sys/fs/cgroup/, full unified
hierarchy
[   58.800578] (sh)[5787]: Found cgroup2 on /sys/fs/cgroup/, full unified
hierarchy
[   75.709475] kernel: watchdog: BUG: soft lockup - CPU#30 stuck for 16s!
[swapper/30:0]
[   75.728228] kernel: Modules linked in: dummy rpcsec_gss_krb5 auth_rpcgss
nfsv4 dns_resolver nfs lockd grace sunrpc netfs snd_seq_dummy snd_hrtimer
snd_seq snd_seq_device snd_timer snd soundcore intel_rapl_msr intel_rapl_co=
mmon
intel_uncore_frequency_common isst_if_common nfit libnvdimm 8021q garp mrp =
stp
llc cbc encrypted_keys trusted asn1_encoder tee vfat fat kvm_intel kvm
crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic gf128mul
ghash_clmulni_intel sha512_ssse3 sha1_ssse3 aesni_intel crypto_simd cryptd =
rapl
cfg80211 rfkill iTCO_wdt joydev intel_pmc_bxt mousedev iTCO_vendor_support
i2c_i801 psmouse i2c_smbus pcspkr lpc_ich mac_hid fuse loop dm_mod nfnetlink
vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport v=
sock
vmw_vmci qemu_fw_cfg ip_tables x_tables btrfs blake2b_generic libcrc32c
crc32c_generic xor raid6_pq serio_raw atkbd virtio_net libps2 net_failover
virtio_blk failover vivaldi_fmap virtio_balloon virtio_rng virtio_pci
crc32c_intel intel_agp sha256_ssse3 virtio_pci_legacy_dev i8042
[   75.796349] kernel:  xhci_pci intel_gtt virtio_pci_modern_dev
xhci_pci_renesas cirrus serio
[   75.796396] kernel: CPU: 30 PID: 0 Comm: swapper/30 Not tainted
6.9.0-rc2-1-mainline #1 4c361158dea5838a7441c4025165296045a48154
[   75.796413] kernel: Hardware name: Red Hat KVM/RHEL, BIOS
edk2-20240214-1.el9 02/14/2024
[   75.796414] kernel: RIP: 0010:pv_native_safe_halt+0xf/0x20
[   75.796421] kernel: Code: 22 d7 c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 9=
0 90
90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 23 db 24 00 fb f4 =
<c3>
cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90
[   75.796423] kernel: RSP: 0018:ffffa945c01b7ed8 EFLAGS: 00000246
[   75.796428] kernel: RAX: 000000000000001e RBX: ffff921dc0b33000 RCX:
ffff921de2bf2908
[   75.796431] kernel: RDX: 000000000000001e RSI: 000000000000001e RDI:
00000000001737f4
[   75.796433] kernel: RBP: 000000000000001e R08: 0000000000000001 R09:
0000000000000000
[   75.796434] kernel: R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000000
[   75.796436] kernel: R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[   75.796437] kernel: FS:  0000000000000000(0000) GS:ffff923cbe900000(0000)
knlGS:0000000000000000
[   75.796439] kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   75.796441] kernel: CR2: 00007f08c013e000 CR3: 000000186ac20002 CR4:
0000000000770ef0
[   75.796444] kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   75.796445] kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   75.796446] kernel: PKRU: 55555554
[   75.796447] kernel: Call Trace:
[   75.796450] kernel:  <IRQ>
[   75.800549] kernel:  ? watchdog_timer_fn+0x1dd/0x260
[   75.800553] kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
[   75.800556] kernel:  ? __hrtimer_run_queues+0x10f/0x2a0
[   75.800560] kernel:  ? hrtimer_interrupt+0xfa/0x230
[   75.800563] kernel:  ? __sysvec_apic_timer_interrupt+0x55/0x150
[   75.800567] kernel:  ? sysvec_apic_timer_interrupt+0x6c/0x90
[   75.800569] kernel:  </IRQ>
[   75.800569] kernel:  <TASK>
[   75.800571] kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   75.800590] kernel:  ? pv_native_safe_halt+0xf/0x20
[   75.800593] kernel:  default_idle+0x9/0x20
[   75.800596] kernel:  default_idle_call+0x30/0x100
[   75.800598] kernel:  do_idle+0x1cb/0x210
[   75.800603] kernel:  cpu_startup_entry+0x29/0x30
[   75.800606] kernel:  start_secondary+0x11c/0x140
[   75.800610] kernel:  common_startup_64+0x13e/0x141
[   75.800616] kernel:  </TASK>
[   75.800619] kernel: watchdog: BUG: soft lockup - CPU#59 stuck for 16s!
[swapper/59:0]
[   75.802944] kernel: Modules linked in: dummy rpcsec_gss_krb5 auth_rpcgss
nfsv4 dns_resolver nfs lockd grace sunrpc netfs snd_seq_dummy snd_hrtimer
snd_seq snd_seq_device snd_timer snd soundcore intel_rapl_msr intel_rapl_co=
mmon
intel_uncore_frequency_common isst_if_common nfit libnvdimm 8021q garp mrp =
stp
llc cbc encrypted_keys trusted asn1_encoder tee vfat fat kvm_intel kvm
crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic gf128mul
ghash_clmulni_intel sha512_ssse3 sha1_ssse3 aesni_intel crypto_simd cryptd =
rapl
cfg80211 rfkill iTCO_wdt joydev intel_pmc_bxt mousedev iTCO_vendor_support
i2c_i801 psmouse i2c_smbus pcspkr lpc_ich mac_hid fuse loop dm_mod nfnetlink
vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport v=
sock
vmw_vmci qemu_fw_cfg ip_tables x_tables btrfs blake2b_generic libcrc32c
crc32c_generic xor raid6_pq serio_raw atkbd virtio_net libps2 net_failover
virtio_blk failover vivaldi_fmap virtio_balloon virtio_rng virtio_pci
crc32c_intel intel_agp sha256_ssse3 virtio_pci_legacy_dev i8042
[   75.803034] kernel:  xhci_pci intel_gtt virtio_pci_modern_dev
xhci_pci_renesas cirrus serio
[   75.803043] kernel: CPU: 59 PID: 0 Comm: swapper/59 Tainted: G          =
   L
    6.9.0-rc2-1-mainline #1 4c361158dea5838a7441c4025165296045a48154
[   75.803048] kernel: Hardware name: Red Hat KVM/RHEL, BIOS
edk2-20240214-1.el9 02/14/2024
[   75.803050] kernel: RIP: 0010:pv_native_safe_halt+0xf/0x20
[   75.803057] kernel: Code: 22 d7 c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 9=
0 90
90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 23 db 24 00 fb f4 =
<c3>
cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90
[   75.803059] kernel: RSP: 0018:ffffa945c029fed8 EFLAGS: 00000252
[   75.803062] kernel: RAX: 000000000000003b RBX: ffff921dc0c78000 RCX:
ffff921e01edf5a8
[   75.803064] kernel: RDX: 000000000000003b RSI: 000000000000003b RDI:
0000000000121a9c
[   75.803065] kernel: RBP: 000000000000003b R08: 0000000000000001 R09:
0000000000000000
[   75.803067] kernel: R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000000
[   75.803069] kernel: R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[   75.803070] kernel: FS:  0000000000000000(0000) GS:ffff923cbf780000(0000)
knlGS:0000000000000000
[   75.803072] kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   75.803074] kernel: CR2: 00007f08c013e000 CR3: 000000186ac20005 CR4:
0000000000770ef0
[   75.803078] kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   75.803079] kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   75.803081] kernel: PKRU: 55555554
[   75.803082] kernel: Call Trace:
[   75.803085] kernel:  <IRQ>
[   75.803091] kernel:  ? watchdog_timer_fn+0x1dd/0x260
[   75.803096] kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
[   75.803098] kernel:  ? __hrtimer_run_queues+0x10f/0x2a0
[   75.803103] kernel:  ? hrtimer_interrupt+0xfa/0x230
[   75.803106] kernel:  ? __sysvec_apic_timer_interrupt+0x55/0x150
[   75.803111] kernel:  ? sysvec_apic_timer_interrupt+0x6c/0x90
[   75.803113] kernel:  </IRQ>
[   75.803114] kernel:  <TASK>
[   75.803116] kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   75.803122] kernel:  ? pv_native_safe_halt+0xf/0x20
[   75.803125] kernel:  default_idle+0x9/0x20
[   75.803129] kernel:  default_idle_call+0x30/0x100
[   75.803131] kernel:  do_idle+0x1cb/0x210
[   75.803137] kernel:  cpu_startup_entry+0x29/0x30
[   75.803139] kernel:  start_secondary+0x11c/0x140
[   75.803145] kernel:  common_startup_64+0x13e/0x141
[   75.803151] kernel:  </TASK>
...

The full stack trace is quite long, please see [2] which is a complete jour=
nal
from the machine boot.

I can reproduce the soft lockups quite reliably. However, I'm not really su=
re
who to blame here, since there's too many moving parts. But my first questi=
on
would be - is this an issue of the guest (Arch Linux) kernel, or is it/can =
it
be caused by the host kernel? I did some testing and if I use the _same_ im=
age
on the C8S hypervisor (with all three guest kernel variations), the issue
disappears, but I'm still not convinced that this might be the host kernel
doings. I'm more than happy to debug this further, but currently I have no =
idea
where to start, so any hint would be greatly appreciated.

[0] https://aws.amazon.com/ec2/instance-types/c5/
[1]
https://mrc0mmand.fedorapeople.org/kernel_kvm_softlockup/arch-mainline-cpui=
nfo.log
[2]
https://mrc0mmand.fedorapeople.org/kernel_kvm_softlockup/arch-mainline-jour=
nal.log

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

