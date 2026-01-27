Return-Path: <kvm+bounces-69234-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AC+3N82OeGmqqwEAu9opvQ
	(envelope-from <kvm+bounces-69234-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:09:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F799278B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 194B230923FC
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B262E7621;
	Tue, 27 Jan 2026 10:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TaZir3ni"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1792E62AC
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508221; cv=none; b=jThKWChY+6LVW0rupIInLfRpNcCfcPEyGUvLn1x2IPnpt80vvfdzHgBV0Q2YQaPTz+VAdMC2MUVjNkgyUAXup/mmXXebfNijqpOqkwUKjI9KDNZS8WMMBPuOFpSw3R5Oj668OXCHaxv0Dn+qjzH/NJiXtJ3Bf0EyPYbS3PcWjsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508221; c=relaxed/simple;
	bh=C7wTOcDWIRSdt7osTfCq8IP4Oz7mE5/3BXkAFgCYI3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCAHVyyXOsiAyCM5vFyAN2WaIbNsmX3aeLN4rtx4Vp13T5Wc6PjqrqT2DvqL/ybpDRphzyVD90pI6V/pJx4s1ZPGVPeGCQ++pMchlDasTQniUM0Lbd/NIwqj8TRp+Bo0QWh1ZvvtnffHAnivXOqpzHzCjxonTD/t4LI96xJU/yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TaZir3ni; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769508219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QIN8rvBpewCUVKXyhBPq2fE6uRIvtT3wSywvie+gvME=;
	b=TaZir3niBjtjIgRNHB4TarVMUrOZ2p4BOApBZpD+2qV6t8SfNhngt4ZUyCq/io1OXt9mXP
	47dbgx+vHE6tLEPu85IWSobv9xDS1U3STzmVPKjMwgGa6FVg993GxHih6A3gYYBl+kjE1+
	JP+D66pKWSVHNZ1ekpBg7ZR8tPAMKnw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-E2h6qf6SOcqj7atksG45Rg-1; Tue,
 27 Jan 2026 05:03:35 -0500
X-MC-Unique: E2h6qf6SOcqj7atksG45Rg-1
X-Mimecast-MFC-AGG-ID: E2h6qf6SOcqj7atksG45Rg_1769508214
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76CC21955D84;
	Tue, 27 Jan 2026 10:03:34 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.44.34.174])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C3B1180066A;
	Tue, 27 Jan 2026 10:03:29 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v5 5/6] igvm: Pass machine state to IGVM file processing
Date: Tue, 27 Jan 2026 11:02:56 +0100
Message-ID: <20260127100257.1074104-6-osteffen@redhat.com>
In-Reply-To: <20260127100257.1074104-1-osteffen@redhat.com>
References: <20260127100257.1074104-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,intel.com,gmail.com,linaro.org,vger.kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69234-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[osteffen@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 86F799278B
X-Rspamd-Action: no action

Pass the full MachineState to the IGVM backend during file processing,
instead of just the ConfidentialGuestSupport struct (which is a member
of the MachineState).
This replaces the cgs parameter of qigvm_process_file() with the machine
state to make it available in the IGVM processing context.

We will use it later to generate MADT data there to pass to the guest
as IGVM parameter.

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm-cfg.c       |  2 +-
 backends/igvm.c           | 31 ++++++++++++++++++-------------
 include/system/igvm-cfg.h |  3 ++-
 include/system/igvm.h     |  5 +++--
 target/i386/sev.c         |  3 +--
 5 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
index f236b523df..64589ca34f 100644
--- a/backends/igvm-cfg.c
+++ b/backends/igvm-cfg.c
@@ -52,7 +52,7 @@ static void igvm_reset_hold(Object *obj, ResetType type)
 
     trace_igvm_reset_hold(type);
 
-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
+    qigvm_process_file(igvm, ms, false, &error_fatal);
 }
 
 static void igvm_reset_exit(Object *obj, ResetType type)
diff --git a/backends/igvm.c b/backends/igvm.c
index 0a0092fb55..f26eb633f8 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -11,6 +11,7 @@
 
 #include "qemu/osdep.h"
 
+#include "hw/core/boards.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/target-info-qapi.h"
@@ -73,7 +74,7 @@ struct QEMU_PACKED sev_id_authentication {
  */
 typedef struct QIgvm {
     IgvmHandle file;
-    ConfidentialGuestSupport *cgs;
+    MachineState *machine_state;
     ConfidentialGuestSupportClass *cgsc;
     uint32_t compatibility_mask;
     unsigned current_header_index;
@@ -239,7 +240,8 @@ static void *qigvm_prepare_memory(QIgvm *ctx, uint64_t addr, uint64_t size,
         g_autofree char *region_name =
             g_strdup_printf("igvm.%X", region_identifier);
         igvm_pages = g_new0(MemoryRegion, 1);
-        if (ctx->cgs && ctx->cgs->require_guest_memfd) {
+        if (ctx->machine_state->cgs &&
+            ctx->machine_state->cgs->require_guest_memfd) {
             if (!memory_region_init_ram_guest_memfd(igvm_pages, NULL,
                                                     region_name, size, errp)) {
                 return NULL;
@@ -359,7 +361,7 @@ static int qigvm_process_mem_region(QIgvm *ctx, unsigned start_index,
      * If a confidential guest support object is provided then use it to set the
      * guest state.
      */
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         cgs_page_type =
             qigvm_type_to_cgs_type(page_type, flags->unmeasured, zero);
         if (cgs_page_type < 0) {
@@ -461,7 +463,7 @@ static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
 
     data = (uint8_t *)igvm_get_buffer(ctx->file, data_handle);
 
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result = ctx->cgsc->set_guest_state(
             vp_context->gpa, data, igvm_get_buffer_size(ctx->file, data_handle),
             CGS_PAGE_TYPE_VMSA, vp_context->vp_index, errp);
@@ -531,7 +533,7 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
      * If a confidential guest support object is provided then use it to
      * set the guest state.
      */
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result = ctx->cgsc->set_guest_state(param->gpa, region,
                                             param_entry->size,
                                             CGS_PAGE_TYPE_UNMEASURED, 0,
@@ -572,7 +574,7 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
     ConfidentialGuestMemoryMapEntry cgmm_entry;
     int retval = 0;
 
-    if (ctx->cgs && ctx->cgsc->get_mem_map_entry) {
+    if (ctx->machine_state->cgs && ctx->cgsc->get_mem_map_entry) {
         get_mem_map_entry = ctx->cgsc->get_mem_map_entry;
 
     } else if (target_arch() == SYS_EMU_TARGET_X86_64) {
@@ -698,7 +700,7 @@ static int qigvm_directive_required_memory(QIgvm *ctx,
     if (!region) {
         return -1;
     }
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result =
             ctx->cgsc->set_guest_state(mem->gpa, region, mem->number_of_bytes,
                                        CGS_PAGE_TYPE_REQUIRED_MEMORY, 0, errp);
@@ -816,14 +818,14 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
                                                 sizeof(
                                                     IGVM_VHS_VARIABLE_HEADER));
             if ((platform->platform_type == IGVM_PLATFORM_TYPE_SEV_ES) &&
-                ctx->cgs) {
+                ctx->machine_state->cgs) {
                 if (ctx->cgsc->check_support(
                         CGS_PLATFORM_SEV_ES, platform->platform_version,
                         platform->highest_vtl, platform->shared_gpa_boundary)) {
                     compatibility_mask_sev_es = platform->compatibility_mask;
                 }
             } else if ((platform->platform_type == IGVM_PLATFORM_TYPE_SEV) &&
-                       ctx->cgs) {
+                       ctx->machine_state->cgs) {
                 if (ctx->cgsc->check_support(
                         CGS_PLATFORM_SEV, platform->platform_version,
                         platform->highest_vtl, platform->shared_gpa_boundary)) {
@@ -831,7 +833,7 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
                 }
             } else if ((platform->platform_type ==
                         IGVM_PLATFORM_TYPE_SEV_SNP) &&
-                       ctx->cgs) {
+                       ctx->machine_state->cgs) {
                 if (ctx->cgsc->check_support(
                         CGS_PLATFORM_SEV_SNP, platform->platform_version,
                         platform->highest_vtl, platform->shared_gpa_boundary)) {
@@ -904,7 +906,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
     return igvm;
 }
 
-int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
+int qigvm_process_file(IgvmCfg *cfg, MachineState *machine_state,
                        bool onlyVpContext, Error **errp)
 {
     int32_t header_count;
@@ -920,13 +922,16 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
     ctx.file = cfg->file;
     trace_igvm_process_file(cfg->file, onlyVpContext);
 
+    ctx.machine_state = machine_state;
+
     /*
      * The ConfidentialGuestSupport object is optional and allows a confidential
      * guest platform to perform extra processing, such as page measurement, on
      * IGVM directives.
      */
-    ctx.cgs = cgs;
-    ctx.cgsc = cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL;
+    ctx.cgsc = machine_state->cgs ?
+                   CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(machine_state->cgs) :
+                   NULL;
 
     /*
      * Check that the IGVM file provides configuration for the current
diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
index 6c07f30840..e06d611f74 100644
--- a/include/system/igvm-cfg.h
+++ b/include/system/igvm-cfg.h
@@ -12,6 +12,7 @@
 #ifndef QEMU_IGVM_CFG_H
 #define QEMU_IGVM_CFG_H
 
+#include "hw/core/boards.h"
 #include "qemu/typedefs.h"
 #include "qom/object.h"
 
@@ -27,7 +28,7 @@ typedef struct IgvmCfgClass {
      *
      * Returns 0 for ok and -1 on error.
      */
-    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
+    int (*process)(IgvmCfg *cfg, MachineState *machine_state,
                    bool onlyVpContext, Error **errp);
 
 } IgvmCfgClass;
diff --git a/include/system/igvm.h b/include/system/igvm.h
index 8355e54e95..5573a6111a 100644
--- a/include/system/igvm.h
+++ b/include/system/igvm.h
@@ -12,12 +12,13 @@
 #ifndef BACKENDS_IGVM_H
 #define BACKENDS_IGVM_H
 
+#include "hw/core/boards.h"
 #include "qemu/typedefs.h"
 #include "system/confidential-guest-support.h"
 #include "qapi/error.h"
 
-int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
-                      bool onlyVpContext, Error **errp);
+int qigvm_process_file(IgvmCfg *igvm, MachineState *machine_state,
+                       bool onlyVpContext, Error **errp);
 
 /* x86 native */
 int qigvm_x86_get_mem_map_entry(int index,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1d70f96ec1..6f86dd710b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1891,8 +1891,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
          */
         if (x86machine->igvm) {
             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
-                    ->process(x86machine->igvm, machine->cgs, true, errp) ==
-                -1) {
+                    ->process(x86machine->igvm, machine, true, errp) == -1) {
                 return -1;
             }
             /*
-- 
2.52.0


