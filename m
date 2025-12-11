Return-Path: <kvm+bounces-65754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E0BCB586B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:32:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B77E4301D67D
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4061303A3A;
	Thu, 11 Dec 2025 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dBiNUFP2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1272D8DA4
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765449129; cv=none; b=RTVA3GN4I8QiA0514ZpIimevYPBhfMs/FvwzgTSzHX4KOGffwyKpX5kaXn28dQUk5aUQZQlVSBF65qZXPgRI52bYGY/0dKG83P+DH2gtrMmU+uyv9bxjvi6SI+aELC5iTnxJO370wdfPwsDDxPr/SgdMio5UcV0w+34V/MPM+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765449129; c=relaxed/simple;
	bh=G3rCKdudT6NtWUagNnmaDsq7+d5yFm9atLfBfiW1Cnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq5YWB6XX96/614Y5NRiNW4XvH1FKLlIXusiAwwdFkHdtrGEba847lGuF5Cczpi1WYbwyw8ut9Exk4Eh8fDQ3jz5DqXykLVJLWxkk4vlMMPDOf9at/1FYyBRxavrGhShLtXNv1LwdQ0H7oHdYgQDIlXGzHt5hdpKzZt3ZJeksV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dBiNUFP2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765449125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiqwH+EbrOicd1rdvR0ZlaJPF+L0oee3OxmFWoyqXNY=;
	b=dBiNUFP2EkaO6bL0qqL5kpydYbONGIY6RAQ5HubbSKCLPAPRhBO/yE7CumBsli4+WuRk0R
	IDx7L5OwfZ16A90n7NjiXDGz3iw1t+nqc1GLNt8uFb55/i0JmvdiimD10T5Ql8iMy3zBV8
	3H4xrG0hcHb14s4Ci2eq4qfy+acbrS8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-F9NmniNwPsarQBtvqBKzvQ-1; Thu,
 11 Dec 2025 05:32:02 -0500
X-MC-Unique: F9NmniNwPsarQBtvqBKzvQ-1
X-Mimecast-MFC-AGG-ID: F9NmniNwPsarQBtvqBKzvQ_1765449120
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EE0319560B2;
	Thu, 11 Dec 2025 10:32:00 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.89])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 532051800451;
	Thu, 11 Dec 2025 10:31:54 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v2 3/3] igvm: Fill MADT IGVM parameter field
Date: Thu, 11 Dec 2025 11:31:36 +0100
Message-ID: <20251211103136.1578463-4-osteffen@redhat.com>
In-Reply-To: <20251211103136.1578463-1-osteffen@redhat.com>
References: <20251211103136.1578463-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Use the new acpi_build_madt_standalone() function to fill the MADT
parameter field.

The IGVM parameter can be consumed by Coconut SVSM [1], instead of
relying on the fw_cfg interface, which has caused problems before due to
unexpected access [2,3]. Using IGVM parameters is the default way for
Coconut SVSM; switching over would allow removing specialized code paths
for QEMU in Coconut.

In any case OVMF, which runs after SVSM has already been initialized,
will continue reading all ACPI tables via fw_cfg and provide fixed up
ACPI data to the OS as before.

Generating the MADT twice (here and during ACPI table building)
seems acceptable, since there is no infrastructure to obtain the MADT
out of the ACPI table memory area.

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm-cfg.c       |  8 +++++++-
 backends/igvm.c           | 37 ++++++++++++++++++++++++++++++++++++-
 include/system/igvm-cfg.h |  5 ++++-
 include/system/igvm.h     |  2 +-
 target/i386/sev.c         |  5 +++--
 5 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
index c1b45401f4..0a77f7b7a1 100644
--- a/backends/igvm-cfg.c
+++ b/backends/igvm-cfg.c
@@ -17,6 +17,7 @@
 #include "qom/object_interfaces.h"
 #include "hw/qdev-core.h"
 #include "hw/boards.h"
+#include "hw/i386/acpi-build.h"
 
 #include "trace.h"
 
@@ -48,10 +49,15 @@ static void igvm_reset_hold(Object *obj, ResetType type)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
     IgvmCfg *igvm = IGVM_CFG(obj);
+    GArray *madt = NULL;
 
     trace_igvm_reset_hold(type);
 
-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
+    madt = acpi_build_madt_standalone(ms);
+
+    qigvm_process_file(igvm, ms->cgs, false, madt, &error_fatal);
+
+    g_array_free(madt, true);
 }
 
 static void igvm_reset_exit(Object *obj, ResetType type)
diff --git a/backends/igvm.c b/backends/igvm.c
index a350c890cc..7e56b19b0a 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -93,6 +93,7 @@ typedef struct QIgvm {
     unsigned region_start_index;
     unsigned region_last_index;
     unsigned region_page_count;
+    GArray *madt;
 } QIgvm;
 
 static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
@@ -120,6 +121,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
 static int qigvm_initialization_guest_policy(QIgvm *ctx,
                                        const uint8_t *header_data,
                                        Error **errp);
+static int qigvm_initialization_madt(QIgvm *ctx,
+                                     const uint8_t *header_data, Error **errp);
 
 struct QIGVMHandler {
     uint32_t type;
@@ -148,6 +151,8 @@ static struct QIGVMHandler handlers[] = {
       qigvm_directive_snp_id_block },
     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
       qigvm_initialization_guest_policy },
+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
+      qigvm_initialization_madt },
 };
 
 static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
@@ -764,6 +769,34 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
     return 0;
 }
 
+static int qigvm_initialization_madt(QIgvm *ctx,
+                                     const uint8_t *header_data, Error **errp)
+{
+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
+    QIgvmParameterData *param_entry;
+
+    if (ctx->madt == NULL) {
+        return 0;
+    }
+
+    /* Find the parameter area that should hold the device tree */
+    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
+    {
+        if (param_entry->index == param->parameter_area_index) {
+
+            if (ctx->madt->len > param_entry->size) {
+                error_setg(
+                    errp,
+                    "IGVM: MADT size exceeds parameter area defined in IGVM file");
+                return -1;
+            }
+            memcpy(param_entry->data, ctx->madt->data, ctx->madt->len);
+            break;
+        }
+    }
+    return 0;
+}
+
 static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
 {
     int32_t header_count;
@@ -892,7 +925,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
 }
 
 int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
-                       bool onlyVpContext, Error **errp)
+                       bool onlyVpContext, GArray *madt, Error **errp)
 {
     int32_t header_count;
     QIgvmParameterData *parameter;
@@ -915,6 +948,8 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
     ctx.cgs = cgs;
     ctx.cgsc = cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL;
 
+    ctx.madt = madt;
+
     /*
      * Check that the IGVM file provides configuration for the current
      * platform
diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
index 7dc48677fd..d5138f745c 100644
--- a/include/system/igvm-cfg.h
+++ b/include/system/igvm-cfg.h
@@ -40,10 +40,13 @@ typedef struct IgvmCfgClass {
      * in the IGVM file will be processed, allowing information about the
      * CPU state to be determined before processing the entire file.
      *
+     * @madt: Optional ACPI MADT data to pass to the guest via the IGVM_VHT_MADT
+     *       parameter. Only relevant if onlyVpContext is false.
+     *
      * Returns 0 for ok and -1 on error.
      */
     int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
-                   bool onlyVpContext, Error **errp);
+                   bool onlyVpContext, GArray *madt, Error **errp);
 
 } IgvmCfgClass;
 
diff --git a/include/system/igvm.h b/include/system/igvm.h
index ec2538daa0..f2e580e4ee 100644
--- a/include/system/igvm.h
+++ b/include/system/igvm.h
@@ -18,7 +18,7 @@
 
 IgvmHandle qigvm_file_init(char *filename, Error **errp);
 int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
-                      bool onlyVpContext, Error **errp);
+                      bool onlyVpContext, GArray *madt, Error **errp);
 
 /* x86 native */
 int qigvm_x86_get_mem_map_entry(int index,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fd2dada013..55fd20510a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1888,11 +1888,12 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
          * we need to pre-process it here to extract sev_features in order to
          * provide it to KVM_SEV_INIT2. Each cgs_* function that is called by
          * the IGVM processor detects this pre-process by observing the state
-         * as SEV_STATE_UNINIT.
+         * as SEV_STATE_UNINIT. The IGVM file is only read here, no MADT data
+         * needs to be supplied.
          */
         if (x86machine->igvm) {
             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
-                    ->process(x86machine->igvm, machine->cgs, true, errp) ==
+                    ->process(x86machine->igvm, machine->cgs, true, NULL, errp) ==
                 -1) {
                 return -1;
             }
-- 
2.52.0


