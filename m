Return-Path: <kvm+bounces-43544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7B2A91798
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C09BC168197
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E88A22D7B9;
	Thu, 17 Apr 2025 09:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sEM5eo7A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E702288C0;
	Thu, 17 Apr 2025 09:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881600; cv=fail; b=kPoQ8YkaRYq5ToyfKqmLmy+s3KfDdGt7JLzorQK438zfhQnze5YAjNRmJhfn8meVh0QkKZkT1E6gC0M8AWAdd68QbOb0UCvihUL4qRt8NWMgIiElwih0Q6xHuEN1eqBBvi0IFpVHE9Z1umE7tT5CxHaWFy/LhGBxpv5d1NxLFBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881600; c=relaxed/simple;
	bh=l67hQth/B3jPiw4KCFmy8syFA5o4eXptYxdkTeBwTdU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSU7kbtfoywbYshrEOjyavPrfwnWffy1HKzYUBO5X7wlAeDoStnxllJwZfrelV4PaJDlKgvQUFEJmjat2PPejciWl+VPY4CnYCvP05c6amHhdZ8LrhensIevK36P1Nf5787SEr4vJT/tnJJHW7NCZS3e6ERn9QWCgoVzb5fMveA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sEM5eo7A; arc=fail smtp.client-ip=40.107.220.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HA0BDu8lTCrrdYT2dwzpvpaksf3ipAbb+2lo9lVGyTxKZrOWOB5x+DE3nhojhv+CnWTdWe3DwLsavKz93AkVXOGyiOmp+c20/em2lC8612HiyxK5W8+u3zFum9rxb1VwOUJCQEl7Y+1h+TmCHWwTfl6iXyNB+rlBGAXVTlVwkxqK1mFUpyVX0sfMYO46I0ORyOKuoJxsUkofjGHcT8HUHygCD7hcMULSASEwbhUhuavLUbgVIveE/+gtJ+mQmqa+7b9MG8Hg4Bt6RTqcxQFyiUEtoCV4vTgr+nb7Jo7BDwkh9u8R26joUqdZp1f2PYz1Zm8p7w6K6nJW6CGyloZACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNjHh9guEw8k0ouLW/Nngcjd3a8lLJLe4G8us86I4h4=;
 b=tUi+p17pmkVFNrDqgYD8PMr8LIhHl/1osjHtLD8Sk2SE2LA0xII31qBPdsc/7gjqsUe/NMEbKQ19zRYqSLcXfNPRP4koIrWZ1rKYxaxHXUhz7IJJfcgnzE5WAMQu0b3kunhveYsTTtva3zlyQUw6TSAWu9GT82CEyN8Pj6jTy0EmKzBbzBU8y9ssuaPKhunDOYnaziIbbusfoCJU8NRDobt1Y82qk9ftMa2/gMsCM8lxZyw7qWhm3f3HiKxH+8kqY/hYjn2XnYymTcbaw61rx1Yvdi+DxDcqMF79r1gYKrt+Pg3uCLQ+upSbNMiBcUFrUDncRgeHC0Ht7ZB45gy7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNjHh9guEw8k0ouLW/Nngcjd3a8lLJLe4G8us86I4h4=;
 b=sEM5eo7ANwdGYYPnfFHBkPyt+MZkG4IZUvNSgzk9EWZ+/5aD6b5LbaclJbsHe8OVORmBFcDCCl69NMoSfznPh2Wc8nkjPWhq1o86oYZttlcMbObJs2Wp29d+CvbdBAySc90B11y8LsmECCVZs0DsjWizDrMcxgqw3clacHCCtpU=
Received: from BN9PR03CA0313.namprd03.prod.outlook.com (2603:10b6:408:112::18)
 by BY5PR12MB4068.namprd12.prod.outlook.com (2603:10b6:a03:203::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.36; Thu, 17 Apr
 2025 09:19:54 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:408:112:cafe::f5) by BN9PR03CA0313.outlook.office365.com
 (2603:10b6:408:112::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.35 via Frontend Transport; Thu,
 17 Apr 2025 09:19:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:19:53 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:19:46 -0500
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
Subject: [PATCH v4 06/18] x86/apic: Add update_vector callback for Secure AVIC
Date: Thu, 17 Apr 2025 14:46:56 +0530
Message-ID: <20250417091708.215826-7-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|BY5PR12MB4068:EE_
X-MS-Office365-Filtering-Correlation-Id: 590c6f4f-4584-449f-1825-08dd7d910387
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/kf9wA9JpG7vuiUuAxA0tIxIXSCw1cSgri+S+lqYeTidmgKyRAfCHYrMuFtf?=
 =?us-ascii?Q?i/9ATGBscsPlhhf7sBSzq0iCFghOk4D856jnA2aPJQ+kOxz1eTRHGTXl+W/8?=
 =?us-ascii?Q?+eOr3pR35L8eEggpo9lquMgyopPlrqdejyzdr10QUd6F0WhJhbaXPIoT01nO?=
 =?us-ascii?Q?UjebRGCKmNl5+vnmLPP/DS82UfOdnEKP5jD883D5zZzU9CC10NuTBUHYqETc?=
 =?us-ascii?Q?K1DX/sbhikQ0rByP2uRBwDIYrVAWXQBCPiX5gX5m1Pxe/t8VLVKtwGayD4XQ?=
 =?us-ascii?Q?3oAG00jNaUSOUGSNTHDll+/uTuF/yG1WMR0yCZw3iaLHA4A755UJYim6C3y5?=
 =?us-ascii?Q?SYvddma1cF1nucLKct5uyFqPZPVoiPFt4JhOq/XNUuxBAPlmI7uX5SvcTFlr?=
 =?us-ascii?Q?0iGID2tsknbnOFYIcBsvfc6KVJN47e1pJdAHMMLPPk0Ymot+jeY+KAdM0Vzi?=
 =?us-ascii?Q?esvZUxy/4BjlTZhuUxyyF0V5x7aqoy87oMNUIAjHlyInunby0rYYRyFf4GWD?=
 =?us-ascii?Q?pTuQTRdGveu77GvTUKJLHiEKxJbUU5qUT2tpNNbtR/1gTXxLX7i+W+EQ7pBE?=
 =?us-ascii?Q?w5BEt7/B/9fh9fXimxMT6ZNn749ouT8B6ofNu09onUgoDAGT+PQlLfLQV68/?=
 =?us-ascii?Q?+My546UmAyql5QgGepjCTobr9BWv4QXp9w1SPWF9ECt0c7CUxSqIptjLIyho?=
 =?us-ascii?Q?lsI0oufBLPY6jR0+a4WCkeb+X1Rnc/sktaseoWgkjkp8P/1FIIEK3xk2zqwg?=
 =?us-ascii?Q?I1sGlVBBP+MYtPMvzh/Xz3aAAnT3uKAnpdhtsKB/5TsApL5HXmqpj0TVLFRo?=
 =?us-ascii?Q?Zzt+5MYrZoBFSZaEdWQGvbsFM+lIdMUOso7vBtsbqJa2VHkUal6qi97FtQyv?=
 =?us-ascii?Q?bS9ua3RRAwdOUfs5DFmvCwgpVIysvCeNJMhJm6/9+Vs88Vplmx7XEGStAZq/?=
 =?us-ascii?Q?nrf/I1YHmGxJm0TgTqZdHjbM1kFCeUX5S5+MG1pt25y+1md8mGZo5D+wR9tv?=
 =?us-ascii?Q?1/PU/pJsUOjLW5wZGa7kb0tbuJrVl9LZ7jxnLApzdtf59OcAQBQp3iqZnUR3?=
 =?us-ascii?Q?Gkq/F5EVDNS4gVu7YwryWQvpyzEDMx9cm27W7vJ1pszQtbxYuhStMhiuzh7i?=
 =?us-ascii?Q?ZoGLm+kSb9gCttvKxVZIQcgPwErpDxCgVz9EpOR5OQcBPX5ufWW377bOIKzh?=
 =?us-ascii?Q?CzGRPdGgBgsC/Ydsv+TwORZrEusyoVaXFOu2DA/EftARrSrlyX3nKPw0fGXq?=
 =?us-ascii?Q?9PDeNYCtVSMohFeuu9gneaE8dpsKucDucTmRWKsz4nU2MGlAdba0ZL6dmt6a?=
 =?us-ascii?Q?/fUFI7ToDuJimIGu+ClbWQCZhrdvk66VqXoMizYILkx/7Xkl41cD7OCX57AL?=
 =?us-ascii?Q?KNXmcUMdA+X4G/bot0OXzeUreWyvXO/S3RaQ2x1hBcQ9ucjw1/N+Q34rKq09?=
 =?us-ascii?Q?pZAv7/jJm36CNJwLKzHaNHldlE4P3xk4gQk7ZvLzskqr0jCLwjcxTUh+o3DK?=
 =?us-ascii?Q?n73GpgmFJRzzwWwdADnL3ZJnkCOpEyq8bZRB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:19:53.8967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 590c6f4f-4584-449f-1825-08dd7d910387
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068

Add update_vector callback to set/clear ALLOWED_IRR field in
a vCPU's APIC backing page for external vectors. The ALLOWED_IRR
field indicates the interrupt vectors which the guest allows the
hypervisor to send (typically for emulated devices). Interrupt
vectors used exclusively by the guest itself and the vectors which
are not emulated by the hypervisor, such as IPI vectors, are part
of system vectors and are not set in the ALLOWED_IRR.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Moved apic_update_vector() to apic.h
 - Restructured update_vector() in x2apic_savic.c.

 arch/x86/include/asm/apic.h         |  9 +++++
 arch/x86/kernel/apic/vector.c       | 53 ++++++++++++++++++++++-------
 arch/x86/kernel/apic/x2apic_savic.c | 35 +++++++++++++++++++
 3 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 562115100038..c359cce60b22 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -318,6 +318,8 @@ struct apic {
 	/* wakeup secondary CPU using 64-bit wakeup point */
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip);
 
+	void	(*update_vector)(unsigned int cpu, unsigned int vector, bool set);
+
 	char	*name;
 };
 
@@ -471,6 +473,12 @@ static __always_inline bool apic_id_valid(u32 apic_id)
 	return apic_id <= apic->max_apic_id;
 }
 
+static __always_inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	if (apic->update_vector)
+		apic->update_vector(cpu, vector, set);
+}
+
 #else /* CONFIG_X86_LOCAL_APIC */
 
 static inline u32 apic_read(u32 reg) { return 0; }
@@ -482,6 +490,7 @@ static inline void apic_wait_icr_idle(void) { }
 static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
 static inline void apic_native_eoi(void) { WARN_ON_ONCE(1); }
 static inline void apic_setup_apic_calls(void) { }
+static inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set) { }
 
 #define apic_update_callback(_callback, _fn) do { } while (0)
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index fee42a73d64a..351db49b9975 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -139,8 +139,38 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
 			    apicd->hw_irq_cfg.dest_apicid);
 }
 
-static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
-			       unsigned int newcpu)
+static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
+{
+	int vector;
+
+	vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
+
+	if (vector >= 0)
+		apic_update_vector(*cpu, vector, true);
+
+	return vector;
+}
+
+static int irq_alloc_managed_vector(unsigned int *cpu)
+{
+	int vector;
+
+	vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask, cpu);
+
+	if (vector >= 0)
+		apic_update_vector(*cpu, vector, true);
+
+	return vector;
+}
+
+static void irq_free_vector(unsigned int cpu, unsigned int vector, bool managed)
+{
+	apic_update_vector(cpu, vector, false);
+	irq_matrix_free(vector_matrix, cpu, vector, managed);
+}
+
+static void apic_chipd_update_vector(struct irq_data *irqd, unsigned int newvec,
+				     unsigned int newcpu)
 {
 	struct apic_chip_data *apicd = apic_chip_data(irqd);
 	struct irq_desc *desc = irq_data_to_desc(irqd);
@@ -174,8 +204,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 		apicd->prev_cpu = apicd->cpu;
 		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
-		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
-				managed);
+		irq_free_vector(apicd->cpu, apicd->vector, managed);
 	}
 
 setnew:
@@ -256,11 +285,11 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	if (apicd->move_in_progress || !hlist_unhashed(&apicd->clist))
 		return -EBUSY;
 
-	vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu);
+	vector = irq_alloc_vector(dest, resvd, &cpu);
 	trace_vector_alloc(irqd->irq, vector, resvd, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	apic_chipd_update_vector(irqd, vector, cpu);
 	apic_update_irq_cfg(irqd, vector, cpu);
 
 	return 0;
@@ -332,12 +361,11 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	/* set_affinity might call here for nothing */
 	if (apicd->vector && cpumask_test_cpu(apicd->cpu, vector_searchmask))
 		return 0;
-	vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask,
-					  &cpu);
+	vector = irq_alloc_managed_vector(&cpu);
 	trace_vector_alloc_managed(irqd->irq, vector, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	apic_chipd_update_vector(irqd, vector, cpu);
 	apic_update_irq_cfg(irqd, vector, cpu);
 	return 0;
 }
@@ -357,7 +385,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 			   apicd->prev_cpu);
 
 	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
+	irq_free_vector(apicd->cpu, vector, managed);
 	apicd->vector = 0;
 
 	/* Clean up move in progress */
@@ -366,7 +394,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 		return;
 
 	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
+	irq_free_vector(apicd->prev_cpu, vector, managed);
 	apicd->prev_vector = 0;
 	apicd->move_in_progress = 0;
 	hlist_del_init(&apicd->clist);
@@ -528,6 +556,7 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
 	if (irqd_is_activated(irqd)) {
 		trace_vector_setup(virq, true, 0);
 		apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
+		apic_update_vector(apicd->cpu, apicd->vector, true);
 	} else {
 		/* Release the vector */
 		apicd->can_reserve = true;
@@ -905,7 +934,7 @@ static void free_moved_vector(struct apic_chip_data *apicd)
 	 *    affinity mask comes online.
 	 */
 	trace_vector_free_moved(apicd->irq, cpu, vector, managed);
-	irq_matrix_free(vector_matrix, cpu, vector, managed);
+	irq_free_vector(cpu, vector, managed);
 	per_cpu(vector_irq, cpu)[vector] = VECTOR_UNUSED;
 	hlist_del_init(&apicd->clist);
 	apicd->prev_vector = 0;
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 81d932061b7b..9d2e93656037 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -43,6 +43,34 @@ static __always_inline void set_reg(unsigned int offset, u32 val)
 	WRITE_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2], val);
 }
 
+static inline unsigned long *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+	return (unsigned long *) &ap->bytes[offset];
+}
+
+static inline unsigned int get_vec_bit(unsigned int vector)
+{
+	/*
+	 * The registers are 32-bit wide and 16-byte aligned.
+	 * Compensate for the resulting bit number spacing.
+	 */
+	return vector + 96 * (vector / 32);
+}
+
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	unsigned long *reg = get_reg_bitmap(cpu, offset);
+	unsigned int bit = get_vec_bit(vector);
+
+	if (set)
+		set_bit(bit, reg);
+	else
+		clear_bit(bit, reg);
+}
+
 #define SAVIC_ALLOWED_IRR	0x204
 
 static u32 savic_read(u32 reg)
@@ -144,6 +172,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void init_apic_page(void)
 {
 	u32 apic_id;
@@ -225,6 +258,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


