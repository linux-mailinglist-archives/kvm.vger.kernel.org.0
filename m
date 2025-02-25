Return-Path: <kvm+bounces-39177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE26FA44E25
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF8BB17B2E3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797A920F096;
	Tue, 25 Feb 2025 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o2WuwRBV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE93220F094;
	Tue, 25 Feb 2025 20:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517190; cv=fail; b=u4w3sO+c2GTi1kCaPoDOGScdMqrs82Ns10gK11ybmkHQiC4A0ipMLUcTpYcgD4JSk9CW3HGgt63QKkQojGB0hYe52xguzED1gZxfKOCZzei98/rqg4BoupUHR77+kp+c3q71Riv9i+0wHuzWED70J7YvONZXTKNNA5Va4/gIv08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517190; c=relaxed/simple;
	bh=xzwQZMEFXII+TDSG3NyHaqSkqapTgmQTgy9ge4RIcfU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nFP6B5mB6G4HpOh5Q5Vsl6T68PHTIysvCGEguNsOmGpIH6x7oKXB5rzJutQgX1AQ8ksp19s9RgPCZQvorBVM4RqmhrVb6PHGZLKLyqNa+sqE8549WiqGsAPKi7SUrpmvQ0lYjog0K2cffJ5ygexnNDo5BhcOaHOb/bPceGoRnuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o2WuwRBV; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LG6Il13U3DI3N6t+IYWSPr27udqyRe02KjXBlw6IBCQZILBMT5pG78B1sauT6/tDXguU6ED2dDZk8gUSYRMfCfnK4ROp9ORvqJ5y8Ga2g8FPqj1GsyLyEyUGXv+wHJtNYGCAbcxrejMuJ3FYPe5PVxvuJ4skxHyyPZ+x0k6EWRmeiMr27NzBeDVz21tofRBvLMsEJqR1asuRqkn3i0bQ08YSd4iGoW0Z0gJiDq4vXD4ju7Pcb5MT4y53R1w0J3aa3k1GyFYWJS5e7ewtRoB1H6jBnPOA+o+1hHG16VNj7f7YdCAyGTrWJ3nANDpJPBirjjGOz8+86xNJO0aYMlZt/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqaLRWR6+WuYx8imf/6yFnrKilQAc0iF9LQxjK5Yg/I=;
 b=IqBOCwFsizeig7cK7tDDgPDmbiYeedj0971AcYGALHHzdvMKk4GNv3zev4tyou03qvci9l0/5iYAf+r3zGXvEDRSsD6GvLNzGrSCbjJQh0UKE6whZY8WZT4UXJIeYCtdoQZ+eqmYbNK2ivn8/GmKq/1CvU6t4dplai/s00E9IA4kDTCUcr9SKzyIro98/4hOAyrdO0nqoQZbf26oB06RXrnAHzd1Getphv+Doaujm2apLnl7Gv5VzOY8cX06H1HyBkIKueW0vLGImMCmeizsXIxY3arMtyfsgjO8Fza2qcpFzbYiMNrqlBifFV38JXbiEuPH6raJfUkc0wIZSAeleA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqaLRWR6+WuYx8imf/6yFnrKilQAc0iF9LQxjK5Yg/I=;
 b=o2WuwRBV1/vdC0MYx7T51JSilP0Pt+vQsMiqvb2VwopvZ/o+h1CuM6hBaUqjYg3JG+JVE9m0Yzl1DaO5dcyWuO+gkW5df2SotNpX/AeUHk09/OlCd2gUo6dselaqIODLaFw17oNLtkBDFx+LUtcFYxVW6G01/MTP4yQt562isTs=
Received: from BY3PR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:254::14)
 by SA1PR12MB8599.namprd12.prod.outlook.com (2603:10b6:806:254::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Tue, 25 Feb
 2025 20:59:44 +0000
Received: from CO1PEPF000042AB.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::44) by BY3PR05CA0009.outlook.office365.com
 (2603:10b6:a03:254::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Tue,
 25 Feb 2025 20:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AB.mail.protection.outlook.com (10.167.243.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 20:59:43 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 14:59:42 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 0/7] Move initializing SEV/SNP functionality to KVM
Date: Tue, 25 Feb 2025 20:59:31 +0000
Message-ID: <cover.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AB:EE_|SA1PR12MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ce20c92-ffdd-49c7-72f1-08dd55df542f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XUue7HW7UmE3CkdyM2rVdbRUFnxBHNpmqP8wHBbFTsv8UVve27eJ7DVP6WJ7?=
 =?us-ascii?Q?bFxRIb0EdFFgHY0L8rogi0uB7X4HcFJegEb0zzOipIxxKtBfImr3YonYM3Ya?=
 =?us-ascii?Q?4NbzcAs60xS0gQsqHfXr1Iw6j09xuZZQtN0mvAqNPeBIYfh2JKoIEQUmlsKY?=
 =?us-ascii?Q?AoNj6mE2cIvm/vIjyyVbaPLQk4PSAmEdVTvEDu7T8tsWQhiuMe8WQyeyQeuC?=
 =?us-ascii?Q?Iv8t0F1a4eFQu0ZCIDdZrVjmotiWMCkRdvKcxhQ4Ueuii5j2Xi+xoVJctLBP?=
 =?us-ascii?Q?gn5yQD4nryn6qtVHs8juAQLr9semxYc0e7JhX5y9rbBe3jVIyUhEK/p2t7JK?=
 =?us-ascii?Q?smm+O7uKL7ecFTpW3Rv6AlfvY+nOe8PkFYH42a9jOrqpHuTBdYOuhv/SQPCZ?=
 =?us-ascii?Q?Na9w3iHDBvAz2q7hblBeXdj4N/dsIBq9bczs63191EH1exp7WBQzzAmFu6di?=
 =?us-ascii?Q?iwAj8AI/cJ2RBJkQUnxjN0wqa6NxT/yAyOc30bmzecnuN9mtLnzR55DYSPk/?=
 =?us-ascii?Q?lTLJu4Ar+YqAa76wLK/64pQS4qv2eyiTJxL+F+tiLXHu89mH1Tf6Rr6tYU3P?=
 =?us-ascii?Q?06arclOKVlYfL3Tp7uNrtcZmo1qAhBGVG7RQREHQWySYJPoaiwH0FZRDDOnn?=
 =?us-ascii?Q?6Qup4EzZ3bslHkZPzH/5b6MLMtHjUvwoN/iWcS7KbRirsa++ps5t2H0dy38M?=
 =?us-ascii?Q?V6iAnZ0o5oj96ag0CLMA+DkuzN4wsBzHS/Vr78XKFHja9hhYN9IOAtpoZX12?=
 =?us-ascii?Q?eGrvCI3xtMbpn91As6try6VgC+eohWSTd557OsExct5/wRFq6ZJC4oH79va9?=
 =?us-ascii?Q?rYDvYKez+a4ebFBR4Vs+1hs9FT81Q/FdlDS84sntAACRxZ0hsA4dfiTjyx+H?=
 =?us-ascii?Q?CYRkCUb5TtqYjuo1tqGLPh/7usPDycJTe8FVXZuCaA68yLNA7oxJ9nOw6l3Z?=
 =?us-ascii?Q?J6Vpr24Ofurz+AUb6cg5g7ybSRAaKbRYuCXhnUGZK027eI5fvM//kHuXyQvM?=
 =?us-ascii?Q?RuAXiiBUPeB0rm+ILCh7DrYN534J8YtSG4YU0HfB4nX6+3e+wUWuZNz0jUM5?=
 =?us-ascii?Q?3zHPpxbBdBkk3vwvRtpfq6r0VAVEjLde5/2ca2YEcl3oq0ndoM7O+iHshH+g?=
 =?us-ascii?Q?AKQYjugGQ9yh/7SW2cpdlFC0RZFzAOf4MS7Xb9Hv9mfe92kE1S+1SvozXFLI?=
 =?us-ascii?Q?9OEhGcNWyq24RSXt1urk5LKt6nEMRch94dZmBe44RDOv6vx/JX0Vz/1A/F1G?=
 =?us-ascii?Q?+AIvyyR0CGx61RfuTOBukZ8OYCYkC2gjeQQa2rOC9o16xOM7vrbd8Se0Hrpi?=
 =?us-ascii?Q?723EU4f5MQwR+eAoov/FMs8uVJ1I5c6yRwqOp4JfA4rlsgw3s3bvq9LtDrGV?=
 =?us-ascii?Q?NF5hd5BO3w4zdla5Jwctk1jTvkXTp5/FZXde5Qt46lby8YXFE/XCr0w9/T33?=
 =?us-ascii?Q?dsn0bbyjupKrvAKI+Y+cXsmVdKbA5Wqm0GRuMJEiEr6EEm2j3MWxjWJiIDER?=
 =?us-ascii?Q?S0W43OuCArW7DYXOcB3dK8clu8C4W21TzRUS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 20:59:43.3223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce20c92-ffdd-49c7-72f1-08dd55df542f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8599

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

v5:
- To maintain 1-to-1 mapping between the ioctl commands and the SEV/SNP commands, 
handle the implicit INIT in the same way as SHUTDOWN, which is to use a local error
for INIT and in case of implicit INIT failures, let the error logs from 
__sev_platform_init_locked() OR __sev_snp_init_locked() be printed and always return
INVALID_PLATFORM_STATE as error back to the caller.
- Add better error logging for SEV/SNP INIT and SHUTDOWN commands.
- Fix commit logs.
- Add more acked-by's, reviewed-by's, suggested-by's.

v4:
- Rebase on linux-next which has the fix for SNP broken with kvm_amd
module built-in.
- Fix commit logs.
- Add explicit SEV/SNP initialization and shutdown error logs instead
of using a common exit point.
- Move SEV/SNP shutdown error logs from callers into __sev_platform_shutdown_locked()
and __sev_snp_shutdown_locked().
- Make sure that we continue to support both the probe field and psp_init_on_probe
module parameter for PSP module to support SEV INIT_EX.
- Add reviewed-by's.

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
  crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
  crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
  crypto: ccp: Reset TMR size at SNP Shutdown
  crypto: ccp: Register SNP panic notifier only if SNP is enabled
  crypto: ccp: Add new SEV/SNP platform shutdown API
  KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
  crypto: ccp: Move SEV/SNP Platform initialization to KVM

 arch/x86/kvm/svm/sev.c       |  15 +++
 drivers/crypto/ccp/sev-dev.c | 239 +++++++++++++++++++++++++----------
 include/linux/psp-sev.h      |   3 +
 3 files changed, 190 insertions(+), 67 deletions(-)

-- 
2.34.1


