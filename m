Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69CB4CA3E4
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbiCBLhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiCBLhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:37:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72EEFA2F0A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 03:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646220995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BUdvzXz8iGKsbnSpqy2Pkbfi1OdFt4mIGGx4XFIiu78=;
        b=FLUkc7zpda71d1bzLtPEgaUzPJfmKf5vnnIBOKZFHjBWJUt+w8Z2vxTZiQeMGjt/SfMH5r
        JkmZ3uREN3QPNRMNZp49ohRyAtAQefn7S3KAxdzv/jUcaDbatb4UCE3DvvLPga3j5kCyLr
        Maukw9qp9abvp2G6ddYv/odQ8ozDyXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-ZhDPsz3_PsqFxOZyebEWiA-1; Wed, 02 Mar 2022 06:36:32 -0500
X-MC-Unique: ZhDPsz3_PsqFxOZyebEWiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D4451854E21;
        Wed,  2 Mar 2022 11:36:30 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45A2183095;
        Wed,  2 Mar 2022 11:36:25 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>, Sergio Lopez <slp@redhat.com>
Subject: [PATCH 0/2] Enable vhost-user to be used on BSD systems
Date:   Wed,  2 Mar 2022 12:36:42 +0100
Message-Id: <20220302113644.43717-1-slp@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
1. Extending event_notifier_get_fd() to be able to return wfd when needed.=
=0D
=0D
2. Modifying the build system to it allows enabling vhost-user on BSD.=0D
=0D
Sergio Lopez (2):=0D
  Allow returning EventNotifier's wfd=0D
  Allow building vhost-user in BSD=0D
=0D
 accel/kvm/kvm-all.c                     | 12 +++----=0D
 block/linux-aio.c                       |  2 +-=0D
 block/nvme.c                            |  2 +-=0D
 configure                               |  5 +--=0D
 contrib/ivshmem-server/ivshmem-server.c |  5 +--=0D
 hw/hyperv/hyperv.c                      |  2 +-=0D
 hw/misc/ivshmem.c                       |  2 +-=0D
 hw/remote/iohub.c                       | 13 +++----=0D
 hw/remote/proxy.c                       |  4 +--=0D
 hw/vfio/ccw.c                           |  4 +--=0D
 hw/vfio/pci-quirks.c                    |  6 ++--=0D
 hw/vfio/pci.c                           | 48 +++++++++++++------------=0D
 hw/vfio/platform.c                      | 16 ++++-----=0D
 hw/virtio/vhost.c                       | 10 +++---=0D
 include/qemu/event_notifier.h           |  2 +-=0D
 meson.build                             |  2 +-=0D
 target/s390x/kvm/kvm.c                  |  2 +-=0D
 util/aio-posix.c                        |  4 +--=0D
 util/event_notifier-posix.c             |  5 ++-=0D
 util/vfio-helpers.c                     |  2 +-=0D
 20 files changed, 79 insertions(+), 69 deletions(-)=0D
=0D
-- =0D
2.35.1=0D
=0D

