Return-Path: <kvm+bounces-45724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C37B7AAE41F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B1801C05443
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE15A28A417;
	Wed,  7 May 2025 15:13:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B717928A415;
	Wed,  7 May 2025 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630824; cv=none; b=S482DHHspJiBxphG+T2yh87Uv0L+CprjUjl6Nln9h0PpNQuLGcdimvdlV5DcD2XTToTOdmKUMUt22k/bg0obawBFDEoBuJrT52yBFkaQAAprV3EZGAdG2LlISIJlua8kGyEr2mtB1MZJkSXsSp9FWitrtm7WTsuXR3EV0K3sUl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630824; c=relaxed/simple;
	bh=U0+OWwt8n/YL64dVcivooJI0BFeXJtIkKSYaGxyq4gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIQJSSgnteawglffovTdOa2ynlQVb0e7o8spWpDlMHOYG0Fnxv/lnmaruI5I+abQ9QLEb2c4ukykiCrHEjdpMWOXjHZveqm78SETJzOMcqPxGjfYY77Q9BexL8dmsaRyhcHgTQl0z0f28/iwUj506eiv6cGs9lbt+GJljEkVh8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E826422BE;
	Wed,  7 May 2025 08:13:31 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C912D3F58B;
	Wed,  7 May 2025 08:13:38 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 08/16] scripts: Add 'kvmtool_params' to test definition
Date: Wed,  7 May 2025 16:12:48 +0100
Message-ID: <20250507151256.167769-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507151256.167769-1-alexandru.elisei@arm.com>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arm/arm64 supports running tests under kvmtool, but kvmtool's syntax for
running and configuring a virtual machine is different to qemu. To run
tests using the automated test infrastructure, add a new test parameter,
'kvmtool_params'. The parameter serves the exact purpose as 'qemu_params',
but using kvmtool's syntax.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/unittests.cfg   | 24 +++++++++++++++++++++++
 docs/unittests.txt  |  8 ++++++++
 scripts/common.bash | 47 +++++++++++++++++++++++++++++----------------
 3 files changed, 62 insertions(+), 17 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index a4192ed7e20b..f3c773e56933 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -17,6 +17,7 @@ file = selftest.flat
 smp = 2
 test_args = 'setup smp=2 mem=256'
 qemu_params = -m 256
+kvmtool_params = --mem 256
 groups = selftest
 
 # Test vector setup and exception handling (kernel mode).
@@ -48,66 +49,77 @@ groups = pci
 file = pmu.flat
 groups = pmu
 test_args = "cycle-counter 0"
+kvmtool_params = --pmu
 
 [pmu-event-introspection]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-event-introspection
+kvmtool_params = --pmu
 
 [pmu-event-counter-config]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-event-counter-config
+kvmtool_params = --pmu
 
 [pmu-basic-event-count]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-basic-event-count
+kvmtool_params = --pmu
 
 [pmu-mem-access]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-mem-access
+kvmtool_params = --pmu
 
 [pmu-mem-access-reliability]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-mem-access-reliability
+kvmtool_params = --pmu
 
 [pmu-sw-incr]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-sw-incr
+kvmtool_params = --pmu
 
 [pmu-chained-counters]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-chained-counters
+kvmtool_params = --pmu
 
 [pmu-chained-sw-incr]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-chained-sw-incr
+kvmtool_params = --pmu
 
 [pmu-chain-promotion]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-chain-promotion
+kvmtool_params = --pmu
 
 [pmu-overflow-interrupt]
 file = pmu.flat
 groups = pmu
 arch = arm64
 test_args = pmu-overflow-interrupt
+kvmtool_params = --pmu
 
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
@@ -131,6 +143,7 @@ file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 test_args = ipi
 qemu_params = -machine gic-version=2
+kvmtool_params = --irqchip=gicv2
 groups = gic
 
 [gicv2-mmio]
@@ -138,6 +151,7 @@ file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 test_args = mmio
 qemu_params = -machine gic-version=2
+kvmtool_params = --irqchip=gicv2
 groups = gic
 
 [gicv2-mmio-up]
@@ -145,6 +159,7 @@ file = gic.flat
 smp = 1
 test_args = mmio
 qemu_params = -machine gic-version=2
+kvmtool_params = --irqchip=gicv2
 groups = gic
 
 [gicv2-mmio-3p]
@@ -152,6 +167,7 @@ file = gic.flat
 smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
 test_args = mmio
 qemu_params = -machine gic-version=2
+kvmtool_params = --irqchip=gicv2
 groups = gic
 
 [gicv3-ipi]
@@ -159,6 +175,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = ipi
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3
 groups = gic
 
 [gicv2-active]
@@ -166,6 +183,7 @@ file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 test_args = active
 qemu_params = -machine gic-version=2
+kvmtool_params = --irqchip=gicv2
 groups = gic
 
 [gicv3-active]
@@ -173,6 +191,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = active
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3
 groups = gic
 
 [its-introspection]
@@ -180,6 +199,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = its-introspection
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3-its
 groups = its
 arch = arm64
 
@@ -188,6 +208,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = its-trigger
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3-its
 groups = its
 arch = arm64
 
@@ -196,6 +217,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = its-migration
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3
 groups = its migration
 arch = arm64
 
@@ -204,6 +226,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = its-pending-migration
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3
 groups = its migration
 arch = arm64
 
@@ -212,6 +235,7 @@ file = gic.flat
 smp = $MAX_SMP
 test_args = its-migrate-unmapped-collection
 qemu_params = -machine gic-version=3
+kvmtool_params = --irqchip=gicv3
 groups = its migration
 arch = arm64
 
diff --git a/docs/unittests.txt b/docs/unittests.txt
index ea0da959f008..a9164bccc24c 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -78,6 +78,14 @@ extra_params
 Alias for 'qemu_params', supported for compatibility purposes. Use
 'qemu_params' for new tests.
 
+kvmtool_params
+--------------
+Extra parameters supplied to the kvmtool process. Works similarly to
+'qemu_params', but uses kvmtool's syntax for command line arguments. The
+example for 'qemu_params', applied to kvmtool, would be:
+
+kvmtool_params = --mem 256
+
 groups
 ------
 groups = <group_name1> <group_name2> ...
diff --git a/scripts/common.bash b/scripts/common.bash
index 649f1c737617..0645235d8baa 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,6 +1,29 @@
 source config.mak
 source scripts/vmm.bash
 
+function parse_opts()
+{
+	local opts="$1"
+	local fd="$2"
+
+	while read -r -u $fd; do
+		#escape backslash newline, but not double backslash
+		if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
+			if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
+				opts=${opts%\\$'\n'}
+			fi
+		fi
+		if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
+			opts+=${BASH_REMATCH[1]}
+			break
+		else
+			opts+=$REPLY$'\n'
+		fi
+	done
+
+	echo "$opts"
+}
+
 function for_each_unittest()
 {
 	local unittests="$1"
@@ -46,24 +69,14 @@ function for_each_unittest()
 			smp="${vmm_opts[$TARGET:nr_cpus]} ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
 			test_args="${vmm_opts[$TARGET:args]} ${BASH_REMATCH[1]}"
-		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
-			opts=${BASH_REMATCH[2]}$'\n'
-			while read -r -u $fd; do
-				#escape backslash newline, but not double backslash
-				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
-					if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
-						opts=${opts%\\$'\n'}
-					fi
-				fi
-				if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
-					opts+=${BASH_REMATCH[1]}
-					break
-				else
-					opts+=$REPLY$'\n'
-				fi
-			done
-		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
+		elif [[ $TARGET = "qemu" ]] && [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
+			opts=$(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)
+		elif [[ $TARGET  = "qemu" ]] && [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
 			opts=${BASH_REMATCH[2]}
+		elif [[ $TARGET = "kvmtool" ]] && [[ $line =~ ^kvmtool_params\ *=\ *'"""'(.*)$ ]]; then
+			opts=$(parse_opts ${BASH_REMATCH[1]}$'\n' $fd)
+		elif [[ $TARGET = "kvmtool" ]] && [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
+			opts=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
-- 
2.49.0


