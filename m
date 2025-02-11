Return-Path: <kvm+bounces-37822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D92A30551
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 521E67A1F37
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553D31EE7D9;
	Tue, 11 Feb 2025 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XdSgE0WZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FC21EE01A
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739261483; cv=fail; b=pJW+hgF7ulXCAJxd+fguTRRCMOtUb9Wzal5ji2iPKH5znuDOArkuHZHdkdA3IqgpmWvMInF70aX1OKNIAtTtOi77JPcX6WWMxnkyhUsldo3QZ8tuJH4P0KVrVuSjCeJtajD0tQ3uabtkhK9R6oI5IpXj6zNkDjSUQmwui65fJ/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739261483; c=relaxed/simple;
	bh=VmvksZsYYFOE3MGboOby7QykootYVuhLD3x4InVKLHM=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WR/naqaLRuQpzUril4GBvSXWP6vtmu9F7UNNiwmMpgRa64Rom0q7kcWhoP+L2ycn/BB1gjH5wdeBHWR8wEc58mJ09sGl3rFyKWx9DgIoL+3ZZOvEy+K5YanjSY9FbZp9XZJMPkjohb3DCW31kOZcH6J0xktRS+wC9xSCfP6hseE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XdSgE0WZ; arc=fail smtp.client-ip=40.107.236.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IbQeAeP5fcC0tmfKAX/jTEn4uAM95XICmrCCXJ4p+kWoBTH19xArFJFXbWUgCMeKJcu5BFqh3i7NHK+JgLq9abMqqD9MR77WJfPoK5aW8nsryi8bNJnIkupz7v0wywXmNJJSTSuMWUPAP9QNxb4NGrOzcVA+DfedpmanYSOye0/umDXKoWFOUYUfTXF/SxkJJKeUSbEg33gG9TAnR9yw0VIZJhYPAU6CG2YIWiBcSMGFEJeFpJG3rB2Wkrz43GGOw6akXC5paZBULEVnvXwnwFIKcY12V6+5w15p0RBKm2eRbrnTE9UEFO7yl6eX8PsZC8x8Lm3tQ8sMmeS7I1DH2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Jd+pvXmC4JLWRmzh7hRWVWaJ5RCXjQOrKOPUT7VRM0=;
 b=EBhCuWeYFTQlYR0XVurtmnXPs3RdgzfOkGDUjkGNM+6K7kxzbHdjjcXlZwCDdHVZ0qEnr+4AS2+jd/0BP0UchQHrEpL/eKy8yOsOvwj7B3TzRvJksnqNORFpsqfwP5UIlYKfi0eKG6PUgaigjx5tksT8DpQzhckip8DeqagfXCRrSKKiAV3nIWN67QDZqQ8+9YOf0Y76VNkEgtBaphXR7T8uShffY3piLMC+QQx3EQRS4MvvkcMdBwxki+I2Nzsrw+1lHCH18O7ADCejORiwfwN6WsW4L4DudVMWaPNxqSL9DbbK52Wu3tjqAeJxSAAD5eOqW/FFT5G2UPLa5Fxzqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Jd+pvXmC4JLWRmzh7hRWVWaJ5RCXjQOrKOPUT7VRM0=;
 b=XdSgE0WZ+v9ZGLm4lMlfQVsDSC+g2DrhccQ0nFVjyYDi7Y4rBcHQzGUBdHcPdrzEVwXRIoAyGC5BJLBY4mGpaUCfSTw6/pK5FJWt+sALWpxGIcIPLRhJ3Em5HZzy7rt6FTKRCRAU7bmjmSua5EuPEcJpXc2Lyqdjz2YDPhnLY3U=
Received: from BN0PR02CA0020.namprd02.prod.outlook.com (2603:10b6:408:e4::25)
 by CH3PR12MB9028.namprd12.prod.outlook.com (2603:10b6:610:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 08:11:18 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:e4:cafe::97) by BN0PR02CA0020.outlook.office365.com
 (2603:10b6:408:e4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 08:11:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 08:11:17 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 11 Feb
 2025 02:11:15 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <ketanch@iitk.ac.in>,
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Enable Secure TSC for SNP guests
In-Reply-To: <03146f82-61b2-3415-c63a-2d5ae582e452@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-5-nikunj@amd.com>
 <03146f82-61b2-3415-c63a-2d5ae582e452@amd.com>
Date: Tue, 11 Feb 2025 08:11:12 +0000
Message-ID: <85h650ucin.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|CH3PR12MB9028:EE_
X-MS-Office365-Filtering-Correlation-Id: a0cb8fa0-94c4-41d3-d00a-08dd4a73a95b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zHmHF37Izs/BdK1QGnjmDWHGtyvv7Y4r+JMszyvVWNhvSE3nve3LT9hhGGZX?=
 =?us-ascii?Q?iCFh3LgbWzWzsUYUUUNAikblGQ31fiWaiPOr1tbFw9qSXeX8ihzufrPWTdyz?=
 =?us-ascii?Q?fMV3zsrji8S0suekSnfOQ6sti3HKZNMpU2p7UIhVG0BJnkTryFSYZsG//Qn+?=
 =?us-ascii?Q?B9UtAumGWtsdOrU7uuQRz+BjiQ3yqtA3LGpKEkTNA9VcWYi45u/2A7gHU5CT?=
 =?us-ascii?Q?xc6il9H+22P85Syv3nz+wwgHb4xF84t+RqxJ23xWbBcVR4KTcu46+pWHyHdZ?=
 =?us-ascii?Q?itQ/q2+7e3J8d1PKMvrA9M1Er93w08e8CJBedYY5pK2biqjxpbfIYAEuLYW0?=
 =?us-ascii?Q?1WeafnpQ/CEQnyDZ2JLZUdVnYBPFq9C8jbLXZg1c7yFTGJ814WWrNPFORc1s?=
 =?us-ascii?Q?gFMUl/Iug3iGItxweXdz2/duh2C6GNIhabOZ3TBti4N1KLX4itIhAf9xKLEn?=
 =?us-ascii?Q?rsbVzNzsWh0h5U4x9TeJGVa/E2vzLPxlFQmwT/bxL8SWFZvj7/vcD021XFkY?=
 =?us-ascii?Q?cOQhew4+XSmkr8DIDpisHHVRZSIfbuSG7+CC6F6bi3485IP8V3eEoT+a5UVt?=
 =?us-ascii?Q?AhjH17zLSrrCk0oStAUfbpKI5SGibj86LMyLdsee+t2htbnTW9U5B5iyaCAm?=
 =?us-ascii?Q?B9OJoxJyWi/o59rKJ5gDOd7AAzgHSzuwbPbXKNYiD4DIPIUxnmay65f1meQC?=
 =?us-ascii?Q?tQT+1RPYph6vNl1sm9/uvMA1IB21PYjtML3zcKI/y4JYqvrZhqZ5/iYZgwOO?=
 =?us-ascii?Q?Cfanis9XKq7FllflWZrUGfJwDWwyk6/wT79Oe6hDg62bLT6eiktJ1d4zUUki?=
 =?us-ascii?Q?Wr69qYvCqXchQddNyZTIxWq59iJXsqYWBTZrbDJP7PytMY1TUq5aST5WwCJa?=
 =?us-ascii?Q?R0vOqb9TCrt1PR6PbgBcOmefXcOYN+SIfbzIlivftYZbyMYLP1eYgGHC9qqU?=
 =?us-ascii?Q?rDcSW511HLhYbBbsmkx8+wOAOSUmSD3cuGuxsZfYuSgjDxmcqH8zF7hWYDF+?=
 =?us-ascii?Q?IFYU3HWdStSzttBrcmnbyZDWrAcZ17qpDtCIqeWhF6Ur32c9ccjk245c/FxV?=
 =?us-ascii?Q?kb8xoBhenZwUa+XNA7vJHYkS/m4ZcnM9+KxoDCVq9iE/8d4RdBR/siqyJVsz?=
 =?us-ascii?Q?jPR9iJ4BYDd4YX/WtmHYXANwP3I35JOjgzQvSWqBSJxx35VcmnIpbYCl5/1H?=
 =?us-ascii?Q?Ur+Eumo0cPEcdaCBd0dEEMyyVSWaH08ctXNHZag36upp4bv7EyECbhS4CSYA?=
 =?us-ascii?Q?VRTcDZCQVtCBjIudnluOrxHULB9NPXtv3a8dV1awB5KTGXUH6C2OorihLEim?=
 =?us-ascii?Q?YVIa6g8oJk/UyPK9+dtVG5aMSjL3acUDlIc5rhDESI3hXXCiSDAjPGRcTQqC?=
 =?us-ascii?Q?eGsRyW6ibhKWuuf/LdvHsLvIT4OD/7Ub5vCn4XTLehRmqkjDPHZ9rvuQbW2z?=
 =?us-ascii?Q?irzKwxvPle42d0vvDhZAqRi+z4SQoTOnl3RUPtJszRUg4D/UJe10dQDuEMt6?=
 =?us-ascii?Q?1xFATV99UU29uf0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 08:11:17.8758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cb8fa0-94c4-41d3-d00a-08dd4a73a95b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9028

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/10/25 03:22, Nikunj A Dadhania wrote:
>> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> 
>> Add support for Secure TSC, allowing userspace to configure the Secure TSC
>> feature for SNP guests. Use the SNP specification's desired TSC frequency
>> parameter during the SNP_LAUNCH_START command to set the mean TSC
>> frequency in KHz for Secure TSC enabled guests. If the frequency is not
>> specified by the VMM, default to tsc_khz.
>> 
>> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/uapi/asm/kvm.h |  3 ++-
>>  arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
>>  include/linux/psp-sev.h         |  2 ++
>>  3 files changed, 24 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 9e75da97bce0..8e090cab9aa0 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
>>  	__u64 policy;
>>  	__u8 gosvw[16];
>>  	__u16 flags;
>> -	__u8 pad0[6];
>> +	__u32 desired_tsc_khz;
>
> This will put the __u32 field misaligned in the struct. You should
> probably move the now 2-byte pad0 field to before the desired_tsc_khz field.
>

Sure, will update.

>> +	__u8 pad0[2];
>>  	__u64 pad1[4];
>>  };
>>  
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 0a1fd5c034e2..0edd473749f7 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2228,6 +2228,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  
>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>  	start.policy = params.policy;
>> +
>> +	if (snp_secure_tsc_enabled(kvm)) {
>> +		u32 user_tsc_khz = params.desired_tsc_khz;
>> +
>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
>> +		if (!user_tsc_khz)
>> +			user_tsc_khz = tsc_khz;
>> +
>> +		start.desired_tsc_khz = user_tsc_khz;
>> +
>> +		/* Set the arch default TSC for the VM*/
>> +		kvm->arch.default_tsc_khz = user_tsc_khz;
>> +	}
>> +
>>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>>  	if (rc) {
>> @@ -2949,6 +2963,9 @@ void __init sev_set_cpu_caps(void)
>>  	if (sev_snp_enabled) {
>>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
>>  		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
>> +
>> +		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>> +			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);
>>  	}
>>  }
>>  
>> @@ -3071,6 +3088,9 @@ void __init sev_hardware_setup(void)
>>  	sev_supported_vmsa_features = 0;
>>  	if (sev_es_debug_swap_enabled)
>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>> +
>> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
>>  }
>>  
>>  void sev_hardware_unsetup(void)
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 903ddfea8585..613a8209bed2 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -594,6 +594,7 @@ struct sev_data_snp_addr {
>>   * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
>>   *          purpose of guest-assisted migration.
>>   * @rsvd: reserved
>> + * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
>>   * @gosvw: guest OS-visible workarounds, as defined by hypervisor
>>   */
>>  struct sev_data_snp_launch_start {
>> @@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
>>  	u32 ma_en:1;				/* In */
>>  	u32 imi_en:1;				/* In */
>>  	u32 rsvd:30;
>> +	u32 desired_tsc_khz;			/* In */
>
> Shouldn't there be a separate fix for this before this patch? The
> desired_tsc_freq should have been here all along, so before this patch,
> the gosvw field is off by 4 bytes with sev_data_snp_launch_start not
> being large enough compared to what the firmware is accessing, right?

Yes, this should have been part of SNP series, I will separate this
change in a new patch with Fixes + stable tag.

Thanks
Nikunj

