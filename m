Return-Path: <kvm+bounces-48827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F70AD4163
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E363C17C10E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F44C24729F;
	Tue, 10 Jun 2025 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xd+9mUSM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C125246766;
	Tue, 10 Jun 2025 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578328; cv=fail; b=LXiIe7HtWHw/dtc5P116K5juk2EgghCdnTAulQXjgTBtEWHp+iWPvrspJFnzHQYwFsn+t49h9j3xu24xOc6AuBChsnRQdlSxYDrIfjtKH93oD/UPNJVCS2LyIe7QhEdzirlHtMxiagPEcVHS193WE0LyMmgg9zvqaOwEmvL8GSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578328; c=relaxed/simple;
	bh=td/jJhon/xyMQbSGu+ZkfrkiS6BhTf4OKg6r7Nl/PrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRrYH93KN1Ond3PcPvPHR5HXt9i9wQk1JAfBYuZzFlrMbC43MMRox6D4THkaaWziodZnZBkpOSxhNHuQHemvLHMWmihQbDM4WOL+VFmCreJ3nTgwvWp7B3vSAUufmw2Vdwuj/k1PhunaHkqm6yO1AOeZvbOIfGZkXUu0xrwL28M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xd+9mUSM; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YharJfZIpIzAZsCmDavm+DHo85MqzOAUkz9CvnfiDcMoLh3G5zts71pE0WYTUQjPiMKpzHD5rtcYFwppmIm5i+FPkCNzCrITQxyAmyoLNHRtsP1gWKttKHjEk1oo5nMWOQJC7ENKVkgbvdTctZuvg2pUpF/BlmUh0ShpH2Q9riVBlXeF5GQv1LMX1TRgw7DDbZyg9HD6SUgWvi6GQ1zj8C/C6fdYpfQhQzr7gsIxzHRyJ30gJrBL4UNS5q/K04RQaAS7REhGD6OaWiqg5R+5ccFGJ2y79bS+Bd0a8oMX9vM1iyR4Y9hX2CiGvq7PJMJ09lHkIVxFcojfS9yAUd4CtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4kvqvyIby/ffehHtaatyPMoG10Rb8cQNNnBqmOgvtE=;
 b=WfwMJIsAh7e8iEF5+QK+A/jd7Qoh1zjzcstpIJzdZiiblNrLRIzOTsAcsYDBzeJqqmKIyrwGNRqp5BMzA3dd48vdTzfZWg8jH5ez+wN82vFPtfUZLj3GiZLkvLqP40ZRZIn4uSXHX7vWQTlH6s0Eh5iY3g+HwUBtgf8rA8paQeBzQpdQpOSuhi/Wo+yEVOCSiQCXFTaF5VtjJuzRhmS6+5pzdvHyLvdLOlG8Ey5hFwH54WR4L8Vc8b4M+6Wfk6MaaZ5pyd+Pe/RHck8m1tnxrYM7ta9UAftUZLKo6MYkOXxA3xiviXWStWdmdvGi2OKfjl8NzmH2xNcAyP7ZrDUkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4kvqvyIby/ffehHtaatyPMoG10Rb8cQNNnBqmOgvtE=;
 b=Xd+9mUSMnKCK2BYsSCcT/x4cMnp6o7ftp1ZP8fXPz47V+SLYDSFQyx+vI2Rxpp/ygmmnNkIsA/EbeYTikj+kkoHhLpyzoIRoJhgj4aehq+y8tu1FaqGH1ZPpXWS+rn8PD9U754DUa9oJsYvlA+w+H/eH9urNnljvVHNbClHD1P8=
Received: from CH5P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::10)
 by DS7PR12MB5960.namprd12.prod.outlook.com (2603:10b6:8:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 17:58:41 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::fc) by CH5P222CA0021.outlook.office365.com
 (2603:10b6:610:1ee::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 17:58:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:58:41 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:58:33 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 11/37] x86/apic: KVM: Move apic_find_highest_vector() to a common header
Date: Tue, 10 Jun 2025 23:23:58 +0530
Message-ID: <20250610175424.209796-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|DS7PR12MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 63c90af4-0a93-4f2a-9b24-08dda8486f64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ztiC9mKLYl4ecz7CN4Cwyn5BeP05zdNjV4OmmI43bHu7tfNDrjrezoZBudzS?=
 =?us-ascii?Q?uQFganEV+XuWN6jNfbOCyBmTNHMq+ARQx3oqutuwuSxhbo5ClJ7eq3wQLQW3?=
 =?us-ascii?Q?/mk1gP5u7Xe8PSD8+vlC44JFfIq9CBdXS62sIDqYQ8O24kg9R9a1f6GvQ+b2?=
 =?us-ascii?Q?XJ6HrM1rgJ8uSzBT+a/XRFCHv8WuYLw7GiEVYh7KpZXfTochGTlUTanvu7pl?=
 =?us-ascii?Q?yDuUUaxWULNi+IeBL7v+0u+ZmZxTFTMnujURzdSP+lvDuVGt0O83Z09OfgdK?=
 =?us-ascii?Q?YeNqqt+jTiwye6R9fha4dXpzdQ4vhJjYdL+28Mc/PHYaSNUSmYFkoN3W5Nmf?=
 =?us-ascii?Q?FTI8INr1Nfruwrsy1IGRp83jh4haQkGXaucO0AbCaW5GCoP0Gm4ba1HIYGTt?=
 =?us-ascii?Q?FQoHUGg4Fw1w9jaZ766hK94kZ3693JSM/JLBeyNdYs7NZmgZoIEs4aVW10Pb?=
 =?us-ascii?Q?F0W4w8pq/VuNIJ92SVqB9rIejyWcTjLne0Yl+l7EKxFLEphSFwCbQQ5+OpEb?=
 =?us-ascii?Q?Zv8AXpiHaDkXesJgSy65It8A/4n+dR1t9Q+q4cLar65zvuG3vuAHgiTS64ok?=
 =?us-ascii?Q?NEztLzbZqNTA37oOad1QeJMnJQoOFoUPA/3t6SaH4ElAiV9LYW+dQd3qCfY9?=
 =?us-ascii?Q?LJ+9qtEflQsNcOWFkchsJIPGwwjkfiiPd9gO8Mqb9XFFBay91kpY6IDhAju1?=
 =?us-ascii?Q?ncAgSeK8ViIT60Ahdq2D3SRTitwi9bPAO1RnNCjNRsUw+V2ULTqaFk9O/bvK?=
 =?us-ascii?Q?+OdMlVNbhXi2v4S/ph7EoKD8rsQuGeBSseRkQP8h30I0wrW7RivPzR108nti?=
 =?us-ascii?Q?YgMapXtQkKmoQsrHFeeP9ujr5ctK0m0wFxUqSsotN5btwOeqCTiECAFALT6f?=
 =?us-ascii?Q?fQipXNK60R+Ahr5iyHJlJ+tdwYN2lMdVjK213xTehNLv+kKUf9e1CRjsG11D?=
 =?us-ascii?Q?0lYXdBZfL7GsKnEmqYe2oP3pfUm6qrLg0Hqj7AMSyMcrYtK+dPXv4Ll3jfrs?=
 =?us-ascii?Q?vP5Bvr4593d17tS3iUNB5u2OdNcxCRAvAWppB/mhnPBQc8ibFR7LioimEht0?=
 =?us-ascii?Q?1BXHEynqUfoWyS3vEVOQTSarB3m+JCz31HYhADyJoXpsoNdasFJgp/xvTcD/?=
 =?us-ascii?Q?98uGlo9FlJxLAHWLuGymD++KE3ulAgnRIwHCtuLryTnhxQwChlfMQamZ8/iR?=
 =?us-ascii?Q?AIGqlmFFh+jK/CU8BcFO0KTO9d/lg15lZq6HzXr7aTZFDcNyx/WhIBSTxoEL?=
 =?us-ascii?Q?LnJT1JpyQ39nMMjj7/CFEZwtWcftU2WLSplYyhYDYKtGzKpajL4opAjGI4Hq?=
 =?us-ascii?Q?jHhCNaGskMV7gZp+zf+9oQdHmxfuxbiOYKTphTAqUA8nFDLx1XQZ+yjcvhTK?=
 =?us-ascii?Q?tj0DMZx/wbdfcqB0Vk/Lcmm04EwsDnlZXgTvWdUjLCFcfSz8JL0sR0zAcdNs?=
 =?us-ascii?Q?3o/7bRdlTtl5r/rAk51tlDszaeYgp4QDdvzObx0uuvJubb897fuhfKA3kmbP?=
 =?us-ascii?Q?3AgxHVMr5HVJ1twDvhwj8bWGo7Y9phq1p1p5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:58:41.5900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c90af4-0a93-4f2a-9b24-08dda8486f64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5960

In preparation for using apic_find_highest_vector() in Secure AVIC
guest APIC driver, move it and associated macros to apic.h.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Split the macro and func renames out of this patch.

 arch/x86/include/asm/apic.h | 22 ++++++++++++++++++++++
 arch/x86/kvm/lapic.c        | 18 +-----------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c84d4e86fe4e..c7355bcbfd60 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -503,6 +503,28 @@ static inline bool is_vector_pending(unsigned int vector)
 	return lapic_vector_set_in_irr(vector) || pi_pending_this_cpu(vector);
 }
 
+#define MAX_APIC_VECTOR			256
+#define APIC_VECTORS_PER_REG		32
+
+/*
+ * Vector states are maintained by APIC in 32-bit registers that are
+ * 16 bytes aligned. The status of each vector is kept in a single
+ * bit.
+ */
+static inline int apic_find_highest_vector(void *bitmap)
+{
+	int vec;
+	u32 *reg;
+
+	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG; vec >= 0; vec -= APIC_VECTORS_PER_REG) {
+		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
+		if (*reg)
+			return __fls(*reg) + vec;
+	}
+
+	return -1;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1f44bbc63f17..f94adcdf242c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/math64.h>
 #include <linux/slab.h>
+#include <asm/apic.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
@@ -55,9 +56,6 @@
 /* 14 is the version for Xeon and Pentium 8.4.8*/
 #define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
-/* followed define is not in apicdef.h */
-#define MAX_APIC_VECTOR			256
-#define APIC_VECTORS_PER_REG		32
 
 /*
  * Enable local APIC timer advancement (tscdeadline mode only) with adaptive
@@ -616,20 +614,6 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
-static inline int apic_find_highest_vector(void *bitmap)
-{
-	int vec;
-	u32 *reg;
-
-	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG; vec >= 0; vec -= APIC_VECTORS_PER_REG) {
-		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
-		if (*reg)
-			return __fls(*reg) + vec;
-	}
-
-	return -1;
-}
-
 static u8 count_vectors(void *bitmap)
 {
 	int vec;
-- 
2.34.1


