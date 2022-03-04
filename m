Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE664CD212
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239493AbiCDKKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiCDKKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:10:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D805A10A7E3
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646388584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bdEk9MzUI/N0m+HiOdQdbRzTmVVSyB4FcT+JOH8W0w=;
        b=K1t9nVEKfm39Evq4VB78TJ+HADOt1EuWctdC6dq22P1+kQlsoGJXu4b/bi91SxGOK8MBw+
        GzlFIpiCXc+g7RhpVeoeS7hPO9LbeLZFWDUj5IqHQcIDc9YLlzTCLLH+1g6WEn4jtv7591
        AzBZVUHWUkg1lv4p6Fn5VtLSniBWyy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-u7FxdYnVMcyKNfbs4GfQEg-1; Fri, 04 Mar 2022 05:09:40 -0500
X-MC-Unique: u7FxdYnVMcyKNfbs4GfQEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5C7F501EE;
        Fri,  4 Mar 2022 10:09:38 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15097842BA;
        Fri,  4 Mar 2022 10:09:04 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, vgoyal@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 1/4] event_notifier: add event_notifier_get_wfd()
Date:   Fri,  4 Mar 2022 11:08:51 +0100
Message-Id: <20220304100854.14829-2-slp@redhat.com>
In-Reply-To: <20220304100854.14829-1-slp@redhat.com>
References: <20220304100854.14829-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
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

