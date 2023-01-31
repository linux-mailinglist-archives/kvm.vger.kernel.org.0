Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7638683853
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 22:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjAaVHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 16:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjAaVHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 16:07:52 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FD77ED6
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 13:07:51 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 143so10989058pgg.6
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 13:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Up7/zvDdjUz1Pcl1Rjcqj9BQdupVezuRTStHZScQfAA=;
        b=rmIT1jIZRk8hQ3tu2ptW5zSnxr4aPhAb2XBN08+YjY4NUbUv3Z1DD9vzsx6igrkfZg
         O32HcLg9Ef5Jh+Z1NNAFpQNQoM4LLvzKKNU4IjP6yXro8bGPMDPzJ7FZJUbRsyVeuOGY
         Y4xY91h9yfK21L8nAepgJQdsmTJPYlmSxScUBiMdS9Rq6V4xHqrjqY2bFjW2Vl8JJrl8
         6bQx8ncWgz9qJ6I/8/Q1Ld8+QYA2cM/8SUU+RvlTb7EfuYGlg88Vx/ApgiPzcxA+AwxS
         6GwKoonBNGseVBx9qyJnQuODj2hr5AKOI3SXcGdm4i9tvzGRacKKKVdz+C1WWrtCGsHY
         dwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Up7/zvDdjUz1Pcl1Rjcqj9BQdupVezuRTStHZScQfAA=;
        b=TS+83yn5K3Vo6gz8h++rhbOV4IPoGiDAaILpjbDbUTE8N0T2461ACX1I82gAc9WokX
         Qsyt/Ap2cAamxt7Iw5OpJTw71FFb8SAxARLMJiuMesCoeGsiG8e+n1XEY6Ayif0cm7Fe
         fk+P2jMbXvf1BfTO8Rgy6iAILE28dijDJogmR8BQi31NEkTGEn9Pc3UVOntdZPnl1lM6
         UC5E5Wb7PuCxqI91yFoi8Y1Ys7l6j8cXVhyFwxE3+Vuxq4daGAlpTLS5wLCTyjYzYrbn
         EjlL86eST9z+C+39SyRZEEutWJRz/dJGF9mAMQEdX0ODKXZR6CO+20DW9CtqMpt5BSyq
         cSsA==
X-Gm-Message-State: AO0yUKV/Q/UV9PuVJSHHfN4vRSgJQybbhr9Rzp8jeMFuRNl4IEQfKB23
        fpD0Da6m82OMAJBBKCE1PfwbvQ==
X-Google-Smtp-Source: AK7set/UeC8+PrNBMRcAicmB2v06KLiBgEVfW/rBqKSq3VcmoSyU+lmwsGCajCVhHYyfaE1vyJWfFA==
X-Received: by 2002:a05:6a00:784:b0:576:9252:d06 with SMTP id g4-20020a056a00078400b0057692520d06mr127327pfu.0.1675199270958;
        Tue, 31 Jan 2023 13:07:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 144-20020a621996000000b0058bcb42dd1asm9920762pfz.111.2023.01.31.13.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 13:07:50 -0800 (PST)
Date:   Tue, 31 Jan 2023 21:07:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 06/11] KVM: SVM: add wrappers to enable/disable IRET
 interception
Message-ID: <Y9mDInNl65hjVblm@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-7-mlevitsk@redhat.com>
 <41abb37b-c74a-f2cf-c0ce-74d5d6487e92@amd.com>
 <181f437164296e19683f086c11bf64c11a3f380e.camel@redhat.com>
 <70078abb-f8b7-cd33-5bdd-bc6ee44c0bd3@amd.com>
 <06d12050eece922e786b7bee1254698466c6d3d4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06d12050eece922e786b7bee1254698466c6d3d4.camel@redhat.com>
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

On Thu, Dec 08, 2022, Maxim Levitsky wrote:
> On Thu, 2022-12-08 at 17:39 +0530, Santosh Shukla wrote:
> > 
> > On 12/6/2022 5:44 PM, Maxim Levitsky wrote:
> > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > index 512b2aa21137e2..cfed6ab29c839a 100644
> > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > @@ -2468,16 +2468,29 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
> > > > >  			       has_error_code, error_code);
> > > > >  }
> > > > >  
> > > > > +static void svm_disable_iret_interception(struct vcpu_svm *svm)
> > > > > +{
> > > > > +	if (!sev_es_guest(svm->vcpu.kvm))
> > > > > +		svm_clr_intercept(svm, INTERCEPT_IRET);
> > > > > +}
> > > > > +
> > > > > +static void svm_enable_iret_interception(struct vcpu_svm *svm)
> > > > > +{
> > > > > +	if (!sev_es_guest(svm->vcpu.kvm))
> > > > > +		svm_set_intercept(svm, INTERCEPT_IRET);
> > > > > +}
> > > > > +
> > > > 
> > > > nits:
> > > > s/_iret_interception / _iret_intercept
> > > > does that make sense?
> > > 
> > > Makes sense.

I would rather go with svm_{clr,set}_iret_intercept().  I don't particularly like
the SVM naming scheme, but I really dislike inconsistent naming.  If we want to
clean up naming, I would love unify VMX and SVM nomenclature for things like this.

> > >  I can also move this to svm.h near the svm_set_intercept(), I think
> > > it better a better place for this function there if no objections.
> > > 
> > I think current approach is fine since function used in svm.c only. but I have
> > no strong opinion on moving to svm.h either ways.
> 
> I also think so, just noticed something in case there are any objections.

My vote is to keep it in svm.c unless we anticipate usage outside of svm.h.  Keeping
the implementation close to the usage makes it easer to understand what's going on,
especially for something like this where there's a bit of "hidden" logic for SEV-ES.
