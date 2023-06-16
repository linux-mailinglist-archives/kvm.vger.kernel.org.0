Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1BEF732BBD
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343914AbjFPJbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344734AbjFPJaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0BB44A3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klrOECQICZynP7hLL56x1E0j6YPlyVxqWgkAdUn8igo=;
        b=JlrJO/l7/n1Y6fUlZgRMjx1eff1a5luQYF4DjZTuEkhQMgOyj/kPj+UAV6q/9uQKvjTi+g
        NXBvD5tSKgaqgn4CHB6dulw201k/FG6KOoYdyDLEVMW+nvpNtIATf1AsN8bUtw4zpAx2NT
        3jn/a0Hs5cq6GYQfZePg5fUhNVw+k94=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-LmxsdaiNNOmz1zLcds_ErA-1; Fri, 16 Jun 2023 05:27:58 -0400
X-MC-Unique: LmxsdaiNNOmz1zLcds_ErA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B24F85A5AA;
        Fri, 16 Jun 2023 09:27:58 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF9411121314;
        Fri, 16 Jun 2023 09:27:55 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH v1 15/15] virtio-mem: Mark memslot alias memory regions unmergeable
Date:   Fri, 16 Jun 2023 11:26:54 +0200
Message-Id: <20230616092654.175518-16-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's mark the memslot alias memory regions as unmergable, such that
flatview and vhost won't merge adjacent memory region aliases and we can
atomically map/unmap individual aliases without affecting adjacent
alias memory regions.

This fixes issues with vhost and vfio (which do not support atomic memslot
updates) and avoids the temporary removal of large memslots, which
can be an expensive operation. For example, vfio might have to unpin +
repin a lot of memory, which is undesired.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 516370067a..cccd834466 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -955,6 +955,12 @@ static void virtio_mem_prepare_memslots(VirtIOMEM *vmem)
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
2.40.1

