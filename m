Return-Path: <kvm+bounces-133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665287DC177
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 22:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ED6E2816EA
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 21:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883FF1BDF8;
	Mon, 30 Oct 2023 21:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JuxqoGKb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F96C1BDC2
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 21:00:10 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571C7DD;
	Mon, 30 Oct 2023 14:00:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PILj6hCUWUIL3b2NoRyIz79vwVcvPuiOL55xfPJ65ZjjledXQUeqakt1XqdwSkO8yQZddncPtuxW8eUdCDg0BovPJrLZN7nuLjalAxDNIOsKsPrQ1BSBF2Q6OQkhm6RtEDUoxGfRtVaBKYpskYYqg+GKpLbpX+X7OYNpVQr0fDpk4OJ98CFMoffPiqKIJ3dC8n2zerefaMkp/8nMxVOJSJORSrDwy8DioaHgN++Ic58CQLSufag+9DVkKDGv++XlK/CzIIRZ4dT5XHRMVxdORqgDEc0D9kPVuxZQTHBX2pGz6o3gsf8e+4JmST7Xy1CYYyvi15QXudZG+6zptblqJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XaneCu9562uVHNPF2RVF3dc+sQJE6EXoTrW8175XIQ=;
 b=a9eb9yHlgBuCMJHssSYEMu80fdwuVmJgt6Qwmzd73nQa0v+MU6a0DjBZTCKze4h6ByM7ePH1ZQfcuix8pkry2gBa2weFN2jtycthbi3klMcyikUicUtwEDnBC2ycgEsnj7gM1aexSQFXtEY+L85UBY1jmZrTuNrPbgT990V6xplVhcBeQH/K02ITVgotUf+/cKy9AkgXP4VcSbQNq1+1gMrFio0J8y0+V2DQkcaClTGYBGvTGIk6oC5c8uIHaVBMR+B0EmrvXjO1D9yv+ApbJ9NVA4hynBfdb4loAG6rEAxdvTu1mFit7CVqfdXtWjol+UJnwwcVZGXg5GaYIfwlDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XaneCu9562uVHNPF2RVF3dc+sQJE6EXoTrW8175XIQ=;
 b=JuxqoGKbtN4O64fQyg72zWochm6xmBP0rNQA2PeejesrKHQ3ETBMUHB8oA6KdXOJTGfk/ZVw7uFQoGp2ct2f7iVeZsKI3ylDRdO/+nTZIzOoUNyqytX0p1nq95HrtTPbr212ZLNAqz9k5MLXpen32Glq/OQzIQd83Vd0ToIlOLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA1PR12MB8162.namprd12.prod.outlook.com (2603:10b6:806:33a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 21:00:06 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 21:00:06 +0000
Message-ID: <cfc9f863-dc07-7c23-7621-d2dc115651bd@amd.com>
Date: Mon, 30 Oct 2023 16:00:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 12/14] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-13-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-13-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:806:23::22) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA1PR12MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a7f016-64c0-4208-bcbc-08dbd98b31fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HRZzgC/B6KMoy13vDq8kuuljqbg/ZNWKWm4lnGuJzPgx5abpoItVvITLbrxSlOXkcLkAyL3gSk2Z5wke5OHtq7/Wx8DhDvDUQuqrd+qFHNN8AHqfmVdQ2+4fxEVhYGkiikGkBEG+jIuJp7PTQel+IrIIfT5QopHcmAjCqWDjTQSUhqYJSfUy/vrR2QJtNmVF5ynBjvtM3yuTVyz5XdXquTbnkOGJRZgqC63ir0wxon3x5X/zMmmw1VDcyvD7xFCKle4K+5g+Nv5i/ZVdE/Bow0+UU2ErBIMNrI3XzMPXackdPD5/0n3rfYaoeUQmJ5TaChlQJiZZmHK0ZhP9W3yXMvGmLj1VZnLqoR4w55wsWC8mC1tgssT5TeHX/BzZ+j2LsK18E+yqRS90W70Qo6nRFks77DiXbz8x3/nf58qLe4oC1IroC1VLQv/Koqy3/GSMfdByku7ycYTGyPfAXt3JBMcwDSKCEIjP7pk9Kqjl8Td+4ULaBfLQ+yPIwhh2x1/46D+7Xv1bknjXLu2fyKSLplllflJXKvnZeRiFqPL1gyLsLdn9p5AW0X+t+ldDkWQAV3bP7dpElEvOJCbCQI5SInOzvi1aD9LIX4j+yk7+PlfVf13Afb32Y+nQxDJYD5RzafSAFIy+aL4OKENPDUNdHQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(136003)(346002)(396003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(31686004)(6512007)(2616005)(26005)(38100700002)(31696002)(36756003)(86362001)(83380400001)(2906002)(7416002)(6486002)(478600001)(53546011)(6506007)(6666004)(66476007)(8936002)(4326008)(8676002)(316002)(966005)(66556008)(5660300002)(41300700001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlNIb1UxeEsreUwzRGkvWlUvQmlNbk5LNDhZNjlGenptV3B6SjlsTm5HZXBJ?=
 =?utf-8?B?NVIxRzdkR3U4Q3lRQ1liYXI5Qi9Ya0F4QTkxSzlCc0NoRXAxdTR5QUF4NjdS?=
 =?utf-8?B?dHR5U3FFZ3FCSW9VWGVodUFIQ1M3ZDZDckFRS0pxUWFLdytVVnFVUjNueDJw?=
 =?utf-8?B?QmRCRS84bG5kV3VjOUdYRDVXQXlSRXlyVXl3M3NuaVU4Q2wrMWkzRE9NNGt5?=
 =?utf-8?B?NUdUOUhnbC9Kd0p1dTRZK0VZMXMxM05HUlhkbEhPVEE3RzUxSGh4UDBpOWZs?=
 =?utf-8?B?dGhldUVZQTlhM0pGRlBqMk84NUtQNVk0WkRhemJjVzg1d2tMeDZzRTA3Ujdz?=
 =?utf-8?B?U1ZLZDN6SXU3NThNb25LcGMrSVZXdWZRVkpGK0V6NzExYXVEUEtocElERWZw?=
 =?utf-8?B?ZURZUnA3cEF6RVNRcWFLWU5MU0NEUDNBb2JiWU1PWWFUL0tINkZwdkNOWHZx?=
 =?utf-8?B?VElNenJ4N3o3ZGJ3THg2OCt6dWxSZUM4NjB6T3NxS0tlcUJJcXNNajR2Yzht?=
 =?utf-8?B?L25zZHgwR1JtbHllQ0ovNjZObmRzSk9iRDBhZm1hSkZKY2ZLWWlSUjVWNnVF?=
 =?utf-8?B?NEJSRG1ONXFXZnJMRDJ6SmF6NEJDK1kvdHhXbHFuSUx1a3hVMlM5RTVhTVZ6?=
 =?utf-8?B?NmRIeEZGeHdvcXQrS2o3VXNxckhVZzNsQnNlZnJ2US9STCtoZ00vQjJJUkhm?=
 =?utf-8?B?Q3d6cTdhS0habTdsY2xOdmZSUVNkbzJ4b2J2VE9HS3ZtMVpONmt0ejMwM1lY?=
 =?utf-8?B?bjRoL2VnbnVmSzVrVzI0SnBOOCtXWmt2TlNQTWJSYVFpQWVWY2lMVjhFZkRv?=
 =?utf-8?B?QXpPUTZZMW9XSDBvaW1vdlQ2Wjl1ZTMwY1hxKzJnMUtHeTdvRkhzNXFQM2FY?=
 =?utf-8?B?RFdYbnVRdUhBT2JlYXA1b1hwYkFEUmZkVzdMSzZhbFBnczB3RDZLMUhFSGVn?=
 =?utf-8?B?eXpHSHUvTlBlTXBZK3R6MHYzemUzZVBsM2FQUHM1WUVhdXErVVVUVStDT21W?=
 =?utf-8?B?Z3ByYnZIT3Q2ZEFwaWEvZktjUFJvR2trbWs5c0x6NlRVNTVMWU8xdVI2d1M3?=
 =?utf-8?B?NmFQUnVrQnVtWExYaEtjcmhnT0tRRW5xNXVhcnprOTFGT21uUkFiR3JJRk15?=
 =?utf-8?B?R3ZEdXl6dHZnLzQyRncxMFYrQTJZT1Frb1ZnSjArWEJ1Vm9meURpQ0F6OXRN?=
 =?utf-8?B?THlSYytRU2dTb1plTmtWY0N2SDUxclRDN1labVduMnVtK0dOU2FiNmY2dlY5?=
 =?utf-8?B?c2xkb1Rxd0Q2YVBQb08wUlBCNDg5RG5KTDBzVjBDSEs4a2YxYjRmRWhnajd5?=
 =?utf-8?B?MmIzZWtiQXlJUmIzQzlla29UZ0JuV1MydHFMdkFLSjVCNzgvZEpIQzk4SThE?=
 =?utf-8?B?UXNFcDRkbjBicitpSWhzVmtTamMzNWxKSEJyMEcrcVZuK1BDd3AwQ1ZuWE5C?=
 =?utf-8?B?YzlhR2FiYzZVY0txZmpzbzJheUpPKytLbyt4WXJ5RGFqbzFIVGJBdGxBWHlk?=
 =?utf-8?B?R2Yzb3dTQzN6VFY1elEzQUhCY3Nkbm1qVlREajlnRnVIQlRDdGNrVTY3RU5u?=
 =?utf-8?B?S29VY3labE5DVHd6Ty9ZUkFNSW55N1JWcHlZTkpiZmhlbkFKeURVcDh4NzhL?=
 =?utf-8?B?MU1tR3pDMkFieDcvbnJEVW5qTC9mR2wvMm90WEw1WHhMZHNpVFRCT3NDVVlJ?=
 =?utf-8?B?b2tJdUxZNWtGMVFPenZ4OE9VdHVYN3V4NEVBYTY5NnJCU3NmcnJwM0JSOGZ2?=
 =?utf-8?B?WWJ5bFg4S3g5WStHaUpZQU8zdDExcFErQ05TLzZ4TEQ3dmRQMDl0L09SYUps?=
 =?utf-8?B?aUU1TG4vaG1xMDRYcXdNVjdjYzgvZWxSNlQ3NzhycUVvMm9NQ1UzWUREbEc5?=
 =?utf-8?B?b2w1RnlSMGU5RzNmcWNsWUJaMTYvcHFEM1gveDJEVW5US2VBMTFlTWQyeWc5?=
 =?utf-8?B?L2J2RFVuQSs5bzZUd2dPdTJjbDliUEl6K0FhZ2VjdXRraHVCT21DaWpUZkVx?=
 =?utf-8?B?N3JlRm5lZ0hnTk9Sem43T05GRko5WHN5YldVakhHZ2QydWRsL21veXB0TFp2?=
 =?utf-8?B?T2JnMnBtODBvRHlXcnl1Ym8rVTlRdnNJV3V2ZFpiQjEzWEpvb0tPVnhuU2dP?=
 =?utf-8?Q?hpLdZAMCdXPHS75G1+/HMxK0T?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a7f016-64c0-4208-bcbc-08dbd98b31fe
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 21:00:06.7058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XoD310rKuNfLigbj0yJEyyyBM9jlY6uF1R8HGc7bDEvLu56JGxxGPlmM84HbRreMyRyerGGBYh+P67ylJIUZKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8162

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
> The guest kernel will fallback and use Secure TSC based clocksource.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/kernel/kvmclock.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index fb8f52149be9..779e7311fa6f 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -288,7 +288,7 @@ void __init kvmclock_init(void)
>   {
>   	u8 flags;
>   
> -	if (!kvm_para_available() || !kvmclock)
> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))

And is setting X86_FEATURE_TSC_RELIABLE, as Dave Hansen suggests, enough
to prevent usage of kvmclock?

There was a discussion here:
  https://lore.kernel.org/lkml/20230808162320.27297-1-kirill.shutemov@linux.intel.com/

Thanks,
Tom

>   		return;
>   
>   	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {

