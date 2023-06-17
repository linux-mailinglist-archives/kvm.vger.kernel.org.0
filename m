Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEDC733D83
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjFQBw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjFQBwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:52:54 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D433ABC
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:52:52 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33b7f217dd0so65625ab.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686966772; x=1689558772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kEx6innLEQVDjO+KUz6QEj9ltKpqkGjnhR99asCdiUE=;
        b=QphXl/2Kh86Rw8vZwPqdALqpoFTwHim7ppYbqz5YDUCqSUqys9oFCfG65/uyJumyTG
         cqfZYsYQ6BJFBdMXrUoPeAvZzm+zSeYolbHaf8bMswb6Smoa7LBXZpY9WnwU5wcixKhC
         +pFPmqpwFh23N3KPhBH9FkQzPnb9iacCfpU0A3DGZIdwQFRg9dhZUm6zqnmUFwwVmYnq
         JfHRpasniZQSM3GoONU/5RysXbyktl4G/r89iTprm6dSg6ZtSnhg+Z2Liv4dS1BdlwBj
         qokecKVcDIBiJ4VTgu68imILXZ3QxoEBuMg1AYmFGg/WgRSlnKfonbEGogzZDyHHmAAr
         QnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966772; x=1689558772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kEx6innLEQVDjO+KUz6QEj9ltKpqkGjnhR99asCdiUE=;
        b=X732YOo8CUcBuDKVJU5qbT98iOTev0k7zfiQuR2RU8lR8kPOD0IULHTgNadgFe53db
         OdZdSQL58Av3CoXwK+5QZkgmNrIRTaG+r6iVAw6BM/Iwz6ODUfmr1cXS/7dICVsDLtLM
         0yDw+/T2ymxWpNMliv3kLlUOSCT6YMM/djGa6dFthpvz1pzU4wKfhRe8dkrFfjkLBzww
         y5M6zO8EoUKJhrsjckBVj4Ex0x0MOarG1KVx4mIaGw2C60VwjjQrODQ4IisNN5Vldgsr
         MmqUNvBDCBASC/CpEJEqQzPCVJO4Mttz2cNz0umAWt+czX5VipWt6T4pZnsYxmNuewqY
         3MDg==
X-Gm-Message-State: AC+VfDzBV0VRqW4sEpuqN9gUsqFWpZu30OPiIdQ8QxocvBWWQLqzAEaN
        cOmsYIelul6faP3EScpQaIb9nQ==
X-Google-Smtp-Source: ACHHUZ5m8J3/6DvcGTTGPBJNW8eEzUuKY5VG5Eg+bRo+QUZFe3m/BKpP1wvItKQYg6hpHAL4W1efbg==
X-Received: by 2002:a05:6e02:20e4:b0:32f:7831:dea5 with SMTP id q4-20020a056e0220e400b0032f7831dea5mr626341ilv.8.1686966772132;
        Fri, 16 Jun 2023 18:52:52 -0700 (PDT)
Received: from google.com ([2620:15c:183:202:bdb2:a15e:7a58:c3a3])
        by smtp.gmail.com with ESMTPSA id h3-20020a02c723000000b004161fafff97sm6616226jao.136.2023.06.16.18.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:52:51 -0700 (PDT)
Date:   Fri, 16 Jun 2023 19:52:47 -0600
From:   Yu Zhao <yuzhao@google.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com,
        robh+dt@kernel.org, zhangfx@lemote.com
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
Message-ID: <ZI0R76Fx25Q2EThZ@google.com>
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com>
 <20230616082322.GA7323@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616082322.GA7323@alpha.franken.de>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 10:23:22AM +0200, Thomas Bogendoerfer wrote:
> On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> > On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > > James Hogan has become inactive for a long time and leaves KVM for MIPS
> > > orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> > > in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> > > made some contributions in kernel and QEMU. If possible, we want to take
> > > the KVM/MIPS maintainership.
> > >
> > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > ---
> > >  MAINTAINERS | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index bddc79a..5f9c2fd 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -9441,9 +9441,11 @@ F:	arch/arm64/kvm/
> > >  F:	include/kvm/arm_*
> > >
> > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > +M:	Huacai Chen <chenhc@lemote.com>
> > > +M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > >  L:	linux-mips@vger.kernel.org
> > >  L:	kvm@vger.kernel.org
> > > -S:	Orphan
> > > +S:	Maintained
> > >  F:	arch/mips/include/asm/kvm*
> > >  F:	arch/mips/include/uapi/asm/kvm*
> > >  F:	arch/mips/kvm/
> > 
> > Hi,
> > 
> > Is kvm/mips still maintained? Thanks.
> > 
> > I tried v6.4-rc6 and hit the following crash. It seems it has been broken since
> > 
> >   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> >   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >   Date:   Mon Mar 1 16:29:57 2021 +0100
> >   
> >       MIPS: Remove KVM_TE support
> 
> ok, I see what I missed when removing TE support, d'oh. Does the patch
> below fix the issue for you ?

Thanks!

It made some progress but somehow crashed the guest kernel.

$ qemu-system-mips64el --version
QEMU emulator version 7.2.2 (Debian 1:7.2+dfsg-7)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

# w/o KVM

  # malta: working (but slow)

    $ qemu-system-mips64el -nographic -kernel lede-malta-le64-vmlinux-initramfs.elf
    [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version 5.5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
    ...

  # loongson3-virt: hanged

    $ qemu-system-mips64el -M loongson3-virt -m 512m -nographic -kernel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
    [    0.000000] Linux version 6.1.0-9-loongson-3 (debian-kernel@lists.debian.org) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #1 SMP PREEMPT Debian 6.1.27-1 (2023-05-08)
    ...
    [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000009fffffff]

# w/ KVM

  # malta: qemu error

    $ sudo qemu-system-mips64el -M accel=kvm -nographic -kernel lede-malta-le64-vmlinux-initramfs.elf
    qemu-system-mips64el: KVM guest kernels must be linked in useg. Did you forget to enable CONFIG_KVM_GUEST?

  # loongson3-virt: qemu error

    $ sudo qemu-system-mips64el -M loongson3-virt,accel=kvm -m 512m -nographic -kernel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
    qemu-system-mips64el: ../../accel/kvm/kvm-all.c:2310: kvm_init: Assertion `TARGET_PAGE_SIZE <= qemu_real_host_page_size()' failed.
    Aborted

$ qemu-system-mips64el --version
QEMU emulator version 8.0.2 (Debian 1:8.0.2+dfsg-1)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

# w/o KVM

  # malta: no change
  # loongson3-virt: no change

# w/ KVM

  # loongson3-virt: the same qemu error

  # malta: booted very fast but guest crashed:

$ sudo qemu-system-mips64el -M accel=kvm -nographic -kernel lede-malta-le64-vmlinux-initramfs.elf
[    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version 5.5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
[    0.000000] earlycon: uart8250 at I/O port 0x3f8 (options '38400n8')
[    0.000000] bootconsole [uart8250] enabled
[    0.000000] Config serial console: console=ttyS0,38400n8r
[    0.000000] CPU0 revision is: 000d9602 (Cavium Octeon III)
[    0.000000] FPU revision is: 00739600
[    0.000000] Checking for the multiply/shift bug... [    0.000000] no.
[    0.000000] Checking for the daddiu bug... [    0.000000] no.
[    0.000000] MIPS: machine is mti,malta
[    0.000000] Software DMA cache coherency enabled
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 0000000008000000 @ 0000000000000000 (usable)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Primary instruction cache 16kB, VIVT, 8-way, linesize 128 bytes.
[    0.000000] Primary data cache 8kB, 8-way, VIPT, no aliases, linesize 128 bytes
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] percpu: Embedded 18 pages/cpu @80000000011c5000 s33120 r8192 d32416 u73728
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32320
[    0.000000] Kernel command line:  console=ttyS0,38400n8r
[    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.000000] Memory: 114464K/131072K available (4299K kernel code, 322K rwdata, 1168K rodata, 7368K init, 295K bss, 16608K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000]  RCU restricting CPUs from NR_CPUS=2 to nr_cpu_ids=1.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:256
[    0.000000] CPU frequency 1999.99 MHz
[    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911270662 ns
[    0.000007] sched_clock: 32 bits at 999MHz, resolution 1ns, wraps every 2147494911ns
[    0.003394] Console: colour dummy device 80x25
[    0.004942] Calibrating delay loop... 653.72 BogoMIPS (lpj=3268608)
[    0.276221] pid_max: default: 32768 minimum: 301
[    0.277862] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.280038] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.284299] Checking for the daddi bug... [    0.286094] no.
[    0.289633] Brought up 1 CPUs
[    0.292878] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.296595] futex hash table entries: 256 (order: 2, 16384 bytes)
[    0.299743] CPU 0 Unable to handle kernel paging request at virtual address c000000000002002, epc == ffffffff804445d4, ra == ffffffff80444cb8
[    0.303942] Oops[#1]:
[    0.304738] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.9.58 #0
[    0.307060] task: 8000000007c58000 task.stack: 8000000007c54000
[    0.309171] $ 0   : 0000000000000000 0000000000000000 0000000000000042 80000000011cf1a8
[    0.312027] $ 4   : c000000000002000 0000000000000000 0000000000000000 0000000000000001
[    0.314882] $ 8   : 0000000000000006 c000000000002238 0000000e00000030 0000000800000054
[    0.317913] $12   : 0000000004000015 ffffffff80326c1c 0000000000000000 0000000e00000028
[    0.320774] $16   : c000000000002000 0000000000000210 8000000007c57d90 ffffffff8067b730
[    0.323622] $20   : ffffffff80680000 ffffffff806e5298 ffffffff806ae2b0 ffffffff80de0000
[    0.326675] $24   : 0000000000000000 ffffffff8016036c
[    0.329539] $28   : 8000000007c54000 8000000007c57cf0 ffffffff80de0000 ffffffff80444cb8
[    0.332388] Hi    : 0000000000000000
[    0.333656] Lo    : 00000000001b4760
[    0.335001] epc   : ffffffff804445d4 bpf_prepare_filter+0x2c/0x674
[    0.337394] ra    : ffffffff80444cb8 bpf_prog_create+0x9c/0xdc
[    0.339461] Status: 140027e3 KX SX UX KERNEL EXL IE
[    0.341260] Cause : 0080004c (ExcCode 13)
[    0.342683] PrId  : 000d9602 (Cavium Octeon III)
[    0.344321] Modules linked in:
[    0.345617] Process swapper/0 (pid: 1, threadinfo=8000000007c54000, task=8000000007c58000, tls=0000000000000000)
[    0.349216] Stack : ffffffff806ae2b0 c000000000002000 00000000024080c2 0000000000001000
[    0.352066]         c000000000002000 0000000000000210 8000000007c57d90 ffffffff8067b730
[    0.354914]         ffffffff80680000 ffffffff806e5298 ffffffff806ae2b0 ffffffff80de0000
[    0.357959]         ffffffff80de0000 ffffffff80444cb8 ffffffff80680000 0000000000000000
[    0.360809]         ffffffff806a0000 0000000000000000 ffffffff806d4848 ffffffff806cce20
[    0.363664]         ffffffff80680042 ffffffff806dfdb0 ffffffff806a0000 ffffffff806cc1b0
[    0.366714]         ffffffff80680000 ffffffff80680000 ffffffff806cc108 ffffffff80100608
[    0.369591]         0000000000000001 0000000000000000 0000000000000000 ffffffff80555660
[    0.372440]         ffffffff805f6338 ffffffff805f0000 0000000000000061 0000000000000002
[    0.375490]         ffffffff806d4888 000000000004093a 0000000000000061 0000000000000002
[    0.378343]         ...
[    0.379220] Call Trace:
[    0.380111] [<ffffffff804445d4>] bpf_prepare_filter+0x2c/0x674
[    0.382177] [<ffffffff80444cb8>] bpf_prog_create+0x9c/0xdc
[    0.384160] [<ffffffff806cce20>] ptp_classifier_init+0x2c/0x3c
[    0.386465] [<ffffffff806cc1b0>] sock_init+0xa8/0xc0
[    0.388276] [<ffffffff80100608>] do_one_initcall+0xa8/0x180
[    0.390289] [<ffffffff806aede0>] kernel_init_freeable+0x180/0x234
[    0.392482] [<ffffffff8052aa38>] kernel_init+0x10/0x10c
[    0.394372] [<ffffffff801062e8>] ret_from_kernel_thread+0x14/0x1c
[    0.396780] Code: ffb10028  ffb00020  ffbe0060 <90820002> 00808025  304200fe  a0820002  fc800020  64920028
[    0.400307]
[    0.401013] ---[ end trace 7278246801a7bc60 ]---
[    0.402570] Kernel panic - not syncing: Fatal exception
[    0.404311] Rebooting in 1 seconds..
[    2.385408] Reboot failed -- System halted

openwrt/malta: https://downloads.openwrt.org/snapshots/targets/malta/le64/
debian/loongson-3: https://deb.debian.org/debian/dists/sid/main/installer-mips64el/current/images/
debian/malta: not working
