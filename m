Return-Path: <kvm+bounces-18042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F091E8CD22D
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6482A1F22ABB
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6925A14885E;
	Thu, 23 May 2024 12:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hcalv8i7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00A81487E6;
	Thu, 23 May 2024 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716466779; cv=fail; b=I003J2UsKDWbWUQEzyRkSz0+1HCXnnlGJfaejWG9BKPS/V1BNWm1I+ZYzw8xw1ytkJsgQtuLeRylKHG7yMVQ6U8UQhEzxE6hBhmhGajdb9wNGhjwC3Cw4Ig9A6s5m0ls6V1KP2qF5AkB2bFhFyxOpN15h37c0Lng9u6+JvyRgko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716466779; c=relaxed/simple;
	bh=mA5Fa7x5eU3CX3XkRcMrqXzP5f912Pyp5dWe6xRm+z8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N0G0s37B995DrHe5XHz+np2Bx4Fw2MPhC3jRwy2aUHO2dcGZYddmrz8d9un8a8wz+eVPzIQYfu8YgOTHQH45jLt2CpEHju7rzKQ5QX1uggcVRge4S6WKJ4qxvxYy0XpYMbU77I/8H0zOlpSLiea7917VKj9dXBoiCqWI9bCcJps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hcalv8i7; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9UJFWrJ3KeRR143e4WJA3o2FzNTE5n990cwKXtDmBn9YhpyEmuuYGg814IFVUCD5iusetQwpm47gcqWfuOvilsynRYnj5E6ffbJ7MK64KsoAsAlaXNe5nkK4sRcm7solzwvAomLlhTX7lKg6wFyO08pxlkTTUPIWuhewPC9JNgiy0WRK4MrU6VBbGxVpduf3vl80HDgqEkLHXe0j6bfcWRxce1V2bqgOXe3RS2pJSLVKBB4/HzoQoT0lG0PO+d8WXGvru+X3xBBz47zC1G7Q//w1Qyu5RsQbNCAIWvOdteLb+IjkzZDtSfjTZEnjwzpW3GM85Xqe2siIivMfSC07Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SS/0ZIhqs/7oQ8QeaxMDQg4AHCONvuTJqVcMo+4Y+YM=;
 b=FfpN9iTbVHcFy4Bj+Adh/QKIoRPS5bSE+It2n4BJqmk1c84iE8rPwKII2JASEtVj852/ZChRAR9vxeiJeYpaaNPrfXDOY10srpoxAIQQWazLpps0RdoDKx3YpQBUQAHR55qMzq01ehprpyBz5y8DUslbLopXf866o++Y74b5UUg3C0cqZ6tUChFTtbEuaJ/S75wR4NOyt1fPHntfBYIgTnrjo0Bm0wTw1/jO5VzGMyXigTXnh1JBwARITij1+oQgQV9OKjWDfEN0aCpzX6W53MCU5GgptkBWauaOnaQeAYDq5LjeUyZEOhCvyA7M6C+/PiJDummLtc5aXvACDtgymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS/0ZIhqs/7oQ8QeaxMDQg4AHCONvuTJqVcMo+4Y+YM=;
 b=hcalv8i7OeDeZq5yMhhLjZgqh8z1kPdSifAGo/+r9VlyGRzKBDphYSvyUYimcLBzTH7eodU05fVQ44H3ogM+ozg1XEM1PmntE//rQo/bFWDmhYDqJxl0fByJJTJtmGRuae5qasebHZYuFU+Fw34XwsrPhj6gLPmTe9Oj9ugI4Vc=
Received: from BN0PR04CA0062.namprd04.prod.outlook.com (2603:10b6:408:ea::7)
 by SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Thu, 23 May
 2024 12:19:16 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:ea:cafe::81) by BN0PR04CA0062.outlook.office365.com
 (2603:10b6:408:ea::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19 via Frontend
 Transport; Thu, 23 May 2024 12:19:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Thu, 23 May 2024 12:19:16 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 23 May
 2024 07:19:09 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v3 2/3] KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
Date: Thu, 23 May 2024 12:18:27 +0000
Message-ID: <20240523121828.808-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240523121828.808-1-ravi.bangoria@amd.com>
References: <20240523121828.808-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|SJ1PR12MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cad37e0-f133-4d52-907c-08dc7b229067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|7416005|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XEd2TGSAmVJ5KD+xhKrJErb6dB62kypi/q0pHCZ+7UBgPJv+P2R8x2I20SIr?=
 =?us-ascii?Q?BVXGXfMW3r+/knztPDYt5NN2GLGQmDe6ZwGHfoJYRAZRaMR4cxIXKdCLRoB4?=
 =?us-ascii?Q?sI6fKhgrqTeZt2OC0ogo7hnJsqK4CiBglJ9LYcFbQ83BqZC/Loat+zkUV3xb?=
 =?us-ascii?Q?cpPZ71sGiw1dU3WuQScn1sQb1+5Q+6dqvEuTHMdCMp+Tq6oso5l/V8muYg05?=
 =?us-ascii?Q?AuiP366uHRFSYVZzjwQBzRKAT7f2OSYw2M/fibhzsIU/Jq/xSY6efkj2BCfk?=
 =?us-ascii?Q?TPJeYYfekrdkyla8NnJ3yMmEiljif3070cFBPC2hfd7l+8xlHG8y8uhxVCwR?=
 =?us-ascii?Q?UpSHV8nQoWOArZR4iWYlZwhQcFP9GzLJ20ikkDoQnMSTcjgpTFI50VG48/5J?=
 =?us-ascii?Q?YgauZNv14VUwno/B5gmKf4vHUEFtSrwI3S516G/muEuaw7M6e1gh3YCWJe0c?=
 =?us-ascii?Q?QlJN4z3AIczgNO1hp4+9iYzdb0XoDUE/moHgZ444yRwk68lcBUI72vU42UZd?=
 =?us-ascii?Q?zAqo+uBmW25sdpDF1B22nG78n/6Dqjk9CtaCbKZ5+TxQK8E3ZJJ0+4m89VTO?=
 =?us-ascii?Q?7f/ZNtazTK6qC/dVd7esohtk2L+lBPVPbDgSvh1SRkRlf0qcYKt1obBSvifn?=
 =?us-ascii?Q?hhSpVRxFryGpVMjP5TszxZ3At6PST/zzUEdM4kB9f4GZQGaFqEQXp+4FtMOx?=
 =?us-ascii?Q?++6OOO6TyTBgBqX0UKAdu5mGmc0ClkUobuiCrtcsyLsSManox5ERbhkZu2wZ?=
 =?us-ascii?Q?WpvsxGIOsWTFZvjfL9voDsdqQSiU+hhIq1YI2TTmDLi1TT8gzXwC6ePji5+6?=
 =?us-ascii?Q?KVOAGPU5DZ1kPQTJZ4K/RsttqIy8aYypQ3v0v8Fw161HXgFYqNoJs84ZHUGw?=
 =?us-ascii?Q?oKaMvg2U6es6Kn6x0uSmyV6TzyvCJMG65leFRFCiJh+uTN1IVIIwDrvmOCHP?=
 =?us-ascii?Q?YOW42dndymesQECPryjKxe6Qy2LG/ulRmtJ03FFerzD0RDxA+8YlKSgGnZDQ?=
 =?us-ascii?Q?JLHW5VQDnnh1c7W1OVB4Jo+4I3N3uH0+c5ah3tXjfNOzNnK3GCKxcyBzDUMi?=
 =?us-ascii?Q?CA+cWOTUieLDvt7Z+fE+VZyGThhF5wyfTwwwJcGvXagpcx36TN1Ia7mc1Ubw?=
 =?us-ascii?Q?hnpWeC9K1/I735jr+XUEW3IOvoM/RqLYLF87tPfhcSHFGR2DFHqTQHIIlJKI?=
 =?us-ascii?Q?3JBit4pbuagcrw7SlXKZDjRHMkMcA97FwUPqnKqQeftlah/BAvCWNBZoSXnE?=
 =?us-ascii?Q?MudTG5cqFI99RHJgvIaVUWlZszNtFHeYKSuFkDxgC4DO6/IKE7rgkL/x8a2t?=
 =?us-ascii?Q?zddyiveikXPUClnh5As9YSDQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 12:19:16.0484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cad37e0-f133-4d52-907c-08dc7b229067
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6124

As documented in APM[1], LBR Virtualization must be enabled for SEV-ES
guests. So, prevent SEV-ES guests when LBRV support is missing.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 15.35.2 Enabling SEV-ES.
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/sev.c |  8 +++++++-
 arch/x86/kvm/svm/svm.c | 16 +++++++---------
 arch/x86/kvm/svm/svm.h |  4 ++--
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 176ba117413a..1a2bde579727 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2856,7 +2856,7 @@ void __init sev_set_cpu_caps(void)
 	}
 }
 
-void __init sev_hardware_setup(void)
+void __init sev_hardware_setup(int lbrv)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_snp_supported = false;
@@ -2933,6 +2933,12 @@ void __init sev_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
 
+	if (!lbrv) {
+		WARN_ONCE(!boot_cpu_has(X86_FEATURE_LBRV),
+			  "LBRV must be present for SEV-ES support");
+		goto out;
+	}
+
 	/* Has the system been allocated ASIDs for SEV-ES? */
 	if (min_sev_asid == 1)
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 489b0183f37d..dcb5eb00a4f5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5308,11 +5308,17 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	if (lbrv) {
+		if (!boot_cpu_has(X86_FEATURE_LBRV))
+			lbrv = false;
+		else
+			pr_info("LBR virtualization supported\n");
+	}
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
 	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
 	 */
-	sev_hardware_setup();
+	sev_hardware_setup(lbrv);
 
 	svm_hv_hardware_setup();
 
@@ -5361,14 +5367,6 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.set_vnmi_pending = NULL;
 	}
 
-
-	if (lbrv) {
-		if (!boot_cpu_has(X86_FEATURE_LBRV))
-			lbrv = false;
-		else
-			pr_info("LBR virtualization supported\n");
-	}
-
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 555c55f50298..2d7fd09c08c9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -728,7 +728,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
-void __init sev_hardware_setup(void);
+void __init sev_hardware_setup(int lbrv);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
@@ -747,7 +747,7 @@ static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
 static inline void sev_vm_destroy(struct kvm *kvm) {}
 static inline void __init sev_set_cpu_caps(void) {}
-static inline void __init sev_hardware_setup(void) {}
+static inline void __init sev_hardware_setup(int lbrv) {}
 static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
-- 
2.45.1


