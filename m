Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B05346FE
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 01:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345105AbiEYX2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 19:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiEYX17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 19:27:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C364B674DE;
        Wed, 25 May 2022 16:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653521278; x=1685057278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A5LF7X+Nqrqi85XaY/ua9Jq6irVUh5oAfTWGmraE7gw=;
  b=TMmvV+IPGPBPKMshdXerr6U3evr6+w/3eeALPcNuSpuBrXevh8sZNot2
   2OQBkdxRA6WRxtsKay/B7+GvC3AF+tEJxGYpzcD+rqwQ4o3sP6aX4xBJF
   sxt0wV/CeVej6FNKlRBhducjwoT9gXfBKnAnNBMmQp7OO7wajJ6xoJVpZ
   qhoBKLBpfDk4RWgm18epU9fmsKEBhAXkEGUEq5V55Tviz5CcnR4mAZL/C
   MtGz57Xgql9ZNqJKtM1Znf8soO0ov1ye+rzncseH4flt+FlYUaLfAaNvk
   rGclF3wYi/4z3dyhK6RJglcPNjC7X543+4UJlDWGmN0YmYXlFbV49eU5s
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="360352128"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="360352128"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 16:27:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="609411661"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 25 May 2022 16:27:45 -0700
Date:   Thu, 26 May 2022 07:27:44 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
 kvm_intel load time
Message-ID: <20220525232744.e6g77merw7pita3s@yy-desk-7060>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525210447.2758436-2-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 09:04:46PM +0000, Sean Christopherson wrote:
> Sanitize the VM-Entry/VM-Exit control pairs (load+load or load+clear)
> during setup instead of checking both controls in a pair at runtime.  If
> only one control is supported, KVM will report the associated feature as
> not available, but will leave the supported control bit set in the VMCS
> config, which could lead to corruption of host state.  E.g. if only the
> VM-Entry control is supported and the feature is not dynamically toggled,
> KVM will set the control in all VMCSes and load zeros without restoring
> host state.
>
> Note, while this is technically a bug fix, practically speaking no sane
> CPU or VMM would support only one control.  KVM's behavior of checking
> both controls is mostly pedantry.
>
> Cc: Chenyi Qiang <chenyi.qiang@intel.com>
> Cc: Lei Wang <lei4.wang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h | 13 ++++--------
>  arch/x86/kvm/vmx/vmx.c          | 35 +++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index dc2cb8a16e76..464bf39e4835 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -97,20 +97,17 @@ static inline bool cpu_has_vmx_posted_intr(void)
>
>  static inline bool cpu_has_load_ia32_efer(void)
>  {
> -	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_EFER) &&
> -	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_EFER);
> +	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_EFER;
>  }
>
>  static inline bool cpu_has_load_perf_global_ctrl(void)
>  {
> -	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
> -	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
> +	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>  }
>
>  static inline bool cpu_has_vmx_mpx(void)
>  {
> -	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
> -		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
> +	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
>  }
>
>  static inline bool cpu_has_vmx_tpr_shadow(void)
> @@ -377,7 +374,6 @@ static inline bool cpu_has_vmx_intel_pt(void)
>  	rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
>  	return (vmx_msr & MSR_IA32_VMX_MISC_INTEL_PT) &&
>  		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
> -		(vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_RTIT_CTL) &&
>  		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
>  }
>
> @@ -406,8 +402,7 @@ static inline bool vmx_pebs_supported(void)
>
>  static inline bool cpu_has_vmx_arch_lbr(void)
>  {
> -	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_LBR_CTL) &&
> -		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL);
> +	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL;
>  }
>
>  static inline u64 vmx_get_perf_capabilities(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6927f6e8ec31..2ea256de9aba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2462,6 +2462,9 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  	return  ctl_opt & allowed;
>  }
>
> +#define VMCS_ENTRY_EXIT_PAIR(name, entry_action, exit_action) \
> +	{ VM_ENTRY_##entry_action##_##name, VM_EXIT_##exit_action##_##name }
> +
>  static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  				    struct vmx_capability *vmx_cap)
>  {
> @@ -2473,6 +2476,24 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	u64 _cpu_based_3rd_exec_control = 0;
>  	u32 _vmexit_control = 0;
>  	u32 _vmentry_control = 0;
> +	int i;
> +
> +	/*
> +	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
> +	 * SAVE_IA32_PAT and SAVE_IA32_EFER are absent because KVM always
> +	 * intercepts writes to PAT and EFER, i.e. never enables those controls.
> +	 */
> +	struct {
> +		u32 entry_control;
> +		u32 exit_control;
> +	} vmcs_entry_exit_pairs[] = {
> +		VMCS_ENTRY_EXIT_PAIR(IA32_PERF_GLOBAL_CTRL, LOAD, LOAD),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_PAT, LOAD, LOAD),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_EFER, LOAD, LOAD),
> +		VMCS_ENTRY_EXIT_PAIR(BNDCFGS, LOAD, CLEAR),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_RTIT_CTL, LOAD, CLEAR),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_LBR_CTL, LOAD, CLEAR),
> +	};
>
>  	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
>  	min = CPU_BASED_HLT_EXITING |
> @@ -2614,6 +2635,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  				&_vmentry_control) < 0)
>  		return -EIO;
>
> +	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
> +		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
> +		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
> +
> +		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
> +			continue;
> +
> +		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
> +			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);

How about "n_ctrl, x_ctrl);" ? In 0/1 or 1/0 case this
outputs all information of real inconsistent bits but not 0.

> +
> +		_vmentry_control &= ~n_ctrl;
> +		_vmexit_control &= ~x_ctrl;
> +	}
> +
>  	/*
>  	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
>  	 * can't be used due to an errata where VM Exit may incorrectly clear
> --
> 2.36.1.124.g0e6072fb45-goog
>
