Return-Path: <kvm+bounces-6786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 550DC83A2B1
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 889151C23C99
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D33917572;
	Wed, 24 Jan 2024 07:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Or/1gBSt"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3332A17558
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080718; cv=none; b=KDbw7qEsf0J85Tssr7MJ78x6pWJ3FElp+V/697LPFUd1KSqxilWiYI1QiR0cFh8uHJyMSt3bRPi25e4mH3xtfkms6QtTbgbOun6an2uGQCnlGBC3vtJomuRh+qHB5jW5c9v9PP2bJdt0nz1VrWcCINedbtL8hGT8oi8hhVkpH6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080718; c=relaxed/simple;
	bh=FR9YspmdMlD7wZos579Wf0jCNclHk+nJTze1UOCJK5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=fGdmr6wpyC3acgazX1dBNU5OrLQYnPG7KclUOIdjw7tntQ1Tq8It/hJ5iz3bYjykBTICQATVxSU5q8C4hxNy8EXRrp1DdiatA/y6cGN95J9mmL4DKFLwVdjkwOeV7OqTbiZOAborGUGAe0fjEY7H34oAxigCpBT4pCNtuuG5ahE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Or/1gBSt; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vTIwHt3MEShEcO7Dx/vVJefVhfbPlPxffgfqpdcExpM=;
	b=Or/1gBSt4JfpmuSAKHwGeaz3SRO72jtjuzZ+9WOJzYIOlh3dQ3ZSze7W7s/ZlCEGXpIzGM
	pyVGZlsDoG7jDKile2bXH53F+Pg+Mc/Djr5Ewflxnlw0cWZufriGlroFmcmjrX/F601DKt
	SLtwuJ2XD9yj6/SH6IAPPus8EZSnPUU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 07/24] riscv: Add run script and unittests.cfg
Date: Wed, 24 Jan 2024 08:18:23 +0100
Message-ID: <20240124071815.6898-33-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

With a run script and a unittests.cfg file we can now run

 $ KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh

where test-env has the environment variables needed for both tests.

Note, to change the SBI implementation under test, for example to
RustSBI, QEMU needs the -bios parameter. The full command line
would be

  qemu-system-riscv64 -nographic -M virt -cpu rv64 \
      -kernel riscv/sbi.flat \
      -bios $PATH_TO_RUSTSBI

and with the run script, it's

  SBI_IMPL="-bios $PATH_TO_RUSTSBI" ./run_tests.sh -g sbi

(note the '-g sbi' to only run the SBI test group)

Finally, with the addition of the run script, 'make standalone' now
also works.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/run           | 38 ++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100755 riscv/run
 create mode 100644 riscv/unittests.cfg

diff --git a/riscv/run b/riscv/run
new file mode 100755
index 000000000000..8a189e5349a2
--- /dev/null
+++ b/riscv/run
@@ -0,0 +1,38 @@
+#!/usr/bin/env bash
+
+if [ -z "$KUT_STANDALONE" ]; then
+	if [ ! -f config.mak ]; then
+		echo "run ./configure && make first. See ./configure -h"
+		exit 2
+	fi
+	source config.mak
+	source scripts/arch-run.bash
+fi
+
+if [[ $PROCESSOR == "riscv32" ]]; then
+	processor="rv32"
+elif [[ $PROCESSOR == "riscv64" ]]; then
+	processor="rv64"
+fi
+
+set_qemu_accelerator || exit $?
+[ "$ACCEL" = "kvm" ] && QEMU_ARCH=$HOST
+acc="-accel $ACCEL$ACCEL_PROPS"
+
+qemu=$(search_qemu_binary) || exit $?
+if ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
+	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
+	exit 2
+fi
+mach='-machine virt'
+
+command="$qemu -nodefaults -nographic -serial mon:stdio"
+command+=" $mach $acc -cpu $processor "
+command="$(migration_cmd) $(timeout_cmd) $command"
+
+if [ "$EFI_RUN" = "y" ]; then
+	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
+else
+	# We return the exit code via stdout, not via the QEMU return code
+	run_qemu_status $command -kernel "$@"
+fi
diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
new file mode 100644
index 000000000000..3840136064ee
--- /dev/null
+++ b/riscv/unittests.cfg
@@ -0,0 +1,37 @@
+##############################################################################
+# unittest configuration
+#
+# [unittest_name]
+# file = <name>.flat		# Name of the flat file to be used.
+# smp  = <num>			# Number of processors the VM will use
+#				# during this test. Use $MAX_SMP to use
+#				# the maximum the host supports. Defaults
+#				# to one.
+# extra_params = -append <params...>	# Additional parameters used.
+# arch = riscv32|riscv64		# Select one if the test case is
+#					# specific to only one.
+# groups = <group_name1> <group_name2> ...	# Used to identify test cases
+#						# with run_tests -g ...
+#						# Specify group_name=nodefault
+#						# to have test not run by
+#						# default
+# accel = kvm|tcg		# Optionally specify if test must run with
+#				# kvm or tcg. If not specified, then kvm will
+#				# be used when available.
+# timeout = <duration>		# Optionally specify a timeout.
+# check = <path>=<value> # check a file for a particular value before running
+#                        # a test. The check line can contain multiple files
+#                        # to check separated by a space but each check
+#                        # parameter needs to be of the form <path>=<value>
+##############################################################################
+
+[selftest]
+file = selftest.flat
+smp = 16
+extra_params = -append 'foo bar baz'
+groups = selftest
+
+[sbi]
+file = sbi.flat
+extra_params = $SBI_IMPL
+groups = sbi
-- 
2.43.0


