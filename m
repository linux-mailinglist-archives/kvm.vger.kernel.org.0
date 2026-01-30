Return-Path: <kvm+bounces-69676-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALaMMHBGfGnfLgIAu9opvQ
	(envelope-from <kvm+bounces-69676-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:49:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF26B7773
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07F2B30432C6
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6CB374169;
	Fri, 30 Jan 2026 05:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJIESb9t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B183128B2
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752091; cv=none; b=GO249G8kURl88GvY4vpEX2j6sGpAmQqrFwV63LMdc9tSalJ487AyluwYlMEQU98QgwI5vcY/8C6uk+wLbyEs/PbkN8/lwqf+ieO/UHsMGXN+wf7ecM7b3belyhrlxRFIXiNdSgJwcZzDqoys0elRT0cBjbyBag00E/uPLucX7tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752091; c=relaxed/simple;
	bh=fDv7Z6k1Bj8e3qc+WB1PRKPA/SatzhafKYcmiP9nhmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAxIp16iVS9kfjes9jD7q/nkvzDkIrjcnnd17/4jsawU1VlENBPs44UcIDmX2wq/s/RZr2J8i9FHh5fRwuIqGog8D6oKWgtCylMQ1aQoTuotSCThxnooHFPO9y1pZU1PjabXpKG5fxWQ3xceDzpxnMSuebFXype09zpuk6T+7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HJIESb9t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769752089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1Dltb/tYVokwk1EyQOjoWzv1MpePR+VA5EOrNUdcRE=;
	b=HJIESb9tCBdREMrqoonyMP4b9DiMVBoOfEtv3jT55X+AdI9lH91wxk+D0OCW5mg2M/vg35
	GiX566ls4TF/CVWDiO879D9RCY+OK22O2l/OSMV9QpMjNkasYdf2tx8bdaT7emq4YO0Yof
	4Cqm4t9HBOq6nv+HwXzyCp4R/HyZF1o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-oNcF6eHuPRmNw1ubQ2aQFA-1; Fri,
 30 Jan 2026 00:48:05 -0500
X-MC-Unique: oNcF6eHuPRmNw1ubQ2aQFA-1
X-Mimecast-MFC-AGG-ID: oNcF6eHuPRmNw1ubQ2aQFA_1769752084
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3A051800447;
	Fri, 30 Jan 2026 05:48:03 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.45.226.150])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C61D19560A2;
	Fri, 30 Jan 2026 05:47:58 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v6 7/9] igvm: Pass machine state to IGVM file processing
Date: Fri, 30 Jan 2026 06:47:12 +0100
Message-ID: <20260130054714.715928-8-osteffen@redhat.com>
In-Reply-To: <20260130054714.715928-1-osteffen@redhat.com>
References: <20260130054714.715928-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
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
	FREEMAIL_CC(0.00)[redhat.com,intel.com,habkost.net,vger.kernel.org,linaro.org,amd.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69676-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 2AF26B7773
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
 backends/igvm-cfg.c            |  2 +-
 backends/igvm.c                | 28 ++++++++++++++++------------
 include/system/igvm-cfg.h      |  3 ++-
 include/system/igvm-internal.h |  3 ++-
 include/system/igvm.h          |  5 +++--
 target/i386/sev.c              |  3 +--
 6 files changed, 25 insertions(+), 19 deletions(-)

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
index ffd1c325b6..3e7c0ea41d 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -202,7 +202,8 @@ static void *qigvm_prepare_memory(QIgvm *ctx, uint64_t addr, uint64_t size,
         g_autofree char *region_name =
             g_strdup_printf("igvm.%X", region_identifier);
         igvm_pages = g_new0(MemoryRegion, 1);
-        if (ctx->cgs && ctx->cgs->require_guest_memfd) {
+        if (ctx->machine_state->cgs &&
+            ctx->machine_state->cgs->require_guest_memfd) {
             if (!memory_region_init_ram_guest_memfd(igvm_pages, NULL,
                                                     region_name, size, errp)) {
                 return NULL;
@@ -322,7 +323,7 @@ static int qigvm_process_mem_region(QIgvm *ctx, unsigned start_index,
      * If a confidential guest support object is provided then use it to set the
      * guest state.
      */
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         cgs_page_type =
             qigvm_type_to_cgs_type(page_type, flags->unmeasured, zero);
         if (cgs_page_type < 0) {
@@ -424,7 +425,7 @@ static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
 
     data = (uint8_t *)igvm_get_buffer(ctx->file, data_handle);
 
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result = ctx->cgsc->set_guest_state(
             vp_context->gpa, data, igvm_get_buffer_size(ctx->file, data_handle),
             CGS_PAGE_TYPE_VMSA, vp_context->vp_index, errp);
@@ -494,7 +495,7 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
      * If a confidential guest support object is provided then use it to
      * set the guest state.
      */
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result = ctx->cgsc->set_guest_state(param->gpa, region,
                                             param_entry->size,
                                             CGS_PAGE_TYPE_UNMEASURED, 0,
@@ -535,7 +536,7 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
     ConfidentialGuestMemoryMapEntry cgmm_entry;
     int retval = 0;
 
-    if (ctx->cgs && ctx->cgsc->get_mem_map_entry) {
+    if (ctx->machine_state->cgs && ctx->cgsc->get_mem_map_entry) {
         get_mem_map_entry = ctx->cgsc->get_mem_map_entry;
 
     } else if (target_arch() == SYS_EMU_TARGET_X86_64) {
@@ -661,7 +662,7 @@ static int qigvm_directive_required_memory(QIgvm *ctx,
     if (!region) {
         return -1;
     }
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result =
             ctx->cgsc->set_guest_state(mem->gpa, region, mem->number_of_bytes,
                                        CGS_PAGE_TYPE_REQUIRED_MEMORY, 0, errp);
@@ -779,14 +780,14 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
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
@@ -794,7 +795,7 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
                 }
             } else if ((platform->platform_type ==
                         IGVM_PLATFORM_TYPE_SEV_SNP) &&
-                       ctx->cgs) {
+                       ctx->machine_state->cgs) {
                 if (ctx->cgsc->check_support(
                         CGS_PLATFORM_SEV_SNP, platform->platform_version,
                         platform->highest_vtl, platform->shared_gpa_boundary)) {
@@ -867,7 +868,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
     return igvm;
 }
 
-int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
+int qigvm_process_file(IgvmCfg *cfg, MachineState *machine_state,
                        bool onlyVpContext, Error **errp)
 {
     int32_t header_count;
@@ -883,13 +884,16 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
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
diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
index 019f95e866..1d36519ab0 100644
--- a/include/system/igvm-internal.h
+++ b/include/system/igvm-internal.h
@@ -12,6 +12,7 @@
 #include "qemu/queue.h"
 #include "qemu/typedefs.h"
 #include "qom/object.h"
+#include "hw/core/boards.h"
 #include "hw/core/resettable.h"
 
 #include "system/confidential-guest-support.h"
@@ -43,7 +44,7 @@ typedef struct QIgvmParameterData {
  */
 typedef struct QIgvm {
     IgvmHandle file;
-    ConfidentialGuestSupport *cgs;
+    MachineState *machine_state;
     ConfidentialGuestSupportClass *cgsc;
     uint32_t compatibility_mask;
     unsigned current_header_index;
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


