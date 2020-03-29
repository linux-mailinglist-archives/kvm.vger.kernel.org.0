Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147CE196CF6
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgC2LeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:34:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40798 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727869AbgC2LeQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585481655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ViPGPqwEgspRtJgmZ4rE2OqFoX1oHWclqobpFUgHsnM=;
        b=He/no2RAPkfymhV+3KbcSW24BNsO8sYmihMdWTVOIwLmI7MHQowgaFCJeI492JWjDGaJgY
        E/IB8www1NV0Gac9ERd3sZwBosPtBsTXwlsbdtv1fsSl2KiKIQs6vnvmV4WcO3i3Zy4HpG
        XnKKEplZo7LfetEPxAeUtNAFwn3AJIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-gzzDmRD2MRCIB1hML660mw-1; Sun, 29 Mar 2020 07:34:11 -0400
X-MC-Unique: gzzDmRD2MRCIB1hML660mw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA33118B5F69;
        Sun, 29 Mar 2020 11:34:09 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-95.ams2.redhat.com [10.36.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 393DB5C1BE;
        Sun, 29 Mar 2020 11:34:03 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] vhost: Reset batched descriptors on SET_VRING_BASE call
Date:   Sun, 29 Mar 2020 13:33:53 +0200
Message-Id: <20200329113359.30960-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vhost did not reset properly the batched descriptors on SET_VRING_BASE ev=
ent. Because of that, is possible to return an invalid descriptor to the =
guest.

This series ammend this, and creates a test to assert correct behavior. T=
o do that, they need to expose a new function in virtio_ring, virtqueue_r=
eset_free_head. Not sure if this can be avoided.

Also, change from https://lkml.org/lkml/2020/3/27/108 is not included, th=
at avoids to update a variable in a loop where it can be updated once.

This is meant to be applied on top of eccb852f1fe6bede630e2e4f1a121a81e34=
354ab in git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git, and some =
commits should be squashed with that series.

Eugenio P=C3=A9rez (6):
  tools/virtio: Add --batch option
  tools/virtio: Add --batch=3Drandom option
  tools/virtio: Add --reset=3Drandom
  tools/virtio: Make --reset reset ring idx
  vhost: Delete virtqueue batch_descs member
  fixup! vhost: batching fetches

 drivers/vhost/test.c         |  57 ++++++++++++++++
 drivers/vhost/test.h         |   1 +
 drivers/vhost/vhost.c        |  12 +++-
 drivers/vhost/vhost.h        |   1 -
 drivers/virtio/virtio_ring.c |  18 +++++
 include/linux/virtio.h       |   2 +
 tools/virtio/linux/virtio.h  |   2 +
 tools/virtio/virtio_test.c   | 123 +++++++++++++++++++++++++++++++----
 8 files changed, 201 insertions(+), 15 deletions(-)

--=20
2.18.1

