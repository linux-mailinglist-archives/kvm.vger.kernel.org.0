Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6278727580
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbjFHDPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFHDPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:15:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FBE2685;
        Wed,  7 Jun 2023 20:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686194104; x=1717730104;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X6ZWze42QVYOX8vk6mTf1shylq+/RkSUfBYN41GBkO4=;
  b=KcgmiLfIEwPr2rv2UacWGQ13Rsgk2SSy8dH/SniBR79+TexX4pCe7jma
   LUkjX30QhWMcaKdIuAD9R+eWrwX/UYNbq4x/BUbGKjEbIhrijECH1KzIw
   7vgCG1r45zX2nzERsDqHhBFV5IVE+S7bJ7WV324phNDGjh1PnyIme8WvN
   Bm+SvWKDFl3zJdJoHNkJ/QUt5V148puj3jurCixgQAdR3ZlTQteCppvZC
   oN5OZesedSayBn3dvuYx/UVFd3mhUtI6YlPRRfKUfwnbjVjftL+h0c8MP
   vcsTgib9ZzLPAv7bekJmLva0QHhvc5oRwArrGi8JWAcv3cpVBH4H84psj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="354673081"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="354673081"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 20:15:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="712941328"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="712941328"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.214.110]) ([10.254.214.110])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 20:15:02 -0700
Message-ID: <217febbf-07fd-32dd-de6b-2e767de6a9eb@intel.com>
Date:   Thu, 8 Jun 2023 11:15:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.2
Subject: Re: [PATCH 2/2] KVM: VMX: Drop unnecessary
 vmx_fb_clear_ctrl_available "cache"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
References: <20230607004311.1420507-1-seanjc@google.com>
 <20230607004311.1420507-3-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230607004311.1420507-3-seanjc@google.com>
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

On 6/7/2023 8:43 AM, Sean Christopherson wrote:
> Now that KVM snapshots the host's MSR_IA32_ARCH_CAPABILITIES, drop the
> similar snapshot/cache of whether or not KVM is allowed to manipulate
> ARCH_CAPABILITIES.FB_CLEAR_CTRL.  The motivation for the cache was
> presumably to avoid the RDMSR, e.g. boot_cpu_has_bug() is quite cheap, and
> modifying the vCPU's MSR_IA32_ARCH_CAPABILITIES is an infrequent option
> and a relatively slow path.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 17 +++--------------
>   1 file changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42d1148f933c..17003660138a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -237,9 +237,6 @@ static const struct {
>   #define L1D_CACHE_ORDER 4
>   static void *vmx_l1d_flush_pages;
>   
> -/* Control for disabling CPU Fill buffer clear */
> -static bool __read_mostly vmx_fb_clear_ctrl_available;
> -
>   static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>   {
>   	struct page *page;
> @@ -366,14 +363,6 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
>   	return sprintf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
>   }
>   
> -static void vmx_setup_fb_clear_ctrl(void)
> -{
> -	if ((host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
> -	    !boot_cpu_has_bug(X86_BUG_MDS) &&
> -	    !boot_cpu_has_bug(X86_BUG_TAA))
> -		vmx_fb_clear_ctrl_available = true;
> -}
> -
>   static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
>   {
>   	u64 msr;
> @@ -399,7 +388,9 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
>   
>   static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
>   {
> -	vmx->disable_fb_clear = vmx_fb_clear_ctrl_available;
> +	vmx->disable_fb_clear = (host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
> +				!boot_cpu_has_bug(X86_BUG_MDS) &&
> +				!boot_cpu_has_bug(X86_BUG_TAA);
>   
>   	/*
>   	 * If guest will not execute VERW, there is no need to set FB_CLEAR_DIS
> @@ -8580,8 +8571,6 @@ static int __init vmx_init(void)
>   	if (r)
>   		goto err_l1d_flush;
>   
> -	vmx_setup_fb_clear_ctrl();
> -
>   	for_each_possible_cpu(cpu) {
>   		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
>   

