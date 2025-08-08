Return-Path: <kvm+bounces-54311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCA4B1E255
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 08:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96E6E7B23A2
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 06:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A019221540;
	Fri,  8 Aug 2025 06:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XqV3OfDc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0011A3167;
	Fri,  8 Aug 2025 06:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754634730; cv=fail; b=qQSSH8ZnuGt9LEalCihUuN7oWn1YCDl/LdsIikE13C6CEdwGBWqmhFWrSWLOkxx8sL88/52UIUI9sMJEAOzMKr8QciREOWkDtY0XFODEjsqDONjdIV162RfMAIXRsYxfKREUu4xKxGdFQbM9kXrYuKhn0Sfaj7SxUwSggXHFUQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754634730; c=relaxed/simple;
	bh=dKFgBIl/KkeyhqV+JuRYkLTiApKrjsD2Dt4eJnKksTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nAMfWrPLebkKDMH0kQRrxdGhvWfJz0pFKlgSbbm7sdpP1Dz8Ebl72hSfg2hTNMW+Hn99aT9aw8+vDJZC4iI5yr/kqnOsdHd5i3yAcItBE48u5CDCyWAJ1v0HSH8GAI9vAgI70CRIoZeEJqZtg4AojFdqFOvXBIWrhYTyHE/RF50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XqV3OfDc; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQzRKqupldTa7/N6j+68eD60Jd8rfj9QI7EToRSRziez9gDte63txzkvQ5VeUw4VT0/vX6k98eNd2IID52Ddblz9MXVVWnOIm32Z8a1xMoeJzMAGGMvRegQXkAnYG4yDTYvqUDfqhRyjnanb+pesK0gP1pD8JKezd8Ycbpqjgtfblb1F7zbNCxKGdTtqu/BHH/hxxg1BWkLO7pzRw6gIt1XBqnW3vs1taYGoKpwE0o6YLf/cfR3qS09Kd9wwCDpLtEQIqpWaXfHhvo9zKGIcWOy9ssJqLcLJEz90vVzc8GRtQlGb2/OOVWDI0F+FWn1H+bzO6pNYjoXC46jbH+ahOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jN5o43C7PLroYdYDq8eAq5sPNuBytUbD2TfyjW/acs=;
 b=cfts2n+PzPZfwyaBeeLTXkuklaeqMxFmdZGvXsCypWuTumdsyXO/nP8Yr7xsLfTmrCcoa30WS9ACcY+AYlrKISC46gCbfRqOjg+yDlkocxOfRMkXPLszKMR49ULfJC0+LhL8O2ph4ZXcVQmz4yaynInPj580Wub9aN/h3s7g7pVpQ1KZUOMyc9pFqsPPJzuLQVhNuPxsYvHrcYagWZ9C5+x292BfUEdpJatKxxnXCJMcNEcco8EnUNVnBcTxx7hCvBgyBSL9du7s2P6lRo1N96d2X3Hi2Aklgan2I6MPhL8Kh4AwEwDhuwP+3WI8QKerRxdI3GL5VHgDZjCg/TYp+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jN5o43C7PLroYdYDq8eAq5sPNuBytUbD2TfyjW/acs=;
 b=XqV3OfDcpXT22AW2Euao9d326EotvVFXZxon9mXDilSWbx729SUeDDpFHxvpdEMSQLiblc6t1OeN3AvBFXJv5XEM+EXh3KbttvuiAMEWUcNU6Yoju9SXYWDHjwn4cl7pgk4CEERm2TtIAmkokTzn08QFc6lDczsKIOrbwNJg+0o=
Received: from BY3PR05CA0003.namprd05.prod.outlook.com (2603:10b6:a03:254::8)
 by MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 06:32:05 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:a03:254:cafe::9e) by BY3PR05CA0003.outlook.office365.com
 (2603:10b6:a03:254::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.9 via Frontend Transport; Fri, 8
 Aug 2025 06:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Fri, 8 Aug 2025 06:32:05 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 8 Aug
 2025 01:31:38 -0500
Received: from [172.31.184.125] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Fri, 8 Aug 2025 01:31:30 -0500
Message-ID: <e459b633-a597-4a7c-b8a4-359117668e2f@amd.com>
Date: Fri, 8 Aug 2025 12:01:21 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] KVM: SEV: Add support for SMT Protection
To: Dave Hansen <dave.hansen@intel.com>, Kim Phillips <kim.phillips@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Nikunj A
 . Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Michael Roth" <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov" <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>,
	"Nathan Fontenot" <nathan.fontenot@amd.com>, Dhaval Giani
	<Dhaval.Giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Naveen Rao
	<naveen.rao@amd.com>, "Gautham R . Shenoy" <gautham.shenoy@amd.com>, Ananth
 Narayan <ananth.narayan@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, David
 Kaplan <david.kaplan@amd.com>, Jon Grimm <Jon.Grimm@amd.com>
References: <20250807165950.14953-1-kim.phillips@amd.com>
 <20250807165950.14953-2-kim.phillips@amd.com>
 <7c36a16a-1c04-4c05-8689-52d8b75d3965@intel.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <7c36a16a-1c04-4c05-8689-52d8b75d3965@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: 1962a155-cb3f-4ae4-3da1-08ddd6454af2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVBlUTVzd2d5RytNY1FTZk02VWNkTGJJUnhzcW5xbU81MlpvLy8ya3puZ21I?=
 =?utf-8?B?TXZpM0Z2eWpSNVR0R0l6N2J1cEZjOTU0Q1FlOWtWckJoNEJMQVpEQ0NIMXhC?=
 =?utf-8?B?bStOdHdCZTAzc3NvSTN0N2VwZGdhN2RzMGREM2lVT24zbUo2V3hIN2tsVndo?=
 =?utf-8?B?Njh2MWloSWIyUjFXN2I5UlgvMHlqckZ0K0dLTjVoM3ZJalFjQVIwZDMwcFBB?=
 =?utf-8?B?TzdPOFRRY3lsVnVJM004YkNMT3hsTC82dVdyQlpSV3RIYS95SFNMVDREQmIv?=
 =?utf-8?B?OEpGM3RZclRCNzFheFkwT1liNXRycStPdzNnbXBTakpVN1FqWjZTei82WXo2?=
 =?utf-8?B?T09xcUsvTHNYRTZGbE9DS3VpU0tNOHN6LzM4SkdOK202NHh6MjlrcnI3d0Jo?=
 =?utf-8?B?RzNZOHRCTVBGcEhQY0NNQzM3ZVNUdVlqT0Z1azR0TDZZY1BvU0pSTitTOVpl?=
 =?utf-8?B?a2RhS2RXYmNINjlvbkd4c1JNRFgzOW5rUXJGcUZ2QjJtaStoZXprOC9hdytm?=
 =?utf-8?B?UEhmdWt1c2E1Vm1LMlh0Q2lhVHpWVEZGMjlFT2l3ZVNFM2FBWU9vMFBBS1dv?=
 =?utf-8?B?bVpyb2Z1NFFScTc1b1pPcHkvWHN4aGE5amRiSDlqMmUveXV1SDB4dUFoTmZo?=
 =?utf-8?B?Sy81RlRkdTVnMkh2cmIzL1ZOM0tjR2Njc3M2d3lZNVU4UEZDWlFRZStBenNz?=
 =?utf-8?B?UEhIWlFSSlkrMnpWeEJ4OStvUU9GZVdSak10aFZUTG5jS2NkQXB1N2VCMVJC?=
 =?utf-8?B?OUhBUHZIZE5XSEZxZENVRkVkS2poelh0NkZOaFVhYXEwbWhlOFV1SUZiU1hE?=
 =?utf-8?B?QzNBTXZSbUhTUVdkcXBkdnRvaGI3MWZNcWc4U252NERnZVA3NGZTVzFjWEt4?=
 =?utf-8?B?QTdhWk91bUNTK1lxVGpKK3QrMVR2NUR0SkRNUmtZOXZ1Y1dkbEtleFR0NUhl?=
 =?utf-8?B?bnRlSnBESldLVWpxUWdFSmdIRWxHYVZnbnhGNEhtQ0pMNDVCWXFXOHVVQjlm?=
 =?utf-8?B?Nm1wc0owUWJ2YmY5VnFJVkQ5WW1mL0g3TWJxMVAraXFkOWtRMjVWT1hwakN5?=
 =?utf-8?B?c3VKUHN4REVDQzhqc3loNmFTaVdaY2VuWHZGY296eXBmekVmZmtrZWRVTFVE?=
 =?utf-8?B?Y3NLSTZHTklxWW4zVkJHNy9jZWJHMW81c0p0Nm1aeVNzUnhtdHRVTElid3k0?=
 =?utf-8?B?d2J4S0lJQ05sbGJoZjNSeWhhMlZyS3N5dFgzK0hUa0VxS0hkSDBjbk1kWFFD?=
 =?utf-8?B?TW9nN2tPNWR2K2czMFVReXlUbm0zMTZUTThjTUpEanYyNmpQclM0UnJTVFIv?=
 =?utf-8?B?MFBlVDU3bVBJMVpLVHAvMmFFRnREWjZ5TDJmdkFycXFkRXpqNW1WemFBU2N3?=
 =?utf-8?B?dVppdEZ5TURQSW5TM1ordVBZTDFpbGJOMDBKTzZLY1M4Y1BUOWZtVnRpR3JP?=
 =?utf-8?B?QXFNN3NmT0cxMnhwc1ZGdUIvRVlyaTdNU1N6MnVOTHg0RmFxSDhCN2dSTjBX?=
 =?utf-8?B?Y25vbEdYYXhpRUhBLy9DU3lCREhxQkRXY0w0bnR3WUJLdGJrUUV3SVBiYVBM?=
 =?utf-8?B?WjZFVWU0cW9ySW5lb0RTTzFwWllobzNocHkwbENIRFRsUzdGc2tXenYyRjhW?=
 =?utf-8?B?VEYyRTVaOHdadHVJbzdpUDAvazdyVEE3aUFJU05rUHVOSXdGV1RpUXgxZTNx?=
 =?utf-8?B?MjdVSmFmUzNtVmJuTWpLQ2xwOXFHd2FsamV5ZjBhQlZlQWFob245RStseGtz?=
 =?utf-8?B?MGxnRUF6eVVvb2pOSHRybVRJazdCQ1BqSm82SWlhNjhOcHJyTSs3bEIybm5M?=
 =?utf-8?B?anB5dkRDZmxROURqUkJaZE54aDBNM1ZQM1VCaFplSUxla1NrYVFlZDdkTU1p?=
 =?utf-8?B?Z1RnaUIxOStoNjUrR1ZOVi9EODdKemlveDN4RC9iNi93dVBXcFNwcUF0OGRX?=
 =?utf-8?B?TnIvbDhMYklKMzJXNWJrbkYzbmhkSW42OTN6OHA0VkRPeWNqQ296M1paRlZk?=
 =?utf-8?B?Q2V2RnpheldPUnQ0azNuUFNKbGVvNHJJeUhPYmoxSWtyRG5XeDZENERIOVFU?=
 =?utf-8?Q?CrPf7t?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 06:32:05.3597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1962a155-cb3f-4ae4-3da1-08ddd6454af2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625

Hello Dave,

On 8/7/2025 11:30 PM, Dave Hansen wrote:
> On 8/7/25 09:59, Kim Phillips wrote:
>> Add the new CPUID bit that indicates available hardware support:
>> CPUID_Fn8000001F_EAX [AMD Secure Encryption EAX] bit 25.
>>
>> Indicate support for SEV_FEATURES bit 15 (SmtProtection) to be set by
>> an SNP guest to enable the feature.
> 
> It would be ideal to see an logical description of what "SmtProtection"
> is and what it means for the kernel as opposed to referring to the
> documentation and letting reviewers draw their own conclusions.

I'll try to elaborate on the general idea of SMT Protection for SEV-SNP
VM: The idea is when a vCPU is running (between VMRUN and VMEXIT), the
sibling CPU must be idle - in HLT or C2 state.

If the sibling is not idling in one of those state the VMRUN will
immediately exit with the "VMEXIT_IDLE_REQUIRED" error code.

Ideally, some layer in KVM / kernel has to coordinate the following:

  (I'm using thread_info flags for illustrative purposes)

                CPU0 (Running vCPU)                               CPU128 (SMT sibling)
                ===================                               ====================

  /* VMRUN Path */                                      /*
  set_thread_flag(TIF_SVM_PROTECTED);                    * Core scheduling ensures this thread is
  retry:                                                 * force into an idle state.
    while (!(READ_ONCE(smt_ti->flags) & TIF_IDLING))     * XXX: Needs to only select HLT / C2
      cpu_relax();                                       */
      cpu_relax();                                      if (READ_ONCE(smt_ti->flags) & TIF_SVM_PROTECTED)
      cpu_relax();                                        force_hlt_or_c2()
      cpu_relax();                                          set_thread_flag(TIF_IDLING);
      /* Sees TIF_IDLING on SMT */                          native_safe_halt(); 
      VMRUN /* Success */


Here is a case where the VMRUN fails with "VMEXIT_IDLE_REQUIRED":

                CPU0 (Running vCPU)                               CPU128 (SMT sibling)
                ===================                               ====================

  /* VMRUN Path */                                      /*
  set_thread_flag(TIF_SVM_PROTECTED);                    * Core scheduling ensures this thread is
  retry:                                                 * force into an idle state.
    while (!(READ_ONCE(smt_ti->flags) & TIF_IDLING))     * XXX: Needs to only select HLT / C2
      cpu_relax();                                       */
      cpu_relax();                                      if (READ_ONCE(smt_ti->flags) & TIF_SVM_PROTECTED)
      cpu_relax();                                        force_hlt_or_c2()
      cpu_relax();                                          set_thread_flag(TIF_IDLING);
      /* Sees TIF_IDLING on SMT */                          native_safe_halt()
      ... /* Interrupted before VMRUN */                      sti; hlt; /* Recieves an interrupt */
      ...                                                     /* Thread is busy running interrupt handler */
      VMRUN /* Fails */                                       ... /* Busy */
      VMGEXIT /* VMEXIT_IDLE_REQUIRED */
        if (exit_code == SVM_VMGEXIT_IDLE_REQUIRED)
          goto retry;


Obviously we cannot just disable interrupts on sibling - if a high
priority task wakes up on the SMT sibling, the core scheduling
infrastructure will preempt the vCPU and run the high priority task on
the sibling.

This is where the "IDLE_WAKEUP_ICR" MSR (MSR_AMD64_HLT_WAKEUP_ICR) comes
into play - when a CPU is idle and the SMT is running the vCPU of an SMT
Protected guest, the idle CPU will not immediately exit idle when
receiving an interrupt (or any "wake up event" as .

It instead programs the value of the IDLE_WAKEUP_ICR into the local APIC
register and waits. The expectation is that an interrupt will be sent to the
sibling CPU which will cause a VMEXIT on the sibling and then the H/W will
exit idle and start running the interrupt handler.

This is the full flow with IDLE_WAKEUP_ICR programming:

                CPU0 (Running vCPU)                               CPU128 (SMT sibling)
                ===================                               ====================

  /* VMRUN Path */                                      /*
  set_thread_flag(TIF_SVM_PROTECTED);                    * Core scheduling ensures this thread is
  retry:                                                 * force into an idle state.
    while (!(READ_ONCE(smt_ti->flags) & TIF_IDLING))     * XXX: Needs to only select HLT / C2
      cpu_relax();                                       */
      cpu_relax();                                      if (READ_ONCE(smt_ti->flags) & TIF_SVM_PROTECTED)
      cpu_relax();                                        force_hlt_or_c2()
      cpu_relax();                                          /* Program to send IPI to CPU0 */
      cpu_relax();                                          wrmsrl(MSR_AMD64_HLT_WAKEUP_ICR, ...)
      cpu_relax();                                          set_thread_flag(TIF_IDLING);
      /* Sees TIF_IDLING on SMT */                          native_safe_halt()
      ...                                                     sti; hlt; /* Idle */
      VMRUN /* Success */                                     ... /* Idle */
      ... /* Running protected guest. */                      ... 
      ...                                                     /*
      ...                                                      * Receives an interrupt. H/W writes
      ...                                                      * value in MSR_AMD64_HLT_WAKEUP_ICR
      ...                                                      * to the local APIC.
      ...                                                      */
      /* Interrupted */                                        ... /* Still idle */
      VMEXIT                                                   /* Exits idle, executes interrupt. */
      /* Handle the dummy interrupt. */
      goto retry;


Apart form the "MSR_AMD64_HLT_WAKEUP_ICR" related bits, the coordination
to force idle the sibling and waiting until HLT / C2 is executed has to
be done by the OS / KVM.

As Kim mentions, core scheduling can only ensure SMT starts running the
idle task but the VMRUN for an SMT Protected guest requires the idle
thread on the sibling to reach the idle instruction in order to proceed.

Furthermore, every little noise on the sibling will cause the guest to
continuously exit out which is a whole difference challenge to deal
with and I'm assuming the folks will use isolated partitions to get
around that.

-- 
Thanks and Regards,
Prateek


