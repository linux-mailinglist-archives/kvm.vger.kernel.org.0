Return-Path: <kvm+bounces-13022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4578902E6
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37F061F277A6
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9B012F384;
	Thu, 28 Mar 2024 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wRIeLC6g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E7083A1C
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711639295; cv=fail; b=ci5FS5+TzeLrwhytKbPbb2TGv0aPHDCnkzQvCuonbBcGY+XhgzY7JZTwWG6U4DhH0mChyYHTIiJN3vHT5OGxlWaJ+ohIxCP09Zp2xxrx2S5ri/Cz0n1tDp3BiQdRzpmoiprrfLTP3bhXsZ+cM8nYbz7Gz+AAbFYGx1m0cykY//E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711639295; c=relaxed/simple;
	bh=xIq1010nD5STKgYxdg/nDepitNATS45035y5uV1dtd0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5V16OyLD7U5Ey5BiWAvHdKTmvtW9aHUkfcN4TvResQjnQVHPzakCRGFD+3cUo3K5A0hNc363Gm9bBJxgTvOAtgnwJs4rcKrE1/8HHSRiZD8deYbC0e+9VZH9zGL4W5GW5QBXrrKDu1SZXeo0XlcXD6rdlYl1++HnuLjLKqKiFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wRIeLC6g; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0DY0iPbHZtLWK5H1Ec2Sx9RmOOUzoJRXcs9LGwP6M5LtHQwTuoyiNFtv0yAvzzktg+77lBFxnLxp8ejdQB5qEjGeVhiHPmblJpAXwIViSlgb/vbcjZCr3x4GSlGvl88LDJdON+x6KK1ImuPbA2FsQ/nx8WrILujgRluHMcqrbiKPvRhY9NjuI1OKNUbCzQxwDZhMl0rA8q7s2WUZi8JBW2TRBmx8XaW01YEroDrL2ij64xZLOVA+59fYXm0Xae8KlHtXNU1fQzWHrzGlcorsdc3PnASmD1c4yUnV34DWTtklQ/CQ16hRMtBfMT4gdWk/n8Vr08FzNqoq0SpLBxRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nht1mymGFfETQEkHOgtEtM9Fz5HHlTezkZW8HwK3BkE=;
 b=ETo+1fUVwgXONJ/xXO1T/SngGEQRT8w1orX/pK37yFeYLAB6wk5gjHR6EsOEVriOsI/3YgFKhy1k0i9HYJxtLwqUQ+6iSD+ta2znAPUFH+dpMyueAVKrzFjxS9q4U6GKy9sUmXOq+vMk0fVfqUpKGBDyDy7ALy9KLgbrSwIZULJcPnf+CiFMBNZo2tjgVTCVifbyXxeNGlWX5wCfyKgg02g6PCYFl0oixgXHqkIBe7arDs8EMuAmE0jtDKiHsVTfqKDeQRbpF0WHClkYymnO9jAMGmEtQEq/dYv7o9EYznC6+zFt6a81onYQWhM0J0fj3PYUnezZ/D+HpEMzQzdOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nht1mymGFfETQEkHOgtEtM9Fz5HHlTezkZW8HwK3BkE=;
 b=wRIeLC6gGsYZg40pv6QQG3/dsQlxvZ6HP839+MHIMJzARtfarX8ucRel9eC3mPowWuflTo2rP52gGC87nkPXZ1eBJvxU3FS4Nv5SofqVW0aiIM0LHEV5kuOxeL5BQxIZGeFWzpFXMMIhBbIXXUyly0iPttGlMPUX2rnirvQpNKs=
Received: from CH0PR03CA0269.namprd03.prod.outlook.com (2603:10b6:610:e5::34)
 by MN2PR12MB4191.namprd12.prod.outlook.com (2603:10b6:208:1d3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 15:21:31 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::4b) by CH0PR03CA0269.outlook.office365.com
 (2603:10b6:610:e5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19 via Frontend
 Transport; Thu, 28 Mar 2024 15:21:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 28 Mar 2024 15:21:31 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 28 Mar
 2024 10:21:30 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, Pavan Kumar Paluri
	<papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v3 2/4] x86/efi: Retry call to efi exit boot services
Date: Thu, 28 Mar 2024 10:21:10 -0500
Message-ID: <20240328152112.800177-2-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240328152112.800177-1-papaluri@amd.com>
References: <20240328152112.800177-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|MN2PR12MB4191:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d84e0c2-a3b4-4406-81ec-08dc4f3abf09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	R+guLkDhvKnnVxBOnKvtgKe23Jogm+oHNpuvVgIOnZsGFdDRZgewDuhuLFTK/itBWHy58eme/bhPqkkZXURXulaF3J5fgiIJlNYDSnFm557aczUVKK9S2VSh5rRLgk6lX+zKZnuQQiYpoqDfUiNdNFkt/JeFt0Be4sLMDjRvtRPs15AR2KJd3CsTzD224gGDrjfTjKBnIbDF5ogsmYuhp6LwXpokjbjLYwYe9mhwmpNgtS7M5wWCSkjESEjYF3/KxWDwW4bCYvzRoQMy3Zf4ekvWrjiIY3XYG9pmQQ212rxlEbHbQ2SODMkNtUPnTKWFU+Exjof/jm3pzXnsID3gvPYLaV0F0sC9MZUxd9h3OUQUCRwkUHptM7AQmRoPMPfMHjnKo024r3wHu/VUFPbEShp/KEaHY1Dk2qPb/CnvXxpJ7NJHzubX0tXkJSL0BR3hOWEW3PPDHkA/JNNBjCIzOY2NaxyCMsZafWqh/gSFeLix7cwnL2/eeMzYS4BGvcCYIy8gG+GUKaU7FAtUqEs1AHoVMWHf8C7KZkY3J+bgdjgZcNyoWNMmR7hATcNM1YERdUYIDKn49Pk5g4SeMy82Vx44aDslhDM+ACT1FvBku0qgZFrX2aGzmGjNn2QDDvqdcLoHEvWSFh38uSqmGfRJP+WPS4R/kCTZfxgHL70yXvoPWhIp9I9doeHd5kHK0ThmOzlTFYFtgs0msgEDejTKE5VqKpl83rrvQ2oQUEYQgMoQUxpK7Hhdlg2AAsTxBpyb
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 15:21:31.0911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d84e0c2-a3b4-4406-81ec-08dc4f3abf09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4191

In some cases, KUT guest might fail to exit boot services due to a
possible memory map update that might have taken place between
efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
to keep trying to update the memory map and calls to exit boot
services as long as case status is EFI_INVALID_PARAMETER. Keep freeing
the old memory map before obtaining new memory map via
efi_get_memory_map() in case of exit boot services failure.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/efi.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 8a74a22834a4..d2569b22b4f2 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -406,8 +406,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	efi_system_table = sys_tab;
 
 	/* Memory map struct values */
-	efi_memory_desc_t *map = NULL;
-	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
+	efi_memory_desc_t *map;
+	unsigned long map_size, desc_size, key, buff_size;
 	u32 desc_ver;
 
 	/* Helper variables needed to get the cmdline */
@@ -446,13 +446,6 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	efi_bootinfo.mem_map.key_ptr = &key;
 	efi_bootinfo.mem_map.buff_size = &buff_size;
 
-	/* Get EFI memory map */
-	status = efi_get_memory_map(&efi_bootinfo.mem_map);
-	if (status != EFI_SUCCESS) {
-		printf("Failed to get memory map\n");
-		goto efi_main_error;
-	}
-
 #ifdef __riscv
 	status = efi_get_boot_hartid();
 	if (status != EFI_SUCCESS) {
@@ -461,11 +454,24 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 #endif
 
-	/* 
-	 * Exit EFI boot services, let kvm-unit-tests take full control of the
-	 * guest
-	 */
-	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
+	status = EFI_INVALID_PARAMETER;
+	while (status == EFI_INVALID_PARAMETER) {
+		/* Get EFI memory map */
+		status = efi_get_memory_map(&efi_bootinfo.mem_map);
+		if (status != EFI_SUCCESS) {
+			printf("Failed to get memory map\n");
+			goto efi_main_error;
+		}
+		/*
+		 * Exit EFI boot services, let kvm-unit-tests take full
+		 * control of the guest.
+		 */
+		status = efi_exit_boot_services(handle,
+						&efi_bootinfo.mem_map);
+		if (status == EFI_INVALID_PARAMETER)
+			efi_free_pool(*efi_bootinfo.mem_map.map);
+	}
+
 	if (status != EFI_SUCCESS) {
 		printf("Failed to exit boot services\n");
 		goto efi_main_error;
-- 
2.34.1


