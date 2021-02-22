Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6163215B7
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 13:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhBVMFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 07:05:05 -0500
Received: from 88-98-93-30.dsl.in-addr.zen.co.uk ([88.98.93.30]:44242 "EHLO
        sent" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S230101AbhBVMEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 07:04:55 -0500
X-Greylist: delayed 2046 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2021 07:04:55 EST
Received: from jlevon by sent with local (Exim 4.93)
        (envelope-from <john.levon@nutanix.com>)
        id 1lE9PZ-00FW15-Uu; Mon, 22 Feb 2021 11:29:57 +0000
From:   John Levon <john.levon@nutanix.com>
To:     john.levon@nutanix.com
Cc:     jasowang@redhat.com, kvm@vger.kernel.org, levon@movementarian.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH v2] use pr_warn_ratelimited() for vq_err()
Date:   Mon, 22 Feb 2021 11:29:47 +0000
Message-Id: <20210222112947.3697927-1-john.levon@nutanix.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115173741.2628737-1-john.levon@nutanix.com>
References: <20210115173741.2628737-1-john.levon@nutanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vq_err() is used to report various failure states in vhost code, but by
default uses pr_debug(), and as a result doesn't record anything unless
enabled via dynamic debug. We'll change this so we get something recorded
in the log in these failure cases. Guest VMs (and userspace) can trigger
some of these messages, so we want to use the pr_warn_ratelimited()
variant. However, on DEBUG kernels, we'd like to get everything, so we use
pr_warn() then.

Signed-off-by: John Levon <john.levon@nutanix.com>
---
v2: use pr_warn() for DEBUG kernels
---
 drivers/vhost/vhost.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b063324c7669..10007bd49f84 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -228,10 +228,16 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
 void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 			  struct vhost_iotlb_map *map);
 
-#define vq_err(vq, fmt, ...) do {                                  \
-		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
-		if ((vq)->error_ctx)                               \
-				eventfd_signal((vq)->error_ctx, 1);\
+#ifdef DEBUG
+#define vq_pr_warn pr_warn
+#else
+#define vq_pr_warn pr_warn_ratelimited
+#endif
+
+#define vq_err(vq, fmt, ...) do {                                \
+		vq_pr_warn(pr_fmt(fmt), ##__VA_ARGS__);          \
+		if ((vq)->error_ctx)                             \
+			eventfd_signal((vq)->error_ctx, 1);      \
 	} while (0)
 
 enum {
-- 
2.25.1

