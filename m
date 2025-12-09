Return-Path: <kvm+bounces-65563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D9BCB0A25
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9D1EB3019A57
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE9332A3C5;
	Tue,  9 Dec 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="texrwsyS"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010022.outbound.protection.outlook.com [40.93.198.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B71329E69;
	Tue,  9 Dec 2025 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299121; cv=fail; b=Xuq0vygKAStUngzwbkn+2dzyKLvORCpMEbbohmfyoFBtItsB4T2qXIfKHYLPdESIA7rciJ99RDsMvthxANXw1dY9Uv3Byf23UdppmqAn0KnY6w8e0X/JYO9QHh7loyqbTlXYMdlHS3Og9SHLXAqhiTtdRqL3XhSR5jnyuOnOMco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299121; c=relaxed/simple;
	bh=VX6dmpYaV/DtdieE4IzthBL4+VVnTlZqXOW3zqYP8C0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKn9GKpRusSRZzuWrZFo9CuQqIsB6EqrUCm2qgKDbEQM/utvLMSyKlhOOh98xem/vheCev1OU6kbf0K2CNw6PADeCZ4wbbFNYNfO2MckroBj5m/nrxFucERhGgnTlHdUyQ2sQLXjskgURPWD5lWayvuoapbYpDF3mE83Vk5WGWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=texrwsyS; arc=fail smtp.client-ip=40.93.198.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MIvbvze9L97WSUdNJZJhiwEOmlVvyDci8B8s8j9VTm0GX5MiHNdlcdS2IemB6wHvnJXXO7PtCVzSPLVSX/l762Vl8zfBh2BJ+q8TNIkCX6PI2eNRGkoy+JfMy5X3fLX0oNFcQ82S6SnTriem1QIPeaL/6xFuyoJ9ICSAtbkgKtLiC3/adjF0xc2jJ06TuvjbGEgaSN6WccmSpk+4B1hasFP2xV8CaHc2X28K9kVgHHTqYwzB9pGxNYus/zAojm510Iql7+SD8gg7ozICgBcBcVbdCI2m9IE+NjyWokYnB+2+nlFRBks0Qp56ob7x7KHQ5jG6AZsfl+NtijMpflYw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ii7KlQy8rAuBxrgwZtcN2qWS7O//IfeJd4bXPLj2Zkw=;
 b=wccvD4uBz42M48pWf+i69oENXZdJPWfxQqu/HgQoJwaivfkz2STp87BW74EkzSEgvShCazZN8EXDXOup9dwxbnu1o7gtPvyAhGKH4I5u2Dg0N9xEORiCcH3ZzbFV2QVac0Ttd3B2Grg3byQ3xPFUJWWr3qtaWUlu75GkkS6x96p7/gKTwLkH4726K4DeL1Z23UH5KjAUDQfivtxnslY2E50h9OcJuOs/TIyQcib8ZI9sP0zaGW+ORAfvPg59+Snv7wxf552Pgxc96BDCNAW9bM6ueQflM0Yw7nti5gECpP9LCx0K73VCtp8MQPt5w6/kf+OBvbJq5dFFR1qcw3ftjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii7KlQy8rAuBxrgwZtcN2qWS7O//IfeJd4bXPLj2Zkw=;
 b=texrwsySW2fQ9sg5588YXGpLiupNqHEyYh91NMshMgMCFOdDUbgz/NVelBAySg2+4MuHAxiARHyPauel3BVLVKOUYy3pb8VYqIHr82kPB6ZWbmE7pKmstjkFNCEiBKhwgFvNYpnQqg0JrmMrDB58vurOylOI3PuBSFzxcTbM9EuIQdEie2xQNB+GhbuP12DN+15Wdfz+wPeRcBw9989lpZtUVQVqAE7QmOWZxKLYY9a8n+UaRZZVOPAh6tFOjcjAy2iOvAsHa3BQSxzKEGIlSipdPAPQHrUMIRErZGg6PVOAC175VOjXMEsHsaqKw8eHDxYq/EBzx3Jc74OyphzxjA==
Received: from BN1PR12CA0030.namprd12.prod.outlook.com (2603:10b6:408:e1::35)
 by PH7PR12MB7210.namprd12.prod.outlook.com (2603:10b6:510:205::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 16:51:53 +0000
Received: from BN2PEPF0000449E.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::44) by BN1PR12CA0030.outlook.office365.com
 (2603:10b6:408:e1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.7 via Frontend Transport; Tue, 9
 Dec 2025 16:51:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000449E.mail.protection.outlook.com (10.167.243.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Tue, 9 Dec 2025 16:51:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:27 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:27 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:20 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 05/15] cxl: introduce cxl_get_committed_regions()
Date: Tue, 9 Dec 2025 22:20:09 +0530
Message-ID: <20251209165019.2643142-6-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449E:EE_|PH7PR12MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ec27fd-7b0b-4e3b-c84b-08de37434059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WXFVm46XK9wl7zNHQfcbd+tDOPV44MVggNFcaDEpwDP99wGJusEJRd0VrDwt?=
 =?us-ascii?Q?Ui3thD9YsKH8PjN/ZfA1iAgpgE4U7j+I+7+HHCecKhLfbF8vluCNqOxPtfni?=
 =?us-ascii?Q?banr42wsAZb2G9q/IagjGrCr+H0pJwKSZH7IyESiy7D050za7fEZ/4Ge1ijW?=
 =?us-ascii?Q?5gZhJKDp9NaTFJnfdxQ7nWCk9t067D4mNwuBiJmgvBj3c4ZVwOte42513Fyv?=
 =?us-ascii?Q?h9lqy1i7aFaCBJ9qcgUPpiD0E8bs1nBFmkEs8FHZPJj6/jYYw3Xvs4tzpmp5?=
 =?us-ascii?Q?XC20DmIlAzGBbUeWa0aJqB4PNpnjQ/fFpX5faUITfG3YpYX6YkayJgzknllL?=
 =?us-ascii?Q?y240ucf8t0heLKK31kibpaVcruUDaQrF3whXPFxW2Qx2Pa5b7OQtnUR39kEW?=
 =?us-ascii?Q?l79Cg55vXL8leXdFJ7MV6YwUOI4/IQMSoP0vrfCS8zJXqfCh7f48p1KcJta8?=
 =?us-ascii?Q?JMm8/rO8XYpGb/ia4y4c5EmcRq95pmK79Uf7Uyvrhwe88XIx0raWrZvf2nE5?=
 =?us-ascii?Q?SzYp/TQ8KRIvVC3yiJHc6ulTsg0aN+xE+VIH8nJ/n3M/Ti+bb3hG37nMqEUz?=
 =?us-ascii?Q?CQq5GolKaW1HGEOmGS1f9LSQ85uL2Ao25O7Uq+wi93fGOPYi8LGilU1I4GDt?=
 =?us-ascii?Q?N8b7FjkK3O50IL1D7O26ECieFL/h35I2fGENIJ6AAx7nH4535Y9PAi57JzBM?=
 =?us-ascii?Q?zGabEiqCc78wiCMgnTRG10V6UphUoq/Ww6ujgfxrAADhhYDkVF++bDvfO+ss?=
 =?us-ascii?Q?2A9jnurYKrq37fJZzMJr2U2d2qaYopNtFggwiPbvueSePOan2jVdTzYmN2qU?=
 =?us-ascii?Q?GPftJokBLC20X7tHRGnXPthRDszWtrA1p3wS+gkLohd38p/LQM7W/VYTKGX7?=
 =?us-ascii?Q?Xrs2IXCaaS85vFU1Hn6AjWsbf1UWFkjBU0grflviLnvhY+nmg5RMuXGRLTWn?=
 =?us-ascii?Q?qAp3K3IPfK5LyTaFgpIXJNNnQLtkJ+htCAen540b6sGiY59RJAufsuc1K5BQ?=
 =?us-ascii?Q?D4Ue09EVyTKQWowaUDqMGxBzat7dwx37SYlC1A7ATB9hJkSptmBf/IB8Q+G4?=
 =?us-ascii?Q?93rQrESGyd96fvI5VGyhwVxdNrVwcQu52UokGdV2r48E/TYoIylEm1lBv7Ha?=
 =?us-ascii?Q?hcZ4lS3d3XcE05W1cE42JC+Y02hrxZAof4E+MEtEyxOgTkhSkj0/Iej3RqSL?=
 =?us-ascii?Q?1NAIX8RWTOJk6el50V2ybwlAm/L3iyIFOgOzTTe7r6/htH1MTUWaGMdVrcc2?=
 =?us-ascii?Q?WXsmCpFp1qiiYzb/Ugc4jgvNVDawfkGBliKkgtbGC5TD9JEl0AKFjrCIpsiN?=
 =?us-ascii?Q?zNresc9jz5TS0PQUw3KN4mkmHbAgb1DiQLMcT2whNH9r+7aBN+vDgA3v7p+L?=
 =?us-ascii?Q?Lwxknj35OvgJwD3tl5HpqOWfpKRitiyaRZZglDV6/9MSV2CLT+cOg1qSMoO/?=
 =?us-ascii?Q?k61w86RurkSNIOu/rcm0QQUv19QbZPrXiKIiiatISInNLq/MrVx81YBjqrP3?=
 =?us-ascii?Q?Pf1mbchTj3iAWx5yNNgvHMMTZuozViW+Lee+nbcMzjLLVgn+tR2Gs2iwKgvS?=
 =?us-ascii?Q?I9khjpfXhRkx/4BDNdg6TV/30D7JlalEs4GU3036?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:51.3296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ec27fd-7b0b-4e3b-c84b-08de37434059
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7210

From: Zhi Wang <zhiw@nvidia.com>

The kernel CXL core can discover the configured and committed CXL regions
from BIOS or firmware, respect its configuration and create the related
kernel CXL core data structures without configuring and committing the CXL
region.

However, those information are kept within the kernel CXL core. A type-2
device can have the same usage and a type-2 driver would like to know
about it before creating the CXL regions.

Introduce cxl_get_committed_regions() for a type-2 driver to discover the
committed regions.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/cxl/core/region.c | 73 +++++++++++++++++++++++++++++++++++++++
 include/cxl/cxl.h         |  1 +
 2 files changed, 74 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e89a98780e76..6c368b4641f1 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2785,6 +2785,79 @@ int cxl_get_region_range(struct cxl_region *region, struct range *range)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_get_region_range, "CXL");
 
+struct match_region_info {
+	struct cxl_memdev *cxlmd;
+	struct cxl_region **cxlrs;
+	int nr_regions;
+};
+
+static int match_region_by_device(struct device *match, void *data)
+{
+	struct match_region_info *info = data;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_memdev *cxlmd;
+	struct cxl_region_params *p;
+	struct cxl_region *cxlr;
+	int i;
+
+	if (!is_cxl_region(match))
+		return 0;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+	cxlr = to_cxl_region(match);
+	p = &cxlr->params;
+
+	if (p->state != CXL_CONFIG_COMMIT)
+		return 0;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		void *cxlrs;
+
+		cxled = p->targets[i];
+		cxlmd = cxled_to_memdev(cxled);
+
+		if (info->cxlmd != cxlmd)
+			continue;
+
+		cxlrs = krealloc(info->cxlrs, sizeof(cxlr) * (info->nr_regions + 1),
+				 GFP_KERNEL);
+		if (!cxlrs) {
+			kfree(info->cxlrs);
+			return -ENOMEM;
+		}
+		info->cxlrs = cxlrs;
+
+		info->cxlrs[info->nr_regions++] = cxlr;
+	}
+
+	return 0;
+}
+
+int cxl_get_committed_regions(struct cxl_memdev *cxlmd, struct cxl_region ***cxlrs, int *num)
+{
+	struct match_region_info info = {0};
+	int ret = 0;
+
+	ret = down_write_killable(&cxl_rwsem.region);
+	if (ret)
+		return ret;
+
+	info.cxlmd = cxlmd;
+
+	ret = bus_for_each_dev(&cxl_bus_type, NULL, &info, match_region_by_device);
+	if (ret) {
+		kfree(info.cxlrs);
+	} else {
+		*cxlrs = info.cxlrs;
+		*num = info.nr_regions;
+	}
+
+	up_write(&cxl_rwsem.region);
+
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_get_committed_regions, "CXL");
+
 static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
 {
 	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index e3bf8cf0b6d6..0a1f245557f4 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -295,5 +295,6 @@ int cxl_get_region_range(struct cxl_region *region, struct range *range);
 int cxl_get_hdm_reg_info(struct cxl_dev_state *cxlds, u64 *count, u64 *offset,
 			 u64 *size);
 int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset);
+int cxl_get_committed_regions(struct cxl_memdev *cxlmd, struct cxl_region ***cxlrs, int *num);
 
 #endif /* __CXL_CXL_H__ */
-- 
2.25.1


