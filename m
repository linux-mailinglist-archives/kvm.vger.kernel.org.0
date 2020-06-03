Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1159B1ED266
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgFCOuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 10:50:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726229AbgFCOuA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 10:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591195799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLD/KBTVLxxXtXFqDAma0g8J7kWPaIou/da+Ye0k/8A=;
        b=DNx/72ZsQgtN4TPp0ho8PwGwCEfAp7NMFaJPwwVwkcnaZRYZiG6n2Rh/SLK8Xvryy+fVRg
        ycBOOKoxeG8z8kFbs5APzeoUyHgEunRy/sPJb+pH7kxVcCr/yxwsHzLpb3O5UWEJItpsFg
        W1h84KmvExyX4MWUAYBdGyPxpcdw1Zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-YYjeMyeAN1SyD-stfqG5-g-1; Wed, 03 Jun 2020 10:49:57 -0400
X-MC-Unique: YYjeMyeAN1SyD-stfqG5-g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62747800685;
        Wed,  3 Jun 2020 14:49:56 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-192.ams2.redhat.com [10.36.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 008825D9CD;
        Wed,  3 Jun 2020 14:49:51 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 06/20] target/i386: sev: Use ram_block_discard_disable()
Date:   Wed,  3 Jun 2020 16:49:00 +0200
Message-Id: <20200603144914.41645-7-david@redhat.com>
In-Reply-To: <20200603144914.41645-1-david@redhat.com>
References: <20200603144914.41645-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 51cdbe5496..4a4863db28 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -649,6 +649,12 @@ sev_guest_init(const char *id)
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
+    ret = ram_block_discard_disable(true);
+    if (ret) {
+        error_report("%s: cannot disable RAM discard", __func__);
+        return NULL;
+    }
+
     sev_state = s = g_new0(SEVState, 1);
     s->sev_info = lookup_sev_guest_info(id);
     if (!s->sev_info) {
@@ -724,6 +730,7 @@ sev_guest_init(const char *id)
 err:
     g_free(sev_state);
     sev_state = NULL;
+    ram_block_discard_disable(false);
     return NULL;
 }
 
-- 
2.25.4

