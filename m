Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C73D1C86ED
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgEGKd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:33:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727778AbgEGKdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 06:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588847600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CeHzMmu7MwOrs5WjHHH6v/xc0aAfahem/qU8YFo2Z7g=;
        b=Ew2Hx3F90HvZX52lrx0Ij1GB+JSPigJsI85Iv3w+s1dfG4DG6Ucbr7gtiP4mVAOIgb6MFi
        m9f3d1ndKqaYrOOF1akTicphWDbUa7si08AXyLJie46zPBB4wV+PYtZ++LqaEgZfnLl6aX
        tjVasErp0mVeXTVlJbSLxin/sWDbQCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-9Slv2ln_MAewsJz0kKSRcw-1; Thu, 07 May 2020 06:33:17 -0400
X-MC-Unique: 9Slv2ln_MAewsJz0kKSRcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59E958015D1;
        Thu,  7 May 2020 10:33:15 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 193E85D9C5;
        Thu,  7 May 2020 10:33:03 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 09/15] virtio-mem: Better retry handling
Date:   Thu,  7 May 2020 12:31:13 +0200
Message-Id: <20200507103119.11219-10-david@redhat.com>
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
References: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start with a retry interval of 5 seconds and double the time until
we reach 5 minutes, in case we keep getting errors. Reset the retry
interval in case we succeeded.

The two main reasons for having to retry are
- The hypervisor is busy and cannot process our request
- We cannot reach the desired requested_size (esp., not enough memory can
  get unplugged because we can't allocate any subblocks).

Tested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
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
index a2edb87e5ed8..eb4c16d634e0 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -141,7 +141,9 @@ struct virtio_mem {
=20
 	/* Timer for retrying to plug/unplug memory. */
 	struct hrtimer retry_timer;
-#define VIRTIO_MEM_RETRY_TIMER_MS		30000
+	unsigned int retry_timer_ms;
+#define VIRTIO_MEM_RETRY_TIMER_MIN_MS		50000
+#define VIRTIO_MEM_RETRY_TIMER_MAX_MS		300000
=20
 	/* Memory notifier (online/offline events). */
 	struct notifier_block memory_notifier;
@@ -1550,6 +1552,7 @@ static void virtio_mem_run_wq(struct work_struct *w=
ork)
=20
 	switch (rc) {
 	case 0:
+		vm->retry_timer_ms =3D VIRTIO_MEM_RETRY_TIMER_MIN_MS;
 		break;
 	case -ENOSPC:
 		/*
@@ -1565,8 +1568,7 @@ static void virtio_mem_run_wq(struct work_struct *w=
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
@@ -1586,6 +1588,8 @@ static enum hrtimer_restart virtio_mem_timer_expire=
d(struct hrtimer *timer)
 					     retry_timer);
=20
 	virtio_mem_retry(vm);
+	vm->retry_timer_ms =3D min_t(unsigned int, vm->retry_timer_ms * 2,
+				   VIRTIO_MEM_RETRY_TIMER_MAX_MS);
 	return HRTIMER_NORESTART;
 }
=20
@@ -1754,6 +1758,7 @@ static int virtio_mem_probe(struct virtio_device *v=
dev)
 	spin_lock_init(&vm->removal_lock);
 	hrtimer_init(&vm->retry_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	vm->retry_timer.function =3D virtio_mem_timer_expired;
+	vm->retry_timer_ms =3D VIRTIO_MEM_RETRY_TIMER_MIN_MS;
=20
 	/* register the virtqueue */
 	rc =3D virtio_mem_init_vq(vm);
--=20
2.25.3

