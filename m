Return-Path: <kvm+bounces-2498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 088DE7F9AEE
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 08:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B5DF1C20980
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 07:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A5F710797;
	Mon, 27 Nov 2023 07:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="dDGTI0Uo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2115.outbound.protection.outlook.com [40.107.244.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDD619B
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 23:27:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElP7p7RjaVjjoGtFNuqAGdJvLdPd+ZzNX2ePbmajd60OGVpTTa5yKsTtYWt5Lvw6y0iqsyDJYyCoJ/0EKdfiSP3hEYnFVk6NMegARL+U7/qQ1L6e4H3Rs6iqyXt5rpqz0jh6uq6Jn7C6pfPYXUG5ritYicPkuyHkYyRR0/cc94I/gmSm+jyFImBtuVok7ET3MeC5BTb9uBESiw7oYwAibzzXWBEKLtRczgYyzyMAxjs2aExZ4+x2zI/ohcte1NS2dKheYCw89ZQVX8DO7gv/PUS804UF2sBlKAyqrA58sMKHlXudrfJDgr6WZk5T4AlrKLfHBcxrXzYvluIAzroJYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIGIhau9ByXWwOVnM1KVb1nPAtzPNMffomeRpF5rVIg=;
 b=jNR7ydRD9UuznaTYa+iXl/JngQ65OV4s1b+J9tA/OlDa5XGuNDJGq/Lz4S7pmCvh5ffHLzuMnWgzDQ4zdyvchlNRdH6+Hj5e7AF7X6mXqlS31+b82JZMLXEiB9aUvqmba7yz7S7nl6nH1b9Lm8IQZgyzM6k3bJrzkLmDt0vlOOV/NDm8UFb1XOE1Gc2LG8wpkLUBZ7CgzWm6ulOCEHe0LtQW7zaR9N5SUzMTHw5Z4ITSoyUv1dXdaRQTtiA3pihJ/AUUqbw5kk/F8A2sAFEh57aVTqk26FQCSyPM4PHQsUA1Dfb9pDG5489A/0NtMKZRoawmOMyAc8C54Aiq++zVIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIGIhau9ByXWwOVnM1KVb1nPAtzPNMffomeRpF5rVIg=;
 b=dDGTI0UoHWLWyFmjLCx8g3+XShQMm4a9kHulLovzttmUTpHayPtlw5dx0ln0/NCZIPy2vMTjqns95VL4kharOGypMnmowGkdK7dul2UQKB/36VFy3IHpU9GKpzBUbV3J0YlKzGStIRJR9gmbSsUeA5NxstDdX3rQJDHl8Pp7hW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 MW4PR01MB6356.prod.exchangelabs.com (2603:10b6:303:66::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.28; Mon, 27 Nov 2023 07:27:09 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 07:27:08 +0000
Message-ID: <9f8656c7-8036-4bd6-a0f5-4fa531f95b2f@os.amperecomputing.com>
Date: Mon, 27 Nov 2023 12:56:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
 <86msv7ylnu.wl-maz@kernel.org>
 <05733774-4210-4097-9912-fb3aa8542fdd@oracle.com>
 <86a5r4zafh.wl-maz@kernel.org>
 <134912e4-beed-4ab6-8ce1-33e69ec382b3@os.amperecomputing.com>
 <868r6nzc5y.wl-maz@kernel.org>
 <65dc2a93-0a17-4433-b3a5-430bf516ffe9@os.amperecomputing.com>
 <86o7fjco13.wl-maz@kernel.org>
 <e18700d4-061d-4489-8d8d-87c11b70eedb@os.amperecomputing.com>
 <86leancjcr.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86leancjcr.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:610:4e::21) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|MW4PR01MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: aa7277b3-0b9e-42f3-8d51-08dbef1a437d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wucDELmjNcEMhGHdvUfR3YdVZprz44unvNgl3964EglTLWDjIBx6tjzv7G1+5eXiOrtqFJS270uLPgME4Ays5rZ9QG1jGSpV9h6tYtwi0JNG0j8NwpvB9l93A5FWb+0c6TAFA8I/hzrIorxhT+c1VO80HJ3byPMlk62AmK6k6UZeaRS3UxFXhAhLr5OPIRDAKkILLEQ9+lDBjg57y4SUI1L01JSCPTcavirmlvEdP0O7NKAJGqxrS5FUOP7hkyPIup9amf88gDDjQTUulaBVU4dmji7dW7hLxYDPirXbpzq7a8qfs0MGZNmZmBFSZdmolu9xWDZDXUoXk6eFzjfqz+CdM2aH22PnR8yPzMOL/1aRyZa8Ad9avtNegJkB058K+ozYNcUojHs4zm8JkJceUc5UEWJyYeGHfjGWGAIxTaHijYUEyB+0QXgZoyL0icDvl42fbJUse9DBqduFIGfLsfJ10KdN3i8F2HRgy/MuMi9ecbwZBAlYedTp5uwxzJtYUrVFdhRVr+1DQ8txOR1TzXLNk4pKnf1uHUJRHw0r79Sen6BuVbEALRhDJ7IlNkA/qVFw+2Gf6lHlPGc0uFvTLdJad8qDwxCDekGAhnUDWwOFbu6r+tEtcFXWcX7nCY2+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(396003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(31696002)(86362001)(38100700002)(478600001)(6486002)(6916009)(316002)(54906003)(66946007)(66476007)(66556008)(26005)(6506007)(6666004)(2616005)(53546011)(6512007)(5660300002)(2906002)(7416002)(4326008)(41300700001)(8936002)(8676002)(31686004)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVRUSkFyQVJTTytGUERlb3hIdWhVRmtWVTJvS3pqemMrZ1V1c1pOR2lWYmMy?=
 =?utf-8?B?UTVZOThPNTBTQmw5Z09xNFcrNkltNmIyMzRGTUd0L2RGbnVVTk9Uc1loSEFo?=
 =?utf-8?B?SWx1MmFxUGE0VnZoc3F4MGZ3d2dYRnZxSkdRenFTZmh1VHFDcjBtaktmUmNX?=
 =?utf-8?B?MERUa2NtZys1eHkzS1NZUzhjeHFxejZMTm5raWxHVDJBa1JkTmsxOHJpL1BX?=
 =?utf-8?B?d0FxWlNZS01OZGZLUVd5ejgwRitWeloreEpoSG1Uc2hjeGxlaFU3YmRLT2Rz?=
 =?utf-8?B?MzhTR29SZUhQUXFWVWZBbGd6S2Z1Y2wyaDYrVmNEQ056ZHBTR0NQY3NOWW1p?=
 =?utf-8?B?bXRkelh4T3RNVVI1TUcwdVVDbU5FSFhBeWdGYXlGNXhpQWZZWDVsZHFLVGFs?=
 =?utf-8?B?clZGYm5RYTlwNjFDYTlLRXE3ZVlXZWF0dStJajJHYzhmZHY5aWJkdGtMb2NC?=
 =?utf-8?B?b2hBNTdoSXFHOFFmc1I3dFRJLzYrVnVpRlBscTJ4Sjhrd2NQTUVsTElvdTc2?=
 =?utf-8?B?WjJWSVgyNUxYd1FLV1hncmZxMXBETDB0RmZzbTlrTU1Xb2pCNDE3UldtdXRI?=
 =?utf-8?B?d0UwT2kxSzdadG05NHZqMzdPSjVKNHgxTXR2UTJYSkN3dnl0aUo4WHRUUVln?=
 =?utf-8?B?MU5ibGF1dCsyMDg4WXZla0dhRWx3bXllbXVKZHZnMWpFN2lFaU5SKzE5NG5T?=
 =?utf-8?B?QmU4RjR2ak5xelc1cGpBOXhqSEZQbDEwRWtVVWdlYmRBdTR6TWM5cGtJVkZv?=
 =?utf-8?B?YVBiUWpWNG1IM1NmcnZ0YlVxbUtVcFVKMFpjWGpGWVhvNzZTUWhXaG8zSEVM?=
 =?utf-8?B?dnNIcEUzYjljd3FIMnJETDIwNDlZSVF6RjJqRFZIMUMxOURuUnlRSHlvbjFo?=
 =?utf-8?B?S21RMTNrTEpubmNZUTRZYyswZ0Z4S09JWjFjL05TWS9laks4YkhLS1pGS1lP?=
 =?utf-8?B?U1VUWGhEYTAyalc2c01uN21jSC9Ncnh3dmFLaWZhMFlTU095YTdUbWJXQ0lt?=
 =?utf-8?B?cHdXcUlJYnIzZGZQOWVBbURNRjNpQTI3eGtJRkQxKzh3eG1VWVNCVFpSZFBL?=
 =?utf-8?B?RUlQcFdkczNaZzBDeUdkT2lsL2FheGU3M2poZ0Z4bk8yWCtoUkNYWmRVMTJV?=
 =?utf-8?B?VFR3Q1ZtU0lURDkyV3lCUk9iWjZBTHRKclNiVmZBdk5aQTlBQ2RnSkF2Tmha?=
 =?utf-8?B?Y2lmTzM3U2Y1eGM2SnpXcUNsYXRtK2c2c29NSlhuTWpnREQ2K25QYjhLUlNz?=
 =?utf-8?B?bGVuS21rOHpjS2pCQ2E5NFRCd0ZTVmczSVM5NmQyaXdhUWRucDNuZkwzRWRa?=
 =?utf-8?B?aDRZY3RPK3VJN0g1VVVwcGVRM0VXczRtYUVjbWo2YWZSZld4Vlc4UGluZXlG?=
 =?utf-8?B?OXhJOVcxYlNCaktmalhVc0FLSGkyYURDMmE3U05iRmF2eXpNMW45ZndaVndC?=
 =?utf-8?B?ZkZyTkpzM2JSTkVCNG13bzlXeW9weDhBNHNvNkQ1YVZabnROSENpeGJDNDBV?=
 =?utf-8?B?MU5hY2lXK2ZaVnAxWjhQZ2VHakZXNnhoL01JUlNua1hEK2lSekh5eTVCaThL?=
 =?utf-8?B?ODNNWExKTjBBNGg3NzJsSnF3bFBreTJnZmtjbW1YTnVSVmFBczlGa0JTMmlY?=
 =?utf-8?B?bTUzeERiWXpiU3c4QTJ2MWFEUExyR3c1M04rdzd1cGJ5Z1o5NytSWEVMUXBn?=
 =?utf-8?B?bHI2STh5blFkamNGTFlaZkt3SzVHbDkrRlVuVXUyYXVUUnBDTTBqM1dreHpj?=
 =?utf-8?B?aXlMalhNNVdzY1hQdWljNFF6OFpnVFJiVkJOWG1FcGcyQldWN0gwZEg2SXpu?=
 =?utf-8?B?M0lpRkpaQm9CNE9JS2xFSnNoQjE0WXBBSFFoZFdiT1V1d0drcGE2NStUNFZZ?=
 =?utf-8?B?eTZyZEwrM25LRjdRbjg1eDhSZFh5S3d4cnU3UXA4ZnhiWHBoQm42ejlrMitE?=
 =?utf-8?B?WDl1RytUZG53ejgvYTN3aWd0Y294WFIrQ3RLdGpIZjFsd0JPcFFYdzZGL1Jy?=
 =?utf-8?B?eVNnNTFXdVdJMjdjT2FhQThKYlp4RS85UDBkdU5KRms4bXQ4cFBTNU00L2Ux?=
 =?utf-8?B?U3FoUm5sTXFheUV0QmpYRFhncTRRb3o3NVU5NUhyZEoyV21aUzlIYXlwdHNT?=
 =?utf-8?B?YW1OaHJIcUZOMnZYTTY4TUNuMFRuYm1mTDFiRi9ocE5YL3J0SkIrZVk1TnU1?=
 =?utf-8?Q?NK5DdlVGF0NwiI8js7wjunawwCBXeElFwQNZRmpXH5SJ?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7277b3-0b9e-42f3-8d51-08dbef1a437d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 07:27:08.5258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MapSeSn0CvnuVPHDynUbA+H8XfqhSP2wfOrsti/uSNG0QHaZXVZctzn8B/e3MdyQ24H9WXmpcMizZNGDSF+FzJ3DkPG+tzLcYGxpTzY0R44aY8D5mlYHS90yBJgJhUcc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6356



On 24-11-2023 08:02 pm, Marc Zyngier wrote:
> On Fri, 24 Nov 2023 13:22:22 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>> How is this value possible if the write to HCR_EL2 has taken place?
>>> When do you sample this?
>>
>> I am not sure how and where it got set. I think, whatever it is set,
>> it is due to false return of vcpu_el2_e2h_is_set(). Need to
>> understand/debug.
>> The vhcr_el2 value I have shared is traced along with hcr in function
>> __activate_traps/__compute_hcr.
> 
> Here's my hunch:
> 
> The guest boots with E2H=0, because we don't advertise anything else
> on your HW. So we run with NV1=1 until we try to *upgrade* to VHE. NV2
> means that HCR_EL2 is writable (to memory) without a trap. But we're
> still running with NV1=1.
> 
> Subsequently, we access a sysreg that should never trap for a VHE
> guest, but we're with the wrong config. Bad things happen.
> 
> Unfortunately, NV2 is pretty much incompatible with E2H being updated,
> because it cannot perform the changes that this would result into at
> the point where they should happen. We can try and do a best effort
> handling, but you can always trick it.
> 
> Anyway, can you see if the hack below helps? I'm not keen on it at
> all, but this would be a good data point.

Thanks Marc, this diff fixes the issue.
Just wondering what is changed w.r.t to L1 handling from V10 to V11 that 
it requires this trick?
Also why this was not seen on your platform, is it E2H0 enabled?

> 
> 	M.
> 
>  From c4b856221661393b884cbf673d100faaa8dc018a Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Fri, 26 May 2023 12:16:05 +0100
> Subject: [PATCH] KVM: arm64: Opportunistically track HCR_EL2.E2H being flipped
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h       |  9 +++++++--
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 13 +++++++++++++
>   arch/arm64/kvm/hyp/vhe/switch.c         | 10 ++++++++--
>   3 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c91f607e989d..d45ef41de5fb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -655,6 +655,9 @@ struct kvm_vcpu_arch {
>   	/* State flags for kernel bookkeeping, unused by the hypervisor code */
>   	u8 sflags;
>   
> +	/* Bookkeeping flags for NV */
> +	u8 nvflags;
> +
>   	/*
>   	 * Don't run the guest (internal implementation need).
>   	 *
> @@ -858,8 +861,6 @@ struct kvm_vcpu_arch {
>   #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
>   /* Save TRBE context if active  */
>   #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
> -/* vcpu running in HYP context */
> -#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
>   
>   /* SVE enabled for host EL0 */
>   #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> @@ -878,6 +879,10 @@ struct kvm_vcpu_arch {
>   /* WFI instruction trapped */
>   #define IN_WFI			__vcpu_single_flag(sflags, BIT(7))
>   
> +/* vcpu running in HYP context */
> +#define VCPU_HYP_CONTEXT	__vcpu_single_flag(nvflags, BIT(0))
> +/* vcpu entered with HCR_EL2.E2H set */
> +#define VCPU_HCR_E2H		__vcpu_single_flag(nvflags, BIT(1))
>   
>   /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>   #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index aed2ea35082c..9c1346116d61 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -669,6 +669,19 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>   	 */
>   	synchronize_vcpu_pstate(vcpu, exit_code);
>   
> +	if (vcpu_has_nv(vcpu) &&
> +	    (!!vcpu_get_flag(vcpu, VCPU_HCR_E2H) ^ vcpu_el2_e2h_is_set(vcpu))) {
> +		if (vcpu_el2_e2h_is_set(vcpu)) {
> +			sysreg_clear_set(hcr_el2, HCR_NV1, 0);
> +			vcpu_set_flag(vcpu, VCPU_HCR_E2H);
> +		} else {
> +			sysreg_clear_set(hcr_el2, 0, HCR_NV1);
> +			vcpu_clear_flag(vcpu, VCPU_HCR_E2H);
> +		}
> +
> +		return true;
> +	}
> +
>   	/*
>   	 * Check whether we want to repaint the state one way or
>   	 * another.
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 8d1e9d1adabe..395aaa06f358 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -447,10 +447,16 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>   	sysreg_restore_guest_state_vhe(guest_ctxt);
>   	__debug_switch_to_guest(vcpu);
>   
> -	if (is_hyp_ctxt(vcpu))
> +	if (is_hyp_ctxt(vcpu)) {
> +		if (vcpu_el2_e2h_is_set(vcpu))
> +			vcpu_set_flag(vcpu, VCPU_HCR_E2H);
> +		else
> +			vcpu_clear_flag(vcpu, VCPU_HCR_E2H);
> +
>   		vcpu_set_flag(vcpu, VCPU_HYP_CONTEXT);
> -	else
> +	} else {
>   		vcpu_clear_flag(vcpu, VCPU_HYP_CONTEXT);
> +	}
>   
>   	do {
>   		/* Jump in the fire! */

Thanks,
Ganapat

