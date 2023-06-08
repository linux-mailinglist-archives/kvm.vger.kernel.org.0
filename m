Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2ECC72757C
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbjFHDND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjFHDMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:12:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C772694;
        Wed,  7 Jun 2023 20:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686193966; x=1717729966;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sMbXuX3lu3dVqH5f33IbRDEXVtqf2GKK2B0SZ+tGM3E=;
  b=VJ/qNtTZh1JHfsZ8G+b7JcNEI4wsANCNN3pX3+GN1AWItDGrdahK/IBX
   m7eZF2drUVks+Hb8FLx9QVNcfZeAsBUt/HxfQCrXV1GUDumrVb7IjE4NF
   kOn56WQ+7HT0JSLezwgVSgEk4SHoUIyers3eV/AMyKSez0NlPL9lcb4K9
   4PcP/kEoggTh6ayOjExaC4xBonpYjYWka7LzowC0o5/29aqS2mCyHSOjm
   3mDwe4vcf+HI/R1Aj430zPVWpbXbp93OKHW82gT9JvL7Lq2ZXY7rpzsZI
   MTsAluZj/lvN37lGNm6zZiTwDP1pQJ8jv3WR3refS5meuERj+zIF3e6Ee
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="354672848"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="354672848"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 20:12:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="833993166"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="833993166"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.214.110]) ([10.254.214.110])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 20:12:44 -0700
Message-ID: <02d97490-9e59-8e78-8a54-0139d316d3b7@intel.com>
Date:   Thu, 8 Jun 2023 11:12:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.2
Subject: Re: [PATCH 1/2] KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
References: <20230607004311.1420507-1-seanjc@google.com>
 <20230607004311.1420507-2-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230607004311.1420507-2-seanjc@google.com>
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
> Snapshot the host's MSR_IA32_ARCH_CAPABILITIES, if it's supported, instead
> of reading the MSR every time KVM wants to query the host state, e.g. when
> initializing the default value during vCPU creation.  The paths that query
> ARCH_CAPABILITIES aren't particularly performance sensitive, but creating
> vCPUs is a frequent enough operation that burning 8 bytes is a good
> trade-off.
> 
> Alternatively, KVM could add a field in kvm_caps and thus skip the
> on-demand calculations entirely, but a pure snapshot isn't possible due to
> the way KVM handles the l1tf_vmx_mitigation module param.  And unlike the
> other "supported" fields in kvm_caps, KVM doesn't enforce the "supported"
> value, i.e. KVM treats ARCH_CAPABILITIES like a CPUID leaf and lets
> userspace advertise whatever it wants.  Those problems are solvable, but
> it's not clear there is real benefit versus snapshotting the host value,
> and grabbing the host value will allow additional cleanup of KVM's
> FB_CLEAR_CTRL code.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Link: https://lore.kernel.org/all/20230524061634.54141-2-chao.gao@intel.com
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 22 ++++++----------------
>   arch/x86/kvm/x86.c     | 13 +++++++------
>   arch/x86/kvm/x86.h     |  1 +
>   3 files changed, 14 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2d9d155691a7..42d1148f933c 100644
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
> +	if (host_arch_capabilities & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
> +		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
> +		return 0;
>   	}
>   
>   	/* If set to auto use the default l1tf mitigation method */
> @@ -373,15 +368,10 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
>   
>   static void vmx_setup_fb_clear_ctrl(void)
>   {
> -	u64 msr;
> -
> -	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
> +	if ((host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
>   	    !boot_cpu_has_bug(X86_BUG_MDS) &&
> -	    !boot_cpu_has_bug(X86_BUG_TAA)) {
> -		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
> -		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
> -			vmx_fb_clear_ctrl_available = true;
> -	}
> +	    !boot_cpu_has_bug(X86_BUG_TAA))
> +		vmx_fb_clear_ctrl_available = true;
>   }
>   
>   static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c7be4815eaa..7c2e796fa460 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -237,6 +237,9 @@ EXPORT_SYMBOL_GPL(enable_apicv);
>   u64 __read_mostly host_xss;
>   EXPORT_SYMBOL_GPL(host_xss);
>   
> +u64 __read_mostly host_arch_capabilities;
> +EXPORT_SYMBOL_GPL(host_arch_capabilities);
> +
>   const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	KVM_GENERIC_VM_STATS(),
>   	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
> @@ -1612,12 +1615,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
>   
>   static u64 kvm_get_arch_capabilities(void)
>   {
> -	u64 data = 0;
> -
> -	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
> -		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
> -		data &= KVM_SUPPORTED_ARCH_CAP;
> -	}
> +	u64 data = host_arch_capabilities & KVM_SUPPORTED_ARCH_CAP;
>   
>   	/*
>   	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
> @@ -9492,6 +9490,9 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   
>   	kvm_init_pmu_capability(ops->pmu_ops);
>   
> +	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
> +		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
> +
>   	r = ops->hardware_setup();
>   	if (r != 0)
>   		goto out_mmu_exit;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 82e3dafc5453..1e7be1f6ab29 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -323,6 +323,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
>   
>   extern u64 host_xcr0;
>   extern u64 host_xss;
> +extern u64 host_arch_capabilities;
>   
>   extern struct kvm_caps kvm_caps;
>   

