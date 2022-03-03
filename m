Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828194CBD3D
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 13:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiCCMA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 07:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiCCMAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 07:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA6D016C4F8
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 04:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646308807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RkYx8BXwwh5aXXB4HkCwMQFLwcuxo1yn4UgLAsD1Dfs=;
        b=CogcfqHap0LM1IBTOBRTHiUMyc6psVyvZ7HLiorQMJWPP4nBmOv1h34Q52kGF1CZU6YAhJ
        asVmhzhq9N/ry+9p6Z4BlTY5T2M3vqJ9BjNnfWbbef7N0RxcTYIz6JuH5Q3GKNqAwmIlma
        5wA724Ykddf/Y8UX4ClR53hz1I9QNZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-UiBKztlxOvKZl7V-c7T0JQ-1; Thu, 03 Mar 2022 07:00:04 -0500
X-MC-Unique: UiBKztlxOvKZl7V-c7T0JQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4045AFC81;
        Thu,  3 Mar 2022 12:00:02 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.37.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD960842DE;
        Thu,  3 Mar 2022 11:58:51 +0000 (UTC)
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
Subject: [PATCH v3 0/4] Enable vhost-user to be used on BSD systems
Date:   Thu,  3 Mar 2022 12:59:07 +0100
Message-Id: <20220303115911.20962-1-slp@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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
    allow enabling it on all non-Windows platforms. (Paolo Bonzini)=0D
=0D
v2->v3:=0D
  - Add a section to docs/interop/vhost-user.rst explaining how vhost-user=
=0D
    is supported on non-Linux platforms. (Stefan Hajnoczi)=0D
=0D
Sergio Lopez (4):=0D
  event_notifier: add event_notifier_get_wfd()=0D
  vhost: use wfd on functions setting vring call fd=0D
  configure, meson: allow enabling vhost-user on all POSIX systems=0D
  docs: vhost-user: add subsection for non-Linux platforms=0D
=0D
 configure                     |  4 ++--=0D
 docs/interop/vhost-user.rst   | 18 ++++++++++++++++++=0D
 hw/virtio/vhost.c             |  6 +++---=0D
 include/qemu/event_notifier.h |  1 +=0D
 meson.build                   |  2 +-=0D
 util/event_notifier-posix.c   |  5 +++++=0D
 6 files changed, 30 insertions(+), 6 deletions(-)=0D
=0D
-- =0D
2.35.1=0D
=0D

