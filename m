Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245B44F6CE7
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiDFVjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiDFVhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:37:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61EC149D17
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 13:52:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ch16-20020a17090af41000b001ca867ef52bso5026413pjb.0
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 13:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkFjUfhGoQ34kJyACGIdw2JI7HA9Qbq4djiPovTr3nU=;
        b=V8fNKwMdF/78RolOKcFf3ZhsNoC2OOtHtdeW5d4KTeh6iZ082KMBgGMOrUBMe/NoAk
         +hYS8r+McENQQu6k7QLmoTfZZhz0LTvbBhIwc1ZI7jxz1W+5c5WWXRyy1o7L2cBuaII1
         NmyILt6XWSnRiLW7ZHhxOJQEiTaLQ9Eq5FsY0JtXgTZsjhSPvufEaufsobiiryXZJNz+
         iBucEWrK4ZyDbDEQsCwa80KUqwk5B3Yq0AUdwErNvl0NPJKwNJbrvt4iLP9RJaDs1tw8
         9doJwoCrBACSmeYA61WBSRyiqNZQ+DLpu8wV1DHZqxvoH2bn9xvtpXh9i1JHl+qFC86h
         PacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkFjUfhGoQ34kJyACGIdw2JI7HA9Qbq4djiPovTr3nU=;
        b=62v82BP0Y1X95NVmF/tAB5E00En73Te1aGvVRjovY6H/Q8eqqJwUp02dTckQclEEsd
         DON48fGXl7zZ+eFdn84k7Ox2FjmDI0MmjU837TELXU5v1fbQ3j6RExxtYLQ+T6Ux0GNI
         zQC+3SbzPC2gNm9PExFZY+N5hlkqVp5VWX3JQwf5AgTvdD3RLkHr1MhX+XmvL276OO0K
         q72Gx/EYWsdrnuyG/zDsnl4HY5QY92JuWFQNitY7NBEDzOX8EVq+MJBTSKiCjqS+cTqk
         xrvMy96oLb02iAJxcu8Z4d/+xuVgOhQXYQ1XmuVS35F2cUsQemE4JJdlzcFkWEx9GXTv
         sS4Q==
X-Gm-Message-State: AOAM532AjYHlmiNVvHbpNZ+coLnqyYYBWPL2xCNBc7majsu3hIj2ulBO
        iQ8mxqXoa2ENGSXcEAX4aj6QRQ==
X-Google-Smtp-Source: ABdhPJxKhnEQV5VqEbY+JvX8VIw//fdN/sZciPCv9KuPGbSdvYgXpIcb2nA5fqbPdQp5BKAl6Hw2OQ==
X-Received: by 2002:a17:902:76ca:b0:157:1c6:5660 with SMTP id j10-20020a17090276ca00b0015701c65660mr703844plt.105.1649278356074;
        Wed, 06 Apr 2022 13:52:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a16-20020a17090a6d9000b001c9c3e2a177sm6421301pjk.27.2022.04.06.13.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:52:35 -0700 (PDT)
Date:   Wed, 6 Apr 2022 20:52:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying
 the instruction
Message-ID: <Yk39j8f81+iDOsDG@google.com>
References: <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
 <Yk3Jd6xAfgVoFgLc@google.com>
 <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
 <Yk3uh6f+0nOdybd3@google.com>
 <cd348e77-cb40-a64c-6b82-24e9a9158946@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd348e77-cb40-a64c-6b82-24e9a9158946@maciej.szmigiero.name>
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

On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
> On 6.04.2022 21:48, Sean Christopherson wrote:
> > On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
> > > On 6.04.2022 19:10, Sean Christopherson wrote:
> > > > On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
> > > And what if it's L0 that is trying to inject a NMI into L2?
> > > In this case is_guest_mode() is true, but the full NMI injection machinery
> > > should be used.
> > 
> > Gah, you're right, I got misled by a benign bug in nested_vmx_l1_wants_exit() and
> > was thinking that NMIs always exit.  The "L1 wants" part should be conditioned on
> > NMI exiting being enabled.  It's benign because KVM always wants "real" NMIs, and
> > so the path is never encountered.
> > 
> > @@ -5980,7 +6005,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> >          switch ((u16)exit_reason.basic) {
> >          case EXIT_REASON_EXCEPTION_NMI:
> >                  intr_info = vmx_get_intr_info(vcpu);
> > -               if (is_nmi(intr_info))
> > +               if (is_nmi(intr_info) && nested_cpu_has_nmi_exiting(vmcs12))
> >                          return true;
> >                  else if (is_page_fault(intr_info))
> >                          return true;
> > 
> 
> I guess you mean "benign" when having KVM as L1, since other hypervisors may
> let their L2s handle NMIs themselves.

No, this one's truly benign.  The nVMX exit processing is:

	if (nested_vmx_l0_wants_exit())
		handle in L0 / KVM;

	if (nested_vmx_l1_wants_exit())
		handle in L1

	handle in L0 / KVM

Since this is for actual hardware NMIs, the first "L0 wants" check always returns
true for NMIs, so the fact that KVM screws up L1's wants is a non-issue.
 
> > > It is also incorrect to block L1 -> L2 NMI injection because either L1
> > > or L2 is currently under NMI blocking: the first case is obvious,
> > > the second because it's L1 that is supposed to take care of proper NMI
> > > blocking for L2 when injecting an NMI there.
> > 
> > Yep, but I don't think there's a bug here.  At least not for nVMX.
> 
> I agree this scenario should currently work (including on nSVM) - mentioned
> it just as a constraint on solution space.
> 
> > > > > With the code in my previous patch set I planned to use
> > > > > exit_during_event_injection() to detect such case, but if we implement
> > > > > VMCB12 EVENTINJ parsing we can simply add a flag that the relevant event
> > > > > comes from L1, so its normal injection side-effects should be skipped.
> > > > 
> > > > Do we still need a flag based on the above?  Honest question... I've been staring
> > > > at all this for the better part of an hour and may have lost track of things.
> > > 
> > > If checking just is_guest_mode() is not enough due to reasons I described
> > > above then we need to somehow determine in the NMI / IRQ injection handler
> > > whether the event to be injected into L2 comes from L0 or L1.
> > > For this (assuming we do VMCB12 EVENTINJ parsing) I think we need an extra flag.
> > 
> > Yes :-(  And I believe the extra flag would need to be handled by KVM_{G,S}ET_VCPU_EVENTS.
> > 
> 
> Another option for saving and restoring a VM would be to add it to
> KVM_{GET,SET}_NESTED_STATE somewhere (maybe as a part of the saved VMCB12
> control area?).

Ooh.  What if we keep nested_run_pending=true until the injection completes?  Then
we don't even need an extra flag because nested_run_pending effectively says that
any and all injected events are for L1=>L2.  In KVM_GET_NESTED_STATE, shove the
to-be-injected event into the normal vmc*12 injection field, and ignore all
to-be-injected events in KVM_GET_VCPU_EVENTS if nested_run_pending=true.

That should work even for migrating to an older KVM, as keeping nested_run_pending
will cause the target to reprocess the event injection as if it were from nested
VM-Enter, which it technically is.

We could probably get away with completely dropping the intermediate event as
the vmc*12 should still have the original event, but that technically could result
in architecturally incorrect behavior, e.g. if vectoring up to the point of
interception sets A/D bits in the guest.
