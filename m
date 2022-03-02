Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FA14CACE5
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiCBSFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244283AbiCBSFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:05:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31FAB3CA4F
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646244258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=s7PNT5w0na4dAC2Znwh5KJuYoihX1QJAjDb7qrJjyeU=;
        b=hafAaouADEPs6ovKs/wioOgoDnzJ0DArt9z5vUmNmhEWYh/9jQ1FYyx/sNqQBvJzHmCfJH
        fVggsGjUFBz7HIQg3z771JhZ1LPrQDgFLWByyIKRoPDV7qeFxzff1fZRcAQXFJguv3sDLI
        Y8OBrMYEal/P6bHe6501ZZCQc1h7Nhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-VGZrFbNYOr2z_9m6d4X_0A-1; Wed, 02 Mar 2022 13:04:15 -0500
X-MC-Unique: VGZrFbNYOr2z_9m6d4X_0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15907180FD74;
        Wed,  2 Mar 2022 18:04:13 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4056684781;
        Wed,  2 Mar 2022 18:02:59 +0000 (UTC)
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
Subject: [PATCH v2 0/3] Enable vhost-user to be used on BSD systems
Date:   Wed,  2 Mar 2022 19:03:15 +0100
Message-Id: <20220302180318.28893-1-slp@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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

Since QEMU is already able to emulate ioeventfd using pipefd, we're already=
=0D
pretty close to supporting vhost-user on non-Linux systems.=0D
=0D
This two patches bridge the gap by:=0D
=0D
1. Adding a new event_notifier_get_wfd() to return wfd on the places where=
=0D
   the peer is expected to write to the notifier.=0D
=0D
2. Modifying the build system to it allows enabling vhost-user on BSD.=0D
=0D
v1->v2:=0D
  - Drop: "Allow returning EventNotifier's wfd" (Alex Williamson)=0D
  - Add: "event_notifier: add event_notifier_get_wfd()" (Alex Williamson)=0D
  - Add: "vhost: use wfd on functions setting vring call fd"=0D
  - Rename: "Allow building vhost-user in BSD" to "configure, meson: allow=
=0D
    enabling vhost-user on all POSIX systems"=0D
  - Instead of making possible enabling vhost-user on Linux and BSD systems=
,=0D
    allow enabling it on all non-Windows platforms. (Paolo)=0D
=0D
Sergio Lopez (3):=0D
  event_notifier: add event_notifier_get_wfd()=0D
  vhost: use wfd on functions setting vring call fd=0D
  configure, meson: allow enabling vhost-user on all POSIX systems=0D
=0D
 configure                     | 4 ++--=0D
 hw/virtio/vhost.c             | 6 +++---=0D
 include/qemu/event_notifier.h | 1 +=0D
 meson.build                   | 2 +-=0D
 util/event_notifier-posix.c   | 5 +++++=0D
 5 files changed, 12 insertions(+), 6 deletions(-)=0D
=0D
-- =0D
2.35.1=0D
=0D

