Return-Path: <kvm+bounces-39683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF9FA494CC
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEF271706BB
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2641C2561D6;
	Fri, 28 Feb 2025 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rFT/Xnak"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88001F30A2;
	Fri, 28 Feb 2025 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734660; cv=fail; b=mCYdE3da4PT75EYcP7UQuJIHKc7G79/ydvihhqAsVWIurx97bI1kiCPJ9I5YJAe2Smiv6Nwx2BLO5L4Hb4dI0YxFQcNg8DEOX6W++/DFbgiH4hrtBeJ7fP8CpXb3rXy1DErEZF02sNrDreswuvSw0f/6FPZndC/zByjczj2skXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734660; c=relaxed/simple;
	bh=9/yMUVH5TQ/upWkNMs/2IAvZC0DDU/TRk6LT3FBipB0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9o/CYaQT6UitN72JBrgUuexMcXieC1I/iyEQ2RtJbBrO58Tfhdjk8I8s+PkPmLQKW2Sa2g1mN9F/9XUTtkxWMSkUO+MzoFiTd2ozbLuG4JSDnQ26jqwT+SPzaLgRnYT1pQpl0VpH3LSvMHTeCJO1Pbwn1rHLbs2fxTeK5oX7Ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rFT/Xnak; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/LrqkAXrfWu4rZnbcaovlUPoa+6IyeP/CWZd1KC78dwUBTQjgwipZSuS01FcWeGiKEn6brBSQXOzH8Fy+vdIFDWtDmzS7z7/kb+XM4zio2Eiw0tJ2Zv2nJSg3n1dK2cQ6fVsjIPAfke8n/acdUSnq41bc3YwZOBDHByPr08qB0q7DPiYFsF0m8P4u26lrt2BNzDThWq9WmHWT1EnLwvCii9reRaKTn7AiLLYHVMRDmeVhQ0O8FXm/pRHyXhyZR/rdaRN4InU3VITe5JMmfnwDwaFVK36taXqe8R7xpdHAhYnZ/NoIyEgRQfhi4T8M3mM7fFM734m8gJMmgFFpPsdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2oJzoquwamRfn+A74VI3gTwiJOszNVo0COy4uKlBvg=;
 b=Bu9O0zlWujNVLfBzpBHknbzaPQ9LAeGrW12ZNvtTAZHcZVON87z0sQYD3Nu5Q3gfle6YUdSSUnaBGjCyPUZchI0Dc9dZ2olGNhoYX5mawo9MyJJkqdaIPuEN+5bgOUkMzwB1OosO3O4kGxk4lfOPqev4atoe8CJAhi8WuAzrWReiEvUwK8x2tb6b+cCyuWMogRn6U9NSr4+JV8j3mrWfQNi7IRvDfXQv15gP0EzpF2SNsfdRBhQi+H1Llg5mQfkOSvgnaY3E/NWjoNnlX20qIS6pMJekHCR5gtWcPIc+ljxjEhPuc0upqkKC4FcABlVhvoC/DRK0xj6iSHTh+akhXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2oJzoquwamRfn+A74VI3gTwiJOszNVo0COy4uKlBvg=;
 b=rFT/XnakVBpzhPPUC3oKg11p19VMBN3b5t5CeZhlIXNEuVm+cumyV+kKNVHcfU17w8qy2J4ks3Pc5XDloorO+lawFVjtS2OeSeuYiacWrXQs6fhc+NQ13s3YaveQpjMoIsiuAfS+OTKckr/ag17k0Sm6xMEipeFE4xe0F6T6EcA=
Received: from SJ0PR05CA0029.namprd05.prod.outlook.com (2603:10b6:a03:33b::34)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 09:24:14 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::eb) by SJ0PR05CA0029.outlook.office365.com
 (2603:10b6:a03:33b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.20 via Frontend Transport; Fri,
 28 Feb 2025 09:24:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:24:14 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:21:44 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 17/19] KVM: x86/ioapic: Disable RTC_GSI EOI tracking for protected APIC
Date: Fri, 28 Feb 2025 14:21:13 +0530
Message-ID: <20250228085115.105648-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 8132b3c9-f8e2-42d7-9fcb-08dd57d9aad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l7Z/938vIZVqHtMCaF1OCVPegaIz8XYNZmU3bHEHlK2AaabV03oJM5MEtzwO?=
 =?us-ascii?Q?CjwwAS3zZjxcqXTLTabKQidqJ3rpK3tJTB8qRYGrUv4wovQloiaZN5j+febY?=
 =?us-ascii?Q?YlRIFOHEMYA4LS7brneXMQaumW0J01GqMLAusoban2b2GhZ8ROnIfl03qNzL?=
 =?us-ascii?Q?MpMw2TAiHwrCrjxY2kSFA6fR1HfbOu2amWdOKe2y1rZDdv0ifad7EbHMhW4o?=
 =?us-ascii?Q?jya9tEBNigz0aNW4m58RbvJ06jsFJj+JDDjA9fgpLuX+QzJdFjoP1Xyhie53?=
 =?us-ascii?Q?uiAAdvkhKKEaOPBPPzwAY0mBku/3RQby4Ak17TgBgwibyG7Tt5dkous1FB8g?=
 =?us-ascii?Q?XdHs/wCysYNbzILNo/FKq0/eWRUlOfzjDdBages1qehDFKqVXagYeTum4QS9?=
 =?us-ascii?Q?YJQnfB8sN1vEbuvJTck/Jb3mncKk8SYXXOnfHnzzITOyqJy7l6FUXAK6hWJ8?=
 =?us-ascii?Q?qncnHU8o8LhvbhnLSpzXFjInX5yp7pEr5Fbboj71fIf0nqytIOyl70wxedEX?=
 =?us-ascii?Q?E6tBze3Ny95AIlJtVm4/RrnGkLpcP0rowUiv1JiwHTXdUGZxTw0BZUyGGC1l?=
 =?us-ascii?Q?rn6AavJHPgkHknSJlTzAm24nLShqm8pAfWJrk5ywLsEaw8cf+8orWdhPkUSS?=
 =?us-ascii?Q?8w+AUJl0vLMUWWwdKQcFIFZxIcQJ/ANXNkr0MPABI14toXanhOCqUFj9NQ/J?=
 =?us-ascii?Q?XcFnL2GIrowB3X6h+luPbDQWlNZliSPUSRZKF6bQHyYWvyKteV+/QiSbC+CA?=
 =?us-ascii?Q?WWFrJPDfQIU2gQTrdDR6TGdwNO/tDVRzNEtQCJlf7AgZom5g9vY58kg7zNCl?=
 =?us-ascii?Q?GKGGXBevL4SI7kenBWgi3k71SSBTqXlfFigNldNVzCEYapCGnks9+zQtN+c/?=
 =?us-ascii?Q?xXa1WemJK99dwVifU2zyfCYEdiLDSl95Y6gHClGBtVSQ6HA41DN753rj1TRu?=
 =?us-ascii?Q?kdX+Cpz6nlgBZORcioQpMANnWoHzpYP0T0nzj5rLps4xF0Bra31sBjy2i/5q?=
 =?us-ascii?Q?g7yxB5Q9r2/hgzAOENsnnXveO1jiLHLDIC1lI4p/cx/WIifbkjEX8KQ01LsH?=
 =?us-ascii?Q?Vf0XNFR5lzk4CCaL9r46w07gL4WEa3O5d/Q1GLrD7qdjuHbmNT6vHKtQ71FA?=
 =?us-ascii?Q?8TjTDuSy2oL0xtKGiJw5XG0F9rYiKyIK6gFs9EIjatJcC4g7fZkYpzL3h0WF?=
 =?us-ascii?Q?RsFnGRiaE7YekraJMymUvFz1CJNS+uGkPMETCpF4QWc9wUUTPLhxs0wbolDe?=
 =?us-ascii?Q?hS4oXTC5JQlWPBp1hApY8cfoRXMKHGK3345Uw1JJNdZvLOJQV/yVr2e0Z/BS?=
 =?us-ascii?Q?x8UI23jiHeD3INmKa9ud1Qz9lTU9AohyJjUv06yWg0BKLJSVytnJ28wzo5Zz?=
 =?us-ascii?Q?QkMy1CiYa9RkFYEPixY7pXWEmuQwdZUouooaNFdjdGoShHAhSaztZL7G11M8?=
 =?us-ascii?Q?XJscbx8uYRUWL1iaZ9ou5jNwFkVim6Lvn1PfNXEtrCnafTo53pCYiHeA2zJe?=
 =?us-ascii?Q?DCyFWRW8PtrsUl4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:24:14.0365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8132b3c9-f8e2-42d7-9fcb-08dd57d9aad2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042

Disable RTC_GSI pending EOI tracking for guests with protected APIC
state such as Secure AVIC. RTC_GSI is a edge-triggered vector and
Secure AVIC accelerates EOI write for edge-triggered interrupts.
In addition, APIC_ISR state is not visible within KVM and is part
of guest-owned backing page. So, lazy pending EOI checks also cannot
be done. So, disable tracking of pending EOI. This means coalesced
RTC interrupts cannot be detected by userspace for Secure AVIC guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/ioapic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..7d68e8ef6245 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -113,6 +113,9 @@ static void __rtc_irq_eoi_tracking_restore_one(struct kvm_vcpu *vcpu)
 	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
 	union kvm_ioapic_redirect_entry *e;
 
+	if (vcpu->arch.apic->guest_apic_protected)
+		return;
+
 	e = &ioapic->redirtbl[RTC_GSI];
 	if (!kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
 				 e->fields.dest_id,
@@ -443,6 +446,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 {
 	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
 	struct kvm_lapic_irq irqe;
+	struct kvm_vcpu *vcpu;
 	int ret;
 
 	if (entry->fields.mask ||
@@ -472,7 +476,9 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
 					       &ioapic->rtc_status.dest_map);
-		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
+		vcpu = kvm_get_vcpu(ioapic->kvm, 0);
+		if (!vcpu->arch.apic->guest_apic_protected)
+			ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
 
-- 
2.34.1


