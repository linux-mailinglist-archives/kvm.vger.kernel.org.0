Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4416D745E75
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 16:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjGCOXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 10:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjGCOXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 10:23:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA764E52
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 07:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688394166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tXq7CSCBg4+cZGxQq09ZDU/5siBg7EUbmcmgq0dXQ3g=;
        b=aYAQg2Cx97s0fDvb2AvY/T3HeUEaZFrFPjJNRgk2TUwegm8ijHD9iCn0U9R/HQfQVap3lu
        AOqQ8OBuIttqxEspoU2jzG0e1N2OP0DT6XbPnR9q9mJTCU6Yv8MejwULLNSlqAu/T9CzoK
        GF0LeCEOrrrDrlr5yZLWwoWaipi5LDk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-g9FqHmkaM_WYKSeHKKyPcQ-1; Mon, 03 Jul 2023 10:22:42 -0400
X-MC-Unique: g9FqHmkaM_WYKSeHKKyPcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 628983813F2C;
        Mon,  3 Jul 2023 14:22:42 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2D581400C35;
        Mon,  3 Jul 2023 14:22:19 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     mst@redhat.com
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not support it
Date:   Mon,  3 Jul 2023 16:22:18 +0200
Message-Id: <20230703142218.362549-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the current code it is accepted as long as userland send it.

Although userland should not set a feature flag that has not been
offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
complain for it.

Since there is no specific reason for any parent to reject that backend
feature bit when it has been proposed, let's control it at vdpa frontend
level. Future patches may move this control to the parent driver.

Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>

---
Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
commit. Please let me know if I should send a v3 of [1] instead.

[1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
---
 drivers/vhost/vdpa.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e1abf29fed5b..a7e554352351 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 {
 	struct vhost_vdpa *v = filep->private_data;
 	struct vhost_dev *d = &v->vdev;
+	const struct vdpa_config_ops *ops = v->vdpa->config;
 	void __user *argp = (void __user *)arg;
 	u64 __user *featurep = argp;
-	u64 features;
+	u64 features, parent_features = 0;
 	long r = 0;
 
 	if (cmd == VHOST_SET_BACKEND_FEATURES) {
 		if (copy_from_user(&features, featurep, sizeof(features)))
 			return -EFAULT;
+		if (ops->get_backend_features)
+			parent_features = ops->get_backend_features(v->vdpa);
 		if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
 				 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_RESUME) |
-				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
+				 parent_features))
 			return -EOPNOTSUPP;
 		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
 		     !vhost_vdpa_can_suspend(v))
-- 
2.39.3

