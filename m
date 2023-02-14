Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2E6955F2
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 02:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjBNB2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 20:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjBNB17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 20:27:59 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D0ACA16
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 17:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676338078; x=1707874078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7lyvN+NyGZL909hWquB9JcLAHP1s7Z86dhsmTP3xCVA=;
  b=P/w7R2HZ2ouGL7uxnizTIW01kCaATsRPEk4lFT2HzFGXcnuwqQhn4rqW
   PhAmSVq86nzTjLKusha/fDoSe5mG80lqQheIBe6koGKrxzoELxxkb/IRa
   aAVwuY104pYFNS29BOx8JgFhjLtk3Z+Bxnd1jaBdXfU2eiI1o6DKiwk/2
   4mccnVgwCOG3gSQVw9XhdxmC3bWwNJS1gFMiZ79EBEGt9GhSJsGfUy+UW
   UYcxNP7SqwKD20O/ou9qMfIMUGA6lIAAwSqjz/5fXIJAHYiUFnXlgrjLK
   rYpbcWsmfMuhtinqvFjSi2uAr2uuQd7qIjall9nTEHxDMufU2MxBRuxkC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310682584"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310682584"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 17:27:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="732703828"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="732703828"
Received: from lichengb-mobl.ccr.corp.intel.com (HELO [10.254.213.213]) ([10.254.213.213])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 17:27:55 -0800
Message-ID: <814481b6-c316-22bd-2193-6aa700db47b5@linux.intel.com>
Date:   Tue, 14 Feb 2023 09:27:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-2-robert.hu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230209024022.3371768-2-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch removes CR4.LAM_SUP from cr4_reserved_bits to allows the 
setting of X86_CR4_LAM_SUP by guest if the hardware platform supports 
the feature.

The interception of CR4 is decided by CR4 guest/host mask and CR4 read 
shadow.

The patch tiltle is not accurate.


On 2/9/2023 10:40 AM, Robert Hoo wrote:
> Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while reserve
> it in __cr4_reserved_bits() by feature testing.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 3 ++-
>   arch/x86/kvm/x86.h              | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f35f1ff4427b..4684896698f4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -125,7 +125,8 @@
>   			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>   			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>   			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> +			  | X86_CR4_LAM_SUP))
>   
>   #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..8ec5cc983062 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>   		__reserved_bits |= X86_CR4_VMXE;        \
>   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>   		__reserved_bits |= X86_CR4_PCIDE;       \
> +	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
> +		__reserved_bits |= X86_CR4_LAM_SUP;	\
>   	__reserved_bits;                                \
>   })
>   
