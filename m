Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D82D19B586
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 20:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbgDASbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 14:31:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732880AbgDASbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 14:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585765893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XFWPG187HUhkSGxk00FG9TA0iVCphDpDrVtIpYx7KzE=;
        b=NZ+quproBE+kn77jrrNP2osXJPfthwFAUeKeVeWVt5WxUUwoS4GYAtJm79y7mp9kwFK4La
        KxrMkDWpbjl0ztddfI1JumIY+oPfeR0Mgu+kY15/dcgSmZ5Vl5MD3sHP3Mt56vBvVOg2Y2
        7LzRSCd9b3rXMYAw2+BprMmDTsTKh6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-o8ufVN_IPVGhpVSDAjVHrw-1; Wed, 01 Apr 2020 14:31:29 -0400
X-MC-Unique: o8ufVN_IPVGhpVSDAjVHrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9962918C8C19;
        Wed,  1 Apr 2020 18:31:27 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-73.ams2.redhat.com [10.36.113.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0887196F83;
        Wed,  1 Apr 2020 18:31:22 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v4 0/7] vhost: Reset batched descriptors on SET_VRING_BASE call
Date:   Wed,  1 Apr 2020 20:31:11 +0200
Message-Id: <20200401183118.8334-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vhost did not reset properly the batched descriptors on SET_VRING_BASE
event. Because of that, is possible to return an invalid descriptor to
the guest.

This series ammend this, resetting them every time backend changes, and
creates a test to assert correct behavior. To do that, they need to
expose a new function in virtio_ring, virtqueue_reset_free_head, only
on test code.

Another useful thing would be to check if mutex is properly get in
vq private_data accessors. Not sure if mutex debug code allow that,
similar to C++ unique lock::owns_lock. Not acquiring in the function
because caller code holds the mutex in order to perform more actions.

v4:
* Rebase with vhost_iotlb changes.

v3:
* Rename accesors functions.
* Make scsi and test use the accesors too.

v2:
* Squashed commits.
* Create vq private_data accesors (mst).

This serie is meant to be applied on top of
38dd2ba72ece18ec8398c8ddd13cfb02870b0309 in
git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.

Eugenio P=C3=A9rez (4):
  tools/virtio: Add --batch option
  tools/virtio: Add --batch=3Drandom option
  tools/virtio: Add --reset=3Drandom
  tools/virtio: Make --reset reset ring idx

Michael S. Tsirkin (3):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched version by default
  vhost: batching fetches

 drivers/vhost/test.c         |  59 +++++++-
 drivers/vhost/test.h         |   1 +
 drivers/vhost/vhost.c        | 271 +++++++++++++++++++++++------------
 drivers/vhost/vhost.h        |  17 ++-
 drivers/virtio/virtio_ring.c |  29 ++++
 tools/virtio/linux/virtio.h  |   2 +
 tools/virtio/virtio_test.c   | 123 ++++++++++++++--
 7 files changed, 395 insertions(+), 107 deletions(-)

--=20
2.18.1

