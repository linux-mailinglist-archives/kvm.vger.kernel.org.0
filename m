Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261F2B12EB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 18:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfILQo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 12:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfILQoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 12:44:25 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C26B3B464
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 16:44:24 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id o16so553201wru.10
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 09:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zoH4QTE6JeRQ9cejfuBwTdDAfAuJXRi5JfhYPwN1PqU=;
        b=BVoKItWaGgc2h65zSOR5Sew55IL5+CzFiUkhZLN+EiGEdMB07wiHh2okVvUdfUKv9n
         myJrC8z/lJZlS5RAWdhZYh85dNdVUHjpQBcMOZ1H13EJna8zmnZCiTm2jlOdIxi1CW6w
         VQRBW1TBIWnYqj6JsSmr3W+IVUdb5CdWlg5Sk0gdnJ/OAyu06/nvwAMVg3WlFEdV9T1Q
         kIG1BXS30XlJs+UmzGfuPfMqMf/MzxyWLEWXEWV7DOJVtycO33oyGLbtEgrOpd3lmdy+
         eYxCYtVu7EoHw06GDXwIYD8d/9qyD0IVEj0M2p4qXn/dAsTPpKAlCdifXu1/B3M7gYqc
         QojQ==
X-Gm-Message-State: APjAAAUnIeStobikKmu7cODGL82MxOZonsssVxCwI/3+Qsm+xVERN5Ug
        0/Yt2us8h9Xl5IgWuK4Y4NKEvNmjA+iq8k8fOfHpiDp7CaGG/0bNxwvb1gaFTTWu+QKcX8AxZOH
        J36Gxr/7gfdib
X-Received: by 2002:adf:e94f:: with SMTP id m15mr2619462wrn.225.1568306663101;
        Thu, 12 Sep 2019 09:44:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxeN2yn1DCTnoJ6sS2TFwy9L2253CghjHXehfinXZ3U/iqRDXW/hi8D0Ic4JQ8+OxbYzc5QZQ==
X-Received: by 2002:adf:e94f:: with SMTP id m15mr2619441wrn.225.1568306662883;
        Thu, 12 Sep 2019 09:44:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a190sm743531wme.8.2019.09.12.09.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 09:44:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack contents
In-Reply-To: <CALMp9eRu=C+MQmRpKh5WtyqBKq=ja8Wj7fD5NTFhZi9EZd+84w@mail.gmail.com>
References: <20190912041817.23984-1-huangfq.daxian@gmail.com> <87tv9hew2k.fsf@vitty.brq.redhat.com> <CALMp9eRu=C+MQmRpKh5WtyqBKq=ja8Wj7fD5NTFhZi9EZd+84w@mail.gmail.com>
Date:   Thu, 12 Sep 2019 18:44:21 +0200
Message-ID: <874l1hcvmi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Sep 12, 2019 at 1:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Fuqian Huang <huangfq.daxian@gmail.com> writes:
>>
>> > Emulation of VMPTRST can incorrectly inject a page fault
>> > when passed an operand that points to an MMIO address.
>> > The page fault will use uninitialized kernel stack memory
>> > as the CR2 and error code.
>> >
>> > The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
>> > exit to userspace;
>>
>> Hm, why so? KVM_EXIT_INTERNAL_ERROR is basically an error in KVM, this
>> is not a proper reaction to a userspace-induced condition (or ever).
>
> This *is* an error in KVM. KVM should properly emulate the quadword
> store to the emulated device. Doing anything else is just wrong.
>
> KVM_INTERNAL_ERROR is basically a cop-out for things that are hard.

Yes, I way arguing with "the right behavior would be" in relation to
KVM_INTERNAL_ERROR.

>
>> I also looked at VMPTRST's description in Intel's manual and I can't
>> find and explicit limitation like "this must be normal memory". We're
>> just supposed to inject #PF "If a page fault occurs in accessing the
>> memory destination operand."
>>
>> In case it seems to be too cumbersome to handle VMPTRST to MMIO and we
>> think that nobody should be doing that I'd rather prefer injecting #GP.
>
> That is not the architected behavior at all. Now you're just making
> things up!

True and I'm not against KVM_INTERNAL_ERROR as an iterim solution if it
comes with a comment explaining why we're 'admitting defeat' here.

-- 
Vitaly
