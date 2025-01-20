Return-Path: <kvm+bounces-36039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 704FDA1706A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3D25162134
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9D61EC01B;
	Mon, 20 Jan 2025 16:43:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295721EB9E1;
	Mon, 20 Jan 2025 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391438; cv=none; b=pi8r+Upwbksqkrh3SUo/eJuGsirqGxGmEbdY2vyuLtHvHjJJyJ8vL4EjuynJ+hodaW0VOT3SO5boy3HpMWFTnGbhT9iLrFGFHm49IMKQ9ndgE33BNV3HHmaHAJmMSTvveUvTiWDJczXCtXEysawMxczIVmzvVoVB46Ogmta4uhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391438; c=relaxed/simple;
	bh=+0z9ZcxM8BSGnL7S6xhZIDiNijF7rdoQ0wWPrMo55Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYHwLq+X4HcmwVy9gKrc8Zf4gdopjKvyXOI1E8TqVedEWbG4POYxRlP/62tXGM9GM2NoUX0E9JhFDiMBblqmdShMOA/CoMZFFbaaNzRvn/q6rR+PL6F5QyWCvzS7QtY5W5DmEiuELZwGLpflrS2AS0dDijL8wcsqiLWUBES/yuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B32F1CE2;
	Mon, 20 Jan 2025 08:44:25 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99F273F5A1;
	Mon, 20 Jan 2025 08:43:53 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 07/18] scripts: Introduce kvmtool_opts
Date: Mon, 20 Jan 2025 16:43:05 +0000
Message-ID: <20250120164316.31473-8-alexandru.elisei@arm.com>
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

In preparation for supporting kvmtool, create and pass the variable
'kvmtool_opts' to the arch run script $RUNTIME_arch_run.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/common.bash  |  6 ++++--
 scripts/runtime.bash | 14 +++++++++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index a40c28121b6a..1b5e0d667841 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -37,6 +37,7 @@ function for_each_unittest()
 	local check
 	local accel
 	local timeout
+	local kvmtool_opts
 	local rematch
 
 	exec {fd}<"$unittests"
@@ -45,7 +46,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
 			fi
 			testname=$rematch
 			smp=1
@@ -57,6 +58,7 @@ function for_each_unittest()
 			check=""
 			accel=""
 			timeout=""
+			kvmtool_opts=""
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
@@ -80,7 +82,7 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index a89f2d10ab78..451b5585f010 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -35,7 +35,7 @@ get_cmdline()
 {
     local kernel=$1
 
-    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $qemu_opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $opts"
 }
 
 skip_nodefault()
@@ -87,8 +87,16 @@ function run()
     local check="${CHECK:-$8}"
     local accel="$9"
     local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
-
-    qemu_opts="-smp $smp $qemu_opts"
+    local kvmtool_opts="${11}"
+
+    case "$TARGET" in
+    qemu)
+        opts="-smp $smp $qemu_opts"
+        ;;
+    kvmtool)
+        opts="--cpus $smp $kvmtool_opts"
+        ;;
+    esac
 
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
-- 
2.47.1


