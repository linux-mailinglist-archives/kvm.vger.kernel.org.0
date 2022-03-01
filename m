Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ECC4C91A0
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiCARgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiCARgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:36:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89241240A9
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:35:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso2521595pjj.2
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aMQ0xR8HN3heOFGGSeg18lBz5d4yLHrOSyd6U9Lh6Fw=;
        b=EHNSr8LzCFPFyUs6zxIioHnObblBiitqqgG4l557hIcctQVI2h9fMp1Yoky2NxKY3a
         uQfTaBArfB36EUPdZCNgeAmeOpzxHe+j0NJiskFpXP0mb9vHov5L6osgosCi2pztw6yl
         F5j3AxrMWUrXnN1WwZv7cYjYYNyc7+nvn3rPfLsSpVRjwRRg7//jw4XBmm7sEwQ8rbdR
         WN2uXPUMaLhO5LXIQoz87OpkF5Ku9Ihf+O88cOlRucpSCq/nVd18hLDaPSjWxt4TMnKp
         0zCiqxFUwOh2P8EOyLSyJoVJg396MrEaC5QPYtGPBkN1PB9qMlfDpOImadUlN+566Rfb
         PP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aMQ0xR8HN3heOFGGSeg18lBz5d4yLHrOSyd6U9Lh6Fw=;
        b=dBt41FAit+VX9Q88IEBNvonZXZ+0ULNT0kBNRSlgSrILmvlPZecL4dPYvjibNfTSKo
         bacmR/P9LSdocXzODtOmPldaO3YgE9B0D6E4KVPTyq0PZ+EuoUs8dNHjm3Ba48J4wc/8
         QphnaLJEtRw3aZnTTzJ7R5nClpIVCiSfHAHc844jsR5mPTJvQr4HseMQQ771Ys+m8rhX
         kauc99Y+Oy7JL4i0yLNYLCDOqhB3wYEM/FXwsQ4GqtL9Ws80gbxvP6WT53wHUdQB7lvw
         3Kilmm5OUr1VEVNbuh6W09ErsoFSdpJTh6GXVkI5cvnQSnK/q+RwtW91fvQVIKZ15X2D
         P72w==
X-Gm-Message-State: AOAM533p+qXh+oKtjjCuVrbD6gEVMnNczwERihdaDLXrdMsGan8L0/ve
        Jak3kaEE44Nz0+YjhVkzb2aKKg==
X-Google-Smtp-Source: ABdhPJyw5rSW0IGaljbs2RqJRKDU/PX1fhz7E8U37pcAmDu+DbFvHblNCe+7AlNYqinpSjZj7rzwwg==
X-Received: by 2002:a17:902:bcc2:b0:14f:23c6:c8c5 with SMTP id o2-20020a170902bcc200b0014f23c6c8c5mr26066573pls.131.1646156117894;
        Tue, 01 Mar 2022 09:35:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d10-20020a63360a000000b0037947abe4bbsm6276pga.34.2022.03.01.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:35:17 -0800 (PST)
Date:   Tue, 1 Mar 2022 17:35:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 3/4] KVM: x86: SVM: use vmcb01 in avic_init_vmcb
Message-ID: <Yh5ZUTkdX5Fuu+kA@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-4-mlevitsk@redhat.com>
 <Yh5H8qRhbefuD9YF@google.com>
 <603d78c516d10119c833ff54367b63b7a66f32b3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <603d78c516d10119c833ff54367b63b7a66f32b3.camel@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> On Tue, 2022-03-01 at 16:21 +0000, Sean Christopherson wrote:
> > Just "KVM: SVM:" for the shortlog, please.
> > 
> > On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > > Out of precation use vmcb01 when enabling host AVIC.
> > > No functional change intended.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/svm/avic.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index e23159f3a62ba..9656e192c646b 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -167,7 +167,7 @@ int avic_vm_init(struct kvm *kvm)
> > >  
> > >  void avic_init_vmcb(struct vcpu_svm *svm)
> > >  {
> > > -	struct vmcb *vmcb = svm->vmcb;
> > > +	struct vmcb *vmcb = svm->vmcb01.ptr;
> > 
> > I don't like this change.  It's not bad code, but it'll be confusing because it
> > implies that it's legal for svm->vmcb to be something other than svm->vmcb01.ptr
> > when this is called.
> 
> Honestly I don't see how you had reached this conclusion.

There's exactly one caller, init_vmcb(), and that caller doesn't assert that the
current VMCB is vmcb01, nor does it unconditionally use vmcb01.  Adding code here
without an assert implies that init_vmcb() may be called with vmcb02 active,
otherwise why diverge from its one caller?

> I just think that code that always works on vmcb01
> should use it, even if it happens that vmcb == vmcb01.

I'm not disagreeing, I'm saying that the rule you want to enforce also applies
to init_vmcb(), so rather than introduce inconsistent code in all the leafs, fix
the problem at the root.  I've no objection to adding a WARN in the AVIC code (though
at that point I'd vote to just pass in @vmcb), I'm objecting to "silently" diverging.
