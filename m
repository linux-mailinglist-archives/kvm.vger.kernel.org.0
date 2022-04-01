Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8004EF9E4
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 20:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351174AbiDASeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 14:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351233AbiDASem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 14:34:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2501F0825
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 11:32:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u22so3382004pfg.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JMTq1e6yQr0fDQw0wF4RdMFu/2SACVOxsMLgeQ3O4dA=;
        b=Bg48/Fgqqf23ooPytrrWz7rbn5a5Xd1Nr6ZCE6Xlw/nKL8OrazcDLCwQnm6NfY/bWd
         3V7TsZVQ203GBzdokBRg8TMXH8XB/85YRzXnInjXMFd1tz4I97WrABeJSHEud7PMxe9U
         Tdtlez19V9cW9ukdenXiY55NAjY2tj+I2FCgc7lMcdzyo37sAGq/7k3apEiHbG9OuERv
         NTFXHJnXTW8IbnO3P+6yiTu8tGiWtL1QOylpqGC0t9CKR5F529eCyQViBVfSIQSZC/Ti
         3JVIOho1oep7kjSCEAuj8eTHNjJl9KsthxEZkMjqJKYu73YT6k/YZjfIp5zr5UO7zhCe
         Dxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JMTq1e6yQr0fDQw0wF4RdMFu/2SACVOxsMLgeQ3O4dA=;
        b=v4uVuyqFXg6a6yDzXQgALnvdN8gCFen5Z/WpOpJnVl6m/EAtpoDhqcmEIs6JuCn+8h
         jB22he52Q5uC0xHFyXgT7jmpiZZ3tKq+Z5JCGPEDU4dfncBoTA1X2VUQxFam8LYhI1c2
         7pIR0drHO38Lwklrxnb/XPJDOykPiO9tFkWTFnrnStmzUNGtmRkgblG16KR3/Moea0+d
         WaZMCfotHVk2ppzhHm07zJOn5nYpJruK0qZezliyBF9EEiTaYt32LzXADjpZdKTstYp4
         qYimyRL6AUiHBDV90wtmM2pRx5HHTYpC+8chToEiO2q1daZdMKIXNwIPrhUZoV4R7+BI
         xYxQ==
X-Gm-Message-State: AOAM532RYCzJfZ9WhOVQM/2k4N4kLvN3Toh+iRw/QIF3qAW40YBWUobz
        NqJ999loZmUTntDBUrxjIerQTg==
X-Google-Smtp-Source: ABdhPJz5roIil4k5gxLecmji/DcZsANkj/Xv1MK35XR0Ismk7xV4vUr8HeqUqvCX6z8+nDpxvY/yzQ==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr12395250pfm.35.1648837966022;
        Fri, 01 Apr 2022 11:32:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k187-20020a636fc4000000b003983a01b896sm2966888pgc.90.2022.04.01.11.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 11:32:45 -0700 (PDT)
Date:   Fri, 1 Apr 2022 18:32:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
Message-ID: <YkdFSuezZ1XNTTfx@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <19c757487eeeff5344ff3684fe9c090235b07d05.1646944472.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19c757487eeeff5344ff3684fe9c090235b07d05.1646944472.git.maciej.szmigiero@oracle.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> The next_rip field of a VMCB is *not* an output-only field for a VMRUN.
> This field value (instead of the saved guest RIP) in used by the CPU for
> the return address pushed on stack when injecting a software interrupt or
> INT3 or INTO exception.
> 
> Make sure this field gets synced from vmcb12 to vmcb02 when entering L2 or
> loading a nested state.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 4 ++++
>  arch/x86/kvm/svm/svm.h    | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d736ec6514ca..9656f0d6815c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -366,6 +366,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->nested_ctl          = from->nested_ctl;
>  	to->event_inj           = from->event_inj;
>  	to->event_inj_err       = from->event_inj_err;
> +	to->next_rip            = from->next_rip;
>  	to->nested_cr3          = from->nested_cr3;
>  	to->virt_ext            = from->virt_ext;
>  	to->pause_filter_count  = from->pause_filter_count;
> @@ -638,6 +639,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>  	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
>  	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
>  	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
> +	/* The return address pushed on stack by the CPU for some injected events */
> +	svm->vmcb->control.next_rip            = svm->nested.ctl.next_rip;

This needs to be gated by nrips being enabled _and_ exposed to L1, i.e.

	if (svm->nrips_enabled)
		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;

though I don't see any reason to add the condition to the copy to/from cache flows.

>  	if (!nested_vmcb_needs_vls_intercept(svm))
>  		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> @@ -1348,6 +1351,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>  	dst->nested_ctl           = from->nested_ctl;
>  	dst->event_inj            = from->event_inj;
>  	dst->event_inj_err        = from->event_inj_err;
> +	dst->next_rip             = from->next_rip;
>  	dst->nested_cr3           = from->nested_cr3;
>  	dst->virt_ext              = from->virt_ext;
>  	dst->pause_filter_count   = from->pause_filter_count;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 93502d2a52ce..f757400fc933 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -138,6 +138,7 @@ struct vmcb_ctrl_area_cached {
>  	u64 nested_ctl;
>  	u32 event_inj;
>  	u32 event_inj_err;
> +	u64 next_rip;
>  	u64 nested_cr3;
>  	u64 virt_ext;
>  	u32 clean;

I don't know why this struct has

	u8 reserved_sw[32];

but presumably it's for padding, i.e. probably should be reduced to 24 bytes.
