Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C1C74490D
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 14:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjGAMvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 08:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGAMvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 08:51:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 803553A9E
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 05:51:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DDD42F4;
        Sat,  1 Jul 2023 05:51:44 -0700 (PDT)
Received: from [10.57.28.201] (unknown [10.57.28.201])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 193433F663;
        Sat,  1 Jul 2023 05:50:58 -0700 (PDT)
Message-ID: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
Date:   Sat, 1 Jul 2023 13:50:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        isaku.yamahata@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>
From:   Kristina Martsenko <kristina.martsenko@arm.com>
Subject: KVM CPU hotplug notifier triggers BUG_ON on arm64
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

When I try to online a CPU on arm64 while a KVM guest is running, I hit a
BUG_ON(preemptible()) (as well as a WARN_ON). See below for the full log.

This is on kvmarm/next, but seems to have been broken since 6.3. Bisecting it
points at commit:

  0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")

Thanks,
Kristina

-->8--

/ # /root/lkvm-static run /root/kimgs/Image -c 1 --console virtio -p "earlycon loglevel=9" -d /root/kvm-rootfs/ &
/ #   # lkvm run -k /root/kimgs/Image -m 256 -c 1 --name guest-112

/ # echo 0 > /sys/devices/system/cpu/cpu1/online
[ 2060.783263] psci: CPU1 killed (polled 0 ms)
/ # echo 1 > /sys/devices/system/cpu/cpu1/online
[ 2061.070582] Detected PIPT I-cache on CPU1
[ 2061.070800] GICv3: CPU1: found redistributor 100 region 0:0x000000002f120000
[ 2061.070985] CPU1: Booted secondary processor 0x0000000100 [0x410fd0f0]
[ 2061.071167] ------------[ cut here ]------------
[ 2061.071233] WARNING: CPU: 1 PID: 18 at arch/arm64/kernel/cpufeature.c:3228 this_cpu_has_cap+0x14/0x60
[ 2061.071403] Modules linked in:
[ 2061.071478] CPU: 1 PID: 18 Comm: cpuhp/1 Not tainted 6.4.0-rc3-00072-g192df2aa0113 #80
[ 2061.071606] Hardware name: FVP Base RevC (DT)
[ 2061.071678] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 2061.071807] pc : this_cpu_has_cap+0x14/0x60
[ 2061.071922] lr : cpu_hyp_init_context+0x100/0x168
[ 2061.072028] sp : ffff800082a4bd10
[ 2061.072091] x29: ffff800082a4bd10 x28: 0000000000000000 x27: 0000000000000000
[ 2061.072270] x26: 0000000000000000 x25: ffff8000801227c8 x24: 0000000000000001
[ 2061.072447] x23: ffff800081c94008 x22: ffff80008234c7d0 x21: 0000000000000001
[ 2061.072626] x20: 0000000000000001 x19: ffff800081c958b0 x18: 0000000000000006
[ 2061.072803] x17: 000000040044ffff x16: 00500075b5503510 x15: ffff800082a0b920
[ 2061.072984] x14: 0000000000000000 x13: ffff800082351aa0 x12: 00000000000004a4
[ 2061.073159] x11: 0000000000000001 x10: 0000000000000a60 x9 : ffff800082a4bce0
[ 2061.073337] x8 : ffff000800240ac0 x7 : ffff00087f768040 x6 : ffff80008234b010
[ 2061.073518] x5 : ffff00087f75f970 x4 : 0000000000000000 x3 : ffff80008012c140
[ 2061.073696] x2 : 0000000000000005 x1 : 0000000000000000 x0 : 0000000000000039
[ 2061.073868] Call trace:
[ 2061.073923]  this_cpu_has_cap+0x14/0x60
[ 2061.074038]  _kvm_arch_hardware_enable+0x48/0xa0
[ 2061.074148]  kvm_arch_hardware_enable+0x2c/0x60
[ 2061.074263]  __hardware_enable_nolock+0x40/0x78
[ 2061.074388]  kvm_online_cpu+0x4c/0x6c
[ 2061.074507]  cpuhp_invoke_callback+0x100/0x1f4
[ 2061.074631]  cpuhp_thread_fun+0xac/0x194
[ 2061.074754]  smpboot_thread_fn+0x224/0x248
[ 2061.074893]  kthread+0x114/0x118
[ 2061.074996]  ret_from_fork+0x10/0x20
[ 2061.075104] ---[ end trace 0000000000000000 ]---
[ 2061.075254] ------------[ cut here ]------------
[ 2061.075316] kernel BUG at arch/arm64/kvm/vgic/vgic-init.c:517!
[ 2061.075405] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[ 2061.075503] Modules linked in:
[ 2061.075580] CPU: 1 PID: 18 Comm: cpuhp/1 Tainted: G        W          6.4.0-rc3-00072-g192df2aa0113 #80
[ 2061.075718] Hardware name: FVP Base RevC (DT)
[ 2061.075790] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 2061.075922] pc : kvm_vgic_init_cpu_hardware+0x80/0x84
[ 2061.076061] lr : _kvm_arch_hardware_enable+0x94/0xa0
[ 2061.076169] sp : ffff800082a4bd40
[ 2061.076236] x29: ffff800082a4bd40 x28: 0000000000000000 x27: 0000000000000000
[ 2061.076412] x26: 0000000000000000 x25: ffff8000801227c8 x24: 0000000000000001
[ 2061.076588] x23: ffff800081c94008 x22: ffff80008234c7d0 x21: 0000000000000001
[ 2061.076768] x20: 0000000000000001 x19: ffff800081c958b0 x18: 0000000000000006
[ 2061.076944] x17: 000000040044ffff x16: 00500075b5503510 x15: ffff800082a0b920
[ 2061.077126] x14: 0000000000000000 x13: ffff800082351aa0 x12: 00000000000004a4
[ 2061.077303] x11: 0000000000000001 x10: 0000000000000a60 x9 : ffff800082a4bce0
[ 2061.077479] x8 : ffff000800240ac0 x7 : ffff00087f768040 x6 : ffff80008234b010
[ 2061.077660] x5 : ffff00087f75f970 x4 : 0000000000000001 x3 : ffff800081ca1000
[ 2061.077838] x2 : ffff800081c958c0 x1 : 0000000000000008 x0 : 0000000000000000
[ 2061.078013] Call trace:
[ 2061.078068]  kvm_vgic_init_cpu_hardware+0x80/0x84
[ 2061.078209]  kvm_arch_hardware_enable+0x2c/0x60
[ 2061.078324]  __hardware_enable_nolock+0x40/0x78
[ 2061.078450]  kvm_online_cpu+0x4c/0x6c
[ 2061.078568]  cpuhp_invoke_callback+0x100/0x1f4
[ 2061.078692]  cpuhp_thread_fun+0xac/0x194
[ 2061.078816]  smpboot_thread_fn+0x224/0x248
[ 2061.078955]  kthread+0x114/0x118
[ 2061.079057]  ret_from_fork+0x10/0x20
[ 2061.079199] Code: d50323bf d65f03c0 d53b4220 373ffc80 (d4210000) 
[ 2061.079294] ---[ end trace 0000000000000000 ]---
[ 2061.288961] pstore: backend (efi_pstore) writing error (-5)
[ 2061.289043] note: cpuhp/1[18] exited with irqs disabled
[ 2061.289151] note: cpuhp/1[18] exited with preempt_count 1
[ 2061.289452] ------------[ cut here ]------------
[ 2061.289516] WARNING: CPU: 1 PID: 0 at kernel/context_tracking.c:128 ct_kernel_exit.constprop.0+0x98/0xa0
[ 2061.289712] Modules linked in:
[ 2061.289790] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W          6.4.0-rc3-00072-g192df2aa0113 #80
[ 2061.289928] Hardware name: FVP Base RevC (DT)
[ 2061.290000] pstate: 200003c5 (nzCv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 2061.290131] pc : ct_kernel_exit.constprop.0+0x98/0xa0
[ 2061.290275] lr : ct_idle_enter+0x10/0x1c
[ 2061.290407] sp : ffff800082a0bdd0
[ 2061.290473] x29: ffff800082a0bdd0 x28: 0000000000000000 x27: 0000000000000000
[ 2061.290650] x26: 0000000000000000 x25: ffff000800238000 x24: 0000000000000000
[ 2061.290826] x23: 0000000000000000 x22: ffff000800238000 x21: ffff800082339b48
[ 2061.291006] x20: ffff800082339a40 x19: ffff00087f764a18 x18: 0000000000000006
[ 2061.291185] x17: 0000000000000008 x16: ffff800082b7bff0 x15: ffff800082a4b4d0
[ 2061.291365] x14: 0000000000000059 x13: 0000000000000059 x12: 0000000000000001
[ 2061.291539] x11: 0000000000000001 x10: 0000000000000a60 x9 : ffff800082a0bd30
[ 2061.291715] x8 : ffff000800238ac0 x7 : 0000000000000000 x6 : 000000306bbc2709
[ 2061.291892] x5 : 4000000000000002 x4 : ffff8007fdac9000 x3 : ffff800082a0bdd0
[ 2061.292073] x2 : 4000000000000000 x1 : ffff800081c9ba18 x0 : ffff800081c9ba18
[ 2061.292255] Call trace:
[ 2061.292310]  ct_kernel_exit.constprop.0+0x98/0xa0
[ 2061.292455]  ct_idle_enter+0x10/0x1c
[ 2061.292589]  default_idle_call+0x1c/0x3c
[ 2061.292728]  do_idle+0x20c/0x264
[ 2061.292840]  cpu_startup_entry+0x24/0x2c
[ 2061.292958]  secondary_start_kernel+0x130/0x154
[ 2061.293090]  __secondary_switched+0xb8/0xbc
[ 2061.293214] ---[ end trace 0000000000000000 ]---

