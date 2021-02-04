Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60330F996
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhBDRYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:24:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47365 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238434AbhBDRYQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:24:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmOKLaTbJiQKcYt0L7iKZJy+Gn/RMRr8BGTDW6LVgJ8=;
        b=HXA18pspGTbbDiK0DUVUY735rH9piUBFN9M+p/e71ruVFHOLdMtmvIq/ObjtsjDzgW9nIt
        DEksR43iEkMFnxg6rr56Q4l/R1pRw5Ib3Woz6zrZVmepguT6Jdfx1d8oHsbCep2VQ+1QiT
        0LTJh1ATy0VmGMTuOGUwx7zA1I1Kueg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-4CDNnwrLMSiO3nF26848RA-1; Thu, 04 Feb 2021 12:22:48 -0500
X-MC-Unique: 4CDNnwrLMSiO3nF26848RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BD0B8799EB;
        Thu,  4 Feb 2021 17:22:47 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 436A1194A4;
        Thu,  4 Feb 2021 17:22:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 03/13] vringh: reset kiov 'consumed' field in __vringh_iov()
Date:   Thu,  4 Feb 2021 18:22:20 +0100
Message-Id: <20210204172230.85853-4-sgarzare@redhat.com>
In-Reply-To: <20210204172230.85853-1-sgarzare@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vringh_iov() overwrites the contents of riov and wiov, in fact it
resets the 'i' and 'used' fields, but also the 'consumed' field should
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

