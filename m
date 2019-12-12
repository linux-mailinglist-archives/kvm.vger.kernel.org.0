Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B938711D36F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfLLRNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:13:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59925 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730206AbfLLRNb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576170810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2upD/YUhaw2ZDUGySKrouuwI8eCyNFFa47e7Zu9VlYw=;
        b=LUaY5Gnuq2gnLK91kJ21eKMjxMK7jhFgHVgvspxLuDMWZRYTMC986MUbH49o9LpSkdfT2A
        yHiaHMUi195L0eAJ+ZZwQdf/uJirdBMtlnnndq6OpUZHwsVJbanB9XncWmy6dv+bOHf7KD
        Y8gH1Ph1Clur/Am0ETCiit9ZQmz9aXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-nNkgjHYrMa--T3YPAku24w-1; Thu, 12 Dec 2019 12:13:27 -0500
X-MC-Unique: nNkgjHYrMa--T3YPAku24w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73FEB107ACC5;
        Thu, 12 Dec 2019 17:13:25 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-65.ams2.redhat.com [10.36.117.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D360E5C1C3;
        Thu, 12 Dec 2019 17:13:18 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC v4 12/13] mm/vmscan: Export drop_slab() and drop_slab_node()
Date:   Thu, 12 Dec 2019 18:11:36 +0100
Message-Id: <20191212171137.13872-13-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have a way to trigger reclaiming of all reclaimable slab objec=
ts
from user space (echo 2 > /proc/sys/vm/drop_caches). Let's allow drivers
to also trigger this when they really want to make progress and know what
they are doing.

virtio-mem wants to use these functions when it failed to unplug memory
for quite some time (e.g., after 30 minutes). It will then try to
free up reclaimable objects by dropping the slab caches every now and
then (e.g., every 30 minutes) as long as necessary. There will be a way t=
o
disable this feature and info messages will be logged.

In the future, we want to have a drop_slab_range() functionality
instead. Memory offlining code has similar demands and also other
alloc_contig_range() users (e.g., gigantic pages) could make good use of
this feature. Adding it, however, requires more work/thought.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 4 ++--
 mm/vmscan.c        | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 64799c5cb39f..483300f58be8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2706,8 +2706,8 @@ int drop_caches_sysctl_handler(struct ctl_table *, =
int,
 					void __user *, size_t *, loff_t *);
 #endif
=20
-void drop_slab(void);
-void drop_slab_node(int nid);
+extern void drop_slab(void);
+extern void drop_slab_node(int nid);
=20
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c3e53502a84a..4e1cdaaec5e6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -719,6 +719,7 @@ void drop_slab_node(int nid)
 		} while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)) !=3D NULL);
 	} while (freed > 10);
 }
+EXPORT_SYMBOL(drop_slab_node);
=20
 void drop_slab(void)
 {
@@ -728,6 +729,7 @@ void drop_slab(void)
 		drop_slab_node(nid);
 	count_vm_event(DROP_SLAB);
 }
+EXPORT_SYMBOL(drop_slab);
=20
 static inline int is_page_cache_freeable(struct page *page)
 {
--=20
2.23.0

