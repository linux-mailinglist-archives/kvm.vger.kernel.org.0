Return-Path: <kvm+bounces-50721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B140AE88B1
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0805A1796C5
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C4A2BD03E;
	Wed, 25 Jun 2025 15:49:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8067D27FD74;
	Wed, 25 Jun 2025 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866542; cv=none; b=BZgNlkFYGnr1pZ0+Cl8Ns132IAUtb3zgxLCKBvvb2FFj7tX/g4FNN7FFjYwFSWV7mLavdRQkSrDG/B6vdQa+XQFcwDo1dh/2nWN4YILSuUILJ9yQFRpQd/94C/+6Wd+vT95Cp/RGIA2xt0GbMXTz8jZZbaUaN3fnQFay3mtZoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866542; c=relaxed/simple;
	bh=DLP1z2S/mVhUBgWouK591gZCkmCZxCxwYPGuCd2LF8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLjrvKcEDEBQ3ZKaIIV7+Z31Ak6kbENeLbM/R68AvGjHFvxf2pkiUQfR70CR5m52hZSiu1vDrSMQCFjRwkW9yooaoQ+TkOSrQIOrRddnwK1FDcQ3N6KX1+WHr8abifdvijJLnE0O3cz4DLa0M4m5hDtX5uQbmp4EgAsA5IIP0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD9331A2D;
	Wed, 25 Jun 2025 08:48:41 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BDE53F58B;
	Wed, 25 Jun 2025 08:48:55 -0700 (PDT)
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
	andre.przywara@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v4 07/13] scripts: Add default arguments for kvmtool
Date: Wed, 25 Jun 2025 16:48:07 +0100
Message-ID: <20250625154813.27254-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes v3->v4:

* Use vmm_default_opts() instead of indexing into vmm_optname
* Reworded the help test for --nodefaults as per Shaoqin's suggestion.

 scripts/common.bash |  6 +++---
 scripts/vmm.bash    | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 7c1b89f1b3c2..d5d3101c8089 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -37,7 +37,7 @@ function for_each_unittest()
 			# -append as a kernel parameter instead of a command
 			# line option.
 			test_args=""
-			opts=""
+			opts="$(vmm_default_opts)"
 			groups=""
 			arch=""
 			machine=""
@@ -51,7 +51,7 @@ function for_each_unittest()
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
 			test_args="$(vmm_optname_args) ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^$params_name\ *=\ *'"""'(.*)$ ]]; then
-			opts=${BASH_REMATCH[1]}$'\n'
+			opts="$(vmm_defaults_opts) ${BASH_REMATCH[1]}$'\n'"
 			while read -r -u $fd; do
 				#escape backslash newline, but not double backslash
 				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
@@ -67,7 +67,7 @@ function for_each_unittest()
 				fi
 			done
 		elif [[ $line =~ ^$params_name\ *=\ *(.*)$ ]]; then
-			opts=${BASH_REMATCH[1]}
+			opts="$(vmm_default_opts) ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 0dd3f971ecdf..368690d62473 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -1,3 +1,14 @@
+# The following parameters are enabled by default when running a test with
+# kvmtool:
+# --nodefaults: suppress VM configuration that cannot be disabled (like
+#               modifying the supplied kernel command line). Otherwise tests
+#               that use the command line will fail without this parameter.
+# --network mode=none: do not create a network device. kvmtool tries to help the
+#               user by automatically create one, and then prints a warning
+#               when the VM terminates if the device hasn't been initialized.
+# --loglevel=warning: reduce verbosity
+: "${KVMTOOL_DEFAULT_OPTS:="--nodefaults --network mode=none --loglevel=warning"}"
+
 ##############################################################################
 # qemu_fixup_return_code translates the ambiguous exit status in Table1 to that
 # in Table2.  Table3 simply documents the complete status table.
@@ -82,11 +93,13 @@ function kvmtool_fixup_return_code()
 
 declare -A vmm_optname=(
 	[qemu,args]='-append'
+	[qemu,default_opts]=''
 	[qemu,fixup_return_code]=qemu_fixup_return_code
 	[qemu,initrd]='-initrd'
 	[qemu,nr_cpus]='-smp'
 
 	[kvmtool,args]='--params'
+	[kvmtool,default_opts]="$KVMTOOL_DEFAULT_OPTS"
 	[kvmtool,fixup_return_code]=kvmtool_fixup_return_code
 	[kvmtool,initrd]='--initrd'
 	[kvmtool,nr_cpus]='--cpus'
@@ -97,6 +110,11 @@ function vmm_optname_args()
 	echo ${vmm_optname[$(vmm_get_target),args]}
 }
 
+function vmm_default_opts()
+{
+	echo ${vmm_optname[$(vmm_get_target),default_opts]}
+}
+
 function vmm_fixup_return_code()
 {
 	${vmm_optname[$(vmm_get_target),fixup_return_code]} "$@"
-- 
2.50.0


