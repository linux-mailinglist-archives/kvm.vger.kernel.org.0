Return-Path: <kvm+bounces-26894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57479978E36
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 08:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25DC028742D
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 06:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979D0126F02;
	Sat, 14 Sep 2024 06:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBYz5o2x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA69474C1B;
	Sat, 14 Sep 2024 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726294434; cv=none; b=KSNtf3/zds/BRCDbndpyfP+fbqxsJQj4fbzwFJNmXnyIgU/APfP3AyJKb7aCaqgMoFi71SoW78GYUo/w5q8c8Ar2FfOejVoVlC0usGBqgFp9WEWzThHzIFHtcQzI4wRYbdIWyllZRYU8GWrmlbK20ISxUw2N1QKycg/CzCCjqDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726294434; c=relaxed/simple;
	bh=j86Wt0drRUC8+O/GuJIO38u52d1Uwkl4NKopuoo6RP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izVtHV1oDmdOzJx3nf+PKq3KsudCvTKUsr2Ee1A2B8T5z8bpp9GwDt38UZ84xuVUGDDcL2Gkw34mTNJGJU4ffJxW9ZiCzT/zYEzRYIK+D4yI7mVdZ9TwWnsK9d8bxaEfRysC2ubKopL5GARB091ljQt9Es3zTNNE0vf4VU/9yo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBYz5o2x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30424C4CEDE;
	Sat, 14 Sep 2024 06:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726294434;
	bh=j86Wt0drRUC8+O/GuJIO38u52d1Uwkl4NKopuoo6RP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBYz5o2xAzHSKbCptSEajGxYj72BMJuTTmQrGJxcGJGCiEwk9ERy/JpI3LDVRVcOn
	 GjpC68Lg9tCOALjKczBh56apwSCIlm1pmYC3Ch+pT19wUCvqR1s2Ty4q/mRIDsDfNO
	 AHlTHdmYK7tBMWqm95Q58HBkZQSVncQUTbVBrQLqJqNhfxrui13Jf7zLUZptut3mm5
	 h6aiBfEYo8FFr7i6/akGfPexwV+QE4WWhsjmhMRtoaY2eafXnQvVPd0lNEQVDHJNAK
	 XJgZ0Fovf8W5VUPZdQ+YJrpF58b9cHxO/Y65lyBb5kpV6sYKSiAJfVoeQZD9CrRmZK
	 mhKE0H4RT4YvA==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1spM2a-00000003V6F-1A4F;
	Sat, 14 Sep 2024 08:13:52 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH v10 13/21] acpi/ghes: better name GHES memory error function
Date: Sat, 14 Sep 2024 08:13:34 +0200
Message-ID: <0f9cbeee62a22b94a6487cc444d87fabd45626f7.1726293808.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726293808.git.mchehab+huawei@kernel.org>
References: <cover.1726293808.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

The current function used to generate GHES data is specific for
memory errors. Give a better name for it, as we now have a generic
function as well.

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 hw/acpi/ghes-stub.c    | 2 +-
 hw/acpi/ghes.c         | 2 +-
 include/hw/acpi/ghes.h | 4 ++--
 target/arm/kvm.c       | 3 ++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index 58a04e935142..b0f053d5998f 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,7 +11,7 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_record_errors(int source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(int source_id, uint64_t physical_address)
 {
     return -1;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index dc15d6a693d6..a8feb39c9f30 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -501,7 +501,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     cpu_physical_memory_write(cper_addr, cper, len);
 }
 
-int acpi_ghes_record_errors(int source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(int source_id, uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 344919f1f75c..7a7961e6078a 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -82,7 +82,7 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
-int acpi_ghes_record_errors(int source_id,
+int acpi_ghes_memory_errors(int source_id,
                             uint64_t error_physical_addr);
 void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
@@ -91,7 +91,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
  * acpi_ghes_present: Report whether ACPI GHES table is present
  *
  * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_record_errors() to record a memory error.
+ * safe to call acpi_ghes_memory_errors() to record a memory error.
  */
 bool acpi_ghes_present(void);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 849e2e21b304..57192285fb96 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2373,7 +2373,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                if (!acpi_ghes_memory_errors(ARM_ACPI_HEST_SRC_ID_SYNC,
+                                             paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
                     error_report("failed to record the error");
-- 
2.46.0


