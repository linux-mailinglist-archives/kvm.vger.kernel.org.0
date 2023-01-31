Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D938A682C2A
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 13:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAaMEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 07:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjAaME1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 07:04:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4EF3BD8B;
        Tue, 31 Jan 2023 04:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675166656; x=1706702656;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PmKcry/A2WaAN30/kvaRsMEhAVcNLmMP9/fiv6D395s=;
  b=AqpnHFtlOuBH8I8FTbbnd3pqMy4K2y84/O+9P6gaiIoT1RWxwQdQTkcH
   pm8afVi+mBhXeIK5Uyq+Z3zF1XZ5x045Miye3342wUiaXbozDmhp/TsOB
   tx+zDFYjsyc723Td174UF6F7PkOHsdOZ0hdfyIDhg6F1nVmX/KngfEPd3
   /WONKTO23oPnWvxLENrR1EtJfsHQh5KlLQmejCmjhzA8fJ8f+cKOW5z2j
   0lspVwPjbG3Z7BMBOi/oTKo+pBbyW/HwZ5noRgWxNe0vRySkqlKlFtxo0
   nE/BMSJOZUqtlkE3mlOyCYF/3+0bKw33r8XbeqSmU3PuFYTqYf5TmFx6I
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="308166277"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="308166277"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 04:04:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="727919096"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="727919096"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.112])
  by fmsmga008.fm.intel.com with ESMTP; 31 Jan 2023 04:04:13 -0800
Date:   Tue, 31 Jan 2023 20:11:37 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        zhi.wang.linux@gmail.com, chao.gao@intel.com,
        shaoqin.huang@intel.com, vkuznets@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Message-ID: <Y9kFeTG/uwrDpfn5@liuzhao-OptiPlex-7080>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-4-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121020738.2973-4-kechenl@nvidia.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 21, 2023 at 02:07:35AM +0000, Kechen Lu wrote:
> Date: Sat, 21 Jan 2023 02:07:35 +0000
> From: Kechen Lu <kechenl@nvidia.com>
> Subject: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT
>  interception when not allowed
> X-Mailer: git-send-email 2.34.1
> 
> From: Sean Christopherson <seanjc@google.com>
> 
> Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT
> exits and KVM previously reported (via KVM_CHECK_EXTENSION) that MWAIT is
> not allowed in guest, e.g. because it's not supported or the CPU doesn't
> have an aways-running

nit: always-running?

> APIC timer.
> 
> Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> ---
>  arch/x86/kvm/x86.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a77b55142c6..60caa3fd40e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4326,6 +4326,16 @@ static inline bool kvm_can_mwait_in_guest(void)
>  		boot_cpu_has(X86_FEATURE_ARAT);
>  }
>  
> +static u64 kvm_get_allowed_disable_exits(void)
> +{
> +	u64 r = KVM_X86_DISABLE_VALID_EXITS;
> +
> +	if (!kvm_can_mwait_in_guest())
> +		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;
> +
> +	return r;
> +}
> +
>  static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>  					    struct kvm_cpuid2 __user *cpuid_arg)
>  {
> @@ -4448,10 +4458,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = KVM_CLOCK_VALID_FLAGS;
>  		break;
>  	case KVM_CAP_X86_DISABLE_EXITS:
> -		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
> -		      KVM_X86_DISABLE_EXITS_CSTATE;
> -		if(kvm_can_mwait_in_guest())
> -			r |= KVM_X86_DISABLE_EXITS_MWAIT;
> +		r |= kvm_get_allowed_disable_exits();
>  		break;
>  	case KVM_CAP_X86_SMM:
>  		if (!IS_ENABLED(CONFIG_KVM_SMM))
> @@ -6224,15 +6231,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		break;
>  	case KVM_CAP_X86_DISABLE_EXITS:
>  		r = -EINVAL;
> -		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> +		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
>  			break;
>  
>  		mutex_lock(&kvm->lock);
>  		if (kvm->created_vcpus)
>  			goto disable_exits_unlock;
>  
> -		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
> -			kvm_can_mwait_in_guest())
> +		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
>  			kvm->arch.mwait_in_guest = true;
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
>  			kvm->arch.hlt_in_guest = true;
> -- 
> 2.34.1
> 
