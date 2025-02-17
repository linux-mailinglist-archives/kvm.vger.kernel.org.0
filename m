Return-Path: <kvm+bounces-38354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB7FA38000
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FF151683B9
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8B2216E14;
	Mon, 17 Feb 2025 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O0ChT3zr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6444213224
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787779; cv=fail; b=AsVZWmD+gkc32x5Oa4gV1qN+C2M2U3hm3c+f2iAhf7t9zLKnvttgOAFr0+m7GvyHvyhaRj2V4PHssSicBIGRc9u6TvJ85uAZ2Sz8ByGtddQAh9p+jsfk/1kv3L5tbnG2orW8qay0ZG+YOsAAojKypCXo8cML0AC0at4QZjL9L/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787779; c=relaxed/simple;
	bh=0CJWg//t0SyTU4tEWr7SB1v558adiPiOLdkrmJMIoY8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OzMdAsGK1ck4SmiCQQmUI6cGriFUYO6GMoA6+05gLyS2DMs1/0GRQnE7vkZ+P6iMxEUlq7NtuK5J0CqYrc2H8GhmrGKZzrMwscHhlhv4xkEM5j8sy/hxHh8kGLhRQQ3N7HF71K9OuxohmJU/7wX6yYTWy9vIGEcm0mkCTZKPkjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O0ChT3zr; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2fXeV4UssYqrArv4JL9yu97MtQ+oA0zuwdhH/PzeKK3WASKU7FaRvz9IQyTAL3VKUNYUDVeOprMLUveFeJ30e4zDaSMGGge/97sBh11AhddREY/GQ9x4HUurflDiHgowdnaXxRRzMf/obxPaZn3ROVRmykL+7wRXCcmbaEN5BkCwlrU6lOR2XEbKSyOiDZhZtXyER4AYUaxhkhcFmZVz3bwYM9gKotgY1LBychQ9lUzYzH9/sm0rJ3fldO1TEsMrG4SbrvgjZvcQRnuLEae56csVYPSQbuKeKyKEqzQQH8z4ULkiJVe4WoQgrk/7gRtUc7R5A0IhArnTLFikufueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IB5UiUGM1YMgFW7kLw7lNOfFNHislVBHpZQf6X0mCTc=;
 b=ocDORWjz0/GEiEYYPNJs3Tpq3EJ5ml1uGEnIDV8Ggl5gKFiDClJC7Z+/KAoo1S9y6T5uop28SbiCSXZSFnkQ+/k6K7NGA1taWINlD6pTK7vD5wFys3Gla1D9NOsyW267WD3lQ4KnzhEprv8u03+RvFm3nitep2VBImvYkOzzpRIACxXL2cxYDETs8qLqqmBmPJAGAiHOCRDYMpNvcHhpcizeB5SXbp9Ga4h8MhGG0Aj6VWdWm4ICvt2JIiuNumo+IYERWnpSgG813leuFvlginSESKic/1LsGecbHevTFxzb9qP8mPx9TlQlmyx9tfgbPvm9UCWKLydn3fbtDkG5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IB5UiUGM1YMgFW7kLw7lNOfFNHislVBHpZQf6X0mCTc=;
 b=O0ChT3zrT14S8pQqSUSeoClC8I+/+WdYV/vIn8D/5SiRUb3a9u+rNUSOpvTk9ToXvsUxpbaBpgNLAhBpkC6gCkJ46Kv16bPbhhEMYegogxmdQ9JCOUwlegv8AZ5ER1MBqVx76Yjq+EZwBfukVF3HLEf7r+zzM1n26Yk8gzHFYUk=
Received: from DM6PR02CA0067.namprd02.prod.outlook.com (2603:10b6:5:177::44)
 by DS0PR12MB7995.namprd12.prod.outlook.com (2603:10b6:8:14e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Mon, 17 Feb
 2025 10:22:54 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::6d) by DM6PR02CA0067.outlook.office365.com
 (2603:10b6:5:177::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.18 via Frontend Transport; Mon,
 17 Feb 2025 10:22:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 10:22:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Feb
 2025 04:22:51 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v3 0/5] Enable Secure TSC for SEV-SNP
Date: Mon, 17 Feb 2025 15:52:32 +0530
Message-ID: <20250217102237.16434-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|DS0PR12MB7995:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a4a1dcf-9cb0-438e-52ca-08dd4f3d0a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ScaWq8llJtJAYKhuNGpVMzovYC0b4K97UpgRxYoLfLWRCq33svXw+U5B+SM7?=
 =?us-ascii?Q?Ey1mhWooRDroJewia+Kvi/9cZO4MTtnRcgrVEc0k3fYSv9iZr5mhuwRMHusJ?=
 =?us-ascii?Q?dEdvVDyFszTH1QotrSv1fEjSU3xE2rBfI2Q+N+pyvNm/xgNiTjiER04YA3Kw?=
 =?us-ascii?Q?Vi6Rnw4/xgheqWhQAlgwnDLnnkLKh7sNVAaeNvZtXZNeYZkEfaAfA5uHwmaH?=
 =?us-ascii?Q?mknRTQi5SLmm2xR3M1jyYcodKJ10qZJ2GO4NXcsHv3x2BkSkJQykyzroozTl?=
 =?us-ascii?Q?oGuntJV0DwXe5RauELQw78RBmMjjSgK5c6Kt+GHaQM8ag61u7BBr84ihqKz4?=
 =?us-ascii?Q?ApGUIQiaWEJwtumlkmrQ9lav+wfj3alcwotRjQQ0bGeuWLIT/MmsfUtnWrhk?=
 =?us-ascii?Q?2hZ+xBIcRXg52FLDjuetEjBhSNfYkFgtBXmrclPbugiqN01aI516C6KMuNHg?=
 =?us-ascii?Q?/XoPG3D4QwUpQS+d906qqHWsHAg237gucq/srOHhrsnwajmrJ95V8UIFhA79?=
 =?us-ascii?Q?v6JLKavO1Vrbhng8O9yrwapQJLv6P7dgR+kd1ybliiENymM8qkGk7CHhvkMl?=
 =?us-ascii?Q?7CfaeN10i++cFlY/rWre4Jv5njtV1FLCNGs8CxJ8G9XwJio5zWU07AdCGhO3?=
 =?us-ascii?Q?aibYtsruL6r5AzcmoC7TEdfMWjIMqLcMwfHBxaIiEGmWYZdQv8+/32agzVJ4?=
 =?us-ascii?Q?kYCvtG1rb+YcFLWwP0W2Bmj+khHWUcoyp+N1SeCl5kMlECw8+tfZBQYi+O5z?=
 =?us-ascii?Q?OUHZoDXjjFDxfm7EoSTz4/WbW7QjhhNr8rSqMg3q+TOsv0xnvfEnpqgIAkAB?=
 =?us-ascii?Q?vL7mxnXMKAdaZadqeqZgNyRBQyTtBLrxaV+i1ujqnEsDkaEPDV0O55JEl2Ka?=
 =?us-ascii?Q?ceyOST5KCC352rGeInXFl7ABG5I67oTBQO/ob3Kc9ajao1jp7O18awW2fO/k?=
 =?us-ascii?Q?prbAMhW2pDdkwgiU+6sqrV4mbrtc6W9Kl1wZymnUmXheYN02i/bT0fX+HKkw?=
 =?us-ascii?Q?bJKGno5DmxClLRebW6mECS45hKv9ZQl8dxrZgt/kCPrLhNL/gQAdsiNH/UzC?=
 =?us-ascii?Q?gsXID2Dc63+nJG1oPTmhJX4h5bsZVvUEQmWNmTf8LGQHe+Y1v02anAtf0Uvt?=
 =?us-ascii?Q?San2Eq0ZPTRj3gfrwRUFMaAHwnm8dalPhIGvQpMpfp5m4zsmTD6V7SZZpTxO?=
 =?us-ascii?Q?d+66ncjxOJF8YtCMij+S2+gxcX8vJmk9CU5mVNKJFhxHYjINtUmvvX0pBUEN?=
 =?us-ascii?Q?xYhMD/r1pGkkVBYCmQLFkbm6uWeLCVEDKwQnPf3LOGRxg2Wv27AeUzcgO5Jt?=
 =?us-ascii?Q?VIihqkskBXgOxrFhejFqiVRphjS4ZfMKPTraY+UUM1UUp/U334UWZ/xHNNrs?=
 =?us-ascii?Q?6rFIxyAK+2UM5/3cTGRqK2feeZf/28y9rH/fWq0fNs+p7HVHA8uG5nDHiNby?=
 =?us-ascii?Q?s7Im4Bql3MgrVX8O0pYguR/R499EItpaonhOdAX5MIL2QNE/xIexbEwWwIwg?=
 =?us-ascii?Q?kiIYaN3W7odZ1E4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 10:22:54.2732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4a1dcf-9cb0-438e-52ca-08dd4f3d0a77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7995

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

This patch set is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

and is based on kvm-x86/next

Testing Secure TSC
-----------------

Secure TSC guest patches are available as part of v6.14-rc1.

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU command line SEV-SNP with Secure TSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v3:
* Rebased on top of kvm-x86/next
* Collect Acked-by
* Separate patch to add missing desired_tsc_khz field (Tom)
* Invoke kvm_set_msr_common() for non-SecureTSC guests (Tom)
* To align desired_tsc_khz to 4-byte boundary, move the 2-byte pad0 above it (Tom)
* Update commit logs (Tom, Sean)

v2: https://lore.kernel.org/all/20250210092230.151034-1-nikunj@amd.com/
* Address cpufeatures comment from Boris
* Squashed Secure TSC enablement and setting frequency patch
* Set the default TSC KHz for proper calculation of guest offset/multiplier

Ketan Chaturvedi (1):
  KVM: SVM: Enable Secure TSC for SNP guests

Nikunj A Dadhania (4):
  x86/cpufeatures: Add SNP Secure TSC
  crypto: ccp: Add missing member in SNP_LAUNCH_START command structure
  KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
  KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 22 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.h             | 11 ++++++++++-
 include/linux/psp-sev.h            |  2 ++
 7 files changed, 53 insertions(+), 2 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.43.0


