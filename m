Return-Path: <kvm+bounces-58466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88098B944B8
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BEEF170DAA
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DDB30EF83;
	Tue, 23 Sep 2025 05:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SeyuXrZW"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68D2E92B7;
	Tue, 23 Sep 2025 05:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604087; cv=fail; b=Wyd/pW3pwgIgyMtKiopx3hXzOqVte11G/6edjpH1xyvhi8BbOETzHFjDUYxtF8kYzPQKdYm/OZqAsZYhy08LU7Hodyyy339ZSMdxBAr67ZZeuKUVyjU76iAkRhSmc4Nt22+y4G/ydbeCYxm6L7DejaTOI4S+38YaYLuG+vnrS+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604087; c=relaxed/simple;
	bh=koS+2PQmltQvFYFNwOImae+hJCN5xJoRJPCbYBMjSz4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXn/3nQugoCGUtMZd8mrVmX9wMc3Zbd8xhr41cWpZpzQKBjIoRaDOP1UpxJrAunU2iFLPy3TQ8KC12X1gERDHi5PoF4H/HUb+69oUwMaVoD4jTcDBUeuidEjzMgOI7NPMpZWTh7po5ZDNUD32oME4jhU6nmiTV9ULHXNY5ICE7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SeyuXrZW; arc=fail smtp.client-ip=40.107.209.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekblckbI0Tw0NPJV5CpmDUXsDYtRY+u9jHdDx9tFex0+1kOV+go9unXAp3Q8fbP7UZe5tayK0ySo289zSPFBuoCuUt/DNmA8FFP4q1UZbyR0tXnIC9U/gEG6Bl2VaFilcb2KcyS+UTe0LTrTj5pNC8wT6qAe+eeFdq25GlmbVtGTZG3navHX0eGp1jIGa4a7mUDzUKgdJXYqhCrYzkgSUwGAfANZkx3nTpCHQ00DbZzFGX1PXz6l5XaPYgmdouK/YQYRucrtvdGEYsIKUv082JNwitjDN9UdX58DaXRuEriAApNlnwYuuRteVev/P//guNqZWuwJbjHSHLLUhstBqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSoIOqoQpeeKO2vdQAfWRtvkVgl/VFF6RhFzFI4Zbfc=;
 b=SV6RxlMTBOcfNE97FCBi3opNL7XGWrdF33tpxu722wc4+MLoEMGj1EY3PNGBtbQw4lYwDoy0L6fag9NK/QMbQVYZjpM03OUFazQLuFjl7/qrMAGArZSmZOVuwPwVEc/tjms5VkQ/A5gHpd6vIHco1NOll0U70VC95ZKgv0RF6sGqyws2qA0t+hVDm+mg+0+hYBmYbT/iKwPY59E+MeGiwDzuIFa7Ue+xvyMuXw7bPbegmyzg5JhJfiih7hf+v7NyHnEbLaFSIG/8X/bbUqoFxPruZUoMmX7PAT2KMF1Auh5H8XR5JV8SToCvPAgCEwhu0PCzb4FfzYhmd/tnLzmZpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSoIOqoQpeeKO2vdQAfWRtvkVgl/VFF6RhFzFI4Zbfc=;
 b=SeyuXrZWUtYWeQs9mCYmr9KOvw3mprwyd+GDaumsDZSTO7POelyotoMfM2+BYJbmc4mjOUKztGyMG8yhOeexlyTsbSQCcT7GsHH/M2myJzvgG8DhVBYmErbsdi0UTjnH4HkU8p8dg9yVav5zm246BjX1VcI9U6m/Yetz7DGxu2I=
Received: from CH0PR07CA0025.namprd07.prod.outlook.com (2603:10b6:610:32::30)
 by PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:08:01 +0000
Received: from CH2PEPF00000145.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::a0) by CH0PR07CA0025.outlook.office365.com
 (2603:10b6:610:32::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:08:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000145.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:08:01 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:07:57 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 16/17] KVM: x86/cpuid: Disable paravirt APIC features for protected APIC
Date: Tue, 23 Sep 2025 10:33:16 +0530
Message-ID: <20250923050317.205482-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000145:EE_|PH7PR12MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: 59e65c60-4288-413a-6279-08ddfa5f2b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iPaTth4GwScQwSnRz5rWW0VIHyd1OoxJiTmxdEytsccWjbbGhJLpAhFTLvHM?=
 =?us-ascii?Q?aoR7dBZoPn4b6trNYV43XB5mtSbxxAlnRncAAN8RirudkeMfkN5Qud22qHAy?=
 =?us-ascii?Q?5MAhxRG1ZgCLVds6oBdCXlAVM8IfXXuWzLjUUfu18Y/YvuAWniXquXiWAEiM?=
 =?us-ascii?Q?iBNlQV2zCovdQ5AdvEclO96Xh9QZgLGPlKVKy2I98gW4dN3nWFdEgtRgfDPQ?=
 =?us-ascii?Q?VNLHauwMvih4fjkfkDSsrNOYRQmSrc/Mz+7UXkZoTJ0kgcSaA97xfMPShS8u?=
 =?us-ascii?Q?egM/qBbuUqnkT6mHSErbI0TSKZnxGy/B/jAx3yTAj9SSBQ5kbyLZpsmEcr40?=
 =?us-ascii?Q?lVjcpk+1p3AGiONQ3P6Bmq6J0zeH5D5yKMNCuro0IphvxfaFV+YNutf6eXs1?=
 =?us-ascii?Q?QCtbtHxAF70ANkmvJJurSOfEyLKv2GQ1Iw9C/d/IlaGZ3SftaNiO5R3YWu26?=
 =?us-ascii?Q?PfiIArgKWQzCLOKpxdk5utcO8sj695ZRQyTjFjzrOzvIKM9jh0xkf5dKzFf6?=
 =?us-ascii?Q?aDnAF+loOiBfQ+adj/UaIxjEQdCczb5Kjv4CgVgM+iapDirraD8gZ+2RPeB0?=
 =?us-ascii?Q?XB8HN6U+w4PO8BcWXnLiWY0r7pef5CZnn7zn14qLXLy/2bxFTFWthDt5YWL+?=
 =?us-ascii?Q?A5Q66NWPOGt6OdHt7gZ7d5jLJNxN539zJwiuQE28HZ/y8vcTIX4kOTi0/RKS?=
 =?us-ascii?Q?IH3QQ1n61WZ1g3fik+UZ/FDoEZCQRfs5DM+ERVO2gLNLjVjSREdtueEv8z8s?=
 =?us-ascii?Q?p1LZsQ+3utvFfs5eLpLCsdccNxrNRpENV9lyUO292YFRus/6ppFDBo4YCncO?=
 =?us-ascii?Q?kZ4HEQ6JOVVZPT6QpwDA2RJ7jBUluHmj33YRgsRC0tNmpxqb2kx1RHD189CR?=
 =?us-ascii?Q?m9vooPOaYuWHjPR+jqQrmGv8rBG4HxZMf9FENVClbbnt5OqHeGhr8nuvdQH+?=
 =?us-ascii?Q?lvPNMZIr/urgkhRztwp6SoqsNTM9IszpNB7fDzrqKP0H+JeLfi+TwC8/ny3s?=
 =?us-ascii?Q?nvfojqjlAArHjbveSmQKR3r7G24hOI8TLVoJE9LvJXYiGg8naRFj3OnxAQQk?=
 =?us-ascii?Q?Ja+vR3KhOaTiqYmz915zUtIXubMCkvosefc8Rgdn+Z0MDUtnCl+RNqDFlxHm?=
 =?us-ascii?Q?oS7cPlMN8jTu3/Hc9Mh8NwB9RDlW1Dt3QP9Yo9r+ivJLpG0qV3BDnhfVCwtz?=
 =?us-ascii?Q?v34WA+TuePQU26x8KaFkMnyOSx78nwtcUvYPEP6RSlqVU8PsnV0b3hyVoIP1?=
 =?us-ascii?Q?jkdKqArS06zKC6sK491dj4VEAhTgApXCN2i1BTDDgfz8GIHCDykoozaYrYUf?=
 =?us-ascii?Q?BQrlof4TX0/hA3/eMcyuYMQtrSrPYAvDQw0X54f8nRJXFbx/wB/vr4L6jYzm?=
 =?us-ascii?Q?K2heJWQo8Lk7FxYWrqvfIUE2UsFCxvo9C6VFcjNqcPkkIOmPITL6MgsAsABH?=
 =?us-ascii?Q?XgkzzsqEbIS/3+7HP+mETJynZLgqcb6RiFhfWBqxMH3zoes7+/wD4/PVIVSN?=
 =?us-ascii?Q?qJWqD2l1QU1KePtF4Jc+22997zPLCUyNONEO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:08:01.5981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e65c60-4288-413a-6279-08ddfa5f2b95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000145.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020

The paravirtualized APIC features, PV_EOI and PV_SEND_IPI, are
predicated on KVM having full visibility and control over the guest's
vAPIC state. This assumption is invalid for guests with a protected APIC
(e.g., AMD SEV-SNP with Secure AVIC, Intel TDX), where the APIC state is
opaque to the hypervisor and managed by the hardware.

- PV_EOI: KVM cannot service a PV_EOI MSR write because it has no
  access to the guest's true In-Service Register (ISR). For these
  guests, EOIs are either accelerated by hardware or virtualized via
  a different, technology-specific VM-Exit, not the PV MSR.

- PV_SEND_IPI: Protected guest models have their own specific IPI
  virtualization flows (e.g., VMGEXIT on ICR write for Secure AVIC).
  Exposing the generic PV_SEND_IPI hypercall would provide a
  conflicting, incorrect path that bypasses the required secure flow.

To prevent the guest from using these incompatible interfaces, clear
the KVM_FEATURE_PV_EOI and KVM_FEATURE_PV_SEND_IPI PV feature CPUID
bits when for guests with protected APIC.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..01b3c4e88282 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -245,6 +245,10 @@ static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
 	if (kvm_hlt_in_guest(vcpu->kvm))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
+	if (vcpu->arch.apic->guest_apic_protected)
+		best->eax &= ~((1 << KVM_FEATURE_PV_EOI) |
+			       (1 << KVM_FEATURE_PV_SEND_IPI));
+
 	return best->eax;
 }
 
-- 
2.34.1


