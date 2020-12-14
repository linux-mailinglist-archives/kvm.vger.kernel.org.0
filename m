Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1452DA20E
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 21:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503391AbgLNUxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 15:53:13 -0500
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:3456
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502900AbgLNUxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 15:53:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEQxxCfJjHZEyPCVahI/6zRT6PmtNFZj5wZk2zVVXFHzYVDjpFENpsAtwIh5c9Chvyt+H6ki7xkgXr42EZvKh0RBJiizu7ft0g5ROZMbN9vg7TP3bGF3/l6odiLTIZfPPpI6SkAplK82EPjODA1qB7dBDyS46UAc1w5/Jf6Th5pohZoPWFTB45kUr9sZur00rakcf9zk/CqtwvEUQVXVuILUgeznQao/F2Qfn2jq1JrbY/E/oRKCvFWJ0yQVEZ6JJTHOknjxZbd+CKgUp60v5RrJTepXa7oh/4iiFNp1pUAG9H8jCVKlMGpA8V45S7QxF1MobA7443aoRGmvgxPlgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMo4VTHk5ROGoxlHBxCAzZwwTSxjT5eWhNd9gUHtfX4=;
 b=jV78hUSX0wuhyQmUxARGYjLWIhfgiUQKXN+h2q3iujAq6Pmin1AvrNkjQVrDLREcwCEFizxmfeoZC31n4gL1SwU4m3XBUHhWe3WINWuY0qHua7OCRLL00PlvcPP9TjKj8fmKTSmB9qpE3SveTwP0QRiyvj+0ePQCX+dSPtz4h+/ODJHxmNi6qhnhI6hS4AeG0RJuu4FsGXMTPr/aMI5Gkl/a3fvCag3qS8PV04Vf2+5Vj9wfBg8/M1daguAsZUpSVfsiTZVi6Vn03TVYqf+DT0q3ZR+7cT1o1HuJDuYlIMny8VVAQ1DNmvvparFP8FRNPoo7Qo0EUH8NpQfIEQ4kpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMo4VTHk5ROGoxlHBxCAzZwwTSxjT5eWhNd9gUHtfX4=;
 b=uLFMEzblHSB9whKLOzwpweIg9Uvymn5ekh69QHWWhSvKkpbKWTGktUBvIW9ymr/ez5+ACbCCjrvHBrrufUFwLAJRiwsbIRf9FW9ey9oww0dpgbhcQWlw1mVb9FlAbqtiZtTDJ2np6f2/5hAzuHFeA7hfjtJ8oyXL1oCg1N3m9qg=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1164.namprd12.prod.outlook.com (2603:10b6:3:77::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.17; Mon, 14 Dec 2020 20:52:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 20:52:11 +0000
Subject: Re: [PATCH 2/3] KVM: x86: use kvm_complete_insn_gp in emulating
 RDMSR/WRMSR
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>
References: <20201214183250.1034541-1-pbonzini@redhat.com>
 <20201214183250.1034541-3-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <bc04f9a7-cc26-2347-58ae-bcbc024d996d@amd.com>
Date:   Mon, 14 Dec 2020 14:52:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201214183250.1034541-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:610:52::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR04CA0018.namprd04.prod.outlook.com (2603:10b6:610:52::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 20:52:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f476310c-8903-4cfd-ee72-08d8a07220d0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1164:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1164599CC6654CA5DA272F03ECC70@DM5PR12MB1164.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Himnx7vcIhPHacfCeDmeE7U+Ah68ZUHxZZaQS5Rnapr70iSBdAp7n2Lgg5YMw4WIV/tq2Di8aEifj7n23P4kCu+kUf3YLdu4IXk8i/LrzTD7n4OK4V6DC58HATrUyRTHa58/ry+/YVRaUBm3VZrzeTkhGxaaZdkBxg+ApY7gSWyA25yCLNU9rLdvTi1ocrH7m5oOkAuWmrEuqE8inq/t6nwpKjO8DaTpxu9xDj5fX5wn+NSBLTGySeV31lcbi1uucJv2ucfxU9WwJJE+/VJ4ddngFKbXakVlONyPRUcnSTnJxatKpvtZHv6qh6LTGYgnDEAEkla892Mqsw4VkqHXIRBLBTTDF/6nZ0KU6vw3WGn6E7ulihLXHRaWP8VdoM5rJd2aPnZ1H5b9EPFT0KsjWsGdZZJDcXlMTocdjChcQDL/U97b8uY0ZyCHABbwqZe/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(508600001)(53546011)(16576012)(8936002)(4326008)(956004)(66946007)(8676002)(26005)(5660300002)(52116002)(2906002)(86362001)(16526019)(83380400001)(186003)(36756003)(2616005)(31686004)(34490700003)(31696002)(66556008)(54906003)(6486002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTRQQWxDRjNlandVd25KVUFGUm9YZVoxaG5WditSTkxhbzNNT01wMjBXVE9t?=
 =?utf-8?B?emxObDJWKzNWaFhCOU00cWR5SFkrODg1TWJNZ0d1cCtaUTh2ZnJ5bTk3ZVN4?=
 =?utf-8?B?VGVFaTBEanFUL21WV2dCT05EYlBGNlUwQlNYeCs1dUI2V2pxWGhOeVNrcmQ1?=
 =?utf-8?B?bjUvTHY0V0VZR3RvUm1CdUUwQ0Jjcm5zakVTdkVMMkhWOU1kcEZyVzN4a0V1?=
 =?utf-8?B?aUZYTjlMVDFtMTQvNjVuN0lMVEExWEd4YTdhb0xRWDJCUFNHOEhoeDRVdHFR?=
 =?utf-8?B?QzNBTlVySDVIME9NZkJzeE0zSnE2R1JpK013RkhPRm5vRm5nSWROUDZYeXBM?=
 =?utf-8?B?OW5zSnJCRE9tcm5GMURkUTdtNzJlT0FYNWdUN0NHU0RSL1F5M3djejVyZVIv?=
 =?utf-8?B?SGZubnBjYUI1bGY1b0UwQ3VvWWJEYWlpR2IxMVZJY1N4emhWWk9sMWMrckUv?=
 =?utf-8?B?MzZVMGN4Wm8yempjcW5LWjlFemNWVHBLZnRuRFhWZmxMV2x5Vk9BZEV3K2xI?=
 =?utf-8?B?WTRvQjhaUk52TktEQWZ1YkQ3ZURiSG9WZVVjN1FVRjBMZGI1bzVUdjNqZWZu?=
 =?utf-8?B?UWUxUEFKTDg1Zlc0Znd4cWJFeUI3dUlqblFXZGl4RXdGYjgxZXdjQ0NWSENN?=
 =?utf-8?B?M09IZE5PTzVGN016ZGp1K1cyM1pyVk9ncENpUkNXemswRmJwRUFwOFBWUWFw?=
 =?utf-8?B?R1djdXFWc0sxUERxT21PMTNXNS9mTklENGVSWkFMTmdjVkc5cUU3TTdvc2px?=
 =?utf-8?B?RlVsdFMyN0FmQWEvdXk2K0RNblFVSWlQRmttbGQzbUpCMnMydnh1TEFiRFZz?=
 =?utf-8?B?VUI4RUJSZ0E2R092S3BHU1l5VGFOSGx0ZW5kNXJza0hTZlptVHNPcy84YlNR?=
 =?utf-8?B?dEtmKzhjQjZ4UEhuQUJqRVRKSEh3NmhKd0o2K0xTdVd4bjBBTGhlMk1hcFg4?=
 =?utf-8?B?Qi90cXZUVXhTTUR5ZzNuWmxQSm1PeExGdFdRNk9zMGZyMTF1RkNTamRCTVR5?=
 =?utf-8?B?UWxBVGZGdzNnMVpSS0dTU0tJeXFpZkFYTTUvR3FMdkx5KzJ3SDZpYVFrR2RQ?=
 =?utf-8?B?NnNXL29vNE5CSENnK1dQbVNZTVk5SlRNSWpQdUtkOE1CcHBQbmpvUDY1S0xh?=
 =?utf-8?B?WDEyZ1dHQVJjSzRiVlE0WFRUeEh2RDlMakFIWHlWZFM4V3JHZDNTRS9mdHM0?=
 =?utf-8?B?Q3p6cjVrbUY2N01yM2ZPbVlOK21nVzZCTlB4djF2bUJiQ3c1SUZLK3RzUU9I?=
 =?utf-8?B?d2w0aG5vTmNQdThUVXZjV21qYnVEVGZvNTFybFBlVlorR0RRVnFmUTVQWTUz?=
 =?utf-8?Q?CC3o0P+K5d3cLfa4CtTnDi9AOQxkbFChg2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 20:52:10.9694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f476310c-8903-4cfd-ee72-08d8a07220d0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPSCeGXj5xsSbvvvraS2sdeub/wMxlLIPUuoVqTvNWi1IkIFoMztUAJHQrrMOC92FxpYoK0X3A3EhyGlobNwAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1164
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:32 PM, Paolo Bonzini wrote:
> Simplify the four functions that handle {kernel,user} {rd,wr}msr, there
> is still some repetition between the two instances of rdmsr but the
> whole business of calling kvm_inject_gp and kvm_skip_emulated_instruction
> can be unified nicely.
> 
> Because complete_emulated_wrmsr now becomes essentially a call to
> kvm_complete_insn_gp, remove complete_emulated_msr.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Just two minor nits below.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a3fdc16cfd6f..2f1bc52e70c0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1634,27 +1634,20 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_msr);
>  
>  
>  	/* MSR read failed? Inject a #GP */

This comment isn't accurate any more, maybe just delete it?

> -	if (r) {
> +	if (!r) {
> +		trace_kvm_msr_read(ecx, data);
> +
> +		kvm_rax_write(vcpu, data & -1u);
> +		kvm_rdx_write(vcpu, (data >> 32) & -1u);
> +	} else {
>  		trace_kvm_msr_read_ex(ecx);
> -		kvm_inject_gp(vcpu, 0);
> -		return 1;
>  	}
>  
> -	trace_kvm_msr_read(ecx, data);
> -
> -	kvm_rax_write(vcpu, data & -1u);
> -	kvm_rdx_write(vcpu, (data >> 32) & -1u);
> -	return kvm_skip_emulated_instruction(vcpu);
> +	return kvm_complete_insn_gp(vcpu, r);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
>  
> @@ -1750,14 +1742,12 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  		return r;
>  
>  	/* MSR write failed? Inject a #GP */

Ditto on this comment.

Thanks,
Tom

> -	if (r > 0) {
> +	if (!r)
> +		trace_kvm_msr_write(ecx, data);
> +	else
>  		trace_kvm_msr_write_ex(ecx, data);
> -		kvm_inject_gp(vcpu, 0);
> -		return 1;
> -	}
>  
> -	trace_kvm_msr_write(ecx, data);
> -	return kvm_skip_emulated_instruction(vcpu);
> +	return kvm_complete_insn_gp(vcpu, r);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>  
> 
