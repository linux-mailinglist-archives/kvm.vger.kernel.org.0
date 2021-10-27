Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF2D43C9F4
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbhJ0Ms2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240311AbhJ0Ms1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8/nicczR9pseL6axCf0NoW1qX9tQ1hx5V0enNVRtU0=;
        b=RgXUaHtNz7/b/WiA9BI7rxGRMeLMXUvT0eFvT0fRagj2P+jJHR/I2wgATY0GHBZUFiKYmG
        D/555mx5wjNylk46MPZFP4a9KecSU1dD5FaRDZaP43efxI7Drl6EW4WkR2i0NJb7ANmWgE
        fHkKanGcDfpNmJDT1tQAA8F5xRZ9vO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-DbfXdOn_NBeY2lX9nHYyZg-1; Wed, 27 Oct 2021 08:45:58 -0400
X-MC-Unique: DbfXdOn_NBeY2lX9nHYyZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7FC410A8E01;
        Wed, 27 Oct 2021 12:45:56 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76C95196E6;
        Wed, 27 Oct 2021 12:45:53 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 05/12] memory-device: Move memory_device_check_addable() directly into memory_device_pre_plug()
Date:   Wed, 27 Oct 2021 14:45:24 +0200
Message-Id: <20211027124531.57561-6-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move it out of memory_device_get_free_addr(), which is cleaner and
prepares for future changes.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 7f76a09e57..68a2c3dbcc 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -67,9 +67,10 @@ static int memory_device_used_region_size(Object *obj, void *opaque)
     return 0;
 }
 
-static void memory_device_check_addable(MachineState *ms, uint64_t size,
+static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
                                         Error **errp)
 {
+    const uint64_t size = memory_region_size(mr);
     uint64_t used_region_size = 0;
 
     /* we will need a new memory slot for kvm and vhost */
@@ -99,7 +100,6 @@ static uint64_t memory_device_get_free_addr(MachineState *ms,
                                             uint64_t align, uint64_t size,
                                             Error **errp)
 {
-    Error *err = NULL;
     GSList *list = NULL, *item;
     Range as, new = range_empty;
 
@@ -125,12 +125,6 @@ static uint64_t memory_device_get_free_addr(MachineState *ms,
                     align);
     }
 
-    memory_device_check_addable(ms, size, &err);
-    if (err) {
-        error_propagate(errp, err);
-        return 0;
-    }
-
     if (hint && !QEMU_IS_ALIGNED(*hint, align)) {
         error_setg(errp, "address must be aligned to 0x%" PRIx64 " bytes",
                    align);
@@ -259,6 +253,11 @@ void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
         goto out;
     }
 
+    memory_device_check_addable(ms, mr, &local_err);
+    if (local_err) {
+        goto out;
+    }
+
     if (legacy_align) {
         align = *legacy_align;
     } else {
-- 
2.31.1

