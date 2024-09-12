Return-Path: <kvm+bounces-26662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6227A9763C6
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93EB41C235CC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3172318FDAA;
	Thu, 12 Sep 2024 08:00:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAB4189B88;
	Thu, 12 Sep 2024 08:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726128054; cv=none; b=EaYu22EwYYm3M+rPWHm63rJooqZ1sfr/VkE+amn5n/FFqHirOIzelqL6tns/EyLZ4pSVmR3mYP6PcxvDe/9MxIc6MYcBUemRjm9/S4GtgDxWXc1lX/5EjTmn33zav7ZuvjLv8utKp+4f/G1kmWs5mHV3/PoMXV9HZSIXHIWdSp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726128054; c=relaxed/simple;
	bh=/IE5H4qEn0ERo4W5Op+X8VJ/LuEYoF9jATwLBKJd/v0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fOTF+zh9w/7DJx+nv18ggnmZRggzTH8NfdFyWtT11oIkT1/IvV4EjNjvZp1Ud5Ml9FCXuXo+vct4eB4bh8DyNH0VjrSpbIaOYKzlJBSyGZc8w0RMbieCcBXvZuEl/d0kxBbKoiAkOU8rKEc/TNPhEaD1YSIXmfZ3bv8WmeljYvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.111.103.6])
	by APP-01 (Coremail) with SMTP id qwCowACn_aqUn+Jm+Fn9Ag--.7302S2;
	Thu, 12 Sep 2024 16:00:21 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH v3 0/2] riscv: Add perf support to collect KVM guest statistics from host side
Date: Thu, 12 Sep 2024 16:00:18 +0800
Message-Id: <cover.1726126795.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACn_aqUn+Jm+Fn9Ag--.7302S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuw1xJw15CF13uryDCF45KFg_yoW7Gw4fpr
	sxCrsxtr4rAryxXw1Svr1Y9ry5J397XrnxGrnxJ3yrAr4jvaykXwn2gr1xZ3y0qrykKryr
	Xw1vqFy2kas8AFUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1x9NDUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCQ4SBmbifb98twABsf

From: Quan Zhou <zhouquan@iscas.ac.cn>

Add basic guest support to RISC-V perf, enabling it to distinguish
whether PMU interrupts occur in the host or the guest, and then
collect some basic guest information from the host side
(guest os callchain is not supported for now).

Based on the x86/arm implementation, tested with kvm-riscv.
test env:
- host: qemu-9.0.0
- guest: qemu-9.0.0 --enable-kvm (only start one guest and run top)

-----------------------------------------
1) perf kvm top
./perf kvm --host --guest \
  --guestkallsyms=/root/repo/shared/kallsyms \
  --guestmodules=/root/repo/shared/modules top

PerfTop:      41 irqs/sec  kernel:97.6% us: 0.0% guest kernel: 0.0% guest us: 0.0% exact:  0.0% [250Hz cycles:P],  (all, 4 CPUs)
-------------------------------------------------------------------------------

    64.57%  [kernel]        [k] default_idle_call
     3.12%  [kernel]        [k] _raw_spin_unlock_irqrestore
     3.03%  [guest.kernel]  [g] mem_serial_out
     2.61%  [kernel]        [k] handle_softirqs
     2.32%  [kernel]        [k] do_trap_ecall_u
     1.71%  [kernel]        [k] _raw_spin_unlock_irq
     1.26%  [guest.kernel]  [g] do_raw_spin_lock
     1.25%  [kernel]        [k] finish_task_switch.isra.0
     1.16%  [kernel]        [k] do_idle
     0.77%  libc.so.6       [.] ioctl
     0.76%  [kernel]        [k] queue_work_on
     0.69%  [kernel]        [k] __local_bh_enable_ip
     0.67%  [guest.kernel]  [g] __noinstr_text_start
     0.64%  [guest.kernel]  [g] mem_serial_in
     0.41%  libc.so.6       [.] pthread_sigmask
     0.39%  [kernel]        [k] mem_cgroup_uncharge_skmem
     0.39%  [kernel]        [k] __might_resched
     0.39%  [guest.kernel]  [g] _nohz_idle_balance.isra.0
     0.37%  [kernel]        [k] sched_balance_update_blocked_averages
     0.34%  [kernel]        [k] sched_balance_rq

2) perf kvm record
./perf kvm --host --guest \
  --guestkallsyms=/root/repo/shared/kallsyms \
  --guestmodules=/root/repo/shared/modules record -a sleep 60

[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 1.292 MB perf.data.kvm (17990 samples) ]

3) perf kvm report (the data shown here is not complete)
./perf kvm --host --guest \
  --guestkallsyms=/root/repo/shared/kallsyms \
  --guestmodules=/root/repo/shared/modules report -i perf.data.kvm

# Total Lost Samples: 0
#
# Samples: 17K of event 'cycles:P'
# Event count (approx.): 269968947184
#
# Overhead  Command          Shared Object            Symbol                                        
# ........  ...............  .......................  ..............................................
#
    61.86%  swapper          [kernel.kallsyms]        [k] default_idle_call
     2.93%  :6463            [guest.kernel.kallsyms]  [g] do_raw_spin_lock
     2.82%  :6462            [guest.kernel.kallsyms]  [g] mem_serial_out
     2.11%  sshd             [kernel.kallsyms]        [k] _raw_spin_unlock_irqrestore
     1.78%  :6462            [guest.kernel.kallsyms]  [g] do_raw_spin_lock
     1.37%  swapper          [kernel.kallsyms]        [k] handle_softirqs
     1.36%  swapper          [kernel.kallsyms]        [k] do_idle
     1.21%  sshd             [kernel.kallsyms]        [k] do_trap_ecall_u
     1.21%  sshd             [kernel.kallsyms]        [k] _raw_spin_unlock_irq
     1.11%  qemu-system-ris  [kernel.kallsyms]        [k] do_trap_ecall_u
     0.93%  qemu-system-ris  libc.so.6                [.] ioctl
     0.89%  sshd             [kernel.kallsyms]        [k] __local_bh_enable_ip
     0.77%  qemu-system-ris  [kernel.kallsyms]        [k] _raw_spin_unlock_irqrestore
     0.68%  qemu-system-ris  [kernel.kallsyms]        [k] queue_work_on
     0.65%  sshd             [kernel.kallsyms]        [k] handle_softirqs
     0.44%  :6462            [guest.kernel.kallsyms]  [g] mem_serial_in
     0.42%  sshd             libc.so.6                [.] pthread_sigmask
     0.34%  :6462            [guest.kernel.kallsyms]  [g] serial8250_tx_chars
     0.30%  swapper          [kernel.kallsyms]        [k] finish_task_switch.isra.0
     0.29%  swapper          [kernel.kallsyms]        [k] sched_balance_rq
     0.29%  sshd             [kernel.kallsyms]        [k] __might_resched
     0.26%  swapper          [kernel.kallsyms]        [k] tick_nohz_idle_exit
     0.26%  swapper          [kernel.kallsyms]        [k] sched_balance_update_blocked_averages
     0.26%  swapper          [kernel.kallsyms]        [k] _nohz_idle_balance.isra.0
     0.24%  qemu-system-ris  [kernel.kallsyms]        [k] finish_task_switch.isra.0
     0.23%  :6462            [guest.kernel.kallsyms]  [g] __noinstr_text_start
     
---
Change since v2:
- Rebased on v6.11-rc7
- Keep the misc type consistent with other architectures
  as `unsigned long` (Andrew)
- Add the same comment for `kvm_arch_pmi_in_guest`
  as in arm64. (Andrew)

Change since v1:
- Rebased on v6.11-rc3
- Fix incorrect misc type (Andrew)

---
v1 link:
https://lore.kernel.org/all/cover.1721271251.git.zhouquan@iscas.ac.cn/
v2 link:
https://lore.kernel.org/all/cover.1723518282.git.zhouquan@iscas.ac.cn/

Quan Zhou (2):
  riscv: perf: add guest vs host distinction
  riscv: KVM: add basic support for host vs guest profiling

 arch/riscv/include/asm/kvm_host.h   | 10 ++++++++
 arch/riscv/include/asm/perf_event.h |  7 ++++++
 arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
 arch/riscv/kvm/Kconfig              |  1 +
 arch/riscv/kvm/main.c               | 12 +++++++--
 arch/riscv/kvm/vcpu.c               |  7 ++++++
 6 files changed, 73 insertions(+), 2 deletions(-)


base-commit: da3ea35007d0af457a0afc87e84fddaebc4e0b63
-- 
2.34.1


