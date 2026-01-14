Return-Path: <kvm+bounces-68066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E4CD20A81
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AAA5305845D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BA032ABCC;
	Wed, 14 Jan 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QxqBsTRm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C992FFDD5
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413048; cv=none; b=D+iUm/II4plYIPn6j2PuhEkDsu/rL1oWoZSASzTdEi6OnzT0Zp4jk9tdvinp4Y2m/5gKntuSpXT4jyBxGbUal3b5LKHdla5Knvxb3vOwZ7qz24OQWsnvHMPN3afkOzFTsFKZRBhSpRdX5nj4nwTbFIo7PyH3n5MLC1+nr2Mc9MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413048; c=relaxed/simple;
	bh=/4MljUoFSQMo676JwTLdluhoJMfJUbKCOyywZY967rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgpcA4m5RVKNZQeqOv+dJKC1NkS7I7t2UDDQPKZKd2z3L3j5zRuyVahvsd3X5vVq0u2TtrKkTfEivSwadhgcY7A6D04aMz+TGVNLnkjv5F3/Yow4ni+GGxPcQzfi7apVFqXNVq3C3XurxM7TX5Y42PVT67OTvzXIHh1LPBj+Pr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QxqBsTRm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768413046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HvCtcU3X4zMESaba3Y3b7w8sMF9sxZxPO6xg8lxyFYQ=;
	b=QxqBsTRmxADS1SV85dlLzYk/RbI5O+KnLol9uhcPAn7nYqxSuoFcjl+B0Y+C0wFEi476bv
	fz822JqgXv9Qe3CC6+4Zjli2P5QfyW47GsFkV7oMbrnX3QgJmS0dJ0Mi1B7EHx2KxWIkjl
	bzzALfM1D+BeTDrEduIZ6cZNko8zRBw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-tc7883kNPQ2uBFRJqFbSRA-1; Wed,
 14 Jan 2026 12:50:42 -0500
X-MC-Unique: tc7883kNPQ2uBFRJqFbSRA-1
X-Mimecast-MFC-AGG-ID: tc7883kNPQ2uBFRJqFbSRA_1768413041
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 429621800342;
	Wed, 14 Jan 2026 17:50:41 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.224.90])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1FB4C1800665;
	Wed, 14 Jan 2026 17:50:35 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v4 4/5] igvm: Pass machine state to IGVM file processing
Date: Wed, 14 Jan 2026 18:50:06 +0100
Message-ID: <20260114175007.90845-5-osteffen@redhat.com>
In-Reply-To: <20260114175007.90845-1-osteffen@redhat.com>
References: <20260114175007.90845-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Pass the full MachineState to the IGVM backend during file processing,
instead of just the ConfidentialGuestSupport struct (which is a member
of the MachineState).
This replaces the cgs parameter of qigvm_process_file() with the machine
state to make it available in the IGVM processing context.

We will use it later to generate MADT data there to pass to the guest
as IGVM parameter.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm-cfg.c       |  2 +-
 backends/igvm.c           | 30 +++++++++++++++++-------------
 include/system/igvm-cfg.h |  3 ++-
 include/system/igvm.h     |  5 +++--
 target/i386/sev.c         |  3 +--
 5 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
index c1b45401f4..1b35dc0a49 100644
--- a/backends/igvm-cfg.c
+++ b/backends/igvm-cfg.c
@@ -51,7 +51,7 @@ static void igvm_reset_hold(Object *obj, ResetType type)
 
     trace_igvm_reset_hold(type);
 
-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
+    qigvm_process_file(igvm, ms, false, &error_fatal);
 }
 
 static void igvm_reset_exit(Object *obj, ResetType type)
diff --git a/backends/igvm.c b/backends/igvm.c
index ccb2f51cd9..cb2f997c87 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -11,6 +11,7 @@
 
 #include "qemu/osdep.h"
 
+#include "hw/boards.h"
 #include "qapi/error.h"
 #include "qemu/target-info-qapi.h"
 #include "system/igvm.h"
@@ -70,7 +71,7 @@ struct QEMU_PACKED sev_id_authentication {
  */
 typedef struct QIgvm {
     IgvmHandle file;
-    ConfidentialGuestSupport *cgs;
+    MachineState *machine_state;
     ConfidentialGuestSupportClass *cgsc;
     uint32_t compatibility_mask;
     unsigned current_header_index;
@@ -235,7 +236,8 @@ static void *qigvm_prepare_memory(QIgvm *ctx, uint64_t addr, uint64_t size,
         g_autofree char *region_name =
             g_strdup_printf("igvm.%X", region_identifier);
         igvm_pages = g_new0(MemoryRegion, 1);
-        if (ctx->cgs && ctx->cgs->require_guest_memfd) {
+        if (ctx->machine_state->cgs &&
+            ctx->machine_state->cgs->require_guest_memfd) {
             if (!memory_region_init_ram_guest_memfd(igvm_pages, NULL,
                                                     region_name, size, errp)) {
                 return NULL;
@@ -355,7 +357,7 @@ static int qigvm_process_mem_region(QIgvm *ctx, unsigned start_index,
      * If a confidential guest support object is provided then use it to set the
      * guest state.
      */
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         cgs_page_type =
             qigvm_type_to_cgs_type(page_type, flags->unmeasured, zero);
         if (cgs_page_type < 0) {
@@ -457,7 +459,7 @@ static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
 
     data = (uint8_t *)igvm_get_buffer(ctx->file, data_handle);
 
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result = ctx->cgsc->set_guest_state(
             vp_context->gpa, data, igvm_get_buffer_size(ctx->file, data_handle),
             CGS_PAGE_TYPE_VMSA, vp_context->vp_index, errp);
@@ -525,7 +527,7 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
              * If a confidential guest support object is provided then use it to
              * set the guest state.
              */
-            if (ctx->cgs) {
+            if (ctx->machine_state->cgs) {
                 result = ctx->cgsc->set_guest_state(param->gpa, region,
                                                     param_entry->size,
                                                     CGS_PAGE_TYPE_UNMEASURED, 0,
@@ -568,7 +570,7 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
     ConfidentialGuestMemoryMapEntry cgmm_entry;
     int retval = 0;
 
-    if (ctx->cgs && ctx->cgsc->get_mem_map_entry) {
+    if (ctx->machine_state->cgs && ctx->cgsc->get_mem_map_entry) {
         get_mem_map_entry = ctx->cgsc->get_mem_map_entry;
 
     } else if (target_arch() == SYS_EMU_TARGET_X86_64) {
@@ -690,7 +692,7 @@ static int qigvm_directive_required_memory(QIgvm *ctx,
     if (!region) {
         return -1;
     }
-    if (ctx->cgs) {
+    if (ctx->machine_state->cgs) {
         result =
             ctx->cgsc->set_guest_state(mem->gpa, region, mem->number_of_bytes,
                                        CGS_PAGE_TYPE_REQUIRED_MEMORY, 0, errp);
@@ -808,14 +810,14 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
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
@@ -823,7 +825,7 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
                 }
             } else if ((platform->platform_type ==
                         IGVM_PLATFORM_TYPE_SEV_SNP) &&
-                       ctx->cgs) {
+                       ctx->machine_state->cgs) {
                 if (ctx->cgsc->check_support(
                         CGS_PLATFORM_SEV_SNP, platform->platform_version,
                         platform->highest_vtl, platform->shared_gpa_boundary)) {
@@ -896,7 +898,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
     return igvm;
 }
 
-int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
+int qigvm_process_file(IgvmCfg *cfg, MachineState *machine_state,
                        bool onlyVpContext, Error **errp)
 {
     int32_t header_count;
@@ -917,8 +919,10 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
      * guest platform to perform extra processing, such as page measurement, on
      * IGVM directives.
      */
-    ctx.cgs = cgs;
-    ctx.cgsc = cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL;
+    ctx.machine_state = machine_state;
+    ctx.cgsc = machine_state->cgs ?
+                   CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(machine_state->cgs) :
+                   NULL;
 
     /*
      * Check that the IGVM file provides configuration for the current
diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
index 7dc48677fd..51bf8d9844 100644
--- a/include/system/igvm-cfg.h
+++ b/include/system/igvm-cfg.h
@@ -12,6 +12,7 @@
 #ifndef QEMU_IGVM_CFG_H
 #define QEMU_IGVM_CFG_H
 
+#include "hw/boards.h"
 #include "qom/object.h"
 #include "hw/resettable.h"
 
@@ -42,7 +43,7 @@ typedef struct IgvmCfgClass {
      *
      * Returns 0 for ok and -1 on error.
      */
-    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
+    int (*process)(IgvmCfg *cfg, MachineState *machine_state,
                    bool onlyVpContext, Error **errp);
 
 } IgvmCfgClass;
diff --git a/include/system/igvm.h b/include/system/igvm.h
index ec2538daa0..ce023fbc9e 100644
--- a/include/system/igvm.h
+++ b/include/system/igvm.h
@@ -14,11 +14,12 @@
 
 #include "system/confidential-guest-support.h"
 #include "system/igvm-cfg.h"
+#include "hw/boards.h"
 #include "qapi/error.h"
 
 IgvmHandle qigvm_file_init(char *filename, Error **errp);
-int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
-                      bool onlyVpContext, Error **errp);
+int qigvm_process_file(IgvmCfg *igvm, MachineState *machine_state,
+                       bool onlyVpContext, Error **errp);
 
 /* x86 native */
 int qigvm_x86_get_mem_map_entry(int index,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fd2dada013..91a55ebd81 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1892,8 +1892,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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


