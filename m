Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFB81ED27D
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 16:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgFCOul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 10:50:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgFCOuj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 10:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591195838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoqG/7LlE0aGkoDnmNDY3ApCiNG/45FhuQTIXGIJ13U=;
        b=MDWa8OIxFksHVKZ6578WfKgjxq2jvCcJhA7wwDPIPSnq3X2NTuJhrpLcw+lLzWXr6esnUg
        X0KtEWvZcL90emlR0KONmD00LwCGQXGk55daQcaVkTd+Z8DbMO5rM5lSLwTn+Mv1RvMBb4
        /TY18JTyYANCJ1aQ8G/FyLZIjPu4uGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-dxgro2VbOa6Ii9n5VgpQBQ-1; Wed, 03 Jun 2020 10:50:35 -0400
X-MC-Unique: dxgro2VbOa6Ii9n5VgpQBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D87FB800685;
        Wed,  3 Jun 2020 14:50:33 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-192.ams2.redhat.com [10.36.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 786335D9CD;
        Wed,  3 Jun 2020 14:50:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 13/20] hmp: Handle virtio-mem when printing memory device info
Date:   Wed,  3 Jun 2020 16:49:07 +0200
Message-Id: <20200603144914.41645-14-david@redhat.com>
In-Reply-To: <20200603144914.41645-1-david@redhat.com>
References: <20200603144914.41645-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print the memory device info just like for other memory devices.

Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 monitor/hmp-cmds.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 9c61e769ca..afc9a28069 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -1818,6 +1818,7 @@ void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
     MemoryDeviceInfoList *info_list = qmp_query_memory_devices(&err);
     MemoryDeviceInfoList *info;
     VirtioPMEMDeviceInfo *vpi;
+    VirtioMEMDeviceInfo *vmi;
     MemoryDeviceInfo *value;
     PCDIMMDeviceInfo *di;
 
@@ -1852,6 +1853,21 @@ void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
                 monitor_printf(mon, "  size: %" PRIu64 "\n", vpi->size);
                 monitor_printf(mon, "  memdev: %s\n", vpi->memdev);
                 break;
+            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
+                vmi = value->u.virtio_mem.data;
+                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
+                               MemoryDeviceInfoKind_str(value->type),
+                               vmi->id ? vmi->id : "");
+                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vmi->memaddr);
+                monitor_printf(mon, "  node: %" PRId64 "\n", vmi->node);
+                monitor_printf(mon, "  requested-size: %" PRIu64 "\n",
+                               vmi->requested_size);
+                monitor_printf(mon, "  size: %" PRIu64 "\n", vmi->size);
+                monitor_printf(mon, "  max-size: %" PRIu64 "\n", vmi->max_size);
+                monitor_printf(mon, "  block-size: %" PRIu64 "\n",
+                               vmi->block_size);
+                monitor_printf(mon, "  memdev: %s\n", vmi->memdev);
+                break;
             default:
                 g_assert_not_reached();
             }
-- 
2.25.4

