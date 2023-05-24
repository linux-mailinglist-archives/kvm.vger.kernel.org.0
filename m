Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B32C70F07E
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbjEXIT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240143AbjEXITq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:19:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46715196;
        Wed, 24 May 2023 01:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684916385; x=1716452385;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ilXW7elIWtAkRXlqUxe/z5itRqPSPN6cSMYozzzzW5w=;
  b=IgzbH0ITr3jLabJIltDm+N9I0QXBPJCJe6eaOw0sHo5s1iGzE92aAvrH
   aF4pTJL/U1UYIMKPphQR0gynaPTXvmr7J+0gDGzsU/kG5KzZ8kicUc8N9
   StCmug0ocRgqIJwB1XtcRehGlgw30KRCw2vNuK+qstjW1Cz3OFefTeScy
   4dzy47BIhS1Mwk/WPOaDTz7A7AAny9AxTi7SzfIGOnrC7JOdY8m7J3elq
   WEDzcYDTJutes2ED3Dj13YQ5Zmnril6IuuWkO7DOFPU1y/5MMVn+2Y+KV
   d0aDsjhqRpfPKC8m2jHrA37mSzngicku1sVJDLXGKFbV/7loufIqn6lXC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="352339303"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="352339303"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:19:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="769354033"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="769354033"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.124]) ([10.255.31.124])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:19:40 -0700
Message-ID: <e5c0fd8d-00fd-8285-3066-1a7bf6e17429@intel.com>
Date:   Wed, 24 May 2023 16:19:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/3] x86/cpu, KVM: Use helper function to read
 MSR_IA32_ARCH_CAPABILITIES
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        linux-kernel@vger.kernel.org
References: <20230524061634.54141-1-chao.gao@intel.com>
 <20230524061634.54141-4-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230524061634.54141-4-chao.gao@intel.com>
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
> KVM open-codes x86_read_arch_cap_msr() in a few places. Eliminate them
> by exposing the helper function and using it directly.
> 
> No functional change intended.
> 

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>   arch/x86/kernel/cpu/common.c |  1 +
>   arch/x86/kvm/vmx/vmx.c       | 19 +++++--------------
>   arch/x86/kvm/x86.c           |  7 +------
>   3 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 80710a68ef7d..b34dd3f3e6c4 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1315,6 +1315,7 @@ u64 x86_read_arch_cap_msr(void)
>   
>   	return ia32_cap;
>   }
> +EXPORT_SYMBOL_GPL(x86_read_arch_cap_msr);
>   
>   static bool arch_cap_mmio_immune(u64 ia32_cap)
>   {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8274ef5e89e5..3dec4a4f637e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -255,14 +255,9 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>   		return 0;
>   	}
>   
> -	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
> -		u64 msr;
> -
> -		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
> -		if (msr & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
> -			l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
> -			return 0;
> -		}
> +	if (x86_read_arch_cap_msr() & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
> +		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
> +		return 0;
>   	}
>   
>   	/* If set to auto use the default l1tf mitigation method */
> @@ -394,13 +389,9 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
>   
>   static void vmx_setup_fb_clear_ctrl(void)
>   {
> -	u64 msr;
> -
> -	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
> -	    !boot_cpu_has_bug(X86_BUG_MDS) &&
> +	if (!boot_cpu_has_bug(X86_BUG_MDS) &&
>   	    !boot_cpu_has_bug(X86_BUG_TAA)) {
> -		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
> -		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
> +		if (x86_read_arch_cap_msr() & ARCH_CAP_FB_CLEAR_CTRL)
>   			vmx_fb_clear_ctrl_available = true;
>   	}
>   }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7838260c183..b1bdb84ac10f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1612,12 +1612,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
>   
>   static u64 kvm_get_arch_capabilities(void)
>   {
> -	u64 data = 0;
> -
> -	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
> -		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
> -		data &= KVM_SUPPORTED_ARCH_CAP;
> -	}
> +	u64 data = x86_read_arch_cap_msr() & KVM_SUPPORTED_ARCH_CAP;
>   
>   	/*
>   	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that

