Return-Path: <kvm+bounces-44690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0AC1AA029F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5A163BD785
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DAA27466D;
	Tue, 29 Apr 2025 06:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oXX/W0PY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB0D2356BC;
	Tue, 29 Apr 2025 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907073; cv=fail; b=Ef/YyuCSxJEML4umc1h4MlsUaNaUPCIltegNkjXODsZBWVQwUVAkZzY1MrDt4GIxvE805FeS2P/3I8OjxLce79PY/V5CPtCxJtHdl0Wh7mrC3AeZsRV5T9C8OQ4Khtz9pfTYXNoVJwkeXCyovmdBsalLyBtv6cMIxfoOZ0jju6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907073; c=relaxed/simple;
	bh=NVnBOc9W+YDyith+Fvp5R/PW9u6dvkkMrhemqu2ISmc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GD6Nfp1Ky1FVXG1rHOmnwMbkuc5eO2Ip6kgtButgXaWDyOGITWxO83SF5Yiqf5sggMq4WwM6HLeAotgIPwRtzb1uCZZkWAeAdzNa1wjgE6qHmWNN+B7ZRT1oCl8IIO+Mpx0RDxXYK/+SJgkOPLbeDHzcRWIg4LGSoNw3UfUnRaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oXX/W0PY; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCeVqfh4F2/xk+9k/U0wppaQGlJSyTPKOywKlCjNTjqdargcEESSColg5bprz13e32ZPQqccmdxepv9/x5+dssvPUO0lrWAVrgaL0TGshNb+rw8Xe/G+Mfh222dkc2CbxvwIe3cKA577Smfq1y7T+IXux+UiRJ72Io53RNpFearrguL71GnJ8CzMCI/+VQGMgly1L8cL6Wq+FzY72TED8PKRkMES98FqAA0Rn+8jYzJbcNgPzx7HRDriccMaOeoVFB4Sq5oNYt8cyhy8K+njPgJMRZwHbAVFpodnd1v/M/D2Fon244i2i3R02Texrtmz4I9piBzbY+6zcsoAz9zQLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhsP4aNj11LWVC17yJL2Hwi1H1ogWfjtFbyZ6AZOdpg=;
 b=kDezXQ65YK6/9h4gri8M3/tVW/JjXjJ2wtI2jxyXQiGZqcRDaMwy98xD3Sb+NbMaZtUcdJlFXtwK1HwJI/TvA0i6C/LKNoxrA/Q33BlgceRNKXma5sK6ealF++W9l1170Iu8m+g7LIJ7PFYRXeU7v0gI252+6Ec8zjGQAXipEjMAAi+NrLFRVYrFIEciBi/ON4B9Bsb/sSUrgqXZMyE0oi8hn7i1McBgRngo71cIFmw2pw3ghI2X98SmXOzPh/tkS/Z4OhyvJe9jD8a9NN4SqQznMffXpoabno05/gCED2qq5Dn2zbUAMpsKBDFWTmAkDFOwWmpQAIqRmkjtv3s9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhsP4aNj11LWVC17yJL2Hwi1H1ogWfjtFbyZ6AZOdpg=;
 b=oXX/W0PYjM4GrRaaHNC2YhcwlBK+6URztEfdrlApCSUr0ukA2owldynLHRzVb63YCUdhoIdo9OGqbledbA3ZLULvGta+b8bMO9TL/Pj/RuyxEUFG8pnBxMGLmL1+Qb87jlEAwFwbgAcS4c68nq08oZuHrQyza89F1Kn8q02LCy4=
Received: from BN0PR04CA0164.namprd04.prod.outlook.com (2603:10b6:408:eb::19)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:11:08 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:408:eb:cafe::6e) by BN0PR04CA0164.outlook.office365.com
 (2603:10b6:408:eb::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.25 via Frontend Transport; Tue,
 29 Apr 2025 06:11:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:11:08 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:10:57 -0500
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
Subject: [PATCH v5 02/20] x86: apic: Move apic_update_irq_cfg() calls to apic_update_vector()
Date: Tue, 29 Apr 2025 11:39:46 +0530
Message-ID: <20250429061004.205839-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|SA0PR12MB4446:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b960498-3199-4cdb-350e-08dd86e4a1f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4w2idpcXknH08pN1JX2lzDRwNFSlqar08nh7N0uPt/EXihgZUYuVi/PpFP2r?=
 =?us-ascii?Q?+tDKNmWpkMo4aGhLEBN1EBlODgbrB9wiqT0FUtlxZFgjZ++jlYrGAVijMbT5?=
 =?us-ascii?Q?QDJJeMmEadLrPEKUYJVQxcjk5HvljSXEx5dtFvizc1ex69Bga0AEdDrAsr58?=
 =?us-ascii?Q?+P4DGjIWQZRHVWvmZocVMbDPU3zmunkSSGVR7ZMtd8djdR3NV//7tzmhH2xe?=
 =?us-ascii?Q?h9cD5uZW5DWMx7ORggWzAeap//7wftYCfgd7WZOiLkvPJ9M9nJFvgMf8zEsV?=
 =?us-ascii?Q?pXhUdGkVyh4h3dVP9GYt3m6CgEbefC2QXjlm1Kzofiff6DtBZw0pkzEqcDlp?=
 =?us-ascii?Q?cNfA+nh0JzZq9zN+Jtc9AIx7qUo7rVVdmq4k0ZAUB+fn0BGjNWlDX2Q2fVyA?=
 =?us-ascii?Q?Ykes/2jmNURMRz8gwEWJKq8Iicjvo18JDjsiERXQr3iTstPV9e9DBWfK8I6U?=
 =?us-ascii?Q?E6JGi1nsF+RJ4CAPKQYneS21ydDwzuP37g/g6GnW+Si6hFIUhXvv9XQ5epzd?=
 =?us-ascii?Q?KFWWKBrpzt1a5b3tkt2bYvMhIPFK2tK3y3hxgHmpImrP2nsh4KWzOfX0VSGs?=
 =?us-ascii?Q?P+61Dtx/SbJK0teiO3OFzKEhfItibFyuKLnRy0TRImhD+MnwUoCFcfzPRGkA?=
 =?us-ascii?Q?jVnEqrK+WYBwZ9ZqwDhbD3U0kvTfXVbZgsx6CyoN5QNPc5RJzYm6FV+fltUI?=
 =?us-ascii?Q?fV4/8GPBhQZCGzGVG6Y/eAvTxP/zHtu9LqqDfdpuY0p5Y51jGLxi9XrW0Hnp?=
 =?us-ascii?Q?RopLbb4CT+cVjEBnS4w/IZITCO2W64xvLAus+JAZxsweHNcRHrO/WKCzOP1T?=
 =?us-ascii?Q?hQA25WHjudRY8fcXXt9+1wFqr25DOJF7JZ/21QYRQP4wAv2Ap1nmKR9U62bV?=
 =?us-ascii?Q?+2svpCvblF+0xCWXI2+3vZ2Arl7QqM2nX/VnfG/BYv+foi2r5fqSc1jEcAPE?=
 =?us-ascii?Q?k2yKja7yLe4VflzWYsle19+l7u130J2afFvTwYP/jEq4C8qGHsZhnmHN5Gmi?=
 =?us-ascii?Q?3TZpXKNr8LBXs7MXOsu5LdL4u+SerxU9+xWvLz9tP4dF2Fto3wsLO9rZWU6p?=
 =?us-ascii?Q?WtNfhCh965rmIvvEkACJFtRuZ3/dLIckwvZ9769dAZIcyBr4F+ZUFEdkHeks?=
 =?us-ascii?Q?ipSEOenCXbNnynAFLXlPUoxLmF3qp6ZY4VrBvSt1uELW0GNVQ0GPWbsFPxd9?=
 =?us-ascii?Q?+eW6VeIbuWMocQA3pBcKCCziHTA2AfB+UfhQcEDIy0lS5eWb6iV4a1MirOb4?=
 =?us-ascii?Q?n22TptOuHb8A5Vsim4mtyKxBoRfSLGqy85Kdixu68/ClZ1WcnEC9FpbfYdr4?=
 =?us-ascii?Q?GVFmLsNHlc3mg22Jvz/SJNjI9m/o1EcCHX85N7GocTZWxcVJDApSVb/4Y61g?=
 =?us-ascii?Q?4QAnVg1u3zqxTI+e8hSWbhiEsNMEwistps53RFMMR7ut9aQOvE5vqdMc7p03?=
 =?us-ascii?Q?LwZHve1TNrF24Ou17/5JvaUfJ49jw9gfuQBO3ezCDDoU9/FDD0kOiEJeZ3Is?=
 =?us-ascii?Q?o5sNkJ4IuuKZG3fbFUSE7M/smzEXFR5stF5v?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:11:08.3978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b960498-3199-4cdb-350e-08dd86e4a1f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446

All callers of apic_update_vector() also call apic_update_irq_cfg()
after it. So, simplify code by moving all such apic_update_irq_cfg()
calls to apic_update_vector().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - New patch.

 arch/x86/kernel/apic/vector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index fee42a73d64a..155253af3deb 100644
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


