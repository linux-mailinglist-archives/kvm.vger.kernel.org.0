Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD7C27622C
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIWUcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:32:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:29989 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWUcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:32:43 -0400
IronPort-SDR: 9e2y1rgsCX8jCW7Na5+RcQr51AIIejnc8gZNR+ea6Jt1HfbGlDMxsKHlrB6y1OJy7x0/QRxmnW
 W+iwdGhmuAnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148671925"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148671925"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:32:42 -0700
IronPort-SDR: fxOz/CIz2/QbwXtGn/prqnou9Y8Rak3zk58kOA1JAX1tCFC73+wy3UHL0WhFU83zgOqaLviSgr
 YpwoC4tuUNNw==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486593724"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:32:42 -0700
Date:   Wed, 23 Sep 2020 13:32:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
Message-ID: <20200923203241.GB15101@linux.intel.com>
References: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 03:27:39PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> The INVD instruction intercept performs emulation. Emulation can't be done
> on an SEV guest because the guest memory is encrypted.
> 
> Provide a dedicated intercept routine for the INVD intercept. Within this
> intercept routine just skip the instruction for an SEV guest, since it is
> emulated as a NOP anyway.
> 
> Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c91acabf18d0..332ec4425d89 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2183,6 +2183,17 @@ static int iret_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int invd_interception(struct vcpu_svm *svm)
> +{
> +	/*
> +	 * Can't do emulation on an SEV guest and INVD is emulated
> +	 * as a NOP, so just skip the instruction.
> +	 */
> +	return (sev_guest(svm->vcpu.kvm))
> +		? kvm_skip_emulated_instruction(&svm->vcpu)
> +		: kvm_emulate_instruction(&svm->vcpu, 0);

Is there any reason not to do kvm_skip_emulated_instruction() for both SEV
and legacy?  VMX has the same odd kvm_emulate_instruction() call, but AFAICT
that's completely unecessary, i.e. VMX can also convert to a straight skip.

> +}
> +
>  static int invlpg_interception(struct vcpu_svm *svm)
>  {
>  	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
> @@ -2774,7 +2785,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>  	[SVM_EXIT_RDPMC]			= rdpmc_interception,
>  	[SVM_EXIT_CPUID]			= cpuid_interception,
>  	[SVM_EXIT_IRET]                         = iret_interception,
> -	[SVM_EXIT_INVD]                         = emulate_on_interception,
> +	[SVM_EXIT_INVD]                         = invd_interception,
>  	[SVM_EXIT_PAUSE]			= pause_interception,
>  	[SVM_EXIT_HLT]				= halt_interception,
>  	[SVM_EXIT_INVLPG]			= invlpg_interception,
> -- 
> 2.28.0
> 
