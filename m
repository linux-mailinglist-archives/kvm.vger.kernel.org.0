Return-Path: <kvm+bounces-13095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C78B6891F4E
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 16:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 526801F30A96
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B811813FD99;
	Fri, 29 Mar 2024 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YXzXFO5k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AEE85C65
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 13:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711718158; cv=fail; b=UagO34n9rltewXm4HPE9PY8eixZshUH3tkiScaqAvvNQTOL9irKeg0vj3dx2NyLE5znmzODcnGkQIvtdAkZpKtEFPtgdkyGHHZWJ93H1n9fUm9l6XunNvUj/uBrARHQh/qpGlOfOQdSd9cviT71h3/4HXzxYH6nzFQvuQByBXUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711718158; c=relaxed/simple;
	bh=x+Y/+2mBpnxTVq8MAx2KMGQv+Ql8+PBJabdLak7n0Ew=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTSWvLdmXAJY/OaHygAJRkVqDVsAuPQ0z/+Vdxp8DamJsz49amqtLk3h8zX4hxDzBDqhmNKzyj1pH9yePn0xGiUigQu6ZVsD3HMTIz3foXS4M3shxzbL2Mreq/bh9Vx9xeddtnjIMLxYpq5H+eMFFGZMPq+rDBgAFBDvEpjFBOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YXzXFO5k; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtUMsUaAaNQJLxf4sAk+rWMDZ52SPOfw/VmsMYtfTxSUQVJbMTA7WOCp6Lp1jFKWxYslcAooezRp6qwC/xWxhpmG+tcfT+gWtQ6+cRIcFGCMVCv6hgsPev/UlQoKS2o1p0q8pq1Wl/euX4+j7WAmiCvWIEvx/uH2REb4JO4uN7JN77GnMBQbZRFJIZRrTvNwoenAGW50tCnRBYNzxChnKghEo6X5Tzor4ANk1n6BXHxYYUpRwx8rwfizdPZoeBDLdzsTuQAjEQQ+hdEJLik/24KI/MsvkdAVKWvdtvg6JGRAXAtQe3NseWCqHFeUukBs9+Cy8IGO6wNMLlZFym4p0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8kJYXi7M3CzOSYESIwKnPebntDJfZZiuZ9g3gk7tKs=;
 b=H70ZWBeUlEKTvN7N92Nh55J1wSQUQLJfC+vW1muUeT/qth1txRIxcwgB49fEGvGhAitwnCD2gNDFFP4YduHFPEhLGMY7QR//KodBSKxKsIL/0Ete2vV+EdPIMWASV2i0e0UzqEbrItcXJVBnrrF+7S9FJNTt4yIThmI7JjgGr7mYkmwqwm05oXumsMMezdOnbpgu2yDzNuSxdCVITjzQMWz/3Oti50GunTtzTfYRCR3P8Ru8c87EB+lAtIRKp+vvUTWd9XRcXEU8b2QMZBuqVQRymaGEfLChD5K29zP0tCmOlDx8u71xNcZv00tdHapCq+DyyebgCCoQxz16AtvohQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8kJYXi7M3CzOSYESIwKnPebntDJfZZiuZ9g3gk7tKs=;
 b=YXzXFO5kd4yMLgX8PuK2cxnqiMx7m+CxvV5mO4AKhvz6LGUuXJoTMPM6WQWe8UoQzCjyD+kyJFQ8fxBAsm0d9GB17f3baXA3ka6ajRuTUEXPfh+6t+noKI8hJQrzRIEePNbNKoKF5IwALi5LTHOFNyBd+UejQiJHBT21r5tNH38=
Received: from MW4PR04CA0210.namprd04.prod.outlook.com (2603:10b6:303:86::35)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 13:15:55 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:303:86:cafe::6b) by MW4PR04CA0210.outlook.office365.com
 (2603:10b6:303:86::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 13:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.0 via Frontend Transport; Fri, 29 Mar 2024 13:15:51 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 08:15:50 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v4 2/2] x86/efi: Retry call to efi exit boot services
Date: Fri, 29 Mar 2024 08:15:22 -0500
Message-ID: <20240329131522.806983-3-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329131522.806983-1-papaluri@amd.com>
References: <20240329131522.806983-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 96194bf5-96a0-400a-1f58-08dc4ff25bcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tX/pA/ZiiwyEgsLMC1EYQz7CMAZugnkXtp4hIdyMbv10DWoQCI2w4yyHoyBzeYIPPSNHFyHHOkrnwlTC2pltkwCNZcVxD4Z5krONS9j1p4Z8JdscikBUjJNCf7EokUec37duFpNsc6ljBEKxMb40+cS8JHbpPprAwttiyXAXHoB8bMdYNEsDtk/8Tp1jo8e4CcXYBIqdoVjvqy5BTtbbuFfX/EN321jjLvCUe5qGCQ/oHssfCpjrlrIxv+Bcyn7Q/rK3vzQomSW7mB/T07acIngS7MzWmb413uySqE7YkLd8nONyDGmHObAIBGGK5z75v7q3dY8mo3ms6sio/iyd7PBymvvQe8lMueTMXf0iBhVRhb7/1Mjdo2quvwpQp7LYKubb3YObYl4fuK4iF6k5neFUSUdsDLPtgb17c6J5xzGEDikazH/iM9Gd6JrwTzqlz1b9n9/NSL8UtSjdJRQAkv1yV6fek9Z8QW4X3tbfzuP+zg/W4BkS1rxgUlQq9KDciiyom8fEHZ1KVhfGBFq2Mo0Hc2cP6gr64OqBOWXjW2YR8OUZTR7IYtbpEt+Opm9WVf+sfmDXs2dfxPIbRu5XipeZJIROhlvay6MIj8JjPPFhJEWbyRyH/nvX7BdNpWIlnfIgDM0dH6Jx19d8FHxMp+BASupnYGIOCK7u0O2eosT6fr65c6FKdFgsjmegBZPWAyuOzyX/mQ+BqNSrjPVvbj7d3nyLPOb7cYaM4fDlrGlwWtci+2o2mtexOWPnHI1K
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 13:15:51.9029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96194bf5-96a0-400a-1f58-08dc4ff25bcf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846

In some cases, KUT guest might fail to exit boot services due to a
possible memory map update that might have taken place between
efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
to keep trying to update the memory map and calls to exit boot
services as long as case status is EFI_INVALID_PARAMETER. Keep freeing
the old memory map before obtaining new memory map via
efi_get_memory_map() in case of exit boot services failure.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/efi.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 8a74a22834a4..44337837705d 100644
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
@@ -461,11 +454,22 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 #endif
 
-	/* 
-	 * Exit EFI boot services, let kvm-unit-tests take full control of the
-	 * guest
-	 */
-	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
+	status = EFI_INVALID_PARAMETER;
+	while (status == EFI_INVALID_PARAMETER) {
+		status = efi_get_memory_map(&efi_bootinfo.mem_map);
+		if (status != EFI_SUCCESS) {
+			printf("Failed to get memory map\n");
+			goto efi_main_error;
+		}
+		/*
+		 * Exit EFI boot services, let kvm-unit-tests take full
+		 * control of the guest.
+		 */
+		status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
+		if (status == EFI_INVALID_PARAMETER)
+			efi_free_pool(*efi_bootinfo.mem_map.map);
+	}
+
 	if (status != EFI_SUCCESS) {
 		printf("Failed to exit boot services\n");
 		goto efi_main_error;
-- 
2.34.1


