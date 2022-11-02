Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36733616BCC
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiKBSOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKBSOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:14:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8FB1DF08;
        Wed,  2 Nov 2022 11:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667412887; x=1698948887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+6Cwh8mS4uE+7AT2oSEpjHEku7LzVrs36zVPClcj1/I=;
  b=LwJ4dRXc0iOlGZrW8//NOExHyd9W0TzLA3G+Pnnf6+qjmStQ3oRViPeb
   WPNelxV+7pJ7QhbhFK+dhVk0Nd/uVIDaGGDPR+wIRTithPpPHJx55/zgY
   Cpq5ey9Lz2tC/Yi3vis7TEAAt8DDp9CmqFdqFVVUB/gAylU+pO6map0jd
   bIv0UfQ70Ql1EBC9gpkWOQB6VPYGkA/z894JFwZjJlABfdc9LuUhmcez/
   1uboRcXZ1mL5zKYdaHQ/XiawGvFzkfF3f87f++RfFVjEf6SWuEskDBHyy
   A7Nl4df+sCtWaWbC0z6V3TC8fZ6YVLdt5mnjWQEicdY26rOolFVFuPMIw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311211527"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="311211527"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 11:14:47 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="963631311"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="963631311"
Received: from malhotra-mobl.amr.corp.intel.com (HELO [10.212.194.120]) ([10.212.194.120])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 11:14:45 -0700
Message-ID: <639c22a1-b0b0-9fb0-2a9a-060c53f9f540@intel.com>
Date:   Wed, 2 Nov 2022 11:14:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/6] x86: KVM: Enable AMX-FP16 CPUID and expose it to
 guest
Content-Language: en-US
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-3-jiaxi.chen@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221019084734.3590760-3-jiaxi.chen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 01:47, Jiaxi Chen wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 445626cb5779..9313240e3cdd 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -309,6 +309,7 @@
>  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
>  #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
> +#define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */

Please zap these from /proc/cpuinfo by doing this:

#define X86_FEATURE_AMX_FP16	(12*32+21) /* "" AMX fp16 Support */

>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>  #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 3f745f6fdc43..d983ddb974ba 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -657,7 +657,7 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>  
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> -		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
> +		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
>  	);
>  
>  	kvm_cpu_cap_mask(CPUID_D_1_EAX,

KVM folks, is the idea that every feature that is enumerated to a guest
needs to be in one of these masks?  Or is there something special about
the features in these masks?
