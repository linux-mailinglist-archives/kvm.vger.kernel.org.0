Return-Path: <kvm+bounces-9099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E0085A8A7
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 17:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 531D71F25041
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 16:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73ACC3CF66;
	Mon, 19 Feb 2024 16:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X5+G85Ql"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F263B79D;
	Mon, 19 Feb 2024 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708359573; cv=none; b=YqUQdQdr4chRfT+C2giqPLtOB0zftutD249LJeQWiaHpdIOqfpasU4hChgYve9HjoMHTjiq4B5Kr0fuWR58R+BKnnr2TZCoXpqGb96KXnNFvnJQrdiO4bQmAFrA3Nqu19neJ7hPngSi7BcUNg67YooV6rIxSjrvd6I+UUDDDf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708359573; c=relaxed/simple;
	bh=Jy9k09PAlwl2enFfxaMgkzK9iRBdmSRKjEAtKTGbCKo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=l9GqlARBHA9E7KyRd74v0NyPeFTOcNXDEl6wumHnB+gRv48yIf5xvkQPDbmJVn+3rZIUQauTkK7zEw3hhXmSUQ/2QWgHhSoA0PlsfKgfJBQFCLlVFToZCtnqnjeig3ZVUQRPgSLZZq3BiIEEqplrBydJyTxhhUa/9mYiAIdOSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X5+G85Ql; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708359567; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=5PwNPGoMJ7CW08mOs+1ZY9zWs2CVp91wKkFaBXXx+ns=;
	b=X5+G85QlodZlQ5xES/KTNP2T4PVsHYvqYAKrp5RD1GsM/e3XOwe7zKxh6/huZ32VRxnC6obQYirzB5FnCfXzOV7ICl7kF7dDA/FFGqrAvmBsyBxuRk33fH7zdojIhID2OrK/gzS7dq4SLFuml/WC/dUR6INwZ82LguLwobmXDRM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yaoma@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0W0tz6l._1708359563;
Received: from localhost.localdomain(mailfrom:yaoma@linux.alibaba.com fp:SMTPD_---0W0tz6l._1708359563)
          by smtp.aliyun-inc.com;
          Tue, 20 Feb 2024 00:19:25 +0800
From: Bitao Hu <yaoma@linux.alibaba.com>
To: tglx@linutronix.de,
	dianders@chromium.org,
	pmladek@suse.com,
	akpm@linux-foundation.org,
	kernelfans@gmail.com,
	liusong@linux.alibaba.com,
	deller@gmx.de,
	npiggin@gmail.com,
	jan.kiszka@siemens.com,
	kbingham@kernel.org
Cc: linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Bitao Hu <yaoma@linux.alibaba.com>
Subject: [PATCHv8 0/2] *** Detect interrupt storm in softlockup ***
Date: Tue, 20 Feb 2024 00:19:18 +0800
Message-Id: <20240219161920.15752-1-yaoma@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, guys.
I have implemented a low-overhead method for detecting interrupt
storm in softlockup. Please review it, all comments are welcome.

Changes from v7 to v8:

- From Thomas Gleixner, implement statistics within the interrupt
core code and provide sensible interfaces for the watchdog code. 

- Patch #1 remains unchanged. Patch #2 has significant changes
based on Thomas's suggestions, which is why I have removed
Liu Song and Douglas's Reviewed-by from patch #2. Please review
it again, and all comments are welcome.

Changes from v6 to v7:

- Remove "READ_ONCE" in "start_counting_irqs"

- Replace the hard-coded 5 with "NUM_SAMPLE_PERIODS" macro in
"set_sample_period".

- Add empty lines to help with reading the code.

- Remove the branch that processes IRQs where "counts_diff = 0".

- Add the Reviewed-by of Liu Song and Douglas.

Changes from v5 to v6:

- Use "./scripts/checkpatch.pl --strict" to get a few extra
style nits and fix them.

- Squash patch #3 into patch #1, and wrapp the help text to
80 columns.

- Sort existing headers alphabetically in watchdog.c

- Drop "softlockup_hardirq_cpus", just read "hardirq_counts"
and see if it's non-NULL.

- Store "nr_irqs" in a local variable.

- Simplify the calculation of "cpu_diff".

Changes from v4 to v5:

- Rearranging variable placement to make code look neater.

Changes from v3 to v4:

- Renaming some variable and function names to make the code logic
more readable.

- Change the code location to avoid predeclaring.

- Just swap rather than a double loop in tabulate_irq_count.

- Since nr_irqs has the potential to grow at runtime, bounds-check
logic has been implemented.

- Add SOFTLOCKUP_DETECTOR_INTR_STORM Kconfig knob.

Changes from v2 to v3:

- From Liu Song, using enum instead of macro for cpu_stats, shortening
the name 'idx_to_stat' to 'stats', adding 'get_16bit_precesion' instead
of using right shift operations, and using 'struct irq_counts'.

- From kernel robot test, using '__this_cpu_read' and '__this_cpu_write'
instead of accessing to an per-cpu array directly, in order to avoid
this warning.
'sparse: incorrect type in initializer (different modifiers)'

Changes from v1 to v2:

- From Douglas, optimize the memory of cpustats. With the maximum number
of CPUs, that's now this.
2 * 8192 * 4 + 1 * 8192 * 5 * 4 + 1 * 8192 = 237,568 bytes.

- From Liu Song, refactor the code format and add necessary comments.

- From Douglas, use interrupt counts instead of interrupt time to
determine the cause of softlockup.

- Remove the cmdline parameter added in PATCHv1.


Bitao Hu (2):
  watchdog/softlockup: low-overhead detection of interrupt
  watchdog/softlockup: report the most frequent interrupts

 arch/mips/dec/setup.c                |   2 +-
 arch/parisc/kernel/smp.c             |   2 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c |   2 +-
 include/linux/irqdesc.h              |   9 +-
 include/linux/kernel_stat.h          |   4 +
 kernel/irq/internals.h               |   2 +-
 kernel/irq/irqdesc.c                 |  34 ++++-
 kernel/irq/proc.c                    |   9 +-
 kernel/watchdog.c                    | 213 ++++++++++++++++++++++++++-
 lib/Kconfig.debug                    |  13 ++
 scripts/gdb/linux/interrupts.py      |   6 +-
 11 files changed, 269 insertions(+), 27 deletions(-)

-- 
2.37.1 (Apple Git-137.1)


