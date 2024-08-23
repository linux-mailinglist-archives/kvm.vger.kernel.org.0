Return-Path: <kvm+bounces-24902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D802495CDC8
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:29:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 620BF281FAA
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35701186E3E;
	Fri, 23 Aug 2024 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ojApKVkz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03511186E20;
	Fri, 23 Aug 2024 13:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419732; cv=fail; b=Z2IBCOe65ffuIbXpm8RM6m3PEVn1FgPMKVp5t5V5zkgxqO6RSVti5LfZZqFmKYnx/6G44wFSWun1ruEfHfA4Do8sxl25K2i41SDJEzAnpRuSrSsvDKw9Y0liEAQnp0IrIL6KMCVFU+JOajEV6NXVtCYMoq+IpBdQ6FOn2iSfRe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419732; c=relaxed/simple;
	bh=WGjp8B11e3jQc3W7BZAy8/Han9bbmUjy0cuZNlHsKlc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAnIO+BF2G/nYsKA1XY6L/lfgEiXmslaZAanh7ImZqB8EtiO3Oiwz3hNBpXyWayqRbTQktTjhVtyND184qIPgKzIlnlz1uCduRqlCNBGPdbP8aY6qY3NNywm/zxEb4u8bN1fdqKDSqWObrfrXpjnCwv8wsFT0t59r+gIeYXZ9kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ojApKVkz; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGEGUtZhjUFiNFBODklm+hjfoLNTcTPSgVN6b9gl7V1Ddf3qpOI9NzBog6F4L/xk5/V5l7ecjAVv5LoHuvtVQbdvSBCzYY6R7HI9Cxj58JMl0BjGllPqAQUyZ/O/SsUDjODnQdGQ9kMbuTQSFboTeTHvNKJF0l7kqJPOohPBhmY0lA8lcrqLw4WZNJIbO9mFCfEXHDdvFZpQ6Z+TWNM5c6LrJieHi4RJ9RPBFm5rUQo+XLKi9q2CMVXblEdTzdKA8tdIbFhU4Gzz7gO+YIdi6xewSOZV+FNlPy1MIshPQgnEuVDn6L0R+N/h3/HRd8uyi9zPXL02QEELltybl2Um0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93VYtRsZiQs6TMdHW8fkIg92dTcAvuyPf0Axhy+ubFI=;
 b=ak8Ab3ybe2/ni6jTcOTSrmkEt33iUtqm2NfEs2/bp0WV4XZLNTaU9Ipv5SZCp15h486QZ8eOYDpsfDy87sbnSj5RMPYP7BmedIwDmjYvTN5cvMYGIwxFLVS7FOeO3db2XW3GA/+kIGQGa/bPtQW+VjuBTNLNSwbmk+ktwjn1M2wPXJZWGuOrq9mpE/I1MN4JKUEUjfbNOKOzTiNr6ten8bwR3rXAmh6R5S82dS5K2S/j+0FpjQSfpfK5FcaCPUisflrTxRG2gogFgGuvYHVJyXsPcC0LigC0NbZenpk+//mORxKciDhhkJGRx8dgne8J+OK4cVNTxM35FcUOVi4Fbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93VYtRsZiQs6TMdHW8fkIg92dTcAvuyPf0Axhy+ubFI=;
 b=ojApKVkzRKDvhepLaA4e+LabpTsZxWfpexnMItucqav18glo6kMNmNQLx3DheAUthwsH9+YUod/doWZhix6LmamGiSqWccQdIHd60TVEwhi1yPpbFGs73yZogHMJ7ThvLihtV3NGtN7ePPPijoon7pjEq0VCvGKOI6Rh81IJMrs=
Received: from CH0PR04CA0062.namprd04.prod.outlook.com (2603:10b6:610:74::7)
 by SA3PR12MB8762.namprd12.prod.outlook.com (2603:10b6:806:31f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:28:47 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::72) by CH0PR04CA0062.outlook.office365.com
 (2603:10b6:610:74::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:28:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:28:47 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:28:41 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 05/21] crypto/ccp: Make some SEV helpers public
Date: Fri, 23 Aug 2024 23:21:19 +1000
Message-ID: <20240823132137.336874-6-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|SA3PR12MB8762:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dcb84b1-dd0d-455a-7840-08dcc37784d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kQa+VGFQkeE3TYo92KhbYtFSi94dhLkNdGmIKsXDpz3DRXIsK9L0+D6jr6ma?=
 =?us-ascii?Q?etCW0cRTUfHaBzGT4KduDJKP4CPvFVol8XGI17KtMSuMN1Ecs0Q1EmZit6SO?=
 =?us-ascii?Q?9TH3o55B9R3VonbWsiNpMJ7K/odb8X8Yy79c/dFyeBuWhFwMzMu2Tgegq7Dv?=
 =?us-ascii?Q?BvaWU6Qz6bP/QyqWV753TCJ6tE1WMt275SplMrcT/GXmi/8ntiTM98j/kqpL?=
 =?us-ascii?Q?gBEI2dNZMtqnDW8nhbtAgqI7AtKQ1wlzrYZulJ2kqt/E/YJ3WpZKGblz9oEX?=
 =?us-ascii?Q?CcpZvpk31JBhCfnP2HK8boJpReQk+wtOabPIapDT2SDc62jt2vpya7BUUYB2?=
 =?us-ascii?Q?0tUvy9dfRBixq6zrlunsAzTg3/8MekTByp9gmmQWr/b9LzP/hCqzMp5x+Q/u?=
 =?us-ascii?Q?C4gR9/dISoxaGJ22XzB7xf1J1z0/d1qDs/ANsqCGkSnMZuHz7inHplYRkAoB?=
 =?us-ascii?Q?qAnN7vgc6YGBdxeWbraXQWgdseVPekXTgBSCJ5u1qYx/5via0nQ7cNwWqvpi?=
 =?us-ascii?Q?YJ6us9sI0D5DyUfdzg4KaZo+0wgcsH+ZQkmkRKs+cn82VObTffx/02bWA9Re?=
 =?us-ascii?Q?3drTGAVlRqHExRZp/eeYRcEgw890PhSn34rSt6K8tcxJlWWkjt1F3F0/lkAs?=
 =?us-ascii?Q?x/hXGUtHKw7aXjIeQmjWyI5Z+B2YZChnLPM4lSTYuZ9BjonH/VF98QfnZG5P?=
 =?us-ascii?Q?5FAHyvlXbewBJUZ3PdeSYzK5YValMS7BTUUX/NToVhwxy2y3ZGyRgrnm/TcD?=
 =?us-ascii?Q?xITxvsmjBAxrHzkDgmoSfAbgtQZmrUHZ5FjdMK15ixgwT5LZnnuC4toXPQeI?=
 =?us-ascii?Q?noP4HFaMrdp4p2kENkDtadUbd9Oxxp87H8Wpo7FxrcIWIG6gGUD/SmDTz+Lc?=
 =?us-ascii?Q?R49HS/qF56qVe2nnJwtcTH8It71C3FGBpV7HrE/aJnGLMIrcCt66YP88jIS6?=
 =?us-ascii?Q?8MTIN7AVRFCeLUZ/9arsu9mPU3H1X2aKfY9nL441Fgw5I7sl0qyaJ78H/xDz?=
 =?us-ascii?Q?449e5SQrfJ9HJHL15MHS8cPc8XbwwyKVsMcRIEUIiiXEhTJHmG7opXZrMVZV?=
 =?us-ascii?Q?4nT7rVoseXxCkQGuEmDCQ060nHn+duez7Ob6+eQWXR689rQE3Fe0pEF8TLyD?=
 =?us-ascii?Q?K7TV1omMy8nTRqGGneNJpBZNHAmqow85ys8krrwKGB1r5wKFdwo4dHv8PGiM?=
 =?us-ascii?Q?WGHUf3hg6BC57mpS8GSZpw/MAlGVpmpz47Z7T7prZ0FahLtI2VA9tePDjM+K?=
 =?us-ascii?Q?n8T+zV8WkVG3ue+AKB51VOFNEfMz0dskICbU9cMbYjelTDTuLeggRyLnFhsf?=
 =?us-ascii?Q?yC7ebGFvjyd7OjGQeQAw57P5IpGU0+V9FkReyF3nVeZw4e85xpGsdDcW0DZB?=
 =?us-ascii?Q?ZBvjUYsYZ78dhrqg7RnhGFUdJJtxwXd0v32CwIti++Dtlcw6Z7ywRGJes0mv?=
 =?us-ascii?Q?XTpRbbGYpaWgesQawawIRMkuwB9rNAwG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:28:47.5977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcb84b1-dd0d-455a-7840-08dcc37784d8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8762

For SEV TIO.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev.h | 2 ++
 include/linux/psp-sev.h      | 1 +
 drivers/crypto/ccp/sev-dev.c | 4 ++--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..59842157e9d1 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -65,4 +65,6 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+bool sev_version_greater_or_equal(u8 maj, u8 min);
+
 #endif /* __SEV_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..52d5ee101d3a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -945,6 +945,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
+int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 82549ff1d4a9..f6eafde584d9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -109,7 +109,7 @@ static void *sev_init_ex_buffer;
  */
 static struct sev_data_range_list *snp_range_list;
 
-static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
+bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
 
@@ -365,7 +365,7 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
  */
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
 
-static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
+int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
 {
 	int ret, err, i;
 
-- 
2.45.2


