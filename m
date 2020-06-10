Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6F1F53EC
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgFJLzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:55:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728774AbgFJLzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591790109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bRpzWo8mGWvq3enPFtqLN32egzNgjYQizck8xugJ+M=;
        b=gaiF9uKQOEnw/xpkr2H7jSIDPpUY0a8EkIT+HSl5WeYeZfUaeTaJrtDs4oFVQnp7sC/jqu
        B9WKyyjXA/b7VutLxn6fCUF2Z/gx2IWngFLBvakDUo9s1GVSXd4/uVCQsuEs7PtNrGOMrK
        uRFHXqVpIW89thfAaY8TvlbdOnF/jzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-DLX1pjx1OeOHbokAJF5eVg-1; Wed, 10 Jun 2020 07:55:07 -0400
X-MC-Unique: DLX1pjx1OeOHbokAJF5eVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E40A461;
        Wed, 10 Jun 2020 11:55:06 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-42.ams2.redhat.com [10.36.114.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE695D9D3;
        Wed, 10 Jun 2020 11:54:58 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 06/21] target/i386: sev: Use ram_block_discard_disable()
Date:   Wed, 10 Jun 2020 13:54:04 +0200
Message-Id: <20200610115419.51688-7-david@redhat.com>
In-Reply-To: <20200610115419.51688-1-david@redhat.com>
References: <20200610115419.51688-1-david@redhat.com>
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
2.26.2

