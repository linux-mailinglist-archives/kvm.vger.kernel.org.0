Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D960D5AA70F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 06:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiIBEkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 00:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIBEkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 00:40:08 -0400
X-Greylist: delayed 1476 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Sep 2022 21:40:06 PDT
Received: from terminus.zytor.com (unknown [IPv6:2607:7c80:54:3::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D8526AE5;
        Thu,  1 Sep 2022 21:40:04 -0700 (PDT)
Received: from [IPV6:2601:646:8600:40c1:5967:deb4:a714:2940] ([IPv6:2601:646:8600:40c1:5967:deb4:a714:2940])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2824ETn5646849
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 1 Sep 2022 21:14:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2824ETn5646849
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022080501; t=1662092073;
        bh=AAFAcyYvevmGoyt0qkojwfLI0sP7++l3bt0rETKoshY=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=IZtbZCHiZSUhm9W9dC74nV+v1OsE2C/t+WE972YhS/zbW2PDwrDr5OZU5FVsdfubl
         WKSY3/iFXnWQLZJM/Kg9mXF4iZRw/y3N13zY6a/dXegjblaTIkZ/PDOR1Bmnymo4YF
         BHhxphrU0+t3HBhL+O7AlEEaH8t0xl8OSuN6n5HOUNTSoScmDrtrBosK73go5+dvQs
         iREgIdP5qysR6y6TJN01dn01NqTqIlAYSkCKNdIZBJJSYSQEamhQiYU8JkNrcqJljE
         JdF+9Kz6UL0U1oorsufV13ZRZCwAiwvjoSgyve9bQQ5bTuAuRpe0fA4TKpJDkiXiE2
         ivGpYjxtbZIMQ==
Message-ID: <f956753b-1aae-37c9-9c9d-88e1550dd541@zytor.com>
Date:   Thu, 1 Sep 2022 21:14:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3 1/2] x86/cpufeatures: Add macros for Intel's new fast
 rep string features
To:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>
References: <20220901211811.2883855-1-jmattson@google.com>
Content-Language: en-US
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20220901211811.2883855-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/22 14:18, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits
> are already cached in word 12. Give the bits X86_FEATURE names, so
> that they can be easily referenced. Hide these bits from
> /proc/cpuinfo, since the host kernel makes no use of them at present.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/include/asm/cpufeatures.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index ef4775c6db01..454f0faa8e90 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -308,6 +308,9 @@
>   /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>   #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>   #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> +#define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
> +#define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
> +#define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
>   
>   /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>   #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */

Any reason why these bits are hidden from /proc/cpuinfo?

	-hpa
