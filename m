Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAABD70F096
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbjEXIZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbjEXIZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:25:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5ED8132;
        Wed, 24 May 2023 01:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684916746; x=1716452746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wf5w+pVCOmmTWohRf52XJbrasB2Q03aVKNpVbuoznkI=;
  b=bVCsxu2Heclr9kf6RXwT5sTHYK5kHxVFCQDPeq7WRJps51l7BbRewp4S
   ffd5M3cbvNFgVGu4teAUzhlwouqGGZWuAAcPG0LJCzt8cI3NVfnATZu4V
   PZbNGHrjalCQ0zlreAEIhSNLkn1yoztT4YBUzBrMGqudyFTknEkPmx3cz
   1pXi0ivMBSE0bYF9Jw/mb5SHsT/VISe6l66HLi/4c7obdp/XxYifVk6zM
   Imypf/LKtXGVOtqnVeyPTBogW84boXhX5hBl0gH1yGYIwcLKqKT/64Mb8
   7DxXienyIpVarTlxr1rv8qbcEygl0ldgFhi7OuISJ1k4S+pPTb3HuZ1Sy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="333855297"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="333855297"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:25:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="878559362"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="878559362"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.124]) ([10.255.31.124])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:25:43 -0700
Message-ID: <ec820c56-ad56-f7bf-db0e-1ba6f7cedfd0@intel.com>
Date:   Wed, 24 May 2023 16:25:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 2/3] KVM: x86: Correct the name for skipping VMENTER
 l1d flush
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230524061634.54141-1-chao.gao@intel.com>
 <20230524061634.54141-3-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230524061634.54141-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2023 2:16 PM, Chao Gao wrote:
> There is no VMENTER_L1D_FLUSH_NESTED_VM. It should be
> ARCH_CAP_SKIP_VMENTRY_L1DFLUSH.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2408b5f554b7..f7838260c183 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1631,7 +1631,7 @@ static u64 kvm_get_arch_capabilities(void)
>   	 * If we're doing cache flushes (either "always" or "cond")
>   	 * we will do one whenever the guest does a vmlaunch/vmresume.
>   	 * If an outer hypervisor is doing the cache flush for us
> -	 * (VMENTER_L1D_FLUSH_NESTED_VM), we can safely pass that
> +	 * (ARCH_CAP_SKIP_VMENTRY_L1DFLUSH), we can safely pass that
>   	 * capability to the guest too, and if EPT is disabled we're not
>   	 * vulnerable.  Overall, only VMENTER_L1D_FLUSH_NEVER will
>   	 * require a nested hypervisor to do a flush of its own.

