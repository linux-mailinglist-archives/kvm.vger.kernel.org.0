Return-Path: <kvm+bounces-36040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBA1A1706E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4B331613A8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1931EBFF7;
	Mon, 20 Jan 2025 16:44:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9621EB9E1;
	Mon, 20 Jan 2025 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391442; cv=none; b=Uz6x+GAB98GLN1EkGqb/0fqta/zl/0zwQ2s95RU+TioDYk3+JLSgGqj7xIGSI9Pw49+bkiz0S2nAn8kt0nBzWSwvTAoq5pZxlH1o2o3zaKG5RUriiQUlkj1WU0uZ2AeFYRBg3W92w4CmyXMFtRDUEcgGRBNgjtbj99CgumFePsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391442; c=relaxed/simple;
	bh=VRlmWOtKd0rzjKQg1nbsvS0WHqWKPiS/g0FGcXukalo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR6YoUWhXWeRVMJKYsD2ZiOR/YjU79rxPpEe8nnNaEFbUJ8JsnO5BFSdbLK7QT3ifvWmve+KQQq3elFYheAN/TbGLvgbAytxl1vulueluDJgxt5ETODH1+ooZDBIh8zyAI5VQUtoFHzPUkFsts7qnrxlohh3UVi9eTiO8OhclO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7381CE0;
	Mon, 20 Jan 2025 08:44:28 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14D993F5A1;
	Mon, 20 Jan 2025 08:43:56 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 08/18] scripts/runtime: Detect kvmtool failure in premature_failure()
Date: Mon, 20 Jan 2025 16:43:06 +0000
Message-ID: <20250120164316.31473-9-alexandru.elisei@arm.com>
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

kvm-unit-tests assumes that if the VMM is able to get to where it tries to
load the kernel, then the VMM and the configuration parameters will also
work for running the test. All of this is done in premature_failure().

Teach premature_failure() about the kvmtool's error message when it fails
to load the dummy kernel.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/runtime.bash | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 451b5585f010..ee8a188b22ce 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -12,18 +12,27 @@ extract_summary()
     tail -5 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
 }
 
-# We assume that QEMU is going to work if it tried to load the kernel
+# We assume that the VMM is going to work if it tried to load the kernel
 premature_failure()
 {
     local log
 
     log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
-    echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
-                -e "error loading" \
-                -e "failed to load" &&
-        return 1
+    case "$TARGET" in
+    qemu)
+
+        echo "$log" | grep "_NO_FILE_4Uhere_" |
+            grep -q -e "[Cc]ould not \(load\|open\) kernel" \
+                    -e "error loading" \
+                    -e "failed to load" &&
+            return 1
+        ;;
+    kvmtool)
+        echo "$log" | grep "Fatal: Unable to open kernel _NO_FILE_4Uhere_" &&
+            return 1
+        ;;
+    esac
 
     RUNTIME_log_stderr <<< "$log"
 
-- 
2.47.1


