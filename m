Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273831ABAA7
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440767AbgDPH6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:58:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31351 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440765AbgDPH5A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 03:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tgxXuDfLVs6iIVTGmU8+FmsYYfOK74J74eQhEPVIacc=;
        b=HDkGgjg3dVx8iwJBYbDMx8AftG6nTMeVBD2Etl7Lji9JcDBWwEh3CYBKzHwPB6y9Y33Vvd
        Ti37oopaVwIQTSkUqt6R7Cwkx+Thld9cKNUJFLRkoIYcm2krcpFqdYx+3EKRiglLQvx25d
        bTivJf/VIwzDfXspc0q9WuLUrXre49M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-MvXKLtxgOCKXkjX_gSKkhg-1; Thu, 16 Apr 2020 03:56:54 -0400
X-MC-Unique: MvXKLtxgOCKXkjX_gSKkhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9252C8017F3;
        Thu, 16 Apr 2020 07:56:52 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DD6F7E7C0;
        Thu, 16 Apr 2020 07:56:47 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/8] tools/vhost: Reset virtqueue on tests
Date:   Thu, 16 Apr 2020 09:56:35 +0200
Message-Id: <20200416075643.27330-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

This patchset commit messages contains references to commits under
"for_linus" tag and references to commits in for_linus..mst/vhost.
They are fixes, so probably it is better just to squash if possible:

("7c48601a3d4d tools/virtio: Add --reset=3Drandom"): Already in for_linus
("af3756cfed9a vhost: batching fetches"): Only in vhost branch, not in
for_linus.

Thanks!

Changes from v1:
* Different base, since branch was force-pushed.
* Using new vring_legacy_*, as base uses them now.

This serie is meant to be applied on top of
503b1b3efb47e267001beba8e0759c15fa3e9be7 in
git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.

Eugenio P=C3=A9rez (8):
  tools/virtio: fix virtio_test.c indentation
  vhost: Not cleaning batched descs in VHOST_SET_VRING_BASE ioctl
  vhost: Replace vq->private_data access by backend accesors
  vhost: Fix bad order in vhost_test_set_backend at enable
  tools/virtio: Use __vring_new_virtqueue in virtio_test.c
  tools/virtio: Extract virtqueue initialization in vq_reset
  tools/virtio: Reset index in virtio_test --reset.
  tools/virtio: Use tools/include/list.h instead of stubs

 drivers/vhost/test.c        |  8 ++---
 drivers/vhost/vhost.c       |  1 -
 tools/virtio/linux/kernel.h |  7 +----
 tools/virtio/linux/virtio.h |  5 ++--
 tools/virtio/virtio_test.c  | 58 +++++++++++++++++++++++++++----------
 tools/virtio/vringh_test.c  |  2 ++
 6 files changed, 51 insertions(+), 30 deletions(-)

--=20
2.18.1

