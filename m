Return-Path: <kvm+bounces-34541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB63A00EAD
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FF291884A15
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 19:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A921BBBC5;
	Fri,  3 Jan 2025 19:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v1iV7Dg/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8670189902;
	Fri,  3 Jan 2025 19:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934360; cv=fail; b=nbtmfFG63fs2ujefbsXfO2wr++kGy4eyoTp6O6OorVITD+xFRzfqqoEvYSUO3lMo8fhWUUHatWVDswdOSAms1kqVpr3kKDwV9TV9xr+5mzc2JJ/Ge0bUlMicI1KnINXnaJzX/DSojv8OBIh9T/AkwJLEYZCvwwXQrgZU00XbIeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934360; c=relaxed/simple;
	bh=pMV0z3Vd95WN2yxF9L4MOezJ4Y9oZqch6RNz9tVJWjw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kR7Z9C81lhUQvxNtUDTWWMIWjF00Fklxpn86/i823Nwt+AnbFZYwjUkVNBPleBPxWQ4TpX5meGLF78l6stKo0ayS8Qcnzl931xEmbh/bkZNpatMEz4Ucg7tY+bC1vrx3Rgub9nF7rm5fYfMht95UFwma9cZ33Ui/6NM+OsKbgmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v1iV7Dg/; arc=fail smtp.client-ip=40.107.100.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zl+OKLU93ia+31Oi1yo1/X7bkyHmChFQ4rJcSQj1pwpF2BpW+iGeElpSwhWJ50l4xojAE8jix0Ubioy5u3b9F57BbVdDhvbxxFFiJ/owAff04dj0CbM4nOVGjRmZy3OjkvCeH6ZlqvOe0XruZs6oAfea6Jtkowr5zx89fM3wreeMcpGBhQIza+jdcJ/QZ62EpqEE2+Iawbj7X1zqEYaW/K4ScpVne0B+fv6YzsDIuCW8ffNIk2xlro0voPRaBYawJfW9NxqbW+vGyWdZSdrYxmp7Xq/IulKQ1+IXELroYvUZXuXcB4cZEfiqQSbITjyPW34eGZM+Ln2YvZIODHjQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c57atcZs5nhVP/B3r5R0jtMiE90xZYDFB+SMxZ8Yuag=;
 b=u+1IPV/WlD8PxaUxFIFJtk1AKIF655nK1ARdA6g4tRM9ZkBRncEhtgw8F+Ly9fVau7s6xp9W4/VRi+6xBxbkfWzLl4UZ7qiy0yvLGPQ92ypLnJ0Je6dbOE5oD6ooD+574PseIEnhtK/Kx4CasK3vYM67e5PmmX1XdDxF3gRQWEm2QcXdoZn/zdffVe1yVCaSZ51w/GnXgrjNCuADfzOZzwr+KaPNXE9xGrL2gy5n32MlVyDcQbNpoIVFl9bBE+bl51IdajQEugQfWMQ5cX+HqJQZZWRt95J/VekEpdemO2jJD/Z37C5BzkyeVoZ2dHl6xE+R1AiFoxEIUWjnXKBjAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c57atcZs5nhVP/B3r5R0jtMiE90xZYDFB+SMxZ8Yuag=;
 b=v1iV7Dg/Oh/Jmm1xztlrFbwS0yW0zPLiY4UqKEogpWxQKDrY+dZOZ1fwg1s3/14TbrqtbGJH5HGySUksGyUhMT0cAdnfEuJBdVPIA2MwXSBIDXUAaDi5VU+BWCufAf/ngdMFP+Vu9/0SKdKdXwjYltJkHPRXdJHY0/Z2ng2BCLk=
Received: from MW3PR06CA0011.namprd06.prod.outlook.com (2603:10b6:303:2a::16)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 19:59:11 +0000
Received: from SJ1PEPF000023CB.namprd02.prod.outlook.com
 (2603:10b6:303:2a:cafe::ce) by MW3PR06CA0011.outlook.office365.com
 (2603:10b6:303:2a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.14 via Frontend Transport; Fri,
 3 Jan 2025 19:59:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CB.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 19:59:10 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 13:59:09 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 0/7] Move initializing SEV/SNP functionality to KVM
Date: Fri, 3 Jan 2025 19:58:59 +0000
Message-ID: <cover.1735931639.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CB:EE_|PH7PR12MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: f1453292-fe53-44fa-0ed8-08dd2c311724
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V5hrJhjlVtG5IFrSCDRnYZDhIP3k0qLlbc7iorCyWQ0FwKkdKpv/4NpYt1Un?=
 =?us-ascii?Q?LEpGHJrKZgCxy+ewsH9GNzJL/dXa9Lnb1HehhUc+ElPXDpi0a35v8iparrrU?=
 =?us-ascii?Q?bBj3NIUraSeEepsZxGcoRFuhr9O6bUBK5droFTxK3yulJ0BAZVh4mzsSEtrV?=
 =?us-ascii?Q?nNGO2EyJAHKWK8L4MW4Fx1ktBIB7/b18Zmbg6RKabvLtqYti6glUggL+EMSo?=
 =?us-ascii?Q?9HMgv7mLlXXTU203OWjuT3CcHEHXG2me4VdVE5J8MDw107/NDSkyX+24sC/H?=
 =?us-ascii?Q?oVmslgfUkri5lcOInooHA/QYkrljIHRv+H6Y5F5eooy9eIoJQrkJFopOOkdt?=
 =?us-ascii?Q?KoS9eGaENh3KWsMP8FV1tht6YTSjtCFP7gsepZtUFuBNSg21bc+sSA8D9M/y?=
 =?us-ascii?Q?utx1wtrPfz5W/sF0we7n0ZyNl7WC8cKDwmhdxkEVjfzzGBDZjW6dgog7svLQ?=
 =?us-ascii?Q?33nto/hMLMhxLp0zNBY24hE+ELMVKeR2W/4zszFkj/IJoVFTPMTbdJOnp75C?=
 =?us-ascii?Q?EGAFmu/93lIENK2TUChJwRMVlkI0a47sKDRhbApgPlTt7T6qEW5y37H7hksa?=
 =?us-ascii?Q?o35zTHgn1rHaiou33aWR/mc1CGLIer5FsyAIBaQkY6GEFZPypuQpknZ+g6F3?=
 =?us-ascii?Q?T0+amTySdnAHrwrJL0YRoj+hdoEszsa8PH2mA5RslI4UtJSKAwGq+AocaY1L?=
 =?us-ascii?Q?en2rB2yL36dCN7+VxIyZwaUg+FVk5P994jo2XKqxuqrU2P/NrmmAuIahSutk?=
 =?us-ascii?Q?AwWGZQDnwo0CXrq/dW/C5PcitgfSMeWnWhIDg0hhUsWb4acQoqgVIEAxnfvt?=
 =?us-ascii?Q?dOAPc9wXLGBSORzhkLToSINszDAQKeur2wwRqj9xMa2r+To7NqyUaG/+qTmn?=
 =?us-ascii?Q?c6p23Dc3YPSjZ/k1qRp7gdSdv53KUfG04q/jqPOUd9U+tchRzmKxQEqYxsHh?=
 =?us-ascii?Q?EtWEcGB134fDDezsgMMidCbEBCqGGDuTaCmpyB6Apxkxfa9sa2kavO72aLJb?=
 =?us-ascii?Q?IEfiMmGposHd76HXRqQW2tH5HlKb4uTyfAqZBJYlPDU4ve2WH6NVujmWKzB+?=
 =?us-ascii?Q?5mZ2Jiw4Ym6d6THA+AICLVlalB4eFspEvVglF1to6let9eDNksLhZQcBbWVR?=
 =?us-ascii?Q?4mPiZBT1kL1nBfPYtWGVP97ul7v7GvHHJVS9QGiTIqSdP7xXweh7ka6XpFbX?=
 =?us-ascii?Q?IrzaOxJ7L4ZwBKkO/03AGvtJtVR48rLevCwytjXaKmOofzUn9dhsN1SxSOed?=
 =?us-ascii?Q?vHRRTCnFYxL0zISm/0kNJ0NWHXrJrbHLOT+tgKcJzYx9bpaN3ZRptjU49NNw?=
 =?us-ascii?Q?y2zQI/skKCI/JUiZ2cWeDgrXNyP5QE/Iov6lyKOIyG210H8WZv+f3crg9Hrm?=
 =?us-ascii?Q?jaJiojGSBL5UUrheQpAKne2yBrDnw2xiNtSacSBayiJFYFkTTSMFuTnUJJvE?=
 =?us-ascii?Q?eGtfNBws+RpZDsPmTy3X1dCYMhBTrN8o5/TEOSCMIxLcc8b5yqLcf6inmCcv?=
 =?us-ascii?Q?z1Z8iIm2l9y7p8FFMDVnkPkzL9nipk11cUJe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 19:59:10.8174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1453292-fe53-44fa-0ed8-08dd2c311724
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596

From: Ashish Kalra <ashish.kalra@amd.com>

Remove initializing SEV/SNP functionality from PSP driver and instead add
support to KVM to explicitly initialize the PSP if KVM wants to use
SEV/SNP functionality.

This removes SEV/SNP initialization at PSP module probe time and does
on-demand SEV/SNP initialization when KVM really wants to use 
SEV/SNP functionality. This will allow running legacy non-confidential
VMs without initializating SEV functionality. 

This will assist in adding SNP CipherTextHiding support and SEV firmware
hotloading support in KVM without sharing SEV ASID management and SNP
guest context support between PSP driver and KVM and keeping all that
support only in KVM.

To support SEV firmware hotloading, SEV Shutdown will be done explicitly
prior to DOWNLOAD_FIRMWARE_EX and SEV INIT post it to work with the
requirement of SEV to be in UNINIT state for DOWNLOAD_FIRMWARE_EX.
NOTE: SEV firmware hotloading will only be supported if there are no
active SEV/SEV-ES guests. 

v3:
- Move back to do both SNP and SEV platform initialization at KVM module
load time instead of SEV initialization on demand at SEV/SEV-ES VM launch
to prevent breaking QEMU which has a check for SEV to be initialized 
prior to launching SEV/SEV-ES VMs. 
- As both SNP and SEV platform initialization and shutdown is now done at
KVM module load and unload time remove patches for separate SEV and SNP
platform initialization and shutdown.

v2:
- Added support for separate SEV and SNP platform initalization, while
SNP platform initialization is done at KVM module load time, SEV 
platform initialization is done on demand at SEV/SEV-ES VM launch.
- Added support for separate SEV and SNP platform shutdown, both 
SEV and SNP shutdown done at KVM module unload time, only SEV
shutdown down when all SEV/SEV-ES VMs have been destroyed, this
allows SEV firmware hotloading support anytime during system lifetime.
- Updated commit messages for couple of patches in the series with
reference to the feedback received on v1 patches.

Ashish Kalra (7):
  crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
  crypto: ccp: Fix implicit SEV/SNP init and shutdown in ioctls
  crypto: ccp: Reset TMR size at SNP Shutdown
  crypto: ccp: Register SNP panic notifier only if SNP is enabled
  crypto: ccp: Add new SEV/SNP platform shutdown API
  KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
  crypto: ccp: Move SEV/SNP Platform initialization to KVM

 arch/x86/kvm/svm/sev.c       |  15 ++-
 drivers/crypto/ccp/sev-dev.c | 239 +++++++++++++++++++++++++----------
 include/linux/psp-sev.h      |   7 +-
 3 files changed, 190 insertions(+), 71 deletions(-)

-- 
2.34.1


