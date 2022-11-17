Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0797F62E058
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 16:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiKQPvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 10:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiKQPvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 10:51:41 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFF2769EC
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 07:51:41 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o7so2018255pjj.1
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 07:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FyuGzGxEZRHvEr/JeItK3VvnrH3Vjqzh4TosRHWmsqQ=;
        b=R1HkdKDDMrNBJhdZpT5wuNeVm7ykr/NYLcK4lYns8I72luzpoJnd9hOVUIJ37xXzpF
         Y9R1C+K2PAGUXcUWln5cbPjqIPmgeqBLB8XvSWAkW5dfMc3/44T/vapbL2o7yHWGZMZS
         BAbYjVGK7csYo1tAbSgDbOiGiiMUaP+xUVQP5s1TdW+x1SauV9jA8mFMRXIopQnyY8SG
         EqANano7h0k0HxMKq6lwz7WLlCStKn017xkNzAWs2WVFoQD2pIJzANNt16M5tNSVwgyN
         wPRTcgN+CTw2/kD038EMM3AWbYdVqHcanplRBcqNhUS55tRvTXJrPqPZhseKlgXeCpbC
         WtVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyuGzGxEZRHvEr/JeItK3VvnrH3Vjqzh4TosRHWmsqQ=;
        b=wll+RaOtgGrZIUYG5ZMR+7GWAcuJAoe6KTbSIaQu7TfRGL/xNNWi7yVpNLZSOONCp9
         ERoLHlW/7ygeyFoNTqGUE2iyfGOzjkjyX3rLu2ChTFSR22XiccCrNPmLxtbxArGk0p79
         Ag6V8NAeN2M0UXBVC3zfYNq0KU7Xc5UDHyb1ttbf6v+c4ZXaa4GF1M+7EEv9TdV6DbEy
         I4a0NztEeYFHnTtqsRBtGUtKNIAoDgpNZhDMFIwqJSEVS2rCaRvldCgVbuVK8j+jyC+h
         7KS6x6Lllbr5l/kSbxAez3wOciYma5xTjkFyxCoS3Vg61Ysr1ELnMQcf/ZUUo2Bunupn
         7kzg==
X-Gm-Message-State: ANoB5pn6R8+FKnm2AibUMLlib5UOkIdXrzcBevGhqRuxntTq1+uJkKY4
        vw6bDOmKsCPhwUzF30l6mKVzaA==
X-Google-Smtp-Source: AA0mqf4f9nYQrcGMW8xmaLKyDIuzI7Mvy29gSNkwlHyOvpLbAxZFoBrxeJiGiwkH4bLZqzd/HC0rUQ==
X-Received: by 2002:a17:902:e414:b0:188:b8cf:85b with SMTP id m20-20020a170902e41400b00188b8cf085bmr3238147ple.126.1668700300567;
        Thu, 17 Nov 2022 07:51:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q13-20020a170902a3cd00b0017f778d4543sm1482631plb.241.2022.11.17.07.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:51:40 -0800 (PST)
Date:   Thu, 17 Nov 2022 15:51:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y3ZYiKbJacmejY3K@google.com>
References: <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
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

On Thu, Nov 17, 2022, Li, Xin3 wrote:
> 
> > > > > > But what about NMIs, afaict this is all horribly broken for NMIs.
> > > > > > So the whole VMX thing latches the NMI (which stops NMI
> > > > > > recursion), right?
> > > > > >
> > > > > > But then you drop out of noinstr code, which means any random
> > > > > > exception can happen (kprobes #BP, hw_breakpoint #DB, or even
> > > > > > #PF due to random nonsense like *SAN). This exception will do
> > > > > > IRET and clear the NMI latch, all before you get to run any of the
> > > > > > NMI code.
> > > > >
> > > > > What you said here implies that we have this problem in the existing code.
> > > > > Because a fake iret stack is created to call the NMI handler in
> > > > > the IDT NMI descriptor, which lastly executes the IRET instruction.
> > > >
> > > > I can't follow; of course the IDT handler terminates with IRET, it has to no?
> > > >
> > > > And yes, the current code appears to suffer the same defect.

That defect isn't going to be fixed simply by changing how KVM forwards NMIs
though.  IIUC, _everything_ between VM-Exit and the invocation of the NMI handler
needs to be noinstr.  On VM-Exit due to NMI, NMIs are blocked.  If a #BP/#DB/#PF
occurs before KVM gets to kvm_x86_handle_exit_irqoff(), the subsequent IRET will
unblock NMIs before the original NMI is serviced, i.e. a second NMI could come in
at anytime regardless of how KVM forwards the NMI to the kernel.

Is there any way to solve this without tagging everything noinstr?  There is a
metric shit ton of code between VM-Exit and the handling of NMIs, and much of that
code is common helpers.  It might be possible to hoist NMI handler much earlier,
though we'd need to do a super thorough audit to ensure all necessary host state
is restored.

> > > With FRED, ERETS/ERETU replace IRET, and use bit 28 of the popped CS
> > > field to control whether to unblock NMI. If bit 28 of the field (above
> > > the selector) is 1, ERETS/ERETU unblocks NMIs.

Side topic, there's a bug in the ISE docs.  Section "9.4.2 NMI Blocking" states
that bit 16 holds the "unblock NMI" magic, which I'm guessing is a holdover from
an earlier revision of FRED.

  As specified in Section 6.1.3 and Section 6.2.3, ERETS and ERETU each unblocks NMIs
  if bit 16 of the popped CS field is 1. The following items detail how this behavior may be
  changed in VMX non-root operation, depending on the settings of certain VM-execution
  controls:

> > Yes, I know that. It is one of the many improvements FRED brings.
> > Ideally the IBT WAIT-FOR-ENDBR state also gets squirreled away in the
> > hardware exception frame, but that's still up in the air I believe :/
> > 
> > Anyway.. given there is interrupt priority and NMI is pretty much on top of
> > everything else the reinject crap *should* run NMI first. That way NMI runs
> > with the latch disabled and whatever other pending interrupts will run later.
> >
> > But that all is still broken because afaict the current code also leaves noinstr --
> > and once you leave noinstr (or use a static_key, static_call or anything else that
> > *can* change at runtime) you can't guarantee nothing.
> 
> For NMI, HPA asked me to use "int $2", as it switches to the NMI IST stack to
> execute the NMI handler, essentially like how HW deals with a NMI in host. and
> I tested it with NMI watchdog, it looks working fine.

Heh, well yeah, because that's how KVM used to handle NMIs back before I reworked
NMI handling to use the direct call method.  Ironically, that original change was
done in part to try and make it _easier_ to deal with FRED (back before FRED was
publicly disclosed).

If KVM reverts to INTn, the fix to route KVM=>NMI through the non-IST entry can
be reverted too.

  a217a6593cec ("KVM/VMX: Invoke NMI non-IST entry instead of IST entry")
  1a5488ef0dcf ("KVM: VMX: Invoke NMI handler via indirect call instead of INTn")
