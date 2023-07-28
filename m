Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CF47660A7
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 02:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjG1ARK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 20:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjG1ARH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 20:17:07 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AFD30C0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 17:16:59 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qPBA3-004rtv-J8; Fri, 28 Jul 2023 02:16:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
        :Cc:To:From; bh=S84RjooGHgGEPbO8aU2+W6gLhFNF2PNxB0JqNqZuOQ8=; b=qYEI873IPrKvF
        x4rP9sdZy26kmD4NcpJvO5KWl4lT6in5X3UF9mWhbpIluotTtVQBESzVnVk+nRNAe+x1dgdv2vas+
        +lgBfRD4Pjezfwse8gPlDSVxnRnQX7bnAITTqsGay3dDzVIhm5Z8YrBqIBlbLNlZx9CvgnnfJtBSB
        x+w/Q2vUlXQzv5MYOmGLZbLc5aMnAW4uUzKcryJmIld9+eLygK6DGl+AT6JvKZX/sBBpFpjMWK6rH
        NZhvtaBul+IU5Hunq1j7Qy1SWz11cWE9nVY46gksIaNQ2fGeS3sIxaegGUm7u5a1Dw1eSEJSQ0eJz
        owpI0xhiRiPtRzUHDLt5w==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qPBA3-000381-AK; Fri, 28 Jul 2023 02:16:51 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qPB9y-0000WA-1P; Fri, 28 Jul 2023 02:16:46 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/2] sync_regs() TOCTOU issues
Date:   Fri, 28 Jul 2023 02:12:56 +0200
Message-ID: <20230728001606.2275586-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() assume they
have exclusive rights to structs they operate on. While this is true when
coming from an ioctl handler (caller makes a local copy of user's data),
sync_regs() breaks this contract; a pointer to a user-modifiable memory
(vcpu->run->s.regs) is provided. This can lead to a situation when incoming
data is checked and/or sanitized only to be re-set by a user thread running
in parallel. 

Selftest racing kvm_vcpu_ioctl_x86_set_vcpu_events() results in hitting
some WARN_ON()s. With [1] applied, racing __set_sregs() ends with
KVM_BUG_ON() during ioctl(KVM_TRANSLATE).

[1] KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled
    https://lore.kernel.org/kvm/20230721230006.2337941-6-seanjc@google.com/

Selftest-induced splats:

arch/x86/kvm/x86.c:kvm_check_and_inject_events():
	WARN_ON_ONCE(vcpu->arch.exception.injected &&
		     vcpu->arch.exception.pending)

[  188.598039] WARNING: CPU: 4 PID: 969 at arch/x86/kvm/x86.c:10095 kvm_check_and_inject_events+0x220/0x500 [kvm]
[  188.598141] Modules linked in: 9p fscache netfs qrtr sunrpc intel_rapl_msr intel_rapl_common kvm_intel kvm 9pnet_virtio pcspkr 9pnet rapl i2c_piix4 drm zram crct10dif_pclmul crc32_pclmul crc32c_intel virtio_console serio_raw virtio_blk ghash_clmulni_intel ata_generic pata_acpi fuse qemu_fw_cfg
[  188.598194] CPU: 4 PID: 969 Comm: sync_regs_test Tainted: G        W          6.5.0-rc3+ #50
[  188.598199] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[  188.598202] RIP: 0010:kvm_check_and_inject_events+0x220/0x500 [kvm]
[  188.598274] Code: 0d 80 bb b0 08 00 00 00 0f 84 49 02 00 00 85 c0 0f 89 db fe ff ff 83 f8 f0 0f 84 b9 fe ff ff 48 83 c4 08 5b 5d 41 5c 41 5d c3 <0f> 0b 85 c0 78 e6 66 83 bb b0 08 00 00 00 0f 85 b2 01 00 00 0f b6
[  188.598278] RSP: 0018:ffffc9000173fcb0 EFLAGS: 00010202
[  188.598284] RAX: 0000000000000000 RBX: ffff888122588000 RCX: 0000000000000000
[  188.598287] RDX: 0000000000000000 RSI: 0000000080000300 RDI: ffff888122588000
[  188.598290] RBP: ffffc9000173fd40 R08: 0000000000000001 R09: ffff888107adc000
[  188.598293] R10: ffffc9000173fd58 R11: 0000000000000001 R12: ffffc9000173fcef
[  188.598296] R13: 0000000000000000 R14: ffff888108988000 R15: ffff888122588000
[  188.598299] FS:  00007fdb3d656740(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
[  188.598303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  188.598306] CR2: 0000000000000000 CR3: 000000011e617000 CR4: 0000000000752ee0
[  188.598316] PKRU: 55555554
[  188.598319] Call Trace:
[  188.598322]  <TASK>
[  188.598325]  ? kvm_check_and_inject_events+0x220/0x500 [kvm]
[  188.598389]  ? __warn+0x81/0x170
[  188.598397]  ? kvm_check_and_inject_events+0x220/0x500 [kvm]
[  188.598458]  ? report_bug+0x189/0x1c0
[  188.598466]  ? handle_bug+0x38/0x70
[  188.598472]  ? exc_invalid_op+0x13/0x60
[  188.598515]  ? asm_exc_invalid_op+0x16/0x20
[  188.598529]  ? kvm_check_and_inject_events+0x220/0x500 [kvm]
[  188.598592]  vcpu_run+0x5aa/0x1660 [kvm]
[  188.598658]  ? skip_emulated_instruction+0xa3/0x190 [kvm_intel]
[  188.598674]  ? complete_emulator_pio_in+0xab/0xc0 [kvm]
[  188.598740]  ? kvm_arch_vcpu_ioctl_run+0x1e4/0x740 [kvm]
[  188.598801]  kvm_arch_vcpu_ioctl_run+0x1e4/0x740 [kvm]
[  188.598862]  kvm_vcpu_ioctl+0x19d/0x680 [kvm]
[  188.598916]  ? lock_release+0x132/0x260
[  188.598927]  __x64_sys_ioctl+0x8c/0xc0
[  188.598935]  do_syscall_64+0x56/0x80
[  188.598939]  ? lockdep_hardirqs_on+0x7d/0x100
[  188.598944]  ? do_syscall_64+0x62/0x80
[  188.598948]  ? do_syscall_64+0x62/0x80
[  188.598952]  ? lockdep_hardirqs_on+0x7d/0x100
[  188.598956]  ? do_syscall_64+0x62/0x80
[  188.598960]  ? do_syscall_64+0x62/0x80
[  188.598964]  ? lockdep_hardirqs_on+0x7d/0x100
[  188.598968]  ? do_syscall_64+0x62/0x80
[  188.598974]  ? asm_exc_page_fault+0x22/0x30
[  188.598980]  ? lockdep_hardirqs_on+0x7d/0x100
[  188.598984]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  188.598991] RIP: 0033:0x7fdb3d759d6f
[  188.598995] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  188.598999] RSP: 002b:00007ffe0c2f3b70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  188.599004] RAX: ffffffffffffffda RBX: 0000000064c2f1b3 RCX: 00007fdb3d759d6f
[  188.599007] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
[  188.599010] RBP: 0000000000e1b2a0 R08: 0000000000417718 R09: 00000000004176e0
[  188.599012] R10: 00007ffe0c3ac258 R11: 0000000000000246 R12: 0000000000418be5
[  188.599015] R13: 0000000000e1b2a0 R14: 00007fdb3d842130 R15: 00007fdb3d87c000
[  188.599027]  </TASK>
[  188.599030] irq event stamp: 33643
[  188.599032] hardirqs last  enabled at (33649): [<ffffffff8118c45e>] __up_console_sem+0x5e/0x70
[  188.599039] hardirqs last disabled at (33654): [<ffffffff8118c443>] __up_console_sem+0x43/0x70
[  188.599043] softirqs last  enabled at (33446): [<ffffffff810f903d>] __irq_exit_rcu+0x9d/0x110
[  188.599050] softirqs last disabled at (33439): [<ffffffff810f903d>] __irq_exit_rcu+0x9d/0x110

arch/x86/kvm/x86.c:exception_type():
	WARN_ON(vector > 31 || vector == NMI_VECTOR)

[   47.224496] WARNING: CPU: 7 PID: 958 at arch/x86/kvm/x86.c:547 kvm_check_and_inject_events+0x4a0/0x500 [kvm]
[   47.224516] Modules linked in: 9p fscache netfs qrtr sunrpc intel_rapl_msr intel_rapl_common kvm_intel kvm 9pnet_virtio pcspkr 9pnet rapl i2c_piix4 drm zram crct10dif_pclmul crc32_pclmul crc32c_intel virtio_console serio_raw virtio_blk ghash_clmulni_intel ata_generic pata_acpi fuse qemu_fw_cfg
[   47.224532] CPU: 7 PID: 958 Comm: sync_regs_test Tainted: G        W          6.5.0-rc3+ #50
[   47.224534] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[   47.224534] RIP: 0010:kvm_check_and_inject_events+0x4a0/0x500 [kvm]
[   47.224553] Code: 31 ed c6 83 28 0b 00 00 01 e8 bc cd 0f 00 be 01 00 00 00 48 89 df e8 6f 68 10 00 85 c0 0f 89 0e fc ff ff 0f 0b e9 07 fc ff ff <0f> 0b e9 0e fe ff ff 0f 0b f6 43 42 10 0f 84 b9 fb ff ff 31 c0 e9
[   47.224554] RSP: 0018:ffffc90001573cc0 EFLAGS: 00010202
[   47.224556] RAX: 0000000000000001 RBX: ffff88810b768000 RCX: 00000000000000ff
[   47.224557] RDX: 0000000000000001 RSI: ffffc90001573cff RDI: ffff88810b768000
[   47.224557] RBP: 0000000000000001 R08: 00000000000005a4 R09: 0000000000000000
[   47.224558] R10: ffffc90001573d68 R11: 0000000000000001 R12: ffffc90001573cff
[   47.224559] R13: 0000000000000000 R14: ffff888110f73380 R15: ffff88810b768000
[   47.224560] FS:  00007f8fc0f80740(0000) GS:ffff88842fd80000(0000) knlGS:0000000000000000
[   47.224561] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.224562] CR2: 0000000000000000 CR3: 0000000151e24000 CR4: 0000000000752ee0
[   47.224564] PKRU: 55555554
[   47.224565] Call Trace:
[   47.224566]  <TASK>
[   47.224566]  ? kvm_check_and_inject_events+0x4a0/0x500 [kvm]
[   47.224585]  ? __warn+0x81/0x170
[   47.224587]  ? kvm_check_and_inject_events+0x4a0/0x500 [kvm]
[   47.224606]  ? report_bug+0x189/0x1c0
[   47.224608]  ? handle_bug+0x38/0x70
[   47.224610]  ? exc_invalid_op+0x13/0x60
[   47.224612]  ? asm_exc_invalid_op+0x16/0x20
[   47.224617]  ? kvm_check_and_inject_events+0x4a0/0x500 [kvm]
[   47.224636]  vcpu_run+0x5aa/0x1660 [kvm]
[   47.224656]  ? lock_acquire+0xd4/0x290
[   47.224658]  ? lockdep_hardirqs_on+0x7d/0x100
[   47.224660]  ? kvm_arch_vcpu_ioctl_run+0x1e4/0x740 [kvm]
[   47.224680]  kvm_arch_vcpu_ioctl_run+0x1e4/0x740 [kvm]
[   47.224700]  kvm_vcpu_ioctl+0x19d/0x680 [kvm]
[   47.224718]  ? lock_release+0x132/0x260
[   47.224722]  __x64_sys_ioctl+0x8c/0xc0
[   47.224724]  do_syscall_64+0x56/0x80
[   47.224726]  ? do_syscall_64+0x62/0x80
[   47.224728]  ? lockdep_hardirqs_on+0x7d/0x100
[   47.224729]  ? do_syscall_64+0x62/0x80
[   47.224730]  ? do_syscall_64+0x62/0x80
[   47.224732]  ? do_syscall_64+0x62/0x80
[   47.224733]  ? lockdep_hardirqs_on+0x7d/0x100
[   47.224734]  ? do_syscall_64+0x62/0x80
[   47.224735]  ? do_syscall_64+0x62/0x80
[   47.224737]  ? lockdep_hardirqs_on+0x7d/0x100
[   47.224738]  ? do_syscall_64+0x62/0x80
[   47.224739]  ? do_syscall_64+0x62/0x80
[   47.224741]  ? do_syscall_64+0x62/0x80
[   47.224742]  ? lockdep_hardirqs_on+0x7d/0x100
[   47.224744]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   47.224746] RIP: 0033:0x7f8fc1083d6f
[   47.224747] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[   47.224748] RSP: 002b:00007ffe2e0a0ed0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   47.224749] RAX: ffffffffffffffda RBX: 0000000064c2f125 RCX: 00007f8fc1083d6f
[   47.224750] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
[   47.224751] RBP: 00000000015dc2a0 R08: 0000000000417718 R09: 00000000004176e0
[   47.224752] R10: 00007ffe2e0d1258 R11: 0000000000000246 R12: 0000000000418be5
[   47.224753] R13: 00000000015dc2a0 R14: 00007f8fc116c130 R15: 00007f8fc11a6000
[   47.224757]  </TASK>
[   47.224758] irq event stamp: 1494439
[   47.224759] hardirqs last  enabled at (1494445): [<ffffffff8118c45e>] __up_console_sem+0x5e/0x70
[   47.224760] hardirqs last disabled at (1494450): [<ffffffff8118c443>] __up_console_sem+0x43/0x70
[   47.224762] softirqs last  enabled at (1493904): [<ffffffff8103894d>] fpu_swap_kvm_fpstate+0x6d/0x120
[   47.224763] softirqs last disabled at (1493902): [<ffffffff810388e5>] fpu_swap_kvm_fpstate+0x5/0x120

arch/x86/kvm/mmu/paging_tmpl.h:
	KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm)

[   79.615678] WARNING: CPU: 1 PID: 944 at arch/x86/kvm/mmu/paging_tmpl.h:358 paging32_walk_addr_generic+0x431/0x8f0 [kvm]
[   79.615774] Modules linked in: 9p fscache netfs qrtr sunrpc intel_rapl_msr intel_rapl_common kvm_intel kvm 9pnet_virtio rapl 9pnet pcspkr i2c_piix4 drm zram crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel virtio_console virtio_blk serio_raw ata_generic pata_acpi fuse qemu_fw_cfg
[   79.615817] CPU: 1 PID: 944 Comm: sync_regs_test Not tainted 6.5.0-rc3+ #51
[   79.615821] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[   79.615824] RIP: 0010:paging32_walk_addr_generic+0x431/0x8f0 [kvm]
[   79.615899] Code: e9 09 fd ff ff 41 f6 86 70 02 00 00 20 0f 85 7d fc ff ff 4d 89 f5 4c 8b 1c 24 45 89 e6 49 8b 7d 00 80 bf 01 a2 00 00 00 75 1e <0f> 0b 41 b8 01 01 00 00 be 01 03 00 00 66 44 89 87 01 a2 00 00 e8
[   79.615903] RSP: 0018:ffffc9000161bcc0 EFLAGS: 00010246
[   79.615910] RAX: 0000000000000004 RBX: ffffc9000161bd48 RCX: 0000000000000000
[   79.615915] RDX: 0000000000000013 RSI: 000000000000000f RDI: ffffc9000166d000
[   79.615919] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000180000
[   79.615923] R10: 0000000000000001 R11: ffff888110770338 R12: 0000000000000000
[   79.615926] R13: ffff888110770000 R14: 0000000000000000 R15: ffff888110770628
[   79.615928] FS:  00007fde4879d740(0000) GS:ffff88842fa80000(0000) knlGS:0000000000000000
[   79.615932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.615934] CR2: 0000000000000000 CR3: 0000000158e67000 CR4: 0000000000752ee0
[   79.615940] PKRU: 55555554
[   79.615942] Call Trace:
[   79.615945]  <TASK>
[   79.615948]  ? paging32_walk_addr_generic+0x431/0x8f0 [kvm]
[   79.616009]  ? __warn+0x81/0x170
[   79.616016]  ? paging32_walk_addr_generic+0x431/0x8f0 [kvm]
[   79.616076]  ? report_bug+0x189/0x1c0
[   79.616083]  ? handle_bug+0x38/0x70
[   79.616088]  ? exc_invalid_op+0x13/0x60
[   79.616093]  ? asm_exc_invalid_op+0x16/0x20
[   79.616105]  ? paging32_walk_addr_generic+0x431/0x8f0 [kvm]
[   79.616168]  ? lock_acquire+0xd4/0x290
[   79.616174]  paging32_gva_to_gpa+0x28/0x80 [kvm]
[   79.616235]  ? lock_acquire+0xd4/0x290
[   79.616240]  ? vmx_vcpu_load+0x27/0x40 [kvm_intel]
[   79.616257]  kvm_arch_vcpu_ioctl_translate+0x79/0xf0 [kvm]
[   79.616317]  ? kvm_arch_vcpu_ioctl_translate+0x5/0xf0 [kvm]
[   79.616374]  kvm_vcpu_ioctl+0x4f0/0x680 [kvm]
[   79.616469]  ? lock_release+0x132/0x260
[   79.616479]  __x64_sys_ioctl+0x8c/0xc0
[   79.616486]  do_syscall_64+0x56/0x80
[   79.616491]  ? do_syscall_64+0x62/0x80
[   79.616495]  ? do_syscall_64+0x62/0x80
[   79.616498]  ? lockdep_hardirqs_on+0x7d/0x100
[   79.616502]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   79.616507] RIP: 0033:0x7fde488a0d6f
[   79.616512] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[   79.616514] RSP: 002b:00007fffc022e7d0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   79.616519] RAX: ffffffffffffffda RBX: 0000000064c2f333 RCX: 00007fde488a0d6f
[   79.616522] RDX: 00007fffc022e850 RSI: 00000000c018ae85 RDI: 0000000000000005
[   79.616524] RBP: 00000000c018ae85 R08: 0000000000417718 R09: 00000000004176e0
[   79.616526] R10: 00007fffc03a5258 R11: 0000000000000246 R12: 0000000000418be5
[   79.616529] R13: 00000000021062a0 R14: 00007fde48989130 R15: 00007fde489c3000
[   79.616540]  </TASK>
[   79.616542] irq event stamp: 34521
[   79.616544] hardirqs last  enabled at (34527): [<ffffffff8118c45e>] __up_console_sem+0x5e/0x70
[   79.616574] hardirqs last disabled at (34532): [<ffffffff8118c443>] __up_console_sem+0x43/0x70
[   79.616577] softirqs last  enabled at (34418): [<ffffffff810f903d>] __irq_exit_rcu+0x9d/0x110
[   79.616582] softirqs last disabled at (34411): [<ffffffff810f903d>] __irq_exit_rcu+0x9d/0x110

Michal Luczaj (2):
  KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
  KVM: selftests: Extend x86's sync_regs_test to check for races

 arch/x86/kvm/x86.c                            |  13 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     | 124 ++++++++++++++++++
 2 files changed, 134 insertions(+), 3 deletions(-)

-- 
2.41.0

