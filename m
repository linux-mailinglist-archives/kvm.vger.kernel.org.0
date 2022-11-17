Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADD562E5B7
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiKQUSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiKQUSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:18:24 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C37F7EBE9
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:18:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u6-20020a17090a5e4600b0021881a8d264so728335pji.4
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2FIVtys96HfN/UY5kdXXtz7aAXS2PJRXIKW8I5uGymE=;
        b=ASfnPir1SSkkS8SS/MQiNH3H7Jp1UGkSYZgsrak/kljlbYTWMrhiSNL0WK415GZ6bA
         2B8b7nI2rm+DGQ2dV7YrQC/VAe22x3J1r8AZ0N7JeMP0hiRE/8iBcCA/kOwD0zX/Xxy4
         hlJkjHIB7SfWI39+ly8nKmnCxkF6R7oeeq1YEG0on0LSt7yFHmkfESjaqMUvzD1Nkvgq
         HALT2lqHI33+tRXU3MYD/+7GXnQkbl/q/nZ63xeupWB8BkzplWewPZVRX87I8JYHHJh1
         bwEKadNFhtmKSDKhhxNL6onixg8o6L6yW2o6cJpVnImFvM2McTE7sWK3qu55RQmsRLPF
         4RlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FIVtys96HfN/UY5kdXXtz7aAXS2PJRXIKW8I5uGymE=;
        b=BsUPVNZjn9KmOeHejY5XW/3yyjRy1mqDLkyHo1CEG1MqDJV/JrWmZMFJkf+EhzTtJn
         4zL1uWl8er+1flW7aXKbsbyZEFn4Ca+2TGdm1qwu/K2Zyfa2dZ0QfptNJtlq2c6l8mJN
         3LGyopnKcrfc5wrIEFPw9sN22+LdvRGEHJeosag5v9pfhN0Q/OFfeIxtEil6gpawvwrW
         UhfVdcGO0nO8ycQZgcu1KpJFKCX1BCP30FKJTSetaLcHjASDG9C4BFa4JJAnv1Gievaq
         tQSCba+N3sWC//HpiljyyAbM/yVqHsYSReSglR0hYVbm1PI11IiIjMsGGNrZUtZsLA7k
         l2eA==
X-Gm-Message-State: ANoB5pl+v4K94It2mlyXtNhM8OPdgXsS9kr14Bv/8XQZtAqg+KHOduxg
        JmWusZNtjMECG/AsYtuFDQ61qw==
X-Google-Smtp-Source: AA0mqf7camjabz60b57BbD7tWrU/g0bn/+9y/Q8vQe+V3tp5UCrHI1ZczUOjqkvRPAUKELY8rGBfIA==
X-Received: by 2002:a17:903:3246:b0:188:f1b4:cf35 with SMTP id ji6-20020a170903324600b00188f1b4cf35mr3771419plb.54.1668716302863;
        Thu, 17 Nov 2022 12:18:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902714900b00186e2123506sm1725423plm.300.2022.11.17.12.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:18:22 -0800 (PST)
Date:   Thu, 17 Nov 2022 20:18:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 12/13] KVM: nSVM: emulate VMEXIT_INVALID case for nested
 VNMI
Message-ID: <Y3aXCklpCQ3JRWPY@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-13-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-13-mlevitsk@redhat.com>
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

On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> If NMI virtualization enabled and NMI_INTERCEPT is unset then next vm
> entry will exit with #INVALID exit reason.
> 
> In order to emulate above (VMEXIT(#INVALID)) scenario for nested
> environment, extending check for V_NMI_ENABLE, NMI_INTERCEPT bit in func
> __nested_vmcb_check_controls.

This belongs in the previous patch, no?  I don't see how this isn't just a
natural part of supporting nested vNMI.

> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c9fcdd691bb5a1..3ef7e1971a4709 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -275,6 +275,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
>  		return false;
>  
> +	if (CC((control->int_ctl & V_NMI_ENABLE) &&
> +		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {

Alignment is off by one:

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
> -- 
> 2.34.3
> 
