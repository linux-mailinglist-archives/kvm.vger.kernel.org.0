Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B435690B9
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiGFRgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiGFRgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:36:46 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF5E1EAD5
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:36:45 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n10so14255044plp.0
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n6GVhQmBGVKBhGa5woMm6aogTfqoCNqPgCzOl2ffqrA=;
        b=e1xeUsyT+W+flSShjjnjyN4TfbfrsLh9Fog2om/V0KJWvgtiMuK0jePKuTI8hlaAHX
         F+WQOOR1u9I03ck70NXzlfW2Ygp/WcfDkgRBchk7NZc7ZqXNjn4u3fDUoFwioxc1YUvK
         d37Fx05W0yx3P7PROVg1GXABbwtaeqIPhrIiEO+0I80c0W53bDFXFkgwYgv+qOrQELuP
         knK+IRouM8+hNF24Z5WPGNAVnI8ObiAWhbj1IEPrTV1rDci+wsq+4IR3OLINoGimlxfK
         D+4cB9HnimksBtqJ2Rg97LOR/dbhF0dYnp2I4jX7mtF0XsBublRREU029Pl4DpQdNiNj
         QCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n6GVhQmBGVKBhGa5woMm6aogTfqoCNqPgCzOl2ffqrA=;
        b=7Y3EPYNl94z2lyWlPxV1MOWtiaDy9EZ4BRjjbxVsOW36DDC49K9oa/3y2aRQFLnRM3
         4vXOqT+8scdhaSTEGlChe5BW5SGECSLECzsRfpIH5ImwLaBy1bVdvUcV5rt7to2Tnm5r
         YWsjcTKd073mdzsDrPjDnDCjiG2WfUVzvIL7B+Pv0xJK/ZPPSDP3spiHDonCpNsZfALq
         qXghIVOIzXaJ7muXQdZWEnACVpakrPqKP/VrF7v3TO5sFyscRAzrmE1H8UdRzLoMGlXq
         mqoRtZSpXJH2GQLn035aLhdFJgO7cS+d6YxqF+l8lMjGiLcZaQpPJbHACFxHl2Ug/wpr
         K9aw==
X-Gm-Message-State: AJIora+lAj4UgrXz+o65XauJn2gSILxA3EiO+PblGTm1dt+qU/B/5S5b
        0iij9crYn1en11KxlbHmu+HqxA==
X-Google-Smtp-Source: AGRyM1vjGjONL95pIBy9rQ/rmpXePKjqmhuUe9hjzvPPN9BnuEaq7l6jpCjoLYhkAbm/LaFvVtKcxA==
X-Received: by 2002:a17:903:2443:b0:16a:29ac:27c2 with SMTP id l3-20020a170903244300b0016a29ac27c2mr46952180pls.46.1657129004700;
        Wed, 06 Jul 2022 10:36:44 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id g15-20020a63564f000000b004129741dd9dsm1519871pgm.51.2022.07.06.10.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 10:36:43 -0700 (PDT)
Date:   Wed, 6 Jul 2022 17:36:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 13/21] KVM: x86: Formalize blocking of nested pending
 exceptions
Message-ID: <YsXIJ50adC+TVejy@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <20220614204730.3359543-14-seanjc@google.com>
 <cd9be62e3c2018a4f779f65fed46954e9431e0b0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd9be62e3c2018a4f779f65fed46954e9431e0b0.camel@redhat.com>
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

On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > Capture nested_run_pending as block_pending_exceptions so that the logic
> > of why exceptions are blocked only needs to be documented once instead of
> > at every place that employs the logic.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 20 ++++++++++----------
> >  arch/x86/kvm/vmx/nested.c | 23 ++++++++++++-----------
> >  2 files changed, 22 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 471d40e97890..460161e67ce5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1347,10 +1347,16 @@ static inline bool nested_exit_on_init(struct vcpu_svm *svm)
> >  
> >  static int svm_check_nested_events(struct kvm_vcpu *vcpu)
> >  {
> > -	struct vcpu_svm *svm = to_svm(vcpu);
> > -	bool block_nested_events =
> > -		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
> >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +	/*
> > +	 * Only a pending nested run blocks a pending exception.  If there is a
> > +	 * previously injected event, the pending exception occurred while said
> > +	 * event was being delivered and thus needs to be handled.
> > +	 */
> 
> Tiny nitpick about the comment:
> 
> One can say that if there is an injected event, this means that we
> are in the middle of handling it, thus we are not on instruction boundary,
> and thus we don't process events (e.g interrupts).
> 
> So maybe write something like that?

Hmm, that's another way to look at things.  My goal with the comment was to try
and call out that any pending exception is a continuation of the injected event,
i.e. that the injected event won't be lost.  Talking about instruction boundaries
only explains why non-exception events are blocked, it doesn't explain why exceptions
are _not_ blocked.

I'll add a second comment above block_nested_events to capture the instruction
boundary angle.

> > +	bool block_nested_exceptions = svm->nested.nested_run_pending;
> > +	bool block_nested_events = block_nested_exceptions ||
> > +				   kvm_event_needs_reinjection(vcpu);
> 
> Tiny nitpick: I don't like that much the name 'nested' as
> it can also mean a nested exception (e.g exception that
> happened while jumping to an exception  handler).
> 
> Here we mean just exception/events for the guest, so I would suggest
> to just drop the word 'nested'.

I don't disagree, but I'd prefer to keep the current naming because the helper
itself is *_check_nested_events().  I'm not opposed to renaming things in the
future, but I don't want to do that in this series.
