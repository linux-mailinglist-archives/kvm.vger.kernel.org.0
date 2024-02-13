Return-Path: <kvm+bounces-8594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 348D5852C4D
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 634311C231F9
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB082225A9;
	Tue, 13 Feb 2024 09:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mtFtMFbU"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD1122319
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816799; cv=none; b=Yhgv/wtbKeI4n3c+W0F7sb/dMg3PXQZsKCPt4q+E0U2fQTGmqoMuSZ3GRfqbn7U1FSkSnDeBO12xLmubhN6ndy6FFmggrCop5wh4mxsD9ZRzgOHYaKDa+OKaFjaXVN8iWoEeReCX7mHWtBveErue4MBPPCIlerup+vQsuHVoQrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816799; c=relaxed/simple;
	bh=pqrF3xPTx1xmxqP1iL+dG5WfH700VcJkBHMegIvgDus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A8N9KN50BRGnATc4cbtbtcETXxnalWeyHAUxV/xx6NH7q3lcUxeTZjhi10fRl4r53coFeavf6obzKp7SX9PVRWUvK2mJnna+7QNIlkuXMOoxOXLmZ+24qrWF81TzxIpt6+PIOPfwl2uCjQzF1q8gsfkZV7hKBR17DjTDAGiex7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mtFtMFbU; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NUCDH79BK5F5dDhUzT0JOtT9z48X42DlZfGByqCjqeE=;
	b=mtFtMFbUyrNIyeJlPry/n5yCkzLHSrmTQs4DzjSh2Gw1htrh/ezDt3vUAmeuRspy1e2NgB
	kjQI9ej2a9mUnZHLoXM9XZ0jJKEcZDClCg0+3S0OEcZ+pAEnpafmrvCe8TE4QTcrAbVXiY
	4PQfOo/vRdB/MoNNVvnj7CMfaS94rRc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/23] KVM: arm64: Improvements to LPI injection
Date: Tue, 13 Feb 2024 09:32:37 +0000
Message-ID: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

For full details on the what/why, please see the cover letter in v1.

Apologies for the delay on v2, I wanted to spend some time to get a
microbenchmark in place to slam the ITS code pretty hard, and based on
the results I'm glad I did.

The test is built around having vCPU threads and device threads, where
each device can signal a particular number of event IDs (alien, right?)

Anyway, here are the results of that test in some carefully-selected
examples:

+----------------------------+---------------------+------------------------------+
|           Config           | v6.8-rc1 (LPIs/sec) | v6.8-rc1 + series (LPIs/sec) |
+----------------------------+---------------------+------------------------------+
| -v 1 -d 1 -e 1 -i 1000000  |           780151.37 |                   1255291.00 |
| -v 16 -d 16 -e 16 -i 10000 |           437081.55 |                   5078225.70 |
| -v 16 -d 16 -e 17 -i 10000 |           506446.50 |                   1126118.10 |
| -v 64 -d 64 -e 1 -i 100000 |           295097.03 |                   5565964.87 |
| -v 1 -d 1 -e 17 -i 1000    |           732934.43 |                       149.24 |
+----------------------------+---------------------+------------------------------+

While there is an 18x improvement in the scaled-out config (64 vCPUs, 64
devices, 1 event per device), there is an extremely disappointing 4911x
regression in the example that effectively forces a cache eviction for
every lookup.

Clearly the RCU synchronization is a bounding issue in this case. I
think other scenarios where the cache is overcommitted (16 vCPUs, 16
devices, 17 events / device) are able to hide effects somewhat, as other
threads can make forward progress while others are stuck waiting on RCU.

A few ideas on next steps:

 1) Rework the lpi_list_lock as an rwlock. This would obviate the need
    for RCU protection in the LPI cache as well as memory allocations on
    the injection path. This is actually what I had in the internal
    version of the series, although it was very incomplete.

    I'd expect this to nullify the improvement on the
    slightly-overcommitted case and 'fix' the pathological case.

 2) call_rcu() and move on. This feels somewhat abusive of the API, as
    the guest can flood the host with RCU callbacks, but I wasn't able
    to make my machine fall over in any mean configuration of the test.

    I haven't studied the degree to which such a malicious VM could
    adversely affect neighboring workloads.

 3) Redo the whole ITS representation with xarrays and allow RCU readers
    outside of the ITS lock. I haven't fully thought this out, and if we
    pursue this option then we will need a secondary data structure to
    track where ITSes have been placed in guest memory to avoid taking
    the SRCU lock. We can then stick RCU synchronization in ITS command
    processing, which feels right to me, and dump the translation cache
    altogether.

    I'd expect slightly worse average case performance in favor of more
    consistent performance.

Even though it is more work, I'm slightly in favor of (3) as it is a
net reduction in overall complexity of the ITS implementation. But, I
wanted to send out what I had to guage opinions on these options, and
get feedback on the first 10 patches which are an overall win.

v1: https://lore.kernel.org/kvmarm/20240124204909.105952-1-oliver.upton@linux.dev/

v1 -> v2:
 - Add the microbenchmark
 - Add tracepoints / VM stats for the important bits of LPI injection.
   This was extremely useful for making sense of test results.
 - Fix a silly lock imbalance on error path in vgic_add_lpi() (Dan)
 - Constrain xas_for_each() based on the properties of the INTID space
   (Marc)
 - Remove some missed vestiges of the LPI linked-list (Marc)
 - Explicitly free unused cache entry on failed insertion race (Marc)
 - Don't explode people's machines with a boatload of xchg() (I said it
   was WIP!) (Marc)

Oliver Upton (23):
  KVM: arm64: Add tracepoints + stats for LPI cache effectiveness
  KVM: arm64: vgic: Store LPIs in an xarray
  KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
  KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
  KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
  KVM: arm64: vgic: Get rid of the LPI linked-list
  KVM: arm64: vgic: Use atomics to count LPIs
  KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
  KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
  KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
  KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
  KVM: arm64: vgic-its: Lazily allocate LPI translation cache
  KVM: arm64: vgic-its: Pick cache victim based on usage count
  KVM: arm64: vgic-its: Protect cached vgic_irq pointers with RCU
  KVM: arm64: vgic-its: Treat the LPI translation cache as an rculist
  KVM: arm64: vgic-its: Rely on RCU to protect translation cache reads
  KVM: selftests: Align with kernel's GIC definitions
  KVM: selftests: Standardise layout of GIC frames
  KVM: selftests: Add a minimal library for interacting with an ITS
  KVM: selftests: Add helper for enabling LPIs on a redistributor
  KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
  KVM: selftests: Hack in support for aligned page allocations
  KVM: selftests: Add stress test for LPI injection

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/guest.c                        |   5 +-
 arch/arm64/kvm/vgic/trace.h                   |  66 ++
 arch/arm64/kvm/vgic/vgic-debug.c              |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   7 +-
 arch/arm64/kvm/vgic/vgic-its.c                | 220 ++++---
 arch/arm64/kvm/vgic/vgic-v3.c                 |   3 +-
 arch/arm64/kvm/vgic/vgic.c                    |  56 +-
 arch/arm64/kvm/vgic/vgic.h                    |  15 +-
 include/kvm/arm_vgic.h                        |  10 +-
 include/linux/kvm_host.h                      |   4 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   8 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |   2 +
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  15 +-
 .../selftests/kvm/aarch64/vgic_lpi_stress.c   | 388 ++++++++++++
 .../kvm/aarch64/vpmu_counter_access.c         |   6 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   5 +-
 .../selftests/kvm/include/aarch64/gic.h       |  15 +-
 .../selftests/kvm/include/aarch64/gic_v3.h    | 586 +++++++++++++++++-
 .../selftests/kvm/include/aarch64/processor.h |   2 -
 .../selftests/kvm/include/aarch64/vgic.h      |  27 +-
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  18 +-
 .../selftests/kvm/lib/aarch64/gic_private.h   |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  69 ++-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 337 +++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  27 +-
 28 files changed, 1641 insertions(+), 262 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.43.0.687.g38aa6559b0-goog


