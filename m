Return-Path: <kvm+bounces-60841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEA3BFD9E4
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFDC43A97DD
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E93D2D4811;
	Wed, 22 Oct 2025 17:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j3KM5Gwe"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E15625A334;
	Wed, 22 Oct 2025 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154677; cv=fail; b=jMbX4++s/V0tRrLoXMhxf/rVUiz6OjkwVppk8uwFbXIH/xz/YPJupKWaeIc0iZxvhPWDWVHGPB9oVCv92A2M4o4NgLvycwBI6LqDTUNKu2B2QMw9H1NtQWgVmETqCKPzk2FcrMRp6CclQxdAUPHtHloAcRL84rN5RqKl+fgY200=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154677; c=relaxed/simple;
	bh=3c9F+uGUb22faz2gv8yTHXmmH2snf8+NhsDrR5qDXz0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VWG36JLwWXr4cAzhPQuw4tUPxpqZeGJYB8E/FI4cAPuoBdySFwjxZVFsFNq8gVV5z8Vjp+/fZZkXQs4rOv8gI06uByACB+2TyC0w0EX9ObmfXQAurX64pclDnMPNJPatns+jYkVBJFOFvwJ7pguT16TSDBJiw/OGFHIuDYVifM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j3KM5Gwe; arc=fail smtp.client-ip=52.101.43.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=si4pTWWhzQ9Z0Iw9oVtH47XBH7aADKRryIF2o3cVU4UHOt5q8YObgG34uf8vvLkUZUXuivBeDgK2d8w34OazZVflLpewrmGmbOlPTWjkcwgD9Iw2A+lkx1tgTI0d1NGuK7I77jpvSHiP3q7POrOVZkkXzK7aSpSUKhfMRZ/B8hLtmqSJOWL7QR/D7Ctu2BOK3423c8mRomUM2xX0LUKTPVDo/asfZMm456PKPji2qmQSpDX5MMgwnBIYigdZLIhBPzk4bRDg6vU6FLhmX5fc/WPouU7HRHYz1cxCJb1JvgbTSELp8GoioGOhu0GMph9+9j0xfBWxua2l3hRyNAhyHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UqACJZre1ElH6zcDPzfr4u8MkivRGHaoZQyxJJPxSU=;
 b=R+C9sPOf8AZQ5Dzs2iETKOhINPKCfxyiKamxvYd1i+L2nl6vdaxOMlSm+d4Te9O25+K2uI7vmlu+V6S9iSD1tbxT3IICbCksK6KmTjdE3Mo0J5jmj0AT3XtGT25+FS55YzP6utUQBe+TtgObHqKjov8HJtxGhvdIFdXemdtN1sE/UgiHkwLUJAAEQg6aFtMTTO+UoHv4Z+TVZilrDOqWOxKiewXolDyHVLgWH6ME96Tq8tYzvg7H8h6rVPFPKz7KzEzJ6t8gIvTGFOXE7fvdtSXTESXSjZEa66nqfJcWlkslhIfvz8+obbPnXDLo6an+Z+zsxvKudL5RCtYOIERgZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UqACJZre1ElH6zcDPzfr4u8MkivRGHaoZQyxJJPxSU=;
 b=j3KM5GweKoH+dY3cwkb5gV6xFdDJG2H77VMaa+1F7StysmoMhD6qixR8JSdkAOCpGwoxl9jTSP+MRtNp7ZFM5ZbBYJtc659m6dzGCGT4+Cey1yoWZdSmtUjo9/xtAcEzuvx0VLCpMy8wYCFc7Cz40rTcQ8YphpDChIMXS17mVdA=
Received: from SJ0PR03CA0230.namprd03.prod.outlook.com (2603:10b6:a03:39f::25)
 by PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Wed, 22 Oct
 2025 17:37:53 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::b9) by SJ0PR03CA0230.outlook.office365.com
 (2603:10b6:a03:39f::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.17 via Frontend Transport; Wed,
 22 Oct 2025 17:37:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 17:37:53 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 22 Oct
 2025 10:37:52 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v3 0/4] SEV-SNP guest policy bit support updates
Date: Wed, 22 Oct 2025 12:37:20 -0500
Message-ID: <cover.1761154644.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|PH7PR12MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: 1945502f-5882-4384-ecd9-08de1191bad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YOJQm1eORnh+4xKqQFBnCfBibZgteiFqt4ECLPRVPLaQibpcCB76b0CRGd43?=
 =?us-ascii?Q?G7vd3XrqQVL7oTCHAOY+N4DAxbm3OofSnVEFskfRHyswNle2jzEHyGff0tU+?=
 =?us-ascii?Q?bf0NpPNa3pE1bJzZOzzR983fI6RHwDK8SpSTtmK3b+eoQQixvulJAw75gkwc?=
 =?us-ascii?Q?OP8Q4aGWXoN5oZCt9cH6dRV05NWx04y7BoCeJjvfXd/pAyMQIJlM6KU1FQba?=
 =?us-ascii?Q?1B52I3aW2C5GpUFeeBmu4yZN+vo1IzD9/3oimruPP8EDuZK0fzAciSpkmj0P?=
 =?us-ascii?Q?Kh1h7xaeshpZTBDUJdHmgZxY25P4CCaGECDHgTQgdbaJSJzhkr9bG6pnCqYC?=
 =?us-ascii?Q?T2/dKfHuFU73XcqMQRXdzDNVDRavUtJhs4pVZKLaVd+Kb5St+KrHhTFLWDeC?=
 =?us-ascii?Q?9CkUlkJYqBQEjaae3mNdJsZYiV5YlyNR3ufoyaTBYRZ4pNMwhVEycMQkoTMj?=
 =?us-ascii?Q?JggF6o1LPHNF9qKQ8Lo1leSmn8G3eW7d6Co/SM756w8S9YvmdUU5p4pTwA+f?=
 =?us-ascii?Q?LpL/wv+BaRculcV2JWw7s2hQiTS7WJTnsyd7HwwyU6wbwGTnWddTIonZ5b6g?=
 =?us-ascii?Q?HbkvJYvMtKkzwYXsI/XZSPhJhHFzvNTvKkpT7BQJvEL/KwEfQ045CsyuC/2H?=
 =?us-ascii?Q?FV9GTcR9tivhSV2+OH6AV4AJkfoLVcNtWscROOnwSjJCgaYlkS2ww43C4lIr?=
 =?us-ascii?Q?7PlH/WWtQYry26MINw5koEQ3QTLkBM04emsC7rvUL+LVuX3+z9I7Yyett66b?=
 =?us-ascii?Q?d3v/ww3iZiyoccn6+erF6rpwONyqW7lKJypyh1aW9wunkXI1cK08HJvgFwsb?=
 =?us-ascii?Q?YSrmtOIPhM3AvdEwg0aRnbzmcjw3qMwJSibiTwIlHcInxoi+K6bD+NChnnqq?=
 =?us-ascii?Q?uexr5pvltPuhpydblOceKMexBLMO+4XyVvzV2vfkuqwAAznTZDbLjuVkEDMh?=
 =?us-ascii?Q?vvUFeSTV2Ni9I7lw0SmeoeF56ffHXw7YyeNg6g2q9TMPdXVpgEpngBxcUAdO?=
 =?us-ascii?Q?1l1GHrbKPX1MJZV/i3fEZJ/wRmEwIuIE5Uss/V5GyIW9ByheMQo6M3vLRr/s?=
 =?us-ascii?Q?Khh+3YcB2sfB7y3+BADQe2Ri2GZv+tHnJL7PXURUrBau2ZFcRp5idbvlazix?=
 =?us-ascii?Q?/aMNLM0X8YL/id5JIYtnlIvTZYmTh2idUQwrq5tuXZLkQp78e5Q+i6GyAjIb?=
 =?us-ascii?Q?dPpEwSLg82eQHkE5mJwhhfDnG4Z9akCamwZKO9Auv0qLw5/tVS1CZHrmUDqU?=
 =?us-ascii?Q?HvxgFww2dlTIfTQmoRJT9jPQG9PgOgBf1M5B1HR2gyyOyFsDtPyZfHqGnX/F?=
 =?us-ascii?Q?lcqZXT7wMEWGv3utli8qCKpMP3aG+vCE9mnEOnB1wWxxSmTWJWhW8aY3yc3w?=
 =?us-ascii?Q?sE/AAmI4pnrxi3wCo6ZVor/AgWUzyIrcI0yL3pFfFeShqUG3jZ6uUsaADDIo?=
 =?us-ascii?Q?DFSjg9MCitmgQQw1WuHIt1VgRaXAz7JTDks7y8Q5Wa4Ah/nnvI2cheD2c0SO?=
 =?us-ascii?Q?Jy02eIgA6nFqCZu4ZOeijEnhTjVAneKMwDAFYT6wPt8I7SkKHwA33WPCiKgL?=
 =?us-ascii?Q?szNqAD/8BBykFnbagcw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 17:37:53.4354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1945502f-5882-4384-ecd9-08de1191bad5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927

This series aims to allow more flexibility in specifying SEV-SNP policy
bits by improving discoverability of supported policy bits from userspace
and enabling support for newer policy bits.

- The first patch adds a new KVM_X86_GRP_SEV attribute group,
  KVM_X86_SNP_POLICY_BITS, that can be used to return the supported
  SEV-SNP policy bits. The initial support for this attribute will return
  the current KVM supported policy bitmask.

- The next 3 patches provide for adding to the known SEV-SNP policy
  bits. Since some policy bits are dependent on specific levels of SEV
  firmware support, the CCP driver is updated to provide an API to return
  the supported policy bits.

  The supported policy bits bitmask used by KVM is generated by taking the
  policy bitmask returned by the CCP driver and ANDing it with the KVM
  supported policy bits. KVM supported policy bits are policy bits that
  do not require any specific implementation support from KVM to allow.

The series is based off of:
  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

---

Changes for v3:
  - Remove RFC tag.

Changes for v2:
  - Marked the KVM supported policy bits as read-only after init.

Tom Lendacky (4):
  KVM: SEV: Publish supported SEV-SNP policy bits
  KVM: SEV: Consolidate the SEV policy bits in a single header file
  crypto: ccp - Add an API to return the supported SEV-SNP policy bits
  KVM: SEV: Add known supported SEV-SNP policy bits

 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 45 ++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h          |  3 ---
 drivers/crypto/ccp/sev-dev.c    | 37 +++++++++++++++++++++++++++
 include/linux/psp-sev.h         | 39 ++++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 20 deletions(-)


base-commit: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
-- 
2.51.1


