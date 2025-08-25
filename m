Return-Path: <kvm+bounces-55593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB07FB335D2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5D8F3BEA36
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 05:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEB62749D7;
	Mon, 25 Aug 2025 05:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OU3Kx0dh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C9019309C;
	Mon, 25 Aug 2025 05:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756100261; cv=fail; b=Q2SWYRIJHR1iAHCJYHhwyYdcPzXId0lKY4g8Dnh6qEV+xYW616rQN80tIMShNh37Bnx88IQYOW0jlvmBiZuMcEoacF34/aIAb+4/jM4Fe91D3JpQ/ZRC11KvEGuC4JHdaCIcTk8KwpzyUnDonoKsBaxcVDr0D/dDVIryR4hSUvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756100261; c=relaxed/simple;
	bh=HRVAXavjK9EQYYCkgwG0Z1OAK3MlYlSaT4YJl/1iyes=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=d1XeD8QIrMqQ9TWOGH49ouh4eInkIfqO9ALwZmrueiwFX6wn1KoPXbqNCOW1Vs8H4srtCV7p8vL1+zrdPrmVzTJj27cpHzfvTmOLukrkZfWAt9PiKD2WOfLzlZnKxy3iDd0vH2XkqAGiZzi4TJhv0bJlPxxzsOyw9ZhI3FaSyMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OU3Kx0dh; arc=fail smtp.client-ip=40.107.212.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1UlGByVJjaUvZRtIMeR+yfAFvMkeA/XzzV0f7Dq+R0lTvNpb8fT92ZYUgbw6M/IqnzFM3v22j4BdHY80WOduVtjucILx+y8CenBVP3QWxPXZ+DoA790RS9nZIACr68Fa2Scr3rw7TEhwutjlsBpcapXkzF2+0tEWvirsS18zuGjz3VRorvBEpfa/JlMghVTLU1zTHWTTJQIcA0GyHcHYY7gkJs8QRutL9qTnMItw9ac27pPX3zOv3oQHeu2TsyxIiszItgsJeDjiBaRIhXsT/XNiDf8P+V+hfW11gbIAW8eQ39UUadW1X5vBqWedENKKJKdVCvry9/hA4m/lda7+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVRpvqRtYsLrilXOgabTSLbiwmiUi3ErVERAMi1si80=;
 b=WUWJ/6GeWwBcGEt9T0sp+LIsWapLCGkMCY0JGcc6I1XYvGPjvtm/5B24/xwsgC1GbkiuSbvi+px6pf5Y4bJxz4z/oPEzZtAxNB1yjx+CZironL0NKRUNwgDUoQ3QAuYk3DGiwWv31Y9i9Pc5dkqb/HRURhCsdidy6qXy20Tq8OYimLwjB0YlvlYuPGfam/LvKlcx69wGVFgLvaX8/QJc5AOv/CzTwgtJjjMVhNyN+g0t7VN5GCfPKl/YENiU9FGWbBBAZIY6GCZbC4BA+B4gtjPE4cdi2Iw1JBOm7+FW124cIN+Neqxb86FhhuUp8XAKtwt8K93NTz4K3nsD4utfCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVRpvqRtYsLrilXOgabTSLbiwmiUi3ErVERAMi1si80=;
 b=OU3Kx0dhxKzS5y7JQ1rVy08p0X5b9ie3SVftEXiHcEPBEzKcAoObgwHfVUv9Pls/f4IlL4pXOkTUqBeM4XZg18k9TA8fVanq3pf91FOmRL20gQmmV/tEBxMDVXA9Fpl8PbqG47O48qJ9P/G/IMjktavm5yiGv2bVO1x/6+v7kTM=
Received: from BYAPR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:40::21)
 by MW4PR12MB7429.namprd12.prod.outlook.com (2603:10b6:303:21b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Mon, 25 Aug
 2025 05:37:33 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::a5) by BYAPR04CA0008.outlook.office365.com
 (2603:10b6:a03:40::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.20 via Frontend Transport; Mon,
 25 Aug 2025 05:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 05:37:33 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 00:37:31 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 00:37:28 -0500
Message-ID: <c3b789cd-ab23-4a61-9c00-f37a2108abd4@amd.com>
Date: Mon, 25 Aug 2025 11:07:22 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Kai
 Huang" <kai.huang@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <175581201824.3460047.14086246675316864904.b4-ty@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <175581201824.3460047.14086246675316864904.b4-ty@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|MW4PR12MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa63bf7-6de7-4836-6d15-08dde3997d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|30052699003|1800799024|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z081aWFIakloaDNaaHRuZ1Y3d1ZZM2IzSksvL0M1K3ZuYU9hK1NlUFNqa3ZX?=
 =?utf-8?B?S2JlR01seTJBU1NpckZXcUZSUXdHVWgrc2RFYW1XZ3BaUmJJeFVmaXhmZklj?=
 =?utf-8?B?Wnk5NXlqLzFHVmpxZUNESWQxUjhTWkMzbUVHRjFIdi9sT3gzbElLcmxTR0pL?=
 =?utf-8?B?QlZJQTU2OWNmOHU2bHVQdThYdzN0UDhmdm8wUXNVOUFsaDlwWHJ1UXlNK0Vs?=
 =?utf-8?B?VDRjTnJuazErb01SVXNHaXo3TE1SSitaVlFiT3ZyOWhqMWttKytNVzZkaUJM?=
 =?utf-8?B?dzdoWVRrK21FckhzRSt1UXdRNnRmQ21wL09SaENVRHRLYlM5VDdmTXNST1hM?=
 =?utf-8?B?VHN5R1ViMWRyVFFTd0cvd3hQZE04bncxZG5hbE0veVhCZTEyN2VhVmxwVUJT?=
 =?utf-8?B?b0srbzlEV0xXdUdlMWZsK0JHaDhJMXBPYktNbThoWUhvallsUGk2SHlXSUJ6?=
 =?utf-8?B?aVFJL0t6M1d2eUNpeVF2ZXFWZmRWbmF1UXl4d3hicG1oNjkvR3FYRm9EUHpq?=
 =?utf-8?B?UUpwdFRxbi80RGdleTByY3BHUllDWkZ0MzNQSXdES09UVGdvcWxhUzFJNHdn?=
 =?utf-8?B?UW1KVDdiL1lnTERreG1kYXBBdHo3aFhCNzVWOWtpSVJFc250TUZCWEhPRGlK?=
 =?utf-8?B?RTBPRTNjVUVLSnFnSkgra2hZTEY3YzhXM1hETUJhOEN4dlpPNXJWV0UzWmN6?=
 =?utf-8?B?ZCtGQXBuSWg2bjRWWFlMdlYwdFJDbkJFUUJiVVZvMHY2OWZLaEJzWi9LbWx0?=
 =?utf-8?B?c0RhRXRMam8wQ1JJU2hkTWI1VFRJM0c0WWNIbUVKSWVOeGVjOVhtYlkrbEx0?=
 =?utf-8?B?N1NYL2dKZXd5dW5xNHFTaXpFRHQ0cm1PNnJTamc3VFZmeC9ucWI0b0RiUEdo?=
 =?utf-8?B?Y0xXaEh2V09rZFhUeEROajE3OGNkT0Vya0RDVE4yc1A2cjFEelFOcWZOTkdH?=
 =?utf-8?B?WTRCczJzNmhMV1hyS0w3eE1kMFJpamtLNHQ2L21xS1ZFU1VLODZIeTFwNXFw?=
 =?utf-8?B?WWxCTGh6M05YRnIrbFdVYlJPendmaDhJckVDRlloM2dyNy81R2lVdXp5cksz?=
 =?utf-8?B?ZlRYRWNlV2gxRStGa0dVbVMvQ1VwTXFDRWFEVEhwR2w0czJOc1NRMmI0dkFh?=
 =?utf-8?B?ODBkZnRtZGE2bU9EbVQxN2xWRlFnN2wwV3BjVEdIbFg5dTJvcGZMclBzT1Bj?=
 =?utf-8?B?Y2xCOWVuamx3bDBrYmRpWUNjY1Z4cXNaa3ZOWnhzS0V6OTFRRFZoSGErUjJ4?=
 =?utf-8?B?WFV3akpWV1A4eW5ybXRQMmQyR0IzQTExNng1WndtMTF2T0ZNdmwxeDlxckx4?=
 =?utf-8?B?dGdPcXNiOEtDREcvMksxaS9ya0N3S01Dd2p5dUsrMFZ3UTlKM01sK0F2Mms3?=
 =?utf-8?B?U3JuMmgxY3A0OVhqekFySXhudGpMdUhpRXhQQ2xvSklDVWczNmZEN3hSdVlB?=
 =?utf-8?B?VU9sNkI5aytIV0VmT0svUjZwYUNDTHIxNTdTWFdNMlkrRk50c0ZCYWI1ZTFa?=
 =?utf-8?B?ZVVhV1RJV3hiQ2pkNEtKR29EU0lUTmVpZWU0SmJCZ1JPbGY3Q0dOazU4WS9x?=
 =?utf-8?B?cmI3YnFJNnRkeUIvY0VoN0pNVXpvUTcvYjlVYWNHKzA5Rk1TdjZCeGJ5VEoy?=
 =?utf-8?B?L1d3aGpaSlE3WERXU1BSazdqQnNNckZTL01hMmVvbUdJQlgrNTBTOVNDRjcy?=
 =?utf-8?B?YXA2V3poUWU2Nm1IVTcxaDFSMWljM3hkb0dJakNKN01ISjRjcGM1R0kvZ3Yw?=
 =?utf-8?B?QTVmVkVINU9MOGNXUUhvSU1DS2dIcm10amJtUlZrVzVDWHZlRlpCZTZJMnpG?=
 =?utf-8?B?cDRiR1QyVXhHZW15SXhTYWxVWE04NUJWZ0grV2V0azRES3lvdmt5Nk42UlM5?=
 =?utf-8?B?bkZ0MGJNT1ROVjhqMGJZTWwvY2VvOHMwdEMzM3pRQjNvdmNsekdCL1dieVVT?=
 =?utf-8?B?WGY5U2dlWGE1L09tYjZETEk3ZG9acHVnWFlvWkQyS3ZBZ3g4YlFBTGIwc3d6?=
 =?utf-8?B?V2tsM3lDS2Rhako4UWJEUEhtSjFISUw1MU5LTDJnV3VDbkRXQTZ0M2FhdGlu?=
 =?utf-8?B?MUVaYzQ2RFJQUVZ4R05NZXNWdXBSRHVoNjQ4UT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(30052699003)(1800799024)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 05:37:33.1710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa63bf7-6de7-4836-6d15-08dde3997d97
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7429



On 8/22/2025 3:05 AM, Sean Christopherson wrote:
> On Tue, 19 Aug 2025 16:48:25 -0700, Sean Christopherson wrote:
>> This is a combination of Nikunk's series to enable secure TSC support and to
>> fix the GHCB version issues, along with some code refactorings to move SEV+
>> setup code into sev.c (we've managed to grow something like 4 flows that all
>> do more or less the same thing).
>>
>> Note, I haven't tested SNP functionality in any way.
>>
>> [...]
> 
> Applied to kvm-x86 svm. 

Thanks Sean !

> Nikunj, can you give this one last sanity check when
> you get the chance?  No rush.  I moved the "!kvm->arch.default_tsc_khz" check
> up slightly so that it could use a direct return instead of a goto, just want
> to make sure I didn't pull a stupid.

Tested the branch with SEV, SEV-ES, SNP and SNP with SecureTSC guests,
working as expected.

> 
> Thanks!
> 
> [1/8] KVM: SEV: Drop GHCB_VERSION_DEFAULT and open code it
>       https://github.com/kvm-x86/linux/commit/c78af20374a1
> [2/8] KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
>       https://github.com/kvm-x86/linux/commit/00f0b959ffb0
> [3/8] x86/cpufeatures: Add SNP Secure TSC
>       https://github.com/kvm-x86/linux/commit/7b59c73fd611
> [4/8] KVM: SVM: Move SEV-ES VMSA allocation to a dedicated sev_vcpu_create() helper
>       https://github.com/kvm-x86/linux/commit/34bd82aab15b
> [5/8] KVM: SEV: Move init of SNP guest state into sev_init_vmcb()
>       https://github.com/kvm-x86/linux/commit/3d4e882e3439
> [6/8] KVM: SEV: Set RESET GHCB MSR value during sev_es_init_vmcb()
>       https://github.com/kvm-x86/linux/commit/baf6ed177290
> [7/8] KVM: SEV: Fold sev_es_vcpu_reset() into sev_vcpu_create()
>       https://github.com/kvm-x86/linux/commit/f7b1f0c1620d
> [8/8] KVM: SVM: Enable Secure TSC for SNP guests
>       https://github.com/kvm-x86/linux/commit/a311fce2b694
> 
> --
> https://github.com/kvm-x86/linux/tree/next

Regards,
Nikunj


