Return-Path: <kvm+bounces-128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F062F7DC046
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 20:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ED9A1C20B46
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06D41A292;
	Mon, 30 Oct 2023 19:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z9QeI7m5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A745E1A271
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 19:19:45 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4744AA9;
	Mon, 30 Oct 2023 12:19:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYYcSIlIWBT23AGag1Du0kb9VzaKJ2ArKLZxGlPA9nkp34/9Sm/9JvBSHS96D0jCqdoCQawiDxsGnfzB7nltIEUjYLgddRtM9hCcJ+j9VPs425g9CpcKD/R3caAEu6hWcGOjjEcyyJ0kiXxWwDaetsp+uYwuOGzKX5fkePFt6Bsne9WleGEGFiav3YTCnni3noFs4KxUhEvStZxJfZ5KRA90aPKgxoKp/YpDaN6hGz4/jxQpTtqD8T5s3srA1y9aPANflUsbzqTHrg4XHEHUp5LLlSQB5OSm1cZJ91hQ0qrC0DpslX685d4Mn1SAVKreE1kfYUohLSieimlmhRCZ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HC0F4DX4OI70JALnKe3QiCRnFkorcl4LlbGk8ulOwZU=;
 b=G4wXPP54X5x0/cAh5HVqRGoWpOZRa+A3fy9Sw5HlNZx5g1jgGWWQMCKecAt2U/Xo0r8OFxRBIHl4ADRCxDMFHiTMGOwKMJguM9QVb304eegosek0/GKqeQnQhRsp+0caxDSt3d7Iq5erG8mGHxrF0T6zhQycDkElQmQfXEmvmrenZrthSDYQ4GPlh/hE6o3Q3yEvkpeDGOeiqTkSnumwassDXQfTLZHtkBTl3vtehwqS4AelVePb/n5zhmNOnczFDRj8SgpTkD+FhDm3BgY1WWlvpNR7DduW2kLv9xg4QGwFEPenM7WaF4xKEGQmdeOPi+H3ghTMahh0PydT+7yJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC0F4DX4OI70JALnKe3QiCRnFkorcl4LlbGk8ulOwZU=;
 b=Z9QeI7m5OuM4MCJYzHh3g7m//xQ7+GAR3j/OPfUcE7v5+aK7s+BEpN+eodTdoQxuJd7S7kwOJt04blcHzvkR5WBoui55Fjo25MF93Nvbmb07DlGMWtARazmlpL9YC28aYW8MiH7oMlwbPPp54m7T9Jl067RFVGk4xGsw9Cy2rlI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ2PR12MB7866.namprd12.prod.outlook.com (2603:10b6:a03:4cc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 19:19:41 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 19:19:41 +0000
Message-ID: <afc3e286-5a2d-62e8-e55e-b95ebe4373f4@amd.com>
Date: Mon, 30 Oct 2023 14:19:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 08/14] x86/mm: Add generic guest initialization hook
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-9-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-9-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:806:130::22) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ2PR12MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: d883cb7f-47f7-4938-118f-08dbd97d2acd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	apYxcWE2k1jfnguX4WyUApV2ZKPziiz6q8B+20IjiZQtCzCYX7ZcUeYf/BZ1CrP9If389yPEOkidoY41rZBIbUT89Rm7iSL2udUTnBlZXZ16fMK73J80JNCD85jcmLHHRHUMysACO4XA+khcSenyFcgcPRZSDP/B1EDg35vTk+1VUPTKQIehL3IQ2em3I/yd8gJO++sYJuKtAb566KOBXkosKloGPROst+JSDyjFszAmCndxp3L1xf46/6McTRHX36CDsoF3a2JqWGw6UGW5ZIcI4ZTAAOifPjKvVzL0TbMj0by8QaEh1ot47SRVdDTU/Zf0fm+2YlkGHxjpWZEmmu4PwhgpCASxp6DoK1fZGpoj8XS7o+BG7Ud9QOkkEdN4I1WS4Abf0Y3ivq8m/JLI1diwLnXNsDJo1VEc7ms6GdNdUvK+2JTEjgXCTF56nhdCasUBd3UTwXUR3QGOxBUnUWksxDn8kxDfn8Crhr3zw7vNEA/KfBQH/hAcv850maE7WssMLRD+JWveNn0B6Dmml9quwRI7HEwNt7yUb+mKhCxJfa+Q8e/7LbbGWwShinlnAMTrrviVAQCllE9/GwIq6ds+acnHfoveIoCb5xStxnkQR0ki1HWPoOzlIWRap9hsbGQRkJWcf8yPrylYiz40D75s8PFpBoFCyBT9ItWFBm8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(396003)(39860400002)(346002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(31686004)(6512007)(53546011)(6666004)(83380400001)(6486002)(478600001)(6506007)(41300700001)(86362001)(31696002)(36756003)(38100700002)(7416002)(66476007)(66556008)(66946007)(26005)(2616005)(2906002)(5660300002)(4326008)(8676002)(8936002)(316002)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckp4WEZVck12NEhtY3JXaU8rS1dpTGJudmpwOUdjWHRvQys0dXI5TnZ3eUFX?=
 =?utf-8?B?QkZsallrWWpHRlpveU5Cb1dsL1A5dXdiV3VxdFNnZHpYQ0pTcktUR2dCNmFD?=
 =?utf-8?B?Njd6OGgyaG0wVGlFNi9yWlp1YmIwTm13TUdSS0VDUWw5dWhrcGhlc3hUMEVY?=
 =?utf-8?B?eCtEd2RxQnZ2RVF5TTJqNmUzSFh2cm5Xc2tkTkFNdmI4MUpIS2FtMUxhU1Ey?=
 =?utf-8?B?ZUFnbWlSRVhEbGFidDlyWTlnNE45ZmdTYmdVMVVtejlwS0liL25GVS9HeU1r?=
 =?utf-8?B?Yml5dWxNdGVqbGQ4bE9zUngrazZmRUtDMG5Yc3oxTTVrd1hJLy93cFpacjdM?=
 =?utf-8?B?dlRqMmgxNEpmbm1NRG1BN04ySG9WOXJNaGhkdExQMERySHpYUHhHM3F4MFc5?=
 =?utf-8?B?Um1aUGkyWkxId2FndlNiaUJlUUZNMTg5L2tZMXlLeE5YcmpMT2tJMnVaTytu?=
 =?utf-8?B?Wll6NEhJaHEwUDFVT0hOelVNV2d4SEpaRWFZTlZmeVd1b09LVFIxSVJYcGpv?=
 =?utf-8?B?Y3lsbzRwbG9sdW1NakFtUzNwZytrU2I2K0VBRlZqWmZuU1d5Q1hYVmxkUit2?=
 =?utf-8?B?YklRWTQvSW0rcGFsTEp4Q0lrbnBRUml0ZjBRRnJSTWNZdTgwRDZLU0ZUMk1s?=
 =?utf-8?B?WVc4UkVqSi9HR3hkaGtqWVJIQ0pxcGtCenBDekdKbnRPR0dlVGN1NWQzSE1v?=
 =?utf-8?B?N3JvT085aHNoT2lNd1lnRjNWMVZZb3o0YlJHMWJyRzIwbzNvTGRiZkJyQnBn?=
 =?utf-8?B?VDcxcDNoSFBwOG1pZlo4SkJyUmVkTFUyQkpjYW51NndnS0pIS3A3ZWp0ZWlC?=
 =?utf-8?B?U2JzYTF5ZXJOb1NWV0NBZkd1M1pwU0JvbzhRN1hEanRuRnJiTWtXWHpFVExj?=
 =?utf-8?B?aThKamY4Y2NaYTZKcXNyb01ZeEttNVpWVVovSFRrZnprdW9QeFdzbzNTbkhX?=
 =?utf-8?B?aXJ5L3BoR3AyNzVSQ0l3RFdkY3ozUDJvQlI2NVlPZTluWWcvYkY3aS92anN3?=
 =?utf-8?B?bFZzaUc0YnJMOGltWFA5ejJHUUttTkNKSlVVWUNkcXJOYzgzN3MrK3FJS2d1?=
 =?utf-8?B?RVYzell4SzdwU2R3YzJmNlVsZVp4OFF3MHdTZzVRTXlJdDQ0QTFmNElRclk3?=
 =?utf-8?B?Z0dCeG1KejU0OE1aSm1DVEsrekl0WUs3T0YwRGpFaERaelJtZ2dRUjRpZ2xB?=
 =?utf-8?B?K25jTE1hMkszU0Nad3FXR1IrSFBiQWVkejRLekpndXZISkovRVJmT0ErWmpj?=
 =?utf-8?B?cUhCcHJkakF1am9keWQzQVFYL0lURDRNaWhoMFBkcFQ5ZzVVVkQvVFBDUDFa?=
 =?utf-8?B?aVh4NmZtcHdRZXNOQWhUMnVTVGtiNWtLK1I2S0NnUHRXeEVlYm5vdkZZZGxK?=
 =?utf-8?B?aUtEZ0srcDFxT3UvUlFTditoK0wzOE95ZWhGTzhEY1N0NHZRTmV6UGh6L0g1?=
 =?utf-8?B?U2xRYlowSnBTd29UQUxCOTRMT1FuN1ZZNTMzczMwUWNFNFJPMis4dmZGTDdB?=
 =?utf-8?B?Z3E0Qk9XelppZWY0S0RPTVd0UE9ZLy91bEdjclhLNDBTWGh4MEhKSElmcWZo?=
 =?utf-8?B?ZFRabDlNTUkvcXBZMkFlYzJEdE43dGdFQ2pZWHpyWUpqZXRTYmxoRUZtbzls?=
 =?utf-8?B?Q0J5TzVaeElsSkdoRlVYbmc4SElDOC9GejNUUWtHemZzQ09zRTVuYit0bzgy?=
 =?utf-8?B?TnpOM3BDc3hZditBUWpJZEI1enhRTm43SENpN3JrcVNSMDFqenYxTUpPSTJx?=
 =?utf-8?B?QncxT2xzaGhEbFdTZVdpT3Y2STEzQnVZMzNiVy9DUVpKZ0p2T2tucm5MWlFI?=
 =?utf-8?B?Vy93WWlPS2s3RW1Jek01aTlhMEZuWm93V3AvOUR4Ukd4MlpqOFFCUERSenhz?=
 =?utf-8?B?NHRydHBvY1QwN2VjM2wza0xoMzRPTDZOOEFSV3g2ZytZSkdyOW9OZFNtTkFH?=
 =?utf-8?B?bGJ5LzM3UVRycGtnY2p0YUxMVDFwQTdJdjEyZlFiNDVNMERpZ1VFcUMxWmhW?=
 =?utf-8?B?QW5QYWc0bzh5N1ZQbm5TOU1xNEtSRitDdnpuVUN3VlNCTThEUURWVTNwSU4y?=
 =?utf-8?B?UVp5R2VCcFY1czdGS0hsVWFJTEMyUC9FTmpjSzZMK1dXVW96Z3dtWEJjSmRk?=
 =?utf-8?Q?BwTmhJd5bqgePe6jPfClgTdAq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d883cb7f-47f7-4938-118f-08dbd97d2acd
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 19:19:41.6782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KL3IuljxZZiWtpX5jlDpGu1EhLK9cFsSla/wPUqh5rjtBcGcu/+wstVWq+euCEYvxO3ci+Mh2D2VyTmlxgA90w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7866

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> Add generic enc_init guest hook for performing any type of
> initialization that is vendor specific.

I think this commit message should be expanded on a bit... like when it is 
intended to be called, etc.

Thanks,
Tom

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/include/asm/x86_init.h | 2 ++
>   arch/x86/kernel/x86_init.c      | 2 ++
>   arch/x86/mm/mem_encrypt.c       | 3 +++
>   3 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 5240d88db52a..6a08dcd1f3c4 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -148,12 +148,14 @@ struct x86_init_acpi {
>    * @enc_status_change_finish	Notify HV after the encryption status of a range is changed
>    * @enc_tlb_flush_required	Returns true if a TLB flush is needed before changing page encryption status
>    * @enc_cache_flush_required	Returns true if a cache flush is needed before changing page encryption status
> + * @enc_init			Prepare and initialize encryption features
>    */
>   struct x86_guest {
>   	bool (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc);
>   	bool (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc);
>   	bool (*enc_tlb_flush_required)(bool enc);
>   	bool (*enc_cache_flush_required)(void);
> +	void (*enc_init)(void);
>   };
>   
>   /**
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index a37ebd3b4773..a07985a96ca5 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -136,6 +136,7 @@ static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool
>   static bool enc_tlb_flush_required_noop(bool enc) { return false; }
>   static bool enc_cache_flush_required_noop(void) { return false; }
>   static bool is_private_mmio_noop(u64 addr) {return false; }
> +static void enc_init_noop(void) { }
>   
>   struct x86_platform_ops x86_platform __ro_after_init = {
>   	.calibrate_cpu			= native_calibrate_cpu_early,
> @@ -158,6 +159,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
>   		.enc_status_change_finish  = enc_status_change_finish_noop,
>   		.enc_tlb_flush_required	   = enc_tlb_flush_required_noop,
>   		.enc_cache_flush_required  = enc_cache_flush_required_noop,
> +		.enc_init		   = enc_init_noop,
>   	},
>   };
>   
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 9f27e14e185f..01abecc9a774 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -84,5 +84,8 @@ void __init mem_encrypt_init(void)
>   	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>   	swiotlb_update_mem_attributes();
>   
> +	if (x86_platform.guest.enc_init)
> +		x86_platform.guest.enc_init();
> +
>   	print_mem_encrypt_feature_info();
>   }

