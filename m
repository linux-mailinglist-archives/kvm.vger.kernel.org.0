Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC28175C2B
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 14:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCBNvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 08:51:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27182 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726969AbgCBNvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 08:51:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583157092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Il+nsakWqayV1I872rbc5vd5eg8q9WbG05kQyarYxI=;
        b=YjulWmPJV3Mo2bT9DzZ6MY+XquVN/5ZBW1suOcYiP8smUU0Ckz00lQcrRxtyWrLOexYKuL
        ewdO8YOqLjT3hT5o9xFelfoR5Bfd3/xj+6/RoALpRsD0VN7jDtUT8NFkwX1MfWCrU2fA3H
        sYgCu6EIlcmO9yQQgERSJMcpxedHb+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-Tq1oOPDSPsOY485gFSbarg-1; Mon, 02 Mar 2020 08:51:28 -0500
X-MC-Unique: Tq1oOPDSPsOY485gFSbarg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A417759320;
        Mon,  2 Mar 2020 13:51:26 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6667839D;
        Mon,  2 Mar 2020 13:51:02 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v1 03/11] virtio-mem: Paravirtualized memory hotunplug part 1
Date:   Mon,  2 Mar 2020 14:49:33 +0100
Message-Id: <20200302134941.315212-4-david@redhat.com>
In-Reply-To: <20200302134941.315212-1-david@redhat.com>
References: <20200302134941.315212-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unplugging subblocks of memory blocks that are offline is easy. All we
have to do is watch out for concurrent onlining activity.

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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 116 +++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index d8da656c9145..c1fc7f9c4acf 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -120,7 +120,7 @@ struct virtio_mem {
 	 *
 	 * When this lock is held the pointers can't change, ONLINE and
 	 * OFFLINE blocks can't change the state and no subblocks will get
-	 * plugged.
+	 * plugged/unplugged.
 	 */
 	struct mutex hotplug_mutex;
 	bool hotplug_active;
@@ -277,6 +277,12 @@ static int virtio_mem_mb_state_prepare_next_mb(struc=
t virtio_mem *vm)
 	     _mb_id++) \
 		if (virtio_mem_mb_get_state(_vm, _mb_id) =3D=3D _state)
=20
+#define virtio_mem_for_each_mb_state_rev(_vm, _mb_id, _state) \
+	for (_mb_id =3D _vm->next_mb_id - 1; \
+	     _mb_id >=3D _vm->first_mb_id && _vm->nb_mb_state[_state]; \
+	     _mb_id--) \
+		if (virtio_mem_mb_get_state(_vm, _mb_id) =3D=3D _state)
+
 /*
  * Mark all selected subblocks plugged.
  *
@@ -322,6 +328,19 @@ static bool virtio_mem_mb_test_sb_plugged(struct vir=
tio_mem *vm,
 	       bit + count;
 }
=20
+/*
+ * Test if all selected subblocks are unplugged.
+ */
+static bool virtio_mem_mb_test_sb_unplugged(struct virtio_mem *vm,
+					    unsigned long mb_id, int sb_id,
+					    int count)
+{
+	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb + sb_id;
+
+	/* TODO: Helper similar to bitmap_set() */
+	return find_next_bit(vm->sb_bitmap, bit + count, bit) >=3D bit + count;
+}
+
 /*
  * Find the first plugged subblock. Returns vm->nb_sb_per_mb in case the=
re is
  * none.
@@ -511,6 +530,9 @@ static void virtio_mem_notify_offline(struct virtio_m=
em *vm,
 		BUG();
 		break;
 	}
+
+	/* trigger the workqueue, maybe we can now unplug memory. */
+	virtio_mem_retry(vm);
 }
=20
 static void virtio_mem_notify_online(struct virtio_mem *vm, unsigned lon=
g mb_id,
@@ -1120,6 +1142,94 @@ static int virtio_mem_plug_request(struct virtio_m=
em *vm, uint64_t diff)
 	return rc;
 }
=20
+/*
+ * Unplug the desired number of plugged subblocks of an offline memory b=
lock.
+ * Will fail if any subblock cannot get unplugged (instead of skipping i=
t).
+ *
+ * Will modify the state of the memory block. Might temporarily drop the
+ * hotplug_mutex.
+ *
+ * Note: Can fail after some subblocks were successfully unplugged.
+ */
+static int virtio_mem_mb_unplug_any_sb_offline(struct virtio_mem *vm,
+					       unsigned long mb_id,
+					       uint64_t *nb_sb)
+{
+	int rc;
+
+	rc =3D virtio_mem_mb_unplug_any_sb(vm, mb_id, nb_sb);
+
+	/* some subblocks might have been unplugged even on failure */
+	if (!virtio_mem_mb_test_sb_plugged(vm, mb_id, 0, vm->nb_sb_per_mb))
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL);
+	if (rc)
+		return rc;
+
+	if (virtio_mem_mb_test_sb_unplugged(vm, mb_id, 0, vm->nb_sb_per_mb)) {
+		/*
+		 * Remove the block from Linux - this should never fail.
+		 * Hinder the block from getting onlined by marking it
+		 * unplugged. Temporarily drop the mutex, so
+		 * any pending GOING_ONLINE requests can be serviced/rejected.
+		 */
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_UNUSED);
+
+		mutex_unlock(&vm->hotplug_mutex);
+		rc =3D virtio_mem_mb_remove(vm, mb_id);
+		BUG_ON(rc);
+		mutex_lock(&vm->hotplug_mutex);
+	}
+	return 0;
+}
+
+/*
+ * Try to unplug the requested amount of memory.
+ */
+static int virtio_mem_unplug_request(struct virtio_mem *vm, uint64_t dif=
f)
+{
+	uint64_t nb_sb =3D diff / vm->subblock_size;
+	unsigned long mb_id;
+	int rc;
+
+	if (!nb_sb)
+		return 0;
+
+	/*
+	 * We'll drop the mutex a couple of times when it is safe to do so.
+	 * This might result in some blocks switching the state (online/offline=
)
+	 * and we could miss them in this run - we will retry again later.
+	 */
+	mutex_lock(&vm->hotplug_mutex);
+
+	/* Try to unplug subblocks of partially plugged offline blocks. */
+	virtio_mem_for_each_mb_state_rev(vm, mb_id,
+					 VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL) {
+		rc =3D virtio_mem_mb_unplug_any_sb_offline(vm, mb_id,
+							 &nb_sb);
+		if (rc || !nb_sb)
+			goto out_unlock;
+		cond_resched();
+	}
+
+	/* Try to unplug subblocks of plugged offline blocks. */
+	virtio_mem_for_each_mb_state_rev(vm, mb_id,
+					 VIRTIO_MEM_MB_STATE_OFFLINE) {
+		rc =3D virtio_mem_mb_unplug_any_sb_offline(vm, mb_id,
+							 &nb_sb);
+		if (rc || !nb_sb)
+			goto out_unlock;
+		cond_resched();
+	}
+
+	mutex_unlock(&vm->hotplug_mutex);
+	return 0;
+out_unlock:
+	mutex_unlock(&vm->hotplug_mutex);
+	return rc;
+}
+
 /*
  * Try to unplug all blocks that couldn't be unplugged before, for examp=
le,
  * because the hypervisor was busy.
@@ -1202,8 +1312,10 @@ static void virtio_mem_run_wq(struct work_struct *=
work)
 		if (vm->requested_size > vm->plugged_size) {
 			diff =3D vm->requested_size - vm->plugged_size;
 			rc =3D virtio_mem_plug_request(vm, diff);
+		} else {
+			diff =3D vm->plugged_size - vm->requested_size;
+			rc =3D virtio_mem_unplug_request(vm, diff);
 		}
-		/* TODO: try to unplug memory */
 	}
=20
 	switch (rc) {
--=20
2.24.1

