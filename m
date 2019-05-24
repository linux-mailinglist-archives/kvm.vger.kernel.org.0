Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6E294DF
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 11:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390357AbfEXJhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 05:37:04 -0400
Received: from 9.mo177.mail-out.ovh.net ([46.105.72.238]:53315 "EHLO
        9.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390203AbfEXJhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 05:37:04 -0400
Received: from player728.ha.ovh.net (unknown [10.108.35.197])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 8D6DBF6C77
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 11:17:21 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id AC82160B1AD8;
        Fri, 24 May 2019 09:17:18 +0000 (UTC)
Subject: Re: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190523063424.GB19655@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <3633e945-7126-c655-587d-e09eafb9f9f3@kaod.org>
Date:   Fri, 24 May 2019 11:17:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523063424.GB19655@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13159799586557299671
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudduiedgudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/19 8:34 AM, Paul Mackerras wrote:
> Recent reports of lockdep splats in the HV KVM code revealed that it
> was taking the kvm->lock mutex in several contexts where a vcpu mutex
> was already held.  Lockdep has only started warning since I added code
> to take the vcpu mutexes in the XIVE device release functions, but
> since Documentation/virtual/kvm/locking.txt specifies that the vcpu
> mutexes nest inside kvm->lock, it seems that the new code is correct
> and it is most of the old uses of kvm->lock that are wrong.
> 
> This series should fix the problems, by adding new mutexes that nest
> inside the vcpu mutexes and using them instead of kvm->lock.

Hello,

I guest this warning when running a guest with this patchset :

[  228.686461] DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
[  228.686480] WARNING: CPU: 116 PID: 3803 at ../kernel/locking/lockdep.c:4219 check_flags.part.23+0x21c/0x270
[  228.686544] Modules linked in: vhost_net vhost xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter fuse kvm_hv kvm at24 ipmi_powernv regmap_i2c ipmi_devintf uio_pdrv_genirq ofpart ipmi_msghandler uio powernv_flash mtd ibmpowernv opal_prd ip_tables ext4 mbcache jbd2 btrfs zstd_decompress zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c xor raid6_pq raid1 raid0 ses sd_mod enclosure scsi_transport_sas ast i2c_opal i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm i40e e1000e cxl aacraid tg3 drm_panel_orientation_quirks i2c_core
[  228.686859] CPU: 116 PID: 3803 Comm: qemu-system-ppc Kdump: loaded Not tainted 5.2.0-rc1-xive+ #42
[  228.686911] NIP:  c0000000001b394c LR: c0000000001b3948 CTR: c000000000bfad20
[  228.686963] REGS: c000200cdb50f570 TRAP: 0700   Not tainted  (5.2.0-rc1-xive+)
[  228.687001] MSR:  9000000002823033 <SF,HV,VEC,VSX,FP,ME,IR,DR,RI,LE>  CR: 48222222  XER: 20040000
[  228.687060] CFAR: c000000000116db0 IRQMASK: 1 
[  228.687060] GPR00: c0000000001b3948 c000200cdb50f800 c0000000015e7600 000000000000002e 
[  228.687060] GPR04: 0000000000000001 c0000000001c71a0 000000006e655f73 72727563284e4f5f 
[  228.687060] GPR08: 0000200e60680000 0000000000000000 c000200cdb486180 0000000000000000 
[  228.687060] GPR12: 0000000000002000 c000200fff61a680 0000000000000000 00007fffb75c0000 
[  228.687060] GPR16: 0000000000000000 0000000000000000 c0000000017d6900 c000000001124900 
[  228.687060] GPR20: 0000000000000074 c008000006916f68 0000000000000074 0000000000000074 
[  228.687060] GPR24: ffffffffffffffff ffffffffffffffff 0000000000000003 c000200d4b600000 
[  228.687060] GPR28: c000000001627e58 c000000001489908 c000000001627e58 c000000002304de0 
[  228.687377] NIP [c0000000001b394c] check_flags.part.23+0x21c/0x270
[  228.687415] LR [c0000000001b3948] check_flags.part.23+0x218/0x270
[  228.687466] Call Trace:
[  228.687488] [c000200cdb50f800] [c0000000001b3948] check_flags.part.23+0x218/0x270 (unreliable)
[  228.687542] [c000200cdb50f870] [c0000000001b6548] lock_is_held_type+0x188/0x1c0
[  228.687595] [c000200cdb50f8d0] [c0000000001d939c] rcu_read_lock_sched_held+0xdc/0x100
[  228.687646] [c000200cdb50f900] [c0000000001dd704] rcu_note_context_switch+0x304/0x340
[  228.687701] [c000200cdb50f940] [c0080000068fcc58] kvmhv_run_single_vcpu+0xdb0/0x1120 [kvm_hv]
[  228.687756] [c000200cdb50fa20] [c0080000068fd5b0] kvmppc_vcpu_run_hv+0x5e8/0xe40 [kvm_hv]
[  228.687816] [c000200cdb50faf0] [c0080000071797dc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[  228.687863] [c000200cdb50fb10] [c0080000071755dc] kvm_arch_vcpu_ioctl_run+0x244/0x420 [kvm]
[  228.687916] [c000200cdb50fba0] [c008000007165ccc] kvm_vcpu_ioctl+0x424/0x838 [kvm]
[  228.687957] [c000200cdb50fd10] [c000000000433a24] do_vfs_ioctl+0xd4/0xcd0
[  228.687995] [c000200cdb50fdb0] [c000000000434724] ksys_ioctl+0x104/0x120
[  228.688033] [c000200cdb50fe00] [c000000000434768] sys_ioctl+0x28/0x80
[  228.688072] [c000200cdb50fe20] [c00000000000b888] system_call+0x5c/0x70
[  228.688109] Instruction dump:
[  228.688142] 4bf6342d 60000000 0fe00000 e8010080 7c0803a6 4bfffe60 3c82ff87 3c62ff87 
[  228.688196] 388472d0 3863d738 4bf63405 60000000 <0fe00000> 4bffff4c 3c82ff87 3c62ff87 
[  228.688251] irq event stamp: 205
[  228.688287] hardirqs last  enabled at (205): [<c0080000068fc1b4>] kvmhv_run_single_vcpu+0x30c/0x1120 [kvm_hv]
[  228.688344] hardirqs last disabled at (204): [<c0080000068fbff0>] kvmhv_run_single_vcpu+0x148/0x1120 [kvm_hv]
[  228.688412] softirqs last  enabled at (180): [<c000000000c0b2ac>] __do_softirq+0x4ac/0x5d4
[  228.688464] softirqs last disabled at (169): [<c000000000122aa8>] irq_exit+0x1f8/0x210
[  228.688513] ---[ end trace eb16f6260022a812 ]---
[  228.688548] possible reason: unannotated irqs-off.
[  228.688571] irq event stamp: 205
[  228.688607] hardirqs last  enabled at (205): [<c0080000068fc1b4>] kvmhv_run_single_vcpu+0x30c/0x1120 [kvm_hv]
[  228.688664] hardirqs last disabled at (204): [<c0080000068fbff0>] kvmhv_run_single_vcpu+0x148/0x1120 [kvm_hv]
[  228.688719] softirqs last  enabled at (180): [<c000000000c0b2ac>] __do_softirq+0x4ac/0x5d4
[  228.688758] softirqs last disabled at (169): [<c000000000122aa8>] irq_exit+0x1f8/0x210



C.
