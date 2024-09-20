Return-Path: <kvm+bounces-27221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6971597DA92
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1D41282733
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F6218CC1D;
	Fri, 20 Sep 2024 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RWSLPszL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868F178383;
	Fri, 20 Sep 2024 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871714; cv=fail; b=fPp8GUjCzUrGTcMQ+z/T9NJZkG3sliwnV8RYb0NH5XXJaXSXy7iMq8LTo59pRCWD2lHrSHcAZzI9X5E6CH41t0lfyV88+hpJ85Bu/ApbVWhHp4v4tN6sXwqfiHQFUlXw8JkHNLyij/1K8pLCCG7ttMtW6M3nMvw5fQfr3pbAEMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871714; c=relaxed/simple;
	bh=fIEQ3gPMHlD88DIhTUaicLUwoVolyTAWkQLHwTTl6bg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a61gjbpY3OKIL6EYWsCt+gaaHGG/mqkONvCQ4Lj7SNxXcaHb8deuKgwWuHA2nJTliswiof07Jv8MjmwueuaZEL+W8R9RVFnMCZSjOaxpESZbU5FjwXpVU1jgKF/L4cw00DOTKmQzGOCiritpFrkvqzLtucSrK8X2VugdarQwqHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RWSLPszL; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jsNjNLtIopKqD/ij5uChR72U7HZnEGdPE8dFfMMB1Ca01JuEwvC+DDhuu1+gjzlnGR8meY2/FhQXhYq1cABGC4UYk6TQubo0cOCKaJFp0MxOkLKuuFenRkt35NVlrbwnLv89hwUI+CzkcZnvo1KyUAdJUOqd7UQ6njHU6bsMznfyZUrX1ioD2XBaPnjepHTZbZ+HNem1/IDnn0rwWR7fpavBCSyPI4260ItBb/iW/hyR7T/YOCazh8hlXvm1O1xoHHS+hwuqP12Gz7uIMg3XSJq/vKgPIEKWw+mSAw91dNDvuEWHo45Ws+wIzB5shwXUUdR/KXHRlg02DGuYMxpb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/DrpFWRD9dbbu+1OcVGRu3xpbNDnY2GDRIR1jRTWzo=;
 b=pFucRdkLrvjdwvNxeFurDCTgJ5CAyqrYQN3FLlpEUhxGdduwtp7icHFxDIOAgyaIeT5xwj96R5/QIZr4kdBzgiGMpQz/BRm00VCP9l5YoKk50U38eIJiypSjvsSMoXrZd2d3S9rMMCrXJ5gGCcyeNWoCMTqXxqjxB5xcDCZmZDStbJ2xLW+bqXEKKapThcE3I4uo06E0nzgh46q0lBDpcXL2mv+3ijk10qsek29IUlnJfIqN4dl0cBTqitAYzq/hmBgucqBloK782VCfvUbUDM9okr9vZ2sC8KbMwVUmHcKokgEvrlh6A8G49D4r+HZshqMr1WJ66NJ4QbHtEtceVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/DrpFWRD9dbbu+1OcVGRu3xpbNDnY2GDRIR1jRTWzo=;
 b=RWSLPszL1CY2naqN9ysioePpPFJbOAUO4GTrXQpdkpr8+t4F3yK21SjMCh8FmwBljoHWAlvOo6aW6AK5gTiIwk6daw5X5I8wwb874bHhuhj5LK787DH/GLXaNQfnu3fDdV5zIU1Muri9EMJqRdJ2AcQarMgCoriwUvXsEUSYAnxsI/aURuJvXuXwaOf6epqtFOxqFnKA8MVLlp0PEzbE8yrwxBzdmDb+XuEnYY3MlYI40YuaqRcBz21Rpkvdk+arWNI/J1IykBDa/+wy2VeZpQnDZgbVgiMvg93eyPG99eb5gZNGqK/EEptxttZHUkJhB/MIgf14eETuVcWmHltA9g==
Received: from PH7PR10CA0006.namprd10.prod.outlook.com (2603:10b6:510:23d::25)
 by PH8PR12MB6817.namprd12.prod.outlook.com (2603:10b6:510:1c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.21; Fri, 20 Sep
 2024 22:35:08 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:510:23d:cafe::c2) by PH7PR10CA0006.outlook.office365.com
 (2603:10b6:510:23d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:53 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:52 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 02/13] cxl: introduce cxl_get_hdm_info()
Date: Fri, 20 Sep 2024 15:34:35 -0700
Message-ID: <20240920223446.1908673-3-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|PH8PR12MB6817:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ea38c5f-0a95-4e0f-fd43-08dcd9c47b41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TPrJNDXkePvuaTF2/wTYvuQIkKOecXYxExRsJlD0lGbqt1zlQhkgCeJOVXZe?=
 =?us-ascii?Q?RIL1TZHQ54oahaoIfkrruGwXXcQx7RAlDBQbsvw06qRdi5Q3MXP4OxHjKnUF?=
 =?us-ascii?Q?jO8h9ii03PA1qRVoRvS0IxP3pv4PwhG8lqCO8I++iziaNgm2QGS1+tpB1FoA?=
 =?us-ascii?Q?YcPEn6BJ7pE09+PMWcq5AXijDJ/4TsG2O7e5juYc8pqPhNo91fLLVK9F8Zgf?=
 =?us-ascii?Q?C3iCt5cGWZ6oNPGUq0pfT/IH1DTu4zg4GzFGjcHO1kP8SM0SAg9GO6j4WBU4?=
 =?us-ascii?Q?jDoQrIq0RvWQduC9GrFI4M1CvzYJiQJMvvfJ5J2HLZEbV3VaWNATJI0mlYq0?=
 =?us-ascii?Q?5wPTtGH0R13xNtd5qpoZrN2O/QZjIRgDK/TuMcE3HKXB3GIxrG/ezPpYCM1I?=
 =?us-ascii?Q?1LHTKeGW77B0Dtke6kGzuOIxm46izjgoZhdmn32UXr3c7DSCChpgvLLtWGF1?=
 =?us-ascii?Q?/vx4IbW4uprucRblReGXnsqpbKKvoooYi2R3ba3fYMbAbc66EYQSYWUpRZ+8?=
 =?us-ascii?Q?VPftiyO1TKDjDATyq16zFzg0NVuM0IjRdixCIipzs+ockuzfe4ZJie1/K4lv?=
 =?us-ascii?Q?tJSKK6JOptz1jfL2qpPTnh78lqSK1EZXUo9k2Hc5k08S6k4W4hVThzg9FEtc?=
 =?us-ascii?Q?sIF0r4uf947GgrkBzszmM+xVo/e8AnkqKMfnVah3O0CHfO/wX3Q9iisLG8yM?=
 =?us-ascii?Q?KiO9yVg5AjPyLcyK2kj+FG2cDRfV5u4sfNFKYYdo4mpPX+vtKjKhPT5T8vxS?=
 =?us-ascii?Q?Jgfu4+Pb5dViq6dO8H2X5li4p+NSPlE/3dQvKQw+625l80qtCQdXYY5XQve6?=
 =?us-ascii?Q?CJL398vjSkZM5IaTCHjfkeYYnpXOxAaR9aLjbjdYp3CGvBXyz2AR8Xas7kUc?=
 =?us-ascii?Q?DpzyfMRVtGIv1+ldlKUyEamzKz/XRKzXxoDCAYT5Xqzo4c2zes8mntXv3aDH?=
 =?us-ascii?Q?qmCVWwUt+JvKcla5IEuSFsog8q3NS8Gt77xoOOs5Rq3tXLkLBvfBgqDDmG4r?=
 =?us-ascii?Q?FJMNiIE6A2iILEFvhfxv4JSn+xhnNp7QtwlhF8FCwVx5e7zqqZZ5eRyNfavO?=
 =?us-ascii?Q?yHI+eg9CyjNVU3wP2Y41Jy2lb/TXD/wubyf5veQxQVpfOE7k7rC41k31XTo4?=
 =?us-ascii?Q?oWY/VcgspniDB0QReT+WJ0GUHPYcerwnGfkicXaqkkcmaQ0ZKpnEP80NBaJb?=
 =?us-ascii?Q?mXzkttQvQhB6bUOpWY9QOElxprSCL1y0gENmmYRbi4SLwaXCYa2CV0nKU+TH?=
 =?us-ascii?Q?R7zRodtY6PlM0haZbC+zUFUWy+euajGzVZi6zt0QB0LzRQjGbNpZ8clgzgHL?=
 =?us-ascii?Q?3BkPfzQi7aeJhtRVKafW4PdoU7zHDXVaTn1gocCrmOIaTarw8Wuc8+JYfUsT?=
 =?us-ascii?Q?4P92rOenUi885o791kvof3bEHkOycgV3a4paScyNFxbE9S+Hg/t/YCaVneEV?=
 =?us-ascii?Q?Wl3kyaYuaJXSGYoZ4qdfFxc99K8oxHDz?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:08.3726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea38c5f-0a95-4e0f-fd43-08dcd9c47b41
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6817

CXL core has the information of what CXL register groups a device has.
When initializing the device, the CXL core probes the register groups
and saves the information. The probing sequence is quite complicated.

vfio-cxl requires the HDM register information to emualte the HDM decoder
registers.

Introduce cxl_get_hdm_info() for vfio-cxl to leverage the HDM
register information in the CXL core. Thus, it doesn't need to implement
its own probing sequence.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/cxl/core/pci.c        | 28 ++++++++++++++++++++++++++++
 drivers/cxl/cxlpci.h          |  3 +++
 include/linux/cxl_accel_mem.h |  2 ++
 3 files changed, 33 insertions(+)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index a663e7566c48..7b6c2b6211b3 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -502,6 +502,34 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_hdm_decode_init, CXL);
 
+int cxl_get_hdm_info(struct cxl_dev_state *cxlds, u32 *hdm_count,
+		     u64 *hdm_reg_offset, u64 *hdm_reg_size)
+{
+	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
+	int d = cxlds->cxl_dvsec;
+	u16 cap;
+	int rc;
+
+	if (!cxlds->reg_map.component_map.hdm_decoder.valid) {
+		*hdm_reg_offset = *hdm_reg_size = 0;
+	} else {
+		struct cxl_component_reg_map *map =
+			&cxlds->reg_map.component_map;
+
+		*hdm_reg_offset = map->hdm_decoder.offset;
+		*hdm_reg_size = map->hdm_decoder.size;
+	}
+
+	rc = pci_read_config_word(pdev,
+				  d + CXL_DVSEC_CAP_OFFSET, &cap);
+	if (rc)
+		return rc;
+
+	*hdm_count = FIELD_GET(CXL_DVSEC_HDM_COUNT_MASK, cap);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_get_hdm_info, CXL);
+
 #define CXL_DOE_TABLE_ACCESS_REQ_CODE		0x000000ff
 #define   CXL_DOE_TABLE_ACCESS_REQ_CODE_READ	0
 #define CXL_DOE_TABLE_ACCESS_TABLE_TYPE		0x0000ff00
diff --git a/drivers/cxl/cxlpci.h b/drivers/cxl/cxlpci.h
index 4da07727ab9c..8d4458f7e45b 100644
--- a/drivers/cxl/cxlpci.h
+++ b/drivers/cxl/cxlpci.h
@@ -129,4 +129,7 @@ void read_cdat_data(struct cxl_port *port);
 void cxl_cor_error_detected(struct pci_dev *pdev);
 pci_ers_result_t cxl_error_detected(struct pci_dev *pdev,
 				    pci_channel_state_t state);
+
+int cxl_get_hdm_info(struct cxl_dev_state *cxlds, u32 *hdm_count,
+		     u64 *hdm_reg_offset, u64 *hdm_reg_size);
 #endif /* __CXL_PCI_H__ */
diff --git a/include/linux/cxl_accel_mem.h b/include/linux/cxl_accel_mem.h
index 5d715eea6e91..db4182fc1936 100644
--- a/include/linux/cxl_accel_mem.h
+++ b/include/linux/cxl_accel_mem.h
@@ -55,4 +55,6 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 int cxl_region_detach(struct cxl_endpoint_decoder *cxled);
 int cxl_accel_get_region_params(struct cxl_region *region,
 				resource_size_t *start, resource_size_t *end);
+int cxl_get_hdm_info(struct cxl_dev_state *cxlds, u32 *hdm_count,
+		     u64 *hdm_reg_offset, u64 *hdm_reg_size);
 #endif
-- 
2.34.1


