Return-Path: <kvm+bounces-58650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 329E3B9A2E5
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D16F04C49DE
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E06E305962;
	Wed, 24 Sep 2025 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="bfqnXNMV"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A00B305078;
	Wed, 24 Sep 2025 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723147; cv=none; b=VvRXZGikthnw1B7CQBwm885zq7seTqARpMTkbVquHEqB5VV3Mtrw3Ly3zHZksHX0rZyJhltIztQR7FKZg5X1kjeVYIkni6f6YQFOH9Cew24Z/vXr3OoClMvZ6h3L8KYs97A86uYGuByrxUIhsVYCZrpnqIw+PNS4VPwihDMQnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723147; c=relaxed/simple;
	bh=oZKQ4C5nPwEI/MmC2cxUscdgtruN1fXnU1IaTsWCpMU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fm5O9ilm5vaIloFYArZiW027f9KgwT79rOwWzIsbQNaKeKZgnc5O225soDtmDYtXoo5niVSdyrcXo1ZJg0db9J40VQm0eW7nfILOsy6LQ4a+C2yzBOTAFa437IfRlVt+sninW20kk9Lno48YneCfGLO3ie/fQ73jgr1dbrRHnHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=bfqnXNMV; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723145; x=1790259145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dux6/g5MiCozMl06Rtbnr6VbWtIYfhLmT7gxLzOUBI4=;
  b=bfqnXNMV9ILIf7j/o79Da/zAP2aQrlP3ZqF+UO3jBvczvmL8IFOgebSM
   VVt2vT+MWZHJZCCIZJLq7yq5GLaEVAPGKbqEoD64dL6mqb1MBmwkD0VwV
   JwVe5KfCEMZ/aTI4an6IGW1kQ7W4VIhLgstnlygKSVi+d8Qm/V6oUleTv
   ERgn5gv8A0xUTHucbOBd8ClL++H2+TnevI1CNuMB9Bv/E/CETmLgxT5zk
   6XzGR54w04ly4/sQ4cNi81j3w/Nwwg1b3Ct4IG/kbpXcrELD/jsv6EY7q
   2t31o3ATxuELuWDhnbEBfW8bX7AidKeI+OxchmHwH5jAWo57ztb7wc4Tn
   g==;
X-CSE-ConnectionGUID: s/7JeZw0RSqUVXT7izFP4A==
X-CSE-MsgGUID: 5BIFu9IJTXmLVIjTpbN4qQ==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2613315"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:12:14 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:28268]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id df92be04-940c-4b32-b8c2-7f001ca0db47; Wed, 24 Sep 2025 14:12:14 +0000 (UTC)
X-Farcaster-Flow-ID: df92be04-940c-4b32-b8c2-7f001ca0db47
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:12:14 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:12:10 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 4/7] vfio: add FEATURE_ALIAS_REGION uapi
Date: Wed, 24 Sep 2025 16:09:55 +0200
Message-ID: <20250924141018.80202-5-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D038UWB003.ant.amazon.com (10.13.139.157) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a new uapi DEVICE_FEATURE uapi, which allows users to create
region aliases. The main usage is allowing user to request alias
region with different attributes set, Like WC etc.

This could be used create alias for current regions with WC or similar
attributes set. Which is helpful for mmap-ing a region with WC. User
can use PROBE to get the supported flags by the specified region index.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 include/uapi/linux/vfio.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009baf..1584409ba2fb9 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -275,6 +275,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_FLAG_WRITE	(1 << 1) /* Region supports write */
 #define VFIO_REGION_INFO_FLAG_MMAP	(1 << 2) /* Region supports mmap */
 #define VFIO_REGION_INFO_FLAG_CAPS	(1 << 3) /* Info supports caps */
+#define VFIO_REGION_INFO_FLAG_ALIAS	(1 << 4) /* This is an Alias Region */
+#define VFIO_REGION_INFO_FLAG_WC	(1 << 5) /* Region supports write combine */
 	__u32	index;		/* Region index */
 	__u32	cap_offset;	/* Offset within info struct of first cap */
 	__aligned_u64	size;	/* Region size (bytes) */
@@ -1478,6 +1480,28 @@ struct vfio_device_feature_bus_master {
 };
 #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
 
+
+/**
+ * Upon VFIO_DEVICE_FEATURE_SET, creates a new region with the specified flags set.
+ * VFIO_DEVICE_FEATURE_PROBE can be used to return the supported flags for this region.
+ *
+ * Alias a region with certain region flags set. For example this
+ * could be used to alias a region with Write Combine or similar
+ * attributes set for mmap. The new region index is returned on
+ * alias_index with the flags specified set. GET_REGION_INFO could then
+ * be used with the new index. By probing a region index the supported
+ * region flags are returned.
+ * Region flags follows the same flags from REGION_GET_REGION_INFO.
+ */
+struct vfio_device_feature_alias_region {
+	__u32	flags;		/* Region flags to be used */
+	__u32	index;		/* Region index */
+	__u32	alias_index;	/* New region index */
+	__u32	_resv1;
+	__u64	_resv2;
+};
+
+#define VFIO_DEVICE_FEATURE_ALIAS_REGION 11
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


