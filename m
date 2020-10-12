Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717428BF47
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403772AbgJLR4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 13:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390827AbgJLR4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 13:56:08 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A73C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 10:56:07 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id f10so16618368otb.6
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 10:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynshGyGxXH52PDD9UJq4+1p/woBGcxlKFru5YAED32M=;
        b=POgI3WcbpTYW+8ffmyMUk4x1++KXNeKgKUGLzte25A/6bMOLN3G5IgnZuN4XlXfTPO
         feeVdNw9KM0QHaabRz1hRcUwQa/qsSlKeGd5SFRIas6RbArXiu3V/Xb3ljywiJyC+Tt9
         MtE+QrfepaKBDKWYpj2u3TrAMAl+xCiCkUKBvAlbRldw1yuIPt3KUN7jZf8OMImoK8jr
         kt489b9sn6YGRYnj8oV9spNwRdMdiyL/QLdBWuXjhaat/kiAz705aPdtroHMjq73r2Ns
         uJM8NP8vjz/M3UsnQ6eStcC0kem1RkwnCu+IJbwkTmyTCL8pVl+8LyqGB+szJwOsmYLO
         Mq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynshGyGxXH52PDD9UJq4+1p/woBGcxlKFru5YAED32M=;
        b=VS1LYmBxpnSPX+mIITQ3iIdONhOvSucuRh2Zfccl7PEZk2vmUlYai3HUCl4rNYG/6V
         PIqVOwRgunqqr4VfWHOxWHU866kXPx0ZPxaX9+1J7JIEaulpX8LnIKjUuLXKvV06vWQd
         eWnAVdgeuXqdZKU4NiR5OkIkSMNBFNyAcE2Rgzv5duDTWiLvl2MFFmqDYHpkZ6gPW1Jo
         XEVHSN7EDf7WYcbp9/jqvvYkcCY48Uiu5w1JESeLgCBuR7Hm9QUh8vLQa7F+SfXXy2zV
         s/P0kkqkBkoJfo79Zf54HCkvis6R5FfMfwgLRDoeO2vWUbRBed5wNyg5NdTfX5fmuCtb
         EGsw==
X-Gm-Message-State: AOAM5324dbANrjsGFdHRjKA38OnP9G1RK/Z1tKxXTX6wdY61a8Hk8Ws9
        zYlEqrp2oHhdPp2E9zzDWy67zuYSS7DAoKTpHOqMBA==
X-Google-Smtp-Source: ABdhPJzeUyd/W+apsqkqIut4CuK8ngIZxJKwJ5bxKCm6fnJ6xnUXIuAiAClJ8OQJDyTqUbnTa4VqeYhbsXlzgO8a9lw=
X-Received: by 2002:a9d:51c4:: with SMTP id d4mr7169650oth.56.1602525366360;
 Mon, 12 Oct 2020 10:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200508203938.88508-1-jmattson@google.com> <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com> <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
In-Reply-To: <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Oct 2020 10:55:54 -0700
Message-ID: <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I don't know of any relevant hardware errata. The test verifies that
the implementation adheres to the architectural specification.

KVM clearly doesn't adhere to the architectural specification. I don't
know what is wrong with your Broadwell machine.

On Mon, Oct 12, 2020 at 9:47 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Oct 12, 2020, at 9:32 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >
> > On Sat, Oct 10, 2020 at 01:42:26AM -0700, Nadav Amit wrote:
> >>> On May 8, 2020, at 1:39 PM, Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> When the VMX-preemption timer is activated, code executing in VMX
> >>> non-root operation should never be able to record a TSC value beyond
> >>> the deadline imposed by adding the scaled VMX-preemption timer value
> >>> to the first TSC value observed by the guest after VM-entry.
> >>>
> >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> >>> Reviewed-by: Peter Shier <pshier@google.com>
> >>
> >> This test failed on my bare-metal machine (Broadwell):
> >>
> >> Test suite: vmx_preemption_timer_expiry_test
> >> FAIL: Last stored guest TSC (44435478250637180) < TSC deadline (44435478250419552)
> >>
> >> Any hints why, perhaps based on the motivation for the test?
> >
> > This test also fails intermittently on my Haswell and Coffee Lake systems when
> > running on KVM.  I haven't done any "debug" beyond a quick glance at the test.
> >
> > The intent of the test is to verify that KVM injects preemption timer VM-Exits
> > without violating the architectural guarantees of the timer, e.g. that the exit
> > isn't delayed by something else happening in the system.
>
> Thanks for testing it. I was wondering how come KVM does not experience such
> failures.
>
> I figured the basic motivation of the patch, but I was wondering whether
> there is some errata that the test is supposed to check.
>
