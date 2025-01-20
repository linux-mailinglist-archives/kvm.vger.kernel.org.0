Return-Path: <kvm+bounces-36047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E097A17084
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E873AA525
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656EA1EEA39;
	Mon, 20 Jan 2025 16:44:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867D91EE7CB;
	Mon, 20 Jan 2025 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391462; cv=none; b=dTiRI3jQj1AAyJcN9O3H9H/jmZ9f+9wckPkr3f4w5vslelN8K1EAQ7//tdhbz0hkMeperXWdYOXoLA4X6wwkwMYSyrBfopLfeRqO2A+4pdZaCOR/SyudTD2TvG65sTL31w/5zMqzKXmqrXW06rdZpfHox+LLlwpvNRj2DCqTQrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391462; c=relaxed/simple;
	bh=F5JLESh64pYGf8TOT5XAacDpOwefATNhBDvIEA6pnoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEK8AmRXGN7eztZ7SNjWnLdAog5fvICqnGDuDsVCA2y5b63nKtW9K+Hg+BKleTneloe+4KSZcW5ZDKJmUicmTCLzeu8aInmhf2l5FfiGRzCZkOMBZy47UYFbx7PskkL+n7pg5g/IB3TUck9Q2eEy59pP0aMmt+Yt8uYDjMZTJys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AD52169C;
	Mon, 20 Jan 2025 08:44:49 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E750E3F5A1;
	Mon, 20 Jan 2025 08:44:17 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 14/18] run_tests: Add KVMTOOL environment variable for kvmtool binary path
Date: Mon, 20 Jan 2025 16:43:12 +0000
Message-ID: <20250120164316.31473-15-alexandru.elisei@arm.com>
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

kvmtool is often used for prototyping new features, and a developer might
not want to install it system-wide. Add a KVMTOOL environment variable to
make it easier for tests to use a binary not in $PATH.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 run_tests.sh          | 1 +
 scripts/arch-run.bash | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index acaaadbb879b..d38954be9093 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -36,6 +36,7 @@ The following environment variables are used:
     TIMEOUT         Timeout duration for the timeout(1) command
     CHECK           Overwrites the 'check' unit test parameter (see
                     docs/unittests.txt)
+    KVMTOOL         Path to kvmtool binary for ARCH-run
 EOF
 }
 
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 34f633cade01..5d840b72f8cb 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -457,7 +457,7 @@ search_kvmtool_binary ()
 {
 	local kvmtoolcmd kvmtool
 
-	for kvmtoolcmd in lkvm vm lkvm-static; do
+	for kvmtoolcmd in ${KVMTOOL:-lkvm vm lkvm-static}; do
 		if $kvmtoolcmd --help 2>/dev/null| grep -q 'The most commonly used'; then
 			kvmtool="$kvmtoolcmd"
 			break
-- 
2.47.1


