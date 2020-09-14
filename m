Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD68C269878
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgINWAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:00:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:58509 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINWAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 18:00:55 -0400
IronPort-SDR: 4pd/+N26yteZUk+NtgfB9AdjUfp13Qcjr2staSZqFGG3SBSrfTcEefIqoOgr+Hn/5t8iIaJKs5
 aZkUxffv7VBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220722842"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220722842"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:00:54 -0700
IronPort-SDR: OAgPPJjpbuWZNBiA0wgpAdDIOIlAb5wp4CY5BsSZ5p8M48RTIc+ApgUIh8dSD8fBSEjlFEApl1
 5yXtzLAqfcpA==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482511319"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:00:54 -0700
Date:   Mon, 14 Sep 2020 15:00:52 -0700
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
Subject: Re: [RFC PATCH 20/35] KVM: SVM: Add SEV/SEV-ES support for
 intercepting INVD
Message-ID: <20200914220052.GH7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <cc70b4ac7119dda48a76b0d3ab6ba99ace3c4b5b.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc70b4ac7119dda48a76b0d3ab6ba99ace3c4b5b.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:34PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> The INVD instruction intercept performs emulation. Emulation can't be done
> on an SEV or SEV-ES guest because the guest memory is encrypted.
> 
> Provide a specific intercept routine for the INVD intercept. Within this
> intercept routine, skip the instruction for an SEV or SEV-ES guest since
> it is emulated as a NOP anyway.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 37c98e85aa62..ac64a5b128b2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2275,6 +2275,17 @@ static int iret_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int invd_interception(struct vcpu_svm *svm)
> +{
> +	/*
> +	 * Can't do emulation on any type of SEV guest and INVD is emulated
> +	 * as a NOP, so just skip it.
> +	 */
> +	return (sev_guest(svm->vcpu.kvm))

Should this be a standalone/backported fix for SEV?

> +		? kvm_skip_emulated_instruction(&svm->vcpu)
> +		: kvm_emulate_instruction(&svm->vcpu, 0);
> +}
> +
>  static int invlpg_interception(struct vcpu_svm *svm)
>  {
>  	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
> @@ -2912,7 +2923,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
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
