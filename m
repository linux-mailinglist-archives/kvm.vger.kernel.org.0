Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A56746F82C
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 01:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhLJA6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 19:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbhLJA6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 19:58:15 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C978DC0617A1
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 16:54:41 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id v19-20020a4a2453000000b002bb88bfb594so2080491oov.4
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 16:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PWSk6caqvw2Au0Kq7gSkUUH//LBYrIaVkaVjdQPwyR4=;
        b=IOlMdKeYy196r8n0PAcOxjUB0ETIqkl1nL3Cw5mVz/oH8PLyC/QoJL5cFV5a0lo6P6
         jKIuocs2zxpr/Dwi1v3XG0qChzeCU+yKZgwlGV0mLk7I2RKrsf61AIHSOUPgN5aDrZmn
         KnjTcG98KkfZIMw99M3eIlx0IOZqg+vO1ffaOSrESbDCv3ZDK62DMLgWwxZJ6QDFihK5
         imbt51xWySK0Z5w7O42BaxpANJhTuwspB43Eb3nG4BeZL+Nlgq6zLzfBOwcXPhvc9TCW
         6QKP6Mjd7ABkOxZMJyu+Ag2tkWTpY6jDpUHfX4CqAXdiS4ZojngbazxSgOFtWV1+6fyN
         nrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWSk6caqvw2Au0Kq7gSkUUH//LBYrIaVkaVjdQPwyR4=;
        b=QmmbK8sss3DUUs9cuajLnaAwatQLW+jEEeC3Il8zksRfcOi3ZOlcj8F7NWDI8eK4Dz
         Ek3xz2K6LXfcf/5QqIQWSw5LQcsgIY0PwgNXsehN0brZFeK257A71wO6zXw7HaG94jiP
         8Rdne+8oOry2gkY+Cgt40GCB7g4THU4Z7rBeuGjbNldnVEVBzHxvPCIl+lg3rInbTx8z
         tY4ydcrkwdqFW8q9qsB3JBtm2l9drvQtbuSuKrvwfrMo2a5OTAjxNY6FhKxdy0nWJKCc
         Y9mNUXkx4fBjHjTorAwGi36F4SNo4LQO2sOE+T5CLNRIk1nt7k/CDVCOwuaa3ZaazOOh
         EFgQ==
X-Gm-Message-State: AOAM531afZIcV4kNmgQ8UJ0W0D9VvUwlwGYbw/dJrFsSxVrqK3uRyK8J
        BLOpvxnaoOhDtw5evPDAecTqDhyrWOpUWRKsrJNjLw==
X-Google-Smtp-Source: ABdhPJy3fxlViF5YsiaUrlmQ7lDKoLcWRAbIkuAC5QKtqf9Pu6c2RqE4NKgnir0c/u09WjzeRYQlcZ2YcGfsPnO1sbs=
X-Received: by 2002:a4a:d284:: with SMTP id h4mr6427005oos.31.1639097680669;
 Thu, 09 Dec 2021 16:54:40 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com> <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com>
In-Reply-To: <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Dec 2021 16:54:29 -0800
Message-ID: <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Andi Kleen <ak@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 9, 2021 at 12:28 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 9/12/2021 12:25 pm, Jim Mattson wrote:
> >
> > Not your change, but if the event is counting anything based on
> > cycles, and the guest TSC is scaled to run at a different rate from
> > the host TSC, doesn't the initial value of the underlying hardware
> > counter have to be adjusted as well, so that the interrupt arrives
> > when the guest's counter overflows rather than when the host's counter
> > overflows?
>
> I've thought about this issue too and at least the Intel Specification
> did not let me down on this detail:
>
>         "The counter changes in the VMX non-root mode will follow
>         VMM's use of the TSC offset or TSC scaling VMX controls"

Where do you see this? I see similar text regarding TSC packets in the
section on Intel Processor Trace, but nothing about PMU counters
advancing at a scaled TSC frequency.

> Not knowing if AMD or the real world hardware
> will live up to this expectation and I'm pessimistic.
>
> cc Andi and Kim.
>
