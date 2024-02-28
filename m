Return-Path: <kvm+bounces-10173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC90486A481
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93EC32847AD
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E0E15AF;
	Wed, 28 Feb 2024 00:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vwoby5bU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B3B36D;
	Wed, 28 Feb 2024 00:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709080348; cv=fail; b=mIBhReghhUR0sE2vPQcifCh+stTM1l20PiuqwIgNlh5WCpZ3gLsxvS13wW/xM2aCkpnN+jFwVnkl5/FhvWtYuz2X6dpAvajUyBW05dJyVslCI9GRVEOKDVkWDk8ImVmfciWKlxgYVoJMPCYnlfOSSzN0LdiLQQRO3DRBYuxM3sE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709080348; c=relaxed/simple;
	bh=04crYxxA8yx0KXUQq9CPGUsc2Rb/B4CN3Yh36ZOy6V0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/E/WluctLGtbCTVKdSyEE9Nr4uoHPxP75OTDtHxaIt6Gfoyhda4/R7OnRppd7crlYlTOun0XpBFSxWwi8715GzsnIGtO4t+LiplKtNMJbsDRjvwkWstfm2glGnsTGTehnJi7x92yLbML9U89x/FTL25hatgyveecRPRfwjLA4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vwoby5bU; arc=fail smtp.client-ip=40.107.220.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ki3c1KRH0x3s0vgK8dgBPJVJ3SyuQ4ilxm2A9Gu883kzVIKnODb6CeFsVYBbhl2af5xfRF4L26eGQgvZA7X5aaWjqcDTVtz6DsxKc90GiaPreTdmfc509qTKMUFeYug8NTc0Y/geX16nfEvqJ5trgDBV7CZhvqhTUY0A1NrbASgeXKih0ID9wjcXwXz1Dc5JqQgikmRWBulHoXE3YmW3fFyeIX0T/w23/z6KdMAakDiCrO682kA6Cm5LdjsRFWNHSknoLtMj5keIiuRNMYXAeHEw72GiX1AIRjaCOBNtGJ1NZsiE+Ln0aNLw5mcIECmfU2wgx0trqukRcSWWPGWwIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFTi1v3imxhCyek6/WfUKUpku6ct66CU+XUsMrHwZMM=;
 b=cVeVboID2579P86P1F4JQskGkk8VRYy4ztWzueF9q6MKs3lSWAQ7hX0+0G3vdcvotWm5/kzA9W/W2VqZUYLd41lI29kn9bOTwDS1wixVWQRUGvT7p5lyqkazpWrsWECuJi8+tdCHVc3ZG7Fvq4zBTImyoAwW47WlUqe6CG5Dv3v7VF8h9wh0eFVlH8icS/RDrgCrtrdU+ABvfyW5loWyaXKoXd92yvZzpGSlwp8a/hECfgpsv3lMRUrFD0NODXqYUauH5Ow9FgjxAXky4ndrB9FVe2F9VrF96+3pkoGM+ImdawUgc5x3fq/olg77p9dJXURGiRflaWwkYwIB+2wJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFTi1v3imxhCyek6/WfUKUpku6ct66CU+XUsMrHwZMM=;
 b=Vwoby5bUWZZ4xbbtqlNDgUqBfA7UV38havHR5Bejm6mgWERctOKJz8vwMBDiMvuVrjZM22ePmpoT34gWPM07l6k0zB3OAiC0uOZ/wJGCZ/sHHIgX7TA/w7tP/+roX8pUuXF3PE2f3E37TbHcCTWMgyZLpnwq+gjc578biinQ248=
Received: from SJ0PR05CA0031.namprd05.prod.outlook.com (2603:10b6:a03:33f::6)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Wed, 28 Feb
 2024 00:32:24 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::52) by SJ0PR05CA0031.outlook.office365.com
 (2603:10b6:a03:33f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.27 via Frontend
 Transport; Wed, 28 Feb 2024 00:32:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Wed, 28 Feb 2024 00:32:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 27 Feb
 2024 18:32:22 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2 vfio 1/2] vfio/pds: Always clear the save/restore FDs on reset
Date: Tue, 27 Feb 2024 16:32:04 -0800
Message-ID: <20240228003205.47311-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240228003205.47311-1-brett.creeley@amd.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: d5a8086e-6f0c-4490-d1ed-08dc37f4bb8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F+TbxPeKXbJFTgjH1S+H+Fb9w7rZflP1KXE9sq9kR/QtbCqG56K00x482YDUytj23BmwdNaHKm3eEcYtheTfY5a1PNzagvWasEFSoA7ScwRAHFx1J6QUaPvLZjZdQqYMCm3U3YyjHueV8V896oYPJsbPjZlxsJLSFuw6wfE+BIpH/q2rt+izwd6nM5t7oGPUWiW0mAfEGNL7ftfzkj6QA3R9LqcKstWQcuxurBK63bTWFw+sHPbIk80ECzciKd3PNE53lmo0LHsTJcXlZxPU43gDRRWjcbYKqfK1rGeuVg/o0O/Qeiz7iqz4w3MhkuBPNlb2bJwjHnJ4UD11l+TldDLCf12LQktdIK+lc3QtTqMHEp3dTZlHpcg9bsjzq39rxsHNlKtEH0I2dNZkmO9CQ5WmAOgX/ddnB1KyarCs+/Slzr7eY8zvVzytnHroylKI9QLUYd4JzCwzuTfYcPQ1dSfeTdCRp/ol0ZpHi61TSyJ9wkCc5x+LkWSCi7Y2Zg7fkCcwFoFI7j0RjnwNULRlJn8G4OlZnphOhdN8HoVyOD0h7wvw6QJJzmUbQAEGnlaozHJMMCA+pbv0UZC8ZXPdLGNwARrtl4yhk4+KuvQPi1m/JPE9dl4CzCMi5MEuz7o2RJ+RhRO7SCeQALEexr79N83ameFvP2NWA3jNe6OHtPuRwrbbBHMMTLm9yw8Oetud9X8DGy5i9BQellbdpW0xhzj85nTWaHhDAJlUxy7QN0zF/slfU5B6BGOukJtZWrhc
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 00:32:23.6165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a8086e-6f0c-4490-d1ed-08dc37f4bb8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

After reset the VFIO device state will always be put in
VFIO_DEVICE_STATE_RUNNING, but the save/restore files will only be
cleared if the previous state was VFIO_DEVICE_STATE_ERROR. This
can/will cause the restore/save files to be leaked if/when the
migration state machine transitions through the states that
re-allocates these files. Fix this by always clearing the
restore/save files for resets.

Fixes: 7dabb1bcd177 ("vfio/pds: Add support for firmware recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 4c351c59d05a..a286ebcc7112 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -32,9 +32,9 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	mutex_lock(&pds_vfio->reset_mutex);
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
+		pds_vfio_put_restore_file(pds_vfio);
+		pds_vfio_put_save_file(pds_vfio);
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio_put_restore_file(pds_vfio);
-			pds_vfio_put_save_file(pds_vfio);
 			pds_vfio_dirty_disable(pds_vfio, false);
 		}
 		pds_vfio->state = pds_vfio->deferred_reset_state;
-- 
2.17.1


