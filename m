Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1623F591
	for <lists+kvm@lfdr.de>; Sat,  8 Aug 2020 02:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHHAjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 20:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHHAjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 20:39:40 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A135DC061756
        for <kvm@vger.kernel.org>; Fri,  7 Aug 2020 17:39:40 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h22so2955343otq.11
        for <kvm@vger.kernel.org>; Fri, 07 Aug 2020 17:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h41FV9raGWGLZdPgFH3QJAwQA7k0QGFw4hV2aVIO9Gg=;
        b=cPAUA0B5xWCRyYf6cNIzw7aPzmFLv+FOdBrY3f9ff1Uh69CyZrRIj0DDnaWIElm9T6
         ObFw30DXno16xymz0G8arRdLM9UioVoDLrXe8Z3sL0RhIg2K0wxRhTv/DZOckML/zD1K
         sJwaTX9U73gIeGN50pBD34Z6/D2qOaRojfN8zypEg/DRz+bXW2qNMwnyTF60Mw2kN9AH
         kVUBU6cDzjc0eHJlwnNF/8oAXTBM9NiS4HC9fet0vkw/XGU88uavzNTfthdneszebiao
         FarDYOVjWa2tm8Xh4wYyAVT7XpFzRJZIQOnX7sYgg9nxSRTgM66rYAXvsY0Ojf2wswaa
         fH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h41FV9raGWGLZdPgFH3QJAwQA7k0QGFw4hV2aVIO9Gg=;
        b=sxk9yrJB/aaSL5ORUyMmiijCmRVDs7uTVI26NOOSDW8G/+YLDu5eUdh2U/ET2Fm3ks
         IiUFUFxihXKGLMsJFLxqUoyn5X9JCcSFwKH9OD2F86Qt8DpLIn7rHcCvLfyxikKN+rSm
         ywj8I72sEt9NFjVy17wQlr5FIOExXHVvzgSBYmxWusI5rx5b2xoPkbW1fr7OlM4ZE49+
         58XylpmtsAvL5PczYtkOnFP/+wMIngwGSlbcs00PTlhmByaeK8VCy7CzqAM8s/HwyeeV
         t2mNJA4ZtmpF1B6vIA6iYbfoYv0HzURSq1eqZEx5o5ezH32uB9nSmMu24E+6ZF6cESV2
         ogNg==
X-Gm-Message-State: AOAM532r2kAG0Ku0lzb/a+NUwiO1k6CscWXgHdif8SfespcUrTfzvzlJ
        H6GP6IDWBgfMOTxxmK010ZgNSTBWTCpJSqqzJ6LvpA==
X-Google-Smtp-Source: ABdhPJzBocE90GK3VomTEeRiL7giX6aKULlKjZO2nVqVb+KBs2vy5aAQx0vwOE142k2jifG6sK0HOHPc/cq6W7UFw8U=
X-Received: by 2002:a9d:ae9:: with SMTP id 96mr13967949otq.241.1596847179443;
 Fri, 07 Aug 2020 17:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-2-aaronlewis@google.com> <183f3ebd-0872-8758-6770-a5769a87011d@amazon.com>
 <CALMp9eRgkENN94x7fpuFcRa-X_9tL0Vp0m453rwJdJ-_6qsy5w@mail.gmail.com> <d67073a5-51e3-82b1-6a85-3574eb6c9c56@amazon.com>
In-Reply-To: <d67073a5-51e3-82b1-6a85-3574eb6c9c56@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 7 Aug 2020 17:39:27 -0700
Message-ID: <CALMp9eR2OYK73vNWbTZwPEmj2-y5-Ebi23r3aGesiar-dFnuEQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 3:49 PM Alexander Graf <graf@amazon.com> wrote:
>
> On 07.08.20 23:16, Jim Mattson wrote:
> > This patch doesn't attempt to solve your problem, "tell user space
> > about unhandled MSRs." It attempts to solve our problem, "tell user
> > space about a specific set of MSRs, even if kvm learns to handle them
> > in the future." This is, in fact, what we really wanted to do when
> > Peter Hornyack implemented the "tell user space about unhandled MSRs"
> > changes in 2015. We just didn't realize it at the time.
>
> Ok, let's take a step back then. What exactly are you trying to solve
> and which MSRs do you care about?

Our userspace handles a handful of MSRs, including some of the
synthetic PV time-related MSRs (both kvm and Hyper-V), which we want
to exit to userspace even though kvm thinks it knows what to do with
them. We also have a range of Google-specific MSRs that kvm will
probably never know about. And, finally, we find that as time goes on,
there are situations where we want to add support for a new MSR in
userspace because we can roll out a new userspace more quickly than a
new kernel. An example of this last category is
MSR_IA32_ARCH_CAPABILITIES. We don't necessarily want to cede control
of such MSRs to kvm as soon as it knows about them. For instance, we
may want to wait until the new kernel reaches its rollback horizon.
There may be a few more MSRs we handle in userspace, but I think that
covers the bulk of them.

I don't believe we have yet seen a case where we wanted to take
control of an MSR that kvm didn't intercept itself. That part of
Aaron's patch may be overkill, but it gives the API clean semantics.
It seems a bit awkward to have a userspace MSR list where accesses to
some of the MSRs exit to userspace and accesses to others do not. (I
believe that your implementation of the allow list suffers from this
awkwardness, though I haven't yet had time to review it in depth.)

> My main problem with a deny list approach is that it's (practically)
> impossible to map the allow list use case onto it. It is however trivial
> to only deny a few select MSRs explicitly with an allow list approach. I
> don't want to introduce yet another ABI to KVM in 2 years to then have
> both :).

I agree in part. A deny list does not support your use case well. But
does an allow list support it that much better? I suspect that the
allow list that specifies "every MSR that kvm knows about today" is
far from trivial to construct, especially if you consider different
microarchitectures and different VM configurations (e.g. vPMU vs. no
vPMU).

Can we back up and ask what it is that you want to accomplish? If you
simply want ignore_msrs to be per-VM, wouldn't it be easier to add an
ioctl to simply set a boolean that potentially overrides the module
parameter, and then modify the ignore_msrs code to consult the per-VM
boolean?

Getting back to one of the issues I raised earlier: your "exit instead
of #GP" patch exits to userspace on both unknown MSRs and illegal
WRMSR values. If userspace wants to implement "ignore MSRs" for a
particular VM, it's absolutely trivial when the reason for the exit is
"unknown MSR." However, it becomes more complicated when the reason
for the exit is "#GP." Now, userspace has to know which MSRs are known
to kvm before it can decide whether or not the access should #GP.

I hope this doesn't come across sounding antagonistic. Like you, I
want to avoid revisiting this design a few years down the road. We're
already in that boat with the 2015 "exit on unknown MSR" change!
