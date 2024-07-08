Return-Path: <kvm+bounces-21081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2C0929C74
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 08:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3228D1F215F5
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 06:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2B524B26;
	Mon,  8 Jul 2024 06:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+LJro03"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AB51F94D
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 06:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720421329; cv=none; b=XochVXCmNzHo7o/uj19p5obzNk5+AMqxtzlhlfP2shDZaSaaeWY0Y3uU4L5HmsgSHbaai2Dtg8CmiylLNltIKCMPokvxz2NPJgybOUXX0dCdEBN0XQUiIrUWz5NUP2sv0CLPXA1QWKRqTnpkWOswObCVJOPqxuItRmoVwLi9Xx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720421329; c=relaxed/simple;
	bh=5Xlv1sun4auRtl8JEHcPbgJZ2O7zh44jl7gcdycfm7g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5BDzK6XQqP+yTyCZ+e2bLWSkzHUKAGiTxtioph4H5bINF+J1HawFw/a64JN4VLeY1VdcV5Spm/k1DENUgB29woTyxbLrm7Hsrzm2BTc6iWrEa8AAyyqRkv2ainnUulCLg6aD8hrK7zPN5bV8EYAC2e//HvwoqDrQz444MGd7eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+LJro03; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720421327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i35Vp9MXO/r/LnANvdQMrcfbXgkBl2r0ZfhuxW1lCqE=;
	b=S+LJro03jVV2LEHXVa0dRf7kVA8oRg6rxlaOeuhn7ZPWrKW6ps4fQQ3Uhr1P7N9RRgXok5
	DS1U7TUzGfAYrw5HXWPRO1VGR9enH24P6vpKYtgx5CUGW0KN/Lm/92pUP5Asxdgf6VOt3M
	1BEYtElVJf6WUZoyiCQJcvpNYD39KPY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-7VOu9dqUNc6_-P9BImhytg-1; Mon,
 08 Jul 2024 02:48:44 -0400
X-MC-Unique: 7VOu9dqUNc6_-P9BImhytg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFAD71955F0D;
	Mon,  8 Jul 2024 06:48:42 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.123])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8733619560AE;
	Mon,  8 Jul 2024 06:48:37 +0000 (UTC)
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
Subject: [PATCH v3 2/2] vdpa_sim_net: Add the support of set mac address
Date: Mon,  8 Jul 2024 14:47:03 +0800
Message-ID: <20240708064820.88955-3-lulu@redhat.com>
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

Add the function to support setting the MAC address.
For vdpa_sim_net, the driver will write the MAC address
to the config space, and other devices can implement
their own functions to support this.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index cfe962911804..a472c3c43bfd 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -414,6 +414,22 @@ static void vdpasim_net_get_config(struct vdpasim *vdpasim, void *config)
 	net_config->status = cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LINK_UP);
 }
 
+static int vdpasim_net_set_attr(struct vdpa_mgmt_dev *mdev,
+				struct vdpa_device *dev,
+				const struct vdpa_dev_set_config *config)
+{
+	struct vdpasim *vdpasim = container_of(dev, struct vdpasim, vdpa);
+
+	struct virtio_net_config *vio_config = vdpasim->config;
+	if (config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
+		if (!is_zero_ether_addr(config->net.mac)) {
+			memcpy(vio_config->mac, config->net.mac, ETH_ALEN);
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
 static void vdpasim_net_setup_config(struct vdpasim *vdpasim,
 				     const struct vdpa_dev_set_config *config)
 {
@@ -510,7 +526,8 @@ static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
 
 static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops = {
 	.dev_add = vdpasim_net_dev_add,
-	.dev_del = vdpasim_net_dev_del
+	.dev_del = vdpasim_net_dev_del,
+	.dev_set_attr = vdpasim_net_set_attr
 };
 
 static struct virtio_device_id id_table[] = {
-- 
2.45.0


