Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6263AB249B
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 19:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbfIMR3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 13:29:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41956 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbfIMR3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 13:29:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so31867734wrw.8
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 10:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UlBe0Lyq/YXSQIpJRmZ/TAPWaDgGXHYnmOBd/Q+RyjQ=;
        b=tB/pB4GRNisIwDBB+yfPJvbSncgtuJQccySzqskuy98/t2HqtKtDE3YewrfmJy6X2G
         2AQCKl6NOBQ52pJrbkq218ZKFnco4p8z98tLWRRx7PVNXBk/yqfTK2EKQM9puS073E4K
         BAB0qbBVCntGpPc8rdCEFyO2yPoGl9v0ezkNL21tPbfQqWZ/CqyL/jwGuqqF1dmNbXTh
         ww17YrU2Ugj9vMGHwL+EchlvXs4XGItU1g9S7MecXJ0eQGqA+JBnBmR7xnmTx65e0zOJ
         LVZpKKt7wNNE0is90QCEZO0jkQiGK1jR2jB79NsCAr3vmMGwGInI3HRggSRBB3b4wTcc
         dVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UlBe0Lyq/YXSQIpJRmZ/TAPWaDgGXHYnmOBd/Q+RyjQ=;
        b=JJn7LQdE80C1Gl4bnB/xaYW9ACGFG1n8QzxPbIO11KWxcXilXzDdXJPCcMOS0wEzYa
         Iot0LaUuYAkd3CzAHAcIRDyX5YewDzLJ/7fFDRvSY5eRpeGpGHwEhp5xKVtX6dbT86DC
         XZM4vCdQ0lhLBQlXk/n9LwgbRyKlMiyj1w3387H2eK/1HamSeWy1O4XWx9b1TOFJks8N
         0U9PT49WT/mQaCyVx9NpC2mMMwb3DtT2xXKvClEAT7Ktz0kK7vdkNwO4F29S+PvRISWp
         J32RZbS4XO1mv3TldMNejsi5cE53NlAB+JaNXw1zM/LoW9Kz8LqtgJAe225u3ZTjnozX
         mUPA==
X-Gm-Message-State: APjAAAWhftSlm5XLSCP8An+8pRqNWSdT7a+7ld6HdBS3KkjC1mtRw4Ii
        2jtxr22setd2wjf/TUCxrTJSHMaiByZQ+8Gvn2mgEQ==
X-Google-Smtp-Source: APXvYqwamus1TBKNj1RsDbd4scVLIgDoCzNrEJGcHrkGr3tZsYWZNySlYEXF5PYZU3jHKrhJiiCz0Ghaw/iY667Z0AI=
X-Received: by 2002:adf:f20f:: with SMTP id p15mr35136301wro.17.1568395774467;
 Fri, 13 Sep 2019 10:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190912181100.131124-1-marcorr@google.com> <20190913140451.GB31125@linux.intel.com>
In-Reply-To: <20190913140451.GB31125@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 13 Sep 2019 10:29:23 -0700
Message-ID: <CAA03e5HG5Znw6YYaA2nycREz+oF8CRdBH93GByM0mh8G5iYGFA@mail.gmail.com>
Subject: Re: [PATCH] kvm: nvmx: limit atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All of this feedback sounds straightforward. I'll send a v2 out later
today. Thanks!

> On Thu, Sep 12, 2019 at 11:11:00AM -0700, Marc Orr wrote:
> > Allowing an unlimited number of MSRs to be specified via the VMX
> > load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> > reasons. First, a guest can specify an unreasonable number of MSRs,
> > forcing KVM to process all of them in software. Second, the SDM bounds
> > the number of MSRs allowed to be packed into the atomic switch MSR lists.
> > Quoting the appendix chapter, titled "MISCELLANEOUS DATA":
>
> Super Nit: There are multiple appendices in the SDM, maybe this?
>
> Quoting the "Miscellaneous Data" section in the "VMX Capability Reporting
> Facility" appendix:

Will do in v2.

> > +#define VMX_MISC_MSR_LIST_INCREMENT             512
>
> VMX_MISC_MSR_LIST_MULTIPLIER seems more appropriate.  INCREMENT makes it
> sound like X number of entries get tacked on to the end.

Will do in v2.

> > +static u64 vmx_control_msr(u32 low, u32 high);
>
> vmx_control_msr() is a 'static inline', just hoist it above this function.
> It probably makes sense to move vmx_control_verify() too, maybe to just
> below nested_vmx_abort()?

Will do in v2.

> >       msr.host_initiated = false;
> >       for (i = 0; i < count; i++) {
> > +             if (unlikely(i >= max_msr_list_size))
>
> Although the SDM gives us leeway to do whatever we please since it states
> this is undefined behavior, KVM should at least be consistent between
> nested_vmx_load_msr() and nested_vmx_load_msr().  Here it fails only after
> processing the first N MSRs, while in the store case it fails immediately.
>
> I'm guessing you opted for the divergent behavior because
> nested_vmx_load_msr() returns the failing index for VM-Enter, but
> nested_vmx_store_msr() has visible side effects too.  E.g. storing the
> MSRs modifies memory, which could theoretically be read by other CPUs
> since VMX abort only brings down the current logical CPU.

Ok. I'll update nested_vmx_store_msr() to iterate over as many MSRs as
it can in v2.
