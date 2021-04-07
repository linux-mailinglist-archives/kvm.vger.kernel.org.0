Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5223577F4
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhDGWs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhDGWs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:48:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA4C061761
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 15:48:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so272130pjb.4
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 15:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DgfW8JkZp8Qfy9QcapA9CK3xFi7FRXqxeMqnc0ZjSZA=;
        b=lozHiKGrOvSj5vWVEWU6vNBRZnSyF48TAYdOso2PswCjmyZhwZBXkZGc/ckWbhY0JD
         5d6nx9oTvGmZaR1fiwuJJ+rSbshXtvTx9z8hzgg/6CAiiQ0ONTcUYe8fj1M9FbPlgW1p
         /f9c2u1pmlrCDxwe7xvH5NJ0TZDSAgDPq6f+CtR4jonCuBQNyMn2heoKbKd6xdE4ROcD
         vgqxoPtS2d6QvFq6B9ZnNKok9/O1FZFnUbBjnfgkgi8pcpHOOes8E+Ofrd8uzqDEbuqI
         SVFEvaA+8mHedpFbwDMQqj4mUKj0axAb9KNeTGgATLr13GtXaKFg4A7Qcogb3YBGFVMG
         QzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgfW8JkZp8Qfy9QcapA9CK3xFi7FRXqxeMqnc0ZjSZA=;
        b=MdNLbMxq/6/UcwDlmUpWru0158WissHG01uirAhv5MY7TILy7jSb0fdSKSj6xcE5cB
         infwp5Rhte8E4JErjTaCQ64Jwr2lQv8sl1xHAhOoHbjGg8y8YrfV23qOpinC5/x8Zs+P
         9rZkDSM7N9nBRSl7MXvPnW9bVYhdoSGedTa29KQiF4JtXS2o0uilMoC4HRbMmhhKHi+g
         VKUxnNuIct/oCdQfLTKZ3nxM1+Su7zLp0Ucp9SppLoT+FiqmGmoz9bCzLclg+p6gUqYs
         OKtOftI2p4c/tEsuFo23voZIyeUzpQuWMb/4pdtlKRTZTTtXXDH1cHYmgVvw+Ys5DVsR
         f0dg==
X-Gm-Message-State: AOAM531Frayc0MxcCkzeiwKD2MWGu1C3KqiO+xwmq88hEu75rhiH+au0
        jZxPX9xTbL59GX5HoR51I8qqsg==
X-Google-Smtp-Source: ABdhPJxTmfV8L6CJgni4FoJssUPZc3Xy1SafJcbvzYbeFJWQRji+q8p4TqkNynJ54BIJozxe8EIY8A==
X-Received: by 2002:a17:90a:5d8f:: with SMTP id t15mr5393064pji.28.1617835728485;
        Wed, 07 Apr 2021 15:48:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n16sm22358949pff.119.2021.04.07.15.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:48:47 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:48:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        KY Srinivasan <kys@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
Message-ID: <YG42zNYA9uCC25In@google.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
 <MWHPR21MB159327E855DAC5BEE4B8A38DD7759@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR21MB159327E855DAC5BEE4B8A38DD7759@MWHPR21MB1593.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021, Michael Kelley wrote:
> From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Wednesday, April 7, 2021 7:41 AM
> > 
> > Detect nested features exposed by Hyper-V if SVM is enabled.
> > 
> > Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> > ---
> >  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> > index 3546d3e21787..4d364acfe95d 100644
> > --- a/arch/x86/kernel/cpu/mshyperv.c
> > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > @@ -325,9 +325,17 @@ static void __init ms_hyperv_init_platform(void)
> >  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
> >  	}
> > 
> > -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> > +	/*
> > +	 * AMD does not need enlightened VMCS as VMCB is already a
> > +	 * datastructure in memory. We need to get the nested
> > +	 * features if SVM is enabled.
> > +	 */
> > +	if (boot_cpu_has(X86_FEATURE_SVM) ||
> > +	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> >  		ms_hyperv.nested_features =
> >  			cpuid_eax(HYPERV_CPUID_NESTED_FEATURES);
> > +		pr_info("Hyper-V nested_features: 0x%x\n",
> 
> Nit:  Most other similar lines put the colon in a different place:
> 
> 		pr_info("Hyper-V: nested features 0x%x\n",
> 
> One of these days, I'm going to fix the ones that don't follow this
> pattern. :-)

Any reason not to use pr_fmt?
