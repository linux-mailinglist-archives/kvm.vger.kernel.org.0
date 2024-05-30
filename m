Return-Path: <kvm+bounces-18388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2D38D4976
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DB8C1F23E3B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FA1176AC8;
	Thu, 30 May 2024 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RI3cpM8B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C11D183998
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717064327; cv=none; b=s88OOaMpnUcOxaG69HDH8eSEnLvtpgOecmmQGHDmdw3MHfdZ8xQ/LUxytlTHsSlG76Qyg5Q237iqJnKig7Wi8nsnV+6L2azlCrkgWZBs9gX0MFQ+2nL+KVgr/68FSozEDFHZoWNJ3k+qBXE8O/25gvy2YdF7GwzkWBRZ7KneM48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717064327; c=relaxed/simple;
	bh=9VPP4cFzW7OB2wpzRs4cJL1MWhCQUMLbiwnAK8S1ARc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OGDyOFyqiALCA4kBnksD4dCQz5payFMHKb5B2PsfUap/lwd5kbfoGMcMHhYMUsQUpKQixa+W1Wxx2LEI7nJxhU+0nwxzQgVswvFGC4Dv3C4AvzLmbM1ceRQJVI9gaSQXiPSKxRiS2gQr6Y8hAbLd9hiwY37Hr6vJaXBl+irrjBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RI3cpM8B; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44U9aJld026823;
	Thu, 30 May 2024 03:18:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=rI8Lk20/T5VuF13OA+HsAw1
	eU5DkDiqyf3+vvz2FfnA=; b=RI3cpM8BfRfKBdrJYw7cJWsOjDsGrkxbkQEuRWJ
	SFeT19kaXlALNqmXGpjrBUsrCOWg3gn/Wi5LmbekBqR0hTHVNHg+CmW3ca/Oi6uV
	ddjdEsVCLxYZzuN5prEMrR2RskT4YZoqPt5DF52ibzYwtfaTunLS6TABIDOEy1xv
	6vOA7QKBUxS1V0DN9/d73CVe6LIhLMxTvMN3T1bOE0Z5IR7LMoLHuVhtoy6cpy1F
	MV8eWX2XmVKMI+gyxPfIdVebKYQPC+01sGeiQEJr5T5gWB0GnxVtwXd1ziOg1kcu
	Si8FD42LTJxBkUGuY1eCJ3SDNjD9lk+mKAjnb8ZN3FNsDcA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3yegkn1a40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 03:18:41 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 30 May 2024 03:18:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 30 May 2024 03:18:27 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 7B1553F70B7;
	Thu, 30 May 2024 03:18:24 -0700 (PDT)
From: Srujana Challa <schalla@marvell.com>
To: <virtualization@lists.linux.dev>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC: <schalla@marvell.com>, <vattunuru@marvell.com>, <sthotton@marvell.com>,
        <ndabilpuram@marvell.com>, <jerinj@marvell.com>
Subject: [PATCH] vdpa: Add support for no-IOMMU mode
Date: Thu, 30 May 2024 15:48:23 +0530
Message-ID: <20240530101823.1210161-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lWiBYN_zV-f78z6lES96ZvgOLlwnQRH6
X-Proofpoint-GUID: lWiBYN_zV-f78z6lES96ZvgOLlwnQRH6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_07,2024-05-28_01,2024-05-17_01

This commit introduces support for an UNSAFE, no-IOMMU mode in the
vhost-vdpa driver. When enabled, this mode provides no device isolation,
no DMA translation, no host kernel protection, and cannot be used for
device assignment to virtual machines. It requires RAWIO permissions
and will taint the kernel.
This mode requires enabling the "enable_vhost_vdpa_unsafe_noiommu_mode"
option on the vhost-vdpa driver. This mode would be useful to get
better performance on specifice low end machines and can be leveraged
by embedded platforms where applications run in controlled environment.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index bc4a51e4638b..d071c30125aa 100644
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
@@ -887,6 +893,10 @@ static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,
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
@@ -980,6 +990,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	if (r)
 		return r;
 
+	if (v->noiommu_en)
+		goto skip_map;
+
 	if (ops->dma_map) {
 		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
@@ -995,6 +1008,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 	}
 
+skip_map:
 	if (!vdpa->use_va)
 		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
 
@@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct device *dma_dev = vdpa_get_dma_dev(vdpa);
+	struct iommu_domain *domain;
 	const struct bus_type *bus;
 	int ret;
 
@@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	if (ops->set_map || ops->dma_map)
 		return 0;
 
+	domain = iommu_get_domain_for_dev(dma_dev);
+	if ((!domain || domain->type == IOMMU_DOMAIN_IDENTITY) &&
+	    vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+		dev_warn(&v->dev, "Adding kernel taint for noiommu on device\n");
+		v->noiommu_en = true;
+		return 0;
+	}
 	bus = dma_dev->bus;
 	if (!bus)
 		return -EFAULT;
-- 
2.25.1


