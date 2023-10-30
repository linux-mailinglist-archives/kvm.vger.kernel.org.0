Return-Path: <kvm+bounces-132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 730DB7DC138
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 21:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B5851C20B6E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 20:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867781CF83;
	Mon, 30 Oct 2023 20:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uE3Px87P"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDD1CF8E
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 20:32:28 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E28CAB;
	Mon, 30 Oct 2023 13:32:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0C60U8pIopa1zcmaWcaOE9RYSWbormobRLJrWkjp8aFbO8efWY4wHgdcSEy9/1Q5ZKAyomv3HLsolAwhGuOB1kmeWBMf6dWudSXnMCwC9aD2Xj6JaGzaDTiCXceY+pk9scTNsCRkDHEj9X5BIjxERCSYAwkjKV8a483slkDfnL0yLkBrtsmN3PixwbPO1DVQFTJifWZkkBXrFRnkNo/aaBYI+T3/Ug2H4hXWOm0cltyxylfLp0ZOUl4kxF4c4bFBBpQxv2DGUmtAfXbIAs9oyR/6R+sHOmHGdM6xRptucQNImkMHw0EuiyGZu3+9UzNu0lI1XS+rts+1z7sD+2jlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvzQlQOCgR+97t1P+GAdGXoGyCMeg7dNhJkEAQkRW5k=;
 b=GtcJjL7n7hIY+j4lEml5BSkuQWp7GC6OWrJwy7Yf9yYnanPftUcW84JknhFV9D8DCOLjaov5cLlm/fPYL66AzKUN9Y3vQDTPTHAEQDxX0ElvYQam08pz32AlGY0mWinIOc9VTQWvOcRUp1eU6gVNI0wpqpXUVjAXLRrYLYGPIrttwzqHzTbFbaueIwhXyD7QRv2vAsf0kXkCjL0HWSN0SN8ewpKWiyyr4iyDtvIaMdLBvyJORMGuR9eqAtVHLDJ8cI+m3Ej97q6SRcKBf6lnq316HYuI4unoe8vRbkSRJGxikyqH8y+YAKsDR1c+IFRInnbNVhYLall8eduvrqyE9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvzQlQOCgR+97t1P+GAdGXoGyCMeg7dNhJkEAQkRW5k=;
 b=uE3Px87PMXQpbSyT/UPrT0aNl+V/gxTO5Z33gEXddL7qv9j+VsOgyi2kGIkowqKZbOfZ5TtfyeF2KN6/L05DEM8YxCs3CaQ+cRv/rGqydT00aCOVv0cKc6Wim4d0URw7EIHK+hyxubJftYEDQ2L1UQ3BBPxdhTeOtBScGtz4gkw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SN7PR12MB7022.namprd12.prod.outlook.com (2603:10b6:806:261::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Mon, 30 Oct
 2023 20:32:24 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 20:32:24 +0000
Message-ID: <8bd907ec-3f91-2e3d-de7c-ef753a005ea7@amd.com>
Date: Mon, 30 Oct 2023 15:32:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 11/14] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-12-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-12-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0096.namprd13.prod.outlook.com
 (2603:10b6:806:24::11) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SN7PR12MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 560c87cf-4215-450d-a552-08dbd9875337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DmEjSJAPmGGjAQvSQul5951igKqr7VcUuQScDj9uCMM31BWFkgFMSZ4+QNO+97rYL1TRWx2pAtUBtNuD9r9XbD9P3usBheYmdIVLMk23lfpI98MHuP/tQBwhLeXMbeU1KI8cS5GzFBjVLLs6z8QEyuP19uSW6MVnhvEwDzCVqEO0JyB//UyQ9YDb02+ETDTckxvfC5C4j3Ryu0pwCO51q/OVz8T/6+mF1N+yoQTCISUwGj72E8XivNlN726Vx0t3AFYTER3xjpIv7f7LiN6DmXXdslq6sKRVAiDePsn4PM/N3gRJ1FeSYB4CyYvmXzCAGE/UbOr0Mo9ZyWKhwJFbldjgK3ZZipo3S2WkhhP85FJSypDZU2NORKdsPIDdEA0Jl8WzyFg3wLAucdDF7wtbfyhxHf9gn+c4w9pMwiw6YOjynNld96nhWWqshRYHDHzqFTEdCZ7L1d22n6lNpTGvB8ZOmaN536qL6IXgucHDT88u4z5ZG9B6b9eD1+08eRxj7VTzUX+eW92SEjN+pKFkb9elonUt3hYcVPLps2T1zeuhHyIRnMnCD6x5fK9HmuxW2w9zmZprjSkK7iuU5RteylSaEUfTv9cAaoUga0JDfT1BC4HseVS7Oa8tsnjeac9/ZFCPEXlgxlDYPw9VSsCg6Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(346002)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(31686004)(41300700001)(8676002)(316002)(8936002)(66556008)(66476007)(66946007)(4326008)(5660300002)(38100700002)(2616005)(6666004)(6512007)(478600001)(83380400001)(36756003)(53546011)(6506007)(2906002)(6486002)(86362001)(7416002)(26005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkdaamVmS0RRVkxCQ25KWEFSR1F5NldtSmJiWFZqcldZcjFFU09CQVZ2VTdq?=
 =?utf-8?B?ekdVSFMvTndYbkRJSndOVStWd3lXdnFoa2NEMHNPcldXZWh0MzdkNWM3L2lQ?=
 =?utf-8?B?NmJyenVnOFh4dkFlcTFtSHhwTHV1V3c1ZkZMT1JVaEJBR3ZTV2RiZnhYMzNH?=
 =?utf-8?B?SzlLcnRPVmZSdWZOSW5kSStHb1IxaG5kUjliQlJNRWFXNzNER1ZzeXZWU2sx?=
 =?utf-8?B?c2h2Z3hvVnpUd1hhRmtuSVVNaE10VWFtY3U0L2FCWXRjR3hSYkdNVDRMbERU?=
 =?utf-8?B?Lzc0TWYzWVBheWtUMXNValNiYWdqYVZYUW40b2ZoSzRmYjMvODJNMG4yMFB4?=
 =?utf-8?B?aVU3WnR1dFlIekNzZnNIRUFyUWJ2azNjRDlLRDl4ck1peUhYamxMK3hYZzZh?=
 =?utf-8?B?Q09QOWhxWm9zQlVrQ01TeEdwbFJhRWdtY3pPdjlnS0ViMUFLTlRzSmxEWWNY?=
 =?utf-8?B?SndXN2IzS0ZOOFZZbjVHRU1nQ2VuSEx3aUJ6SUtORzV3cVAzT3lJMFB0ZnNq?=
 =?utf-8?B?aVFqTUVwWXR2Y3RDTHdjaEFSQVJ6K2QwWVc4SWZ6d3NIRHBWck9NaVo4ZzRJ?=
 =?utf-8?B?NzdzeC8vN1VlT1ZKRU1Lb2wrQS9EbU1mRmZHYzliZHVqdWVRQU12VWpzNmpI?=
 =?utf-8?B?bzdMZWYwbGtMVzl5YjRLWUxWZzdSNmg1MGlOOTZmMGlKaXRMOHBPOGlabURW?=
 =?utf-8?B?eExXOEZ1TjNCUEtMTVFDUHNPSGJzK3BNOHNtdVdPM1RNaTkvdEtvRWQrVnBU?=
 =?utf-8?B?OUhqNzkzVHVYSm1VLzJ6eXFlWDNQaDF0N3VnZExvNUxBTnNFU1IyNVBLU1FR?=
 =?utf-8?B?UkR0VldjMHlRdUY5akRONk11SnJoYnFFTlpzbW84NU5tUXluNkZuaWhCbU55?=
 =?utf-8?B?V2RuV3cxRzJrQkR2dnJ2MFJ1dWp0MFlTZ3U1RUlaL0hDdU9uc0NJWEJhS3RE?=
 =?utf-8?B?alY4ZHVRWXVUVmsvb1ZCOVZvNlMwdmhjbUtrWUxmQVV2UHZNdG5WWFRPdS95?=
 =?utf-8?B?TkxoYldad3FrZXhmWjE3VnZsTFg2YWJNNTU2QkMvbTNkcUN0dzk5SVozSzVu?=
 =?utf-8?B?OWNtMGgrZjlrYVYyWEhsTXdLYmNCcDExQ1pKSFpOemljVnNqOEFXSk9yU285?=
 =?utf-8?B?YmZLYldCczIxeUFmeUEvcncyNWJKV0FFNTdjNTNlZVhqSkVmbjY2c1ZlaEQr?=
 =?utf-8?B?SlZSOURDemNSYTR5ZjJPempjVDFBcmhSakdrakN5Y1FqSHdVZG51blFSU1lS?=
 =?utf-8?B?V0lWb2sySlVubmU3VGtiNktocHJsb2Z1Q1ZUTTh6QzFieDZSU1JuRFdKN2Ni?=
 =?utf-8?B?VmhTRE1FTkg3YkZXSE5ZWExtMFdEY0w5T3VaZWIzVnM2cHNlUUpZZjZUZU55?=
 =?utf-8?B?UzRLNWR3azRNa2o3Y2EyMGhhcUpOTnJ1ejdNQkFydzRPLytKZXB0SXJGTi9v?=
 =?utf-8?B?TjhrSjFXeFV4Wm5CNFpadlBlUk9nOEF3NzhyY1VGRHFUd01JdjJybjBCZjlK?=
 =?utf-8?B?VnlSQ2dVNm82ZWhQY01hNWlaZktzSkNpQzB2ZU1jRVphSG5rcG1STkxvNE5n?=
 =?utf-8?B?ZGNLaTUvU2dRRGtTUE5QRS84bExFajJvcjYvVTV5SVF0KzE2NERJaE40QTN4?=
 =?utf-8?B?VVc1emViVFF2cFhXaWp6dFN2M2sxREJFREgrR2tldmVxQlQ4bVk2QVJ5WEV6?=
 =?utf-8?B?RnJxbEZPaG53NzBxbkpZTnZNcVdyRWgrLzg4UXpYckJpNlBXMXp5bkdDMXJK?=
 =?utf-8?B?bEc4WXRidS9ZR09nUitoMk9CTDU2d01uQ05PbFpJQm5jd09JQ1NPZlVYZm9w?=
 =?utf-8?B?d0JtZVI1eU1PNXVJalV4dCt6TEdwdXZVQnJOYW4vZG1GSTZPbm12RHJIRnNZ?=
 =?utf-8?B?TnhiTFRqa3l1YnMwSVViUWc1bTdUSGNiQkxJZlhBZU81WDZWYmtNRlB6bDg5?=
 =?utf-8?B?V1lZZnBJdUIzY0FzQkhlcUFMREgweGc4bE9DdFpoZEJSelhvTkloSXpOWEZo?=
 =?utf-8?B?SDZjaEZJL1AxWDlLWUthM0VyMUp4QmM2RGpzb0lyQ3dhYzRZT2U1TXFBMmdm?=
 =?utf-8?B?aUZVQUxWYmpjTm41VjdCSm0rcEZXMHphNmlWYmExMS8yY25qQUVTcEZiZXdz?=
 =?utf-8?Q?DGthq0MWwyh39usjkX9Q4joSF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560c87cf-4215-450d-a552-08dbd9875337
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 20:32:24.5407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ENrYkiHl2sTVBUgyPqqOsI3GsbA8pdfCEBulORlmQ7NiA0/r28eAIxp7NB8hwIiamkpeYc7cmbhX0fbBnXhBQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7022

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
> is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
> instructions are being intercepted. If this should occur and Secure
> TSC is enabled, terminate guest execution.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/kernel/sev-shared.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index ccb0915e84e1..833b0ae38f0b 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -991,6 +991,13 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>   	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>   	enum es_result ret;
>   
> +	/*
> +	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 */
> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)

If you have to use sev_status, then please document why cc_platform_has() 
can't be used in the comment above.

Thanks,
Tom

> +		return ES_VMM_ERROR;
> +
>   	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
>   	if (ret != ES_OK)
>   		return ret;

