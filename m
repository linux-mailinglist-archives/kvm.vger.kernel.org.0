Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0836455CD0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhKRNjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:39:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231420AbhKRNjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637242569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i0jWfCVy5hsGWWk378HfV5JQITTylC4Ln+G643a7bz0=;
        b=d7NPpS1y/M7g9qfDXvElc25uxDn8zhKm3cIiwZHPn0PWnEoRwDqmdbUZLXZ2W3jO0+JvPK
        VBJR/YCkqIq/rcSjtRmAWx/WPeFIQGDRRewUEnEOdRrIEMlG1je49kFjkCg742XsQDhQXW
        Ga5OUGYooZ9lGpazJFyjBJtYLsC3j/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-hUyKkSDmOT6NqcLCvhAdkA-1; Thu, 18 Nov 2021 08:36:05 -0500
X-MC-Unique: hUyKkSDmOT6NqcLCvhAdkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03DBE100E320;
        Thu, 18 Nov 2021 13:36:04 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.33.36.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ECC756A90;
        Thu, 18 Nov 2021 13:36:02 +0000 (UTC)
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
Subject: [PULL 4/6] target/i386/sev: Fail when invalid hashes table area detected
Date:   Thu, 18 Nov 2021 13:35:30 +0000
Message-Id: <20211118133532.2029166-5-berrange@redhat.com>
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

Commit cff03145ed3c ("sev/i386: Introduce sev_add_kernel_loader_hashes
for measured linux boot", 2021-09-30) introduced measured direct boot
with -kernel, using an OVMF-designated hashes table which QEMU fills.

However, no checks are performed on the validity of the hashes area
designated by OVMF.  Specifically, if OVMF publishes the
SEV_HASH_TABLE_RV_GUID entry but it is filled with zeroes, this will
cause QEMU to write the hashes entries over the first page of the
guest's memory (GPA 0).

Add validity checks to the published area.  If the hashes table area's
base address is zero, or its size is too small to fit the aligned hashes
table, display an error and stop the guest launch.  In such case, the
following error will be displayed:

    qemu-system-x86_64: SEV: guest firmware hashes table area is invalid (base=0x0 size=0x0)

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Reported-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 target/i386/sev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6ff196f7ad..d11b512361 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1221,7 +1221,7 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     uint8_t kernel_hash[HASH_SIZE];
     uint8_t *hashp;
     size_t hash_len = HASH_SIZE;
-    int aligned_len;
+    int aligned_len = ROUND_UP(sizeof(SevHashTable), 16);
 
     /*
      * Only add the kernel hashes if the sev-guest configuration explicitly
@@ -1237,6 +1237,11 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
         return false;
     }
     area = (SevHashTableDescriptor *)data;
+    if (!area->base || area->size < aligned_len) {
+        error_setg(errp, "SEV: guest firmware hashes table area is invalid "
+                         "(base=0x%x size=0x%x)", area->base, area->size);
+        return false;
+    }
 
     /*
      * Calculate hash of kernel command-line with the terminating null byte. If
@@ -1295,7 +1300,6 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     memcpy(ht->kernel.hash, kernel_hash, sizeof(ht->kernel.hash));
 
     /* When calling sev_encrypt_flash, the length has to be 16 byte aligned */
-    aligned_len = ROUND_UP(ht->len, 16);
     if (aligned_len != ht->len) {
         /* zero the excess data so the measurement can be reliably calculated */
         memset(ht->padding, 0, aligned_len - ht->len);
-- 
2.31.1

