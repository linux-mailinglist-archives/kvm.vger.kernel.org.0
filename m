Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6134F6276AA
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 08:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiKNHti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 02:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbiKNHth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 02:49:37 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12685C2F;
        Sun, 13 Nov 2022 23:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668412177; x=1699948177;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OAma0AQcRYfh/Iefxk+hEiI+He8Dtgk0YGypPF8trQs=;
  b=g4nGvvP0r0Z0mxdWPNW/uwHCNmbrCkDp/eWx4+JXdFgu8aDqgKadcJdD
   iFOzyi4SRLzoJADAmNQK/nbjl+rRmfLuyGLPnHbaICVuXDasuomuIZqxA
   plVXCjVbpre2hBb5phb1QBVGV1m24/ylkiwRAdXdRrkE5lBu6epZ78e75
   pMC7UmuxS7CucgPuVpSDbyB2Z4skoy1d9RARH4o2qBITLw2r6OV8OzJKN
   MrO1bcBR58iCzWbROm8muNQWoa/ywdIMqicHHuKXi1M2xoXMmn/VgCfrO
   y7RmfT2l2gyr3WJc71UlfDNVpackVucpOz2DoW0Zw5zJAe+N3nnO5sM3F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="299424995"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="299424995"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 23:49:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="967467391"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="967467391"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.173.21]) ([10.249.173.21])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 23:49:34 -0800
Message-ID: <de9b844f-c70b-bce7-9723-25f61e4f696f@linux.intel.com>
Date:   Mon, 14 Nov 2022 15:49:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v10 072/108] KVM: TDX: restore user ret MSRs
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <3260994f3d9a036795c81bf06842558afabeeef7.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <3260994f3d9a036795c81bf06842558afabeeef7.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Several user ret MSRs are clobbered on TD exit.  Restore those values on
> TD exit and before returning to ring 3.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3ec465cbaeef..f35ccf2b502d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -456,6 +456,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vcpu->kvm->vm_bugged = true;
>   }
>   
> +struct tdx_uret_msr {
> +	u32 msr;
> +	unsigned int slot;
> +	u64 defval;
> +};
> +
> +static struct tdx_uret_msr tdx_uret_msrs[] = {
> +	{.msr = MSR_SYSCALL_MASK,},
> +	{.msr = MSR_STAR,},
> +	{.msr = MSR_LSTAR,},
> +	{.msr = MSR_TSC_AUX,},
> +};
> +
> +static void tdx_user_return_update_cache(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> +		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> +					     tdx_uret_msrs[i].defval);
> +}
> +
>   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -495,6 +517,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(vcpu, tdx);
>   
> +	tdx_user_return_update_cache();
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
> @@ -1558,6 +1581,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   		return -ENODEV;
>   	}
>   
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> +		/*
> +		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> +		 * before returning to user space.
> +		 *
> +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> +		 * because the registration is done at vcpu runtime by
> +		 * kvm_set_user_return_msr().
> +		 * Here is setting up cpu feature before running vcpu,
> +		 * registered is alreays

typo, already or always?



>   false.
> +		 */
> +		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
> +		if (tdx_uret_msrs[i].slot == -1) {
> +			/* If any MSR isn't supported, it is a KVM bug */
> +			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
> +				tdx_uret_msrs[i].msr);
> +			return -EIO;
> +		}
> +	}
> +
>   	max_pkgs = topology_max_packages();
>   	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
>   				   GFP_KERNEL);
