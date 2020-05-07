Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7161C86F3
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgEGKdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:33:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40177 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727859AbgEGKdf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 06:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588847615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VV+XtjN/vOPWAyzHKaECo8g5UUJQog8PwMWqUHC0ZqQ=;
        b=TzqTnt1jtlNmifVJCL4OO6+Gzp3DtCG0drOv5OpTYxaFKzLhrBviy6Q3rxGyX/8V7vdtle
        sHiZ4P3Akpgb5/SIvwN3nbjuGAMdDTZuMQoGah1FaEQ9OVF8Q6bCUEqUH2stPmRpWk6RaU
        Q0romAlX0ojhJCJsl3UW/j6wOlzZwnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-pwgm0o-_Ms-r2SPNS6lnKg-1; Thu, 07 May 2020 06:33:31 -0400
X-MC-Unique: pwgm0o-_Ms-r2SPNS6lnKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E7980183C;
        Thu,  7 May 2020 10:33:29 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D761E5D9C5;
        Thu,  7 May 2020 10:33:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH v3 13/15] virtio-mem: Unplug subblocks right-to-left
Date:   Thu,  7 May 2020 12:31:17 +0200
Message-Id: <20200507103119.11219-14-david@redhat.com>
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
References: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We unplug blocks right-to-left, let's also unplug subblocks within a bloc=
k
right-to-left.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 38 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 8dd57b61b09b..a719e1a04ac7 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -353,18 +353,6 @@ static bool virtio_mem_mb_test_sb_unplugged(struct v=
irtio_mem *vm,
 	return find_next_bit(vm->sb_bitmap, bit + count, bit) >=3D bit + count;
 }
=20
-/*
- * Find the first plugged subblock. Returns vm->nb_sb_per_mb in case the=
re is
- * none.
- */
-static int virtio_mem_mb_first_plugged_sb(struct virtio_mem *vm,
-					  unsigned long mb_id)
-{
-	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb;
-
-	return find_next_bit(vm->sb_bitmap, bit + vm->nb_sb_per_mb, bit) - bit;
-}
-
 /*
  * Find the first unplugged subblock. Returns vm->nb_sb_per_mb in case t=
here is
  * none.
@@ -1016,21 +1004,27 @@ static int virtio_mem_mb_unplug_any_sb(struct vir=
tio_mem *vm,
 	int sb_id, count;
 	int rc;
=20
+	sb_id =3D vm->nb_sb_per_mb - 1;
 	while (*nb_sb) {
-		sb_id =3D virtio_mem_mb_first_plugged_sb(vm, mb_id);
-		if (sb_id >=3D vm->nb_sb_per_mb)
+		/* Find the next candidate subblock */
+		while (sb_id >=3D 0 &&
+		       virtio_mem_mb_test_sb_unplugged(vm, mb_id, sb_id, 1))
+			sb_id--;
+		if (sb_id < 0)
 			break;
+		/* Try to unplug multiple subblocks at a time */
 		count =3D 1;
-		while (count < *nb_sb &&
-		       sb_id + count  < vm->nb_sb_per_mb &&
-		       virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id + count,
-						     1))
+		while (count < *nb_sb && sb_id > 0 &&
+		       virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id - 1, 1)) {
 			count++;
+			sb_id--;
+		}
=20
 		rc =3D virtio_mem_mb_unplug_sb(vm, mb_id, sb_id, count);
 		if (rc)
 			return rc;
 		*nb_sb -=3D count;
+		sb_id--;
 	}
=20
 	return 0;
@@ -1337,12 +1331,12 @@ static int virtio_mem_mb_unplug_any_sb_online(str=
uct virtio_mem *vm,
 	 * we should sense via something like is_mem_section_removable()
 	 * first if it makes sense to go ahead any try to allocate.
 	 */
-	for (sb_id =3D 0; sb_id < vm->nb_sb_per_mb && *nb_sb; sb_id++) {
+	for (sb_id =3D vm->nb_sb_per_mb - 1; sb_id >=3D 0 && *nb_sb; sb_id--) {
 		/* Find the next candidate subblock */
-		while (sb_id < vm->nb_sb_per_mb &&
+		while (sb_id >=3D 0 &&
 		       !virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
-			sb_id++;
-		if (sb_id >=3D vm->nb_sb_per_mb)
+			sb_id--;
+		if (sb_id < 0)
 			break;
=20
 		start_pfn =3D PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
--=20
2.25.3

