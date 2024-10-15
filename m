Return-Path: <kvm+bounces-28839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB3C99DEA4
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DE7D1C2160A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 06:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B03818A956;
	Tue, 15 Oct 2024 06:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="u/1YDoDf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3E4189F43
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 06:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728974589; cv=none; b=hnl6gaonjZOMsusu4X5FV0wD2cwR2OWNWgnFJzb0mzeovb1wqFPpqNRdrXugYImNuH+uq2DppO9cbbSowi6wB//xWzxN/rvvmnjRdUXsCOwm3/CmRhrcGUrIYPlLca08AtefSLvnnh6IfW0aWeduydiKBR3aTWI5Fj5AUAcpRj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728974589; c=relaxed/simple;
	bh=q4pOo0mKq9PHvAzEjAZuBGJwLjJ61GOeJjV0JBSuu0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ltyOgwKB+URhh7M66/mTCRdhyKjgy/Oz7savQ41kPwPG0qThk/LGPTd8krHWtZDeq5FIih76ALdBc00UVkN6lqQa7tAbLantP18kPTKYJRkczJhoo8w/adFAy9wrqyA54+MUpWWppMMQfrY0UJsiQwMVrILfY6nQAcx+TMUpEOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=u/1YDoDf; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a3b463e9b0so10892835ab.3
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 23:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1728974587; x=1729579387; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyYlnfYOujvvEy5NpJ15tZ1d57xVnxV002iUwSLbYqo=;
        b=u/1YDoDflZ3z8/KJlDBBugq3/PUx5GBdjHA3FGjagXCW8fBHm7XKQNEv5h378QW4SW
         XkOFQOin3x/i/fSd23LjVYeOuz5Fa8NHLeHNrHqJzDP5ZOe7dlZfmnlG9fwDSRXNgQga
         nAG6UbhKnYQaf664yYPZcH1+NDU1Fq3d5hHr9HMxSuViozhXavQZZoVMFQojt3Te5wTy
         RD4diIoHulJozY6R9tSKawIZQBNI6TYZGu5PX3uupB5W4uOB0A78HuecG4zSyVaW6eJc
         6pLea2w8Z7a7WfM/v3KUpWs7IFHgEP19bBqpSnjFlvWusdIvVtY662ddnzYMIAMcr+jd
         PvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728974587; x=1729579387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyYlnfYOujvvEy5NpJ15tZ1d57xVnxV002iUwSLbYqo=;
        b=aHqIj8WjOrPDSpCjhE2NR1dFwj4qjUFO0ZmSRhRIsa/XZ2282T4SCywEGLwWvzzuCn
         1kfSKu34eX1NyPvyvW/bpuONOSeyIEilwxDfDNBkwEWn3Yh4mvzP1+c1jeV7Cg/HTuFZ
         oVndk6CE4TywDvL6va2q8ZZm/Bd6r3/C+ng2OiTD3O8de5OEAso+zh3Aapl8uaQt2aTk
         SZz6RCTdqvkm0tuSJ1ZW5UfW208RK5nuqqHXUB2FVqx0HLGqXWu7NtAgvoqbFEsOt9Jn
         RA6HWxk6ut3uGLR3HMkVX2LtD3HJDPl68xQrmIysh1Wc66nn6Jxyg2ZvOX8D5SWXA54+
         8o7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUzObzrB63FwRc+MGuCj+kITWfJOi0BjZ7UcQlmoTdEXiC1uCBuRHtwujekUrNlcmMUeCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRY3Z6fwVDJei6TSgxzeacGXXnTG682tsZapDkEw6duBw50TtI
	47ShEBU4o5rvj5/MIzxdVe+W3t/CEjWg050B/bcEhmRqPb8yBP6opYFAo4eMH9keqH8KISlSKNG
	uhCA5+8LbDLvubmSTzFjJeX0uqyFr6suYK3PGzg==
X-Google-Smtp-Source: AGHT+IGvQbC0/b5Ce2YbvHlkhebuCb+KYoHY5qbt65xUQ/y6bbyBicbUVY5plLRK82lv2VCEPUGhaowNVLFLGqH6YzQ=
X-Received: by 2002:a05:6e02:b44:b0:3a1:f549:7272 with SMTP id
 e9e14a558f8ab-3a3b5fc3bafmr104253155ab.23.1728974587112; Mon, 14 Oct 2024
 23:43:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1728957131.git.zhouquan@iscas.ac.cn>
In-Reply-To: <cover.1728957131.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 15 Oct 2024 12:12:55 +0530
Message-ID: <CAAhSdy1nmpiSfi-9B0ZXS9s6CYs_R9YZfd6rrXNc-BQHucm6ww@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] riscv: Add perf support to collect KVM guest
 statistics from host side
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2024 at 8:28=E2=80=AFAM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Add basic guest support to RISC-V perf, enabling it to distinguish
> whether PMU interrupts occur in the host or the guest, and then
> collect some basic guest information from the host side
> (guest os callchain is not supported for now).
>
> Based on the x86/arm implementation, tested with kvm-riscv.
> test env:
> - host: qemu-9.0.0
> - guest: qemu-9.0.0 --enable-kvm (only start one guest and run top)
>
> -----------------------------------------
> 1) perf kvm top
> ./perf kvm --host --guest \
>   --guestkallsyms=3D/<path-to-kallsyms> \
>   --guestmodules=3D/<path-to-modules> top
>
> PerfTop:      41 irqs/sec  kernel:97.6% us: 0.0% guest kernel: 0.0% guest=
 us: 0.0% exact:  0.0% [250Hz cycles:P],  (all, 4 CPUs)
> -------------------------------------------------------------------------=
------
>
>     64.57%  [kernel]        [k] default_idle_call
>      3.12%  [kernel]        [k] _raw_spin_unlock_irqrestore
>      3.03%  [guest.kernel]  [g] mem_serial_out
>      2.61%  [kernel]        [k] handle_softirqs
>      2.32%  [kernel]        [k] do_trap_ecall_u
>      1.71%  [kernel]        [k] _raw_spin_unlock_irq
>      1.26%  [guest.kernel]  [g] do_raw_spin_lock
>      1.25%  [kernel]        [k] finish_task_switch.isra.0
>      1.16%  [kernel]        [k] do_idle
>      0.77%  libc.so.6       [.] ioctl
>      0.76%  [kernel]        [k] queue_work_on
>      0.69%  [kernel]        [k] __local_bh_enable_ip
>      0.67%  [guest.kernel]  [g] __noinstr_text_start
>      0.64%  [guest.kernel]  [g] mem_serial_in
>      0.41%  libc.so.6       [.] pthread_sigmask
>      0.39%  [kernel]        [k] mem_cgroup_uncharge_skmem
>      0.39%  [kernel]        [k] __might_resched
>      0.39%  [guest.kernel]  [g] _nohz_idle_balance.isra.0
>      0.37%  [kernel]        [k] sched_balance_update_blocked_averages
>      0.34%  [kernel]        [k] sched_balance_rq
>
> 2) perf kvm record
> ./perf kvm --host --guest \
>   --guestkallsyms=3D/<path-to-kallsyms> \
>   --guestmodules=3D/<path-to-modules> record -a sleep 60
>
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 1.292 MB perf.data.kvm (17990 samples) =
]
>
> 3) perf kvm report
> ./perf kvm --host --guest \
>   --guestkallsyms=3D/<path-to-kallsyms> \
>   --guestmodules=3D/<path-to-modules> report -i perf.data.kvm
>
> # Total Lost Samples: 0
> #
> # Samples: 17K of event 'cycles:P'
> # Event count (approx.): 269968947184
> #
> # Overhead  Command          Shared Object            Symbol
> # ........  ...............  .......................  ...................=
...........................
> #
>     61.86%  swapper          [kernel.kallsyms]        [k] default_idle_ca=
ll
>      2.93%  :6463            [guest.kernel.kallsyms]  [g] do_raw_spin_loc=
k
>      2.82%  :6462            [guest.kernel.kallsyms]  [g] mem_serial_out
>      2.11%  sshd             [kernel.kallsyms]        [k] _raw_spin_unloc=
k_irqrestore
>      1.78%  :6462            [guest.kernel.kallsyms]  [g] do_raw_spin_loc=
k
>      1.37%  swapper          [kernel.kallsyms]        [k] handle_softirqs
>      1.36%  swapper          [kernel.kallsyms]        [k] do_idle
>      1.21%  sshd             [kernel.kallsyms]        [k] do_trap_ecall_u
>      1.21%  sshd             [kernel.kallsyms]        [k] _raw_spin_unloc=
k_irq
>      1.11%  qemu-system-ris  [kernel.kallsyms]        [k] do_trap_ecall_u
>      0.93%  qemu-system-ris  libc.so.6                [.] ioctl
>      0.89%  sshd             [kernel.kallsyms]        [k] __local_bh_enab=
le_ip
>      0.77%  qemu-system-ris  [kernel.kallsyms]        [k] _raw_spin_unloc=
k_irqrestore
>      0.68%  qemu-system-ris  [kernel.kallsyms]        [k] queue_work_on
>      0.65%  sshd             [kernel.kallsyms]        [k] handle_softirqs
>      0.44%  :6462            [guest.kernel.kallsyms]  [g] mem_serial_in
>      0.42%  sshd             libc.so.6                [.] pthread_sigmask
>      0.34%  :6462            [guest.kernel.kallsyms]  [g] serial8250_tx_c=
hars
>      0.30%  swapper          [kernel.kallsyms]        [k] finish_task_swi=
tch.isra.0
>      0.29%  swapper          [kernel.kallsyms]        [k] sched_balance_r=
q
>      0.29%  sshd             [kernel.kallsyms]        [k] __might_resched
>      0.26%  swapper          [kernel.kallsyms]        [k] tick_nohz_idle_=
exit
>      0.26%  swapper          [kernel.kallsyms]        [k] sched_balance_u=
pdate_blocked_averages
>      0.26%  swapper          [kernel.kallsyms]        [k] _nohz_idle_bala=
nce.isra.0
>      0.24%  qemu-system-ris  [kernel.kallsyms]        [k] finish_task_swi=
tch.isra.0
>      0.23%  :6462            [guest.kernel.kallsyms]  [g] __noinstr_text_=
start
>
> ---
> Change since v3:
> - Rebased on v6.12-rc3
>
> Change since v2:
> - Rebased on v6.11-rc7
> - Keep the misc type consistent with other architectures as `unsigned lon=
g` (Andrew)
> - Add the same comment for `kvm_arch_pmi_in_guest` as in arm64. (Andrew)
>
> Change since v1:
> - Rebased on v6.11-rc3
> - Fix incorrect misc type (Andrew)
>
> ---
> v3 link:
> https://lore.kernel.org/all/cover.1726126795.git.zhouquan@iscas.ac.cn/
> v2 link:
> https://lore.kernel.org/all/cover.1723518282.git.zhouquan@iscas.ac.cn/
> v1 link:
> https://lore.kernel.org/all/cover.1721271251.git.zhouquan@iscas.ac.cn/
>
> Quan Zhou (2):
>   riscv: perf: add guest vs host distinction
>   riscv: KVM: add basic support for host vs guest profiling
>
>  arch/riscv/include/asm/kvm_host.h   | 10 ++++++++
>  arch/riscv/include/asm/perf_event.h |  6 +++++
>  arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
>  arch/riscv/kvm/Kconfig              |  1 +
>  arch/riscv/kvm/main.c               | 12 +++++++--
>  arch/riscv/kvm/vcpu.c               |  7 ++++++
>  6 files changed, 72 insertions(+), 2 deletions(-)

Please include Reviewed-by tags obtained on previous patch revisions.

Queued this series for Linux-6.13

Regards,
Anup

>
>
> base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
> --
> 2.34.1
>

