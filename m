Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D60E6FE175
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 17:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbjEJPUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 11:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbjEJPUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 11:20:37 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A09149E5
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 08:20:25 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pwkR7-00GkR2-5O; Wed, 10 May 2023 16:04:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=bfUOtGuEHKhhwghmqsoPprp9hhjQL7nHkzTNr2PYphA=; b=ibVMZLX70BcRq
        n7WK0AnUHG7Yfh9sZad+dMNKB39u3aF+FIGnNjE39WWeA3VnJu2JFzqf15A0E0tLCClq79ioXprF4
        9Oe2HfaFivBcEHH43TFXyJiy8Dm0F3BEyQbs6fBPWUetQT93mRoXV5rmPB50ZDIta/RN3RdYiL70t
        3VL3c6hyY9UFlzSH6X1lf1PByc17v20TiyUxiG1neOOwSZthBHgJXMEIqP2uQOmYkheOgdgpJLYg+
        1B07dt8LwfMXZJuLR/bspB/7PaH1tjh2X8dNRBfbft57+hvumfe/v39Oy5oJBpMr+abInqPewuKEK
        xR8R0W/CxhoNOEOvkpurw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pwkR6-0000rX-Q5; Wed, 10 May 2023 16:04:56 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pwkQi-0003HK-JC; Wed, 10 May 2023 16:04:32 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, shuah@kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/2] KVM: vcpu_array[0] races
Date:   Wed, 10 May 2023 16:04:08 +0200
Message-Id: <20230510140410.1093987-1-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
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

When online_vcpus=0, any call to kvm_get_vcpu() goes through
array_index_nospec() and ends with an attempt to xa_load(vcpu_array, 0):

	int num_vcpus = atomic_read(&kvm->online_vcpus);
	i = array_index_nospec(i, num_vcpus);
	return xa_load(&kvm->vcpu_array, i);

Similarly, when online_vcpus=0, a kvm_for_each_vcpu() does not iterate over
an "empty" range, but actually [0, ULONG_MAX]:

	xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, \
			  (atomic_read(&kvm->online_vcpus) - 1))

In both cases, such online_vcpus=0 edge case, even if leading to
unnecessary calls to XArray API, should not be an issue; requesting
unpopulated indexes/ranges is handled by xa_load() and xa_for_each_range().

However, this means that when the first vCPU is created and inserted in
vcpu_array *and* before online_vcpus is incremented, code calling
kvm_get_vcpu()/kvm_for_each_vcpu() already has access to that first vCPU.

This should not pose a problem assuming that once a vcpu is stored in
vcpu_array, it will remain there, but that's not the case:
kvm_vm_ioctl_create_vcpu() first inserts to vcpu_array, then requests a
file descriptor. If create_vcpu_fd() fails, newly inserted vcpu is removed
from the vcpu_array, then destroyed:

	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
	kvm_get_kvm(kvm);
	r = create_vcpu_fd(vcpu);
	if (r < 0) {
		xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
		kvm_put_kvm_no_destroy(kvm);
		goto unlock_vcpu_destroy;
	}
	atomic_inc(&kvm->online_vcpus);

This results in a possible race condition when a reference to a vcpu is
acquired (via kvm_get_vcpu() or kvm_for_each_vcpu()) moments before said
vcpu is destroyed.

Selftest exercises four different races between KVM_CREATE_VCPU and users
of kvm_get_vcpu() and kvm_for_each_vcpu(). Below are respective KASAN
splats.

Note that some tests have 10+ minutes time-outs.

KVM_IRQ_ROUTING_XEN_EVTCHN:

[   58.358416] ==================================================================
[   58.358420] BUG: KASAN: user-memory-access in kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
[   58.358497] Read of size 1 at addr 00000000000011ec by task a.out/954

[   58.358501] CPU: 5 PID: 954 Comm: a.out Not tainted 6.3.0-kasan+ #8
[   58.358504] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[   58.358506] Call Trace:
[   58.358507]  <TASK>
[   58.358509]  dump_stack_lvl+0x57/0x90
[   58.358514]  kasan_report+0xc1/0xf0
[   58.358517]  ? kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
[   58.358587]  ? kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
[   58.358660]  kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
[   58.358733]  ? lock_release+0x214/0x3a0
[   58.358737]  ? kvm_set_irq+0x110/0x280 [kvm]
[   58.358817]  ? kvm_xen_hvm_config+0x110/0x110 [kvm]
[   58.358887]  ? lock_is_held_type+0xce/0x120
[   58.358891]  evtchn_set_fn+0x1a/0x40 [kvm]
[   58.358961]  kvm_set_irq+0x181/0x280 [kvm]
[   58.359019]  ? kvm_send_userspace_msi+0x100/0x100 [kvm]
[   58.359077]  ? kvm_xen_hypercall+0xf80/0xf80 [kvm]
[   58.359146]  ? __call_rcu_common.constprop.0+0x2f1/0x920
[   58.359150]  ? mark_held_locks+0x1a/0x80
[   58.359154]  ? kasan_quarantine_put+0xd2/0x1e0
[   58.359157]  ? lockdep_hardirqs_on+0x7d/0x100
[   58.359159]  ? kasan_quarantine_put+0xd2/0x1e0
[   58.359162]  ? mark_lock+0xf4/0xce0
[   58.359165]  ? slab_free_freelist_hook+0xef/0x220
[   58.359169]  kvm_vm_ioctl_irq_line+0x52/0x70 [kvm]
[   58.359239]  kvm_vm_ioctl+0xbd3/0x1370 [kvm]
[   58.359320]  ? kvm_vm_ioctl+0xe49/0x1370 [kvm]
[   58.359400]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[   58.359487]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[   58.359565]  ? __lock_acquire+0x9ed/0x3210
[   58.359570]  ? __lock_acquire+0x9ed/0x3210
[   58.359575]  ? do_vfs_ioctl+0xb45/0xc40
[   58.359579]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[   58.359582]  ? vfs_fileattr_set+0x480/0x480
[   58.359585]  ? do_vfs_ioctl+0xb45/0xc40
[   58.359588]  ? vfs_fileattr_set+0x480/0x480
[   58.359591]  ? find_held_lock+0x83/0xa0
[   58.359595]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[   58.359599]  ? selinux_bprm_creds_for_exec+0x440/0x440
[   58.359602]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[   58.359605]  ? rcu_is_watching+0x34/0x50
[   58.359609]  ? __fget_files+0x146/0x200
[   58.359614]  __x64_sys_ioctl+0xb8/0xf0
[   58.359618]  do_syscall_64+0x56/0x80
[   58.359620]  ? do_syscall_64+0x62/0x80
[   58.359623]  ? lockdep_hardirqs_on+0x7d/0x100
[   58.359625]  ? do_syscall_64+0x62/0x80
[   58.359627]  ? do_syscall_64+0x62/0x80
[   58.359630]  ? do_syscall_64+0x62/0x80
[   58.359633]  ? do_syscall_64+0x62/0x80
[   58.359635]  ? lockdep_hardirqs_on+0x7d/0x100
[   58.359638]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   58.359642] RIP: 0033:0x7feb7dfd1d6f
[   58.359645] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[   58.359647] RSP: 002b:00007feb7decce20 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   58.359651] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007feb7dfd1d6f
[   58.359653] RDX: 00007feb7decce88 RSI: 000000004008ae61 RDI: 0000000000000004
[   58.359654] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffefb29f677
[   58.359656] R10: 00007feb7dee9c38 R11: 0000000000000246 R12: ffffffffffffff80
[   58.359658] R13: 0000000000000000 R14: 00007ffefb29f580 R15: 00007feb7d6cd000
[   58.359663]  </TASK>
[   58.359664] ==================================================================
[   58.359680] Disabling lock debugging due to kernel taint
[   58.359683] BUG: unable to handle page fault for address: 00000000000011ec
[   58.359746] #PF: supervisor read access in kernel mode
[   58.359771] #PF: error_code(0x0000) - not-present page
[   58.359795] PGD 10c522067 P4D 10c522067 PUD 10c523067 PMD 0
[   58.359823] Oops: 0000 [#1] PREEMPT SMP KASAN
[   58.359847] CPU: 5 PID: 954 Comm: a.out Tainted: G    B              6.3.0-kasan+ #8
[   58.359873] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[   58.359900] RIP: 0010:kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
[   58.360014] Code: 00 48 63 d3 48 39 c2 48 19 c0 21 c3 48 8d bd 40 12 00 00 48 63 f3 e8 a1 01 1c c2 48 89 c3 48 8d bb ec 11 00 00 e8 22 ee 0f c1 <80> bb ec 11 00 00 00 0f 84 ca 04 00 00 4c 89 ff e8 ed ef 0f c1 48
[   58.360061] RSP: 0018:ffffc900015ef8e0 EFLAGS: 00010282
[   58.360087] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff81146546
[   58.360112] RDX: fffffbfff0b6f8b1 RSI: 0000000000000008 RDI: ffffffff85b7c580
[   58.360137] RBP: ffffc900014b1000 R08: 0000000000000001 R09: ffffffff85b7c587
[   58.360168] R10: fffffbfff0b6f8b0 R11: 00000000ffffffff R12: ffffc900014b2338
[   58.360194] R13: ffffc900015efa00 R14: 00000000ffffffff R15: ffffc900015efa10
[   58.360219] FS:  00007feb7decd6c0(0000) GS:ffff8883ef080000(0000) knlGS:0000000000000000
[   58.360252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   58.360277] CR2: 00000000000011ec CR3: 000000012ac96006 CR4: 0000000000772ee0
[   58.360304] PKRU: 55555554
[   58.360326] Call Trace:
[   58.360349]  <TASK>
[   58.360371]  ? lock_release+0x214/0x3a0
[   58.360403]  ? kvm_set_irq+0x110/0x280 [kvm]
[   58.360506]  ? kvm_xen_hvm_config+0x110/0x110 [kvm]
[   58.360612]  ? lock_is_held_type+0xce/0x120
[   58.360638]  evtchn_set_fn+0x1a/0x40 [kvm]
[   58.360748]  kvm_set_irq+0x181/0x280 [kvm]
[   58.360858]  ? kvm_send_userspace_msi+0x100/0x100 [kvm]
[   58.360962]  ? kvm_xen_hypercall+0xf80/0xf80 [kvm]
[   58.361069]  ? __call_rcu_common.constprop.0+0x2f1/0x920
[   58.361099]  ? mark_held_locks+0x1a/0x80
[   58.361125]  ? kasan_quarantine_put+0xd2/0x1e0
[   58.361150]  ? lockdep_hardirqs_on+0x7d/0x100
[   58.361175]  ? kasan_quarantine_put+0xd2/0x1e0
[   58.361203]  ? mark_lock+0xf4/0xce0
[   58.361227]  ? slab_free_freelist_hook+0xef/0x220
[   58.361259]  kvm_vm_ioctl_irq_line+0x52/0x70 [kvm]
[   58.361364]  kvm_vm_ioctl+0xbd3/0x1370 [kvm]
[   58.361467]  ? kvm_vm_ioctl+0xe49/0x1370 [kvm]
[   58.361570]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[   58.361675]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[   58.361969]  ? __lock_acquire+0x9ed/0x3210
[   58.362145]  ? __lock_acquire+0x9ed/0x3210
[   58.362291]  ? do_vfs_ioctl+0xb45/0xc40
[   58.362408]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[   58.362539]  ? vfs_fileattr_set+0x480/0x480
[   58.362658]  ? do_vfs_ioctl+0xb45/0xc40
[   58.362811]  ? vfs_fileattr_set+0x480/0x480
[   58.362930]  ? find_held_lock+0x83/0xa0
[   58.363048]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[   58.363171]  ? selinux_bprm_creds_for_exec+0x440/0x440
[   58.363288]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[   58.363426]  ? rcu_is_watching+0x34/0x50
[   58.363549]  ? __fget_files+0x146/0x200
[   58.363695]  __x64_sys_ioctl+0xb8/0xf0
[   58.364184]  do_syscall_64+0x56/0x80
[   58.364343]  ? do_syscall_64+0x62/0x80
[   58.364485]  ? lockdep_hardirqs_on+0x7d/0x100
[   58.364583]  ? do_syscall_64+0x62/0x80
[   58.364634]  ? do_syscall_64+0x62/0x80
[   58.364870]  ? do_syscall_64+0x62/0x80
[   58.364897]  ? do_syscall_64+0x62/0x80
[   58.364921]  ? lockdep_hardirqs_on+0x7d/0x100
[   58.364958]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   58.365005] RIP: 0033:0x7feb7dfd1d6f
[   58.365039] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[   58.365091] RSP: 002b:00007feb7decce20 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   58.365138] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007feb7dfd1d6f
[   58.365168] RDX: 00007feb7decce88 RSI: 000000004008ae61 RDI: 0000000000000004
[   58.365213] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffefb29f677
[   58.365247] R10: 00007feb7dee9c38 R11: 0000000000000246 R12: ffffffffffffff80
[   58.365282] R13: 0000000000000000 R14: 00007ffefb29f580 R15: 00007feb7d6cd000
[   58.365318]  </TASK>
[   58.365359] Modules linked in: kvm_intel 9p fscache netfs qrtr sunrpc intel_rapl_msr intel_rapl_common 9pnet_virtio kvm rapl 9pnet pcspkr i2c_piix4 drm zram crct10dif_pclmul crc32_pclmul crc32c_intel virtio_blk virtio_console serio_raw ata_generic pata_acpi ghash_clmulni_intel fuse qemu_fw_cfg [last unloaded: kvm_intel]
[   58.365439] CR2: 00000000000011ec
[   58.365472] ---[ end trace 0000000000000000 ]---
[   58.365506] RIP: 0010:kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
[   58.365631] Code: 00 48 63 d3 48 39 c2 48 19 c0 21 c3 48 8d bd 40 12 00 00 48 63 f3 e8 a1 01 1c c2 48 89 c3 48 8d bb ec 11 00 00 e8 22 ee 0f c1 <80> bb ec 11 00 00 00 0f 84 ca 04 00 00 4c 89 ff e8 ed ef 0f c1 48
[   58.365681] RSP: 0018:ffffc900015ef8e0 EFLAGS: 00010282
[   58.365715] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff81146546
[   58.365757] RDX: fffffbfff0b6f8b1 RSI: 0000000000000008 RDI: ffffffff85b7c580
[   58.365799] RBP: ffffc900014b1000 R08: 0000000000000001 R09: ffffffff85b7c587
[   58.365862] R10: fffffbfff0b6f8b0 R11: 00000000ffffffff R12: ffffc900014b2338
[   58.365906] R13: ffffc900015efa00 R14: 00000000ffffffff R15: ffffc900015efa10
[   58.365950] FS:  00007feb7decd6c0(0000) GS:ffff8883ef080000(0000) knlGS:0000000000000000
[   58.365993] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   58.366036] CR2: 00000000000011ec CR3: 000000012ac96006 CR4: 0000000000772ee0
[   58.366082] PKRU: 55555554
[   58.366111] note: a.out[954] exited with irqs disabled

KVM_RESET_DIRTY_RINGS:

[  113.917423] ==================================================================
[  113.917427] BUG: KASAN: vmalloc-out-of-bounds in kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
[  113.917489] Read of size 4 at addr ffffc90009150000 by task a.out/954

[  113.917493] CPU: 0 PID: 954 Comm: a.out Not tainted 6.3.0-kasan+ #8
[  113.917496] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[  113.917497] Call Trace:
[  113.917499]  <TASK>
[  113.917501]  dump_stack_lvl+0x57/0x90
[  113.917505]  print_report+0xcf/0x640
[  113.917509]  ? _raw_spin_lock_irqsave+0x5b/0x60
[  113.917512]  ? __virt_addr_valid+0x48/0x150
[  113.917516]  kasan_report+0xc1/0xf0
[  113.917519]  ? kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
[  113.917574]  ? kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
[  113.917631]  kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
[  113.917688]  kvm_vm_ioctl+0x6ea/0x1370 [kvm]
[  113.917742]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  113.917797]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  113.917849]  ? __lock_acquire+0x9ed/0x3210
[  113.917855]  ? __lock_acquire+0x9ed/0x3210
[  113.917859]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  113.917863]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  113.917866]  ? do_vfs_ioctl+0xa33/0xc40
[  113.917870]  ? vfs_fileattr_set+0x480/0x480
[  113.917872]  ? do_vfs_ioctl+0xa33/0xc40
[  113.917875]  ? vfs_fileattr_set+0x480/0x480
[  113.917878]  ? find_held_lock+0x83/0xa0
[  113.917881]  ? lock_release+0x214/0x3a0
[  113.917884]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  113.917888]  ? selinux_bprm_creds_for_exec+0x440/0x440
[  113.917892]  ? __fget_files+0x146/0x200
[  113.917898]  __x64_sys_ioctl+0xb8/0xf0
[  113.917901]  do_syscall_64+0x56/0x80
[  113.917904]  ? do_syscall_64+0x62/0x80
[  113.917906]  ? lockdep_hardirqs_on+0x7d/0x100
[  113.917909]  ? do_syscall_64+0x62/0x80
[  113.917911]  ? do_syscall_64+0x62/0x80
[  113.917914]  ? lockdep_hardirqs_on+0x7d/0x100
[  113.917916]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  113.917920] RIP: 0033:0x7f7c1fc66d6f
[  113.917922] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  113.917925] RSP: 002b:00007f7c1fb61e70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  113.917928] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f7c1fc66d6f
[  113.917930] RDX: 00007f7c1fb626c0 RSI: 000000000000aec7 RDI: 0000000000000004
[  113.917932] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc53511437
[  113.917933] R10: 00007f7c1fb7ec38 R11: 0000000000000246 R12: ffffffffffffff80
[  113.917935] R13: 0000000000000000 R14: 00007ffc53511340 R15: 00007f7c1f362000
[  113.917940]  </TASK>

[  113.917943] Memory state around the buggy address:
[  113.917945]  ffffc9000914ff00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  113.917947]  ffffc9000914ff80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  113.917948] >ffffc90009150000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  113.917949]                    ^
[  113.917951]  ffffc90009150080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  113.917952]  ffffc90009150100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  113.917954] ==================================================================
[  113.917955] Disabling lock debugging due to kernel taint
[  113.917959] BUG: unable to handle page fault for address: ffffc90009150000
[  113.918000] #PF: supervisor read access in kernel mode
[  113.918029] #PF: error_code(0x0000) - not-present page
[  113.918057] PGD 100000067 P4D 100000067 PUD 1008a2067 PMD 143f5d067 PTE 0
[  113.918092] Oops: 0000 [#1] PREEMPT SMP KASAN
[  113.918121] CPU: 0 PID: 954 Comm: a.out Tainted: G    B              6.3.0-kasan+ #8
[  113.918153] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[  113.918179] RIP: 0010:kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
[  113.918256] Code: 8d 43 08 8b 6b 04 48 89 c7 48 89 44 24 18 e8 4b d0 18 c1 8b 43 08 83 e8 01 21 e8 48 c1 e0 04 49 01 c7 4c 89 ff e8 34 d0 18 c1 <41> 8b 2f 83 e5 02 0f 84 2b 01 00 00 c7 44 24 14 00 00 00 00 b9 01
[  113.918289] RSP: 0018:ffffc9000161fb10 EFLAGS: 00010286
[  113.918314] RAX: 0000000000000001 RBX: ffff888126469dc8 RCX: ffffffff81146546
[  113.918339] RDX: fffffbfff0b6f8b1 RSI: 0000000000000008 RDI: ffffffff85b7c580
[  113.918364] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffff85b7c587
[  113.918388] R10: fffffbfff0b6f8b0 R11: 0000000000000010 R12: ffffc9000161fbd8
[  113.918432] R13: 0000000000000000 R14: ffffc90001392338 R15: ffffc90009150000
[  113.918457] FS:  00007f7c1fb626c0(0000) GS:ffff8883eee00000(0000) knlGS:0000000000000000
[  113.918484] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.918509] CR2: ffffc90009150000 CR3: 00000001395b3006 CR4: 0000000000772ef0
[  113.918535] PKRU: 55555554
[  113.918558] Call Trace:
[  113.918580]  <TASK>
[  113.918603]  kvm_vm_ioctl+0x6ea/0x1370 [kvm]
[  113.918703]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  113.918802]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  113.918901]  ? __lock_acquire+0x9ed/0x3210
[  113.918928]  ? __lock_acquire+0x9ed/0x3210
[  113.918954]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  113.918980]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  113.919005]  ? do_vfs_ioctl+0xa33/0xc40
[  113.919029]  ? vfs_fileattr_set+0x480/0x480
[  113.919053]  ? do_vfs_ioctl+0xa33/0xc40
[  113.919077]  ? vfs_fileattr_set+0x480/0x480
[  113.919101]  ? find_held_lock+0x83/0xa0
[  113.919126]  ? lock_release+0x214/0x3a0
[  113.919150]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  113.919175]  ? selinux_bprm_creds_for_exec+0x440/0x440
[  113.919202]  ? __fget_files+0x146/0x200
[  113.919228]  __x64_sys_ioctl+0xb8/0xf0
[  113.919253]  do_syscall_64+0x56/0x80
[  113.919277]  ? do_syscall_64+0x62/0x80
[  113.919300]  ? lockdep_hardirqs_on+0x7d/0x100
[  113.919324]  ? do_syscall_64+0x62/0x80
[  113.919348]  ? do_syscall_64+0x62/0x80
[  113.919371]  ? lockdep_hardirqs_on+0x7d/0x100
[  113.919395]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  113.919420] RIP: 0033:0x7f7c1fc66d6f
[  113.919452] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  113.919485] RSP: 002b:00007f7c1fb61e70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  113.919511] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f7c1fc66d6f
[  113.919536] RDX: 00007f7c1fb626c0 RSI: 000000000000aec7 RDI: 0000000000000004
[  113.919561] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc53511437
[  113.919586] R10: 00007f7c1fb7ec38 R11: 0000000000000246 R12: ffffffffffffff80
[  113.919611] R13: 0000000000000000 R14: 00007ffc53511340 R15: 00007f7c1f362000
[  113.919639]  </TASK>
[  113.919660] Modules linked in: kvm_intel 9p fscache netfs qrtr sunrpc intel_rapl_msr intel_rapl_common kvm 9pnet_virtio 9pnet rapl i2c_piix4 pcspkr drm zram crct10dif_pclmul crc32_pclmul crc32c_intel virtio_console virtio_blk serio_raw ghash_clmulni_intel ata_generic pata_acpi fuse qemu_fw_cfg [last unloaded: kvm_intel]
[  113.919726] CR2: ffffc90009150000
[  113.919749] ---[ end trace 0000000000000000 ]---
[  113.919772] RIP: 0010:kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
[  113.919872] Code: 8d 43 08 8b 6b 04 48 89 c7 48 89 44 24 18 e8 4b d0 18 c1 8b 43 08 83 e8 01 21 e8 48 c1 e0 04 49 01 c7 4c 89 ff e8 34 d0 18 c1 <41> 8b 2f 83 e5 02 0f 84 2b 01 00 00 c7 44 24 14 00 00 00 00 b9 01
[  113.919904] RSP: 0018:ffffc9000161fb10 EFLAGS: 00010286
[  113.919928] RAX: 0000000000000001 RBX: ffff888126469dc8 RCX: ffffffff81146546
[  113.919953] RDX: fffffbfff0b6f8b1 RSI: 0000000000000008 RDI: ffffffff85b7c580
[  113.919978] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffff85b7c587
[  113.920002] R10: fffffbfff0b6f8b0 R11: 0000000000000010 R12: ffffc9000161fbd8
[  113.920027] R13: 0000000000000000 R14: ffffc90001392338 R15: ffffc90009150000
[  113.920052] FS:  00007f7c1fb626c0(0000) GS:ffff8883eee00000(0000) knlGS:0000000000000000
[  113.920078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.920102] CR2: ffffc90009150000 CR3: 00000001395b3006 CR4: 0000000000772ef0
[  113.920127] PKRU: 55555554
[  113.920149] note: a.out[954] exited with irqs disabled

KVM_SET_PMU_EVENT_FILTER:

[  640.826721] ==================================================================
[  640.826725] BUG: KASAN: slab-use-after-free in rcuwait_wake_up+0x47/0x160
[  640.826731] Read of size 8 at addr ffff888149545260 by task a.out/952

[  640.826735] CPU: 1 PID: 952 Comm: a.out Not tainted 6.3.0-kasan+ #8
[  640.826738] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[  640.826740] Call Trace:
[  640.826741]  <TASK>
[  640.826743]  dump_stack_lvl+0x57/0x90
[  640.826746]  print_report+0xcf/0x640
[  640.826749]  ? _raw_spin_lock_irqsave+0x5b/0x60
[  640.826752]  ? __virt_addr_valid+0xd5/0x150
[  640.826757]  kasan_report+0xc1/0xf0
[  640.826759]  ? rcuwait_wake_up+0x47/0x160
[  640.826762]  ? rcuwait_wake_up+0x47/0x160
[  640.826767]  rcuwait_wake_up+0x47/0x160
[  640.826770]  kvm_make_vcpu_request+0x59/0x120 [kvm]
[  640.826828]  kvm_make_all_cpus_request_except+0x11d/0x1e0 [kvm]
[  640.826882]  ? kvm_make_vcpus_request_mask+0x160/0x160 [kvm]
[  640.826935]  kvm_vm_ioctl_set_pmu_event_filter+0x484/0x540 [kvm]
[  640.827003]  ? kvm_pmu_destroy+0x20/0x20 [kvm]
[  640.827069]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827130]  ? kvm_arch_vm_ioctl+0x751/0xf20 [kvm]
[  640.827191]  kvm_arch_vm_ioctl+0x751/0xf20 [kvm]
[  640.827251]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827311]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827378]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827456]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827533]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827611]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  640.827688]  ? __lock_acquire+0x9ed/0x3210
[  640.827695]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  640.827699]  ? lock_acquire+0x159/0x3b0
[  640.827703]  ? find_held_lock+0x83/0xa0
[  640.827706]  ? mark_lock+0xf4/0xce0
[  640.827709]  ? mark_lock+0xf4/0xce0
[  640.827712]  ? print_usage_bug.part.0+0x3b0/0x3b0
[  640.827716]  ? mark_lock+0xf4/0xce0
[  640.827718]  ? mark_lock+0xf4/0xce0
[  640.827721]  ? print_usage_bug.part.0+0x3b0/0x3b0
[  640.827724]  ? mark_lock+0xf4/0xce0
[  640.827727]  ? print_usage_bug.part.0+0x3b0/0x3b0
[  640.827730]  ? print_usage_bug.part.0+0x3b0/0x3b0
[  640.827734]  ? __lock_acquire+0x9ed/0x3210
[  640.827740]  ? __lock_acquire+0x9ed/0x3210
[  640.827744]  ? mark_lock+0xf4/0xce0
[  640.827747]  ? mark_lock+0xf4/0xce0
[  640.827749]  ? mark_lock+0xf4/0xce0
[  640.827753]  ? kvm_vm_ioctl+0xc12/0x1370 [kvm]
[  640.827831]  ? mark_lock+0xf4/0xce0
[  640.827834]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  640.827912]  kvm_vm_ioctl+0xc12/0x1370 [kvm]
[  640.827989]  ? __lock_acquire+0x9ed/0x3210
[  640.827993]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  640.828071]  ? __lock_acquire+0x9ed/0x3210
[  640.828074]  ? __lock_acquire+0x9ed/0x3210
[  640.828079]  ? find_held_lock+0x83/0xa0
[  640.828083]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  640.828085]  ? lock_release+0x214/0x3a0
[  640.828088]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  640.828092]  ? do_vfs_ioctl+0xb45/0xc40
[  640.828096]  ? vfs_fileattr_set+0x480/0x480
[  640.828099]  ? find_held_lock+0x83/0xa0
[  640.828102]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  640.828105]  ? selinux_bprm_creds_for_exec+0x440/0x440
[  640.828110]  ? __fget_files+0x146/0x200
[  640.828115]  __x64_sys_ioctl+0xb8/0xf0
[  640.828119]  do_syscall_64+0x56/0x80
[  640.828122]  ? do_syscall_64+0x62/0x80
[  640.828124]  ? do_syscall_64+0x62/0x80
[  640.828126]  ? do_syscall_64+0x62/0x80
[  640.828129]  ? do_syscall_64+0x62/0x80
[  640.828131]  ? do_syscall_64+0x62/0x80
[  640.828133]  ? lockdep_hardirqs_on+0x7d/0x100
[  640.828137]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  640.828141] RIP: 0033:0x7f3cf47d7d6f
[  640.828144] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  640.828150] RSP: 002b:00007f3cf46d2e50 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  640.828154] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f3cf47d7d6f
[  640.828155] RDX: 00007f3cf46d2eb0 RSI: 000000004020aeb2 RDI: 0000000000000004
[  640.828157] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffe55a966a7
[  640.828159] R10: 00007f3cf46efc38 R11: 0000000000000246 R12: ffffffffffffff80
[  640.828160] R13: 0000000000000000 R14: 00007ffe55a965b0 R15: 00007f3cf3ed3000
[  640.828166]  </TASK>

[  640.828168] Allocated by task 949:
[  640.828183]  kasan_save_stack+0x1c/0x40
[  640.828186]  kasan_set_track+0x21/0x30
[  640.828189]  __kasan_slab_alloc+0x7d/0x80
[  640.828191]  kmem_cache_alloc+0x16f/0x370
[  640.828194]  kvm_vm_ioctl+0x7de/0x1370 [kvm]
[  640.828272]  __x64_sys_ioctl+0xb8/0xf0
[  640.828275]  do_syscall_64+0x56/0x80
[  640.828277]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  640.828281] Freed by task 949:
[  640.828282]  kasan_save_stack+0x1c/0x40
[  640.828285]  kasan_set_track+0x21/0x30
[  640.828288]  kasan_save_free_info+0x2a/0x40
[  640.828290]  ____kasan_slab_free+0x165/0x1c0
[  640.828293]  slab_free_freelist_hook+0xef/0x220
[  640.828295]  kmem_cache_free+0xdb/0x330
[  640.828298]  kvm_vm_ioctl+0xb6c/0x1370 [kvm]
[  640.828375]  __x64_sys_ioctl+0xb8/0xf0
[  640.828378]  do_syscall_64+0x56/0x80
[  640.828380]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  640.828384] The buggy address belongs to the object at ffff888149545180
                which belongs to the cache kvm_vcpu of size 10176
[  640.828386] The buggy address is located 224 bytes inside of
                freed 10176-byte region [ffff888149545180, ffff888149547940)

[  640.828389] The buggy address belongs to the physical page:
[  640.828390] page:00000000d55e5c1a refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x149540
[  640.828393] head:00000000d55e5c1a order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  640.828395] memcg:ffff88812110b441
[  640.828396] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[  640.828399] page_type: 0xffffffff()
[  640.828402] raw: 0017ffffc0010200 ffff888120164640 ffffea00042b5400 dead000000000002
[  640.828404] raw: 0000000000000000 0000000000030003 00000001ffffffff ffff88812110b441
[  640.828405] page dumped because: kasan: bad access detected

[  640.828408] Memory state around the buggy address:
[  640.828409]  ffff888149545100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  640.828411]  ffff888149545180: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  640.828412] >ffff888149545200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  640.828414]                                                        ^
[  640.828415]  ffff888149545280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  640.828417]  ffff888149545300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  640.828418] ==================================================================
[  640.828429] Disabling lock debugging due to kernel taint

KVM_X86_SET_MSR_FILTER:

==================================================================
[  283.549764] BUG: KASAN: slab-use-after-free in kvm_make_vcpu_request+0x6b/0x120 [kvm]
[  283.549819] Write of size 4 at addr ffff88810a15d1b4 by task a.out/955

[  283.549823] CPU: 6 PID: 955 Comm: a.out Not tainted 6.3.0-kasan+ #8
[  283.549826] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[  283.549828] Call Trace:
[  283.549829]  <TASK>
[  283.549831]  dump_stack_lvl+0x57/0x90
[  283.549835]  print_report+0xcf/0x640
[  283.549838]  ? _raw_spin_lock_irqsave+0x5b/0x60
[  283.549842]  ? __virt_addr_valid+0xd5/0x150
[  283.549846]  kasan_report+0xc1/0xf0
[  283.549848]  ? kvm_make_vcpu_request+0x6b/0x120 [kvm]
[  283.549902]  ? kvm_make_vcpu_request+0x6b/0x120 [kvm]
[  283.549956]  kasan_check_range+0x100/0x1b0
[  283.549959]  kvm_make_vcpu_request+0x6b/0x120 [kvm]
[  283.550014]  kvm_make_all_cpus_request_except+0x11d/0x1e0 [kvm]
[  283.550069]  ? kvm_make_vcpus_request_mask+0x160/0x160 [kvm]
[  283.550123]  ? __kmem_cache_free+0xaa/0x2a0
[  283.550127]  kvm_vm_ioctl_set_msr_filter+0x311/0x390 [kvm]
[  283.550187]  ? lockdep_hardirqs_on+0x7d/0x100
[  283.550190]  kvm_arch_vm_ioctl+0x6ac/0xf20 [kvm]
[  283.550252]  ? kvm_make_all_cpus_request_except+0x1a2/0x1e0 [kvm]
[  283.550306]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  283.550378]  ? kvm_make_vcpus_request_mask+0x160/0x160 [kvm]
[  283.550456]  ? __kmem_cache_free+0xaa/0x2a0
[  283.550460]  ? kvm_vm_ioctl_set_msr_filter+0x311/0x390 [kvm]
[  283.550539]  ? kvm_arch_vm_ioctl+0x6ac/0xf20 [kvm]
[  283.550620]  ? kvm_arch_vm_ioctl+0x6ac/0xf20 [kvm]
[  283.550701]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  283.550780]  ? kvm_set_or_clear_apicv_inhibit+0x50/0x50 [kvm]
[  283.550860]  ? __lock_acquire+0x9ed/0x3210
[  283.550866]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  283.550883]  ? mark_lock+0xf4/0xce0
[  283.550888]  kvm_vm_ioctl+0xc12/0x1370 [kvm]
[  283.550968]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  283.551049]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  283.551144]  ? mark_lock+0xf4/0xce0
[  283.551148]  ? __lock_acquire+0x9ed/0x3210
[  283.551153]  ? kvm_unregister_device_ops+0x40/0x40 [kvm]
[  283.551230]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  283.551234]  ? do_vfs_ioctl+0xb45/0xc40
[  283.551238]  ? vfs_fileattr_set+0x480/0x480
[  283.551241]  ? find_held_lock+0x83/0xa0
[  283.551244]  ? lock_release+0x214/0x3a0
[  283.551247]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  283.551251]  ? selinux_bprm_creds_for_exec+0x440/0x440
[  283.551255]  ? __fget_files+0x146/0x200
[  283.551260]  __x64_sys_ioctl+0xb8/0xf0
[  283.551264]  do_syscall_64+0x56/0x80
[  283.551266]  ? blkcg_maybe_throttle_current+0x70/0x690
[  283.551270]  ? __x64_sys_rseq+0x310/0x310
[  283.551273]  ? blkcg_exit_disk+0x30/0x30
[  283.551277]  ? mark_held_locks+0x1a/0x80
[  283.551281]  ? do_syscall_64+0x62/0x80
[  283.551283]  ? lockdep_hardirqs_on+0x7d/0x100
[  283.551285]  ? do_syscall_64+0x62/0x80
[  283.551288]  ? do_syscall_64+0x62/0x80
[  283.551290]  ? lockdep_hardirqs_on+0x7d/0x100
[  283.551292]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  283.551296] RIP: 0033:0x7f0f7f7f6d6f
[  283.551299] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  283.551301] RSP: 002b:00007f0f7f6f1cd0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  283.551304] RAX: ffffffffffffffda RBX: 00007f0f7f6f1d30 RCX: 00007f0f7f7f6d6f
[  283.551306] RDX: 00007f0f7f6f1d30 RSI: 000000004188aec6 RDI: 0000000000000004
[  283.551308] RBP: 0000000000000004 R08: 0000000000000000 R09: 00007ffd35b70d67
[  283.551310] R10: 00007f0f7f70ec38 R11: 0000000000000246 R12: ffffffffffffff80
[  283.551312] R13: 0000000000000000 R14: 00007ffd35b70c70 R15: 00007f0f7eef2000
[  283.551317]  </TASK>

[  283.551319] Allocated by task 952:
[  283.551320]  kasan_save_stack+0x1c/0x40
[  283.551323]  kasan_set_track+0x21/0x30
[  283.551326]  __kasan_slab_alloc+0x7d/0x80
[  283.551328]  kmem_cache_alloc+0x16f/0x370
[  283.551330]  kvm_vm_ioctl+0x7de/0x1370 [kvm]
[  283.551407]  __x64_sys_ioctl+0xb8/0xf0
[  283.551409]  do_syscall_64+0x56/0x80
[  283.551411]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  283.551415] Freed by task 952:
[  283.551416]  kasan_save_stack+0x1c/0x40
[  283.551419]  kasan_set_track+0x21/0x30
[  283.551422]  kasan_save_free_info+0x2a/0x40
[  283.551424]  ____kasan_slab_free+0x165/0x1c0
[  283.551427]  slab_free_freelist_hook+0xef/0x220
[  283.551429]  kmem_cache_free+0xdb/0x330
[  283.551432]  kvm_vm_ioctl+0xb6c/0x1370 [kvm]
[  283.551508]  __x64_sys_ioctl+0xb8/0xf0
[  283.551510]  do_syscall_64+0x56/0x80
[  283.551512]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[  283.551516] The buggy address belongs to the object at ffff88810a15d180
                which belongs to the cache kvm_vcpu of size 10176
[  283.551518] The buggy address is located 52 bytes inside of
                freed 10176-byte region [ffff88810a15d180, ffff88810a15f940)

[  283.551521] The buggy address belongs to the physical page:
[  283.551523] page:00000000ad8bb4b2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10a158
[  283.551525] head:00000000ad8bb4b2 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  283.551527] memcg:ffff88811fefdb81
[  283.551528] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[  283.551531] page_type: 0xffffffff()
[  283.551534] raw: 0017ffffc0010200 ffff888119e0ab40 dead000000000122 0000000000000000
[  283.551536] raw: 0000000000000000 0000000000030003 00000001ffffffff ffff88811fefdb81
[  283.551537] page dumped because: kasan: bad access detected

[  283.551540] Memory state around the buggy address:
[  283.551541]  ffff88810a15d080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  283.551543]  ffff88810a15d100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  283.551544] >ffff88810a15d180: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  283.551546]                                      ^
[  283.551547]  ffff88810a15d200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  283.551549]  ffff88810a15d280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  283.551550] ==================================================================
[  283.551562] Disabling lock debugging due to kernel taint

Michal Luczaj (2):
  KVM: Fix vcpu_array[0] races
  KVM: selftests: Add tests for vcpu_array[0] races

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/vcpu_array_races.c  | 198 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  16 +-
 3 files changed, 209 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/vcpu_array_races.c

-- 
2.40.1

