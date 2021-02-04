Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1358130F9B1
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbhBDRZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238115AbhBDRYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUo8I0b7AavPlrPtY5OvFdMytOb4QXrFAY18JZE4vd8=;
        b=bGbFjQzVstzKmynS1kfuZtYUzokjqD4lrkXmlh1EhCF9ZNwgYoXq8CtZd7ip/+k2LSJGUf
        k6mF6UEuXJpITK4lMnWvj06pJLz5FTFWm6H13z8g5AB7fM4YJc7aYAFQ+rkzY9oi/jNOyj
        /Zxg+z838jizJy65UkEUIHj3znKgRXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-eRlPKZeLMvCbkQ8zwhNgmg-1; Thu, 04 Feb 2021 12:23:23 -0500
X-MC-Unique: eRlPKZeLMvCbkQ8zwhNgmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF116100C611;
        Thu,  4 Feb 2021 17:23:21 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B83D460C9B;
        Thu,  4 Feb 2021 17:23:19 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 06/13] vringh: add vringh_kiov_length() helper
Date:   Thu,  4 Feb 2021 18:22:23 +0100
Message-Id: <20210204172230.85853-7-sgarzare@redhat.com>
In-Reply-To: <20210204172230.85853-1-sgarzare@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new helper returns the total number of bytes covered by
a vringh_kiov.

Suggested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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

