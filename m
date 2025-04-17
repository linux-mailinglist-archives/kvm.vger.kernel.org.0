Return-Path: <kvm+bounces-43551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E42BA917AB
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C079218913D9
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CBD535D8;
	Thu, 17 Apr 2025 09:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="St4OBVdn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36361F8EF6;
	Thu, 17 Apr 2025 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881776; cv=fail; b=e9A+1fj4FxKjAAOPC3S799+a2NGLJs/EM3rUXLCRZSlVkdF3BNt8RnhWlVSkF92yRKBtk4zDek0sIxkk6pNnqfz7/cP/y+SzojJwRJjDJnPMBM1OMlyTHRia5AV0Tp0wn9SocBk1EA/OL79a7WkqnD/99sg9UdgP/Gj8QcWjFeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881776; c=relaxed/simple;
	bh=xEUvlrXk4EWRwYXFn10rQBgpOBmW6WQ3Kf9l4qY67dI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRpW8mABGxsXbWTBoRRO2VYyiiVuSYT31pTE2g/ynyycuHk5BxiZf0UzBUgKGRO0P855D5hgWKc2eDuvoG/2BphQFv62rsKdnIhueHcROtIQICuiWxtOyarH5hPvQ3mtCfiniJwWYTJUC8LYnK/aLSQSObLbMHFk02we2hhYZHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=St4OBVdn; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=am69RBdfkWt70aiMDURMg30plX2Nv8CVwgGHEoDax0sUPjNxtCayHEv+3Jvg0ty2e/YLz65ZvR6jyYyV+aDSHmkyMwEXD/urfb0PN/WBh9oNQw9bKqvthM0hLTmkEcVV6ODdLq0Ucfo/qYmSlldHxIsnMt1bhVB43GBu56LL3YrDWSoBPr7j2UQut0vzzijrGyTYqdQNEcfUt/1wZjBruamPrPgeoAREILOe5BnZp8spe7TEYjvgSjZID3KIXroYRAfY+QmTmAxnyakH21x+OPU77zIOBUCrEa332Kt9mO/vWQbfX1ZkZO0nrI+7JpcM7Og+DCmrzE7MKP3QCr5fxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nP7Jxd0pGvAFO7x3fzBXjfGdpFy6E6CXUNlASVE4e+U=;
 b=EoLRx/A8WySw7SPwRh/kN+P00lXerXccIOovzCl5MEU3xlR9kOAObM4dZkOKv571FFsxMWVnvldcufq3Ps2MtxpRM5H2a2OXLw2s2IJRGzckYd010mvVN6/3H1YM2ALatQI0BELEPFWKhGha9YHOwtSHUakv3QnATSWz6XKr3B0am6USaC0bK4QGFKQcIb04S0uZvkOg0abdo7Fzi+DVdZ72UuCOqZ1rsifr9UrXG1Dkb9tcJgdzkeKDkExpPdRrJqRc97Ec4aDJUhqlc9+ED0lhKE6NdeAlj2rnRmczE7qRo8tDLfwqlwD35AFZ5lLA+1nHC5E9J009nRt+Wa0+aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nP7Jxd0pGvAFO7x3fzBXjfGdpFy6E6CXUNlASVE4e+U=;
 b=St4OBVdnI07u+g9gb9QyFB6NRlqsjIYxIvJhM3OOgSnNvQ4OjcWutmfiKgfSpQd8d3B2ctgJ7bx7jQmZUh+2uGvLWqsheY8TgwWmc0g2EuMK5Jm9pj0x9DKSRlZzupeT/B1qzK2D+/H8NhqTv0SL+EqzwM77iZzREPRY+UmZ5xU=
Received: from BL1PR13CA0019.namprd13.prod.outlook.com (2603:10b6:208:256::24)
 by SN7PR12MB8104.namprd12.prod.outlook.com (2603:10b6:806:35a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Thu, 17 Apr
 2025 09:22:51 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:256:cafe::44) by BL1PR13CA0019.outlook.office365.com
 (2603:10b6:208:256::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Thu,
 17 Apr 2025 09:22:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:22:50 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:22:41 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 13/18] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Thu, 17 Apr 2025 14:47:03 +0530
Message-ID: <20250417091708.215826-14-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|SN7PR12MB8104:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b27debf-d942-47b3-7a4a-08dd7d916cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WJjpTBII8OmNEWziZ28ZB4scftVNqxEtQcJDpK/58Yyztpup40upnLvtRySG?=
 =?us-ascii?Q?4pEiTudk/Ku3ZzhfeBsL1OZ3j0cuQMlwWGvHZMLnm71N1IqOlFsYqYzkA6+A?=
 =?us-ascii?Q?C3Jts/YN3c9YegXzUUJk7KBnAjaUSUZT5VHSEUAA95ulNW39C1gllbCmch4f?=
 =?us-ascii?Q?WFW0TO2Zrya3Qb3t0EXmyDfI/Dt+w2wJfIVoCSCWoxrGmYelcDlefo5n7g3F?=
 =?us-ascii?Q?x50VChnbZS4IZoK1ftKPKBvWIM0FSiyrI8XgFg93of5YopcgoJunUfepIuO+?=
 =?us-ascii?Q?PBz9bont0iWwvOI7AlgLWAVA1p/q8/TBmA15t0y7rrVOkjHwCLTXZOOQsrfp?=
 =?us-ascii?Q?vJUEHtkuN6gJqE5g0DwmCA3QTCMoLewouO/+Aqc99H61yBpVyZoVlDpPcJGa?=
 =?us-ascii?Q?zbJvxz4m4uWijcKTi0IGmIS02Rs9dt0FkK5Dkfs6t6E5qxmcC/aywUHXUE30?=
 =?us-ascii?Q?RQXNFZyAUO8kdHj/lMLMUsfN9vGkHuYt8aLylxjhr7uqb9g7wEFGb4N8DjNf?=
 =?us-ascii?Q?9EYTe0W75gLsBXTT54bZnH//4WZqvOOJhujU8XfHSzpxxtpOfRrmbo4SlQwO?=
 =?us-ascii?Q?e5s/k46pMMQOGjeYsfn/spJshS4ogRQMCa4zg+wPIBgM9b0ZnLBwtPcbaxrR?=
 =?us-ascii?Q?jlynIbieYk0KmPrBCh/7GQLygZuplz/Jrr5HQyHX068HuHDEzO/6azGdt0oo?=
 =?us-ascii?Q?Vn7Xvy0lvswQTphf2cUwdKal59pAdwgEREm3LzJebrTbdPEomZ3wbHra9paj?=
 =?us-ascii?Q?MFltFuDWeUKL95JwNkEDFNAwLCgBUIB/hu0yN9iu0SXVz8ScTnLnamuzqcpb?=
 =?us-ascii?Q?7qWg75ieknZZ056fmlKjNoUCcedlwQUpS5cKvUCLg8Epp7sz8oZ/aUGz5nUc?=
 =?us-ascii?Q?ILYLjgf652LkucjdXGneBD+KTJSoMdhKA3THpXkiNHt9Mdcg9dxf6mxJsqIQ?=
 =?us-ascii?Q?CdygqkcrRdSIBP9sEiTDziodUhh1mDOJ/ln1IenwCiosoGkht8podc9fqgmg?=
 =?us-ascii?Q?ZZ/wruJ8GtMQAZFZZtrzI19KJ1S6axppN+r8HIyNKSRWnWfIeBiEI1btBuNA?=
 =?us-ascii?Q?B5j1UF8xbsEdDxj4J+RF5qLx5oT6yXbpY0GJu8mzOR9l1VTTzdT0o1YJpsVz?=
 =?us-ascii?Q?psGwPZxYOzyzwQrvufzHdWoX54chRIatQefqDsRpGNMFQSGHgh9DZ/h3NgpF?=
 =?us-ascii?Q?bpcxwbMWb0iIiURXiYqpuDqFDaKx1PINkwSnbWY4DdQf0AjBk74CDwBQWJsY?=
 =?us-ascii?Q?cEknlDG9DLrg29evjxFkWyCKLW1Y8YvWiNGfI2YRuujx0ywEe6acbN+X4Ec3?=
 =?us-ascii?Q?vXZMdprZuRGFr1GuaRuEpAF+1reetz7byihe4rRla30v/g7+sNrNy6K7dm9J?=
 =?us-ascii?Q?qXmI5QIl9e2fHCX4r86f+IZkXgNQ2qPaIMer+i33l6VBVRSeJpXGCgM0hq1U?=
 =?us-ascii?Q?37hh53tdmhAqOcLEbr7DcT6kb5XJDXf9XJO+/2WZ1HHaUS3vVnmJKLrQUALT?=
 =?us-ascii?Q?J1PlIVZNvRkc5RKW4qgIY7Ejo2ZATgNqd+L0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:22:50.7794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b27debf-d942-47b3-7a4a-08dd7d916cf5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8104

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the Hypervisor for Secure AVIC guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 552581ce6b36..f113c04b0352 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -97,6 +97,11 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -107,11 +112,6 @@ static u32 savic_read(u32 reg)
 	case APIC_SPIV:
 	case APIC_ESR:
 	case APIC_ICR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -160,19 +160,19 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ:
 	case APIC_ESR:
 	case APIC_ICR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


