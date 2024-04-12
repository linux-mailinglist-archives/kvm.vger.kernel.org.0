Return-Path: <kvm+bounces-14511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9DF8A2C7C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D5701C20C2E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3227658112;
	Fri, 12 Apr 2024 10:35:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEA157864
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918110; cv=none; b=MznwfcsJVIvMoxzCnLbZlwBs5AAXrVjgZOEeb2y8yj7eBVgUCifq1j3oKm6wgrd4Uc5Z9m+wkbolFsoxATGB5iNfRyWWD0r993AfjCLG+7SQYIi5tiZJaNN75whX3I9vgrZyd2eb2n6FkL+Ca0tZ1KXGQNjMfppmOkN78mpcZBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918110; c=relaxed/simple;
	bh=SpT/LFvTyGusz8aCmIBMHkb4uzOotu1G8SqSr67r580=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c/zn5r/R1QrUXhFglew+3OHIhU8VeUolYcxAuFW9s9kNNL4KgXrHl1fs2qvmuUfUY8dXH1UeQuKrukfOYqAAUr0qVdoNua3JY0VH2e9Du2yOlOM92dOkWxDrt7GdvN1ipTl6KVKUT36fNpwNkVcfLwbU8zF5EAWg9F7Qt/+29s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B13E15A1;
	Fri, 12 Apr 2024 03:35:38 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B9073F64C;
	Fri, 12 Apr 2024 03:35:07 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 25/33] arm: Add build steps for QCBOR library
Date: Fri, 12 Apr 2024 11:34:00 +0100
Message-Id: <20240412103408.2706058-26-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The QCBOR library will be used for Realm attestation.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index b3e085d3..de73601d 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,8 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
+CFLAGS += -I $(SRCDIR)/lib/qcbor/inc
+CFLAGS += -DQCBOR_DISABLE_FLOAT_HW_USE -DQCBOR_DISABLE_PREFERRED_FLOAT -DUSEFULBUF_DISABLE_ALL_FLOAT
 
 sve_flag := $(call cc-option, -march=armv8.5-a+sve, "")
 ifneq ($(strip $(sve_flag)),)
@@ -35,6 +37,7 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/rsi.o
+cflatobjs += lib/qcbor/src/qcbor_decode.o lib/qcbor/src/UsefulBuf.o
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
@@ -64,4 +67,5 @@ tests += $(TEST_DIR)/realm-sea.$(exe)
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
 arch_clean: arm_clean
-	$(RM) lib/arm64/.*.d
+	$(RM) lib/arm64/.*.d		\
+	      lib/qcbor/src/.*.d
-- 
2.34.1


