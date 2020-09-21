Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F752272B02
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgIUQIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 12:08:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:40028 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIUQIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 12:08:14 -0400
IronPort-SDR: RRItxq4VBejbUEyL0MDkp5sSFcvExM/WLkAlY4XnW/s3cDPPsNSCQIMyyKFASzhP2RHZhAdFx6
 5TSO6tcef5kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="160479295"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="160479295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:08:14 -0700
IronPort-SDR: 051PsSzC0eVf6k01q0l2RoBVBkMCGYIYlRA1kzvgHSuXW/D33IkWd+4DfuYqdksIOLT/kfEzY5
 S7G7G1sAVBpA==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="334538715"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:08:13 -0700
Date:   Mon, 21 Sep 2020 09:08:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 2/4] KVM: x86: report negative values from wrmsr to
 userspace
Message-ID: <20200921160812.GA23989@linux.intel.com>
References: <20200921131923.120833-1-mlevitsk@redhat.com>
 <20200921131923.120833-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921131923.120833-3-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 21, 2020 at 04:19:21PM +0300, Maxim Levitsky wrote:
> This will allow us to make some MSR writes fatal to the guest
> (e.g when out of memory condition occurs)
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 7 +++++--
>  arch/x86/kvm/x86.c     | 5 +++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 1d450d7710d63..d855304f5a509 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3702,13 +3702,16 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
>  static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>  {
>  	u64 msr_data;
> +	int ret;
>  
>  	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
>  		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
> -	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
> +
> +	ret = ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data);
> +	if (ret > 0)
>  		return emulate_gp(ctxt, 0);
>  
> -	return X86EMUL_CONTINUE;
> +	return ret < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
>  }
>  
>  static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 063d70e736f7f..b6c67ab7c4f34 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1612,15 +1612,16 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  {
>  	u32 ecx = kvm_rcx_read(vcpu);
>  	u64 data = kvm_read_edx_eax(vcpu);
> +	int ret = kvm_set_msr(vcpu, ecx, data);
>  
> -	if (kvm_set_msr(vcpu, ecx, data)) {
> +	if (ret > 0) {
>  		trace_kvm_msr_write_ex(ecx, data);
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
>  	}
>  
>  	trace_kvm_msr_write(ecx, data);

Tracing the access as non-faulting feels wrong.  The WRMSR has not completed,
e.g. if userspace cleanly handles -ENOMEM and restarts the guest, KVM would
trace the WRMSR twice.

What about:

	int ret = kvm_set_msr(vcpu, ecx, data);

	if (ret < 0)
		return ret;

	if (ret) {
		trace_kvm_msr_write_ex(ecx, data);
		kvm_inject_gp(vcpu, 0);
		return 1;
	}

	trace_kvm_msr_write(ecx, data);
	return kvm_skip_emulated_instruction(vcpu);

> -	return kvm_skip_emulated_instruction(vcpu);
> +	return ret < 0 ? ret : kvm_skip_emulated_instruction(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>  
> -- 
> 2.26.2
> 
