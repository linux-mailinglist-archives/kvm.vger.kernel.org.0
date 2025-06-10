Return-Path: <kvm+bounces-48837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31004AD4186
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD9D73A8AF3
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E2D24502D;
	Tue, 10 Jun 2025 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M3B6Gcpd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC4B1F1527;
	Tue, 10 Jun 2025 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578556; cv=fail; b=LvVZ54Z04Ckstw9FDsvaQV0zbRMabV7QUDkD6weM7pJkm1KsTeCsjSl5V76U27QKTFSqv2APXNbLFzA26GVC6gXLaU6YCU8xk8m7TuDMNTit1N+4Hhz5Tq9G6ONDiOfxcIIjI05aI6W6S2wKJ3hQPHl7XTZcZlaZlHfJBbYkDRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578556; c=relaxed/simple;
	bh=+ZMbbzeWmiE9pme9PhR9qhaGAoqoCFtkMDA0rfEcmvw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gWI1aN1k1zAm/q9F6DmBllrAekw+ItlVUVMba7vD6Efo3vPmpNRFizl7Tc/vT+gEDhqpQic3xyt5XhH2EeKSlMAeOyuUiyB1n/tPoKVRvXucYf78LC8eNNDk2S+LQBLN38lkE/qGCJnDnxxQUW9eBVGE00xhjiPRDnY9X8Wp1wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M3B6Gcpd; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PLC8AyfXLB5+UjEQbzoIzBotzGtE+96eQYPyf1Q8Znq0TX8JM+nmtBluoNugktJ9P1gZY9/sBj6BkVgvcH+hBfdafGSWuqnSpTIvkwI5C01/Q4e3bUpDsGGfYTCsC8CYGN7DE8i0W1xkIJAUFuuvUkSTvy+m7Zi9hMYRgALMUw9QDYDlNYv8dTGKYFno89ICHrdlYDy7aXnCoiVf3n1kN1etdAbGVskWjQK11shLI9ZvZ+Imh8n4W9XV9RfnjZV6u+Aa3UnXyAG1BDGYFpZywAh7WT4rVOkDoO5ZnjzoN/MdULL+7tZHVMmqtME92wtRNhhOWAQb8bh+kSrIEBYL2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGR9qamGGv6xu+AoYxRkNwdPhrWCjwZnBBGTZSW8ly0=;
 b=AduquVIEvBAlSrQ0kTpwHIbTPNf5n0n98csgtfR6x6RrcVUddyltnLjRzwBbLClmGhsqczRstUAGUrUBhHLUU4usjHR7AaSzqoREUmgxEP/1CBeA7Oeqel+eEHgzvCADzJrrI8eLV3TrSUPTw6pnqVLUOfVuzRH4s4JqSpdwQPa3nCu08Cf12NaElpoY6/ctSz50duWLk4TF01IT9MBc61K0Grna0D2zCUhMpUT4C8xpKLFde/I/s505qt2Q9uJit/WE5vXyRI9EUV35EeTvsLL2oi5AG7VVJ/Yu9kjj2PIqucwTMczfkigdqMRv3AH/YSKlkqplGYrGVixaUs7B6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGR9qamGGv6xu+AoYxRkNwdPhrWCjwZnBBGTZSW8ly0=;
 b=M3B6Gcpdr77wS0l9YbSBwTHEuV9X4/L2oNs3soxB+D6xHheqZqJKknOBimKERPAjEb43REbtV7VJZWObgY6wKCyc0mmeS48JqTniYArvPtFTrbBj5WtegRjPaSomMDG2sQJqXEm3Drx4H57AAURGDco8nxULpbXRwkHq9kZKxUg=
Received: from BL1PR13CA0409.namprd13.prod.outlook.com (2603:10b6:208:2c2::24)
 by DS0PR12MB6438.namprd12.prod.outlook.com (2603:10b6:8:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Tue, 10 Jun
 2025 18:02:31 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:208:2c2:cafe::25) by BL1PR13CA0409.outlook.office365.com
 (2603:10b6:208:2c2::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Tue,
 10 Jun 2025 18:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:02:31 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:02:21 -0500
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
Subject: [RFC PATCH v7 21/37] x86/apic: Initialize Secure AVIC APIC backing page
Date: Tue, 10 Jun 2025 23:24:08 +0530
Message-ID: <20250610175424.209796-22-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|DS0PR12MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f1f970-8b53-44db-bf7f-08dda848f835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2aYb0g3heFXnD4S8GtcHplhkfpANYwZJeimgOR9lETB8ku4jKxFPnQAjNT/g?=
 =?us-ascii?Q?0KVNr0BdGFwFaLSyAj6xJ6wOp/snSq6tQBYz5A4OHuZ3MIVIE239ezV07bdt?=
 =?us-ascii?Q?S8hB5cEi5zOMuLUIHRaC8qKZPoMP/zA8YqfiK8/6wHaHIL0AHlkd1jxyI6BL?=
 =?us-ascii?Q?+AQxfKsGlnIJ/d8QmuulQf30Xs9+PGk1lQuOlyNRq5Ab9Mg/HOdcrm6Fn0GH?=
 =?us-ascii?Q?34sTUfpX48Bz9cRvAWSuiqYDsKqg2ZgIv6M2g69phGc8gZpqS1Zu9oawj7l6?=
 =?us-ascii?Q?N1mcOZr1tnawUdckpVpTPROWsWOHgQFueXkLSYhWBmq0N9lfW4sEQ5cGXObS?=
 =?us-ascii?Q?JIXB+wlvPXHQrFRaoqO3YZJ+jxAk889wUeqC8zK80Lh5Yd0EBvP7F2TQ9Ic9?=
 =?us-ascii?Q?DKT5h3MZSnwkBNpKKydWo/MSZf9lJMgdgOGvxnQ1my9i7RhHLI5Eb9M6Tnog?=
 =?us-ascii?Q?jD1L30HroKjxqDADBrmrqBdjafXrgc5z140TLq1AZj0dW6G1s5lWRRd2GKmE?=
 =?us-ascii?Q?qzDUYsdIvjQMjSEE6QDseeK0FTXT0bJHsOtpzANdrsKbrbfGviZXX8YLIpYj?=
 =?us-ascii?Q?2F5JNKOqTO9G7+u7kDg8OoejnDxP9tnYC6fLaETwJyBU8yyCAIFH3rVxZaPS?=
 =?us-ascii?Q?NPz1YA3WYAMVJnOuQY3jORuI+WGLMpOV/9jbt2s3zNx69WAGYNX6evSd6PFe?=
 =?us-ascii?Q?XaPzzb+M8GcgBM6PP4f5Hixen70Kqwlw+XswVa+QKb2+0HB120LpUoLbfhQ9?=
 =?us-ascii?Q?rmtkj+C7bDGH55WM988jMbIO4v1q9kGja9kRx05I3l2xoYcid1f8cfFthZmP?=
 =?us-ascii?Q?l6ckWUB49wUL9dSCIGKXUHxLWR4KjX6OVOMgzs/F+IHdvZYwpaky4aXzlJoP?=
 =?us-ascii?Q?XjFxvVgXFKlOgG3eU3evohB4U/3zsysLttSN8G/NCGKoL2YlZvdCYs+8zxdx?=
 =?us-ascii?Q?G5Yok47vLzyxc7I77A6YY6UXjOlPNpidW9X1EjM3EHKn7rm2/+tN4HXET6z6?=
 =?us-ascii?Q?qu7k93BlXVLF4xBSWqXWoRC5UHLcjB4p3D4iRdBgSUB/XSkPs41MLf5Dxebt?=
 =?us-ascii?Q?hEzp4htMaORdPXKOrqTjSzGt/tLpMXy8xs1AwIzHolXAYtUemb8TCil4Kqb8?=
 =?us-ascii?Q?ovf1nLjoaHdzPKkIVwK2kqa14nq6avyMiog6Kqw/4d9+Tj3ldsRND3kVpXGy?=
 =?us-ascii?Q?TzWSEti2EYY54exrAftk4xZOV0GrTX99AcJNNo2yKBGV53eAz1q1hVl3HCgv?=
 =?us-ascii?Q?VR7a2LhXnebdDRHRUSBGd+Kia3BNgqoZIlHj9hkFtoZWeqg3XvZElUf8WS9w?=
 =?us-ascii?Q?3CaeFPa/e3Rhm+d3aPXN0lsBb5lIS3z3ZdgRDzoC3SG8fQXPudhuGXoc5iC4?=
 =?us-ascii?Q?moDaByXq1BhVOTKCIpZHmWbEzo3jcyc7g/RDjZeVolohRgM/X66EVemL23CO?=
 =?us-ascii?Q?xjgjpkxq7ryGuegz28EepBiCJxR6ecqWCaD0AR1pTSUWV6M6WXNGvRSPBRJm?=
 =?us-ascii?Q?IwnqMuVgC8Y4Mck70oglDDGi9ETtKhhelKvC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:02:31.1428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f1f970-8b53-44db-bf7f-08dda848f835
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6438

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for a vCPU's APIC backing page must always be present
when the vCPU is running, in order for Secure AVIC to function. A
VMEXIT_BUSY is returned on VMRUN and the vCPU cannot be resumed if
the NPT entry for the APIC backing page is not present. To handle this,
notify GPA of the vCPU's APIC backing page to the hypervisor by using the
SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN,
the hypervisor makes use of this information to make sure the APIC backing
page is mapped in NPT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/coco/sev/core.c            | 22 ++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 ++++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 32 +++++++++++++++++++++++++++++
 6 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e4d89a5f9f9f..32be4ab2f886 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1072,6 +1072,28 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
 	return 0;
 }
 
+enum es_result savic_register_gpa(u64 gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
+	ghcb_set_rbx(ghcb, gpa);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_REGISTER_GPA, 0);
+
+	__sev_put_ghcb(&state);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f91d23757375..184cae6e786b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 58e028d42e41..12bf2988ea19 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -520,6 +520,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 gpa);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -592,6 +593,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..650e3256ea7d 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -118,6 +118,10 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SAVIC			0x8000001a
+#define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
+#define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
+#define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d73ba5a7b623..36f1326fea2e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1503,6 +1503,9 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
+
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bea844f28192..a2747ab9200a 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,17 +8,44 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+static struct apic_page __percpu *apic_page __ro_after_init;
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static void savic_setup(void)
+{
+	void *backing_page;
+	enum es_result res;
+	unsigned long gpa;
+
+	backing_page = this_cpu_ptr(apic_page);
+	gpa = __pa(backing_page);
+
+	/*
+	 * The NPT entry for a vCPU's APIC backing page must always be
+	 * present when the vCPU is running in order for Secure AVIC to
+	 * function. A VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
+	 * be resumed if the NPT entry for the APIC backing page is not
+	 * present. Notify GPA of the vCPU's APIC backing page to the
+	 * hypervisor by calling savic_register_gpa(). Before executing
+	 * VMRUN, the hypervisor makes use of this information to make sure
+	 * the APIC backing page is mapped in NPT.
+	 */
+	res = savic_register_gpa(gpa);
+	if (res != ES_OK)
+		snp_abort();
+}
+
 static int savic_probe(void)
 {
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
@@ -30,6 +57,10 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
+	apic_page = alloc_percpu(struct apic_page);
+	if (!apic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -38,6 +69,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+	.setup				= savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


