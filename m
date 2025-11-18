Return-Path: <kvm+bounces-63511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32750C68095
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 1B52D2A189
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392C63081D0;
	Tue, 18 Nov 2025 07:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dn6kQNHt"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F0E30648F;
	Tue, 18 Nov 2025 07:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451891; cv=fail; b=mIA7NsnfGg+/+omKSV1GLETgbW9MhRY4wSCR+8UzD0K0sZmV/weS9oh72JPjIXENfSaYIUQVUzZl76KT0GS96l/6w2dk3Qy96cmQsY2eMzJbA5NqmVQfl1v0+io4d6E4MX6dDlN0R6v4h6iyQ3ixd7+Ojft4UnzfGC0BNrCfnOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451891; c=relaxed/simple;
	bh=VyLM6liVDQC9hlNtzFGPHAIgjHrZHTpyKsBlehu8CTc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyovqr5S8gqM9J1XWapQ1Wtfw8d5jqGiG3yItMcr+eJGLUFEVsTTsk1kmfnkEE+y7YrL6nK/qyb+PYC046/2xLQbuDE+6hfJZDIJxa1k5rdOmDdoacyp+Xg5/TL4CR7QaPBpypIQPqTIpd2NQOFEVhieE5+XUi0tIe2UbkfvtMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dn6kQNHt; arc=fail smtp.client-ip=52.101.56.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=igyysJ2MsG7om+ki1vgwi56XiOXVHauwYw6jZijZp66sUvYnRqpRHJdQT2BWdLkIbbjW3CqFFwmIgLjSuNGPFGJXGHhRiKN9H1HAeNM+sS+Cq3ydiTcOhoZZzQCayd3oeIZLyq1bVePsh1TFbYRpJV0ZVHKapV1Y+Wb3SM6bGfTQu+HErWy6KVYFt5GEP+Y7q5u0csf0uTn3Ec9f0nqq4nVtsS711cyzqvzQzxzr0b4TxBR/H+Cw4cjY6LXDLvg8mhBbhyDQg5/uFc+X5KeUOax6l8Fq5fZ83+rTarDkw/jZh8TVmd3C3eaUU/Gr7h08U+Aw+EQ+L4z/XOvj3D4VEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tpAxSuayLF9nR1BoJltoWgKnaT5kvM4z8pn3GvDtJc=;
 b=M/iU55Q1gZcAAbNMs+3BDqh51PxYlKAVARkpqzOYg4ansY/JxO95QJ8ekBgF7CEe/V+/popvUtPq26i1ul6KiiQPk4NqDlQYra/jJShmlBU3d8jM2s0p1cpsHHZS/9PNA1rZezD87jRoqLW9mnMH4yQQlajMqZvAm2kW2rg5V5PEzC29cYHUfzJCUw77sepvElADbrW2J5h5B56oT3eAs4M5eFdpQKv5IeXO8Mp6ejJm+6CmltdzcpJdNAU3PbfVLGbVJUwWBWZFRJmwfQi6TXu1c35xwI8pWSJC+jzuFFD602ThIQqC2bjYcEyOVapkurcpy1I/NELQz0BVmamAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tpAxSuayLF9nR1BoJltoWgKnaT5kvM4z8pn3GvDtJc=;
 b=dn6kQNHtuRVgShUUThUPzp4gpZkeF/YOgpm70P0EP3BgDkrPERuOna/qLYvKlqGxM4uurebE+2JeGFHLfDwBCg6z6u0egN2uowZzvy9MpIaSuFEzla0fFxlTIJBUx2i4e73wSDPLjNfBGpHl7zAwMQ6Q8WgQ+0i+PQeerVvM6Q6Exvs2J01Z5GSD7kabUOgCn8nwDFsJX0GJZpuHng4aTyQ8iuALfWfRo5heTydUUTrqn24aP/qipKNNrLFqaAp86+QGpy0mUstS8SBLKjAl4Gcjrkf2QBQrl5heZ1NC2Vn2gACUESgwmX6j+QIEDvWu/aZjEbjiEOdNz9UHlY+X3g==
Received: from SN1PR12CA0071.namprd12.prod.outlook.com (2603:10b6:802:20::42)
 by LV9PR12MB9832.namprd12.prod.outlook.com (2603:10b6:408:2f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:44:45 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:802:20:cafe::3e) by SN1PR12CA0071.outlook.office365.com
 (2603:10b6:802:20::42) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Tue,
 18 Nov 2025 07:44:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:27 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:27 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:26 -0800
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
Subject: [PATCH v2 5/6] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Tue, 18 Nov 2025 07:44:21 +0000
Message-ID: <20251118074422.58081-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118074422.58081-1-ankita@nvidia.com>
References: <20251118074422.58081-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|LV9PR12MB9832:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df8b389-5190-4225-81a9-08de26765756
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F6rjPf9IUwLZHlilYllE0KzW89qotzO5zr1Tfx01d+mhq8v505DjeNFtCiYV?=
 =?us-ascii?Q?cc6g2kquw1oHHYxZJAjJ1W+70kyF+m2mmxMTLGy+ue/WjVbnfhGYsEoFPzKc?=
 =?us-ascii?Q?eTHISxkh16vr66051JuW+TXkoP7YHSh1yWNg9L2Az4MiMnd9H3oTI9xtQuQg?=
 =?us-ascii?Q?g/MASSnmIX1DnpUEpPH/kIBOhm0pgTaDHqzFDCi1/tIOeYWh6mmbc+n+Zp65?=
 =?us-ascii?Q?PTm2cvBhT8UnaxJsektA3Xv5IJ97RCMUWXOnfVPCqaQP6uE/BUJaK8zau+rU?=
 =?us-ascii?Q?7ihFzXWZ10jeA8YXygxG+wjIXIx6iZilHDgc5kjUaWPZSRZWWPjNwQXylnKn?=
 =?us-ascii?Q?ARW6dwiXuFcuj/1B3RmIQ5xTIEr5XGoXmtR4Cx4RO8F0pMrFrrfSNEkwXxZe?=
 =?us-ascii?Q?8VZzFbTOWAMcYiAzPqLsPn1M/lpgi7hnxvom1dfYTLagEf9dl25EZpyyZjlf?=
 =?us-ascii?Q?JGyVQHt8wPaRYQPmgk1xHNhVl4g64nceLiC1FAtMOiYGwDOpCksxY2dRh8vu?=
 =?us-ascii?Q?AUu8hIcRy4A1ycbMiA1t7QGlUIFiHqabWyNBFrd5pPSyipybQoinj4YNivDW?=
 =?us-ascii?Q?aTYNLlZAHyT/oJVjQ0jN+pxq2Pf9RIblMbKE234VN7QTFIrgJdld6Xps3/Ce?=
 =?us-ascii?Q?QDqAPc5EMaXYQe7okI1oeMMA+sAGjnwd3Av8r/9LVvQ8a37du+kxgRPnVGs/?=
 =?us-ascii?Q?IEEOqUEPTytdtTJtIuv2pi/Fcwz9ckz9Pds2nQWG6akw1IFDEvR6z/EA6HPv?=
 =?us-ascii?Q?nQaALpDj7edOPnl0ph2hajVzFcvMItiWASKKgXsnE5xlKtVx3iB7F33ZjoRr?=
 =?us-ascii?Q?D/YufH0uH1qmiJBYd51YKqV+mcdj7e7VUspawMPsKHxVKzbrFgYkldRPox5m?=
 =?us-ascii?Q?QNL2l783QNHXz6TQhHRP1Xq2/A5r0miZON7caknBjLBoaL/IXCjoH1TyWJML?=
 =?us-ascii?Q?Br2mUTAH5sJGX8A5FNTGSTTRaf9UrBLm2m3kNgqjnkyPt1Pr4NFDCXEgIDXL?=
 =?us-ascii?Q?lxPXbnLWw7iTshvc8l1m2JgOKV5K5Dw78L+Gf+D2ekDPx5Riovs+sjjViMII?=
 =?us-ascii?Q?BQXfiFCBxKKk/DL4WRP4D9raCiG/FNXpZpIs8xHnrQj8GmskYdCV+WieO/ki?=
 =?us-ascii?Q?HYpD/pBfR9qjlsgtJ+tbdQsLQay+abrAIdyaI5tXdRzTzpNI+Cy6ChNBj1DU?=
 =?us-ascii?Q?4aMbpwsFuX0aT4yQqK8Y1N+RlcI7n8lhwp5HZwF4vnXfj4mElosLMxVlGXIu?=
 =?us-ascii?Q?z2TvOUAzn8uQMvsARjcE8jx+Nv4LMH513XDTJF3Tqt/fWaHk+Oyvq1N/EI8z?=
 =?us-ascii?Q?27ew6i1RiDH0Bw9sQzdIWe2xA1jLoUlFL+VkZTOLvMSeOrWIqHcRing6gqHc?=
 =?us-ascii?Q?8zshoxae/ggF6hMCfBoBcs3Qm6RN/qaWj3qGH9sEhgpV74JnQJDm/awneeyy?=
 =?us-ascii?Q?r9kphnLNrsblQPZohrHsqevBtXXrGcuXEqlJ+SQIJzaDPjy8Y9ssqAJkcfDZ?=
 =?us-ascii?Q?UOvt1pGBRKDyGoKivCtX19RpcQgN4ap3WKfR7PTtLsmibpHuneC1mHAmsR0A?=
 =?us-ascii?Q?iRTfn9xeZ0rBdmgghDw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:44.5067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df8b389-5190-4225-81a9-08de26765756
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9832

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 33 ++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 3883a9de170f..7618c3f515cc 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,24 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static int nvgrace_gpu_wait_device_ready(void __iomem *io)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	int ret = -ETIME;
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			ret = 0;
+			goto ready_check_exit;
+		}
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+ready_check_exit:
+	return ret;
+}
+
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 						  unsigned int order)
 {
@@ -931,9 +949,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
 	int ret = -ETIME;
 
@@ -951,16 +968,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
 		goto iomap_exit;
 	}
 
-	do {
-		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
-		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
-			ret = 0;
-			goto reg_check_exit;
-		}
-		msleep(POLL_QUANTUM_MS);
-	} while (!time_after(jiffies, timeout));
+	ret = nvgrace_gpu_wait_device_ready(io);
 
-reg_check_exit:
 	pci_iounmap(pdev, io);
 iomap_exit:
 	pci_release_selected_regions(pdev, 1 << 0);
@@ -977,7 +986,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


