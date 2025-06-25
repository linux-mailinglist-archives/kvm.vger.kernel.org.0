Return-Path: <kvm+bounces-50718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39759AE88A6
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE3954A6061
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E52289823;
	Wed, 25 Jun 2025 15:48:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CC213A3F7;
	Wed, 25 Jun 2025 15:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866527; cv=none; b=NgabbS5h0+Apf/KmaelMtM8y44RTcte7H+FyqIVAdQGgXAtkFS03NHrx6vj2YRBRm2xBF0JG8uqH8mFSW4HLEulIS06fSV1kvgcKnEcI65HFAgSBp/EO7BgYf0DwfnDlVTJXEEOw69egbFPvYkobXUe5oRJQP2RGqZHHNr8ptk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866527; c=relaxed/simple;
	bh=5lU4H05w600J/E1YmIBX07CPs82h+3zW96SyEFsmK1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDScXSXTDGUEiL7y9NFJm1Jm8zCMaMDsQ59xc8Yyqn+atoBD3kMiteeNUKi4FS2cAVJG38h/3xYIaGqwrPyyvClP1FOpY1AnBbn90u0IaIwwx8AAs3imBYcJu509yKYJmeVzVqP5dO65EkNA3NGvXBhZ+lSPj1pFf2FRgvOvnks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D194B2103;
	Wed, 25 Jun 2025 08:48:26 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A7733F58B;
	Wed, 25 Jun 2025 08:48:40 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v4 04/13] scripts: Use an associative array for qemu argument names
Date: Wed, 25 Jun 2025 16:48:04 +0100
Message-ID: <20250625154813.27254-5-alexandru.elisei@arm.com>
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

Move away from hardcoded qemu arguments and use instead an associative
array to get the needed arguments. This paves the way for adding kvmtool
support to the scripts, which has a different syntax for the same VM
configuration parameters.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes v3->v4:

* Renamed vmm_opts to vmm_optname.
* Dropped entries for 'kernel' and 'initrd' in vmm_optname because they weren't
used in this patch.
* Use vmm_optname_nr_cpus() and vmm_optname_args() instead of directly indexing
into vmm_optname.
* Dropped the check for empty $test_args in scripts/runtime.bash::run() by
having $test_args already contain --append if not empty in
scripts/common.bash::for_each_unittest().

 scripts/common.bash  | 11 ++++++++---
 scripts/runtime.bash |  7 +------
 scripts/vmm.bash     | 15 +++++++++++++++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 9deb87d4050d..ae127bd4e208 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,4 +1,5 @@
 source config.mak
+source scripts/vmm.bash
 
 function for_each_unittest()
 {
@@ -26,8 +27,12 @@ function for_each_unittest()
 				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 			fi
 			testname=$rematch
-			smp=1
+			smp="$(vmm_optname_nr_cpus) 1"
 			kernel=""
+			# Intentionally don't use -append if test_args is empty
+			# because qemu interprets the first word after
+			# -append as a kernel parameter instead of a command
+			# line option.
 			test_args=""
 			opts=""
 			groups=""
@@ -39,9 +44,9 @@ function for_each_unittest()
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
-			smp=${BASH_REMATCH[1]}
+			smp="$(vmm_optname_nr_cpus) ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
-			test_args=${BASH_REMATCH[1]}
+			test_args="$(vmm_optname_args) ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
 			opts=${BASH_REMATCH[2]}$'\n'
 			while read -r -u $fd; do
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index bc17b89f4ff5..86d8a2cd8528 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -34,7 +34,7 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $smp $test_args $opts"
 }
 
 skip_nodefault()
@@ -88,11 +88,6 @@ function run()
     local accel="${10}"
     local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
 
-    # If $test_args is empty, qemu will interpret the first option after -append
-    # as a test argument instead of a qemu option, so make sure that doesn't
-    # happen.
-    [ -n "$test_args" ] && opts="-append $test_args $opts"
-
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
     fi
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 8365c1424a3f..7629b2b9146e 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -1,3 +1,18 @@
+declare -A vmm_optname=(
+	[qemu,args]='-append'
+	[qemu,nr_cpus]='-smp'
+)
+
+function vmm_optname_args()
+{
+	echo ${vmm_optname[$(vmm_get_target),args]}
+}
+
+function vmm_optname_nr_cpus()
+{
+	echo ${vmm_optname[$(vmm_get_target),nr_cpus]}
+}
+
 function vmm_get_target()
 {
 	if [[ -z "$TARGET" ]]; then
-- 
2.50.0


