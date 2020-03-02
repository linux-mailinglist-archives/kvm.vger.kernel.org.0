Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD589175C4E
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 14:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgCBNxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 08:53:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42371 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727159AbgCBNxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 08:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583157209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJAXInylArG9rLg06go9tQ3aGFK8jnixemJ3wKG4rio=;
        b=iZvXmRtsaDMbP14qnayj9AIEuuTvdTsvlFNdZv+mWPbJbFz56tmIGWgUvWzqVSpgGVk3XB
        HZyfH2d/ejpmegQUkpWxTIdLzyPkbBEQkKr4BMg+vE0OsIPAJ8+uLjyAPuahtLuy/XmH+3
        7LYzVjONze/KFZ2xk9+7wP7/1ENps1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-5Oviz7HnPNqP0pDoEaZQVg-1; Mon, 02 Mar 2020 08:53:25 -0500
X-MC-Unique: 5Oviz7HnPNqP0pDoEaZQVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2CA8107BAA7;
        Mon,  2 Mar 2020 13:53:23 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16E2B385;
        Mon,  2 Mar 2020 13:53:12 +0000 (UTC)
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
Subject: [PATCH v1 10/11] virtio-mem: Better retry handling
Date:   Mon,  2 Mar 2020 14:49:40 +0100
Message-Id: <20200302134941.315212-11-david@redhat.com>
In-Reply-To: <20200302134941.315212-1-david@redhat.com>
References: <20200302134941.315212-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start with a retry interval of 30 seconds and double the time until
we reach 30 minutes, in case we keep getting errors. Reset the retry
interval in case we succeeded.

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
 drivers/virtio/virtio_mem.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 0274527ac517..8992d0d0e5da 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -138,7 +138,9 @@ struct virtio_mem {
=20
 	/* Timer for retrying to plug/unplug memory. */
 	struct hrtimer retry_timer;
-#define VIRTIO_MEM_RETRY_TIMER_MS		30000
+	unsigned int retry_timer_ms;
+#define VIRTIO_MEM_RETRY_TIMER_MIN_MS		30000
+#define VIRTIO_MEM_RETRY_TIMER_MAX_MS		1800000
=20
 	/* Memory notifier (online/offline events). */
 	struct notifier_block memory_notifier;
@@ -1544,6 +1546,7 @@ static void virtio_mem_run_wq(struct work_struct *w=
ork)
=20
 	switch (rc) {
 	case 0:
+		vm->retry_timer_ms =3D VIRTIO_MEM_RETRY_TIMER_MIN_MS;
 		break;
 	case -ENOSPC:
 		/*
@@ -1559,8 +1562,7 @@ static void virtio_mem_run_wq(struct work_struct *w=
ork)
 		 */
 	case -ENOMEM:
 		/* Out of memory, try again later. */
-		hrtimer_start(&vm->retry_timer,
-			      ms_to_ktime(VIRTIO_MEM_RETRY_TIMER_MS),
+		hrtimer_start(&vm->retry_timer, ms_to_ktime(vm->retry_timer_ms),
 			      HRTIMER_MODE_REL);
 		break;
 	case -EAGAIN:
@@ -1580,6 +1582,8 @@ static enum hrtimer_restart virtio_mem_timer_expire=
d(struct hrtimer *timer)
 					     retry_timer);
=20
 	virtio_mem_retry(vm);
+	vm->retry_timer_ms =3D min_t(unsigned int, vm->retry_timer_ms * 2,
+				   VIRTIO_MEM_RETRY_TIMER_MAX_MS);
 	return HRTIMER_NORESTART;
 }
=20
@@ -1746,6 +1750,7 @@ static int virtio_mem_probe(struct virtio_device *v=
dev)
 	spin_lock_init(&vm->removal_lock);
 	hrtimer_init(&vm->retry_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	vm->retry_timer.function =3D virtio_mem_timer_expired;
+	vm->retry_timer_ms =3D VIRTIO_MEM_RETRY_TIMER_MIN_MS;
=20
 	/* register the virtqueue */
 	rc =3D virtio_mem_init_vq(vm);
--=20
2.24.1

