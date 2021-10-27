Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6243C9F3
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241988AbhJ0MsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241980AbhJ0MsX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cHf2ZqC5DC9zioFkkyjMYiEOu523mJCDOZFO8VfZXy8=;
        b=BL267+ptq0W2bYQ52iivwUPQPh5j3f2vS1ZEExf0yo9m/Xdqd+JsA+NXksaWc2h7NnvhLj
        QFHdAz8gA+eJp4l34ipayYGbl2FLvFD39tOwNofc4yuYr3/x+Biuc6A21cJgH4NxI+xJka
        dP6QI+I7T/TWuYiSpwk9Vy+p/rqzbq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-EzF0ft-uOY2jUUW1mdrN4g-1; Wed, 27 Oct 2021 08:45:54 -0400
X-MC-Unique: EzF0ft-uOY2jUUW1mdrN4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00F92802B4F;
        Wed, 27 Oct 2021 12:45:53 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA57D19724;
        Wed, 27 Oct 2021 12:45:49 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 04/12] vhost: Don't merge unmergeable memory sections
Date:   Wed, 27 Oct 2021 14:45:23 +0200
Message-Id: <20211027124531.57561-5-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Memory sections that are marked unmergeable should not be merged, to
allow for atomic removal later.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2707972870..49a1074097 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -620,7 +620,7 @@ static void vhost_region_add_section(struct vhost_dev *dev,
                                                mrs_size, mrs_host);
     }
 
-    if (dev->n_tmp_sections) {
+    if (dev->n_tmp_sections && !section->unmergeable) {
         /* Since we already have at least one section, lets see if
          * this extends it; since we're scanning in order, we only
          * have to look at the last one, and the FlatView that calls
@@ -653,7 +653,7 @@ static void vhost_region_add_section(struct vhost_dev *dev,
             size_t offset = mrs_gpa - prev_gpa_start;
 
             if (prev_host_start + offset == mrs_host &&
-                section->mr == prev_sec->mr &&
+                section->mr == prev_sec->mr && !prev_sec->unmergeable &&
                 (!dev->vhost_ops->vhost_backend_can_merge ||
                  dev->vhost_ops->vhost_backend_can_merge(dev,
                     mrs_host, mrs_size,
-- 
2.31.1

