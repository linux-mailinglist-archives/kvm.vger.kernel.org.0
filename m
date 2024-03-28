Return-Path: <kvm+bounces-13021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A9A8902E3
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3614F1F2748E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD8912D1E8;
	Thu, 28 Mar 2024 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4VvRv4iv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32B8199BC
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711639284; cv=fail; b=fJ4ROMPGRxSYplDUMpTKZbYw3IW1XIYJhpoQe2VxdPtrXQFsnO1eWJ6vrPCuI0YlzKNS5fb8uYmTgxfb+NAPfgj9O9bhEk8AkKVDMZl6mEgn7KwjAhe85GUrEqrS3c2eTZeH5IbS3gocYEqkB+6g8Nc/k1qQA29N8I2Dv8uFeoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711639284; c=relaxed/simple;
	bh=eqS707r7Bse27gh7zugFdLJZjTKtTFKjwLTUC614W8M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZR7vU7dvM2HwMPXhZjgUAE6n5n3/+r1TVaXxJLaB0CdTOOtw+VX/J/LoBkLSeOuNY8tX+qJ3SUopGu8z4p655g6jQAcuF2q5jPHE3/LEs2HQzZj50KpfC/ccvnOmyLyDhTlg91+Ce3jPAG5dNhLDNd89WvsqNi4RMkvLv5XGRjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4VvRv4iv; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzQgqQbvqy6xgsf2bZzLtQRxcINvQi+/dYPGTlYLmAe8emj/I10OVsSeMW+PoOoUlEmOGThMNTQnA8jeVlMbgF+MXqZoDcc7/52TsH6Qdww9fTGAvfBdF7zwupMxrdOYAKQfjPybAGfNAvG4Oi94oHzStEyE+ZgrkfH9h8s5dJrXxAXnjdW2PsczYgoOPOWpVeS3OuJQocPZdof6JNM+XicbH+aKwSeXzlvTsbeLafoc0RGKFY/L+SBQJzR3HxHAW0+m4V+OEzG4lh+58BdXr5ucJ3Q7sSJuWnWnJN1D7PcmhHWQZrU5MZLpBstHULFYURH82BXQCznNVCawmCv+gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoqEjZtMxVxzeVqpZABOV4G4Gd6XVC3elcBVHQ61A0k=;
 b=IuJsvBstuR8t8gJWFa1Dbkiku1qwrwfv0qywFbmiW78usQDQaWauS/5jQQ3JL9G4H3vOkxUO9S9k0CnDKXJwtpf0613DQ4gRcDmKjjbqUuv1KUDAo1biNxEFCrqXVyAuDG15UVr45si1lRBxJzq6oEzlV0EHmhvtDkyWs1nr1/+eSa/J9xeIlvt0ZTE9ddnLRpe9T6Y6kd72mYL+dxeEALreOtIjeHrwjDCF//HOg/BA+9HgHPCuhsl0aOqAnjjqCDgsfOEcr6ooWqm2QRmNpUzysnO01BhbTj5MexhKAU08l04ctz2VhdJ2xwRRRq5hpowSlfukGrYTF+0O7pTdzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoqEjZtMxVxzeVqpZABOV4G4Gd6XVC3elcBVHQ61A0k=;
 b=4VvRv4ivr8BRTPKZRAptcQA5qOJUfRXbpZBs2CneG7BrRCwukXfdqQMibwZeu3Nrp9QNyR2o6iSsQwrbR82UNoYakFV6+/CGoP5e7I1DTNSHUrro5a2vuwMzp3IWkhtlXYHWtukPbD7AqN9yDEa9kqCaqgm+R/4tvFigaXSBZxg=
Received: from CH0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:610:b0::25)
 by MN2PR12MB4271.namprd12.prod.outlook.com (2603:10b6:208:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.39; Thu, 28 Mar
 2024 15:21:20 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::f) by CH0PR03CA0020.outlook.office365.com
 (2603:10b6:610:b0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Thu, 28 Mar 2024 15:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 28 Mar 2024 15:21:20 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 28 Mar
 2024 10:21:19 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, Pavan Kumar Paluri
	<papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v3 1/4] x86 EFI: Bypass call to fdt_check_header()
Date: Thu, 28 Mar 2024 10:21:09 -0500
Message-ID: <20240328152112.800177-1-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|MN2PR12MB4271:EE_
X-MS-Office365-Filtering-Correlation-Id: 48c87855-c8ca-4e30-7849-08dc4f3ab89f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wfgQYtBTaJWSaTj9/Xa3WM+v8e/62Vuz6ZJZWtSz5k2wPeMsymuPzA9PtebVlW5Er+zJI899qXqMSReX1tjtgLF/+nZigv08Uu0fOco8DHsKl6icW16/+OfUmMWf5FDJ/3mGwcuQLFv2FBiSFMzDov6L7CKi3Kt/gaoMEMa/4ruF3y0/zfow89eb1QZ7Qo8bDBqeVYy5Tjk4ApWvBfwLdPvkR6yLlNYr1v3xhJCODSsuWAY7Fj8wcmuzgKy6VzCmRNGJd0fmUY5elG87qFvyH2bG0Mb/+NKPREZ8rTGUGPTVHGyyKs/I8Ecy+T0JW66AcCMWbJCpLN4oB4qNApXv/iePBfN6pZrujFtx+teNuy5yl8fyUkJpZQIPQxoa1LY5+zYnBKUpXmz/RjxOcZSGT13hsTFWZqAQM+mdXLYg8ho5NQbgtdSqTruxWzVY1egL5tD6pTC+nCZ70GITU4sHNR2i/1hZLfQgQ301yjrmn49t1OwruF47b8dHXhbFt7LCqIESa+4FR0ZCmLsMXz10AxuQ9lOHgOGKV3xJ6g/0N/VBn/5FzluGyRH89QltfhOomASPNNEW3UVLrlNVP7pATxbQkYd8xadXDmOLJ5JDNagVn+xxkWBFew93ZeoNgPzSd7mbYMY18wlZGXuki+z1jTO8yldryEtULLhc0NGewQfgEU44Mt02qkMzil6p4RoU2bqa3Js2qRuymrpXgg6BBsghPncdOyI0MJL1UOhqWwkTEjlMxScPSAd+eXX4QASn
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 15:21:20.3299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c87855-c8ca-4e30-7849-08dc4f3ab89f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4271

Issuing a call to fdt_check_header() prevents running any of x86 UEFI
enabled tests. Bypass this call for x86 and also calls to
efi_load_image(), efi_grow_buffer(), efi_get_var() in order to enable
UEFI supported tests for KUT x86 arch.

Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/efi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 5314eaa81e66..8a74a22834a4 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -204,6 +204,7 @@ static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, int *cmd_lin
 	return (char *)cmdline_addr;
 }
 
+#if defined(__aarch64__) || defined(__riscv)
 /*
  * Open the file and read it into a buffer.
  */
@@ -330,6 +331,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
 
 	return fdt_check_header(fdt) == 0 ? fdt : NULL;
 }
+#else
+static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
+{
+	return NULL;
+}
+#endif
 
 static const struct {
 	struct efi_vendor_dev_path	vendor;
-- 
2.34.1


