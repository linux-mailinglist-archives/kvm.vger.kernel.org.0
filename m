Return-Path: <kvm+bounces-7742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15781845D85
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DD9DB2EADF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5401B5E216;
	Thu,  1 Feb 2024 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="crH/jOmu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621DD5A4E7;
	Thu,  1 Feb 2024 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706804409; cv=fail; b=MlhPRP0rtf95aaxx7U5XK1tbj+NYujovb3YO+E7vFFvV2uJ3hbeyeX7wCofGC/hKVsk5uAeYdADp4s6MXjl7W7jr91CXIaDGRPqrHlOGwx+xfBZI2zjjW2SAAmqqPKEIi7BgQ7PcL+XB2vR+skzecuKzu2z71HmJR9hHGkroOKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706804409; c=relaxed/simple;
	bh=imSW+WCltENdgC2LkLREAYiIjGQQheBVdKnVP6VsUTY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UhtAET5XT24SK5oheRGMZoUlcHGMhU1ViSJX9//YXXBpRZo2aXsvUBogPdaNNRmhIvEu9jRlRCOZDEIhrtcz/FI7Bw7T73pjc3zZn7WCx5Z9vPpPW67c57qyfHM/so+4u8EUFLQnX9h4Tykm1/yGxSBKOOUH+USoVIi44F2c8yU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=crH/jOmu; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPmy/sL0IYGcXCVRJZ8PVsVSdUFobSVPhT0BQegmgMvjPuWWA2g2/EoFOxFqHREd/ndbvkaLj/9Wz9fKFldX15JM1DqFXlKENy5ExT9ZtzeD3MsiWxX+9sLwQJV+ezkyVlAp2d1ymPs+RxcSwmIW9k8CMWyUHqvyujW9jP8pAfzCPBQWqhNgqGOoc5YfpF/BPZp7NACxaKpmtiPPAnil2EjU8RyTsZNibtAWR0mA9k/0J1axh7GNriruyjUjwk/aSKY0gyQaqyDE+9YAiKImfy5+f8BTtOBJYOE4OiDJTHY+EM+b5uELdVrVM9kYYiaGBvLd85B3QtHjf0ckKPeBng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YpwGvsMbsW6CfrUfof1GO19o8jL2WJdS0llo0p+oV4=;
 b=NSNuRjmCftR2k7FtNo2WLolUTkP+5dEpkVwRiKElX6eBTq2SOu5OxcwV/EkX0ac2aESMOdKfqs/vEKm5gqR4e9ndtRZakqsTfy9HXPjSKOts+U0ocn6YNgseCJqY0LetdlaWRSpD8gO0GPjq4A33Mekr9qAn2PYz+IwGWUaJ5hFUi3yn2x7KgjcEt7UEsJIhdoHvO8Y5F5t5n0XJHK5uMcLbDyFReFJDelXzm26fMcIIJy+VLR4beNztWyuRYKKgp+ZVfTQ2jUdDeuckp8KLhbJpYzn7mjS/vgMAOF0BoWU0KzkWdj0k1xENldSRajL18ROGj9wBTBbkuhpH8Z8Few==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YpwGvsMbsW6CfrUfof1GO19o8jL2WJdS0llo0p+oV4=;
 b=crH/jOmuBfuytSynUEdbltWc5MqZexTBdQsGM02VV+fSk6m49TTWXVerF20sF3NGOrVez3q8AYZRZbZ/wEgqWQWIuIT2j+U6qulEeaLVd5m8B4y2bxgnhzXSLQKrpttnnqPgSMOCYsL3yDP7h9+kZ7Sb+eGtvq2GoekmfXCuN6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW4PR12MB6707.namprd12.prod.outlook.com (2603:10b6:303:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.37; Thu, 1 Feb
 2024 16:20:04 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%4]) with mapi id 15.20.7270.009; Thu, 1 Feb 2024
 16:20:04 +0000
Message-ID: <ceacd840-d27e-483d-9e67-97666a4b3aab@amd.com>
Date: Thu, 1 Feb 2024 10:20:02 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: SVM: Set sev->asid in sev_asid_new() instead
 of overloading the return
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>
References: <20240131235609.4161407-1-seanjc@google.com>
 <20240131235609.4161407-2-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240131235609.4161407-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0056.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::8) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW4PR12MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: eece8e6b-b61e-4745-2ef5-08dc2341a5ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VK0Dqv9b+I9vSIy9Xm/jnj0kGXajba2ZuMlJ7Ih/k+56gAhTzR3apeWrHDQWmkBXuM5+HF885OCSx0HgjXCNorlZx/jkfmCpFVZpbnbZI4qUNmryHQRGKd1l4TMDnCIBkvpsfhJS1DuZiX9R2QMZw9TZEeo5C73N6Jy+7lUxyAqWulbH0p302dwEtnNxI2S7r1u7H639yIJwF6hSk4qNd3hTaSCcrMjvZA9QmSyb9MTi8zkrfSvhwPHkCSEbQw+uFSgwc3iAcZhnBJA1fvlxfzFwKlY1amdCADvEyPA6Y28bAYLCqQk5/JG8jfYKc359DU8rqXCvTuYZiLrLfuCgS3qs1RhQqQYER9G1ecwe8Of/IqLQQGE2MRI7OHq4cUr67xeSqAtH/N9g/+r48UMPJWUVICgoteH5vptrP3Q1lldFauueaJVkCAJA7M3D9rZU0pLzqjaGIQhIKWPpFwYwc7znbZpBWQOP0GsSNqSmHfjkqte1DTUCOhKoGRijlFTqjMvrygJ9La/nq/rQE7MMfpj3U6aSWbpT8SDMQV4LehVazFmRZNBVNT/jnGDiNcEofJT+Zu0J0P6tNVwYPcfS3P3e3rzjWvdIqJwXfNFSY4aGjDj5c1cSh8AT1JXAuFxhArX+CoJmqg85Z8MdBo8xcw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(39860400002)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(31686004)(83380400001)(41300700001)(86362001)(36756003)(31696002)(53546011)(2616005)(38100700002)(26005)(8676002)(6512007)(6486002)(316002)(110136005)(66946007)(2906002)(478600001)(8936002)(5660300002)(66476007)(6506007)(4326008)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ky9ocWdtU1JNUVFFR09VMmNXT0lTQm9YeTRteExocTVZM2R6Zks1Q3VaSytj?=
 =?utf-8?B?MDNRWDZROHU1emd4QmtYSHFwbjBueVk4UFB6VkIxZS9oZVdDbko5S1Q0dDJU?=
 =?utf-8?B?UDdybG1yajNNcVIzTzBzWU5wZjhEMGdCWWVxODBFenY0eVJnTlZCa0QwSTE3?=
 =?utf-8?B?S1ArOTFVdThRWEhaNVFGNnZYWGRnK1NMRk14cm4rZTkySCtRaTl5VHQ0VHhi?=
 =?utf-8?B?VXBVbU9HY1gyckJzdjIzZ2xGYVVOUWxKbThwdVdOK2N6c0sxVmMwL2QvVWFM?=
 =?utf-8?B?alBobk9ZcUVyV2JTR2hienNsMElnZHpDSnRBNnh2b2JudnFmYlZtQTRSak1k?=
 =?utf-8?B?U0FIeU1pS2NYWklGQngzSnBGamxqbExtZUVWNFhXb2lqcW9hZVNHeU5XQnlK?=
 =?utf-8?B?eXUxaVdvSGVNbHBsdFgvZFFvQ2EvNDFlL3ZSSEw2ZmlZcHVvdHh0VUN5L2NM?=
 =?utf-8?B?N3lNdTBad0F5ZEdGUUoyNzZQMUxYWjg1UFdiM1hGNU96UFFQVFNhK000QlY5?=
 =?utf-8?B?emlDUFlKK3QvWHR6TWdmamdKbGNrNXNTRFROT3lXeWZLdERrR3FTZEZqOUhk?=
 =?utf-8?B?MVM1NHpXSHV5MWxIRzU0STl1aG9DMW50Vm91SnN4ZEtDelk0K3ZvNEt1dHk0?=
 =?utf-8?B?dDhodk9qUm0yVE9oaDNIWlFzaVVJYWtoVWxtVk8zQWkyekJjdjNINk03b0U3?=
 =?utf-8?B?UnQxcjczN281OFlvbTZaWW0yNEdrczN3Y2lRdTdsZVFRcS9uZlB3YXJUYWtP?=
 =?utf-8?B?dnRMVWU1Q0R1Q3NRdW52NUZ0NUZmRlJuZDZCanlDNkx6QW1vR1krOHFBcmE1?=
 =?utf-8?B?TzJ5V3Jocmd6TVFwVDZvU01CTGsycmJUVEdoVkVXb25IaEVVRUk2eTVJSFBv?=
 =?utf-8?B?eForWG14MVJER0pGQkN5SUgvM09sQ3lKeHcxbXdGaW9OdWM4b1hTMW04dW4x?=
 =?utf-8?B?cjBWUVhnM3BZV2FPT0tFaUhqb2d3TUR3dmYrMGtGTzVWZ0xNdW82MWt1UjBy?=
 =?utf-8?B?a3VLK0ZrOUg3YnRQdWxwcnZFZVZjbXNBU1lYck44dVYvcHdqeHB3TXV2QVo2?=
 =?utf-8?B?Q21ENGdUZkJFZmcyelppNlJlNFd1SzZQVjFralJ2cUJXWnBiWDVxUThpdEVy?=
 =?utf-8?B?VzFmenVFWTZMUUxuUm8zRkszVWtaMlFmZGtxeElGVUhoVC85TWIxa09xVzVG?=
 =?utf-8?B?K1BsWU1FSGRSVHgva0NsOTBOL09icC9Dc29sNk9hMHJKVEFLakcrWW1aWnMz?=
 =?utf-8?B?a3NqTXhyL1M0OVNnOXR2cDc2SFRPZ3RQbWNtdnI1ZktQa3Q1b2laN0N5eDVw?=
 =?utf-8?B?N3dNZG1kaXorclg1Z0pTR1ExN25WU3JUMGRwMG1KVnRLMTNjMDBlSVlBWUMz?=
 =?utf-8?B?dU9NZU9GTUpUSHFDNHZmNVFNeDkwcGNPS0h4NVJQMXQ3K0gxWEJvaWgrdmJp?=
 =?utf-8?B?dWdiaExlT21pd1VhZlhBOS8xaE0yc3N1cWdPZTlzS0hLTmNvODI0UmdlbW5M?=
 =?utf-8?B?QlNqdVQyUnRGb3JubnRtV0N6MVcxLzMwekV5RFFnMU1EWWk5RUZKVzlhbUxP?=
 =?utf-8?B?eDBoRzNlV1ZCbHlJM0RTdTN1dFJIZXFXenAwWEE2MlEvREM4NUQ1c0k2QThY?=
 =?utf-8?B?L0RWOWVWRnd5alVGcWJPRnBZQTFWeEg2WkRHRVEvS1ZFOEFtZ0pZNVJQbDdt?=
 =?utf-8?B?U1Vwbi9aYXgwMnAyOWdhc090UWhlZnEyYVpiM0w2T2xUVUNiVm9VZEJlU045?=
 =?utf-8?B?N2YxN2dnN2UwVE5FM3pUQTVVR2NnMG9ZVTZJdE9yclVmbjR0c1dOSjREYmxJ?=
 =?utf-8?B?aDdwaUU4NGoyUE5XM05uZVFDTXVXaHBtRlFPTThCTjdnRkRPaTFvS1VhT2U2?=
 =?utf-8?B?WFF2Z1R0eTNhSkFBTS92N0FrQnhtelE4SXllTHVUMlNTQVh5ckpBYXdJeExp?=
 =?utf-8?B?aTdUbDRVajRnTTY4aDJZREdMc2VOMG1sWDlNUkpUcjRFME03NmowTnNOYTEv?=
 =?utf-8?B?RElYb2REUk9OWXhHSkRob01ZWUN1YmEvaDgrZWZ4cnhLWHlrbjJuaXVnWDFs?=
 =?utf-8?B?VlJNSCszZkNiVW9xb2R3d29zMEtJRjRSQVl2TDFPZDY3VFpObVNYODQ1cUQx?=
 =?utf-8?Q?Ru3yIOpg5XxUFI4TmTNEltCd/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eece8e6b-b61e-4745-2ef5-08dc2341a5ab
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 16:20:04.0421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YX8mJmobb3Bqcjyq4kXEv76CLmGGS2GzMvbZkMEvJEwWB5Ze94gG/3Ny2vCGb6wRHSmjx5uEedcre45s8JGU2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6707

On 1/31/24 17:56, Sean Christopherson wrote:
> Explicitly set sev->asid in sev_asid_new() when a new ASID is successfully
> allocated, and return '0' to indicate success instead of overloading the
> return value to multiplex the ASID with error codes.  There is exactly one
> caller of sev_asid_new(), and sev_asid_free() already consumes sev->asid,
> i.e. returning the ASID isn't necessary for flexibility, nor does it
> provide symmetry between related APIs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f760106c31f8..7c000088bca6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -179,7 +179,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   
>   	mutex_unlock(&sev_bitmap_lock);
>   
> -	return asid;
> +	sev->asid = asid;
> +	return 0;
>   e_uncharge:
>   	sev_misc_cg_uncharge(sev);
>   	put_misc_cg(sev->misc_cg);
> @@ -246,7 +247,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	int asid, ret;
> +	int ret;
>   
>   	if (kvm->created_vcpus)
>   		return -EINVAL;
> @@ -257,10 +258,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	sev->active = true;
>   	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> -	asid = sev_asid_new(sev);
> -	if (asid < 0)
> +	ret = sev_asid_new(sev);
> +	if (ret)
>   		goto e_no_asid;
> -	sev->asid = asid;
>   
>   	ret = sev_platform_init(&argp->error);
>   	if (ret)

