Return-Path: <kvm+bounces-47052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C778AABCBCA
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68A084A5A14
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F48E23C8A0;
	Mon, 19 May 2025 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NXV+88WY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ABC23BD1D;
	Mon, 19 May 2025 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747698991; cv=fail; b=UH6skwZ/i0lPCNzg5vuI8DkfNYauhvzsDsszNC2CGNF8cxEUY3GvmS2SOUF0BcfIzm5tFkHEeG84CF6g0cQIoP+gZPRMimv4qIPDIL0KH8OI/ay20wuOFt/USHYP9SG6Ji3QqQSRQwdLNGDhuEwf8dpxx3HYUMeDeAb4FWTZQss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747698991; c=relaxed/simple;
	bh=Cm9fXa4PCntU/V4yolgUIAlCJUsVhnI6CbzhSzOZdek=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LlmLpFp2ZIjto3J6z06XXF/xufvnU3u0XyX4axEsYO9iy6hJS85ZvBrYhPFqcQzLGCjbhLcG0ZD4/+uLCwAK1JGQYfO+z49TzCgwbvpM4rmPLJs8AwjiOcdbOc4pID+V9yajlaJwEWfJKouPps0kSLtdW6wmxRQPLf2IW3wsC/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NXV+88WY; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pd0bD2PvuR4nfzZsaxp0t3DltPpZlyiem/RNXizDsgR7pgWGRkJo10T5n0pCKzjwJMGi7nEKo7r52+s+Rq4WXox+tHZrC3hndKUPcBkfFIZAUv4K129oPmInpsjzHMeAzsxMvsv9eM5ZAIRygM+Uy1z3EQ5jgGhA60poH0VpL7+zMNkI3A3/XcY+gCZnSSSHzEEFGl/+WLb8zkkkRIjidDPjW5eMzA/kYtNLs7Q08gTStQlSRZjJ8a8UJVObzxy+1Gc4hAX1KZLIjOLbWSRL7ek9eiUH6i7Z058Bc8NLLxUM+YebIcG9PKWUFfkNl0Lwjk5x/FV/AhrSpG41mDqHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZE78U/HG3bSAuci3wUvkl10lpGE1hDJFvQSg9oC/wy8=;
 b=KCGf2BwLE/NnHnOaF01BtT1HFFUk71sTpKmdPVUjrtkEx7YVotx/Dn3ACi8wAGABX8lVV2aJe3A2uPULSdDZWDE1AmWoYjsNWQWz6RlYfPDBFK99cz9ZWklHw6QNNGeSsCozLrzoiH6K6qL9QaJ1jdzsGP5Hl3GY7TPXg60/VJdBzmR9BmH2IJl23FGlkXdxUC9b5zFyZsPdXIO14Up4CQ2kQVlfZlkLa2NeerBYY7xBVMJ5KmDghdIAWBjxH0ba2cjUy2S143cRiYqQ5n6kS4Jct950B4dLodDolud7dOUMFRjYy7sIUcsjG2kKJl3ftgw9xRKgkWfxrFdsqXVLxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZE78U/HG3bSAuci3wUvkl10lpGE1hDJFvQSg9oC/wy8=;
 b=NXV+88WYp2NTpPeVl94lHMx9F3KlZTOFM2ZmN3hJSC6SuPrOX0Ufz9CAkZIKdGcftsiWIolaIUZhL8PqZe/VGNq8mcg/aYoetgCDqxfYZIydDIk6yxcT1x80MZSYz1a23A+o/TIrBSvuubJRL6kg3cN6HAYT4AtpZKg7yJ73e8g=
Received: from BYAPR06CA0017.namprd06.prod.outlook.com (2603:10b6:a03:d4::30)
 by DS2PR12MB9710.namprd12.prod.outlook.com (2603:10b6:8:276::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 23:56:24 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::91) by BYAPR06CA0017.outlook.office365.com
 (2603:10b6:a03:d4::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.26 via Frontend Transport; Mon,
 19 May 2025 23:56:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Mon, 19 May 2025 23:56:24 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 May
 2025 18:56:21 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v4 0/5] Add SEV-SNP CipherTextHiding feature support
Date: Mon, 19 May 2025 23:56:12 +0000
Message-ID: <cover.1747696092.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|DS2PR12MB9710:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f12acf4-0147-4165-b870-08dd9730c317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?itmUvbmMyVvmzW7OwsuzErfPvAatreaeypa+ZAdquDeTmM5m2VJFnYfZb/Hz?=
 =?us-ascii?Q?D4MLQmw7JsxBIEi3c7QIHSOSR8J8VdRQknG8rjxx3EgV+zTFE3ByXS4PuZN6?=
 =?us-ascii?Q?bW1EJ1sNo97GHJuOExoeg4oh3vQ3AzrI3JctLhXgAggoi5GeVQFj51FjAg3u?=
 =?us-ascii?Q?7FczVwSLeonJ6KKzqLWtzEUPu7eenwtd9Tl5W2zOFqkL/7vKulTgptYeD+SR?=
 =?us-ascii?Q?VXsB4LuY9mlxR28ib3RmFYctQC4Q0oM4FV02IvVZ2Z9mTqC5AnmbBofJJCxQ?=
 =?us-ascii?Q?JbyR7eUQx77T6ygSIjp3YiXmib72EdkdeHBELoYKCJM7aOMBCK1vIUQBBlLP?=
 =?us-ascii?Q?AgM3XzE7RzSQ6Ns0kCf1e3vBIDd/Js4awP19IgPPxCXIWrBqZoJxFSm2uHy0?=
 =?us-ascii?Q?Et+9BP+s5swC3LQGlh4wQrWMJ2fbL7lEKS4rZfeQH9QXwgguM8XGpQL8Wp7R?=
 =?us-ascii?Q?jIv0GEKeEx5nUkz63sRfbTR60BgBFDxYLgJyD58di3wkzz3p//KmLE6RQT6g?=
 =?us-ascii?Q?Nn8V0Xm9y40RvsWE/9KaVqe3aiPWusHFMYpdDhMQjHKoSdeGoV7rd88PmJHz?=
 =?us-ascii?Q?Zjwg2F6f5HzFHpTBiPU8FIoEb2PCh4lxMZAZ93f3olvBJtGJ3D48PcOkF0CD?=
 =?us-ascii?Q?zoeaKGPOQU+3cv56oUjB4dHV5obO1prpoI+SGWXr1WvZKH3WABOfsPstEEMh?=
 =?us-ascii?Q?pAR4c2u3gRGiT571iUV7Yb6v1qLjwG/qA2Ffp9AUYzRJj1ERtr8bdKCljdIP?=
 =?us-ascii?Q?KG1zkkf1QtOFCQoTwbz1scpeQYcUTo5XyKZLznhpg1PKkB9R+3nQkg/rMJku?=
 =?us-ascii?Q?stIJyZyU+1XVX1C95AAAHBpoV4G+38eOYK80oEW6TsJuZUQUWPL95BUeCDxA?=
 =?us-ascii?Q?956zY3hgV6L+dH4cY8KsZvfiHYU/rXciElY9dCEuYY2nZ7U2Cqr24YX4ZMz1?=
 =?us-ascii?Q?ewcXEes4V7p7axTl28iXgsCso5BtYPpR0td0VEUM/ep24wwLWVsFqNjy/rfz?=
 =?us-ascii?Q?GqeMlhShgZXv/h0p3aXymPmwYKXmxQ1Wi/7H2yZ2yXXit2dBR96NICeXfoFB?=
 =?us-ascii?Q?CErDG1xCUZfBV5JFMMQv2SAz9h6ho3z2AoIpY1hMmm5sV4nRDlshu+L46koa?=
 =?us-ascii?Q?000hWgb1r2Y38GmI+I6MaXr8zkZIsXn/O5SM1C7NEjk7Wh5U+wX0QJLl1vLT?=
 =?us-ascii?Q?DPIhLCm9GI/PRJudBl3sh3XrVT7/bi3S5Qw/i3Uukcp2hXEpCb622l6fxBYU?=
 =?us-ascii?Q?skbplmmUVFy9omjZXoZGEqOUu63teNO4ZZ8Gd3jEowERS8ciBNPrLImAoJ0x?=
 =?us-ascii?Q?NCis3REC6k6BZW4NZSyFs9rBTldvB5e5f+133rvsOzlLpBwSfulbuMrlzpMF?=
 =?us-ascii?Q?Fsrw865E0b+lVZQL+BcgpIOpDy2cy3wkKQ06FXm4yIzfQtGn0bnFom+IBojZ?=
 =?us-ascii?Q?CzJzGS4CPF/GEL0VP06nB+XmnyAHvyS/F2o/D0N0U7Wq1+ihl3qzJhXuyqUo?=
 =?us-ascii?Q?SbNoLz3bpMpJwHRQbW+/h09yXwQiyg00M+0K?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 23:56:24.2553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f12acf4-0147-4165-b870-08dd9730c317
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9710

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

The SEV ASID space is basically split into legacy SEV and SEV-ES+.
CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES
and SEV-SNP.

Add new module parameter to the KVM module to enable CipherTextHiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is -1 then the ASID space is equally
divided between SEV-SNP and SEV-ES guests.

v4:
- Fix buffer allocation for SNP_FEATURE_INFO command to correctly
handle page boundary check requirements.
- Return correct length for SNP_FEATURE_INFO command from
sev_cmd_buffer_len().
- Switch to using SNP platform status instead of SEV platform status if
SNP is enabled and cache SNP platform status and feature information.
Modify sev_get_api_version() accordingly.
- Fix commit logs.
- Expand the comments on why both the feature info and the platform
status fields have to be checked for CipherTextHiding feature 
detection and enablement.
- Add new preperation patch for CipherTextHiding feature which
introduces new {min,max}_{sev_es,snp}_asid variables along with
existing {min,max}_sev_asid variable to simplify partitioning of the
SEV and SEV-ES+ ASID space.
- Switch to single KVM module parameter to enable CipherTextHiding
feature and the maximum SNP ASID usable for SNP guests when 
CipherTextHiding feature is enabled.

v3:
- rebase to linux-next.
- rebase on top of support to move SEV-SNP initialization to
KVM module from CCP driver.
- Split CipherTextHiding support between CCP driver and KVM module
with KVM module calling into CCP driver to initialize SNP with
CipherTextHiding enabled and MAX ASID usable for SNP guest if
KVM is enabling CipherTextHiding feature.
- Move module parameters to enable CipherTextHiding feature and
MAX ASID usable for SNP guests from CCP driver to KVM module
which allows KVM to be responsible for enabling CipherTextHiding
feature if end-user requests it.

v2:
- Fix and add more description to commit logs.
- Rename sev_cache_snp_platform_status_and_discover_features() to 
snp_get_platform_data().
- Add check in snp_get_platform_data to guard against being called
after SNP_INIT_EX.
- Fix comments for new structure field definitions being added.
- Fix naming for new structure being added.
- Add new vm-type parameter to sev_asid_new().
- Fix identation.
- Rename CCP module parameters psp_cth_enabled to cipher_text_hiding and 
psp_max_snp_asid to max_snp_asid.
- Rename max_snp_asid to snp_max_snp_asid. 

Ashish Kalra (5):
  crypto: ccp: New bit-field definitions for SNP_PLATFORM_STATUS command
  crypto: ccp: Add support for SNP_FEATURE_INFO command
  crypto: ccp: Add support to enable CipherTextHiding on SNP_INIT_EX
  KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
  KVM: SEV: Add SEV-SNP CipherTextHiding support

 .../admin-guide/kernel-parameters.txt         |  10 ++
 arch/x86/kvm/svm/sev.c                        |  68 +++++++++--
 drivers/crypto/ccp/sev-dev.c                  | 111 +++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h                  |   3 +
 include/linux/psp-sev.h                       |  44 ++++++-
 include/uapi/linux/psp-sev.h                  |  10 +-
 6 files changed, 231 insertions(+), 15 deletions(-)

-- 
2.34.1


