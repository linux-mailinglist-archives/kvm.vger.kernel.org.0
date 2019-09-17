Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6F7B55D4
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 21:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfIQTAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 15:00:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33192 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbfIQTAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 15:00:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id b9so4362510wrs.0
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 12:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0WTIFwekZGAl1Tv2OjE0SPQeY0xfvNp1exHguftDhs8=;
        b=VoB3mARQNWCWu3/yUQSrvKVr8uiD1SBYImYjk7m0LC6xGUBs1I0/Mzq+siWLkTq7KN
         /nIKRfwyKcJWrN2k7Z2nmRHIdkNPGvEdoke0uQEo0wi90PMY/ZUc/pMrwpUG2FDwOst3
         AxQR1cQR4XlXLSuvoVSRz+AQNzoM70bIvr3mj4MVA9zdxn5ZVaP/Jj/on/HNoW6FYsB7
         2qMwSn0PPjpUMBfb9j0PzhUr7Owctt5JPsER9kTa1irQkoLgcryvKkSnlOBJhvaGs4Lh
         zF6E+0qZ99JoyqlgnjzXDhkz9eKGoUAQr+BlZ9iR60RUFvBmw+LJdX6czPu0cY/Cd3H3
         SYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0WTIFwekZGAl1Tv2OjE0SPQeY0xfvNp1exHguftDhs8=;
        b=il1XU28VpnhyklY5AJsPlNDNo0EKv8OpX2SV68RAaLBjqq9XqoKi1mIBFggu4uTHAP
         0oMSJZIM40K87F4YKnH9WqjuoCs4g6XSXoOL9SYfr14oxovaOJ+g10XQgWSUp3dRwrkV
         08ny1tZAsT4XQcSCZINyEE3/EkkYMuOsScLemIS2b4DrcG+E9csagSp5QN+KyIQg575x
         cvtajbiyZ9ob5K5DXvvid6ar/pYO2NRd92a6ffm3Ok+4hptaX16PxfYpA77Sd6YUaZyd
         SIUvZD2FVEpDYFTZNA85+H7XApM7NOamZbddASPLEtLqZaw42yGbmqEpvXSecbbeexYh
         LFNw==
X-Gm-Message-State: APjAAAWjMYFTMZabNaTJK61CC328rBSeKaBoZa9peY5nGzTIHhUByFjB
        IMXMfjMK/pu0Pd5C3IEH8l3zEmUTX20VTokpwqIo0g==
X-Google-Smtp-Source: APXvYqwyuXMiK+6oe7R6uVtcu+6q2fTVP0hk64lf8NJxJnxSFgdDG0WizVSBVbjqTJlI8/cDw+sTvL4M1/84zHF02mk=
X-Received: by 2002:adf:e9ce:: with SMTP id l14mr95776wrn.264.1568746833582;
 Tue, 17 Sep 2019 12:00:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190914003940.203636-1-marcorr@google.com> <20190916230229.GO18871@linux.intel.com>
In-Reply-To: <20190916230229.GO18871@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 17 Sep 2019 12:00:22 -0700
Message-ID: <CAA03e5FEwWi30pS2b4XMHfeuJg0RoNixr_VvjE87L0-rGBfoOA@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: nvmx: limit atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Allowing an unlimited number of MSRs to be specified via the VMX
> > load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> > reasons. First, a guest can specify an unreasonable number of MSRs,
> > forcing KVM to process all of them in software. Second, the SDM bounds
> > the number of MSRs allowed to be packed into the atomic switch MSR lists.
> > Quoting the "Miscellaneous Data" section in the "VMX Capability
> > Reporting Facility" appendix:
> >
> > "Bits 27:25 is used to compute the recommended maximum number of MSRs
> > that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> > list, or the VM-entry MSR-load list. Specifically, if the value bits
> > 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> > maximum number of MSRs to be included in each list. If the limit is
> > exceeded, undefined processor behavior may result (including a machine
> > check during the VMX transition)."
> >
> > Thus, force a VM-entry to fail due to MSR loading when the MSR load
> > list is too large. Similarly, trigger an abort during a VM exit that
> > encounters an MSR load list or MSR store list that is too large.
>
> It's probably redundant/obvious, but I think it's worth calling out that
> this is arbitrary KVM behavior, e.g. replace "Thus," with something like:
>
>   Because KVM needs to protect itself and can't model "undefined processor
>   behavior", arbitrarily
>
> The changelog (and maybe a comment in the code) should also state that
> the count is intentionally not pre-checked so as to maintain compability
> with hardware inasmuch as possible.  That's a subtlety that's likely to
> lead to "cleanup" in the future :-)

Done.

> Code itself looks good, with the spurious vmx_control_msr() removed.

Done.
