Return-Path: <kvm+bounces-48831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F30AFAD4171
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 323CD3A464C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E57246781;
	Tue, 10 Jun 2025 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3nJZmHjb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04D6245028;
	Tue, 10 Jun 2025 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578418; cv=fail; b=S+l3W645cL0YC/gErcCwLymHVx6dWaidosT67kCNpNLUKvlJv3Pr9AAF/oOJnmW1yY8TZZhgRAVex4krIV07aAwHSARhz5auwuIR3ZgOmBdZzwbYGS60y/AgUhGfrrJdStN7FwYWIkN+4wHQq56aTXsdfjCpx3G5ak5edAjVZLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578418; c=relaxed/simple;
	bh=ozAIRwXbOZbGu4jPiy0PAb7MK2NHqYsNBBgg5NMM4jk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IInmmx/l/1c+PrGyWKYIoGVs44/qKaFDcnGjV8c8e2n+/OTAe/6dWP9otskqDwhottcbLJJQkg8ncTPdj1xO519ssexf7eW4P8Hvb78mVHIpl1gAPTmNgoqj0bGEHtDKT9gNXgZSdTGs+2OMyqhBcTwA6Zzo+8m9byjAC4cOct8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3nJZmHjb; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okj/ECqkw3TRgnbXEBdfoDZSQOwD6VrYDqDMBeCVnla34uOtFXxu1pUtci9J1+XIz9xwVXt/ZJr38IxrafGTGUBoLYLrTlYv1bAYxe3D0IQ+ZDSAm+gc7xLmsXwhhdHV0vEFF+t7xZG0bKkfg0Z2abIf6tany+Su7EjMoBWqEV15YlaOBnN4MahRnEWBPbPvWEPa19Zy6nx5kF0QRGIDV97L6TvV44F5SvGzWLX8qDC9dE/JBNOdVruhlkYInftRs/vkuN7m6VpDd6dSrooBa1DTuhPc+n3hHXxj764bm5A1Ow9dCXZjjKL3PGIh5LnnVEAiQtSRQ26KzgaU90khQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3TixncYMd+dai7EzhTj4JRs90ylHRIsEwkqsHVOpIk=;
 b=N2gGufkpJt6hzdxJ65T/WMEz5MO0PluFu18dawUUlpTiGSnr3pedyE3H3fDM9Ic3tdkWARnjD99gCzR4o9D9HwB3IZD+UDYFih/+j2OpdA31hQWaLjH+GEx+zunBjfOdKsdJgx7a+ZxBX1lzUU0V3EJmxIvAaZPNy9DQQ+LidxayQOL+TG/eQOeknugHssyYfvzc4UOmzPpdFRcfR6NyYyzMWIyrKaPNwj/UL2+3YykwYOEiBvb8Qn1T7xmqy2CnTgCBh9LEq9suLzOB3ZU88GFV0Ry70PYFpgLcF/4Qafv2aslQZ4qlmPJ7kylLAekxfw506LmZprIrcn+DX2DUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3TixncYMd+dai7EzhTj4JRs90ylHRIsEwkqsHVOpIk=;
 b=3nJZmHjbC4W/Iylcb+CUz8LgAMTsNqYIg05Sf6Xb7cvmNeJlXGkZni0PvULx8whvlMQrR5Q5CKH4Ia46JdXpQr76XWbSvIbKYnicdXqViT6RQSar0pPFbRUbpA4gSgpbZnWezwvozsCIQVp/q/qcsZGW+5r3SN2ytS1kZNi2QNU=
Received: from CH0PR03CA0080.namprd03.prod.outlook.com (2603:10b6:610:cc::25)
 by BL4PR12MB9508.namprd12.prod.outlook.com (2603:10b6:208:58e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Tue, 10 Jun
 2025 18:00:13 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::ea) by CH0PR03CA0080.outlook.office365.com
 (2603:10b6:610:cc::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.27 via Frontend Transport; Tue,
 10 Jun 2025 18:00:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:00:12 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:00:04 -0500
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
Subject: [RFC PATCH v7 15/37] KVM: x86: apic_test_vector() to common code
Date: Tue, 10 Jun 2025 23:24:02 +0530
Message-ID: <20250610175424.209796-16-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|BL4PR12MB9508:EE_
X-MS-Office365-Filtering-Correlation-Id: dd34e1e3-1477-46f7-4335-08dda848a5cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hh/QXXirunO4oZW8gdscriU8b6J60YswSvrNTQ47ksvLZw3i3JPeWlpDsidz?=
 =?us-ascii?Q?7s4AIzNlK7ady9dBXCzLC5KRoIoZxELSz89xNzRoGr7ZLGRKWKnJCqulsAWr?=
 =?us-ascii?Q?6syGiv0TvgIR4hG2hhBuycOhQHYusW/EgDMGgk4okYmgdQi4ghkkq+BA80Dr?=
 =?us-ascii?Q?2RMaa9DavlPQCqW6vxlUUa9/xzzWyMADSn6iq9Vaa+xjJp+k1gf+o1n4jL6+?=
 =?us-ascii?Q?eCrLeNr6QUiSEMfbus/HlFYWu3XBqj88rXohOuYA4i2/o0ie6+ScECiNiz0a?=
 =?us-ascii?Q?/yDnR6u3MaOAyYMZoaKNPxmwc1Mjw/j4I85didSVlgpnJEOwiwmuBTzIRW/P?=
 =?us-ascii?Q?H24zHOnAO4kGeTraUQDegCsLfxiGf1q5+zo/vxhAcecN3H2ZZYWqSlswNNtM?=
 =?us-ascii?Q?+81oO6UapPryi5KYCCLkKjKElj5ttRmzP26Y5/+k+SoAQH15Dd1PvX8iVBHl?=
 =?us-ascii?Q?NYLVwOS0PAYCcqqq7+tCKINjuqCRdr5L6XmWnRA2hrs9x2UjexIo08bEbZxB?=
 =?us-ascii?Q?71CyIqhFBvWZC29HyDH274roAJ5os4s3iIpT3okp402AgfwdSaBQdZYvX6dC?=
 =?us-ascii?Q?ie6AW5uB4WcLyAJhShSd98f+XVvRe6jfjkbTgHBZ8iWgcoa9GkJwqijM4+wW?=
 =?us-ascii?Q?HRZO3mlbnCUkADRYlRbC41I2ygIRp6M5My38yc6HBBPU7UOuQE7bK72TzWfG?=
 =?us-ascii?Q?bkL2gT4i58cR8IG59EI/nF0JdDyclknbh0L22bO56KRqz4e51Nn8QAi5u0cz?=
 =?us-ascii?Q?SP+6fpM96rUUQcfnzMtzd3UTq2TvMDbklgx5bbUfY4hqUreXuxYDmFc0T9U1?=
 =?us-ascii?Q?BW96X88ORaDQzKhXYcO12KKwjxMbrGOn8WpgPKmhGFxUsOBipjw7OJacuosz?=
 =?us-ascii?Q?yZANUzHr+tXawBvyXj2BAFqBz8JnkLneTD/3iTveNe+Fh8IiPg25Hsuf3PzL?=
 =?us-ascii?Q?4rWpQy7Zyc9I/ZOaSGYxwlq8yEQwOTxGMbzWHoOCsu4VYD+gNyI8DSrHu+c6?=
 =?us-ascii?Q?VfxdFcH2fIk3AVQxSJcbU4XqtTmV7lgsWAxdrk/+YIykrtsu460Czb5DiVZq?=
 =?us-ascii?Q?yMZY/SzGS8xhqpoIMjwroCAJQyeSX+HmnwdM+PIQ5XDvOkdoTUn6JSnexU2z?=
 =?us-ascii?Q?mYLOGmkTWdoKxMRhdlqpSA+iju6qAiB2D0UEX2qLUWFm6WGsMdY3RKkRbDfJ?=
 =?us-ascii?Q?7xmi3UCFW2DPGCGk8nQiTnW/oynOEM5yHrLqDltqWg2mU6/XChiaY+AzFS8+?=
 =?us-ascii?Q?52nlrdBgrtELXPRIvLWIKQF/Onz7xnMl8JWPmiyPp1MCdO9QmfRhEKJunPza?=
 =?us-ascii?Q?+mmW9rUUrOAmVTCkcmLBQsQ5/KVPfrlku5Wp10TJp0rE/IHjPhkPYkF44Lmz?=
 =?us-ascii?Q?pH0yJHfMFQeLBdHBv26ppUZnUhq5tzlKlfGNB3aihArlqtu8CRnV50utW58T?=
 =?us-ascii?Q?BaHVY/XMqCWMEdj48mpMHW4B1H1MdKT52hYs58rTJ7EgHbjKm0VEKcapoEKi?=
 =?us-ascii?Q?bBmKNa+Mu3FQPwEvFscrvqgbJKqvVZ5LH3DF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:00:12.8667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd34e1e3-1477-46f7-4335-08dda848a5cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9508

Move apic_test_vector() to apic.h in order to reuse it in the
Secure AVIC guest apic driver in later patches to test vector
state in the APIC backing page.

No function change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Moved macro and function renames outside of this patch.

 arch/x86/include/asm/apic.h | 5 +++++
 arch/x86/kvm/lapic.c        | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c6d1c51f71ec..34e9b43d8940 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -557,6 +557,11 @@ static inline void apic_set_vector(int vec, void *bitmap)
 	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
+static inline int apic_test_vector(int vec, void *bitmap)
+{
+	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 85bc31747d54..ed5e22fc49cd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -93,11 +93,6 @@ static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 	apic_set_reg64(apic->regs, reg, val);
 }
 
-static inline int apic_test_vector(int vec, void *bitmap)
-{
-	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
-}
-
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-- 
2.34.1


