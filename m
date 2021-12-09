Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478DC46F316
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhLISbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbhLISbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:31:41 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36962C0617A1
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:28:08 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id m24so4509685pls.10
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvBPGp5MJ07YRQOMUwXfLmMJ6dHOOSwPc5qG1seRKfY=;
        b=hJXvKPK++7eGyJS3RkCH3fdGYPs2uYdOnLAm0K4mLbCyNIdaSmZ4Rd4iGcaHqlLqxx
         wy+Qx+f9X5tMb7EiVzFGRL58E8HjMF26+IaN7kRKQqDC/erlB+YyivlUsCv6QSDGMabl
         k6bx8WO22i0uQV28Lujiw+X9Ddr5hU33TNOcnFtPEhl86V6Ei/oTtQ5YlVBdgrW5eFYC
         nVSfRLoMhNHmM2nZ+SFQeUv6jZRDIXxiVRAYECdnaIeujDI8z9pbyyJwNIn01j316uJl
         JLzvxgdi0DkKTj1JYOypVg2VmMsQldhjhTZBh3YT+PppmWuhMXGTdcE26gpWBkQ8dWdS
         N4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvBPGp5MJ07YRQOMUwXfLmMJ6dHOOSwPc5qG1seRKfY=;
        b=SoPDG26pgexpRINoTot+kmwLdMJh6uS8GOQIZl/CaP8eQLbg4Chy/iR4z2DXtM9Gdt
         Fk32v9YakNw3/HELMw/MTtvomIsz6sZ4A50V3XKt8LdnyI0F3gR+umnAkvFePV7ngVU/
         i6nS/Wf71QIZ65IFAaWtXk+Y1NNYYFyydEP3RJGAvrCpFgfBTAzRquaSjMJ3TvWf7Xuo
         YFqslYspCTaHcHYmB75gZyb6gDGEUt55hYb9EVDxJ63INWHtJCTxV11mHzMhCR27QWZN
         0AwXlxIvBrXekC8JCGQMTUEQuRBsLZ5wE8OFUhMDNm1Y0kAIQOc9MkEszgI81TzJQ6yJ
         YgCg==
X-Gm-Message-State: AOAM531/ayp0A7Mu05Ul3soA8GX0QaLdwl45jjEKJY1dY5tuBgtE3vUV
        mva1SpfRCiwKufTueGCKAVEwOnuiMsNpjoT8ISAgmg==
X-Google-Smtp-Source: ABdhPJzeKpn5m4+3PWIDhrUxTmGP4vJZk0PJ0vVlHtb91UaiIz0e/uhsOe2ji8SB7UdteXvd8una101CqCrZ6rIp3+w=
X-Received: by 2002:a17:90b:3ecc:: with SMTP id rm12mr17580586pjb.75.1639074487426;
 Thu, 09 Dec 2021 10:28:07 -0800 (PST)
MIME-Version: 1.0
References: <20211209155257.128747-1-marcorr@google.com> <5f8c31b4-6223-a965-0e91-15b4ffc0335e@redhat.com>
 <CALMp9eThf3UtvoLFjajkrXtvOEWQvc8_=Xf6-m6fHXkOhET+GA@mail.gmail.com> <YbJJXKFevTV/L3in@google.com>
In-Reply-To: <YbJJXKFevTV/L3in@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Dec 2021 10:27:56 -0800
Message-ID: <CALMp9eTMm474vAXg--WKecLh4tPROFcTPtSbdEdptPHC-c-ggg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Always set kvm_run->if_flag
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Orr <marcorr@google.com>,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        thomas.lendacky@amd.com, mlevitsk@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 9, 2021 at 10:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 09, 2021, Jim Mattson wrote:
> > On Thu, Dec 9, 2021 at 9:48 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 12/9/21 16:52, Marc Orr wrote:
> > > > The kvm_run struct's if_flag is a part of the userspace/kernel API. The
> > > > SEV-ES patches failed to set this flag because it's no longer needed by
> > > > QEMU (according to the comment in the source code). However, other
> > > > hypervisors may make use of this flag. Therefore, set the flag for
> > > > guests with encrypted registers (i.e., with guest_state_protected set).
> > > >
> > > > Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> > > > Signed-off-by: Marc Orr<marcorr@google.com>
> > >
> > > Applied, though I wonder if it is really needed by those other VMMs
> > > (which? gVisor is the only one that comes to mind that is interested in
> > > userspace APIC).
> >
> > Vanadium appears to have one use of it.
> >
> > > It shouldn't be necessary for in-kernel APIC (where userspace can inject
> > > interrupts at any time), and ready_for_interrupt_injection is superior
> > > for userspace APIC.
> >
> > LOL. Here's that one use...
> >
> > if (vcpu_run_state_->request_interrupt_window &&
> > vcpu_run_state_->ready_for_interrupt_injection &&
> > vcpu_run_state_->if_flag) {
> > ...
> > }
> >
> > So, maybe this is much ado about nothing?
>
> I assume the issue is that SEV-ES always squishes if_flag, so that above statement
> can never evaluate true.

If that's the only use, though, it's pretty easy to just remove that conjunct.
