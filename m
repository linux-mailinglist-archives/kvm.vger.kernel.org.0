Return-Path: <kvm+bounces-45728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4D4AAE43D
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 436703BBAE5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED2328AAFA;
	Wed,  7 May 2025 15:13:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AFA289824;
	Wed,  7 May 2025 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630837; cv=none; b=izJ2U5b6148ISwdcpQx1/FOGnUAFL1188W7pxUCL3r/K4dSoJVToCDBYTEPelg9/xf7su7CisD6VvbGmly4sxZw9+nOaAv02FkeNXwpDNeW2GGfgj1LCXoxkESgI1NvpVPov+QIhKWUBLOoQDod4vqnLNQhI0u9B8W9qvkV1n0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630837; c=relaxed/simple;
	bh=KqVGjdtY1KplYXqLH4WAh1YQFxnkOHfZVSpRgBrU3lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlLLFo+uAS+MwMEP5+TNSXAWzuSzP+qp0BGg3NV+6oLhb2GY0auz+7fojlTM83EFAjwk3PcgXrzLhql+OkObT8Ne3rUkmVTUkld5OdwxOkXYhTJmHIPo33naXkkJ+R8RroyderIySX3GBv4BigWf31pertVENFtrDPzF7vbnvDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0CAA22D7;
	Wed,  7 May 2025 08:13:45 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0FFF3F58B;
	Wed,  7 May 2025 08:13:52 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 12/16] scripts: Detect kvmtool failure in premature_failure()
Date: Wed,  7 May 2025 16:12:52 +0100
Message-ID: <20250507151256.167769-13-alexandru.elisei@arm.com>
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

kvm-unit-tests assumes that if the VMM is able to get to where it tries to
load the kernel, then the VMM and the configuration parameters will also
work for running the test. All of this is done in premature_failure().

Teach premature_failure() about the kvmtool's error message when it fails
to load the dummy kernel.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/runtime.bash |  8 +++-----
 scripts/vmm.bash     | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 86d8a2cd8528..01ec8eae2bba 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -1,3 +1,5 @@
+source scripts/vmm.bash
+
 : "${RUNTIME_arch_run?}"
 : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
 : "${TIMEOUT:=90s}"
@@ -19,11 +21,7 @@ premature_failure()
 
     log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
-    echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
-                -e "error loading" \
-                -e "failed to load" &&
-        return 1
+    ${vmm_opts[$TARGET:parse_premature_failure]} "$log" || return 1
 
     RUNTIME_log_stderr <<< "$log"
 
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index d24a4c4b8713..a1d50ed51981 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -93,6 +93,27 @@ kvmtool_fixup_return_code()
 	echo $ret
 }
 
+function qemu_parse_premature_failure()
+{
+	local log="$@"
+
+	echo "$log" | grep "_NO_FILE_4Uhere_" |
+		grep -q -e "[Cc]ould not \(load\|open\) kernel" \
+			-e "error loading" \
+			-e "failed to load" &&
+		return 1
+	return 0
+}
+
+function kvmtool_parse_premature_failure()
+{
+	local log="$@"
+
+	echo "$log" | grep "Fatal: Unable to open kernel _NO_FILE_4Uhere_" &&
+		return 1
+	return 0
+}
+
 declare -A vmm_opts=(
 	[qemu:nr_cpus]='-smp'
 	[qemu:kernel]='-kernel'
@@ -100,6 +121,7 @@ declare -A vmm_opts=(
 	[qemu:initrd]='-initrd'
 	[qemu:default_opts]=''
 	[qemu:fixup_return_code]=qemu_fixup_return_code
+	[qemu:parse_premature_failure]=qemu_parse_premature_failure
 
 	[kvmtool:nr_cpus]='--cpus'
 	[kvmtool:kernel]='--kernel'
@@ -107,6 +129,7 @@ declare -A vmm_opts=(
 	[kvmtool:initrd]='--initrd'
 	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
 	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
+	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
 )
 
 function check_vmm_supported()
-- 
2.49.0


