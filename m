Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A205D24C48E
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgHTRat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 13:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgHTRar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 13:30:47 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12866C061385
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 10:30:47 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u24so2566666oic.7
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBeF1Usg6ifiYEJEML0zoiVnyrKdxeURswDFMsvppW8=;
        b=aJ56sSNfHV6Ijs9bOL0Qaf2cWHGxOn/t639xg2VqkJ6y6geX+xm0N1iXaNwGB0TD0m
         69jkkElivY41CDpLGVRveKXRJq1cudhIZUTZzTqIrBhFdIa+aOqUmtKxBZBn5lgDOPXy
         a1iNcuqOm3rWFSE8O/HL9vbUab3WhvhnIG8Q1h//tBEUu7G5yuVK3V/+YrRM2cU0vHRz
         tJGNQ/dhmKJGVQSu6fSinZ5Ksgxbu8QzoDwWd7L4vqECSf/785QcbewMLxjybYc08jNO
         W96lWltguMZXfnGmVxOiXBq9/Iy9ZbW39TO5tEK+AhO5D/FeXz8TlMt5GvweL38dFafm
         iXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBeF1Usg6ifiYEJEML0zoiVnyrKdxeURswDFMsvppW8=;
        b=cPWpsGbgNuY6txYoDxaL+EPir3AQ0Ko5DP0JQwl8RUYWPu5Joo7Cx/69MmDd2GI94d
         OJaEyA7YGpiqUgkKDkVNBNrrJJFyxjxFEdixlSetZutW78oq9nW6SdsToeAZSCuva3Re
         7O6r0onu5J2pOAW8gXKRCIbjOHGSq6oWigHZko7kKNopGMIVt6eGMI8+AWkhN/ip2Evy
         t+fBbYsrrTEIskhyYnl2A5l9kQzGw2QuENLDwhNF0YmwHXLHbut8lHIsIXpaB9ZPvaBx
         9USm2pJbBRWUHDSkgkgrHDVmrvZqMwRG5B+5rM/QpquKubbzbbkWVdhHnVcU0F+Qtp5c
         0RHw==
X-Gm-Message-State: AOAM530vUdwvpKV4c1OS5kr1QgJCWaeDA2t3pso/O7/NhhATLmiZd/dN
        DLA62LHtm2/mVrsxelwcqa7Gg+ECkD7WNSLcDFTJww==
X-Google-Smtp-Source: ABdhPJzBcCJbfZjYzhUzt6FDWVzspudOntMpF+04IrVYNWLXF1brT9pFiAvGi4YDge5468xHuamTE42ZxzxGUzD0TOc=
X-Received: by 2002:aca:670b:: with SMTP id z11mr2285933oix.6.1597944646122;
 Thu, 20 Aug 2020 10:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-5-aaronlewis@google.com> <b8bbbd5d-9411-407d-7757-f31e1ee54ae2@amazon.com>
In-Reply-To: <b8bbbd5d-9411-407d-7757-f31e1ee54ae2@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 10:30:34 -0700
Message-ID: <CALMp9eT5_zq52kzQjSM2gK=oQ1UMFNZhNgK0px=Y2FLzxHxqhA@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 2:00 AM Alexander Graf <graf@amazon.com> wrote:

> Why would we still need this with the allow list and user space #GP
> deflection logic in place?

Conversion to an allow list is cumbersome when you have a short deny
list. Suppose that I want to implement the following deny list:
{IA32_ARCH_CAPABILITIES, HV_X64_MSR_REFERENCE_TSC,
MSR_GOOGLE_TRUE_TIME, MSR_GOOGLE_FDR_TRACE, MSR_GOOGLE_HBI}. What
would the corresponding deny list look like? Given your current
implementation, I don't think the corresponding allow list can
actually be constructed. I want to allow 2^32-5 MSRs, but I can allow
at most 122880, if I've done the math correctly. (10 ranges, each
spanning at most 0x600 bytes worth of bitmap.)

Perhaps we should adopt allow/deny rules similar to those accepted by
most firewalls. Instead of ports, we have MSR indices. Instead of
protocols, we have READ, WRITE, or READ/WRITE. Suppose that we
supported up to <n> rules of the form: {start index, end index, access
modes, allow or deny}? Rules would be processed in the order given,
and the first rule that matched a given access would take precedence.
Finally, userspace could specify the default behavior (either allow or
deny) for any MSR access that didn't match any of the rules.

Thoughts?
