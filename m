Return-Path: <kvm+bounces-59507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA57EBB9B7F
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 21:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89DE83AEDF2
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 19:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B69E1D6DA9;
	Sun,  5 Oct 2025 19:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d4nVmTXA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1BE191F98
	for <kvm@vger.kernel.org>; Sun,  5 Oct 2025 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759691805; cv=none; b=MRweMBbnBWiaE5lTyfGJxgk9F4l5bRTzl+xgW38AkWx+bVKQgapHr7MJljAUyhIUnrtWyJQZuT8KZut8l+NWwV6ctxB3fZbyOEyeHzAO2FDJL5cVgu78wnnpB6puJxwrJUTD+m2Xm9j+Tqq0UHt+h4q8tTh9nVbrSlFtgiqA4Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759691805; c=relaxed/simple;
	bh=7ACw0EVVXURF7zJ9teuFNPGxEo9yGtSsw4FNj0eGUsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uq3JLiXSvls2dZSj+ISEnUdHM+ewIuep2N1nvIAG2rCPf6qVZqhkzqyF0Z4/Iskl+EoedJ8QwbxsRtNKeNkMwd192KpxUOlF143uvwixv9nVMuXDrU8cWfzlKxrFbe7DkxV2/T8QiT6fB1wsYYxEnEAr0SPXUIAe7t99GLcmz9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d4nVmTXA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759691802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G3bx+7LM3Llba1e5OHMznPMG9tdv+rmdE+oLgoJki90=;
	b=d4nVmTXA5SIkipd6Nnrkk7vz0Cmu94ymV3XuMo2MJF8LuC0cjCY7nEYs7tAg53khbBOfDV
	jdfzCewDF1aHKhmE04l9233TfA1j28bjLcI/J1mJj5ZOBtmpTOy3GVnopa2w9ap/JJg9DX
	vEfSkkvGhxi6Euck2KCB0zAbxG6hJiE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-ZJDzhTg8N-6rB4FlfbDUHw-1; Sun, 05 Oct 2025 15:16:41 -0400
X-MC-Unique: ZJDzhTg8N-6rB4FlfbDUHw-1
X-Mimecast-MFC-AGG-ID: ZJDzhTg8N-6rB4FlfbDUHw_1759691800
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso2120871f8f.0
        for <kvm@vger.kernel.org>; Sun, 05 Oct 2025 12:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759691800; x=1760296600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3bx+7LM3Llba1e5OHMznPMG9tdv+rmdE+oLgoJki90=;
        b=m29vsZ0jVnRaW7N0ne6IIjGYjfnf7CveJk4YSoiRb4Z0NGRcPtkzNkFVe/lDX+Y/2d
         o30r7o90mmfIOwsGXm9753esz+RAZzDUgIvCT+UV/kiUiTc1GsX7TgMvY3YemE3AxrrU
         wA3CH4LIcFp305EDe12TrcgO6KkLxqY3AIkbhBcelD7OBJMzkUde9Hx0SAuoQ9WUQ3O5
         fhmVTzakfV9Yhw+ZPo+GWXRsvFEjXv7U+H6NRvMUN4mdNQ98e2GSC6xCetHrB8jvLNFH
         WPZUnNIK3YXPq0lhti5V5JJZ8sPlbvECpJZHMFnys8uIZDV6voqbto/vl75oCcDpnceM
         1J1A==
X-Forwarded-Encrypted: i=1; AJvYcCUDk8U0eUG2Qa+65x/lasZXbKSQDgUQ8x06xSYswpR4jCPIm2Jhlk1ABX5Gl/GBTx7dQI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXGw/QZ74mwF0AoFeNoKySTmFXO9F/+zmBwgRi9RG/cp+ZDAl5
	2K3CPW07laLitOFHHAmxOlCcdSnBFFL96ftfhl/sDaDKPiCBiSNnNit/Zol/nhHon7RjzjVI/MC
	HMqZ+/ySILgLImbZzmXLER+BFbZlz1tPu0yjdHdoNQSo/6WeM/8f2pg==
X-Gm-Gg: ASbGncvckXjZNfmPvR3wHGTdbkkptbqP/Y1ycgPaUfxL3krH4obV3kqYVOnRLOPEUT9
	4qPPZAQFLCrawh1QAHRQzqlVPR50Zt3SvqdPPdir5mUl+dlBzo1xdAhDBkg0KNddzHqLal0QOtU
	uEqh6pb8ZTk+cYGNpR27LISe1+gqzzZaHBml3S1xYtvOjT4KeofJspjScmbaXrDFwijMFRHq/Ok
	0GpR6vFV63EsEuDWdGbkZc6SsalS0j6O4NYWkYNz7r87w8gS7vlgSrUcM0iAeRD4zxIvwZz9QG2
	7Hzpwz+oLeZEIgxCa+hhgKBpd8hFa/SJTFkTRzo=
X-Received: by 2002:a05:600c:6b70:b0:46e:33ed:bca4 with SMTP id 5b1f17b1804b1-46e68c0753amr67499625e9.15.1759691799693;
        Sun, 05 Oct 2025 12:16:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuGB3l3pIDXSGVrRuUrUnctbOBh/MSrjC9rDycwWkkElXPcoaV30umY+0jkaNBvq5iVZK9zA==
X-Received: by 2002:a05:600c:6b70:b0:46e:33ed:bca4 with SMTP id 5b1f17b1804b1-46e68c0753amr67499405e9.15.1759691799158;
        Sun, 05 Oct 2025 12:16:39 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1518:6900:b69a:73e1:9698:9cd3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46f9c8873f1sm22226505e9.8.2025.10.05.12.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 12:16:38 -0700 (PDT)
Date: Sun, 5 Oct 2025 15:16:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 16/75] acpi/ghes: Cleanup the code which gets ghes ged state
Message-ID: <1547c5a5ff894eac9d3666ded3cbf80ce82a28e4.1759691708.git.mst@redhat.com>
References: <cover.1759691708.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759691708.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Move the check logic into a common function and simplify the
code which checks if GHES is enabled and was properly setup.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <2bbb1d3eb88b0a668114adef2f1c2a94deebba0e.1758610789.git.mchehab+huawei@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/acpi/ghes.h | 14 +++++++-------
 hw/acpi/ghes-stub.c    |  7 ++++---
 hw/acpi/ghes.c         | 38 +++++++++++---------------------------
 target/arm/kvm.c       |  7 +++++--
 4 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 39619a2457..f96ac3e85c 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -66,7 +66,6 @@ enum {
 
 typedef struct AcpiGhesState {
     uint64_t hw_error_le;
-    bool present; /* True if GHES is present at all on this board */
 } AcpiGhesState;
 
 void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
@@ -74,15 +73,16 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
-int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
-void ghes_record_cper_errors(const void *cper, size_t len,
+int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t error_physical_addr);
+void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
 
 /**
- * acpi_ghes_present: Report whether ACPI GHES table is present
+ * acpi_ghes_get_state: Get a pointer for ACPI ghes state
  *
- * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_memory_errors() to record a memory error.
+ * Returns: a pointer to ghes state if the system has an ACPI GHES table,
+ * NULL, otherwise.
  */
-bool acpi_ghes_present(void);
+AcpiGhesState *acpi_ghes_get_state(void);
 #endif
diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index 7cec1812da..40f660c246 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,12 +11,13 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t physical_address)
 {
     return -1;
 }
 
-bool acpi_ghes_present(void)
+AcpiGhesState *acpi_ghes_get_state(void)
 {
-    return false;
+    return NULL;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index b709c177cd..84b891fd3d 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -360,18 +360,12 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
     /* Create a read-write fw_cfg file for Address */
     fw_cfg_add_file_callback(s, ACPI_HW_ERROR_ADDR_FW_CFG_FILE, NULL, NULL,
         NULL, &(ags->hw_error_le), sizeof(ags->hw_error_le), false);
-
-    ags->present = true;
 }
 
 static void get_hw_error_offsets(uint64_t ghes_addr,
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
@@ -390,35 +384,20 @@ static void get_hw_error_offsets(uint64_t ghes_addr,
     *read_ack_register_addr = ghes_addr + sizeof(uint64_t);
 }
 
-void ghes_record_cper_errors(const void *cper, size_t len,
+void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
                              uint16_t source_id, Error **errp)
 {
     uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
-    AcpiGedState *acpi_ged_state;
-    AcpiGhesState *ags;
 
     if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
         error_setg(errp, "GHES CPER record is too big: %zd", len);
         return;
     }
 
-    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
-                                                       NULL));
-    if (!acpi_ged_state) {
-        error_setg(errp, "Can't find ACPI_GED object");
-        return;
-    }
-    ags = &acpi_ged_state->ghes_state;
-
     assert(ACPI_GHES_ERROR_SOURCE_COUNT == 1);
     get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
                          &cper_addr, &read_ack_register_addr);
 
-    if (!cper_addr) {
-        error_setg(errp, "can not find Generic Error Status Block");
-        return;
-    }
-
     cpu_physical_memory_read(read_ack_register_addr,
                              &read_ack_register, sizeof(read_ack_register));
 
@@ -444,7 +423,8 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     return;
 }
 
-int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
@@ -470,7 +450,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
     acpi_ghes_build_append_mem_cper(block, physical_address);
 
     /* Report the error */
-    ghes_record_cper_errors(block->data, block->len, source_id, &errp);
+    ghes_record_cper_errors(ags, block->data, block->len, source_id, &errp);
 
     g_array_free(block, true);
 
@@ -482,7 +462,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
     return 0;
 }
 
-bool acpi_ghes_present(void)
+AcpiGhesState *acpi_ghes_get_state(void)
 {
     AcpiGedState *acpi_ged_state;
     AcpiGhesState *ags;
@@ -491,8 +471,12 @@ bool acpi_ghes_present(void)
                                                        NULL));
 
     if (!acpi_ged_state) {
-        return false;
+        return NULL;
     }
     ags = &acpi_ged_state->ghes_state;
-    return ags->present;
+
+    if (!ags->hw_error_le) {
+        return NULL;
+    }
+    return ags;
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b8a1c071f5..891d4fcde9 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2433,10 +2433,12 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 {
     ram_addr_t ram_addr;
     hwaddr paddr;
+    AcpiGhesState *ags;
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
-    if (acpi_ghes_present() && addr) {
+    ags = acpi_ghes_get_state();
+    if (ags && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
@@ -2454,7 +2456,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SEA,
+                                             paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
                     error_report("failed to record the error");
-- 
MST


