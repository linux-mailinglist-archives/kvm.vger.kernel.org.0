Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4792E27E4
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 16:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgLXPQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 10:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgLXPQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 10:16:00 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF6EC061573
        for <kvm@vger.kernel.org>; Thu, 24 Dec 2020 07:15:20 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id t8so2244171iov.8
        for <kvm@vger.kernel.org>; Thu, 24 Dec 2020 07:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=/3KZl3bkzsQuCnLuJDpge3skse2PIs/ieYkboI6XaOw=;
        b=Orgk/HA3vrhT1Y0fNz9pAzUqJuXn7mnuq4TX/MTTAbvmZxyvpZfLO7H5fy491aH6rH
         remxYxm5bvKxkGjrBS7QljyOVyq/ubY7JK1rHnY2ebS02zvueswi5i6QlmyeSFUgEN8S
         xTNU/puRqBOgAK2NDzz+1j8CkjDV1qAIZL0sZUOMaePKpjE68ha5ljrMfcNkoRs+qB9y
         /2C/WpFDm8Nq8MFJFdA64f5kQl6v4s9shVeMSR2hHnWo+TOXXkRVZXEg6z3sjRS7Od+G
         DGJrzrCmA9ty8nxdz5EPVm4+iFSQ2hps4yuwmIb2SbnCLAfeznAVFl8D9X8ByIwszWDa
         28UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=/3KZl3bkzsQuCnLuJDpge3skse2PIs/ieYkboI6XaOw=;
        b=N0UUhVwtwtXLF5e4gOPpml5rMTfEsCqvQ7iWC9Cba3aacffMtccpordjeI//4X1Cb+
         D2LvZB8OZlN1/LFd5h5tObB+8yMaF/YpjuTG29GubrW6JYeE4rmHQ2HlN1KA1EOB0Vd4
         PY6anJdM72/GE9NPZr+vv/q3yyIzz3k6z0G3/AMBRmA2fa1NwfBX/1T1QOzrnLnmPiGH
         Nd4AXjhxMqFshX+x8t/ATLdA349e7Z+svpmBHwK+DsyTdzMlSaeMPvpWyv1eWdw/WB1B
         PuaVcsL4jWP1KA/u+8DJgvxeVpSMwZh+QKVdzsUz86aN9otZmC1Q0ANVGvy650kR8WMY
         HGMA==
X-Gm-Message-State: AOAM531WElbbkjJFg/IPRN8YTL2b4teYLxuSg9i3i8YfxZoo/eHo/nEu
        vwdDpRuEGGcRM+lUKD8H5Y3rGRE+G+VAnS8Hhm2w9FZZPtKHNQ==
X-Google-Smtp-Source: ABdhPJxvGFLNaIFzeCq/c3/RwSu9iK6qOpu2GZlWif4mKYXjW31CFbH1e+nb/4alT+dqh3R+Vfs3g6pxeRx+bYOc8lg=
X-Received: by 2002:a6b:6b18:: with SMTP id g24mr25429030ioc.189.1608822918818;
 Thu, 24 Dec 2020 07:15:18 -0800 (PST)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Thu, 24 Dec 2020 16:15:08 +0100
Message-ID: <CAKXUXMxN05q4hcrQW-mm6EVhiTQ+roesLf0SgkFXOtOVUDOhSA@mail.gmail.com>
Subject: KVM kernel BUG: unable to handle kernel paging request in kvm_kick_cpu
To:     kvm@vger.kernel.org
Cc:     syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear kvm folks, (CC: syzkaller users),

I have encountered the following kernel bug running qemu on my system
(as part of setting up a syzkaller campaign).

kernel version: next-20201123 [can also be triggered on earlier
version, such v5.10]
kernel configuration:

wget https://raw.githubusercontent.com/openSUSE/kernel-source/9753528d001e0ff814f8b6938211bc47a0a2a1d8/config/x86_64/rt
-O .config
make olddefconfig

With the following simple script, I start up the kernel on a simple
debian base image (as used for syzkaller fuzzing) and just observe if
I can run through the systemd initialisation:

>>>
#!/bin/bash

crashes=0
for (( total=1; total<=100; total++ ))
do

timeout --foreground 10 \
  qemu-system-x86_64 -m 2048 -display none -serial stdio -no-reboot
-enable-kvm \
  -cpu host,migratable=off -drive file=$IMAGE/stretch.img,if=virtio \
  -device e1000,netdev=net0 \
  -netdev "user,id=net0,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22" \
  -snapshot -kernel $KERNEL/arch/x86/boot/bzImage \
  -append "earlyprintk=serial panic=-1 console=ttyS0 root=/dev/vda rw
kaslr crashkernel=512M minnowboard_1:eth0:::" -smp 4

RET=$?

if [ "$RET" = "0" ]; then
# echo "crashed!"
crashes=$((crashes+1))
elif [ "$RET" = "124" ]; then
# echo "timed out!"
:
else
# echo "unexpected return"
exit 1
fi

echo "crashes / total = $crashes / $total"

sleep 1

done
<<<

The image at $IMAGE/stretch.img was created as described at
https://github.com/google/syzkaller/blob/master/docs/linux/setup_ubuntu-host_qemu-vm_x86-64-kernel.md.

Side remark: Even if no kernel crash occurs, it fails to reach the
login, but that is unrelated to the reported kernel issue; I just
reduced the kernel config during the investigation to not have
sufficient driver support to actually start up all services
successfully.


In roughly 70 of 100 cases, I hit the following kernel crash:

[    0.474842] BUG: unable to handle page fault for address: ffffffff96044553
[    0.474844] #PF: supervisor write access in kernel mode
[    0.474844] #PF: error_code(0x0003) - permissions violation
[    0.474845] PGD 740c067 P4D 740c067 PUD 740d063 PMD 64001e1
[    0.474847] Oops: 0003 [#1] SMP PTI
[    0.474847] CPU: 1 PID: 34 Comm: kauditd Not tainted
5.10.0-next-20201223-rt #2
[    0.474848] RIP: 0010:kvm_kick_cpu+0x23/0x30
[    0.474848] Code: 1f 84 00 00 00 00 00 66 66 66 66 90 48 63 ff 53
48 c7 c0 78 15 01 00 31 db 48 8b 14 fd 60 84 db 96 0f b7 0c 02 b8 05
00 00 00 <0f> 01 c1 5b c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 48
89 fb
[    0.474849] RSP: 0000:ffffb1428013fbe8 EFLAGS: 00010046
[    0.474850] RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
[    0.474850] RDX: ffff8ff0bfc00000 RSI: ffffffff97699600 RDI: 0000000000000000
[    0.474851] RBP: 0000000000000000 R08: 0000000000000100 R09: ffff8ff0bffd5000
[    0.474851] R10: 303034313d657079 R11: 74203a7469647561 R12: 0000000000000001
[    0.474851] R13: 0000000000000005 R14: 0000000000000000 R15: 00000000000000ed
[    0.474852] FS:  0000000000000000(0000) GS:ffff8ff0bfc80000(0000)
knlGS:0000000000000000
[    0.474852] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.474853] CR2: ffffffff96044553 CR3: 0000000000c64000 CR4: 00000000003506a0
[    0.474853] Call Trace:
[    0.474853]  __pv_queued_spin_unlock_slowpath+0xa1/0xd0
[    0.474854]  __raw_callee_save___pv_queued_spin_unlock_slowpath+0x11/0x20
[    0.474854]  ? univ8250_console_exit+0x20/0x20
[    0.474855]  .slowpath+0x9/0xe
[    0.474855]  _raw_spin_unlock_irqrestore+0xa/0x10
[    0.474855]  serial8250_console_write+0x30c/0x330
[    0.474856]  console_unlock+0x37b/0x4b0
[    0.474856]  vprintk_emit+0xb0/0x170
[    0.474856]  ? audit_log_lost+0x90/0x90
[    0.474857]  printk+0x58/0x6f
[    0.474857]  kauditd_hold_skb.cold.29+0x17/0x1c
[    0.474857]  ? stop_machine_from_inactive_cpu+0x110/0x110
[    0.474858]  kauditd_send_queue+0x10f/0x150
[    0.474858]  kauditd_thread+0x236/0x2c0
[    0.474858]  ? wait_woken+0x80/0x80
[    0.474858]  ? auditd_reset+0x90/0x90
[    0.474859]  kthread+0x116/0x130
[    0.474859]  ? kthread_park+0x80/0x80
[    0.474859]  ret_from_fork+0x22/0x30
[    0.474860] Modules linked in:
[    0.474860] CR2: ffffffff96044553
[    0.474871] ---[ end trace 66ccf77300901455 ]---
[    0.474871] RIP: 0010:kvm_kick_cpu+0x23/0x30
[    0.474872] Code: 1f 84 00 00 00 00 00 66 66 66 66 90 48 63 ff 53
48 c7 c0 78 15 01 00 31 db 48 8b 14 fd 60 84 db 96 0f b7 0c 02 b8 05
00 00 00 <0f> 01 c1 5b c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 48
89 fb
[    0.474873] RSP: 0000:ffffb1428013fbe8 EFLAGS: 00010046
[    0.474873] RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
[    0.474874] RDX: ffff8ff0bfc00000 RSI: ffffffff97699600 RDI: 0000000000000000
[    0.474874] RBP: 0000000000000000 R08: 0000000000000100 R09: ffff8ff0bffd5000
[    0.474875] R10: 303034313d657079 R11: 74203a7469647561 R12: 0000000000000001
[    0.474875] R13: 0000000000000005 R14: 0000000000000000 R15: 00000000000000ed
[    0.474876] FS:  0000000000000000(0000) GS:ffff8ff0bfc80000(0000)
knlGS:0000000000000000
[    0.474876] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.474877] CR2: ffffffff96044553 CR3: 0000000000c64000 CR4: 00000000003506a0
[    0.474877] Kernel panic - not syncing: Fatal exception
[    1.539900] Shutting down cpus with NMI
[    1.539902] Kernel Offset: 0x15000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)


So far, I made the following further observations:

kernel configuration needs to include PARAVIRT_SPINLOCKS = y; if set
to n, the kernel bug is not reproducible.

A kernel configured with make defconfig && make kvmconfig &&
./scripts/config -e PARAVIRT_SPINLOCKS does not show the kernel bug.
So, it requires some further configuration of the kernel configuration
above beyond what is in make defconfig && make kvmconfig &&
./scripts/config -e PARAVIRT_SPINLOCKS to actually trigger.

-smp option of qemu needs to be larger than 1 in the script above; it
is some kind of concurrency bug.

With the script above, the issue only occurs with `timeout
--foreground`, not with timeout (but maybe that is a completely
different issue I just misunderstand in the timeout and qemu
interaction).

Has this issue been observed by others?

Can somebody reproduce this issue here?

Are there certain kernel configurations I should try out to pinpoint
the issue to a certain set of kernel configurations?

Did I miss to mention some further important information for
reproducing and debugging?

Is there anything specific I can do to support debugging and fixing the issue?


Best regards,

Lukas
