Return-Path: <kvm+bounces-27034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFE497AE15
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0FB5B28BFD
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE591662E8;
	Tue, 17 Sep 2024 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eew8mu/B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC8015CD6E
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565951; cv=none; b=CZDCtkXETCMMN5VsObOijgd0iLkMHeWRmDXKG2tAJJBBx7yuu/+HZpBqRSXkiAqpIFi2c/xeE5WYMr08TNQOfIyKSQZEYIEc++elQNK9bf/BPMMh9s3VCGtso8u6EjdnrDWZa2WqmnUj6cy1kKYzZhFQKpzkL95PtkCgPZvQuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565951; c=relaxed/simple;
	bh=Pby3DcZyp14RhAJleSoL2znXIzFMNtZrCFUDqVhutQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7lfDzfSeiug78+xMeMKVNeAw4ZCpOH41S+auEuxJSva986VRFV8+cjmgmudMW/OELHDd9Cyy51K3eoD/AUMUmg2IYc1ka3QKYikPma40/DU38EunlFOkM7s+b5on6Nj6nTOSvxSSJqwyQDisAmjSA1My23IhZAbHfTZIh5SH4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eew8mu/B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726565948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHimdIgejLVZPp9ejvAk3wHq7yXS/6u29ozuQ5c+vvI=;
	b=Eew8mu/BGMJ1hQs/nJK5rQHNiTKpWzIlr3LsolEc7CKLV6l9Gc9Ii8oxillSBpr1aL24bD
	iVhhIFLbkMm0OVtgAhoC5UlyLEeYj63jIshprKKJ8+riaDPC0dvW7S3ImSUWGxSYYsvCqf
	xiuQAGppB2P2jKqWDVrohVALCnikB/8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-zglMNBjjNEK0ORYMx6jSjw-1; Tue,
 17 Sep 2024 05:39:05 -0400
X-MC-Unique: zglMNBjjNEK0ORYMx6jSjw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C12C1955D4A;
	Tue, 17 Sep 2024 09:39:03 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5B7530001A1;
	Tue, 17 Sep 2024 09:38:58 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	jonathanh@nvidia.com,
	mperttunen@nvidia.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	clg@redhat.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com
Cc: msalter@redhat.com
Subject: [RFC PATCH v2 1/6] vfio_platform: Introduce vfio_platform_get_region helper
Date: Tue, 17 Sep 2024 11:38:09 +0200
Message-ID: <20240917093851.990344-2-eric.auger@redhat.com>
In-Reply-To: <20240917093851.990344-1-eric.auger@redhat.com>
References: <20240917093851.990344-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reset modules need to access some specific regions. It may
easier and safer to refer to those regions using their
name instead of relying on their index.

So let's introduce a helper that looks for the
struct vfio_platform_region with a given name.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

I don't know if reg names described in binding yaml are guaranteed to
appear in the listed order. I guess no, hence the reg-names.
In my case, for the host tegra234 dt node, regs I even observe regs that
are not documented in the yaml:
mac, xpcs, macsec-base, hypervisor whereas yaml only describes
hypervisor, mac, xpcs
---
 drivers/vfio/platform/vfio_platform_common.c  | 14 ++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index e53757d1d095..6861f977fd5b 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -153,6 +153,7 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 		vdev->regions[i].addr = res->start;
 		vdev->regions[i].size = resource_size(res);
 		vdev->regions[i].flags = 0;
+		vdev->regions[i].name = res->name;
 
 		switch (resource_type(res)) {
 		case IORESOURCE_MEM:
@@ -188,6 +189,19 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 	return -EINVAL;
 }
 
+struct vfio_platform_region*
+vfio_platform_get_region(struct vfio_platform_device *vdev, const char *name)
+{
+	int i;
+
+	for (i = 0; i < vdev->num_regions; i++) {
+		if (!strcmp(vdev->regions[i].name, name))
+			return &vdev->regions[i];
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_get_region);
+
 static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
 {
 	int i;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 8d8fab516849..20d67634bc41 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -37,6 +37,7 @@ struct vfio_platform_region {
 	resource_size_t		size;
 	u32			flags;
 	u32			type;
+	const char		*name;
 #define VFIO_PLATFORM_REGION_TYPE_MMIO	1
 #define VFIO_PLATFORM_REGION_TYPE_PIO	2
 	void __iomem		*ioaddr;
@@ -104,6 +105,10 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
 void vfio_platform_unregister_reset(const char *compat,
 				    vfio_platform_reset_fn_t fn);
+
+struct vfio_platform_region *
+vfio_platform_get_region(struct vfio_platform_device *vdev, const char *name);
+
 #define vfio_platform_register_reset(__compat, __reset)		\
 static struct vfio_platform_reset_node __reset ## _node = {	\
 	.owner = THIS_MODULE,					\
-- 
2.41.0


