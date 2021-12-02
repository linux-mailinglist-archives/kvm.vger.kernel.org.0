Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA8465B91
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 02:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344382AbhLBBW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 20:22:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:9435 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343896AbhLBBW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 20:22:57 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="216612509"
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="216612509"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 17:19:36 -0800
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="512956057"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.236]) ([10.255.31.236])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 17:19:32 -0800
Message-ID: <3b3b099c-67c6-ce31-879a-1aa4087714ca@intel.com>
Date:   Thu, 2 Dec 2021 09:19:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [PATCH 03/11] KVM: x86: Clean up kvm_vcpu_ioctl_x86_setup_mce()
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-4-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20211112153733.2767561-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Isaku is going to re-organize TDX KVM series based on your and tglx's 
comments. I'm not sure if it's good/correct to make this series 
separate. Maybe introduction of vm_type is better to sit at the very 
beginning of Isaku's next series. In that case, I think you can pick 
this cleanup patch separately?

Thanks,
-Xiaoyao

On 11/12/2021 11:37 PM, Xiaoyao Li wrote:
> No need to use goto.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/x86.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 23617582712d..b02088343d80 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4505,15 +4505,13 @@ static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
>   static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>   					u64 mcg_cap)
>   {
> -	int r;
>   	unsigned bank_num = mcg_cap & 0xff, bank;
>   
> -	r = -EINVAL;
>   	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
> -		goto out;
> +		return -EINVAL;
>   	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
> -		goto out;
> -	r = 0;
> +		return -EINVAL;
> +
>   	vcpu->arch.mcg_cap = mcg_cap;
>   	/* Init IA32_MCG_CTL to all 1s */
>   	if (mcg_cap & MCG_CTL_P)
> @@ -4523,8 +4521,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>   		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
>   
>   	static_call(kvm_x86_setup_mce)(vcpu);
> -out:
> -	return r;
> +
> +	return 0;
>   }
>   
>   static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> 

