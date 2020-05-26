Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F591AEBAF
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 12:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgDRKXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 06:23:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgDRKWi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Apr 2020 06:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587205352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1YUNj0J7TkJiSbunnXUbMtu2GWAgY2j7p/Zlm7bbq2k=;
        b=CE1Q/Z9Qv+jRm71HhrdWp1SfeALjhMN/yBtVANoo2dHinoqeegaC1CfZ6zCmwmA5uYZ6Nj
        rTdSIMrEfiKhyogjRCF0duA2qLgTJLBkcKjSesM7m/W2mOtYvwZ06kAKYQ8XIoT07jFfK8
        taFTaVmWCLwSuRz00WyHFkW43CCCnzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-hFGc7cjiNHuGB6rKmK9-Hg-1; Sat, 18 Apr 2020 06:22:29 -0400
X-MC-Unique: hFGc7cjiNHuGB6rKmK9-Hg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD31418B9FC1;
        Sat, 18 Apr 2020 10:22:26 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 296401000325;
        Sat, 18 Apr 2020 10:22:21 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm list <kvm@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: [PATCH v3 0/8] tools/vhost: Reset virtqueue on tests
Date:   Sat, 18 Apr 2020 12:22:09 +0200
Message-Id: <20200418102217.32327-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series add tests used to validate the "vhost: Reset batched
descriptors on SET_VRING_BASE call" series, with a few minor updates of
them.

They are based on the tests sent back them, the ones that were not
included (reasons in that thread). This series changes:

* Delete need to export the ugly function in virtio_ring, now all the
code is added in tools/virtio (except the one line fix).
* Add forgotten uses of vhost_vq_set_backend. Fix bad usage order in
vhost_test_set_backend.
* Drop random reset, not really needed.
* Minor changes.

The first patch of this patchset ("vhost: Not cleaning batched descs in
VHOST_SET_VRING_BASE ioctl") should be squashed with ("vhost: batching
fetches") (currenlty, commit e7539c20a4a60b3a1bda3e7218c0d2a20669f357
in mst repository vhost branch).

Thanks!

Changes from v2:
* Squashed commits with fixes.
* Back to plain vring_*

Changes from v1:
* Different base, since branch was force-pushed.
* Using new vring_legacy_*, as base uses them now.

This serie is meant to be applied on top of
801f9bae9cf35b3192c3959d81a717e7985c64ed in
git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.

Eugenio P=C3=A9rez (8):
  vhost: Not cleaning batched descs in VHOST_SET_VRING_BASE ioctl
  tools/virtio: Add --batch option
  tools/virtio: Add --batch=3Drandom option
  tools/virtio: Add --reset
  tools/virtio: Use __vring_new_virtqueue in virtio_test.c
  tools/virtio: Extract virtqueue initialization in vq_reset
  tools/virtio: Reset index in virtio_test --reset.
  tools/virtio: Use tools/include/list.h instead of stubs

 drivers/vhost/test.c        |  57 +++++++++++++++
 drivers/vhost/test.h        |   1 +
 drivers/vhost/vhost.c       |   1 -
 tools/virtio/linux/kernel.h |   7 +-
 tools/virtio/linux/virtio.h |   5 +-
 tools/virtio/virtio_test.c  | 139 ++++++++++++++++++++++++++++++------
 tools/virtio/vringh_test.c  |   2 +
 7 files changed, 182 insertions(+), 30 deletions(-)

--=20
2.18.1

