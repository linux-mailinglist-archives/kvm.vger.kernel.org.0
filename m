Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701D14ECFF8
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 01:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351806AbiC3XW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 19:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343757AbiC3XW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 19:22:26 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7822A27F
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 16:20:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id w21so18630980pgm.7
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 16:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nrxYfNyK7S9x3Z4TVz6BHoXQgDDsXzELpg8P7G1ivg8=;
        b=kRrEQEOfK4vi4t86gOlwSDhe0QxixvlP3Y+iGpGQ+YI02dzbgJjUnSBPKJmZoJKUit
         0pvaqdznhG3rOnDKxa4dCb9nvBeym00O+b6Bf9gGvITnHIPrGDtsyydg+2/ouQtfLPFY
         KF/Qvp5wr0kSin82mbEatQ5upUewJoA1VSEsPJClJBZ1u8HU0HtS8QYx5iWtjnjegPRb
         GRLDPQw1jw8cy+4/24EodHLv4lU0iayGdt94948UMQeHb9de2W+p4AGYkXFqkvCfRJOY
         KEsphq+fuLy/sBb6HCM4uQg6tO4z/E0oUSZvvGbcrPBdrdqkGfhYFu6+sjmgCSwY8UXJ
         KKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nrxYfNyK7S9x3Z4TVz6BHoXQgDDsXzELpg8P7G1ivg8=;
        b=MMiLFNOg0u8yAI9UvjMrgqyVVdH4OyTiNq3h8K9FsubGWJDE/9kElHRY44lVUB7W6l
         sadp4J2ZdrGTGFaC7+Br4IGFF9it56/muls7wsrA7/zf2st8W70vzLRpJWmCVyVJRBWq
         N5QcuxJd58qZnI4e1LcgUcmu8V3BlAG9gIis7m75di/R5sGhuF0SbepCWKIZzbBV8438
         Pq8xbTWc8EYwC34KbQdLH4SQRt7/CrxDB4gFQYJqdfD7ufERVfxQyVKlmqhRUe8AQPrv
         yz/wO1SD+0hyLA5uSEZkQUkxovpGUh/ce8okY/pMddNhHMVuTvXJbe+HyihWt5uvu91C
         5Lnw==
X-Gm-Message-State: AOAM533md48jKZ58Q2cTv1HRaJtg5nVfOW+N6Ygr7guqyHtnuPTVCuk8
        02w5Z1ezJFIQ1lD84gNKFHSNQg==
X-Google-Smtp-Source: ABdhPJwAfwTqt60SdaK0tl9eBDOrfHucuy+UPjttuNW2XE/EijzVSSD3+SeaKx1tonZQV1WGxMEshA==
X-Received: by 2002:a05:6a00:194c:b0:4fb:32b9:dfb6 with SMTP id s12-20020a056a00194c00b004fb32b9dfb6mr1983349pfk.17.1648682440631;
        Wed, 30 Mar 2022 16:20:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a2b8a00b001c6594e5ddcsm7584150pjd.15.2022.03.30.16.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 16:20:39 -0700 (PDT)
Date:   Wed, 30 Mar 2022 23:20:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
Message-ID: <YkTlxCV9wmA3fTlN@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
 <YkTSul0CbYi/ae0t@google.com>
 <8f9ae64a-dc64-6f46-8cd4-ffd2648a9372@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f9ae64a-dc64-6f46-8cd4-ffd2648a9372@maciej.szmigiero.name>
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

On Thu, Mar 31, 2022, Maciej S. Szmigiero wrote:
> On 30.03.2022 23:59, Sean Christopherson wrote:
> > On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
> > > @@ -3627,6 +3632,14 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
> > >   	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
> > >   		return;
> > > +	/* L1 -> L2 event re-injection needs a different handling */
> > > +	if (is_guest_mode(vcpu) &&
> > > +	    exit_during_event_injection(svm, svm->nested.ctl.event_inj,
> > > +					svm->nested.ctl.event_inj_err)) {
> > > +		nested_svm_maybe_reinject(vcpu);
> > 
> > Why is this manually re-injecting?  More specifically, why does the below (out of
> > sight in the diff) code that re-queues the exception/interrupt not work?  The
> > re-queued event should be picked up by nested_save_pending_event_to_vmcb12() and
> > propagatred to vmcb12.
> 
> A L1 -> L2 injected event should either be re-injected until successfully
> injected into L2 or propagated to VMCB12 if there is a nested VMEXIT
> during its delivery.
> 
> svm_complete_interrupts() does not do such re-injection in some cases
> (soft interrupts, soft exceptions, #VC) - it is trying to resort to
> emulation instead, which is incorrect in this case.
> 
> I think it's better to split out this L1 -> L2 nested case to a
> separate function in nested.c rather than to fill
> svm_complete_interrupts() in already very large svm.c with "if" blocks
> here and there.

Ah, I see it now.  WTF.

Ugh, commit 66fd3f7f901f ("KVM: Do not re-execute INTn instruction.") fixed VMX,
but left SVM broken.

Re-executing the INTn is wrong, the instruction has already completed decode and
execution.  E.g. if there's there's a code breakpoint on the INTn, rewinding will
cause a spurious #DB.

KVM's INT3 shenanigans are bonkers, but I guess there's no better option given
that the APM says "Software interrupts cannot be properly injected if the processor
does not support the NextRIP field.".  What a mess.

Anyways, for the common nrips=true case, I strongly prefer that we properly fix
the non-nested case and re-inject software interrupts, which should in turn
naturally fix this nested case.  And for nrips=false, my vote is to either punt
and document it as a "KVM erratum", or straight up make nested require nrips.

Note, that also requires updating svm_queue_exception(), which assumes it will
only be handed hardware exceptions, i.e. hardcodes type EXEPT.  That's blatantly
wrong, e.g. if userspace injects a software exception via KVM_SET_VCPU_EVENTS.
