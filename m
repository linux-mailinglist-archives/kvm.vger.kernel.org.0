Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325134536DF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbhKPQJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238873AbhKPQIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 11:08:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38135C061764
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 08:05:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g19so18627799pfb.8
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 08:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=deqGK3yKMLsBufstVPiHWoHpV0QbG75PNlw5AN12k/U=;
        b=W6XWgmoOR0nc3wCDhUnBqEhxtHPEjLOcuwSSU01/0n8B4OfWJqNQxd4cX3T6UJbokv
         ZD6jfaU/4/rF1aOToTIyQBPlqasw/bLjwOfwP6l8f+T6zKYX+SJjhkcq+K48n2KzjLrn
         evjj4NWZmJ0SGNoouR1m+oUR8ADMImRqHMIvbsrZ6uMXfilheVvC3PsLYdN0MntyZE9l
         mE4s7hOxVa94PSZGuhuMZDjX8NmhdgalP9B6nJB8SWnqA+NSmo4xn15BUF23cotvKCrq
         OMweaQEPtBUGfsFAV57qs7IdC5I5UKon307eCVe3n1HXG8iPQCYwi7sL/+ywLt/1YkMB
         JgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=deqGK3yKMLsBufstVPiHWoHpV0QbG75PNlw5AN12k/U=;
        b=PvenSBqSgWDKsqE8nYK6RtQ/ctES6fL8bqla7y/qkH2LqvZWMeafaL5qtR9J6JGFje
         lsgDv+UoOSLi36bfyuAznQ0w4SjLby6RP1Ipcgh6Cq3UTekWo11Ca7hYWsDz3FketTqI
         cyf69lP0x8N1uUpiBQnuUvzgKPC67ENCg2HlkpGG+K50McSwM4aI6jEGt28M4tNanqJu
         qEQIyf3Y/FLmRoAAfAMZleHQKHCYarEBhZO9+aLtixt8HGqMfpmuvU2r12TYb9VGgwHW
         N2IxljOl19Tc3jJsY73cvQ9/Eyc9eQp2V6GXnqqvIRKQe7soA0p+HS5eF3lZMdxjJ6ND
         hWlg==
X-Gm-Message-State: AOAM531nX13xApLuQtGPKpTjsH6z0fwW37BDmyC9tN7sOzmsby9Ic40G
        vJyZNBXMCK4radl0blPgIyNIZA==
X-Google-Smtp-Source: ABdhPJyCe4SDrcnQD4hUJWiTClXh0x7fVaPYRsR6Spm56yWJv6UODIw7xs8/6PBtC4BCCx3F+pC3SA==
X-Received: by 2002:a63:7e48:: with SMTP id o8mr5491970pgn.157.1637078708619;
        Tue, 16 Nov 2021 08:05:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id np1sm3037810pjb.22.2021.11.16.08.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:05:08 -0800 (PST)
Date:   Tue, 16 Nov 2021 16:05:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Message-ID: <YZPWsICdDTZ02UDu@google.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0h85m65.ffs@tglx>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Thomas Gleixner wrote:
> > One of potential drawbacks of the Option 2 might be additional 
> > checks in the host, although we can minimize the impact by having
> > CONFIG_KVM_TBD. We believe that the case
> > "XFD != 0 and XINUSE != 0" should be very infrequent.
> 
> I really don't like the idea of having an extra check in switch_to().
> 
> Can we start simple and do something like the uncompiled below and see
> how much overhead it creates?
> 
> Thanks,
> 
>         tglx
> ---

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2686f2edb47c..9425fdbb4806 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9576,6 +9576,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>  	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>  
> +	kvm_update_guest_xfd_state();

Is there a reason the XFD switch can't key off TIF_NEED_FPU_LOAD a la the other
FPU stuff?  I.e. piggyback this snippet in vcpu_enter_guest():

	if (test_thread_flag(TIF_NEED_FPU_LOAD))
		switch_fpu_return();
> +
>  	vcpu->mode = OUTSIDE_GUEST_MODE;
>  	smp_wmb();
>  
> 
> 
