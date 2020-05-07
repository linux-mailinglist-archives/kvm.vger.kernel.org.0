Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0061C86F8
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEGKdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:33:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33900 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727874AbgEGKdi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 06:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588847617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IMpKC+WaqGZDsc1g0rXogIX0QesvRk4Fl/dqbsUcG6U=;
        b=T70DOvut3+MhplrA4XVjUKKYISEkX8H5JPDylhhf8wxVwgfiOezdVRm0UHu0E+twYuf405
        SMwKM2J8EgUx2zU4Bd+TdINtJ80n3knR0Ax3nsA4ZqVvpgXXc1JDJdZiNmpbQt7fUVwMhs
        cdnrAAdd32CaS5M3WpZTEV/XpcB4Zx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-Rd-9UwcXMkuTVi-LBsv7Cg-1; Thu, 07 May 2020 06:33:33 -0400
X-MC-Unique: Rd-9UwcXMkuTVi-LBsv7Cg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30625872FE0;
        Thu,  7 May 2020 10:33:32 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30DFF5D9C5;
        Thu,  7 May 2020 10:33:30 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH v3 14/15] virtio-mem: Use -ETXTBSY as error code if the device is busy
Date:   Thu,  7 May 2020 12:31:18 +0200
Message-Id: <20200507103119.11219-15-david@redhat.com>
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
References: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's be able to distinguish if the device or if memory is busy.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index a719e1a04ac7..abd93b778a26 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -893,7 +893,7 @@ static int virtio_mem_send_plug_request(struct virtio=
_mem *vm, uint64_t addr,
 	case VIRTIO_MEM_RESP_NACK:
 		return -EAGAIN;
 	case VIRTIO_MEM_RESP_BUSY:
-		return -EBUSY;
+		return -ETXTBSY;
 	case VIRTIO_MEM_RESP_ERROR:
 		return -EINVAL;
 	default:
@@ -919,7 +919,7 @@ static int virtio_mem_send_unplug_request(struct virt=
io_mem *vm, uint64_t addr,
 		vm->plugged_size -=3D size;
 		return 0;
 	case VIRTIO_MEM_RESP_BUSY:
-		return -EBUSY;
+		return -ETXTBSY;
 	case VIRTIO_MEM_RESP_ERROR:
 		return -EINVAL;
 	default:
@@ -941,7 +941,7 @@ static int virtio_mem_send_unplug_all_request(struct =
virtio_mem *vm)
 		atomic_set(&vm->config_changed, 1);
 		return 0;
 	case VIRTIO_MEM_RESP_BUSY:
-		return -EBUSY;
+		return -ETXTBSY;
 	default:
 		return -ENOMEM;
 	}
@@ -1557,11 +1557,15 @@ static void virtio_mem_run_wq(struct work_struct =
*work)
 		 * or we have too many offline memory blocks.
 		 */
 		break;
-	case -EBUSY:
+	case -ETXTBSY:
 		/*
 		 * The hypervisor cannot process our request right now
-		 * (e.g., out of memory, migrating) or we cannot free up
-		 * any memory to unplug it (all plugged memory is busy).
+		 * (e.g., out of memory, migrating);
+		 */
+	case -EBUSY:
+		/*
+		 * We cannot free up any memory to unplug it (all plugged memory
+		 * is busy).
 		 */
 	case -ENOMEM:
 		/* Out of memory, try again later. */
--=20
2.25.3

