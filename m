Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5437570A120
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjESU5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 16:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjESU5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 16:57:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3841EC2
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 13:57:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-559ea6b1065so67313357b3.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684529852; x=1687121852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=taC7EmecSoPqYCCkWj+HzMbbAhne+m3XF3zqa1yQ0T0=;
        b=4B7m9BOelUqdIVU9DQbPW2sWg+cpcfFxzeaMsHpViJbsnIFZdCmqby2ypo9+/L9cur
         uU/0mkb3OEh9KfHiw/OXkz/dqjjDRFuh/UYbPTWgRDV5tassrDU+w7qktfU2GIq+WOgb
         UWMDQnY1UtPg3Ohj33Ua8dE0GvysFG2aZABlzod6Hi9M0T5JE7ySunRW5ySiyzFKdbLK
         VosgijfZUR4nX7yyBEMr1B3729NxFHGNJLdfEk12g8S+7CE4Yvm0wKNv8E9OE49S29L7
         Cpbmy+iK55LTFoNtMNSrPHvZM9VKCOToPCWy0BoqfAaajNuG+bqQmsUdOfDKBUPTchYa
         pexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684529852; x=1687121852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taC7EmecSoPqYCCkWj+HzMbbAhne+m3XF3zqa1yQ0T0=;
        b=Fw+38WlieD/HdYgGbNffQ+ufeV5AJH2DKm4l1Ner/+/KBdihxVGFz2/VN3lRfpwyuU
         st68C76mLF7tErMg2pHKy4BdnY+1gFI18wTCxWgsWIX/Wq3BwCZAkrTMXV9IKTOY9ktS
         Ku35IrlU/dgaNx9NydOB31jVea4ZVKxCOmoo6OILZroYWhhj2slVcaQGf350vHzBAyz2
         ftSa/SpopuaeIWi3EBoaeLQBMFuUUGFH7KbDOYKW8yDQ8t2s+Xg3jFzPgVwywcAU6z8H
         /ZIHbJg6H+JaytfNOHK9IUQmk8L2xourrXmbm4FFPOYp13tpc3daUYbLtB0uZdkOAFWx
         CNlw==
X-Gm-Message-State: AC+VfDyd1y5F+L1bRqEJGqdv53/xN9nMov5fRMShh+Lvj3h1PpIYUb0V
        ExPVLv9QnCOsL5Pm3BeSda3GzTlcaHw=
X-Google-Smtp-Source: ACHHUZ4734pJLWBn2szowanUZEDxVRHek8WgSKyLA+UtgLhhHZnXfDvUn/Wi+3M+ONKwnQYSYn2JFbGCo4A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae4c:0:b0:561:b7fc:7445 with SMTP id
 g12-20020a81ae4c000000b00561b7fc7445mr1980300ywk.1.1684529852517; Fri, 19 May
 2023 13:57:32 -0700 (PDT)
Date:   Fri, 19 May 2023 13:57:30 -0700
In-Reply-To: <10abe213-54bb-e637-7ea2-c088bca4726d@redhat.com>
Mime-Version: 1.0
References: <20230503160838.3412617-1-seanjc@google.com> <10abe213-54bb-e637-7ea2-c088bca4726d@redhat.com>
Message-ID: <ZGfius5UkckpUyXl@google.com>
Subject: Re: [PATCH v2 0/3] KVM: x86: SGX vs. XCR0 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023, Paolo Bonzini wrote:
> On 5/3/23 18:08, Sean Christopherson wrote:
> > Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
> > for SGX enclaves.  Past me didn't understand the roles and responsibilities
> > between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
> > being helpful by having KVM adjust the entries.
> > 
> > This is clearly an ABI change, but QEMU does the right thing and AFAIK no
> > other VMMs support SGX (yet), so I'm hopeful/confident that we can excise
> > the ugly before userspace starts depending on the bad behavior.
> > v2:
> >   - Collect reviews/testing. [Kai]
> >   - Require FP+SSE to always be set in XFRM, and exempt them from the XFRM
> >     vs. XCR0 check. [Kai]
> > 
> > v1: https://lore.kernel.org/all/20230405005911.423699-1-seanjc@google.com
> > 
> > Sean Christopherson (3):
> >    KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0 restrictions for
> >      ECREATE
> >    KVM: x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)
> >    KVM: x86: Open code supported XCR0 calculation in
> >      kvm_vcpu_after_set_cpuid()
> > 
> >   arch/x86/kvm/cpuid.c   | 43 ++++++++++--------------------------------
> >   arch/x86/kvm/vmx/sgx.c | 11 +++++++++--
> >   2 files changed, 19 insertions(+), 35 deletions(-)
> > 
> > 
> > base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
> 
> Queued, thanks.  But why patch 3?

I want to guard against future misuse of calculating the support XCR0 before the
CPUID update is complete.  I suppose I could have done this:

  static u64 guest_cpuid_supported_xcr0(struct kvm_vcpu *vcpu)
  {
	struct kvm_cpuid_entry2 *best;

	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
	if (!best)
		return 0;

	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
  }

but I don't really see the point since there should only ever be one caller,
e.g. unlike cpuid_query_maxphyaddr() which needs a non-zero default.

> Small functions are nice and remove the need to remember what is in EDX:EAX
> of CPUID[0xD,0].

Hmm, yes and no.  Specifically, I dislike single-use helpers that bury unintuitive
details in the helper, e.g. in this case, filtering the raw iguest CPUID with KVM's
kvm_caps.supported_xcr0.  Communicating that in the name of the function so that
they're are no surprises is often more difficult than just open coding things.
