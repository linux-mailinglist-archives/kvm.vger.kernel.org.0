Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5E13078A8
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhA1Ovh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:51:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231827AbhA1Onz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:43:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611844949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dMfBbPjDPZ4dIyXQtS0tJU0Oae1keECk1ejt9iIRqJg=;
        b=K3xIJrPl+EiFWyCIoDQuiijp8mdxD4iFqtzs/men9O8zaH3CE7L6AMBzv+/38zbvdTRW8d
        nM0TzikNGGCK+yOc+e7M6N95z8rmHc35JNPkg1CUVBg6SAir9sB2mO3qoGxK+cSWoHy6Eh
        2WSwtXN+10EeYbDITPBRVpuj5aYPiD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-UzL0ZiMJPbiRkiCf77zeAA-1; Thu, 28 Jan 2021 09:42:25 -0500
X-MC-Unique: UzL0ZiMJPbiRkiCf77zeAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA868801B2E;
        Thu, 28 Jan 2021 14:42:23 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-219.ams2.redhat.com [10.36.113.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0F9E19443;
        Thu, 28 Jan 2021 14:42:05 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC v2 04/10] vringh: implement vringh_kiov_advance()
Date:   Thu, 28 Jan 2021 15:41:21 +0100
Message-Id: <20210128144127.113245-5-sgarzare@redhat.com>
In-Reply-To: <20210128144127.113245-1-sgarzare@redhat.com>
References: <20210128144127.113245-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, it may be useful to provide a way to skip a number
of bytes in a vringh_kiov.

Let's implement vringh_kiov_advance() for this purpose, reusing the
code from vringh_iov_xfer().
We replace that code calling the new vringh_kiov_advance().

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vringh.h |  2 ++
 drivers/vhost/vringh.c | 41 +++++++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 9c077863c8f6..755211ebd195 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -199,6 +199,8 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
 	kiov->iov = NULL;
 }
 
+void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
+
 int vringh_getdesc_kern(struct vringh *vrh,
 			struct vringh_kiov *riov,
 			struct vringh_kiov *wiov,
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index bee63d68201a..4d800e4f31ca 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -75,6 +75,34 @@ static inline int __vringh_get_head(const struct vringh *vrh,
 	return head;
 }
 
+/**
+ * vringh_kiov_advance - skip bytes from vring_kiov
+ * @iov: an iov passed to vringh_getdesc_*() (updated as we consume)
+ * @len: the maximum length to advance
+ */
+void vringh_kiov_advance(struct vringh_kiov *iov, size_t len)
+{
+	while (len && iov->i < iov->used) {
+		size_t partlen = min(iov->iov[iov->i].iov_len, len);
+
+		iov->consumed += partlen;
+		iov->iov[iov->i].iov_len -= partlen;
+		iov->iov[iov->i].iov_base += partlen;
+
+		if (!iov->iov[iov->i].iov_len) {
+			/* Fix up old iov element then increment. */
+			iov->iov[iov->i].iov_len = iov->consumed;
+			iov->iov[iov->i].iov_base -= iov->consumed;
+
+			iov->consumed = 0;
+			iov->i++;
+		}
+
+		len -= partlen;
+	}
+}
+EXPORT_SYMBOL(vringh_kiov_advance);
+
 /* Copy some bytes to/from the iovec.  Returns num copied. */
 static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
 				      struct vringh_kiov *iov,
@@ -95,19 +123,8 @@ static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
 		done += partlen;
 		len -= partlen;
 		ptr += partlen;
-		iov->consumed += partlen;
-		iov->iov[iov->i].iov_len -= partlen;
-		iov->iov[iov->i].iov_base += partlen;
 
-		if (!iov->iov[iov->i].iov_len) {
-			/* Fix up old iov element then increment. */
-			iov->iov[iov->i].iov_len = iov->consumed;
-			iov->iov[iov->i].iov_base -= iov->consumed;
-
-			
-			iov->consumed = 0;
-			iov->i++;
-		}
+		vringh_kiov_advance(iov, partlen);
 	}
 	return done;
 }
-- 
2.29.2

