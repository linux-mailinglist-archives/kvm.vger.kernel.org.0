Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C8D30786D
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhA1Onq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:43:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhA1OnN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611844907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vra/8R9BJFPpbB1vr+cBu428jEwk9zi9qo7gpPVDYWY=;
        b=N+sKNSyFt6kjNLZ8S3xALs1G/ztpELyI34RkVsADtwTY9LyIOiLwisqpdhFPJ1m55OMOGa
        xBk4kS4CBjvSCU1v7bUgUi3Nd17FVYZEyBWigrh6VXEBG/En5U3tXAmVC0emzszf0V3+C2
        bh10ZUu0O08W4vF73mThwrKj3J3aIJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-91Ui66JCMViZtffPQ_YwDg-1; Thu, 28 Jan 2021 09:41:45 -0500
X-MC-Unique: 91Ui66JCMViZtffPQ_YwDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7606410054FF;
        Thu, 28 Jan 2021 14:41:44 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-219.ams2.redhat.com [10.36.113.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F39F060CF1;
        Thu, 28 Jan 2021 14:41:41 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC v2 03/10] vringh: reset kiov 'consumed' field in __vringh_iov()
Date:   Thu, 28 Jan 2021 15:41:20 +0100
Message-Id: <20210128144127.113245-4-sgarzare@redhat.com>
In-Reply-To: <20210128144127.113245-1-sgarzare@redhat.com>
References: <20210128144127.113245-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vringh_iov() overwrites the contents of riov and wiov, in fact it
resets the 'i' and 'used' fields, but also the consumed field should
be reset to avoid an inconsistent state.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index f68122705719..bee63d68201a 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -290,9 +290,9 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		return -EINVAL;
 
 	if (riov)
-		riov->i = riov->used = 0;
+		riov->i = riov->used = riov->consumed = 0;
 	if (wiov)
-		wiov->i = wiov->used = 0;
+		wiov->i = wiov->used = wiov->consumed = 0;
 
 	for (;;) {
 		void *addr;
-- 
2.29.2

