Return-Path: <kvm+bounces-25322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 890AC9639F4
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010B31F22D8B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B3B1487F6;
	Thu, 29 Aug 2024 05:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="shafzmfU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5451487D1
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909891; cv=fail; b=MBIB9kJafNOKs+izufh8NZQ0QB8fKTwooInoIq52lp4AP/yxqJtxvp/o9HOCWWPT+glqZbGyEf/1ziGLlWB0QH8uL53HcuwSC9hysl7+yZURt976kLv98R9vP/jsiDxGiCpdU04EI+PeztF2M62scKMEkJJ49Z7ygyk2NAJpCU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909891; c=relaxed/simple;
	bh=WdP7jaVi0RxfCJ2QK6puPAkK4ypQEvkEm/h94QnOjqU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L7cR7YIU74fvTtW/pUEeE5e3+FN0OnkujWEBxjTJ/RYidk4UA7w0DI3OEJPi693PMaX1tffDq2Drc0c7CGjVzcmCyDQidmHU/TWIHdl3EEG/SuSzS0qWB/treAQNO2OMiKSrYPQF8BkUNfR3mPaIOS8dDhlcGtrSvkCqMdf+3fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=shafzmfU; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PceIRMROELTgOT7X20ocAJmEfqNJnxkM/zixi+EVvQgbUrh0GAJzo761vL6DnizbBcHbU5gzSf+SRQNvoSmTpur+A90MgW4QHVolZw9/y/wkUV9UHT9WgMQsvpKZLfbuZofs8lWWZx8sT5NlHWTNOmSf4ixrkTP4Cg8vd/WyM0BwDw0p87BgTuU6efk6dKkE3frt4LIIjiNZuYgBTquvZFFGhXNA+sJk3B/JzoAx30Kcrvib77xO0h/bnNNsN+yq9315Y8s0LAUdyDEaMfxcXbZrQZ6YMKd6ZAKa7SAe8ua09fYht96Q6O1ciECjHYmcnSL/ANPm15jldqAblPRhQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMxFsNLQ+WnBE+cd2r1x0r0xfYRF08JRY6Ue8ikyQaA=;
 b=sE3oMAFGBOHY4fZxWpO1rBeAFhFeTZfzx4FHoTJUMJYGRn51Zb32blwNE993uowN9LTHbf7Oz+gePA+t4DdXzh7aQUZvYar3IXQmvEqAVYKDf7vj+vJk9hRqIViF7gvdWwabmwJiNBP1BpcMR2UGPVmuEZ5VGs/68flMbtg2FAOXUK5VjWTyMpqGeVmquwB+BcDdpnq43MOfeQQS1ZMKb1fQfkihedBrSmt63TEDSz3gzHZfdhIaudOBpoxXnkXnD7Mho0Tlb3zI9uHYLhFmvBsSQQaA6sQrs75g++LzZctLM/rx77gt8sCeiHljQTg2y8HqL2PjVbED8kWE4ZceOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMxFsNLQ+WnBE+cd2r1x0r0xfYRF08JRY6Ue8ikyQaA=;
 b=shafzmfUYr4UUiLkAkKENvdnvMAWfjzbflJRd5wcri7qsSksdYFR3Olf48X+EfrtSz24MPZG6f9G54X0QOrYh/z/SKDyYWDRuWROQi/R6xauMQcaM/1V07B8F+1uUYEXFeEIdzmGs/xbT3cozlJN8KpcLlHuTi6dBclKgjn5zl4=
Received: from SN6PR01CA0009.prod.exchangelabs.com (2603:10b6:805:b6::22) by
 CH2PR12MB4293.namprd12.prod.outlook.com (2603:10b6:610:7e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.28; Thu, 29 Aug 2024 05:38:06 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:805:b6:cafe::10) by SN6PR01CA0009.outlook.office365.com
 (2603:10b6:805:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27 via Frontend
 Transport; Thu, 29 Aug 2024 05:38:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 05:38:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 Aug
 2024 00:37:59 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>
Subject: [RFC PATCH 0/5] Enable Secure TSC for SEV-SNP
Date: Thu, 29 Aug 2024 11:07:43 +0530
Message-ID: <20240829053748.8283-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|CH2PR12MB4293:EE_
X-MS-Office365-Filtering-Correlation-Id: f6746b71-ac1b-40cd-3916-08dcc7ecc276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t1oc0qUt8fe7r0YRLSiT7KYqLEwwNMF8UOoPLgK1Fp6AhGtVYDkWjbmgJUKo?=
 =?us-ascii?Q?J9SZouJtBahGlWJedxnxIU9IaHsSVFeYzXy0D0AGJ32yugjAXjr4JAZPDJNU?=
 =?us-ascii?Q?j4DzKuJDLj8YcUYBnjb+8+O0ETtYU8utxf6PD3zddBV8BnJSM6VD00xJzhOb?=
 =?us-ascii?Q?iWo4oZYAFuApx+yBWlihZBB3qF/9LvSyQ81l6eEzNuIIxJrQ1II5RfwXXaNI?=
 =?us-ascii?Q?+KaiDuk3yZuit4hKLfjsTjwl0OcvF3DLmLdOchyt+16qoP51bKGPDZUgGJ5B?=
 =?us-ascii?Q?Dw/PjYisJBwxCk3qJJIQwYKlXGHUewxSHbhocbFj9xTOoBYGcsBAWfzOSycZ?=
 =?us-ascii?Q?A5SeXFoOiIawAwATTC5wwxZuuSyLRsfYgpZQ0caU4o8F1PK0Of8pI92bRIb/?=
 =?us-ascii?Q?s0gdsExlCV94UF7rVRbpI/OCYKPklU0KzDw5mH4f/y5+of2MjSgF4wZmQ76k?=
 =?us-ascii?Q?TtyfR2lcTCsXrAwAh9jCwebFsXGF4z/TWiniL7OdGKCsKqOCBxibCfqDLSSf?=
 =?us-ascii?Q?lJeskpi6LKztPIJQNMH67hFae5EM2qBWxt3lTpB2knOKLlkpLTrYcQGRWvr9?=
 =?us-ascii?Q?5MhuGMUj9mklLmvUSzHWzLUe0bzPX2buob4pVYaj7FUkDRXT572hVTybsBUM?=
 =?us-ascii?Q?sqsC0oUVsXTZVYL0Gv9Y2B2w1yQTOyEsx3019XsymcuJ0TVG93TI0RRw41iT?=
 =?us-ascii?Q?saDiSzHgr5YKHmFFjDrxJ/Oyu9rgpGsn/jykWBB2QnT7vio3kKrf3fJo1FL3?=
 =?us-ascii?Q?XJu7kreVlHE7DgRv5HTszSOagP+gFJil7rkEo6MGcjJ6U0rxV3NOePMwax8I?=
 =?us-ascii?Q?GeirgrWpXduTSaBocM6IRk+9WsIpDfJ+c5EUxOw87p8WzlT7uBjXL6Ax9Zxv?=
 =?us-ascii?Q?mJBGhLKW7m/5ZfAap/HjZDbC3CbUkKvbAMiCz2CD+VXGlNzYGt1inhtR0tN2?=
 =?us-ascii?Q?yhdm9iD42a4NWH2QWf3lXrZl4NJ22uCRm/N54ausuGV78zHmoMQoV8I3ImKf?=
 =?us-ascii?Q?Bcu0K5bo/1jn9cMb8LiXxM/o8y/tcf/grDjW8LH83Md4ev3Bt1+NcH6b01yb?=
 =?us-ascii?Q?2lvenTmOA7Pxw937zJQDSRaYoQ4U16uVE7AoH/Rbdn9C9VNZRAsUTB0kxlz3?=
 =?us-ascii?Q?XyFsY5SP3D+ouReKTx31pD+MVYjez5l4E79BnmCDx4aH1ggD12ypz+lP2VaQ?=
 =?us-ascii?Q?A+Skw3jwliYj0u+zuxJdaeiyrV8YBA54xb0v1FgCSgSxCVVbDEkG0Tq9MkXy?=
 =?us-ascii?Q?2+MlctZVrz5tg1drhv85aMlF9pojfaQXiyAeQqL3LZWVq23jOFr1dUu5trbY?=
 =?us-ascii?Q?9O+vMmR1sTuj20bgxl705WcNkSyJNayjaLHYQBlQuH5XAdh7PfyjFcY6cQxC?=
 =?us-ascii?Q?hJd+uDCTGpvDUu/M/QQeM0TjpGG86gOddMtAngT5EDFihiZRQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 05:38:06.6786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6746b71-ac1b-40cd-3916-08dcc7ecc276
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4293

TSC value calculations for the guest are controlled by the hypervisor. A
malicious hypervisor can prevent guest from moving forward. The Secure TSC
feature for SEV-SNP allows guests to securely use the RDTSC and RDTSCP
instructions. This ensures the guest gets a consistent view of time and
prevents a malicious hypervisor from making it appear that time rolls
backwards, advancing at an unusually fast rate, or employing similar tricks.
For more details, please refer to "Secure Nested Paging (SEV-SNP)" section,
subsection "Secure TSC" of APM Volume 2

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

and is based on v6.11-rc5

Testing SecureTSC
-----------------
 
SecureTSC Guest patches:
https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest
 
QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
 
QEMU commandline SEV-SNP with SecureTSC:
 
  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
     -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
     -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
     ...

Ketan Chaturvedi (2):
  KVM: SVM: Set TSC frequency for SecureTSC-enabled guests
  KVM: SVM: Add Secure TSC support for SNP Guest

Nikunj A Dadhania (3):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Add GUEST_TSC_FREQ MSR
  KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.c             | 12 ++++++++++++
 arch/x86/kvm/svm/svm.h             | 14 +++++++++++++-
 include/linux/psp-sev.h            |  2 ++
 8 files changed, 47 insertions(+), 2 deletions(-)


base-commit: 5be63fc19fcaa4c236b307420483578a56986a37
-- 
2.34.1


