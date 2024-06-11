Return-Path: <kvm+bounces-19295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6C4903148
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 07:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED964B21C09
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 05:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34150173356;
	Tue, 11 Jun 2024 05:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcV0T09R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2793173343
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 05:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083990; cv=none; b=dmw7UiWu/xXm641lFFlWkgRzZU+YNx11/7GvbrC/3ewqXwQuRdvQiyHMXq4WVJdzrN1T2TLBIIo3IqxKD0BJL0Rh1JeyF3VxZrFDhNdYga2a1uq357X6MmTCgCLALsdS/Dxeb53WlmecpHZxhcgi5UVyggGJu77/FinTGpyhb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083990; c=relaxed/simple;
	bh=8meoOHH2u4J9pIl45EG/aglfIRMGEcJWPK7180fCoiY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmgRyudtBZ+NfJAE8rDrpSSEmfg9SU8O2LMIntfQdDURNY7vaJNcx07/Q9yOzOO3d1DnhfK8d4/AZ19WXg1tF7buBb63WSV2nYf9pnyWz8yMJsC+oFLimlGRkxSFTH9llZUWUNd0LkHY25vMRGqCNFVSVSUCpanp21+cii9+6iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VcV0T09R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718083987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SVGIwSDAhOOGKWQlWioglXyQduZq6q0YAfjnb7x8qA=;
	b=VcV0T09RS/M07VdYEzLsjkmh0xQYqiBRfwcgT8Jv0EmDFyRwlf8i2DebpD1Xu9OQrDZWuc
	6LMAMggyvkS5XugNXgMDtk/irTxvXTKlemSM0YocFVvSvpF5mkcugsF/mbW27ZQEUGTL4U
	16GPqldtUbrMnJ/ApkTGBm6Aw3w8udA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-cuzI-JmTP9KSuAHrN3CMrg-1; Tue,
 11 Jun 2024 01:32:55 -0400
X-MC-Unique: cuzI-JmTP9KSuAHrN3CMrg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5239C1956087;
	Tue, 11 Jun 2024 05:32:54 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.77])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B055B1956048;
	Tue, 11 Jun 2024 05:32:49 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 2/2] vdpa_sim_net: Add the support of set mac address
Date: Tue, 11 Jun 2024 13:32:33 +0800
Message-ID: <20240611053239.516996-2-lulu@redhat.com>
In-Reply-To: <20240611053239.516996-1-lulu@redhat.com>
References: <20240611053239.516996-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add the function to support setting the MAC address.
For vdpa_sim_net, the driver will write the MAC address
to the config space, and other devices can implement
their own functions to support this.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index cfe962911804..e961a08341c2 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -414,6 +414,21 @@ static void vdpasim_net_get_config(struct vdpasim *vdpasim, void *config)
 	net_config->status = cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LINK_UP);
 }
 
+static int vdpasim_net_set_mac(struct vdpa_mgmt_dev *mdev,
+			       struct vdpa_device *dev,
+			       const struct vdpa_dev_set_config *config)
+{
+	struct vdpasim *vdpasim = container_of(dev, struct vdpasim, vdpa);
+
+	struct virtio_net_config *vio_config = vdpasim->config;
+
+	if (config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
+		memcpy(vio_config->mac, config->net.mac, ETH_ALEN);
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static void vdpasim_net_setup_config(struct vdpasim *vdpasim,
 				     const struct vdpa_dev_set_config *config)
 {
@@ -510,7 +525,8 @@ static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
 
 static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops = {
 	.dev_add = vdpasim_net_dev_add,
-	.dev_del = vdpasim_net_dev_del
+	.dev_del = vdpasim_net_dev_del,
+	.set_mac = vdpasim_net_set_mac
 };
 
 static struct virtio_device_id id_table[] = {
-- 
2.45.0


