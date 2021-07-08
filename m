Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155313C1A96
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 22:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhGHUiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 16:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhGHUiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 16:38:05 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A9DC06175F
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 13:35:22 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 62so7579209pgf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 13:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kl0UstyEraXY68jDpGmnd3NZGwUo8e2e0FemGce00zA=;
        b=upK5A0amrbf3n92/3nQS7H1OESzObIjFROsWcWUjkOiuGBxleLh8D0NffDK0PtGYhj
         LRx0tZd0qcE0SJ2ttMKhcP/aG/BYzUf1LYYslLhwKahW7aXxHcVP2kRjFTDq9Fiwf8Mv
         hpNkBcUQxg9PG5WxpEHjk7Aq7DM7D2BEzIfjrnCH1MoGpcFY7tzPHqI1B9OBr3xopg5O
         ODnFhYfO1ffXCsKbQ6Bj44y9ZFL+V6ihI7QLOfoRnpawnrL9aLmZMjkGK4btcbHK2it/
         Y/lv5/ROSozXE5pKT5ivGmD0Ie3oPGOLi6KgRCX3PfyNbMZZrsEuLNgJdtoT6NXEYSKa
         GL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kl0UstyEraXY68jDpGmnd3NZGwUo8e2e0FemGce00zA=;
        b=KHdhNdGDeZI1IFf3eeXr+/Pa0XpAErxJ2C+rsAIZ8zHryOow6MpLJ22XMXAUUvk3er
         2Q4JsFyxmigoRZGNaFKuIxtqjJLROLm6HtWkY+Eppx08MjvpWBGNv57kHm00EFwshv87
         1JtdEYiQtnGtKOVXj3JxPXpjlW22gYAVpFG/sIMw1wMO54RtbZBhKTNp//cV6zkDTeZI
         dG1fJ7Jrjmcmiv2dzDuHLw2PweqxM8VXUFdUctNcxcVoymHcZJtdasUnFMuhHjwrOWcf
         aA+3lUMN69VtUgxBVT1fL6yMmajqoJyCxNG+uChYciUkMuGlp88HQfLc0Le7hf+jVSwU
         YaOA==
X-Gm-Message-State: AOAM533X7DfJQE7b+W/Zc1jIWTXgTCYHlshaD0ehLwchXullJQgaYz2V
        nPmY5Qlj6OO3qKUF+lUq+9LB1g==
X-Google-Smtp-Source: ABdhPJwELSZtV6L9yMvFZoFOLERy4vbuKCApmnsERQW/tYcVHxntYe6X8UlC2G67TCntdHTVQRNXNw==
X-Received: by 2002:a65:5a41:: with SMTP id z1mr33360580pgs.130.1625776522024;
        Thu, 08 Jul 2021 13:35:22 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 20sm3804440pfi.170.2021.07.08.13.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 13:35:21 -0700 (PDT)
Date:   Thu, 8 Jul 2021 20:35:17 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] kvm: x86: Convey the exit reason to user-space on
 emulation failure
Message-ID: <YOdhhcjXEHUaMIFc@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <YOY2pLoXQ8ePXu0W@google.com>
 <m28s2g51q3.fsf@dme.org>
 <YOdGGuk2trw0h95x@google.com>
 <m2y2ag36od.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y2ag36od.fsf@dme.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021 at 09:13:38PM +0100, David Edmondson wrote:
> On Thursday, 2021-07-08 at 18:38:18 UTC, David Matlack wrote:
> 
> > On Thu, Jul 08, 2021 at 03:17:40PM +0100, David Edmondson wrote:
> >> Apologies if you see two of these - I had some email problems earlier.
> >
> > I only got one! :)
> 
> Phew!
> 
> >> On Wednesday, 2021-07-07 at 23:20:04 UTC, David Matlack wrote:
> >> 
> >> > On Tue, Jul 06, 2021 at 11:12:05AM +0100, David Edmondson wrote:
> >> >> To help when debugging failures in the field, if instruction emulation
> >> >> fails, report the VM exit reason to userspace in order that it can be
> >> >> recorded.
> >> >
> >> > What is the benefit of seeing the VM-exit reason that led to an
> >> > emulation failure?
> >> 
> >> I can't cite an example of where this has definitively led in a
> >> direction that helped solve a problem, but we do sometimes see emulation
> >> failures reported in situations where we are not able to reproduce the
> >> failures on demand and the existing information provided at the time of
> >> failure is either insufficient or suspect.
> >> 
> >> Given that, I'm left casting about for data that can be made available
> >> to assist in postmortem analysis of the failures.
> >
> > Understood, thanks for the context. My only concern would be that
> > userspace APIs are difficult to change once they exist.
> 
> Agreed.
> 
> > If it turns out knowing the exit reason does not help with debugging
> > emulation failures we'd still be stuck with exporting it on every
> > emulation failure.
> 
> We could stop setting the flag and never export it, but this would waste
> space in the structure and be odd, without doubt.
> 
> > My intuition is that the instruction bytes (which are now available with
> > Aaron's patch) and the guest register state (which is queryable through
> > other ioctls) should be sufficient to set up a reproduction of the
> > emulation failure in a kvm-unit-test and the exit reason should not
> > really matter. I'm curious if that's not the case?
> 
> The instruction bytes around the reported EIP are all zeroes - the
> register dump looks suspect, and doesn't correspond with the reported
> behaviour of the VM at the time of the failure.

Interesting... Nothing comes to mind but others on this list might have
a suggestion of where to look next.

> 
> It's possible that Aaron's changes will help, indeed, given that they
> report state from within the instruction emulator itself. So far I don't
> have a sufficiently reproducible case to be able to see if that is the
> case.
> 
> > I'm really not opposed to exporting the exit reason if it is useful, I'm
> > just not sure it will help.
> 
> In the emulation failure case we are not in something I would consider a
> fast path, and the overhead of acquiring and reporting the exit reason
> is low.

Agreed. I'm not worried about performance, only code complexity and
bloat in the userspace API. But as you suggested above we could always
stop setting the flag and remove the code that populates the exit reason
if it turns out to not be useful. The field in kvm_run is the only thing
that could be hard to remove in the future.

> 
> Do you anticipate a case where it would be inappropriate or expensive to
> report the reason?
> 
> >> 
> >> >> I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
> >> >> to use the emulation_failure part of the exit union in struct kvm_run
> >> >> - advice welcomed.
> >> >> 
> >> >> v2:
> >> >> - Improve patch comments (dmatlack)
> >> >> - Intel should provide the full exit reason (dmatlack)
> >> >> - Pass a boolean rather than flags (dmatlack)
> >> >> - Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
> >> >>   (dmatlack)
> >> >> - Describe the exit_reason field of the emulation_failure structure
> >> >>   (dmatlack)
> >> >> 
> >> >> David Edmondson (2):
> >> >>   KVM: x86: Add kvm_x86_ops.get_exit_reason
> >> >>   KVM: x86: On emulation failure, convey the exit reason to userspace
> >> >> 
> >> >>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >> >>  arch/x86/include/asm/kvm_host.h    |  3 +++
> >> >>  arch/x86/kvm/svm/svm.c             |  6 ++++++
> >> >>  arch/x86/kvm/vmx/vmx.c             | 11 +++++++----
> >> >>  arch/x86/kvm/x86.c                 | 22 +++++++++++++---------
> >> >>  include/uapi/linux/kvm.h           |  7 +++++++
> >> >>  6 files changed, 37 insertions(+), 13 deletions(-)
> >> >> 
> >> >> -- 
> >> >> 2.30.2
> >> >> 
> >> 
> >> dme.
> >> -- 
> >> It's gettin', it's gettin', it's gettin' kinda hectic.
> 
> dme.
> -- 
> Please forgive me if I act a little strange, for I know not what I do.
