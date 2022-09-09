Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392D35B3163
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiIIIMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiIIIMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:12:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07866B6007
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662711120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WfbTGILIwnlqrhBy2hpfPOMOrZst7fDmliV6QGcqmGY=;
        b=iO1WsOFomZvJ6cfNamYUw1aYsosHVhwlQXw7sUIZHai+LZY4SSU48mA/xrbJ5aVA7pXJS1
        Ti1jPaxZvppM6pCnhFxnjXlqa6PFy8OY+Pk8mRaagobbQF7tdbz7r/HyN72rLYlivXxlLN
        4+yF8EWuFnYoSlwr0w3oIhL5EGgzZ60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-0YNmnC_oO_m-mxQhTD3Adg-1; Fri, 09 Sep 2022 04:11:56 -0400
X-MC-Unique: 0YNmnC_oO_m-mxQhTD3Adg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73129185A7A4;
        Fri,  9 Sep 2022 08:11:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EB524011960;
        Fri,  9 Sep 2022 08:11:56 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH v2 2/3] accel/kvm/kvm-all.c: pass kvm_userspace_memory_region_entry instead
Date:   Fri,  9 Sep 2022 04:11:49 -0400
Message-Id: <20220909081150.709060-3-eesposit@redhat.com>
In-Reply-To: <20220909081150.709060-1-eesposit@redhat.com>
References: <20220909081150.709060-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It won't change anything from the kernel side, but prepares the logic
for KVM_SET_USER_MEMORY_REGION_LIST ioctl, where all requests are sent
at once.

Because QEMU does not send any memslot MOVE request to KVM, simplify
mem.invalidate_slot logic to only detect DELETE requests.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 645f0a249a..e9947ec18b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -360,7 +360,7 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
 static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
 {
     KVMState *s = kvm_state;
-    struct kvm_userspace_memory_region mem;
+    struct kvm_userspace_memory_region_entry mem;
     int ret;
 
     mem.slot = slot->slot | (kml->as_id << 16);
@@ -372,12 +372,29 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
         mem.memory_size = 0;
+        mem.invalidate_slot = 1;
+        /*
+         * Note that mem is struct kvm_userspace_memory_region_entry, while the
+         * kernel expects a kvm_userspace_memory_region, so it will currently
+         * ignore mem->invalidate_slot and mem->padding.
+         */
         ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
         if (ret < 0) {
             goto err;
         }
     }
     mem.memory_size = slot->memory_size;
+    /*
+     * Invalidate if it's a kvm memslot MOVE or DELETE operation, but
+     * currently QEMU does not perform any memslot MOVE operation.
+     */
+    mem.invalidate_slot = slot->memory_size == 0;
+
+    /*
+     * Note that mem is struct kvm_userspace_memory_region_entry, while the
+     * kernel expects a kvm_userspace_memory_region, so it will currently
+     * ignore mem->invalidate_slot and mem->padding.
+     */
     ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
     slot->old_flags = mem.flags;
 err:
-- 
2.31.1

