Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80924DFFEE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbfJVIqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28819 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387575AbfJVIqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:46:15 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A9F585363
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 08:46:14 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id u17so1564516wmd.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 01:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3vFeOe+bYuDka4Ka2yl0bdvDmUhyxmNAPA43fQB+Vwo=;
        b=ErCAbm+YsGHkdvuCkcVxaxX1NqyxXYzR8xC5Ccc0dE50+5sOvar4hokIBThUoqlKMh
         ktzwJ409975Uc16HMDe0ERgaBy3EGXJxgybJ/Ad0Ps8GfZPAT1Z1LcPpKGRAUi6g8AxL
         b7qRb9d5fPahfxKyxV+0DCm39FdD77IaBVFfP+k2hzsEhsWYp22QyY4yQwAx0bEjXtKj
         JkQliZ5fr05/35O7XYam/jUOWN9L1rPstkUq9ga122rYW3My5YTYq6ej2ab0Vxm5lJvr
         TEWpMcQ9TCaLvsGD8HCpAD/hmd8EWd4lmeccGkJ+HXslSckCFN6nCOH/gcefQufysCHv
         kDgg==
X-Gm-Message-State: APjAAAV4nGuvmhgqZMoOArU3BYfQky8oRSm4/GjaT9BnIc4vqeXk8L7e
        pI6ZcCwTkZxqdU5FyyXZ6SK9YG84rflpYqRRNr1O6ruev7gug54RMohEvvBSKiJF34gDF+5AdQZ
        ZXKwqIBBSaGmS
X-Received: by 2002:adf:e34b:: with SMTP id n11mr2287667wrj.250.1571733972956;
        Tue, 22 Oct 2019 01:46:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy6/EZb4JYeMXrDvX360zKNmzBLoFUiJOFM7/Ur73oRbIJaoO1FKmJioq7z4BpW58NSfwNr8A==
X-Received: by 2002:adf:e34b:: with SMTP id n11mr2287649wrj.250.1571733972675;
        Tue, 22 Oct 2019 01:46:12 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q11sm7080488wmq.21.2019.10.22.01.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 01:46:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     wanpengli@tencent.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Skip pv ipi test if hcall not available
In-Reply-To: <34e212a851eb0d490fad49f8b712b2c6e652db76.camel@gmail.com>
References: <20191017235036.25624-1-sjitindarsingh@gmail.com> <87pniu0zcw.fsf@vitty.brq.redhat.com> <34e212a851eb0d490fad49f8b712b2c6e652db76.camel@gmail.com>
Date:   Tue, 22 Oct 2019 10:46:11 +0200
Message-ID: <875zkh1830.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:

> Hi,
>
> On Fri, 2019-10-18 at 18:53 +0200, Vitaly Kuznetsov wrote:
>> Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
>> 
>> > From: Suraj Jitindar Singh <surajjs@amazon.com>
>> > 
>> > The test in x86/apic.c named test_pv_ipi is used to test for a
>> > kernel
>> > bug where a guest making the hcall KVM_HC_SEND_IPI can trigger an
>> > out of
>> > bounds access.
>> > 
>> > If the host doesn't implement this hcall then the out of bounds
>> > access
>> > cannot be triggered.
>> > 
>> > Detect the case where the host doesn't implement the
>> > KVM_HC_SEND_IPI
>> > hcall and skip the test when this is the case, as the test doesn't
>> > apply.
>> > 
>> > Output without patch:
>> > FAIL: PV IPIs testing
>> > 
>> > With patch:
>> > SKIP: PV IPIs testing: h-call not available
>> > 
>> > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
>> > ---
>> >  x86/apic.c | 11 +++++++++++
>> >  1 file changed, 11 insertions(+)
>> > 
>> > diff --git a/x86/apic.c b/x86/apic.c
>> > index eb785c4..bd44b54 100644
>> > --- a/x86/apic.c
>> > +++ b/x86/apic.c
>> > @@ -8,6 +8,8 @@
>> >  #include "atomic.h"
>> >  #include "fwcfg.h"
>> >  
>> > +#include <linux/kvm_para.h>
>> > +
>> >  #define MAX_TPR			0xf
>> >  
>> >  static void test_lapic_existence(void)
>> > @@ -638,6 +640,15 @@ static void test_pv_ipi(void)
>> >      unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 =
>> > 0x0;
>> >  
>> >      asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI),
>> > "b"(a0), "c"(a1), "d"(a2), "S"(a3));
>> > +    /*
>> > +     * Detect the case where the hcall is not implemented by the
>> > hypervisor and
>> > +     * skip this test if this is the case. Is the hcall isn't
>> > implemented then
>> > +     * the bug that this test is trying to catch can't be
>> > triggered.
>> > +     */
>> > +    if (ret == -KVM_ENOSYS) {
>> > +	    report_skip("PV IPIs testing: h-call not available");
>> > +	    return;
>> > +    }
>> >      report("PV IPIs testing", !ret);
>> >  }
>> 
>> Should we be checking CPUID bit (KVM_FEATURE_PV_SEND_IPI) instead?
>> 
>
> That's also an option. It will produce the same result.
>

Generally yes, but CPUID announcement has its own advantages: when a
feature bit is set we know the hypercall *must* exist so -KVM_ENOSYS
would be a bug (think of a theoretical situation when the hypercall
starts to return -KVM_ENOSYS erroneously - how do we catch this?)

> Would that be the preferred approach or is the method used in the
> current patch ok?

I'm not insisting, let's leave it up to Paolo :-)

-- 
Vitaly
