Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4D307871
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhA1OoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231859AbhA1On7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:43:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611844953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GX3yzMGQ3b9tW8KNSpNTjKrt3+i1m/42zdPvkaXw/ns=;
        b=YQQkZWk8TggJb7ujbrne/oyZAjG2SQu/tmOXkRsYesSlEjX+wNf2razfKLK8GvUIlpE/Zp
        JCgdeZsyAf1JweG6Qi/Kr47Q/cDpeVck53yKH5FmHh+X7ZUYMX5ElYvK2gjW8rt8QUgC0H
        pvg746YfY3qWEEuu3hOwlB9V36loZZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-rEt7-J4-OkOT7O3gJRvBUg-1; Thu, 28 Jan 2021 09:42:30 -0500
X-MC-Unique: rEt7-J4-OkOT7O3gJRvBUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 737C6107ACE8;
        Thu, 28 Jan 2021 14:42:29 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-219.ams2.redhat.com [10.36.113.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2869F18642;
        Thu, 28 Jan 2021 14:42:23 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC v2 05/10] vringh: add vringh_kiov_length() helper
Date:   Thu, 28 Jan 2021 15:41:22 +0100
Message-Id: <20210128144127.113245-6-sgarzare@redhat.com>
In-Reply-To: <20210128144127.113245-1-sgarzare@redhat.com>
References: <20210128144127.113245-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new helper returns the total number of bytes covered by
a vringh_kiov.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vringh.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 755211ebd195..84db7b8f912f 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -199,6 +199,17 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
 	kiov->iov = NULL;
 }
 
+static inline size_t vringh_kiov_length(struct vringh_kiov *kiov)
+{
+	size_t len = 0;
+	int i;
+
+	for (i = kiov->i; i < kiov->used; i++)
+		len += kiov->iov[i].iov_len;
+
+	return len;
+}
+
 void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
 
 int vringh_getdesc_kern(struct vringh *vrh,
-- 
2.29.2

