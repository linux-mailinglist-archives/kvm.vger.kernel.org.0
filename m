Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726F2377DF1
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhEJITs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230224AbhEJITq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWHVecN3IcQ6TaVNoD4ymbrSPyoMCexrSWsjK9p+k/c=;
        b=gYFngHe8eD872m8Mx7WwNMHLXSabjIAQ4Fse4fGd4d7LzR3Vm0bzWH9HfkbHhHaBc4V7Sz
        9x9DCl6jYjt8HG8bPyRa9xV7NIW2SwPDAmX3nnO/KdOxeKE/Klj8pc+UaT5HsYv8r25gAK
        8Vm0Bz5XKbQJXC65iarzx5uIc9XcxAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-bBW1ouWrNyKkzkyR6PIfuw-1; Mon, 10 May 2021 04:18:38 -0400
X-MC-Unique: bBW1ouWrNyKkzkyR6PIfuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12EF0801B13;
        Mon, 10 May 2021 08:18:36 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2021517A9B;
        Mon, 10 May 2021 08:18:32 +0000 (UTC)
Message-ID: <17c3853354e59ad99afffc0481eb0796a5975003.camel@redhat.com>
Subject: Re: [PATCH 05/15] KVM: VMX: Disable preemption when probing user
 return MSRs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:18:31 +0300
In-Reply-To: <20210504171734.1434054-6-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Disable preemption when probing a user return MSR via RDSMR/WRMSR.  If
> the MSR holds a different value per logical CPU, the WRMSR could corrupt
> the host's value if KVM is preempted between the RDMSR and WRMSR, and
> then rescheduled on a different CPU.
> 
> Opportunistically land the helper in common x86, SVM will use the helper
> in a future commit.
> 
> Fixes: 4be534102624 ("KVM: VMX: Initialize vmx->guest_msrs[] right after allocation")
> Cc: stable@vger.kernel.org
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/vmx.c          |  5 +----
>  arch/x86/kvm/x86.c              | 16 ++++++++++++++++
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3e5fc80a35c8..a02c9bf3f7f1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1778,6 +1778,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  		    unsigned long icr, int op_64_bit);
>  
>  void kvm_define_user_return_msr(unsigned index, u32 msr);
> +int kvm_probe_user_return_msr(u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
>  
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 99591e523b47..990ee339a05f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6914,12 +6914,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
>  		u32 index = vmx_uret_msrs_list[i];
> -		u32 data_low, data_high;
>  		int j = vmx->nr_uret_msrs;
>  
> -		if (rdmsr_safe(index, &data_low, &data_high) < 0)
> -			continue;
> -		if (wrmsr_safe(index, data_low, data_high) < 0)
> +		if (kvm_probe_user_return_msr(index))
>  			continue;
>  
>  		vmx->guest_uret_msrs[j].slot = i;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf52ba5f2bb..e304447be42d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -339,6 +339,22 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
>  	}
>  }
>  
> +int kvm_probe_user_return_msr(u32 msr)
> +{
> +	u64 val;
> +	int ret;
> +
> +	preempt_disable();
> +	ret = rdmsrl_safe(msr, &val);
> +	if (ret)
> +		goto out;
> +	ret = wrmsrl_safe(msr, val);
> +out:
> +	preempt_enable();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
> +
>  void kvm_define_user_return_msr(unsigned slot, u32 msr)
>  {
>  	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

One note though: every time we probe for a MSR existance via
checking for a #GP on write, we risk getting nonsense results 
if the L1 has ignore_msrs=1.

Thus if possible to use the CPUID instead, 
that would be preferred.

Best regards,
	Maxim Levitsky


