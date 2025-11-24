Return-Path: <kvm+bounces-64381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86107C805B6
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D21D3AC0A6
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BEA302CD7;
	Mon, 24 Nov 2025 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Su06Dlf/"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D503019D2;
	Mon, 24 Nov 2025 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985587; cv=fail; b=argZBbSZWhWXlZWzvAIndtth5+COdTG6Wd5KzUd71+xiaa9tDemgVBkhgPfxWb92hVo0cZSISpeeQmfpXATMKBLEBLU1dZ7E/4gaKRKqxC7f7I7Jx/kLa7UxrGWC4Tm8JzLqlwIDgHfhtU1uMiEqAcllamvJs1j2e6NnEqByoUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985587; c=relaxed/simple;
	bh=3t4pi7rzHdERHTubBXnRtEoWXTDIusT4AE97Au28WY8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SgVETA+lt7/tbSJ5VbnmWMvs7M8IqhHvFlv13s4YF/yVbn5uEEPBGHbyiHTQz/wuiE4esZlIArm3BEDbUJ4Y5VmIIHnuLrNazYao3QCITlqmMWpd3oJ2oBIUIvqltN64kvQncqxOdSFMIiGi9ZgOFxPnxxqqcofnuOhxQGkE9Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Su06Dlf/; arc=fail smtp.client-ip=52.101.62.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mp8+YmegmBpgJvIdlovFO42vhXnn0G3ocxUNrC6/w9S980hG4zRPDmXad3wmvpPmoOKQ6P/i4PJRNM0MJi1Hbl6d4kgxyXDylY7y5122tt40i9G8qjCFoGaaJhV+LISWWPP0Pre8EszLL7QFtl+3SjdbrBgEHhg8SR/hLD8qSXCBjjGaPPcJWlbeMyz36X9vIQ9YYiQ35VIwgYcbJ5Pw2Oyioaiq8exz41ucrEmcx5JzhtHmaCLUVaOxGI7F1AlRaUAt10ZDlGljDBdr3UkmIQOImRb3ZUB+Eomks8KWkiM3UZuemYHSKHIZz8HRGjpg0Y8o1hoWaKodywbtGQFIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MCJOEkkzwklZS+x26XZEBa/NkUveUmPVttAnE5TTdc=;
 b=WFUZzQnpjtjoZHuvd2hB2vFN/b04Mzhx9UFTet/QKIQXxh/5FpBb/gVI/FKSKB4hudHvnNJw0F5K2cKScimNAmxD6R8cofHX0oWqVS6wOljm22GIe4puIW69FoUmcopQ3+CpB11NtVsjAGi39mTMQmZDHVXg06+L4cNiWa6iPELUbx9JoeAxfckAINQe3Pa+Zw58ccFUofRwO1+AAFG4Okql2G8FF2qKUqQc9yIrBTZKIYdIQn5vP98vLkscC78kthNLYq5Woqagk3l6wcczZIgc6/Ss/ifXvxzCEEPPOKKq7fMi1PVmmTO9iyWdGZ8o/SPj8OgKI+CF9/6VV7twkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MCJOEkkzwklZS+x26XZEBa/NkUveUmPVttAnE5TTdc=;
 b=Su06Dlf/oQRHF69BsiINvbtz/0UuVWt67BjT5qELQoNaF8Z5s1GN1djwdLTvgtzzeL0POyJ/eRJmdG1ZhpzMmQ5hCHTYPN7qmNTMrKkyvlmcc1pw8k6MxTUy3jcN8TrasuwtkuI6Gfs3AOGDhQ9fBAqAa8MLQUA+WM1uD+mrIt0oIUio0nuNWVBmSVwnf4qPpXmWWqL+IC8aAUUhNRvLTBd4WKCZBMMAuM5l8upvpIC/pAY4SMuqkRoJVvSle6BSYJ7DT7yj91sOUy8tPvJKWMYmUH7t/OgNnzbPqHXRTUaJVoRstSYhz6OXCgiaRyKlYJDpT/w1HrzHdLd1kGGx0w==
Received: from SJ0PR13CA0054.namprd13.prod.outlook.com (2603:10b6:a03:2c2::29)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:59:42 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::2) by SJ0PR13CA0054.outlook.office365.com
 (2603:10b6:a03:2c2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.9 via Frontend Transport; Mon,
 24 Nov 2025 11:59:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:31 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:31 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:30 -0800
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
Subject: [PATCH v5 6/7] vfio/nvgrace-gpu: Inform devmem unmapped after reset
Date: Mon, 24 Nov 2025 11:59:25 +0000
Message-ID: <20251124115926.119027-7-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251124115926.119027-1-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: 9782136a-6435-441a-eae9-08de2b50f385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LKxq1cfuuQ+twKxlBrIQ4FDTFmEphy3LqdcEKaOXaJyeLdsYgPs9q0yduigq?=
 =?us-ascii?Q?Jxz7Mc2CYwRBPfwz9a5CpnnZjVGltZ/3j0ZDbMaHqGSI19A+kLN+RttPrq9N?=
 =?us-ascii?Q?Qh0Q6POMIx1FYFp6rGU/at0D5uoQjElBSes9FYDzpt7kDEH8P4G2N0Mjy2sI?=
 =?us-ascii?Q?dgLGg51qe1V8CMpdVCJnnWtXvnz0vWZOJ7gwVqS9qKj1wzyH8qVp4FINGRqQ?=
 =?us-ascii?Q?l4fCh6Z0CvBJsE70/jkW5/LifOFNDvS79onfDpoPGsBpSVLLPX99OCBO15fZ?=
 =?us-ascii?Q?Ss/GPF0h4+ZB+Y2WeE0xq5hqTawJ9g87z60xBOj6neSceebOJdRr9s4fZnGX?=
 =?us-ascii?Q?sSshH85joND5dFdf7bJMku1yiXZXoGV2SrxRq7rTIO1wJsD1jLz7KnqMYFAx?=
 =?us-ascii?Q?T7aoz5KIT2yLWNZrlO9DCt8hOKmnjM4diypXQo9m0yVR+Oels4XYqXHGzflp?=
 =?us-ascii?Q?KlM9rEpbq1miP0N21yyxB6sVCfpvZEFPg0Ga7yZ+pK6gV359Rh9+RBYHf0FM?=
 =?us-ascii?Q?ObzWZ/zNmQb8+3VZFnaOL4rE7PdJywkDej+8gdYftLFdm+VszRqGDpN5SXhw?=
 =?us-ascii?Q?ueFpKptfn6yzEKxRXth0bGU/YKOGArBdPEosJsSzdCqdlFSVjyM4/EgiQlSn?=
 =?us-ascii?Q?8ZW7G4jhQwYZh3vkBktMma0MvQjNSQaAWRTxC/8Uo8Hr9Cq2/A+Inrd3mBKw?=
 =?us-ascii?Q?yk/hK2Gne2F836v9d9eNaoUqJsp23QLVwA6XtefoqPwGdG8SGS9Os/iV/3LO?=
 =?us-ascii?Q?BE3NnO+ay2ezNUO+dTTJ7OsK4gpBcmAI/ZHEYsC6lfTpuVpLsMlWrImynMZJ?=
 =?us-ascii?Q?MjUZGXtkCl7qJViORCtiHQBRkpnEAEukfydNQFxw8/dEJr0QDOS+oYBs7rMq?=
 =?us-ascii?Q?DS5H6herU5Qm20S8kUnpLG/TEGJhIn7wfwePo1fU0NcPDKzyLu+1rXLFVCXc?=
 =?us-ascii?Q?ngdh4UTWveLL2YOq8Hf9bIXHXbNXt4iRB6Etn3XI1l7MSMKZA6E/muihFMpY?=
 =?us-ascii?Q?ZQJBj96OIk0RncfTQNI4A0nw1JwhxAFXpsiuc3Z07DCpDyUNYczNIMpfSp1X?=
 =?us-ascii?Q?Qd1PmHxfpKFWf0XMfy1ReaF0biqJ80EPksIXzYn3LPvVF6aJnqI7l6UHAYfT?=
 =?us-ascii?Q?93HFiSIili8QF6XXTcVbdHvV1jlQ4Z8wygU8twXjo5GAzEmmhjtttT3wd0v/?=
 =?us-ascii?Q?aug8FydKHwjXm145RuPHAGqP48pZce08zU+z7E50kl06wBqY3tSB1y1iHlYm?=
 =?us-ascii?Q?y0NUvEHbH0PBI31lMahyXBefEQqjHNwRr3v8kCbRnpRtJAIGh7a7S7sigvsd?=
 =?us-ascii?Q?7DuJpPG/56ctrQzhNFzKBFhkAgOSuIW+t4zVGNE9GqkBdvQB8K4XgOWLaJqY?=
 =?us-ascii?Q?kLzuWewvk/kc5DSqxQJ+mXyHdqY4jOkKal1yjKsNIOaIBZ/2pywIRZOyCtrz?=
 =?us-ascii?Q?n1YEQMtI2p0L6V8YFnt6350rfq5R6z3lBWYah+IIoG67GlsuoXzrwkT5zWQa?=
 =?us-ascii?Q?o3ok7pl2jvMOgR2xDkwzjcW2x9k/Imw1hnetjRXBpR1rSeVbqK4531mXbiF+?=
 =?us-ascii?Q?oNYo3y5Ml0ZX4CnY8pg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:41.6032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9782136a-6435-441a-eae9-08de2b50f385
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new flag reset_done to notify that the GPU has just
been reset and the mapping to the GPU memory is zapped.

Implement the reset_done handler to set this new variable. It
will be used later in the patches to wait for the GPU memory
to be ready before doing any mapping or access.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 3e45b8bd1a89..bef9f25bf8f3 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
 	bool has_mig_hw_bug;
+	/* GPU has just been reset */
+	bool reset_done;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -1048,12 +1050,29 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
 
+static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+	struct nvgrace_gpu_pci_core_device *nvdev =
+		container_of(core_device, struct nvgrace_gpu_pci_core_device,
+			     core_device);
+
+	lockdep_assert_held_write(&core_device->memory_lock);
+
+	nvdev->reset_done = true;
+}
+
+static const struct pci_error_handlers nvgrace_gpu_vfio_pci_err_handlers = {
+	.reset_done = nvgrace_gpu_vfio_pci_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = nvgrace_gpu_vfio_pci_table,
 	.probe = nvgrace_gpu_probe,
 	.remove = nvgrace_gpu_remove,
-	.err_handler = &vfio_pci_core_err_handlers,
+	.err_handler = &nvgrace_gpu_vfio_pci_err_handlers,
 	.driver_managed_dma = true,
 };
 
-- 
2.34.1


