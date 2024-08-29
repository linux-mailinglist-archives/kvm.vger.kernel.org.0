Return-Path: <kvm+bounces-25385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3093A964B2F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2234B2536C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7451B5319;
	Thu, 29 Aug 2024 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gE7uyWZz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D9E1B3B1D
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948000; cv=none; b=vDp9YV68edrQCO1gB/VszFpnuooYxNM1PcinlHVr3puYchNNy/6GvyWzgt7DSkijxshQY7wd+K32DbLtUACRi/d5/pViN8MKgKkH3mEdd2kmayJ2o3C/QH241C40kJuw6vzxnotGtlSM36e0OCXI4deUUC/MJfOyZ1qvskmmHno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948000; c=relaxed/simple;
	bh=Pby3DcZyp14RhAJleSoL2znXIzFMNtZrCFUDqVhutQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAnO2noaetZ1MwkJPbESST8Y+xITyHTHp97a7MG9gqr/FBc0G68aP0O3j2DTZT2TywwSzRzIGffGJfxFZThFPMUFvurpstlS98PqsMaLUB9NLZoKqi9/rRc/orhMg5AGlT+tUcA0kR8Wiv6xA2aP3s0H8isjnx/zezTS7pQ/ZxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gE7uyWZz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724947998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHimdIgejLVZPp9ejvAk3wHq7yXS/6u29ozuQ5c+vvI=;
	b=gE7uyWZzYn+9TLFfLuOpZ51loR4QOP36kilsKVplKspPHxuhls+ID/bwmHXOR++PJi7XPL
	0yraxVAE0tu/UjyX5IYiGoj2pIyAEZ7IwkS12DOOKcAymheVmBBYzsA9ody5NkLAKSCf8E
	MxHrosn2kS21TaQ8zlKuhAv44WEnNVM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-Dyel0zHIPsOwWpnsL2v1sA-1; Thu,
 29 Aug 2024 12:13:17 -0400
X-MC-Unique: Dyel0zHIPsOwWpnsL2v1sA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BF2F1956048;
	Thu, 29 Aug 2024 16:13:15 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47AE619560AA;
	Thu, 29 Aug 2024 16:13:11 +0000 (UTC)
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
Subject: [RFC PATCH 1/5] vfio_platform: Introduce vfio_platform_get_region helper
Date: Thu, 29 Aug 2024 18:11:05 +0200
Message-ID: <20240829161302.607928-2-eric.auger@redhat.com>
In-Reply-To: <20240829161302.607928-1-eric.auger@redhat.com>
References: <20240829161302.607928-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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


