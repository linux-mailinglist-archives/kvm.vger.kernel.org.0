Return-Path: <kvm+bounces-59872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E1351BD1ACA
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 11DCA4EFFB4
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8042E54BD;
	Mon, 13 Oct 2025 06:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yZEEer+Z"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010016.outbound.protection.outlook.com [52.101.85.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AB72E4279
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336765; cv=fail; b=Wv6mby4maW1gDaF5mDZqh0Ck+ifoBFSMjISuDk94PImSA0RaEWH7jtYopE16qKH4t+3wnErEMprYG8azOQNpzx3wP6Gy8DwLnl1hfvuIzkwSXZ7Xn7RoEAsjEoYhpsU5OrZft/5VUHHIQq6Uu8EQPlWBTAOKHkDfWGRFs3C6KAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336765; c=relaxed/simple;
	bh=ODyw847kHcVRDAplraRxMm+9MUUWqkvBSIygwi8j7SU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iEipAk+LWIzvO4NUGG/VRdkyeAKEHFTEu7h1rqF3QUkEYYXyjoXGw6qPIEd6ElR1+lnr8QHLu2i1IoHjC6s/5ZRTRXWN3L3dFSCGr0EqMx3pZWpJHSaISMBT5t2r01Ppb++8pWOkO6O9SBLBvawkYishXeubWx/pUKIIB8daOOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yZEEer+Z; arc=fail smtp.client-ip=52.101.85.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0g0Uz95lsLXdCVEs6yMlClZiz5zGbsRmlqUN2kvaZ0S2wKo/vfjHy3AcIjUs5aXnsUatRz+/vuAX0t+a5I19018BkpU/9pnEMGEQeRNH7OEiivFz4K1hItwe1Bfun7nKXYyZ2KQS/gdIkE6RBQJTMqo3bdFrNdJbcqsFeNWou9X+9JpkStO1mdqh0b6fdYgXLZqyKqMzcBXaRnjprZetXcCco6oJf04D6kpztbrEXJiP6GFobMrHBEKnBsDHaAGO7/kXoapNaI4ObEAeTfilTFJhN7Ch/YBQDHtL+dBeZ0bzoqNI97Ccqt543Mg5V++fHc/gF1c+floPVWyB/fyvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVZCvHb2VZaC3rB5n8aSIvc9kG4RK8IZ57WYmOscWYM=;
 b=N54uBFX5GTAfH2NeG9YYxeBGiPsaoYu+UgAHOqWXudTwfzcnU4Dtpse/TV8tJG+B0/hFHCSAwUi7GeOgkUuOV622u1wG1Ac/vkKiZIIc6uIE6DRrK2FBWEaNuHoX1e561F2FYvhlR8m7993kFFeoXPmHMN1Qv65KYFc0qzmitGtcpkLHvXLyYBzhSYDecEg4dIwzQwGJQ3MOL/ojwivo7LTi7fLfSPHi1vJF/tQ1wpU+q6wWu5aqa1AxZ+K/Gvxecomhaw42BJpwAoltiqGVGItDmy5PCZSWqYtDrSXDo69vBugNNh2EB76Fe7XG+xZdzkKo+mGC5o/+MfedVEKRpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVZCvHb2VZaC3rB5n8aSIvc9kG4RK8IZ57WYmOscWYM=;
 b=yZEEer+ZBZbt4+2+vxXT8c/kItUbWab3reMXpzgUphpJEnV1TvLDSAzfdzdTGHIef/8iMUkki+YVPq4ClITSr+NVYvX0bpwiYGTfTqNdhOTN2kYk+GSDI451uDxFB/JQEKAuMzXYgdkTniI5TSUt43F4RLo+DEsTJYiyH6FuoxM=
Received: from DM6PR07CA0113.namprd07.prod.outlook.com (2603:10b6:5:330::16)
 by PH7PR12MB6000.namprd12.prod.outlook.com (2603:10b6:510:1dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 06:25:57 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::82) by DM6PR07CA0113.outlook.office365.com
 (2603:10b6:5:330::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Mon,
 13 Oct 2025 06:25:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:25:56 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:53 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to common code
Date: Mon, 13 Oct 2025 06:25:12 +0000
Message-ID: <20251013062515.3712430-5-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|PH7PR12MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: 77703603-47ca-4527-5a2a-08de0a215e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zy3sMvJWe+tYSFjTZYVKRlLDMRmnF1A0O/QKe7N3TiGQuzqTf9xa5HZqakSa?=
 =?us-ascii?Q?pNOuTqQRot++ohYaA0QL6SwRxlkHdc0VO1ZUeVqM4X3CSa3xdx7sn7ZoTMK8?=
 =?us-ascii?Q?60qvgMa+Qg0Wu9zrPr79BFXDGPJTmCZCvGYkSt3LFcw4+MM7JljvYkpI4NZq?=
 =?us-ascii?Q?W98hLhl7Bp6adqOFAZogObpGUZe8yudreWJugXxEDHcgm6NvKly466agxeEJ?=
 =?us-ascii?Q?hMCXm0WR3NliDSs/cJVro/QtSX3d4ZtwWLl1faj/N9wuydjaJ9akD9MKHzT2?=
 =?us-ascii?Q?9Xh4PFzzbLOKAI6KaqTwI7vSwCzvO8D3BkujtskiIeHa9qcsUREvxTr0oR/W?=
 =?us-ascii?Q?zkfyj2f0TA35SCdq+4DHCO7AwMz6ONaRqC+Cd3tpuii21zgs6tRuxHAPAVUW?=
 =?us-ascii?Q?cybBuJlqqZ71u8gv3ZkI1Y7m8pe+pGVuKOHpTzrMFAg40kaJiF3VwJPAKFbt?=
 =?us-ascii?Q?dCpwiIKiLzTQ2HNO9FaJG6O2HbyLiLLbb3jAkAdeidctaFzRH8eFePvILwBR?=
 =?us-ascii?Q?drYakly/X825JbtaelWRncTEP4T+VHVuFlvj43GENeqBsh8C4vhKlu3yC+Nc?=
 =?us-ascii?Q?w/wNv2K1as+bHxppdPoocTQJOknJgNOitypE140dwbK5dsC7ShZvJjSYTAjg?=
 =?us-ascii?Q?ZyR8vyCWC8H23naix2edOU7kp1ECQVKI6GlvpHGIO/Et08mchFlbW1o2yx08?=
 =?us-ascii?Q?qEG55iK93dBQIwhJ5H5wFGSdGmkO9PVdmC7JnNC06bCcltp73eLKywWLBCyt?=
 =?us-ascii?Q?qOCzS4LVBh5br7xYkGN4KY0CerPGC+e6IWt1+MXFx3ZH+zPV7N/tBDMqXQM9?=
 =?us-ascii?Q?eDB1mEuOQI3/ZHoGWjcLpm8HxTJW7aRnv8QJ0Py8WChieNKbNmHcXvv3NW+j?=
 =?us-ascii?Q?GZ0cPUA6ZqawNav0h7y6JUJBlFgJo7kbiCafso3uHQM2j8ENnnqkUDffcDIs?=
 =?us-ascii?Q?RrHIBWOfr0mIGQMvyODR8QD1efY0Zh2qMQJae05QIiKO5SXDPauw80c+ODLZ?=
 =?us-ascii?Q?9M5nBQxLASUJAEeV937P6C2U+s4iW6ZzWRcAEodKohr0ZEZhco6W3jxAWGER?=
 =?us-ascii?Q?VGfrNylH7KPvsgMw1udDhDZh2lXpKgKvBdQdRtOROqqD8+qy8wSYzZgIol3r?=
 =?us-ascii?Q?D9WWCGRXWTOPW0SsWjA0rK8jepGeTr+Cw853WirQp+AJ3AiNiiC2ELD3cGw1?=
 =?us-ascii?Q?Oho4lfmItK9G1akXqLOmX1YMTbO/68maGtfVn8gqxZlVY8YLk+HaJiRYipWi?=
 =?us-ascii?Q?6QcO5sUrXkOp1yEWu92mcoAn9MbMXluofQpOr1H4RLDpA2hdw58NksWj9lSU?=
 =?us-ascii?Q?qOJ90tOxIZM0eX0Pub0dGMgn/GHQ6aeEf6ZRL12H5tYqckWSV+eE9U/SAPg6?=
 =?us-ascii?Q?PyF8cpT5D5qFBaRiLNyqA8H3z84jwufc9zk7k1aeXyIlO0YFdo5Pr9PVwKi5?=
 =?us-ascii?Q?xj16+fVgVpdTPL4K8/ATQ6TDsccpP7JPmf08ciZ8738cLgUkZOR5dE8SKXzt?=
 =?us-ascii?Q?USG0MC5aCUmkEopjTYYeM8Sn1YbcgR6vdJR6OXXbYTA24fepoVvEPFEHUhHd?=
 =?us-ascii?Q?bzjBrdIZrywMkc20L4w=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:25:56.9695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77703603-47ca-4527-5a2a-08de0a215e99
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6000

From: Kai Huang <kai.huang@intel.com>

Move nested PML dirty logging update logic from VMX-specific code to common
x86 infrastructure. Both VMX and SVM share identical logic: defer CPU dirty
logging updates when running in L2, then process pending updates when
exiting to L1.

No functional change.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/kvm_cache_regs.h   |  7 +++++++
 arch/x86/kvm/vmx/main.c         |  4 ++--
 arch/x86/kvm/vmx/nested.c       |  5 -----
 arch/x86/kvm/vmx/vmx.c          | 23 ++++-------------------
 arch/x86/kvm/vmx/vmx.h          |  3 +--
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 arch/x86/kvm/x86.c              | 22 +++++++++++++++++++++-
 8 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 73b16cecc06d..ca5def4f3585 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -862,6 +862,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
 	struct page *pml_page;
+	bool update_cpu_dirty_logging_pending;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
@@ -1884,7 +1885,7 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
+	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu, bool enable);
 
 	const struct kvm_x86_nested_ops *nested_ops;
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 8ddb01191d6f..0c4a832a9dab 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -238,6 +238,13 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
 
+	/* Also see kvm_vcpu_update_cpu_dirty_logging() */
+	if (vcpu->arch.update_cpu_dirty_logging_pending) {
+		vcpu->arch.update_cpu_dirty_logging_pending = false;
+		kvm_x86_call(update_cpu_dirty_logging)(vcpu,
+				atomic_read(&vcpu->kvm->nr_memslots_dirty_logging));
+	}
+
 	vcpu->stat.guest_mode = 0;
 }
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0eb2773b2ae2..6fb97f6ce48e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -103,7 +103,7 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_load(vcpu, cpu);
 }
 
-static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable)
 {
 	/*
 	 * Basic TDX does not support feature PML. KVM does not enable PML in
@@ -112,7 +112,7 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
 		return;
 
-	vmx_update_cpu_dirty_logging(vcpu);
+	vmx_update_cpu_dirty_logging(vcpu, enable);
 }
 
 static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb70..0093fc389eae 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5202,11 +5202,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_set_virtual_apic_mode(vcpu);
 	}
 
-	if (vmx->nested.update_vmcs01_cpu_dirty_logging) {
-		vmx->nested.update_vmcs01_cpu_dirty_logging = false;
-		vmx_update_cpu_dirty_logging(vcpu);
-	}
-
 	nested_put_vmcs12_pages(vcpu);
 
 	if (vmx->nested.reload_vmcs01_apic_access_page) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 81216deb3959..ede5aaf24278 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8194,27 +8194,12 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
-void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (WARN_ON_ONCE(!enable_pml))
-		return;
-
-	if (is_guest_mode(vcpu)) {
-		vmx->nested.update_vmcs01_cpu_dirty_logging = true;
-		return;
-	}
-
-	/*
-	 * Note, nr_memslots_dirty_logging can be changed concurrent with this
-	 * code, but in that case another update request will be made and so
-	 * the guest will never run with a stale PML value.
-	 */
-	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
-		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_ENABLE_PML);
+	if (enable)
+		secondary_exec_controls_setbit(to_vmx(vcpu), SECONDARY_EXEC_ENABLE_PML);
 	else
-		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
+		secondary_exec_controls_clearbit(to_vmx(vcpu), SECONDARY_EXEC_ENABLE_PML);
 }
 
 void vmx_setup_mce(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d2dd63194ee2..22bf8860add4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -133,7 +133,6 @@ struct nested_vmx {
 
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
-	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
 	bool update_vmcs01_hwapic_isr;
 
@@ -401,7 +400,7 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
-void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
 
 u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
 bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9697368d65b3..1ae01fa592cd 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -113,7 +113,7 @@ u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu);
-void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
 #ifdef CONFIG_X86_64
 int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 		     bool *expired);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b23d7721444..42479fcda688 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -149,6 +149,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
+EXPORT_STATIC_CALL_GPL(kvm_x86_update_cpu_dirty_logging);
 
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, 0644);
@@ -11055,6 +11056,25 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_x86_call(set_apic_access_page_addr)(vcpu);
 }
 
+static void kvm_vcpu_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(!enable_pml))
+		return;
+
+	if (is_guest_mode(vcpu)) {
+		vcpu->arch.update_cpu_dirty_logging_pending = true;
+		return;
+	}
+
+	/*
+	 * Note, nr_memslots_dirty_logging can be changed concurrently with this
+	 * code, but in that case another update request will be made and so the
+	 * guest will never run with a stale PML value.
+	 */
+	kvm_x86_call(update_cpu_dirty_logging)(vcpu,
+			atomic_read(&vcpu->kvm->nr_memslots_dirty_logging));
+}
+
 /*
  * Called within kvm->srcu read side.
  * Returns 1 to let vcpu_run() continue the guest execution loop without
@@ -11221,7 +11241,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_call(recalc_intercepts)(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
-			kvm_x86_call(update_cpu_dirty_logging)(vcpu);
+			kvm_vcpu_update_cpu_dirty_logging(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
 			kvm_vcpu_reset(vcpu, true);
-- 
2.48.1


