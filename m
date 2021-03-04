Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0BE32DDFB
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhCDXrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:47:12 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45700 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233262AbhCDXrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 18:47:08 -0500
X-Greylist: delayed 1986 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2021 18:47:08 EST
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3F09F105BD3;
        Fri,  5 Mar 2021 10:14:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHxAN-00FDz4-8o; Fri, 05 Mar 2021 10:13:59 +1100
Date:   Fri, 5 Mar 2021 10:13:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: Problem With XFS + KVM
Message-ID: <20210304231359.GT4662@dread.disaster.area>
References: <BYAPR04MB4965AAAB580D73E3B03E7E7886979@BYAPR04MB4965.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB4965AAAB580D73E3B03E7E7886979@BYAPR04MB4965.namprd04.prod.outlook.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=2J7IuT7wAAAA:8 a=ID6ng7r3AAAA:8
        a=7-415B0cAAAA:8 a=r7zCAvGXysCvWua5TsEA:9 a=CjuIK1q_8ugA:10
        a=RtgRkGnnZwJf8nmJIBi8:22 a=AkheI1RvQwOzcTXhi5f4:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021 at 10:34:29PM +0000, Chaitanya Kulkarni wrote:
> Hi,
> 
> I'm running fio verification job with XFS formatted file system on 5.12-rc1
> with NVMeOF file backend target inside QEMU test machine.
> 
> I'm getting a following message intermittently it is happening since
> yesterday.
> This can be easily reproduces with runing block tests nvme/011 :-
> 
> nvme/011 (run data verification fio job on NVMeOF file-backed ns) [failed]
>     runtime  270.553s  ...  268.552s
>     something found in dmesg:
>     [  340.781752] run blktests nvme/011 at 2021-03-04 14:22:34
>     [  340.857161] nvmet: adding nsid 1 to subsystem blktests-subsystem-1
>     [  340.890225] nvmet: creating controller 1 for subsystem
> blktests-subsystem-1 for NQN
> nqn.2014-08.org.nvmexpress:uuid:e4cfc949-8f19-4db2-a232-ab360b79204a.
>     [  340.892477] nvme nvme0: Please enable CONFIG_NVME_MULTIPATH for
> full support of multi-port devices.
>     [  340.892937] nvme nvme0: creating 64 I/O queues.
>     [  340.913759] nvme nvme0: new ctrl: "blktests-subsystem-1"
>     [  586.495375] nvme nvme0: Removing ctrl: NQN "blktests-subsystem-1"
>     [  587.766464] ------------[ cut here ]------------
>     [  587.766535] raw_local_irq_restore() called with IRQs enabled
>     [  587.766561] WARNING: CPU: 14 PID: 12543 at
> kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20
>     ...
>     (See '/root/blktests/results/nodev/nvme/011.dmesg' for the entire
> message)
> 
> Please let me know what kind of more details I can provide to resolve
> this issue.
> 
> Here is the dmesg outout :-
> 
>  ------------[ cut here ]------------
> [  587.766535] raw_local_irq_restore() called with IRQs enabled
.....
> [  587.766819] CPU: 14 PID: 12543 Comm: rm Not tainted 5.12.0-rc1nvme+ #165
> [  587.766823] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [  587.766826] RIP: 0010:warn_bogus_irq_restore+0x1d/0x20
> [  587.766831] Code: 24 48 c7 c7 e0 f2 0f 82 e8 80 c3 fb ff 80 3d 15 1c
> 09 01 00 74 01 c3 48 c7 c7 70 6c 10 82 c6 05 04 1c 09 01 01 e8 cc c2 fb
> ff <0f> 0b c3 55 53 44 8b 05 63 b4 0c 01 65 48 8b 1c 25 40 7e 01 00 45
> [  587.766835] RSP: 0018:ffffc900086cf990 EFLAGS: 00010286
> [  587.766840] RAX: 0000000000000000 RBX: 0000000000000003 RCX:
> 0000000000000027
> [  587.766843] RDX: 0000000000000000 RSI: ffff8897d37e8a30 RDI:
> ffff8897d37e8a38
> [  587.766846] RBP: ffff888138764888 R08: 0000000000000001 R09:
> 0000000000000001
> [  587.766848] R10: 000000009f0f619c R11: 00000000b7972d21 R12:
> 0000000000000200
> [  587.766851] R13: 0000000000000001 R14: 0000000000000100 R15:
> 00000000003c0000
> [  587.766855] FS:  00007f6992aec740(0000) GS:ffff8897d3600000(0000)
> knlGS:0000000000000000
> [  587.766858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  587.766860] CR2: 0000000000bcf1c8 CR3: 00000017d29e8000 CR4:
> 00000000003506e0
> [  587.766864] Call Trace:
> [  587.766867]  kvm_wait+0x8c/0x90
> [  587.766876]  __pv_queued_spin_lock_slowpath+0x265/0x2a0
> [  587.766893]  do_raw_spin_lock+0xb1/0xc0
> [  587.766898]  _raw_spin_lock+0x61/0x70
> [  587.766904]  xfs_extent_busy_trim+0x2f/0x200 [xfs]

That looks like a KVM or local_irq_save()/local_irq_restore problem.
kvm_wait() does:

static void kvm_wait(u8 *ptr, u8 val)
{
        unsigned long flags;

        if (in_nmi())
                return;

        local_irq_save(flags);

        if (READ_ONCE(*ptr) != val)
                goto out;

        /*
         * halt until it's our turn and kicked. Note that we do safe halt
         * for irq enabled case to avoid hang when lock info is overwritten
         * in irq spinlock slowpath and no spurious interrupt occur to save us.
         */
        if (arch_irqs_disabled_flags(flags))
                halt();
        else
                safe_halt();

out:
        local_irq_restore(flags);
}

And the warning is coming from the local_irq_restore() call
indicating that interrupts are not disabled when they should be.
The interrupt state is being modified entirely within the kvm_wait()
code here, so none of the high level XFS code has any influence on
behaviour here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
