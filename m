Return-Path: <kvm+bounces-12709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70ACA88CB03
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DF893238B4
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DA71CD2E;
	Tue, 26 Mar 2024 17:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="njmbpijJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D100A95B
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711474459; cv=fail; b=sNVE+Hjy0UxEbLhfXHER2ce/ENTtB1HXt97O0Ec1ON/9TZ3UXJqVE3R4REwWYKSPYcb6yxhHiB9OEKMPaviVP4SvqrSI4jZubeFBtmkNZbWFS1c/HftrXQyEenJBw0pCF+6BRqqeIaXMZT38fkR5yeGiHP+ffQ5hrDeZpdF1YIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711474459; c=relaxed/simple;
	bh=TRdKKg7iopiyugY7lkvGAzP7qbcifFAUi0k3Fxw3+CA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EUdpyiW/CNktOmkoOUpx+VFiaygqhawff7QdwCLN84SSwA819jlOMZ94FCARRrF+N6n/3SYgL/X3zg5i0iYK+PJYOMPcS0dL5TrzqotBqJDN42pWE+Zfmx44OO8QNoctWL4YbEGZIulqY9gGzvTP6OkoG5s7oiICaPRmrRNhLHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=njmbpijJ; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5fn6OT66e8hoCiU2taOa0Sraoy6vnkxsaE9bHNySLGZHx9I8YBQaQDmS9YkH99nN5knRTqVl0Bt+HoRjCNM3XDzYcp9KzWqAtDyDiWRbzSk5T9whUg/1sTSWgTwyqtVGGIKazBvREAPyws6E+oZJRiEqHfr9On1B+MUpmvvNnTWKDkw2AIUc4Go3FEom/mwDEt8xDuSOlq7qd03vH8ffU2SxSaEb/7zbh7yThk0Zdq0jot/ReMZZWwgjyu/iVXFcmFoq8eywEk1d54UTrLAgXy1BDjDZnRdEgdF+antWGsHt0B36xiKDhsi2+00i66ZUAbTrK4CnvSIyTP/4Rh+ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWOzrl1wYZNAxQWu6gXQ2Q9al7igmUvtZmcci55qYiE=;
 b=JIuHk9XXJrVW2t22jdsDAHh4ZFBUploGNkFH6BiENUzdYunipUhHygDPedwaPHX3ZVbb6yVbX2H7E0Ff5bSu6ESnnCIg3t9eyKpHy+KTxXZuld6SGcwcyBK2UU2X4x/smSIWiXQymfz4M5HmZuG5vFfxb7RaGzqHfPQY2NymiR/Str7lR23RsiDTSGjE5Ph84C9YGyV3avUwdNnFa6rJOdpTbCkobTJoU3VSkmItg5I36uR0dDN4JfUH7sEWNIMzD820TPYj2TC7i9hN4lvYInsD9P6NpAWBP/FR3sM8lhrqUskQIowoCy0R8M0wWnW6GvSNtLkghewFFgQ9a6/iLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWOzrl1wYZNAxQWu6gXQ2Q9al7igmUvtZmcci55qYiE=;
 b=njmbpijJHu96dd5KX3Ft3xheKy6GBqfjtHrpiJGSjP3y/Fn4vdqsUimUwI34d7WSPnS5GU1Bb0HFQrNJp8OD6sAs7LZS8CFcQtqray42XsDpKveAYxcbxRfLWdzLw0HjKi8T0iAl+TMEK3zfhqWU8rbAfWLkQ0WtnTwfArqpJf8=
Received: from BY5PR17CA0004.namprd17.prod.outlook.com (2603:10b6:a03:1b8::17)
 by PH7PR12MB6719.namprd12.prod.outlook.com (2603:10b6:510:1b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 17:34:15 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::27) by BY5PR17CA0004.outlook.office365.com
 (2603:10b6:a03:1b8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 17:34:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 17:34:14 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 12:34:14 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, <papaluri@amd.com>, <amit.shah@amd.com>
Subject: [kvm-unit-tests PATCH v2 1/4] x86 EFI: Bypass call to fdt_check_header()
Date: Tue, 26 Mar 2024 12:33:57 -0500
Message-ID: <20240326173400.773733-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|PH7PR12MB6719:EE_
X-MS-Office365-Filtering-Correlation-Id: 94a90b81-f635-4df8-8c1a-08dc4dbaf51b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pNvuRvTVXRiY4KMAa73Tjekwbv+YKgPr1OTmmG2B+0zpsMB4RZJ/pfemcvofH81bg8VrI3a6PmOBadD4GxX9qPd/9RZq5nwfBiJjrdredMwSGMo90npdloo/lbFqEWj9FTX5OMABFZteF1VywPY/ahRTT62oYf0bJDKaONhk3aSCNLn4MJbj8zGn8YMuWysJ/m2fObbVWapkRaibn7zK764gydgO+gB4UhsEizTTXAiNhX4Rudidj7YJUGBaWIzmw5tUqf64+xlPxWd7jx6It3miC7F49qnG83cc1xveLn8W/EwwmBJ/jPxcEVKg68IW7SWVy1Er/mzuFTv7ZA661T3c2MxSOZJzDiW53LejsyP7OKZtqjBznZLk3KPYyzBLtHi+BEQw//Ve48vnYYFZCE6X9nxtAl1zYju217m4DUUc9Vq5JogazkgiC9k7vLKyeMc0WT79nLJuoPKEET/CKV4/xNhkGO6PGTKrOPUvlRV1kLIYCQ82wuiAYth/CNJH1Q2UtX+cexN2Yy8JxE/V+wCHFLHOOZz3puS9yTEqjOGJtvORlx4xB/Jffe1L943SM9IP5mPQCkqT/q0EqPjYGuCy0lpJfvQ4+mzae7sK6tvUKkVCEaSnRWo0VSLREXEiWRkCEzQg2tjHw4kOfDG4irBegei59a+VIvmADQ23Vm/d8rMLkRYj9DsURV4M0YmibkKgKrnsY666ZpOgEtB+KDxfZE30fEipWwboi5/6hNB1Cwv+ZSmamp9RLAW47R3l
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 17:34:14.9684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a90b81-f635-4df8-8c1a-08dc4dbaf51b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6719

Issuing a call to fdt_check_header() prevents running any of x86 UEFI
enabled tests. Bypass this call for x86 and also calls to
efi_load_image(), efi_grow_buffer(), efi_get_var() in order to enable
UEFI supported tests for KUT x86 arch.

Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
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


