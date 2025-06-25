Return-Path: <kvm+bounces-50723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 787E7AE88BF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FFF9189A88B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73F32BD03E;
	Wed, 25 Jun 2025 15:49:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0A5269AFB;
	Wed, 25 Jun 2025 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866552; cv=none; b=hIPIJ0CxVEmmGC4mj4zjAs3YPnqJ4wknxQtce3X0AVOTNu0jPN9+rH5fhwLWPVouqmMx+1FRL7GAdOuhs/TbXi0xzwqZynPHPZnlsw4tDdHaE6RI3G69Nfqd0uwFQsbxQUOsiVTqqA++g2LGAsBCyKQnUMGA7zKStaWH1l9ew0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866552; c=relaxed/simple;
	bh=dJUT46NbgoVxJI1KGwmICwjwM5Y+z6bKgrozaq4JnqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb0MCgYMPNPjH6X9Kc/5sO8xeHTTMmwNDahDmZTvL2ARmBlKBcXo2CCF2CnjU1BqQJZgRzJ7H9SSyEPK0+a3C5fzboWV3lQyZ5WAhLedSvX68P1EMLzoc9Ebax52ncHWT9veYZKg67gOxk7BymX6tCvENb2djmjyWmSfcP43co4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4245A22E6;
	Wed, 25 Jun 2025 08:48:51 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 118DB3F58B;
	Wed, 25 Jun 2025 08:49:04 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v4 09/13] scripts: Detect kvmtool failure in premature_failure()
Date: Wed, 25 Jun 2025 16:48:09 +0100
Message-ID: <20250625154813.27254-10-alexandru.elisei@arm.com>
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

kvm-unit-tests assumes that if the VMM is able to get to where it tries to
load the kernel, then the VMM and the configuration parameters will also
work for running the test. All of this is done in premature_failure().

Teach premature_failure() about the kvmtool's error message when it fails
to load the dummy kernel.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes v3->v4:

* Use vmm_parse_premature_failure() in
scripts/runtime.bash::premature_failure().
* Do not source scripts/vmm.bash in scripts/runtime.bash to avoid errors in
the standalone tests.

 scripts/mkstandalone.sh |  1 +
 scripts/runtime.bash    |  6 +-----
 scripts/vmm.bash        | 28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 9c5768563757..ebf425564af5 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -81,6 +81,7 @@ generate_test ()
 	echo "RUNTIME_log_stdout () { cat >&\$stdout; }"
 	echo "RUNTIME_log_stderr () { cat >&2; }"
 
+	cat scripts/vmm.bash
 	cat scripts/runtime.bash
 
 	echo "run ${args[*]}"
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 86d8a2cd8528..5839ca5ca665 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -19,11 +19,7 @@ premature_failure()
 
     log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
-    echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
-                -e "error loading" \
-                -e "failed to load" &&
-        return 1
+    vmm_parse_premature_failure "$log" || return 1
 
     RUNTIME_log_stderr <<< "$log"
 
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 368690d62473..44954a711cad 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -79,6 +79,18 @@ function qemu_fixup_return_code()
 	echo $ret
 }
 
+function qemu_parse_premature_failure()
+{
+	local log=$*
+
+	echo "$log" | grep "_NO_FILE_4Uhere_" |
+		grep -q -e "[Cc]ould not \(load\|open\) kernel" \
+			-e "error loading" \
+			-e "failed to load" &&
+		return 1
+	return 0
+}
+
 function kvmtool_fixup_return_code()
 {
 	local ret=$1
@@ -91,18 +103,29 @@ function kvmtool_fixup_return_code()
 	echo $ret
 }
 
+function kvmtool_parse_premature_failure()
+{
+	local log=$*
+
+	echo "$log" | grep "Fatal: Unable to open kernel _NO_FILE_4Uhere_" &&
+		return 1
+	return 0
+}
+
 declare -A vmm_optname=(
 	[qemu,args]='-append'
 	[qemu,default_opts]=''
 	[qemu,fixup_return_code]=qemu_fixup_return_code
 	[qemu,initrd]='-initrd'
 	[qemu,nr_cpus]='-smp'
+	[qemu,parse_premature_failure]=qemu_parse_premature_failure
 
 	[kvmtool,args]='--params'
 	[kvmtool,default_opts]="$KVMTOOL_DEFAULT_OPTS"
 	[kvmtool,fixup_return_code]=kvmtool_fixup_return_code
 	[kvmtool,initrd]='--initrd'
 	[kvmtool,nr_cpus]='--cpus'
+	[kvmtool,parse_premature_failure]=kvmtool_parse_premature_failure
 )
 
 function vmm_optname_args()
@@ -130,6 +153,11 @@ function vmm_optname_nr_cpus()
 	echo ${vmm_optname[$(vmm_get_target),nr_cpus]}
 }
 
+function vmm_parse_premature_failure()
+{
+	${vmm_optname[$(vmm_get_target),parse_premature_failure]} "$@"
+}
+
 function vmm_get_target()
 {
 	if [[ -z "$TARGET" ]]; then
-- 
2.50.0


