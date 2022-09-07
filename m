Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A314A5B094D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiIGP4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIGP4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:56:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3CA83042
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 08:56:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v1so1676302plo.9
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 08:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=gu51tTeubGA4NmbCnkGTbmAG64OE9zjLhtK0FhQe950=;
        b=Pr86m6G98JqU1Urcvo1EUkEDGK9pfiks9+WPDL8jR4YkN8/2gldaS0vRK1P+XSnPxe
         MlJCY/ltfWaGduF+UUkYT1iLlFjv9NpjpJI8kbEk7vBBQj6qQBAypwpr/KEKvAe1zcE+
         Qlpod8JfhDYhxWEpQhrv/Vv/0kQkn1lJJvgNeBD9k+jwdx8Jzpa3d3RBOdWVJ9mTitme
         pmtUpeXH29obpufNv5uP7nHMZAxksBoaarLwO2xLzGiiVxRdg0wWKvIDlxuc6R5DQzKy
         t611VsGsQ0HcT2kDuxf12Tc3PymfZwevBZttehAKFwNA4s59+DwFD7dEk3oLG07yujdM
         20Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=gu51tTeubGA4NmbCnkGTbmAG64OE9zjLhtK0FhQe950=;
        b=UQWLRuicG5ezfpECjEbjHvruaq5/Bd6na8USV4tOFUsdzTIOhc3Oy96W3DeTjJ2Vs+
         ypGs0nGRWaCmrUY0IkzADAA8vsrG6G63td0FL23pmBbRq8SdMKBrP6Wcg7to+Q0JBbHE
         Mcu9Cil0vfxAERW9bfr6xFg5XcYL8fMmu9P9Nc+OdNwRp6az4av12NDL0IQ2adlpoY8G
         vU4Ffo7VjHlxpHdw8k+S1hogneI3coP0chFkGlNI2VMulU5k9fT+FDMie4vzsrkrOmeV
         1qc0QFbJXw0zGgF2g3lr+dSWAkCQ2KVygI+GadALCYGLrMKtonmkztt71u06xpF1Wg+o
         jdZQ==
X-Gm-Message-State: ACgBeo11sN0uIfoRl8I6B+f83pohKsW+1QXkJr92zgz0MPa6ZUvVEsSp
        N+3x/Ubw1VjpKk4JnXvZeDKxCg==
X-Google-Smtp-Source: AA6agR6xxiOhtnIeeQp07O1eOAr/mOul3MWxVgcuf8Zja3cq9J5XPPCqN+pz/3w8sPPqSivkOuap0Q==
X-Received: by 2002:a17:90b:1e47:b0:200:b9b4:ba1e with SMTP id pi7-20020a17090b1e4700b00200b9b4ba1emr4321382pjb.172.1662566171350;
        Wed, 07 Sep 2022 08:56:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s2-20020aa78bc2000000b0053e0d6f353esm4858065pfd.27.2022.09.07.08.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:56:10 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:56:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
Message-ID: <Yxi/F7BjiYTWnABh@google.com>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-2-mizhang@google.com>
 <YwzkvfT0AiwaojTx@google.com>
 <20220907025042.hvfww56wskwhsjwk@yy-desk-7060>
 <CAL715WJK1WwXFfbUiMjngV8Z-0jyu_9JeZaK4qvvdJfYvtQEYg@mail.gmail.com>
 <20220907053523.qb7qsbqfgcg2d2vx@yy-desk-7060>
 <Yxi9QRziGl2YhNuB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxi9QRziGl2YhNuB@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022, Sean Christopherson wrote:
> On Wed, Sep 07, 2022, Yuan Yao wrote:
> > On Tue, Sep 06, 2022 at 09:26:33PM -0700, Mingwei Zhang wrote:
> > > > > @@ -10700,6 +10706,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> > > > >               if (kvm_cpu_has_pending_timer(vcpu))
> > > > >                       kvm_inject_pending_timer_irqs(vcpu);
> > > > >
> > > > > +             if (vcpu->arch.nested_get_pages_pending) {
> > > > > +                     r = kvm_get_nested_state_pages(vcpu);
> > > > > +                     if (r <= 0)
> > > > > +                             break;
> > > > > +             }
> > > > > +
> > > >
> > > > Will this leads to skip the get_nested_state_pages for L2 first time
> > > > vmentry in every L2 running iteration ? Because with above changes
> > > > KVM_REQ_GET_NESTED_STATE_PAGES is not set in
> > > > nested_vmx_enter_non_root_mode() and
> > > > vcpu->arch.nested_get_pages_pending is not checked in
> > > > vcpu_enter_guest().
> > > >
> > > Good catch. I think the diff won't work when vcpu is runnable.
> 
> It works, but it's inefficient if the request comes from KVM_SET_NESTED_STATE.
> The pending KVM_REQ_UNBLOCK that comes with the flag will prevent actually running
> the guest.  Specifically, this chunk of code will detect the pending request and
> bail out of vcpu_enter_guest().
> 
> 	if (kvm_vcpu_exit_request(vcpu)) {
> 		vcpu->mode = OUTSIDE_GUEST_MODE;
> 		smp_wmb();
> 		local_irq_enable();
> 		preempt_enable();
> 		kvm_vcpu_srcu_read_lock(vcpu);
> 		r = 1;
> 		goto cancel_injection;
> 	}
> 
> But the inefficiency is a non-issue since "true" emulation of VM-Enter will flow
> through this path (the VMRESUME/VMLAUNCH/VMRUN exit handler runs at the end of
> vcpu_enter_guest().

Actually, nested VM-Enter doesn't use this path at all.  The above holds true for
emulated RSM, but that's largely a moot point since RSM isn't exactly a hot path.
