Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA05606528
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiJTP7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiJTP7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:59:32 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1740112AE4
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:59:27 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1olXx6-001Uj9-HY; Thu, 20 Oct 2022 17:59:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=Jm2luoWMr76bBOwgzPKV0iQbsFFu9RoKqYzcwToB4vw=; b=oHeEqY8u2gSnX8awpMQostSlk2
        ZC7EFzsvJg1CrrUKJwnZpQoAbccWMshIWALKywKfSk5Qc99dd250WNGL5bRYlqQyTqND/Y3kVq0Dp
        H/xBhDy1zRBeVU+HKDxDfRcG8qz63Cp1ict8N7hhAbDgroPI3kJE6jVOc0lTh1Fgh3t+hluxmxTkn
        TdOFmDIs/PFv0KVGedlfOtAytzTb6IMRgOztoJMrFDoaYILYKOoWYIyetdksMDnSezyjvUjASXK1v
        YNBpJPoJh2JiI3bqrKatmw1iDGzVij0SW6IsPjVEr+ko0CuaJmyikM675N646gp6m7dmKkfrcyNlz
        BeKXKAQw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1olXx5-0006xy-R8; Thu, 20 Oct 2022 17:59:23 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1olXx3-00061g-Nz; Thu, 20 Oct 2022 17:59:21 +0200
Message-ID: <0574dd3d-4272-fc93-50c0-ba2994e272ba@rbox.co>
Date:   Thu, 20 Oct 2022 17:59:20 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 8/8] KVM: x86: Fix NULL pointer dereference in
 kvm_xen_set_evtchn_fast()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-9-mhal@rbox.co> <Y0SquPNxS5AOGcDP@google.com>
 <Y0daPIFwmosxV/NO@google.com> <Y0h0/x3Fvn17zVt6@google.com>
From:   Michal Luczaj <mhal@rbox.co>
Content-Language: en-US, en-GB
In-Reply-To: <Y0h0/x3Fvn17zVt6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/22 22:28, Sean Christopherson wrote:
> On Thu, Oct 13, 2022, Sean Christopherson wrote:
>> On Mon, Oct 10, 2022, Sean Christopherson wrote:
>>> On Wed, Sep 21, 2022, Michal Luczaj wrote:
>>> If this fixes things on your end (I'll properly test tomorrow too), I'll post a
>>> v2 of the entire series.  There are some cleanups that can be done on top, e.g.
>>> I think we should drop kvm_gpc_unmap() entirely until there's actually a user,
>>> because it's not at all obvious that it's (a) necessary and (b) has desirable
>>> behavior.
>>
>> Sorry for the delay, I initially missed that you included a selftest for the race
>> in the original RFC.  The kernel is no longer exploding, but the test is intermittently
>> soft hanging waiting for the "IRQ".  I'll debug and hopefully post tomorrow.
> 
> Ended up being a test bug (technically).  KVM drops the timer IRQ if the shared
> info page is invalid.  As annoying as that is, there's isn't really a better
> option, and invalidating a shared page while vCPUs are running really is a VMM
> bug.
> 
> To fix, I added an intermediate stage in the test that re-arms the timer if the
> IRQ doesn't arrive in a reasonable amount of time.
> 
> Patches incoming...

Sorry for the late reply, I was away.
Thank you for the whole v2 series. And I'm glad you've found my testcase
useful, even if a bit buggy ;)

Speaking about SCHEDOP_poll, are XEN vmcalls considered trusted?
I've noticed that kvm_xen_schedop_poll() fetches guest-provided
sched_poll.ports without checking if the values are sane. Then, in
wait_pending_event(), there's test_bit(ports[i], pending_bits) which
(for some high ports[i] values) results in KASAN complaining about
"use-after-free":

[   36.463417] ==================================================================
[   36.463564] BUG: KASAN: use-after-free in kvm_xen_hypercall+0xf39/0x1110 [kvm]
[   36.463962] Read of size 8 at addr ffff88815b87b800 by task xen_shinfo_test/956
[   36.464149] CPU: 1 PID: 956 Comm: xen_shinfo_test Not tainted 6.1.0-rc1-kasan+ #49
[   36.464252] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.0-3-3 04/01/2014
[   36.464259] Call Trace:
[   36.464259]  <TASK>
[   36.464259]  dump_stack_lvl+0x5b/0x73
[   36.464259]  print_report+0x17f/0x477
[   36.464259]  ? __virt_addr_valid+0xd5/0x150
[   36.464259]  ? kvm_xen_hypercall+0xf39/0x1110 [kvm]
[   36.464259]  ? kvm_xen_hypercall+0xf39/0x1110 [kvm]
[   36.464259]  kasan_report+0xbb/0xf0
[   36.464259]  ? kvm_xen_hypercall+0xf39/0x1110 [kvm]
[   36.464259]  kasan_check_range+0x136/0x1b0
[   36.464259]  kvm_xen_hypercall+0xf39/0x1110 [kvm]
[   36.464259]  ? kvm_xen_set_evtchn.part.0+0x190/0x190 [kvm]
[   36.464259]  ? get_kvmclock+0x86/0x360 [kvm]
[   36.464259]  ? pvclock_clocksource_read+0x13a/0x190
[   36.464259]  kvm_emulate_hypercall+0x1d7/0x860 [kvm]
[   36.464259]  ? get_kvmclock+0x151/0x360 [kvm]
[   36.464259]  ? kvm_fast_pio+0x260/0x260 [kvm]
[   36.464259]  ? kvm_post_set_cr4+0xf0/0xf0 [kvm]
[   36.464259]  ? lock_release+0x9c/0x430
[   36.464259]  ? rcu_qs+0x2b/0xb0
[   36.464259]  ? rcu_note_context_switch+0x18e/0x9b0
[   36.464259]  ? rcu_read_lock_sched_held+0x10/0x70
[   36.464259]  ? lock_acquire+0xb1/0x3d0
[   36.464259]  ? vmx_vmexit+0x6c/0x19d [kvm_intel]
[   36.464259]  ? vmx_vmexit+0x8d/0x19d [kvm_intel]
[   36.464259]  ? rcu_read_lock_sched_held+0x10/0x70
[   36.464259]  ? lock_acquire+0xb1/0x3d0
[   36.464259]  ? lock_downgrade+0x380/0x380
[   36.464259]  ? vmx_vcpu_run+0x5bf/0x1260 [kvm_intel]
[   36.464259]  vmx_handle_exit+0x295/0xa50 [kvm_intel]
[   36.464259]  vcpu_enter_guest.constprop.0+0x1436/0x1ed0 [kvm]
[   36.464259]  ? kvm_check_and_inject_events+0x800/0x800 [kvm]
[   36.464259]  ? lock_downgrade+0x380/0x380
[   36.464259]  ? __blkcg_punt_bio_submit+0xd0/0xd0
[   36.464259]  ? kvm_arch_vcpu_ioctl_run+0xa46/0xf70 [kvm]
[   36.464259]  ? unlock_page_memcg+0x1e0/0x1e0
[   36.464259]  ? __local_bh_enable_ip+0x8f/0x100
[   36.464259]  ? trace_hardirqs_on+0x2d/0xf0
[   36.464259]  ? fpu_swap_kvm_fpstate+0xbd/0x1c0
[   36.464259]  ? kvm_arch_vcpu_ioctl_run+0x418/0xf70 [kvm]
[   36.464259]  kvm_arch_vcpu_ioctl_run+0x418/0xf70 [kvm]
[   36.464259]  kvm_vcpu_ioctl+0x332/0x8f0 [kvm]
[   36.464259]  ? kvm_clear_dirty_log_protect+0x430/0x430 [kvm]
[   36.464259]  ? do_vfs_ioctl+0x951/0xbf0
[   36.464259]  ? vfs_fileattr_set+0x480/0x480
[   36.464259]  ? kernel_write+0x360/0x360
[   36.464259]  ? selinux_inode_getsecctx+0x50/0x50
[   36.464259]  ? ioctl_has_perm.constprop.0.isra.0+0x133/0x200
[   36.464259]  ? selinux_inode_getsecctx+0x50/0x50
[   36.464259]  ? ksys_write+0xc4/0x140
[   36.464259]  ? __ia32_sys_read+0x40/0x40
[   36.464259]  ? lockdep_hardirqs_on_prepare+0xe/0x220
[   36.464259]  __x64_sys_ioctl+0xb8/0xf0
[   36.464259]  do_syscall_64+0x55/0x80
[   36.464259]  ? lockdep_hardirqs_on_prepare+0xe/0x220
[   36.464259]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   36.464259] RIP: 0033:0x7f81e303ec6b
[   36.464259] Code: 73 01 c3 48 8b 0d b5 b1 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b1 1b 00 f7 d8 64 89 01 48
[   36.464259] RSP: 002b:00007fff72009028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   36.464259] RAX: ffffffffffffffda RBX: 00007f81e33936c0 RCX: 00007f81e303ec6b
[   36.464259] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
[   36.464259] RBP: 00000000008457b0 R08: 0000000000000000 R09: 00000000004029f6
[   36.464259] R10: 00007f81e31b838b R11: 0000000000000246 R12: 00007f81e33a4000
[   36.464259] R13: 00007f81e33a2000 R14: 0000000000000000 R15: 00007f81e33a3020
[   36.464259]  </TASK>
[   36.464259] The buggy address belongs to the physical page:
[   36.464259] page:00000000d9b176a3 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x1 pfn:0x15b87b
[   36.464259] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
[   36.464259] raw: 0017ffffc0000000 ffffea0005504e48 ffffea00056cf688 0000000000000000
[   36.464259] raw: 0000000000000001 0000000000000000 00000000ffffff7f 0000000000000000
[   36.464259] page dumped because: kasan: bad access detected
[   36.464259] Memory state around the buggy address:
[   36.464259]  ffff88815b87b700: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   36.464259]  ffff88815b87b780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   36.464259] >ffff88815b87b800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   36.464259]                    ^
[   36.464259]  ffff88815b87b880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   36.464259]  ffff88815b87b900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   36.464259] ==================================================================

I can't reproduce it under non-KASAN build, I'm not sure what's going on.

Anyway, here's the testcase, applies after your selftests patches in
https://lore.kernel.org/kvm/20221013211234.1318131-1-seanjc@google.com/

---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 2a5727188c8d..402e3d7b86b0 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -375,6 +375,29 @@ static void guest_code(void)
 	guest_saw_irq = false;
 
 	GUEST_SYNC(24);
+	/* Terminate racer thread */
+
+	GUEST_SYNC(25);
+	/* Test SCHEDOP_poll out-of-bounds read */
+
+	p = (struct sched_poll) {
+		.ports = ports,
+		.nr_ports = 1,
+		.timeout = 1
+	};
+
+	ports[0] = (PAGE_SIZE*2) << 3;
+	for (i = 0; i < 0x1000; i++) {
+		asm volatile("vmcall"
+			     : "=a" (rax)
+			     : "a" (__HYPERVISOR_sched_op),
+			       "D" (SCHEDOP_poll),
+			       "S" (&p)
+			     : "memory");
+		ports[0] += PAGE_SIZE << 3;
+	}
+
+	GUEST_SYNC(26);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -925,6 +948,21 @@ int main(int argc, char *argv[])
 
 				ret = pthread_join(thread, 0);
 				TEST_ASSERT(ret == 0, "pthread_join() failed: %s", strerror(ret));
+
+				/* shinfo juggling done; reset to a valid GFN. */
+				struct kvm_xen_hvm_attr ha = {
+					.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
+					.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE,
+				};
+				vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ha);
+				break;
+
+			case 25:
+				if (verbose)
+					printf("Testing SCHEDOP_poll out-of-bounds read\n");
+				break;
+
+			case 26:
 				goto done;
 
 			case 0x20:
-- 
2.38.0

