Return-Path: <kvm+bounces-7211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D193183E3C4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 896492821DD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 21:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73213249FC;
	Fri, 26 Jan 2024 21:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m2wowQ2z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCAD1CA9C;
	Fri, 26 Jan 2024 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706303784; cv=fail; b=oV3cPoX1tEQkxN+zDy4mAIWx13LO+lmEx7tElPVGdC3Oc3QpotBLiDhvbWc5TdQI2FMW7kyYW8suk9uFfbdzYDgrZnd+yU7vR3vWXcehbMe0zYhN50JiFZX1wVqm5ParSiL3znBBTg0OEtkkyyIOLBCSgWEseuocZLk83lgzfLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706303784; c=relaxed/simple;
	bh=QRI28kBQNFtn+5Q3EDqEZUDgcKtii6Q9iCrBEPsasA0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YcYDnsprx9aid4b/he9MSRWdjFSFbWG8mSP4jwmnkYHrcGoGW2BsdoHXDjiT36pe2Eii+DgaJK6uq+ar9HBoDvatIvvX0VTU9WT/c9aJC7IPYipwCywBCmeHhZJ3AtvzCcyOmzkUImEdzC6uTwyZjasIGzpgyrVP9hv84tm7pro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m2wowQ2z; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyGbjaodm9HWDdFKCy7Yesvmn+J+EaKcmlknJ35tMFHXkiChluudYVJl+DFp/tMNUUpt0/82CWmPqXr/7Yac3YXPihxIyadvLQ2Q+lSX2yNOjoLG1gRqvfD4U+CO5pHJSUGQ1MLcZF9yNfHHVcZ+GE+Wkq9qNojBxdZbMasDM9Am3PXMRhTxHdTBkPKBVTRaKzcGRldntdrRCV98udZHVi+4GwzId2W47arYl/eaeH5Cg+33YdGS0Vryi3s/WknS+SDxYO2vcOfd6CsyVbHYU8iDwFUTd/wdAmsBebrQPfUjqCe8HLwwIX5VxYBdCdlaf0YAkTlW2l4axQl+/ocn5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQWTn2OCDAYTtMjiwIeeGlV60oKnNdT93mcSAgbcxhY=;
 b=PEbMAMExToBN226bXjKMxFvRyP/Y3CMxPLbVgCajAgfjCSvR+Z1dmwOU1wRl4wLpDoQTcA/KeUjFMWcrszq38SVd1+lE7U0HLATX3gKpIVvzC7jxlqcYLxi4M9YU1LslKRabNtwKKBOboqj3xnlGOdvycCoNZDSBFqQNk5HUvpLVz080TMtZG+2t3F7OfNJBAJ5fTFe0A5xrBFSByCLGhm96oEZiSzYrBSrkFWOS37IJAmMIAOryHc1UI74rqC5RSA5cdrmaxA/So9UoL0k8f4zkjXgXSCNoSJAm0cbaT9XGNnA2W3puWBbPk59jwaJL8VdQcYTccWHzCAxrPo/JSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQWTn2OCDAYTtMjiwIeeGlV60oKnNdT93mcSAgbcxhY=;
 b=m2wowQ2zju3cVoMXsBcRJ/iHtNjiDDj9S/3/yQOeHyjRvYcLuuapxTrutt2pwGPuWrSpbFS5HUGsSnb2+kiQajAVzt+zeysmnMrpLagvRaeih8WUYUt3ggRz2Wg4bhNff4OwSSg+1hS7TTMa0gvGAAqP5WpuKuzAnpKWHNnrNoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 21:16:20 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%4]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 21:16:20 +0000
Message-ID: <529ca51b-e698-5aa6-5af7-db2d00880559@amd.com>
Date: Fri, 26 Jan 2024 15:16:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231220151358.2147066-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:806:21::20) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 94563e54-955a-4e00-1ea4-08dc1eb40ab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oK5JlbYEdrzXgE1Uxo6sfG4PeGMQkclQ/flWmQuloJOH5+z46K6SS/iFwh3uJ0GZ71vO2RdZ7yxEYrnYA46ICWlWCiXv4JJXMZJJAAp0lycdmWoinCjgGudPHH+2ZzaX1iu9QP/cZ0xkcBZX2ueVCbVPLNItlyVivVVn/2+qPPXrSLDK7gCB5vUlltZU8Tgqvnf8hlslkl9ubfhFi41PkvVrdKh3BfQLZ8ljy8BYlyPk47qiW1xgfJBATShxpyQ7upGyhhEU50feb2vCak79eOJAX7YJ6DsLbsK7GtEAZdGSj5Jrh9QcOV4rkCGpxLf6U/nI3EtuL3UkPLH/ZmpoYmJ9r2QNLz3Vgpl2j7ami3OExZonSf7AR+y6RdzoxlY3JJcIMkiMcz486RE7/4fV1CeNZB0vduSl6fHfsHnGzyDrPeydVbfi7oYPNfuRzrGNu5TROqWnJEUTzBy075TxrNUu3GGUhyfjzLlebNDbblk9s1IoZQV9CeBOWU7Y9vkrtuTKPe8rWnfwBmSUrQLPKBc28VKOuvmItaKMMjL61apg45vaCMgeCFjk6w88AbrvjU5g97/1qwI5Gq6ANPVcEiqQDdViQSbaFoZggWjm2+ISWR1eOkj21Y0WWuwO9eBmW4JhTtrAytoVrXugWeU53A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(83380400001)(6512007)(26005)(6506007)(53546011)(2616005)(41300700001)(6666004)(66556008)(8936002)(2906002)(4326008)(7416002)(36756003)(316002)(5660300002)(31696002)(66946007)(86362001)(66476007)(8676002)(6486002)(478600001)(31686004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjZjSlRsVmRvWDlzLzRZdzdCVnhJL3VNNVRyMWF0SmZDSnN5UTdxajRSQ08v?=
 =?utf-8?B?a3R2OEM0dm9tbEd0MndHbTFVL0ZxTHZ3RWN3S1NDQ0ZuanU1NEYwYnRTY0ho?=
 =?utf-8?B?SHExZlREd2Y5YWo1TVdoQlJSbG5vNGgwUUFRU2p5SE9STStMcDZkZUc5aG1t?=
 =?utf-8?B?Wk1lelRFSzJNV1ZCclBzUjA5dVU4UnBwVFI2M0R1TktDcXhTVXJUMk1MUDls?=
 =?utf-8?B?MTZ5dEswZTc2bHc4djg0akw5WWNYU2JkQzJDZkxQdEFjaHQ1VkJCRHdWNDJx?=
 =?utf-8?B?VEJseTJ0Yy82NkpmQXJWVXRXVkYvOXJubzMxLzR0enZveU5LRTJJczNUclJu?=
 =?utf-8?B?UmJvWEQveTFzWG44aExkWjJLOFZJZGlOR3pKc0d0MG1iSXUvdEprcWNvOWh2?=
 =?utf-8?B?STZPcFQrVUw2NnNUNnh5NE1VcEhBYkpod0w1UnU5dlU2emNjdUZEREx0OFM4?=
 =?utf-8?B?VkNoc25tNWNVYzQzM1VvMHdIWlRjRVNKNzZEa0c4Zk0rMkszT2xZUG9NSDBE?=
 =?utf-8?B?dGhVM2NnRnlLemRtTlkxRTdvSzZ5cmxYK0kycHJPRTRMVkFzdDVpM2ZtN3R3?=
 =?utf-8?B?dC9jYVMrb2hrRGJRY1dqRXB1NDZ0TFhpOW5YYU1IV2JTRGxXclB0eW9JSEVF?=
 =?utf-8?B?dEkwY0QvbG1STy9oZThkNU1KMWhYSTYzZ2Q4TWo1R0FVTmR1amMyc1BDS0Qv?=
 =?utf-8?B?Y0ZPOUFremcxUGtkaW4rY1dRV25HSEdpSmpMTlBJQUhhWW9BR1d4YjluNjg5?=
 =?utf-8?B?cG9hdmQ3czhuWnd5SzlDUGxPWENNNldvTVZhUFNNRWEyTk4vR3lINmQ1UWxI?=
 =?utf-8?B?RTgyZ1pTc0ZVSGFSaUZpK0I0RUtwa2FadThPd1VjclZFN0Z0Ry9TSGVkQ3gr?=
 =?utf-8?B?OWVWemVDRk5YczdkVng1bU1xU05Qa3ZZc2MvV1VkcnZ4QzliTkZsNUJBS2J1?=
 =?utf-8?B?S3FlOVRRcmxNODFZWHFVRWxTRnZzdTBPVDh4VlhJMlJscWdIUGFlQS9vSmNj?=
 =?utf-8?B?WEo4cnVkdE1xMHRkRFhPazdlNzJoUDNPZisvWDVkbWExd1RpZ2tJblJidmRW?=
 =?utf-8?B?UEhxMm9kRzQ1dFNrMStER3cxL1Y5LzRyd20rTGU5aURzL1lTNE1ad2d2UCtQ?=
 =?utf-8?B?VUFzZS9MdG5hbUUvU3h2ZExsUTVKd2VSME93bVFnY28rUGtRKytvb284cFVZ?=
 =?utf-8?B?ZThpZlE3N01VemxnNEd6cG1PTjk2RDBmNU9VWjZuSC94K1hnRkNwVm83UW5i?=
 =?utf-8?B?UlZteFZEWG14YlB3clZLUkFWWURQYkkyL3hHUlRROGdSbDlUenVFdWFJR0Z1?=
 =?utf-8?B?VHQ3cFhSVHVxSWpQNGJlTWllMnBsQ2VLczdXQW9LMjZ5c0Zuc0ZFZUZuVVAz?=
 =?utf-8?B?K0VJV1Z4Z2Y2K0lQMlBZQ3RUbkVqUXc0NHlOWlBMM2pNWTRGQ3VHUXYzb09s?=
 =?utf-8?B?L0NFVXJLOU1QaDFDdkV2OTM3WTJEU2dSNG00TUE0M2NvczRmL0JvN0dwU2Qy?=
 =?utf-8?B?RUx0ZWszQWp3Wll3NUxlTVo4cnJZdVBjM21Dd1FDaUc5Mk55bm1WbVpPMUJq?=
 =?utf-8?B?bE9ZVmRlbGtOY3E2Z3ZXT2ovOHhxYkdtdTh1eDJlK0VDUlNyNks2ZVU2QVl5?=
 =?utf-8?B?UHJrUzNvaUk3KzNBREJidjVOV3NYTVhhR0JYNmoyeGprOWdNUkhtL243STIz?=
 =?utf-8?B?bDRWUHNFeGNyaWY4R0J0OFRKWHZ1Mnhkby9DM3NaQnV2bjE4bDNKbFBsTnBR?=
 =?utf-8?B?V3RaK0YvZTJyM0dQU3FZM3dlN1c1Q2t6T3Z5SG9jVUQxZzBvem4rVFU4TXla?=
 =?utf-8?B?S1hpMm9wRHdiVTUrZEcvQXRJeXNnUHZtcmF5N2w2Zmdld3pDbVB1QVNpWk96?=
 =?utf-8?B?UDFTWUpVdXAranhFSzJZd05USFdTWS8rZU9nV0syeDB0SW5BdnVWREZxRlBX?=
 =?utf-8?B?TlBqb25MZU80a3lFWTkrMks5cVdwU2UwT0dGcDZGbGNIalEwb1FGeHN4bFN3?=
 =?utf-8?B?NlBFYXBUQUt2SFZCWmVuenhqeTFYdzBIcFlUcVd6ZGJXMlZMTDFVYW5MM01y?=
 =?utf-8?B?TlBEbjlwSDBia0tVQ1FyT3dEYVdZVzV0N1orTnErL2lWVVArQWxja2ZaMGVI?=
 =?utf-8?Q?b7EeVXUBdc0XxlygWbYLnXVf6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94563e54-955a-4e00-1ea4-08dc1eb40ab6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 21:16:20.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7kXRovCTmI+DCouuSLeaa8/qqQXnAr9/Q/rt/TsV383ThXZBVic+biFRH3PDXUoZbhbK86BJCOQ0py2OzsTUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150

On 12/20/23 09:13, Nikunj A Dadhania wrote:
> Add a snp_guest_req structure to simplify the function arguments. The
> structure will be used to call the SNP Guest message request API
> instead of passing a long list of parameters.
> 
> Update snp_issue_guest_request() prototype to include the new guest request
> structure and move the prototype to sev_guest.h.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>   .../x86/include/asm}/sev-guest.h              |  18 +++
>   arch/x86/include/asm/sev.h                    |   8 --
>   arch/x86/kernel/sev.c                         |  15 ++-
>   drivers/virt/coco/sev-guest/sev-guest.c       | 108 +++++++++++-------
>   4 files changed, 93 insertions(+), 56 deletions(-)
>   rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (78%)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
> similarity index 78%
> rename from drivers/virt/coco/sev-guest/sev-guest.h
> rename to arch/x86/include/asm/sev-guest.h
> index ceb798a404d6..27cc15ad6131 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -63,4 +63,22 @@ struct snp_guest_msg {
>   	u8 payload[4000];
>   } __packed;
>   
> +struct snp_guest_req {
> +	void *req_buf;
> +	size_t req_sz;
> +
> +	void *resp_buf;
> +	size_t resp_sz;
> +
> +	void *data;
> +	size_t data_npages;
> +
> +	u64 exit_code;
> +	unsigned int vmpck_id;
> +	u8 msg_version;
> +	u8 msg_type;
> +};
> +
> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> +			    struct snp_guest_request_ioctl *rio);

This seems odd to have in this file. It's arch/x86/kernel/sev.c that 
exports the call and so this should probably stay in 
arch/x86/include/asm/sev.h and put the struct there, too, no?

Thanks,
Tom

>   #endif /* __VIRT_SEVGUEST_H__ */
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 5b4a1ce3d368..78465a8c7dc6 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -97,8 +97,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>   struct snp_req_data {
>   	unsigned long req_gpa;
>   	unsigned long resp_gpa;
> -	unsigned long data_gpa;
> -	unsigned int data_npages;
>   };
>   
>   struct sev_guest_platform_data {
> @@ -209,7 +207,6 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
>   void snp_set_wakeup_secondary_cpu(void);
>   bool snp_init(struct boot_params *bp);
>   void __init __noreturn snp_abort(void);
> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
>   void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>   u64 snp_get_unsupported_features(u64 status);
>   u64 sev_get_status(void);
> @@ -233,11 +230,6 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
>   static inline void snp_set_wakeup_secondary_cpu(void) { }
>   static inline bool snp_init(struct boot_params *bp) { return false; }
>   static inline void snp_abort(void) { }
> -static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
> -{
> -	return -ENOTTY;
> -}
> -
>   static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>   static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>   static inline u64 sev_get_status(void) { return 0; }

