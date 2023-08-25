Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89B478887E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245141AbjHYNXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbjHYNXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E481FF6
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtUWiTxvfEaXjj5InMUTbpkzC5jsR7h9EO68NccA5RQ=;
        b=VhI5Dd+F3RaejNGFiC+Ibco+WyRdPUR/64fOYJZlR3Bb1/TfZypBVlFw56LzHDoD6/dMPV
        S3wWAxy5zhd1PxYHA/uVEJJcRob3iBYhawFn8Iqd6XJp+ASjW26fKYmgXOR3qhb3y+GScu
        IAVKO3sAbUuTWJShEG3EFwAmeU17T+U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-b24xiUr_P_OMUhSaKekaKA-1; Fri, 25 Aug 2023 09:22:54 -0400
X-MC-Unique: b24xiUr_P_OMUhSaKekaKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B6E3856F67;
        Fri, 25 Aug 2023 13:22:54 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16DE5140E950;
        Fri, 25 Aug 2023 13:22:50 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v2 16/16] virtio-mem: Mark memslot alias memory regions unmergeable
Date:   Fri, 25 Aug 2023 15:21:49 +0200
Message-ID: <20230825132149.366064-17-david@redhat.com>
In-Reply-To: <20230825132149.366064-1-david@redhat.com>
References: <20230825132149.366064-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's mark the memslot alias memory regions as unmergable, such that
flatview and vhost won't merge adjacent memory region aliases and we can
atomically map/unmap individual aliases without affecting adjacent
alias memory regions.

This handles vhost and vfio in multiple-memslot mode correctly (which do
not support atomic memslot updates) and avoids the temporary removal of
large memslots, which can be an expensive operation. For example, vfio
might have to unpin + repin a lot of memory, which is undesired.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 724fcb189a..50770b577a 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -959,6 +959,12 @@ static void virtio_mem_prepare_memslots(VirtIOMEM *vmem)
         memory_region_init_alias(&vmem->memslots[idx], OBJECT(vmem), name,
                                  &vmem->memdev->mr, memslot_offset,
                                  memslot_size);
+        /*
+         * We want to be able to atomically and efficiently activate/deactivate
+         * individual memslots without affecting adjacent memslots in memory
+         * notifiers.
+         */
+        memory_region_set_unmergeable(&vmem->memslots[idx], true);
     }
 }
 
-- 
2.41.0

