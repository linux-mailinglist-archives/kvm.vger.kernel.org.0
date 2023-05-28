Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92E2713B1D
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 19:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjE1R1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 13:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjE1R07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 13:26:59 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECB8B1
        for <kvm@vger.kernel.org>; Sun, 28 May 2023 10:26:56 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q3KAK-00CUv8-SB; Sun, 28 May 2023 19:26:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=dYvYlL69CdkmAyuMUQGS9XRGjqk7Tjb9aHU7HcEwAro=; b=JMOn+4RJ9QMGmVYlcyVNwrGlJb
        Wg8DoW2hhK8iDyOuzvF4SZo56rlTtmenFF5yhKNGGgaxur9iQDNpcYYs7Jg+cXC0O7WmenN7zPefL
        R+srR36gsTFzn4uHH6ylRZ02GruHbZt6A53fauRaoga++zkoVO+VDDLSi1Hf6lGkdfdkETay4NqJn
        WoeJ9j0MOft1MTEbFxQ1S88+8L3GhaVhHOB5T/AaIFIO1DWGVQcDo6Y4+evbwOoaOQHUVcvZItcu0
        ZMzl7l51f3AVz0IqF2gIrWZ2CnlAtt7laKOGUw4XMz0ha1NUkMS84/br3Xasw+lo8gE0BBb3hOrrQ
        eqXOwPqA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q3KAK-00030g-1X; Sun, 28 May 2023 19:26:48 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q3KAI-0004GN-Rc; Sun, 28 May 2023 19:26:46 +0200
Message-ID: <814baa0c-1eaa-4503-129f-059917365e80@rbox.co>
Date:   Sun, 28 May 2023 19:26:45 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 3/3] KVM: selftests: Add test for race in
 kvm_recalculate_apic_map()
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
References: <20230525183347.2562472-1-mhal@rbox.co>
 <20230525183347.2562472-4-mhal@rbox.co> <ZHFDcUcgvRXB/w/g@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZHFDcUcgvRXB/w/g@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/27/23 01:40, Sean Christopherson wrote:
> All of these open coded ioctl() calls is unnecessary.  Ditto for the fancy
> stuffing, which through trial and error I discovered is done to avoid having
> vCPUs with aliased xAPIC IDs, which would cause KVM to bail before triggering
> the bug.  It's much easier to just create the max number of vCPUs and enable
> x2APIC on all of them.
> ...

Yup, this looks way better, thanks.
(FWIW, the #defines were deliberately named to match enum lapic_mode.)

In somewhat related news, I've hit kvm_recalculate_logical_map()'s
WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic))):

[  464.081627] WARNING: CPU: 2 PID: 958 at arch/x86/kvm/lapic.c:331 kvm_recalculate_apic_map+0x609/0xa00 [kvm]
[  464.081703] Modules linked in: kvm_intel 9p fscache netfs qrtr sunrpc intel_rapl_msr kvm 9pnet_virtio 9pnet intel_rapl_common rapl pcspkr i2c_piix4 drm zram crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ata_generic serio_raw virtio_blk virtio_console pata_acpi fuse qemu_fw_cfg [last unloaded: kvm_intel]
[  464.081778] CPU: 2 PID: 958 Comm: recalc_apic_map Not tainted 6.4.0-rc3-vanilla+ #35
[  464.081782] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[  464.081785] RIP: 0010:kvm_recalculate_apic_map+0x609/0xa00 [kvm]
[  464.081852] Code: 04 0f 84 00 02 00 00 49 8d 7e 24 e8 b1 2d 13 c1 41 8b 56 24 89 d0 83 e2 0f c1 e8 04 c1 e0 10 0f ab d0 39 e8 0f 84 50 fe ff ff <0f> 0b e9 49 fe ff ff 4c 8d a5 b0 02 00 00 4c 89 e7 e8 a1 2e 13 c1
[  464.081855] RSP: 0018:ffffc900015cf6c8 EFLAGS: 00010297
[  464.081860] RAX: 0000000000000001 RBX: ffff888108bb3c00 RCX: dffffc0000000000
[  464.081863] RDX: 0000000000000000 RSI: ffffffffc04875ef RDI: ffff888178a651a4
[  464.081865] RBP: 0000000000000002 R08: 0000000000000000 R09: ffffffff8446e2e7
[  464.081868] R10: fffffbfff088dc5c R11: 0000000000000000 R12: 0000000000000000
[  464.081870] R13: 0000000000000003 R14: ffff888178a65180 R15: ffff8881131b2000
[  464.081873] FS:  00007fade8a9a740(0000) GS:ffff8883eef00000(0000) knlGS:0000000000000000
[  464.081876] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  464.081879] CR2: 00007fade88d0008 CR3: 000000014d68b000 CR4: 0000000000752ee0
[  464.081883] PKRU: 55555554
[  464.081886] Call Trace:
[  464.081888]  <TASK>
[  464.081901]  ? kvm_can_use_hv_timer+0x60/0x60 [kvm]
[  464.081969]  ? queue_delayed_work_on+0x6c/0xa0
[  464.081978]  kvm_apic_set_state+0x1cf/0x5b0 [kvm]
[  464.082050]  kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
[  464.082116]  ? kvm_arch_vcpu_put+0x410/0x410 [kvm]
[  464.082180]  ? mark_lock+0xf4/0xce0
[  464.082185]  ? kvm_arch_vcpu_put+0x410/0x410 [kvm]
[  464.082251]  ? mark_lock+0xf4/0xce0
[  464.082255]  ? preempt_count_sub+0x14/0xc0
[  464.082263]  ? print_usage_bug.part.0+0x3b0/0x3b0
[  464.082269]  ? kvm_arch_vcpu_put+0x410/0x410 [kvm]
[  464.082363]  ? mark_lock+0xf4/0xce0
[  464.082369]  ? __kernel_text_address+0xe/0x30
[  464.082373]  ? unwind_get_return_address+0x2f/0x50
[  464.082382]  ? print_usage_bug.part.0+0x3b0/0x3b0
[  464.082392]  ? __lock_acquire+0x9ed/0x3210
[  464.082404]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  464.082410]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  464.082420]  ? lock_acquire+0x159/0x3b0
[  464.082426]  ? lock_acquire+0x169/0x3b0
[  464.082432]  ? lock_sync+0x110/0x110
[  464.082438]  ? find_held_lock+0x83/0xa0
[  464.082444]  ? lock_release+0x214/0x3a0
[  464.082448]  ? kvm_vcpu_ioctl+0x1c6/0x8a0 [kvm]
[  464.082507]  ? rcu_is_watching+0x34/0x50
[  464.082524]  ? preempt_count_sub+0x14/0xc0
[  464.082527]  ? __mutex_lock+0x201/0x1040
[  464.082532]  ? kvm_vcpu_ioctl+0x13a/0x8a0 [kvm]
[  464.082586]  ? find_held_lock+0x83/0xa0
[  464.082591]  ? kvm_vcpu_ioctl+0x13a/0x8a0 [kvm]
[  464.082648]  ? mutex_lock_io_nested+0xe40/0xe40
[  464.082652]  ? bit_wait_io_timeout+0xc0/0xc0
[  464.082658]  ? kvm_vcpu_ioctl+0x13a/0x8a0 [kvm]
[  464.082720]  ? kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
[  464.082774]  kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
[  464.082831]  ? kvm_vcpu_kick+0x200/0x200 [kvm]
[  464.082884]  ? vfs_fileattr_set+0x480/0x480
[  464.082889]  ? vfs_fileattr_set+0x480/0x480
[  464.082893]  ? rcu_is_watching+0x34/0x50
[  464.082897]  ? kfree+0x107/0x140
[  464.082902]  ? kvm_vcpu_ioctl+0x1d6/0x8a0 [kvm]
[  464.082955]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  464.082961]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x1f0
[  464.082967]  ? selinux_bprm_creds_for_exec+0x440/0x440
[  464.082988]  __x64_sys_ioctl+0xb8/0xf0
[  464.082994]  do_syscall_64+0x56/0x80
[  464.083000]  ? mark_held_locks+0x1a/0x80
[  464.083007]  ? do_syscall_64+0x62/0x80
[  464.083011]  ? lockdep_hardirqs_on+0x7d/0x100
[  464.083015]  ? do_syscall_64+0x62/0x80
[  464.083019]  ? lockdep_hardirqs_on+0x7d/0x100
[  464.083023]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  464.083027] RIP: 0033:0x7fade8b9dd6f
[  464.083031] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  464.083034] RSP: 002b:00007ffffd2d4550 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  464.083038] RAX: ffffffffffffffda RBX: 00007ffffd2d4ae8 RCX: 00007fade8b9dd6f
[  464.083041] RDX: 00007ffffd2d45c0 RSI: 000000004400ae8f RDI: 0000000000000005
[  464.083044] RBP: 0000000000000001 R08: 00000000004150a8 R09: 0000000000415004
[  464.083047] R10: 0000000002268301 R11: 0000000000000246 R12: 00000000022662a0
[  464.083050] R13: 00007ffffd2d4af8 R14: 0000000000421df0 R15: 00007fade8cc0000
[  464.083064]  </TASK>
[  464.083066] irq event stamp: 22889
[  464.083069] hardirqs last  enabled at (22895): [<ffffffff81234ede>] __up_console_sem+0x5e/0x70
[  464.083073] hardirqs last disabled at (22900): [<ffffffff81234ec3>] __up_console_sem+0x43/0x70
[  464.083077] softirqs last  enabled at (22184): [<ffffffff811538cf>] __irq_exit_rcu+0xdf/0x1b0
[  464.083082] softirqs last disabled at (22077): [<ffffffff811538cf>] __irq_exit_rcu+0xdf/0x1b0

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c9b8f16fb23f..1c7f9cf51998 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -117,6 +117,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_race
+TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_warn
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_warn.c b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_warn.c
new file mode 100644
index 000000000000..2845e1d9b865
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_warn.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * recalc_apic_map_warn
+ *
+ * Test for hitting WARN_ON_ONCE() in kvm_recalculate_logical_map().
+ */
+
+#include "processor.h"
+#include "kvm_util.h"
+#include "apic.h"
+
+#define	LAPIC_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
+
+int main(void)
+{
+	struct kvm_lapic_state lapic = {};
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL); /* vcpu_id = 0 */
+	vcpu_set_msr(vcpu, MSR_IA32_APICBASE, LAPIC_X2APIC);
+
+	*(u32 *)(lapic.regs + APIC_ID) = 1 << 24; /* != vcpu_id */
+	*(u32 *)(lapic.regs + APIC_SPIV) = APIC_SPIV_APIC_ENABLED;
+	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &lapic);
+
+	kvm_vm_release(vm);
+
+	return 0;
+}
