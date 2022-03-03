Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2C14CBD3E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiCCMBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 07:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiCCMA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 07:00:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85B8D16C4F8
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 04:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646308812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KdMdqEWeBP2boGVGfeEr3E5hnozpl+T46v4UlfqVOqc=;
        b=GZ8BhupHxleeNJFsCOb2vMRqIhhw3t9E4ZdOrbbmdm/+xomb2dSPWUmIlNd+Kw93QWYznl
        sQl2Uqh90tFa+f/2FNMLHK8V1HaRLbRM8ozLQQWfGZwmRB3dk+IXn+TXsc6bTGCGwrBB8g
        8AJ9z/iDCdZjB2VoS+TxpVpGr8xxDnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-_3OU1C2pOTmZ7s9ykW7b-g-1; Thu, 03 Mar 2022 07:00:09 -0500
X-MC-Unique: _3OU1C2pOTmZ7s9ykW7b-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F895801DDB;
        Thu,  3 Mar 2022 12:00:07 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.37.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A3A842CC;
        Thu,  3 Mar 2022 12:00:02 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v3 1/4] event_notifier: add event_notifier_get_wfd()
Date:   Thu,  3 Mar 2022 12:59:08 +0100
Message-Id: <20220303115911.20962-2-slp@redhat.com>
In-Reply-To: <20220303115911.20962-1-slp@redhat.com>
References: <20220303115911.20962-1-slp@redhat.com>
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

