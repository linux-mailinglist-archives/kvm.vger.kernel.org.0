Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9D5732B94
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbjFPJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344371AbjFPJ3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:29:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAD230E4
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYAGcIiBozkpSp3T5+K2LJNfVGImLOKVErgdOfZyLGs=;
        b=dQCuBjqCUBF+hP47RD3MSNix/+pA6nB/FfFs+A97hNE+gAqzfMhFmwTspdnIrOomtdKKE+
        fde+9CZqY8QyCtHspG7vI0EGsuZmJVaql+/378yKW77EaQ1oJ5VKgIsKFsMrdRNDXtdpLN
        RwswEwOU9yxy3SpyqTllBgYihHYDuo0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-603ggW9-NtO0DCIu0SPyKQ-1; Fri, 16 Jun 2023 05:27:12 -0400
X-MC-Unique: 603ggW9-NtO0DCIu0SPyKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5187A810BBA;
        Fri, 16 Jun 2023 09:27:12 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5447C1121314;
        Fri, 16 Jun 2023 09:27:09 +0000 (UTC)
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
Subject: [PATCH v1 01/15] memory-device: Track the required memslots in DeviceMemoryState
Date:   Fri, 16 Jun 2023 11:26:40 +0200
Message-Id: <20230616092654.175518-2-david@redhat.com>
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

Let's track how many memslots are currently required by plugged memory
devices. We'll use this number to perform sanity checks next (soft limit
to warn the user).

Right now, each memory device consumes exactly one memslot, and the
number of required memslots matches the number of used memslots.

Once we support memory devices that consume multiple memslots
dynamically, the requested number of memslots will no longer correspond to
the number of memory devices, and there will be a difference between
required and actually used memslots.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c | 2 ++
 include/hw/boards.h    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 667d56bd29..28ad419dc0 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -275,6 +275,7 @@ void memory_device_plug(MemoryDeviceState *md, MachineState *ms)
     g_assert(ms->device_memory);
 
     ms->device_memory->used_region_size += memory_region_size(mr);
+    ms->device_memory->required_memslots++;
     memory_region_add_subregion(&ms->device_memory->mr,
                                 addr - ms->device_memory->base, mr);
     trace_memory_device_plug(DEVICE(md)->id ? DEVICE(md)->id : "", addr);
@@ -294,6 +295,7 @@ void memory_device_unplug(MemoryDeviceState *md, MachineState *ms)
 
     memory_region_del_subregion(&ms->device_memory->mr, mr);
     ms->device_memory->used_region_size -= memory_region_size(mr);
+    ms->device_memory->required_memslots--;
     trace_memory_device_unplug(DEVICE(md)->id ? DEVICE(md)->id : "",
                                mdc->get_addr(md));
 }
diff --git a/include/hw/boards.h b/include/hw/boards.h
index fcaf40b9da..a346b4ec4a 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -297,12 +297,14 @@ struct MachineClass {
  * @mr: address space container for memory devices
  * @dimm_size: the sum of plugged DIMMs' sizes
  * @used_region_size: the part of @mr already used by memory devices
+ * @required_memslots: the number of memslots required by memory devices
  */
 typedef struct DeviceMemoryState {
     hwaddr base;
     MemoryRegion mr;
     uint64_t dimm_size;
     uint64_t used_region_size;
+    unsigned int required_memslots;
 } DeviceMemoryState;
 
 /**
-- 
2.40.1

