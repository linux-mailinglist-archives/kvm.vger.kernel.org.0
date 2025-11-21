Return-Path: <kvm+bounces-64132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 526DFC7A165
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:17:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3F398344AB8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F42631A7F4;
	Fri, 21 Nov 2025 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m4/zdXwD"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA112F657E;
	Fri, 21 Nov 2025 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734332; cv=fail; b=X60uN4T5/F4DXfsYJJ+zzj6ITvtyj0ntPMnoxStPe1EhIBlmzyEMvwkCTJDQzMcO9GxHeyOrGFEc+O3gwuBHAZ6n6Ja6EB+zifhSGnvDMjDHeW9cNsRNKtb5rbiC0qwjfvIHSj7YFB3XvzwtN9vw/e5VEuh8kV4fFi3pQ7awFKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734332; c=relaxed/simple;
	bh=N7+zYOdrJZ7FIL476RpLrz5wXoXB6jWLw/EraOMqSBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPDow1/rgKEhHtUPrISSnMIooAUf5f6Woir+Hf8tucHlH2yFBICc64PzL+5nJr39ePRhLV+MgIJoFmGrPSUVxnybnfQ3hw8i588MJlYjNcGIwPoDfIvRpA/WZ0oQFCIOd+nJMYkffLXhmumErj8tVssAMs4f6deZwMUWpAsgkUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m4/zdXwD; arc=fail smtp.client-ip=52.101.85.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQuhiDPnRrNqZMhzu+aN1DaID4zsjbNDolYRocRlnCCDafp1/7/+C+maWwaimwVH3IjJEJsfTj4zk2sZGQThLKGQqEX6PEmXtzmdajI9lC5H5zBU3xnn5MrlNu0eAhPziojy7cL/mWdS4rPmevHT+Nv/CWCcxhikXaQZK7n1HfCVdGKbjLf9GB70QCVUthI1WAAKfBxVDYQ0DVTX2FSGAad5eOBMPvjzoGRXJppSAv6Jkw51VNNykJth8uoIyPMDtXT6UDx15ooj45vn4Ec13TuKittA22KPhb0cKDXtjbyVQd067UbSsfWfKaeE6RfvFlAXpgw1PLFKy5i0nCuktQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gIwnXlwC5nA45FDLzSeoV2hjFrKoOSTsb3afesgyis=;
 b=K4Rkh3WIaRQKP/AaL7V4ptLp1BqOwlaArOHRtqdBxPrkhPETiQHT1qJnZsG0CvHKSmeHoNRBWYckJS+1rrVo1Nn9Wf8DK3F/1n1+smh9yWZQIAyNf3Rhdo6snG0XAIiPoHTzc+GZPz4iNaJeUpybQ67RC6hrKn61Z7O5kjPc0V87F13AMe6uN79sBgBaPfSvjeNGREnmwDtCyktp10jdCzTt5nimpR6+hZh4X/vd1/zEE+e1wtq4z/cYY+RFVa0LPHzYl/GlPEFlbPksxcu6s+6VGBQjfkN7Gk7rz81ZYmCnVWEAxsEWqaiurgknicTlcFOSUId4YLeD5y0whJ8Dlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gIwnXlwC5nA45FDLzSeoV2hjFrKoOSTsb3afesgyis=;
 b=m4/zdXwDU1KtaSccG2rVAqSd5ShwunYHOOHpGiK36aREygWmKLTKg8NQCTksSyRpkPT5OCPjgYbeaQSBfXmJOvr2rOWccj3AJCNqRBNSpBDtGuUKzPEF0FrrzTZMBNFxKPmhvtY6ufXqfsE/uTuxZUIMw7vlPzqV8rP/8ihmDaXw69DcWpUoJSDVwojOzHw4/56gbetSbnVW6V5Ff2EnTZI5UWzooLtvtfXwb1/vfSzuwiY3RRebQQUp4gurxvhwvcXOKitjkNDc85QwZ1FH90QPDPZmya2u0OxHdzU5+jX7jA7lyJa/6rPcP+Mp3BzmxE6fr00/3UV7CP81cMWylw==
Received: from CH0PR04CA0115.namprd04.prod.outlook.com (2603:10b6:610:75::30)
 by DS7PR12MB5983.namprd12.prod.outlook.com (2603:10b6:8:7e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 14:12:06 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:75:cafe::3b) by CH0PR04CA0115.outlook.office365.com
 (2603:10b6:610:75::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Fri,
 21 Nov 2025 14:11:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:44 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:44 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:44 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v3 4/7] vfio: export vfio_find_cap_start
Date: Fri, 21 Nov 2025 14:11:38 +0000
Message-ID: <20251121141141.3175-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251121141141.3175-1-ankita@nvidia.com>
References: <20251121141141.3175-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|DS7PR12MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: 1435c759-d269-437c-97c8-08de2907f395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f59TzNrzQSMITXec/kID0T30nwcxs7B6po82jziu4BHd3SWZJGLbbrrTT66m?=
 =?us-ascii?Q?EDS7TQMt8iz186LcO6cu7YnTQa4JohJfY0aYbDxD/D5CM7Akfwh3DuqpDGvE?=
 =?us-ascii?Q?mXsMGV70QcoWLhWC0S2hbaAyJdpuxAsEwlr5oE5R0qfYhsDnZFMMdkNvPv+z?=
 =?us-ascii?Q?fMKjkKLYdejI9RteqVO/iSXmDUFTNaV6U5mUZcE6//p0BX0vwkbmHzaM+zRg?=
 =?us-ascii?Q?TqjrYqb9C+epQl3wovYnvHNa6Zh+1nL+sxVAHv26GxF3tD2NepkW01tHvh0M?=
 =?us-ascii?Q?Bufe0xfs7e7bYD8sQANZRmZrPfU3aI0RNdSuJHqTUWoetVIymZFP1AM+sCqU?=
 =?us-ascii?Q?x9NUvBlUsgpx7f3ASMx8VPJgWbjPXt5rxbinjrWxjfpbwnk35df6zyVVjY3Z?=
 =?us-ascii?Q?uPUOX6Fp7/4sXd0sWyxBQttOM2R6KhZ4dnI+cWmaNE0Mx9sE7iR//gLKcU1z?=
 =?us-ascii?Q?IIzkYV4vtAVf7qhqxcrt7GpmWpWJtZ3WRCByUR8VTTatmpafZI8JHREiwTSN?=
 =?us-ascii?Q?bFVQjnuwAtUE9T53a37sppBQVwlfiIEUwZ+xp2e1+t6+Vl1OhYE1ycofyUB4?=
 =?us-ascii?Q?IWrYFJeNGBuMrBLEiaxSzg5saunaANhrQR/LUZsHPVENJX02fJEorD1TynOZ?=
 =?us-ascii?Q?/fjrlAzvcGuyRgBlNPcnP7HuArsnvM4dc1QEJOB6IoZbOPw1OUlp9EJtvUHh?=
 =?us-ascii?Q?y6Z27PmrtWURpQwWET+IUcior2omDMZwy+7HAwMK9/s4g917QFqmyA9mybUi?=
 =?us-ascii?Q?IfZ7a01c0AVgNM8Xi2ZqQST2XW3NODcWyy1WK5luwgkG4u8+fe+J3SuWWcjG?=
 =?us-ascii?Q?9DfQ65d5nuOPGKluzbWksoK6bXIVey9u4wpzLRxVEauxw22xENs92YfSssCp?=
 =?us-ascii?Q?VYUKBF3HjvjkUYMhhx5ggk2xhMoB+d8EIoTVE9Q+05VBjG27Ep8jXZeo7Qsj?=
 =?us-ascii?Q?fgRh3JjH/8Uzq2IwjjGtie2wml8nmCrk5DnD6iWz2JaCOrE4dO1ZPMlZdomx?=
 =?us-ascii?Q?+2jLnx1hRoT0RXLM+WFKb8IgZEYiMuCqBOtsSaYZDnDzlN/B4eT6wuam0GHx?=
 =?us-ascii?Q?Cwi/1Xyim0gZUF/Ng0Sg3qiIBlqMQwpIEpMXp85/qvGxZmc8VqGbuS8IbeBn?=
 =?us-ascii?Q?mcNJNyEhUBZq3lxonODBalkd7lAJV6h4TEkZoWCN3K7iaOZnDnuXst8qB4d/?=
 =?us-ascii?Q?Uy0813gigab8AQXFE6In52QE9aj6yY9leW+jYwRXB5ZG2KEV7uMeceXXKzVq?=
 =?us-ascii?Q?NlvdntSFuYWmZDTJec2PY84PlK1fqtGHAWFmGv5ISF3rXRmxVbE2DItKwGL2?=
 =?us-ascii?Q?WDr5WcA7LTGCIJjVup+1MOqTI3U1SHS71oSDvaCCHUnBAfLd4cvgSn+0AmN7?=
 =?us-ascii?Q?+K4BYSfFlhfZ8c8TOmDwlBqkLzZ6HNtHQW70eUXQH6zmxX951adWtfjt9v3H?=
 =?us-ascii?Q?Ze0YstSaHdNQAeXGeEqdaVUWe9gZRSSSDAibmtl85BZlfqocNB2nkZzSvtBR?=
 =?us-ascii?Q?MRo583w077g+j7T3Xo+fJuio+Il7FVxH5UzcTPdslDdMbWMx29NQi74iG+qK?=
 =?us-ascii?Q?QuGLhNh3iFpeyNA6Qm4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:05.9553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1435c759-d269-437c-97c8-08de2907f395
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5983

From: Ankit Agrawal <ankita@nvidia.com>

Export vfio_find_cap_start to be used by the nvgrace-gpu module.
This would be used to determine GPU FLR requests.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 3 ++-
 include/linux/vfio_pci_core.h      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 333fd149c21a..50390189b586 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1114,7 +1114,7 @@ int __init vfio_pci_init_perm_bits(void)
 	return ret;
 }
 
-static int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
+int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
 {
 	u8 cap;
 	int base = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE :
@@ -1130,6 +1130,7 @@ static int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
 
 	return pos;
 }
+EXPORT_SYMBOL_GPL(vfio_find_cap_start);
 
 static int vfio_msi_config_read(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 058acded858b..a097a66485b4 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -132,6 +132,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
+int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos);
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-- 
2.34.1


