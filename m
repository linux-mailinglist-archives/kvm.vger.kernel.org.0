Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714221BACEC
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgD0Si0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:38:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:35198 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgD0SiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:38:25 -0400
IronPort-SDR: c1QlqbLdfMjcVpu6moX/m5nNLivmzCAScwsBETdAnjKq0vl1kHzqwSpGdJQGxjvUH064Vq50cL
 +se8+i1O4Xng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:38:25 -0700
IronPort-SDR: FtdBTeDrQ0JVzTaJWw0lfxE2WnB9BH6sqcv18cgaH1FSFpsx/WB4GZGhjatTM6IvYFD+adCRjZ
 hkaOSNmQHd8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="367248684"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 27 Apr 2020 11:38:25 -0700
Date:   Mon, 27 Apr 2020 11:38:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 4/5] KVM: X86: TSCDEADLINE MSR emulation fastpath
Message-ID: <20200427183825.GQ14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-5-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587709364-19090-5-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:22:43PM +0800, Wanpeng Li wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4561104..99061ba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1616,27 +1616,45 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>  	return 1;
>  }
>  
> +static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	if (!kvm_x86_ops.set_hv_timer ||
> +		kvm_mwait_in_guest(vcpu->kvm) ||
> +		kvm_can_post_timer_interrupt(vcpu))

Bad indentation.

> +		return 1;
> +
> +	kvm_set_lapic_tscdeadline_msr(vcpu, data);
> +	return 0;
> +}
> +
>  enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	u32 msr = kvm_rcx_read(vcpu);
>  	u64 data;
> -	int ret = 0;
> +	int ret = EXIT_FASTPATH_NONE;
>  
>  	switch (msr) {
>  	case APIC_BASE_MSR + (APIC_ICR >> 4):
>  		data = kvm_read_edx_eax(vcpu);
> -		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
> +		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data))
> +			ret = EXIT_FASTPATH_SKIP_EMUL_INS;
> +		break;
> +	case MSR_IA32_TSCDEADLINE:
> +		data = kvm_read_edx_eax(vcpu);
> +		if (!handle_fastpath_set_tscdeadline(vcpu, data))
> +			ret = EXIT_FASTPATH_CONT_RUN;
>  		break;
>  	default:
> -		return EXIT_FASTPATH_NONE;
> +		ret = EXIT_FASTPATH_NONE;
>  	}
>  
> -	if (!ret) {
> +	if (ret != EXIT_FASTPATH_NONE) {
>  		trace_kvm_msr_write(msr, data);
> -		return EXIT_FASTPATH_SKIP_EMUL_INS;
> +		if (ret == EXIT_FASTPATH_CONT_RUN)
> +			kvm_skip_emulated_instruction(vcpu);
>  	}
>  
> -	return EXIT_FASTPATH_NONE;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
>  
> -- 
> 2.7.4
> 
