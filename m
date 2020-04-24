Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196AD1B7B85
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgDXQZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 12:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgDXQZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 12:25:19 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E81C09B047
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 09:25:19 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id i3so10920828ioo.13
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 09:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D9NwqAXZ16ztzXp1zBHQSfRgUn9IPW7nGp69A48BIn8=;
        b=bX0//RWI4pfNyrf5ltw0MZ7T8jjJo+mVgXpEIRZ/TK+g22E360mDtxydj6ANgQgPNH
         Cuv8aKELAVTZmphsVtBozRfQm9NW1+brDA5zVf4j8vESw2ov47Tc5T76AmOiDcCrnt9K
         88x6h5AhlaN82qbZq/ZNywNq0H/ChvmpSdpQxz6fAqBt9Cf4kUMkVpqzfIRZEPyN2/eI
         RLCvSAfhfD5IVD+G/C552dqTJ1hbnr/DuxbS+aQMGGDUZ38g1VE7V9NvsxMKp3qNxfO4
         hkcaFQdcT51zgVFW198KHIrbB0d0yhbkhDhPrzyvu1tQ+v8SDi57iyiEsIxA9XCVV6wA
         uMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D9NwqAXZ16ztzXp1zBHQSfRgUn9IPW7nGp69A48BIn8=;
        b=n+zD3crBDOOzibUJM2Kh7dECnasqSJZHw0jrHZO3k+9XQPDDOJOpzUA3M7gJWogEKY
         lCJlo4ff+g/0bKRAZ9uURGviu6bxumCgpu4y53z3iCi8VwljuEw0ZoHlMShK6fMD750p
         xa4gQXLr9nfBMcGb4U7+lWu2r+itiM5rl2+2Ipt/umfv4i11lmA1pWdRmAFyXo5a13eg
         EBZKdiAK3EdIey9aqzG2ULb1hNCS5n4IPrTHb3ogGScF3XlFoJuUnadI92qp+qoZoW5r
         TuN9PWJszB+hslDHMmEHE7z7p2emmSu5KVori14AP9UzzHt4xlm17M5Zl9ipCSi3KQTG
         2dbA==
X-Gm-Message-State: AGi0PubmTpcmRMwJddD9fBiZ0IJmMOgfoSfNO4fOIrTWo+eX1xJcw+vZ
        O+KbtVJgMKfzsjq3DD9SlPrF4yjB4TKTQzHYxynaQg==
X-Google-Smtp-Source: APiQypIwqVR6Y+rC8zImSR9nN/+vSOB4mAAWXn8idVMSqNTEUa3+FFp62JpBUKiv2CeoArFWHhJgEDvaFKQIcWkeBFY=
X-Received: by 2002:a6b:91d4:: with SMTP id t203mr9533511iod.70.1587745518057;
 Fri, 24 Apr 2020 09:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net> <20200424144625.GB30013@linux.intel.com>
In-Reply-To: <20200424144625.GB30013@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 24 Apr 2020 09:25:06 -0700
Message-ID: <CALMp9eQtSrZMRQtxa_Z5WmjayWzJYhSrpNkQbqK5b7Ufxg-cMA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Li RongQing <lirongqing@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 7:46 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Apr 24, 2020 at 12:01:43PM +0200, Peter Zijlstra wrote:
> > On Fri, Apr 24, 2020 at 01:08:55PM +0800, Li RongQing wrote:

> This requires four RDMSRs per VMX transition.  Doing that unconditionally
> will drastically impact performance.  Not to mention that reading the MSRs
> without checking for host support will generate #GPs and WARNs on hardware
> without APERFMPERF.
>
> Assuming we're going forward with this, at an absolute minimum the RDMSRs
> need to be wrapped with checks on host _and_ guest support for the emulated
> behavior.  Given the significant overhead, this might even be something
> that should require an extra opt-in from userspace to enable.

I would like to see performance data before enabling this unconditionally.
