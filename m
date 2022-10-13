Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1084B5FDD00
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJMPTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiJMPTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:35 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F975112AAA
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:34 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-RI;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 06/10] drivers/vhost: add ioctl to increase the number of workers
Date:   Thu, 13 Oct 2022 18:18:35 +0300
Message-Id: <20221013151839.689700-7-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
References: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Finally add ioctl to allow userspace to create additional workers
For now only allow to increase the number of workers

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c      | 32 +++++++++++++++++++++++++++++++-
 include/uapi/linux/vhost.h |  9 +++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 219ad453ca27..09e3c4b1bd05 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -648,6 +648,25 @@ static int vhost_add_worker(struct vhost_dev *dev)
 	return err;
 }
 
+static int vhost_set_workers(struct vhost_dev *dev, int n)
+{
+	int i, ret;
+
+	if (n > dev->nvqs)
+		n = dev->nvqs;
+
+	if (n > VHOST_MAX_WORKERS)
+		n = VHOST_MAX_WORKERS;
+
+	for (i = 0; i < n - dev->nworkers ; i++) {
+		ret = vhost_add_worker(dev);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
@@ -1821,7 +1840,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 	struct eventfd_ctx *ctx;
 	u64 p;
 	long r;
-	int i, fd;
+	int i, fd, n;
 
 	/* If you are not the owner, you can become one */
 	if (ioctl == VHOST_SET_OWNER) {
@@ -1878,6 +1897,17 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 		if (ctx)
 			eventfd_ctx_put(ctx);
 		break;
+	case VHOST_SET_NWORKERS:
+		r = get_user(n, (int __user *)argp);
+		if (r < 0)
+			break;
+		if (n < d->nworkers) {
+			r = -EINVAL;
+			break;
+		}
+
+		r = vhost_set_workers(d, n);
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 		break;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 56a709e31709..f78cec410460 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -71,6 +71,15 @@
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
 
+/* Set number of vhost workers
+ * Currently nuber of vhost workers can only be increased.
+ * All workers are freed upon reset.
+ * If the value is too big it is silently truncated to the maximum number of
+ * supported vhost workers
+ * Even if the error is returned it is possible that some workers were created
+ */
+#define VHOST_SET_NWORKERS _IOW(VHOST_VIRTIO, 0x1F, int)
+
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
 
-- 
2.31.1

