Return-Path: <kvm+bounces-36042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6390A17074
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1B8C7A3A2B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969B41EBFFD;
	Mon, 20 Jan 2025 16:44:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB9F1EB9F7;
	Mon, 20 Jan 2025 16:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391449; cv=none; b=ai14CVqm5rQ+Krwmyb7vTeUOLMx9kX9eLs9ugba46yMpdQQQjV1EkgnxzwvZGjJbyPgUZ4QSrIldLMHr9ijJX85NAOBgqahG9qcMtZ62SHD86p7RF9Vn2l203mmRf5So8UFLcHM/L7+xEusPSYuXM55D+RoHpDEKXTS6SnhVyzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391449; c=relaxed/simple;
	bh=guJ8SHnjnRQ7PAUSpfkyhXyfLTmNeo8YLg2jt5EEMEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEHp3mrN3gtyfs17J6V6Hb3GPtRD7NQqyPOgOkFsLqeEXLFFZU6WUPMjg379UZsHfl4K5AQQn8jJ9LuxoT81z+P4TGqou7agaiLU1XnjPgeFBM5DdNcH+5m4UIZVd0azmnx6q8cY4QjbDUyqDqZJSijLHACD5lcjkMCnHHiCElQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9854F1D14;
	Mon, 20 Jan 2025 08:44:35 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0131C3F5A1;
	Mon, 20 Jan 2025 08:44:03 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 10/18] scripts/arch-run: Add support for kvmtool
Date: Mon, 20 Jan 2025 16:43:08 +0000
Message-ID: <20250120164316.31473-11-alexandru.elisei@arm.com>
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

Add two new functions, search_kvmtool_binary(), which, like the name
suggests, searches for the location of the kvmtool binary, and
run_kvmtool(), which runs a test with kvmtool as the VMM.

initrd_create() has also been modified to use the kvmtool syntax for
supplying an initrd, which is --initrd (two dashes instead of the single
dash that qemu uses).

arm/run does not know how to use these functions yet, but this will be
added in a subsequent patch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/arch-run.bash | 94 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 13 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d6eaf0ee5f09..34f633cade01 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -75,16 +75,47 @@ run_qemu ()
 	return $ret
 }
 
+run_kvmtool ()
+{
+	local stdout errors ret sig
+
+	initrd_create || return $?
+
+	echo -n "$@"
+	[ "$ENVIRON_DEFAULT" = "yes" ] && echo -n " #"
+	echo " $INITRD"
+
+	# stdout to {stdout}, stderr to $errors and stderr
+	exec {stdout}>&1
+	"${@}" $INITRD </dev/null 2> >(tee /dev/stderr) > /dev/fd/$stdout
+	ret=$?
+	exec {stdout}>&-
+
+	return $ret
+}
+
 run_test_status ()
 {
-	local stdout ret
+	local stdout ret ret_success
 
 	exec {stdout}>&1
-	lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
+
+	# For qemu, an exit status of 1 means that the test completed. For kvmtool,
+	# 0 means the same thing.
+	case "$TARGET" in
+	qemu)
+		ret_success=1
+		lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
+		;;
+	kvmtool)
+		ret_success=0
+		lines=$(run_kvmtool "$@" > >(tee /dev/fd/$stdout))
+		;;
+	esac
 	ret=$?
 	exec {stdout}>&-
 
-	if [ $ret -eq 1 ]; then
+	if [ $ret -eq $ret_success ]; then
 		testret=$(grep '^EXIT: ' <<<"$lines" | head -n1 | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
 		if [ "$testret" ]; then
 			if [ $testret -eq 1 ]; then
@@ -422,6 +453,25 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+search_kvmtool_binary ()
+{
+	local kvmtoolcmd kvmtool
+
+	for kvmtoolcmd in lkvm vm lkvm-static; do
+		if $kvmtoolcmd --help 2>/dev/null| grep -q 'The most commonly used'; then
+			kvmtool="$kvmtoolcmd"
+			break
+		fi
+	done
+
+	if [ -z "$kvmtool" ]; then
+		echo "A kvmtool binary was not found." >&2
+		return 2
+	fi
+
+	command -v $kvmtool
+}
+
 initrd_cleanup ()
 {
 	rm -f $KVM_UNIT_TESTS_ENV
@@ -447,7 +497,18 @@ initrd_create ()
 	fi
 
 	unset INITRD
-	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD="-initrd $KVM_UNIT_TESTS_ENV"
+	if [ ! -f "$KVM_UNIT_TESTS_ENV" ]; then
+		return 0
+	fi
+
+	case "$TARGET" in
+		qemu)
+			INITRD="-initrd $KVM_UNIT_TESTS_ENV"
+			;;
+		kvmtool)
+			INITRD="--initrd $KVM_UNIT_TESTS_ENV"
+			;;
+	esac
 
 	return 0
 }
@@ -471,18 +532,25 @@ env_params ()
 	local qemu have_qemu
 	local _ rest
 
-	qemu=$(search_qemu_binary) && have_qemu=1
+	env_add_params TARGET
+
+	# kvmtool's versioning has been broken since it was split from the kernel
+	# source.
+	if [ "$TARGET" = "qemu" ]; then
+		qemu=$(search_qemu_binary) && have_qemu=1
 
-	if [ "$have_qemu" ]; then
-		if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
-			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
+		if [ "$have_qemu" ]; then
+			if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
+				[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
+			fi
+			QEMU_VERSION_STRING="$($qemu -h | head -1)"
+			# Shellcheck does not see QEMU_MAJOR|MINOR|MICRO are used
+			# shellcheck disable=SC2034
+			IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
 		fi
-		QEMU_VERSION_STRING="$($qemu -h | head -1)"
-		# Shellcheck does not see QEMU_MAJOR|MINOR|MICRO are used
-		# shellcheck disable=SC2034
-		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
+
+		env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
 	fi
-	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
 
 	KERNEL_VERSION_STRING=$(uname -r)
 	IFS=. read -r KERNEL_VERSION KERNEL_PATCHLEVEL rest <<<"$KERNEL_VERSION_STRING"
-- 
2.47.1


