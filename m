Return-Path: <kvm+bounces-36051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 366B0A17091
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29F9C7A43E8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6821EF093;
	Mon, 20 Jan 2025 16:44:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E959F1EE008;
	Mon, 20 Jan 2025 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391477; cv=none; b=s3nE/Wb4FEyclEh2V0+mSsd61QxaTREhuCHmnrz+p0+ZUWU0KeDpxES+TidNkklQ8BvAWdcRYhGibvr4+h6ugh4/jeGqaPLXm8qlS+2HKio5OmMSgYKcp6P9sdbzHN756sEHl6Fpmzz0tLaPePpULpf6DY2l3h2oMarODfFo1mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391477; c=relaxed/simple;
	bh=oQPuFvqZz+8QpVL27r/lIr9FEsSrJtFYCs3MYHG2bUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBOFauGEcwKO8vjPVR+ETNFuk+VNaZlBM8ZEOolIszzn0YYPvsv4AHG8MU9R8w3aNO9660UMH+mtXB11V/wyfCQSER5kceRkvXZ9FNRR2JxtollNVHq/fg3Fhv/8k+Kfrr/y/7d2l4FehknRTf27rBDHrS5z3XhA+sVhSUwqJso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00BE31D6F;
	Mon, 20 Jan 2025 08:45:04 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08CEE3F5A1;
	Mon, 20 Jan 2025 08:44:31 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 18/18] run_tests: Enable kvmtool
Date: Mon, 20 Jan 2025 16:43:16 +0000
Message-ID: <20250120164316.31473-19-alexandru.elisei@arm.com>
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

Everything is in place to run the tests using kvmtool:

$ ./configure --target=kvmtool
$ make clean && make
$ KVMTOOL=<path/to/kvmtool> ./run_tests.sh

so enable it, and remove ERRATA_FORCE=y when configuring for kvmtool,
because the runner will generate and pass the correct environment to
kvmtool.

Missing is support for EFI tests. That's because distros don't ship a
EDK2 binary compiled for kvmtool, and on top of that kvm-unit-tests as
an EFI app hasn't been tested to work with kvmtool.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Should I also revert commit 35145f140442 ("arm/arm64: kvmtool: force all tests
to run") which introduced ERRATA_FORCE? I didn't do this now in case other
architectures use it/planning to use it.

 README.md               | 15 +++++++++++++++
 arm/run                 |  2 +-
 configure               |  1 -
 run_tests.sh            |  2 +-
 scripts/mkstandalone.sh |  2 +-
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/README.md b/README.md
index be07dc28a094..5e7706f02553 100644
--- a/README.md
+++ b/README.md
@@ -65,6 +65,9 @@ or:
 
 to run them all.
 
+All tests can be run using QEMU. On arm and arm64, tests can also be run using
+kvmtool.
+
 By default the runner script searches for a suitable QEMU binary in the system.
 To select a specific QEMU binary though, specify the QEMU=path/to/binary
 environment variable:
@@ -80,10 +83,22 @@ For running tests that involve migration from one QEMU instance to another
 you also need to have the "ncat" binary (from the nmap.org project) installed,
 otherwise the related tests will be skipped.
 
+To run a test with kvmtool, please configure kvm-unit-tests accordingly first:
+
+   ./configure --arch=arm64 --target=kvmtool
+
+then run the test(s) like with QEMU above.
+
+To select a kvmtool binary, specify the KVMTOOL=path/to/binary environment
+variable. kvmtool supports only kvm as the accelerator.
+
 ## Running the tests with UEFI
 
 Check [x86/efi/README.md](./x86/efi/README.md).
 
+On arm and arm64, this is only supported with QEMU; kvmtool cannot run the
+tests under UEFI.
+
 # Tests configuration file
 
 The test case may need specific runtime configurations, for
diff --git a/arm/run b/arm/run
index 880d5afae86d..438a2617e564 100755
--- a/arm/run
+++ b/arm/run
@@ -10,7 +10,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 
 case "$TARGET" in
-qemu)
+qemu | kvmtool)
     ;;
 *)
    echo "'$TARGET' not supported"
diff --git a/configure b/configure
index 86cf1da36467..17d3d931f2c0 100755
--- a/configure
+++ b/configure
@@ -299,7 +299,6 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
         arm_uart_early_addr=0x1000000
-        errata_force=1
     else
         echo "--target must be one of 'qemu' or 'kvmtool'!"
         usage
diff --git a/run_tests.sh b/run_tests.sh
index d38954be9093..3921dcdcb344 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -110,7 +110,7 @@ while [ $# -gt 0 ]; do
 done
 
 case "$TARGET" in
-qemu)
+qemu | kvmtool)
     ;;
 *)
     echo "$0 does not support '$TARGET'"
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 10abb5e191b7..16383b05adfa 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -8,7 +8,7 @@ source config.mak
 source scripts/common.bash
 
 case "$TARGET" in
-qemu)
+qemu | kvmtool)
     ;;
 *)
     echo "'$TARGET' not supported for standlone tests"
-- 
2.47.1


