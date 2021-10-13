Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0C242BCE6
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhJMKhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:37:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhJMKhx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8/nicczR9pseL6axCf0NoW1qX9tQ1hx5V0enNVRtU0=;
        b=iDTL51sbJ0QB8oTHJX/GpLYpaS1Idv3UjYJQYQTYGITuEojJNg6XzdNrb6TvJqiKtAnDvP
        01Mlado5v0MeauMHHsMHJBLsfa+fmVWX1HN2qrFuNU5nGK2FHRBQO6ed09oglSVCOIFQeY
        m09MaiIyzB6UFM7xElgHs5tnLZOnltI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-jCblcP9TML-z5svllEZhFQ-1; Wed, 13 Oct 2021 06:35:47 -0400
X-MC-Unique: jCblcP9TML-z5svllEZhFQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D78B10A8E02;
        Wed, 13 Oct 2021 10:35:46 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 947465D9D5;
        Wed, 13 Oct 2021 10:34:55 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH RFC 06/15] memory-device: Move memory_device_check_addable() directly into memory_device_pre_plug()
Date:   Wed, 13 Oct 2021 12:33:21 +0200
Message-Id: <20211013103330.26869-7-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

