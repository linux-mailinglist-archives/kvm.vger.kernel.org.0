Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0848A2F843A
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733084AbhAOSWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:22:11 -0500
Received: from 88-98-93-30.dsl.in-addr.zen.co.uk ([88.98.93.30]:34960 "EHLO
        sent" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733294AbhAOSWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 13:22:09 -0500
X-Greylist: delayed 2553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 13:22:09 EST
Received: from jlevon by sent with local (Exim 4.93)
        (envelope-from <john.levon@nutanix.com>)
        id 1l0T3g-00B1tx-IL; Fri, 15 Jan 2021 17:38:48 +0000
From:   John Levon <john.levon@nutanix.com>
To:     levon@movementarian.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, jasowang@redhat.com, mst@redhat.com
Cc:     John Levon <john.levon@nutanix.com>
Subject: [PATCH] use pr_warn_ratelimited() for vq_err()
Date:   Fri, 15 Jan 2021 17:37:41 +0000
Message-Id: <20210115173741.2628737-1-john.levon@nutanix.com>
X-Mailer: git-send-email 2.25.1
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
variant.

Signed-off-by: John Levon <john.levon@nutanix.com>
---
 drivers/vhost/vhost.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b063324c7669..cb4ef78c84ba 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -228,10 +228,10 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
 void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 			  struct vhost_iotlb_map *map);
 
-#define vq_err(vq, fmt, ...) do {                                  \
-		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
-		if ((vq)->error_ctx)                               \
-				eventfd_signal((vq)->error_ctx, 1);\
+#define vq_err(vq, fmt, ...) do {                                \
+		pr_warn_ratelimited(pr_fmt(fmt), ##__VA_ARGS__); \
+		if ((vq)->error_ctx)                             \
+			eventfd_signal((vq)->error_ctx, 1);      \
 	} while (0)
 
 enum {
-- 
2.25.1

