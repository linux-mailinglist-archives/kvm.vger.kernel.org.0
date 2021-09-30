Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960A541E040
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352735AbhI3Rhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 13:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352722AbhI3Rhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 13:37:31 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CE4C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:35:48 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i4so28966599lfv.4
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s5N4b19Q49QeVKOuC0SBVfXLj3HIljMXb2q43UZ1RZU=;
        b=Wzcae0dC0R4migP9faLoevPT6NeA4ofALujPzFb5LPchEtGYDaYEcpfcMHc3f6nL4u
         vsCYkmkrivUsiaSdXfvOys+LPVWgFMALtu7w+TgbZL6hpW1Y9cXfHcXfDpx8TGt4aqyI
         q+oAA3nRydIPNQTBCKSIzDBOO12926TNCH/+KRaBua5pg0YrvjqQgqz7fZzyP/eaFUar
         nQNbEEwOdwzVkP/pQJU7lcMLxORWob2euKcVzisb30yGwrshGtJ18z4ZYVMtkWLLpLbn
         MGKvdoG44SqXYzJztlrV58yv+cUwHjo1U3NXPE66ppDN4+zM3cceep2FW/xNsuoHA+5l
         BWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s5N4b19Q49QeVKOuC0SBVfXLj3HIljMXb2q43UZ1RZU=;
        b=AkCY7EMj/CJpZCAjqfZ0rY7TEIRGInUPpT7QUzrDju9tTEEcLrYv3yjwYUOPDruZKd
         pTdLeEG4UlxxJF7plaVVbYeMsr5CDSqh5RtNuxeO0eOfR0dJSww6X7+cguVpFDll4/5b
         KbOJGKZefmmt3m2pRf1E86TrSRDehOKf3NaJVM5Abktpzd32R3ZNu5UFnYUUSTodDkRI
         dEbexdw2/B+gFlPZ9V0s4YcNA700yBjEdoKBsS0NXXnHNDsFZxdDKi1pd7GZ0usOba1g
         MVbNw0J7XsiWtx4WnfYAJp6qwgw8ZjjsJYDrEEMyLICL2C7CucxgnQQbE2wC8UTRXW3j
         W4VQ==
X-Gm-Message-State: AOAM532WHU0Ji5X7o84rc+hefF2zKkBwrEoMY99y/5svzYxhTa7S3MS9
        AZaxKlvrNggV8vEekI0sr3BtRYJS4bpYHkoHJsENYA==
X-Google-Smtp-Source: ABdhPJxqPGj5cL1Lx+IjKbi+sEIpu/qet2OJxG2dnCOQma9Vui7OB+v+y/6skqu8JhFPQHC/P7ckRH2kXO2E1obtI+4=
X-Received: by 2002:ac2:4c50:: with SMTP id o16mr453283lfk.286.1633023346789;
 Thu, 30 Sep 2021 10:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-7-oupton@google.com>
 <877deytfes.wl-maz@kernel.org> <YVXxlg6g4fYsphwM@google.com>
In-Reply-To: <YVXxlg6g4fYsphwM@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 30 Sep 2021 10:35:35 -0700
Message-ID: <CAOQ_QsjQL-o926c_dQ4_snRKGQN+WhScX9yRQ4UPkbMJcmRvGQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 10:19 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 30, 2021, Marc Zyngier wrote:
> > Hi Oliver,
> >
> > On Thu, 23 Sep 2021 20:16:05 +0100,
> > Oliver Upton <oupton@google.com> wrote:
> > >
> > > ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
> > > used to request a system be suspended. This is optional for PSCI v1.0
> > > and to date KVM has elected to not implement the call. However, a
> > > VMM/operator may wish to provide their guests with the ability to
> > > suspend/resume, necessitating this PSCI call.
> > >
> > > Implement support for SYSTEM_SUSPEND according to the prescribed
> > > behavior in the specification. Add a new system event exit type,
> > > KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
> > > system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
> >
> > KVM_MP_STATE_HALTED is a per-CPU state on x86 (it denotes HLT). Does
> > it make really sense to hijack this for something that is more of a
> > VM-wide state? I can see that it is tempting to do so as we're using
> > the WFI semantics (which are close to HLT's, in a twisted kind of
> > way), but I'm also painfully aware that gluing x86 expectations on
> > arm64 rarely leads to a palatable result.
>
> Agreed, we literally have billions of possible KVM_MP_STATE_* values, and I'm pretty
> sure all of the existing states are arch-specific.  Some are common to multiple
> architectures, but I don't think _any_ are common to all architectures.

Yeah, I was debating this as well when cooking up the series. No need
to overload the x86-ism when we can have a precisely named state for
ARM.
