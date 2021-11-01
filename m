Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1290D442314
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhKAWMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232360AbhKAWMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIlkv3kUVM5FLjDY6YlHGmvpDrEJaIZ60b+7KENr5m4=;
        b=RroJFxsbK+OCWinvHPZq/ChrrIRkJi3l9tpoxt3YyJasht3h8YlFH2xDiI/0a7jm4myfbK
        f78XPx3p6TVdCJnvZNpWSShRHjzvk6t+fUu2E1ArcmlkAFXh+8hAmL4lyyMJztE9W34hlU
        yr0Ej3G63koOoxO0SYeTXhDuM+txvQ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-vg7Ean9GNtyKLgi9Aswctw-1; Mon, 01 Nov 2021 18:09:34 -0400
X-MC-Unique: vg7Ean9GNtyKLgi9Aswctw-1
Received: by mail-wm1-f70.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so3342376wmg.9
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FIlkv3kUVM5FLjDY6YlHGmvpDrEJaIZ60b+7KENr5m4=;
        b=Qs+UM2xyUFLePJkhz/4DAUFLApHOn/WuWQgZvNLKpq1/IMpa4QsMRxPYYkqpLxd5vg
         dwlTyF3yposMhSBolcpezPcRb4vh2EnY/ggRL8S53RMiBdjjix9RD2sV9+Rc0gwMDr6c
         RjsI2DDBwoXZE7vT7ge1Yy7t6IF4xn2eYZWB6mnJTYKYntO675T/283V8iMvQupe4w+b
         nD+0A03i82SCfB8KF2e9W1CsqdEdFo55k5FK9jcHDNAcmbugQWolGbCGmvfvrl92aDCh
         B6z1wPMXXMI1ttH8EeAzTfpq+LEkKCMyK9xUfcizk/766RJs+/KrkwdXwGjIgX1o6v6l
         1PaA==
X-Gm-Message-State: AOAM5323ASDUUMG3CtCaW91kqxHSBk/Zt/o23mjMePJ31oXxUAZ4v6s1
        Pfflnv7K6f9/kDs1CLFjVKefXK/jAiKnYmwR/7tELHj9LEdCcuZowkB2SMY2E/xBuCM3NHdxnUR
        tyxih/uVTvAGe
X-Received: by 2002:a5d:64af:: with SMTP id m15mr12543619wrp.267.1635804573225;
        Mon, 01 Nov 2021 15:09:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrZQZMxAe13255F4Umt/lsvtqR2XTX2d+P8MJlbDMrZGA3GCpF4nzZPJktxVFBm5Hby8r3Kg==
X-Received: by 2002:a5d:64af:: with SMTP id m15mr12543584wrp.267.1635804573009;
        Mon, 01 Nov 2021 15:09:33 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id m35sm1212614wms.2.2021.11.01.15.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:32 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 14/20] virtio-mem: Drop precopy notifier
Date:   Mon,  1 Nov 2021 23:09:06 +0100
Message-Id: <20211101220912.10039-15-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Migration code now properly handles RAMBlocks which are indirectly managed
by a RamDiscardManager. No need for manual handling via the free page
optimization interface, let's get rid of it.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/hw/virtio/virtio-mem.h |  3 ---
 hw/virtio/virtio-mem.c         | 34 ----------------------------------
 2 files changed, 37 deletions(-)

diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
index 9a6e348fa2..a5dd6a493b 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -65,9 +65,6 @@ struct VirtIOMEM {
     /* notifiers to notify when "size" changes */
     NotifierList size_change_notifiers;
 
-    /* don't migrate unplugged memory */
-    NotifierWithReturn precopy_notifier;
-
     /* listeners to notify on plug/unplug activity. */
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 284096ec5f..d5a578142b 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -776,7 +776,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
     host_memory_backend_set_mapped(vmem->memdev, true);
     vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
     qemu_register_reset(virtio_mem_system_reset, vmem);
-    precopy_add_notifier(&vmem->precopy_notifier);
 
     /*
      * Set ourselves as RamDiscardManager before the plug handler maps the
@@ -796,7 +795,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
      * found via an address space anymore. Unset ourselves.
      */
     memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
-    precopy_remove_notifier(&vmem->precopy_notifier);
     qemu_unregister_reset(virtio_mem_system_reset, vmem);
     vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
     host_memory_backend_set_mapped(vmem->memdev, false);
@@ -1089,43 +1087,11 @@ static void virtio_mem_set_block_size(Object *obj, Visitor *v, const char *name,
     vmem->block_size = value;
 }
 
-static int virtio_mem_precopy_exclude_range_cb(const VirtIOMEM *vmem, void *arg,
-                                               uint64_t offset, uint64_t size)
-{
-    void * const host = qemu_ram_get_host_addr(vmem->memdev->mr.ram_block);
-
-    qemu_guest_free_page_hint(host + offset, size);
-    return 0;
-}
-
-static void virtio_mem_precopy_exclude_unplugged(VirtIOMEM *vmem)
-{
-    virtio_mem_for_each_unplugged_range(vmem, NULL,
-                                        virtio_mem_precopy_exclude_range_cb);
-}
-
-static int virtio_mem_precopy_notify(NotifierWithReturn *n, void *data)
-{
-    VirtIOMEM *vmem = container_of(n, VirtIOMEM, precopy_notifier);
-    PrecopyNotifyData *pnd = data;
-
-    switch (pnd->reason) {
-    case PRECOPY_NOTIFY_AFTER_BITMAP_SYNC:
-        virtio_mem_precopy_exclude_unplugged(vmem);
-        break;
-    default:
-        break;
-    }
-
-    return 0;
-}
-
 static void virtio_mem_instance_init(Object *obj)
 {
     VirtIOMEM *vmem = VIRTIO_MEM(obj);
 
     notifier_list_init(&vmem->size_change_notifiers);
-    vmem->precopy_notifier.notify = virtio_mem_precopy_notify;
     QLIST_INIT(&vmem->rdl_list);
 
     object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_get_size,
-- 
2.33.1

