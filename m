Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD52138B6
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 12:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgGCKki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 06:40:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725984AbgGCKki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 06:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593772837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvOKeE9W3K+z4bWbP0gU4au5S8Ovk4stRWZMqPe80kQ=;
        b=FEVMU99t7w0LybYuikr76DdW2GEyhlVusAJEq/KtgglbBRidG1DjmIGOHxgDtIka1tJbOH
        7KBHUnLErKBdi+067TD+avM2u/hgXkX1NWuiV/ce99lmTmnR+l8HYgakf9gNr1MMe8SCbK
        KEr7OBKpJ1o3MwA/wG/P5cacA2TWCFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-PchIVjkqNdqJHzcoi9aB7Q-1; Fri, 03 Jul 2020 06:40:35 -0400
X-MC-Unique: PchIVjkqNdqJHzcoi9aB7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8784B800C60;
        Fri,  3 Jul 2020 10:40:34 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-0.ams2.redhat.com [10.36.114.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E095B7AC72;
        Fri,  3 Jul 2020 10:40:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH v1] virtio-mem: fix cross-compilation due to VIRTIO_MEM_USABLE_EXTENT
Date:   Fri,  3 Jul 2020 12:40:27 +0200
Message-Id: <20200703104027.30441-1-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The usable extend depends on the target, not on the destination. This
fixes cross-compilation on other architectures than x86-64.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index bf9b414522..65850530e7 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -51,7 +51,7 @@
  * necessary (as the section size can change). But it's more likely that the
  * section size will rather get smaller and not bigger over time.
  */
-#if defined(__x86_64__)
+#if defined(TARGET_X86_64) || defined(TARGET_I386)
 #define VIRTIO_MEM_USABLE_EXTENT (2 * (128 * MiB))
 #else
 #error VIRTIO_MEM_USABLE_EXTENT not defined
-- 
2.26.2

