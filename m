Return-Path: <kvm+bounces-10596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2174186DC60
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBA7B28C1A0
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ADFB6996F;
	Fri,  1 Mar 2024 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3wQgW+ct"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAD4692FE;
	Fri,  1 Mar 2024 07:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709279434; cv=fail; b=Ait4IL2h/gqZ3U4spuRJxjVC/vzdpiYWVd2iZLpXIsVuRwVJ86rz/gn/Mnnw+TvWxIYDvx6Oy84a+zUuQObU6zOcZoOPUmN8aiuZGYJ0n/0E9to1IMBWQpZRqrgbEiUCplHEB1fSZMRyufJDIgOKmAqLNK6NREnlkqKTRZ+UyYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709279434; c=relaxed/simple;
	bh=asHjvHZ+MtMOQs+r9EhoePP9uBWoCcXH4URMJDXF1so=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EHHuyVybX7DiU7cJINkIRg76VAURQXcdKOuMwIosqL37HX0kze1/kND/c2IYQI+G7gEXtmSMlSwEfX5GD7lzaffBn/Ze5LZF42vJtPMsf7J1RISQyxos+bmr+k/XWD3vGuVyymfuc+vWZ6BIXiE6ilp38z4LpC/4SrBQ46ltpms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3wQgW+ct; arc=fail smtp.client-ip=40.107.212.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mU4N6yAMBUBqz+CCbVV5OP9k5KKyo3e/vfKBqG0SDyMcLUSmwXTR3+5qzjAtRuvQHnv66W+0bpYuVFe+weIOv45BBNcLQHdk+gXTiwjAlMqtDxxcmil1SUefgkotCLfCjH3jLWV4XjRx+o23n0+ZMDLZE856EQAdRKfIyoQ3JXtJ6Pe8hOBmzSkSTteOQrptJ8J4HhAzfkoPrjLURiEmXPkVsyk3fi/4hIfOmscWWBNwap5mNxcZ7IFrVksEhbcl/7Wx9wDMyJxTSZqYB23eaVHwS4y3CzNQLm/RcbQsIJnszfTJY9pRbjqrbcqYmrP5+jZg2wyNKdQHK3ReBkH9pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/qb8nRcEP8KNeg6eNXHoLhdUi6VPjChojgIIYKpqwU=;
 b=HLcTm2De6tIccHeII7FOPEU9mNwLTXPRypUzRwp2aeNdg5N0nMAgM3LvnFb5CY6I1Q7nQa+PpTISrE3vKBcCz94UHwrJeAcB7KkKlz8uvoCv1m9IzYiD9/9MEP0O6s/N+2LSUwRzRzljaj8Dw/9SpT5sDuUPvBUbq/w2inoNfjK4z3oI7H9cZBFTmLZOmPyMqHbyChrEdQFNUenYQZLnXBuh/dwpw281KB3nsSffnNPMjBqu8qks8tWRE8jp49TI/gmD1vvA19gPBWEBzWS4vEZYBgzxSUPNRLuwsubgb9+VHHoCEaRUzPaMliQQh9uy1H61yJdkpurNGxMDYZB/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/qb8nRcEP8KNeg6eNXHoLhdUi6VPjChojgIIYKpqwU=;
 b=3wQgW+ct2+HW1SNwVOOXHyb4dM+RrtOsXh+bhRboPpbNIAYGqYNNPRw+ErCZEo+GeMKqHBDu1sbcdwHtIB04aX2l5d1Xl6DxELemeA2+PruPTSjYhxw7UawwsoOpVf9a1IhgGhaZgGcx2Zox5/wgTEn4hj8D/2H3zkTCFhBZ1e8=
Received: from DS7PR03CA0138.namprd03.prod.outlook.com (2603:10b6:5:3b4::23)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.32; Fri, 1 Mar
 2024 07:50:29 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:5:3b4:cafe::89) by DS7PR03CA0138.outlook.office365.com
 (2603:10b6:5:3b4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.32 via Frontend
 Transport; Fri, 1 Mar 2024 07:50:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7362.11 via Frontend Transport; Fri, 1 Mar 2024 07:50:29 +0000
Received: from sindhu.amdval.net (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 1 Mar
 2024 01:50:20 -0600
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <likexu@tencent.com>,
	<dapeng1.mi@linux.intel.com>, <rkagan@amazon.de>, <mizhang@google.com>,
	<tao1.su@linux.intel.com>, <jmattson@google.com>,
	<andriy.shevchenko@linux.intel.com>, <ravi.bangoria@amd.com>,
	<ananth.narayan@amd.com>, <nikunj.dadhania@amd.com>,
	<santosh.shukla@amd.com>, <manali.shukla@amd.com>, <babu.moger@amd.com>,
	<sandipan.das@amd.com>
Subject: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits correctly
Date: Fri, 1 Mar 2024 13:20:07 +0530
Message-ID: <20240301075007.644152-1-sandipan.das@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: 077ac97f-fabb-4953-abcd-08dc39c443bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mFrFpV08CVJwV/L+qg23hvDHe+n66ex//Wx6TT1xyRavy36jbFzrZfODkqxT44Hn/0m3cQXpp0cLkuhXFagQy80KW/KWDX+wHP9ApFaE0qaZyZp5dGNPZ+spR4K4C0/UKMqJ4locJlUqpiyeo8IwLvOLxUUaxhNwir1V0kRvXOdOZ8H4UxH/9kj5VImfhhNxJ/zm6IhjLsk86BFepObM21sJHltIyjR4YId2n08JODUQInX1MYYMZAwJh+FghE3PHY0jXbpfrnHjGQ31bKZLJZuoR1sc2JS6YRqJtcf05s9rsQSbujxkBrlN5BiAv6SK1ypT8GRNtTsl9E4aUdKi221bwFyc8TXStKXTvk7/jQw6syfMK71OteNx9WEw7/Bl0SmYzqCUpbI9Xh1E6v3brGmRPl1AosyrH4rvcdCvPhNQ8sOBTxmLoQPBX0HSmueYAMjiXhetlciQWdzR1tk8KHc44vF2R3huVTrimUPDS3Odgwdfau09/CKWegSeyRzW+uBiXmvD2+wO6TXUgMCSeUZ4VM3k7lsN03x6+DAHyXavYfQR+h0LoOMxDePdGnnxAw9Er6fEQG+cu20zUI2Vnzc2vvod06InLXIE9NJETbIwwdZhn2oAuWEHfB/qymvjyan+ZZx3RjVKrhzWyU3WddZk++REOtamIhiZ7hho6MyPvFjniKTGjGV1Cyi8gg9DcnME0fBixHuwlfX0tcYL4pKbM0mJhdAH0uax901F2fCBo2HWKbefdCuB3Kv55fLG
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 07:50:29.0951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 077ac97f-fabb-4953-abcd-08dc39c443bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338

With PerfMonV2, a performance monitoring counter will start operating
only when both the PERF_CTLx enable bit as well as the corresponding
PerfCntrGlobalCtl enable bit are set.

When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
for a guest but the guest kernel does not support PerfMonV2 (such as
kernels older than v5.19), the guest counters do not count since the
PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
writes to it.

This is not observed on bare-metal as the default value of the
PerfCntrGlobalCtl MSR after a reset is 0x3f (assuming there are six
counters) and the counters can still be operated by using the enable
bit in the PERF_CTLx MSRs. Replicate the same behaviour in guests for
compatibility with older kernels.

Before:

  $ perf stat -e cycles:u true

   Performance counter stats for 'true':

                   0      cycles:u

         0.001074773 seconds time elapsed

         0.001169000 seconds user
         0.000000000 seconds sys

After:

  $ perf stat -e cycles:u true

   Performance counter stats for 'true':

             227,850      cycles:u

         0.037770758 seconds time elapsed

         0.000000000 seconds user
         0.037886000 seconds sys

Reported-by: Babu Moger <babu.moger@amd.com>
Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b6a7ad4d6914..14709c564d6a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (pmu->version > 1) {
 		pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
 		pmu->global_status_mask = pmu->global_ctrl_mask;
+		pmu->global_ctrl = ~pmu->global_ctrl_mask;
 	}
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
-- 
2.34.1


