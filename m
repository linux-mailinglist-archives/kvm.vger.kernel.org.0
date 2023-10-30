Return-Path: <kvm+bounces-131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7B27DC132
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 21:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD3B81C20A95
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 20:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364B61BDDA;
	Mon, 30 Oct 2023 20:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XrdBvle2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1351B29B
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 20:27:09 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5B7107;
	Mon, 30 Oct 2023 13:27:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NukTwQ1CA6NuLpscUauDS+3CucTiRCIA+W6IQpQ6BhyyL6QHcfhRkIItteQcunjqcZ4DII15LBvxBZwDBSrZFTS3mzy4zKKHhAd21ZDNz70O/UjKdWKmnTJ6qCeiP06k8Zrdmh3PEYVtc13AlI2euO95UBtPX+FATkUZrRpNplYkqeCK3D76341syMAiyHTz2k0tsDO5yky120ANLGqep2rqz2tqThQwIRKkod4unIv9O8UPO7iSvswh1yBOWfo8FNtwa8b7dXkWII417b4mTyN72oGN3ZpZIpUUX55vIwpdoLJESDGUhzMbbsJbbGAwZHT5yis1YOEEqYoGrWaEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIEHOeEdiGMJCsQaXHumckktB2o+cqiiekKgvWsnn+k=;
 b=nAOSE+KB9G2xQdTcpZxmRUdvWzMORtD1r+5y4G5FSlDPyi7XWCmzChudTAp08cS8vTbFzfHgPcz+pvRPfPKEbyHultrgXmVtE4ZkKe00KXFd8+0aqtEeywMen+NR+UcDnTejFh2AnmCKe2viu3g/PDaROXo+ODH6gelBm/8VWxC6lmEd2qVc3lQ1s7YPxlOtqrbZEzmLWmIUYlkthTt3srGk48mlsgKf8saA0mbOYOs7SH3FqfwiXNUpRmyUHJpLGCCqupuWVevf88YZWXdvy+EzgxRf/2rPlQez1MdoTHV+7xnPH9pzPBO5zGCy6zOWQsVfDESgAgWm7tz5u1zduA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIEHOeEdiGMJCsQaXHumckktB2o+cqiiekKgvWsnn+k=;
 b=XrdBvle2VZOF9atUpnQXpKOSXQ3S5lgby96hndwvgSTBMCH/yxKiYxo+6BZ3T9G5tv6drkxGblJlTCER9BSD32fv/YIeW1Tseb7xUaSV/yC2P4TavUYnP6uEst74sZrjvX/ksav+3E3ksSy3Y6aHj+6JpMqoVgRr17vFz2JLmCg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH8PR12MB7133.namprd12.prod.outlook.com (2603:10b6:510:22e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.25; Mon, 30 Oct
 2023 20:27:02 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 20:27:02 +0000
Message-ID: <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
Date: Mon, 30 Oct 2023 15:26:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-10-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:4:60::23) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH8PR12MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 25bf153e-08ef-47d6-3230-08dbd9869339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pY5fnsv6gvn4GQMIFgRK0h/yGUIqdvIFloyxbeb1hIXtQjrVgRrjRckaJoWH29a9QjJdKR75X6o5siEdV913qHscZQdqZbWdM5mdxTgfiXwkVI0TNbLhvtxIrx/BoQ8ZAoKe4AoE4UPrK6HyE5RamG7KlhIPeKhGK8KeU81If+dTWfiOI1yPgIlMtkRS9NerdH/wd1AW6H09h0nH+0e+laiCyLKPyAhnJ48oXbO8+tVYQEccwgYKcjmMWUz7WNSzoHd9kcV7mmC1MaMJds15Hi5dUwDEOVLrDS3juyj3cprS8IP/QtHAqPx+WPDhpK4BJxtf9XiAo4izqNNInSjOHpNZrcgFdIxAnfiE5nR4FYpfyJkS46eE54vx+Oyj+SXGLYHEwioKKZTkMdZMSdXaIEBtwPE/0+RSvM+sqkAkDqYvyJU9e9995oAtEsFN9lpoV5UbM7IF/c6JF4kZyKqTFqowtk+VU2knJeFIFiZm6CkgT7sJNuPmYd9ZWP+mSNokcA72DIrZGyXbXt+Z7tPWUWDdeIM5P2QKbXgM5MJtIe4zShUpfXEYClZqrBHUz+ZyE5rox1COv0PnmaGukUO5J908iLrO2oflmBYNl51CQ6lhro0FIMZG5SExV2DYIgoRTaTiKI64EG0FJOBLQL7fyg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(39860400002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(26005)(6486002)(83380400001)(2616005)(6506007)(478600001)(6666004)(6512007)(53546011)(316002)(66946007)(8676002)(4326008)(8936002)(31686004)(38100700002)(7416002)(41300700001)(66556008)(66476007)(36756003)(5660300002)(2906002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L05jeFR0L2RpSk13SDFpVU1lQVdmOHc0WGRMcEFnRHFkMFRKZlZ2Ui9ic21t?=
 =?utf-8?B?cTh1aHJ3VUI3WHhWTzdzUk5SK09SckhYRDZmdXMxNmN2enlrMDZlajE2ZWdJ?=
 =?utf-8?B?RjVxME9TVktmVDQwVGlOVTQ2VmgvQTBRVFZNQ3lDRU85ZTZORTMvT2VxVkV4?=
 =?utf-8?B?ekw4UjZhMmpxU2tYL0h0ZytsS3k0dG9KZUZNM1p3WDhEbjRDVE9RMmhnZENZ?=
 =?utf-8?B?bjVRRmVxSzU0d2RLN0k3V05NVGQ1bUxxdlBmQWY0M212MytXWWN2N09iWmw5?=
 =?utf-8?B?YkltWFRRSFREOGpybXVpRVY3OEw2bVMzS1VqcjhCUEJNYmhwRnNpUXBqcVBs?=
 =?utf-8?B?VUJoR1Q0bVUvdk5pRXZYc0hOTFlaMnFrbmhvcWVMYlcya3pnOU9QVkNnMGJS?=
 =?utf-8?B?YTN5WjNTSlFacVVZOXlEWndoUVJuK0NNNmVWNmhrcGo5VDhxRkdZeGhocXdm?=
 =?utf-8?B?bVZEVkxtaWJJZ0F2YVFHN3c0T0R1ZXliSGlyRUYxaHFLT2lDaFY4aU9hOUI0?=
 =?utf-8?B?QkkvaUcvNlM4VWljQk9rcVdOV2NtdnRoVVE1YncwR2FOanJIeWFQOHdZQWhx?=
 =?utf-8?B?VWhBYUx6T0FWa0RwQlh5bGZURU4rcERyUHNoMFlqN0ROVFo0NkhnQkwyR0hI?=
 =?utf-8?B?UGlUM1c2QmREUWxBUWFIZGxPMnpsTlVHeFprZlovYUVKNWZpZ2NvVElnMUlu?=
 =?utf-8?B?U0RKcXprT3dvTFFMQ2NsYkcyYlBqbnlCVUFtbnV1T2lyY081NTZvRVhQZGd4?=
 =?utf-8?B?RitOaTdtckYybkdBaUlFYTM0Yk9lZzB0eTVObHp0QjNQRVJSUDMvc0h0WkQr?=
 =?utf-8?B?OW1FVXVNNytXVDJGL1Z2ZDZDbXFjSWx2ZkpFVU1Tb3pnb1pjYllDS3lzdzc4?=
 =?utf-8?B?a1plU2xNNzdCQ1NFVlI0eEtYL3hwM1BlVUkzSE9aTnlrSDNVUTJnenZTdFpy?=
 =?utf-8?B?dEhBY0ROTXkvR2U4TUJtUGU1aVh5UmZ3SHpmdmV2c2c1a0Y3YUpGRTR1UFBq?=
 =?utf-8?B?dzVzWE1kRVlBbWoyNmprWE4zK0ZmZWw3anp2WFg3N2tvQktiL0JUNSsxM3FK?=
 =?utf-8?B?V3Y2MUwvUVAxa3JpR3pwNVV1RC95cjd2VXFwSkpBWnBkNjJHVUNteGRoTGIz?=
 =?utf-8?B?dG9hMzBqM1JySjVFeFVWcVlSbFAxdWtrMy9ydHMwTnVVUG03M3o5ZmpwZW4r?=
 =?utf-8?B?OEVScS9PR2VsbStsK2tTOXlTVks2Lzd1L1B4REovOUF3dzJrK3pydC9hZFNS?=
 =?utf-8?B?c0ZVQ2VKOVoxVHF0WS9XTjFMM0dudFR0eFBETzNYY3FLRzZPN3VFRU9zTnF4?=
 =?utf-8?B?aXY5bDZYOU94dUkxY2J5WVZCMTdFYXMySTlxdVNFSjZUOE9qcXhYR3k2bVZw?=
 =?utf-8?B?eEdZSGw1WjVjSXZtTUtDV3JHZ0pxWXhLczQ4WTNuLzFkVWkxeUxqcFFIYjRB?=
 =?utf-8?B?Z1U3aHpVcW01aHROcnN2VHR4MkJnWXhoNit4dGdYQjdwdi9hSnhwNFAxRnZh?=
 =?utf-8?B?KzhMUVE3cUxtWEg1RTQzamZLRzEwUmVVN3I0aHVyTUJYNmFNSDlHejBEVXpD?=
 =?utf-8?B?VzNGZ01Od0owWkJOVUdZU0IzcHMwOWt3V09jQzN5MU84WFRvanJrbGcvQStp?=
 =?utf-8?B?a0gra216V2xMMHh6VWwyemlac283d0ZOenB6bGJjQkZtZTdrMlNZaVJhOFFZ?=
 =?utf-8?B?Ynl6THFRTGxtTmNGUWw1emdNMENXYVVKZ2dqSkFibjVVRmRRcVd6Qy9NSy85?=
 =?utf-8?B?czVqd3hRV1FLSFc1VzI4b2hJOEVqcEdkQmRyYXZvbGxPMG93TW5pS3BhWTAw?=
 =?utf-8?B?cnhEa1h5UERhc2h3TWVkczV1WFlYL2sxYVl6cWN1dGF5VXRWcTdxMm5hKzVm?=
 =?utf-8?B?RTJyL1lYcVdEUUhXL2o2VkhwYzFqNVc1N0RNR3RpcjJMU3VIcExQam9oVnFr?=
 =?utf-8?B?em02emZJVXZwQ0ZwZnBRQkRGeVRYc01xK01YSEM2UDdqVHVzeEJVRG1oOS9y?=
 =?utf-8?B?Vlg1YTdBSm4xTWV6ZUZsSjF1WDJlQ2UrRXVzMWQzMDlLdkNGbnhNWFp4R3l2?=
 =?utf-8?B?Q2lNZGtaeitWNW5ML29vVWZmTWxBQnpRQWwrM2liTUdvS3lKOFY5SUtISnJa?=
 =?utf-8?Q?5cTqn3iARgYWbBsEU/hIJfDOn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25bf153e-08ef-47d6-3230-08dbd9869339
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 20:27:02.3205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qEbQKdxJXOGJFxHRHgm1v3nxp4paV+oPB0Wbg70tmymwGh9b++UTbgWCxbMEcY2DGRQ57dHS+GK1PvwoE1WHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7133

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP enabled guests. Secure TSC allows
> guest to securely use RDTSC/RDTSCP instructions as the parameters
> being used cannot be changed by hypervisor once the guest is launched.
> 
> During the boot-up of the secondary cpus, SecureTSC enabled guests
> need to query TSC info from AMD Security Processor. This communication
> channel is encrypted between the AMD Security Processor and the guest,
> the hypervisor is just the conduit to deliver the guest messages to
> the AMD Security Processor. Each message is protected with an
> AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
> Guest messages to communicate with the PSP.

Add to this commit message that you're using the enc_init hook to perform 
some Secure TSC initialization and why you have to do that.

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/coco/core.c             |  3 ++
>   arch/x86/include/asm/sev-guest.h | 18 +++++++
>   arch/x86/include/asm/sev.h       |  2 +
>   arch/x86/include/asm/svm.h       |  6 ++-
>   arch/x86/kernel/sev.c            | 82 ++++++++++++++++++++++++++++++++
>   arch/x86/mm/mem_encrypt_amd.c    |  6 +++
>   include/linux/cc_platform.h      |  8 ++++
>   7 files changed, 123 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index eeec9986570e..5d5d4d03c543 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -89,6 +89,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>   	case CC_ATTR_GUEST_SEV_SNP:
>   		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>   
> +	case CC_ATTR_GUEST_SECURE_TSC:
> +		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
> +
>   	default:
>   		return false;
>   	}
> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
> index e6f94208173d..58739173eba9 100644
> --- a/arch/x86/include/asm/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -39,6 +39,8 @@ enum msg_type {
>   	SNP_MSG_ABSORB_RSP,
>   	SNP_MSG_VMRK_REQ,
>   	SNP_MSG_VMRK_RSP,
> +	SNP_MSG_TSC_INFO_REQ = 17,
> +	SNP_MSG_TSC_INFO_RSP,
>   
>   	SNP_MSG_TYPE_MAX
>   };
> @@ -111,6 +113,22 @@ struct snp_guest_req {
>   	u8 msg_type;
>   };
>   
> +struct snp_tsc_info_req {
> +#define SNP_TSC_INFO_REQ_SZ 128

Please move this to before the struct definition.

> +	/* Must be zero filled */
> +	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
> +} __packed;
> +
> +struct snp_tsc_info_resp {
> +	/* Status of TSC_INFO message */
> +	u32 status;
> +	u32 rsvd1;
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u32 tsc_factor;
> +	u8 rsvd2[100];
> +} __packed;
> +
>   int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
>   int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
>   			   struct snp_guest_request_ioctl *rio);
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 783150458864..038a5a15d937 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -200,6 +200,7 @@ void __init __noreturn snp_abort(void);
>   void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>   u64 snp_get_unsupported_features(u64 status);
>   u64 sev_get_status(void);
> +void __init snp_secure_tsc_prepare(void);
>   #else
>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>   static inline void sev_es_ist_exit(void) { }
> @@ -223,6 +224,7 @@ static inline void snp_abort(void) { }
>   static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>   static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>   static inline u64 sev_get_status(void) { return 0; }
> +static inline void __init snp_secure_tsc_prepare(void) { }
>   #endif
>   
>   #endif
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 3ac0ffc4f3e2..ee35c0488f56 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -414,7 +414,9 @@ struct sev_es_save_area {
>   	u8 reserved_0x298[80];
>   	u32 pkru;
>   	u32 tsc_aux;
> -	u8 reserved_0x2f0[24];
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u8 reserved_0x300[8];
>   	u64 rcx;
>   	u64 rdx;
>   	u64 rbx;
> @@ -546,7 +548,7 @@ static inline void __unused_size_checks(void)
>   	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>   	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>   	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
> -	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
> +	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>   	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>   	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>   	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index fb3b1feb1b84..9468809d02c7 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -76,6 +76,10 @@ static u64 sev_hv_features __ro_after_init;
>   /* Secrets page physical address from the CC blob */
>   static u64 secrets_pa __ro_after_init;
>   
> +/* Secure TSC values read using TSC_INFO SNP Guest request */
> +static u64 guest_tsc_scale __ro_after_init;
> +static u64 guest_tsc_offset __ro_after_init;

s/guest_/snp_/

> +
>   /* #VC handler runtime per-CPU data */
>   struct sev_es_runtime_data {
>   	struct ghcb ghcb_page;
> @@ -1393,6 +1397,78 @@ bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>   }
>   EXPORT_SYMBOL_GPL(snp_assign_vmpck);
>   
> +static struct snp_guest_dev tsc_snp_dev __initdata;
> +
> +static int __init snp_get_tsc_info(void)
> +{
> +	static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
> +	struct snp_guest_request_ioctl rio;
> +	struct snp_tsc_info_resp tsc_resp;
> +	struct snp_tsc_info_req tsc_req;
> +	struct snp_guest_req req;
> +	int rc, resp_len;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting the
> +	 * response payload. Make sure that it has enough space to cover the
> +	 * authtag.
> +	 */
> +	resp_len = sizeof(tsc_resp) + AUTHTAG_LEN;
> +	if (sizeof(buf) < resp_len)
> +		return -EINVAL;
> +
> +	memset(&tsc_req, 0, sizeof(tsc_req));
> +	memset(&req, 0, sizeof(req));
> +	memset(&rio, 0, sizeof(rio));
> +	memset(buf, 0, sizeof(buf));
> +
> +	if (!snp_assign_vmpck(&tsc_snp_dev, 0))
> +		return -EINVAL;
> +
> +	/* Initialize the PSP channel to send snp messages */
> +	if (snp_setup_psp_messaging(&tsc_snp_dev))
> +		sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);

This should just return the non-zero return code from 
snp_setup_psp_messaging(), no?

	rc = snp_setup_psp_messaging(&tsc_snp_dev);
	if (rc)
		return rc;

> +
> +	req.msg_version = MSG_HDR_VER;
> +	req.msg_type = SNP_MSG_TSC_INFO_REQ;
> +	req.vmpck_id = tsc_snp_dev.vmpck_id;
> +	req.req_buf = &tsc_req;
> +	req.req_sz = sizeof(tsc_req);
> +	req.resp_buf = buf;
> +	req.resp_sz = resp_len;
> +	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +	rc = snp_send_guest_request(&tsc_snp_dev, &req, &rio);

Aren't you supposed to hold a mutex before calling this since it will 
eventually call the message sequence number functions?

> +	if (rc)
> +		goto err_req;
> +
> +	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
> +	pr_debug("%s: Valid response status %x scale %llx offset %llx factor %x\n",
> +		 __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
> +		 tsc_resp.tsc_factor);
> +
> +	guest_tsc_scale = tsc_resp.tsc_scale;
> +	guest_tsc_offset = tsc_resp.tsc_offset;
> +
> +err_req:
> +	/* The response buffer contains the sensitive data, explicitly clear it. */
> +	memzero_explicit(buf, sizeof(buf));
> +	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
> +	memzero_explicit(&req, sizeof(req));
> +
> +	return rc;
> +}
> +
> +void __init snp_secure_tsc_prepare(void)
> +{
> +	if (!cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
> +		return;
> +
> +	if (snp_get_tsc_info())
> +		sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);

How about using SEV_TERM_SET_LINUX and a new GHCB_TERM_SECURE_TSC_INFO.

> +
> +	pr_debug("SecureTSC enabled\n");
> +}
> +
>   static int wakeup_cpu_via_vmgexit(int apic_id, unsigned long start_ip)
>   {
>   	struct sev_es_save_area *cur_vmsa, *vmsa;
> @@ -1493,6 +1569,12 @@ static int wakeup_cpu_via_vmgexit(int apic_id, unsigned long start_ip)
>   	vmsa->vmpl		= 0;
>   	vmsa->sev_features	= sev_status >> 2;
>   
> +	/* Setting Secure TSC parameters */
> +	if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
> +		vmsa->tsc_scale = guest_tsc_scale;
> +		vmsa->tsc_offset = guest_tsc_offset;
> +	}
> +
>   	/* Switch the page over to a VMSA page now that it is initialized */
>   	ret = snp_set_vmsa(vmsa, true);
>   	if (ret) {
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 6faea41e99b6..9935fc506e99 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -215,6 +215,11 @@ void __init sme_map_bootdata(char *real_mode_data)
>   	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
>   }
>   
> +void __init amd_enc_init(void)
> +{
> +	snp_secure_tsc_prepare();
> +}
> +
>   void __init sev_setup_arch(void)
>   {
>   	phys_addr_t total_mem = memblock_phys_mem_size();
> @@ -502,6 +507,7 @@ void __init sme_early_init(void)
>   	x86_platform.guest.enc_status_change_finish  = amd_enc_status_change_finish;
>   	x86_platform.guest.enc_tlb_flush_required    = amd_enc_tlb_flush_required;
>   	x86_platform.guest.enc_cache_flush_required  = amd_enc_cache_flush_required;
> +	x86_platform.guest.enc_init                  = amd_enc_init;
>   
>   	/*
>   	 * AMD-SEV-ES intercepts the RDMSR to read the X2APIC ID in the
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index cb0d6cd1c12f..e081ca4d5da2 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -90,6 +90,14 @@ enum cc_attr {
>   	 * Examples include TDX Guest.
>   	 */
>   	CC_ATTR_HOTPLUG_DISABLED,
> +
> +	/**
> +	 * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine and actively
> +	 * using AMD SEV-SNP Secure TSC feature.

I think TDX also has a secure TSC like feature, so can this be generic?

Thanks,
Tom

> +	 */
> +	CC_ATTR_GUEST_SECURE_TSC,
>   };
>   
>   #ifdef CONFIG_ARCH_HAS_CC_PLATFORM

