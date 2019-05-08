Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161BC18297
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfEHXL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 19:11:56 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46320 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfEHXL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 19:11:56 -0400
Received: by mail-io1-f65.google.com with SMTP id m14so107617ion.13
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 16:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JgcGkH9zIchXryBzpe+vAmJYy9gUucLQHyUH47Okfhc=;
        b=izikx642ZFpaCMsNwj++KlELmWJ6wOMBZV/AUbWWs030GAcC6W9++3jJ+tO6S9bURZ
         5c07ScsZRTqivYYSW6Wwq1L5w/M0mohMziNNVxHTHHmM9w00czhr2j+HbKqzTdWr4i/a
         OBO/e0cLhQr9MZ/dPU2JmaAyn9u3GnKzCOMusdd+a8XPGQRaJbhj9AHzWr2ITCgV9U/u
         pg9Ql1g/5uLpqxjKxjKuEcf6v+VxmSnFHyslxo4f2neufMFnV1SefEwDmy2fuHjHMdYV
         CS1TipHO1j2Fz+3bNU+lCaBiQ856lwLmKcV4Y+58vv6WnmKqREm0tWQ1hoREuzKwwGsp
         BZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JgcGkH9zIchXryBzpe+vAmJYy9gUucLQHyUH47Okfhc=;
        b=czJDoitkRctHj6QRAi7++Z9yE1dKYU5fkRWSDGNwpprUtGN8xC5WrqBitpulBdyJpk
         mR3CSrpOkbQO2HtfEvp+BHTohgEVnspmqXfvjgLAuqfHoWTlz2eMJwLDAgjyWhZfo+Ib
         L0/CQvIFUZhNJT9gPpKW4VTzWKUMOF6m/X6k7tFawReUIPl08jsAtzKQWeFpNxXjBgoW
         wjDKYObuaXeo67MnvXklcgJM2qi+AYkzBjHMWr/0axuFFac8ryZFn/ga4aL6H0sCz9po
         4i6JQiH/XLUFneMgulYqPsQFUttW53TGtE77ryXfGCDNnSGbdvhHkPXF2lILGt/f8jrh
         bgVA==
X-Gm-Message-State: APjAAAU5mAWq236wzsh+/m0Iw+HL5rG8WXK6lyNQ/pG6OBPjaAafaURT
        3UY1E9CBvlpdO8pNWghi3Br/FgYhttSxQPIYseIHFw==
X-Google-Smtp-Source: APXvYqw3vYLlWb6O1yDP+aZchFjjoNEu2tM9c8q/nZkZtNs/pDDTgyXrRTx1J6o8OoqJD6ltlXk7bSsXNUNZiKs8BnU=
X-Received: by 2002:a5d:9616:: with SMTP id w22mr478999iol.40.1557357115231;
 Wed, 08 May 2019 16:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190508102715.685-1-namit@vmware.com> <20190508102715.685-2-namit@vmware.com>
In-Reply-To: <20190508102715.685-2-namit@vmware.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 May 2019 16:11:44 -0700
Message-ID: <CALMp9eRnqn6Jrd762UZGZ9cQSMBFaxvNFsOkqYryP8ngG7dUEw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Use #DB in nmi and intr tests
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>
Date: Wed, May 8, 2019 at 10:47 AM
To: Paolo Bonzini
Cc: <kvm@vger.kernel.org>, Nadav Amit, Jim Mattson, Sean Christopherson

> From: Nadav Amit <nadav.amit@gmail.com>
>
> According to Intel SDM 26.3.1.5 "Checks on Guest Non-Register State", if
> the activity state is HLT, the only events that can be injected are NMI,
> MTF and "Those with interruption type hardware exception and vector 1
> (debug exception) or vector 18 (machine-check exception)."
>
> Two tests, verify_nmi_window_exit() and verify_intr_window_exit(), try
> to do something that real hardware disallows (i.e., fail the VM-entry)
> by injecting #UD in HLT-state.  Inject #DB instead as the injection
> should succeed in these tests.
>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

Thanks for the fix!

It has always bothered me that there is no easy way to validate a
kvm-unit-test on physical hardware. Do you have a mechanism for doing
so? If so, would you be willing to share?

I don't suppose you have a patch for kvm to fail the VM-entry in this case?
