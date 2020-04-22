Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5FC1B36EB
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 07:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDVFnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 01:43:11 -0400
Received: from chronos.abteam.si ([46.4.99.117]:40501 "EHLO chronos.abteam.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgDVFnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 01:43:10 -0400
X-Greylist: delayed 39165 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2020 01:43:06 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by chronos.abteam.si (Postfix) with ESMTP id 8A0805D00090
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 07:43:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bstnet.org; h=
        content-transfer-encoding:content-language:content-type
        :content-type:mime-version:user-agent:date:date:message-id
        :subject:subject:from:from; s=default; t=1587534185; x=
        1589348586; bh=MjNRBYyLcD7HIEQBXNwwZl5M8YIHgDpvCXsoChqY2Lk=; b=m
        oQpyfHXCbPHElwhoxfveoPlVS4hSgUvA8kJ+0PhJff2UdGq3H5bx3FtJTt+vPy5N
        y64CEe8mIXIGypVHN5mVpYBmC7uZlKZjCCYwX0fJo4/5smPiMjOZ/3lK16CQTe36
        Vdnjbk6U9oRC3WSRcV4Q9AJlnSqrH5CV/tmEV+VVAg=
Received: from chronos.abteam.si ([127.0.0.1])
        by localhost (chronos.abteam.si [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oqfuEEFTY8OU for <kvm@vger.kernel.org>;
        Wed, 22 Apr 2020 07:43:05 +0200 (CEST)
Received: from bst-slack.bstnet.org (unknown [IPv6:2a00:ee2:4d00:602:d782:18ef:83c9:31f5])
        (Authenticated sender: boris@abteam.si)
        by chronos.abteam.si (Postfix) with ESMTPSA id E21095D0008B
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 07:43:04 +0200 (CEST)
To:     kvm@vger.kernel.org
From:   "Boris V." <borisvk@bstnet.org>
Subject: KVM Kernel 5.6+, BUG: stack guard page was hit at
Message-ID: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
Date:   Wed, 22 Apr 2020 07:43:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

when running qemu with GPU passthrough it crashes with 5.6 and also=20
5.7-rc kernels, it works with 5.5 and lower.
Without GPU passthrough I don't see this crash.
With bisecting, I found commit that causes this BUG.
It seems bad commit is f458d039db7e8518041db4169d657407e3217008, if I=20
revert this patch it works.

CPU: Intel(R) Core(TM) i7-5930K CPU
kernel parameters: intel_iommu=3Don hugepagesz=3D1GB default_hugepagesz=3D=
1GB=20
hugepages=3D32

Module: kvm_intel
Parameter: dump_invalid_vmcs --> N
Parameter: emulate_invalid_guest_state --> Y
Parameter: enable_apicv --> Y
Parameter: enable_shadow_vmcs --> N
Parameter: ept --> Y
Parameter: eptad --> Y
Parameter: fasteoi --> Y
Parameter: flexpriority --> Y
Parameter: nested --> Y
Parameter: nested_early_check --> N
Parameter: ple_gap --> 128
Parameter: ple_window --> 4096
Parameter: ple_window_grow --> 2
Parameter: ple_window_max --> 4294967295
Parameter: ple_window_shrink --> 0
Parameter: pml --> N
Parameter: preemption_timer --> Y
Parameter: pt_mode --> 0
Parameter: unrestricted_guest --> Y
Parameter: vmentry_l1d_flush --> never
Parameter: vnmi --> Y
Parameter: vpid --> Y

Module: kvm
Parameter: enable_vmware_backdoor --> N
Parameter: force_emulation_prefix --> N
Parameter: halt_poll_ns --> 200000
Parameter: halt_poll_ns_grow --> 2
Parameter: halt_poll_ns_grow_start --> 10000
Parameter: halt_poll_ns_shrink --> 0
Parameter: ignore_msrs --> N
Parameter: kvmclock_periodic_sync --> Y
Parameter: lapic_timer_advance_ns --> -1
Parameter: min_timer_period_us --> 200
Parameter: mmu_audit --> N
Parameter: nx_huge_pages --> N
Parameter: nx_huge_pages_recovery_ratio --> 60
Parameter: pi_inject_timer --> 0
Parameter: report_ignored_msrs --> Y
Parameter: tsc_tolerance_ppm --> 250
Parameter: vector_hashing --> Y

$ qemu-system-x86_64 --version
QEMU emulator version 4.2.0
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers

This stack trace is from 5.7.0-rc2 kernel:

[=C2=A0 100.907346] BUG: stack guard page was hit at 000000008f595917 (st=
ack=20
is 00000000bdefe5a4..00000000ae2b06f5)
[=C2=A0 100.908167] kernel stack overflow (double-fault): 0000 [#1] SMP N=
OPTI
[=C2=A0 100.908990] CPU: 11 PID: 2258 Comm: qemu-system-x86 Tainted:=20
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 E=C2=A0=
=C2=A0=C2=A0=C2=A0 5.7.0-rc2 #1
[=C2=A0 100.909827] Hardware name: ASUS All Series/X99-DELUXE, BIOS 3802=20
09/05/2017
[=C2=A0 100.910683] RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
[=C2=A0 100.911516] Code: 48 8b 04 25 28 00 00 00 48 89 84 24 c8 00 00 00=
 31=20
c0 8b 05 d9 aa 08 00 85 c0 0f 8f b9 00 00 00 4c 8d a5 b8 9d 00 00 4c 89=20
e7 <e8> 5a 11 78 e0 89 da 48 89 ef 48 8d 74 24 08 41 89 c7 e8 68 fe ff
[=C2=A0 100.913290] RSP: 0018:ffff98bb81088000 EFLAGS: 00010246
[=C2=A0 100.914175] RAX: 0000000000000000 RBX: 0000000000000017 RCX:=20
0000000000000000
[=C2=A0 100.915084] RDX: 0000000000000017 RSI: 0000000000000001 RDI:=20
ffff98bb81062db8
[=C2=A0 100.915987] RBP: ffff98bb81059000 R08: 0000000000000000 R09:=20
ffff88fc50fc2900
[=C2=A0 100.916885] R10: 0000000000000000 R11: 0000000000000000 R12:=20
ffff98bb81062db8
[=C2=A0 100.917796] R13: 0000000000000001 R14: 0000000000000000 R15:=20
ffff88fc4062f800
[=C2=A0 100.918702] FS:=C2=A0 00007f224a3ff700(0000) GS:ffff88fc5fcc0000(=
0000)=20
knlGS:0000000000000000
[=C2=A0 100.919626] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[=C2=A0 100.920557] CR2: ffff98bb81087ff8 CR3: 0000000fb10aa004 CR4:=20
00000000001626e0
[=C2=A0 100.921512] Call Trace:
[=C2=A0 100.922476]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.923436]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.924388]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.925362]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.926338]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.927319]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.928293]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.929262]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.930225]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.931184]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.932147]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.933102]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.934051]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.935001]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.935945]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.936885]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.937833]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.938780]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.939718]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.940654]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.941588]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.942525]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.943457]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.944387]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.945325]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.946247]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.947138]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.948006]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.948860]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.949699]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.950531]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.951349]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.952141]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.952916]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.953680]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.954449]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.955219]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.955993]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.956783]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.957558]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.958319]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.959067]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.959805]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.960543]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.961284]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.962030]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.962770]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.963508]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.964245]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.964983]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.965721]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.966462]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.967207]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.967946]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.968684]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.969421]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.970160]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.970900]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.971641]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.972388]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.973129]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.973868]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.974606]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.975344]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.976084]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.976825]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.977572]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.978311]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.979050]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.979788]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.980526]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.981265]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.982006]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.982753]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.983492]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.984230]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.984968]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.985706]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.986445]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.987187]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.987934]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.988675]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.989414]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.990153]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.990892]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.991632]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.992374]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.993120]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.993860]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.994599]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 100.995337]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 100.996076]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 100.996816]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 100.997556]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 100.998302]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 100.999041]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 100.999779]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.000517]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.001256]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.001995]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.002737]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.003485]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.004225]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.004964]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.005702]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.006439]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.007178]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.007919]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.008665]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.009405]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.010143]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.010881]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.011619]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.012357]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.013098]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.013845]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.014585]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.015323]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.016061]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.016800]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.017539]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.018280]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.019026]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.019766]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.020504]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.021241]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.021979]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.022717]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.023458]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.024204]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.024943]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.025682]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.026420]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.027159]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.027898]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.028640]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.029388]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.030129]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.030869]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.031608]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.032346]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.033085]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.033826]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.034573]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.035312]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.036051]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.036790]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.037529]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.038268]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.039009]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.039757]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.040497]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.041236]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.041974]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.042713]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.043452]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.044194]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.044941]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.045681]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.046420]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.047158]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.047897]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.048636]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.049377]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.050124]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.050864]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.051603]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.052342]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.053080]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.053820]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.054561]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.055307]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.056048]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.056786]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.057524]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.058262]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.059001]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.059742]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.060488]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.061228]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.061966]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.062703]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.063442]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.064180]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.064921]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.065668]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.066407]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.067145]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.067883]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.068621]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.069360]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.070101]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.070847]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.071587]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.072325]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.073063]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.073797]=C2=A0 ? update_group_capacity+0x25/0x190
[=C2=A0 101.074534]=C2=A0 ? gfn_to_hva_memslot_prot+0x16/0x40 [kvm]
[=C2=A0 101.075274]=C2=A0 ? vmx_get_cpl+0x19/0x30 [kvm_intel]
[=C2=A0 101.076012]=C2=A0 ? paging64_walk_addr_generic+0x55b/0x9a0 [kvm]
[=C2=A0 101.076750]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.077489]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.078233]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.078986]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.079738]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.080486]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.081229]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.081963]=C2=A0 ? update_load_avg+0x76/0x630
[=C2=A0 101.082688]=C2=A0 ? newidle_balance+0x21f/0x3d0
[=C2=A0 101.083412]=C2=A0 ? dequeue_entity+0xc6/0x220
[=C2=A0 101.084139]=C2=A0 irqfd_resampler_ack+0x32/0x90 [kvm]
[=C2=A0 101.084870]=C2=A0 kvm_notify_acked_irq+0x62/0xd0 [kvm]
[=C2=A0 101.085604]=C2=A0 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kv=
m]
[=C2=A0 101.086342]=C2=A0 ioapic_set_irq+0x20e/0x240 [kvm]
[=C2=A0 101.087074]=C2=A0 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
[=C2=A0 101.087804]=C2=A0 kvm_set_irq+0xbb/0x160 [kvm]
[=C2=A0 101.088534]=C2=A0 ? kvm_hv_set_sint+0x20/0x20 [kvm]
[=C2=A0 101.089264]=C2=A0 kvm_vm_ioctl_irq_line+0x23/0x30 [kvm]
[=C2=A0 101.089998]=C2=A0 kvm_vm_ioctl+0x163/0xcf0 [kvm]
[=C2=A0 101.090720]=C2=A0 ? kvm_vcpu_ioctl+0x2b3/0x5c0 [kvm]
[=C2=A0 101.091437]=C2=A0 ksys_ioctl+0x82/0xc0
[=C2=A0 101.092141]=C2=A0 __x64_sys_ioctl+0x16/0x20
[=C2=A0 101.092843]=C2=A0 do_syscall_64+0x48/0x140
[=C2=A0 101.093546]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
[=C2=A0 101.094255] RIP: 0033:0x7f225211a4b7
[=C2=A0 101.094959] Code: 00 00 90 48 8b 05 d9 29 0d 00 64 c7 00 26 00 00=
 00=20
48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f=20
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a9 29 0d 00 f7 d8 64 89 01 48
[=C2=A0 101.096482] RSP: 002b:00007f224a3fe258 EFLAGS: 00000246 ORIG_RAX:=
=20
0000000000000010
[=C2=A0 101.097257] RAX: ffffffffffffffda RBX: 00000000c008ae67 RCX:=20
00007f225211a4b7
[=C2=A0 101.098041] RDX: 00007f224a3fe2f0 RSI: ffffffffc008ae67 RDI:=20
0000000000000012
[=C2=A0 101.098830] RBP: 00007f224d48ac00 R08: 00005622815dac50 R09:=20
00000007e428381c
[=C2=A0 101.099620] R10: 00007f224d5d2200 R11: 0000000000000246 R12:=20
00007f224a3fe2f0
[=C2=A0 101.100409] R13: 00007f22454abe18 R14: 0000000000000000 R15:=20
0000000000000003
[=C2=A0 101.101196] Modules linked in: cmac(E) nls_utf8(E) cifs(E) fscach=
e(E)=20
cfg80211(E) 8021q(E) garp(E) mrp(E) bridge(E) stp(E) llc(E) i2c_dev(E)=20
vhost_net(E) tun(E) vhost(E) tap(E) vhost_iotlb(E) mlx4_ib(E)=20
ib_uverbs(E) ib_core(E) ipv6(E) nf_defrag_ipv6(E) mlx4_en(E)=20
intel_rapl_msr(E) coretemp(E) intel_rapl_common(E)=20
x86_pkg_temp_thermal(E) intel_powerclamp(E) kvm_intel(E) kvm(E)=20
snd_hda_codec_realtek(E) crct10dif_pclmul(E) snd_hda_codec_generic(E)=20
crc32_pclmul(E) ledtrig_audio(E) snd_hda_codec_hdmi(E)=20
ghash_clmulni_intel(E) snd_hda_intel(E) intel_cstate(E)=20
snd_intel_dspcfg(E) snd_hda_codec(E) intel_rapl_perf(E) snd_hda_core(E)=20
eeepc_wmi(E) wmi_bmof(E) intel_wmi_thunderbolt(E) snd_hwdep(E)=20
snd_pcm(E) joydev(E) uas(E) evdev(E) igb(E) snd_timer(E) nvme(E) dca(E)=20
mei_me(E) snd(E) mxm_wmi(E) i2c_i801(E) i2c_algo_bit(E) nvme_core(E)=20
e1000e(E) soundcore(E) mlx4_core(E) mei(E) lpc_ich(E) button(E) loop(E)=20
nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) algif_skcipher(E) af_alg(E)=20
ext4(E) mbc
[=C2=A0 101.101219]=C2=A0 jbd2(E) hid_multitouch(E) hid_microsoft(E) hid_=
lenovo(E)=20
hid_logitech_hidpp(E) hid_logitech_dj(E) hid_logitech(E) hid_cherry(E)=20
hid_asus(E) asus_wmi(E) battery(E) sparse_keymap(E) rfkill(E) wmi(E)=20
video(E) hwmon(E) hid_generic(E) i2c_hid(E) i2c_core(E) usbhid(E) hid(E)=20
uhci_hcd(E) ohci_pci(E) ehci_pci(E) ohci_hcd(E) ehci_hcd(E) xhci_pci(E)=20
xhci_hcd(E) usb_storage(E) ahci(E) libahci(E) vfio_pci(E) irqbypass(E)=20
vfio_virqfd(E) vfio_iommu_type1(E) vfio(E)
[=C2=A0 101.113244] ---[ end trace 4643b8cc729d78f1 ]---
[=C2=A0 101.114409] RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
[=C2=A0 101.115567] Code: 48 8b 04 25 28 00 00 00 48 89 84 24 c8 00 00 00=
 31=20
c0 8b 05 d9 aa 08 00 85 c0 0f 8f b9 00 00 00 4c 8d a5 b8 9d 00 00 4c 89=20
e7 <e8> 5a 11 78 e0 89 da 48 89 ef 48 8d 74 24 08 41 89 c7 e8 68 fe ff
[=C2=A0 101.118002] RSP: 0018:ffff98bb81088000 EFLAGS: 00010246
[=C2=A0 101.119231] RAX: 0000000000000000 RBX: 0000000000000017 RCX:=20
0000000000000000
[=C2=A0 101.120480] RDX: 0000000000000017 RSI: 0000000000000001 RDI:=20
ffff98bb81062db8
[=C2=A0 101.121730] RBP: ffff98bb81059000 R08: 0000000000000000 R09:=20
ffff88fc50fc2900
[=C2=A0 101.122978] R10: 0000000000000000 R11: 0000000000000000 R12:=20
ffff98bb81062db8
[=C2=A0 101.124225] R13: 0000000000000001 R14: 0000000000000000 R15:=20
ffff88fc4062f800
[=C2=A0 101.125461] FS:=C2=A0 00007f224a3ff700(0000) GS:ffff88fc5fcc0000(=
0000)=20
knlGS:0000000000000000
[=C2=A0 101.126710] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[=C2=A0 101.127960] CR2: ffff98bb81087ff8 CR3: 0000000fb10aa004 CR4:=20
00000000001626e0
[=C2=A0 101.129253] ------------[ cut here ]------------
[=C2=A0 101.130532] WARNING: CPU: 11 PID: 0 at kernel/rcu/tree.c:569=20
rcu_idle_enter+0x9f/0xb0
[=C2=A0 101.130533] Modules linked in: cmac(E) nls_utf8(E) cifs(E) fscach=
e(E)=20
cfg80211(E) 8021q(E) garp(E) mrp(E) bridge(E) stp(E) llc(E) i2c_dev(E)=20
vhost_net(E) tun(E) vhost(E) tap(E) vhost_iotlb(E) mlx4_ib(E)=20
ib_uverbs(E) ib_core(E) ipv6(E) nf_defrag_ipv6(E) mlx4_en(E)=20
intel_rapl_msr(E) coretemp(E) intel_rapl_common(E)=20
x86_pkg_temp_thermal(E) intel_powerclamp(E) kvm_intel(E) kvm(E)=20
snd_hda_codec_realtek(E) crct10dif_pclmul(E) snd_hda_codec_generic(E)=20
crc32_pclmul(E) ledtrig_audio(E) snd_hda_codec_hdmi(E)=20
ghash_clmulni_intel(E) snd_hda_intel(E) intel_cstate(E)=20
snd_intel_dspcfg(E) snd_hda_codec(E) intel_rapl_perf(E) snd_hda_core(E)=20
eeepc_wmi(E) wmi_bmof(E) intel_wmi_thunderbolt(E) snd_hwdep(E)=20
snd_pcm(E) joydev(E) uas(E) evdev(E) igb(E) snd_timer(E) nvme(E) dca(E)=20
mei_me(E) snd(E) mxm_wmi(E) i2c_i801(E) i2c_algo_bit(E) nvme_core(E)=20
e1000e(E) soundcore(E) mlx4_core(E) mei(E) lpc_ich(E) button(E) loop(E)=20
nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) algif_skcipher(E) af_alg(E)=20
ext4(E) mbc
[=C2=A0 101.130575]=C2=A0 jbd2(E) hid_multitouch(E) hid_microsoft(E) hid_=
lenovo(E)=20
hid_logitech_hidpp(E) hid_logitech_dj(E) hid_logitech(E) hid_cherry(E)=20
hid_asus(E) asus_wmi(E) battery(E) sparse_keymap(E) rfkill(E) wmi(E)=20
video(E) hwmon(E) hid_generic(E) i2c_hid(E) i2c_core(E) usbhid(E) hid(E)=20
uhci_hcd(E) ohci_pci(E) ehci_pci(E) ohci_hcd(E) ehci_hcd(E) xhci_pci(E)=20
xhci_hcd(E) usb_storage(E) ahci(E) libahci(E) vfio_pci(E) irqbypass(E)=20
vfio_virqfd(E) vfio_iommu_type1(E) vfio(E)
[=C2=A0 101.143511] CPU: 11 PID: 0 Comm: swapper/11 Tainted: G=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 D E=C2=A0=C2=A0=C2=A0=C2=A0=20
5.7.0-rc2 #1
[=C2=A0 101.143511] Hardware name: ASUS All Series/X99-DELUXE, BIOS 3802=20
09/05/2017
[=C2=A0 101.143518] RIP: 0010:rcu_idle_enter+0x9f/0xb0
[=C2=A0 101.143519] Code: c8 00 00 00 00 00 00 00 65 48 03 1d a3 fd ec 5e=
 b8=20
02 00 00 00 f0 0f c1 83 d8 00 00 00 5b 5d c3 48 89 ef e8 f3 db ff ff eb=20
ce <0f> 0b eb 89 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00
[=C2=A0 101.143520] RSP: 0018:ffff98bb8011bec0 EFLAGS: 00010002
[=C2=A0 101.143522] RAX: ffff88fc5fce9f00 RBX: 0000000000029f00 RCX:=20
0000000000000000
[=C2=A0 101.143523] RDX: 4000000000000000 RSI: 0000000000000087 RDI:=20
000000000000000b
[=C2=A0 101.143523] RBP: ffff88fc58cf44c0 R08: ffff88fc5fcdcfc0 R09:=20
0000000000000071
[=C2=A0 101.143523] R10: ffff88fc5fce8424 R11: ffff88fc5fce8404 R12:=20
ffff88fc58cf44c0
[=C2=A0 101.143524] R13: ffffffffa22cc220 R14: ffffb8bb7f8d2100 R15:=20
ffff88fc58cf44c0
[=C2=A0 101.143525] FS:=C2=A0 0000000000000000(0000) GS:ffff88fc5fcc0000(=
0000)=20
knlGS:0000000000000000
[=C2=A0 101.143525] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[=C2=A0 101.143525] CR2: ffff98bb81087ff8 CR3: 0000000fb10aa004 CR4:=20
00000000001626e0
[=C2=A0 101.143526] Call Trace:
[=C2=A0 101.143529]=C2=A0 do_idle+0x1cb/0x260
[=C2=A0 101.143531]=C2=A0 cpu_startup_entry+0x19/0x20
[=C2=A0 101.143537]=C2=A0 start_secondary+0x148/0x170
[=C2=A0 101.143538]=C2=A0 secondary_startup_64+0xa4/0xb0
[=C2=A0 101.143539] ---[ end trace 4643b8cc729d78f2 ]---

