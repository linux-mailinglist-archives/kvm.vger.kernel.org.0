Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0FBF2CAF
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 11:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbfKGKi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 05:38:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387839AbfKGKi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 05:38:28 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFC8F83F3B
        for <kvm@vger.kernel.org>; Thu,  7 Nov 2019 10:38:27 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id g17so754185wru.4
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 02:38:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1cBytUypSmrDIXCTuphD26i91wQdyJsDQ/c6D49Q3/s=;
        b=uWtbApUdtvGVl1UasgVtRkky882Yk5BMO9aCVuT/iiQlYMF7pVxTrhEHsv8WslG0Nu
         fHtpR2Q5lDcxWU3oeTo1P2SpQU48wr/DUYDM0jFKsVh+dRP+mr1n7GBDOjFWXtsozlho
         Ut1Y8o+Y7YjNCEtAm0t/47oPT14OfwSo69wfQpz3V4a4LcO13oTTnAIantxDslikU2ZK
         88akvrcz628RpOjcxiMTC54gutsiscbOXWNB+bhod1WlUeO9xZm1cLQl6vkB77OnYGGk
         kdWlZWc20xJSp9QsZSsq6keeetuZDNtfD8aMVThvRXNy7P/K2PpfB9jbLoA1nZ1Pr15d
         oGGA==
X-Gm-Message-State: APjAAAWPrgpxJD9J/WjWM9/4usJR41UE/f7IYU4ojClgCTVCEJ4bbex/
        Uz2pMOFZGkA9amAAqv2Gd01uU04kZRW3vIjnZo6pPNhf1uwQHLJWRL86Vky9uiQpEfdmz0iETBR
        xMnZnh4Wd71+I
X-Received: by 2002:adf:ea50:: with SMTP id j16mr2050948wrn.295.1573123106316;
        Thu, 07 Nov 2019 02:38:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqy29JLKN+fQKhtAvQsjApYEtkKH0E4xyVUx/oPkr1HuCBG5qXWHjPsVEHaccFuX1Z35xiuEdQ==
X-Received: by 2002:adf:ea50:: with SMTP id j16mr2050934wrn.295.1573123106058;
        Thu, 07 Nov 2019 02:38:26 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j14sm1756813wrp.16.2019.11.07.02.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 02:38:25 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is trustworthy
In-Reply-To: <20191105232500.GA25887@linux.intel.com>
References: <20191105161737.21395-1-vkuznets@redhat.com> <20191105193749.GA20225@linux.intel.com> <20191105232500.GA25887@linux.intel.com>
Date:   Thu, 07 Nov 2019 11:38:24 +0100
Message-ID: <87ftj0as4f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Nov 05, 2019 at 11:37:50AM -0800, Sean Christopherson wrote:
>> On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
>> > Virtualized guests may pick a different strategy to mitigate hardware
>> > vulnerabilities when it comes to hyper-threading: disable SMT completely,
>> > use core scheduling, or, for example, opt in for STIBP. Making the
>> > decision, however, requires an extra bit of information which is currently
>> > missing: does the topology the guest see match hardware or if it is 'fake'
>> > and two vCPUs which look like different cores from guest's perspective can
>> > actually be scheduled on the same physical core. Disabling SMT or doing
>> > core scheduling only makes sense when the topology is trustworthy.
>> > 
>> > Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
>> > that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
>> > topology is actually trustworthy. It would, of course, be possible to get
>> > away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
>> > compatibility but the current approach looks more straightforward.
>> 
>> I'd stay away from "trustworthy", especially if this is controlled by
>> userspace.  Whether or not the hint is trustworthy is purely up to the
>> guest.  Right now it doesn't really matter, but that will change as we
>> start moving pieces of the host out of the guest's TCB.
>> 
>> It may make sense to split the two (or even three?) cases, e.g.
>> KVM_FEATURE_NO_SMT and KVM_FEATURE_ACCURATE_TOPOLOGY.  KVM can easily
>> enforce NO_SMT _today_, i.e. allow it to be set if and only if SMT is
>> truly disabled.  Verifying that the topology exposed to the guest is legit
>> is a completely different beast.
>
> Scratch the ACCURATE_TOPOLOGY idea, I doubt there's a real use case for
> setting ACCURATE_TOPOLOGY and not KVM_HINTS_REALTIME.  A feature flag to
> state that SMT is disabled seems simple and useful.

You seem to have the most conservative ideas around)

I wasn't actually thinking about KVM enforcing anything here, my goal
was to provide guest with enough information so it can adjust its SMT
related settings accordingly. These could be:
- 'nosmt'
- STIBP
- Core scheduling (not yet upstream afaik)
- Manual vCPU pinning for certain tasks (including running nested
guests). [E.g. nested Hyper-V hides 'md_clear' from its guests when it
doesn't see 'NoNonarchitecturalCoreSharing' from the underlying
hypervisor as it's pointless]
- (Liran's idea): Using SMT information for better scheduling

KVM_FEATURE_NO_SMT would cover one case, however, it's basically the
same as not exposing hyperthreads by KVM userspace, just enforced. Do
you think that such enforcement makes sense? What the guest is supposed
to do when it sees the flag (compared to what's doing now)?

('KVM_HINTS_REALTIME' may actually imply what we want, however, judging
by its name it may gain additional meaning in the future like 'always do
busy polling everywhere')

-- 
Vitaly
