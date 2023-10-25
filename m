Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E967D6FF5
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344159AbjJYOv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344712AbjJYOvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:37 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC27ED50
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=RxBAjsQ+mysvOozFK2bkVeJvxuxKEpOcW9P4vMvsaUw=; b=kWEwCVesu3RU1Gi+zD5e+MXOzL
        TI6NwMrSRoAQx1N/L//K4TlUXhKgj7PQrl+DuBhCNNSDgpxlC7tv6T7Eclwqo3JB/3jdzRkNzQ9qF
        quoMMtl9n21EtXIqLbI9iMJAqKE5Ob4RUIz7XAD1NO24I6Wwr+QeGorNW5GKyAU6AJbWDsEToPZSu
        XMKIpWSZ84bjXrvQIeIKE++0nq8nOdav05MHqaccNURQ/24YIQufkFSp5KZYBu8Or7scgLcu/6cHU
        UsvgICpmvIfuJWV3/+UaFP9GBwV1+sI8ZM3NKS1yiX/c3qj/QciOq9QyDey+tRL/JUEb9G4h67r4c
        sMq+tCFA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDZ-00GPLx-01;
        Wed, 25 Oct 2023 14:50:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDY-002dEF-06;
        Wed, 25 Oct 2023 15:50:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v3 05/28] hw/xen: fix XenStore watch delivery to guest
Date:   Wed, 25 Oct 2023 15:50:19 +0100
Message-Id: <20231025145042.627381-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231025145042.627381-1-dwmw2@infradead.org>
References: <20231025145042.627381-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When fire_watch_cb() found the response buffer empty, it would call
deliver_watch() to generate the XS_WATCH_EVENT message in the response
buffer and send an event channel notification to the guest… without
actually *copying* the response buffer into the ring. So there was
nothing for the guest to see. The pending response didn't actually get
processed into the ring until the guest next triggered some activity
from its side.

Add the missing call to put_rsp().

It might have been slightly nicer to call xen_xenstore_event() here,
which would *almost* have worked. Except for the fact that it calls
xen_be_evtchn_pending() to check that it really does have an event
pending (and clear the eventfd for next time). And under Xen it's
defined that setting that fd to O_NONBLOCK isn't guaranteed to work,
so the emu implementation follows suit.

This fixes Xen device hot-unplug.

Fixes: 0254c4d19df ("hw/xen: Add xenstore wire implementation and implementation stubs")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/i386/kvm/xen_xenstore.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index 660d0b72f9..8e716a7009 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -1357,10 +1357,12 @@ static void fire_watch_cb(void *opaque, const char *path, const char *token)
     } else {
         deliver_watch(s, path, token);
         /*
-         * If the message was queued because there was already ring activity,
-         * no need to wake the guest. But if not, we need to send the evtchn.
+         * Attempt to queue the message into the actual ring, and send
+         * the event channel notification if any bytes are copied.
          */
-        xen_be_evtchn_notify(s->eh, s->be_port);
+        if (s->rsp_pending && put_rsp(s) > 0) {
+            xen_be_evtchn_notify(s->eh, s->be_port);
+        }
     }
 }
 
-- 
2.40.1

