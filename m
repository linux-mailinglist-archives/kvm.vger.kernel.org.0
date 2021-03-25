Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7AB349512
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCYPNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:13:44 -0400
Received: from mail-bn8nam08on2040.outbound.protection.outlook.com ([40.107.100.40]:34451
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229547AbhCYPNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 11:13:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6nFgYTKLsgWFZn5kjtd5rpHCqk8ajCcKIkJbMsxUUKAlD6iPVX92Bq6M5OTgqCFy1/WDjLRNYYoE/G7BQXx4qC5YoBcvRX4vx/dh3NBzljwfHWcNjD02U7sfiqQt1RNKySDeWEqpky6maCvHE9lTO4T/dHAQHSzcKLxJNMLtZNnqZmsTGjmZHDRWZ1/nx5cuum4rZBtuR4D7itcP5pwRXfIeqRIjBKtD74zdkoAQuzdIN5qWxcOCWB2efgOUOKSAgu/DjuxfiHAzOzdl6spuzHgp1nvVnQnMmDRKN3uou5sl5R5aA74s1xJVCOLuti2VO7om8vwGPH29i0RTnF//g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnzkXhpnf6vDBUpWcmLU39NgLNkpNCCiSi3YHmg8m8c=;
 b=ma38aoCx8GXlrgsqECVOGhl1LgLT/YMZ2TV1WAtQw+xBZhhcItoOAgIdN595Fpz6sfBHc1NmfnvnFmORlXFJuSo1uWXmQzRWXgaAjsgaYFnLGTJOc3AtQHtQJly7aYqIFImfpUdAHwUGOS6kShlKrjQkJ2/kDCul7ffqWxQigTY8EcXJZrIia2VEqnOZ80eyCQ9vCZDY9kdyYgbK7+YjzKWJ4UwWOoBAFUmO5AiAjvdGxnPcmBVx65ANy6sDZ4z4HwcwQ25CbALO2xoisLKEwj2/J2MjtbsnEMrN/zHcOGBY2FsuBWCHGlWffkM2BL7US8c/YIl7jzR7Rzhj6Mj06g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnzkXhpnf6vDBUpWcmLU39NgLNkpNCCiSi3YHmg8m8c=;
 b=HCxMvJ9mbIrAR989DHQpeog4zhG8jA0Dt6YsomHVFaUxkd42Vxxad0zpbW4s0x4v+5DNk+YAcwIM9rTq33oj38lN8AtzvvMePMch7Vu3keVw6wjpfCBWom5Z9w90pjNKei6Qz0+frCv83Lwi7SpGsv7EsxlOD3x6sclLkUMszUs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Thu, 25 Mar
 2021 15:13:12 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::487b:ba17:eef5:c8eb]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::487b:ba17:eef5:c8eb%2]) with mapi id 15.20.3977.024; Thu, 25 Mar 2021
 15:13:12 +0000
Subject: Re: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
To:     Borislav Petkov <bp@alien8.de>, Hugh Dickins <hughd@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
 <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
 <20210325095619.GC31322@zn.tnic> <20210325102959.GD31322@zn.tnic>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <c853578c-1a47-6fb0-8bf8-9c9f5c991e30@amd.com>
Date:   Thu, 25 Mar 2021 10:13:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210325102959.GD31322@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:806:21::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA9PR13CA0018.namprd13.prod.outlook.com (2603:10b6:806:21::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Thu, 25 Mar 2021 15:13:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15ea5d35-6c30-425d-46c0-08d8efa08193
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:
X-Microsoft-Antispam-PRVS: <SA0PR12MB43525AB89B77CBA1FEC7802895629@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JAzPZfyT871/rzldcDJ6Wai8rQoHhZAgz3RBImsoGiNhPh0l6Nnuu489kgPytkWEqftuiIVKMPADERQPP854dv/zS6jT7R2ad/4ePjBjH4nMjYDKX4L+4ZoPJP8GLsFGqUSO5bFHR0f/wjDXIuaFXziVPT798M3EPUEEnBBZIMXcszn2inGP9KpRQJNK/pynR5uEUDUPVxQXng8HjI8AqdyTNkrGNiqty699z0LCuUJcNwW4S4tCa13ULFAb8C8Dkp4qVFcJAFzEbgDveiJT8rQ8hDjU2MsFTKJbwmUxL8HqTVEx471/FK34BjigmDIYLiDj6zxpHAfMgLe20q+pJViDNyZyo8RLHTuSGh0jprgile5mb8uFoghhBdmLi5nTeogQFoMd5LuWV0CaGWJJRZc3I+IsnK4MoNLD/NJXYxNIDD5qT48463eP57DdbsOH3He9mm47G787nwc0JV0K8YhLFGYU9jS/uZXJIVb1LzuL2v5onw73fZ92Pw7YoeM3y7QPJkr1wX2hUC59/cvKZATBTtHyUzFMpRwK+Y/1xXJVf5vkVlgOKHDaIw7ctJ1oJDGLlmTGiAVGXMAaaOWaR0mxDJBUPk4LPfr/3Riz1JvVZ6EYMGXsg7INXWs3qCvwioMbr0eJx/MtukV4o5vY5rj2jFVn92IUEHaGRIhQziwcBdAkNE0glzOtJPx24UcNL1HQmxKAeGRO5vnAVIaawLAnKq8rymk6yzKA92sLSLMGFkKkprlpcmd1y48QG8b7duNqi4zn+ldK1FLp50r+BmC6Fj07fbSKyclyFe2xEHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(956004)(6486002)(966005)(66946007)(4326008)(53546011)(16576012)(478600001)(16526019)(31686004)(2616005)(54906003)(2906002)(52116002)(316002)(44832011)(186003)(31696002)(110136005)(36756003)(8936002)(5660300002)(7416002)(26005)(66556008)(83380400001)(45080400002)(8676002)(38100700001)(86362001)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OHBCaDB4RlQ0dU0rUzdNN1o3Tllra3BFWHVJTUxSdzZOMW83akpFRUptc0dk?=
 =?utf-8?B?ajF3RGhzR3I1eGFQRHlVb2tqM2dwb3lFZE4wTmRBejJXVEtkdVhVVkhLdVht?=
 =?utf-8?B?dENoZXpxWk9YK05ReXNGdmE1My91RFR0WHY5aTh3OWJhRDRRYzRBaDE1NmJz?=
 =?utf-8?B?bzlxRVhTY2dUaGk3TW5nT3ZORkFWQm1GVmVtMkd0Ti94QTNpMnFQb3YrWXJS?=
 =?utf-8?B?Wmw0TC9aSHVWUjdzemxmL2RBbGkxeTAxVHRDSGk4bmJlSnNDMmFiWXhKYnZY?=
 =?utf-8?B?VXpxaGxLQXJuV0lVYjJoMHRwY25YTjVpbmhKakk1T2Y2KzE5WURyRCs2VDJX?=
 =?utf-8?B?NElXM2Y4QXdJLzVmUEFFSkRFUDZ3S0kxT0xSZjdOYUtvbFBENytaUHRWVm9N?=
 =?utf-8?B?NGpvT2dqU09hYkZSMnBWR2IrYnlvSmk4bXZ4UjlYOFRwZ3hjaXRaNkZQVmtQ?=
 =?utf-8?B?djBBclFiUUZwMVVQd04rNWlTUU1TcmdrQVR3cmt0QVZPam1pc0xMUC96dWhi?=
 =?utf-8?B?VnBFbGw0VkhNR1E5WUNaU1kvWEFwWTRnZEZpWDAxZDl1Qm9sY1o2MW52YmFW?=
 =?utf-8?B?b1VlY1JyQnlXaGIwMFNGdzVmeEdnWmZ5RmE3VDR3TFJUT2UyM3NJck4raXVa?=
 =?utf-8?B?WnI0ZFlaNTFqM3dQSDJVaTEwT3BQdUF0Tkgyb0VBSzgyUlMzQ3BNSzhBTUd2?=
 =?utf-8?B?ZklKaVBwNEFhMStKeVRaRHExN2lKeG4vWmMrS0xCaU5pbUFYaUpvaGxENytD?=
 =?utf-8?B?cE5xOEF3dXFyRG4xTURWNFJQMyszWmhXekxxUE8rbVRsN1VGVmxmVXpNbFZX?=
 =?utf-8?B?RTB5ZzAzS3M1bjRCYXBmV0gyN2tFMnhXZkc3UGNaWHVwYmpYWEtCQjBrK1o5?=
 =?utf-8?B?cGtLYVRUZ0NNUE11L2lSZnAwZWlNaUl0TG1ITlBoQlFTWi9rSnpuS0NWZ09Z?=
 =?utf-8?B?WndXdTdZUHpTbzlMOE5XSkI3QU5OazRlU3VOVnJVZ3hGRVVIbDFMQUlZdVZl?=
 =?utf-8?B?TTNmbkdENE1JS09MMGtvQmNRS2U0cnJBRTJManRRU2cvQ3VOdm9MWUt1OWtV?=
 =?utf-8?B?ek5NZ05hN1RvcENMMlRaNko3eUU2S29hNDI5ZWNJaVRqSkNSVHJyY1ZZQXM2?=
 =?utf-8?B?RUhOUmFZYWdlWHVvYU1EUzhHNXM3VWpQYTBxWnNXT2Q4VTAwcWVZWms1cXpt?=
 =?utf-8?B?WkdRVW1FdnByZ2U5SXU0cmFRME4vN1F4ZmExbFExM0pTQ29GNFhNRjVTd1BH?=
 =?utf-8?B?cXBmeXY2a1MzUmJoZ1dhc0FNRWl4MFRvNmNQWGQrTE5nNjFYQnV3WnZMQTdK?=
 =?utf-8?B?OEYyamprRUlvODFlUUNzK3dGYTJ2V0dpVVd2RVo3Rm13Z2g2NVhDK0QzRjcv?=
 =?utf-8?B?QjNveGtNY21adUpzNW5ZRWlVL3g1SlIxblRwUTdKaTdaUUFDRU05eUZVbW1V?=
 =?utf-8?B?RDdpaDVDRE1zMzAycXM5dUJpQSswNmU2QnlsNkMxbTFrS20wandteXBNcXdI?=
 =?utf-8?B?MGNsSnUxei8vdmR0enFvOXJUVkpWRDNNTUxiZ3YyMlpLWDhCYVM0aWlJbHdv?=
 =?utf-8?B?MzJZcFZjMmJZelFSRzhFK0REL3R3bmlHUUdTM2YxWmx0YlhlZnRkaFY1d3VY?=
 =?utf-8?B?Qlk2NGxmUGZQaSt2a3dMaHdUdUFDWFNLWER0ZU1vc3JxTVViN3M0akJqVWlQ?=
 =?utf-8?B?eTVQOWlQaWZISms5UmwzdWNoYytGd2RMaTNuUjVsQXFxWjE1OFNObE5EMVZk?=
 =?utf-8?Q?35kz3q6Qfc7ywDs1YxHOkDJ5vwWSq6OwKL1W05l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ea5d35-6c30-425d-46c0-08d8efa08193
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 15:13:12.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzwtloaGLxjUvjgKQjb8/WgYhH9Q3JifBI+GkjUndJBYRORB6tTFm4rItLPW4ztO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 5:29 AM, Borislav Petkov wrote:
> Ok,
> 
> I tried to be as specific as possible in the commit message so that we
> don't forget. Please lemme know if I've missed something.
> 
> Babu, Jim, I'd appreciate it if you ran this to confirm.
> 
> Thx.
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Thu, 25 Mar 2021 11:02:31 +0100
> 
> Jim Mattson reported that Debian 9 guests using a 4.9-stable kernel
> are exploding during alternatives patching:
> 
>   kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
>   invalid opcode: 0000 [#1] SMP
>   Modules linked in:
>   CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.9.0-13-amd64 #1 Debian 4.9.228-1
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   Call Trace:
>    swap_entry_free
>    swap_entry_free
>    text_poke_bp
>    swap_entry_free
>    arch_jump_label_transform
>    set_debug_rodata
>    __jump_label_update
>    static_key_slow_inc
>    frontswap_register_ops
>    init_zswap
>    init_frontswap
>    do_one_initcall
>    set_debug_rodata
>    kernel_init_freeable
>    rest_init
>    kernel_init
>    ret_from_fork
> 
> triggering the BUG_ON in text_poke() which verifies whether patched
> instruction bytes have actually landed at the destination.
> 
> Further debugging showed that the TLB flush before that check is
> insufficient because there could be global mappings left in the TLB,
> leading to a stale mapping getting used.
> 
> I say "global mappings" because the hardware configuration is a new one:
> machine is an AMD, which means, KAISER/PTI doesn't need to be enabled
> there, which also means there's no user/kernel pagetables split and
> therefore the TLB can have global mappings.
> 
> And the configuration is new one for a second reason: because that AMD
> machine supports PCID and INVPCID, which leads the CPU detection code to
> set the synthetic X86_FEATURE_INVPCID_SINGLE flag.
> 
> Now, __native_flush_tlb_single() does invalidate global mappings when
> X86_FEATURE_INVPCID_SINGLE is *not* set and returns.
> 
> When X86_FEATURE_INVPCID_SINGLE is set, however, it invalidates the
> requested address from both PCIDs in the KAISER-enabled case. But if
> KAISER is not enabled and the machine has global mappings in the TLB,
> then those global mappings do not get invalidated, which would lead to
> the above mismatch from using a stale TLB entry.
> 
> So make sure to flush those global mappings in the KAISER disabled case.
> 
> Co-debugged by Babu Moger <babu.moger@amd.com>.
> 
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2FCALMp9eRDSW66%252BXvbHVF4ohL7XhThoPoT0BrB0TcS0cgk%3DdkcBg%40mail.gmail.com&amp;data=04%7C01%7Cbabu.moger%40amd.com%7Cf4e0aacf81744dc8be4408d8ef78f2cf%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637522650066097649%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=1c4MQ9I9KrLxWLqghGCI%2BC%2Bvs0c9vYaNC5d%2FiYL0oMA%3D&amp;reserved=0
> ---
>  arch/x86/include/asm/tlbflush.h | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index f5ca15622dc9..2bfa4deb8cae 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -245,12 +245,15 @@ static inline void __native_flush_tlb_single(unsigned long addr)
>  	 * ASID.  But, userspace flushes are probably much more
>  	 * important performance-wise.
>  	 *
> -	 * Make sure to do only a single invpcid when KAISER is
> -	 * disabled and we have only a single ASID.
> +	 * In the KAISER disabled case, do an INVLPG to make sure
> +	 * the mapping is flushed in case it is a global one.
>  	 */
> -	if (kaiser_enabled)
> +	if (kaiser_enabled) {
>  		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> -	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> +		invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> +	} else {
> +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> +	}
>  }
>  
>  static inline void __flush_tlb_all(void)
> 

Thanks Boris. As you updated the patch little bit since yesterday, I
retested them again both on host and guest kernel. They are looking good.

Tested-by: Babu Moger <babu.moger@amd.com>
