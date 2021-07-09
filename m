Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC63C27A3
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhGIQis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 12:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhGIQis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 12:38:48 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B63C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 09:36:04 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id z18-20020a9d7a520000b02904b28bda1885so8556185otm.7
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 09:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPJc57zXKNbmm6Wda6Wo2yhPL66N0K7mX7Ni/9wA22A=;
        b=MLhRmhg31B/NqMjA2W3smAusHRT7XDvc2hG4HgIGIn0JTGEdMDa45XXhOMirJW1j4E
         CwQteVMF1OM0UkapniXaSksq8EBVbqXIHhLkmN2KY3s7i1uJ13FxA2dMGLRejl4H836E
         59dTDDPVDkxWC/s+vYz9Pn7andHFbqorbs3C97CpJt8ameRLbeKfzFT2KHZV+IwSHmH/
         VsiwT9OSNAK6jezJJzPy3UEUTe/dWCAKFob1CDk2u5RsbyR+YlhUQbiEHBpbqw87y1Nw
         W8k9sgwbLdpgTS27koSUOrVv41azZR7wU1tmMVTeequSaY2NKWTK7nmREjnTaWt6EkDt
         2MKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPJc57zXKNbmm6Wda6Wo2yhPL66N0K7mX7Ni/9wA22A=;
        b=PNbzNMgBZG1AEQuvk3unbKu3W1REU6myqUdzeuZDlYfYP1z2t9CmP06Gi64kVSwKD/
         SOrk2XCC3N8h200E0CPsD7kz1NlsbG42HE6uMd4Hw8HOryDQyp0g6eUzq6BxgPRp22DZ
         QmQoV2ValEB3Za+RZ9emLW2+NadKfh+VJ2hi1p+QgeZU/lflvvcIAosStXRAXhg4B7wb
         wJhX4OlFjbuEkyfEKMXZZHyif+0/l3SwzzsxlP02suRH2pV1NaVrEm3Q2lk+P+H2D1zE
         UmJINejXEyAh2boQFrFkL8oVteYMCeoImtuONOCk8YQkekG07hOKstMbnYTgiQXw/wlG
         ES1Q==
X-Gm-Message-State: AOAM533AJBrKeQcCwQvd4lkdG7+uMf9/M2FCIHUZOerINsFtL91/DfbD
        H22n1MMG8LMpW6uMtu5D6OZaX5NMvMS3TkXd3VQzWg==
X-Google-Smtp-Source: ABdhPJzmi7sJ7IjCj6kOY34d6qrQNMR5UNqyGmph22ptlmZ5SLYcWRXGTXDYBGh3Qm9ILS/PCo+NwsupNOdicOaAmU8=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr30228676oth.241.1625848563120;
 Fri, 09 Jul 2021 09:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210628172632.81029-1-jiangshanlai@gmail.com>
 <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com> <c79d0167-7034-ebe2-97b7-58354d81323d@linux.alibaba.com>
 <397a448e-ffa7-3bea-af86-e92fbb273a07@redhat.com> <a4e07fb1-1f36-1078-0695-ff4b72016d48@linux.alibaba.com>
 <01946b5a-9912-3dfb-36f0-031f425432d2@redhat.com>
In-Reply-To: <01946b5a-9912-3dfb-36f0-031f425432d2@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 09:35:30 -0700
Message-ID: <CALMp9eQWnUM-O7VmMWTGE2C2YraWxM2K0QcOQnbkctkzg_1pUA@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Also reload the debug registers before
 kvm_x86->run() when the host is using them
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 8:52 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/07/21 12:05, Lai Jiangshan wrote:
> >
> >
> > On 2021/7/9 17:49, Paolo Bonzini wrote:
> >> On 09/07/21 05:09, Lai Jiangshan wrote:
> >>> I just noticed that emulation.c fails to emulate with DBn.
> >>> Is there any problem around it?
> >>
> >> Just what you said, it's not easy and the needs are limited.  I
> >> implemented kvm_vcpu_check_breakpoint because I was interested in
> >> using hardware breakpoints from gdb, even with unrestricted_guest=0
> >> and invalid guest state, but that's it.
> >
> > It seems kvm_vcpu_check_breakpoint() handles only for code breakpoint
> > and doesn't handle for data breakpoints.
>
> Correct, there's a comment above the call.  But data breakpoint are much
> harder and relatively less useful.

Data breakpoints are actually quite useful. I/O breakpoints not so much.

> > And no code handles DR7_GD bit when the emulation is not resulted from
> > vm-exit. (for example, the non-first instruction when kvm emulates
> > instructions back to back and the instruction accesses to DBn).
>
> Good point, that should be fixed too.
>
> Paolo
>
