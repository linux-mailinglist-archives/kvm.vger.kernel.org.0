Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFD32F40B3
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436619AbhAMAnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 19:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391670AbhALXsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 18:48:39 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C0C061795
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 15:47:58 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id k7so82353ooa.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 15:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wU+Y/gAUBTmXheJG3ydpWv4eoAE0W44TF73lG0z05SY=;
        b=YkfvYKli+lhzT6+DsrEo+FG2LHvMQO5ByLVQ3neEErPCprAe/LgJec5KXyxTvwnjFN
         thuB0oL7Ja2wAmFyjKhylLNuMvOlh8CtVXpJ3bMOFBR/1nWxTi8p/O9jG6D0jszftGRw
         VUbBApNb1NJGu1UmPq43bLj7F/Zm/UEI2Wbv/2suIkDOQyuAODXqd0Wm3IziUjR1pHYY
         qt9TL4dTLkznLJL7NyswubcfwaEoyeCGtiqvN7cqcXYc7YikK22EPo9tXR8NAhQI1/FU
         0i9nrRfteUzs0JwqxtWmV90/YMSBTK7Anb+Md/DwZLZtQTpgGj28ZDNvmb0vjcvGf6Sn
         IpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wU+Y/gAUBTmXheJG3ydpWv4eoAE0W44TF73lG0z05SY=;
        b=Y5u7mw/93th+K45rKtXJGw59inckFAJjJ6bj1iZnr7Fgl7kubnMxnl0I9zm51G4bqr
         CWh1anzpT6rGLl/UUFi2/Z3d/dnNoOJfpwvL/S1pBWAaYf4EHodeWE+Q4fFK5vTtaVDq
         Xc8w0Kl+wBkuoOWgphxxsehDPVI4dFZpfJR1N+FnlZf021U8R37Z85WaXcLhUWFdD1bu
         Xlk4BE+LqRXAcIzaaS7cH5LfKGubEsCuLk4UOs9W26iCfeP2KqvO4+n8pmfBTzcu9ial
         OjBeQVuvqMJf35h0jtZkgvslC8emcXbX2hBVpOvf2yxvNOcC6/yKkyBZEx5i/EAe8YP/
         07eg==
X-Gm-Message-State: AOAM531XLgCJHaUaA/7yxUmw0LqjkI+zcZsd2zH6ChzLtYdVyKbHd2/x
        glFtvCw9Tf0V05uYtO3IrzNO29wOV797o3X3zQopkw==
X-Google-Smtp-Source: ABdhPJz39L3qom0ex/JRaSaofYUQQjf7qldbu8BRbz3uRE4CxDS29s3R6R8sVnJskGvctDVw1iJY74LivgWnz5GcVB4=
X-Received: by 2002:a4a:d396:: with SMTP id i22mr932339oos.55.1610495277816;
 Tue, 12 Jan 2021 15:47:57 -0800 (PST)
MIME-Version: 1.0
References: <20180401155444.7006-1-sf@sfritsch.de> <20180404171040.GW5438@char.us.oracle.com>
 <288c32e4-a1ec-7b43-0d6a-6a7c0e1a04b2@redhat.com> <1883982.uaQK4EgVKX@k> <321b36c9-d6fc-b562-5f87-3d3594e7ead9@redhat.com>
In-Reply-To: <321b36c9-d6fc-b562-5f87-3d3594e7ead9@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 Jan 2021 15:47:46 -0800
Message-ID: <CALMp9eR0OjUV7LsWQ_r4o20wSZ0dw0eGs=LJ0htLmwwvcuUP_A@mail.gmail.com>
Subject: Re: [PATCH] kvm: Add emulation for movups/movupd
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stefan Fritsch <sf@sfritsch.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 4, 2018 at 10:44 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/04/2018 19:35, Stefan Fritsch wrote:
> > On Wednesday, 4 April 2018 19:24:20 CEST Paolo Bonzini wrote:
> >> On 04/04/2018 19:10, Konrad Rzeszutek Wilk wrote:
> >>> Should there be a corresponding test-case?
> >>
> >> Good point!  Stefan, could you write one?
> >
> > Is there infrastructure for such tests? If yes, can you give me a pointer to
> > it?
>
> Yes, check out x86/emulator.c in
> https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git.  There is
> already a movaps test.

Whatever became of this unit test? I don't see it in the
kvm-unit-tests repository.
