Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C933A1B27A3
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 15:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgDUNXg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 Apr 2020 09:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbgDUNXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 09:23:34 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207389] New: Regression in nested SVM from 5.7-rc1, starting L2
 guest locks up L1
Date:   Tue, 21 Apr 2020 13:23:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: s.reiter@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207389-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207389

            Bug ID: 207389
           Summary: Regression in nested SVM from 5.7-rc1, starting L2
                    guest locks up L1
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.7-rc1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: s.reiter@proxmox.com
        Regression: No

With 5.7-rc1 (and subsequent, also tested on 5.7-rc2) starting an L2 guest from
an L1 (w/ kernel 5.4.30) almost immediately hangs the L1 with CPU lockups
(example below, stacktraces in the guest differ everytime, but always seem to
end at load_new_mm_cr3 or some tlb flushing). Host sees nothing in logs,
killing the VM and restarting it works.

I've successfully bisected the bug to this commit:
b518ba9fa691 KVM: nSVM: implement check_nested_events for interrupts

Consistently reproducible on my system (AMD 3960X), L0/L1 as described above,
L2 doesn't matter, it mostly already crashes in SeaBIOS.


# grep -H '' /sys/module/kvm/parameters/*
/sys/module/kvm/parameters/enable_vmware_backdoor:N
/sys/module/kvm/parameters/force_emulation_prefix:N
/sys/module/kvm/parameters/halt_poll_ns:0
/sys/module/kvm/parameters/halt_poll_ns_grow:2
/sys/module/kvm/parameters/halt_poll_ns_grow_start:10000
/sys/module/kvm/parameters/halt_poll_ns_shrink:0
/sys/module/kvm/parameters/ignore_msrs:Y
/sys/module/kvm/parameters/kvmclock_periodic_sync:Y
/sys/module/kvm/parameters/lapic_timer_advance_ns:-1
/sys/module/kvm/parameters/min_timer_period_us:200
/sys/module/kvm/parameters/mmu_audit:N
/sys/module/kvm/parameters/nx_huge_pages:N
/sys/module/kvm/parameters/nx_huge_pages_recovery_ratio:60
/sys/module/kvm/parameters/pi_inject_timer:1
/sys/module/kvm/parameters/report_ignored_msrs:N
/sys/module/kvm/parameters/tsc_tolerance_ppm:250
/sys/module/kvm/parameters/vector_hashing:Y

# grep -H '' /sys/module/kvm_amd/parameters/*
/sys/module/kvm_amd/parameters/avic:1  # (Note: Disabling AVIC doesn't change
the outcome, I tried this after seeing the commit was interrupt related)
/sys/module/kvm_amd/parameters/dump_invalid_vmcb:N
/sys/module/kvm_amd/parameters/nested:1
/sys/module/kvm_amd/parameters/npt:1
/sys/module/kvm_amd/parameters/nrips:1
/sys/module/kvm_amd/parameters/pause_filter_count:3000
/sys/module/kvm_amd/parameters/pause_filter_count_grow:2
/sys/module/kvm_amd/parameters/pause_filter_count_max:65535
/sys/module/kvm_amd/parameters/pause_filter_count_shrink:0
/sys/module/kvm_amd/parameters/pause_filter_thresh:128
/sys/module/kvm_amd/parameters/sev:0
/sys/module/kvm_amd/parameters/vgif:1
/sys/module/kvm_amd/parameters/vls:1

Log example from L1:

[  228.112063] watchdog: BUG: soft lockup - CPU#6 stuck for 22s! [kvm:4676]
[  228.112190] CPU: 3 PID: 1811 Comm: kworker/3:5 Tainted: P           OE    
5.4.30-1-pve #1
[  228.112771] Modules linked in: veth(E) ceph(E) libceph(E) fscache(E)
ebtable_filter(E) ebtables(E) ip_set(E) ip6table_raw(E) iptable_raw(E)
ip6table_filter(E) ip6_tables(E) sctp(E) iptable_filter(E) bpfilter(E)
softdog(E) nfnetlink_log(E) nfnetlink(E) kvm_amd(E) ccp(E) kvm(E)
crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) qxl(E)
aesni_intel(E) ttm(E) crypto_simd(E) cryptd(E) drm_kms_helper(E) input_leds(E)
glue_helper(E) joydev(E) pcspkr(E) serio_raw(E) drm(E) fb_sys_fops(E)
syscopyarea(E) sysfillrect(E) sysimgblt(E) qemu_fw_cfg(E) mac_hid(E)
vhost_net(E) vhost(E) tap(E) ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E)
sunrpc(E) iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E)
virtio_rng(E) ip_tables(E) x_tables(E) autofs4(E) zfs(POE) zunicode(POE)
zlua(POE) zavl(POE) icp(POE) zcommon(POE) znvpair(POE) spl(OE) btrfs(E) xor(E)
zstd_compress(E) raid6_pq(E) libcrc32c(E) hid_generic(E) usbhid(E) hid(E)
ahci(E) libahci(E) psmouse(E) i2c_i801(E) virtio_net(E)
[  228.112801]  net_failover(E)
[  228.113333] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0
02/06/2015
[  228.117425]  lpc_ich(E) virtio_scsi(E) failover(E)
[  228.118061] Workqueue: events drm_fb_helper_dirty_work [drm_kms_helper]
[  228.118686] CPU: 6 PID: 4676 Comm: kvm Tainted: P           OE    
5.4.30-1-pve #1
[  228.119321] RIP: 0010:smp_call_function_many+0x200/0x270
[  228.119942] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0
02/06/2015
[  228.119947] RIP: 0010:smp_call_function_single+0xe4/0x110
[  228.120583] Code: c7 e8 b4 aa 98 00 3b 05 02 16 70 01 0f 83 9a fe ff ff 48
63 d0 48 8b 0b 48 03 0c d5 20 69 05 b2 8b 51 18 83 e2 01 74 0a f3 90 <8b> 51 18
83 e2 01 75 f6 eb c7 48 c7 c2 a0 ca 44 b2 4c 89 fe 89 df
[  228.121209] Code: 8b 4c 24 38 65 48 33 0c 25 28 00 00 00 75 42 c9 c3 48 89
d1 48 89 f2 48 89 e6 e8 57 fe ff ff 8b 54 24 18 83 e2 01 74 0b f3 90 <8b> 54 24
18 83 e2 01 75 f5 eb ca 8b 05 db 67 a4 01 85 c0 0f 85 72
[  228.121845] RSP: 0018:ffffbb7d4e6ebca0 EFLAGS: 00000202 ORIG_RAX:
ffffffffffffff13
[  228.122563] RSP: 0018:ffffbb7d43977ba0 EFLAGS: 00000202 ORIG_RAX:
ffffffffffffff13
[  228.123792] RAX: 0000000000000000 RBX: ffff96806faebcc0 RCX:
ffff96806fa320a0
[  228.123793] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
ffff96806dc29df8
[  228.125042] RAX: 0000000000000000 RBX: 0000000000000006 RCX:
0000000000000830
[  228.125718] RBP: ffffbb7d4e6ebcd8 R08: 0000000000000006 R09:
000000000000003b
[  228.125719] R10: 0000000000000000 R11: 0000000000000008 R12:
ffffffffb0c87700
[  228.126383] RDX: 0000000000000001 RSI: 00000000000000fb RDI:
0000000000000830
[  228.126384] RBP: ffffbb7d43977bf0 R08: 0000000000000000 R09:
ffff96806dc07b80
[  228.127057] R13: 0000000000000000 R14: 0000000000000001 R15:
0000000000000008
[  228.127060] FS:  0000000000000000(0000) GS:ffff96806fac0000(0000)
knlGS:0000000000000000
[  228.127732] R10: ffff96806d157e90 R11: 0000000000000000 R12:
ffffffffb0c87ef0
[  228.128401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.129074] R13: ffff96806fbaa680 R14: 0000000000000001 R15:
ffff96806d157e90
[  228.129748] CR2: 0000558be4e47000 CR3: 000000044ac44000 CR4:
0000000000340ee0
[  228.129751] Call Trace:
[  228.130428] FS:  00007fb5a05fe700(0000) GS:ffff96806fb80000(0000)
knlGS:0000000000000000
[  228.131102]  ? load_new_mm_cr3+0xe0/0xe0
[  228.131773] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.131774] CR2: 00005575d4137378 CR3: 00000003e6056000 CR4:
0000000000340ee0
[  228.132459]  on_each_cpu+0x2d/0x60
[  228.133155] Call Trace:
[  228.133849]  flush_tlb_kernel_range+0x38/0x90
[  228.134553]  ? flush_tlb_func_common.constprop.9+0x230/0x230
[  228.135249]  __purge_vmap_area_lazy+0x7c/0x6d0
[  228.135939]  ? cpumask_next_and+0x1e/0x20
[  228.136614]  ? vunmap_page_range+0x208/0x390
[  228.136615]  free_vmap_area_noflush+0xe1/0xf0
[  228.137283]  smp_call_function_many+0x235/0x270
[  228.137950]  remove_vm_area+0x95/0xa0
[  228.138614]  ? flush_tlb_func_common.constprop.9+0x230/0x230
[  228.139255]  iounmap+0x86/0xb0
[  228.139259]  ttm_bo_kunmap+0x4a/0xd0 [ttm]
[  228.139895]  on_each_cpu_mask+0x28/0x70
[  228.140522]  qxl_bo_kunmap+0x31/0x40 [qxl]
[  228.141141]  ? x86_configure_nx+0x50/0x50
[  228.141752]  qxl_gem_prime_vunmap+0xe/0x10 [qxl]
[  228.142359]  on_each_cpu_cond_mask+0xab/0x140
[  228.142963]  drm_gem_vunmap+0x43/0x50 [drm]
[  228.143538]  ? flush_tlb_func_common.constprop.9+0x230/0x230
[  228.144115]  drm_client_buffer_vunmap+0x1a/0x30 [drm]
[  228.144671]  native_flush_tlb_others+0x62/0x180
[  228.145223]  drm_fb_helper_dirty_work+0x17e/0x190 [drm_kms_helper]
[  228.145760]  kvm_flush_tlb_others+0x8c/0xa0
[  228.146287]  process_one_work+0x20f/0x3d0
[  228.146794]  flush_tlb_mm_range+0xb1/0xe0
[  228.147295]  worker_thread+0x34/0x400
[  228.147789]  tlb_flush_mmu+0xb7/0x140
[  228.148274]  kthread+0x120/0x140
[  228.148755]  tlb_finish_mmu+0x41/0x80
[  228.149231]  ? process_one_work+0x3d0/0x3d0
[  228.149232]  ? kthread_park+0x90/0x90
[  228.149713]  zap_page_range+0x154/0x180
[  228.150189]  ret_from_fork+0x22/0x40
[  228.150653]  ? find_vma+0x1b/0x70
[  228.158814]  __do_sys_madvise+0x82c/0xaa0
[  228.159410]  ? __schedule+0x2ee/0x6f0
[  228.159999]  __x64_sys_madvise+0x1a/0x20
[  228.160581]  ? __x64_sys_madvise+0x1a/0x20
[  228.161167]  do_syscall_64+0x57/0x190
[  228.161731]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  228.162294] RIP: 0033:0x7fb62e6c32d7
[  228.162853] Code: ff ff ff ff c3 48 8b 15 b7 6b 0c 00 f7 d8 64 89 02 b8 ff
ff ff ff eb bc 66 2e 0f 1f 84 00 00 00 00 00 90 b8 1c 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 89 6b 0c 00 f7 d8 64 89 01 48
[  228.164049] RSP: 002b:00007fb5a05f8688 EFLAGS: 00000246 ORIG_RAX:
000000000000001c
[  228.164654] RAX: ffffffffffffffda RBX: 00007fb623665b4c RCX:
00007fb62e6c32d7
[  228.165254] RDX: 0000000000000004 RSI: 0000000000001000 RDI:
00007fb5d748a000
[  228.165849] RBP: 0000000000001000 R08: 00007fb5a05faa40 R09:
0000000000001000
[  228.166437] R10: 0000000000001000 R11: 0000000000000246 R12:
00000000ffffffff
[  228.167025] R13: 00007fb5d748a000 R14: 0000000035c8a000 R15:
00000000ffffffff

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
