Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B3E455FAE
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhKRPku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:40:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230376AbhKRPkt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637249869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yy1LH5o0VGJSqKmP60w+gcgBMDkEPZ5wa2DfnRKliAM=;
        b=MBPzOlzF/AN32UClrJMapvdkTkM4JTRFghLp6fgjRV35NAb27JalBi1BfPi+85aLRYtNge
        C2sZCTp4TA2su016ZbNJdrj3nUtiQQG/qs6WJ+OxBdVPWL5pWXbWYb/bWVdAlVCjeq0Xjb
        IuTxt4XxKN6eftqq7LINgB2HW+wRkb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-337--oIvI2fGNeOs3_A8TJP0FA-1; Thu, 18 Nov 2021 10:37:45 -0500
X-MC-Unique: -oIvI2fGNeOs3_A8TJP0FA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A69B687D541;
        Thu, 18 Nov 2021 15:37:43 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA86960657;
        Thu, 18 Nov 2021 15:37:39 +0000 (UTC)
Message-ID: <937c373e-80f4-38d9-b45a-a655dcb66569@redhat.com>
Date:   Thu, 18 Nov 2021 16:37:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 13/15] KVM: SVM: Add and use svm_register_cache_reset()
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-14-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211108124407.12187-14-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 13:44, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> It resets all the appropriate bits like vmx.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/svm/svm.c |  3 +--
>   arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++++++++++++
>   2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b7da66935e72..ba9cfddd2875 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3969,8 +3969,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
>   	vmcb_mark_all_clean(svm->vmcb);
> -
> -	kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
> +	svm_register_cache_reset(vcpu);
>   
>   	/*
>   	 * We need to handle MC intercepts here before the vcpu has a chance to
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0d7bbe548ac3..1cf5d5e2d0cd 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -274,6 +274,32 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>           return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
>   }
>   
> +static inline void svm_register_cache_reset(struct kvm_vcpu *vcpu)
> +{
> +/*
> + * SVM_REGS_AVAIL_SET - The set of registers that will be updated in cache on
> + *			demand.  Other registers not listed here are synced to
> + *			the cache immediately after VM-Exit.
> + *
> + * SVM_REGS_DIRTY_SET - The set of registers that might be outdated in
> + *			architecture. Other registers not listed here are synced
> + *			to the architecture immediately when modifying.
> + *
> + *			Special case: VCPU_EXREG_CR3 should be in this set due
> + *			to the fact.  But KVM_REQ_LOAD_MMU_PGD is always
> + *			requested when the cache vcpu->arch.cr3 is changed and
> + *			svm_load_mmu_pgd() always syncs the new CR3 value into
> + *			the architecture.  So the dirty information of
> + *			VCPU_EXREG_CR3 is not used which means VCPU_EXREG_CR3
> + *			isn't required to be put in this set.
> + */
> +#define SVM_REGS_AVAIL_SET	(1 << VCPU_EXREG_PDPTR)
> +#define SVM_REGS_DIRTY_SET	(0)
> +
> +	vcpu->arch.regs_avail &= ~SVM_REGS_AVAIL_SET;
> +	vcpu->arch.regs_dirty &= ~SVM_REGS_DIRTY_SET;
> +}

I think touching regs_dirty is confusing here, so I'd go with this:

         vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;

         /*
          * SVM does not use vcpu->arch.regs_dirty.  The only register that
          * might be out of date in the VMCB is CR3, but KVM_REQ_LOAD_MMU_PGD
          * is always requested when the cache vcpu->arch.cr3 is changed and
          * svm_load_mmu_pgd() always syncs the new CR3 value into the VMCB.
          */

(VMX instead needs VCPU_EXREG_CR3 mostly because it does not want to
update it unconditionally on exit).

Paolo

