Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1D6DA76A
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 04:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbjDGCGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 22:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjDGCGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 22:06:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD2AA5F8;
        Thu,  6 Apr 2023 19:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680833075; x=1712369075;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2Od254oOAWniJ+pr2U34s6T+QW7hHIwDJe++sSvcJfo=;
  b=Q3y3va4929ulAafMzC358ekFgqIrxM4ckUlaJIFq8jNlG35XGqI2beeH
   n7+nGHyoCEw75WptnuTCCsJV3WqKQjRRex9gtKpQbAKT+HFbRYrWZMoIV
   jNBe+2hUkJT7W0YEs3YM+X9G1RbfBFHz4D7ipAHUihK9t8+iRmVLuZwf2
   LFYxY0+XMdDBIpAM7th5Q9yeALK/s4pdWF7lSwELda8yp602IkqugRVjY
   IJzOzojFTQ8LJ9rhsj/w2G2cPA/URpKT+zVIlxHT8Os07lQNBxYynAeNX
   qzmWATOJAo/oBOJgW6dti3yS9C0ruhqgx+oAo2tmXvzNaXXfjPRi5GDKP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="341646884"
X-IronPort-AV: E=Sophos;i="5.98,324,1673942400"; 
   d="scan'208";a="341646884"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 19:01:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="798555760"
X-IronPort-AV: E=Sophos;i="5.98,324,1673942400"; 
   d="scan'208";a="798555760"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.212.181]) ([10.254.212.181])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 19:01:31 -0700
Message-ID: <a358d966-86f9-93f5-ded9-36a0ad0b538a@intel.com>
Date:   Fri, 7 Apr 2023 10:01:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH 1/3] KVM: x86: Disallow enable KVM_CAP_X86_DISABLE_EXITS
 capability after vCPUs have been created
Content-Language: en-US
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/2023 8:35 PM, Hou Wenlong wrote:
> Disable PAUSE/MWAIT/HLT exits after vCPUs have been created is useless,
> because PAUSE/MWAIT/HLT intercepts configuration is not changed after
> vCPU created.  

PAUSE intercepts can be updated via 
SET_CPUID->vmx_vcpu_after_set_cpuid() after vCPU is created.

Aside it, this patch looks good to me.

> And two vCPUs may have inconsistent configuration if
> disable PAUSE/MWAIT/HLT exits between those two vCPUs creation. Since
> it's a per-VM capability, all vCPUs should keep same configuration, so
> disallow enable KVM_CAP_X86_DISABLE_EXITS capability after vCPUs have
> been created.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>   Documentation/virt/kvm/api.rst | 3 ++-
>   arch/x86/kvm/x86.c             | 5 +++++
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a69e91088d76..95a683a27cf2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7179,7 +7179,8 @@ branch to guests' 0x200 interrupt vector.
>   
>   :Architectures: x86
>   :Parameters: args[0] defines which exits are disabled
> -:Returns: 0 on success, -EINVAL when args[0] contains invalid exits
> +:Returns: 0 on success, -EINVAL when args[0] contains invalid exits or
> +	  any vCPUs have been created.
>   
>   Valid bits in args[0] are::
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c0ff40e5345..7e97595465fc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6275,6 +6275,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
>   			break;
>   
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus)
> +			goto disable_exits_unlock;
>   		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
>   			kvm->arch.pause_in_guest = true;
>   
> @@ -6296,6 +6299,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   
>   		r = 0;
> +disable_exits_unlock:
> +		mutex_unlock(&kvm->lock);
>   		break;
>   	case KVM_CAP_MSR_PLATFORM_INFO:
>   		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
> 
> base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393

