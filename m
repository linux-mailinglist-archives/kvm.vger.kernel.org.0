Return-Path: <kvm+bounces-27209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 671CA97D69E
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 16:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A071AB23845
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 14:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4AF17BB34;
	Fri, 20 Sep 2024 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Zja2MU18"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D93217BB2A
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726841150; cv=none; b=StqoYmZYXk4jdQxb4sXxuQasMMxvmvJLwS4XrIsZ503+4dBRck9XHIzYKDaS2cayTmra80DBJ4dzPjsw6r7+yDj5RIcszvFKdkkJSOdoqUJSXFJx0XEZRBAUHT8VwGRJkp0+LbAzeuWTz4kzfVGblkISS5aMkLBo56SNM++sch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726841150; c=relaxed/simple;
	bh=POW88XPmKTENgNJ3EVcTBnE0Jk1PpJ+8UCz3kvTcyRE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hjvCG+Y40iQuEeT2+B0M/+qF7b0SwkmIK1iT4+snLvOzoPbNEhzpBp8RI1MZdr6UyaIo5m/46WDEehjnaOuAJE+VSnapUwdobRtjRaQG9EIV/Q1s6xrpqau0RSQHKlfH9wNog6jFFZal/ei1oo16wF19ijrwBZCLw9vItaWYbio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Zja2MU18; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48KAO53h016801;
	Fri, 20 Sep 2024 07:05:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=i
	b+qjRjMdio+JPMq4mlyBr3Awe6xrQkt0nrcapFPo3A=; b=Zja2MU18BcLmJda7A
	/Yx5pairp22+EzJH1uoNps4xwKS0sRK3+H5MelQJmhJM/TqVSCmyM8q3Z5T3ukgm
	L7CXa5pbihglPM3Ss9CT/H5ahXg0Jalabj2tMZM113NZukwP/8cRS8CwPNit8l20
	P/UPfzGYXegB8lIJWOWmR3Ll0hzQT1mIJZB2N6Ix5pKPQFOIboNGu5cQVs8CGwvn
	EmlhxBjMXAjtG5Jx4RtCBo8y6cdzeRWWgpar+lOpaHHyKCg3fewFqLaBvZbpKIMP
	rdKbVjfZULhEHL3nRRHwpBp3uFB83LOmoNa1fQ6wWX3nmRjzYXgup23BHFIdyG40
	YEUsQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 41s78rgtgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Sep 2024 07:05:37 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 20 Sep 2024 07:05:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 07:05:37 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 9A51A5B6923;
	Fri, 20 Sep 2024 07:05:34 -0700 (PDT)
From: Srujana Challa <schalla@marvell.com>
To: <virtualization@lists.linux.dev>, <kvm@vger.kernel.org>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <eperezma@redhat.com>,
        <ndabilpuram@marvell.com>, <jerinj@marvell.com>
Subject: [PATCH v2 1/2] vhost-vdpa: introduce module parameter for no-IOMMU mode
Date: Fri, 20 Sep 2024 19:35:29 +0530
Message-ID: <20240920140530.775307-2-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240920140530.775307-1-schalla@marvell.com>
References: <20240920140530.775307-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: upiRO3dIppuFRQylAcwhVKuxuWqC5aIa
X-Proofpoint-GUID: upiRO3dIppuFRQylAcwhVKuxuWqC5aIa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

This commit introduces module parameter
"enable_vhost_vdpa_unsafe_noiommu_mode" to enable an UNSAFE, no-IOMMU
mode in the vhost-vdpa driver. When enabled, this mode provides no
device isolation, no DMA translation, no host kernel protection, and
cannot be used for device assignment to virtual machines.
It requires RAWIO permissions and will taint the kernel.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/vhost/vdpa.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5a49b5a6d496..b3085189ea4a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -36,6 +36,11 @@ enum {
 
 #define VHOST_VDPA_IOTLB_BUCKETS 16
 
+bool vhost_vdpa_noiommu;
+module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
+		   vhost_vdpa_noiommu, bool, 0644);
+MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
+
 struct vhost_vdpa_as {
 	struct hlist_node hash_link;
 	struct vhost_iotlb iotlb;
@@ -60,6 +65,7 @@ struct vhost_vdpa {
 	struct vdpa_iova_range range;
 	u32 batch_asid;
 	bool suspended;
+	bool noiommu_en;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
@@ -910,6 +916,10 @@ static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (v->noiommu_en)
+		return;
+
 	if (ops->dma_map) {
 		ops->dma_unmap(vdpa, asid, map->start, map->size);
 	} else if (ops->set_map == NULL) {
@@ -1003,6 +1013,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	if (r)
 		return r;
 
+	if (v->noiommu_en)
+		goto skip_map;
+
 	if (ops->dma_map) {
 		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
@@ -1018,6 +1031,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 	}
 
+skip_map:
 	if (!vdpa->use_va)
 		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
 
@@ -1321,12 +1335,26 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct device *dma_dev = vdpa_get_dma_dev(vdpa);
+	struct iommu_domain *domain;
 	int ret;
 
 	/* Device want to do DMA by itself */
 	if (ops->set_map || ops->dma_map)
 		return 0;
 
+	domain = iommu_get_domain_for_dev(dma_dev);
+	if (!domain && vhost_vdpa_noiommu) {
+		if (!capable(CAP_SYS_RAWIO)) {
+			dev_warn_once(&v->dev, "No RAWIO permissions, couldn't support NOIOMMU\n");
+			return -ENOTSUPP;
+		}
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+		dev_warn(&v->dev, "Adding kernel taint for noiommu on device\n");
+		v->noiommu_en = true;
+		return 0;
+	}
+	v->noiommu_en = false;
+
 	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
 		dev_warn_once(&v->dev,
 			      "Failed to allocate domain, device is not IOMMU cache coherent capable\n");
-- 
2.25.1


