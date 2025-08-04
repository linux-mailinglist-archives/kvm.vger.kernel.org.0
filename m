Return-Path: <kvm+bounces-53902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63254B19FE3
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F56816DB68
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E125A24E01F;
	Mon,  4 Aug 2025 10:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="sNhY8nYG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE3238C08
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304238; cv=none; b=A/D7YY/r9bV08GiyhpbgPDlQfMeUn8ErPxH1y0Rz0EKIBYFwaDpoCnl9eifngebRhBRETSYR5HAf6Y+Z44m1UCxRL1wcudslEdNy40OWRi6y3qDjywqLiwcz17oA5w7UsFzqBx013OfsgpdknUdpSCwOXXlDPvAoMsOK2+Xoz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304238; c=relaxed/simple;
	bh=6V4kpaBdmXlfGXOWn1PHDCVrHZmSy//Oz8PMXertoMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbLz28PPmZfLn1K2tt00Mv7lwXgy2N6WzlBle2cyG70DfkkU2tnqA0Nkvpf1+1Itwnzu5efa1fPLsYxyGPL7XL639RXVO7bRAnkQ8RwM5NF+H+E9JwxwQZFz+/lbPm+lNR5FrXbTQ5pwmMI4v4Y1bGcLdI5CvJIGLHgAxPX9ruE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=sNhY8nYG; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304237; x=1785840237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n99zAO1jN5ZnMXlDd1znZsc7arKdZgvoiOo/ni9nF2U=;
  b=sNhY8nYGgxVfR+0OAgR0GatFb53ILzb75ea8L9sfI35bJcObLf7AbN+l
   va2Osmrm70I2qDXVC1fGQuFo/iIOO5iUCssZvYZt5DJCoh+KBjMgA4xRh
   zPurSo7GSGCZug7Y/yuFHuQuncpUVZ9wIAMguGhvr8r9USDHe2r9iVyJe
   Xngq4TFUd46+IQa9uNMgnSP7y+tl+VPxEZiyv/SzAVIqae4wREJSOM8RT
   0u0JFy9uhZPEHVyYnlMCT7QIznucQ+2N8qeM0jP4qfFYEZzLfgENu9Tyj
   XSVn+04zlCV6J6AKVWy/XT2AXkJtILTm/JROl2ywZqlVSW/0JazpV2b3k
   Q==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="520019907"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:43:54 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:40997]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.198:2525] with esmtp (Farcaster)
 id 76fbe72b-2915-4b6a-9701-2a1a0d548080; Mon, 4 Aug 2025 10:43:53 +0000 (UTC)
X-Farcaster-Flow-ID: 76fbe72b-2915-4b6a-9701-2a1a0d548080
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:43:53 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:43:50 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 8/9] vfio: UAPI for setting mmap attributes
Date: Mon, 4 Aug 2025 12:40:01 +0200
Message-ID: <20250804104012.87915-9-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWB001.ant.amazon.com (10.13.138.123) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This uapi allows setting mmap attributes using a specified region
offset, region offset is expected to be used from returned value of
VFIO_DEVICE_GET_REGION_INFO or similar, where vmmap mt entry was
created, start with write_combine attribute, which the user can use to
request mmap to use wc. vfio devices expected to load the vmmap entry
from mt and do the needed region specific checks, and sets the
attributes accordingly.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/vfio_main.c  |  1 +
 include/linux/vfio.h      |  1 +
 include/uapi/linux/vfio.h | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3275ff56eef47..58c3cf12a5317 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -633,6 +633,7 @@ void vfio_mmap_init(struct vfio_device *vdev, struct vfio_mmap *vmmap,
 	vmmap->ops = ops;
 	vmmap->size = size;
 	vmmap->region_flags = region_flags;
+	vmmap->attrs = 0;
 }
 EXPORT_SYMBOL_GPL(vfio_mmap_init);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 836ef72a38104..5885df1729183 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -85,6 +85,7 @@ struct vfio_mmap {
 	u64 offset;
 	u64 size;
 	u32 region_flags;
+	u32 attrs;
 	struct vfio_mmap_ops *ops;
 };
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5764f315137f9..2e3fa90eef5a3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1831,6 +1831,25 @@ struct vfio_iommu_spapr_tce_remove {
 };
 #define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
 
+/**
+ * VFIO_DEVICE_SET_MMAP_ATTRS  - _IOW(VFIO_TYPE, VFIO_BASE + 21, struct vfio_mmap_attrs)
+ *
+ * Set memory mapping attributes for a specified region offset before
+ * calling mmap, it expects that the offset used was fetched by
+ * calling VFIO_DEVICE_GET_REGION_INFO.
+ *
+ * Attributes supported:
+ * - VFIO_MMAP_ATTR_WRITE_COMBINE: use write-combine when requested to mmap this offset.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_mmap_attrs {
+	__u64	offset;	/* Region offset */
+	__u32	attrs;
+#define VFIO_MMAP_ATTR_WRITE_COMBINE	(1 << 0)
+};
+#define VFIO_DEVICE_SET_MMAP_ATTRS	_IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /* ***************************************************************** */
 
 #endif /* _UAPIVFIO_H */
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


