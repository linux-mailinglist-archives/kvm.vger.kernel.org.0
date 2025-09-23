Return-Path: <kvm+bounces-58464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEFBEB944AC
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A8B93AD26E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D9330E834;
	Tue, 23 Sep 2025 05:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z/zD6DAl"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E730DEA0;
	Tue, 23 Sep 2025 05:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604054; cv=fail; b=rDkvb9mZtt621+VdUbMys5/+CEfFxu05ikd7EittCV3RP4yyJHRzuneSCl4KsIl2Foehzr8mQiQpgtSutVc43IN9VDUwUxCvKMCrhPUn01lR4B5srSAGwvz2gXaFwuWHWPnsVOyXKQgGodf7GnmSRHa0ULb/xHAKKKCjHuzhqyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604054; c=relaxed/simple;
	bh=L8Dsym2d5MqA+M6GYvdfAmwhJj2bY7kJUmTnWz4NDR0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qhqGsSHucU/YYIHxQGD8QrUkeFMPGKusHrviRmsRenZ6ppYKjz4D1HHKL2ub7lEMKTR+5hQJLdAIk47UDUkafrKDt0zh/tawhZ+afDCyf/K+8sKyuHxtkAZCKoJStI11PyBfP8dwDC1sZUfqQJ/58jk0pfWSCsV21BDgX6HIbUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z/zD6DAl; arc=fail smtp.client-ip=40.93.198.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vjf6BlufTH+aN/hkl8KsXyNNJ7/gfATi8G/t7L0ijdkYOv2wSEsIFeTstSjvnuvBjmVZbjAFJD27OBHq96WInBZ/HNZChp8q1VvFs+mBdkvh7jxW3wxdZxaM+111B8CLCJP+g6/mr27eldkQE+wTn4p9HC3/85AvbMTI3GPCQ0+UzWkD6NIKFl73PzssZLykdcQ8jLiuOrT6EBQZ2wIyXd+FsfxU4u5JZq0t0nRsEDeNcN2cuU4APQYXNv8ImYUvwE2EN15yjplHnnWiHefBcOEbiLVLvk45wcZTUOVlvAq/3RDZgQoOdWV3rhl0yqyf8DoGoDobBOc16qYoelC0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH427d0zB5Ivt4t8pB2VVSJ8AfCk1mUzKUyjjJr3bLs=;
 b=SE1PNGf42xoSHIrGIfQZFkkl8ePctfPNUrc4JeXsTJ5e1Q5npr88UkJphaS5kbCsmeQRLjvl6UbbuzqYIE+SbN8bH9fW3Cugzf2Wo0Pwo265fKder+AOKA41wc5e3zjm+Gh1pvHBM+VNcORJUrER6l6uZhRiDDa3av7l6UDIFFde6ctQeAYx3zPeFkYX/yMO3CrVuvxMPTycYJv7JrTZxl1JWP0CG2FTz7A3YMu0pswV7jHX9/cexzrjLSwLQ/t0E3TRqNhyRM/zS1IjD0v8ck1NHpaTLIlFb1Sjx3Z2jkiltMAcB7pIKqVeBgg1zCUd9g2m/MZBZqT08E/NQ4SmWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH427d0zB5Ivt4t8pB2VVSJ8AfCk1mUzKUyjjJr3bLs=;
 b=z/zD6DAl3Oo8TfxOylg1TXi2iR//DlhGTnmRGb4GSD7qGO29KzJkEXFIOfr4Mks7Gqi0cYlgA32yc0izeWbljEwTgu23zvWqb1b3D1350r1xIMRyszmO9Z2G2YFZpa+GuOtljv20y14oqDCYcJE4KpSvV4r+vD8VwGTvfd9RxbA=
Received: from SJ0PR03CA0029.namprd03.prod.outlook.com (2603:10b6:a03:33a::34)
 by CH2PR12MB4104.namprd12.prod.outlook.com (2603:10b6:610:a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:07:28 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::51) by SJ0PR03CA0029.outlook.office365.com
 (2603:10b6:a03:33a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:07:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:07:27 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:07:23 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 14/17] KVM: x86/ioapic: Disable RTC EOI tracking for protected APIC guests
Date: Tue, 23 Sep 2025 10:33:14 +0530
Message-ID: <20250923050317.205482-15-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|CH2PR12MB4104:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ead4741-3bfe-4c34-3c47-08ddfa5f1798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4PJc2fRW76TekVYr/FB0vred8+9hE/3mzIt68BD8Q+Q0GoxpL/w9IBdWdKVD?=
 =?us-ascii?Q?KlRBB+bzdS9g8VW2He+ebpgvDq0+amXzuK7723zOH1yp+2Cc8dBvtzD3kSvD?=
 =?us-ascii?Q?fK4mqeAICLoMUm/SUdz0PkqnuNi5emBWzjZ5dU9O5OezO7w+uxe239VlKkeR?=
 =?us-ascii?Q?sNDBDOnNYn6M3HX3Eqh1CPV6Etm8LpAIeHwp9FJOshVJ+6FgUoezRrtcwEAo?=
 =?us-ascii?Q?I7qrLsuq1nMOkFLF6jmVyjoutppx5TtesSKfpJfDFNulj6TSs/VI+/e+9kHz?=
 =?us-ascii?Q?6UBiBTlCj+bB9/cew2M+BrHoDDxFxUTMkgMjy+TVxAdPFDAWH0Kv3qh5rse2?=
 =?us-ascii?Q?T8DPqriqM+NQOI+JiGY8OxV9EUtFRJC58oOqgTfcxeoWoaxqId0RoCKM6qlY?=
 =?us-ascii?Q?gDFAksrB2hkE7uZljD6oqVQqOFv7HyEmOXBRJ/7HECagBvJnMuaghT9v8MbC?=
 =?us-ascii?Q?Th7YP+NbH85Ck64roz84UvEoIfeKP/rb62KiPaNWtSjClvmKPymiZLfNyMX2?=
 =?us-ascii?Q?+fmWuffp6sQwTTmHpq948n6rqLGy7zJKO5U4W9vCwvlM0XTCBIm3QtU3ncyt?=
 =?us-ascii?Q?FpCMga8TSBDuMkzh7rD/mZ3V1vYfnTLN2Kqe5PNiA5u+MJfeN2+q4YFS+45d?=
 =?us-ascii?Q?Xg5WwOkdNRTXvDGdLkIfP2eiqHVfEP5d9Vy8xv8G5iPpAjIx8m884SqqLYuF?=
 =?us-ascii?Q?ozugUXTs6iM9/Aq2OPAMBPmUzznhNawnu3yOylhtjCORVlx+diGXCcaU4GM8?=
 =?us-ascii?Q?u/rf2cKFGD+jE8xFkZlsvb0RYPyizU+G1gU3DIWuik9fOchPD+KcJxJ4Eo9e?=
 =?us-ascii?Q?6TOoMCb7v580uG638bTB4LLiHe9vhiARwYq08Wc0KjU+ekoRGtyiv4kSOYq3?=
 =?us-ascii?Q?7YyzZYKko3rQ8W9UmNmD8B/KiudAVwqM5obMmeRQZkbfieERQtTQ/u7TE5Ph?=
 =?us-ascii?Q?3Abl4ezvYc+o62KOTKBJTTwSiAq39R0s1A5WYLQNORth4Ia2FwP5kXkwH+Us?=
 =?us-ascii?Q?D63iynJaYBrNdAl5vI7ayqzR9pEAsNfWhP6LbM2p+aS9Iq9gxn7UVucyAyrN?=
 =?us-ascii?Q?cDAYm7wT5WB7NCSMmEq+Hw4ktCHzAYk+f6tYCicHdYNOiagFk9A7udiU6TN6?=
 =?us-ascii?Q?6wS8xHSHp4Ru76FiSJDxXdbXZRS77h2a/SUwyW0ZKiMEQZR68VfOm1hiaWH9?=
 =?us-ascii?Q?CxUYOkt6z2tiF2NdNDZYUNY9oTIyU8HuzZLyHJ9hubvaAdhzxeCt8KkagD3s?=
 =?us-ascii?Q?S1AwPQWXxf1mhWwoqWKpd3EoKjMOMyq5+luBwdRCYrH0nI4EgEIQ03nfc+ap?=
 =?us-ascii?Q?QB0oeS0y+vmiNCgkEQpctt5JOAwVBO2l/OQD7+MCCw0JxKagzrc5JKwV2mUG?=
 =?us-ascii?Q?4gSN1UfiVEiuV3YZ8LJWSA/U6nafCL7l02/DZNqcqO0P2txIgGvRUr6CQHY4?=
 =?us-ascii?Q?VZLfQD2aShmh7Z3XkTaZAWye9JVeUmsA7x/DqU4VSjcuDT1JHJd+zzLWERYf?=
 =?us-ascii?Q?dO5Nk+U42SoQc3VhNlXs1O+EQVnSk0Nw4ac5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:07:27.9548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ead4741-3bfe-4c34-3c47-08ddfa5f1798
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4104

KVM tracks End-of-Interrupts (EOIs) for the legacy RTC interrupt (GSI 8)
to detect and report coalesced interrupts to userspace. This mechanism
fundamentally relies on KVM having visibility into the guest's interrupt
acknowledgment state.

This assumption is invalid for guests with a protected APIC (e.g., Secure
AVIC) for two main reasons:

a. The guest's true In-Service Register (ISR) is not visible to KVM,
   making it impossible to know if the previous interrupt is still active.
   So, lazy pending EOI checks cannot be done.

b. The RTC interrupt is edge-triggered, and its EOI is accelerated by the
   hardware without a VM-Exit. KVM never sees the EOI event.

Since KVM can observe neither the interrupt's service status nor its EOI,
the tracking logic is invalid. So, disable this feature for all protected
APIC guests. This change means that userspace will no longer be able to
detect coalesced RTC interrupts for these specific guest types.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/ioapic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 2b5d389bca5f..308778ba4f58 100644
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
@@ -476,6 +479,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 {
 	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
 	struct kvm_lapic_irq irqe;
+	struct kvm_vcpu *vcpu;
 	int ret;
 
 	if (entry->fields.mask ||
@@ -505,7 +509,9 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
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


