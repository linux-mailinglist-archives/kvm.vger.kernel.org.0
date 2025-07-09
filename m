Return-Path: <kvm+bounces-51863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D868AFDE6E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41839566DF8
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A6A21171D;
	Wed,  9 Jul 2025 03:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MF7rHC62"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC378194A44;
	Wed,  9 Jul 2025 03:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032534; cv=fail; b=aUkubQCii3F5sVBkvKdx8Ld6zPFM01DFwh73dvPOMP1kLMU0YaG5gyi9qgeE3QTwj9jKhFkJNcNaw01AXG/6e45CTw64LP44cthUoglew/xtCxQaX3PHSrAEZDUf4ktJ4r/pT5wzdh5vvjoIMk8/gnZHpgj1+tQMTr4n9lmCWX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032534; c=relaxed/simple;
	bh=MkBNEa9m33ocVOqrBKzbWgF+IXk4GKuqXffmWitD2Go=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrWN0N1q25/yUxmWqlKaPB2itMQPSYAKi5SH3w1W+PhV9ufsy8QNc5IsUY7fZaxXzkOhsjvb5Yzv0P3XifvKKv8LAqpj5cL07IupLLHpm4WfCgou3632hto+SDrd+H2RIM8gk+CowNZROcXWI7xGeX6jA9+qQiG3U5+cPxOuxuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MF7rHC62; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUVw6LfCr6ecswVeO2u3d+HxD4T3HsBpjwuqyan/iKa5zCz5zUymxJN+hD2D+5lZvBur4/i60IWRtqnTSW3meKXadrBwvjt3nNFfEX7ZhdpIouXZOk4bawWm5vkDFj2gsqIv9vR/znUxxrNL8+5wPAvMYEksZhcHcROheItB1W3d6Yfxr/ZmZzMsK97eAZJfLVWrgTsDcyeqAbG2l9Eyn4Hx+JmAiGiMmL2xh+6tcQ2CjF0hYJNmPUbxEu9gy4/rWz2SEN7BGZObP9D0rVgeLx09M4ME+x7AZKkLjirJYCrMlJtVVszSd6yzjK9HogZf8kc9B2+V6jGxQ5aVYlm7wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8/f6FtC6XhnC2wW3q5ybttmY59k20Hr19O6r4q+I6g=;
 b=Yrhs+IqqgG/T+n8B/IP2cYAHCiD7NMScH1jCFGWq7DWDYbgAAhI2edyUyyuqIwZtMuz43C86ff94TfvheWvU1eUqWFBQnMzbRkDV7WNBQRewURo9cy8XPbQm5Iye9axmLPYrQqub8Us1ZHAfwH0gFNrADtz2SvIYLxIOKgEgtypjKYOm2xiNaRQwMK/5XNj5QeyLPQG+SAXG+vRDg+R6Z4Hl2SmR/2IDDlXH7qmHOHy3t7GMunTgBPjs86CoRT6RG0/0ExUfOnaa4v6aXG33dQTw90VP9iLk/szHwJBQfVtEJ1QCkW7v8u/VR2T4MVmi8KWQAhAWvDFon5KS9Dt1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8/f6FtC6XhnC2wW3q5ybttmY59k20Hr19O6r4q+I6g=;
 b=MF7rHC62A5+cFkRJw7py7QpP1z+7HiwUrGlhNN53JT0HpOmNv4IjW+cT9QKL/ltLPREQnkkHgWC0VDTq3fjrnk6nL56GHrmTnvbQoxq3Ec10yiFzj2yvTSaG77bU1uFBHbDvgkst0aBO65g0OSiMA4SQ47OjnA8VhfcQFYUUjOE=
Received: from BL1PR13CA0066.namprd13.prod.outlook.com (2603:10b6:208:2b8::11)
 by DM4PR12MB7550.namprd12.prod.outlook.com (2603:10b6:8:10e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 9 Jul
 2025 03:42:09 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::90) by BL1PR13CA0066.outlook.office365.com
 (2603:10b6:208:2b8::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.5 via Frontend Transport; Wed, 9
 Jul 2025 03:42:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:42:08 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:41:59 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 29/35] x86/sev: Enable NMI support for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:36 +0530
Message-ID: <20250709033242.267892-30-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|DM4PR12MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: f5aba912-7190-4157-c7ef-08ddbe9a94ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jsB7lBYt/Aq8k6HFOSJbuuYDTwuNz/AXTBshkJCC7IEtE3uZqEPqiZscXkCD?=
 =?us-ascii?Q?g1jB6CfF9AXIIvC8Eoq/oyDV/kntzuDTxePjVgN2G7E63vcYDMj2xadVhdwY?=
 =?us-ascii?Q?fUcrAWWXhyRzgxqOedmEGBSrR63GWlOux2hgBhyacj3epE28cFJHavAxXfV6?=
 =?us-ascii?Q?JEoPKrJag8H0shDyTEYoUS2ZsTCV9TV7zGCdD/BXlBBIBST+N71jDCoTWmsg?=
 =?us-ascii?Q?GgDFYsIZoJLnvSZnTx7uw6NJYgcTdjnSd6KF+WWWsvErUmmNdXfrFsZFuf8B?=
 =?us-ascii?Q?lgeV54kPDWvn1ts5GPy82PvjSEsCr+SVWXJ6G+TKVU6F4yErdtbTSEUNy4+s?=
 =?us-ascii?Q?5Zwb7UxSY0ETtq+1fvRC+72QABwMXz7pvzK6jc1z83TAQniiY84hm20pKMLP?=
 =?us-ascii?Q?+gfCecQKzPgCJoI6pj01nnGAa5F0pt/Fzu2eWbpZIR0SV47sTacGn2n5KYox?=
 =?us-ascii?Q?/eVz2Szu3a+8WtDKL4C7KGfgRyCiUBnm+IGjURSf1y6k+SMfo1KjzmUMCE1U?=
 =?us-ascii?Q?qjlU5Mq48KVjHXnwDHeNSZ9Ga5OXbQCO9rY1WmqODpjx7I6yZzKSAiAyCHVY?=
 =?us-ascii?Q?NFZgt/q+ht5ogyODvhGtvLa+XQgp5H4w6W4y+j71xfh/fKc7qlIV28cwzyUY?=
 =?us-ascii?Q?KqPKVqh/dRaYWsifroMIbjj+NTpIHRuulCWqrgAQ4yi0C5TK9HkUeRxfW2Nn?=
 =?us-ascii?Q?nULmzBpeKSSt5aMplzvINh7WBUWKcng0QMeD6E7UwWAZ1Igl+2r4YjJhM382?=
 =?us-ascii?Q?73R9pH9JwrwW7WEug+opkoreHH/B40xh8lDxwc4jik6YryDj4o63FwbVDkeZ?=
 =?us-ascii?Q?VgOtDfezmK6m6wQvuoXOR3/sP+6Yqto5jpYbU2+dUv0lmS8kUko92uexh+B8?=
 =?us-ascii?Q?TrTg4Snr8NJBlDBi3v0QGoV/sXL/HAX8PA82aeagh2Qd3Fq3xFC8Mef9P+Ak?=
 =?us-ascii?Q?BRwYW/I7NFyks1TJ20j0L/N/aOmCJavCBRJQtQON8rz0nRj+hUd3JZEGKd45?=
 =?us-ascii?Q?G1V8BVy9/5YvrUU7TUMHyvXpXHgY+gEgsyFqXqwYtLri6DnCUwdNR3+Fqx3t?=
 =?us-ascii?Q?Sv69nO2wQhXZGi32HACyPqIW6QgTQU9dE/p9FC2dWKc+UdbkYO3DRo0VufUO?=
 =?us-ascii?Q?pw8zvFXeIDaSXTKprrZPmVLwkTXoCJXxQMqcONKbxgOwTQQI4+lEpkK5l9iS?=
 =?us-ascii?Q?XruFTcDmQfZEI/2zgUTm5jgf+ty2hJGsf0LlaLTMnXRMA+ls/MzvlMnhTEaE?=
 =?us-ascii?Q?8Bidb7D+vL06YbZQ5B9I2pislvvWo3UtK7Gls8uRBzCbpa7vThCpcmxwu8Q5?=
 =?us-ascii?Q?4RF9qsxBHZd1tMi+EtoxR12kJSdagLeV+QR/wVqR2wyFWdHI2lBKMsszGJI9?=
 =?us-ascii?Q?qtYdx2aPXDS+H2/wqOcDF+kej4FAI9/hMvCI7XL77eueSEcUtvE2vvt1/89s?=
 =?us-ascii?Q?ckIFNyaAqOpKJAPpKaJnScdyYt8mYtKrOsP/s3LidcqfGt92bo7sI5B9tOiU?=
 =?us-ascii?Q?t+nYPqnlotXCcPNPRNueLFk2Sz9QsXBOvIKm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:42:08.8825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5aba912-7190-4157-c7ef-08ddbe9a94ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7550

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e341d6239326..d7c53b3eeaa9 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -952,7 +952,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


