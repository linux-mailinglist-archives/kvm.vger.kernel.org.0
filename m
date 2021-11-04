Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADC64450EB
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 10:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhKDJNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 05:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhKDJNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 05:13:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50166C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 02:11:08 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id j5so8344861lja.9
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 02:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ip4jIKzplcPRjOqExcXRBQqPqAPXrq235jk6EqfK8sA=;
        b=Ajj9xGu0eMeaOm/pl+F3O4w34Y56ucIS1YivaQBUsztCkIODJSzEomzA8LyYwWDhIv
         gL4GafSII/OrRNlmeVnclC/zVYk+T//wrPlyD/ksgrxvgeA82um0lcBr8G4qDc3xCJsQ
         HpK4IiT/8yrDHY95CZO0fe4r0yALgFqeTpFBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ip4jIKzplcPRjOqExcXRBQqPqAPXrq235jk6EqfK8sA=;
        b=xr1E1wfnGRVKKdDnh2u9v8VGDSbgnFEzA0/N3a5HZAZ7XUk0Yskh0HjVyBf7GsMGEv
         +gAFYNwGe5VVMIMTeYFHQd7Rusv6vKzAbFkuBr+lWcbP+wvguT8DQ2KB2eM0i6+bVufF
         kefdxe+Mc41pqzQ5BBB6BGVg0KjIWf1PRyS5KPg1bqQhD2He7ophrVAvAzKGwf/fwS7L
         Vy0F8Zl1jOMXdF/l8vUmVwDzUVolfXpWgNDksGpx7WHpwGo7jFzTkEvqUGjDo1GMIl/S
         UpUauPG7zgE215jGyXuHXXOrxCZHhDXREkarn4vwWRCfZP7kk1Zgzhr5/MXHEwMfqjKA
         ywCA==
X-Gm-Message-State: AOAM530ES7JPfVml/Ij8Tnt3+867cxSfHqoW5hYLLdY+xlrhD3SXBLpw
        nqboQLSlb8CN7vxrvgcfK7HAj07YkR/Yh8qdx7t4aw==
X-Google-Smtp-Source: ABdhPJy8fhKodASuD5SKo5rDH8OmLdPRdEwIa15ljtPKQs6a7cExLx0VBmUmWvEB+7WHB09t29utQs4L5T2n+YQsf8E=
X-Received: by 2002:a2e:b5d2:: with SMTP id g18mr18870481ljn.282.1636017066544;
 Thu, 04 Nov 2021 02:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211020120431.776494-1-hikalium@chromium.org> <874k9bdcrk.wl-maz@kernel.org>
In-Reply-To: <874k9bdcrk.wl-maz@kernel.org>
From:   Hikaru Nishida <hikalium@chromium.org>
Date:   Thu, 4 Nov 2021 18:10:55 +0900
Message-ID: <CACTzKb+vVU0Ymh2Nx5B6kSydBsJ6AgrbQMF39RFvqoHpvL_riw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] x86/kvm: Virtual suspend time injection support
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
        vkuznets@redhat.com, will@kernel.org, suleiman@google.com,
        senozhatsky@google.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Thanks for the comments! (Sorry for the late reply)

On Wed, Oct 20, 2021 at 10:52 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Hikaru,
>
> On Wed, 20 Oct 2021 13:04:25 +0100,
> Hikaru Nishida <hikalium@chromium.org> wrote:
> >
> >
> > Hi,
> >
> > This patch series adds virtual suspend time injection support to KVM.
> > It is an updated version of the following series:
> > v2:
> > https://lore.kernel.org/kvm/20210806100710.2425336-1-hikalium@chromium.org/
> > v1:
> > https://lore.kernel.org/kvm/20210426090644.2218834-1-hikalium@chromium.org/
> >
> > Please take a look again.
> >
> > To kvm/arm64 folks:
> > I'm going to implement this mechanism to ARM64 as well but not
> > sure which function should be used to make an IRQ (like kvm_apic_set_irq
> > in x86) and if it is okay to use kvm_gfn_to_hva_cache /
> > kvm_write_guest_cached for sharing the suspend duration.
>
> Before we discuss interrupt injection, I want to understand what this
> is doing, and how this is doing it. And more precisely, I want to find
> out how you solve the various problems described by Thomas here [1].

The problems described by Thomas in the thread was:
- User space or kernel space can observe the stale timestamp before
the adjustment
  - Moving CLOCK_MONOTONIC forward will trigger all sorts of timeouts,
watchdogs, etc...
- The last attempt to make CLOCK_MONOTONIC behave like CLOCK_BOOTTIME
was reverted within 3 weeks. a3ed0e4393d6 ("Revert: Unify
CLOCK_MONOTONIC and CLOCK_BOOTTIME")
  - CLOCK_MONOTONIC correctness (stops during the suspend) should be maintained.

I agree with the points above. And, the current CLOCK_MONOTONIC
behavior in the KVM guest is not aligned with the statements above.
(it advances during the host's suspension.)
This causes the problems described above (triggering watchdog
timeouts, etc...) so my patches are going to fix this by 2 steps
roughly:
1. Stopping the guest's clocks during the host's suspension
2. Adjusting CLOCK_BOOTTIME later
This will make the clocks behave like the host does, not making
CLOCK_MONOTONIC behave like CLOCK_BOOTTIME.

First one is a bit tricky since the guest can use a timestamp counter
in each CPUs (TSC in x86) and we need to adjust it without stale
values are observed by the guest kernel to prevent rewinding of
CLOCK_MONOTONIC (which is our top priority to make the kernel happy).
To achieve this, my patch adjusts TSCs (and a kvm-clock) before the
first vcpu runs of each vcpus after the resume.

Second one is relatively safe: since jumping CLOCK_BOOTTIME forward
can happen even before my patches when suspend/resume happens, and
that will not break the monotonicity of the clocks, we can do that
through IRQ.

[1] shows the flow of the adjustment logic, and [2] shows how the
clocks behave in the guest and the host before/after my patches.
The numbers on each step in [1] corresponds to the timing shown in [2].
The left side of [2] is showing the behavior of the clocks before the
patches, and the right side shows after the patches. Also, upper
charts show the guest clocks, and bottom charts are host clocks.

Before the patches(left side), CLOCK_MONOTONIC seems to be jumped from
the guest's perspective after the host's suspension. As Thomas says,
large jumps of CLOCK_MONOTONIC may lead to watchdog timeouts and other
bad things that we want to avoid.
With the patches(right side), both clocks will be adjusted (t=4,5) as
if they are stopped during the suspension. This adjustment is done by
the host side and invisible to the guest since it is done before the
first vcpu run after the resume. After that, CLOCK_BOOTTIME will be
adjusted from the guest side, triggered by the IRQ sent from the host.

[1]: https://hikalium.com/files/kvm_virt_suspend_time_seq.png
[2]: https://hikalium.com/files/kvm_virt_suspend_time_clocks.png


>
> Assuming you solve these, you should model the guest memory access
> similarly to what we do for stolen time. As for injecting an
> interrupt, why can't this be a userspace thing?

Since CLOCK_BOOTTIME is calculated by adding a gap
(tk->monotonic_to_boot) to CLOCK_MONOTONIC, and there are no way to
change the value from the outside of the guest kernel, we should
implement some mechanism in the kernel to adjust it.
(Actually, I tried to add a sysfs interface to modify the gap [3], but
I learned that that is not a good idea...)

[3]: https://lore.kernel.org/lkml/87eehoax14.fsf@nanos.tec.linutronix.de/

Thank you,

Hikaru Nishida

>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/all/871r557jls.ffs@tglx
>
>
> --
> Without deviation from the norm, progress is not possible.
