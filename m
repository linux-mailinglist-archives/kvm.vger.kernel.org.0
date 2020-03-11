Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF484181EF6
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgCKRPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:15:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730478AbgCKRPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 13:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583946944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DoiGjgNcOxwqOQ4QGLK3eCJGLVC9kfOrCPPjHii9JB4=;
        b=a0J2d//gJvLkkvsAqiznpg4xDdzL0XfA2HEYQAaq4d50UHY7pseserpGDrz7nKD9CVO3GD
        eMM8OPgQc/epCp1HUun2M5N8X7x8++gg8L0gYbLd5sS9U0lqSkYDba81YGl1p6L7vSmfTr
        sg+B3/bRqbzRNTVl11rC4BH2nkuvK0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-PpHwPLyTPSGON5TanGJrtA-1; Wed, 11 Mar 2020 13:15:40 -0400
X-MC-Unique: PpHwPLyTPSGON5TanGJrtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F51E107ACC9;
        Wed, 11 Mar 2020 17:15:38 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD3EA91D9B;
        Wed, 11 Mar 2020 17:15:19 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH v2 02/10] virtio-mem: Allow to specify an ACPI PXM as nid
Date:   Wed, 11 Mar 2020 18:14:14 +0100
Message-Id: <20200311171422.10484-3-david@redhat.com>
In-Reply-To: <20200311171422.10484-1-david@redhat.com>
References: <20200311171422.10484-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to allow to specify (similar as for a DIMM), to which node a
virtio-mem device (and, therefore, its memory) belongs. Add a new
virtio-mem feature flag and export pxm_to_node, so it can be used in kern=
el
module context.

Acked-by: Michal Hocko <mhocko@suse.com> # for the export
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org> # for the export
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/acpi/numa/srat.c        |  1 +
 drivers/virtio/virtio_mem.c     | 37 +++++++++++++++++++++++++++++++--
 include/uapi/linux/virtio_mem.h | 10 ++++++++-
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 47b4969d9b93..5be5a977da1b 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -35,6 +35,7 @@ int pxm_to_node(int pxm)
 		return NUMA_NO_NODE;
 	return pxm_to_node_map[pxm];
 }
+EXPORT_SYMBOL(pxm_to_node);
=20
 int node_to_pxm(int node)
 {
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 803e1426f80b..d8da656c9145 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -20,6 +20,8 @@
 #include <linux/bitmap.h>
 #include <linux/lockdep.h>
=20
+#include <acpi/acpi_numa.h>
+
 enum virtio_mem_mb_state {
 	/* Unplugged, not added to Linux. Can be reused later. */
 	VIRTIO_MEM_MB_STATE_UNUSED =3D 0,
@@ -71,6 +73,8 @@ struct virtio_mem {
=20
 	/* The device block size (for communicating with the device). */
 	uint32_t device_block_size;
+	/* The translated node id. NUMA_NO_NODE in case not specified. */
+	int nid;
 	/* Physical start address of the memory region. */
 	uint64_t addr;
=20
@@ -386,7 +390,10 @@ static int virtio_mem_sb_bitmap_prepare_next_mb(stru=
ct virtio_mem *vm)
 static int virtio_mem_mb_add(struct virtio_mem *vm, unsigned long mb_id)
 {
 	const uint64_t addr =3D virtio_mem_mb_id_to_phys(mb_id);
-	int nid =3D memory_add_physaddr_to_nid(addr);
+	int nid =3D vm->nid;
+
+	if (nid =3D=3D NUMA_NO_NODE)
+		nid =3D memory_add_physaddr_to_nid(addr);
=20
 	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
 	return add_memory(nid, addr, memory_block_size_bytes());
@@ -404,7 +411,10 @@ static int virtio_mem_mb_add(struct virtio_mem *vm, =
unsigned long mb_id)
 static int virtio_mem_mb_remove(struct virtio_mem *vm, unsigned long mb_=
id)
 {
 	const uint64_t addr =3D virtio_mem_mb_id_to_phys(mb_id);
-	int nid =3D memory_add_physaddr_to_nid(addr);
+	int nid =3D vm->nid;
+
+	if (nid =3D=3D NUMA_NO_NODE)
+		nid =3D memory_add_physaddr_to_nid(addr);
=20
 	dev_dbg(&vm->vdev->dev, "removing memory block: %lu\n", mb_id);
 	return remove_memory(nid, addr, memory_block_size_bytes());
@@ -423,6 +433,17 @@ static void virtio_mem_retry(struct virtio_mem *vm)
 	spin_unlock_irqrestore(&vm->removal_lock, flags);
 }
=20
+static int virtio_mem_translate_node_id(struct virtio_mem *vm, uint16_t =
node_id)
+{
+	int node =3D NUMA_NO_NODE;
+
+#if defined(CONFIG_ACPI_NUMA)
+	if (virtio_has_feature(vm->vdev, VIRTIO_MEM_F_ACPI_PXM))
+		node =3D pxm_to_node(node_id);
+#endif
+	return node;
+}
+
 /*
  * Test if a virtio-mem device overlaps with the given range. Can be cal=
led
  * from (notifier) callbacks lockless.
@@ -1266,6 +1287,7 @@ static int virtio_mem_init(struct virtio_mem *vm)
 {
 	const uint64_t phys_limit =3D 1UL << MAX_PHYSMEM_BITS;
 	uint64_t region_size;
+	uint16_t node_id;
=20
 	if (!vm->vdev->config->get) {
 		dev_err(&vm->vdev->dev, "config access disabled\n");
@@ -1286,6 +1308,9 @@ static int virtio_mem_init(struct virtio_mem *vm)
 		     &vm->plugged_size);
 	virtio_cread(vm->vdev, struct virtio_mem_config, block_size,
 		     &vm->device_block_size);
+	virtio_cread(vm->vdev, struct virtio_mem_config, node_id,
+		     &node_id);
+	vm->nid =3D virtio_mem_translate_node_id(vm, node_id);
 	virtio_cread(vm->vdev, struct virtio_mem_config, addr, &vm->addr);
 	virtio_cread(vm->vdev, struct virtio_mem_config, region_size,
 		     &region_size);
@@ -1501,12 +1526,20 @@ static int virtio_mem_restore(struct virtio_devic=
e *vdev)
 }
 #endif
=20
+static unsigned int virtio_mem_features[] =3D {
+#if defined(CONFIG_NUMA) && defined(CONFIG_ACPI_NUMA)
+	VIRTIO_MEM_F_ACPI_PXM,
+#endif
+};
+
 static struct virtio_device_id virtio_mem_id_table[] =3D {
 	{ VIRTIO_ID_MEM, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
=20
 static struct virtio_driver virtio_mem_driver =3D {
+	.feature_table =3D virtio_mem_features,
+	.feature_table_size =3D ARRAY_SIZE(virtio_mem_features),
 	.driver.name =3D KBUILD_MODNAME,
 	.driver.owner =3D THIS_MODULE,
 	.id_table =3D virtio_mem_id_table,
diff --git a/include/uapi/linux/virtio_mem.h b/include/uapi/linux/virtio_=
mem.h
index 1bfade78bdfd..e0a9dc7397c3 100644
--- a/include/uapi/linux/virtio_mem.h
+++ b/include/uapi/linux/virtio_mem.h
@@ -83,6 +83,12 @@
  * device is busy.
  */
=20
+/* --- virtio-mem: feature bits --- */
+
+/* node_id is an ACPI PXM and is valid */
+#define VIRTIO_MEM_F_ACPI_PXM		0
+
+
 /* --- virtio-mem: guest -> host requests --- */
=20
 /* request to plug memory blocks */
@@ -177,7 +183,9 @@ struct virtio_mem_resp {
 struct virtio_mem_config {
 	/* Block size and alignment. Cannot change. */
 	__u32 block_size;
-	__u32 padding;
+	/* Valid with VIRTIO_MEM_F_ACPI_PXM. Cannot change. */
+	__u16 node_id;
+	__u16 padding;
 	/* Start address of the memory region. Cannot change. */
 	__u64 addr;
 	/* Region size (maximum). Cannot change. */
--=20
2.24.1

