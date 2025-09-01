Return-Path: <kvm+bounces-56411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79970B3D8BB
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62D403A467A
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43102239E8A;
	Mon,  1 Sep 2025 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ohdZCSf4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28DF19AD89;
	Mon,  1 Sep 2025 05:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704362; cv=fail; b=QH6S3l3rWf6WEICkdEP1sFQ1jNXs9KTuQi848SKeu5OQ6dNw3WMAhb0v1zaN3f4SSfgkXHM7tDtUQXnpFlNQS5RtHWGA2O1JYl7/o+RWpuRAMVsaSQE/jjxSyxV5OeMc8DeHtpskQwOLuPi8EiD/xcfyWOH6P7uDmQUxBcmX4RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704362; c=relaxed/simple;
	bh=Dba9tVwu9jRXlUYWa2YmoAw2SOtAV/Mb/s7rISbFpV0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqAzxYXTIRYCNPDqSQ/1aeagzp+NTVmueZtqUrbBcL+wx2kxuLWpzxMJJhgTba14QszrBLP2qXcjFga91iz+CI/PWWW5lRcwq4YXnZtKURvX3Kv0StHMdP9NkHywMa05KP9TgpE2n+gizdqkwt9n+iphIC9h4zGqq/S6atgtpmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ohdZCSf4; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mFkKGGNMtWib0P4dxfwPwQ+2PHoaU3dMYTck4l1uWM+4Z0F4W73hCw4RGNCvttsx87Zx+uXlTBbQmG4NCeRx2QBQTks75y+o3Mw02VhCrAOJCgcwv45C7gaK66gMFe6h2h/WnFIEzGWY5m4eKAG8vuwia1mnzbjtzUqUlcrtuxY5ZF4uKaBPjhucpQMB3/sJ6hQhSdk27hQyJkm7mS/g5LHq6zmqnrmtRfaBaKk+cEqHvISzdWybRIR1E/gn2En3ONSyHPXtB0+EZ7AbY6Oc2/u2jljZysB9JUhlMWnrBun75T5EjY85OuhJRRLEd9iqCcUOG5QzaEzx/yYcnEBCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nC4MthSJA29TLf/D8IjZKgXVeT3T/yFICzUYZpScUxw=;
 b=DYcHuuEDcFUhtRKXXFZ5+yaopu116B0ilK2IXhcmUNePhbuZtB5kgcqkZ7q4PRvzDeuM4qaDqfCCePLay5wDEw3UI6s4ZlnzsOhC0CdlEV3TQX9bX4huFTJMLTBK8TIS76zPGzpJZyjOGplGzg8eh4+9jyF0vhU01/oZ8hEQlPREJjY2qHD/gxc9qr0dY//ZDX8YWpVtDH22UHAvr1OoDbYKga424zkCeaDnEwXkKuRzi6gaE7y5AI+/4Esanq2pzmHymuDKwIJfTp9iHeFkZOvBfNyh2JoxZVc2e1gTl53AB1rC5JjzylalR+BkVD8zIlf3/r0ftECRp+ESud3jjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nC4MthSJA29TLf/D8IjZKgXVeT3T/yFICzUYZpScUxw=;
 b=ohdZCSf4YAKZ8e4xfETuTMJQxxjbwFj9id/iTet3SJUKpZEzXmYGxAcR9gJSdnNADmKn0BT7RbJnzACwVFBT6XlHGNeNAbBQ4GjNqvzMgMSizOmDTDKSiVUKUaP8jDk3AoT6QsD8a32nyVqJz4wu6gie7ZZk6eCkowyCZgts7eI=
Received: from CH0PR04CA0096.namprd04.prod.outlook.com (2603:10b6:610:75::11)
 by MW4PR12MB7429.namprd12.prod.outlook.com (2603:10b6:303:21b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 05:25:55 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:75:cafe::9a) by CH0PR04CA0096.outlook.office365.com
 (2603:10b6:610:75::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:25:55 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:25:54 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:25:50 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 10/12] KVM: SVM: Add support for IBS Virtualization
Date: Mon, 1 Sep 2025 10:55:36 +0530
Message-ID: <20250901052536.209251-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|MW4PR12MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: 8713605e-58b3-47b3-b50c-08dde918066a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVBwOE9OR21rNTViajdMQmx5SldGUGNrSmdpNGdCck9WekZLQWpVQWNIVkcr?=
 =?utf-8?B?SmZtSXlRcFNtWDgvdlhIZi9MZCtHbnhMSGM5ZGttY2h6OERKejA3dzJnczNS?=
 =?utf-8?B?TndjMk9HWWtBcTc5NGczVzJkdmNaZGFoeUJCS1E1TEJIUmY1cUVadVlFNWJm?=
 =?utf-8?B?ZTIwSFN3VFhXcjFWS092RG83cDJLWHZxTmloYUxyNnVUWEFDeVYrOEZXd0hl?=
 =?utf-8?B?UHY5bnNBNXdRbXd1VjZrMGF3dEE3SVpZSGtCWkhrMkczYUtid3Z5ZDNidFVW?=
 =?utf-8?B?TVZiUW9qckI0NDlacXdjSVZ3NFJraXlqR3VkQWlLVEcwcHlzamxXK0VNUEkw?=
 =?utf-8?B?eEpTQTV1ZDJLeDJOZUdxU1AzWG0vTmV4VThYQjlmYkkzeDNTbXVoc2ZnZ0J4?=
 =?utf-8?B?TS9hOU1IalVjMWRzWDJyV2lnTjhVYVJxVjJ1bmdnSjFtckxQNmpSWkNMOUR2?=
 =?utf-8?B?Zmt0akdSVkpod0VyNzl4RmlDNTgydkEzTGppbzNVVGlnajk3T21UN29la2Zp?=
 =?utf-8?B?VnVmdlY0S0FQbVI2V3dZaHFGcWUraTBUK3JXUS9tZVBrbUZZYk1YWnB6VTBV?=
 =?utf-8?B?UEt2Z1ExcGtWaTJQK0hIWUx1RXI3V2xzZHFJSEtKcXA2SGpvR2pGOWFoQ3J1?=
 =?utf-8?B?WTQ5LzRwRjBzaDU3VTg5QUJiZTZwZ3BkdlpqT3Bsb3k3aGFCYXloVUJpS1Vu?=
 =?utf-8?B?dDVHZUcvR1RvVUd1aDhVTFVnSThKTGwzY3F0dzBIMEd4VkJOd2d3SldzeGpF?=
 =?utf-8?B?Wk9ZV2wvQ1NEaHhPSE5wYnBEcFU3cHZXS0ZmUGpPVW14czBJSE9RZlBibERN?=
 =?utf-8?B?VEt3bVpobUNOeG54R0dpUmZLV2tnMEYrcTI0T0FpY3V4eEJQYUdPSFRsb2JW?=
 =?utf-8?B?Sk04L0RjVFgzZUFwK2F6QkwzUTd4OC81a1B1b2pIUzczUmZHOW5zUFB6bU4x?=
 =?utf-8?B?QnJzdDArTCs0dVR4dkJCVFRmTnlMSWlpNGpHT3lGdVV0QXIxVy9PQnRONHo0?=
 =?utf-8?B?SklsMlBYQ0FGek5tbGphVG8rZGJyTHJ2QmRJR040ZS9PbXdFK2lWbm9LRG1k?=
 =?utf-8?B?ODJXU0NodzdlbWxJTFdPR2FDYTQzeWxERkhYWmJpcGprVlA4VmM2ZWx6Z2w2?=
 =?utf-8?B?ZUhrVjJoYmpBakNlTTZ5aUE2N200d0FTakxEbkdIaGhzYit0OHcyYTFiNVov?=
 =?utf-8?B?Z1Z1Rk5CaHlmSEtSVFVJaXFVZmdhRE1RM0ROdEhZcWxkcXNEY0k3OTBwbU5W?=
 =?utf-8?B?Mng1MHBQOFZDdjZZSnRWOUVPTWMzNUtnakt1SVRoK0w0S2tHbDB3d1RwcG5V?=
 =?utf-8?B?eFo4STdTZks5L0FUS29BMHBFdUVjcVh2Njg3cmlJZEVNajdqWFJKMmVPdnVO?=
 =?utf-8?B?SnhzTklPNzhkRW82QWJ3dGxtYXdqekNiK3VCWHRhRXJ0N2J1d0w1Tjg0RUVI?=
 =?utf-8?B?UDNYOHdoNzNlOHRzTW1TaGZ5c0NuS0tKVmNQS25HRy95Njh3VCtjQWptdzJj?=
 =?utf-8?B?REZESTIwSXpkMlFQU2hmb096RGVvang0TjZTWlR2UFBWQlIzc3dSWTFObG1P?=
 =?utf-8?B?WXVYdXh3NDdFMEFLeXNjRXh2OWlsUjZ6WTJrR1ZqdnN0S0VXSitNZnlDKzJJ?=
 =?utf-8?B?UU1mK2YzaFNsSm5YTHUyY3pCWnNPWnVFODFvblBYMGdmQ1M2RGxicFlZR1F3?=
 =?utf-8?B?RFlPZnVQSWtMR0thVWIvQmROVjNoMW5pM0I3bEtxclpqTDE3T1lQV0sxWklN?=
 =?utf-8?B?MVN3RjFiNzk0RWhkOXNBbEdZVUdtS1JtUWR4eWZLaFBGbkQvNzRvSksrU1dq?=
 =?utf-8?B?Wlc0NTdPbTdYOWFnc29CL1AzMFh1azdUVjdheDZpZ3hOdGllY0MzNzJRQVVu?=
 =?utf-8?B?aS91ZWtkYTVPZ1MzK0dkWVB0WXVFc2hpbHNrOFh4aXgvcnZlSUE4clNLcnJZ?=
 =?utf-8?B?YUdEN1REU1REZllVcGtUeVRTeUp3NHFBVkx3MktDS0x4MnZCMG9KRUdBRW5j?=
 =?utf-8?B?N3dTMktlVDBtcTVkNkphQndlNWViTi9BbVRDK2Vnd0dMT25iNVNKL0g3UG1L?=
 =?utf-8?B?dExNaEh3U1htWG5VR0hZaS9TR2ExRjJ0dVFXUT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:25:55.2055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8713605e-58b3-47b3-b50c-08dde918066a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7429

From: Santosh Shukla <santosh.shukla@amd.com>

IBS virtualization (VIBS) allows a guest to collect Instruction-Based
Sampling (IBS) data using hardware-assisted virtualization. With VIBS
enabled, the hardware automatically saves and restores guest IBS state
during VM-Entry and VM-Exit via the VMCB State Save Area.

IBS-generated interrupts are delivered directly to the guest without
causing a VMEXIT.

VIBS depends on mediated PMU mode and requires either AVIC or NMI
virtualization for interrupt delivery. However, since AVIC can be
dynamically inhibited, VIBS requires VNMI to be enabled to ensure
reliable interrupt delivery. If AVIC is inhibited and VNMI is
disabled, the guest can encounter a VMEXIT_INVALID when IBS
virtualization is enabled for the guest.

Because IBS state is classified as swap type C, the hypervisor must
save its own IBS state before VMRUN and restore it after VMEXIT. It
must also disable IBS before VMRUN and re-enable it afterward. This
will be handled using mediated PMU support in subsequent patches by
enabling mediated PMU capability for IBS PMUs.

More details about IBS virtualization can be found at [1].

[1]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h |  2 +
 arch/x86/kvm/svm/svm.c     | 94 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 269a8327ab2a..9416a20bf4d3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -222,6 +222,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
+#define VIRTUAL_IBS_ENABLE_MASK BIT_ULL(2)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0471d72a7382..0be24cf03675 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -155,6 +155,10 @@ module_param(vgif, int, 0444);
 int lbrv = true;
 module_param(lbrv, int, 0444);
 
+/* enable/disable IBS virtualization */
+static int vibs = true;
+module_param(vibs, int, 0444);
+
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
@@ -977,6 +981,20 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
 	}
 }
 
+static void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept)
+{
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSFETCHCTL, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSFETCHLINAD, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPCTL, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPRIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPDATA, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPDATA2, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPDATA3, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSDCLINAD, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSBRTARGET, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_ICIBSEXTDCTL, MSR_TYPE_RW, intercept);
+}
+
 static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1118,6 +1136,20 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
+
+		/*
+		 * If hardware supports VIBS then no need to intercept IBS MSRs
+		 * when VIBS is enabled in guest.
+		 *
+		 * Enable VIBS by setting bit 2 at offset 0xb8 in VMCB.
+		 */
+		if (vibs) {
+			if (guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_IBS) &&
+			    kvm_vcpu_has_mediated_pmu(vcpu)) {
+				svm_ibs_msr_interception(svm, false);
+				svm->vmcb->control.virt_ext |= VIRTUAL_IBS_ENABLE_MASK;
+			}
+		}
 	}
 
 	if (kvm_need_rdpmc_intercept(vcpu))
@@ -2894,6 +2926,27 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+
+	case MSR_AMD64_IBSCTL:
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBS))
+			msr_info->data = IBSCTL_LVT_OFFSET_VALID;
+		else
+			msr_info->data = 0;
+		break;
+
+
+	/*
+	 * When IBS virtualization is enabled, guest reads from
+	 * MSR_AMD64_IBSFETCHPHYSAD and MSR_AMD64_IBSDCPHYSAD must return 0.
+	 * This is done for security reasons, as guests should not be allowed to
+	 * access or infer any information about the system's physical
+	 * addresses.
+	 */
+	case MSR_AMD64_IBSDCPHYSAD:
+	case MSR_AMD64_IBSFETCHPHYSAD:
+		msr_info->data = 0;
+		break;
+
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -3138,6 +3191,16 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	/*
+	 * When IBS virtualization is enabled, guest writes to
+	 * MSR_AMD64_IBSFETCHPHYSAD and MSR_AMD64_IBSDCPHYSAD must be ignored.
+	 * This is done for security reasons, as guests should not be allowed to
+	 * access or infer any information about the system's physical
+	 * addresses.
+	 */
+	case MSR_AMD64_IBSDCPHYSAD:
+	case MSR_AMD64_IBSFETCHPHYSAD:
+		return 1;
 	default:
 		return kvm_set_msr_common(vcpu, msr);
 	}
@@ -5284,6 +5347,28 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
+static void svm_ibs_set_cpu_caps(void)
+{
+	kvm_cpu_cap_check_and_set(X86_FEATURE_IBS);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_EXTLVT);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_EXTAPIC);
+	if (kvm_cpu_cap_has(X86_FEATURE_IBS)) {
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_AVAIL);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_FETCHSAM);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPSAM);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_RDWROPCNT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPCNT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_BRNTRGT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPCNTEXT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_RIPINVALIDCHK);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPBRNFUSE);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_FETCHCTLEXTD);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_ZEN4_EXT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_LOADLATFIL);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_DTLBSTAT);
+	}
+}
+
 static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -5336,6 +5421,9 @@ static __init void svm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_THRESHOLD))
 		kvm_caps.has_bus_lock_exit = true;
 
+	if (vibs)
+		svm_ibs_set_cpu_caps();
+
 	/* CPUID 0x80000008 */
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
@@ -5509,6 +5597,12 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.set_vnmi_pending = NULL;
 	}
 
+	vibs = enable_mediated_pmu && vnmi && vibs
+		&& boot_cpu_has(X86_FEATURE_VIBS);
+
+	if (vibs)
+		pr_info("IBS virtualization supported\n");
+
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
-- 
2.43.0


