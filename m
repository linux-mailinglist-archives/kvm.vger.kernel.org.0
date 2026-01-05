Return-Path: <kvm+bounces-67001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B83CF215D
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B0F3301FB4F
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D055A1EEA55;
	Mon,  5 Jan 2026 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e0MAixZe"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DAF4502A
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595033; cv=fail; b=qDzdzRKdPE3TOFcmH9gLRVqi9DFQ6tDdCJZZR3TQ/2svytcQNtfq2U6w7ZHb1ERGw89V8YnzRnf/DhgFfYxBNPqR0FgiXb5gB5gsAE1inI4Tm3EsblwHI9Be6O8H+Vs7tCrQWWgZg2Dnxld1oW8ZgGWWqKIQVRUwsNMgSwMy2No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595033; c=relaxed/simple;
	bh=wRStuVwzrDuWXRaFpGhvWosJvfNcjhOa/we0EnnxlLc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=giyqjsJAHSmmta0+r3pDhtZX8L7a/Q2Wg6D2WgbyEEp9bfJBL91wLRpwPjkDcZQDTl6vlk1RbcetNm/LdBRaHKvcnegYV7iUNA+/Z2JtX+Kpyyxfl3SM1qWVbGUntNqQXbM6JNOfbPgCcYEUE/kpuqQrVf8JusfEv+kDNoa1myE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e0MAixZe; arc=fail smtp.client-ip=40.107.200.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVVwZWQ0xFra6lqYeQi38RPrBWopDe4rqR6NM0xWNq79NO2m0objhk93ol7po3bmN4b3UpvObKo8VOeEXn8pwgbVuPxlPqDGR3kUhCm3uCRiVjA7Pcy1TA2fWQWxxK4RljlzFHuZXEja/hSMAcKlTZQd2ugdIqyLOvMpnDfLpOWQXrqfvV5rf8Sr0pBjW+3Ah8tDG8i+5KmoBxK32eFF3aF/5F7o1JFXwvCdO3+61myPXEa7IDS30uRt1uVLtF9Mzc+dSz7r5LQrRLqYD0hdpK/oeUzHprjdBo/MVLoqnq8hf2Elzxjac3pvpdAhpvD9D4PSwt/HloiHGAuJwIzPzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yzPRpwxh2R6wMVphGmC7Qr2saSilcMdwKgaaJA/Hyw=;
 b=J0hyJceohKLe68yK1ByvY5mpTf4w8j4ZXbSU31gzW7/cSqkJd7UJQbpQwcFVww2yUgKjhgv6UHLzC87eWPSKLjHtA8hxdqWmqLRIxbBL4G7hrJpCuI9q0ppLAMZIGZ3mrqcxh2v4Y6sQE8FC3cDYnT4y+x9Qpel4dAVSXBvcHHnZK0bsogpRbR9JxDtjr3eo6vQZ9gvJVJHp1/c5bxjOSlb4Taa4hQcsgKPiHrNDmTIz+iDcXxy0PvvUl3l26oKI/JsCnc+banXe/miPZ9Ydo1Kq9X62nOzqb8qdLnS5IC02cAMpkhdhOwq6+TD3P5qyNg9/AObJl60Fpn0Zorktyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yzPRpwxh2R6wMVphGmC7Qr2saSilcMdwKgaaJA/Hyw=;
 b=e0MAixZeSLHAbKK5yY6PgX0ixfWVAInIoUaHs5jSAND4XrzZViMJ1Fpwc1GFBzCFd8tpqmKIHGUed0WXrVtUFZl/j1ZzdFviWV15sryoxMiS12SorbHu8A0fgplqiJhwXJca7MHvvSAiiXSRgk1yx2RM1Ll5m+drm8YB+aAxgGs=
Received: from DM6PR03CA0073.namprd03.prod.outlook.com (2603:10b6:5:333::6) by
 MN6PR12MB8544.namprd12.prod.outlook.com (2603:10b6:208:47f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:37:05 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::62) by DM6PR03CA0073.outlook.office365.com
 (2603:10b6:5:333::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:37:05 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:37:01 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 4/8] KVM: x86: Move nested CPU dirty logging logic to common code
Date: Mon, 5 Jan 2026 06:36:18 +0000
Message-ID: <20260105063622.894410-5-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|MN6PR12MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: 6633d785-9682-47c8-1ae3-08de4c24d7a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LE4JsTMsqNHyfvGGy989tyDLXuQ5CXq9m/5poaLo+bM6S63+tc08Ht6zbQaq?=
 =?us-ascii?Q?/jfFhP3U3CxhehL/R0NImT2XwxruBBZ5zhaeDayCbMY5mXKXrv2kH8+LX47U?=
 =?us-ascii?Q?+TXqotIluNdfamle9EmIExzDzG8h62KvoEHnS9ScwUydfcSeokb/ZPcqk1MZ?=
 =?us-ascii?Q?EAmniGU0ByXxFktbGp3tyz14mHn8Lj6Og03y2ghXBfEhL44unGL92EJnv2pr?=
 =?us-ascii?Q?RJQAyGfCiWK2NpVQZ2M1oJWCyj7tMfh4m/PdmRkqbDs/uIAsC/JDR65Qaipw?=
 =?us-ascii?Q?pIGU6dYO+WNNzOsAl8yLFug1RyZxg4+jeXp/a8QPTrOtjLO+OPm+q00tjlRv?=
 =?us-ascii?Q?sbv/1k1Ih9uqDqMb0Ft6aNWwzhBGi8IVuJLUfVkUKvQsO1PKio4NtU0c3GoL?=
 =?us-ascii?Q?+PoTA7zjyFNYNXg18sya0a7bCUW2AKop42QZX8kobrtZMIAfXusZBkRUhrjU?=
 =?us-ascii?Q?EobTMo4fmNT8KL1H9EmQs/2TmUzYvii6BP3HHe1dh4z5UEKaHMDcxYX5SMIo?=
 =?us-ascii?Q?dRlgRQvFt52MrZ/MhEOtE6qGzJ4CppIV6guPaH3j3/XnDjsyE8znjCBt8SAV?=
 =?us-ascii?Q?M5GK/aP9Nh9SC1UjkzvuoUwj64OJsQ3aPtO/pt5lFoc1IoXqGqJJqW+KcUWA?=
 =?us-ascii?Q?jXsFSpnP//bXZSr1P6ALiUmelesg+OBhnZWuRnUXsvDCQGpms75CzdqTs1Fe?=
 =?us-ascii?Q?tgHs47l3W0+6nw+M1sbc1jFoWaG5IMhiyKTH4RCxlnUiTO3AbyHz4xxAH073?=
 =?us-ascii?Q?gn79wcYNrLUDy7GvdrmGQshfKCqXMweNplmLooRwr+yLdOPssONG99KdDg/6?=
 =?us-ascii?Q?CnKTjRlnJQ5SCj0qLmcRhafhSBY8L0kN1PR+jbfmuaczGFYGfexvDVmiKvlo?=
 =?us-ascii?Q?EgXSNIOBhvobyR2LwTYDnG7aTYigUfRsVGua1yoNt2KofgtQWYTJ02CSYuD8?=
 =?us-ascii?Q?WkpW6liNdI45EZ+VChWqjgY95GT3DADtk6yG5X/CdQ8sXNF8AAikQC47m+6v?=
 =?us-ascii?Q?EGM84muA7RGEipcrFtshOHDECswUgAdWTsiORclmmT3GM7cwj+1G0EfJcI1d?=
 =?us-ascii?Q?u2YgUl8YzJdZGezenA6FicQlVuj/dEo2rXhTLn+K3rSRTKJYZQS/L9jiRxNa?=
 =?us-ascii?Q?yO3TVFIi2jCPcSnpeAC6dciUT3d//POKHs37pKcGKKvQuI1D0wonOI1a1aRX?=
 =?us-ascii?Q?iobzDRlw1UsG/BvXYKeMSXzr7eePSjzGODsrWPy7TdozEIdqOZ+3dbJfoVEz?=
 =?us-ascii?Q?N3D58bGgAKT8lSUyXcQZnKreSM81xhywXydcJ38TbE4Jv+bXXvEEFqQmGAvM?=
 =?us-ascii?Q?3qULV/PiGMgEKqfc8wxzzCO0QXPk/sLSmJKhDSDKaBIBvSQc5fgHlaDV9T1I?=
 =?us-ascii?Q?zr4NX9weoixLsTnFOamLTyMltuMc4rSbz8hBkLdrPsm9j2GkWgFOAIhpnO34?=
 =?us-ascii?Q?YXibnLDPFY52Y9KgdZeZA7hZn73AmA75TH0Tjv6LqGDhQ1jW5D2Nj1rHA3Hs?=
 =?us-ascii?Q?HzYlBMtBRfptcOrnq8HCIVPVBCCNNupm8OJJZ6PS375h0J8vHITZYEw1Hn51?=
 =?us-ascii?Q?mlaN1k1GucPhmWBN8FQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:37:05.2560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6633d785-9682-47c8-1ae3-08de4c24d7a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8544

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
index 123b4d0a8297..4bd4c647aaaa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -862,6 +862,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
 	struct page *pml_page;
+	bool update_cpu_dirty_logging_pending;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
@@ -1879,7 +1880,7 @@ struct kvm_x86_ops {
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
index a46ccd670785..7235913ca58f 100644
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
index 6137e5307d0f..920a925bb46f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5152,11 +5152,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
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
index 91e3cd30a147..6c3ffaa8ce1a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8238,27 +8238,12 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
-void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (WARN_ON_ONCE(!vcpu->kvm->arch.cpu_dirty_log_size))
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
index c9b6760d7a2d..5dff2fa213f5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -133,7 +133,6 @@ struct nested_vmx {
 
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
-	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
 	bool update_vmcs01_hwapic_isr;
 
@@ -400,7 +399,7 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
-void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
 
 u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
 bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d09abeac2b56..f4e1cb6d8ada 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -112,7 +112,7 @@ u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu);
-void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
 #ifdef CONFIG_X86_64
 int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 		     bool *expired);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e299c4b9bf7..5154fa8924cf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -148,6 +148,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
+EXPORT_STATIC_CALL_GPL(kvm_x86_update_cpu_dirty_logging);
 
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, 0644);
@@ -11066,6 +11067,25 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_x86_call(set_apic_access_page_addr)(vcpu);
 }
 
+static void kvm_vcpu_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(!vcpu->kvm->arch.cpu_dirty_log_size))
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
@@ -11232,7 +11252,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_call(recalc_intercepts)(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
-			kvm_x86_call(update_cpu_dirty_logging)(vcpu);
+			kvm_vcpu_update_cpu_dirty_logging(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
 			kvm_vcpu_reset(vcpu, true);
-- 
2.48.1


