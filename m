Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EED732B93
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjFPJae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344665AbjFPJaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD9135AA
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XM+HePR6LNcuziWHsgGYi0zTa4lGcGp8H1+/yHmULy8=;
        b=MFz9zoLuXjg3tA+xAwtjxtnXIV/NpeKnyy4oU+kXgB70rRyxyHQVjfP6VPRY3a5IJajDmI
        r1y6fg+bEhlJ3zI9PvzI+RavzJ3Yu2N127IWHMHPc6CsQlUauuy6YRehDZ75g+RGmVytfc
        JnpjmQssUUlWabuHLSy+IKzLXBbkDt0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-YQHJtK1AMzGU30RbNQ8YJg-1; Fri, 16 Jun 2023 05:27:42 -0400
X-MC-Unique: YQHJtK1AMzGU30RbNQ8YJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A3A0280AA28;
        Fri, 16 Jun 2023 09:27:42 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A80111121314;
        Fri, 16 Jun 2023 09:27:39 +0000 (UTC)
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
Subject: [PATCH v1 10/15] pc-dimm: Provide pc_dimm_get_free_slots() to query free ram slots
Date:   Fri, 16 Jun 2023 11:26:49 +0200
Message-Id: <20230616092654.175518-11-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

memory device wants to figure out at per-device memslot limit for memory
devices that want to consume more than a single memslot. We want to try
setting the memslots required for DIMMs/NVDIMMs (1 memslot per such device)
aside, so expose how many of these slots are still free.

Keep it simple and place the stub into qmp_memory_device.c.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/pc-dimm.c          | 27 +++++++++++++++++++++++++++
 include/hw/mem/pc-dimm.h  |  1 +
 stubs/qmp_memory_device.c |  6 ++++++
 3 files changed, 34 insertions(+)

diff --git a/hw/mem/pc-dimm.c b/hw/mem/pc-dimm.c
index 37f1f4ccfd..64ee0c38c0 100644
--- a/hw/mem/pc-dimm.c
+++ b/hw/mem/pc-dimm.c
@@ -152,6 +152,33 @@ out:
     return slot;
 }
 
+static int pc_dimm_count_slots(Object *obj, void *opaque)
+{
+    unsigned int *slots = opaque;
+
+    if (object_dynamic_cast(obj, TYPE_PC_DIMM)) {
+        DeviceState *dev = DEVICE(obj);
+        if (dev->realized) { /* count only realized DIMMs */
+            (*slots)++;
+        }
+    }
+    return 0;
+}
+
+unsigned int pc_dimm_get_free_slots(MachineState *machine)
+{
+    const unsigned int max_slots = machine->ram_slots;
+    unsigned int slots = 0;
+
+    if (!max_slots) {
+        return 0;
+    }
+
+    object_child_foreach_recursive(OBJECT(machine), pc_dimm_count_slots,
+                                   &slots);
+    return max_slots - slots;
+}
+
 static Property pc_dimm_properties[] = {
     DEFINE_PROP_UINT64(PC_DIMM_ADDR_PROP, PCDIMMDevice, addr, 0),
     DEFINE_PROP_UINT32(PC_DIMM_NODE_PROP, PCDIMMDevice, node, 0),
diff --git a/include/hw/mem/pc-dimm.h b/include/hw/mem/pc-dimm.h
index 322bebe555..60051ac753 100644
--- a/include/hw/mem/pc-dimm.h
+++ b/include/hw/mem/pc-dimm.h
@@ -70,4 +70,5 @@ void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine,
                       const uint64_t *legacy_align, Error **errp);
 void pc_dimm_plug(PCDIMMDevice *dimm, MachineState *machine);
 void pc_dimm_unplug(PCDIMMDevice *dimm, MachineState *machine);
+unsigned int pc_dimm_get_free_slots(MachineState *machine);
 #endif
diff --git a/stubs/qmp_memory_device.c b/stubs/qmp_memory_device.c
index 74707ed9fd..7022bd188b 100644
--- a/stubs/qmp_memory_device.c
+++ b/stubs/qmp_memory_device.c
@@ -1,5 +1,6 @@
 #include "qemu/osdep.h"
 #include "hw/mem/memory-device.h"
+#include "hw/mem/pc-dimm.h"
 
 MemoryDeviceInfoList *qmp_memory_device_list(void)
 {
@@ -19,3 +20,8 @@ unsigned int memory_devices_get_reserved_memslots(void)
 {
     return 0;
 }
+
+unsigned int pc_dimm_get_free_slots(MachineState *machine)
+{
+    return 0;
+}
-- 
2.40.1

