Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CB54CACEC
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbiCBSFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244365AbiCBSFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:05:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16EDD54FB2
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646244306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KdMdqEWeBP2boGVGfeEr3E5hnozpl+T46v4UlfqVOqc=;
        b=RNVw19sU3Z2fXJ+Ap6P70DtJEAue3SG6N8/l4SS77pbXfXMMH2s7mdCGT5umusSmwk7E6D
        UhntVGlnKKGwSc8aJ+Qr/h6+GyW5E7Ypen7InwNdAipqwjSRh7F/OoZOvWy8MCLb1EI9JZ
        S/CIHxNIoqsli6I9Mdea5S9rKUR/bUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-p_rODWPJMeeITqszFUTRsg-1; Wed, 02 Mar 2022 13:05:05 -0500
X-MC-Unique: p_rODWPJMeeITqszFUTRsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA3CF1006AA6;
        Wed,  2 Mar 2022 18:05:02 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 754BB838D1;
        Wed,  2 Mar 2022 18:04:13 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        qemu-block@nongnu.org, vgoyal@redhat.com,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-s390x@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v2 1/3] event_notifier: add event_notifier_get_wfd()
Date:   Wed,  2 Mar 2022 19:03:16 +0100
Message-Id: <20220302180318.28893-2-slp@redhat.com>
In-Reply-To: <20220302180318.28893-1-slp@redhat.com>
References: <20220302180318.28893-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

event_notifier_get_fd(const EventNotifier *e) always returns
EventNotifier's read file descriptor (rfd). This is not a problem when
the EventNotifier is backed by a an eventfd, as a single file
descriptor is used both for reading and triggering events (rfd ==
wfd).

But, when EventNotifier is backed by a pipe pair, we have two file
descriptors, one that can only be used for reads (rfd), and the other
only for writes (wfd).

There's, at least, one known situation in which we need to obtain wfd
instead of rfd, which is when setting up the file that's going to be
sent to the peer in vhost's SET_VRING_CALL.

Add a new event_notifier_get_wfd(const EventNotifier *e) that can be
used to obtain wfd where needed.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 include/qemu/event_notifier.h | 1 +
 util/event_notifier-posix.c   | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/qemu/event_notifier.h b/include/qemu/event_notifier.h
index b79add035d..8a4ff308e1 100644
--- a/include/qemu/event_notifier.h
+++ b/include/qemu/event_notifier.h
@@ -38,6 +38,7 @@ int event_notifier_test_and_clear(EventNotifier *);
 #ifdef CONFIG_POSIX
 void event_notifier_init_fd(EventNotifier *, int fd);
 int event_notifier_get_fd(const EventNotifier *);
+int event_notifier_get_wfd(const EventNotifier *);
 #else
 HANDLE event_notifier_get_handle(EventNotifier *);
 #endif
diff --git a/util/event_notifier-posix.c b/util/event_notifier-posix.c
index 8307013c5d..16294e98d4 100644
--- a/util/event_notifier-posix.c
+++ b/util/event_notifier-posix.c
@@ -99,6 +99,11 @@ int event_notifier_get_fd(const EventNotifier *e)
     return e->rfd;
 }
 
+int event_notifier_get_wfd(const EventNotifier *e)
+{
+    return e->wfd;
+}
+
 int event_notifier_set(EventNotifier *e)
 {
     static const uint64_t value = 1;
-- 
2.35.1

