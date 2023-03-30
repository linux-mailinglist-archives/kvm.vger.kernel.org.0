Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6BD6D0C66
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjC3RMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjC3RMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:12:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829EF526F
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:12:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b1-20020a17090a8c8100b002400db03706so5508811pjo.0
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680196356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ioBafc1jE3EEeqzwTNbBrZD3ovHkrs99FyUrXRF156A=;
        b=msUO/9ThOjN8i56o4SeCuRAALYD7WOOSf1zpA1W56mqG3L+Cv5Oe+aSZKS4T2cDVwT
         WJ+hwOZsYzOyKZhsv/GlCN0CRLRLHttB+BlxyPfewSSg8S78rBu3X66dvebHIL20ddAU
         /D4exBXpre0+9enUknX1jwg9hNYxKigzHXBi00PeqBnV/ljoTM9O0SN9Z1/t+s4JQ/CI
         E1DTIl+6/YviouTNy6L4GdVtH/DnU9TW9yndfEHEHm94to/sQYps+mgRZzvbtpvi44J9
         kvSZqzcA05kR7fA9ql6k6SCqgVYXOQOKDJSdDE0/zu15gYHLCbO4zrFY7ljdYVzQh9+o
         iXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680196356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ioBafc1jE3EEeqzwTNbBrZD3ovHkrs99FyUrXRF156A=;
        b=LGeY2elPownhMy5iYAe9o8vfOpHuxyb2MjNL6eWRflP0mzJRtBUober3Uf85IRJdLJ
         q0WzsTW8RKC/FQbRKkJLteMg+J7+FNA2jC6HwZJiRfk+QffIwGbQtW+mfVxpYQ8Cc8Rg
         mqXr3oBhZTNYH+PVsU/lM4WDIq2WtqZZcfbcIbidgDwIUxviEEnVcfUSfdS6UHqV4QaS
         ngWr8OyAe2x7AUM0bfC1zEJ6AZDz5jDGR69juhM3xryO3aoAg7lE1QIX8IpZ9l8ekGR7
         nkGiO1tW4o5jdIKdF4M1E4PH0bShaLtabKy/BNjNAqM/p8OJ7yO3rZXlceI07sKT0EUQ
         bk/g==
X-Gm-Message-State: AAQBX9d3PtJhyoq9v1siqZZLnXN27r6f29ibyEFgkqYSPJC8rM0doOdT
        Ebp4RBqQ891N3XGHCA+1lLI3mNwEA5U=
X-Google-Smtp-Source: AKy350aMF5gEqFkS2yOuUw/kCM+VW9fHPk4cRIMrJsEobbypPXnitBkck2f9Ebysy8Gp2Z0Aqj6tLn6duPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9285:0:b0:626:1710:9b7d with SMTP id
 j5-20020aa79285000000b0062617109b7dmr2998427pfa.0.1680196356061; Thu, 30 Mar
 2023 10:12:36 -0700 (PDT)
Date:   Thu, 30 Mar 2023 10:12:34 -0700
In-Reply-To: <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net> <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
Message-ID: <ZCXDAiUOnsL3fRBj@google.com>
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Mathias Krause wrote:
> On 22.03.23 02:37, Mathias Krause wrote:
> > Guests like grsecurity that make heavy use of CR0.WP to implement kernel
> > level W^X will suffer from the implied VMEXITs.
> > 
> > With EPT there is no need to intercept a guest change of CR0.WP, so
> > simply make it a guest owned bit if we can do so.
> > 
> > This implies that a read of a guest's CR0.WP bit might need a VMREAD.
> > However, the only potentially affected user seems to be kvm_init_mmu()
> > which is a heavy operation to begin with. But also most callers already
> > cache the full value of CR0 anyway, so no additional VMREAD is needed.
> > The only exception is nested_vmx_load_cr3().
> > 
> > This change is VMX-specific, as SVM has no such fine grained control
> > register intercept control.
> 
> Just a heads up! We did more tests, especially with the backports we did
> internally already, and ran into a bug when running a nested guest on an
> ESXi host.
> 
> Setup is like: ESXi (L0) -> Linux (L1) -> Linux (L2)
> 
> The Linux system, especially the kernel, is the same for L1 and L2. It's
> a grsecurity kernel, so makes use of toggling CR0.WP at runtime.
> 
> The bug we see is that when L2 disables CR0.WP and tries to write to an
> r/o memory region (implicitly to the r/o GDT via LTR in our use case),
> this triggers a fault (EPT violation?) that gets ignored by L1, as,
> apparently, everything is fine from its point of view.

It's not an EPT violation if there's a triple fault.  Given that you're dumping
the VMCS from handle_triple_fault(), I assume that L2 gets an unexpected #PF that
leads to a triple fault in L2.

Just to make sure we're on the same page: L1 is still alive after this, correct?

> I suspect the L0 VMM to be at fault here, as the VMCS structures look
> good, IMO. Here is a dump of vmx->loaded_vmcs in handle_triple_fault():

...

> The "host" (which is our L1 VMM, I guess) has CR0.WP enabled and that is
> what I think confuses ESXi to enforce the read-only property to the L2
> guest as well -- for unknown reasons so far.

...

> I tried to reproduce the bug with different KVM based L0 VMMs (with and
> without this series; vanilla and grsecurity kernels) but no luck. That's
> why I'm suspecting a ESXi bug.
   
...

> I'm leaning to make CR0.WP guest owned only iff we're running on bare
> metal or the VMM is KVM to not play whack-a-mole for all the VMMs that
> might have similar bugs. (Will try to test a few others here as well.)
> However, that would prevent them from getting the performance gain, so
> I'd rather have this fixed / worked around in KVM instead.

Before we start putting bandaids on this, let's (a) confirm this appears to be
an issue with ESXi and (b) pull in VMware folks to get their input.

> Any ideas how to investigate this further?

Does the host in question support UMIP?

Can you capture a tracepoint log from L1 to verify that L1 KVM is _not_ injecting
any kind of exception?  E.g. to get the KVM kitchen sink:

  echo 1 > /sys/kernel/debug/tracing/tracing_on
  echo 1 > /sys/kernel/debug/tracing/events/kvm/enable

  cat /sys/kernel/debug/tracing/trace > log

Or if that's too noisy, a more targeted trace (exception injection + emulation)
woud be:

  echo 1 > /sys/kernel/debug/tracing/tracing_on

  echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_emulate_insn/enable
  echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_inj_exception/enable
  echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
  echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable

> PS: ...should have left the chicken bit of v3 to be able to disable the
> feature by a module parameter ;)

A chicken bit isn't a good solution for this sort of thing.  Toggling a KVM module
param requires (a) knowing that it exists and (b) knowing the conditions under which
it is/isn't safe to toggle the bit.

E.g. if this ends up being an ESXi L0 bug, then an option might be to add something
in vmware_platform_setup() to communicate the bug to KVM so that KVM can precisely
disable the optimization on affected platforms.
