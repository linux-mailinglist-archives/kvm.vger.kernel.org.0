Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A8D584869
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiG1Wty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiG1Wtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:49:53 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EB751421
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:49:51 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y197so2471391iof.12
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=zp3s0H17eNS8RLeZJwuDNDBm2rORUB76Sr+0ULT5CUY=;
        b=6PGeof5tavB8xZZTMvnmR1G9QRO/mLfOjc0reQCxtLSivzfi9q8iDpINmOG3CqIk1J
         V/4tvnXKugAAt21XfV/Z2uiIxw+8hXzLA2dsAv/uoXinTF4o8Nqwz1gfVxY8qwjGwY/g
         ufPTjRpLHsKTfLpawEKVoX2rNyPWNAmDWeHmOBct8AVx0zYE3CiPQ8jV0V4RIpUngPKE
         1fnLh+jaLYGb+QbWJx0XiPPLS/1W7idEyupyUBwnk3IYA1WWk6ObCbHxbzGlYOeQ7hMS
         srTT0S2fMC/rzOYu2eNTUrB+cZyNdLRlHtwIcSDAz3Wu+lGFtnno1DSP3IU7TtdWciEa
         si1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=zp3s0H17eNS8RLeZJwuDNDBm2rORUB76Sr+0ULT5CUY=;
        b=431i8yhsB58sTIyWwP4era7kmlzGrVrP25RblufNu2h8JqtxH0ByhKb7lTxuTpJA7p
         If2SQLG4YI7Xom+lYecJE3Ngr08VSe42kzaXf7cSx8FY88ef6C501lYRANnf2ntyUlnH
         1CxqcJhiw0M+saOoYP89WkQM34TuAAZC9F34N+D+q+j664StzyEZMOUBp49D5jkbNnYV
         J6rFtjpdErrCCMHPR66PsO6F0OVN8VDb32lgJ8A7+WZJXijZrAVDM9W5JeiZbDfaekcM
         yIdLXP+ADvzDqdVc9OFQGHitMY5BSlzrqXCGDGTMds7nBGCRtaZ7fTOQoKPUJIhtWEQC
         rJpA==
X-Gm-Message-State: AJIora+iDf9mAP/5/T05VET7vEx3zYssMN9KsMbgi1mpr5ph1pj36wNz
        Qlc17bZMAeShd0c/VXmYfHupAA==
X-Google-Smtp-Source: AGRyM1uqTbWLghcYSIroC35qIH2sScjpChjXWce93/xlSm9BiJZwYwxOvdmB3S0gh0B1moTqmpnYeQ==
X-Received: by 2002:a05:6638:270d:b0:33f:3f96:468c with SMTP id m13-20020a056638270d00b0033f3f96468cmr394388jav.272.1659048591254;
        Thu, 28 Jul 2022 15:49:51 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id w11-20020a056602034b00b0067bd23bb692sm853686iou.27.2022.07.28.15.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:49:50 -0700 (PDT)
Date:   Thu, 28 Jul 2022 17:49:49 -0500
From:   Coleman Dietsch <dietschc@csp.edu>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86/xen: Fix bug in kvm_xen_vcpu_set_attr()
Message-ID: <YuMSjQ3Y2ADA40KV@kernel-dev-1>
References: <20220728194736.383727-1-dietschc@csp.edu>
 <YuL0auT3lFhfQHeY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuL0auT3lFhfQHeY@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 08:41:14PM +0000, Sean Christopherson wrote:
> Be more specific in the shortlog.  "Fix a bug in XYZ" doesn't provide any info
> about the bug itself, and can even become frustratingly stale if XYZ is renamed.
> I believe we should end up with two patches (see below), e.g.
> 
>   KVM: x86/xen: Initialize Xen timer only once (when it's NOT running)
> 
> and
>   
>   KVM: x86/xen: Stop Xen timer before changing the IRQ vector
> 

Got it, I will work on splitting the v2 into a patch set as you suggested
(with better names of course).

> Note, I'm assuming timer_virq is a vector of some form, I haven't actually looked
> that far into the code.
> 
> On Thu, Jul 28, 2022, Coleman Dietsch wrote:
> > This crash appears to be happening when vcpu->arch.xen.timer is already set
> 
> Instead of saying "This crash", provide the actual splat (sanitized to make it
> more readable).  That way readers, reviewers, and archaeologists don't need to
> open up a hyperlink to get details on what broken.
> 
> > and kvm_xen_init_timer(vcpu) is called.
> 
> Wrap changelogs at ~75 chars.
> 
> > During testing with the syzbot reproducer code it seemed apparent that the
> > else if statement in the KVM_XEN_VCPU_ATTR_TYPE_TIMER switch case was not
> > being reached, which is where the kvm_xen_stop_timer(vcpu) call is located.
> 
> Neither the shortlog nor the changelog actually says anything about what is actually
> being changed.
> 

I will make sure to address all these issues in the v2 patch set.

> > Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
> > Reported-and-tested-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
> > Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
> > ---
> >  arch/x86/kvm/xen.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index 610beba35907..4b4b985813c5 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -707,6 +707,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
> >  		break;
> >  
> >  	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> > +		/* Stop current timer if it is enabled */
> > +		if (kvm_xen_timer_enabled(vcpu)) {
> > +			kvm_xen_stop_timer(vcpu);
> > +			vcpu->arch.xen.timer_virq = 0;
> > +		}
> > +
> >  		if (data->u.timer.port) {
> >  			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> >  				r = -EINVAL;
> 
> I'm not entirely sure this is correct.  Probably doesn't matter, but there's a
> subtle ABI change here in that invoking the ioctl with a "bad" priority will
> cancel any existing timer.
> 

I will try to get some clarification before I send in the next patch.

> And there appear to be two separate bugs: initializing the hrtimer while it's
> running, and not canceling a running timer before changing timer_virq.
> 

This does seem to be the case so I will be splitting v2 into a patch
set.

> Calling kvm_xen_init_timer() on "every" KVM_XEN_VCPU_ATTR_TYPE_TIMER is odd and
> unnecessary, it only needs to be called once during vCPU setup.  If Xen doesn't
> have such a hook, then a !ULL check can be done on vcpu->arch.xen.timer.function
> to initialize the timer on-demand.
> 

Yes I also thought that was a bit odd that kvm_xen_init_timer() is called on "every" KVM_XEN_VCPU_ATTR_TYPE_TIMER 

> With that out of the way, the code can be streamlined a bit, e.g. something like
> this?
> 
> 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> 		if (data->u.timer.port &&
> 		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> 			r = -EINVAL;
> 			break;
> 		}
> 
> 		if (!vcpu->arch.xen.timer.function)
> 			kvm_xen_init_timer(vcpu);
> 
> 		/* Stop the timer (if it's running) before changing the vector. */
> 		kvm_xen_stop_timer(vcpu);
> 		vcpu->arch.xen.timer_virq = data->u.timer.port;
> 
> 		if (data->u.timer.port && data->u.timer.expires_ns)
> 			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> 					    data->u.timer.expires_ns -
> 					    get_kvmclock_ns(vcpu->kvm));
> 		r = 0;
> 		break;
> 

I agree this code could use some cleanup, I'll see what I can do.

> > @@ -720,9 +726,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
> >  				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> >  						    data->u.timer.expires_ns -
> >  						    get_kvmclock_ns(vcpu->kvm));
> > -		} else if (kvm_xen_timer_enabled(vcpu)) {
> > -			kvm_xen_stop_timer(vcpu);
> > -			vcpu->arch.xen.timer_virq = 0;
> >  		}
> >  
> >  		r = 0;
> > -- 
> > 2.34.1
> > 

Thank you for the feedback Sean, it has been most helpful!
