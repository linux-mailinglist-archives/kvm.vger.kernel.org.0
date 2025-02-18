Return-Path: <kvm+bounces-38400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8D6A39480
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 351153B10DF
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 08:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57F222ACF7;
	Tue, 18 Feb 2025 08:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fgLeY+mp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5194822ACDF
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866087; cv=fail; b=aEA8MygzlhsKa4t/xsC8xkq1oOnN8ZOIywP+4En8utksaPb4i//j+hjYoer0RQFZ/QekyIjUs6ImEFg6gQPb0TcgOh+KTKRCMGv43wrmHcGWoRb9G44XvIqOG396m7dQP29RuPcIa58/BvHwTr79N9k+cOzTafLtFY2BA7X+gNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866087; c=relaxed/simple;
	bh=8O1LrTu1BTyJjun+8fu3h1nyopWKqkA9wXGB+AkAGcs=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bB0XCYJAfvZmXScxApYkOv070ZhtvQZfpQ0AE+qlcJ1DXje3pno0+3alQFPcpNj37PXKE95Yhfc5ntOTJp/S9VAE8HUS/QRrYAtlpeBUD5qThTykYJVpHcROjAJe7RTaN2JCZ6O/XNYC4MMmuPjiJ6P1UAsnPCqTmfgae8OpYEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fgLeY+mp; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x2UO19f6OPt2VkPEpWTYfiaHkDik/j4yKY3TOPIQM8HrcGta3d152ykH3RwrEiI6yv0Qs0fpHH9k7Kf+wpeL/UiO5wQanJueuLW1YPnda1VpSatb1+ggD+6ogBsAcdkfKd0xzttNsA5lzQV+dxhvoZvdxd3n4/P71tdWo+NsNE8GEP5SdSqQbrTh+NcOBCyYOQAhOitcYqyVcTs3BGiXAc0/HH69/RQ2bbdA/hMJQoA+88DTHz/gn5mqRJydoMqnZAjGdwf7Ed0Vh9wVr1bl+xDmyRVrV9BFhOBj9RCIK6esWavZsBPBGOAGri0sQpNBTyWprRY2Tf/0va+KDsPpQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzpNd/GVOGTsGIjRpWOiLFpp0JlGLG8b3ddzpRwaAUY=;
 b=yy5dzPFh1M6864P7CImyBPRdYqCOAOUu8vR5afFSpAhFgWrcizvrbi2ckmq18rZ0Gvrl0geExH2UL4wCmrJXwl3/3oEX1T9UXpWJLSELaYhgOxTUmDRnqP4hsjL69/hi6hjyd4WTwHziQpTsIIbmj7xqJU7yJ4bagIXZWsvVPIo6/97w86Ij6d0m+6DP5vZ7mDMYrdi/9YA03ag+aX6BmDrnNOVtS4dVEofEkGCFYXNoNVgOoZCHusb745TfjRs9dsTA2PjE4B9b7FjzgVzy7RQeq17NE5D3VSXavf89z9mcQZvEMRUvgVS4zHc7e2t9QP8FRUXq7ycQ2y+OGM9aow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzpNd/GVOGTsGIjRpWOiLFpp0JlGLG8b3ddzpRwaAUY=;
 b=fgLeY+mps1LJghBYEZ6ZGw5rVlefy8v+4jQ6QwFKkYec/wppxkP8hFoBczWmw1ANpOrvhPqvJzgcQKGq7aEZ34R6TdJsue+HsSDYFmH8wN+A1ItxVyEjMFlffqDPRy9ai+E6FqKLQruM42L9B317SQBvfOHLDJh27gsbO0uR0WY=
Received: from BN9PR03CA0055.namprd03.prod.outlook.com (2603:10b6:408:fb::30)
 by CY8PR12MB8244.namprd12.prod.outlook.com (2603:10b6:930:72::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 08:08:03 +0000
Received: from BN1PEPF0000468A.namprd05.prod.outlook.com
 (2603:10b6:408:fb:cafe::b7) by BN9PR03CA0055.outlook.office365.com
 (2603:10b6:408:fb::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Tue,
 18 Feb 2025 08:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468A.mail.protection.outlook.com (10.167.243.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Tue, 18 Feb 2025 08:08:03 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 18 Feb
 2025 02:08:00 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 3/5] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC
 enabled guests
In-Reply-To: <6ad0aa86-fb21-872a-5423-8eb996b0e7fe@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-4-nikunj@amd.com>
 <6ad0aa86-fb21-872a-5423-8eb996b0e7fe@amd.com>
Date: Tue, 18 Feb 2025 08:07:58 +0000
Message-ID: <85h64riskh.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468A:EE_|CY8PR12MB8244:EE_
X-MS-Office365-Filtering-Correlation-Id: 8faab947-fc21-4463-7ce7-08dd4ff35e7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I9UC9oxDMfZFnuT6Xmpkd6G2B1F30H4AF1rBd8/BfArjyjt6x8gEoZRhiD8h?=
 =?us-ascii?Q?GAsUBREV0vB9xescSVbeFpx9M6bxFMV4P+ADMD9AZDIKVnauZNZ6PNPtNMEP?=
 =?us-ascii?Q?mVJEGu0vRJzbDzV5jygQq3etLcj0jiaHjAUcmSB98qrBLe3/KUS8UZAD7aDs?=
 =?us-ascii?Q?mDbQiPA1ZjAws7N51yNcu+6Evcox12i0B4OKby3eIixDacKnzpff+0DaXlBX?=
 =?us-ascii?Q?Mk0bfMSD7kxDURzc6ttr+kMY83BLrPhpe3ouWCtvQhqxzJGPbHekAn418Vgr?=
 =?us-ascii?Q?5kSySGLw9bs8AWSewnUm9k9E4DiujRX1RA3oP8wmhKZGdyFkH08gZRoE+lGZ?=
 =?us-ascii?Q?XuFdTk6nstShx5iPAZfjLX6ibuP3h8++Q/8PDSSrqJMdStPmR3YQ1GSmZ3JS?=
 =?us-ascii?Q?yaBQ5xZAZbN85NhseFRW0UnaTF7ySzoP2LzTzqpBbVEM0luwBkSajEAFD1yE?=
 =?us-ascii?Q?D6flgkO1U08CvKZjNg3ChRfQKpDSYLKsMRplA+EMlpCnMZYncbRM8qhbqvdP?=
 =?us-ascii?Q?qDZkNhmjBKUVLoFVWVbRmeAXe6po/nCPQzT5AL39Fe/PvbjuvdpSBeaP/RgF?=
 =?us-ascii?Q?kZUj/uU4BJnJmbD6hu/46hnKRncX4rKWK74enNDMv97jlYMPm77Xcav3PK1+?=
 =?us-ascii?Q?vu2iPTEnvl6Hj9sYe9183nssOwYQ6bpHycgvGKbqQshQ5594xNwTEdiY6y96?=
 =?us-ascii?Q?7X7+bqd22oYWUxVutQPvGMjGkyfLS1hwga7mhP5mf2BhFsOsigtNxLeOm2Kw?=
 =?us-ascii?Q?JMW/NCgoYekR+imXClutqRTrZ3mhF5895imCGRM3sxQmzv2TiTRk5aqTOJRB?=
 =?us-ascii?Q?EsY0VW6JA2I6d9MFNhQ8Kxpd44+FzVYHRfnh/wdPGACaYrzVEx7wt1+Zbgx5?=
 =?us-ascii?Q?hxI3+1Aa6C7zyn7yhcCkcCK75KMR5Ju3GzFsnRvqjkAAkdR9OsCPURsWamOY?=
 =?us-ascii?Q?dAZUI1K9zm4ZoucpzcJp0p72VVul945f9VdGdysmApslZkkShmMq8ptj0Kxb?=
 =?us-ascii?Q?+7ecvItb6FglYjTa7GpExscXumeQaLUp/fWS//hMiJDT9DXjrDRoIroncrNI?=
 =?us-ascii?Q?gO1eBojcll5OKo0ZWUS/ngkQUaY+DvYNBZ8TPxgmYnxbBYma6MrRaKeLanYZ?=
 =?us-ascii?Q?jaSnKFeyabaGBr6TFTxaTtT0jQIux24qt+nxCmrC6fnDK+t/h2tZunuiipUZ?=
 =?us-ascii?Q?aDw8GFuF2w/hACKzD4IUhve5DTjHRSRVEUhJC7Xto1OzkDiwwMQxZoX7Gh4o?=
 =?us-ascii?Q?hFv21+593MZ5YPdRpej3CMz8DpzqkU3mFBwhc/TstqJJq1CgaWPvwhdY87Zu?=
 =?us-ascii?Q?HSU9xP3hSvECiKYKxqhfNuvvijCghTiU10XgdALyb/tWc5N3e0dYiEa2JVQE?=
 =?us-ascii?Q?sfoPIIHKX77W5BgwtSbM0Q4HflCGBmUafdncwXvzyS5L1JJK7LOWoDUP5oS2?=
 =?us-ascii?Q?i95OXDnfp+KQvx+2QfCIAadOQ1oU3p8isXTz4aVq3C9Lzn4yXv/jHW0oetZ5?=
 =?us-ascii?Q?l0M22rkgWdlek7Q=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 08:08:03.6651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8faab947-fc21-4463-7ce7-08dd4ff35e7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8244

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/17/25 04:22, Nikunj A Dadhania wrote:
>> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> hypervisor context.
>> 
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/svm.h |  1 +
>>  arch/x86/kvm/svm/sev.c     |  2 ++
>>  arch/x86/kvm/svm/svm.c     |  1 +
>>  arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
>>  4 files changed, 14 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index e2fac21471f5..a04346068c60 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -289,6 +289,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>>  
>>  #define SVM_SEV_FEAT_INT_INJ_MODES		\
>>  	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 74525651770a..7875bb14a2b1 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -843,6 +843,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>  	save->dr6  = svm->vcpu.arch.dr6;
>>  
>>  	save->sev_features = sev->vmsa_features;
>> +	if (snp_secure_tsc_enabled(vcpu->kvm))
>> +		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
>
> Seems odd to clear the intercept in the sev_es_sync_vmsa() routine. Why
> not in the sev_es_init_vmcb() routine where this is normally done?

No particular reason that I can remember, I will move this to
sev_es_init_vmcb().

Regards,
Nikunj

