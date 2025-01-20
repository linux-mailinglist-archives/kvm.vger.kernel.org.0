Return-Path: <kvm+bounces-36048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D742A17088
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43FBC7A42E5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A9C1EF085;
	Mon, 20 Jan 2025 16:44:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ABC1EEA51;
	Mon, 20 Jan 2025 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391466; cv=none; b=fZAkuT0/giHHXPOSP/ozbfHpKj6uqWJXrH23CTf43LPUWA4GJBYLVZV3zBdqhETmuR/BC6JEcJRndPrcYR+gT/APFFjx9oWKVZxRMppm5YBZSq1mka2r2ArNPBMCb5ThuP7gzNvZHEb/5Sk/eklzDtCQHWHMX0zgaS932nD7hy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391466; c=relaxed/simple;
	bh=hX5y+GTypT4FSYyuc2jp+IPa0QblQk+VmbjbbPKgJx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9osS1EJzax4nuxUiaWgZABX1wMMG7meQJAt+l41EkvL8mMWkEzwnZXCFt/uCMtps5cTSVUFxNggBRQVmtKOi9tiKAXY3//rjdhg5BLRDlRIVQ1lJLpVLUqlQhRFbQgiViEf6SuZAZlUs9AhzyBAJWi7ykb2v9wfJ3g0JKUSYPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B42E1D15;
	Mon, 20 Jan 2025 08:44:53 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 644773F5A1;
	Mon, 20 Jan 2025 08:44:21 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 15/18] Add kvmtool_params to test specification
Date: Mon, 20 Jan 2025 16:43:13 +0000
Message-ID: <20250120164316.31473-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arm/arm64 supports running tests under kvmtool, but kvmtool's syntax for
running a virtual machine is different than qemu's. To run tests using the
automated test infrastructure, add a new test parameter, kvmtool_params.
The parameter serves the exact purpose as qemu_params/extra_params, but using
kvmtool's syntax.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/unittests.cfg   | 27 +++++++++++++++++++++++++++
 docs/unittests.txt  |  8 ++++++++
 scripts/common.bash |  4 ++++
 3 files changed, 39 insertions(+)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 2bdad67d5693..974a5a9e4113 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -16,18 +16,21 @@
 file = selftest.flat
 smp = 2
 extra_params = -m 256 -append 'setup smp=2 mem=256'
+kvmtool_params = --mem 256 --params 'setup smp=2 mem=256'
 groups = selftest
 
 # Test vector setup and exception handling (kernel mode).
 [selftest-vectors-kernel]
 file = selftest.flat
 extra_params = -append 'vectors-kernel'
+kvmtool_params = --params 'vectors-kernel'
 groups = selftest
 
 # Test vector setup and exception handling (user mode).
 [selftest-vectors-user]
 file = selftest.flat
 extra_params = -append 'vectors-user'
+kvmtool_params = --params 'vectors-user'
 groups = selftest
 
 # Test SMP support
@@ -35,6 +38,7 @@ groups = selftest
 file = selftest.flat
 smp = $MAX_SMP
 extra_params = -append 'smp'
+kvmtool_params = --params 'smp'
 groups = selftest
 
 # Test PCI emulation
@@ -47,66 +51,77 @@ groups = pci
 file = pmu.flat
 groups = pmu
 extra_params = -append 'cycle-counter 0'
+kvmtool_params = --pmu --params 'cycle-counter 0'
 
 [pmu-event-introspection]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-event-introspection'
+kvmtool_params = --pmu --params 'pmu-event-introspection'
 
 [pmu-event-counter-config]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-event-counter-config'
+kvmtool_params = --pmu --params 'pmu-event-counter-config'
 
 [pmu-basic-event-count]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-basic-event-count'
+kvmtool_params = --pmu --params 'pmu-basic-event-count'
 
 [pmu-mem-access]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-mem-access'
+kvmtool_params = --pmu --params 'pmu-mem-access'
 
 [pmu-mem-access-reliability]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-mem-access-reliability'
+kvmtool_params = --pmu --params 'pmu-mem-access-reliability'
 
 [pmu-sw-incr]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-sw-incr'
+kvmtool_params = --pmu --params 'pmu-sw-incr'
 
 [pmu-chained-counters]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-chained-counters'
+kvmtool_params = --pmu --params 'pmu-chained-counters'
 
 [pmu-chained-sw-incr]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-chained-sw-incr'
+kvmtool_params = --pmu --params 'pmu-chained-sw-incr'
 
 [pmu-chain-promotion]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-chain-promotion'
+kvmtool_params = --pmu --params 'pmu-chain-promotion'
 
 [pmu-overflow-interrupt]
 file = pmu.flat
 groups = pmu
 arch = arm64
 extra_params = -append 'pmu-overflow-interrupt'
+kvmtool_params = --pmu --params 'pmu-overflow-interrupt'
 
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
@@ -127,48 +142,56 @@ extra_params = -append 'pmu-overflow-interrupt'
 file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'ipi'
+kvmtool_params = --irqchip=gicv2 --params 'ipi'
 groups = gic
 
 [gicv2-mmio]
 file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'mmio'
+kvmtool_params = --irqchip=gicv2 --params 'mmio'
 groups = gic
 
 [gicv2-mmio-up]
 file = gic.flat
 smp = 1
 extra_params = -machine gic-version=2 -append 'mmio'
+kvmtool_params = --irqchip=gicv2 --params 'mmio'
 groups = gic
 
 [gicv2-mmio-3p]
 file = gic.flat
 smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
 extra_params = -machine gic-version=2 -append 'mmio'
+kvmtool_params = --irqchip=gicv2 --params 'mmio'
 groups = gic
 
 [gicv3-ipi]
 file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'ipi'
+kvmtool_params = --irqchip=gicv3 --params 'ipi'
 groups = gic
 
 [gicv2-active]
 file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'active'
+kvmtool_params = --irqchip=gicv2 --params 'active'
 groups = gic
 
 [gicv3-active]
 file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'active'
+kvmtool_params = --irqchip=gicv3 --params 'active'
 groups = gic
 
 [its-introspection]
 file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'its-introspection'
+kvmtool_params = --irqchip=gicv3-its --params 'its-introspection'
 groups = its
 arch = arm64
 
@@ -176,6 +199,7 @@ arch = arm64
 file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'its-trigger'
+kvmtool_params = --irqchip=gicv3-its --params 'its-trigger'
 groups = its
 arch = arm64
 
@@ -232,6 +256,7 @@ groups = cache
 file = debug.flat
 arch = arm64
 extra_params = -append 'bp'
+kvmtool_params = --params 'bp'
 groups = debug
 
 [debug-bp-migration]
@@ -244,6 +269,7 @@ groups = debug migration
 file = debug.flat
 arch = arm64
 extra_params = -append 'wp'
+kvmtool_params = --params 'wp'
 groups = debug
 
 [debug-wp-migration]
@@ -256,6 +282,7 @@ groups = debug migration
 file = debug.flat
 arch = arm64
 extra_params = -append 'ss'
+kvmtool_params = --params 'ss'
 groups = debug
 
 [debug-sstep-migration]
diff --git a/docs/unittests.txt b/docs/unittests.txt
index 3e1a9e563016..ebb6994cab77 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -69,6 +69,14 @@ extra_params
 Alias for 'qemu_params', supported for compatibility purposes. Use
 'qemu_params' for new tests.
 
+kvmtool_params
+--------------
+Extra parameters supplied to the kvmtool process. Works similarly to
+qemu_params and extra_params, but uses kvmtool's syntax for command line
+arguments. The example for qemu_params, applied to kvmtool, would be:
+
+kvmtool_params = --mem 256 --params 'smp=2'
+
 groups
 ------
 groups = <group_name1> <group_name2> ...
diff --git a/scripts/common.bash b/scripts/common.bash
index 1b5e0d667841..f54ffbd7a87b 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -67,6 +67,10 @@ function for_each_unittest()
 			qemu_opts=$(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)
 		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
 			qemu_opts=${BASH_REMATCH[2]}
+		elif [[ $line =~ ^kvmtool_params\ *=\ *'"""'(.*)$ ]]; then
+			kvmtool_opts=$(parse_opts ${BASH_REMATCH[1]}$'\n' $fd)
+		elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
+			kvmtool_opts=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
-- 
2.47.1


