Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0111D36B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfLLRNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:13:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730089AbfLLRNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576170802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdeNKnrtxM4ObNLac44ljwb18ODcIBAtiRL+hFA1/ZQ=;
        b=F1Jq6Qi/b4eUh4H1fbgLIUDolzOYGJI+bwleBsORkOKlcwKd623q0NmAlHpsj33pXi4wIT
        qt4L6NZ8GVCjKaOqQz+Dnwp35n0o5zofUc14ciJvRcQl93sVKbpatefIlRoGjUB/rmb6BW
        QV569DAmCdIollps9LHlTbMWjfUctZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-s80F6KfRNRqjBO-zuYg7Sg-1; Thu, 12 Dec 2019 12:13:17 -0500
X-MC-Unique: s80F6KfRNRqjBO-zuYg7Sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06391800D53;
        Thu, 12 Dec 2019 17:13:16 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-65.ams2.redhat.com [10.36.117.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0516D5C1C3;
        Thu, 12 Dec 2019 17:13:07 +0000 (UTC)
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
Subject: [PATCH RFC v4 10/13] virtio-mem: Better retry handling
Date:   Thu, 12 Dec 2019 18:11:34 +0100
Message-Id: <20191212171137.13872-11-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 drivers/virtio/virtio_mem.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 807d4e393427..3a57434f92ed 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -137,7 +137,9 @@ struct virtio_mem {
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
@@ -1537,6 +1539,7 @@ static void virtio_mem_run_wq(struct work_struct *w=
ork)
=20
 	switch (rc) {
 	case 0:
+		vm->retry_timer_ms =3D VIRTIO_MEM_RETRY_TIMER_MIN_MS;
 		break;
 	case -ENOSPC:
 		/*
@@ -1552,8 +1555,7 @@ static void virtio_mem_run_wq(struct work_struct *w=
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
@@ -1573,6 +1575,9 @@ static enum hrtimer_restart virtio_mem_timer_expire=
d(struct hrtimer *timer)
 					     retry_timer);
=20
 	virtio_mem_retry(vm);
+	/* Racy (with reset in virtio_mem_run_wq), we ignore that for now. */
+	vm->retry_timer_ms =3D min_t(unsigned int, vm->retry_timer_ms * 2,
+				   VIRTIO_MEM_RETRY_TIMER_MAX_MS);
 	return HRTIMER_NORESTART;
 }
=20
@@ -1746,6 +1751,7 @@ static int virtio_mem_probe(struct virtio_device *v=
dev)
 	spin_lock_init(&vm->removal_lock);
 	hrtimer_init(&vm->retry_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	vm->retry_timer.function =3D virtio_mem_timer_expired;
+	vm->retry_timer_ms =3D VIRTIO_MEM_RETRY_TIMER_MIN_MS;
=20
 	/* register the virtqueue */
 	rc =3D virtio_mem_init_vq(vm);
--=20
2.23.0

