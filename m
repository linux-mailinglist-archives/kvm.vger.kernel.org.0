Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F173430
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbfGXQs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 12:48:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:51124 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387729AbfGXQs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 12:48:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 09:48:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="scan'208";a="369355335"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga006.fm.intel.com with ESMTP; 24 Jul 2019 09:48:26 -0700
Date:   Wed, 24 Jul 2019 09:48:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     luferry@163.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: init x2apic_enabled() once
Message-ID: <20190724164826.GC25376@linux.intel.com>
References: <20190723130608.26528-1-luferry@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723130608.26528-1-luferry@163.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 23, 2019 at 09:06:08PM +0800, luferry@163.com wrote:
> From: luferry <luferry@163.com>
> 
> x2apic_eanbled() costs about 200 cycles
> when guest trigger halt pretty high, pi ops in hotpath
> 
> Signed-off-by: luferry <luferry@163.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98eac371c0a..e17dbf011e47 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -186,6 +186,8 @@ static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>  static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>  static DEFINE_MUTEX(vmx_l1d_flush_mutex);
>  
> +static int __read_mostly host_x2apic_enabled;
> +
>  /* Storage for pre module init parameter parsing */
>  static enum vmx_l1d_flush_state __read_mostly vmentry_l1d_flush_param = VMENTER_L1D_FLUSH_AUTO;
>  
> @@ -1204,7 +1206,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  		dest = cpu_physical_id(cpu);
>  
> -		if (x2apic_enabled())
> +		if (host_x2apic_enabled)

Instead of caching x2apic_enabled(), this can be:

	if (x2apic_supported() && x2apic_mode)

which will get compiled out if CONFIG_X86_X2APIC=n.

It's quite suprising (to me) that 2apic_enabled() reads the MSR in the
first place, but at a glance the other users of x2apic_enabled() do need
to query the MSR and/or may be called before x2apic_mode is set.

>  			new.ndst = dest;
>  		else
>  			new.ndst = (dest << 8) & 0xFF00;
> @@ -7151,7 +7153,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  
>  		dest = cpu_physical_id(vcpu->cpu);
>  
> -		if (x2apic_enabled())
> +		if (host_x2apic_enabled)
>  			new.ndst = dest;
>  		else
>  			new.ndst = (dest << 8) & 0xFF00;
> @@ -7221,7 +7223,7 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
>  		 */
>  		dest = cpu_physical_id(vcpu->pre_pcpu);
>  
> -		if (x2apic_enabled())
> +		if (host_x2apic_enabled)
>  			new.ndst = dest;
>  		else
>  			new.ndst = (dest << 8) & 0xFF00;
> @@ -7804,6 +7806,8 @@ static int __init vmx_init(void)
>  	}
>  #endif
>  
> +	host_x2apic_enabled = x2apic_enabled();
> +
>  	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
> -- 
> 2.14.1.40.g8e62ba1
> 
> 
