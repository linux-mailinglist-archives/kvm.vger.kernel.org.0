Return-Path: <kvm+bounces-12621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 595C988B2E7
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D79BD1F2E98C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFF46EB52;
	Mon, 25 Mar 2024 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qTTGXB1N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5716D1A3
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711402615; cv=fail; b=PE71DJJs2zCgSzPGxxz98eZxWEN49M6GxH4jF0wxNOIT4MP3AYnxY56nlR7G1hDOsimukoj2LyrIDRp2AU5fogCd9hdFCaHYW9lvGuNwnuOuDGYD5fSCdXqw7zr/PmmYaTIEbQRjVeQKQw7cc1y7OXH+Ah5wOhqBjxm9C9F+79M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711402615; c=relaxed/simple;
	bh=tOQktBIWiBT3mbXRmPAIKsUPJqOmnO3fGvyLFsZnJ8o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXiJi0kwjhJ8UOYFetP+92cdZUutCHwIv31o6xvnEKuKleU73cpckAzZI4tcOti1+tC417LRvD8+PIJ29V7nfCWbUlzY5gL/FVFlGpO4wsxhB7NrxIMNqDQql95S9sxpWxQUWN1NBa+XsqdeNGy9cDPXIkh5BrdGrbsQ7DwRa08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qTTGXB1N; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BET4n0H/ESs1KW+GrilslXJ2xlbJaqqztChgZyr5JJURaSD4S5zAnq6GzUUGnzEGqk27/w7q5IMcAyFORDZCUf8I4HMfX+Yo7pZn49HrMKj8d4KHCW8cb5Sd7TlGrIkkam1TZfKTlUutJbfyqAyfkwEb4yqhnrtT5NHqQnKvWvvu1KHDPcIORH8KPej7dPh4YoLgZj36HjYVIkMCxOr0FAjHx5yWv9VvTL7gJ0YuQ/4IyowftEkhiFdC1OS8aanXjFusEoeAwZrQK4z0GnoSKnvK9IoJkxVmTZSy02HnCvFpj9cfAJnWM5fSOxUmIEctb4rpLxHW6zNJSIaAUOYaOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+m0yXnjRGm7bk0bsfHBb0P+GHJXAP6Dzi9XcjVrNoOI=;
 b=DxYJORD70J6Fm/k3DXw0ErLFidh4VyupuiejncbTmyO2t1Z52EyHSfKKsSFHL1qw0IFRRNf2DIWR9ock/msFY4nUcCu9WXmoV8na7+s2TW0tmC04DmuMFB/piPKYI1JlGgJG2Wkmxfw/Q8Kq8LXpPlCs0IXN/Ak/7Kmh0l2EWODTovpq+b0leHkJROJwxXyaTAE+NZgGNEXO7xr4x0+HGB1R1V9GFhrfOFWd59SCl8LjXIaIXtH/ojbf28E7lDusYwPtMhoQ64zUuuMEp+b5HTnzSc3pnLFuqSgPkpAij3HV0+y+Qny6F0LHBQkJFg0PkI5SdRa1kRGH0/8S0uHNPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+m0yXnjRGm7bk0bsfHBb0P+GHJXAP6Dzi9XcjVrNoOI=;
 b=qTTGXB1N8DCCFvdaQ7h0dp4W4lKjD7hcgkuYuH1dsMGNpMrkwLuBmFkiX6y6hoLbaqXxwHcYfrcC1mDtqwQSeLk63+f5PRTR+PGg/3FfeRsWl+V1RJkdW0f/mKIFlA+Reiz2JvxnWw1Mjrdt+vgkrUaEw5UucVihQNDx96V2hb8=
Received: from SJ0PR03CA0062.namprd03.prod.outlook.com (2603:10b6:a03:331::7)
 by BY5PR12MB4307.namprd12.prod.outlook.com (2603:10b6:a03:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 21:36:48 +0000
Received: from CO1PEPF000066E8.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::80) by SJ0PR03CA0062.outlook.office365.com
 (2603:10b6:a03:331::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Mon, 25 Mar 2024 21:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066E8.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Mon, 25 Mar 2024 21:36:48 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 25 Mar
 2024 16:36:46 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <andrew.jones@linux.dev>,
	<nikos.nikoleris@arm.com>, <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
	<amit.shah@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [kvm-unit-tests RFC PATCH 2/3] x86/efi: Retry call to efi exit boot services
Date: Mon, 25 Mar 2024 16:36:22 -0500
Message-ID: <20240325213623.747590-2-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325213623.747590-1-papaluri@amd.com>
References: <20240325213623.747590-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E8:EE_|BY5PR12MB4307:EE_
X-MS-Office365-Filtering-Correlation-Id: e2493a06-3d3b-4fae-af80-08dc4d13ad08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v5ktjILTLtIftHuH1ztb/zbIpPLnQVcrOoE5IQnKxKMxFGfDTdBt+VBtvX+7CBfr6X0/BiRi6hXzMRNKchqlB0tMTl/OLIuDEU1YhqYuITICBawQnbeSrcW2CBGVXfPm7xDUApQCgzOHVaLbNqfKta4UwwNHkFuadZZQ6+jAuGyNks6DAO9dXVydbg9uZgvgQ1HemsD5c2pogmdl/y7xZ/zyD3MvVnC27BRwU7xTbeiGKMOOLC9Yfn/ChnxXJQbSHFa+NyRmNt8kv0Ri1udOJiR/HcaYgdKdy1Whw9yUPqgzjWJ6XeYp7w2KswmvuMyng5p9FR0yKZ9KmUe2v/d2pdAvCvSZs/GJGyPUG6CY22fWPIOCVULUNA3ew7nc4OkQU2GCVrrYii6pIlQsZmUhsSL8k7AdJFhzsI9A2EBEQxqefdy6PlkBjUummv68v+GslCc9fLIXP3k3yXOJSeMxoCdOC0pPfZlglOlzl25TaTsEwH/hVMNrrHzr5BvWY4O6pNaUWU9lXXqM3AKl8BHxS8pR0J/wY/00Iah3wyQopaJaxf/uRMII+I9XbDvEe/XSn8Bdl148GtVHI/GTHpCGHlcGwaW4vtbBFKD4mU2EEIxkqcFE0WQowefB9Hh13obRgwFPHgAWkecR2bdLDI4bqm8WosAbvotxm/r+4rqGYivLTQ0BISutfW5klkouaKk+jdJnEya8WqDUOao6vwilCEXe+YSJSWnc4XWc7U11BSfCXqi9BiW9kEPyV2I4PKpr
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 21:36:48.1106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2493a06-3d3b-4fae-af80-08dc4d13ad08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4307

In some cases, KUT guest might fail to exit boot services due to a
possible memory map update that might have taken place between
efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
to update the memory map and retry call to exit boot
services.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/efi.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 124e77685230..9d066bfad0b6 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -458,14 +458,27 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 #endif
 
-	/* 
+	/*
 	 * Exit EFI boot services, let kvm-unit-tests take full control of the
-	 * guest
+	 * guest.
 	 */
 	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
-	if (status != EFI_SUCCESS) {
-		printf("Failed to exit boot services\n");
-		goto efi_main_error;
+
+	/*
+	 * There is a possibility that memory map might have changed
+	 * between efi_get_memory_map() and efi_exit_boot_services in
+	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
+	 * 2.10, we need to get the updated memory map and try again.
+	 */
+	if (status == EFI_INVALID_PARAMETER) {
+		efi_get_memory_map(&efi_bootinfo.mem_map);
+
+		status = efi_exit_boot_services(handle,
+						&efi_bootinfo.mem_map);
+		if (status != EFI_SUCCESS) {
+			printf("Failed to exit boot services\n");
+			goto efi_main_error;
+		}
 	}
 
 	/* Set up arch-specific resources */
-- 
2.34.1


