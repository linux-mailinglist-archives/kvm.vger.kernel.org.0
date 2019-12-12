Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA65511D35A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbfLLRNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:13:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50933 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730188AbfLLRNF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576170784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRA+T3LczXKLz/t1x5ONbwAW2HplNDXABfw4iwLSung=;
        b=GvIQ3IoNhbxzJsKwz8C5CTdV3+QO5e2ruUlcbNHdWFmB5PHFJYn3+8L00Sl0KSa7oXkiRJ
        wE6SL+1LXzNS5qGslEaGiLzxY+QPtbyYzRJPRBn3PkrzYLLTrtZncpYaTwJNT7JGYyBx3g
        0KkphcQ4Rxc4YiYFQa5DoqPEsXvRWgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-v1whvpOoM_OtlY-bBijBcA-1; Thu, 12 Dec 2019 12:13:01 -0500
X-MC-Unique: v1whvpOoM_OtlY-bBijBcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52813800D5A;
        Thu, 12 Dec 2019 17:12:59 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-65.ams2.redhat.com [10.36.117.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7388F5C21B;
        Thu, 12 Dec 2019 17:12:56 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.com>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH RFC v4 08/13] mm/memory_hotplug: Introduce offline_and_remove_memory()
Date:   Thu, 12 Dec 2019 18:11:32 +0100
Message-Id: <20191212171137.13872-9-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio-mem wants to offline and remove a memory block once it unplugged
all subblocks (e.g., using alloc_contig_range()). Let's provide
an interface to do that from a driver. virtio-mem already supports to
offline partially unplugged memory blocks. Offlining a fully unplugged
memory block will not require to migrate any pages. All unplugged
subblocks are PageOffline() and have a reference count of 0 - so
offlining code will simply skip them.

All we need an interface to trigger the "offlining" and the removing in a
single operation - to make sure the memory block cannot get onlined by
user space again before it gets removed.

To keep things simple, allow to only work on a single memory block.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/memory_hotplug.h |  1 +
 mm/memory_hotplug.c            | 35 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index ba0dca6aac6e..586f5c59c291 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -310,6 +310,7 @@ extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages=
);
 extern int remove_memory(int nid, u64 start, u64 size);
 extern void __remove_memory(int nid, u64 start, u64 size);
+extern int offline_and_remove_memory(int nid, u64 start, u64 size);
=20
 #else
 static inline bool is_mem_section_removable(unsigned long pfn,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index da01453a04e6..d04369e6d3cc 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1825,4 +1825,39 @@ int remove_memory(int nid, u64 start, u64 size)
 	return rc;
 }
 EXPORT_SYMBOL_GPL(remove_memory);
+
+/*
+ * Try to offline and remove a memory block. Might take a long time to
+ * finish in case memory is still in use. Primarily useful for memory de=
vices
+ * that logically unplugged all memory (so it's no longer in use) and wa=
nt to
+ * offline + remove the memory block.
+ */
+int offline_and_remove_memory(int nid, u64 start, u64 size)
+{
+	struct memory_block *mem;
+	int rc =3D -EINVAL;
+
+	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+	    size !=3D memory_block_size_bytes())
+		return rc;
+
+	lock_device_hotplug();
+	mem =3D find_memory_block(__pfn_to_section(PFN_DOWN(start)));
+	if (mem)
+		rc =3D device_offline(&mem->dev);
+	/* Ignore if the device is already offline. */
+	if (rc > 0)
+		rc =3D 0;
+
+	/*
+	 * In case we succeeded to offline the memory block, remove it.
+	 * This cannot fail as it cannot get onlined in the meantime.
+	 */
+	if (!rc && try_remove_memory(nid, start, size))
+		BUG();
+	unlock_device_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
--=20
2.23.0

