Return-Path: <kvm+bounces-56710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC05EB42C9A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 184873ABF13
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8B62FF158;
	Wed,  3 Sep 2025 22:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mYPfmVHu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A32ECD31
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937506; cv=fail; b=eyAlo6EdaIX6QIQpvpaz5x1WpzTCorKP8kEPd/mpEBpahNtAdodCAWctpIjk6yJr5Q2GOEPDtUhqBNB77KunKyBXKdOZXFxQcWyPFVekHS9j0fdt8ywuIVKOiK+BpTjo5SQA52+8VnHBoAJVOXbn1qeHdKlVHEe6/Wdd7K5W31k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937506; c=relaxed/simple;
	bh=jPd0N2GQ43S1YzoGNkVGzfnHVhTtaWaGOy8250i2JHM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGr8Ay8sCrTYKuYCl7SQrRc5vcXiIm2307VqIZB44SYLGpL3NFJ+GCJNK756wnhPL7a4DF7bsI/dDilUSPy7y3vWSR8qB3597pIHuM0dhrP7KqP1tG7zKwqqTrVgwwojZFcgruOvFeHMea9Sm0aJDxdNKr3+zsrKnP1ZqlcY8kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mYPfmVHu; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e/TMEvZQQz3cdywMaU6ExrkG6iWlJWkyxCZPWJVIFsNMHdxiyzkQQ7rewop51dzNOyzjNYYTyRjuRKomyQegJVl5yoEHQ9VlKjsuJVQXrS33FH3O/KYm1hUohHFf/HemP3qSl6YJH7z2QQ3y0kQt7KPwLm8kDSa6eMrHLzxx98KFnu7k2n3KnK70Kmse16oO0LBqEc5pWnUTh5FQzjKG2Shcjs1+zWa43dKLURasUAbhTqnQxqlcPaur/ZYBs/m14IUqe+03bnM7dBn4jSqsvG6/OUek2831ongfJ4AW7hXK6abOdWqdfmp1N7qxCfHzl5u7Ze63TVtuwAdXw9kE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFnnbZ50X8LpmTm/Sy5O0WGKB3RIbjvMpqh+NlXw1Ro=;
 b=C2wLvqkMok4AfbwKK0U36pZTsZ1uiQkVlELbfKLN/zPc5X/wDEstIuYSV1Sg8BJIiVEeHMhjghPQM2PjUYyor6oRujwkBikVkhnaGWvS6KNmDPWOHvPKoCt2lXpL6yWEcsXjCs7KYdOjH79sN+/CcXJ+POzILZsKP9MGMnmru10dssNsGh7Y7W9U2je7InYDIpSbpZbupcuVffUhl+Nq1tanR3TGtJAYUEZG0ktOghia5+DNdkyco7lBNmJEF1xivL6Qyj8V8tzUjlR/l87BAZOPvyKK34HkxM2Ds1GyfzBTjIfnfqkjlsTgYBWyYw+XZupu/mmsHsGilB1se2lHxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFnnbZ50X8LpmTm/Sy5O0WGKB3RIbjvMpqh+NlXw1Ro=;
 b=mYPfmVHu+WBRkKUoQ3MgD0IY3plDgvIrnQT9AKflFmskDKAjyLENZaMF+lYGr8ZMWwkCfmVsGC5j0EQCRWkbQgsd8rGZYvGJ09Tu4n1kRa8EIEXyfU7UtJBgFdvMSVA8D1HOkhbg3GuMNs9+zLVYViSAOvJbQO22kfg86OxMvpk+6Ljw1/Q4xEbBFqmMXVJKzM6jfpjA1zIXvaTR5u2zCVYTSYXCiAEgCBrsC7tXVKCgkHS7zk3qqzGwcuv5Ev0ljb4py8gGhkdCVsiC/wXEUdX9GRNXqNxA+y6+28Us+PyMqqwPH5rgH1MaylGuY8us4UD+pOsABIaZiaD7ZS9Ysg==
Received: from BN9PR03CA0481.namprd03.prod.outlook.com (2603:10b6:408:130::6)
 by SN7PR12MB7106.namprd12.prod.outlook.com (2603:10b6:806:2a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Wed, 3 Sep
 2025 22:11:35 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:408:130:cafe::71) by BN9PR03CA0481.outlook.office365.com
 (2603:10b6:408:130::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 22:11:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:15 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:15 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 04/14] vfio/nvidia-vgpu: allocate vGPU channels when creating vGPUs
Date: Wed, 3 Sep 2025 15:11:01 -0700
Message-ID: <20250903221111.3866249-5-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|SN7PR12MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc7add4-3686-4bcf-5c75-08ddeb36d8e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHFGWTRxS2lvazhnandEM0lTREdZdG1WWjN1WFpibkZHYWFveTRkTjZRWmp0?=
 =?utf-8?B?dkd5M1dZQmpJbXRSRk43MG1GYnVNSVJyK3ArYzd3cmZwTEUyZnZaOXB0OHh5?=
 =?utf-8?B?MWFtbXJQNEExc0xBbVh4YzFpTGxrUXNpK1NpKy9jaGZ5NUx5d0lSSHVpNVNp?=
 =?utf-8?B?UUExWDdkTnhPNUVLWlg4U3F5TEFnTGhDR0dLUFpNSUpwYkVHR1Z2cEJwYlF4?=
 =?utf-8?B?UDBiamZCL2dObUpNR1lYVVBxS3R2Umh2UmRYOXhaakNWTFAvSGx1b1cvWUJK?=
 =?utf-8?B?M0k0dUYxZzR5VGtpUW5CeWc1Z0UvUFJlNjNXNXQ2Y3lITmtMdGdhQnNPQUJS?=
 =?utf-8?B?Und4Ylgwb1R0aTE3T1pHZDkwZTlSOGt5N1dnQ0EveG5NWXlCaFA1QkRwb1Vn?=
 =?utf-8?B?clFqSUtaUUlnSXF1elVCSU9qamF0Z2RGTXA3Y1NYNmNZL0NQL1dSRzJwdmZy?=
 =?utf-8?B?L3dWczJnSkhGRWFVY0JnZTFZSHZTelcvUHhEK0l1eWMrRlF2NlJMZUxYdE96?=
 =?utf-8?B?VVRtWnJ2VHBONTd6UCtWRVNHUThVK1UxY1IycHpzdDExS29oSS9yVTQxNkpF?=
 =?utf-8?B?aDRJckNLci94ZzRqQmpxbnlEVDlPRFV3VWxsOFlyazh3eEh4Z1pxTEt6dE1R?=
 =?utf-8?B?ZUd1bVhUQmsvSzVjVHEwa1B6ZEdvR3pFTmNSa2oyc1FzNDVmZWhrQXBvaTNF?=
 =?utf-8?B?dy91NW8wcUJHYjVSUk1hL0RzelVoZXA2c040UTlmYmg4Q3lVSU5HMmlsazAw?=
 =?utf-8?B?VEt5aGlPTmRHZWJYOU44WkI2aU5OYWNhR3FwY25iOGhvKzJQZzRXcVYrenlN?=
 =?utf-8?B?VkZFbTdzRzNEdklFZm05ZlRkWHFUWmtNY3Nmeis5VWVaU2RMSHZ6YkFxUVk1?=
 =?utf-8?B?ZkJZTTJDb0NSUk43NjI4YmVGaFAyNnVHZHVWZEFHQ1dMbjJSNjlMelBqdGtt?=
 =?utf-8?B?aDhMek9ZRmp3RGtzUFVRZlVmY2tsTUQ5eTdEZlFsWmh0NUtpR0VOQXJUdlNy?=
 =?utf-8?B?QloyUUJic0lvS2VkZFlYMGwrVFVDRUcvbHBKYW52Wi9xeWVlazlOdm4wNDlN?=
 =?utf-8?B?a3M0bnAyZmNUM3QvcWtEeTlBdkVIUHlYalVrMERNbGRpZHRzUTdac2hRQVM3?=
 =?utf-8?B?WE1uU0lVUSt4Q1JyeXlua0tLWW9Ua1FRZ1dDQ0NRZi9TU3BsNjNuU0VUNkpp?=
 =?utf-8?B?S1ZZa2FkTWx4ek9yWEZDbUlCbDBGbkI1T3QyY2JvUFJSTlVRM3dnaFFwZFpW?=
 =?utf-8?B?Z3I4MzZZdUVMVmFnQXk4eHZtaG1LeUI0S2FmUSs5M2JJRkYvUG5PQmNTdEMy?=
 =?utf-8?B?ZjBFMmhaelNqTTRVVk4ycFF6dStNSHllaHpKZ0paek5nSTd5VSt0eS9CemNs?=
 =?utf-8?B?SHRVdko3QWhZT3JSRjQreE1TWU85VGdod1FtNEV5NU5qSXZSSExKTFowcHN0?=
 =?utf-8?B?NFltcHpWdTZ6ZTJUelBaaWllTnJ2U3V5SE1CaUdYdGR6eVJiQlMzakh3SVhJ?=
 =?utf-8?B?T0ptMmJUbEhaODBZRDV5UGFqR2lrQnE4dExWMEJSUHNSM1ZhcmRhak40Q3F3?=
 =?utf-8?B?Ym5tRGpFVkNmMkpPMXZhRTZ3K2VTMFpRZklUK0ZESWMwdjdnaVo4em1TMVlS?=
 =?utf-8?B?ektBeUF1ZGxXNUR0Yk4vZzlDMHFVZ2xxWWhCemYvaUl5c043Z3BvdWNxczNq?=
 =?utf-8?B?ZW8zSnhjazNiQ3YrY2ZnWkovenpVT3JPbERUQVlGZDJ4elJmNDdaaXR1Ymhl?=
 =?utf-8?B?dEN1emZPWnZtMENBSmVJcXdrcDdQbElSUmlJSTh2aFpQZ1l2UnRFWUViVWg2?=
 =?utf-8?B?K0JwQlB5eTdlUlROamU4eURtT2l4NnFOZHl3cCt6aE40Ukc5aE91YlgyY2lX?=
 =?utf-8?B?ZmNHaVVncFNKYnk4Ukh6WkhwdkpTMmYzYW5EL1ZCSzFuMGc2eVNENHN5S1k0?=
 =?utf-8?B?cEJMdkU4NlM1UjliYmJRYUVpYTBGQ1RBM291S3hmT3RXdnFnZ2lUYVdmSHpZ?=
 =?utf-8?B?SmF4MmRUNU9vSEZHUnFmeDYrL21Mc2ZTWUtYZE9jbHQ4eUQzM2cway9USUx1?=
 =?utf-8?Q?qc4LUU?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:35.4103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc7add4-3686-4bcf-5c75-08ddeb36d8e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7106

Creating a vGPU requires allocating a portion of the channels from the
reserved channel pool.

Allocate the channels from the reserved channel pool when creating a vGPU.

Cc: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/pf.h       | 10 ++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 76 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c | 33 ++++++++++-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h | 21 +++++++
 4 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index 19f0aca56d12..b8008d8ee434 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -85,4 +85,14 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_rm_ctrl_done(m, g, c) \
 	((m)->handle.ops->rm_ctrl_done(g, c))
 
+#define nvidia_vgpu_mgr_alloc_chids(m, o, s) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->alloc_chids(__m->handle.pf_drvdata, o, s); \
+})
+
+#define nvidia_vgpu_mgr_free_chids(m, o, s) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->free_chids(__m->handle.pf_drvdata, o, s); \
+})
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index cbb51b939f0b..52b946469043 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -3,6 +3,8 @@
  * Copyright © 2025 NVIDIA Corporation
  */
 
+#include <linux/log2.h>
+
 #include "debug.h"
 #include "vgpu_mgr.h"
 
@@ -43,6 +45,70 @@ static int register_vgpu(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static void clean_chids(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_chid *chid = &vgpu->chid;
+
+	vgpu_debug(vgpu, "free guest channel offset %d size %d\n", chid->chid_offset,
+		   chid->num_chid);
+
+	if (vgpu_mgr->use_chid_alloc_bitmap)
+		bitmap_clear(vgpu_mgr->chid_alloc_bitmap, chid->chid_offset, chid->num_chid);
+	else
+		nvidia_vgpu_mgr_free_chids(vgpu_mgr, chid->chid_offset, chid->num_chid);
+}
+
+static inline u32 prev_pow2(const u32 x)
+{
+	return x ? 1U << ilog2(x) : 0;
+}
+
+static void get_alloc_chids_num(struct nvidia_vgpu *vgpu, u32 *size)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_info *info = &vgpu->info;
+	struct nvidia_vgpu_type *type = info->vgpu_type;
+	u32 v;
+
+	/* Calculate with total reserved CHIDs for vGPUs. */
+	v = (vgpu_mgr->total_avail_chids) / type->max_instance;
+	*size = prev_pow2(v);
+}
+
+static int setup_chids(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_chid *chid = &vgpu->chid;
+	u32 size, offset;
+	int ret;
+
+	get_alloc_chids_num(vgpu, &size);
+
+	if (vgpu_mgr->use_chid_alloc_bitmap) {
+		offset = bitmap_find_next_zero_area(vgpu_mgr->chid_alloc_bitmap,
+						    vgpu_mgr->total_avail_chids, 0, size, 0);
+
+		if (offset + size > vgpu_mgr->total_avail_chids)
+			return -ENOSPC;
+
+		bitmap_set(vgpu_mgr->chid_alloc_bitmap, offset, size);
+	} else {
+		ret = nvidia_vgpu_mgr_alloc_chids(vgpu_mgr, &offset, size);
+		if (ret)
+			return ret;
+	}
+
+	chid->chid_offset = offset;
+	chid->num_chid = size;
+	chid->num_plugin_channels = 1;
+
+	vgpu_debug(vgpu, "alloc guest channel offset %u size %u\n", chid->chid_offset,
+		   chid->num_chid);
+
+	return 0;
+}
+
 /**
  * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
  * @vgpu: the vGPU instance going to be destroyed.
@@ -54,6 +120,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	clean_chids(vgpu);
 	unregister_vgpu(vgpu);
 
 	vgpu_debug(vgpu, "destroyed\n");
@@ -93,10 +160,19 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	if (ret)
 		return ret;
 
+	ret = setup_chids(vgpu);
+	if (ret)
+		goto err_setup_chids;
+
 	atomic_set(&vgpu->status, 1);
 
 	vgpu_debug(vgpu, "created\n");
 
 	return 0;
+
+err_setup_chids:
+	unregister_vgpu(vgpu);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_create_vgpu);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index a7f8a00f96bf..8565bb881fda 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -6,6 +6,14 @@
 #include "debug.h"
 #include "vgpu_mgr.h"
 
+static void clean_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	if (vgpu_mgr->use_chid_alloc_bitmap) {
+		bitmap_free(vgpu_mgr->chid_alloc_bitmap);
+		vgpu_mgr->chid_alloc_bitmap = NULL;
+	}
+}
+
 static void vgpu_mgr_release(struct kref *kref)
 {
 	struct nvidia_vgpu_mgr *vgpu_mgr =
@@ -17,6 +25,7 @@ static void vgpu_mgr_release(struct kref *kref)
 		return;
 
 	nvidia_vgpu_mgr_clean_metadata(vgpu_mgr);
+	clean_vgpu_mgr(vgpu_mgr);
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 	kvfree(vgpu_mgr);
 }
@@ -95,6 +104,20 @@ static void attach_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr,
 	handle_data->vfio.pf_detach_handle_fn = pf_detach_handle_fn;
 }
 
+static int setup_chid_alloc_bitmap(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	if (WARN_ON(!vgpu_mgr->use_chid_alloc_bitmap))
+		return 0;
+
+	vgpu_mgr->chid_alloc_bitmap = bitmap_alloc(vgpu_mgr->total_avail_chids, GFP_KERNEL);
+	if (!vgpu_mgr->chid_alloc_bitmap)
+		return -ENOMEM;
+	bitmap_zero(vgpu_mgr->chid_alloc_bitmap, vgpu_mgr->total_avail_chids);
+
+	vgpu_mgr_debug(vgpu_mgr, "using chid allocation bitmap.\n");
+	return 0;
+}
+
 static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
 	vgpu_mgr->total_avail_chids = nvidia_vgpu_mgr_get_avail_chids(vgpu_mgr);
@@ -103,12 +126,17 @@ static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 	vgpu_mgr_debug(vgpu_mgr, "total avail chids %u\n", vgpu_mgr->total_avail_chids);
 	vgpu_mgr_debug(vgpu_mgr, "total fbmem size 0x%llx\n", vgpu_mgr->total_fbmem_size);
 
-	return 0;
+	return vgpu_mgr->use_chid_alloc_bitmap ? setup_chid_alloc_bitmap(vgpu_mgr) : 0;
 }
 
 static int setup_pf_driver_caps(struct nvidia_vgpu_mgr *vgpu_mgr, unsigned long *caps)
 {
-	/* more to come */
+#define HAS_CAP(cap) \
+	test_bit(NVIDIA_VGPU_PF_DRIVER_CAP_HAS_##cap, caps)
+
+	vgpu_mgr->use_chid_alloc_bitmap = !HAS_CAP(CHID_ALLOC);
+
+#undef HAS_CAP
 	return 0;
 }
 
@@ -169,6 +197,7 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 	detach_vgpu_mgr(handle_data);
 	nvidia_vgpu_mgr_clean_metadata(vgpu_mgr);
 fail_setup_metadata:
+	clean_vgpu_mgr(vgpu_mgr);
 fail_init_vgpu_mgr:
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 fail_alloc_gsp_client:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 0519b595378f..5a7a6103a677 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -36,6 +36,19 @@ struct nvidia_vgpu_info {
 	struct nvidia_vgpu_type *vgpu_type;
 };
 
+/**
+ * struct nvidia_vgpu_chid - per-vGPU channel IDs
+ *
+ * @chid_offset: beginning offset of channel IDs
+ * @num_chid: number of allocated channel IDs
+ * @num_plugin_channels: number of channels for vGPU manager
+ */
+struct nvidia_vgpu_chid {
+	u32 chid_offset;
+	u32 num_chid;
+	u32 num_plugin_channels;
+};
+
 /**
  * struct nvidia_vgpu - per-vGPU state
  *
@@ -45,6 +58,7 @@ struct nvidia_vgpu_info {
  * @vgpu_list: list node to the vGPU list
  * @info: vGPU info
  * @vgpu_mgr: pointer to vGPU manager
+ * @chid: vGPU channel IDs
  */
 struct nvidia_vgpu {
 	/* Per-vGPU lock */
@@ -55,6 +69,8 @@ struct nvidia_vgpu {
 
 	struct nvidia_vgpu_info info;
 	struct nvidia_vgpu_mgr *vgpu_mgr;
+
+	struct nvidia_vgpu_chid chid;
 };
 
 /**
@@ -72,6 +88,8 @@ struct nvidia_vgpu {
  * @gsp_client: the GSP client
  * @vgpu_types: installed vGPU types
  * @num_vgpu_types: number of installed vGPU types
+ * @use_alloc_bitmap: use chid allocator for the PF driver doesn't support chid allocation
+ * @chid_alloc_bitmap: chid allocator bitmap
  */
 struct nvidia_vgpu_mgr {
 	struct kref refcount;
@@ -92,6 +110,9 @@ struct nvidia_vgpu_mgr {
 	struct nvidia_vgpu_gsp_client gsp_client;
 	struct nvidia_vgpu_type *vgpu_types;
 	unsigned int num_vgpu_types;
+
+	bool use_chid_alloc_bitmap;
+	void *chid_alloc_bitmap;
 };
 
 #define nvidia_vgpu_mgr_for_each_vgpu(vgpu, vgpu_mgr) \
-- 
2.34.1


