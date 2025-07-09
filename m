Return-Path: <kvm+bounces-51851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E195AFDE4A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 777931896BE7
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF2721767A;
	Wed,  9 Jul 2025 03:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f5BDsVxZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C51B2036FF;
	Wed,  9 Jul 2025 03:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032299; cv=fail; b=pqeDdCdKU39kHYrJh4aUYNxtwXrWDMI6cyhdPFLv3qVNdzY3mJ8tdArn1zUyQDxIM3IV9eSPu8hsBVTA8m7+6VJn2MYP/TSbzTtyrtkRUERwTyc/F/+T/OpB6RVBSd2O4mxbK4I3h9nLhah5vGJZSwEWLsmk2amLfuXHXGF7HO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032299; c=relaxed/simple;
	bh=xH8LBxYrLD1du1T7GKn+lbaJu2Xae937pGDg/evSY+A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9rbhKxDYIeNUW695H53LkDXtJMbN8OBO3GeqAbLPz2P89vYSwh8v8HfoOLgPhZgCZH1vS73UvFE7glJXK5yVwW63ihlLoCA33gn1niUNibL94jWa5m54JEz+js/A+O89w6Ns4duA3uJzPAkKrNk35Y9ah7VOHbRct10n0uihsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f5BDsVxZ; arc=fail smtp.client-ip=40.107.93.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T998PghcDJrAKChKJJGewaAcER20NXDaz0NiyGXAyC4Fd2SVBM0tsEixVH0ptJ5bZPLFU1utF2zMoYyjRHFQLSguPVLlutXKA2I5h9E1FvKI0dGO6eEOyr/ue7XkUhm2qLI3oPdFhMLNObmxiKkGg9LtITtbJ/YInPoy+Oyc23KPRmCIApa8rijQh/UJv/3gHkYDVkz9Ns1cNwgK1m+E7rxegPnmdDX3MmRRBv9w5ACLrkRNkahNQ9vyomLLilvMKiZYz1U+RybuqgLrNgw2PEt4aQ1oDmvtgkBxqkB5yxN+0hpktjZBrDbRcdG8mpfQPWahH8KD1Jp3BRA7z2Dmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcDsvfurVfN5C60v1p131zDmIKhwXp1wo9TtJDtu3x8=;
 b=HXGswwHVKolHyJOaKvX9sDGuFWzfsTCGTxkOONleGlxkidL+jd2BOvZuNhv+wk2Ho7fJkt55OEAyPyAKfrVSdIdXDJ6syQbPeAqDR9rxBjqhSbO2Lj5CNiLHW0AE8AE1hjFI/pXL6YtYhLmzxVL6hPmkPv3ZsnprkNz9/kyvN0OQRQ5wx6Ver1kjB8wdLleAmlWXnAF8K4sKW/AhmJC+YytUzJaueqMNKDxsxitNA1fDjnyg7mIoeOgKL567uFNcf+MkUDoqrRyfzJ7cI4bLR3IWXwHwwVUxzD+TvG4zPtfYIy4WdsNd9mjaNyg9wBBWuFI6GwPgOjfRM6nQnKpMdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcDsvfurVfN5C60v1p131zDmIKhwXp1wo9TtJDtu3x8=;
 b=f5BDsVxZ51ABid4gabYkoL4ErKRIFdLJbGSF+j83GmmDALcqK6Udntx4NAa2WhnIC11C7ATIwxMHKFUPAFNS2q/kfCiQE7+xb0cFlk1J6Z3EGZf0/0u6av/01KDjptt0Q+VKtU0FnAlJ9nQ1pN0IQscLeuVSqYHtBQi2sB/i6xw=
Received: from BL1PR13CA0190.namprd13.prod.outlook.com (2603:10b6:208:2be::15)
 by MN0PR12MB6126.namprd12.prod.outlook.com (2603:10b6:208:3c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.34; Wed, 9 Jul
 2025 03:38:14 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::f9) by BL1PR13CA0190.outlook.office365.com
 (2603:10b6:208:2be::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.20 via Frontend Transport; Wed,
 9 Jul 2025 03:38:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:38:14 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:38:08 -0500
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
Subject: [RFC PATCH v8 17/35] x86/apic: Move apic_update_irq_cfg() calls to apic_update_vector()
Date: Wed, 9 Jul 2025 09:02:24 +0530
Message-ID: <20250709033242.267892-18-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|MN0PR12MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ada6467-72e3-4bf0-6018-08ddbe9a0915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VhNh6q/LCT0wUFRMlVhdRhOxoX4gBInRQ6mOjUzEi7Mwt71Nw4IeSHlZtxAE?=
 =?us-ascii?Q?VmwB1konBNomWol1gKltBSfbINsf9r14XKXfWj14uAN2o3kbcfrGK+R9ymp/?=
 =?us-ascii?Q?kft8aovrsaUAo4H2hL8WBxhvmy08D6OMncKhdpxUfS40f9xVqXhh8YXAWRsa?=
 =?us-ascii?Q?0tndQoAdyZ6xERXPxpxOfeSgynkIwzgfnwvTMfruDqjNoXUt6+b26cu9w+Ho?=
 =?us-ascii?Q?VxWR9BWoVuVTbqQGK29OypAifz1+oemjcOrsHenM5oYzfhIdJjTSOT2tKuW7?=
 =?us-ascii?Q?htxwbKkvB+pM9L+B3M4qOw1GVteePngUCn1EUzyKSwL1KDiYYDbS+k97J8zV?=
 =?us-ascii?Q?KSJwa7qalkDxENXvpFBVKZZ6fL+0Q8i6x0pTp+IsnhYc1Ci31ZkiX4d6jsMk?=
 =?us-ascii?Q?tF03srKIHRJhW5Eqz7TTZ2SyhpwfBxQ0HKcPYz0O+WOZJjw+1DKhclxS/Icq?=
 =?us-ascii?Q?2pxircZ0S03RXtDdHTCbsdu7zFTWqi3/eInVOj0u+MCFoHEGJrvGlMGBUYX/?=
 =?us-ascii?Q?1PHVLJ1Fry9CS9AULSD8MqMQDjsMiXbmQ31m92NwUZNvfcBUSa4ywk3iUUAE?=
 =?us-ascii?Q?7B1SG+ON7TlQP2geavwZqJCgcHv5XO/g8C6nwwdtQtpcoJ+b134e24nOQm/C?=
 =?us-ascii?Q?X3iJAu2u8zhWHhhgMqTv/sTlragnUk3CIG95Ud453FZq/VGcXwNFRwTr0QjP?=
 =?us-ascii?Q?c6jiS4FPhBC1bkPW+tEQRS6Wwfj4iBRJTD6hyPn3svUuRlaLL5B/ePNCLQq7?=
 =?us-ascii?Q?vA3B2PDYOj4upD/nnpvMrneVXlummMT0jXG4HITEwSYYVTDICRKY8RA0esnH?=
 =?us-ascii?Q?0bxJIlfVbkcXTaB6sGhGnZCbvTSCJWwuAo8qehIA3Xzn+JjjNBQSl21YOgcP?=
 =?us-ascii?Q?cpPALrSWvsOcekKmZnV5dZVgqn+UdqHNkInKsRmySAYKC9MUaZCJ6unQ5Pbg?=
 =?us-ascii?Q?dJXIEkxVflyb1jkKHEqaz9i4nUwZag18I+N+GfyntScJlOn6SGJ59S3hir4L?=
 =?us-ascii?Q?+zdLhwOWJn6QkcJ/GygPv4bVVo6RDhFopU7b5c9KFIiBvgf7yDq69eWWEffc?=
 =?us-ascii?Q?dtGrGfz1RPfsK3pS7FbdYVfThO+SstFdJGQL5NvrbcjBAQU1jsq5zwIF7Qnf?=
 =?us-ascii?Q?I3xAYbLo62tfjyDhnSskPSuk0DFThQJ6ay5GTjimmExSjmit/wMxGxkDxo1X?=
 =?us-ascii?Q?p/3AYtn7BTuz9AQpiahHlycMhKCsTKriDpILIYagDL1by6O+moIihSlh2Cqt?=
 =?us-ascii?Q?26hQptip3AbIgweI/eyt7WKTuKztJjBMngDSH8xtmIMyMM2URuBCkQPPIH7X?=
 =?us-ascii?Q?gG3sm6zcQgPpBNwBdsxBwTyCO/CP3MhKHWJStUOGncodUEOEXhoeuZC2hD+0?=
 =?us-ascii?Q?Wj248xRTlBMcZnc85Nq3zJHW5sJEBS8H9v9P2kaVXuSIDwFlsnibZdsg+B9S?=
 =?us-ascii?Q?qx8BJ0mHIV6WXyU5B9yJGPJWs9idu8TtYVtIAMTahi2D2wUYGZ/pbB8OBmaj?=
 =?us-ascii?Q?F1pV34Ayov3pb4QWjLsrJjfKhrt9bHVnxj3B?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:38:14.2673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ada6467-72e3-4bf0-6018-08ddbe9a0915
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6126

All callers of apic_update_vector() also call apic_update_irq_cfg()
after it. So, simplify the code by moving all such apic_update_irq_cfg()
calls to apic_update_vector().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/kernel/apic/vector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 93069b13d3af..a947b46a8b64 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -183,6 +183,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 	apicd->cpu = newcpu;
 	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
 	per_cpu(vector_irq, newcpu)[newvec] = desc;
+	apic_update_irq_cfg(irqd, newvec, newcpu);
 }
 
 static void vector_assign_managed_shutdown(struct irq_data *irqd)
@@ -261,7 +262,6 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
 
 	return 0;
 }
@@ -338,7 +338,7 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
+
 	return 0;
 }
 
-- 
2.34.1


