Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A342BD69
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhJMKpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:45:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhJMKpE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBvLIgW2i2uwd7ToirTYXVN7d6sYO4/nwGsrCS5gg4M=;
        b=emJT5lbljc7C9AGfCiyhbZAT7rsxZYdK1I+viKC7ZywzDK/d06gNn317Acq4s8cT0oKCZ5
        WbN+j/ozTJcHzSt7/fJ6OBQ4y9mWovrSOuorSUYdjesyPNcEvsLMgTKFpHjqI/4GrxTSqo
        yVDuSx1AvHvx34RcKfGRBubzUGPPqbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-7IQ-mNL2Mw2TxTox0fZawA-1; Wed, 13 Oct 2021 06:42:57 -0400
X-MC-Unique: 7IQ-mNL2Mw2TxTox0fZawA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 851C0802C98;
        Wed, 13 Oct 2021 10:42:56 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0448A5DF21;
        Wed, 13 Oct 2021 10:42:17 +0000 (UTC)
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
Subject: [PATCH RFC 15/15] virtio-mem: Set "max-memslots" to 0 (auto) for the 6.2 machine
Date:   Wed, 13 Oct 2021 12:33:30 +0200
Message-Id: <20211013103330.26869-16-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's enable automatic detection of memslots to use for the 6.2 machine,
leaving the behavior of compat machines unchanged.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/core/machine.c      | 1 +
 hw/virtio/virtio-mem.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index b8d95eec32..25aa42cf9f 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -39,6 +39,7 @@
 
 GlobalProperty hw_compat_6_1[] = {
     { "vhost-user-vsock-device", "seqpacket", "off" },
+    { "virtio-mem", "max-memslots", "1" },
 };
 const size_t hw_compat_6_1_len = G_N_ELEMENTS(hw_compat_6_1);
 
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index f7e8f1db83..3de8ed94e6 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -1272,7 +1272,7 @@ static Property virtio_mem_properties[] = {
     DEFINE_PROP_LINK(VIRTIO_MEM_MEMDEV_PROP, VirtIOMEM, memdev,
                      TYPE_MEMORY_BACKEND, HostMemoryBackend *),
     DEFINE_PROP_UINT16(VIRTIO_MEM_MAX_MEMSLOTS_PROP, VirtIOMEM, nb_max_memslots,
-                       1),
+                       0),
     DEFINE_PROP_END_OF_LIST(),
 };
 
-- 
2.31.1

