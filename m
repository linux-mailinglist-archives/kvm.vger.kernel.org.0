Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACAC54A880
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 06:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbiFNE4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 00:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiFNE4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 00:56:05 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D02D37BD3;
        Mon, 13 Jun 2022 21:56:04 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id E050220C29A6;
        Mon, 13 Jun 2022 21:55:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E050220C29A6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655182563;
        bh=li+PNz3Vd3GyStPzFitjj/G0JokV2AZ4Fg5xm9celE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUVUxD6k6/ZIF1vOVETFrUQMN+dLMESJqPUUnTazK787X47Vi7B/+JJ/g40qmCEG4
         xwOeJTn8++aEQXy3VV/um2ElhpGGa356gcKyQ/CgnXpBPruc/qjYOmxnHa8wYw8aw9
         2NrDzhL11Fkn3UWwCDSeqBQNGBkyYqfGnAUkAE7Q=
Date:   Tue, 14 Jun 2022 10:25:52 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <YqgU2KfFCqawbTkW@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 06:49:17PM +0200, Paolo Bonzini wrote:
> On 6/13/22 18:16, Anirudh Rayabharam wrote:
> > +	if (!kvm_has_tsc_control)
> > +		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;
> > +
> >   	msrs->secondary_ctls_low = 0;
> >   	msrs->secondary_ctls_high &=
> >   		SECONDARY_EXEC_DESC |
> > @@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> >   		SECONDARY_EXEC_RDRAND_EXITING |
> >   		SECONDARY_EXEC_ENABLE_INVPCID |
> >   		SECONDARY_EXEC_RDSEED_EXITING |
> > -		SECONDARY_EXEC_XSAVES |
> > -		SECONDARY_EXEC_TSC_SCALING;
> > +		SECONDARY_EXEC_XSAVES;
> >   	/*
> 
> This is wrong because it _always_ disables SECONDARY_EXEC_TSC_SCALING,
> even if kvm_has_tsc_control == true.

The MSR actually allows 1-setting of the "use TSC scaling" control. So this
line is redundant anyway.

> 
> That said, I think a better implementation of this patch is to just add
> a version of evmcs_sanitize_exec_ctrls that takes a struct
> nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
> 
> 	evmcs_sanitize_nested_vmx_vsrs(msrs);

Sanitize at the end might not work because I see some cases in
nested_vmx_setup_ctls_msrs() where we want to expose some things to L1
even though the hardware doesn't support it.

> 
> Even better (but I cannot "mentally test it" offhand) would be just
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e802f71a9e8d..b3425ce835c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1862,7 +1862,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * sanity checking and refuse to boot. Filter all unsupported
>  		 * features out.
>  		 */
> -		if (!msr_info->host_initiated &&
> +		if (static_branch_unlikely(&enable_evmcs) ||
>  		    vmx->nested.enlightened_vmcs_enabled)
>  			nested_evmcs_filter_control_msr(msr_info->index,
>  							&msr_info->data);

I will try this.

Thanks,

	Anirudh.

> 
> I cannot quite understand the host_initiated check, so I'll defer to
> Vitaly on why it is needed.  Most likely, removing it would cause some
> warnings in QEMU with e.g. "-cpu Haswell,+vmx"; but I think it's a
> userspace bug and we should remove that part of the condition.  You
> don't need to worry about that part, we'll cross that bridge if the
> above patch works for your case.
> 
> Thanks,
> 
> Paolo
