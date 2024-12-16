Return-Path: <kvm+bounces-33854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A4B9F2D99
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 11:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73D78161C65
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 10:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75132036E5;
	Mon, 16 Dec 2024 09:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="iQcW2qtH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C30202C26
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734343192; cv=none; b=agWw15Wlb01cmBNHc4KBl20fHe9p08e2Nd2zzuA7CMNT6yBs46c9Tpwd4wUmDWeWFZxF/r0Xm7oqOcgLYh9XO6iaZ6NQ0giOP47DdddZN2wnKpV0c5sr8tzkUsP/Fu594YjKwG+QkC/iQpho9EG/GapDE5jP7Zl3oikjNAllS4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734343192; c=relaxed/simple;
	bh=5P1uqXyO4EerMfJMg5b6+ZEycfMz4MOJsVkFcXjJvCw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdPOl7JQZDot9VpMeQcwPHOqdCLYzya3sn2SQ1jIyvNp0JWHKVBtY3+S/792Ucn6B6joUI8Wa9XbQR+CizExLd9zO/LaXgT3fKAfav+BrCzdNwUbzemO0H0V3L8/atR5E4+9Cv5afqOlZ1oyup1wb0xlFpJ5jxBoCMZ6/yLhg+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=iQcW2qtH; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BG7vNCQ000407
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 01:59:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=X
	F5WtkBONmd+8r9yLmklM/sXmsTbxQzH7Qh2X2Sk4Zo=; b=iQcW2qtHMLJ/fH7Dn
	QLQlIMCfpgE3LFX5gdTeBwzUmcVUKiLQ/Z2PFQo6W+iiA+lnNuW6HAoK9dxOhxrV
	VIrl24J9lGGEBL84/L24xI1lCL6jp86mYmZIGfGqLz+v+bQ6k2sxkl8E6pCPysHC
	npQrXcJIcsQZGXQHvwVPWpAIwk=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43jg8pgje7-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 01:59:49 -0800 (PST)
Received: from twshared18153.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 16 Dec 2024 09:59:34 +0000
Received: by devvm12370.nha0.facebook.com (Postfix, from userid 624418)
	id 93F1210A1F70A; Mon, 16 Dec 2024 01:59:28 -0800 (PST)
From: Wei Lin Guay <wguay@fb.com>
To: <alex.williamson@redhat.com>, <dri-devel@lists.freedesktop.org>,
        <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC: <jgg@nvidia.com>, <vivek.kasireddy@intel.com>, <dagmoxnes@meta.com>,
        <kbusch@kernel.org>, <nviljoen@meta.com>,
        Wei Lin Guay <wguay@meta.com>
Subject: [PATCH 2/4] dma-buf: Add dma_buf_try_get()
Date: Mon, 16 Dec 2024 01:59:16 -0800
Message-ID: <20241216095920.237117-3-wguay@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241216095920.237117-1-wguay@fb.com>
References: <20241216095920.237117-1-wguay@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: dBVamL5q8cEYZV-kk_inwAYXRW27L99Z
X-Proofpoint-ORIG-GUID: dBVamL5q8cEYZV-kk_inwAYXRW27L99Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Jason Gunthorpe <jgg@nvidia.com>

Summary:
Used to increment the refcount of the dma buf's struct file, only if the
refcount is not zero. Useful to allow the struct file's lifetime to
control the lifetime of the dmabuf while still letting the driver to keep
track of created dmabufs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Wei Lin Guay <wguay@meta.com>
Reviewed-by: Dag Moxnes <dagmoxnes@meta.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Nic Viljoen <nviljoen@meta.com>
---
 include/linux/dma-buf.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 36216d28d8bd..9854578afecd 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -614,6 +614,19 @@ int dma_buf_fd(struct dma_buf *dmabuf, int flags);
 struct dma_buf *dma_buf_get(int fd);
 void dma_buf_put(struct dma_buf *dmabuf);

+/**
+ * dma_buf_try_get - try to get a reference on a dmabuf
+ * @dmabuf - the dmabuf to get
+ *
+ * Returns true if a reference was successfully obtained. The caller mus=
t
+ * interlock with the dmabuf's release function in some way, such as RCU=
, to
+ * ensure that this is not called on freed memory.
+ */
+static inline bool dma_buf_try_get(struct dma_buf *dmabuf)
+{
+	return get_file_rcu(&dmabuf->file);
+}
+
 struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_tab=
le *,
--
2.43.5

