Return-Path: <kvm+bounces-29239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FD99A5A16
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:00:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95FB6282B2F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646FD195385;
	Mon, 21 Oct 2024 06:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xDWr4Rnn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C801918EFDE;
	Mon, 21 Oct 2024 06:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490437; cv=fail; b=YALOM8cdqR4L37hz8CNj8c8TekgBguN06LOtPQtNJQzyPaBtxKD++WImKVofsa09iHlvjnwEBcSYda8Ra1bnK66n8jE2QQutgubR3hF8YJbgbw5seQQOUMuoZHpbdhkfGnMabV2Cecsb6L0QT3DeA/3CVGyiUhkoAgmAmEn2KF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490437; c=relaxed/simple;
	bh=J7ITyZv4fTZN+ZfiudI2wlQZ6XlSSdAR/6O3kPxxatE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mn3bJJPRbBhN6gopLApyc7lS/uVgoa2oX32wzmt6zMxQLEbX360/4E3w2bFy2r6tihCap/DwZi860lCdQ4KmjmAVsqOzGodKC/F6R1RJQYE5Bn/tu2JDHKMfLMwneKHUSj56Q5qFv5geuIL3oLgeqNBoWYw3Csl8kWE8atzVDAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xDWr4Rnn; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcEchYhZevfEtFGnuZ+nlsOuENLSb2V3DYsRtffjElg+UXfGVJHrhomALqZ9lWghiHx9kc+6SK0WW/RZMxGTbeFADIBnnam9dFUXdbxvzqesaewUIN5ks2LsVI2EryoCJrGVvf84KSM7UW4E9BCGC8DvDxhDoesfMA6pfgv0mAqAa79SkXoeR3S4X+hW3BoSXypJFUohdcgG5KARm0lwa4TZyGgDm+s6DEJPBJ5JUoYKYKhmSyuXokIIAnuiYjv2deAuj0MQeO9EjtU0RNYwFUtY2S4lRK71WBO5gxjP7DHpwoEgsXPm7dag/JXBXooDrGoYyWXbLBqkRMDPIGhYYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=Z8ZGa4QP77M55sDDx39lx7dQDnWy20bLTARqyy42eGFnR0IdZ1BxtLAxxLsKsIH4s1+RiqExICV3P5akWveigWfG/NW5pee58qvFrLVInWjMqcNUD21xx8Xd5vEgxxJsfvhq9L1NETp47KiM/SUE7tvyAh8F4OqXQhSolKFFD2pjSTGSt/BL4EwFV4QCfVLHeP4EE5sSeQFepXlBNTIPEdMTOTxiwTWJhLEqs0sJI2WZgOx9+L6Z97/hlVeb6/Vei2lPvftw35KzZzdQuew2Anp9H2hZ1GrU6oEmuVeBB1J6Bb1YzIr111s48xcFlkJYbUqQRsE02HwfV8/A0c8KqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=xDWr4RnnlDTUUDW7/QL8BOP2sykK5NzK8CamfJ1Fl6rQjYhht9fvxXxnBpNgcvJloRVS1HgNT2ZwrRGFckX+VzDzuF5cdjOXIi2syInxh7jNjoO4jttR3NO5pYcuazFs9AqqUu29elAeveTX8VCzQkhXMSbDbdQQsIQbZONjMhc=
Received: from BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45)
 by CH0PR12MB8577.namprd12.prod.outlook.com (2603:10b6:610:18b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 06:00:33 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::53) by BYAPR06CA0068.outlook.office365.com
 (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 06:00:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 06:00:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:59:34 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 13/13] x86/sev: Allow Secure TSC feature for SNP guests
Date: Mon, 21 Oct 2024 11:21:56 +0530
Message-ID: <20241021055156.2342564-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|CH0PR12MB8577:EE_
X-MS-Office365-Filtering-Correlation-Id: 80832fde-c30c-42d4-106d-08dcf195ac80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CCufUdBd/xzuH6NZs4y792y4clV7YR1ZWuE/ugcFq1+orV49YBYp9svAqgaB?=
 =?us-ascii?Q?yFV+CEKOIzjul2+GZq0miSSrXIyYOFQrNNDSt2YTMB6495cEBITUGiLkzg9+?=
 =?us-ascii?Q?6h6QVheg7puu075jsTGEA4jYzo0o7+tWY4PA64mfvKJ/k63lFHtEpYUGBkdh?=
 =?us-ascii?Q?0WPMKme9RWG5cPf98z4EeLaJJ5ebPs/UFKuAtEpXJuljinzdVntY1F5koL2h?=
 =?us-ascii?Q?c/dAqZHpHRwEAEVPL3bKyx5+3k0sZIpTBDLb5gK0MH1ip67B463Fug/O7Z41?=
 =?us-ascii?Q?XNdUein7mrxi7LGoorAvVxWNWrgA0fk9PIcisgKhQ7xq7vt1PYun+1h2OmoC?=
 =?us-ascii?Q?fT26/h10IfdZmYSM3IVk1HEmGXq3LmN9xiOdvpQf79NEQxlV30kNoAbsyBxV?=
 =?us-ascii?Q?SniS00BCtVO5BkvZ75m75lWdVFNlc1Lx7qy13DvTUMDMS9O7A/QbxKz3y5fz?=
 =?us-ascii?Q?69/4mwDj2DJQxdAMwCsmApXDK6rcUaJMR4yF9M+vIu2Pj6qRfRTnoIjCaPJb?=
 =?us-ascii?Q?V8IXiKkVmqmoBmlh0XvdKlBSpXVXxYV03SKRRsGpvW2HqDbAvsKhnUnIJuz8?=
 =?us-ascii?Q?ibXl35rYcKufeYaGIJu0oeifOcBPfQx9yBK0t2cwS5xrS4nJeGQAHWwbA73E?=
 =?us-ascii?Q?qCwdoRh4/Tp39u3iexOeDK2+frLfYLOdtCyeGwWrlKkZ17XKoLEw+/SDZyqa?=
 =?us-ascii?Q?47lqLxp8W6YxWjBlbzw9tO2Puslv8KKw9RjEtbO09whck1R5e4bRbpUZBp8x?=
 =?us-ascii?Q?v8AuIK27ArF3x5Xtrb+8QxAK4Cf23uen/FlWNQKEbe20HnvgQCkX05Tc8xuB?=
 =?us-ascii?Q?xsEpNtHsKWJOoxaswE9dRvJWsgdsBSaxY+gBRhKHvY5mR0T0IcKbXZYXjXXt?=
 =?us-ascii?Q?xy6r0G++n50lNL2K5ZTiaw3s03iHh4Jwp6PoPRh9dyPd/LJz/a94tRqKsib/?=
 =?us-ascii?Q?MATU7iuVslLGKVhmg92NQUi96TOyHfg6KQmiryGdVNx9yusnTEY+24eh9/7q?=
 =?us-ascii?Q?wRAeXGRyr3+0wOXJlDncf3Wj/yqOzhPqpyVuxj7D+JQvXcK9cWrEi6oT53sN?=
 =?us-ascii?Q?l4gnL9DBufk6ZyFAtOyMbKGuwwb2Ps2QuJqrF1VnxTTGSkVdrwVb9XAdhbmK?=
 =?us-ascii?Q?5ZdaE+/cWhxLr8RWebOBN0FXTq+Cy78LeMtsp8b1/PLD+42UMs2iWX6mmK3P?=
 =?us-ascii?Q?yyhbP9qLxfrcVy4Ob3QN9MM0uBVe87WA7LVTX8r7ylQDQ05LoPMtAcWnGVYM?=
 =?us-ascii?Q?flDkCmiINzE3wflH/iEkCH8ISwLJO0G5Jnel6Yj6nREyvcBWNNkpzQtGKyiX?=
 =?us-ascii?Q?X7+1pvMrpiRBUX0GNWpOo6YOVegm2BK+rTKPQXUZFwNXIImkvqoXjPPJQKfO?=
 =?us-ascii?Q?ZGV31C8l222piUl74b3b/+eiosH5t6iMhGF5E7P7DLMVxDYI4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 06:00:32.4700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80832fde-c30c-42d4-106d-08dcf195ac80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8577

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


