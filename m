Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9A20ACFA
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgFZHYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:24:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728665AbgFZHYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYlfhj1OTPEaIzcBYdA05uMy9bmVrgsPwAVJjLsnp5k=;
        b=BGDt8GyOmwlqM63xhOoI5GUaMBy1eJeHNZqj6/+TTSnqy9haN6/kI2QH0D+trsUds8YcCz
        Wn9meynsTxyDjSN4OSyzILwhSyAwlRGqX8VOBr6iM+y4cPQ7rWN8IwZTIMJJwdgmUWJP72
        7Sh1wpnyVj7GlAXlVnuA0BtTcFXdlTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-7Jh82G8aOGGxlw28373TdA-1; Fri, 26 Jun 2020 03:24:04 -0400
X-MC-Unique: 7Jh82G8aOGGxlw28373TdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37D9E1005512;
        Fri, 26 Jun 2020 07:24:03 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 310241C8;
        Fri, 26 Jun 2020 07:23:58 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 07/21] target/i386: sev: Use ram_block_discard_disable()
Date:   Fri, 26 Jun 2020 09:22:34 +0200
Message-Id: <20200626072248.78761-8-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV will pin all guest memory, mark discarding of RAM broken. At the
time this is called, we cannot have anyone active that relies on discards
to work properly - let's still implement error handling.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 target/i386/sev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index d273174ad3..f100a53231 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -680,6 +680,12 @@ sev_guest_init(const char *id)
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
+    ret = ram_block_discard_disable(true);
+    if (ret) {
+        error_report("%s: cannot disable RAM discard", __func__);
+        return NULL;
+    }
+
     sev = lookup_sev_guest_info(id);
     if (!sev) {
         error_report("%s: '%s' is not a valid '%s' object",
@@ -751,6 +757,7 @@ sev_guest_init(const char *id)
     return sev;
 err:
     sev_guest = NULL;
+    ram_block_discard_disable(false);
     return NULL;
 }
 
-- 
2.26.2

