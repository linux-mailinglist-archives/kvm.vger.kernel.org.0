Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FF242BD48
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhJMKns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:43:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229461AbhJMKnr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3wYyhah5TBD+5tb0f6Fmglz6xziVK7NNaX1k9BXRGA=;
        b=Ir7EGoblJwJV2gpLo9GqB3z8ChEDnJgN9UOjwt0kv4WO5rQaCr95staU8palDT2UXFmbMh
        p/iZLDUhwO+sU1rmI174ZHzKINCrUCStJ4VPFNiBDR/noYO0BVOb9tjYNqXpoPnJB+MvxV
        98ettIMQfUjthuW9BLov963YpVJE9+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-kLb36IpyOSGmbDfXBZ-wbA-1; Wed, 13 Oct 2021 06:41:40 -0400
X-MC-Unique: kLb36IpyOSGmbDfXBZ-wbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C2410A8E02;
        Wed, 13 Oct 2021 10:41:39 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DC6F5D9D5;
        Wed, 13 Oct 2021 10:40:12 +0000 (UTC)
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
Subject: [PATCH RFC 13/15] vhost-user: Increase VHOST_USER_MAX_RAM_SLOTS to 496 with CONFIG_VIRTIO_MEM
Date:   Wed, 13 Oct 2021 12:33:28 +0200
Message-Id: <20211013103330.26869-14-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's increase the number of slots to 4096 to allow for increased
flexibility with virtio-mem when dealing with large virtio-mem devices
that start out small.

In the future, we might want to look into some performance improvements,
but for now there isn't really anything stopping us from raising the
limit.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/vhost-user.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 2c8556237f..1c6a720728 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -24,6 +24,7 @@
 #include "sysemu/cryptodev.h"
 #include "migration/migration.h"
 #include "migration/postcopy-ram.h"
+#include CONFIG_DEVICES
 #include "trace.h"
 
 #include <sys/ioctl.h>
@@ -45,8 +46,10 @@
  * the maximum number supported by the target
  * hardware plaform.
  */
-#if defined(TARGET_X86) || defined(TARGET_X86_64) || \
-    defined(TARGET_ARM) || defined(TARGET_ARM_64)
+#if defined(CONFIG_VIRTIO_MEM)
+#define VHOST_USER_MAX_RAM_SLOTS 4096
+#elif defined(TARGET_X86) || defined(TARGET_X86_64) || \
+      defined(TARGET_ARM) || defined(TARGET_ARM_64)
 #include "hw/acpi/acpi.h"
 #define VHOST_USER_MAX_RAM_SLOTS ACPI_MAX_RAM_SLOTS
 
-- 
2.31.1

