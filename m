Return-Path: <kvm+bounces-62977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 08094C55E9B
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F36BD4E20AF
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA253203AB;
	Thu, 13 Nov 2025 06:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iWeJJy6Q"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6822609DC;
	Thu, 13 Nov 2025 06:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014743; cv=fail; b=q28iqTj0LLvwroJqNt0JCgWUd4mvhhuu6kF52+MsVGXDJQQah0W1hHbKDAO0dqYUFwafumaTWamUn6PQKFPGFLwU4yBjAHdDbKEY06TkxLFLdhNLTFGQLmLH7+A+BQXiRCLnVKLFJ1mvVNJ4mgdG7nQpNXKM873OTDvKfKdNDrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014743; c=relaxed/simple;
	bh=oUcXUQSeyjNbS1VzOWZ9eUU/vO5tNmbZurKKKCK+jvE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cL1Fil7yIUnRcuvvHPPEkyChxPPvBC1NAIibVO1+tLskIVT94Hd5tmmh5+qDjD+0R6IxIpHPnJq85+7illreC8eZEg+RAbChItqU8mjqrzwgcc9yin0P67rwz/9pyq+qa24o77nYGQrceLCODlkSBpHxDu6/alARol5qIDjbjBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iWeJJy6Q; arc=fail smtp.client-ip=52.101.61.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PW3RgLeDVRu6An7VDOPqcJWu7an+POsPNeyHA2nKU4l0uw+m0wQgN7pqw1X1iQyY/oKHkKgE//pbLC4J3pE90bNq1pZfj1aRi4zwBDG5lWYDvS1l7rmvuavtRIS9W9HOFB6AGlHO8PDEpMI1G/nSWpGNKGD1zB1HqU17nF4dTBYyf2aZqyaKqyhtxvZXuPES92MrQChgBrLUelw7o8wTV7KH3JUTJimd+7Q1Nx0ZyNcYBXIkEAGQvGZmP70qeReLwk/g2BlpqzvAFgpOnVoFjcHfKTUQ5xJ6HK3RHis0rkkLlW7JjbPtkO95Td9f2hVUD5SiNx8coQ3CrRlwKLz0Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTuxq57PjEWBcFAB6Nw9eDjVH+G/udoxi0RzDcK0OTA=;
 b=JOPbbUYc9vuyqGyM5+QiCAZbuT93lFLoJjB5SNKAYe6SiUb9h4/4AHAQvcXJbiPktNYuGEDnmH9+VR7znRq1KSVgakrblwyo1xWeTWpg/SdJBvrEeklsohQbmKHAAatWxlKidxzFBNqitXQcrtX7dgKuneBGXIljbq6gOZ3fah/plXq1gyEcKRL99L1/XUbOvr1H+WwTc8fDD9Vw537hRBp+CZXHQqZhgDOkJVXauEOQj+nIXgJS6pbKgEulc6/xfTTcR9sSilYWMi+S7LJ8h/irMWTlrbsgSVRQSUiWUjP2eUjnncYE2DIOPENrBHsYneMdqoef5X0+tLecTCCVoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTuxq57PjEWBcFAB6Nw9eDjVH+G/udoxi0RzDcK0OTA=;
 b=iWeJJy6QU235YiRMecRl889YjpoAz3K/cJlccPI9QXVBXt1uNW2wKbDi5RQ6bEL9Q6ciNJJzmuKTE91f+0OAttw1Bk6NyxkxCP/4qq/KpECuDadlIDkDnuFS55e+6+nSjyesBgtxaoI9sJkiRiJNCQzk6v0wABoBIbvIPoUJjUY=
Received: from PH7P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::7)
 by PH7PR12MB6954.namprd12.prod.outlook.com (2603:10b6:510:1b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 06:18:56 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::b8) by PH7P221CA0001.outlook.office365.com
 (2603:10b6:510:32a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 06:18:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:18:56 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:18:52 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 1/7] perf: Add a capability for hardware virtualized PMUs
Date: Thu, 13 Nov 2025 11:48:21 +0530
Message-ID: <e07e012cf2f96a135b78c02aa8951b8e61dd5cb8.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762960531.git.sandipan.das@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|PH7PR12MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 01ba6d4e-f43e-4870-9851-08de227c86ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lVr+DHfGC00GDwRJIsRV4YlKTRpCuUpcb6FxJckIUcnCIwLfXU9od0fcl/CT?=
 =?us-ascii?Q?o2oFEUcbs1QpLmvB0qYSFvjY0uZMXNUB/cKYj6Btm9pCveb5mUDNNLak2Htd?=
 =?us-ascii?Q?NB3bENXMGnja2WcRBEBBL7qLQFLvI0fImRHFxibx4dfA3OhevjLXGl5rYkOr?=
 =?us-ascii?Q?hz29y7y/hTzGPB9I39DTA7lmc0d9QjEfsPz+rkAv0L+/QYBO48xMV9gyPhfs?=
 =?us-ascii?Q?uLE4UCPQ+7PYF2PG5BPWH2DS+fVeLZdRyj4dqvMCG5ct5j4mNNBRFOaAjGoE?=
 =?us-ascii?Q?sMiJDlLa39YJEhAIUOiWCu47glqwHquhZ/Glw0Y9FDbTFePt1QTyOGgY3PAr?=
 =?us-ascii?Q?J1p0cP8Jg1ycsQic/aKNks6CQqZweA/+OFc3w8RKBe55a+w0OMRAkSyx4per?=
 =?us-ascii?Q?/6U8EUCGXQXL7LDbWVx9JkVLJoDP7zEM1ImwvGcjHn1otH0OAw6Ewd1JvRV1?=
 =?us-ascii?Q?t3r4jG/2ZOal06EZ1g07pnSW5weZhyefrAIVsm890kwtA91shj+EKCo8PIi6?=
 =?us-ascii?Q?gEaSgD6cI5sFYmEVr0Czhg6KmznuFX3q4PIQjJR4O+X0xBIPxe4jb8gFKhgx?=
 =?us-ascii?Q?joR0BicmLuXOXr3DDvBRqH5+abVsPxCzI6BzgGejXsDUfFL2ENRDtprYWiWL?=
 =?us-ascii?Q?5yrlrrR5jGA7AH2dqd7QEoYDD90p08UVtdUWIZKV8+8bMM6QSKF/zQNyqY/y?=
 =?us-ascii?Q?E9GsZVaLI/i5dJu0D682sAEmOfzTnvMAjLWSzt7laHWbPn1s3TFqFSO3eAIq?=
 =?us-ascii?Q?f+BDmedj3HQub05A+pTjH4h74254CB82I1ChQSfIUNpLgzXnNbhFuJaf0jne?=
 =?us-ascii?Q?SyoOb1rt0UO+DIHuVvPG6ZM7UC26WZxCzoK/iehw8gE+k0xZ7qFWa0ZqPZTy?=
 =?us-ascii?Q?+ZuEcQ9/tSecCEb2XIrMcs+N8K9kj9g1qm+G6GUV1Q5mcYrSAIDTWRLgxoVv?=
 =?us-ascii?Q?Lc8U6nsbG5XZdV94qGMFrEXcN7iJw/4WSw4+P1v5BIrx8AFGaJS8pgijv0QB?=
 =?us-ascii?Q?FxppROZCA/u3W7NvvsLDwei4dI7b6b9EnCHbivyhEkWkgtsWvqNqk16vIc6+?=
 =?us-ascii?Q?hLdosvb7mimg1Qj0dPD15hNpIBnqtKLn7Ak9JzhnLMO1cgQxNfO4wf4QPl1g?=
 =?us-ascii?Q?YhRPC8iayTlkHgmuaWXsN3TtH+LPkFkZAoP75VSMOzSV3TDPoceNXZo6VQLU?=
 =?us-ascii?Q?90K8PYg+rcuwa2rLp0LnssXOmCRq+jSnC4Qn1et47V5jFZcPLTObndXZvleL?=
 =?us-ascii?Q?fwW2Dxk28O4LL/KGvIm8vhfIHJ5Odl03fWau8n3akVsdMYXt/eJBY4S1gey2?=
 =?us-ascii?Q?3v+WdqXrbYr9CZ7lD694ZHlaa31D8bNfVnh3oa1nJCtyr0mJjrp98XbzMYPs?=
 =?us-ascii?Q?4roa0TaVu1kLqmlLX+1yAjdNTxp7vvtPm4B50kjb7v0D8Dn3cf5aFWa4FIVl?=
 =?us-ascii?Q?sBPNjs5AlfgID4Lg8BXZmpflBICUc30ufxcKF0dEiWsKaP7K0DQ1A4rrlbaS?=
 =?us-ascii?Q?Uoj6dCkuaPX6fV9BrMc4BDFBhn0Gnfsf9MPGUh7WLoTUv7MRePlvJJlnSFUA?=
 =?us-ascii?Q?zoJVnW4cQTTxZuwZ6T4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:18:56.3188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ba6d4e-f43e-4870-9851-08de227c86ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6954

Introduce PERF_PMU_CAP_VIRTUALIZED_VPMU as an extension to the existing
PERF_PMU_CAP_MEDIATED_VPMU to indicate support for hardware virtualized
PMU where the guest counter states are automatically saved and restored
during world switches.

Pass on the new capability through x86_pmu_cap so that any other entity,
such as KVM, can enquire if the host has hardware PMU virtualization.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/include/asm/perf_event.h | 1 +
 include/linux/perf_event.h        | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index d58aa316b65a..8a8111762cc5 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3131,6 +3131,7 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
 	cap->mediated		= !!(pmu.capabilities & PERF_PMU_CAP_MEDIATED_VPMU);
+	cap->virtualized	= !!(pmu.capabilities & PERF_PMU_CAP_VIRTUALIZED_VPMU);
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 74db361a53d3..6c7d3b7623ad 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -293,6 +293,7 @@ struct x86_pmu_capability {
 	int		events_mask_len;
 	unsigned int	pebs_ept	:1;
 	unsigned int	mediated	:1;
+	unsigned int	virtualized	:1;
 };
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3a9bd9c4c90e..3d7bec2b918d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -306,6 +306,7 @@ struct perf_event_pmu_context;
 #define PERF_PMU_CAP_AUX_PAUSE		0x0200
 #define PERF_PMU_CAP_AUX_PREFER_LARGE	0x0400
 #define PERF_PMU_CAP_MEDIATED_VPMU	0x0800
+#define PERF_PMU_CAP_VIRTUALIZED_VPMU	0x1000
 
 /**
  * pmu::scope
-- 
2.43.0


