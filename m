Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE851B5848
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgDWJfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWJfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:35:36 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DDDC03C1AF;
        Thu, 23 Apr 2020 02:35:36 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id e20so4897925otk.12;
        Thu, 23 Apr 2020 02:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/1A4hBh1dolv+frlySc+d0U0LH03mwvnz3gVgxsSMU=;
        b=bAESsIRhZD37NKG0MIomS9UmIlUo6trshfHUoXzEoL4k0SPLvMNZt3V1lX6os+A9VG
         2IbwmhLrTwsCZqQpKlLrSYiC5UBF7bIWsv/PAecdTrkdkK2tqnHymU/vNQ22ZgaBenrD
         pWvqB/guN4j1vMnwQLZ5PAut/4rFZM4rQRu4sGPDp36pPIS3lWiSwk1zBd3BajsKb3zT
         wnPgDXsrOdDaQ8JqqHcI4r8axYcdu1Ig7Edan1pEAbAw+QqHgaaleiKKbzBES4VehSi1
         iKb3YQ0dXTJjXBtdpsLj6CmI+2yETd/pbssV2PyqxUq8weaZRr4N6zO4WKiinNnbzakF
         XGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/1A4hBh1dolv+frlySc+d0U0LH03mwvnz3gVgxsSMU=;
        b=M64SrUVt+mcSogYr/gxFLXtRt7czAz+d3YeaEtR28Ws+uvpA9EtJVXHfwyWThV7Iec
         Hot4EKYoBOaXUrSGvJtFEq6Q4E7ALC0ALhPD4/bnJeWf1bMEiGKGDbiy0bTzByw2O9o/
         C2LTmrc1x6dGubr+KHYsTMKmVnFHkbS30s2QGwOxbZ/CROHi8gRKu2T0SVJnNfjgcRVk
         7YYGfOwcstkxkm4FQyh4kEcWBb9RcU80dgA4gQQYepQoLvuQNrC6vjn3yPHrsw/Q03dv
         nQd4/vJIecRzQW/a3kMsltA7CW/dsQDziKWZbjH0ynslk5aUbhW/NCw85XCetzFG7LpE
         vY+Q==
X-Gm-Message-State: AGi0PuZJLmRU8ybPIHQZL2OjmamjNk9NeurMn7n0tZeUiqCW44dieAjC
        O1XezXchwbRiFCnt5vHP92mcQx0zfc/u5eHXyag=
X-Google-Smtp-Source: APiQypJGYXEPSN+YMpH4YdbjzjxfI23adoKgaemmwhjrkwuljfxD+wbomcWgxN3qdwM+UWYpVfGBC9+i2Lpk/euPMsY=
X-Received: by 2002:a9d:7f04:: with SMTP id j4mr2791485otq.185.1587634536173;
 Thu, 23 Apr 2020 02:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-2-git-send-email-wanpengli@tencent.com> <09cba36c-61d8-e660-295d-af54ceb36036@redhat.com>
In-Reply-To: <09cba36c-61d8-e660-295d-af54ceb36036@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 23 Apr 2020 17:35:25 +0800
Message-ID: <CANRm+Cybksev1jJK7Fuog43G9zBCqmtLTYGvqAdCwpw3f6z0yA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] KVM: LAPIC: Introduce interrupt delivery fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 at 17:25, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/04/20 11:01, Wanpeng Li wrote:
> > +static void fast_deliver_interrupt(struct kvm_lapic *apic, int vector)
> > +{
> > +     struct kvm_vcpu *vcpu = apic->vcpu;
> > +
> > +     kvm_lapic_clear_vector(vector, apic->regs + APIC_TMR);
> > +
> > +     if (vcpu->arch.apicv_active) {
> > +             if (kvm_x86_ops.pi_test_and_set_pir_on(vcpu, vector))
> > +                     return;
> > +
> > +             kvm_x86_ops.sync_pir_to_irr(vcpu);
> > +     } else {
> > +             kvm_lapic_set_irr(vector, apic);
> > +             if (kvm_cpu_has_injectable_intr(vcpu)) {
> > +                     if (kvm_x86_ops.interrupt_allowed(vcpu)) {
> > +                             kvm_queue_interrupt(vcpu,
> > +                                     kvm_cpu_get_interrupt(vcpu), false);
> > +                             kvm_x86_ops.set_irq(vcpu);
> > +                     } else
> > +                             kvm_x86_ops.enable_irq_window(vcpu);
> > +             }
> > +     }
> > +}
> > +
>
> Ok, got it now.  The problem is that deliver_posted_interrupt goes through
>
>         if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>                 kvm_vcpu_kick(vcpu);
>
> Would it help to make the above
>
>         if (vcpu != kvm_get_running_vcpu() &&
>             !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>                 kvm_vcpu_kick(vcpu);
>
> ?  If that is enough for the APICv case, it's good enough.

We will not exit from vmx_vcpu_run to vcpu_enter_guest, so it will not
help, right?

    Wanpeng
