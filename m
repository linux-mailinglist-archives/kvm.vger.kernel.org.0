Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C52685C4F
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 01:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjBAAo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 19:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjBAAoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 19:44:25 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975454F87F
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:44:24 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z1so9326113plg.6
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fILGJLKFTgQqBASICVRglDo5VTpMJSJN+N2x7b/rdBk=;
        b=VtqeeEdUWzK83zLh2INNladmSIBZCqmMoDTcy0EhHYItIUfhNKPsU1oklDEaDOYMcd
         D3pvcHeIwlo/3R5VmzTUXxZnnMutOu2ZSdGJo2yQWH8u2eD7XnzqnUZ164wBFW3Aq3d6
         FmgBV0/FgPQUg8jxWPDgfkRZPi/NgTJMuvuKCZ+MK738RUHtc8LFMXlop6Aw72+sEeuP
         ev4VVywtpayNbqTXj1q32o8gECFDfxR2nU8uYyv/xBH8qxsf7iVxjEg9FCWq0xmIm3B+
         n1Beq+jzh1IUT9GNTuRHoTcIbcFtFIph71dnYmIPUrqsXkj1UnHHPYCbhQWjX9DLh8s+
         HDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fILGJLKFTgQqBASICVRglDo5VTpMJSJN+N2x7b/rdBk=;
        b=owojlqLHCDh6ZL1Pm0A4ZVIKPRUAiK6cPpNJhT8TjYJ4oZhf65WRRBw6nXL6ENSaUp
         nfvo+MHL6OozwqJ8aZVv6kIfnF6Pw9qlv5q4xBufTSeftq/mSJImvlAXrq893favv5H9
         XHHnTvxj4vvBuwnp70u4DcZI7xDZ7r0h3ELTVBuvDex8EJPbRe93qcCALWY+1rv3vWx6
         xfZgmFKb5Glp4czJgiYUNex3Y4lXGCJvAj8rdFUaaKXMvjS+4TdY8jFJKrHLAHGnvk+J
         cKCuseCPf5+guDX7a0I9zdUmfzSeahIeNPygumzwXFFBBNGw4lhUts42w5dEirtYcn3k
         NlrQ==
X-Gm-Message-State: AO0yUKUhD76Z6SEuB7DVI4hm1DdgVH1BDvEA/+z/SGfb5bRhPPyCZr8l
        q6Ad/dSr0dVk5ELh71YpNn1U8Q==
X-Google-Smtp-Source: AK7set/DWqn5PC0ETUdENyV490PneHjvVT5utDZH/R2pbIRwQjfTGT6Stq1kYwJ6EwRYjRtRlkVLbQ==
X-Received: by 2002:a17:902:daca:b0:198:af4f:de04 with SMTP id q10-20020a170902daca00b00198af4fde04mr3274plx.4.1675212263899;
        Tue, 31 Jan 2023 16:44:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e17-20020a656891000000b004768b74f208sm9378137pgt.4.2023.01.31.16.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:44:23 -0800 (PST)
Date:   Wed, 1 Feb 2023 00:44:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH v2 11/11] KVM: nSVM: implement support for nested VNMI
Message-ID: <Y9m15P8xQ2dxvIzd@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-12-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129193717.513824-12-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> This patch allows L1 to use vNMI to accelerate its injection
> of NMIs to L2 by passing through vNMI int_ctl bits from vmcb12
> to/from vmcb02.
> 
> While L2 runs, L1's vNMI is inhibited, and L1's NMIs are injected
> normally.

Same feedback on stating the change as a command instead of describing the net
effects.

> In order to support nested VNMI requires saving and restoring the VNMI
> bits during nested entry and exit.

Again, avoid saving+restoring.  And it's not just for terminology, it's not a
true save/restore, e.g. a pending vNMI for L1 needs to be recognized and trigger
a nested VM-Exit.  I.e. KVM can't simply stash the state and restore it later,
KVM needs to actively process the pending NMI.

> In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
> vmcb02 during entry and vice-versa during exit.
> And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
> vmcb02 during entry and vice-versa during exit.
> 
> Tested with the KVM-unit-test and Nested Guest scenario.
> 
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Same SoB issues.

> ---
>  arch/x86/kvm/svm/nested.c | 13 ++++++++++++-
>  arch/x86/kvm/svm/svm.c    |  5 +++++
>  arch/x86/kvm/svm/svm.h    |  6 ++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5bea672bf8b12d..81346665058e26 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -278,6 +278,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
>  		return false;
>  
> +	if (CC((control->int_ctl & V_NMI_ENABLE) &&
> +		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {

Align indentation.

	if (CC((control->int_ctl & V_NMI_ENABLE) &&
	       !vmcb12_is_intercept(control, INTERCEPT_NMI))) {
		return false;
	}

> +		return false;
> +	}
> +
>  	return true;
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0b7e1790fadde1..8fb2085188c5ac 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -271,6 +271,7 @@ struct vcpu_svm {
>  	bool pause_filter_enabled         : 1;
>  	bool pause_threshold_enabled      : 1;
>  	bool vgif_enabled                 : 1;
> +	bool vnmi_enabled                 : 1;
>  
>  	u32 ldr_reg;
>  	u32 dfr_reg;
> @@ -545,6 +546,11 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>  }
>  
> +static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);

Gah, the "nested" flags in vcpu_svm are super confusing.  I initially read this
as "if vNMI is enabled in L1 and vmcb12".  

I have a series that I originally prepped for the architectural LBRs series that
will allow turning this into

	return guest_can_use(vcpu, X86_FEATURE_VNMI) &&
	       (svm->nested.ctl.int_ctl & V_NMI_ENABLE);

I'll get that series posted.

Nothing to do on your end, just an FYI.  I'll sort out conflicts if/when they happen.
