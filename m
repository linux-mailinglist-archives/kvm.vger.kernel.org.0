Return-Path: <kvm+bounces-36038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A059A17069
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB2E47A2A66
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74D11E9B28;
	Mon, 20 Jan 2025 16:43:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00DB71E9B3F;
	Mon, 20 Jan 2025 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391435; cv=none; b=rcfJfJZ1xxCaOcQkaKwev/+s5nFJDAVDUMjG5hentlXQ4wmHtM6WGZDVZxjE1j+RdxpjCTOaiypEpOOhK7bxwNyb0NII8DwZoRFn2JEdCXhTTSOnkFcGKEHvJREMZs6KYAj5rQnV8b2HH7jQl/0q0CA8OoKvkERablMtnJiLzgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391435; c=relaxed/simple;
	bh=jacWk6aUJYc+SCjwy2Kul2rVWQrs8XYtBgBQWT2mpVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyAWW38t+kpIgaZprkIsewbzOfZRm+nCL1/x08O18AOAoXK/wWD+OO9M5ZiJyvtBVGn0F4AisxkJoMiO4elItYfFMgJxBFjYW9k0eFMIkefXckDtxbLVJzgrnm629bcmvmnBsImqT8Ds6NjZrKczu0hddC4M8XCYvEIu8vGy9Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C18EE1CC4;
	Mon, 20 Jan 2025 08:44:21 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A9F03F5A1;
	Mon, 20 Jan 2025 08:43:50 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 06/18] scripts: Merge the qemu parameter -smp into $qemu_opts
Date: Mon, 20 Jan 2025 16:43:04 +0000
Message-ID: <20250120164316.31473-7-alexandru.elisei@arm.com>
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

kvmtool has a different command line parameter to specify the number of
VCPUs (-c/--cpus). To make it easier to accommodate it, merge the qemu
specific parameter -smp into $qemu_opts when passing it to the
$RUNTIME_arch_run script.

This is safe to do because the $RUNTIME_arch_run script, on all
architectures, passes the parameters right back to run_qemu() et co, and
do not treat individual parameters separately.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/runtime.bash | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index e5d661684ceb..a89f2d10ab78 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -34,7 +34,8 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $qemu_opts"
+
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $qemu_opts"
 }
 
 skip_nodefault()
@@ -87,6 +88,8 @@ function run()
     local accel="$9"
     local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
 
+    qemu_opts="-smp $smp $qemu_opts"
+
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
     fi
-- 
2.47.1


