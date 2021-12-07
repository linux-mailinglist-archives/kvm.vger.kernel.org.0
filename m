Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C982F46C4BD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbhLGUln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 15:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbhLGUlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 15:41:42 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58111C061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 12:38:12 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z6so473029pfe.7
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 12:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tahw8lr7Eo912eVNmXdwIVFgh3iBz1otD8cy1FuG8Cg=;
        b=OmzCiDKsu5J4DzIaB5MMSPO6KacFic5zES9uE2LRjQwuYUVqw/QwUNiuiEWVdgaZLg
         eNduadsDzhJuvz/mSkv/2H0PHwbXrImNTQ+1OW1C7Ag0xmiZcqcrdKnvu+K+3Gnj6rlo
         3u9cggyGj/AiXzdcM/oQEP7kpts/QVdb6Yqzb/7O7UKtlPvwezjnPutSx3pvuDjH9TWq
         IJmnXaAErs/tn0sAd7aQvn6l6UUY4WndUSV/nno0FbeC33/uMwIwCz7EBkv6jAXVBNGh
         +mYsrGXxK+iyOiI15r3jnOCOx2txoVzXxApt9EkHKXosyChJpGS+CWkMKS/eMN7ifuiX
         M46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tahw8lr7Eo912eVNmXdwIVFgh3iBz1otD8cy1FuG8Cg=;
        b=Ze/yAs/DBEr3UCmeunkf1hXsjnNL5Ozimu3Siw4FBbk7TzWKRK4SlUQj0wJNRNkElm
         ab8F/BKDg13MTvSBZ9yAw8/i7SCTjih6WUU6sQTOFzfyS73qSEf+IdKH1ZoGoo0lFIDE
         BM3JvTeF0v1XeRmg/uUx1FyJF9cbdP6FTqAAlbPo+rKffNwZBPaAY7U7B+sKKgt8PxW5
         Rf1L/RSF0O1lxDI5N4mq7dnYI9f9m0P94Z9Hv1gc54qJYciZLY9RfToSmqyUT8iJA0e9
         bkg0HKG/bVCeLlCJhRkbaVYAxGxFUlf676ni4Wg/bx/jvqGcNd97Bg6l2nbd574420ro
         rygQ==
X-Gm-Message-State: AOAM5329qcOxqqgf0OyIpaVVuA0NiJ2MufjHFPU3K12Sn2TD3jZJdkPf
        Jd0ydhpjKQu4y5tq3VCiyMqsmg==
X-Google-Smtp-Source: ABdhPJzlswD2/fTrqx7DkQ75CY5WTclgyGqyPn8nSQijFnbfMbm3xn3hDTx9KEgZoTes5fg4RVGQ4Q==
X-Received: by 2002:a05:6a00:148c:b0:49f:e048:25dc with SMTP id v12-20020a056a00148c00b0049fe04825dcmr1429664pfu.12.1638909491636;
        Tue, 07 Dec 2021 12:38:11 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t2sm663266pfd.36.2021.12.07.12.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:38:11 -0800 (PST)
Date:   Tue, 7 Dec 2021 20:38:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/15] KVM: VMX: Add document to state that write to uret
 msr should always be intercepted
Message-ID: <Ya/GL0zyobfM1rUF@google.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-6-jiangshanlai@gmail.com>
 <226fc242-ae46-3214-4e01-dbfdf5f7c0fb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226fc242-ae46-3214-4e01-dbfdf5f7c0fb@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> On 11/18/21 12:08, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > 
> > And adds a corresponding sanity check code.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >   arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
> >   1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index e8a41fdc3c4d..cd081219b668 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3703,13 +3703,21 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> >   	if (!cpu_has_vmx_msr_bitmap())
> >   		return;
> > +	/*
> > +	 * Write to uret msr should always be intercepted due to the mechanism
> > +	 * must know the current value.  Santity check to avoid any inadvertent
> > +	 * mistake in coding.
> > +	 */
> > +	if (WARN_ON_ONCE(vmx_find_uret_msr(vmx, msr) && (type & MSR_TYPE_W)))
> > +		return;
> > +
> 
> I'm not sure about this one, it's relatively expensive to call
> vmx_find_uret_msr.
> 
> User-return MSRs and disable-intercept MSRs are almost the opposite: uret is
> for MSRs that the host (not even the processor) never uses,
> disable-intercept is for MSRs that the guest reads/writes often.  As such it
> seems almost impossible that they overlap.

And they aren't fundamentally mutually exclusive, e.g. KVM could pass-through an
MSR and then do RDMSR in vmx_prepare_switch_to_host() to refresh the uret data
with the current (guest) value.  It'd be silly, but it would work.
