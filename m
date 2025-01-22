Return-Path: <kvm+bounces-36268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66837A195AA
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B639D163733
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22167214A8D;
	Wed, 22 Jan 2025 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoQ5v/Rg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B86214218;
	Wed, 22 Jan 2025 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737560800; cv=none; b=NKKLLwagEo0cfGlblYhgFdAocnPbLH+2llIcyecqCFHWOi1cz79HrNLQSitJp9SZ4Q8Y4TVJ8pB2yD1eLVgk7SxpdveAIMZI0Rg9l5G0OjjVi2z0rDAcUwl8yk1W3/1S5pBJy0ddCig5P5Ye8eOb2O2Ah7hei8y1DrNNAZ7aCp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737560800; c=relaxed/simple;
	bh=SDAM2Hf0+OjvENc78mlriwxC/2c7OGDKK+nhESUWpgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGeAgpJpkSVUcmLiRn4BtlbhnQN/QYozxEa9qfFTwN8V+5xKJq41jqzXrqv0Q+qrH3zInPXiQVsbLAb+bVTPGhuDcAs/HFu7wgjBmBgsYlZxjZ7coj3QP8whEO3QDmLh4OeUEn6euOVR3qS2ZcQzvxZ/M9INcoJD1gPoeJmefkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoQ5v/Rg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B56C4CEE4;
	Wed, 22 Jan 2025 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737560799;
	bh=SDAM2Hf0+OjvENc78mlriwxC/2c7OGDKK+nhESUWpgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoQ5v/Rg8D57ii/NQ0uNW6JD9BzuQ1V4D89wzL2hK4zrO5HyCWSQef4TqC8edvJM2
	 lKzhNp4d4kxEG6LYjj0QVncNjsVooYp7GNM93wh4lukvszBIjW+EIHIvemN6taSowR
	 5n8Uze/3ee/XcI3LeTj/ekV+PV/kmkOI860gil1MjptMK/TisF/w2Dt1PDIAfg6N0X
	 rMqTC+d91EOCD4gcP+kaobSknP6eXoc6/tsnpZlea/8RI+B/Oh11fUfix24YIBA5Np
	 Tq4mwZpcM4RlkiJVUicNVoka8rFN44uuWy6wEl4g6GoIBTsQqbRpd6bgXb8wL0NADK
	 mT3HoOrfAONgA==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1tacw9-00000008ogg-3xHu;
	Wed, 22 Jan 2025 16:46:37 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] acpi/ghes: Cleanup the code which gets ghes ged state
Date: Wed, 22 Jan 2025 16:46:24 +0100
Message-ID: <200501cb372d5121c44128a79b8775e529dc46e6.1737560101.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1737560101.git.mchehab+huawei@kernel.org>
References: <cover.1737560101.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Move the check logic into a common function and simplify the
code which checks if GHES is enabled and was properly setup.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 hw/acpi/ghes-stub.c    |  4 ++--
 hw/acpi/ghes.c         | 33 +++++++++++----------------------
 include/hw/acpi/ghes.h |  9 +++++----
 target/arm/kvm.c       |  2 +-
 4 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index 7cec1812dad9..fbabf955155a 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -16,7 +16,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
     return -1;
 }
 
-bool acpi_ghes_present(void)
+AcpiGhesState *acpi_ghes_get_state(void)
 {
-    return false;
+    return NULL;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 961fc38ea8f5..5d29db3918dd 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -420,10 +420,6 @@ static void get_hw_error_offsets(uint64_t ghes_addr,
                                  uint64_t *cper_addr,
                                  uint64_t *read_ack_register_addr)
 {
-    if (!ghes_addr) {
-        return;
-    }
-
     /*
      * non-HEST version supports only one source, so no need to change
      * the start offset based on the source ID. Also, we can't validate
@@ -451,10 +447,6 @@ static void get_ghes_source_offsets(uint16_t source_id, uint64_t hest_addr,
     uint64_t err_source_struct, error_block_addr;
     uint32_t num_sources, i;
 
-    if (!hest_addr) {
-        return;
-    }
-
     cpu_physical_memory_read(hest_addr, &num_sources, sizeof(num_sources));
     num_sources = le32_to_cpu(num_sources);
 
@@ -513,7 +505,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp)
 {
     uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
-    AcpiGedState *acpi_ged_state;
     AcpiGhesState *ags;
 
     if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
@@ -521,13 +512,10 @@ void ghes_record_cper_errors(const void *cper, size_t len,
         return;
     }
 
-    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
-                                                       NULL));
-    if (!acpi_ged_state) {
-        error_setg(errp, "Can't find ACPI_GED object");
+    ags = acpi_ghes_get_state();
+    if (!ags) {
         return;
     }
-    ags = &acpi_ged_state->ghes_state;
 
     if (!ags->hest_lookup) {
         get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
@@ -537,11 +525,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
                                 &cper_addr, &read_ack_register_addr, errp);
     }
 
-    if (!cper_addr) {
-        error_setg(errp, "can not find Generic Error Status Block");
-        return;
-    }
-
     cpu_physical_memory_read(read_ack_register_addr,
                              &read_ack_register, sizeof(read_ack_register));
 
@@ -605,7 +588,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
     return 0;
 }
 
-bool acpi_ghes_present(void)
+AcpiGhesState *acpi_ghes_get_state(void)
 {
     AcpiGedState *acpi_ged_state;
     AcpiGhesState *ags;
@@ -614,8 +597,14 @@ bool acpi_ghes_present(void)
                                                        NULL));
 
     if (!acpi_ged_state) {
-        return false;
+        return NULL;
     }
     ags = &acpi_ged_state->ghes_state;
-    return ags->present;
+    if (!ags->present) {
+        return NULL;
+    }
+    if (!ags->hw_error_le && !ags->hest_addr_le) {
+        return NULL;
+    }
+    return ags;
 }
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 2e8405edfe27..64fe2b5bea65 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -91,10 +91,11 @@ void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
 
 /**
- * acpi_ghes_present: Report whether ACPI GHES table is present
+ * acpi_ghes_get_state: Get a pointer for ACPI ghes state
  *
- * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_memory_errors() to record a memory error.
+ * Returns: a pointer to ghes state if the system has an ACPI GHES table,
+ * it is enabled and it is safe to call acpi_ghes_memory_errors() to record
+ * a memory error. Returns false, otherwise.
  */
-bool acpi_ghes_present(void);
+AcpiGhesState *acpi_ghes_get_state(void);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb2349..0283089713b9 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2369,7 +2369,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
-    if (acpi_ghes_present() && addr) {
+    if (acpi_ghes_get_state() && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-- 
2.48.1


