Return-Path: <kvm+bounces-56099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B7BB39B45
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D19114666FD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E949C30E0D1;
	Thu, 28 Aug 2025 11:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3W7KQx5d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C29630C62D;
	Thu, 28 Aug 2025 11:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379663; cv=fail; b=eHL7t5Kn82ZbvqK1DzsJa+erbfYzwJmsYa6x+BJPmtEa9JFmFLWO5v76xclIGX9htDsrpVUroEggm41Um/LEr9dLyqp1eso1HLjnhY1OX3V9Broor7ynp3ctnHSX5DdwnvmOJsANKIb7kYfJgJ8fnkv+k7yeGtBajD6Ao9h8O4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379663; c=relaxed/simple;
	bh=SfvJHIpj+x1ntt10aMsHGrLE4099WfbK3xcDnINCtoI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lliIQQOV/fv0OcoqWbL0fUKh7zqXUSZhjcYHPHnypLb0MQUi42oRGPiyshzHPjDpghwahxjYK6R8ykyHVX85TWq3+ekpW3gQ5ydfE3uMzFhpG/U7ULpDgsRWrHM54md2ZZn5kgH326un6niR93UOIoNUbbWJXdXSZODtpyHf/k0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3W7KQx5d; arc=fail smtp.client-ip=40.107.212.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1P+4PGTb7JAIW1p1TKOLnghCrTl9kuUEObCj2mFKbb0P5qngqdt6PpbOUHrhzfDARMuEWJSYNpK6CZ5iF+EegMk/H9Bl5UlEmkT6Gu2dRdRc0jQocEI5iJw8z1Ut1KW2n5EI+U9pQlDR7UpSdUX5Y+eXcBztrQCDH8J//p8ji72nbSosgPWznBZmW0ySMEfKX7LUNV1ob2+6PCdHw6QA0hg8CsMLaH+2ezPRBYFEkINl8MF1scpF6JfOvJzKb4jaY7DZnjI89uEpm9sMHCQ9TGnrGTiN7MKW8JsgEAPxknGvmiWeOoEsUczSTqixffA6AioequFOZcQeGEMwYHsmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0NygJSNDy2c9LvyB3pHkE/bUIXzFXvxWIMov9kiJt8=;
 b=aNlAX2aYZUvk564LJ7At8rffZBm6REYJlCdoDBT6cdxRpuIs982JTDXEVy1gz3H8f3LOnw+DaGf9alAMhoevCdDbwoQOwLfUaSRDb3Rz/AAwkrWd4jpmpSL4kO9GKN2kfLhV9vS9XOrNVbhaz1e4im+Rr46i1qUpmMpHQ9qG6j3W2xHhEK0IcT2nsM5X0Uoh/peFSTVpGry5N6TSwkh9Mo2yqZHcMTI3BE4qtQ2SKIs5lDDdPtA7n34gjhcLcnKfX3wpfvbvWbbORDBnkjhI4BVSYPUKVObLlJieFK8XPVDVlHQ7SVps5dcddiWLPhVxlrUhujxOfCktSQON5vsKDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0NygJSNDy2c9LvyB3pHkE/bUIXzFXvxWIMov9kiJt8=;
 b=3W7KQx5dDy8ZNdwjq+tk3TjYo9BVHAKXAtYYu4A57Fu4AvKPhlujMaOjFsp2xEsJ1NctSQuyr7HEAlhBT8tK7V0mZ9Idya29YO8KLD0Yze8fFdLq6RpR1imvthbXSeJf6sQ6WQKYRSPUJGm5eWeww2ktA1uUcwEW+LAOX7jvZ6o=
Received: from BLAPR03CA0173.namprd03.prod.outlook.com (2603:10b6:208:32f::35)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:14:12 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::5e) by BLAPR03CA0173.outlook.office365.com
 (2603:10b6:208:32f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:14:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:14:12 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:14:12 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:14:05 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 13/18] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Thu, 28 Aug 2025 16:43:56 +0530
Message-ID: <20250828111356.208972-1-Neeraj.Upadhyay@amd.com>
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
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 79e40daf-9857-435f-d07d-08dde6240487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?860lKu9v9k4mO6UZexowd54RiG13sTmgzPZ99wBoqi5ffxQ3G6By+qW7Bg7l?=
 =?us-ascii?Q?FQg6OX9VaVfKnBV2J/Bnrva2lj4t2pm/ZkV3/olrQp3JAkP1WPd4NzZiR2Xb?=
 =?us-ascii?Q?wZpXWJ7hTUlEwlBIhKJ1VF2mFvnEqxSUjdjiU0Oy77kukHD/6Y/OJqyUXZMN?=
 =?us-ascii?Q?HWC4x2eJ2/hXlAS7t9K358dpwqgbRrz5/wi11N7lmtRZG4nZPMNde44mbJ8S?=
 =?us-ascii?Q?06T954+tXENLg0JGsj/PGlNI4k83fzQpMSetHbeaTMJuEneiR7a6E4J7zM/n?=
 =?us-ascii?Q?uT+LKZ6X9l3ibpc017/hIKOYU9O5RB6jPfVsk5v/qhktsKkUE6pm0Y+8qKtz?=
 =?us-ascii?Q?wiLR/pT7fypdocXMlAjljKhaCCjk86SC6gvFwuSIhBYtaDPCX9IuM7zdIaiC?=
 =?us-ascii?Q?2a7tpQVWBwm+mWlzhBMCCi4GFWo2Ims0rbdHg/Qa0uGf4uJiWpMYvNza9vbu?=
 =?us-ascii?Q?EobNpQdGgjLjhYlEBk3fiLpbKDYRaZmxrAOo9uKWvP9HsFdfWqttuX1b/N0z?=
 =?us-ascii?Q?hm/WcR+y+HaJjyO9LnDVp5J6O6GQ+KoZwa87QSTi2hde0EOUoQz4Rsy+ogoG?=
 =?us-ascii?Q?+TRU4TrK7nrwtm1HFZkuiJ3jrPfWSKC9NLczd3pM+upLaoEgZaoKIZ1h5X+d?=
 =?us-ascii?Q?D6MrBngaVxtQzZWHipzfsJ2DGvgu5IeCY9FKEN0aSDeBOii4GEUsCHjBY/ii?=
 =?us-ascii?Q?owSNxhzp4t1jLek1el3URx+4f/u9rwrosZbZEndDX7nKKwGsoBXe41I15YsD?=
 =?us-ascii?Q?ulqzr71Q/WRMt0gNxsif2n0EWQjQmazXSlZWaJSt1+utn2zxcOrV27QQW0zA?=
 =?us-ascii?Q?/VzZAV7bhIo45naOInKuTt97RdMHeIAIb47ooRVzJtyeU5b/bDXcu69cHKFj?=
 =?us-ascii?Q?GZhXwMXg8Ub89tSydi8VH7qQ8cJPc4qClGQSd8Qthhj8HPSOBVO+uqWnWXk5?=
 =?us-ascii?Q?HK97YlCHkN0zMRNO486Vwmih54shmQlpNSXlkw7Gt8KSQ3pRiROmjt8NsLM5?=
 =?us-ascii?Q?JfcXF/EesrVZ3zXC1LD4yZuWvzK3gLK7LQy0GZpprxXKNFS86K2Ts/DW64jR?=
 =?us-ascii?Q?Gicy3G8GG8TaxFUguRyZcCUNLap+lrrexpgPm++D1wxOqNbBc26FoKUjYZ6n?=
 =?us-ascii?Q?jjF2Np7gqpZDvPQGFIqngPsiqvpxZiMNnE+UVpdTNDkL/o7JQxKBlw3QGQyG?=
 =?us-ascii?Q?bnC2dkO5NaXhTBpkYZJev34eHaZJ1XXSsaer6X5yWsRN36rCgwUhlBpmWVX/?=
 =?us-ascii?Q?eLo8/ki788AKI2P9sTJjWoF7RtkAQP3xsyj7c0Sg1EqDi28T3ZfNwBOC/mYB?=
 =?us-ascii?Q?yyy7zNcmk8kz9b7A9OxB6/nnyyv4dELkY0vopIJVwocO0tzudNVGiv36MOE1?=
 =?us-ascii?Q?bmH74xJll87UxhS09xmgv09oPDbl3l4jPO/wM7/96IR+EMjcp990zJdAbhIy?=
 =?us-ascii?Q?jRlQ/Lrd05R7MTKzXTz1gGEazSzquSAEiK5rpCNiOIltBJEAuExaW7obnKt4?=
 =?us-ascii?Q?r2VJD29aNWH9awK6V7wWflD/A+gG6J6U/B6Y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:14:12.5248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e40daf-9857-435f-d07d-08dde6240487
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the hypervisor for Secure AVIC enabled guests.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bb8d4032dcf9..c569b6e23777 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -67,6 +67,11 @@ static u32 savic_read(u32 reg)
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
@@ -76,11 +81,6 @@ static u32 savic_read(u32 reg)
 	case APIC_LDR:
 	case APIC_SPIV:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -205,18 +205,18 @@ static void savic_write(u32 reg, u32 data)
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
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


