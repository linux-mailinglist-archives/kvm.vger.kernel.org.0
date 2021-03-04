Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56932D42C
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241331AbhCDN3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:29:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241276AbhCDN2w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614864446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7P35+hl0rGzSm8fNL2MMnwVW2zrFoSI5a4tDCIPtXbw=;
        b=f5BLeB5a9aOlalBI0rE0FP8uof9oVAktEwk8BY3VSMkdqSJbBAKRHX2EfWBQ9llGMgjCLp
        la5EK8wS7kVmO1fxLoD55R8Pnug0XiMMSd7LbnubATNEjapfoj8W+uE8PKi/cmD3IdHg9G
        FhPnfsarU4woSxyh1Ef2gww+0ZqUBDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-HpxSyng9Pc-f-1KlWFnBUQ-1; Thu, 04 Mar 2021 08:27:25 -0500
X-MC-Unique: HpxSyng9Pc-f-1KlWFnBUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4DEE108BD1B;
        Thu,  4 Mar 2021 13:27:23 +0000 (UTC)
Received: from gondolin.redhat.com (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E79E84EF68;
        Thu,  4 Mar 2021 13:27:18 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC 0/2] virtio-ccw: allow to disable legacy virtio
Date:   Thu,  4 Mar 2021 14:27:13 +0100
Message-Id: <20210304132715.1587211-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike virtio-pci, virtio-ccw is currently always a transitional
driver (i.e. it always includes support for legacy devices.) The
differences between legacy and virtio-1+ virtio-ccw devices are not
that big (the most interesting things are in common virtio code
anyway.)

It might be beneficial to make support for legacy virtio generally
configurable, in case we want to remove it completely in a future
where we all have flying cars. As a prereq, we need to make it
configurable for virtio-ccw.

Patch 1 introduces a parameter; now that I look at it, it's probably
not that useful (not even for testing), so I'm inclined to drop it
again.

Patch 2 adds a new config symbol for generic legacy virtio support,
which currently does not do anything but being selected by the
legacy options for virtio-pci and virtio-ccw. A virtio-ccw driver
without legacy support will require a revision of 1 or higher to
be supported by the device.

A virtio-ccw driver with legacy turned off works well for me with
transitional devices and fails onlining gracefully for legacy devices
(max_revision=0 in QEMU).

(I also have some code that allows to make devices non-transitional
in QEMU, but I haven't yet found time to polish the patches.)

Cornelia Huck (2):
  virtio/s390: add parameter for minimum revision
  virtio/s390: make legacy support configurable

 arch/s390/Kconfig                       |  11 ++
 drivers/s390/virtio/Makefile            |   1 +
 drivers/s390/virtio/virtio_ccw.c        | 179 ++++++++----------------
 drivers/s390/virtio/virtio_ccw_common.h | 113 +++++++++++++++
 drivers/s390/virtio/virtio_ccw_legacy.c | 138 ++++++++++++++++++
 drivers/virtio/Kconfig                  |   8 ++
 6 files changed, 330 insertions(+), 120 deletions(-)
 create mode 100644 drivers/s390/virtio/virtio_ccw_common.h
 create mode 100644 drivers/s390/virtio/virtio_ccw_legacy.c


base-commit: cf6acb8bdb1d829b85a4daa2944bf9e71c93f4b9
-- 
2.26.2

