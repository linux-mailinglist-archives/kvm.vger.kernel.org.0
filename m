Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DD45B35FB
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiIILCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 07:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIILC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 07:02:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA2B13D7BE
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 04:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662721303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZ7cp/F9ZhuoBQSl9KZ5nLiwALh3iP/kh0uBnlYquJs=;
        b=NJllSD2fLUvt50Qy5YrX+LKyCxl7xn7IMQ54fOAvcRecET7M5V5KvLT/cikR5G+uEnW+rs
        qOizQ7oms0NhJo43/xaW69tu56wx5HEetNBX+Xvvy2dJbKFiSr1vsBBC9rIL6bjHU1cHgm
        RCPOlZGSCyasF5cNFli8Tff0g6490a8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-YxD6is4vPkuhfgtaIIw0EQ-1; Fri, 09 Sep 2022 07:01:37 -0400
X-MC-Unique: YxD6is4vPkuhfgtaIIw0EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86AE61C068D3;
        Fri,  9 Sep 2022 11:01:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 804962166B26;
        Fri,  9 Sep 2022 11:01:28 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 1/1] kvm/kvm-all.c: implement KVM_SET_USER_MEMORY_REGION_LIST ioctl
Date:   Fri,  9 Sep 2022 07:00:34 -0400
Message-Id: <20220909110034.740282-2-eesposit@redhat.com>
In-Reply-To: <20220909110034.740282-1-eesposit@redhat.com>
References: <20220909110034.740282-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of sending memslot updates in each callback, kvm listener
already takes care of sending them in the commit phase, as multiple
ioctls.

Using the new KVM_SET_USER_MEMORY_REGION_LIST, we just need a single
call containing all memory regions to update.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9780f3d2da..6a7f7b4567 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1547,30 +1547,25 @@ static void kvm_commit(MemoryListener *listener)
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
                                           listener);
     KVMState *s = kvm_state;
-    int i;
+    int i, ret;
 
     for (i = 0; i < kml->mem_array.list->nent; i++) {
         struct kvm_userspace_memory_region_entry *mem;
-        int ret;
 
         mem = &kml->mem_array.list->entries[i];
 
-        /*
-         * Note that mem is struct kvm_userspace_memory_region_entry, while the
-         * kernel expects a kvm_userspace_memory_region, so it will currently
-         * ignore mem->invalidate_slot and mem->padding.
-         */
-        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, mem);
-
         trace_kvm_set_user_memory(mem->slot, mem->flags, mem->guest_phys_addr,
                                   mem->memory_size, mem->userspace_addr, 0);
+    }
 
-        if (ret < 0) {
-            error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
-                         " start=0x%" PRIx64 ": %s",
-                         __func__, mem->slot,
-                         (uint64_t)mem->memory_size, strerror(errno));
-        }
+    ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION_LIST, kml->mem_array.list);
+
+    if (ret < 0) {
+        error_report("%s: KVM_SET_USER_MEMORY_REGION_LIST failed, size=0x%"
+                     PRIx64 " flags=0x%" PRIx64 ": %s",
+                     __func__, (uint64_t)kml->mem_array.list->nent,
+                     (uint64_t)kml->mem_array.list->flags,
+                     strerror(errno));
     }
 
     kml->mem_array.list->nent = 0;
-- 
2.31.1

