Return-Path: <kvm+bounces-6111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 838C282B600
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 21:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 693281C251DF
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 20:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FC857881;
	Thu, 11 Jan 2024 20:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fvpQYreA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3AB57318;
	Thu, 11 Jan 2024 20:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMEIxWp9pQd8O3lrM44fWxEqWTEVUUrUIzCFIh1RutPhOsA5PLTKuoETuey6NpBJeN7vYTW0UoGFf2nlOou1QJnbnrWEP/jV+zIuRIrSi2BgC5iZ2xUL9MfcjP4V0Lw6Uis/I9vi1EvhBQnooXvRM8X36hbkseAoQ2aZAZJopcvds171ZsVNgxuewsbOj8kmJNLRj6Rcbc9HOhxnSkZszssp4LielDD5L3SSLutpL7cMc3oPzrlgXsdphfpb8jnbNcoJewbkLLaAXmMAx36ZmEwnR0qGNpsvJe4PTPUtO44JWpCC0hbSZfu40ZceX41ai6GTvXYavTE0fXIb6bnaaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBu4sDIW8vzspZ9mc5dX1qZse+P5VwzaTq6GGcjuUzY=;
 b=e/FwQmklcc14w6b1ezkSuk2n6K6wWV14kM4LheZpDedEIBQtLC9PjPE7MsZOfxnM/qRGNl0io5Jqm+h/+hUNWa2ss4LP3DnrLw6up71J10rKQyw7m5DxeGoLb3gJ2g8z8FmcMs2KzO6uwzV8vtvTs2vYyfO3YKPY8SV+NV8i7+m/5GDMs0x4wgXDX7tktco8gNevSrSOza4UJ2GSvabWRhuBQ4uFdRxNfYpMnnwxBSqbDF9Vl5v9x3OFY2gVFAIm24bsZI5m/hZt9WiAPicEIZHSdlsJzaLqPDHFifyK+59sBi919Kp5ZbHDez0wsJqYsCLquqZ0N08adbf7dmyXPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBu4sDIW8vzspZ9mc5dX1qZse+P5VwzaTq6GGcjuUzY=;
 b=fvpQYreAVOyJ5DGNIb6OyLXd4/fwwrdtKQ/kJe8+126quu4Aiqg7rDy1U4tFjXfsGSsu80JRlvpkvrsgIR896o84qybtU2PnQgEIVX5FbhNYkyVWQqcR9KC2XG07c636Af30sXEnpIc9JiW1mqkjGpAZMwDC2Ugvk7CK72h+6ag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DM3PR12MB9352.namprd12.prod.outlook.com (2603:10b6:0:4a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Thu, 11 Jan
 2024 20:34:08 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%3]) with mapi id 15.20.7181.018; Thu, 11 Jan 2024
 20:34:08 +0000
Message-ID: <15e5bef2-c45f-4aa7-af20-63d1a23fa288@amd.com>
Date: Thu, 11 Jan 2024 14:34:06 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] x86/sev: Add support for allowing zero SEV ASIDs.
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc: seanjc@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org
References: <20240104190520.62510-1-Ashish.Kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240104190520.62510-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:806:122::6) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DM3PR12MB9352:EE_
X-MS-Office365-Filtering-Correlation-Id: a2251f62-0f3c-4365-9565-08dc12e4a946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fKMcEhRA0ESnc8rkNnmnopghcPeMfbfYH3o/hC/waXafWGx+r5Wjapuayy89ALz+An2xVJHHSaA3cbwEcBdUoz6YJp3o+oa5Lq6IyeYUfd+qmaVxh7buqfK6yOtFK1wAQpl70XyAcwEWmI9NeIqgNMlbYZJCFLqilDCz8zhZ1UD5v1aqoBRGhu2Vvk3zLlUTdoPme7nlfgUwl2O4Et3kOAhsSylHedlqjZ7/p8LpritliLspwJGvEM0+cRohP406cNvFL4fDvdSF+dzBQZtOJLu6kjI8IZ2uMwQtsvmfjELo3MFRgcd1Uy0eySx4M/3eYPDOAscdqG2OtlJsHmnV/tNT7nHENOqiPNEwrPM5GEzQ0T8Boeo9ixcwOj0Iqxb4fHy6x/f/R+2zAubyE6B+/T2L2xeuzUM3FIuld9Y6LpBPMPDvBC2J0yic67AX4V40PVnufYNWfe0usn8XcbI+pkXBXrKyHUYlp37Rwhc9dek6Lfy+uiNK9aFzPL8ibs/mjWDizRy/lmWojmj+NtDL4hZlJ9IdTox2eZWQWIu+RkcDmutc724wwGQblV6xjWxjDeI+7UDRp3JGQm283F2dYRGSmaPidiMGG66XNBWAV3H9QQH3sjMmwvnmX2CaoKm5QGHP8tWeQae4kasKGE8Giw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(6486002)(6512007)(6506007)(53546011)(2616005)(36756003)(26005)(38100700002)(86362001)(31696002)(83380400001)(41300700001)(478600001)(8936002)(8676002)(4326008)(5660300002)(66946007)(66476007)(66556008)(31686004)(316002)(2906002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nzkvd25VbGdReFZCN2s4ZUVDTjBEYnBYVTM2alVRTGRIZUxROGlYb0NqU0xX?=
 =?utf-8?B?eEI2YkVaZDA2c0ZwUmYrR0tGTWpzSDJkeHorUjNJZVNud091cUNSWVk5c1dP?=
 =?utf-8?B?aGdCaC9BTU50VWZTSTVqUjhsR1h4SFFnSVc2Q1dGOUpNUjRuZVpPek5MMysx?=
 =?utf-8?B?bGtLMHlNTVhDV1VxTnVod1NKU0hMY2lNZXpiMmtlRVUxZEx3ZFE5Qis2TDZP?=
 =?utf-8?B?bXhtYm9OM3hZVDZHMUJQS2RrR3g0SDROZFpZaUE5NnJ1S2lYMGxwN0ZFM1VI?=
 =?utf-8?B?cHVKNTg2WEpHL1VJTDZ2bS9JbDhyS0k1N0JrMnEzdDc5QTFNeVRRNmcvNFk1?=
 =?utf-8?B?c3d6UnRaZEtnRW1aQVBEVmYwTnlSVFVOWExaTWRwVy9OSHJQMHo3a2RHWCt1?=
 =?utf-8?B?VkdJRkZ4UmFlcEdoUmhzaituY2FaK29kMmVmSDVkdHM1R0lLTXJnOGFnVEY4?=
 =?utf-8?B?TWdMeGQ0Tk9nVExGTnIyRWd0YU5laUZyaXZzM1ZtbHRYVjlEY21xR2svYW9U?=
 =?utf-8?B?cjVxK0x6ZkxtZUZhbkx6TTZ1Z2x0dWtBZzRta05KN29vb1kzcHZFVms0UVEx?=
 =?utf-8?B?Q29NYUJ1TkxrcHM4VnN4QnlidzZSOTJ3WHJqOFhQbmJIbkpOVXMzckg4NW8x?=
 =?utf-8?B?SGk5MzZ5SXovTWpMcy91a2QvNGhHcHpHQ2g0SkU1K204VldHbGZVUkNHMEVQ?=
 =?utf-8?B?WU1ONEs3bE9KYkVPd1l0cUZ4NFBzK0pLM2crL0FDc3k4SjBYa2VIaUVTQmFX?=
 =?utf-8?B?cUZGREdCemxiejQ5djJFYTRlc0ExaUpOVmpSZnp4S2VhaW5HTWxZMXp2ZklT?=
 =?utf-8?B?d1RuYVhjUVVjYjU0VmsxVzBzZFZYbzVkNWpwM3BjaHJnUTZmeTBScmxndDlO?=
 =?utf-8?B?YXdOM3JFcmpSczBJaGhSMXEvcm55NU9JRUQ5d1pxdTg3ZGpQMTVubDlXK2lY?=
 =?utf-8?B?ZW10c0sxVjIzUE80Z2RtNm5xYVcrVm9aVHRlRkEvL2dwRHpCby91cnQyc010?=
 =?utf-8?B?T3Q1djBSam1sYktmajFuTGZsZEgxYmlmYk9sTmhEWlVldFR3cWdibVk5ak01?=
 =?utf-8?B?T1JNVEllOUZ4c2FoVGxzOXczU0tVclZpVUkwSzhyRFRrRnd2SFRIMjMzbjdZ?=
 =?utf-8?B?WEs4UzJLT3d0QjdJRWpZQklCak9LUW5reVlTY1JKQnd5N3VrbG11Y2lUN25Q?=
 =?utf-8?B?clVGaXNCc0ZhcFkzQjkyOEV5S25QMzFFYm9BNHRRcytnU3liT29NeHBGQWc2?=
 =?utf-8?B?aTJlT0lvTGR5dStEekJ3SU1zbmRxS3hmb1RBVFJYMnhpQXdpYWo4RkhXVXNE?=
 =?utf-8?B?S0IvR1pOcU5OYVl4T0ErYThadlhmdEdyaGNubnptbWxsOW5BYkgvUHJHRGxm?=
 =?utf-8?B?bUJGWnM4OU5yZnI5MzRrd2hRTllVWkVjR1dlbGhXTFlqYXZSL0daY2RWVGxM?=
 =?utf-8?B?S2RkR2diR1JFRGQvUzV1bTRTRm0xN290NG9yN3pqaGtBbFhpbHVxMGc2a21M?=
 =?utf-8?B?blhmS0JhdC9pNXNCK1lxMWdvU1d4ZnR0MkkydW5lZDJjZ0thRnRDSWtLWDdO?=
 =?utf-8?B?Ym10NXZyMkVJUzVObUl1ZWY2WjRqcGQrVGhpaFVsbUJWZ20xQmp1V2tsMy96?=
 =?utf-8?B?LzI0alMzOUErL3JsRmlpOUV1NWJRWUliUkkwMThRdklLd294VXdpQ3pjYkti?=
 =?utf-8?B?dkQzQk9IR0NGdTB6aUFqODF1NXNBMHZGaFJyNzZ6blZMT3Qxd3pMcUVYdWJR?=
 =?utf-8?B?TTdwZ0t6TUEzcGZOb3BrTnd5dVNkbjl2S0hwSHNCdTVZcy93Zy9GTWttN1Y0?=
 =?utf-8?B?RjNCMkg5RkdnVnNvMzNwMWloMUFYNVJPNkZhY1hWa01KbDlNMkM3NHFxVEtx?=
 =?utf-8?B?S25WbXdYQ1Q4TW1jWUFWalRJcDk1RnFIQ0hDS3pDMjdEOHZ3SW5xWm5LQkNU?=
 =?utf-8?B?WGY5VzBuNDVCbGE5NSsvL1J2WlpCTWJnRHZLMnNFOVk2NlNmUEEweHZUQm8x?=
 =?utf-8?B?cWc0d2k4SkRUM1pKU2FFMm12S05WajBLQThLT1VLMm40U3h0WWd3TGo2cXRq?=
 =?utf-8?B?M0h6R1BEK2tQcHM1STI1VC9ubUFPcWFGWE9Tc0pWV2NCSDhTSWdCR0tRVjBm?=
 =?utf-8?Q?EAFN02EcyPcNInfrliOzWMPKr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2251f62-0f3c-4365-9565-08dc12e4a946
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 20:34:08.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXssKNMesZcjQkwpLq0KFYYqE26wE+xUwsKJdped7mxuRSxNnoMG9FaFafN02BWkQhPZuEF2wmzQABL3h8DyGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9352

On 1/4/24 13:05, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Some BIOSes allow the end user to set the minimum SEV ASID value
> (CPUID 0x8000001F_EDX) to be greater than the maximum number of
> encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
> in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.
> 
> The SEV support, as coded, does not handle the case where the minimum
> SEV ASID value can be greater than the maximum SEV ASID value.
> As a result, the following confusing message is issued:
> 
> [   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)
> 
> Fix the support to properly handle this case.
> 
> Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Cc: stable@vger.kernel.org

One minor comment below that could maybe be done when merging vs sending a 
another version? Otherwise...

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 40 ++++++++++++++++++++++++----------------
>   1 file changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4900c078045a..2112c94bac76 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -143,8 +143,20 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>   
>   static int sev_asid_new(struct kvm_sev_info *sev)
>   {
> -	int asid, min_asid, max_asid, ret;
> +	/*
> +	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> +	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> +	 * Note: min ASID can end up larger than the max if basic SEV support is
> +	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 */
> +	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
> +	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> +	unsigned int asid;
>   	bool retry = true;
> +	int ret;
> +
> +	if (min_asid > max_asid)
> +		return -ENOTTY;
>   
>   	WARN_ON(sev->misc_cg);
>   	sev->misc_cg = get_current_misc_cg();
> @@ -157,12 +169,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   
>   	mutex_lock(&sev_bitmap_lock);
>   
> -	/*
> -	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> -	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> -	 */
> -	min_asid = sev->es_active ? 1 : min_sev_asid;
> -	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>   again:
>   	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>   	if (asid > max_asid) {
> @@ -246,21 +252,20 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	int asid, ret;
> +	int ret;
>   
>   	if (kvm->created_vcpus)
>   		return -EINVAL;
>   
> -	ret = -EBUSY;
>   	if (unlikely(sev->active))
> -		return ret;
> +		return -EINVAL;
>   
>   	sev->active = true;
>   	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> -	asid = sev_asid_new(sev);
> -	if (asid < 0)
> +	ret = sev_asid_new(sev);
> +	if (ret < 0)
>   		goto e_no_asid;
> -	sev->asid = asid;
> +	sev->asid = ret;
>   
>   	ret = sev_platform_init(&argp->error);
>   	if (ret)
> @@ -2229,8 +2234,10 @@ void __init sev_hardware_setup(void)
>   		goto out;
>   	}
>   
> -	sev_asid_count = max_sev_asid - min_sev_asid + 1;
> -	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> +	if (min_sev_asid <= max_sev_asid) {
> +		sev_asid_count = max_sev_asid - min_sev_asid + 1;
> +		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> +	}
>   	sev_supported = true;
>   
>   	/* SEV-ES support requested? */
> @@ -2261,7 +2268,8 @@ void __init sev_hardware_setup(void)
>   out:
>   	if (boot_cpu_has(X86_FEATURE_SEV))
>   		pr_info("SEV %s (ASIDs %u - %u)\n",
> -			sev_supported ? "enabled" : "disabled",
> +			sev_supported ? (min_sev_asid <= max_sev_asid ?  "enabled" : "unusable")
> +			: "disabled",

Just a nit with the alignment, it would look better if the ":" was lined 
up under the first "?".

Thanks,
Tom

>   			min_sev_asid, max_sev_asid);
>   	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",

