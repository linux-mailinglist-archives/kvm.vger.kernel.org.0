Return-Path: <kvm+bounces-41552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F170A6A71A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DC6E16A3FB
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D11321CA0A;
	Thu, 20 Mar 2025 13:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HVnUvDCT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B7C2AE99;
	Thu, 20 Mar 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477234; cv=fail; b=o7VTIeW1XPeiEgKMZyTFfqirD8qQGI8uYuQ4kWhHjskxCm1vBdmzZuHy6RcCTrvolMUs9CZGkwhdHzNvDtfRFXU9t+6QwevtJt1rGSfcOhDr4QZagLrUKqunTV7Y68XP/6IJeRJK29Ib8Y8PgK12LtdTw16aVLchg6X1hP0PRA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477234; c=relaxed/simple;
	bh=DbAbGZoH6uKpieJ96/MkgQzb+GTRVNYAvLCk3CoqRnQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IJUvdpR3g5DYrasOGqcnBuyaMXzWFN9azRGpFXDJRrZ+0aSgmOdTH7Q3P7damphV/Vg3pEbTy/Mfs5i5CoDCe7Wi0ZZWwFsu+vcRS8unzUKFX8IddS1dFCSO3GTBLeRweIgLE/zDPfFCpzn7iPwYkwHbBZRRX9LytMa6iaPDcfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HVnUvDCT; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yP5wWxIbB1flBTfSwND2jMdgWDLaw8MygypKAq7g9jJ+Qfk1sN9NysmNyTZCqT9phFor6OPTjSaNxQaIBRLx2Tcjhvgz6V/yGEyYY1d7JVcAbdTlW8PUWW1S7oAQAOJDQ1V8mQ9bheuRLp1uHrXlDgQ9ad60lUf0KbjUOdKs3Sj4mOjmorNJhRWmmrSZWv7z1OLJ4lvKH33mpL7xbnEQ/nDwm8NwjWWpuOt1idn5hNuzxgYMFCRe6rOhQmkN5FQv4TIpmqrFuav8uX4v1ipYA+tazQoRqtwkzgSU9//HoxNmaE9bezvgYQfaknn4GMQOAnET0q/NwRlW9i9UqyWajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmQC4DoJnuw2BVPiRUqaw1/QRoMcwM8sbwV7Ukc4n5U=;
 b=L7Znt61uZ2YHbnnB42JYMMemDT0TZMG+rPDX1wZJW0BNRRe5zcmD239pjy+guMVLfc8jK2pztBdfZO2gdpu79ef6nQQdR4GmUPBUvlTsCVROeSBUWvMo4h7KqbHl1RrB95QjivwmESUJwsisOONmlhx+BIzy45aMqIjpj6UqmT2cgxH8qKLyuwPBVGdzoVOGGsiCqbD7UxIiQg+K91ni2lVfvgTND+UmDLyuCfwubhpAhnvQLIcmilYTOtS3pL5X6FMNlcwkb9v5Din5YsUGs0lnnYEEq5bfXMzUgaYKt2AqDVzwsdyrYIy1x2iYhTkMBu1Rvuks3pa+lbjTtCAqHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmQC4DoJnuw2BVPiRUqaw1/QRoMcwM8sbwV7Ukc4n5U=;
 b=HVnUvDCTrZCweIf59CuJG4079u8KzdidlFZpvD5+hRKtBy7mN0nnqmi0x+KNmJjaaBYtOs1tGQsE7TaQSoTt9fqzR1UPR8jID+ESfBIn4/skDnbgZOgvuL06ompj3sj2CvIC0QQEAx0GDMkVZpyo4RtGBrIut2Nuf1b0ssg3K5A=
Received: from BN9PR03CA0366.namprd03.prod.outlook.com (2603:10b6:408:f7::11)
 by BL1PR12MB5876.namprd12.prod.outlook.com (2603:10b6:208:398::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Thu, 20 Mar
 2025 13:27:07 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::14) by BN9PR03CA0366.outlook.office365.com
 (2603:10b6:408:f7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.36 via Frontend Transport; Thu,
 20 Mar 2025 13:27:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 13:27:07 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 08:27:05 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 0/5] Provide SEV-ES/SEV-SNP support for decrypting the VMSA
Date: Thu, 20 Mar 2025 08:26:48 -0500
Message-ID: <cover.1742477213.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|BL1PR12MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 80d10ec9-8669-44ad-b223-08dd67b2e97a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a/KZGW/B7tBifGYbzA8tY15cRb0J/I7517HXqQfo6+zGUU2ZWe0sJLNaiTIk?=
 =?us-ascii?Q?DnwvAfjI0lGKSs5T8KEkJab70kGaBD3uygkSeESkxDN5ny8vspZ3JWyXWvUW?=
 =?us-ascii?Q?++oBBkmKD80PTFu8UQ0YefzxLUAOHGOQfRKOmxKF6ufjLfqQH2vv2BNrrABS?=
 =?us-ascii?Q?kJRWwRecv+L1P/OCOyampu0S4eju8E8H8A+y1aaALPicNLJLbfYpKQ7ke9ID?=
 =?us-ascii?Q?IcnxJNx1AMs6azTv8INVt73X/QNPFkuXQN/9mK8xO3c9NONMqVhT4dUwz6KB?=
 =?us-ascii?Q?wCm8ALBDW0+T0zvepHK8LJ/HDWgjUcSDwIy35uNVuThuJyyoAVUdtlh3FAEL?=
 =?us-ascii?Q?1YwOCRbiF4CS/Sco4j8QPB6fdxNLxFlcxKKtlzDw2jfZGsEkUCfnpbWpKS2j?=
 =?us-ascii?Q?xCsMHktZ6elTKl4x3IvCdrYYJrwcoH/vHIYfLmHi2xO1Ki/WCxNNMHJQ+egm?=
 =?us-ascii?Q?6vqBbzem0labWu5MqbyhxPwdKWSjUtRlK6osM3/WSd///K7X3212kogTpTon?=
 =?us-ascii?Q?OHrRJ1bnOT8rZdSVI83adzpXCCenmqd4TBommicAfEf4Yef9ZXTfBYcZ5egH?=
 =?us-ascii?Q?1Ekm7K5tzoQORpJUTLzOpbcvbgMwUn6rDhiIOiqvo/AQbBbGT9hIJlDLza+g?=
 =?us-ascii?Q?e3PT7CWFKXmoMBkxa50NSR9fk71NyS1nBPUr1YqWal5MPHSdJHWxt4k1Pdnp?=
 =?us-ascii?Q?H2LA3bh95SaAqdXvuokamjcS7hqcxWl9ChSfBYW7xdjiLQTLzuJ5dBaI4T3y?=
 =?us-ascii?Q?w55dBc3qg/JLTq8dcqvnFtBlPAtFR6tBqqakFq/Tu4CaPWnptiPEkmtt399I?=
 =?us-ascii?Q?kKGRPghrwcejklDRuu3DEl8VDQjqJEuSn+XM8znPzE23hUgkdoczaSnktIfM?=
 =?us-ascii?Q?IgVZgbBlKQ2GXH8jMmgwsW2wW+dyiWSQmhI/Nvw/EaSAR77aGTIodzA0/UDS?=
 =?us-ascii?Q?shVcMxFCgwY43yUON8WU04g5/MmLqun85/LM5NoQ4caAB3VZxeAkhVNYZd1s?=
 =?us-ascii?Q?PsI7G+BagIzOA/t0rj+SDaznbLf2CCxRB00hdAuEJJgap56KkcpChvBA0F3p?=
 =?us-ascii?Q?ahG8QX4fxQ02EN9GDcUXzXywKQXRNTxcrfrislJoOMbmZCzoU4u8oByXKDZH?=
 =?us-ascii?Q?i8A+QIkVKI7rlLzfFH1n5LL05/6mRIR+1WcQDkKZrLyOG2UtBnBBJ60dywtp?=
 =?us-ascii?Q?HPMi3lY+AHWISQYJIQQ3YHw/wISWl0E8VDYYcgLf3NNGPh3GE9voQh3pdE8K?=
 =?us-ascii?Q?qtZVC065n+hXw3deOn7t3go2HkJR473zhBv5hZ4BwZIiCPF0KaSy4dUJMsWz?=
 =?us-ascii?Q?QQUog7Hg+bWbj5pcJANkXIMBo80HkLb1RIe4UbNM+JkXFoTgpjUk2JSzlqsk?=
 =?us-ascii?Q?prBgoulYVuzbrkWPXLgLNmMNLMn1zH6AhXU5qfdQxuR0KEppVSkNpFsb7OYR?=
 =?us-ascii?Q?la/l5ZrMP01ilIqp+sop4jtdLk0MqzSMnZlPqyd7tIWDrvo8fxHHg3c6odPx?=
 =?us-ascii?Q?2OzqhgFmyVSScw0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 13:27:07.4981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80d10ec9-8669-44ad-b223-08dd67b2e97a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5876

This series adds support for decrypting an SEV-ES/SEV-SNP VMSA in
dump_vmcb() when the guest policy allows debugging.

It also contains some updates to dump_vmcb() to dump additional guest
register state, print the type of guest, print the vCPU id, and adds a
mutex to prevent interleaving of the dump_vmcb() messages when multiple
vCPU threads call dump_vmcb(). These last patches can be dropped if not
desired.

The series is based off of and tested against the KVM tree:
  https://git.kernel.org/pub/scm/virt/kvm/kvm.git next

  e335300095c3 ("Merge tag 'loongarch-kvm-6.15' of git://git...")

Tom Lendacky (5):
  KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled
  KVM: SVM: Dump guest register state in dump_vmcb()
  KVM: SVM: Add the type of VM for which the VMCB/VMSA is being dumped
  KVM: SVM: Include the vCPU ID when dumping a VMCB
  KVM: SVM: Add a mutex to dump_vmcb() to prevent concurrent output

 arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 80 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h | 11 +++++
 3 files changed, 187 insertions(+), 2 deletions(-)


base-commit: e335300095c370149aada9783df2d7bf5b0db7c7
-- 
2.46.2


