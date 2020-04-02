Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B981219C7CB
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388991AbgDBRUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 13:20:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38714 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388669AbgDBRUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 13:20:18 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK3VJ-000060-0D; Thu, 02 Apr 2020 19:19:45 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 361B9100D52; Thu,  2 Apr 2020 19:19:44 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in guest
In-Reply-To: <20200402155554.27705-4-sean.j.christopherson@intel.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-4-sean.j.christopherson@intel.com>
Date:   Thu, 02 Apr 2020 19:19:44 +0200
Message-ID: <87sghln6tr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> @@ -4623,6 +4623,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)

I used a different function name intentionally so the check for 'guest
want's split lock #AC' can go there as well once it's sorted.

> +{
> +	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
> +	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
> +}
> +
>  static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4688,9 +4694,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  		return handle_rmode_exception(vcpu, ex_no, error_code);
>  
>  	switch (ex_no) {
> -	case AC_VECTOR:
> -		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> -		return 1;
>  	case DB_VECTOR:
>  		dr6 = vmcs_readl(EXIT_QUALIFICATION);
>  		if (!(vcpu->guest_debug &
> @@ -4719,6 +4722,27 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
>  		kvm_run->debug.arch.exception = ex_no;
>  		break;
> +	case AC_VECTOR:
> +		/*
> +		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
> +		 * legacy alignment check enabled.  Pre-check host split lock
> +		 * turned on to avoid the VMREADs needed to check legacy #AC,
> +		 * i.e. reflect the #AC if the only possible source is legacy
> +		 * alignment checks.
> +		 */
> +		if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ||

I think the right thing to do here is to make this really independent of
that feature, i.e. inject the exception if

 (CPL==3 && CR0.AM && EFLAGS.AC) || (FUTURE && (GUEST_TEST_CTRL & SLD))

iow. when its really clear that the guest asked for it. If there is an
actual #AC with SLD disabled and !(CPL==3 && CR0.AM && EFLAGS.AC) then
something is badly wrong and the thing should just die. That's why I
separated handle_guest_split_lock() and tell about that case.

Thanks,

        tglx


