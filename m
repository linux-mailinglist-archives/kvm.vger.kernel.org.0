Return-Path: <kvm+bounces-11301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB09874F7C
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 13:53:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06B99B22157
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258C212BEB4;
	Thu,  7 Mar 2024 12:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xQC44U3I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82225129A7F;
	Thu,  7 Mar 2024 12:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709815995; cv=fail; b=TiATq1WLnsqQKh5ulxCJXTcdwIy8tgosZZ1TSqvBkk/QIY5/D5dwffg2dHZf6Ks3/qmCHnjc0/6DqEn0kb6M9fTJPa8vJiROYFVLyTb+Y3RfdngpvrzEMsGuefESL+jtz/xGEoa4vUtDn6/y5LeZnTKmT/0SoeApcwl1QU3HILc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709815995; c=relaxed/simple;
	bh=r6kweQUYl9koMyNbhni3AEYTB+uofJF3LblgeZuvdeA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JHStMEFY0IXgVeIkaB17lRMEKYOE/n3sjlW7ogbUlEgZiTusRsYetQpQT11QWK34yx9yAVtGd87zCX3452R3DGU6Wjf7+YPAZzlewAC0dBwN1A/xlNUP2kV8Dxok006wNKdvdgKb4+YUKlAhENuFrPHsiQensrKwX0uWB06GaQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xQC44U3I; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4lix+P/QdvPxWRG6mTEtgqVHo5qMfYGOPOUP/92WuQiOqC3wNARKrOvHFlHIhA78WFE1E0ozTyBJ2U4UqoPqeIZnwmUgbWYjm+0tevOB3Zxr6f+qplCVSbT6+uq60AR/DP6lGVWUji7reslzxPrbHvzpDFi9W96lgQqLvrNQwSs1rNOM7XiL33E19Y95eHDOQbR/A3sNqlYU/Dd+WRWEVMWXCA9EcJs4B8IvTlu93idGESPWp+xqRX6cRUZP8usN1K3TEyQpgdQx8aFXRm3eJ8q2rbnirSxDGkp1QI9ZrOvWHq9mTutMCGL0iwUF5fKFCMW3ukrr4lTfmzeozG5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOPRDslB/ZO9a2Xenxhj+7YQt6ptu/dlGWNxmaImykk=;
 b=V54qSwIgAk90iaaPQBRJ3qNCRjFwSTDVvaPyGNAEQFlab4uPN5eKyQMf5jckcWkP23xuWAx+ThmemGras6Q85fCEhHSBRft49uWa4UX5i7p/4I/5nyjS76ilIrFWTfkgWFleA/K7j/DYZ2RGR3zEqlyIIlBK9VHkQCGdZhD2/ggrCiDZbJS9+n1quZ0vqTO26W6sbnKiSQUZ6tcdhTltOU4OCQBhTPQYeEl5QmfuorBYycuGMwkegr3ukSJ6kl3X11rWlrlX+6tgDIQMrWHOxIs9cSH2RqGSAVtUxe7Ui13CnJYL4YMlHl41CQQ1ImCDaZIN/oP0qf2mXZ2bkaaC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOPRDslB/ZO9a2Xenxhj+7YQt6ptu/dlGWNxmaImykk=;
 b=xQC44U3ID0BvRiFleCBPxah8azvT1Zs7Py6Lele3DFSJJOicTh+KFTsrYwbBVd4K4BIWhU78PHp4hsJSQHfdjdx5zy6ktVNxciju8H8QjJCdVRTIox/WUhMk6jeX4c3kHSup0E4Sm7hxKG55GHgyb5MVKnX+HdoC6igPHqAhefM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 MW3PR12MB4377.namprd12.prod.outlook.com (2603:10b6:303:55::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.27; Thu, 7 Mar 2024 12:53:10 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::2385:dab8:fddf:bcba]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::2385:dab8:fddf:bcba%6]) with mapi id 15.20.7362.024; Thu, 7 Mar 2024
 12:53:10 +0000
Message-ID: <2441bd2a-a0b1-5184-bac8-28c94b151c93@amd.com>
Date: Thu, 7 Mar 2024 13:52:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if
 private fault hits emulation
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-2-seanjc@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240228024147.41573-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::27) To SN6PR12MB2815.namprd12.prod.outlook.com
 (2603:10b6:805:78::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|MW3PR12MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: beff5df0-a958-4e53-8e00-08dc3ea58aaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Szg0kNXGSqOSPII3R3JBowNjli6L982H+tKFvQJOcVDyTtPXxRgOZao/+JRcg5EQ76+ciik2r7biqHO2z4IsrhnJlYDE7iRV2VxEhKJRKKSBusr5yaN93PKt9rxTR3+9/htZs0BqgGSjxaMU4CR2BmpJTGfjZmLfJQZIOCDq2ei67W0Xj4hFZc9VNgQNylAFP0zbTSY13Kn64O6TiXyKqAxTvjyRkrRWAfxtNAHFpQnqiVAqnEhWtBeDdjKgqxLZOm0trz53WgmEDO7Uq6KxeId7cM4wOjZT8kSDbMPoeTnk2zWGLgKM4TcdzijjMscv6zwFFlKeZ58+OvGH5z8muoMX1qFL3mMz1aZQcxZYwEeTV5jZaDGJxbO6rHvHTR8ICycoUlxNUScIGnYqu/nAdmygTI8HhWHhYMiLstvev+7Iao+3zg1cFonLypYdoAm8Yw2lLJaRHF2O9VfxJ/VJE3ueqgOnQ3M6WVzb1onRMFdAb3+iPHaQZDCnkkb01ittflsKCT4KhUUf6YiBAnrZOF63UBz0iRn300okPJMGGh3VPBjvIQ554BzIdHYOZ7AShlir95Dgw//nVoexOsQAsuelHto6zQp6mjj0a4oJssAb4q2+RP/LZv2EVQWQHKAcCYYxtWX7nWlH1lI5pb7Lo30vI0DsGKEkGs149Gb23kI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGl5Q3RvOXZnUjJMSHVyMUlNVUlqVDRuSHA2VEo1RW40ejUxSnlIbCtrYnRL?=
 =?utf-8?B?ZjYzOVF0UEpTdzRkanZyT3lmcHp4bCtMKy80NTNyZEVOY2FXUHM0SkMxRC95?=
 =?utf-8?B?UXQ3TEJkSkxkTi9hdGRFUXdQR2lIekZmL0dsSDNqM2xsZmE3OEE5M0FUaFd2?=
 =?utf-8?B?R1A2TW45Y3Vrc2dUSlo5WDlFZG13U1BtK3k0QzZRZ0V0VjBWQ0l1dDZWODk3?=
 =?utf-8?B?MFhXVmFXc0JzVjhBYjBMZ1JrYkdZTlJma2VUSnpMR3gyN2NtbjJmWERtbDAv?=
 =?utf-8?B?ajR3em1RWkJYZDhTRHNzcnlSejllRTFPYi92Q3FtSFdmREpyaS9YT3U3T1lY?=
 =?utf-8?B?WkthdUFza3NScUNYR0g1NG5Fc2prZmlqRGdocUtlYllyTk4rMWlnaWF1Y2U2?=
 =?utf-8?B?K1pnNWV4aHJHeVZCQjlaUG5VazF4UysyZkJSTWF0ek9VRkkrZGZwOTYwd0ZW?=
 =?utf-8?B?MkUvTEFKOTJhLy9uK0VmOGpKWDFqMW1qbFhuNmJ5emI5S1ZGdnN0b3ZTeXR1?=
 =?utf-8?B?WGM3Q0lCcnpxRGFKT3JjbnVEUzJqNWkwUXNFaXVWbnRDK1VLRXZiYXZ4UnJF?=
 =?utf-8?B?WEIrUmxlSmR2N2luUWhGa3NJUjJGbjZQRXJUWTRRZUN4VVAzRzRRMDZEZE9x?=
 =?utf-8?B?YVFkZFhYeTB1dFQ2ZlhRZllJR1d1Ty9IQlprek1NM2c5V1dJYnppN25nWEpp?=
 =?utf-8?B?TEhzSWcrSnhmMHBBNFYxT0xnS05USEFZMHozSjZYUU5XOFQvYmZLYmEwR3lT?=
 =?utf-8?B?T2ZUd0lwUmFrTmlnRGZKRTAzeEJxUE5Pdll2NjFzOWlJb1ZPN0NtM1pyVTRV?=
 =?utf-8?B?WXkvdDBHNDZMakpJMmxNTXZWWHJZUWJPOEtacmJNUnMydWlqeVNMZi9FMmtl?=
 =?utf-8?B?R1U4bFY3VXZydWpGcG03Vzg0OTlmdjZqWTRuVHQ0dWtFL25vSjNMSjc2K1dL?=
 =?utf-8?B?MERDQ0Z0Z012UDlZT2YwSm5iWVp6Y1V6THUvWnZQMW9xcmZIZHhxWFJJRGVz?=
 =?utf-8?B?NVU3dDY1cVdwOUF5WmdQeXhva0gwOEZyMURIbmF5K1JFdVlTdUZETjJpdVpS?=
 =?utf-8?B?YzNKUVd1cXd1YytLTDJlNFkwNmI5aHArdjFSeG5acTMzWmI4ZCthbjJWVWxx?=
 =?utf-8?B?aEJkbGkvSldTc0loSitXbGx3VElxRE5iTk0rSlhibmpjdnZWbGY1TGJQazdn?=
 =?utf-8?B?b3lUYzdRaUl3Zkp6QXdBM2xwYzM4aFFlNmYwMEkyWjhsNitwVFNodGJpZEdk?=
 =?utf-8?B?MDlUWldOVEdjQW0xVThNdXN6ZHA5NEM4MmZYNUt6MENkdWJta256U0xVSG1W?=
 =?utf-8?B?QmZZMG1yaXl3aXpwWEd2WWRnZXU1b0NySVdHeHZsYWJCWDRYNjdXUTVFalBx?=
 =?utf-8?B?eDFrRE9ybFl0YU5rVzNQYTNhMDl2c1V6SUgyM1dvYXYxMUJRYVBNcXNnZ1o1?=
 =?utf-8?B?LzBZNllOL3ZCS2RKS1ZTUzcrVkdsOFFoMnBueitEczQ2TUZpMHd3bEJUb1I1?=
 =?utf-8?B?dHl1VEJzRmVDeGI2QWJaamlWbGZaa0JUZXB4VnU4YkVJRWxPYjA3cDdkb2hy?=
 =?utf-8?B?SFZHakN6cG5aTWpnSnA0cEdsMkVXamlEbmhLWUlFNjhEK1E5MTA2R0tUd3B4?=
 =?utf-8?B?aXJtOUxvYy9NN3RhMHlCOXp1dXN0WXdTYlhpY1VENzF5eG9VbU81YklzTFU5?=
 =?utf-8?B?eEFHNENtYmVlNVh6QXhZcmduQy92TThNN3dSY0dYK0UvQk1HeXJkeDV0M3Nq?=
 =?utf-8?B?ejFGOEY0L1kyU0xacGM5VG45dlZnSysrODRZaGx6aEFTR3dCclU3ZnFvZnZY?=
 =?utf-8?B?RTduY2hpeFZOWDVuaGJ1WlZ2UkhIeDdkeDNqaWRwZ3BUdVczNVFSWithdzJP?=
 =?utf-8?B?UDljV0l6UlpPRDRwL2wyUTVGWWYwajN0OE53Z2NBUHpXSlhEcC9NODFPK3NZ?=
 =?utf-8?B?M1VxdnVlejlPdWpQTGN6Rkw4VWlJWVN2bVZnbDRScGZDNHVVOGVQZkVwaVFx?=
 =?utf-8?B?eU1hcGQyanBEcGFaRk1mRHpkaWZyOWVTSy9kNkZtcFhzY3pReittWVZrbGJV?=
 =?utf-8?B?a0J0UUFLem5MZ1VySk5MOU9KM2RsVVMwaTlHMXFleldLQXprdjVkRXhNZExz?=
 =?utf-8?Q?KPMIjA1RHRQ1iSX+XNNAHCIOZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beff5df0-a958-4e53-8e00-08dc3ea58aaa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2815.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 12:53:10.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvpLmwSVrhsTqM0bmz2r4V2covoAK1W+M9wG5pT7xxhrzQTmMTbl8bAeU8QZsb10rkPIykmwQrOWWSPV0jc/JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4377

> Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
> triggers emulation of any kind, as KVM doesn't currently support emulating
> access to guest private memory.  Practically speaking, private faults and
> emulation are already mutually exclusive, but there are edge cases upon
> edge cases where KVM can return RET_PF_EMULATE, and adding one last check

edge cases upon edge cases?

Just curious about the details of the edge cases scenarios?

> to harden against weird, unexpected combinations is inexpensive.
> 
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          |  8 --------
>   arch/x86/kvm/mmu/mmu_internal.h | 13 +++++++++++++
>   2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e4cc7f764980..e2fd74e06ff8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4309,14 +4309,6 @@ static inline u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> -					      struct kvm_page_fault *fault)
> -{
> -	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> -				      PAGE_SIZE, fault->write, fault->exec,
> -				      fault->is_private);
> -}
> -
>   static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   				   struct kvm_page_fault *fault)
>   {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0669a8a668ca..0eea6c5a824d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -279,6 +279,14 @@ enum {
>   	RET_PF_SPURIOUS,
>   };
>   
> +static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> +						     struct kvm_page_fault *fault)
> +{
> +	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> +				      PAGE_SIZE, fault->write, fault->exec,
> +				      fault->is_private);
> +}
> +
>   static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   					u32 err, bool prefetch, int *emulation_type)
>   {
> @@ -320,6 +328,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	else
>   		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
>   
> +	if (r == RET_PF_EMULATE && fault.is_private) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> +		return -EFAULT;
> +	}
> +
>   	if (fault.write_fault_to_shadow_pgtable && emulation_type)
>   		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
>   


