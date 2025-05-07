Return-Path: <kvm+bounces-45726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE888AAE435
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60DAF9C0785
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892A828A1F7;
	Wed,  7 May 2025 15:13:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711A028AAE8;
	Wed,  7 May 2025 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630831; cv=none; b=fgDu5RBPQ9rpuz9nimoAeo52X3tkWsJsldYMnA7LQ1haxUMyib3zXDZI4PCJ8v5QPulSBibZ8cUrkdGPoSpVoLx+xU6zvoWhjX2M3v0kqsuo5CFLmftHW+t979CkX+jq3tCbGBKSYICpSDuVOXDqH+XKRPcWvvXA39gMHLrI/Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630831; c=relaxed/simple;
	bh=UL5H81A+N3Qt1JfiipyAgs7FIgz5kmkYlYGcrntTeD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaJf7zcat/ApuycnWKgF1KC5ij5ott+1qYyfGw+5YUerjeI4VhYrj4ceO2tQoz5lh/sUkJKmwKV9R92DD+4NYDMTNAP+bICMBiZnYwuABvWEmbpogWT2p5OQlfh4XHe5p47lJZ4NoyVsB42u4+G7h66X/DEMrUBiNqgDOy7S+zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA54122C8;
	Wed,  7 May 2025 08:13:38 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC8393F58B;
	Wed,  7 May 2025 08:13:45 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 10/16] scripts: Add default arguments for kvmtool
Date: Wed,  7 May 2025 16:12:50 +0100
Message-ID: <20250507151256.167769-11-alexandru.elisei@arm.com>
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

kvmtool, unless told otherwise, will do its best to make sure that a kernel
successfully boots in a virtual machine. It does things like automatically
creating a rootfs and adding extra parameters to the kernel command line.
This is actively harmful to kvm-unit-tests, because some tests parse the
kernel command line and they will fail if they encounter the options added
by kvmtool.

Fortunately for us, kvmtool commit 5613ae26b998 ("Add --nodefaults command
line argument") addded the --nodefaults kvmtool parameter which disables
all the implicit virtual machine configuration that cannot be disabled by
using other parameters, like modifying the kernel command line. So always
use --nodefaults to allow a test to run.

kvmtool can also be too verbose when running a virtual machine, and this is
controlled by several parameters. Add those to the default kvmtool command
line to reduce this verbosity to a minimum.

Before:

$ vm run arm/selftest.flat --cpus 2 --mem 256 --params "setup smp=2 mem=256"
Info: # lkvm run -k arm/selftest.flat -m 256 -c 2 --name guest-5035
Unknown subtest

EXIT: STATUS=127
Warning: KVM compatibility warning.
    virtio-9p device was not detected.
    While you have requested a virtio-9p device, the guest kernel did not initialize it.
    Please make sure that the guest kernel was compiled with CONFIG_NET_9P_VIRTIO=y enabled in .config.
Warning: KVM compatibility warning.
    virtio-net device was not detected.
    While you have requested a virtio-net device, the guest kernel did not initialize it.
    Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y enabled in .config.
Info: KVM session ended normally.

After:

$ vm run arm/selftest.flat --nodefaults --network mode=none --loglevel=warning --cpus 2 --mem 256 --params "setup smp=2 mem=256"
PASS: selftest: setup: smp: number of CPUs matches expectation
INFO: selftest: setup: smp: found 2 CPUs
PASS: selftest: setup: mem: memory size matches expectation
INFO: selftest: setup: mem: found 256 MB
SUMMARY: 2 tests

EXIT: STATUS=1

Note that KVMTOOL_DEFAULT_OPTS can be overwritten by an environment
variable with the same name, but it's not documented in the help string for
run_tests.sh. This has been done on purpose, since overwritting
KVMTOOL_DEFAULT_OPTS should only be necessary for debugging or development
purposes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/common.bash | 10 +++++-----
 scripts/vmm.bash    | 13 +++++++++++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 0645235d8baa..ee0ae71948c2 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -56,7 +56,7 @@ function for_each_unittest()
 			# because qemu interprets the first argument after
 			# -append as a kernel parameter.
 			test_args=""
-			opts=""
+			opts="${vmm_opts[$TARGET:default_opts]}"
 			groups=""
 			arch=""
 			machine=""
@@ -70,13 +70,13 @@ function for_each_unittest()
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
 			test_args="${vmm_opts[$TARGET:args]} ${BASH_REMATCH[1]}"
 		elif [[ $TARGET = "qemu" ]] && [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
-			opts=$(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)
+			opts="${vmm_opts[$TARGET:default_opts]} $(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)"
 		elif [[ $TARGET  = "qemu" ]] && [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
-			opts=${BASH_REMATCH[2]}
+			opts="${vmm_opts[$TARGET:default_opts]} ${BASH_REMATCH[2]}"
 		elif [[ $TARGET = "kvmtool" ]] && [[ $line =~ ^kvmtool_params\ *=\ *'"""'(.*)$ ]]; then
-			opts=$(parse_opts ${BASH_REMATCH[1]}$'\n' $fd)
+			opts="${vmm_opts[$TARGET:default_opts]} $(parse_opts ${BASH_REMATCH[1]}$'\n' $fd)"
 		elif [[ $TARGET = "kvmtool" ]] && [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
-			opts=${BASH_REMATCH[1]}
+			opts="${vmm_opts[$TARGET:default_opts]} ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 20968f2e6b10..d24a4c4b8713 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -1,5 +1,16 @@
 source config.mak
 
+# The following parameters are enabled by default when running a test with
+# kvmtool:
+# --nodefaults: suppress VM configuration that cannot be disabled otherwise
+#               (like modifying the supplied kernel command line). Tests that
+#               use the command line will fail without this parameter.
+# --network mode=none: do not create a network device. kvmtool tries to help the
+#               user by automatically create one, and then prints a warning
+#               when the VM terminates if the device hasn't been initialized.
+# --loglevel=warning: reduce verbosity
+: "${KVMTOOL_DEFAULT_OPTS:="--nodefaults --network mode=none --loglevel=warning"}"
+
 ##############################################################################
 # qemu_fixup_return_code translates the ambiguous exit status in Table1 to that
 # in Table2.  Table3 simply documents the complete status table.
@@ -87,12 +98,14 @@ declare -A vmm_opts=(
 	[qemu:kernel]='-kernel'
 	[qemu:args]='-append'
 	[qemu:initrd]='-initrd'
+	[qemu:default_opts]=''
 	[qemu:fixup_return_code]=qemu_fixup_return_code
 
 	[kvmtool:nr_cpus]='--cpus'
 	[kvmtool:kernel]='--kernel'
 	[kvmtool:args]='--params'
 	[kvmtool:initrd]='--initrd'
+	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
 	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
 )
 
-- 
2.49.0


