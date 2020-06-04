Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8761E1EEAC2
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgFDTAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbgFDTAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:00:45 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3D8C08C5C0
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 12:00:45 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u13so1362570iol.10
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 12:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=69PoFfU2upvom817GnReWkGrjJfx7VICK5EigdbUTME=;
        b=PW1jT03QmVtqEKvKlH5SaggmhN/rsrtwjmhM32F9R4Ra4FxyVeJULgUf9Pa58QT8PP
         zQ0s9akBrnYkTPNH0568W5B5AZNqSwj0RADodxOIrjPp09bMEGPpVY0TzRafqpv9nlB7
         fXZGS9JCdQRR/mCsfXZzPWs+IxE617K5PYH3t85+TgijwV+DKl/EYsyOkFSZAKOlq5GB
         cHST+Z7H8IAytdpLCRGuRIm/lXa5jWJgo7t44un336PauYGtpBKpNNN4wkE9A7Ww5csV
         2uPKaL9BQY7U7G02tpAS22ZlT9oquN716+IhatxGNRHYt5FzqcHnl3T51MmNu8EQ27ta
         9M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=69PoFfU2upvom817GnReWkGrjJfx7VICK5EigdbUTME=;
        b=OHzm64JtFnbFHhdYxAtCmHRxVM+k7DWTyqCXDdTpkliSZC7A01l6gmqNMNTnSDuUZ3
         uHKnhslniVsHw/ADpt3PO0YjeMlLeRY8rzr84j9P70TXpEqvDKXum9KCX/HTodH2ohgF
         ShXHqXOXR7Zjpo2qX0w+b1gzqgsEAo9yIucBAmuY9qqCoP1GcCRv5LFbGiPTVyYCzIwV
         Z65qqwmohAtLHaUqd9qwCXqgzrZUGsmGjTVrc3aNYTpZJnhEn88gZOOVKGt9Vn9VjcH0
         cuKSZzYrz2CHKs4ECggupBLH3cKHWPzGq4EEF/BX1yRlywjsXKy8RZcQkvi4oTepVDTH
         L1RA==
X-Gm-Message-State: AOAM532MTqTTw5UIqCqW65y65aJGrjdBUMLcgE+A4QDTGW4ZnBMZKcKt
        IzEerT08h+ODF/nPykgUsmecQiHmYsW3bWq3z8/zZHPs
X-Google-Smtp-Source: ABdhPJx6SpfkV1+QNeGpDw9pqachf2iCWTXildjUVg9L2eUnH2p/exaA9XKZer0Bv4ZDmYScgyk9dc9KnSPkEPPYf8w=
X-Received: by 2002:a5e:a705:: with SMTP id b5mr5367042iod.12.1591297244342;
 Thu, 04 Jun 2020 12:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com> <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com> <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
 <20200603022414.GA24364@linux.intel.com> <CALMp9eSth924epmxS8-mMXopGMFfR_JK7Hm8tQXyeqGF3ebxcg@mail.gmail.com>
 <20200604184656.GD30456@linux.intel.com>
In-Reply-To: <20200604184656.GD30456@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 4 Jun 2020 12:00:33 -0700
Message-ID: <CALMp9eR3c3wQ4YrP7O0UwP=B95XR_-rEpbjet1AgKVMYNEWskA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 11:47 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Jun 03, 2020 at 01:18:31PM -0700, Jim Mattson wrote:
> > On Tue, Jun 2, 2020 at 7:24 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > As an alternative to storing the last run/attempted CPU, what about moving
> > > the "bad VM-Exit" detection into handle_exit_irqoff, or maybe a new hook
> > > that is called after IRQs are enabled but before preemption is enabled, e.g.
> > > detect_bad_exit or something?  All of the paths in patch 4/4 can easily be
> > > moved out of handle_exit.  VMX would require a little bit of refacotring for
> > > it's "no handler" check, but that should be minor.
> >
> > Given the alternatives, I'm willing to compromise my principles wrt
> > emulation_required. :-) I'll send out v4 soon.
>
> What do you dislike about the alternative approach?

Mainly, I wanted to stash this in a common location so that I could
print it out in our local version of dump_vmcs(). Ideally, we'd like
to be able to identify the bad part(s) just from the kernel logs.
That, and I wouldn't have been as comfortable with the refactoring
without a lot more testing.
