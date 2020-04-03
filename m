Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6C19DC07
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 18:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403996AbgDCQvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 12:51:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403858AbgDCQve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 12:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585932694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nhFm16Rn59ljHy8zT4BNa+1TatqX7wOcSX4H/Bklex4=;
        b=ff4m51sAAZVKHnOuFxX43uniOzhykFICXbEi9tNijM41/cOVxmj4DWUJnvv5eQEWFV/qGm
        dyLufyqMA7s2WroDSaclBfuNpke1EF8by7ehiDeln3S7SDgquXH0b/bZpUjgHeJcuYNHb3
        7OodOmBhefxGHOR4dKN7njFi4pgHqNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-vq3TbPQyPVGdok5uH-fH2g-1; Fri, 03 Apr 2020 12:51:30 -0400
X-MC-Unique: vq3TbPQyPVGdok5uH-fH2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4748100550D;
        Fri,  3 Apr 2020 16:51:28 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4AA18A85;
        Fri,  3 Apr 2020 16:51:23 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 0/8] tools/vhost: Reset virtqueue on tests
Date:   Fri,  3 Apr 2020 18:51:11 +0200
Message-Id: <20200403165119.5030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series add the tests used to validate the "vhost: Reset batched
descriptors on SET_VRING_BASE call" series, with a small change on the
reset code (delete an extra unneded reset on VHOST_SET_VRING_BASE).

They are based on the tests sent back them, the ones that were not
included (reasons in that thread). This series changes:

* Delete need to export the ugly function in virtio_ring, now all the
code is added in tools/virtio (except the one line fix).
* Add forgotten uses of vhost_vq_set_backend. Fix bad usage order in
vhost_test_set_backend.
* Drop random reset, not really needed.
* Minor changes updating tests code.

This serie is meant to be applied on top of
5de4e0b7068337cf0d4ca48a4011746410115aae in
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

