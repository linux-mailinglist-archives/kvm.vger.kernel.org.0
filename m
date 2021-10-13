Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABB042BCE2
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhJMKhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhJMKhC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cHf2ZqC5DC9zioFkkyjMYiEOu523mJCDOZFO8VfZXy8=;
        b=a8+EKECW4PqHC/7NpsKrljdEvrtBQjiZDZjzeRD2JkoePy4s+IaVvQVve+9V7yqEK05D2e
        VGsTAfD/7a+RR7UXBn++vkUGY/dnhQ7/8nkOTBeXAyW87J3ZclXNZZcj2R9QQPB8xHw/54
        jfo3vgpELvJJu/0ZZCZkBOv0vEtrwWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-NI4MhWvBNF6bRyWFtjjMtw-1; Wed, 13 Oct 2021 06:34:56 -0400
X-MC-Unique: NI4MhWvBNF6bRyWFtjjMtw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F84C100CCC2;
        Wed, 13 Oct 2021 10:34:55 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4110D5D9D5;
        Wed, 13 Oct 2021 10:34:49 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH RFC 05/15] vhost: Don't merge unmergeable memory sections
Date:   Wed, 13 Oct 2021 12:33:20 +0200
Message-Id: <20211013103330.26869-6-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

