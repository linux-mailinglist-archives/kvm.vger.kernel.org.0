Return-Path: <kvm+bounces-11387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E935D876AAD
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 19:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 163901C219D4
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BF156478;
	Fri,  8 Mar 2024 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H8bVgrqJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B3B381D4;
	Fri,  8 Mar 2024 18:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709922136; cv=fail; b=WYgeXJedWMPr7aY1SA/ycMdfNF17qj/kPV067dh+s5I/77j8zmh9HHAcYMVEmw9NKElw3JWc6D/cue3P2ltUN7H366QcqiwHYQtxxHAnKwVNRYGeTXgPbMLZWjwWmbPZE5LEFoMTnbGkLdZiLNdyubJTrrFsCR89vA6DTH9M9e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709922136; c=relaxed/simple;
	bh=wODMZoemZDIarOXV+4nUMoVq//fHduAMOAm2BEXl/To=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bV0qlagzQuI8/Tv6k7C2Z15TX3SXriJSA0bjGdNl7k79DiO4uxgIXe9Sp1KgiifPBbCG0PhDfQTW77MJlF5cLDNjYlxqlDy3m1TLntPzeK9b/e7Fks7P9V9zvXxSgIvxbpiaMHgbaa+zjwpfudO6ieY9rJqqd/q9QFiq40rVOGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H8bVgrqJ; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbFT2NnGIaZbgIYUiPsPF1BzxVmB6VtGadWbzLa2pVQzcDh2lJJIxyzIraJItJta183aTjuiTpG/UnXXX7mcuqJsJ8SDwhlAEObAfiHzDeuOCEskMrW2x89bZGP5g44DgM0XuRReyB3jI1POXzrHVtKoRg0PA8peUNIYDL4Temoc4sZwQWXRw4RwKNUhuiVmA3dr2U1DTOROWLNjgex72L8KwlHnlv0TtzizlD16bDiB2JtnqURHftYo3jaXZffPiKnFhHdczf6hms2X2e93ewsXzLnRhvjRE1rKZD2jO5s4f6uOEREBurpcHB3CqyDpSI43Yy+D3DVJK/5p6cVS7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FNm4q114oYNBoi66ijue0FUqITklcsSS4X0AyxmoqA=;
 b=XtBI2YdwptGKpmyHpjJqiKxwBbCc2n2TKRxsRaQf8BwSrFM2JRjDcO+J8fyQO53HPR/9m57IMJqiCpg8UtCNxqB4vQh4E1Lqym52Yrmt7yN9PB6hzshhCaP89bR2pnMi424ra9NujdHAl82MERQqgYvXON6RPwoVPBQjoP2qlkgZD25U26rNndNCrZs6MmXjBmm4P52HhFDIACvau7iHSGznzH4ZZ/vnudq9d6L1lR4+crbilOXQsp4M2ZjoGPl82lGoQpJHRb0mqa5fjE8Z4d4+K3kFGL4WDnb8Ai1GHXhrC63BKqZzOcNWF1aP20fJ53wfLvlF+KfNUdbg97e05A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FNm4q114oYNBoi66ijue0FUqITklcsSS4X0AyxmoqA=;
 b=H8bVgrqJOyhUp4OFMhrzbTqp+y1UApI7lvzTuXExuzVu3xTVFzarT7u63R6NZuZdZAlNqFv0LaR1ubhsOAZXgA08I8616dbO0ngPUAsh1UsdczCr5tcB4n/GuSgvbdyy8+4PB+z0UChPbZY8OW2curESHNuzOSDunD7CLjBSmGc=
Received: from CY8PR22CA0012.namprd22.prod.outlook.com (2603:10b6:930:45::13)
 by CY8PR12MB8242.namprd12.prod.outlook.com (2603:10b6:930:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 18:22:12 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:45:cafe::44) by CY8PR22CA0012.outlook.office365.com
 (2603:10b6:930:45::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27 via Frontend
 Transport; Fri, 8 Mar 2024 18:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7362.11 via Frontend Transport; Fri, 8 Mar 2024 18:22:11 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 8 Mar
 2024 12:22:09 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 0/2] vfio/pds: Reset related fixes/improvements
Date: Fri, 8 Mar 2024 10:21:47 -0800
Message-ID: <20240308182149.22036-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|CY8PR12MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: b87d7d2f-b302-414e-4cdc-08dc3f9cac5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/AnaoHCIAL/vvY279N+ZjxXkUo5ikK/tw0J/vbeYacAvdKcmjt4ae7p7/7/VHmkjfa/ypvxIGBuvqs4uLf2Ln3af81zKMPRA7l2m1kCtNG1+ZjJPHi1+T3Vl5maa1V0AzLeiCIo+WvFuk0mFltLY48WtBaszWN3TJm1Ho98/9j2gVIU6b+zywn5ztdR/XODks8o39SGRkGkbsEVhaHkaXrcsICI9yv/NvSElDXf6qHjCp/WBXmkUKfG2S8lRSxwumffItFTyRzFpphtUM/d5SauSbmzVVaNAo+taHq8Zi7IABKz9mpV5BFQ9ERpOsmag9d+fGtVnTpwioeQniyyen/GdWwnnjLB2v/C3svno+r8tLPbgkVlN+YZKnAzPEnWrp8sDhBY6Rl63vOa+E4fafhGdO0TesHnl3jQTAFjNhUh82dHpqQjo2yXxqe1gz5YR1I+GWEYTBimohQ3NX47CVaTgdK5yDfMhtOrkOiNifHkq73stK6E4/4N/Uk76RSe2bVTCzK1iqJ6nQatNnSCWmfxx7KcPH1JkyTINi+iRY635U/c2sQp9vzgw5Hc7F6c72QjtyMoF8pB/tcp5hc2aLj9scTxs9QpJVhA9ef/4O4R52keWieb2YcOvfAYmZoHPqP6rXjerCnWLIDcDngUEO7GwXdyc6h2WapnstwqZZJgufVKpRKVj24xnYxyXHTKvff+Tq0z8q9A7OMVmdPYnqQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 18:22:11.7786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b87d7d2f-b302-414e-4cdc-08dc3f9cac5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8242

This mini-series adds a fix for a patch that was recently accepted that
I missed during initial testing. The link can be found here:
https://lore.kernel.org/kvm/20240228003205.47311-2-brett.creeley@amd.com/

Also, remove the unnecessary deferred reset logic.

Brett Creeley (2):
  vfio/pds: Make sure migration file isn't accessed after reset
  vfio/pds: Refactor/simplify reset logic

 drivers/vfio/pci/pds/dirty.c    |  6 ++---
 drivers/vfio/pci/pds/lm.c       | 13 ++++++++++
 drivers/vfio/pci/pds/lm.h       |  1 +
 drivers/vfio/pci/pds/pci_drv.c  | 27 ++++----------------
 drivers/vfio/pci/pds/vfio_dev.c | 45 +++++++--------------------------
 drivers/vfio/pci/pds/vfio_dev.h |  8 ++----
 6 files changed, 33 insertions(+), 67 deletions(-)

-- 
2.17.1


