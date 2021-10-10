Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9A428038
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 11:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhJJJgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 05:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhJJJgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 05:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D4661074;
        Sun, 10 Oct 2021 09:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633858453;
        bh=qF5p5vASTMQ/14LCzbh68bl3olW1+srm7jt6OtpJqmg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YlOcoL3WMC0zjiv473TUvKpz11NNPBPY9a3GGT4S/y93aCCmwAbDoEey0zhVmuVZ9
         WN9cOZT6GIMY1b1cpW6HQh54b/pITgJpY9+PuGGGnYinTjdUlge8WE2F3uqFid2FF2
         LDsCjDsFHqPVE0hgCSYHVPwPprjPk9mNO0pm2AsNJ1DirfIL9YJUs3uK9KW/jRcdof
         36yXAONC0FhKulhsOP6i3PDhMjvVPQqZR0TuTBUG9RP5B5iw2Kh095JNqmt7LApoos
         Ez8NnqYbYJeanzKm7U1EvM7KW+UBuoBzhe4uxcvJ724mMfauxJh5Im5l9gPdQZifSw
         efEfrxsgpA+Tg==
Received: by mail-vk1-f176.google.com with SMTP id z202so6147362vkd.1;
        Sun, 10 Oct 2021 02:34:13 -0700 (PDT)
X-Gm-Message-State: AOAM5309+Zb5uG4czwrq8AdNAPq6vninWzUScxpUFSInJxO5VUztFC29
        3a46xHjqAJCtTBK9QDM3NI/aqxENVyIMO2S1iDI=
X-Google-Smtp-Source: ABdhPJx9JgFrr6ePF/tCgcw7yXGUjgPYhnOFRXPxWMgraYpmGh0dmtf5oimTGnaYhAGKWmrD9QWFKEMKO272vvasVSM=
X-Received: by 2002:a1f:2a4c:: with SMTP id q73mr429807vkq.8.1633858452384;
 Sun, 10 Oct 2021 02:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032036.2201971-1-atish.patra@wdc.com>
In-Reply-To: <20211008032036.2201971-1-atish.patra@wdc.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Sun, 10 Oct 2021 17:34:01 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRrSS90XO+YGbSJ-smgEPgnHQadGRpcdW2XOQ7QCTFjOA@mail.gmail.com>
Message-ID: <CAJF2gTRrSS90XO+YGbSJ-smgEPgnHQadGRpcdW2XOQ7QCTFjOA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add SBI v0.2 support for KVM
To:     Atish Patra <atish.patra@wdc.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 8, 2021 at 11:20 AM Atish Patra <atish.patra@wdc.com> wrote:
>
> The Supervisor Binary Interface(SBI) specification[1] now defines a
> base extension that provides extendability to add future extensions
> while maintaining backward compatibility with previous versions.
> The new version is defined as 0.2 and older version is marked as 0.1.
>
> This series adds following features to RISC-V Linux KVM.
> 1. Adds support for SBI v0.2 in KVM
> 2. SBI Hart state management extension (HSM) in KVM
> 3. Ordered booting of guest vcpus in guest Linux
>
> This series is based on base KVM series which is already part of the kvm-next[2].
>
> Guest kernel needs to also support SBI v0.2 and HSM extension in Kernel
> to boot multiple vcpus. Linux kernel supports both starting v5.7.
> In absense of that, guest can only boot 1 vcpu.
>
> Changes from v2->v3:
> 1. Rebased on the latest merged kvm series.
> 2. Dropped the reset extension patch because reset extension is not merged in kernel.
> However, my tree[3] still contains it in case anybody wants to test it.
>
> Changes from v1->v2:
> 1. Sent the patch 1 separately as it can merged independently.
> 2. Added Reset extension functionality.
>
> Tested on Qemu and Rocket core FPGA.
>
> [1] https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc
> [2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
> [3] https://github.com/atishp04/linux/tree/kvm_next_sbi_v02_reset
Tested-by: Guo Ren <guoren@kernel.org>

/ # echo o > /proc/sysrq-trigger
[   97.164312] sysrq: Power Off
[   97.177376] reboot: Power down
[   97.189630] machine_power_off, 34.
[   97.209240] sbi_srst_power_off, 528

  # KVM session ended normally.

> [4] https://github.com/atishp04/linux/tree/kvm_next_sbi_v02
Yes, it will hang without your reset patch.

/ # echo o > /proc/sysrq-trigger
[   20.753143] sysrq: Power Off
[   20.766105] reboot: Power down
[   20.777462] machine_power_off, 34.
[   20.789932] default_power_off, 11.
[   41.769217] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   41.803683]  (detected by 0, t=5252 jiffies, g=-191, q=2)
[   41.823503] rcu: All QSes seen, last rcu_sched kthread activity
5252 (4294902728-4294897476), jiffies_till_next_fqs=1, root ->qsmask
0x0
[   41.868656] rcu: rcu_sched kthread starved for 5252 jiffies! g-191
f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
[   41.905574] rcu:     Unless rcu_sched kthread gets sufficient CPU
time, OOM is now expected behavior.
[   41.939434] rcu: RCU grace-period kthread stack dump:
[   41.957946] task:rcu_sched       state:R  running task     stack:
 0 pid:   11 ppid:     2 flags:0x00000000
[   41.994477] Call Trace:
[   42.004217] [<ffffffff807384a8>] __schedule+0x22a/0x500
[   42.024580] [<ffffffff807387d6>] schedule+0x58/0xcc
[   42.042803] [<ffffffff8073cf82>] schedule_timeout+0x68/0xda
[   42.063509] [<ffffffff8006e930>] rcu_gp_fqs_loop+0x22e/0x2de
[   42.084670] [<ffffffff8006f9c4>] rcu_gp_kthread+0xf4/0x118
[   42.105075] [<ffffffff800345ae>] kthread+0x100/0x112
[   42.123564] [<ffffffff80003068>] ret_from_exception+0x0/0xc
[   42.146121] rcu: Stack dump where RCU GP kthread last ran:
[   42.173224] Task dump for CPU 0:
[   42.185784] task:kworker/0:1     state:R  running task     stack:
 0 pid:   13 ppid:     2 flags:0x00000008
[   42.222593] Workqueue: events do_poweroff
[   42.237804] Call Trace:
[   42.247202] [<ffffffff8000487e>] dump_backtrace+0x1c/0x24
[   42.267635] [<ffffffff80039aa6>] sched_show_task+0x156/0x176
[   42.289890] [<ffffffff8072d914>] dump_cpu_task+0x42/0x4c
[   42.309939] [<ffffffff8072e6e2>] rcu_check_gp_kthread_starvation+0xfa/0x112
[   42.337239] [<ffffffff80070e40>] rcu_sched_clock_irq+0x638/0x6ca
[   42.359294] [<ffffffff80076e44>] update_process_times+0xa2/0xca
[   42.381707] [<ffffffff80084cb2>] tick_sched_timer+0x78/0x130
[   42.402984] [<ffffffff800774e2>] __hrtimer_run_queues+0x122/0x186
[   42.427002] [<ffffffff80078198>] hrtimer_interrupt+0xcc/0x1d8
[   42.447506] [<ffffffff805cbe70>] riscv_timer_interrupt+0x32/0x3c
[   42.470831] [<ffffffff8006508e>] handle_percpu_devid_irq+0x80/0x118
[   42.495964] [<ffffffff800601d0>] handle_domain_irq+0x58/0x88
[   42.518874] [<ffffffff803007ce>] riscv_intc_irq+0x36/0x5e
[   42.540270] [<ffffffff80003068>] ret_from_exception+0x0/0xc
[   42.561475] [<ffffffff80364f3e>] univ8250_console_write+0x0/0x2a
[   68.137301] watchdog: BUG: soft lockup - CPU#0 stuck for 45s!
[kworker/0:1:13]
[   68.171330] Modules linked in:
[   68.183426] CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted
5.15.0-rc2-00156-g5ff89d5fae43-dirty #10
[   68.216937] Hardware name: linux,dummy-virt (DT)
[   68.234380] Workqueue: events do_poweroff
[   68.249798] epc : default_power_off+0x22/0x24
[   68.266249]  ra : default_power_off+0x1e/0x24
[   68.283131] epc : ffffffff8072ce4a ra : ffffffff8072ce46 sp :
ffffffd00406bda0
[   68.310349]  gp : ffffffff812e7ad0 tp : ffffffe0016b8000 t0 :
ffffffff812f659f
[   68.337152]  t1 : ffffffff812f6590 t2 : 0000000000000000 s0 :
ffffffd00406bdb0
[   68.364485]  s1 : ffffffff81214950 a0 : 0000000000000016 a1 :
ffffffff81284af0
[   68.391110]  a2 : 0000000000000010 a3 : fffffffffffffffe a4 :
86a924d9b215f000
[   68.418203]  a5 : 86a924d9b215f000 a6 : 0000000000000030 a7 :
ffffffff80364f3e
[   68.445367]  s2 : ffffffe001640a80 s3 : 0000000000000000 s4 :
ffffffe00fa6d0c0
[   68.472728]  s5 : ffffffe00fa70e00 s6 : ffffffe00fa70e05 s7 :
ffffffff81214958
[   68.499914]  s8 : ffffffff8002df26 s9 : ffffffff812e92e8 s10:
ffffffff80034744
[   68.526820]  s11: 0000000000000000 t3 : 0000000000000064 t4 :
ffffffffffffffff
[   68.554701]  t5 : ffffffff812128f8 t6 : ffffffd00406bb08
[   68.574879] status: 0000000000000120 badaddr: 0000000000000000
cause: 8000000000000005
[   68.604540] [<ffffffff8072ce4a>] default_power_off+0x22/0x24
[   68.625675] [<ffffffff8072cecc>] machine_power_off+0x26/0x2e
[   68.646515] [<ffffffff80036c7e>] kernel_power_off+0x66/0x6e
[   68.667518] [<ffffffff8005ba02>] do_poweroff+0xc/0x14
[   68.686739] [<ffffffff8002dd24>] process_one_work+0x13e/0x28a
[   68.707735] [<ffffffff8002deec>] worker_thread+0x7c/0x320
[   68.729517] [<ffffffff800345ae>] kthread+0x100/0x112
[   68.748754] [<ffffffff80003068>] ret_from_exception+0x0/0xc

>
> Atish Patra (5):
> RISC-V: Mark the existing SBI v0.1 implementation as legacy
> RISC-V: Reorganize SBI code by moving legacy SBI to its own file
> RISC-V: Add SBI v0.2 base extension
> RISC-V: Add v0.1 replacement SBI extensions defined in v02
> RISC-V: Add SBI HSM extension in KVM
>
> arch/riscv/include/asm/kvm_vcpu_sbi.h |  33 ++++
> arch/riscv/include/asm/sbi.h          |   9 ++
> arch/riscv/kvm/Makefile               |   4 +
> arch/riscv/kvm/vcpu.c                 |  19 +++
> arch/riscv/kvm/vcpu_sbi.c             | 208 ++++++++++++--------------
> arch/riscv/kvm/vcpu_sbi_base.c        |  73 +++++++++
> arch/riscv/kvm/vcpu_sbi_hsm.c         | 109 ++++++++++++++
> arch/riscv/kvm/vcpu_sbi_legacy.c      | 129 ++++++++++++++++
> arch/riscv/kvm/vcpu_sbi_replace.c     | 136 +++++++++++++++++
> 9 files changed, 608 insertions(+), 112 deletions(-)
> create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
> create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_legacy.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c
>
> --
> 2.31.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv



-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
