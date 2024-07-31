Return-Path: <kvm+bounces-22776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 792CF9432C2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA6DDB28C34
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8B01BD50E;
	Wed, 31 Jul 2024 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sWsm8Ek8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A951BD4E9;
	Wed, 31 Jul 2024 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438529; cv=fail; b=pePGKBA3xvry3UNuCDbvAXSXeor2kWrFQeeK83sZ35ISTzIGgDXm8ypxLJBIaqmNAWudTgc+pT3xOTNTJTBY5ZFRQqp+rKrIen2+OC5HGFtEg7oxTtJjrdffnlZZhj8Vl83d5Nl5KtLeDmvCQwRQZJakLgQoJ0v2Y2q/PMFni2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438529; c=relaxed/simple;
	bh=Mmvg97okGCyiJtHTPCEbYYo70LTO+mCOglmOhzElZoM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKMQiGd/ZSx3wXzx9iYss3iuvan/Bltp8dIaiGPEcOJWA12eKqZvtIoWiL2VnJbYE4Q+Me7SuxAZe8ThrR6TxuGgYCEIFGtnlySgggACBKTn/kZ0EhXPSnPFSw05fC7Ss4ALjkmQBpRNyrMdNcXgCZNg4jk0cNCGU/8jyKWJbYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sWsm8Ek8; arc=fail smtp.client-ip=40.107.100.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P/3jPH9KW3qmya2IAbUk4ROcwHP+MD/y712Vk0krcDCRcSj166kftYgo3zyEw1sqHGLV/TI+ELMt2113C0lN+vpcmEICOhinVXh5LUeocTtw2DAXSikUNWhGOnC905VOr4VeJU42mNYTIcPwjClBsEg+GVd5RqItsjPkuS+amIg9wz1Tbkzal3ohLdc3nXXYVH9/4uth1ciOOSw0Bvi7CFdJzQ2YEEpzeJx9UpgSJ0yGsuITDs72h6tgPGVSgevsGocZv64l9rr+6dDxbqQgyD2iD7m4+DTnv8uPycdwq5leWhiuuEurXAgZT5Ao+rWvgudbT6+TJkSJwv0tVYU6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbjWWUGOuINJ9pQgi9EEriHDcboXIVDNMMGrDh8DLoc=;
 b=XM18sQbJsBee2C3jcetBUyRP0RO83AipIx6nupoHGVfU+PAORMR6FVLdngiAESBnvXBZpz06lDMghv6h8NiYWYFrz+JC1rDlY24qLwR4CN3w4drn57aK6YfYrarahTQ9go7fp8xtp9MFHj68jR0pf7z3bBEEf0Z1JYqUZcysoP8lK05OTosf2Kj1k1sP9BFHUif49zqAHlrjx7cLdQ2M8brlyxdUWJddmdd9LHZY6VazReh2lv5yuFJki012Zoey7mE45gfSlTHbZYg0mDqm65/c7UuSyqN+M5JY57hkmVzZDsT+XuxU+su1FhBid1XSUg1n9cfaWenkW/bruUZjHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbjWWUGOuINJ9pQgi9EEriHDcboXIVDNMMGrDh8DLoc=;
 b=sWsm8Ek8GFohpOcBxT9xWA42L+jmhuxM1bhoqVoU0JgQ7NdqTDjVA/GrumU0hMRkiNqVB5yhJ/mJ1g+3uvKOOSJ0qQVnuarh7RKb1ZeyfqFmkOkZo1YFIKF9Ho9MPozCuhESq3oUklo9XNUnxSQ9PLhYeC4rTPbruE5MYuzhB7o=
Received: from DM6PR07CA0091.namprd07.prod.outlook.com (2603:10b6:5:337::24)
 by IA1PR12MB8406.namprd12.prod.outlook.com (2603:10b6:208:3da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Wed, 31 Jul
 2024 15:08:44 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:5:337:cafe::81) by DM6PR07CA0091.outlook.office365.com
 (2603:10b6:5:337::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:40 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 04/20] virt: sev-guest: Ensure the SNP guest messages do not exceed a page
Date: Wed, 31 Jul 2024 20:37:55 +0530
Message-ID: <20240731150811.156771-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|IA1PR12MB8406:EE_
X-MS-Office365-Filtering-Correlation-Id: 62bc6c1f-b0a0-4a9c-9d4a-08dcb172abae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rZBbNmNB3tbbfs9s0wyAIfbgwxp5rqPKhqneedSuxZnVQ21tNZL12O4mi72P?=
 =?us-ascii?Q?k00CGzwQ5CsyEbnFho4flOP9s6Bi3vwsJAyxVQQTHjFALvm0jvKkQlnCGw3w?=
 =?us-ascii?Q?Y2OJhkXG78AtVdL2j6riv4BjNfzje3dL5jZMrxOcyNyL9ySFLG0zD8fPtFXz?=
 =?us-ascii?Q?J3cO6eZeqKpfUY1j2hp0/lNUeEhKe4+4B6GWT+7qo/9bHHnLm8yK6eumNrlu?=
 =?us-ascii?Q?LgGDilE+oJ4PmqpguWHVl/AIg4acVDvHgxPuW7U7qFC9A3Vbm2NCRNaVxmc9?=
 =?us-ascii?Q?AQAPoTnImRmEADuop60LFItnB9X3B8V8TugArMwnAN2e0JsV9AOx5WWY4RrM?=
 =?us-ascii?Q?zjYQSRTamb5Wk3Gl+TZ0qZBQpHPbB1S5senXQ1piIMzx0b0QVYUHeRk1+4w7?=
 =?us-ascii?Q?EYBJH3Gd/JIZMbV9N6xJrGC3C6CV5NEeMtou5GjEdpx+lFi3mNNoLp4whtFf?=
 =?us-ascii?Q?4jb4HFYimXUUgtMK/x56mR3ZzexeL4Acxk7Up7hWRNYYAp1TSDUnIJuyK6bh?=
 =?us-ascii?Q?5bkuysgLfggm92RKSesWO5w00FReFEXxhE8vRbm6B2kEpmJqnoJwkNUBpvNZ?=
 =?us-ascii?Q?4HEFVOcEchlEhn0JHRlYOIGc4kB5rUro5jds976/t/FttQvxXAMu11nIHZyo?=
 =?us-ascii?Q?J3Wj0eVkJBYl6/TeXRBdOnfoqtj4fGRKxnhudYL/fT1/jNH2OB+4xO/73Hjx?=
 =?us-ascii?Q?umZQBo54n3aRwU7+WQj9BOsGsQnwso8nD0CZoggatllSsykvrNCJdFyqHrrp?=
 =?us-ascii?Q?daRnTchxS+qF0ZUOcsf2kzkaBFFPqzJszANwyvUv4IKQXsytbVNM1Ua6iLWA?=
 =?us-ascii?Q?YqHGrCql9rQa424vN7PVsTxHaCL0uZLRzn6qg1GdUfVzmAp/AjM+bvC1PywB?=
 =?us-ascii?Q?Wlj1ckwJjAJaqJYT7/SlzloK9LbuIMKaTfsqK8ujCfmERW6iYXSyGTqTu3q0?=
 =?us-ascii?Q?B/r/tcFDgnbEaSjtA43593HXVVf7emY+0T5MFvN/83N6NooLO1OeVyEIyXtY?=
 =?us-ascii?Q?W6ynyAX2z3qYVIWb7simAoH53dAkOI3QropOLPqRlIUhkvgLQgdqB1m6Y+2c?=
 =?us-ascii?Q?QknwDkVHXuF80HCsVA2Ps6lnhlDCdDLtl60GjrM+puWsvwgfcBYbQvxuAwGm?=
 =?us-ascii?Q?MMmPKFJ/Imu9UZPxmygcUovXji7ndqxVPyjq/QTYiVohxaRQIGNokOERRcxE?=
 =?us-ascii?Q?OL7ZZMmEESWMadoiAKMrxFev0+2moa6CpWOqTe43oY8q0bquJ4PYe61Kaimw?=
 =?us-ascii?Q?y4Uj3jx8NRdXQZsYRwApcXolJkJMv0x0fC2mwtHbsyIOOZiD5KazZgGVEVhM?=
 =?us-ascii?Q?cCo5lLZk91sMUA+gaeumvc9MaJM383TcXCJiT1qvX87KsGXra2CmL6ZS4QJo?=
 =?us-ascii?Q?W6qPHo6PW7NouqABtPoplyD707s/c1S5smAYuNKz4ZpcTtjZkJzqPZ3CmC1I?=
 =?us-ascii?Q?6HDjgUoYbV/hZ2xF8JYr7ctI1RdLCHr8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:44.3409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62bc6c1f-b0a0-4a9c-9d4a-08dcb172abae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8406

Currently, snp_guest_msg includes a message header (96 bytes) and a
payload (4000 bytes). There is an implicit assumption here that the SNP
message header will always be 96 bytes, and with that assumption the
payload array size has been set to 4000 bytes magic number. If any new
member is added to the SNP message header, the SNP guest message will span
more than a page.

Instead of using magic number '4000' for the payload, declare the
snp_guest_msg in a way that payload plus the message header do not exceed a
page.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/sev.h              | 2 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 79bbe2be900e..ee34ab00a8d6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -164,7 +164,7 @@ struct snp_guest_msg_hdr {
 
 struct snp_guest_msg {
 	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
+	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
 } __packed;
 
 struct sev_guest_platform_data {
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 3b76cbf78f41..0b950069bfcb 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -1131,6 +1131,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->dev = dev;
 	snp_dev->secrets = secrets;
 
+	/* Ensure SNP guest messages do not span more than a page */
+	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
+
 	/* Allocate the shared page used for the request and response message. */
 	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
 	if (!snp_dev->request)
-- 
2.34.1


