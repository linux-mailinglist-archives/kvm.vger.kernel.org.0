Return-Path: <kvm+bounces-67567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB09D0AA89
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F05D3060894
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798EF2BDC2F;
	Fri,  9 Jan 2026 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgzsa9zL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615DE4A01
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969291; cv=none; b=pbjlxjvF3YQeM5PdR5a1bVvbB2+9FyTr6myR9vKCh2J78bguIFPSLu8o4Z6LjsZiujqy0vuHc5Aw63t0pz0JnTdQmLIHJMgfxW2Hpl9dJ23LP/iX63878mpDuM9Peie1sYUAEkCAcAYqwaUmPYOmXGSdE4g4OjMZTo0WeSKcUAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969291; c=relaxed/simple;
	bh=KJnNNqJhuqOSdB5usETLMRXkXClDDn1FKl4nMx27xS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/Tz4ae3ug07u7DiNUj+HY6bqNQ+1MqKh8TqX++iMjzoVyyG1AG4DJHajxXvb3sihlyOEisTn4jQyAhfDsWTfApfZ5pnOMgOKSL5PTB8qJk+pMP29/AQjYtos268TrdvMx3D2BnPGA/w1oRpInM84G5wvm2UQZs5knPV3DJA6i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgzsa9zL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767969289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kh5b5sfCH40GicWYc2tsY/crNp+W5lW6bAFRhHZ+qr0=;
	b=dgzsa9zLUCXdq8jZARChB1LguNuPY5V54p/FCpqt9WakpPb3P+aOBy+OPAzGRjyz94Q25x
	9IWUDD+2lzzb1B2w0Kt8ZmBrTQcjcqldjX+7ksNqaGwi2YggF/nqhXnVmgiaC/KWHd1e7i
	xr+UyxlQy+y4XU0rciqpiI2Cu4BDgZU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-Pjbg_medOXeK_QnUXxk9kg-1; Fri,
 09 Jan 2026 09:34:48 -0500
X-MC-Unique: Pjbg_medOXeK_QnUXxk9kg-1
X-Mimecast-MFC-AGG-ID: Pjbg_medOXeK_QnUXxk9kg_1767969286
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 847721956054;
	Fri,  9 Jan 2026 14:34:46 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.84])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D145180066A;
	Fri,  9 Jan 2026 14:34:40 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v3 4/6] igvm: Add common function for finding parameter entries
Date: Fri,  9 Jan 2026 15:34:11 +0100
Message-ID: <20260109143413.293593-5-osteffen@redhat.com>
In-Reply-To: <20260109143413.293593-1-osteffen@redhat.com>
References: <20260109143413.293593-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Move repeating code for finding the parameter entries in the IGVM
backend out of the parameter handlers into a common function.
---
 backends/igvm.c | 115 +++++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 54 deletions(-)

diff --git a/backends/igvm.c b/backends/igvm.c
index dc1fd026cb..a797bd741c 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -95,6 +95,18 @@ typedef struct QIgvm {
     unsigned region_page_count;
 } QIgvm;
 
+static QIgvmParameterData *qigvm_find_param_entry(QIgvm *igvm, const IGVM_VHS_PARAMETER *param) {
+
+    QIgvmParameterData *param_entry;
+    QTAILQ_FOREACH(param_entry, &igvm->parameter_data, next)
+    {
+        if (param_entry->index == param->parameter_area_index) {
+            return param_entry;
+        }
+    }
+    return NULL;
+}
+
 static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
                                      Error **errp);
 static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
@@ -576,57 +588,54 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
     }
 
     /* Find the parameter area that should hold the memory map */
-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
+    param_entry = qigvm_find_param_entry(ctx, param);
+    if (param_entry != NULL)
     {
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
+        max_entry_count =
+            param_entry->size / sizeof(IGVM_VHS_MEMORY_MAP_ENTRY);
+        mm_entry = (IGVM_VHS_MEMORY_MAP_ENTRY *)param_entry->data;
+
+        retval = get_mem_map_entry(entry, &cgmm_entry, errp);
+        while (retval == 0) {
+            if (entry >= max_entry_count) {
+                error_setg(
+                    errp,
+                    "IGVM: guest memory map size exceeds parameter area defined in IGVM file");
+                return -1;
             }
-            if (retval < 0) {
-                return retval;
+            mm_entry[entry].starting_gpa_page_number = cgmm_entry.gpa >> 12;
+            mm_entry[entry].number_of_pages = cgmm_entry.size >> 12;
+
+            switch (cgmm_entry.type) {
+            case CGS_MEM_RAM:
+                mm_entry[entry].entry_type =
+                    IGVM_MEMORY_MAP_ENTRY_TYPE_MEMORY;
+                break;
+            case CGS_MEM_RESERVED:
+                mm_entry[entry].entry_type =
+                    IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
+                break;
+            case CGS_MEM_ACPI:
+                mm_entry[entry].entry_type =
+                    IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
+                break;
+            case CGS_MEM_NVS:
+                mm_entry[entry].entry_type =
+                    IGVM_MEMORY_MAP_ENTRY_TYPE_PERSISTENT;
+                break;
+            case CGS_MEM_UNUSABLE:
+                mm_entry[entry].entry_type =
+                    IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
+                break;
             }
-            /* The entries need to be sorted */
-            qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
-                  qigvm_cmp_mm_entry);
-
-            break;
+            retval = get_mem_map_entry(++entry, &cgmm_entry, errp);
         }
+        if (retval < 0) {
+            return retval;
+        }
+        /* The entries need to be sorted */
+        qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
+                qigvm_cmp_mm_entry);
     }
     return 0;
 }
@@ -662,14 +671,12 @@ static int qigvm_directive_environment_info(QIgvm *ctx,
     QIgvmParameterData *param_entry;
     IgvmEnvironmentInfo *environmental_state;
 
-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
+    param_entry = qigvm_find_param_entry(ctx, param);
+    if (param_entry != NULL)
     {
-        if (param_entry->index == param->parameter_area_index) {
-            environmental_state =
-                (IgvmEnvironmentInfo *)(param_entry->data + param->byte_offset);
-            environmental_state->memory_is_shared = 1;
-            break;
-        }
+        environmental_state =
+            (IgvmEnvironmentInfo *)(param_entry->data + param->byte_offset);
+        environmental_state->memory_is_shared = 1;
     }
     return 0;
 }
-- 
2.52.0


