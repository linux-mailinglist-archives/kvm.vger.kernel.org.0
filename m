Return-Path: <kvm+bounces-21080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8209B929C6E
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 08:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02FA91F21425
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 06:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169BC17C66;
	Mon,  8 Jul 2024 06:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDZu266J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EAC1CD23
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 06:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720421325; cv=none; b=EDGPZGk1bqWa6rkGln9u6L4antX/27UmcuMcYhKk6G+SfmnSI8U/D0UHqTNOJZHccctzVG58FzJh8tVaW1WwPaSBkkegkwYiXmKp8PKEpGgXc/JyWZ47jyhu02SYsbOuI14mxiU5TL08aDO/ueRGORDC0GBHTi/dNdwor0tFvow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720421325; c=relaxed/simple;
	bh=AoLMdehBkes1d6GgeEPiJFOpZ18AaXk7Y4RkM+T4E8E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDKxwogTGuzi2L3+8HxyQDI9Hb2tBvzC4hHABDjtoUNjFCnHd0t58t5gGDZlZButK4jWrIu6+HT97tLtfB1gq/abw0G9uzfY3K+Jn/5NNRh039AaoNsODGL+8jwNvbr7c0y3wiY8UL8Jhsk9zXuWyzj31sDeopo9yr+dT4GYdJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDZu266J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720421322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ka5voMkLnXCnTu0/ZE9TEICzmrDDtAGJgajnDyqsx3I=;
	b=gDZu266JsMUPznNlhzBjAns3rRMFY0PoT3MEvxaitlnGeHkiDEXDUufRiXo1Q4m0gYv7jQ
	k1fNknLcS3nmK4da76+OJuxzZxLSHlNS0FWM6UlR2sBMiyjHxBboJRpEdO75D5+MFqNqF8
	hf63fH0HBomTa79rnSEmVDwBVvVVGOE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-sTrY2VPaNVC86PssDVMz0A-1; Mon,
 08 Jul 2024 02:48:38 -0400
X-MC-Unique: sTrY2VPaNVC86PssDVMz0A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF379195609E;
	Mon,  8 Jul 2024 06:48:36 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.123])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A281D19560AE;
	Mon,  8 Jul 2024 06:48:31 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	parav@nvidia.com,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 1/2] vdpa: support set mac address from vdpa tool
Date: Mon,  8 Jul 2024 14:47:02 +0800
Message-ID: <20240708064820.88955-2-lulu@redhat.com>
In-Reply-To: <20240708064820.88955-1-lulu@redhat.com>
References: <20240708064820.88955-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add new UAPI to support the mac address from vdpa tool
Function vdpa_nl_cmd_dev_attr_set_doit() will get the
new MAC address from the vdpa tool and then set it to the device.

The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**

Here is example:
root@L1# vdpa -jp dev config show vdpa0
{
    "config": {
        "vdpa0": {
            "mac": "82:4d:e9:5d:d7:e6",
            "link ": "up",
            "link_announce ": false,
            "mtu": 1500
        }
    }
}

root@L1# vdpa dev set name vdpa0 mac 00:11:22:33:44:55

root@L1# vdpa -jp dev config show vdpa0
{
    "config": {
        "vdpa0": {
            "mac": "00:11:22:33:44:55",
            "link ": "up",
            "link_announce ": false,
            "mtu": 1500
        }
    }
}

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa.c       | 81 +++++++++++++++++++++++++++++++++++++++
 include/linux/vdpa.h      |  9 +++++
 include/uapi/linux/vdpa.h |  1 +
 3 files changed, 91 insertions(+)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index a7612e0783b3..ca97ad43e1bd 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1149,6 +1149,82 @@ static int vdpa_nl_cmd_dev_config_get_doit(struct sk_buff *skb, struct genl_info
 	return err;
 }
 
+static int vdpa_dev_net_device_attr_set(struct vdpa_device *vdev,
+					struct genl_info *info)
+{
+	struct vdpa_dev_set_config set_config = {};
+	const u8 *macaddr;
+	struct vdpa_mgmt_dev *mdev = vdev->mdev;
+	struct nlattr **nl_attrs = info->attrs;
+	int err;
+
+	if (!vdev->mdev)
+		return -EINVAL;
+
+	down_write(&vdev->cf_lock);
+	if ((mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC)) &&
+	    nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
+		set_config.mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
+		macaddr = nla_data(nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]);
+		memcpy(set_config.net.mac, macaddr, ETH_ALEN);
+
+		if (mdev->ops->dev_set_attr) {
+			err = mdev->ops->dev_set_attr(mdev, vdev, &set_config);
+		} else {
+			NL_SET_ERR_MSG_FMT_MOD(info->extack,
+					       "features 0x%llx not supported",
+					       BIT_ULL(VIRTIO_NET_F_MAC));
+			err = -EINVAL;
+		}
+	}
+	up_write(&vdev->cf_lock);
+
+	return err;
+}
+static int vdpa_nl_cmd_dev_attr_set_doit(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	const char *name;
+	int err = 0;
+	struct device *dev;
+	struct vdpa_device *vdev;
+	u64 classes;
+
+	if (!info->attrs[VDPA_ATTR_DEV_NAME])
+		return -EINVAL;
+
+	name = nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
+
+	down_write(&vdpa_dev_lock);
+	dev = bus_find_device(&vdpa_bus, NULL, name, vdpa_name_match);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(info->extack, "device not found");
+		err = -ENODEV;
+		goto dev_err;
+	}
+	vdev = container_of(dev, struct vdpa_device, dev);
+	if (!vdev->mdev) {
+		NL_SET_ERR_MSG_MOD(
+			info->extack,
+			"Fail to find the specified management device");
+		err = -EINVAL;
+		goto mdev_err;
+	}
+	classes = vdpa_mgmtdev_get_classes(vdev->mdev, NULL);
+	if (classes & BIT_ULL(VIRTIO_ID_NET)) {
+		err = vdpa_dev_net_device_attr_set(vdev, info);
+	} else {
+		NL_SET_ERR_MSG_FMT_MOD(info->extack, "%s device not supported",
+				       name);
+	}
+
+mdev_err:
+	put_device(dev);
+dev_err:
+	up_write(&vdpa_dev_lock);
+	return err;
+}
+
 static int vdpa_dev_config_dump(struct device *dev, void *data)
 {
 	struct vdpa_device *vdev = container_of(dev, struct vdpa_device, dev);
@@ -1285,6 +1361,11 @@ static const struct genl_ops vdpa_nl_ops[] = {
 		.doit = vdpa_nl_cmd_dev_stats_get_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = VDPA_CMD_DEV_ATTR_SET,
+		.doit = vdpa_nl_cmd_dev_attr_set_doit,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family vdpa_nl_family __ro_after_init = {
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index db15ac07f8a6..14afa6d59098 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -576,11 +576,20 @@ void vdpa_set_status(struct vdpa_device *vdev, u8 status);
  *	     @dev: vdpa device to remove
  *	     Driver need to remove the specified device by calling
  *	     _vdpa_unregister_device().
+  * @dev_set_attr: change a vdpa device's attr after it was create
+ *	     @mdev: parent device to use for device
+ *	     @dev: vdpa device structure
+ *	     @config:Attributes to be set for the device.
+ *	     The driver needs to check the mask of the structure and then set
+ *	     the related information to the vdpa device. The driver must return 0
+ *	     if set successfully.
  */
 struct vdpa_mgmtdev_ops {
 	int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name,
 		       const struct vdpa_dev_set_config *config);
 	void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
+	int (*dev_set_attr)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev,
+			    const struct vdpa_dev_set_config *config);
 };
 
 /**
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 54b649ab0f22..76b3a1fd13f3 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -19,6 +19,7 @@ enum vdpa_command {
 	VDPA_CMD_DEV_GET,		/* can dump */
 	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
 	VDPA_CMD_DEV_VSTATS_GET,
+	VDPA_CMD_DEV_ATTR_SET,
 };
 
 enum vdpa_attr {
-- 
2.45.0


