Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634EE7C9154
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 01:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjJMX0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 19:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjJMX0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 19:26:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0401DC2
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 16:26:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c647150c254so2229191276.1
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 16:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697239607; x=1697844407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxyOGXfEtIJtv+c8UKOk7f88Du3NTkDVIB8Ot0qjFrU=;
        b=dDPr/jcNs5wnaiIeHyIdazDbfbBjJu6YU3t+MqEUQXdodtuWZhLpfUI3tF/4mL2zdG
         BKkYp83jM7dUXZQAfjDywOXqGAu4Zuopou8zaS4jfyULrrd5funZuUp/Vtw/67v3A7mh
         u9P8etvDvEcuO30Qz7Sj7mN/yjUleF44gD1UtPKbGTnHxPKw7H/4MQwq6ldJbLVn7+8E
         Hm7wVtd+yMEAK4/e100NfC/hJjJgRnWWxmxEXlIUUYtGEAqRzbtTpuvlcDaNb9ifQXny
         ZYn9685U8uGhNsZqPq2bQ3ca7q5vSRjew3kc1a8WvOn5a/WLsDwpM40F5n0L7gwDfDS0
         gsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697239607; x=1697844407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxyOGXfEtIJtv+c8UKOk7f88Du3NTkDVIB8Ot0qjFrU=;
        b=Q4IdUPB9cpx4S7/XNb8lVgVHrMWnrTs/hJSQJaesvqEWtHeaiL3/OgWqcMOX1rPwm9
         zMUJrAgfzHoINsmumRAhklG+OPlIdgwTGkmNFwt1aeudDxHvWcDDCf0NIe3UomgRnWzQ
         6Zg7SBGmQUxWMJujhzcSX3GZpsNWdJtXKxw1aqlbL9Nsfz3psSJ6z13bInEJzNlSGT9c
         JSwNOqfa9kZNpv6mshmaMlsgs04HxtjiJcRplkpP3Z92UoGDc7Z9NRBqJTcE7bPGssn+
         S+irxHymJ66hsA+CqitBWxTOeGSAfm5P7w2QQihLeP107P+KZAk1fAm660f0Jty5boeT
         VYNg==
X-Gm-Message-State: AOJu0YxEd4A9ZpxN/Glm8Nowv1P/fI/1hjWuVjoFvVSn1SDtGQVgZ2+G
        c1sG3KIkVchb5yZmCA32B1Zoe4dv6hE=
X-Google-Smtp-Source: AGHT+IFQprQeeqDErduhvYEUioZzrtTBys2b4mF6B8tFqcwNVK7VJheN/wBsDzU4CECZzpqmAnREQbXwFvc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150b:b0:d9a:4400:d62c with SMTP id
 q11-20020a056902150b00b00d9a4400d62cmr64933ybu.4.1697239607269; Fri, 13 Oct
 2023 16:26:47 -0700 (PDT)
Date:   Fri, 13 Oct 2023 16:26:45 -0700
In-Reply-To: <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
Mime-Version: 1.0
References: <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com> <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
Message-ID: <ZSnSNVankCAlHIhI@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023, Dongli Zhang wrote:
> On 10/13/23 11:07, Sean Christopherson wrote:
> > What if we add a module param to disable KVM's TSC synchronization craziness
> > entirely?  If we first clean up the peroidic sync mess, then it seems like it'd
> > be relatively straightforward to let kill off all of the synchronization, including
> > the synchronization of kvmclock to the host's TSC-based CLOCK_MONOTONIC_RAW.
> > 
> > Not intended to be a functional patch...
> > 
> > ---
> >  arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 32 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5b2104bdd99f..75fc6cbaef0d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
> >  static bool __read_mostly kvmclock_periodic_sync = true;
> >  module_param(kvmclock_periodic_sync, bool, S_IRUGO);
> >  
> > +static bool __read_mostly enable_tsc_sync = true;
> > +module_param_named(tsc_synchronization, enable_tsc_sync, bool, 0444);
> > +
> >  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
> >  static u32 __read_mostly tsc_tolerance_ppm = 250;
> >  module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
> > @@ -2722,6 +2725,12 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> >  	bool matched = false;
> >  	bool synchronizing = false;
> >  
> > +	if (!enable_tsc_sync) {
> > +		offset = kvm_compute_l1_tsc_offset(vcpu, data);
> > +		kvm_vcpu_write_tsc_offset(vcpu, offset);
> > +		return;
> > +	}
> 
> TBH, I do not like this idea for two reasons.
> 
> 1. As a very primary part of my work is to resolve kernel issue, when debugging
> any clock drift issue, it is really happy for me to see all vCPUs have the same
> vcpu->arch.tsc_offset in the coredump or vCPU debugfs.
> 
> This patch may lead to that different vCPUs added at different time have
> different vcpu->arch.tsc_offset.

The expectation is that *if* userspace disables TSC synchronization, then userespace
would be responsible for setting the guest TSC offset directly.  And disabling
TSC synchronization would be fully opt-in, i.e. we'd fix the existing masterclock
sync issues first.

> 2. Suppose the KVM host has been running for long time, and the drift between
> two domains would be accumulated to super large? (Even it may not introduce
> anything bad immediately)

That already happens today, e.g. unless the host does vCPU hotplug or is using
XEN's shared info page, masterclock updates effectively never happen.  And I'm
not aware of a single bug report of someone complaining that kvmclock has drifted
from the host clock.  The only bug reports we have are when KVM triggers an update
and causes time to jump from the guest's perspective.

If the guest needs accurate timekeeping, it's all but guaranteed to be using NTP
or an equivalent.  I.e. the imprecision that's inherent in the pvclock ABI shouldn't
be problematic for any guest that actually cares.

> If the objective is to avoid masterclock updating, how about the below I copied
> from my prior diagnostic kernel to help debug this issue.
> 
> The idea is to never update master clock, if tsc is stable (and masterclock is
> already used).

That's another option, but if there are no masterclock updates, then it suffers
the exact same (theoretical) problem as #2.  And there are real downsides, e.g.
defining when KVM would synchronize kvmclock with the host clock would be
significantly harder, as we'd have to capture all the possible ways that KVM could
(temporarily) disable the masterclock and start synchronizing.
