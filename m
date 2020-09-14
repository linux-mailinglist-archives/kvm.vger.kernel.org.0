Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F99269854
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgINVvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:51:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:31453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgINVvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:51:47 -0400
IronPort-SDR: G0qi4DcXulCQCE6zZu89m7dmCPC9SrP9qaowDvOdtfZ6SuvatCAgzUHgf1e3t9NrToUSlJhp1t
 tR764kI1FuCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="156558708"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="156558708"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:51:46 -0700
IronPort-SDR: LcBOudzkE4g59yt4ncCQ1nyyWKogchU/1XtnSx1ua06AycBa7pdmDhhdmo6il05NMUQg1ZUxEI
 PhWALHWpYGrg==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="451045487"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:51:46 -0700
Date:   Mon, 14 Sep 2020 14:51:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 28/35] KVM: X86: Update
 kvm_skip_emulated_instruction() for an SEV-ES guest
Message-ID: <20200914215144.GE7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <ff66ee115d05d698813f54e10497698da21d1b73.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff66ee115d05d698813f54e10497698da21d1b73.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:42PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> The register state for an SEV-ES guest is encrypted so the value of the
> RIP cannot be updated. For an automatic exit, the RIP will be advanced
> as necessary. For a non-automatic exit, it is up to the #VC handler in
> the guest to advance the RIP.
> 
> Add support to skip any RIP updates in kvm_skip_emulated_instruction()
> for an SEV-ES guest.

Is there a reason this can't be handled in svm?  E.g. can KVM be reworked
to effectively split the emulation logic so that it's a bug for KVM to end
up trying to modify RIP?

Also, patch 06 modifies SVM's skip_emulated_instruction() to skip the RIP
update, but keeps the "svm_set_interrupt_shadow(vcpu, 0)" logic.  Seems like
either that change or this one is wrong.

> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 23564d02d158..1dbdca607511 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6874,13 +6874,17 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
>  
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
> +	unsigned long rflags;
>  	int r;
>  
>  	r = kvm_x86_ops.skip_emulated_instruction(vcpu);
>  	if (unlikely(!r))
>  		return 0;
>  
> +	if (vcpu->arch.vmsa_encrypted)
> +		return 1;
> +
> +	rflags = kvm_x86_ops.get_rflags(vcpu);
>  	/*
>  	 * rflags is the old, "raw" value of the flags.  The new value has
>  	 * not been saved yet.
> -- 
> 2.28.0
> 
