Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94675F547E
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJEMbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJEMbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:31:41 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683DE303D7
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:31:39 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1og3Ym-00Ged7-Bi; Wed, 05 Oct 2022 14:31:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=yKvOA+ympkx7SPIUCblghTAvJk67XTiD8cZvWT2JeLM=; b=cZDMgzGcym6r6jLZhmHqaNdpGL
        /9/p6D6ngXSmXBTeWjz5ntoqGiixregYbysx7jk7t1eRNGtdIyHv5TwSvuT3NqnG6IjbmWEwp+PXZ
        yYyW25PPyOTWKVoPIXe0GESbNGIoSgzx87d4lwKgp4jiR3u96qZUcF3xgCLKtV8jxJlIXUHLEVVj/
        5ya6j4SSaJZsh1JgBsmPjxmov8WydlJB/6HSClfYwx8yKMiilakGLZZsBQw7ItU/dXaSic9kocyHR
        2qdSWR5UHA/e4oIAF7jHQ1NIaIIcyuLjSX6o1dZBc6GWsv3PoEyItccI9cgQHPPjAWwgMITqdfoK2
        ENvyGKOg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yl-0005zE-N9; Wed, 05 Oct 2022 14:31:35 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1og3YR-0007vp-VL; Wed, 05 Oct 2022 14:31:16 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 8/8] KVM: x86: Fix NULL pointer dereference in kvm_xen_set_evtchn_fast()
Date:   Wed,  5 Oct 2022 14:30:51 +0200
Message-Id: <20221005123051.895056-9-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221005123051.895056-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20221005123051.895056-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's a race between kvm_xen_set_evtchn_fast() and kvm_gpc_activate()
resulting in a near-NULL pointer write.

1. Deactivate shinfo cache:

kvm_xen_hvm_set_attr
case KVM_XEN_ATTR_TYPE_SHARED_INFO
 kvm_gpc_deactivate
  kvm_gpc_unmap
   gpc->valid = false
   gpc->khva = NULL
  gpc->active = false

Result: active = false, valid = false

2. Cause cache refresh:

kvm_arch_vm_ioctl
case KVM_XEN_HVM_EVTCHN_SEND
 kvm_xen_hvm_evtchn_send
  kvm_xen_set_evtchn
   kvm_xen_set_evtchn_fast
    kvm_gpc_check
    return -EWOULDBLOCK because !gpc->valid
   kvm_xen_set_evtchn_fast
    return -EWOULDBLOCK
   kvm_gpc_refresh
    hva_to_pfn_retry
     gpc->valid = true
     gpc->khva = ~0

Result: active = false, valid = true

3. Race ioctl KVM_XEN_HVM_EVTCHN_SEND against ioctl
KVM_XEN_ATTR_TYPE_SHARED_INFO:

kvm_arch_vm_ioctl
case KVM_XEN_HVM_EVTCHN_SEND
 kvm_xen_hvm_evtchn_send
  kvm_xen_set_evtchn
   kvm_xen_set_evtchn_fast
    read_lock gpc->lock
                                          kvm_xen_hvm_set_attr case
                                          KVM_XEN_ATTR_TYPE_SHARED_INFO
                                           mutex_lock kvm->lock
                                           kvm_xen_shared_info_init
                                            kvm_gpc_activate
                                             gpc->khva = NULL
    kvm_gpc_check
     [ Check passes because gpc->valid is
       still true, even though gpc->khva
       is already NULL. ]
    shinfo = gpc->khva
    pending_bits = shinfo->evtchn_pending
    CRASH: test_and_set_bit(..., pending_bits)

Protect kvm_gpc_activate() cache properties writes by write lock
gpc->lock.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Attaching more details:

[   86.127703] BUG: kernel NULL pointer dereference, address: 0000000000000800
[   86.127751] #PF: supervisor write access in kernel mode
[   86.127778] #PF: error_code(0x0002) - not-present page
[   86.127801] PGD 105792067 P4D 105792067 PUD 105793067 PMD 0
[   86.127826] Oops: 0002 [#1] PREEMPT SMP NOPTI
[   86.127850] CPU: 0 PID: 945 Comm: xen_shinfo_test Not tainted 6.0.0-rc5-test+ #31
[   86.127874] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.0-3-3 04/01/2014
[   86.127898] RIP: 0010:kvm_xen_set_evtchn_fast (./arch/x86/include/asm/bitops.h:138 ./include/asm-generic/bitops/instrumented-atomic.h:72 arch/x86/kvm/xen.c:1370) kvm
[ 86.127960] Code: 5a 84 c0 0f 84 01 01 00 00 80 bb b4 9f 00 00 00 8b 45 00 48 8b 93 c8 a0 00 00 75 4d 41 89 c0 48 8d b2 80 08 00 00 41 c1 e8 05 <f0> 48 0f ab 82 00 08 00 00 0f 82 19 01 00 00 8b 45 00 48 0f a3 06
All code
========
   0:	5a                   	pop    %rdx
   1:	84 c0                	test   %al,%al
   3:	0f 84 01 01 00 00    	je     0x10a
   9:	80 bb b4 9f 00 00 00 	cmpb   $0x0,0x9fb4(%rbx)
  10:	8b 45 00             	mov    0x0(%rbp),%eax
  13:	48 8b 93 c8 a0 00 00 	mov    0xa0c8(%rbx),%rdx
  1a:	75 4d                	jne    0x69
  1c:	41 89 c0             	mov    %eax,%r8d
  1f:	48 8d b2 80 08 00 00 	lea    0x880(%rdx),%rsi
  26:	41 c1 e8 05          	shr    $0x5,%r8d
  2a:*	f0 48 0f ab 82 00 08 	lock bts %rax,0x800(%rdx)		<-- trapping instruction
  31:	00 00
  33:	0f 82 19 01 00 00    	jb     0x152
  39:	8b 45 00             	mov    0x0(%rbp),%eax
  3c:	48 0f a3 06          	bt     %rax,(%rsi)

Code starting with the faulting instruction
===========================================
   0:	f0 48 0f ab 82 00 08 	lock bts %rax,0x800(%rdx)
   7:	00 00
   9:	0f 82 19 01 00 00    	jb     0x128
   f:	8b 45 00             	mov    0x0(%rbp),%eax
  12:	48 0f a3 06          	bt     %rax,(%rsi)
[   86.127982] RSP: 0018:ffffc90001367c50 EFLAGS: 00010046
[   86.128001] RAX: 0000000000000001 RBX: ffffc90001369000 RCX: 0000000000000001
[   86.128021] RDX: 0000000000000000 RSI: 0000000000000a00 RDI: ffffffff82886a66
[   86.128040] RBP: ffffc90001367ca8 R08: 0000000000000000 R09: 000000006cc00c97
[   86.128060] R10: ffff88810c150000 R11: 0000000076cc00c9 R12: 0000000000000001
[   86.128079] R13: ffffc90001372ff8 R14: ffff8881045c0000 R15: ffffc90001373830
[   86.128098] FS:  00007f71d6111740(0000) GS:ffff888237c00000(0000) knlGS:0000000000000000
[   86.128118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   86.128138] CR2: 0000000000000800 CR3: 0000000104774006 CR4: 0000000000772ef0
[   86.128158] PKRU: 55555554
[   86.128177] Call Trace:
[   86.128196]  <TASK>
[   86.128215] kvm_xen_hvm_evtchn_send (arch/x86/kvm/xen.c:1432 arch/x86/kvm/xen.c:1562) kvm
[   86.128256] kvm_arch_vm_ioctl (arch/x86/kvm/x86.c:6883) kvm
[   86.128294] ? __lock_acquire (kernel/locking/lockdep.c:4553 kernel/locking/lockdep.c:5007)
[   86.128315] ? __lock_acquire (kernel/locking/lockdep.c:4553 kernel/locking/lockdep.c:5007)
[   86.128335] ? kvm_vm_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4814) kvm
[   86.128368] kvm_vm_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4814) kvm
[   86.128401] ? lock_is_held_type (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5710)
[   86.128422] ? lock_release (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5688)
[   86.128442] __x64_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:870 fs/ioctl.c:856 fs/ioctl.c:856)
[   86.128462] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[   86.128482] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128501] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128520] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4383)
[   86.128539] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128558] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128577] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128596] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128615] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128634] ? do_syscall_64 (arch/x86/entry/common.c:87)
[   86.128653] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4383)
[   86.128673] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[   86.128692] RIP: 0033:0x7f71d6152c6b
[ 86.128712] Code: 73 01 c3 48 8b 0d b5 b1 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b1 1b 00 f7 d8 64 89 01 48
All code
========
   0:	73 01                	jae    0x3
   2:	c3                   	ret
   3:	48 8b 0d b5 b1 1b 00 	mov    0x1bb1b5(%rip),%rcx        # 0x1bb1bf
   a:	f7 d8                	neg    %eax
   c:	64 89 01             	mov    %eax,%fs:(%rcx)
   f:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
  13:	c3                   	ret
  14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  1b:	00 00 00
  1e:	90                   	nop
  1f:	f3 0f 1e fa          	endbr64
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d 85 b1 1b 00 	mov    0x1bb185(%rip),%rcx        # 0x1bb1bf
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d 85 b1 1b 00 	mov    0x1bb185(%rip),%rcx        # 0x1bb195
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[   86.128735] RSP: 002b:00007fff7c716c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   86.128755] RAX: ffffffffffffffda RBX: 00007f71d61116c0 RCX: 00007f71d6152c6b
[   86.128775] RDX: 00007fff7c716f00 RSI: 00000000400caed0 RDI: 0000000000000004
[   86.128794] RBP: 0000000001f2b2a0 R08: 0000000000417343 R09: 00007f71d62cc341
[   86.128814] R10: 00007fff7c74c258 R11: 0000000000000246 R12: 00007f71d6329000
[   86.128833] R13: 00000000632870b9 R14: 0000000000000001 R15: 00007f71d632a020
[   86.128854]  </TASK>
[   86.128873] Modules linked in: kvm_intel 9p fscache netfs nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink qrtr sunrpc intel_rapl_msr intel_rapl_common kvm irqbypass rapl pcspkr 9pnet_virtio i2c_piix4 9pnet drm zram ip_tables crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel virtio_console serio_raw ata_generic virtio_blk pata_acpi qemu_fw_cfg ipmi_devintf ipmi_msghandler fuse
[   86.128893] Unloaded tainted modules: kvm_intel():1 [last unloaded: kvm_intel]
[   86.128944] CR2: 0000000000000800
[   86.128962] ---[ end trace 0000000000000000 ]---
[   86.128982] RIP: 0010:kvm_xen_set_evtchn_fast (./arch/x86/include/asm/bitops.h:138 ./include/asm-generic/bitops/instrumented-atomic.h:72 arch/x86/kvm/xen.c:1370) kvm
[ 86.129022] Code: 5a 84 c0 0f 84 01 01 00 00 80 bb b4 9f 00 00 00 8b 45 00 48 8b 93 c8 a0 00 00 75 4d 41 89 c0 48 8d b2 80 08 00 00 41 c1 e8 05 <f0> 48 0f ab 82 00 08 00 00 0f 82 19 01 00 00 8b 45 00 48 0f a3 06
All code
========
   0:	5a                   	pop    %rdx
   1:	84 c0                	test   %al,%al
   3:	0f 84 01 01 00 00    	je     0x10a
   9:	80 bb b4 9f 00 00 00 	cmpb   $0x0,0x9fb4(%rbx)
  10:	8b 45 00             	mov    0x0(%rbp),%eax
  13:	48 8b 93 c8 a0 00 00 	mov    0xa0c8(%rbx),%rdx
  1a:	75 4d                	jne    0x69
  1c:	41 89 c0             	mov    %eax,%r8d
  1f:	48 8d b2 80 08 00 00 	lea    0x880(%rdx),%rsi
  26:	41 c1 e8 05          	shr    $0x5,%r8d
  2a:*	f0 48 0f ab 82 00 08 	lock bts %rax,0x800(%rdx)		<-- trapping instruction
  31:	00 00
  33:	0f 82 19 01 00 00    	jb     0x152
  39:	8b 45 00             	mov    0x0(%rbp),%eax
  3c:	48 0f a3 06          	bt     %rax,(%rsi)

Code starting with the faulting instruction
===========================================
   0:	f0 48 0f ab 82 00 08 	lock bts %rax,0x800(%rdx)
   7:	00 00
   9:	0f 82 19 01 00 00    	jb     0x128
   f:	8b 45 00             	mov    0x0(%rbp),%eax
  12:	48 0f a3 06          	bt     %rax,(%rsi)
[   86.129044] RSP: 0018:ffffc90001367c50 EFLAGS: 00010046
[   86.129064] RAX: 0000000000000001 RBX: ffffc90001369000 RCX: 0000000000000001
[   86.129083] RDX: 0000000000000000 RSI: 0000000000000a00 RDI: ffffffff82886a66
[   86.129103] RBP: ffffc90001367ca8 R08: 0000000000000000 R09: 000000006cc00c97
[   86.129122] R10: ffff88810c150000 R11: 0000000076cc00c9 R12: 0000000000000001
[   86.129142] R13: ffffc90001372ff8 R14: ffff8881045c0000 R15: ffffc90001373830
[   86.129161] FS:  00007f71d6111740(0000) GS:ffff888237c00000(0000) knlGS:0000000000000000
[   86.129181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   86.129201] CR2: 0000000000000800 CR3: 0000000104774006 CR4: 0000000000772ef0
[   86.129221] PKRU: 55555554
[   86.129240] note: xen_shinfo_test[945] exited with preempt_count 1
[  151.131754] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  151.131793] rcu: 	1-...0: (13 ticks this GP) idle=785c/1/0x4000000000000000 softirq=4758/4760 fqs=16038
[  151.131816] 	(detected by 2, t=65002 jiffies, g=6449, q=1299 ncpus=4)
[  151.131837] Sending NMI from CPU 2 to CPUs 1:
[  151.131862] NMI backtrace for cpu 1
[  151.131864] CPU: 1 PID: 949 Comm: xen_shinfo_test Tainted: G      D            6.0.0-rc5-test+ #31
[  151.131866] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.0-3-3 04/01/2014
[  151.131866] RIP: 0010:queued_write_lock_slowpath (kernel/locking/qrwlock.c:85)
[ 151.131870] Code: ff 90 48 89 df 5b 5d e9 86 fd ff ff f0 81 0b 00 01 00 00 ba ff 00 00 00 b9 00 01 00 00 8b 03 3d 00 01 00 00 74 0b f3 90 8b 03 <3d> 00 01 00 00 75 f5 89 c8 f0 0f b1 13 74 c0 eb e2 89 c6 48 89 ef
All code
========
   0:	ff 90 48 89 df 5b    	call   *0x5bdf8948(%rax)
   6:	5d                   	pop    %rbp
   7:	e9 86 fd ff ff       	jmp    0xfffffffffffffd92
   c:	f0 81 0b 00 01 00 00 	lock orl $0x100,(%rbx)
  13:	ba ff 00 00 00       	mov    $0xff,%edx
  18:	b9 00 01 00 00       	mov    $0x100,%ecx
  1d:	8b 03                	mov    (%rbx),%eax
  1f:	3d 00 01 00 00       	cmp    $0x100,%eax
  24:	74 0b                	je     0x31
  26:	f3 90                	pause
  28:	8b 03                	mov    (%rbx),%eax
  2a:*	3d 00 01 00 00       	cmp    $0x100,%eax		<-- trapping instruction
  2f:	75 f5                	jne    0x26
  31:	89 c8                	mov    %ecx,%eax
  33:	f0 0f b1 13          	lock cmpxchg %edx,(%rbx)
  37:	74 c0                	je     0xfffffffffffffff9
  39:	eb e2                	jmp    0x1d
  3b:	89 c6                	mov    %eax,%esi
  3d:	48 89 ef             	mov    %rbp,%rdi

Code starting with the faulting instruction
===========================================
   0:	3d 00 01 00 00       	cmp    $0x100,%eax
   5:	75 f5                	jne    0xfffffffffffffffc
   7:	89 c8                	mov    %ecx,%eax
   9:	f0 0f b1 13          	lock cmpxchg %edx,(%rbx)
   d:	74 c0                	je     0xffffffffffffffcf
   f:	eb e2                	jmp    0xfffffffffffffff3
  11:	89 c6                	mov    %eax,%esi
  13:	48 89 ef             	mov    %rbp,%rdi
[  151.131871] RSP: 0018:ffffc900011f7b98 EFLAGS: 00000006
[  151.131872] RAX: 0000000000000300 RBX: ffffc90001372ff8 RCX: 0000000000000100
[  151.131872] RDX: 00000000000000ff RSI: ffffffff827ea0a3 RDI: ffffffff82886a66
[  151.131873] RBP: ffffc90001372ffc R08: ffff888107864160 R09: 00000000777cbcf6
[  151.131873] R10: ffff888107863300 R11: 000000006777cbcf R12: ffffc90001372ff8
[  151.131874] R13: ffffc90001369000 R14: ffffc90001372fb8 R15: ffffc90001369170
[  151.131874] FS:  00007f71d5f09640(0000) GS:ffff888237c80000(0000) knlGS:0000000000000000
[  151.131875] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  151.131876] CR2: 00007f71d5f08ef8 CR3: 0000000104774002 CR4: 0000000000772ee0
[  151.131877] PKRU: 55555554
[  151.131878] Call Trace:
[  151.131879]  <TASK>
[  151.131880] do_raw_write_lock (./include/asm-generic/qrwlock.h:101 kernel/locking/spinlock_debug.c:210)
[  151.131883] kvm_gpc_refresh (arch/x86/kvm/../../../virt/kvm/pfncache.c:262) kvm
[  151.131907] ? kvm_gpc_activate (./include/linux/spinlock.h:390 arch/x86/kvm/../../../virt/kvm/pfncache.c:375) kvm
[  151.131925] kvm_xen_hvm_set_attr (arch/x86/kvm/xen.c:51 arch/x86/kvm/xen.c:464) kvm
[  151.131950] kvm_arch_vm_ioctl (arch/x86/kvm/x86.c:6883) kvm
[  151.131971] ? __lock_acquire (kernel/locking/lockdep.c:4553 kernel/locking/lockdep.c:5007)
[  151.131973] kvm_vm_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4814) kvm
[  151.131991] ? lock_is_held_type (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5710)
[  151.131993] ? lock_release (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5688)
[  151.131995] __x64_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:870 fs/ioctl.c:856 fs/ioctl.c:856)
[  151.131997] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[  151.131998] ? lock_is_held_type (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5710)
[  151.132000] ? do_syscall_64 (arch/x86/entry/common.c:87)
[  151.132000] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4383)
[  151.132002] ? do_syscall_64 (arch/x86/entry/common.c:87)
[  151.132003] ? do_syscall_64 (arch/x86/entry/common.c:87)
[  151.132003] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4383)
[  151.132004] ? do_syscall_64 (arch/x86/entry/common.c:87)
[  151.132005] ? do_syscall_64 (arch/x86/entry/common.c:87)
[  151.132006] ? do_syscall_64 (arch/x86/entry/common.c:87)
[  151.132007] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4383)
[  151.132008] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[  151.132009] RIP: 0033:0x7f71d6152c6b
[ 151.132011] Code: 73 01 c3 48 8b 0d b5 b1 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b1 1b 00 f7 d8 64 89 01 48
All code
========
   0:	73 01                	jae    0x3
   2:	c3                   	ret
   3:	48 8b 0d b5 b1 1b 00 	mov    0x1bb1b5(%rip),%rcx        # 0x1bb1bf
   a:	f7 d8                	neg    %eax
   c:	64 89 01             	mov    %eax,%fs:(%rcx)
   f:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
  13:	c3                   	ret
  14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  1b:	00 00 00
  1e:	90                   	nop
  1f:	f3 0f 1e fa          	endbr64
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d 85 b1 1b 00 	mov    0x1bb185(%rip),%rcx        # 0x1bb1bf
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d 85 b1 1b 00 	mov    0x1bb185(%rip),%rcx        # 0x1bb195
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[  151.132011] RSP: 002b:00007f71d5f08da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  151.132012] RAX: ffffffffffffffda RBX: 0000000001f2b2a0 RCX: 00007f71d6152c6b
[  151.132013] RDX: 00007f71d5f08db0 RSI: 000000004048aec9 RDI: 0000000000000004
[  151.132013] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fff7c716b3f
[  151.132013] R10: 00007f71d611c948 R11: 0000000000000246 R12: 00007f71d5f09640
[  151.132014] R13: 0000000000000004 R14: 00007f71d61b3550 R15: 0000000000000000
[  151.132016]  </TASK>

 virt/kvm/pfncache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 45b9b96c0ea3..e987669c3506 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -364,11 +364,13 @@ EXPORT_SYMBOL_GPL(kvm_gpc_init);
 int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
 	if (!gpc->active) {
+		write_lock_irq(&gpc->lock);
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
 		gpc->valid = false;
 		gpc->active = true;
+		write_unlock_irq(&gpc->lock);
 
 		spin_lock(&gpc->kvm->gpc_lock);
 		list_add(&gpc->list, &gpc->kvm->gpc_list);
-- 
2.37.3

