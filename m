Return-Path: <kvm+bounces-56105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A67B39B9B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4C237B78DF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A26530DEBB;
	Thu, 28 Aug 2025 11:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kAhB4Jax"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D769C849C;
	Thu, 28 Aug 2025 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380711; cv=fail; b=Ysz2Qvp4LSO4vXyDTt8n/rHTm2KsGast9ZpKZhPP1m/OiTJ0QyaxwwgeuyUeEEdzQQoJU3JGmB36+3kl38gtQRVE1Dks3vMbP03Aeu/1qfpud9+iJSP4Ez4X0UZVL4p7fSFAmXYsC7Al6ioEjfLH+Th/fqCZvWCQ/f8acH2qF4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380711; c=relaxed/simple;
	bh=Ut7jBYFnF9fXUnjVlAGfQ2nN9XxjrT/bCxL/8xMU4+U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hUKr2u4x0iJgQVKITwTzI3VjtI5hGUc5SiPyDd3HJYeiNfaft3AMRDu0SM6GD2CnkekqMbLUIShQSSLchGVomrw98WufOYFZQOdnbAw3dZ8vemctNsZYtezbdcFqI4TK6MlbjgoUNUOFCgQOeESuse47z/y2p5qf8JHz+qAfr70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kAhB4Jax; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABP8sxWKOQHjew2YbfxIYTIczs6tPjocQlLfAIZdD8w/fZoe/2WojgFYXwowl5yejIO5M/ja+uGfITgf+EOmD0GBI2xpcNdsFOq72Sw0GSIwL8N7btu1Tzw/nxoawXqOj0c9m0/mm5pY+ZeDqCwp81VMsz4W3BUyE4UoaFYVwr49ujX2NN8GFa5I/JaLs5n7oKMPIGzfJMR0GGziT7RCO6mEqGsZgBBeIkNGu+zdlraB7o9tTqheDO7Px4D5ZuopQs/JOs+uh6lpu/+Tg3e5Kuuqabf86EeypZ7Tdjokx/QvPY2yvhXRYF2dUbGqRzTFFftOBe6obrkTPJtkfwlrbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VD5gC2ZMX2PpR1asm9/W/EhT1amAL8cDQi6bjjSQwUw=;
 b=PDflnUyFxMxWdEkxVAp8O7DL6wlLd+9XLaQpJYU/rdsgjJxikaRNLkYhcRNJiPxk/rRN9vUAOq35CQkfqHCTWpcYvWx7XMUgKgTH6JOvc906bYuF7tvj+N2ycxXjXGYWuBbfXtqkYN6q1G7FAG3ZMLDLbJqjncqSb7lZq0P5e1P5EgGaRnxQQK+L7rfIseedDVg1lts3V0Z3zQyANwior9baPKewSJAVINxVRjfcUrempd3loW69+c+lK1kVB7dEL/lj3NRfY2XzHXKyjipNupxRL74UYnUMuSfOBuN9PchePUVXsPltMYYq/apFa2PC3E/Mnv1AXZSuu3xOVSLV/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VD5gC2ZMX2PpR1asm9/W/EhT1amAL8cDQi6bjjSQwUw=;
 b=kAhB4JaxegiYrWUTaHDwZJFHkOBx7dZ6VecNmtcaa7SHHG7usgfvd5x4k1xA/MMm2j7V91JSMJDt2Sw7FZUjxVXFGniEgiwxEEi9vh1VeGXOVS4KCv+3rWjNWyOLEmsFgJUrAfKLNUkgPC6urj86yYyhWWUeg+GHGWH8kd47gAY=
Received: from BYAPR05CA0087.namprd05.prod.outlook.com (2603:10b6:a03:e0::28)
 by CY5PR12MB6648.namprd12.prod.outlook.com (2603:10b6:930:3e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 11:31:39 +0000
Received: from SJ1PEPF00001CE0.namprd05.prod.outlook.com
 (2603:10b6:a03:e0:cafe::e0) by BYAPR05CA0087.outlook.office365.com
 (2603:10b6:a03:e0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.5 via Frontend Transport; Thu,
 28 Aug 2025 11:31:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE0.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:31:39 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:31:39 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:31:32 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 17/18] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Thu, 28 Aug 2025 17:01:19 +0530
Message-ID: <20250828113119.209135-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|CY5PR12MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: d4142ad0-3347-4ee0-e9f2-08dde62674ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KvyXRgCFnzHM1B5KY6ixld636buNwhNop/theAEp4S2F+fUQ3HtZBln0lJLb?=
 =?us-ascii?Q?RcIPcEUR4gZU2COqeo5cnVg6tET1BYwO4fiMdbJMiU+nujTH+b4t90ELgsaj?=
 =?us-ascii?Q?hJuSMJAFuQeCU38/Ou5NgjbUzNUYP324NGbiHVAjiZEo0TJyS17AhSLoIq/F?=
 =?us-ascii?Q?OyESjjc61cCyiXScyyQHntjaMg5MKbLNKvxHpBhz+v812izpLfe0SDZ3TE3m?=
 =?us-ascii?Q?igoDTXY8JHSL5kEpZbbd2X4M5Sgc+EqAgrKmpcZZdCB2ThJi8f+0krJvKE+r?=
 =?us-ascii?Q?4dpp0HRKcvAbCyKzEl7nbbJDcQVgOOMjzB54qTnMzSYGh01JGD9DCYZvU+tW?=
 =?us-ascii?Q?1sciEbnFG498Q8j2BTlXT/1oilo9k4dhcqR+kh/YKtk3IbXFc+m83anscw+I?=
 =?us-ascii?Q?D8R6VHba+R0efD8uSGgTGTp5t6940/4j1DbrFb0FoIHvfpSKW2/Z+db6wF+C?=
 =?us-ascii?Q?yYS1muN+IpkanwOSJox72zPxh4Sqte2L+LxkeiWPqkyHqoeD2PZVoPo0pV4/?=
 =?us-ascii?Q?VBqPVL8ruy7OoGok/RIvbKj1ZahliJlloIhmWoF3J7dn8zALgotAKnRECu4t?=
 =?us-ascii?Q?U40yV6pML3/3fa2zmIJ80KO3Mgs1R3blARy+iVbu/kJueU+LSYqQ6WgYMKgf?=
 =?us-ascii?Q?/kEc4vDibWrCVQeiINe0G7N/c3lOGu4NRhvQOVYMTGAw7Yx5i82XKEsr3DLw?=
 =?us-ascii?Q?EVts6ytfOpOph9F1KOhCVeEgMpLVxiceRkE2Q6QHYa9mQxGbeHT49/YIyYRB?=
 =?us-ascii?Q?3MHxGYo4cCVrR03FQKwvfoEqzmrX5A0PIHNsiqQMR677wiEM6Ffjk/HcrnEF?=
 =?us-ascii?Q?JnX2BidNxoJTaj1j1KXlWEFNGFwmC5yS4RgNvFNhVuilJffkq5qF5z+Mvf8/?=
 =?us-ascii?Q?W4NXSkAfE6X1aeDX0+v7USRLi6sE8nAmcS+BajeKlQegcgjowjV65sInsRJm?=
 =?us-ascii?Q?hmLHTWuLu1pDINny21ePxik4pPJxtfW81/zOToDx2arJOoaMIcarPlUf/j0Q?=
 =?us-ascii?Q?9Agr0WVQ7svTn4xerFkJB+HYFW5PnRQFYmxqyOcYZR815I+jp/08hs6leBMT?=
 =?us-ascii?Q?87PPLqY2a5aHrJdm/mZ6GEHywbmNvJslSqK1x9PsIe10QwCPkbbc83jNq/0u?=
 =?us-ascii?Q?ogxXvi2QgwxdVC2rxH6JP0UXCE1n7KotHc4TrP/Aq7iFUB/8CqN/hCV5m+Pc?=
 =?us-ascii?Q?zjqN93kuVjMfBgCk3NhfQlpcQkUG4FXMKmjoCjptbd66IoRXTVa/+e009TDH?=
 =?us-ascii?Q?M2PtpLP9gjAjVCF8GSI3C/EFAXJ60jRLuawIp0L+qOkEacujREcXL22QX5J1?=
 =?us-ascii?Q?bzPcJmVZgPz9j8715zqhjWaUh9kf0TGhpI8+9W4CuZq7vVKmLuLJwBXwemdi?=
 =?us-ascii?Q?3KkhAVfvuAqEq2Svgtp2gvuBmCA7OI52MDUSpnwHd25VB8LDMLR6vMCOA//Y?=
 =?us-ascii?Q?KHVbpH5LTYz4ELRRUqni6YTmaQpFXFfSxw+cZxCPOaFW5tQaEzXkyB5G2KEt?=
 =?us-ascii?Q?kUtzBX2HJ5GwnL7WGkVnYTCUULzr++eaHjw9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:31:39.6766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4142ad0-3347-4ee0-e9f2-08dde62674ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6648

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and whether
the guest allows NMIis to be injected by the hypervisor. This MSR is
populated by the guest and can be read by the guest to get the GPA
of the APIC backing page. The MSR can only be accessed in Secure AVIC
mode. Any attempt to access it when not in Secure AVIC mode results
in #GP. So, the hypervisor should not intercept it. A #VC exception
will be generated otherwise. If this occurs and Secure AVIC is enabled,
terminate the guest execution.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Update commit log to explain why SECURE_AVIC_CONTROL MSR
   should not be intercepted by the hypervisor.

 arch/x86/coco/sev/vc-handle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index c1aa10ce9d54..0fd94b7ce191 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -415,6 +415,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 			return __vc_handle_secure_tsc_msrs(ctxt, write);
 		break;
+	case MSR_AMD64_SAVIC_CONTROL:
+		/*
+		 * AMD64_SAVIC_CONTROL should not be intercepted when
+		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
+		 * if the interception is enabled.
+		 */
+		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+			return ES_VMM_ERROR;
+		break;
 	default:
 		break;
 	}
-- 
2.34.1


