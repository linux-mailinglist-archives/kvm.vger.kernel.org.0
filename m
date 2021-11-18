Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFDA455CD2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKRNjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:39:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231260AbhKRNjV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:39:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637242581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ytnUUif25oYMkqa8jMsmzRzFU3UWIYFhkH5hBybYE+I=;
        b=R30S1IRBDgwSpPYLVIYwTo2lq/D4XVre7ZMxRYZ1d7qM4zv70RvSTgKReBPc3Uwai83jgj
        GUM7G0OzoWU77V+76xa/CAOcxylQpEjA9QwFowz6POvSYu9Aj1pw//IC/ETX44iwlfFHJv
        KdVE29hpHqUn7tQ3IWVYBsQmIq6NdQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-fe5sf_YwNa6xoEFepYn9eA-1; Thu, 18 Nov 2021 08:36:19 -0500
X-MC-Unique: fe5sf_YwNa6xoEFepYn9eA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 141CD100E320;
        Thu, 18 Nov 2021 13:36:18 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.33.36.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BB6A62A41;
        Thu, 18 Nov 2021 13:36:16 +0000 (UTC)
From:   =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Dov Murik <dovmurik@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PULL 6/6] target/i386/sev: Replace qemu_map_ram_ptr with address_space_map
Date:   Thu, 18 Nov 2021 13:35:32 +0000
Message-Id: <20211118133532.2029166-7-berrange@redhat.com>
In-Reply-To: <20211118133532.2029166-1-berrange@redhat.com>
References: <20211118133532.2029166-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.ibm.com>

Use address_space_map/unmap and check for errors.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
[Two lines wrapped for length - Daniel]
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 target/i386/sev.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 4fd258a570..025ff7a6f8 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -37,6 +37,7 @@
 #include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/pc.h"
+#include "exec/address-spaces.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
@@ -1232,6 +1233,9 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     uint8_t kernel_hash[HASH_SIZE];
     uint8_t *hashp;
     size_t hash_len = HASH_SIZE;
+    hwaddr mapped_len = sizeof(*padded_ht);
+    MemTxAttrs attrs = { 0 };
+    bool ret = true;
 
     /*
      * Only add the kernel hashes if the sev-guest configuration explicitly
@@ -1292,7 +1296,12 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
      * Populate the hashes table in the guest's memory at the OVMF-designated
      * area for the SEV hashes table
      */
-    padded_ht = qemu_map_ram_ptr(NULL, area->base);
+    padded_ht = address_space_map(&address_space_memory, area->base,
+                                  &mapped_len, true, attrs);
+    if (!padded_ht || mapped_len != sizeof(*padded_ht)) {
+        error_setg(errp, "SEV: cannot map hashes table guest memory area");
+        return false;
+    }
     ht = &padded_ht->ht;
 
     ht->guid = sev_hash_table_header_guid;
@@ -1314,10 +1323,13 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     memset(padded_ht->padding, 0, sizeof(padded_ht->padding));
 
     if (sev_encrypt_flash((uint8_t *)padded_ht, sizeof(*padded_ht), errp) < 0) {
-        return false;
+        ret = false;
     }
 
-    return true;
+    address_space_unmap(&address_space_memory, padded_ht,
+                        mapped_len, true, mapped_len);
+
+    return ret;
 }
 
 static void
-- 
2.31.1

