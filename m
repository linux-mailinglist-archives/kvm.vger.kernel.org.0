Return-Path: <kvm+bounces-24996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD80195E0EC
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 05:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 203FA1C20EA5
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 03:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC842BAE5;
	Sun, 25 Aug 2024 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBbLTPSr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9376857CA7;
	Sun, 25 Aug 2024 03:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724557640; cv=none; b=IJeXCiIsBPdJVW44XchdZG7G/j64+veHWSsrwojwfudGDbEcTTrmNt6jpAQnxGuitjoq7vMxtfrFiCrFuPGvopJ9H2GO0IZpaQYHRe/m4QL4tpvKcc2pWbwteUxnQICfy/T6iRHbTf8WREs8HK4jQsBp+GKCkANe1WsKVoU+04c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724557640; c=relaxed/simple;
	bh=lvDSsNqUtQQvopqQkh5pV2gPEmOPZKjex7TqFGENmKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxzONxC1akJpLgdrMZ2VsmUL2Sxk9Za/vOL7cuLJ0STu6rbiRshk7A+jS5Y1HdzobKnrCsx6niJErnHukX4/k1cLOE2EwR4OE1U/07QvZP7PMD4hymr5ceJLoB7zRPEZ7loagvd9bEjjfnsLVYtGZoGNMxf2zB2G2AoII5zLPzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBbLTPSr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AC9C32782;
	Sun, 25 Aug 2024 03:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724557640;
	bh=lvDSsNqUtQQvopqQkh5pV2gPEmOPZKjex7TqFGENmKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBbLTPSrrjCJ/ijsVLLoEjz7uWsxO97viqL3e2POmTTrBetZT3S9ONKLweRrHh4zh
	 8SgMzAlGpCfuZcoEszdLBdosePC7SBI8zp+aJA8CXhoK3B5HGfZGYMxjI62jYvU3h2
	 M0mSqSM50ZXXwQiaCqIIuaPemAOkgKhmOzRWisxoSHU1qwYn7KBAGyXeCAkyJ/en5q
	 se1WPLOel2VgFwOzbV81xILoSP/bLIzyw3VGNfVxKaazU6HfzpipC7TEsFVXWKmDSH
	 g6z6Dbhs3suTjYx935PkEBJ18PfSERH+9JQIuFaJVbe0nD/tW1fdCEJ3E/a9Yngmzh
	 +xIgBP50RPKgg==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab@kernel.org>)
	id 1si4Ch-00000001RMg-2Qod;
	Sun, 25 Aug 2024 05:46:11 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: 
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH v9 04/12] acpi/ghes: better name GHES memory error function
Date: Sun, 25 Aug 2024 05:45:59 +0200
Message-ID: <ceb8b8f3537cf9f125fbdc86659bae25fdb34e3b.1724556967.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1724556967.git.mchehab+huawei@kernel.org>
References: <cover.1724556967.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>

The current function used to generate GHES data is specific for
memory errors. Give a better name for it, as we now have a generic
function as well.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 hw/acpi/ghes-stub.c    | 2 +-
 hw/acpi/ghes.c         | 2 +-
 include/hw/acpi/ghes.h | 4 ++--
 target/arm/kvm.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index c315de1802d6..dd41b3fd91df 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,7 +11,7 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_record_errors(uint8_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint8_t source_id, uint64_t physical_address)
 {
     return -1;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 3190eb954de4..10ed9c0614ff 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -494,7 +494,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     cpu_physical_memory_write(cper_addr, cper, len);
 }
 
-int acpi_ghes_record_errors(int source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(int source_id, uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 4b5af86ec077..be53b7c53c91 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -70,7 +70,7 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
-int acpi_ghes_record_errors(int source_id,
+int acpi_ghes_memory_errors(int source_id,
                             uint64_t error_physical_addr);
 void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
@@ -79,7 +79,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
  * acpi_ghes_present: Report whether ACPI GHES table is present
  *
  * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_record_errors() to record a memory error.
+ * safe to call acpi_ghes_memory_errors() to record a memory error.
  */
 bool acpi_ghes_present(void);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8c4c8263b85a..8e63e9a59a5e 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2373,7 +2373,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_record_errors(ARM_ACPI_HEST_SRC_ID_SEA,
+                if (!acpi_ghes_memory_errors(ARM_ACPI_HEST_SRC_ID_SEA,
                                              paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
-- 
2.46.0


