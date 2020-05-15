Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C49F1D4A9F
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 12:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgEOKO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 06:14:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728290AbgEOKO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 06:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589537665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUc3PuOX813Luq3FUqNVTnGhB/o6E0eeOYPacW9Z1Gk=;
        b=Etbk/Aq/HDlE8LdSj/DGBgE0ypMARfAV9zNCAiCPvt3RZ0WtJN0sKz+iV0zaIZ2YSOALYa
        sweKMYLiSugGvhrIQHlrnIjEIBu5Va0khCAdOfhua92/sRO430mStfu04ADPtmdAZlDhVo
        eea14aUxpAdNGr+BzZPZdmVUBEis1x0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-t0_WzsGWPv2-7atizBRpXg-1; Fri, 15 May 2020 06:14:23 -0400
X-MC-Unique: t0_WzsGWPv2-7atizBRpXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55031835B44;
        Fri, 15 May 2020 10:14:21 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA02360FB9;
        Fri, 15 May 2020 10:14:12 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>
Subject: [PATCH v4 16/15] virtio-mem: Don't rely on implicit compiler padding for requests
Date:   Fri, 15 May 2020 12:14:02 +0200
Message-Id: <20200515101402.16597-1-david@redhat.com>
In-Reply-To: <20200507140139.17083-1-david@redhat.com>
References: <20200507140139.17083-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The compiler will add padding after the last member, make that explicit.
The size of a request is always 24 bytes. The size of a response always
10 bytes. Add compile-time checks.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

Something I noticed while working on the spec (which proves that writing a
virtio-spec makes sense :) ).

---
 drivers/virtio/virtio_mem.c     | 3 +++
 include/uapi/linux/virtio_mem.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 9e523db3bee1..f658fe9149be 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -1770,6 +1770,9 @@ static int virtio_mem_probe(struct virtio_device *vdev)
 	struct virtio_mem *vm;
 	int rc = -EINVAL;
 
+	BUILD_BUG_ON(sizeof(struct virtio_mem_req) != 24);
+	BUILD_BUG_ON(sizeof(struct virtio_mem_resp) != 10);
+
 	vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
 	if (!vm)
 		return -ENOMEM;
diff --git a/include/uapi/linux/virtio_mem.h b/include/uapi/linux/virtio_mem.h
index e0a9dc7397c3..a455c488a995 100644
--- a/include/uapi/linux/virtio_mem.h
+++ b/include/uapi/linux/virtio_mem.h
@@ -103,16 +103,19 @@
 struct virtio_mem_req_plug {
 	__virtio64 addr;
 	__virtio16 nb_blocks;
+	__virtio16 padding[3];
 };
 
 struct virtio_mem_req_unplug {
 	__virtio64 addr;
 	__virtio16 nb_blocks;
+	__virtio16 padding[3];
 };
 
 struct virtio_mem_req_state {
 	__virtio64 addr;
 	__virtio16 nb_blocks;
+	__virtio16 padding[3];
 };
 
 struct virtio_mem_req {
-- 
2.25.4

