Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7CFC34B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 10:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfKNJ7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 04:59:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38310 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727302AbfKNJ7A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 04:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XCLo79DoODtOWpB/3GfW2GwOgctYpPrR1VkAEDTZFs=;
        b=PWbiDAuoxEXy/UMtLqtL8bZHNlUBxhyuQCP2YSYHXkmuvjrb5orsD/JKJtVg0sw/IfXiLw
        P7cM/PbcWJ8iGauWXyrDAK2/yY9Q9Ga7d7a9NVc1pDjGCBEb2nqn3txTkcZa8Xwih6VAXa
        I4WO1RxgIgppK48N2U+4bIYrtCKl9EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-ioWvI0r8MXCuxQs-rVil_g-1; Thu, 14 Nov 2019 04:58:56 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A56D2107ACC5;
        Thu, 14 Nov 2019 09:58:53 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A969019757;
        Thu, 14 Nov 2019 09:58:46 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Subject: [PATCH net-next v2 10/15] hv_sock: set VMADDR_CID_HOST in the hvs_remote_addr_init()
Date:   Thu, 14 Nov 2019 10:57:45 +0100
Message-Id: <20191114095750.59106-11-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ioWvI0r8MXCuxQs-rVil_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remote peer is always the host, so we set VMADDR_CID_HOST as
remote CID instead of VMADDR_CID_ANY.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/hyperv_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 7d0a972a1428..22b608805a91 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -188,7 +188,8 @@ static void hvs_remote_addr_init(struct sockaddr_vm *re=
mote,
 =09static u32 host_ephemeral_port =3D MIN_HOST_EPHEMERAL_PORT;
 =09struct sock *sk;
=20
-=09vsock_addr_init(remote, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+=09/* Remote peer is always the host */
+=09vsock_addr_init(remote, VMADDR_CID_HOST, VMADDR_PORT_ANY);
=20
 =09while (1) {
 =09=09/* Wrap around ? */
--=20
2.21.0

