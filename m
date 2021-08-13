Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E743EBAFA
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 19:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhHMREJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 13:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhHMREH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 13:04:07 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493A7C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 10:03:40 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so12848901otl.1
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 10:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Vya4fij45HvsBDaqcVVQb/ZojhWxXSw/4IGHIPsKPc=;
        b=B5oa4eLsgwBKkIaZo7fb1ppSOuy3QqGM1MR7mtbYDSBvglBdFQvhhxMPDU+fgRBuBM
         rBm8zcCHFJxE+mky6syjCUhoy4xlsXa34z77rsSpG0/MkI5UtMp049+BlP85+9l127hm
         7f823HSk1P3jzdmGlV9FEx9T2UJVu9K4NS/rXF1FhIpLNIaP9CGbJYGYRZPAU0n4Q0Tk
         xZ+qYJwdbrPaKX7wk2RgmVbanR051x4tIFhjl2QahRQGkPiJJtAO3KvVq4qOK0sMGnYw
         UtnLLIB+XLDONfCsvWNP3VepLFX8H1FZ2mupHn2HV/w65zrKz9jTys4vDA3d7pGDFCCB
         hBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Vya4fij45HvsBDaqcVVQb/ZojhWxXSw/4IGHIPsKPc=;
        b=ekwWz4TExYGJrihjkIpN4FF+ceXWYciCwDjytjFASi6wh+LRQiKMReOycLkgweFmUU
         DdTuGpEIG36UZ8nJ3U5d1Y6qHItsxk9nJzGvLBrQg2BTUZ4e/QYlYE9hXYYFHs1PO4vY
         jJczSU/6yEUKUg9CK+UTloLhxBcFpRCNPct5MTIrMKLsqot3P3aYh9YFAAk6/ROxAftM
         zbl0zp9hFKF54pm8yA7Qe/jlyp5Ah1kK8DgxpT2NJhfV9O0h0aGLBd3O4hEXT1LbApw8
         vyU5alL7xwpqteYu76yrFKWy3c5jNNkq7YkhEFyagQY1Cwp5kWhWpEec5hQA313xyjNp
         JxlA==
X-Gm-Message-State: AOAM530QNOQAyJh2gWf/J0B8CfnWVLJPmPtPxtvN/kpCTVnP9gtc7JKk
        uHHZ6HCnlIOD6gYKI3jzOB6JFIqKzDK1OMquU7AvUA==
X-Google-Smtp-Source: ABdhPJyLC0S+8Tt849HwLjAzYCsbpK6yyFSUuDrfiCPaGvqTNsSjPGWBRWDH4/fkUxOmIWWyhdboQgquxjqjpZMRf6Q=
X-Received: by 2002:a9d:76d0:: with SMTP id p16mr2924065otl.241.1628874219087;
 Fri, 13 Aug 2021 10:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200128092715.69429-1-oupton@google.com> <20200128092715.69429-5-oupton@google.com>
 <CALMp9eT+bbnjZ_CXn6900LxtZ5=fZo3-3ZLp1HL2aHo6Dgqzxg@mail.gmail.com> <YRafVro7jZoswngG@google.com>
In-Reply-To: <YRafVro7jZoswngG@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 13 Aug 2021 10:03:28 -0700
Message-ID: <CALMp9eR4_BFwoKGRC31hFo2ZX4iyF5k_APrW-hahqWbJ3cttLQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: nVMX: Emulate MTF when performing instruction emulation
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021 at 9:35 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 12, 2021, Jim Mattson wrote:
> > On Tue, Jan 28, 2020 at 1:27 AM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Since commit 5f3d45e7f282 ("kvm/x86: add support for
> > > MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
> > > flag processor-based execution control for its L2 guest. KVM simply
> > > forwards any MTF VM-exits to the L1 guest, which works for normal
> > > instruction execution.
> > >
> > > However, when KVM needs to emulate an instruction on the behalf of an L2
> > > guest, the monitor trap flag is not emulated. Add the necessary logic to
> > > kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
> > > instruction emulation for L2.
> > >
> > > Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
>
> ...
>
> > > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > > index 503d3f42da16..3f3f780c8c65 100644
> > > --- a/arch/x86/include/uapi/asm/kvm.h
> > > +++ b/arch/x86/include/uapi/asm/kvm.h
> > > @@ -390,6 +390,7 @@ struct kvm_sync_regs {
> > >  #define KVM_STATE_NESTED_GUEST_MODE    0x00000001
> > >  #define KVM_STATE_NESTED_RUN_PENDING   0x00000002
> > >  #define KVM_STATE_NESTED_EVMCS         0x00000004
> > > +#define KVM_STATE_NESTED_MTF_PENDING   0x00000008
> >
> > Maybe I don't understand the distinction, but shouldn't this new flag
> > have a KVM_STATE_NESTED_VMX prefix and live with
> > KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE, below?
>
> That does seem to be the case, seems highly unlikely SVM will add MTF.  And SVM's
> KVM_STATE_NESTED_GIF_SET should have been SVM specific, but kvm_svm_nested_state_hdr
> doesn't even reserve a flags field :-/

APIs are hard.
