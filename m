Return-Path: <kvm+bounces-69232-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMWfBrGOeGmqqwEAu9opvQ
	(envelope-from <kvm+bounces-69232-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:08:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E72492758
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DB8C301D304
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F2078F5B;
	Tue, 27 Jan 2026 10:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EO4xCfOy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590B299943
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508209; cv=none; b=dyj/8Xiiuxhlv4D5IdNJ+PUc+OsOtgq0hykw+MJJwie+PF776SpI17GU0I1OlbgdYH2JKHcX+kJ6iYOw2YbiQ9atkE09pak1Oi55x9qFn/8H5zbWF8956UO1Pm5M/QPQyfeS1um48TrHGf0m+/OzG06gEsi/mRvXxyPFrZsqors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508209; c=relaxed/simple;
	bh=TUUQlEG/a2RyMiCdbrlfAF5O1usQcBeUBDmzSq3WBLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5pY2iOQnYxAGEShzGDEBWXum9OrsgrSPw9mUAM9o42CznegE6kIjijLWZr+qremQCywBG9r5d2xE7SDXX5OWgh3qPrejxOqEKWw3jll15GZp4haJlYagS1X1mvm+4zRSayLLLJs0ptJ9CaNe9J/iT9gNAsQOoYTiF3KEk+h+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EO4xCfOy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769508207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJK70mYmfTu4Vb3wBxCU3kc4SeIhw8zwF2RBpz/uZU4=;
	b=EO4xCfOy1hic6LbxKyNJJm66rnocntylIVy7h4OOWsYGiAeUqqHYY43mEqBD//Rfq4wdVx
	nn8NpVOxGPdPxAM2XR5G8vQUOKym7AzkhTajaIdzB/iEmfa6yoLsZuENW22bgLLdgsfbNI
	2hRax89NY0eGrkzO1YDxbqVabNaJgac=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-nRC6KdMoNiGhaHGupXgGog-1; Tue,
 27 Jan 2026 05:03:24 -0500
X-MC-Unique: nRC6KdMoNiGhaHGupXgGog-1
X-Mimecast-MFC-AGG-ID: nRC6KdMoNiGhaHGupXgGog_1769508203
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84EFD19775DE;
	Tue, 27 Jan 2026 10:03:23 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.44.34.174])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCDAD180066A;
	Tue, 27 Jan 2026 10:03:17 +0000 (UTC)
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
Subject: [PATCH v5 3/6] igvm: Add common function for finding parameter entries
Date: Tue, 27 Jan 2026 11:02:54 +0100
Message-ID: <20260127100257.1074104-4-osteffen@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,intel.com,gmail.com,linaro.org,vger.kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69232-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E72492758
X-Rspamd-Action: no action

Move repeating code for finding the parameter entries in the IGVM
backend out of the parameter handlers into a common function.

A warning message is emitted in case a no parameter entry can be found
for a given index.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c | 143 ++++++++++++++++++++++++++----------------------
 1 file changed, 77 insertions(+), 66 deletions(-)

diff --git a/backends/igvm.c b/backends/igvm.c
index 4cf7b57234..213c9d337e 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "qemu/target-info-qapi.h"
 #include "system/igvm.h"
 #include "system/igvm-cfg.h"
@@ -97,6 +98,20 @@ typedef struct QIgvm {
     unsigned region_page_count;
 } QIgvm;
 
+static QIgvmParameterData*
+qigvm_find_param_entry(QIgvm *igvm, uint32_t parameter_area_index)
+{
+    QIgvmParameterData *param_entry;
+    QTAILQ_FOREACH(param_entry, &igvm->parameter_data, next)
+    {
+        if (param_entry->index == parameter_area_index) {
+            return param_entry;
+        }
+    }
+    warn_report("IGVM: No parameter area for index %u", parameter_area_index);
+    return NULL;
+}
+
 static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
                                      Error **errp);
 static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
@@ -571,58 +586,54 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
     }
 
     /* Find the parameter area that should hold the memory map */
-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
-    {
-        if (param_entry->index == param->parameter_area_index) {
-            max_entry_count =
-                param_entry->size / sizeof(IGVM_VHS_MEMORY_MAP_ENTRY);
-            mm_entry = (IGVM_VHS_MEMORY_MAP_ENTRY *)param_entry->data;
-
-            retval = get_mem_map_entry(entry, &cgmm_entry, errp);
-            while (retval == 0) {
-                if (entry >= max_entry_count) {
-                    error_setg(
-                        errp,
-                        "IGVM: guest memory map size exceeds parameter area defined in IGVM file");
-                    return -1;
-                }
-                mm_entry[entry].starting_gpa_page_number = cgmm_entry.gpa >> 12;
-                mm_entry[entry].number_of_pages = cgmm_entry.size >> 12;
-
-                switch (cgmm_entry.type) {
-                case CGS_MEM_RAM:
-                    mm_entry[entry].entry_type =
-                        IGVM_MEMORY_MAP_ENTRY_TYPE_MEMORY;
-                    break;
-                case CGS_MEM_RESERVED:
-                    mm_entry[entry].entry_type =
-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
-                    break;
-                case CGS_MEM_ACPI:
-                    mm_entry[entry].entry_type =
-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
-                    break;
-                case CGS_MEM_NVS:
-                    mm_entry[entry].entry_type =
-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PERSISTENT;
-                    break;
-                case CGS_MEM_UNUSABLE:
-                    mm_entry[entry].entry_type =
-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
-                    break;
-                }
-                retval = get_mem_map_entry(++entry, &cgmm_entry, errp);
-            }
-            if (retval < 0) {
-                return retval;
-            }
-            /* The entries need to be sorted */
-            qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
-                  qigvm_cmp_mm_entry);
+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
+    if (param_entry == NULL) {
+        return 0;
+    }
+
+    max_entry_count = param_entry->size / sizeof(IGVM_VHS_MEMORY_MAP_ENTRY);
+    mm_entry = (IGVM_VHS_MEMORY_MAP_ENTRY *)param_entry->data;
+
+    retval = get_mem_map_entry(entry, &cgmm_entry, errp);
+    while (retval == 0) {
+        if (entry >= max_entry_count) {
+            error_setg(
+                errp,
+                "IGVM: guest memory map size exceeds parameter area defined "
+                "in IGVM file");
+            return -1;
+        }
+        mm_entry[entry].starting_gpa_page_number = cgmm_entry.gpa >> 12;
+        mm_entry[entry].number_of_pages = cgmm_entry.size >> 12;
 
+        switch (cgmm_entry.type) {
+        case CGS_MEM_RAM:
+            mm_entry[entry].entry_type = IGVM_MEMORY_MAP_ENTRY_TYPE_MEMORY;
+            break;
+        case CGS_MEM_RESERVED:
+            mm_entry[entry].entry_type =
+                IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
+            break;
+        case CGS_MEM_ACPI:
+            mm_entry[entry].entry_type =
+                IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
+            break;
+        case CGS_MEM_NVS:
+            mm_entry[entry].entry_type = IGVM_MEMORY_MAP_ENTRY_TYPE_PERSISTENT;
+            break;
+        case CGS_MEM_UNUSABLE:
+            mm_entry[entry].entry_type =
+                IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
             break;
         }
+        retval = get_mem_map_entry(++entry, &cgmm_entry, errp);
+    }
+    if (retval < 0) {
+        return retval;
     }
+    /* The entries need to be sorted */
+    qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
+          qigvm_cmp_mm_entry);
     return 0;
 }
 
@@ -634,18 +645,18 @@ static int qigvm_directive_vp_count(QIgvm *ctx, const uint8_t *header_data,
     uint32_t *vp_count;
     CPUState *cpu;
 
-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
+    if (param_entry == NULL) {
+        return 0;
+    }
+
+    vp_count = (uint32_t *)(param_entry->data + param->byte_offset);
+    *vp_count = 0;
+    CPU_FOREACH(cpu)
     {
-        if (param_entry->index == param->parameter_area_index) {
-            vp_count = (uint32_t *)(param_entry->data + param->byte_offset);
-            *vp_count = 0;
-            CPU_FOREACH(cpu)
-            {
-                (*vp_count)++;
-            }
-            break;
-        }
+        (*vp_count)++;
     }
+
     return 0;
 }
 
@@ -657,15 +668,15 @@ static int qigvm_directive_environment_info(QIgvm *ctx,
     QIgvmParameterData *param_entry;
     IgvmEnvironmentInfo *environmental_state;
 
-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
-    {
-        if (param_entry->index == param->parameter_area_index) {
-            environmental_state =
-                (IgvmEnvironmentInfo *)(param_entry->data + param->byte_offset);
-            environmental_state->memory_is_shared = 1;
-            break;
-        }
+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
+    if (param_entry == NULL) {
+        return 0;
     }
+
+    environmental_state =
+        (IgvmEnvironmentInfo *)(param_entry->data + param->byte_offset);
+    environmental_state->memory_is_shared = 1;
+
     return 0;
 }
 
-- 
2.52.0


