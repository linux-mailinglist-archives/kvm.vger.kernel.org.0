Return-Path: <kvm+bounces-122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E707DBF95
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEC8EB20F71
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78EB719BB4;
	Mon, 30 Oct 2023 18:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IzdkVWGX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2D3199C8
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 18:16:36 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B258D9E;
	Mon, 30 Oct 2023 11:16:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKkGWLN36f+AYkUODaFbgCv3uXTFGLsHgQSDIO8lF93+bMfsNRKBrfawJOVmh3u/l01lWe4QiqrVVNUReNGoBmiwAEJkNpQk1ZGj3oCLn5vSiOQg2dYA8QUzNspptD5Qof2FnsLBbxsAhpUY+/dy7SAWSZteVREonUhhcqnxo3kyaPRYjI6qef68OP0CeJ1hu4wc5PBpcSDomaS1w43GjNCjq8FFV77phdZOFfYISeJyrpUOle6lkZF9x4VPZcJ2Oe3/FJnLs1T8/b8IxFfyxohstFK2w4VJVyNlB2dZfCUhAYQMz0gnQZOP10xO2c39hGq46bpnXJf+HYbCAFdKXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5UY/dM4ivICXHNXoa+6KjHpJANJ+HicMBHPSoCASco=;
 b=Pdwblb39XVFDsGfjM1+91Hk4HkZKFUjf26pPjHQA3BVmpkrHkIZ4dtdrwcEFCuY1DnNRCSX2qeOAkZgpHI6irdW6oD+Hu/DsNaCJSIu6e24aTTKHF4WrowqO1d9OYd7YE/EtWpRb8KPJdUTLlF3DehEcZVAl49P/r5blaSnx0hoce29dOe6VssXNdBiwYTXdPWflykPytaQJBXVBnXuCYgxhvAHExiQEsaccmi3hcteGcWs62rEOaLK+X/r9/+aJWRqR80PxVtGi0SXgIFYTcVYVaHNla4mAE8/eAb/1zWqbnJZVmTWSmzOxjrOqWfDtIByrrFXQgjHivnGAcQsy8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5UY/dM4ivICXHNXoa+6KjHpJANJ+HicMBHPSoCASco=;
 b=IzdkVWGX9QivCDIikZTvuzIvc5BFFH/qPYa2brUin0zfYwTx/DsuGu7h5sYQGlNtlHktvbQRiEAxPN4hRhXWKUSlEZEheSzwvRZBfKREbPJZ0TUv/1W6UNZsjxXUJwPpH1PZXu3cpwzsPXDfVIh7FpbXvL+tLI8z3gDykd6Xuo8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Mon, 30 Oct
 2023 18:16:31 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 18:16:30 +0000
Message-ID: <070e79b2-9cff-3d3d-4210-8a935518d979@amd.com>
Date: Mon, 30 Oct 2023 13:16:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 04/14] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-5-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-5-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::10) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8b7008-4e97-4c25-7594-08dbd9745747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EDL4sPRqqZsfRu9fuklgUIJmpjhwg2FymzagLYPbkLWeWgxWkhm6nSGtH4544aN1M2SOXglKON7PlrajVbPPPPjqBdL8u0mpmBYz60CtHb5zD/RtVMDR3Yv7m3CL7ylsFwQ7zOTMkpKZywEBT6BgYVSW8da2QdQlWbdNSE/HztbhSq23GoqGK42JVc1Q63rSFsgHQNvo0WooiZ487YmCGfIa5Y/3/yZ3PS5hSjGYd+ALNKAKCl0IysLy4PDtIobJF4VIzVnRlVquDe2jnGf+c/o2TpxUYBOQnON1o7EanHIb/gf6uEGjPaoUJQuECeSs2HmLd+vfdcxZx/BEekx2Xei1QnwU84UuQSCC6Nkvy5SiSgKMLooZBN6UBvImYtBKckJN6OtuZftll4P96c55hwYLiAWEucl3y/dv+onHsU4lSBRPMsnuQkHaL7vkDbz1lPRLrosgc5dkIyZyeL2vbVDKXch5BmwprD/W2s7Da8ns0+v5ZCtdtRy+tmHKl5Po8WVaWQmIfU9G9u1w5zNH/ZCGWVRFDgRBH60gC/odR9PUyyKzPkB7ShaLL2MFanBL1cPRbwiaOuadWPym3YxvWnN3VCqXKiafN50q3iOcCqwFuFr4iZ3DF13ZONcJcT8SeIdF/YgZWnP3jh7bCEkbqA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(366004)(376002)(39860400002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(83380400001)(41300700001)(30864003)(7416002)(2906002)(36756003)(31696002)(31686004)(5660300002)(26005)(2616005)(86362001)(38100700002)(6512007)(6506007)(6666004)(53546011)(478600001)(6486002)(66556008)(66476007)(316002)(66946007)(4326008)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THd5K0hmR2ppbUs0ZXB1aDdicXQvZzVQYVloR0Y5aFd6cGlUVy9nUUIzTUpk?=
 =?utf-8?B?MlNnSmR1bXI3Zldad0NMU3EzZHU5US93bWJOK2szd0xkSXNpSzVaM0t4ek5Z?=
 =?utf-8?B?MWNDV3Y3T1N1aHN0TG1kK2ErM09IeXdRNENzYVM0K2JpbDZyVmhLYXJrK3VR?=
 =?utf-8?B?SFZBQmRobzV5RnhsaDlKeWcxRXVtaVRRdW10aktSOW9HL1VsNXh1eiswWWpp?=
 =?utf-8?B?UEU0akFURmxUL2d5cHNGa1FHUzdjWi8rSnRwaS8yeVV1VXV1UkRSUHYzQ2ls?=
 =?utf-8?B?b2k2V0xCejgvbHZKQVFTTW9ibDVSTzQ0SXRRanNqejFOZXpCUUNlT3ZQeVdt?=
 =?utf-8?B?STQ3ajhDVmJOTWxJNnVoT2V5MzB6Ynk2OXh2NXhkcVVnTmhxKzQ4dXhxN3hU?=
 =?utf-8?B?VE9rSU1NbHR6MWhxZTZQMklOdmdGVVU1S2xuOWVaV3psUFJlaGZtT01UcGJ3?=
 =?utf-8?B?YXZGcUZFejcrWU1OTHJFT2pBZEwyVHJzWGtWakErRzIvVDFBS2tSZnZZMlB3?=
 =?utf-8?B?RExUTHgvZnNYZ0hra3ZBWlNTMFdMNVFJdkVtSFBtbEVNWjlyaVh2QnR6Vldk?=
 =?utf-8?B?djVtbWZueTlvUmd5L0hqZU9EQVVIUitrWGZpbWN5SnZhSzdVd1ZoclBzK284?=
 =?utf-8?B?ZlBpdTVVQzRVekhZWld2bHhnRjd0eHRNVFo5NGIrclFmMGJXNFJGWWFzWlQz?=
 =?utf-8?B?QnVPRmlBY3lrOXdLMG5YSWFPYy8xVStxbE1zdGlWcEk5RkZSdmJ5K2pObUxw?=
 =?utf-8?B?WjVRVk53OE9KeDNDdU8wdUFYbll6eDJzenFXVVRBNDhoYzBqOHQ4MGk2UW0w?=
 =?utf-8?B?Q1I0WG9KZDZPZzdod3cyckxXUTBqYzFwQ3JYbThLQzFmaXdTeERRTTh6eTNn?=
 =?utf-8?B?aDQ4c1lLcWZoeTkxSmZSOFZISWdCMUY2TUNZck1lL2ptSmVLL3BiaHo3MEFI?=
 =?utf-8?B?ZUIxU1U2NzBFNUlTRnpMQVJkU1B1MU1DSGxxdUdOQmxDeEpwcHMwNlpXeGtl?=
 =?utf-8?B?SGpwZkY1NStnL1BQUWxreENaRGZMVEMraFhxaTRGRFhxMVUzeDhLU0tmQ0VV?=
 =?utf-8?B?UlNLMDBLOE9FcTd4YTI4ZmthUTJlUFNEeEpBTk1sQ1dkNlRidTV2L0c1bGFM?=
 =?utf-8?B?dE9NR1dpOVR0V3lWSk1oRGVSRVczZWJCWmptckVRK2U3S2FnaWhrMXZJM1pj?=
 =?utf-8?B?RXh1SzZWUlhYSENVUTN6Y3dXSksxMi81c1VPV3Z1N3ExVjFScm1ZN1FCYW02?=
 =?utf-8?B?TmdHTUZMS2FKL2V0M2FKSFp6RjRrOXdadW1NZ0h6LzNUa2hLODRFVEhSV1Q2?=
 =?utf-8?B?a0Q3L0ovN3Vlc1huNWZCYlR1WnIwbDVUYzZNZUhISE9CS0tub0ZPMENvdFZh?=
 =?utf-8?B?dDgvS1lxQkllaGRMQS82TW95UE00REhFUldYaEFhcTd2UXRtOWRMaTF6ZnpP?=
 =?utf-8?B?V0l2NTgrcjhSL0IweXF2WEQ3R3dUTEJzckc1WC9EZzhuTVR6ckN6MWFVcnFq?=
 =?utf-8?B?Sk5JSEVMK0VTbTVhdjZEeHF3QWR5OFNmZzJLdUI4cjhVaGNFWWIrK1pyTElP?=
 =?utf-8?B?dDc5OEhuYmtJOHdWOUxtdGRMbmREQ0M5b0RWeXFibnQzTjFVcDFHWklrZERp?=
 =?utf-8?B?ZTNydVlBRVhWVW9BZ1A0Y05GL3djaFE4SXo5Wks4SzdQS2NvMS95Qm95M2E0?=
 =?utf-8?B?ZXFJbXlLaXpTTURuNzErVjJWanVuME5SVUdnZXhTK1UweHVkSEozNGc3UUlU?=
 =?utf-8?B?NTBoVGNYcEJObDIxTzRyYkZKenIzTzNkNGdwOVlQSnZJRW5VQWg3Mzc3cjJV?=
 =?utf-8?B?czRCemxxdy9xcy8zOTNVZ0dUOEwrVDlmZzZGMUhpc080MU44M2ordk5zT3p6?=
 =?utf-8?B?dkRraDNzTWFnSFBRRXNoT1ppdnpEdkNOOFN5eHRKS2M3Z1pzNWtGaDhWdU9Z?=
 =?utf-8?B?MzBKY1BoZHY2U0t1eXA1VUdKU2IrY3kxbU8zUitGM05FdjFRY1ZQQmVmb1JX?=
 =?utf-8?B?cE9wclNqMXhuR240bThPNjRSRDdROXU1Zkt4dGMvYXdad3lIdUxHWG1GeGU2?=
 =?utf-8?B?YmxXUUVNVTN5WU9GVEh2SnBOL0R0aE1xd1M0OGhhb0RkTkgwSE8ya09QSkxM?=
 =?utf-8?Q?53Y4KhcLA+R+tTS4ubWBCZQLt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8b7008-4e97-4c25-7594-08dbd9745747
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 18:16:30.8478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzNLp3lJainCppRIut0VnC7KMYP7UdlbjbC3hSYK5F/3Q07ObyAZJMx0eDNLh1FVcKEZTMAZ3a72xQMxKFKzdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> Add a snp_guest_req structure to simplify the function arguments. The
> structure will be used to call the SNP Guest message request API
> instead of passing a long list of parameters.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Some minor comments below.

> ---
>   .../x86/include/asm}/sev-guest.h              |  11 ++
>   arch/x86/include/asm/sev.h                    |   8 --
>   arch/x86/kernel/sev.c                         |  15 ++-
>   drivers/virt/coco/sev-guest/sev-guest.c       | 103 +++++++++++-------
>   4 files changed, 84 insertions(+), 53 deletions(-)
>   rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (80%)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
> similarity index 80%
> rename from drivers/virt/coco/sev-guest/sev-guest.h
> rename to arch/x86/include/asm/sev-guest.h
> index ceb798a404d6..22ef97b55069 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -63,4 +63,15 @@ struct snp_guest_msg {
>   	u8 payload[4000];
>   } __packed;
>   
> +struct snp_guest_req {
> +	void *req_buf, *resp_buf, *data;
> +	size_t req_sz, resp_sz, *data_npages;

For structures like this, I find it easier to group things and keep it one 
item per line, e.g.:

	void *req_buf;
	size_t req_sz;
	
	void *resp_buf;
	size_t resp_sz;

	void *data;
	size_t *data_npages;

And does data_npages have to be a pointer? It looks like you can just use 
this variable as the address on the GHCB call and then set it 
appropriately without all the indirection, right?

> +	u64 exit_code;
> +	unsigned int vmpck_id;
> +	u8 msg_version;
> +	u8 msg_type;
> +};
> +
> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> +			    struct snp_guest_request_ioctl *rio);
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

May want to mention in the commit message why this can be deleted vs changed.

>   static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>   static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>   static inline u64 sev_get_status(void) { return 0; }
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 6395bfd87b68..f8caf0a73052 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -28,6 +28,7 @@
>   #include <asm/cpu_entry_area.h>
>   #include <asm/stacktrace.h>
>   #include <asm/sev.h>
> +#include <asm/sev-guest.h>
>   #include <asm/insn-eval.h>
>   #include <asm/fpu/xcr.h>
>   #include <asm/processor.h>
> @@ -2167,15 +2168,21 @@ static int __init init_sev_config(char *str)
>   }
>   __setup("sev=", init_sev_config);
>   
> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> +			    struct snp_guest_request_ioctl *rio)
>   {
>   	struct ghcb_state state;
>   	struct es_em_ctxt ctxt;
>   	unsigned long flags;
>   	struct ghcb *ghcb;
> +	u64 exit_code;
>   	int ret;
>   
>   	rio->exitinfo2 = SEV_RET_NO_FW_CALL;
> +	if (!req)
> +		return -EINVAL;
> +
> +	exit_code = req->exit_code;
>   
>   	/*
>   	 * __sev_get_ghcb() needs to run with IRQs disabled because it is using
> @@ -2192,8 +2199,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
>   	vc_ghcb_invalidate(ghcb);
>   
>   	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
> -		ghcb_set_rax(ghcb, input->data_gpa);
> -		ghcb_set_rbx(ghcb, input->data_npages);
> +		ghcb_set_rax(ghcb, __pa(req->data));
> +		ghcb_set_rbx(ghcb, *req->data_npages);
>   	}
>   
>   	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
> @@ -2212,7 +2219,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
>   	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
>   		/* Number of expected pages are returned in RBX */
>   		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
> -			input->data_npages = ghcb_get_rbx(ghcb);
> +			*req->data_npages = ghcb_get_rbx(ghcb);
>   			ret = -ENOSPC;
>   			break;
>   		}
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 49bafd2e9f42..5801dd52ffdf 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -23,8 +23,7 @@
>   
>   #include <asm/svm.h>
>   #include <asm/sev.h>
> -
> -#include "sev-guest.h"
> +#include <asm/sev-guest.h>
>   
>   #define DEVICE_NAME	"sev-guest"
>   
> @@ -192,7 +191,7 @@ static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>   		return -EBADMSG;
>   }
>   
> -static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)
>   {
>   	struct snp_guest_msg *resp = &snp_dev->secret_response;
>   	struct snp_guest_msg *req = &snp_dev->secret_request;
> @@ -220,29 +219,28 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
>   	 * If the message size is greater than our buffer length then return
>   	 * an error.
>   	 */
> -	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
> +	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
>   		return -EBADMSG;
>   
>   	/* Decrypt the payload */
> -	return dec_payload(ctx, resp, payload, resp_hdr->msg_sz);
> +	return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
>   }
>   
> -static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
> -			void *payload, size_t sz)
> +static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
>   {
> -	struct snp_guest_msg *req = &snp_dev->secret_request;
> -	struct snp_guest_msg_hdr *hdr = &req->hdr;
> +	struct snp_guest_msg *msg = &snp_dev->secret_request;
> +	struct snp_guest_msg_hdr *hdr = &msg->hdr;
>   
> -	memset(req, 0, sizeof(*req));
> +	memset(msg, 0, sizeof(*msg));
>   
>   	hdr->algo = SNP_AEAD_AES_256_GCM;
>   	hdr->hdr_version = MSG_HDR_VER;
>   	hdr->hdr_sz = sizeof(*hdr);
> -	hdr->msg_type = type;
> -	hdr->msg_version = version;
> +	hdr->msg_type = req->msg_type;
> +	hdr->msg_version = req->msg_version;
>   	hdr->msg_seqno = seqno;
> -	hdr->msg_vmpck = vmpck_id;
> -	hdr->msg_sz = sz;
> +	hdr->msg_vmpck = req->vmpck_id;
> +	hdr->msg_sz = req->req_sz;
>   
>   	/* Verify the sequence number is non-zero */
>   	if (!hdr->msg_seqno)
> @@ -251,10 +249,10 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>   	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
>   		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>   
> -	return __enc_payload(snp_dev->ctx, req, payload, sz);
> +	return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
>   }
>   
> -static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
> +static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
>   				  struct snp_guest_request_ioctl *rio)
>   {
>   	unsigned long req_start = jiffies;
> @@ -269,7 +267,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   	 * sequence number must be incremented or the VMPCK must be deleted to
>   	 * prevent reuse of the IV.
>   	 */
> -	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
> +	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
>   	switch (rc) {
>   	case -ENOSPC:
>   		/*
> @@ -279,8 +277,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   		 * order to increment the sequence number and thus avoid
>   		 * IV reuse.
>   		 */
> -		override_npages = snp_dev->input.data_npages;
> -		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
> +		override_npages = *req->data_npages;
> +		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
>   
>   		/*
>   		 * Override the error to inform callers the given extended
> @@ -335,15 +333,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   	}
>   
>   	if (override_npages)
> -		snp_dev->input.data_npages = override_npages;
> +		*req->data_npages = override_npages;
>   
>   	return rc;
>   }
>   
> -static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
> -				struct snp_guest_request_ioctl *rio, u8 type,
> -				void *req_buf, size_t req_sz, void *resp_buf,
> -				u32 resp_sz)
> +static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
> +				  struct snp_guest_request_ioctl *rio)
>   {
>   	u64 seqno;
>   	int rc;
> @@ -357,7 +353,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
>   
>   	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
> -	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
> +	rc = enc_payload(snp_dev, seqno, req);
>   	if (rc)
>   		return rc;
>   
> @@ -368,7 +364,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   	memcpy(snp_dev->request, &snp_dev->secret_request,
>   	       sizeof(snp_dev->secret_request));
>   
> -	rc = __handle_guest_request(snp_dev, exit_code, rio);
> +	rc = __handle_guest_request(snp_dev, req, rio);
>   	if (rc) {
>   		if (rc == -EIO &&
>   		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
> @@ -377,12 +373,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   		dev_alert(snp_dev->dev,
>   			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
>   			  rc, rio->exitinfo2);
> -
>   		snp_disable_vmpck(snp_dev);
>   		return rc;
>   	}
>   
> -	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
> +	rc = verify_and_dec_payload(snp_dev, req);
>   	if (rc) {
>   		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
>   		snp_disable_vmpck(snp_dev);
> @@ -394,6 +389,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   
>   static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>   {
> +	struct snp_guest_req guest_req = {0};
>   	struct snp_report_resp *resp;
>   	struct snp_report_req req;
>   	int rc, resp_len;
> @@ -416,9 +412,16 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>   	if (!resp)
>   		return -ENOMEM;
>   
> -	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
> -				  SNP_MSG_REPORT_REQ, &req, sizeof(req), resp->data,
> -				  resp_len);
> +	guest_req.msg_version = arg->msg_version;
> +	guest_req.msg_type = SNP_MSG_REPORT_REQ;
> +	guest_req.vmpck_id = vmpck_id;
> +	guest_req.req_buf = &req;
> +	guest_req.req_sz = sizeof(req);
> +	guest_req.resp_buf = resp->data;
> +	guest_req.resp_sz = resp_len;
> +	guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = snp_send_guest_request(snp_dev, &guest_req, arg);
>   	if (rc)
>   		goto e_free;
>   
> @@ -433,6 +436,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>   static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>   {
>   	struct snp_derived_key_resp resp = {0};
> +	struct snp_guest_req guest_req = {0};
>   	struct snp_derived_key_req req;
>   	int rc, resp_len;
>   	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
> @@ -455,8 +459,16 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>   	if (copy_from_user(&req, (void __user *)arg->req_data, sizeof(req)))
>   		return -EFAULT;
>   
> -	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
> -				  SNP_MSG_KEY_REQ, &req, sizeof(req), buf, resp_len);
> +	guest_req.msg_version = arg->msg_version;
> +	guest_req.msg_type = SNP_MSG_KEY_REQ;
> +	guest_req.vmpck_id = vmpck_id;
> +	guest_req.req_buf = &req;
> +	guest_req.req_sz = sizeof(req);
> +	guest_req.resp_buf = buf;
> +	guest_req.resp_sz = resp_len;
> +	guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = snp_send_guest_request(snp_dev, &guest_req, arg);
>   	if (rc)
>   		return rc;
>   
> @@ -472,9 +484,11 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>   
>   static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>   {
> +	struct snp_guest_req guest_req = {0};
>   	struct snp_ext_report_req req;
>   	struct snp_report_resp *resp;
> -	int ret, npages = 0, resp_len;
> +	int ret, resp_len;
> +	size_t npages = 0;

This becomes unnecessary if you don't define data_npages as a pointer in 
the snp_guest_req structure.

Thanks,
Tom

>   
>   	lockdep_assert_held(&snp_dev->cmd_mutex);
>   
> @@ -514,14 +528,22 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	if (!resp)
>   		return -ENOMEM;
>   
> -	snp_dev->input.data_npages = npages;
> -	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
> -				   SNP_MSG_REPORT_REQ, &req.data,
> -				   sizeof(req.data), resp->data, resp_len);
> +	guest_req.msg_version = arg->msg_version;
> +	guest_req.msg_type = SNP_MSG_REPORT_REQ;
> +	guest_req.vmpck_id = vmpck_id;
> +	guest_req.req_buf = &req.data;
> +	guest_req.req_sz = sizeof(req.data);
> +	guest_req.resp_buf = resp->data;
> +	guest_req.resp_sz = resp_len;
> +	guest_req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
> +	guest_req.data = snp_dev->certs_data;
> +	guest_req.data_npages = &npages;
> +
> +	ret = snp_send_guest_request(snp_dev, &guest_req, arg);
>   
>   	/* If certs length is invalid then copy the returned length */
>   	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
> -		req.certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
> +		req.certs_len = npages << PAGE_SHIFT;
>   
>   		if (copy_to_user((void __user *)arg->req_data, &req, sizeof(req)))
>   			ret = -EFAULT;
> @@ -530,7 +552,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	if (ret)
>   		goto e_free;
>   
> -	if (npages &&
> +	if (npages && req.certs_len &&
>   	    copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
>   			 req.certs_len)) {
>   		ret = -EFAULT;
> @@ -734,7 +756,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   	/* initial the input address for guest request */
>   	snp_dev->input.req_gpa = __pa(snp_dev->request);
>   	snp_dev->input.resp_gpa = __pa(snp_dev->response);
> -	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
>   
>   	ret =  misc_register(misc);
>   	if (ret)

