Return-Path: <kvm+bounces-13094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 004E4891F4C
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 16:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA6D3287E90
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D146813FD8A;
	Fri, 29 Mar 2024 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qPmPcevt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C1286128
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711718145; cv=fail; b=dBvArMgs7MuyeU39gZCbIwAN9YKdV4F2wWbuL4uJff//sHS5GoTgf+AeZBpQnEs2nJwQZMi/NiGR51KzVnE2SmN5UYxWHqfeetOEguG5oZ1tcgBEvgjP/uQgaBdtG2zbQ3EpYVidYTzkX+TY85oNTQPhbhHAor0mc9AskMwY3vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711718145; c=relaxed/simple;
	bh=eqS707r7Bse27gh7zugFdLJZjTKtTFKjwLTUC614W8M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNSILZYq4l6xUxR6wqVQjqaxJAR5F5m6MmU8oc9bTArPf4cNkCDrYxPe8Y/XiVl2g60oYBNSWQtqf/v6Sdbs40IZ09iaaznNwqTprpLNThLDy+DDO83+DuOP7hZpMG7QtG5NjErDFupe4AfRaIp8b126YiLHQSDH6w9vqP8RWPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qPmPcevt; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gI5yAu1EaFKCPQRCoHQ039bFXYYWuqV5T19/sdVsni+C20KOHzebIpA+GTtW+ZTXxSHA5Ubno4kkr5yAW4dtM0365v67RhiqQLWeeouT/cWzGCfIW9g47OSAMAuMaN8phzC5js/4JY5BXNOhNZrN+CXTt/IsDW/Re5aVBziZhzyFKNqojbc60hYCuAMTs3NilQNwbyqL9BQsZBtSLErbvRjXeagUHEeUj4GpuV+Fs22txSbnzoV6WmIL+fZSIJTgrZzXs7x635Mxt6L4viEyEC29r+3ETrPKIq9wHBNWjWHeC6n8UkN/h5TyWFZbAy0pmDoUmEmDDwo4gbf08iVkWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoqEjZtMxVxzeVqpZABOV4G4Gd6XVC3elcBVHQ61A0k=;
 b=eA7xOmgj1vbTLYwd1FvFBbo+7G5OaQ2wTJHnmjn3lU2aE22eTirgw/9CBk5R667rhbvKxdV76LixVyu1qWBsAZAMuFQGgMEXQ5A9vGZySXPlntLb7883FGfLXAKjJn/0dfBTH2/Xh46rAG2IhXWZqon5+CC41Q4l/Xxu7it19jalSVOKCNFdsxEWzYI3B//MbWwNQZIdIAoyNNbmAPtysRCBs9QqMKoT+oKTVkrGAQKk90KvZpVutiEhFF2OIz+gAfGAL8SaiHUyRw7HhjORuXAWRKtq5OvSMicEcW1PHd+t6De66DBWmvTsZye3va/FeAR7lJ1kvRMfvbdNu0Ju4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoqEjZtMxVxzeVqpZABOV4G4Gd6XVC3elcBVHQ61A0k=;
 b=qPmPcevtTOCgynkyohnylmJLvnpH8vH6uprWqIWo3dExQt/GY+4WLPttdI5BbDEbF1EOEuuglOWYo3wY4eT6zk6W4VevRIP77TfZqhvHgU3nXNbOPxlvVP68baARvW6qBvEqjXSMuSxc5LbeW64b8GYuUPTgJEXDS1ltTl+UH14=
Received: from MW4PR04CA0193.namprd04.prod.outlook.com (2603:10b6:303:86::18)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 13:15:41 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:303:86:cafe::7d) by MW4PR04CA0193.outlook.office365.com
 (2603:10b6:303:86::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 13:15:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.0 via Frontend Transport; Fri, 29 Mar 2024 13:15:41 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 08:15:40 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v4 1/2] x86 EFI: Bypass call to fdt_check_header()
Date: Fri, 29 Mar 2024 08:15:21 -0500
Message-ID: <20240329131522.806983-2-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d99421-db14-4f72-e324-08dc4ff2555a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UFHUAHaaFdgIkt0IyYAY0lF23Qsyl5gkqSJH55Caporwp2FOLX/rjLvs6DYbtIlV+y2Trw7Z8VaJjUOyGjbNSMYh1ss4B6Y4mLHGqiB/yFG6csGMqJsPEPc8+2q0iFGB71Aqsd5/hQNWOL81stKF9+Vx8uBU1cv4/4jHtmDTPRzug1lFCnwJTQ8jWbEK+wOiPfESV3tqneULk7all8M0rJnF54h5hUBhyaUtQ+IrNTkdokq5M7UTjp/O4IZTVKLVzUIb6blnziZocMx78FGmY18v/LT7xIU2kyb8pRSmYz2yFWo6trfXoj3sWsvKNzCWK8Zht2kNGzxzjfFY4HGpmknapnMaWW6YipqF+Od2/F5/aeD5QEHJe3mMAAVgZuZPcC3Mf48uAKo9AV1JkpSR6y7cg2LV7R5YeeaPo4zEjSdlkQ5YbTV5kz+PrgUPpr4O3TvwDqfnP3AtJ2FyaOmPti+xok/EY3ZfXL97myMGcBH3J+iBzsEP5fTPrKlwZ74za7nteuLweIygdbcFzw7vJnmKyTCxWf7RLBMDDLFAfAegM1m0rgZ0BZf2sXDvkjVWfhiFWnfKBO8Kxo6n+V0WtrMBOW8QpUSHgsTHWv2CgEybobPY3+k/S90FFPCy9JdrbxNVrTXt4jzBHjyTXTPO8ZZrw/B+nf0ydxfz5L9z+ccHNTqw/KYyUpL6GLD0vqNywY2KxpLUevfrbQvsyDZvpJeHg3pYcw0SmUrLV8IOn0eT/WFSmJFJDr7a2sYyAvmD
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 13:15:41.1061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d99421-db14-4f72-e324-08dc4ff2555a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

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


