Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE461C6D9A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgEFJvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:51:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39206 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729268AbgEFJvE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gPYy5xjngtAqGsyw4OWH5Hdfo7Ahip1m9nldPmeLgtA=;
        b=K32mckECEvZa3R7CdL5EN+oq1noP9tShMvgV0MN9tbFSddmUkY/BMvmZxixFc7XTsNQRzK
        nyGHpH8HRFHwDhaPdWosBX8koUIg+TvNdbvVg3KqNXJdC+qSdJFyuG/pSftDUbFdQGvW6n
        g6QwaOGsKanwrACL1P2pJ3KybFV0+vI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-4NIsTY3ePFGNQHX65Cxkwg-1; Wed, 06 May 2020 05:50:59 -0400
X-MC-Unique: 4NIsTY3ePFGNQHX65Cxkwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CD4B1800D4A;
        Wed,  6 May 2020 09:50:58 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58E345C1BD;
        Wed,  6 May 2020 09:50:56 +0000 (UTC)
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
Subject: [PATCH v1 14/17] numa: Handle virtio-mem in NUMA stats
Date:   Wed,  6 May 2020 11:49:45 +0200
Message-Id: <20200506094948.76388-15-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
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
@@ -812,6 +812,7 @@ static void numa_stat_memory_devices(NumaNodeMem node=
_mem[])
     MemoryDeviceInfoList *info;
     PCDIMMDeviceInfo     *pcdimm_info;
     VirtioPMEMDeviceInfo *vpi;
+    VirtioMEMDeviceInfo *vmi;
=20
     for (info =3D info_list; info; info =3D info->next) {
         MemoryDeviceInfo *value =3D info->value;
@@ -832,6 +833,11 @@ static void numa_stat_memory_devices(NumaNodeMem nod=
e_mem[])
                 node_mem[0].node_mem +=3D vpi->size;
                 node_mem[0].node_plugged_mem +=3D vpi->size;
                 break;
+            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
+                vmi =3D value->u.virtio_mem.data;
+                node_mem[vmi->node].node_mem +=3D vmi->size;
+                node_mem[vmi->node].node_plugged_mem +=3D vmi->size;
+                break;
             default:
                 g_assert_not_reached();
             }
--=20
2.25.3

