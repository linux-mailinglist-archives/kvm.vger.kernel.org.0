Return-Path: <kvm+bounces-14612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DECD8A473E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 05:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F34091F21056
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 03:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F383E1C6B9;
	Mon, 15 Apr 2024 03:16:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.231.56.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27E01DA22;
	Mon, 15 Apr 2024 03:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=20.231.56.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713150983; cv=none; b=JXWDtZaPXrUs0syrzl8UFUIcg5WXcpDitA3AFT1GYjv3+tG02Hxq42aUFjpOc3E2FKdCuDjz5+3AC5xMr8DgjCZzqwKQaxQfJ0pY86yu2AQChoQ+CxV5l/wmHf1+dmp0gl/Zjz2R+BfUKEOVNKb3e3fixpzDMjf+evoimFGsUmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713150983; c=relaxed/simple;
	bh=rfukLwDDV18e2IBcGCdhJgSFIi+4pEqXkQGWXDpgN6o=;
	h=From:To:Cc:Subject:Date:Message-Id; b=Qx/A9Gqt8sV8PejSgCZZm/CL/9Vnqh+l7KETp9XpzokBbaQftNtfxyJeeuLtYMhGY3ARCYajYR4vQ2ELJ5dtAF/wKi8MbTJbR2LaS3xGGIdBMn4GF5y04DbmrE0bsY0tuEnmBNQgZmHCePD8QV3NgMU0kZ42eYwF8c74Cj3HSF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=20.231.56.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgCnSOV3mxxmR4gGAA--.51722S4;
	Mon, 15 Apr 2024 11:14:00 +0800 (CST)
From: Shenlin Liang <liangshenlin@eswincomputing.com>
To: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	linux-perf-users@vger.kernel.org
Cc: Shenlin Liang <liangshenlin@eswincomputing.com>
Subject: [PATCH v2 0/2] perf kvm: Add kvm stat support on riscv
Date: Mon, 15 Apr 2024 03:11:29 +0000
Message-Id: <20240415031131.23443-1-liangshenlin@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TAJkCgCnSOV3mxxmR4gGAA--.51722S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWUGrykZr47XF4UZFWxXrb_yoW8Kw48pF
	W2krs8Kw4rtFy3KwsxC3WDWrWrCw4kur1Yqr12yryUC3yj9ryDJ3WkKr9FyrZ8JF1UtFWk
	AF1Dur1rGrW5JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7VU122NtUUUUU==
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Changes from v1->v2:
- Rebased on Linux 6.9-rc3.

'perf kvm stat report/record' generates a statistical analysis of KVM
events and can be used to analyze guest exit reasons. This patch tries
to add stat support on riscv.

Map the return value of trace_kvm_exit() to the specific cause of the 
exception, and export it to userspace.

It records on two available KVM tracepoints for riscv: "kvm:kvm_entry"
and "kvm:kvm_exit", and reports statistical data which includes events
handles time, samples, and so on.

Simple tests go below:

# ./perf kvm record -e "kvm:kvm_entry" -e "kvm:kvm_exit"
Lowering default frequency rate from 4000 to 2500.
Please consider tweaking /proc/sys/kernel/perf_event_max_sample_rate.
[ perf record: Woken up 18 times to write data ]
[ perf record: Captured and wrote 5.433 MB perf.data.guest (62519 samples) 

# ./perf kvm report
31K kvm:kvm_entry
31K kvm:kvm_exit

# ./perf kvm stat record -a
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 8.502 MB perf.data.guest (99338 samples) ]

# ./perf kvm stat report --event=vmexit
Event name                Samples   Sample%    Time (ns)     Time%   Max Time (ns)   Min Time (ns)  Mean Time (ns)
STORE_GUEST_PAGE_FAULT     26968     54.00%    2003031800    40.00%     3361400         27600          74274
LOAD_GUEST_PAGE_FAULT      17645     35.00%    1153338100    23.00%     2513400         30800          65363
VIRTUAL_INST_FAULT         1247      2.00%     340820800     6.00%      1190800         43300          273312
INST_GUEST_PAGE_FAULT      1128      2.00%     340645800     6.00%      2123200         30200          301990
SUPERVISOR_SYSCALL         1019      2.00%     245989900     4.00%      1851500         29300          241403
LOAD_ACCESS                986       1.00%     671556200     13.00%     4180200         100700         681091
INST_ACCESS                655       1.00%     170054800     3.00%      1808300         54600          259625
HYPERVISOR_SYSCALL         21        0.00%     4276400       0.00%      716500          116000         203638 

Shenlin Liang (2):
  RISCV: KVM: add tracepoints for entry and exit events
  perf kvm/riscv: Port perf kvm stat to RISC-V

 arch/riscv/kvm/trace.h                        | 67 ++++++++++++++++
 arch/riscv/kvm/vcpu.c                         |  7 ++
 tools/perf/arch/riscv/Makefile                |  1 +
 tools/perf/arch/riscv/util/Build              |  1 +
 tools/perf/arch/riscv/util/kvm-stat.c         | 78 +++++++++++++++++++
 .../arch/riscv/util/riscv_exception_types.h   | 41 ++++++++++
 6 files changed, 195 insertions(+)
 create mode 100644 arch/riscv/kvm/trace.h
 create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
 create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h

-- 
2.37.2


