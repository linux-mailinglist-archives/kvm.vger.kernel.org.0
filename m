Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6662F199EEB
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgCaT2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:28:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22650 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727795AbgCaT2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585682898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bZBZ2PvIvDxfPAe1u1A6kkjjW8ODyemq7LucCatSJOc=;
        b=fkKgv8kkWljFwdfF4mCP69z7oHk+IQztyjfT7G4xNfc+nm4ra+KCZwQaXLVKiAmsA2DbfL
        qIdXve7aCP0/08OYs3/G4rvYJpbH5E+UggdSpLZ0QM1neczgsAZEXK0GCsYJUFd4dF0Uhz
        q8qIE8w2jWFVidPtOKO+AxalLJu5MFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-PaRuMewrOIaDewXx01564w-1; Tue, 31 Mar 2020 15:28:14 -0400
X-MC-Unique: PaRuMewrOIaDewXx01564w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F07C418A6EC1;
        Tue, 31 Mar 2020 19:28:12 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-92.ams2.redhat.com [10.36.112.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BE2898A57;
        Tue, 31 Mar 2020 19:28:07 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 0/8] vhost: Reset batched descriptors on SET_VRING_BASE call
Date:   Tue, 31 Mar 2020 21:27:56 +0200
Message-Id: <20200331192804.6019-1-eperezma@redhat.com>
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

v3:
* Rename accesors functions.
* Make scsi and test use the accesors too.

v2:
* Squashed commits.
* Create vq private_data accesors (mst).

This is meant to be applied on top of
c4f1c41a6094582903c75c0dcfacb453c959d457 in
git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.

Eugenio P=C3=A9rez (5):
  vhost: Create accessors for virtqueues private_data
  tools/virtio: Add --batch option
  tools/virtio: Add --batch=3Drandom option
  tools/virtio: Add --reset=3Drandom
  tools/virtio: Make --reset reset ring idx

Michael S. Tsirkin (3):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched version by default
  vhost: batching fetches

 drivers/vhost/net.c          |  28 ++--
 drivers/vhost/scsi.c         |  14 +-
 drivers/vhost/test.c         |  69 ++++++++-
 drivers/vhost/test.h         |   1 +
 drivers/vhost/vhost.c        | 271 +++++++++++++++++++++++------------
 drivers/vhost/vhost.h        |  44 +++++-
 drivers/vhost/vsock.c        |  14 +-
 drivers/virtio/virtio_ring.c |  29 ++++
 tools/virtio/linux/virtio.h  |   2 +
 tools/virtio/virtio_test.c   | 123 ++++++++++++++--
 10 files changed, 456 insertions(+), 139 deletions(-)

--=20
2.18.1

