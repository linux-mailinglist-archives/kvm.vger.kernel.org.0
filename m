Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DFB3C27E4
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 19:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhGIREu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 13:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGIREt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 13:04:49 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59270C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 10:02:06 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id f12-20020a056830204cb029048bcf4c6bd9so10094364otp.8
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 10:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nh9/iNzoFNEIgyZu/Qlm8/4wVhFn8ycrPC1i/L8PYJw=;
        b=RGwMWLLhK2+AOE285PRCDhZC45szeGyR65RdsTakJNvgutrQToMEUWI8Dm3aDg+70w
         LwYctokSSTVcBSA1WxUQUx4sC4V5agmSmTt1qLBJ19YTTnGPz2Y0R3sNHvLiUHghh5hN
         lXQKyUOZOYHhPqM+Vsa+RdEEvpf31gG4oXiFmeLyOkE+uMh9zXa4NfiDSo7DHduw6KB5
         naqQMhlnb9Alsj6Dx9LTjNrza5ru58JzzIxjK9D0leJacXHWii+hv96Anger2Pehdfz4
         qUbL0d5vgWRP4oBN+XF6vKrOZwsX7lMQgv5M7ofSUk58LVIRAPSVt83+olp6NbX3NgyL
         rpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nh9/iNzoFNEIgyZu/Qlm8/4wVhFn8ycrPC1i/L8PYJw=;
        b=ASkrcOcBxc8OgY9yM/6XKagQ/o2a8mbxxrWmjKEv0rkloWfsWebUZgRCE1TNl3Zoob
         LRvO9HscGbOdvqVIHnuZdc2zY8pbppVRj3QHQemkdyhew/HGFMPFy9XA4E3hqgnr2hOI
         akiccXAF2x0TLaVw7CmzEq5JLZKnsd96GcaWIg08fTlijPvb5MODti1Axipb9pDJG5LZ
         7yTzqG8xvcsz6Lc029zlwIWav860uQ47TDTIa3QOQSje91nppsRoitManrN3zvtneLpQ
         pf6lKzNLyaxpnWyn6eHierD5LUogDwH09JtEiH7dIQqf8qVTUIieUfxLpXTG7CzEj/70
         01Aw==
X-Gm-Message-State: AOAM532K3hYvATRF2j/XkFI21tDZfoevcX7MIKMe4L3k/hf6Z6gFma0i
        RgV4RKQvsRTa7gyEjpITrqHtLyNH7y37gThKXWRz6g==
X-Google-Smtp-Source: ABdhPJzwEnMHC1LMMeMjfcvzNaL2InBapCK+/72lVd2Enw+TfAGE6vJiniiuNb9kp6NKu3TkLfqWhH1VoYtQU6fu/68=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr30322349oth.241.1625850125274;
 Fri, 09 Jul 2021 10:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210628172632.81029-1-jiangshanlai@gmail.com>
 <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com> <c79d0167-7034-ebe2-97b7-58354d81323d@linux.alibaba.com>
 <397a448e-ffa7-3bea-af86-e92fbb273a07@redhat.com> <a4e07fb1-1f36-1078-0695-ff4b72016d48@linux.alibaba.com>
 <01946b5a-9912-3dfb-36f0-031f425432d2@redhat.com> <CALMp9eQWnUM-O7VmMWTGE2C2YraWxM2K0QcOQnbkctkzg_1pUA@mail.gmail.com>
 <bac2de6d-ae6d-565d-38f2-0c46b06cee0f@redhat.com>
In-Reply-To: <bac2de6d-ae6d-565d-38f2-0c46b06cee0f@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 10:01:54 -0700
Message-ID: <CALMp9eRrPtidJOamfSnkHT-PnPRXZ7SXkw9JFW-Q38v0Q-ws5w@mail.gmail.com>
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

On Fri, Jul 9, 2021 at 9:59 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/07/21 18:35, Jim Mattson wrote:
> >>>> Just what you said, it's not easy and the needs are limited.  I
> >>>> implemented kvm_vcpu_check_breakpoint because I was interested in
> >>>> using hardware breakpoints from gdb, even with unrestricted_guest=0
> >>>> and invalid guest state, but that's it.
> >>> It seems kvm_vcpu_check_breakpoint() handles only for code breakpoint
> >>> and doesn't handle for data breakpoints.
> >> Correct, there's a comment above the call.  But data breakpoint are much
> >> harder and relatively less useful.
> >
> > Data breakpoints are actually quite useful. I/O breakpoints not so much.
>
> Normally yes; much less for the specific case of debugging
> invalid-guest-state or other invocations of the emulator.

Agreed. But if they don't actually work in-guest (because the emulator
ignores them), then their normal usefulness is curtailed.
