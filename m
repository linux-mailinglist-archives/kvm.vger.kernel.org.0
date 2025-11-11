Return-Path: <kvm+bounces-62708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DA1C4B83F
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 074EC1891FAD
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 05:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340F3253F03;
	Tue, 11 Nov 2025 05:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IN6jXlGi"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010022.outbound.protection.outlook.com [52.101.193.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192A0314A9F;
	Tue, 11 Nov 2025 05:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762838017; cv=fail; b=ueej0ooMPI2qRQ2MoLAJQP47W1vXtYtxNAPFym5W236n1HiSU9O2SkWe+AQs4qTYYHjYrnutTxA8phGhBirzLtYWVtbBoXznePzOG2v7na99Eb5N7Yr+tsSZAWlNbGp/uN2fHvCZSiF6+YbYQo4kTjojYHHAPl/pE3wR/L9MLyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762838017; c=relaxed/simple;
	bh=reel/uSpVtqxeeWIhl67MXSPO6SsI6DqJgiSj754PMo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qjhyxb6/vjQHgt1b1cRif32ncGLG/FJDNYwTgVDYTG/3A1vFwUmu9pK+yvyFbHfleOs4XoCL/UuFLS3/ObseUTIMP69uleI5AtJsvt2+m6eq4rcjFjSoEg2YiIMOe65k9L5YSzSrcWq9TAvLS/g2ZzKTqOaiFqAGv1tOAJOMmQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IN6jXlGi; arc=fail smtp.client-ip=52.101.193.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nlBt6XEuLodS4xvxU7GyuL8HjSD0CFtqO2gG+seAn5yqdr6+6GTvFTDBIhWI1ntc/Hp/FFroR1ioyXzxel0EMoLPFe0G4S0Ig1gJOhLK1ZwadlE1GHQr62WJ5VhZnrbTMPEUWPmTVt+Ni480c4QqhBF/lbBAIBLabrZq77bXJI+C2vM6k9l0D+Sp1ya7Nypo8ruj9GTbKOSl97WmfB/otllsH1ns225EVnCtCwFA8f4OasAa45sluoEuDk11Rg92TAQ8JiRqWJlMO2rx3WaEyUFFn+UpL5e/RH/fyh07muLTXHcwB+VegbBeJsXC4R9gAG3Kgigdia+9OmKBa5U14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKb20I2MlS43J/fwsYrzfJGiGWgeWbV/qLCR+EeqwO0=;
 b=OHFthpnnEuV+25+X9a63BujvZ98DFzUQkkpncSIVlhhvFjDYMklSbVHrcJajL/tXeVVNdgiaGWT8VASansfHOUlfcWGDHWYxeY5GOx7QbWWJGgT0wyR4Tqzb3LE95vjIGfFarZONvUNcpjL63DP8nHo0F/CHp40NXVLc1lNf1Zn9sCpt/xOu48TL8KbLYi26V+ipx/pgC5Z/wyJu0Nw12AXZpY3A4Ojb3Hb8t8FBwhR/lxQuJ9mtEQd3kdMA57GZP+ijv8McRATkF4LiUZg4zbLb8UBDR30UyhdY/AgWIF4SdXO3j6Aw0oaXrGDYkmzV3/l/fw2Sg1DJyfIBLLs8lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKb20I2MlS43J/fwsYrzfJGiGWgeWbV/qLCR+EeqwO0=;
 b=IN6jXlGizZPTVUOcMainNl8PaACUg3yDUu2kVe981OkV/taNsp3HTnTRrZxhIxPBHXy/i/0U82AZUjYetRRCvXMVnlANyS1udXYMxIaemlsbtMjaTo1WREAeBM3LWRhL9zJlbYCB0HFomNemlkmj5yxbSLXBw7uTuHFrcfXCo4K3mOeNL3zz2F1pJJHs9qpOJfQvxaQAVTN8rS6I6OswsREDkhz++cu7ySNoR+M390UgYK+AozlzYEhxPgQegwH7xbqa4yhQT/T9pAdqgbkttI38lohOcKwPEcI7S2ir85i+bE5SfSr5MTMpB25sjLozGl7rh0ep6RL49HQ3LeFOxg==
Received: from DS7PR03CA0015.namprd03.prod.outlook.com (2603:10b6:5:3b8::20)
 by CH3PR12MB8307.namprd12.prod.outlook.com (2603:10b6:610:12f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 05:13:29 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:5:3b8:cafe::6b) by DS7PR03CA0015.outlook.office365.com
 (2603:10b6:5:3b8::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 05:13:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 05:13:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:20 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:19 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Nov 2025 21:13:18 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and iommu_dev_reset_done()
Date: Mon, 10 Nov 2025 21:12:54 -0800
Message-ID: <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762835355.git.nicolinc@nvidia.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|CH3PR12MB8307:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ccbabbc-b027-408e-93ec-08de20e10d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Z718uLOWwOR6BAJHrui5PYaeozqHGZbSRmm5s2nAkMfbFzQclKhrJknBWkF?=
 =?us-ascii?Q?OvKFvlzCAvkaA0yK/GIZ3Me2AG8OXfuYipM9c7sFyoMCSiksANMex04DeVes?=
 =?us-ascii?Q?EmYSKEKzDfLKbVSpt0cD+9T402gDagMVulR+F0i/q9thhRtrsnFDsTxWuJG9?=
 =?us-ascii?Q?tNyhzyROqbeZ6iYT7+bkdCigPzLqCpJVs1ku/NgHGReRTTgNfCDEtOqrU9z/?=
 =?us-ascii?Q?//8X32PJBzpbH+507wkOhqZTakWaQdMzKpaYDYUiPpOV0wzZon78L0KL0Sgk?=
 =?us-ascii?Q?4WMLHeVoxbXpwTQDxya2mpz6Q/zu/TOd6kGeFlSz4VzqWrc/e+AB9Z8KX1vK?=
 =?us-ascii?Q?XwtI69eyS3pDS+gpYyQVC8ty0h7ciYUVEEiSAYFO+f6CwKP6n6TLul06FGol?=
 =?us-ascii?Q?VRhfMjgD9mCixOOkOOtFiz25a2itVnleaRofmrn8NSbqM5fm1q7EAZU3PZMP?=
 =?us-ascii?Q?pm/HIkHIVd/fe9dXubFiwA3l8lwhv1c7r6FwMOGVayaLVb2XqjOB8TKLlQOG?=
 =?us-ascii?Q?TozbVO3MT+8alSnGK6hFofrSVcKK5i5yRRVD8i1JgfwxpnzTnBQ/fBLzNeo9?=
 =?us-ascii?Q?bLRHob+OfOF3BIorgZXGTH25ePvzPyyikGTThv5hYcDm6p47FqRfG4tW0RFh?=
 =?us-ascii?Q?toNWklY2psN6qMAK+HXjxa7A4Iu3XkIGT+3FSmk0xlWG0ssXV/lf/2QFWuZC?=
 =?us-ascii?Q?p6gQAQo7v/Ohw5c2sTGRsip1XiTt4Qpctvi9xzvxaJexXOki9NBCm2mWg6Zk?=
 =?us-ascii?Q?xpe7Dj5/Z7D2tG8tcp267GuCodemXluIO5AasmNAIGkkhX5seFEMLtfFAkNb?=
 =?us-ascii?Q?2DRxCKBqVWdwdt75d63/dytUlJ0MgF7fFEQUO7MdVBg9uiNYOeghviMeonSg?=
 =?us-ascii?Q?BpFA5ZwTwVdsiy93p+sI6U2sZggJmiS9ogri34F1KXmdoOlFciSR3xlt7+f0?=
 =?us-ascii?Q?wAoPD2dpLHVcf8petcdyhEKHkI9jc8Xz5QZD/bUgIiRR7+Pjn3pJs6bPDXpc?=
 =?us-ascii?Q?mw9ASjSURMBsw1r9N8wTu7ad5Tr/N8I0UN/+2iuaiLRxDX18lKuQKxS/0Q8H?=
 =?us-ascii?Q?XM9ZamLGdzDkN1/jJQBqJxrWmScWBSx08/GZYhtWfRnScPEZbF3bpdv5a2Ti?=
 =?us-ascii?Q?Ic8dIjk+XJ6p6VrUIwAZiLP2Z4Klq+PDWTCEoyUWpDD+yzNw2tYq8lz0COKC?=
 =?us-ascii?Q?gEuKnkUfjXX1ukqZK0a4C8jM6uxHgjlgpC0pNMau3eohAUnOkx7Dnrx324r0?=
 =?us-ascii?Q?PkomF+HrBEFBzn6l6gvpWYs3YWTY9NXpWPI1SL3Yx6883d9uVzeYjz38p/uy?=
 =?us-ascii?Q?sQTCwKRAyEHaHGDrxL8J26o39bFWGyHgCpyUNzxPDVSwQFwmje52jIWTbh73?=
 =?us-ascii?Q?5u6P6ru2pZ0gCa/0xGNCfPmPSthnsjRTn/p/JO04Zghj2E6VzvF//sQHMx/0?=
 =?us-ascii?Q?1CNRng6DPbj6IEEmD3lWJmGNBUK9ciAdveW0urSq++2hy4dVro3Esl8q5IYA?=
 =?us-ascii?Q?6S+UvK72jZrv4qC8IA0mKxiF/ByuUQ6cwiXQW8n9eIVJEwaqzzYIh04wNmej?=
 =?us-ascii?Q?29xGjM7WODmxVhAZDwg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:13:29.3529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccbabbc-b027-408e-93ec-08de20e10d3c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8307

PCIe permits a device to ignore ATS invalidation TLPs, while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out. E.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The OS should do something to mitigate this as we do not want production
systems to be reporting critical ATS failures, especially in a hypervisor
environment. Broadly, OS could arrange to ignore the timeouts, block page
table mutations to prevent invalidations, or disable and block ATS.

The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

Provide a callback from the PCI subsystem that will enclose the reset and
have the iommu core temporarily change all the attached domain to BLOCKED.
After attaching a BLOCKED domain, IOMMU hardware would fence any incoming
ATS queries. And IOMMU drivers should also synchronously stop issuing new
ATS invalidations and wait for all ATS invalidations to complete. This can
avoid any ATS invaliation timeouts.

However, if there is a domain attachment/replacement happening during an
ongoing reset, ATS routines may be re-activated between the two function
calls. So, introduce a new resetting_domain in the iommu_group structure
to reject any concurrent attach_dev/set_dev_pasid call during a reset for
a concern of compatibility failure. Since this changes the behavior of an
attach operation, update the uAPI accordingly.

Note that there are two corner cases:
 1. Devices in the same iommu_group
    Since an attachment is always per iommu_group, disallowing one device
    to switch domains (or HWPTs in iommufd) would have to disallow others
    in the same iommu_group to switch domains as well. So, play safe by
    preventing a shared iommu_group from going through the iommu reset.
 2. SRIOV devices that its PF is resetting while its VF isn't
    In such case, the VF itself is already broken. So, there is no point
    in preventing PF from going through the iommu reset.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h     |  12 +++
 include/uapi/linux/vfio.h |   3 +
 drivers/iommu/iommu.c     | 183 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a42a2d1d7a0b7..25a2c2b00c9f7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1169,6 +1169,9 @@ void dev_iommu_priv_set(struct device *dev, void *priv);
 extern struct mutex iommu_probe_device_lock;
 int iommu_probe_device(struct device *dev);
 
+int iommu_dev_reset_prepare(struct device *dev);
+void iommu_dev_reset_done(struct device *dev);
+
 int iommu_device_use_default_domain(struct device *dev);
 void iommu_device_unuse_default_domain(struct device *dev);
 
@@ -1453,6 +1456,15 @@ static inline int iommu_fwspec_add_ids(struct device *dev, u32 *ids,
 	return -ENODEV;
 }
 
+static inline int iommu_dev_reset_prepare(struct device *dev)
+{
+	return 0;
+}
+
+static inline void iommu_dev_reset_done(struct device *dev)
+{
+}
+
 static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009baf..6cc9d2709d13a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -963,6 +963,9 @@ struct vfio_device_bind_iommufd {
  * hwpt corresponding to the given pt_id.
  *
  * Return: 0 on success, -errno on failure.
+ *
+ * When a device gets reset, any attach will be rejected with -EBUSY until that
+ * reset routine finishes.
  */
 struct vfio_device_attach_iommufd_pt {
 	__u32	argsz;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1f4d6ca0937bc..74b9f2bfc0458 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -61,6 +61,11 @@ struct iommu_group {
 	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *blocking_domain;
+	/*
+	 * During a group device reset, @resetting_domain points to the physical
+	 * domain, while @domain points to the attached domain before the reset.
+	 */
+	struct iommu_domain *resetting_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
 	unsigned int owner_cnt;
@@ -2195,6 +2200,12 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 
 	guard(mutex)(&dev->iommu_group->mutex);
 
+	/*
+	 * This is a concurrent attach while a group device is resetting. Reject
+	 * it until iommu_dev_reset_done() attaches the device to group->domain.
+	 */
+	if (dev->iommu_group->resetting_domain)
+		return -EBUSY;
 	return __iommu_attach_device(domain, dev, NULL);
 }
 
@@ -2253,6 +2264,16 @@ struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev)
 
 	lockdep_assert_held(&group->mutex);
 
+	/*
+	 * Driver handles the low-level __iommu_attach_device(), including the
+	 * one invoked by iommu_dev_reset_done(), in which case the driver must
+	 * get the resetting_domain over group->domain caching the one prior to
+	 * iommu_dev_reset_prepare(), so that it wouldn't end up with attaching
+	 * the device from group->domain (old) to group->domain (new).
+	 */
+	if (group->resetting_domain)
+		return group->resetting_domain;
+
 	return group->domain;
 }
 EXPORT_SYMBOL_GPL(iommu_driver_get_domain_for_dev);
@@ -2409,6 +2430,13 @@ static int __iommu_group_set_domain_internal(struct iommu_group *group,
 	if (WARN_ON(!new_domain))
 		return -EINVAL;
 
+	/*
+	 * This is a concurrent attach while a group device is resetting. Reject
+	 * it until iommu_dev_reset_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain)
+		return -EBUSY;
+
 	/*
 	 * Changing the domain is done by calling attach_dev() on the new
 	 * domain. This switch does not have to be atomic and DMA can be
@@ -3527,6 +3555,16 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach while a group device is resetting. Reject
+	 * it until iommu_dev_reset_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	for_each_group_device(group, device) {
 		/*
 		 * Skip PASID validation for devices without PASID support
@@ -3610,6 +3648,16 @@ int iommu_replace_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach while a group device is resetting. Reject
+	 * it until iommu_dev_reset_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	entry = iommu_make_pasid_array_entry(domain, handle);
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL,
 			  XA_ZERO_ENTRY, GFP_KERNEL);
@@ -3867,6 +3915,141 @@ int iommu_replace_group_handle(struct iommu_group *group,
 }
 EXPORT_SYMBOL_NS_GPL(iommu_replace_group_handle, "IOMMUFD_INTERNAL");
 
+/**
+ * iommu_dev_reset_prepare() - Block IOMMU to prepare for a device reset
+ * @dev: device that is going to enter a reset routine
+ *
+ * When certain device is entering a reset routine, it wants to block any IOMMU
+ * activity during the reset routine. This includes blocking any translation as
+ * well as cache invalidation (especially the device cache).
+ *
+ * This function attaches all RID/PASID of the device's to IOMMU_DOMAIN_BLOCKED
+ * allowing any blocked-domain-supporting IOMMU driver to pause translation and
+ * cahce invalidation, but leaves the software domain pointers intact so later
+ * the iommu_dev_reset_done() can restore everything.
+ *
+ * Return: 0 on success or negative error code if the preparation failed.
+ *
+ * Caller must use iommu_dev_reset_prepare() and iommu_dev_reset_done() together
+ * before/after the core-level reset routine, to unset the resetting_domain.
+ *
+ * These two functions are designed to be used by PCI reset functions that would
+ * not invoke any racy iommu_release_device(), since PCI sysfs node gets removed
+ * before it notifies with a BUS_NOTIFY_REMOVED_DEVICE. When using them in other
+ * case, callers must ensure there will be no racy iommu_release_device() call,
+ * which otherwise would UAF the dev->iommu_group pointer.
+ */
+int iommu_dev_reset_prepare(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+	unsigned long pasid;
+	void *entry;
+	int ret = 0;
+
+	if (!dev_has_iommu(dev))
+		return 0;
+
+	guard(mutex)(&group->mutex);
+
+	/*
+	 * Once the resetting_domain is set, any concurrent attachment to this
+	 * iommu_group will be rejected, which would break the attach routines
+	 * of the sibling devices in the same iommu_group. So, skip this case.
+	 */
+	if (dev_is_pci(dev)) {
+		struct group_device *gdev;
+
+		for_each_group_device(group, gdev) {
+			if (gdev->dev != dev)
+				return 0;
+		}
+	}
+
+	/* Re-entry is not allowed */
+	if (WARN_ON(group->resetting_domain))
+		return -EBUSY;
+
+	ret = __iommu_group_alloc_blocking_domain(group);
+	if (ret)
+		return ret;
+
+	/* Stage RID domain at blocking_domain while retaining group->domain */
+	if (group->domain != group->blocking_domain) {
+		ret = __iommu_attach_device(group->blocking_domain, dev,
+					    group->domain);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Stage PASID domains at blocking_domain while retaining pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		iommu_remove_dev_pasid(dev, pasid,
+				       pasid_array_entry_to_domain(entry));
+
+	group->resetting_domain = group->blocking_domain;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_dev_reset_prepare);
+
+/**
+ * iommu_dev_reset_done() - Restore IOMMU after a device reset is finished
+ * @dev: device that has finished a reset routine
+ *
+ * When certain device has finished a reset routine, it wants to restore its
+ * IOMMU activity, including new translation as well as cache invalidation, by
+ * re-attaching all RID/PASID of the device's back to the domains retained in
+ * the core-level structure.
+ *
+ * Caller must pair it with a successfully returned iommu_dev_reset_prepare().
+ *
+ * Note that, although unlikely, there is a risk that re-attaching domains might
+ * fail due to some unexpected happening like OOM.
+ */
+void iommu_dev_reset_done(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+	unsigned long pasid;
+	void *entry;
+
+	if (!dev_has_iommu(dev))
+		return;
+
+	guard(mutex)(&group->mutex);
+
+	/* iommu_dev_reset_prepare() was bypassed for the device */
+	if (!group->resetting_domain)
+		return;
+
+	/* iommu_dev_reset_prepare() was not successfully called */
+	if (WARN_ON(!group->blocking_domain))
+		return;
+
+	/* Re-attach RID domain back to group->domain */
+	if (group->domain != group->blocking_domain) {
+		WARN_ON(__iommu_attach_device(group->domain, dev,
+					      group->blocking_domain));
+	}
+
+	/*
+	 * Re-attach PASID domains back to the domains retained in pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		WARN_ON(__iommu_set_group_pasid(
+			pasid_array_entry_to_domain(entry), group, pasid,
+			group->blocking_domain));
+
+	group->resetting_domain = NULL;
+}
+EXPORT_SYMBOL_GPL(iommu_dev_reset_done);
+
 #if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
 /**
  * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
-- 
2.43.0


