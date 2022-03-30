Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFC34EB769
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 02:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbiC3AWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 20:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbiC3AWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 20:22:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398D314B87A
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:20:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id y16so6285375pju.4
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4YqnuRfg2MHKNaL7P8O8O9EyyaSzDXcdnGupk1MjP6Q=;
        b=FwBNuG0B2TUtJ7MsB9irvutbDXGMqfxx4ZVng27Iu1ZaBc9HMbFPOPY+2a9BcFGcqr
         q/I6kj6SnLjFU5gXSHzSmcuUQPmVGZVmebcqp0EteR7JV5Bdmh0qmsQuE9pldf5/0aw8
         d12+58TApk71ah/NZEctlSTaWz8ngGNL//7HTmS7FE3dv3yr0bGYGVYIuoX7JV6icmKf
         oedwcKH23HbvMhZ0Ehz1kc/SJDrXOLe11c2hUg4Qe9kKwMiMOI6KwbRwmlUGFCJvFtRd
         2VAmckMfgDbVjYzNe8Kg+c6/frjBlkeU3Y3uYvGfojmAS1xMiyMbIRCJfWEO4ItOGYhD
         bjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4YqnuRfg2MHKNaL7P8O8O9EyyaSzDXcdnGupk1MjP6Q=;
        b=ZXkjgXqTz0msufxZY+5+ZJyyUAXsSVYNMlnxBxWuz0q/UdQh4Br0EKQ5TMS4OyDaZ0
         F8q+iq3VMP/Hwuo4l7Wr0VkwGLjCcfqLGmUny1XKOY9izs/b89c8K+u0cB/CLL9Jpx2x
         5HvogtelUldonHH6YWqoBwjrbdB1qn4z9PKbyZnKJ7514KmLl6s0MIvcin1734KKqszr
         2VTZP/oJQeQY27cStWnyBEypeK0cOxGdOroxovvBF12dMNmX2pxhH+COYQfwB7HBhlAe
         Z4Z/oqlJJp/tpPUMBODMX0UWVtB+FojSsYYXFMZ5bsbEtq7ceZ6SfLZoXEEr+1/rIqM+
         mvCg==
X-Gm-Message-State: AOAM531NgK5tY9OtkpxUgq6AWmQ1ikaeyw/xez2NSw0hCWhy2fn2k/3c
        8m5h3imujQv1IlRTGITcvj3wvw==
X-Google-Smtp-Source: ABdhPJzKGF5NfLOT5f+svn56e+f7y8K9XwDPlhKkbMLmKNTt8SD9AQDoihMvJukzmSEU5jTPkJiRTQ==
X-Received: by 2002:a17:90a:bc1:b0:1c6:cace:32de with SMTP id x1-20020a17090a0bc100b001c6cace32demr1858248pjd.62.1648599639475;
        Tue, 29 Mar 2022 17:20:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm3876619pjn.34.2022.03.29.17.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 17:20:38 -0700 (PDT)
Date:   Wed, 30 Mar 2022 00:20:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 8/8] KVM: x86: SVM: remove vgif_enabled()
Message-ID: <YkOiU2TtxE32xhCu@google.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
 <20220322172449.235575-9-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322172449.235575-9-mlevitsk@redhat.com>
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

On Tue, Mar 22, 2022, Maxim Levitsky wrote:
> KVM always uses vgif when allowed, thus there is
> no need to query current vmcb for it

It'd be helpful to explicitly call out that KVM always takes V_GIF_ENABLE_MASK
from vmcs01, otherwise this looks like it does unintentend things when KVM is
runing vmcb02.

> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 12 ++++++------
>  arch/x86/kvm/svm/svm.h | 12 ++++--------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index acf04cf4ed2a..70fc5897f5f2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -172,7 +172,7 @@ static int vls = true;
>  module_param(vls, int, 0444);
>  
>  /* enable/disable Virtual GIF */
> -static int vgif = true;
> +int vgif = true;
>  module_param(vgif, int, 0444);

...

> @@ -453,14 +454,9 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>  	return vmcb_is_intercept(&svm->vmcb->control, bit);
>  }
>  
> -static inline bool vgif_enabled(struct vcpu_svm *svm)
> -{
> -	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
