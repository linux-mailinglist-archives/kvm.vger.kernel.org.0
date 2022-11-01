Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74D8615138
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiKASDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 14:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiKASDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 14:03:52 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C184C18E35
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 11:03:51 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z26so1023299pff.1
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B6yv38rBcXg8ajx2YDuTgCNAFEG5qCJwSqMKG6SLY/Q=;
        b=oirac5wGLIY4i7en0pMoj97TKnKq5f/AWRFqN4VjYjwFJLSoZ5tysow4ZthFobpB+C
         OT2R7Lw6Tj2fGOjQC+xOG98LCLhmIwEezmGHnhlQS9/wSEox5HqG3Qm0XqGl2Sh51yvd
         B3MmVErdZm05tk1aomEDBL8K7UR++WC4l1Q4JyGEu0Tryq9rEHAhcRL3zECb5eZercVE
         oKh2MTW00uc7UUaQe6BVZyRldAUz5rnjgecL7jLu2eCTtOGzlNwQj93/PGOQsz1DnKLH
         JJ5ZoYcKx6Naccvr6z1KH1wCt3w7It0+gROA6MwGCmRk51ZOX+kTQviVFpc8c03w5MmN
         T/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6yv38rBcXg8ajx2YDuTgCNAFEG5qCJwSqMKG6SLY/Q=;
        b=Klndkr6N358c+dNLjO619cUnffSP0paq3shIcx0FXBuaoCWLYTzqa+Y92AdWMkN5L7
         9/FeAJhm5Q9nrmhaYtgvSVEfbKqjeRshqLB6LZG66v8G8N2N3l830+PR9JIozm18z1/P
         beaHvZCKIHF3fgEUitII9bp3Y1TsSjk8K088B4q7uUIZ4u0jEWhVeJe9UEUP5WBo5PGC
         PmR1xwhGITmkYZPHejMF3LiuLTN86q6FhkeqG9OzABXjKLbH657kqQmazj4dSTnuKFvz
         e7TUs4JMFhtxRD85HHO1ZZpmMcAHqCuYFeTzaHa0Rl2z5eS/dvr0FUyIcEqM+vWHnueQ
         vmsA==
X-Gm-Message-State: ACrzQf048efbd60n5QdKKrLynDd/Cr+NeRz/vppDpjcPrXHReeMeYJkw
        iIIPw/vMRFv+TCS1wyKZDt5WWg==
X-Google-Smtp-Source: AMsMyM6UQ/rdIID1qVa9AOBJLP7GWRwIhvkiK6LmGe8T+mVuZ6XCaLcp8TDY9IHaNRNUNYRuiec+hQ==
X-Received: by 2002:a65:56ca:0:b0:439:169f:f027 with SMTP id w10-20020a6556ca000000b00439169ff027mr17974497pgs.580.1667325831175;
        Tue, 01 Nov 2022 11:03:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g6-20020a625206000000b005633a06ad67sm6808026pfb.64.2022.11.01.11.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 11:03:50 -0700 (PDT)
Date:   Tue, 1 Nov 2022 18:03:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jmattson@google.com
Subject: Re: [PATCH 1/7] KVM: VMX: remove regs argument of __vmx_vcpu_run
Message-ID: <Y2Ffg5ed5zoijqOB@google.com>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
 <20221028230723.3254250-2-pbonzini@redhat.com>
 <Y2AH6sevOvD/GnKV@google.com>
 <20221101173204.w7yuoerkafxonyzx@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101173204.w7yuoerkafxonyzx@treble>
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

On Tue, Nov 01, 2022, Josh Poimboeuf wrote:
> On Mon, Oct 31, 2022 at 05:37:46PM +0000, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> > > index cb50589a7102..90da275ad223 100644
> > > --- a/arch/x86/kernel/asm-offsets.c
> > > +++ b/arch/x86/kernel/asm-offsets.c
> > > @@ -111,6 +111,7 @@ static void __used common(void)
> > >  
> > >  	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
> > >  		BLANK();
> > > +		OFFSET(VMX_vcpu_arch_regs, vcpu_vmx, vcpu.arch.regs);
> > 
> > Is there an asm-offsets-like solution that doesn't require exposing vcpu_vmx
> > outside of KVM?  We (Google) want to explore loading multiple instances of KVM,
> > i.e. loading multiple versions of kvm.ko at the same time, to allow intra-host
> > migration between versions of KVM to upgrade/rollback KVM without changing the
> > kernel (RFC coming soon-ish).  IIRC, asm-offsets is the only place where I haven't
> > been able to figure out a simple way to avoid exposing KVM's internal structures
> > outside of KVM (so that the structures can change across KVM instances without
> > breaking kernel code).
> 
> Is that really a problem?  Would it even make sense for non-KVM kernel
> code to use 'vcpu_vmx' anyway?

vcpu_vmx itself isn't a problem as non-KVM kernel code _shouldn't_ be using
vcpu_vmx, but I want to go beyond "shouldn't" and make it all-but-impossible for
non-KVM code to reference internal KVM structures/state, e.g. I want to bury all
kvm_host.h headers in kvm/ code instead of exposing them in include/asm/.
