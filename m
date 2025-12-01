Return-Path: <kvm+bounces-64973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 66450C95730
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 01:31:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B2A45341B73
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 00:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B932E4204E;
	Mon,  1 Dec 2025 00:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RB6X1fAx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31E8A55;
	Mon,  1 Dec 2025 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764549061; cv=none; b=cWNhsJ3UNlrSSIzSojcsSYqQEf37MjhdqAUQHaeavPTghrj9DsAhZHWq8NA0+m0Cf3gE8k1FHnkO62RxJUO1YZ/ADwNub7GQ5crIQDAhsX1i7HenVxx+JONX0V2j8DYsvVEgGYdEBwzcpognuRuhxHIb89bFgAJRp9dgX8SR82A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764549061; c=relaxed/simple;
	bh=e0d1UPxi03h0AozV9+X7CmZKceGti3RSfEqjNkXsT60=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I/v1VEXc6iLnKPZBYzTWgU9J/Kixy+W8ZYK/7XiQTNVkW0ruxbUfXKK7g0cxS89E6G6O9tlU+IBBV1RxGhJVwubczhaBP96F45GhZ3VW1wPVibXYnT4vXeSbS3PdZysoyfLVQfeKb38VWAcJE15BdBR6JWhmIbFwi2+cx4CuAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RB6X1fAx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F1BC4CEFB;
	Mon,  1 Dec 2025 00:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764549060;
	bh=e0d1UPxi03h0AozV9+X7CmZKceGti3RSfEqjNkXsT60=;
	h=From:To:Cc:Subject:Date:From;
	b=RB6X1fAxFkN/0RwTZGmdbkz4+8QbT1jD8e8apWMaI9d4uv43ofqltogWyqdZDGEV6
	 z46CIZya/7/1ho+ah109BI4WlUmeTUuU5dUBqWlGERjI/G+GfK5FSU+d1yy3hXfmEQ
	 EIc4pH8HPPV//9IhYNpc2R/rnebbPdVeQvXC9nOkCNdEGXOSMo2VxUDG7vdw6eSwZ5
	 7EKrsjKfvJt88eTuSb7NtvZjYmkDSKy1pGOoyc+zTLAv+qGoFph6vaRyaDg5qeYP50
	 IoxoCesNknGQwNnF1zBdqxiSRS9Y3RaKQmmG+V4MwhdQ/hA0xMeVCY0nHaLfGrgVQZ
	 QNU+A3Dh+uExQ==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	leobras@redhat.com,
	ajones@ventanamicro.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	corbet@lwn.net
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH V3 0/4] RISC-V: Add PARAVIRT_SPINLOCKS support
Date: Sun, 30 Nov 2025 19:30:37 -0500
Message-Id: <20251201003041.695081-1-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

Paravirtualized spinlocks allow a unfair qspinlock to replace the
ticket-lock or native fair qspinlock implementation with something
virtualization-friendly, for example, halt the virtual CPU rather
than spinning.

You could observe the paravirt qspinlock internal work situation with
/sys/kernel/debug/tracing/trace:

ls /sys/kernel/debug/tracing/events/paravirt/
 enable   filter   pv_kick  pv_wait

echo 1 > /sys/kernel/debug/tracing/events/paravirt/enable
cat /sys/kernel/debug/tracing/trace
 entries-in-buffer/entries-written: 33927/33927   #P:12

                                _-----=> irqs-off/BH-disabled
                               / _----=> need-resched
                              | / _---=> hardirq/softirq
                              || / _--=> preempt-depth
                              ||| / _-=> migrate-disable
                              |||| /     delay
           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
              | |         |   |||||     |         |
             sh-100     [001] d..2.    28.312294: pv_wait: cpu 1 out of wfi
         <idle>-0       [000] d.h4.    28.322030: pv_kick: cpu 0 kick target cpu 1
             sh-100     [001] d..2.    30.982631: pv_wait: cpu 1 out of wfi
         <idle>-0       [000] d.h4.    30.993289: pv_kick: cpu 0 kick target cpu 1
             sh-100     [002] d..2.    44.987573: pv_wait: cpu 2 out of wfi
         <idle>-0       [000] d.h4.    44.989000: pv_kick: cpu 0 kick target cpu 2
         <idle>-0       [003] d.s3.    51.593978: pv_kick: cpu 3 kick target cpu 4
      rcu_sched-15      [004] d..2.    51.595192: pv_wait: cpu 4 out of wfi
lock_torture_wr-115     [004] ...2.    52.656482: pv_kick: cpu 4 kick target cpu 2
lock_torture_wr-113     [002] d..2.    52.659146: pv_wait: cpu 2 out of wfi
lock_torture_wr-114     [008] d..2.    52.659507: pv_wait: cpu 8 out of wfi
lock_torture_wr-114     [008] d..2.    52.663503: pv_wait: cpu 8 out of wfi
lock_torture_wr-113     [002] ...2.    52.666128: pv_kick: cpu 2 kick target cpu 8
lock_torture_wr-114     [008] d..2.    52.667261: pv_wait: cpu 8 out of wfi
lock_torture_wr-114     [009] .n.2.    53.141515: pv_kick: cpu 9 kick target cpu 11
lock_torture_wr-113     [002] d..2.    53.143339: pv_wait: cpu 2 out of wfi
lock_torture_wr-116     [007] d..2.    53.143412: pv_wait: cpu 7 out of wfi
lock_torture_wr-118     [000] d..2.    53.143457: pv_wait: cpu 0 out of wfi
lock_torture_wr-115     [008] d..2.    53.143481: pv_wait: cpu 8 out of wfi
lock_torture_wr-117     [011] d..2.    53.143522: pv_wait: cpu 11 out of wfi
lock_torture_wr-117     [011] ...2.    53.143987: pv_kick: cpu 11 kick target cpu 8
lock_torture_wr-115     [008] ...2.    53.144269: pv_kick: cpu 8 kick target cpu 7

This series is split from [1]. The newest discussion is at [2].

[1]: https://lore.kernel.org/linux-riscv/20231225125847.2778638-1-guoren@kernel.org/
[2]: https://lists.riscv.org/g/tech-prs/message/1211

Changelog:
v3:
 - Rebase on linux-6.18-rc7.
 - Simplify nopvspin usage.

v2:
https://lore.kernel.org/linux-riscv/20241227011011.2331381-1-guoren@kernel.org/
 - Add RFC tag.
 - Using new SBI_EXT_PVLOCK ID.
 - Add virt_spin_lock support.
 - Add nopvspin support.

v1:
https://lore.kernel.org/linux-riscv/20241222033917.1754495-1-guoren@kernel.org/

Guo Ren (Alibaba DAMO Academy) (4):
  RISC-V: paravirt: Add pvqspinlock KVM backend
  RISC-V: paravirt: Add pvqspinlock frontend
  RISC-V: paravirt: pvqspinlock: Add trace point for pv_kick/wait
  RISC-V: paravirt: Support nopvspin to disable PARAVIRT_SPINLOCKS

 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/riscv/Kconfig                            | 12 +++
 arch/riscv/include/asm/Kbuild                 |  1 -
 arch/riscv/include/asm/kvm_vcpu_sbi.h         |  1 +
 arch/riscv/include/asm/qspinlock.h            | 59 +++++++++++++
 arch/riscv/include/asm/qspinlock_paravirt.h   | 28 +++++++
 arch/riscv/include/asm/sbi.h                  |  5 ++
 arch/riscv/include/uapi/asm/kvm.h             |  1 +
 arch/riscv/kernel/Makefile                    |  2 +
 arch/riscv/kernel/qspinlock_paravirt.c        | 84 +++++++++++++++++++
 arch/riscv/kernel/setup.c                     |  5 ++
 .../kernel/trace_events_filter_paravirt.h     | 60 +++++++++++++
 arch/riscv/kvm/Makefile                       |  1 +
 arch/riscv/kvm/vcpu_sbi.c                     |  4 +
 arch/riscv/kvm/vcpu_sbi_pvlock.c              | 57 +++++++++++++
 15 files changed, 320 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/qspinlock.h
 create mode 100644 arch/riscv/include/asm/qspinlock_paravirt.h
 create mode 100644 arch/riscv/kernel/qspinlock_paravirt.c
 create mode 100644 arch/riscv/kernel/trace_events_filter_paravirt.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_pvlock.c

-- 
2.40.1


