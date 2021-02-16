Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F4E31C84D
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBPJqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhBPJqd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wcnd7ClbZgShooWszPEgOAqPp+c33seC7pun/tamuzE=;
        b=hti9g678GWwU23gGIDts/48Kubo5NXXl/1cT/UQlemoHVxp53DCzgmQGQCCE87GwvSFwPS
        Cs8EulP2Q30rGhWDNW6kOAAt895hwf2nOUH7HC7eJE4iYn5gTIMkfrLDVqHO0/Yo+RSGXv
        Cg7a34t/6+mDLNMvOdrsvlV5u2K3RHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-MA4WhP80O1ixGB_T6ZurCA-1; Tue, 16 Feb 2021 04:45:04 -0500
X-MC-Unique: MA4WhP80O1ixGB_T6ZurCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CD6A801998;
        Tue, 16 Feb 2021 09:45:03 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7BD15D9C0;
        Tue, 16 Feb 2021 09:44:55 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 00/10] vdpa: get/set_config() rework
Date:   Tue, 16 Feb 2021 10:44:44 +0100
Message-Id: <20210216094454.82106-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the discussion with Michael and Jason [1], I reworked a bit
get/set_config() in vdpa.

I changed vdpa_get_config() to check the boundaries and added vdpa_set_config().
When 'offset' or 'len' parameters exceed boundaries, we limit the reading to
the available configuration space in the device, and we return the amount of
bytes read/written.

In this way the user space can pass buffers bigger than config space.
I also returned the amount of bytes read and written to user space.

Patches also available here:
https://github.com/stefano-garzarella/linux/tree/vdpa-get-set-config-refactoring

Thanks for your comments,
Stefano

[1] https://lkml.org/lkml/2021/2/10/350

Stefano Garzarella (10):
  vdpa: add get_config_size callback in vdpa_config_ops
  vdpa: check vdpa_get_config() parameters and return bytes read
  vdpa: add vdpa_set_config() helper
  vdpa: remove param checks in the get/set_config callbacks
  vdpa: remove WARN_ON() in the get/set_config callbacks
  virtio_vdpa: use vdpa_set_config()
  vhost/vdpa: use vdpa_set_config()
  vhost/vdpa: allow user space to pass buffers bigger than config space
  vhost/vdpa: use get_config_size callback in
    vhost_vdpa_config_validate()
  vhost/vdpa: return configuration bytes read and written to user space

 include/linux/vdpa.h              | 22 ++++-------
 drivers/vdpa/ifcvf/ifcvf_base.c   |  3 +-
 drivers/vdpa/ifcvf/ifcvf_main.c   |  8 +++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  9 ++++-
 drivers/vdpa/vdpa.c               | 51 ++++++++++++++++++++++++
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 15 +++++---
 drivers/vhost/vdpa.c              | 64 ++++++++++++++++---------------
 drivers/virtio/virtio_vdpa.c      |  3 +-
 8 files changed, 116 insertions(+), 59 deletions(-)

-- 
2.29.2

