Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01843332C4F
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhCIQkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 11:40:01 -0500
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:57215
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229916AbhCIQju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 11:39:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwEwU9dyT525313lTtTD6T/BSMvzh5krOtZjmHGqThGiOKHMg6IW6BZTVdk0drnZme/AGi4nq0h/qwDwTl+icIXn1z+f9sGqM4t2kGKnk8jHmNV2ol5414N2H/3/vhAoUbJsHls7uWj2NXN+zrU3RTi8GOCmT0PWsdKb+vKZq+YBq9G1veZ/JJMFekDNje7eh0kN82GRuMIIkkBfYDv5SkURaZd5rHHC+Ht/3vXcEp/z7zzWvonxbhQeO+ggHUMKdvWz1eixgeAPN6RKMPbtfqJpeqrgMlc1siOBudkUmZYqcaIDz5WbgXMlYm/kZfSyPD+xpIU6B9flebnjlCQlzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kwks3ARb0H/OPMimyCRuTuPeu1s966ieY3YoA4LYKE0=;
 b=Sk57c2I5drKyn0aV6sneEV4BBCF/PaFez9+6fCB7HHegj0UySW8cceyyu1Ft9slEbyCgRGsMZ+32IM4vXft+jQ1HqqZxGWd4SlHQDgYTDbeHYYvS4DgYPM4I+Wd+j5fLRUvbUfodHiqdWZ4N4g/ZOid5wCU/EFA+19F+gmMjoQDy7UDkXx2gISY2O3ibqdM4dCJP0CQlXbiaUSBlBV8bwbZ/KvPIfIaL76OylYGQzlo6eRYaJSC/pxnyLZGl0Wn4pVQy1o98rpoQOk5Kawraf+j819w6W6b3tzYPl9JHVV103B3kRSzGC+OAwTQ4QS6tyCtske2k4PCX/ZnjwwCofw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kwks3ARb0H/OPMimyCRuTuPeu1s966ieY3YoA4LYKE0=;
 b=vdFT1TZfnuWvzf/cHAWBQPvILnbtYW79iMCHhMhYZPYSKVgxQz8u11mtQ01zkLFpob1KUi2MtT6NA4GuMkLjdhTL4VVfsvbmz8CGevrLzduwFFPXBtqgwhufToGGYqgxhnWOq+Nf1XqJIDnMep3dQ7mCcaXA5yqFqT+CE1gq8DU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3690.namprd12.prod.outlook.com (2603:10b6:5:149::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Tue, 9 Mar 2021 16:39:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 16:39:48 +0000
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO
 SPTE's generation
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210309021900.1001843-1-seanjc@google.com>
 <20210309021900.1001843-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d7708644-f35a-952a-a0aa-ea376ac6490a@amd.com>
Date:   Tue, 9 Mar 2021 10:39:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210309021900.1001843-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:806:21::7) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA9PR13CA0002.namprd13.prod.outlook.com (2603:10b6:806:21::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Tue, 9 Mar 2021 16:39:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ef86040-4c38-418f-4c67-08d8e319f439
X-MS-TrafficTypeDiagnostic: DM6PR12MB3690:
X-Microsoft-Antispam-PRVS: <DM6PR12MB36909C962C6C33629289CC66EC929@DM6PR12MB3690.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfMlXdtiWhrvr+I4fZcs03ItfjT106BMSK1avsaQ2ciOwAEreFM8V1UAD8Y811v3ZSIr4g9uowHcoxHptg2FPJfK+GmKq+88tfG/q6kEP9NcE0eXeffF4zI6E6kfQ9hSIa2fl+ExeqwI+WdcYQ03zZ900EqHGs28sdAvjX36ovfSua7WVW8M8CAHKcZn9ZSvwiTxaJ5+meX6V4sZz4A5kvkE57jkkGL7dGxmDytyNNdSUZ/IIX01bwKzIwxnB7H0wqM9EvnCGiqMD06nM4TnUcIT3+o4JnRFHZlvoCK7mKHjjfFPdsnsxPKQED6oDZ2Tb/nD7D9rJQpno3KAPEkec8Zmraz/3nL1Aj2TCTJXElCfcnT+vbA5zyTQhnLjnb5p5Mp8TBsrbQ5ZSofGD4mkcKYZEqPyN6U/C0tDvHTnhCkVG94zu5XELjrwj7GdsSSTtIbxGoQiK7OOIgijR4QE6UQZtGZ6JlaTLVChLBTDYXUtSj5qPPuDwj/1Szr4PRxo0ND4LyDro1b2JMYvnBkpWc51ME8Vg1KZpSkERk8pHQRHzVo8twxDHvv732f39fFijUsF4kl0kJyLyyiu8y/PwKjhGm0ZUu6JkaCkJ1/dGDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(31686004)(5660300002)(86362001)(316002)(956004)(186003)(66556008)(4326008)(66946007)(2906002)(66476007)(478600001)(54906003)(31696002)(26005)(36756003)(16526019)(83380400001)(6486002)(8936002)(53546011)(8676002)(52116002)(2616005)(16576012)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N2h0YVViUEFPR3FsOFBQWC9YdSt1c0xPVTNjMVE2VFhiYm5VWmU4TmhEWHIy?=
 =?utf-8?B?Q0dZaHE5TXFmdXRkd2NLOGpJbWFKbFdHZ0F5ZmIwOW83VUg1ZS9NWkNtZlRn?=
 =?utf-8?B?K0ZITmliMEphTnpseXRUZmMwWDI1WWhFRnM4V2grdGpxMTZ2UXNSMWZhOW83?=
 =?utf-8?B?aWtVejM2UWRpSTNtTklqanBGenJxVW9sQTNEajB4cVVkZXdxOXN3TFk5ZCtU?=
 =?utf-8?B?dXhGOHhxbUtGWjUxNEZ4UEFnL3FTNnhPSUIxdnJoVkw2R3d0VXFmcVZKbGov?=
 =?utf-8?B?eEhhSHFlNk0zajJRVEhCbnBiK09EblUyc1EwMmhrWjZkbFB6YkJPNndiSHg5?=
 =?utf-8?B?ZDduYkFqTFh1RmJ2MGUwK0t0THZ6QUNBZS90eEdiWWJvSVpxMWpFemNCelVW?=
 =?utf-8?B?MWRxQ094MEkrLzNHU1lHOHBzMkY3SmdYSWhwQ0J2dmZjdnNZSVJTRFRuY0Zy?=
 =?utf-8?B?YTVYa0VEbDFPdFE3T0JCZ01wOFFBOC82R3JBMkg2b1hxS0xnWkFsMFh1YXlU?=
 =?utf-8?B?ZFpCRUNaRkliRklldHJhUWMyTWxZeTh3WUdYaUdPQkZXOWNBYndFWTk0Qytu?=
 =?utf-8?B?aWNpcUg3c3JzaWZKOVJGZ21SZTZadmUvVzF4SGc0cW51N2Jla3JTdGVyV0Ex?=
 =?utf-8?B?NkpkVDF2K3JYOGRVR01UWGRjcktlSjFKRXVmNHZLUTZnK2NHd2NjWDZjU1Jn?=
 =?utf-8?B?Zm9TZHhTZFV0ZVQ0ZGNwSlhFUWdVZWF4ZlFjdXlTbWNWMWJQS3FIZkgxNzNs?=
 =?utf-8?B?dWRjd3FXT2RQUUp5MWVoL1RvSlAyTWZmTlQ2WmZBb2N5OTVaNVd1S0VNUzgz?=
 =?utf-8?B?a2hpVWF6M1hJMWNPU0ZTL05ZY2VYOGRncXlIY3cvT0REcFVYZ3ArcWNaY3Jm?=
 =?utf-8?B?NS9tWEhYL1dFQzg4QVQ4ODkyZmJ6TmZPZUxod0g3SHNyZEJ5ekVjUTM1K3Fo?=
 =?utf-8?B?dTFaOUMyczF2cUx5QUxFR2RPNDFiYmMyclVDV0M4U0JaYW1GSGhqNldMRWhK?=
 =?utf-8?B?b24reUNxd3RWdUlFeHVyRURlcXJPSzFWdnUzajlXdnI1RkkzOHVWTkNOWm8z?=
 =?utf-8?B?Ri9DbVgvR2NWYWJhcVc2MklNRUV1UnBFWVR0bjVzZjU0ODRLYkZxMThTRXAw?=
 =?utf-8?B?enBvcDRrRXhiMGpIbVlRaW1uODA5eU56UVNndFl6RXZSWVFNellHUXZ4SWNP?=
 =?utf-8?B?VUtOWitKQ2U1WTBsMHdqQWlvRWNFQVZITnc5SzBZaVdQZUsvOTZRc0VqL3Jv?=
 =?utf-8?B?YXJUMnQwbG55STkyWXc0UnJualluWTVJWnJob25nTjBqNVBGQWRLMEZOMmFy?=
 =?utf-8?B?SHhiQkpOaVRFcFA4YUY1WmErVUtEUTBqSDF3Y3RIWkQrTVRqR0hUOEUrNk9S?=
 =?utf-8?B?aHZRTm8xMnZ3WlF5TjB6dHQxaTNnQUZOWW1KbU5Eem1Hek5rUjB6SmFQRUJx?=
 =?utf-8?B?K00xVENSRlRRMWJlZExaV2VPS0pHN3ZEdjAzSzRkNXRMUXZNKzFGOUtrTjg3?=
 =?utf-8?B?TFA1Nk5abHNqUS84UDJVS2Z2bXlIaE8xSEh0c1pNbm1GMHZlQVZqRmNER29k?=
 =?utf-8?B?bFhtTTBKNE1Gck42N1RIKzlNalJneGIrakhnZ2dnZ2NlQXRkRDJzdm9qdUQv?=
 =?utf-8?B?Y2c3QTRxU1dpMWNsU2IvaHV0emFNS2tGRC9BdVNyTEd0WlZDMFVNYmQxRWNN?=
 =?utf-8?B?NldQb0YvL3Y2V29iRnJZclhWVHJJMWRMM3BPNnI2WDF1Nkl3amZIcjA1cUpS?=
 =?utf-8?Q?Re5AUZY+GBJ3Lb9+k/YuFg88zc/AwYfUMWfVNZZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef86040-4c38-418f-4c67-08d8e319f439
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 16:39:48.8036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBKDvZmDK2D1ThY6cGzaYekXwhqSrcJpMD5ecplg0CrkjvGotrceKAlu1D32xTxdJ8FSukwgTbdcxIQJUC1MXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3690
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/21 8:19 PM, Sean Christopherson wrote:
> Drop bit 11, used for the MMU_PRESENT flag, from the set of bits used to
> store the generation number in MMIO SPTEs.  MMIO SPTEs with bit 11 set,
> which occurs when userspace creates 128+ memslots in an address space,
> get false positives for is_shadow_present_spte(), which lead to a variety
> of fireworks, crashes KVM, and likely hangs the host kernel.
> 
> Fixes: b14e28f37e9b ("KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs")
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>

Fixes the issue for me. Thanks, Sean.

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>

> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/spte.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index b53036d9ddf3..bca0ba11cccf 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -101,11 +101,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>  #undef SHADOW_ACC_TRACK_SAVED_MASK
>  
>  /*
> - * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
> + * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
>   * the memslots generation and is derived as follows:
>   *
> - * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
> - * Bits 9-19 of the MMIO generation are propagated to spte bits 52-62
> + * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
> + * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
>   *
>   * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
>   * the MMIO generation number, as doing so would require stealing a bit from
> @@ -116,7 +116,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>   */
>  
>  #define MMIO_SPTE_GEN_LOW_START		3
> -#define MMIO_SPTE_GEN_LOW_END		11
> +#define MMIO_SPTE_GEN_LOW_END		10
>  
>  #define MMIO_SPTE_GEN_HIGH_START	52
>  #define MMIO_SPTE_GEN_HIGH_END		62
> @@ -125,12 +125,14 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>  						    MMIO_SPTE_GEN_LOW_START)
>  #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
>  						    MMIO_SPTE_GEN_HIGH_START)
> +static_assert(!(SPTE_MMU_PRESENT_MASK &
> +		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
>  
>  #define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
>  #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
>  
>  /* remember to adjust the comment above as well if you change these */
> -static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 11);
> +static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>  
>  #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
>  #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
> 
