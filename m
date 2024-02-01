Return-Path: <kvm+bounces-7743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D8EF845D3A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52C252980EF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37C75E20E;
	Thu,  1 Feb 2024 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CyhM5eQo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292047E0EF;
	Thu,  1 Feb 2024 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706804855; cv=fail; b=uWqBBzltsZacWYabSjLKXpN4ezcn02tMI5xs59Y2XX8DcCCu54ywayoGF5EEHuLyFTjFzwppbHfr4QN/Ar28efjR9ko3dFPXaqezAZ2Ib/V90Ruh1FrYzO2UUefc8UPZ2qT5yGrTcOysJckp8PQk+U4A7lQf/NVQBhK0dXYzGEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706804855; c=relaxed/simple;
	bh=WspPIuWR618ok2whFPeB/scbGkd7xwz0YwQ/0WWVrAM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YdtgFVsVSUfBe9SzzJWRX5qyHxaokhCE4cXenVukdhncAU/UiLczhPxt6v2ry7Yngkxwy6zfcJ7jcbzi6RDDrHaPaZ07n6Ak3/FMqxce5pU/5MugRImbsn9sMtgTEnLO/7jd6xt9GsiVvCLMpXhv0p2rfuPLJ1qmklLTsmLqYpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CyhM5eQo; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut0Y3a2SojorxdVWKrFl8A3hB1ctrpAHslUQMB3SS5ywZjih9316USq6xZdz3SWz20EBblj87oqO5OFngA/G2FnzGRCI9jNP2h54IXO8AYyswLd98LjRFqId6qwC6CguMfK0sCpnJ0WfgbIPWGbsx4acJlPLejlFgdMr7zXDWlDfdQPrOUudGkcwHZ7BBGlDxQsNaclsqqazSLDhmw5ZE42Vd5jjo/xTCopRRB7bJpM5uFVIS8YHjVlImDYLQcjyy+b881cWKvwHvm05jAwZeSzLdCzRHW/V+88wOOrqKp2RhGhNT8qL6T1Rn7rGc5/dBp1lAX5nn1ZEMRNkQKr9DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzfVAesZqJTcpecjyteX+ISVsMho/gwwy8+Pmfjrx3k=;
 b=YMYWAErY+5qrHEhTa1/rpn8IeWgM711ZV1NiTGrtd9zqEom16ic8gRJbALn2TwixmYNqZRvIYHLqWENwNUE+TAXNdEFo2+UXv/WkAaGPR7QHtn6miuoFKQGrI9u/xlcOPxaz67kz9mQNU3AjkZPnoQn/cx5tUi74yIicqX2Im8VGdmmULPZFBlcBs0gV1V9yccl2Rg9PIu5bl8lURdedlsubeWjaoEeWtVKqmTaWT6D4pntiu3nxT3NEjJoAd4PomX8hm+UzhJkde6wA+RqAU7DGTkF6W5FBxeSfFdHgVSA92tkF5xRRvqHbMycW0t+KdWrtXsWuS7NWMpBV41UTCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzfVAesZqJTcpecjyteX+ISVsMho/gwwy8+Pmfjrx3k=;
 b=CyhM5eQoLMRLN8vJOU16LkD3HNhZ6cW/Ns7kw0eRSwjvjoQNoG/nIFzEYHbweSNqlM+R1yBy8hbK5opTN+g0LfLvb98Qgoles07zAmJfKqZP1013nJ527IkkaEQ8Fq+wrMSnAC/xKgNVIrR6BVbK4KD+nr06Qw48aWUoKN505jA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ2PR12MB7943.namprd12.prod.outlook.com (2603:10b6:a03:4c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.9; Thu, 1 Feb
 2024 16:27:30 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%4]) with mapi id 15.20.7270.009; Thu, 1 Feb 2024
 16:27:30 +0000
Message-ID: <7d74cea0-2d98-476b-8d55-ec3a4e3c0fc7@amd.com>
Date: Thu, 1 Feb 2024 10:27:28 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] KVM: SVM: Use unsigned integers when dealing with
 ASIDs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>
References: <20240131235609.4161407-1-seanjc@google.com>
 <20240131235609.4161407-3-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240131235609.4161407-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0034.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::7) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ2PR12MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e1ff61c-434e-444e-0225-08dc2342af80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M6tSBizvTRkUKKdKgzWuzlH/Pj4Y1ardg7nIxtxS5Xz8PBxuzoxqZD4ni07fmTdLUprcgOdyKgqviFDxpDKLsRfH/r+P7dVtYiTA61CNlVGkGVFktMYFzCbGiB0n4fMyw1ayr74n1jRWfZ29kHO/sInpge4sQUzOw5ARHfGE5PWIUnM56yADpComon3bKvT0j/gCg/8wx2PTIQw8IsZJReLHvYBYFx4GPKW1EocNqkgaFCGArLMRjpCAk7ImAjC48tUOyUVmrmwvLx7zhFBOIuXyY1gA+uGXfBmlY5B/ARMFxmJoaT+0/MZMfmd1AxkadulRyDjVbK4iETaZ96WF3uh7MxPI310hs04WQ6Xot2LrYW7fh9HmhP1j8VwbjH531tGfxAzwz16bG+I1qL0FWPn6s2VaqtGsizdetMAGrC1c4E5oo+praXlmE8tPv9aYMjyFanjfFTTJOl/8u0bSpMiXytcmu4EJDQYaXjVBfTy4puqS6tXxYYmlrZhnhYzQCxNxHijL1QBUtu7K9B4MpbaVqnBzGJUJChZU+/odICGuYEq/UQ2zacfyFaF8g6YJ8DBv1gdJDet7rpQCVYf787r5JhQ8zt3xEmMMlyzgeCUCfxb1LHkatjIcs07DZfnur383IondM6y3YDoWZkTFpQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(346002)(136003)(376002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(5660300002)(478600001)(6506007)(6486002)(31696002)(6512007)(86362001)(53546011)(4326008)(8676002)(110136005)(66556008)(66476007)(66946007)(8936002)(316002)(36756003)(38100700002)(2616005)(41300700001)(26005)(83380400001)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVlheEZKRnYvUW9oTW1PbTdBTG9hdFpRbkE2QUZsTDNmVUVVTUNwKzNjR3F2?=
 =?utf-8?B?UkxpRDB6Q01OdHkxcjNaVHNMOVoxU0JSeXcwMWY3T1hMcjByVGpIc2NZYkpn?=
 =?utf-8?B?VFE4UW1PRW5nNVg3THA0dTYwS2lObFZXVWYzbm5MSEdHc2RsOUo3cHJCcFI3?=
 =?utf-8?B?Tk94V3o4YmdseU9EWG1SaCthUEgwKzdqRzYzYXo5L3NVWE42cTBkZTB3aVJY?=
 =?utf-8?B?cGhJQ1IzUTNtQ0pwbHZFeHdDTXlIK1JnZytZdWlUcjFFaE93eGdMOFd4OE1N?=
 =?utf-8?B?ZUdqeTEvcEIxV2ZvVkk2bHQzNFlLM1R4ejlVWnc2eTZ6NjRyTHhqeHNYZU1G?=
 =?utf-8?B?bjhob1h1Y3lUUXphRDJKeHN1QUFCNTlkNzRFeGFTM1VGQ2R3Yi9QMUhoeTBn?=
 =?utf-8?B?ajh6N2ZZZHZBakEzbjdoVWd2Z21yUitRMmVUdDNzejZDa2gvWU42U0dKWW1j?=
 =?utf-8?B?aEw1SzBKRVFBQUNBUloxbjZ2d0krSndWZHoxdjBZS0g0WWRLZnBTcjBrUk9Z?=
 =?utf-8?B?OVJidmp6R1ZWQklvUGhvNFJEOFpHOCtkM3A5cldoNkNJcXpQMStpYlVXTWgr?=
 =?utf-8?B?UEtxeFRFdW9TTUxweldvSnM3Y0pDOHRrMHpZU2NVUm0vYjlvaSt1bDJtR2Rm?=
 =?utf-8?B?aHYvbEdONS85Y05hNk5TMHFnc0pjczZCQklmeHdHVityMXRVTU5vRndDaDRZ?=
 =?utf-8?B?SlkrYVJSMmg4RnhDMTBXVExHYzYxUnNPUmsxcjMrWERpU2w0UGdxQVF1NjRs?=
 =?utf-8?B?alFmS2YzNE12ZW9Nanhnc0NOUDJSNTNSOVE2MEh5Vlh1MkxGeFNUMTY2TlB4?=
 =?utf-8?B?aUJoOCtTSzlUTEM2V3FjeFNnU016UllnK2xFZzNTQVN3VThTV2N0QitGZjl6?=
 =?utf-8?B?WWRjRGdGMmtETGgwdVpwbzdMMHRHeXlycUpuTHRkU2ZlV2tjZnRxZE9td1kx?=
 =?utf-8?B?M2JXRi9kVkYzQjJMYzAvSkIwNS9WZUpxZHRCZnY5Ti9EQndnNks3MTY2Tmpi?=
 =?utf-8?B?TmtnU2ljdlJISXNjazJUbXlkbVE3bkRoNWNyL3huNXMzdzBEajlkM21jdjlF?=
 =?utf-8?B?QmIya2dqeVdqdW1FNnhyRzVOY1BxSzEvVUN2RGg1WnhnMFlxNWRvdGVxOVJG?=
 =?utf-8?B?TitXM3FKOWF1ZGJjMU43aytkK0s1ZUFPbmFhSTNUWkNZZjYweVFycDcycXNL?=
 =?utf-8?B?T3JGUXBRaTFsWGRmc012MGtyb1FtNU9BK0doWnZZMWdUd0NhL1dKN1g2cGUw?=
 =?utf-8?B?ZHFqQVFSK2pudmR2VHBIbDFqdkxjeHJYdEdDNDI0ZytIUTFoT1NXVXRZUlBq?=
 =?utf-8?B?OTh1bEtxb3ErSEZ6ZWhHKythNm1haFdXckhVTU5ZYXF4ZkM4Z0cycThpVEtE?=
 =?utf-8?B?cVJmd3RnQnJ0OXQ4b1QyemJVSVlPTTNIaDNtNzVvL21TT2JTZU15aXNJV2xE?=
 =?utf-8?B?VXpJN0NqbDBFSFkvOERUR0hoVE4za1NEa2pLRGZzMUhiU2lRSEZ0OVRVUEpU?=
 =?utf-8?B?TXRtdUE1ODNEeUtlbk9Qc1B2endveGh2TUxTbzRUVWFmSnJXSFVFaXF5NmN1?=
 =?utf-8?B?cFd5bWxZRE82Q20yZGVKeGhDdG9vOWIyVEVwOXZVUVBMSGZjaGVFS2xRbmF3?=
 =?utf-8?B?TW5SSFJ2NUJvVlNVSk9RY2FOZWphVWxHV1czc1hGRFNBMjBmc1RBUkJ3bVJM?=
 =?utf-8?B?dzR2bXJ4UGZWRG45YmVkY1c3ZTJrN3VhZGRxMDdMbEtXZXdEa0ZrVyt3WjZl?=
 =?utf-8?B?aWI0c3pvay9yU1RLK0lkdGRTbHUwS2FKZTVZV0FDOERhQXlVVEVYTDdlcHdJ?=
 =?utf-8?B?V01PdnB2WmErYnBkbVVOQUhZZjcyZlVId1pGcFpJU3ZPcGhyQmdrYTNaaVJV?=
 =?utf-8?B?alhKREpMVmx2aGNYSUFESTZvRWw1MHFRYXdvMHMybXBYUHhZTHZwTkozZ0k1?=
 =?utf-8?B?UElKUjZLVlJJeThWYTM0dmFSUnNmTjN6SHZaYkZUTG01T2RZNjZDR014YkNh?=
 =?utf-8?B?RmlJWWYyaDc0dHdNMHg5LzlBTzhBZ0UwL09FaE9JSDBhaFBTM1JIVDZrTDlp?=
 =?utf-8?B?RGNGUnpWbWxKZW90K1VxUW5LSEFJUzlEUzg1SXhCQnl1NXMzOEQ1TkVYR29y?=
 =?utf-8?Q?5w4oKE3R9l3S/M8uZamGy9F66?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e1ff61c-434e-444e-0225-08dc2342af80
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 16:27:30.0092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aq3hfZ4rwIRV+lnWlU2UVrgLD1V041RI6+EhxrVWMpcH6XRhVgomMtB52e54GEWcVS58yLP41ehmyLSRJapHxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7943

On 1/31/24 17:56, Sean Christopherson wrote:
> Convert all local ASID variables and parameters throughout the SEV code
> from signed integers to unsigned integers.  As ASIDs are fundamentally
> unsigned values, and the global min/max variables are appropriately
> unsigned integers, too.
> 
> Functionally, this is a glorified nop as KVM guarantees min_sev_asid is
> non-zero, and no CPU supports -1u as the _only_ asid, i.e. the signed vs.
> unsigned goof won't cause problems in practice.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Just one minor comment below, but either way...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 18 ++++++++++--------
>   arch/x86/kvm/trace.h   | 10 +++++-----
>   2 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7c000088bca6..04c4c14473fd 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -84,9 +84,10 @@ struct enc_region {
>   };
>   
>   /* Called with the sev_bitmap_lock held, or on shutdown  */
> -static int sev_flush_asids(int min_asid, int max_asid)
> +static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
>   {
> -	int ret, asid, error = 0;
> +	int ret, error = 0;
> +	unsigned int asid;
>   
>   	/* Check if there are any ASIDs to reclaim before performing a flush */
>   	asid = find_next_bit(sev_reclaim_asid_bitmap, nr_asids, min_asid);
> @@ -116,7 +117,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
>   }
>   
>   /* Must be called with the sev_bitmap_lock held */
> -static bool __sev_recycle_asids(int min_asid, int max_asid)
> +static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
>   {
>   	if (sev_flush_asids(min_asid, max_asid))
>   		return false;
> @@ -143,8 +144,9 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>   
>   static int sev_asid_new(struct kvm_sev_info *sev)
>   {
> -	int asid, min_asid, max_asid, ret;
> +	unsigned int asid, min_asid, max_asid;
>   	bool retry = true;
> +	int ret;
>   
>   	WARN_ON(sev->misc_cg);
>   	sev->misc_cg = get_current_misc_cg();
> @@ -188,7 +190,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   	return ret;
>   }
>   
> -static int sev_get_asid(struct kvm *kvm)
> +static unsigned int sev_get_asid(struct kvm *kvm)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   
> @@ -284,8 +286,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>   {
> +	unsigned int asid = sev_get_asid(kvm);
>   	struct sev_data_activate activate;
> -	int asid = sev_get_asid(kvm);
>   	int ret;
>   
>   	/* activate ASID on the given handle */
> @@ -2312,7 +2314,7 @@ int sev_cpu_init(struct svm_cpu_data *sd)
>    */
>   static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>   {
> -	int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
> +	unsigned int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;

Since you're touching this, you could switch this to:

	unsigned int asid = sev_get_asid(vcpu->kvm);

>   
>   	/*
>   	 * Note!  The address must be a kernel address, as regular page walk
> @@ -2630,7 +2632,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>   void pre_sev_run(struct vcpu_svm *svm, int cpu)
>   {
>   	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> -	int asid = sev_get_asid(svm->vcpu.kvm);
> +	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
>   
>   	/* Assign the asid allocated with this SEV guest */
>   	svm->asid = asid;
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 83843379813e..b82e6ed4f024 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -732,13 +732,13 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
>    * Tracepoint for nested #vmexit because of interrupt pending
>    */
>   TRACE_EVENT(kvm_invlpga,
> -	    TP_PROTO(__u64 rip, int asid, u64 address),
> +	    TP_PROTO(__u64 rip, unsigned int asid, u64 address),
>   	    TP_ARGS(rip, asid, address),
>   
>   	TP_STRUCT__entry(
> -		__field(	__u64,	rip	)
> -		__field(	int,	asid	)
> -		__field(	__u64,	address	)
> +		__field(	__u64,		rip	)
> +		__field(	unsigned int,	asid	)
> +		__field(	__u64,		address	)
>   	),
>   
>   	TP_fast_assign(
> @@ -747,7 +747,7 @@ TRACE_EVENT(kvm_invlpga,
>   		__entry->address	=	address;
>   	),
>   
> -	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx",
> +	TP_printk("rip: 0x%016llx asid: %u address: 0x%016llx",
>   		  __entry->rip, __entry->asid, __entry->address)
>   );
>   

