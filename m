Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076521C6D99
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgEFJvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:51:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41203 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729261AbgEFJu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ko1It9mCGjyIjOIhDtbfixtHC6gx4a3dweLY3ADWVjI=;
        b=JFlDe55u8NUsU6slyxGZH9Imsga/CFuaHvx/IoGeX/qVm4awkMXBu916U0BxtwUYnk6/NU
        ubQtM1x+xiuJn4cp6OtaNg19TWj6oz8Ae+1/z5fOetZVXvK+Jh31WBP4UYlsZ5BACO7Rx6
        zeO7pu58g4zsVBlnOZgppVMzcjZp2xM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-En2Gr8pMNr2BK5wn2n0xlA-1; Wed, 06 May 2020 05:50:57 -0400
X-MC-Unique: En2Gr8pMNr2BK5wn2n0xlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AAA280058A;
        Wed,  6 May 2020 09:50:56 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FB675C1BD;
        Wed,  6 May 2020 09:50:54 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 13/17] hmp: Handle virtio-mem when printing memory device info
Date:   Wed,  6 May 2020 11:49:44 +0200
Message-Id: <20200506094948.76388-14-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
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
index 7f6e982dc8..4b3638a2a6 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -1805,6 +1805,7 @@ void hmp_info_memory_devices(Monitor *mon, const QD=
ict *qdict)
     MemoryDeviceInfoList *info_list =3D qmp_query_memory_devices(&err);
     MemoryDeviceInfoList *info;
     VirtioPMEMDeviceInfo *vpi;
+    VirtioMEMDeviceInfo *vmi;
     MemoryDeviceInfo *value;
     PCDIMMDeviceInfo *di;
=20
@@ -1839,6 +1840,21 @@ void hmp_info_memory_devices(Monitor *mon, const Q=
Dict *qdict)
                 monitor_printf(mon, "  size: %" PRIu64 "\n", vpi->size);
                 monitor_printf(mon, "  memdev: %s\n", vpi->memdev);
                 break;
+            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
+                vmi =3D value->u.virtio_mem.data;
+                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
+                               MemoryDeviceInfoKind_str(value->type),
+                               vmi->id ? vmi->id : "");
+                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vmi->m=
emaddr);
+                monitor_printf(mon, "  node: %" PRId64 "\n", vmi->node);
+                monitor_printf(mon, "  requested-size: %" PRIu64 "\n",
+                               vmi->requested_size);
+                monitor_printf(mon, "  size: %" PRIu64 "\n", vmi->size);
+                monitor_printf(mon, "  max-size: %" PRIu64 "\n", vmi->ma=
x_size);
+                monitor_printf(mon, "  block-size: %" PRIu64 "\n",
+                               vmi->block_size);
+                monitor_printf(mon, "  memdev: %s\n", vmi->memdev);
+                break;
             default:
                 g_assert_not_reached();
             }
--=20
2.25.3

