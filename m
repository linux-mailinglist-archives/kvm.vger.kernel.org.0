Return-Path: <kvm+bounces-12711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC0488CB08
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0D361C663A3
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7240DA95B;
	Tue, 26 Mar 2024 17:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CjWQwjTE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5F91CD2E
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 17:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711474475; cv=fail; b=VKka179ca5DpZl/0uGBEvJi2m7ySX0tvJCiPo69Ci9GNurxpH6dCsUsPYciUTaKdR8GdSslkQXaanUWGyFINXlKHG8VEkchnJl05VQFjK8uhdfLqiShCNKZo+nonplqJ33Gs5dTsjdpqImKdc0PHTrI6guQfvnUIGTp8o24ZnuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711474475; c=relaxed/simple;
	bh=yhg/rTTLMhdYh/WMT3Am/PSnoRo2f1nDqWREEu0fhfU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ML6Vr/p2D1x+9S/78Jm57burmw26OtHKF29it6UFznquuzKBGJjYQF9CZNHH0AfeQm2zrSXMdHjX2rdZWBTOcKn5kNLqHx0lYtrouJQYlqZBIhmAfy/AYyU4XuUh7DvEksTlca/ZSaBHi9wYexo1QjqpkqazZ/ojNeGy6L2SEoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CjWQwjTE; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXgS5m4cwwa8rdXqKjlu/bZZptsExFVJxyIVb9sZ6s6nv1TQglntFvBMyFQu71bpIoa6s5OR+1kxMZbA8Ptlcr/oIL7wzWpzP0+e9AqoM4tMsLlxnVj1mf0nrWBJ5dstAS2HQcDW7kU4ObI2fMkinCzask/o4izNS0sjCLBRSc+dQWXSxMfqQVwxdPdE7UvJd9h5+/qcfu9TdGhIgsn16Sb16/Xkc5Yobn/XgfsoxHnFaZdVIL+ZKAmEpjZmQOSawwSICQp83TZseLHq7EFzBhaGFAvWGGTC03NYmGMPq+Iq0f8xc8e42BimchfYJ4WwnVx9HVI/XiYhzMvhj+E1oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhZZQM9uqiYCGqWzmQjNWxiYb4QXlovvvrDe+pkpRYw=;
 b=lOkUK2Se6JZBwycgCQficuqQXxr13oUsHyDs7bBrhS8PcFF+weCE12em/zmlDZBbRKhl31mADT66PyWf1yE8O8PelRTdxJEFVfMUalOzRBhSG49GphGzMVIwFg4x9zGsOc8ksw7TMPA0Z9vODv1N0XuGCkJx0TEgpNsRcu2cnEWzztLPPfu27Tr+vLL56ZvwbddhIWocF7/UhFx2qpnewi6C6t5Z/WS1hIOhm3xzp9DpIa58G4D6OjYhv0hEudPv/M+DAnBiMffd2cSTFSAKtHg8AvNvpjzSMhBeW3Qm39q+OSE+vU/2W1DLdI0l7MxYN28yL+c9VLsqPIYnq6Gnxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhZZQM9uqiYCGqWzmQjNWxiYb4QXlovvvrDe+pkpRYw=;
 b=CjWQwjTEGuUTveVNKSQ6JoHw2751jfJ4ffXFL6hWV+CTFv55bBCAZLM8QngVIhwwkcliLitUbXgFFJBb6K9vACFsmVm0MHL5sUalRrHwt/Y/tcN9/26w+TPWXfkrz33jriYh9j6RjpzMs0w94Dm1tOtINLAvaJFK3MrsmWXVxt8=
Received: from BYAPR01CA0004.prod.exchangelabs.com (2603:10b6:a02:80::17) by
 CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.33; Tue, 26 Mar 2024 17:34:26 +0000
Received: from CY4PEPF0000E9DA.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::1a) by BYAPR01CA0004.outlook.office365.com
 (2603:10b6:a02:80::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 17:34:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DA.mail.protection.outlook.com (10.167.241.79) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 17:34:25 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 12:34:24 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, <papaluri@amd.com>, <amit.shah@amd.com>
Subject: [kvm-unit-tests PATCH v2 2/4] x86/efi: Retry call to efi exit boot services
Date: Tue, 26 Mar 2024 12:33:58 -0500
Message-ID: <20240326173400.773733-2-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240326173400.773733-1-papaluri@amd.com>
References: <20240326173400.773733-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DA:EE_|CH2PR12MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 81f5521e-1467-430a-6850-08dc4dbafb5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0WD/KuTVha5Y78pqlU5/3pG5IPzoz0y9HjNNjcs1IvrJNlrl9zUSr5L1mXTCq2A31Ieif+Q2VtrJLRG5UGHb/Xbbo6C6wcWpx26uJgEdkTik5ctOy7gazx+uTb9j9SpIQcLeUDCCrbZ3OY3zO+ok8U4h7lnb6RYrBDOZXvGewq4irJn/IaIv7aigFPdNWdSwHpv+kYWk2c2TjxvMZFe27pgQ2SlUa9IeKNc8VFpwElG8LnuEVmfDAqa17jaHEGSq9dklmWT1kOa6b+VeoTl87sv1zobTA6FaysI32lcx2xVhyJi6ruPJRDVhrXx+n2UtZQtFEU+nzf78GTuHn1FUo65BfhoAk/R7BcMAhaT9rAF4upwlnZIdTBnQHvd7iX66qnIRMfV3lrOmy76CP9SnWY3jPiujIQnADH0MJxuOYjLwf3GHsa9Y2JGx7TM1IsCvImNW9+n2CDO6PUo8hs/k5UU2E2Bw35seVfb9rfDqQik666en5ajSj9gy32zAp/2F7xctYlVz1ajFkQ1ObTf9jDOC/QXl6A4k4DWHQZ6t5gQnT2Y2CdR20nGM6qsVfZhPGAKHq2orAnHsIpTksnpwUtIyb/E9gkgsDYUj2Ne0aJN/1B0Z54UC1LxzWriXrcQmja0uuQU163E6t+RTbKgiLN0gJp0VTRCESgG5dkzgdbkRNyVSCT553HnOuqdqf2ZqpYdK9ZRneT68hSisjwH7ylSkzu3SNg9D7Fo/ufNE7fdZ5q0//kBKNrUjRcAHdL4c
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 17:34:25.5157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f5521e-1467-430a-6850-08dc4dbafb5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213

In some cases, KUT guest might fail to exit boot services due to a
possible memory map update that might have taken place between
efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
to keep trying to update the memory map and calls to exit boot
services as long as case status is EFI_INVALID_PARAMETER.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/efi.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 8a74a22834a4..c98bc5c0a022 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -461,16 +461,35 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 #endif
 
-	/* 
+	/*
 	 * Exit EFI boot services, let kvm-unit-tests take full control of the
 	 * guest
 	 */
 	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
-	if (status != EFI_SUCCESS) {
+	if (status != EFI_SUCCESS && status != EFI_INVALID_PARAMETER) {
 		printf("Failed to exit boot services\n");
 		goto efi_main_error;
 	}
 
+	/*
+	 * There is a possibility that memory map might have changed
+	 * between efi_get_memory_map() and efi_exit_boot_services in
+	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
+	 * 2.10, we need to get the updated memory map and keep trying
+	 * until status is not EFI_INVALID_PARAMETER.
+	 */
+	while (status == EFI_INVALID_PARAMETER) {
+		efi_get_memory_map(&efi_bootinfo.mem_map);
+
+		status = efi_exit_boot_services(handle,
+						&efi_bootinfo.mem_map);
+		if (status != EFI_SUCCESS &&
+		    status != EFI_INVALID_PARAMETER) {
+			printf("Failed to exit boot services\n");
+			goto efi_main_error;
+		}
+	}
+
 	/* Set up arch-specific resources */
 	status = setup_efi(&efi_bootinfo);
 	if (status != EFI_SUCCESS) {
-- 
2.34.1


