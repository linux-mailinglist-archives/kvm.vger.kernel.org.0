Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A46711458
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 20:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241939AbjEYSgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241876AbjEYSfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 14:35:46 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09634E73
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 11:34:23 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmy-004iL9-2R; Thu, 25 May 2023 20:34:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=XOdnPRfEDDpMwfKFbhHUhttEQLX9uN4kYVfocSXnqp4=; b=YooWEXpfQYqBx
        aoF8UbRKoIZgRjFwdGbE/2Mbz2jtzCKjGjzisbDoxURsDWA/UTz6EM5eLcxxiQkEBNL2u0uVV+s8B
        y2yiN+8VW6iCaamSbDxeEMaIltKON6qyBtgP8/uSxb6Yhm0RbwV0QssD+lSfLDjoMlkSLZE1aVuIZ
        mq3d/YNQ81PQqEVLvzH/PDTk6cZ3Vheg2+Ilss/thhRXxCI1wXBBm0y/kNssSXRzQo9MEiZgnyxDJ
        MpKGv073zbal8oGRAleZA8JIqMu/9wVtJIs7xodTbQgW3GxtZmqk5LJ8qdFH6+6IV6AeI+C/MTPG8
        aX/IVnS3GOAJ6C1F0I75Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmx-0006Wl-Mj; Thu, 25 May 2023 20:34:15 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2Fmr-00047d-Rn; Thu, 25 May 2023 20:34:09 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/3] Out-of-bounds access in kvm_recalculate_phys_map()
Date:   Thu, 25 May 2023 20:33:44 +0200
Message-Id: <20230525183347.2562472-1-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_recalculate_apic_map() creates the APIC map iterating over the list of
vCPUs twice. First to find the max APIC ID and allocate a max-sized buffer,
then again, calling kvm_recalculate_phys_map() for each vCPU. This opens a
race window: value of max APIC ID can increase _after_ the buffer was
allocated.

PATCH 1/3 introduces one more if() to thwart the out-of-bounds access.
PATCH 2/3 attempts to simplify the code touched. Attempts, as I'm really
not sure if the result is actually cleaner.
PATCH 3/3 is a selftest that results in:

[   54.253315] ==================================================================
[   54.253327] BUG: KASAN: slab-out-of-bounds in kvm_recalculate_apic_map+0x3a0/0xa00 [kvm]
[   54.253431] Read of size 8 at addr ffff88814dd99218 by task recalc_apic_map/955

[   54.253431] CPU: 7 PID: 955 Comm: recalc_apic_map Not tainted 6.4.0-rc3-kasan+ #26
[   54.253431] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[   54.253431] Call Trace:
[   54.253431]  <TASK>
[   54.253431]  dump_stack_lvl+0x57/0x90
[   54.253431]  print_report+0xcf/0x640
[   54.253431]  ? _raw_spin_lock_irqsave+0x5b/0x60
[   54.253431]  ? __virt_addr_valid+0xd5/0x150
[   54.253431]  kasan_report+0xc1/0xf0
[   54.253431]  ? kvm_recalculate_apic_map+0x3a0/0xa00 [kvm]
[   54.253431]  ? kvm_recalculate_apic_map+0x3a0/0xa00 [kvm]
[   54.253431]  kvm_recalculate_apic_map+0x3a0/0xa00 [kvm]
[   54.253431]  ? kvm_can_use_hv_timer+0x60/0x60 [kvm]
[   54.253431]  ? kvm_lapic_set_base+0xae/0x4b0 [kvm]
[   54.253431]  ? kasan_set_track+0x21/0x30
[   54.253431]  kvm_apic_set_state+0x1cf/0x5b0 [kvm]
[   54.253431]  kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
[   54.253431]  ? preempt_notifier_unregister+0x29/0x60
[   54.253431]  ? preempt_count_sub+0x14/0xc0
[   54.253431]  ? vcpu_put+0x46/0x60 [kvm]
[   54.253431]  ? kvm_arch_vcpu_put+0x410/0x410 [kvm]
[   54.253431]  ? mark_lock+0xf4/0xce0
[   54.253431]  ? print_usage_bug.part.0+0x3b0/0x3b0
[   54.253431]  ? print_usage_bug.part.0+0x3b0/0x3b0
[   54.253431]  ? mark_lock+0xf4/0xce0
[   54.253431]  ? __lock_acquire+0x9ed/0x3210
[   54.253431]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[   54.253431]  ? mark_lock+0xf4/0xce0
[   54.253431]  ? lock_acquire+0x159/0x3b0
[   54.253431]  ? lock_acquire+0x169/0x3b0
[   54.253431]  ? lock_sync+0x110/0x110
[   54.253431]  ? lock_acquire+0x169/0x3b0
[   54.253431]  ? print_usage_bug.part.0+0x3b0/0x3b0
[   54.253431]  ? mark_lock+0xf4/0xce0
[   54.253431]  ? rcu_is_watching+0x34/0x50
[   54.253431]  ? preempt_count_sub+0x14/0xc0
[   54.253431]  ? __mutex_lock+0x201/0x1040
[   54.253431]  ? kvm_vcpu_ioctl+0x1c6/0x8a0 [kvm]
[   54.253431]  ? kvm_vcpu_ioctl+0x13a/0x8a0 [kvm]
[   54.253431]  ? __mutex_lock+0x201/0x1040
[   54.253431]  ? mutex_lock_io_nested+0xe40/0xe40
[   54.253431]  ? __lock_acquire+0x9ed/0x3210
[   54.253431]  ? kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
[   54.253431]  kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
[   54.253431]  ? kvm_vcpu_kick+0x200/0x200 [kvm]
[   54.253431]  ? vfs_fileattr_set+0x480/0x480
[   54.253431]  ? find_held_lock+0x83/0xa0
[   54.253431]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[   54.253431]  ? selinux_bprm_creds_for_exec+0x440/0x440
[   54.253431]  ? selinux_bprm_creds_for_exec+0x440/0x440
[   54.253431]  ? __fget_files+0x146/0x200
[   54.253431]  __x64_sys_ioctl+0xb8/0xf0
[   54.253431]  do_syscall_64+0x56/0x80
[   54.253431]  ? do_syscall_64+0x62/0x80
[   54.253431]  ? lockdep_hardirqs_on+0x7d/0x100
[   54.253431]  ? do_syscall_64+0x62/0x80
[   54.253431]  ? asm_exc_page_fault+0x22/0x30
[   54.253431]  ? lockdep_hardirqs_on+0x7d/0x100
[   54.253431]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   54.253431] RIP: 0033:0x7f66e4dedd6f
[   54.253431] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[   54.253431] RSP: 002b:00007f66e4ce8a60 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   54.253431] RAX: ffffffffffffffda RBX: 00007f66e4ce8ac0 RCX: 00007f66e4dedd6f
[   54.253431] RDX: 00007f66e4ce8ac0 RSI: 000000004400ae8f RDI: 0000000000000005
[   54.253431] RBP: 0000000000000005 R08: 0000000000000000 R09: 00007ffc7793e4b7
[   54.253431] R10: 00007f66e4d05c38 R11: 0000000000000246 R12: ffffffffffffff80
[   54.253431] R13: 0000000000000000 R14: 00007ffc7793e3c0 R15: 00007f66e44e9000
[   54.253431]  </TASK>

[   54.253431] Allocated by task 955:
[   54.253431]  kasan_save_stack+0x1c/0x40
[   54.253431]  kasan_set_track+0x21/0x30
[   54.253431]  __kasan_kmalloc+0x9e/0xa0
[   54.253431]  __kmalloc_node+0x61/0x160
[   54.253431]  kvm_recalculate_apic_map+0x206/0xa00 [kvm]
[   54.253431]  kvm_apic_set_state+0x1cf/0x5b0 [kvm]
[   54.253431]  kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
[   54.253431]  kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
[   54.253431]  __x64_sys_ioctl+0xb8/0xf0
[   54.253431]  do_syscall_64+0x56/0x80
[   54.253431]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

[   54.253431] The buggy address belongs to the object at ffff88814dd98000
                which belongs to the cache kmalloc-cg-4k of size 4096
[   54.253431] The buggy address is located 1256 bytes to the right of
                allocated 3376-byte region [ffff88814dd98000, ffff88814dd98d30)

[   54.253431] The buggy address belongs to the physical page:
[   54.253431] page:00000000d1f90483 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14dd98
[   54.253431] head:00000000d1f90483 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   54.253431] memcg:ffff888119ce4ac1
[   54.253431] anon flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[   54.253431] page_type: 0xffffffff()
[   54.253431] raw: 0017ffffc0010200 ffff888100050280 0000000000000000 dead000000000001
[   54.253431] raw: 0000000000000000 0000000080040004 00000001ffffffff ffff888119ce4ac1
[   54.253431] page dumped because: kasan: bad access detected

[   54.253431] Memory state around the buggy address:
[   54.253431]  ffff88814dd99100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   54.253431]  ffff88814dd99180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   54.253431] >ffff88814dd99200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   54.253431]                             ^
[   54.253431]  ffff88814dd99280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   54.253431]  ffff88814dd99300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   54.253431] ==================================================================
[   54.255939] Disabling lock debugging due to kernel taint

Michal Luczaj (3):
  KVM: x86: Fix out-of-bounds access in kvm_recalculate_phys_map()
  KVM: x86: Simplify APIC ID selection in kvm_recalculate_phys_map()
  KVM: selftests: Add test for race in kvm_recalculate_apic_map()

 arch/x86/kvm/lapic.c                          |  38 +++---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/recalc_apic_map_race.c         | 110 ++++++++++++++++++
 3 files changed, 127 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c

-- 
2.40.1

