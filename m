Return-Path: <kvm+bounces-70146-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IG4dHSf5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70146-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E4240E2C87
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FF6F304A65B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359F538E12F;
	Wed,  4 Feb 2026 07:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i+1Kx6N6"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4538E5FF
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191124; cv=fail; b=kyAEXFYBGWDxvj/vAjmS6gay9GqF0H3q49g+n6Ifv/LzvrbmVHgeJsJsdjjBntbB5T3gxHbYYSQK9LWw6EPeVzfLpSvgigKMF6NZi7otyr7BE2KYG54aRUu1xC5HW+KdMdsKlr+P2jLn/A+yuXj5OReYuj2BWRATdj9KRj9Pot0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191124; c=relaxed/simple;
	bh=8xWxopj+9Ep/6ONNUjvoZY6qxZVCTu10+eLSapDiA2o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GyhDkfPyCGP2D0s/T9B59B1C/yIW+cN1yjiu0pxZWFQkaez6gjI3pc1/OmuocVquIrXLs4TEvbyD9pCs+39BIH7a3f57XSLTSCLa3Mn5LlaBMltVrdXx1fsgfnzR4i9Ei/vfXknn+lIrxUw1WRJ6e0+RXP34xeybFZg1pI+roSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i+1Kx6N6; arc=fail smtp.client-ip=52.101.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxpO1U25iFPqqZNytc6NWEhoZhArwewtxP+QSNvgVOkRPvx1ekPJgXC/OCx7Y5pKB01mXpxJf5ekoQeJnHTkYNBhSEdNp47QIKkEx2vltNN4jaMf4tkFYKVEFmavjsQPINPoilm2cTQmPDDDQMl2tePYURCtOYmWoooBib+e+In7MsuSte5mqcqvuNzyjkEzJs7V2CB71O58xk7nqSnNKb8VTv4mLVjvdehbIjnBqsZYOBNZTwjdM/M2zEWLjkghJL0V5lCoWpEIqytfl6Xjvh9QnuJzGQ01fYYK+ORPgqvNR4IxjRfyu/EE268yfy4DtV4eIhQyUiKrKX7ux8uLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcDFGfJvKwSKbwTlPOrQLhSzxWhiF/Dr48Vhj19wBVE=;
 b=FQZEFhJNKvkyb4sv6joFr1mEOjn2NRbuTmDmlLAIBlqnGQ7fZlRmOyQixGjxpbKPzepNVtxF088ma+m0bdFDPXZ8vhPGcderGTu55HOmwpR3WR2a9xUXsoF705SCiwqy05pRLgGpA3H1aGHnToKHIIAQcLbIOKqcProKtpLoz66yA5BJe69QXPt0xlm8CRrzsrRXqT4S3tj/YttAVLL+NaSohxHtRDtGI850lwrpKzO2oP1BuQoij3lED5YwZuT6vsreHBzeU9vWnfN/D/SmnX51CZMYqlAeJnreVnWZzVlPi8Yt0ASLAKS8yldzBu9WB5PN5xFcR+JBkSb21zaG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcDFGfJvKwSKbwTlPOrQLhSzxWhiF/Dr48Vhj19wBVE=;
 b=i+1Kx6N6Vvgf4iOWqyDElQ+i8YDXsFtiuT6Rvl3buScatR2XRTgP6n0YxTbyxpbp0r/ymStdFOyqVPU+FXme4iVVVky4QdpSacMng6S+74ieZvnCGTwLalGY+O3fju0TgZheOKukmiiFiju3rfyqNd/nUAZTuutbcWwXbe6E4RY=
Received: from SA1P222CA0148.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::14)
 by CH3PR12MB9078.namprd12.prod.outlook.com (2603:10b6:610:196::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:18 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:3c2:cafe::ec) by SA1P222CA0148.outlook.office365.com
 (2603:10b6:806:3c2::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Wed,
 4 Feb 2026 07:45:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:17 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:11 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 1/9] KVM: x86: Refactor APIC register mask handling to support extended APIC registers
Date: Wed, 4 Feb 2026 07:44:44 +0000
Message-ID: <20260204074452.55453-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204074452.55453-1-manali.shukla@amd.com>
References: <20260204074452.55453-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|CH3PR12MB9078:EE_
X-MS-Office365-Filtering-Correlation-Id: 94c6b5a7-e4f3-4993-b86d-08de63c15763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LHFikQEvfGVyEdPQEDG7u54bWkVvqRC8oyiaTeN3uNbbuwg7UoyBZH52srap?=
 =?us-ascii?Q?L1AMRCrb+j6xqlKfCwCnyc8V3elE7LQiJ9AkUhaq6CA7xUcjBSZu9Z8gmf8K?=
 =?us-ascii?Q?TyXfwWUD6c4gcblQtSkAsojNBhRz4w8XG5wCBxrEvhJYraT0o6otz+Whhg7B?=
 =?us-ascii?Q?a0iPOa3WwFHQRK5Cm5IRrynV8IyhBW8dlo/ZGngUaGQ+6s6fIcEyoTCWpuqk?=
 =?us-ascii?Q?vRUnsadtfCmnDon1sp/SWxVLajq8QFdx0JDfafDWfTwOkEnDC6tMiAPJ/eU6?=
 =?us-ascii?Q?DLbcIOz4rHkcsyYh8RyVvYVRtoDOi1QnF7kpak5izz1JuYMqAquXggTR1Ur8?=
 =?us-ascii?Q?0eIUx6U/cyeEJ38ZhM+VNM07qtgEwPHo/ngUJIG9UFqp3mjVF9wEaITdYikJ?=
 =?us-ascii?Q?SxZoen+gEgwV6Xy2dzKQduZJGeZROykwASq+YSDoHogbVxPgwCy1SnXrD/8s?=
 =?us-ascii?Q?32YeRiEk94jgwRdQwPrMU6aKjSZpd+WmMIw5oMDtbfBfvCo9CFLJaS3pAH2U?=
 =?us-ascii?Q?zsWUTIacXCwqwtYtQERYE6bPJL5AuVyhmsj0gyRUvm0WH8DeQPX+yVIOuECz?=
 =?us-ascii?Q?sfhTpqPDrPjvqaBoxzuuW95HNqv29szsl10Hrl2R6E3o9PYglYnZNdBP8F/k?=
 =?us-ascii?Q?Z7ZjWJ6mO9dHTtEjh5SVWcrzyGCZI2EFy+kgxyTzwbjFoS+5onPvGCM74Odo?=
 =?us-ascii?Q?U1OGrh+fye7ywBcV4UYrL9becmz+jlzQab1y4l2RVBwQi8ZHpe5IDDWtg4Qy?=
 =?us-ascii?Q?bUHQXYh9Uy2A9+wb0rARCLWUfhX0MsUkMPpViTGOa7dR7i9vVrwjQ/GJsIRy?=
 =?us-ascii?Q?P829EUwoUTwjkcDE1OMdkMWMu8EyRrftItUywso1UoWbfGuAZr4/b4N24Rup?=
 =?us-ascii?Q?6nt0UsXXCLl+/tChqpIsmpx99Xnu1jcCP9JTrOaDomZACGSlw9Y1E0JrpaHK?=
 =?us-ascii?Q?YIcBOWwLmVMa5nN5QDr0SGfUZxaQkevUG8I+QgXOLsJ1qXo+mIBTuZWHRo/M?=
 =?us-ascii?Q?gbgdbMJe4T4bPoSYcvUCmCf2+M293isGdA7E+VqlEynsr0Fcm3mr/dun/1+h?=
 =?us-ascii?Q?eOZ92PUNZNglcl2xYy87Gan9js9bgBkoW6AvFSKbPzG6LFFWADdz5toLDCJr?=
 =?us-ascii?Q?cXKcUS+uFH4Ggw8atCG8eanfn83uAuaHTGCKEuLxaD0AEci9RQxgftAaP5Ev?=
 =?us-ascii?Q?KGJyD53Xpx26eX/zdhr/qH4YzzX7qFT7PiIJPK5hV+RZsUFgm0a8kc4XbYmE?=
 =?us-ascii?Q?kb8fFNil3jqjtFsZ6HpEZVSVlHpf+/ZukcpoTHByG/3gC7EjaAq6j2QXTTGG?=
 =?us-ascii?Q?BC25YdufapIunwB6HOv9LKxwjL+HKkDvVB2C1j6AGuAQiAqwKPPgCrVmCPbH?=
 =?us-ascii?Q?A4/EeIUpaSl+irLLpf3WhDkuhWlVxu2jTfsGN+e/KESKkt7sfBNCUnauVkIh?=
 =?us-ascii?Q?bAHX0G17KqAq5OwGRqP2sjePsqV1gfRqy1gqakp/vtdT0DcVEn6uEv0pe1PM?=
 =?us-ascii?Q?KNoEX80E6pIuc8tKhwyBd174RcVuZZmYAJDu5jpGkubY/7MLtlZNRHllrzWA?=
 =?us-ascii?Q?yL82vlW3jG3sspie9PDRa3ZjAJ/YhqbvPnqVJhX8MDuTda21jyriuWG3jQdR?=
 =?us-ascii?Q?KaKvZzmi/6kX18IucXHeMqNjIZ0AozgVNLUHd+n2j+dvQmgnjAvKSo8PyAPN?=
 =?us-ascii?Q?sdZY9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sR9aBzw17RbMmR3NB1tP4Ni4eqnlbC717CX9zwjG3QZGw9rl6c3nujKD2Uel273OdirtUzZnOuZD4s+KNZzAGEbs9HYr4rsvoUALHYi08EwijKBfy5x35oK/8zRl4TiMfLaO/tBRxH2q3yL19tlg7eVaeLqGAWq2Z3SG5wi+E9KKsKGCYpvmqclGIexPxN65qv/EOrwZHZ/FKUF+FWTyJukUNCudGogLO8MQMF2xjALnXzIihafbzci7f7lZ2YhxQ9TCeD1I4f3aWBBvSJe5oDlnd2EHGA3S1J/31OFSbNTdZXN41NvV3AdiDJ9uaHIbN47WW4FzdCYHgBCbmJGhhyr0j+5YxUyGos1uUv4tWaCD9VNWmEC/SgTDAvR0s2UZKFiJ+Bvm4BE6der83pQdXsYDuou+N3koXM6kZSJLR1HWOpLMau5otAIkrGZoWgIN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:17.8763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c6b5a7-e4f3-4993-b86d-08de63c15763
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9078
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70146-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E4240E2C87
X-Rspamd-Action: no action

Expand the APIC register mask infrastructure from a single u64 to
a u64[2] array to accommodate both standard APIC registers (0x0-0x3f0)
and extended APIC registers (0x400-0x530).  Current AMD processors
support four extended LVT registers; future processors may support up to
255.

The existing single 64-bit mask can track at most 64 registers (with 16-
byte granularity), which is insufficient for the extended APIC register
space.  A 128-bit mask (u64[2]) provides coverage for both standard and
extended register ranges.

Convert the bitmask infrastructure to use kernel bitmap APIs.
APIC_REG_MASK now sets bits in the u64[2] array via bitmap_set(),
APIC_REG_TEST checks register validity via test_bit(), and
kvm_lapic_readable_reg_mask() populates the expanded mask as an output
parameter instead of a return value.

Update all callers, including vmx_update_msr_bitmap_x2apic() in VMX, to
pass and utilize the new two-element mask array. Currently, extended
APIC registers are only supported for AMD processors.

No functional change intended; extended APIC register emulation will be
added in a subsequent patch.

Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/lapic.c   | 96 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/lapic.h   |  2 +-
 arch/x86/kvm/vmx/vmx.c | 10 +++--
 3 files changed, 67 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2e513f1c8988..66819397e073 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1664,53 +1664,74 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_lapic, dev);
 }
 
-#define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
-#define APIC_REGS_MASK(first, count) \
-	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
-
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
-{
-	/* Leave bits '0' for reserved and write-only registers. */
-	u64 valid_reg_mask =
-		APIC_REG_MASK(APIC_ID) |
-		APIC_REG_MASK(APIC_LVR) |
-		APIC_REG_MASK(APIC_TASKPRI) |
-		APIC_REG_MASK(APIC_PROCPRI) |
-		APIC_REG_MASK(APIC_LDR) |
-		APIC_REG_MASK(APIC_SPIV) |
-		APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR) |
-		APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR) |
-		APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR) |
-		APIC_REG_MASK(APIC_ESR) |
-		APIC_REG_MASK(APIC_ICR) |
-		APIC_REG_MASK(APIC_LVTT) |
-		APIC_REG_MASK(APIC_LVTTHMR) |
-		APIC_REG_MASK(APIC_LVTPC) |
-		APIC_REG_MASK(APIC_LVT0) |
-		APIC_REG_MASK(APIC_LVT1) |
-		APIC_REG_MASK(APIC_LVTERR) |
-		APIC_REG_MASK(APIC_TMICT) |
-		APIC_REG_MASK(APIC_TMCCT) |
-		APIC_REG_MASK(APIC_TDCR);
+/*
+ * Helper macros for APIC register bitmask handling
+ * 2 element array is being used to represent 128-bit mask, where:
+ * - mask[0] tracks standard APIC registers
+ * - mask[1] tracks extended APIC registers
+ */
+
+#define APIC_REG_BITMAP_WORDS   2  /* 2 x 64-bit words = 128 bits */
+#define APIC_REG_BITMAP_BITS    (APIC_REG_BITMAP_WORDS * BITS_PER_LONG)
+
+#define APIC_REG_TO_BIT(reg)		(((reg) < 0x400) ? ((reg) >> 4) : \
+					 (64 + (((reg) - 0x400) >> 4)))
+
+#define APIC_REG_MASK(reg, mask) \
+	bitmap_set((unsigned long *)(mask), APIC_REG_TO_BIT(reg), 1)
+
+#define APIC_REGS_MASK(first, count, mask) \
+	bitmap_set((unsigned long *)(mask), APIC_REG_TO_BIT(first), (count))
+
+#define APIC_REG_TEST(reg, mask) \
+	test_bit(APIC_REG_TO_BIT(reg), (unsigned long *)(mask))
+
+#define APIC_LAST_REG_OFFSET		0x3f0
+
+void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
+{
+	bitmap_zero((unsigned long *)(mask), APIC_REG_BITMAP_BITS);
+
+	APIC_REG_MASK(APIC_ID, mask);
+	APIC_REG_MASK(APIC_LVR, mask);
+	APIC_REG_MASK(APIC_TASKPRI, mask);
+	APIC_REG_MASK(APIC_PROCPRI, mask);
+	APIC_REG_MASK(APIC_LDR, mask);
+	APIC_REG_MASK(APIC_SPIV, mask);
+	APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR, mask);
+	APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR, mask);
+	APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR, mask);
+	APIC_REG_MASK(APIC_ESR, mask);
+	APIC_REG_MASK(APIC_ICR, mask);
+	APIC_REG_MASK(APIC_LVTT, mask);
+	APIC_REG_MASK(APIC_LVTTHMR, mask);
+	APIC_REG_MASK(APIC_LVTPC, mask);
+	APIC_REG_MASK(APIC_LVT0, mask);
+	APIC_REG_MASK(APIC_LVT1, mask);
+	APIC_REG_MASK(APIC_LVTERR, mask);
+	APIC_REG_MASK(APIC_TMICT, mask);
+	APIC_REG_MASK(APIC_TMCCT, mask);
+	APIC_REG_MASK(APIC_TDCR, mask);
 
 	if (kvm_lapic_lvt_supported(apic, LVT_CMCI))
-		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+		APIC_REG_MASK(APIC_LVTCMCI, mask);
 
 	/* ARBPRI, DFR, and ICR2 are not valid in x2APIC mode. */
-	if (!apic_x2apic_mode(apic))
-		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI) |
-				  APIC_REG_MASK(APIC_DFR) |
-				  APIC_REG_MASK(APIC_ICR2);
-
-	return valid_reg_mask;
+	if (!apic_x2apic_mode(apic)) {
+		APIC_REG_MASK(APIC_ARBPRI, mask);
+		APIC_REG_MASK(APIC_DFR, mask);
+		APIC_REG_MASK(APIC_ICR2, mask);
+	}
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_readable_reg_mask);
 
 static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 			      void *data)
 {
+	unsigned int last_reg = APIC_LAST_REG_OFFSET;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
+	u64 mask[2];
 
 	/*
 	 * WARN if KVM reads ICR in x2APIC mode, as it's an 8-byte register in
@@ -1721,8 +1742,9 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	if (alignment + len > 4)
 		return 1;
 
-	if (offset > 0x3f0 ||
-	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
+	kvm_lapic_readable_reg_mask(apic, mask);
+
+	if (offset > last_reg || !APIC_REG_TEST(offset, mask))
 		return 1;
 
 	result = __apic_read(apic, offset & ~0xf);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index adf04a9bd57d..152f17903ff0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -156,7 +156,7 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
+void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2]);
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9e6c78a22b10..35440753e5c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4231,10 +4231,14 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 	 * through reads for all valid registers by default in x2APIC+APICv
 	 * mode, only the current timer count needs on-demand emulation by KVM.
 	 */
-	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
-		msr_bitmap[read_idx] = ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
-	else
+	if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
+		u64 mask[2];
+
+		kvm_lapic_readable_reg_mask(vcpu->arch.apic, mask);
+		msr_bitmap[read_idx] = ~mask[0];
+	} else {
 		msr_bitmap[read_idx] = ~0ull;
+	}
 	msr_bitmap[write_idx] = ~0ull;
 
 	/*
-- 
2.43.0


