Return-Path: <kvm+bounces-55525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD3FDB32427
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0EE1A013B9
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C09D335BAA;
	Fri, 22 Aug 2025 21:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lNAMPZCc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1027B335;
	Fri, 22 Aug 2025 21:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897952; cv=fail; b=RuBlJGa3ZO9MJB87v4vkgSKskKcTiQ8FOQ287B+3I/tWNR+mngeD5UKFwngWZFabZfOxmj/8inySVB7JlHttb06Rhvz3/bof+mTOzCeY1t7TK+lNGGlAymXUzl+mvN5xkvo6GUZsPe7HMg2ATIZJrZIH6hqFJ3TWPg9KKTOrPQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897952; c=relaxed/simple;
	bh=ByERF7iTPQTTnu4iA4iw2cljYlr7djOWvmGdzeJlzEU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XzLglFSBnnO9nDXceW3xAjN6DFwz/lKeZJ6eVjEKTk8mzuslJhg9/hek0vwikwGmrmDMM+7e3rVM/qJWE2FoKuDe8+0rb1/5CKhF0tVGJ8UhUWVFgqEtWezCyrG8b+KInPvdF8Qzp3PAKZ3mh0zIra1kvkm/sxt7PigEOHJJCks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lNAMPZCc; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKLsMY4ouIDJLaltD627VWuqNNbI18Kw2cOpbXoAC5VNTBql5d8g9zbVbKWa+7Igef+FpN4uvR+dv6sAuhTxUmpzE2vvTJ0LOdJgoJImbKNKFzNTzuZ5/kafGpje4PM48yYuxHMmx/Jw61lZPBFXzzk5W4PxHaJY0TW0msdZjYd/zB1lnary3En06S4DQk/0oJZhj8ruHHksZzYCTLap8liNSZXOeIXk2PJoFb59RyTqtuSvu2gLR3eXfDgcrk5TwpXtMD0u96xAXRkLRArxjumN6uZ6qGe5IzRRvQtV55lsSvKRkie72bq7D4woasp9839soBoiI8ozh++2mfihig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBqpCKZ2tyL/LOW79yl6DsruDwzsuqQttQZ8pE/5/yI=;
 b=tJZYUCq9ubADUGSenSi0vxlFpI+9c1MUTNKBlqStz80b2nxNF9URH0G8w7FbYcXUed4TqUehkop02qGtiqOFsKQD5Q+KZNbakRGS/Ns0P8Y/SXyog9QDJYg7N86Ydz/8Dds+jPneXAoc8nMvUpxWsLU33OowyAG8qKVDkPCfbYqsjuk/iZcbHICXL1ChWjRepVy8gtDlz3X7hj4jS+qz5GF4BqBT4KjySlPs8w3vs1tIVPw/QmYjUtdLIx+ijfHZzmO/kazkR63hcewfDi94gWhQRu2YvwZDitrpSRcEdZieryFmwg/1nXPzLVoCojpFVn2qjJjZWSw1ZLBnggP1XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBqpCKZ2tyL/LOW79yl6DsruDwzsuqQttQZ8pE/5/yI=;
 b=lNAMPZCcyi4Y/4AsVt+4XvtXfd9qKI/6AZVNoLBnbg32AOTxWPzNkXxa2/Q8nhLmC8H+cuT1IAP54vkaI8QVvkCggdKI/BI3cg8Ii30cul9gpwbkAufj5Y/EvzjeE4bqNl7n82JZZIfzaJWPLN+1/HE7EOc8UMRyy1PmzKcpcsI=
Received: from BYAPR21CA0003.namprd21.prod.outlook.com (2603:10b6:a03:114::13)
 by BY5PR12MB4305.namprd12.prod.outlook.com (2603:10b6:a03:213::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 21:25:48 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:a03:114:cafe::9d) by BYAPR21CA0003.outlook.office365.com
 (2603:10b6:a03:114::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.10 via Frontend Transport; Fri,
 22 Aug 2025 21:25:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Fri, 22 Aug 2025 21:25:48 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 22 Aug
 2025 16:25:47 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH 0/4] SEV-SNP guest policy bit support updates
Date: Fri, 22 Aug 2025 16:25:30 -0500
Message-ID: <cover.1755897933.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|BY5PR12MB4305:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c78e744-26ba-427c-1abf-08dde1c27682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lfV8Fc15FhIKk0yYwZPn3i0azaoNtWUM40oefoP6XqJsky2/mn2+6hvX/jCC?=
 =?us-ascii?Q?3oU/ruy+wehrhJCvz2dj6caHRvoEowACxHFL+rA+D4FfNWxWDNGCCd5O/axX?=
 =?us-ascii?Q?HB1lF53FksyKdGkm8BMkhlsuwbUVZhT7AMngadxc+GDJanEWPIgtvKT/RCi4?=
 =?us-ascii?Q?lpqDQGcg+fVwnjqKYGwDufMDuFr4zsoUDB6ymxZkG5PM2bzo7SG1GlJZyfYf?=
 =?us-ascii?Q?PoS2L68KGIIQlNHhP/x4vz311ZZDq4Gy1ph9u/5K6mxflXUHMkorbmKmDkgJ?=
 =?us-ascii?Q?n4XaZ8KPZKtfEva6qrZbsRZyNtRbpclbV6OK5fhipn+Oms2H7hidQ91htOwA?=
 =?us-ascii?Q?ezWTvFCQ+YOZLxxg03gNugc62iwx5sw2BZW7zkZRpLw4x2A63+ZrJznmp6XY?=
 =?us-ascii?Q?8r+dKyfWpeWQM7hQKPRyKOmaDIkVrDPCB+/cRF/srtCFTfK/B5rJ/VEk0V1Y?=
 =?us-ascii?Q?hMv9X6a4dAF/I3Zla8DnAlj622ljCFGOt6qJEf9YM/2dHgINS9G4pPK/A5Tr?=
 =?us-ascii?Q?Aj82eWjvqZ7/MC9IxfkJ7RrUFD/07ca7B6YvnPK0JbBeVt3o4j5WOLdo4CpP?=
 =?us-ascii?Q?Mo2C7NfbHvSDy5d7qBayjA0Zc5pdUK/fDRAarRXtdRN4WXyQHTqlmg0H4SIF?=
 =?us-ascii?Q?xYw0+RitsAF1HPyYZEe1EH+qpi8l92p/NJ3LpOMAl9ovCWnrZzpTXcih/TI7?=
 =?us-ascii?Q?QCuWENl3QejFaw1VN2nh/sTwTnUb8aXYN24kDKJD17pkNwLPmaWmAvoTOx/J?=
 =?us-ascii?Q?8wnJ+7/yrkkJZQP30YZ0nyzj9WtyKqJREsaC6IJa3GGLtzyy+UgsPyOSpF4R?=
 =?us-ascii?Q?rVLkt2/3sua6UYeUCGZaLt3PhzYQrGQjju6Va0z2uOZT8AVD54W8JSqLME13?=
 =?us-ascii?Q?fumRYGpGUzxmKHBLRQrh4m2VuxR7Ft7ekCmDjfiwNKMwgY4laam7E/GQiGfI?=
 =?us-ascii?Q?Rv1Ni3FVnSVvq6UqflgiFB1h/sbCwpiojfqI571WjqjYBZe1gE2+57gWmsLP?=
 =?us-ascii?Q?gueZATCZmdTBwSnyiIPJtKV7uP0fvfXoP9lR/FGEuH7laKsxLcZc0Qog6bcM?=
 =?us-ascii?Q?2nb4S+aKENh49crYu6WtkwnI7rgWxkVFRZVGfBV6DrBO8Rw+W2WXiZwiBybL?=
 =?us-ascii?Q?6MX2oTnN+d+pyo9ArI90ncv9lwKVoeGjf7lCMiwGG61UduZEkdot41zIgQyD?=
 =?us-ascii?Q?TjM1KG/64HKp44O0anwu7r/xht0JJiLwUUVJB+FyTMUVht/kOqCx5hE8TGUK?=
 =?us-ascii?Q?5OHPIlIgG+DfiJL9tuyiyb0MSFFPzkWfo6vBENOB+hNJgN3mE2wZb5d1wHsj?=
 =?us-ascii?Q?Sc6GvNLlASyv2VPJGynpGbe4TEMln2BopHNne7rHu0QhV9rsPFMoo3A+5zI0?=
 =?us-ascii?Q?x3l6S6vn+tQHQkzZt8o+mR6OYib/mOffzKk/GDq/Nx0Ct+DK+ywEdBOA7O2v?=
 =?us-ascii?Q?DoAoN09IRnb5Th+hneBu/a1y8OiWt9QF9CMKmrkkVOjcPtBROVOaT99CmH6H?=
 =?us-ascii?Q?Psqcs0oFjJKL4f8zcm4dv5cA1ODq+0qYbgDy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 21:25:48.3725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c78e744-26ba-427c-1abf-08dde1c27682
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4305

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

This series has a prereq against the ciphertext hiding patches that were
recently accepted into the cryptodev tree.

The series is based off of:
  git://git.kernel.org/pub/scm/virt/kvm/kvm.git next

  with the added the ciphertext hiding patches

Tom Lendacky (4):
  KVM: SEV: Publish supported SEV-SNP policy bits
  KVM: SEV: Consolidate the SEV policy bits in a single header file
  crypto: ccp - Add an API to return the supported SEV-SNP policy bits
  KVM: SEV: Add known supported SEV-SNP policy bits

 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 45 +++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h          |  3 ---
 drivers/crypto/ccp/sev-dev.c    | 37 +++++++++++++++++++++++++++
 include/linux/psp-sev.h         | 39 ++++++++++++++++++++++++++++
 5 files changed, 106 insertions(+), 19 deletions(-)


base-commit: 82a56258ec2d48f9bb1e9ce8f26b14c161dfe4fb
-- 
2.46.2


