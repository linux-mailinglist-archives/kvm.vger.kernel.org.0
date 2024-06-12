Return-Path: <kvm+bounces-19497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4A0905BBD
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8191C1C23B56
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCFC82C7E;
	Wed, 12 Jun 2024 19:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qc1DyMgI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C11EB2A
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219560; cv=fail; b=t52fLX1CdHlSrXxhxVrWH93ouL0ERJkng3WWe9C/98cKkDwCDKsK2jjwKd4WPKiHp0BN9LluMcnE64IvD/uEJDCmCJ9iT3exq2Hnv+UwW2RbGkc+sqq1FrqAro8WgL7lpRUfpiDuGLVOTpnQAujo/0nJID4YvUah5KPRUyNevLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219560; c=relaxed/simple;
	bh=Q+npuagMERFOb7ijCjubQ0NgwrkCw13Cj9+fHhLc7KU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiXqo3kO1BvYzZvkmBZN1zlIZVkcGWlN2qW5PyJfz97W7CDfuh+cPU/VG1NkBe4JbghuOfemHHIs4SnmqrwdfH4T7b5O7MLzvRSOGmIcxwrsrK3udnhyjo8MbLQ3rAbm0DwMTdEVzulTwzKpRw/Ls+CUPm1VgdJusfdU0RN5e24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qc1DyMgI; arc=fail smtp.client-ip=40.107.92.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC+A6jTrQO+xZ58bTBRTmV4Iy5XUkTKNkezBg1qdRxD+pQBofyCnCKxARaLG/oSm5sqHPAW0Dr8kOgSZpis8cQkplm3mkmRzZQShoKcCLtERmhAzlNZqZb+o5pKFi6NJ07jqXtGfP/b40RKRN+D6KJk3T02SxvvEvRi8sdCDO6InIDwR8Ctypx85M1VRdNGddkQpf4TZpQXxovclltIRMEmMcYluBAAoJ+6mK8g+mR6tdbL8om7FAGxKJc9BAaYFPwHXIkWAnxdXXBdEeOKpBch91/HgGA4bsBwYpSJGdjrx/3xm66204CPEY9hRdyldHcQKkpsGWNM4vhcB4zlUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suzcerVuTrrNRWy7kWm+wcFfIkx7AsB60FcSu99qWps=;
 b=EuenX68l5Dif2MDO1RGIwOMuyJfxCkftBRJm3ikgnaGlPxibHp922YSdWpzLI1pERyYNl/EURgDDbJvDzUfCG0Vu6xy8MOmMI7FpXbg45aeD50o4dIIxtpy6U6aXJvPf5qKSaH850zPS0z/pDzzuNOmjisqVMwAaI00w3A9uzDyRnY1zdS+UEpA3WBEAw//aRWIDNvp1tcIj/KvafwP1p+Z5ozP+UeEELBJsIsjkOYJfzbXoz0zjnpRREvlgERwsFsmn9WCYQc/ODNVwbOpZW0DygH+OL2DQaUkuCcDXVH8LqjOB2TlIogy3TOPX8OFtDwGmOIF/k5tIvSyjkC0fbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suzcerVuTrrNRWy7kWm+wcFfIkx7AsB60FcSu99qWps=;
 b=Qc1DyMgIu8dm4PtJLIG2F/myNdnEPGkqUkq8h3KJnT3k3dbc7JY1ISAxmy4SC530uGJQGyid8nQbrZxWQ9weoIITMGXnia+2+Mu8GhvEtk8010icpaW6AhDdJdKKl0t7Lj1K4zCzYXTb0C+ARkWrgtyTDHQnhDTq7xVHeKbIoKo=
Received: from BYAPR07CA0071.namprd07.prod.outlook.com (2603:10b6:a03:60::48)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 19:12:35 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:a03:60:cafe::42) by BYAPR07CA0071.outlook.office365.com
 (2603:10b6:a03:60::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.23 via Frontend
 Transport; Wed, 12 Jun 2024 19:12:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 12 Jun 2024 19:12:34 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Jun
 2024 14:12:32 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <babu.moger@amd.com>, <kvm@vger.kernel.org>
Subject: [PATCH 1/4] i386/cpu: Add RAS feature bits on EPYC CPU models
Date: Wed, 12 Jun 2024 14:12:17 -0500
Message-ID: <9bba9cbb783da2eaee4e385bf3d93b7cac2c8c77.1718218999.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1718218999.git.babu.moger@amd.com>
References: <cover.1718218999.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: f44c7e3d-b65e-467a-48b2-08dc8b139e1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230034|376008|1800799018|82310400020|36860700007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nQAXHBxeeZZTJq9OOtjqFj3/bzQmfWVby6ljl2yjr+fyYuiLxTgNEhHmwCxn?=
 =?us-ascii?Q?MXX5qsLb+4p47s1XZOfLUb5tsVwdNasp3WlqJAXBo++wvZdEhrD7k2VU/66x?=
 =?us-ascii?Q?mLWlu2DYLbpXsjmNBJcxHhU2ICD4uqggWOk4pAthTDK9kmUx0ZZ2NUZXWheI?=
 =?us-ascii?Q?RhYTBug8ijleK6gPil2ws5ewBeOdrEVaIK4p0hZyBHiOGHZAfuX8y67g8QIu?=
 =?us-ascii?Q?objGcj9dGHcWcLX4S/Ks0m8J8AtVyBeT3+2zXf60Zf/NFZ/1pg7QR0QWzUhy?=
 =?us-ascii?Q?DSgTF1Rz9517+0GyAgMDSMl25sSfYOO1yw3yOjeagLGCPlocSOJFD7BrG0M8?=
 =?us-ascii?Q?2UCENCbTlKWhHaUdKFKdcvwaeyxb3h0D6BwLwxEScYstubtYPIFv08H2tU6G?=
 =?us-ascii?Q?a3+XILfWz8/M9Zoa6s46bostihh4XI/GEb1KpTLBH+9hdrn7Ew1+4/n+EJDy?=
 =?us-ascii?Q?9tFyPILl2fps8t+uZ8tdAPmGlNsdvHBpmDoj/eQBsbhkRAX5PcFFKQvqcGyZ?=
 =?us-ascii?Q?KuPjXCNCEOYDEkLqhtfee/tcy38odNQqgNidl2PJQuoRRSZwxlqi5HmLC65h?=
 =?us-ascii?Q?iFMZM6osYewCcnMNbpu+CEkOzcRM/t9AZoaBIq7/HCzn6ChYm4IhhxChFsNW?=
 =?us-ascii?Q?EGg5Ydy+l6sEFFMlP/r8z/6J702pMk81nIu+t7LJ3S0L3yF7fqO/73CILLab?=
 =?us-ascii?Q?Vt/JkRorKy8HmCj2jL3TMDi9k1y7a1TzQnEq3KCJ/+/QF7J5Sm8Mzh/AKIj1?=
 =?us-ascii?Q?dD5Uzoi2iM+Uh+Ovvzo2mmAAJCHtFDJwmWjgRoBVVbz4J2MfDpGnhWci8yQ8?=
 =?us-ascii?Q?/kD6xj6RVVH8zAQxu7vB6HyLEKT/eP34fi1qs2BiAnhbGkmz/ifZpvst/KxL?=
 =?us-ascii?Q?m4OVevpLDSYGqlpuYAPuCGs7SL44g7MYt2yRMmvd+PCKhIbRd/AIOsEbUu9u?=
 =?us-ascii?Q?DPy41ULSxBamuZFiIpyEMd384dpaOhraocZL/5Wt1X4iotI2TJbnspaIA8Em?=
 =?us-ascii?Q?dKMKapmXgcTR6T8mwrNZteZyB8gI1N8rZ4Wa9ENFbqSqFTuGdSyWwTJImA4V?=
 =?us-ascii?Q?OWnXFtow1bCzcpytT+XqMq1p3/ap4hQb07kXXH0biqQzK8HShN67obD/gHLD?=
 =?us-ascii?Q?8EJawCWFdihgx9XqikLyM7MQavvhr5MpONUybPBr/xAXBvp4vrfV2shm9OCZ?=
 =?us-ascii?Q?1cIp4ZYo6PIR0AEu6sP8JdXwUrDW3UPM0UiEi0JQuZI8VZm9pIiMiZhb9jyd?=
 =?us-ascii?Q?Xms56tr+0CqV8DeMBuh10NU/9rZo21SkIhYRCoSphuC84zsZHKqGFosmLW5y?=
 =?us-ascii?Q?M78Il1cSuBTqD+KrITF+xEfXBGN20KJGjLiSLzYL4UWVBlppQBXV53zq3oUF?=
 =?us-ascii?Q?mXlbI3zV0uQj/Vpze/68vLCDn7f/MvAzXTc8IzrPenDjgabpaQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230034)(376008)(1800799018)(82310400020)(36860700007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 19:12:34.9623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f44c7e3d-b65e-467a-48b2-08dc8b139e1c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120

Add the support for following RAS features bits on AMD guests.

SUCCOR: Software uncorrectable error containment and recovery capability.
	The processor supports software containment of uncorrectable errors
	through context synchronizing data poisoning and deferred error
	interrupts.

McaOverflowRecov: MCA overflow recovery support.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 165b982c8c..86a90b1405 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4939,6 +4939,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_v4_cache_info
             },
+            {
+                .version = 5,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "model-id",
+                      "AMD EPYC-v5 Processor" },
+                    { /* end of list */ }
+                },
+            },
             { /* end of list */ }
         }
     },
@@ -5077,6 +5087,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 },
             },
+            {
+                .version = 5,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "model-id",
+                      "AMD EPYC-Rome-v5 Processor" },
+                    { /* end of list */ }
+                },
+            },
             { /* end of list */ }
         }
     },
@@ -5152,6 +5172,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_milan_v2_cache_info
             },
+            {
+                .version = 3,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "model-id",
+                      "AMD EPYC-Milan-v3 Processor" },
+                    { /* end of list */ }
+                },
+            },
             { /* end of list */ }
         }
     },
-- 
2.34.1


