Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFC35BECC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfGAOyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 10:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27119 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbfGAOyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 10:54:49 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2062A3082A27;
        Mon,  1 Jul 2019 14:54:49 +0000 (UTC)
Received: from gimli.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 735897E8F7;
        Mon,  1 Jul 2019 14:54:44 +0000 (UTC)
Subject: [PATCH v2] mdev: Send uevents around parent device registration
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kwankhede@nvidia.com, alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 01 Jul 2019 08:54:44 -0600
Message-ID: <156199271955.1646.13321360197612813634.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 01 Jul 2019 14:54:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows udev to trigger rules when a parent device is registered
or unregistered from mdev.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Don't remove the dev_info(), Kirti requested they stay and
    removing them is only tangential to the goal of this change.

 drivers/vfio/mdev/mdev_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index ae23151442cb..7fb268136c62 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 {
 	int ret;
 	struct mdev_parent *parent;
+	char *env_string = "MDEV_STATE=registered";
+	char *envp[] = { env_string, NULL };
 
 	/* check for mandatory ops */
 	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
@@ -197,6 +199,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	mutex_unlock(&parent_list_lock);
 
 	dev_info(dev, "MDEV: Registered\n");
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+
 	return 0;
 
 add_dev_err:
@@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
 void mdev_unregister_device(struct device *dev)
 {
 	struct mdev_parent *parent;
+	char *env_string = "MDEV_STATE=unregistered";
+	char *envp[] = { env_string, NULL };
 
 	mutex_lock(&parent_list_lock);
 	parent = __find_parent_device(dev);
@@ -243,6 +249,8 @@ void mdev_unregister_device(struct device *dev)
 	up_write(&parent->unreg_sem);
 
 	mdev_put_parent(parent);
+
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 EXPORT_SYMBOL(mdev_unregister_device);
 

