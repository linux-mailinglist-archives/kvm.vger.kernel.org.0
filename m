Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3461DB341
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgETMce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36933 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgETMcd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 08:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0h5mfzq+A62RyhkwKLGooNpTnN8J0fXCpseWp13+GE=;
        b=hU6FK8OTg90SVCctSr7oPx/6lqdxnAy2KTn9Ma0zp7m7vVIgtrKMvZ7Sou65hF3kZ3JYlB
        InUOXhizgU39I3oEyJnEI1LySYfXpuu2O9OWpdYZk8gaFoaCZ8viNSgNQTk/VVJz2ssDWI
        vdWQB0iEoxoXM9TN9PUJpqzIP1CSyGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-ry7lJIbwMVuu5JFod3zDWw-1; Wed, 20 May 2020 08:32:31 -0400
X-MC-Unique: ry7lJIbwMVuu5JFod3zDWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38075107ACCD;
        Wed, 20 May 2020 12:32:30 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59CCC61547;
        Wed, 20 May 2020 12:32:28 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 06/19] target/i386: sev: Use ram_block_discard_disable()
Date:   Wed, 20 May 2020 14:31:39 +0200
Message-Id: <20200520123152.60527-7-david@redhat.com>
In-Reply-To: <20200520123152.60527-1-david@redhat.com>
References: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV will pin all guest memory, mark discarding of RAM broken. At the
time this is called, we cannot have anyone active that relies on discards
to work properly.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 target/i386/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 51cdbe5496..cadaefc08d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -719,6 +719,7 @@ sev_guest_init(const char *id)
     ram_block_notifier_add(&sev_ram_notifier);
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, s);
+    g_assert(!ram_block_discard_disable(true));
 
     return s;
 err:
-- 
2.25.4

