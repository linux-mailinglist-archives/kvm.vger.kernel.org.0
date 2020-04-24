Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22AA1B78E9
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgDXPJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:09:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41257 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728047AbgDXPJE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 11:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587740943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mGgOnRVzcCEgMJaj5VrAhSpVCj/tilxi8AFKq06F19o=;
        b=Vf24+Hr9G4Dusn980oam3TXgYnqPZa6PuDqbwRjFh0PclZ0PtvmQKIZvGsY8QWUUIPbIvL
        yVBIh20T6Aw6XSWFrkE39AE70AR3Fi+uPo/Nl3K9gGXHSTkV5mqbM5l2ahiXIDSoIpvT1E
        WWyd7xJCV/eMefHkFgY1xOyx2z0C+5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-MjVSv9QHNR6m_5AgATCLsw-1; Fri, 24 Apr 2020 11:08:54 -0400
X-MC-Unique: MjVSv9QHNR6m_5AgATCLsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16056846348;
        Fri, 24 Apr 2020 15:08:34 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-43.ams2.redhat.com [10.36.114.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E8EC5D76A;
        Fri, 24 Apr 2020 15:08:31 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2] vsock/virtio: fixes about packet delivery to
 monitoring devices
Date:   Fri, 24 Apr 2020 17:08:28 +0200
Message-Id: <20200424150830.183113-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During the review of v1, Stefan pointed out an issue introduced by=0D
that patch, where replies can appear in the packet capture before=0D
the transmitted packet.=0D
=0D
While fixing my patch, reverting it and adding a new flag in=0D
'struct virtio_vsock_pkt' (patch 2/2), I found that we already had=0D
that issue in vhost-vsock, so I fixed it (patch 1/2).=0D
=0D
v1 -> v2:=0D
- reverted the v1 patch, to avoid that replies can appear in the=0D
  packet capture before the transmitted packet [Stefan]=0D
- added patch to fix packet delivering to monitoring devices in=0D
  vhost-vsock=0D
- added patch to check if the packet is already delivered to=0D
  monitoring devices=0D
=0D
v1: https://patchwork.ozlabs.org/project/netdev/patch/20200421092527.41651-=
1-sgarzare@redhat.com/=0D
=0D
Stefano Garzarella (2):=0D
  vhost/vsock: fix packet delivery order to monitoring devices=0D
  vsock/virtio: fix multiple packet delivery to monitoring devices=0D
=0D
 drivers/vhost/vsock.c                   | 16 +++++++++++-----=0D
 include/linux/virtio_vsock.h            |  1 +=0D
 net/vmw_vsock/virtio_transport_common.c |  4 ++++=0D
 3 files changed, 16 insertions(+), 5 deletions(-)=0D
=0D
-- =0D
2.25.3=0D
=0D

