Return-Path: <kvm+bounces-7153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1D583DBAE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87340283F7F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CD01D54B;
	Fri, 26 Jan 2024 14:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Md2fslmI"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659311D524
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279036; cv=none; b=r0oD/BuKroe0OTf0ptm4S1A2K42cQZWxPhY4yttvy1nqLiG7Not8eMDNOHISOLckwbIWdLMOygQFlcNPmu1FXjjaCKJ9MubpGFnYwj+DQmeSyoDer8ZRvDg4lN4+w189djtrRSKCPt1VM4F5q1d/A33CeoiGY/+H1GT9MhCJEZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279036; c=relaxed/simple;
	bh=AqzowsNVzjsrMExYxA4bt+5klnLgZ5ZI5/RvSwZrV3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=tWHC2i+jZ68B2s3eH7bb5Oy/7167XUCI1P+AlraH/XFJHsMTaFGN1vmRZfidpXj0BqpLijzdEmdcziWKyqoTGIYhEK4BsNozdcc1ER4idxZRDskjiwCScaTV+E8ge8O48NjplFcIq6WHXJEnXHhnyH7iTFgOIb+ggihtIkrbzW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Md2fslmI; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZUp330OSR2JQRH74uAFZ7ZfiTWvrNknQMPMiXtJgyA=;
	b=Md2fslmISirutiSNzN2GS5dsDCWQGGnjqqJKnujJVrWZRC3PPm+v+MmObOZSwutsGCvPHU
	ZA52HIBHjW34JM2/xs4gnJ82whPKo6mh4gG7wG+tT584BDePjkKUL7v4UE4J5OwIw9yREb
	c8g6HTOYEHV7Mlfe3vgwFyuuFNP8wiI=
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
Subject: [kvm-unit-tests PATCH v2 07/24] riscv: Add run script and unittests.cfg
Date: Fri, 26 Jan 2024 15:23:32 +0100
Message-ID: <20240126142324.66674-33-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
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
Acked-by: Thomas Huth <thuth@redhat.com>
---
 riscv/run           | 41 +++++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)
 create mode 100755 riscv/run
 create mode 100644 riscv/unittests.cfg

diff --git a/riscv/run b/riscv/run
new file mode 100755
index 000000000000..cbe5dd792dcd
--- /dev/null
+++ b/riscv/run
@@ -0,0 +1,41 @@
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
+# Allow user overrides of some config.mak variables
+processor=$PROCESSOR_OVERRIDE
+firmware=$FIRMWARE_OVERRIDE
+
+[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
+: "${processor:=$PROCESSOR}"
+: "${firmware:=$FIRMWARE}"
+[ "$firmware" ] && firmware="-bios $firmware"
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
+command+=" $mach $acc $firmware -cpu $processor "
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
index 000000000000..5a23bed9cdd6
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
+# Set $FIRMWARE_OVERRIDE to /path/to/firmware to select the SBI implementation.
+[sbi]
+file = sbi.flat
+groups = sbi
-- 
2.43.0


