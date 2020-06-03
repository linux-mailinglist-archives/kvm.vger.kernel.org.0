Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABFE1ED27E
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgFCOul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 10:50:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbgFCOuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 10:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591195838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7eFNjxbOeGebdmjSbhg2jAQpS+8NVK1sfSB+HezFe0=;
        b=XdwXJl2Efc9mA0C2jCIgERhq7NHsfw8ggrk+CsBXT5yoBiSnqlwsbGiJoDFiv7qr5xsQWj
        lm4k5WAijPm1AmUThhNnD4YedOIMHAcXReYkqRW3V7BerFgElJczHNPTWrrVeV8A0edDpG
        t2zLpPwWyWrpwjOXJXpQlyncTl+khXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-uCsrJaazO0mtPFBUvrWbTA-1; Wed, 03 Jun 2020 10:50:37 -0400
X-MC-Unique: uCsrJaazO0mtPFBUvrWbTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4315680058E;
        Wed,  3 Jun 2020 14:50:36 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-192.ams2.redhat.com [10.36.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34D065D9CD;
        Wed,  3 Jun 2020 14:50:34 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH v3 14/20] numa: Handle virtio-mem in NUMA stats
Date:   Wed,  3 Jun 2020 16:49:08 +0200
Message-Id: <20200603144914.41645-15-david@redhat.com>
In-Reply-To: <20200603144914.41645-1-david@redhat.com>
References: <20200603144914.41645-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Account the memory to the configured nid.

Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/core/numa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 316bc50d75..06960918e7 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -812,6 +812,7 @@ static void numa_stat_memory_devices(NumaNodeMem node_mem[])
     MemoryDeviceInfoList *info;
     PCDIMMDeviceInfo     *pcdimm_info;
     VirtioPMEMDeviceInfo *vpi;
+    VirtioMEMDeviceInfo *vmi;
 
     for (info = info_list; info; info = info->next) {
         MemoryDeviceInfo *value = info->value;
@@ -832,6 +833,11 @@ static void numa_stat_memory_devices(NumaNodeMem node_mem[])
                 node_mem[0].node_mem += vpi->size;
                 node_mem[0].node_plugged_mem += vpi->size;
                 break;
+            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
+                vmi = value->u.virtio_mem.data;
+                node_mem[vmi->node].node_mem += vmi->size;
+                node_mem[vmi->node].node_plugged_mem += vmi->size;
+                break;
             default:
                 g_assert_not_reached();
             }
-- 
2.25.4

