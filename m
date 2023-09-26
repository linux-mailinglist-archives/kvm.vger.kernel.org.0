Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D978F7AF39F
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbjIZTBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbjIZTBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:01:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464141AE
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695754811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAvglJj91/o8R3ulPUvMP06jx5ezTDNURc+rL2BIGo4=;
        b=hR12PzKXXvgb//rP8/f7FQccH0FZyKQbaawQnhzy2V+TVcxtJRRVw2KKXx+SYqNZOyT8Ro
        5EE4TTfACEKDkiFVFP0UbCGnrIPUetn+m6flyA9GOQMdfJ+qEczZxyWzHo4ju6C7Z+Qs/v
        KcrmJg5mJ+eLK0qbyMEAxfuXirZxXhg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-t_nnSmVvNL-nvOoa5tOcxg-1; Tue, 26 Sep 2023 15:00:07 -0400
X-MC-Unique: t_nnSmVvNL-nvOoa5tOcxg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DE3E811E8E;
        Tue, 26 Sep 2023 19:00:07 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9B372026D4B;
        Tue, 26 Sep 2023 19:00:02 +0000 (UTC)
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
Subject: [PATCH v4 18/18] virtio-mem: Mark memslot alias memory regions unmergeable
Date:   Tue, 26 Sep 2023 20:57:38 +0200
Message-ID: <20230926185738.277351-19-david@redhat.com>
In-Reply-To: <20230926185738.277351-1-david@redhat.com>
References: <20230926185738.277351-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index e1e4250e69..9dc3c61b5a 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -940,6 +940,12 @@ static void virtio_mem_prepare_memslots(VirtIOMEM *vmem)
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

