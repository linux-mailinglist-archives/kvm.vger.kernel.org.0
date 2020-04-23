Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629191B58AA
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgDWJ5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbgDWJ5D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 05:57:03 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C732AC03C1AF;
        Thu, 23 Apr 2020 02:57:02 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id b13so5037529oti.3;
        Thu, 23 Apr 2020 02:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zpVZ9ErILW2s2TLRWRMEyXqH+tdaxrwrClR4yhCM63A=;
        b=f+tlLNe/7c5lNj49h+TjMXRdhQ6FJTks90I9bWP/RWG3yICYZkFf5leNgGYdDJpHrP
         et9KkypWu5hmk1DznoYL+UTLXVCeH6bFPyApKyEqvRpcn46PX7qtoLFDCDkUXgsfvO9E
         WioFpPjShvrB6p/oqBw5KzFpjWBIIoJGbu/S4Kq2TG3avvjgypfRZheaV/BDf/HAREQH
         JkhrQ7AJEm00NTAkktuoo11RTXqICuWTyLv+wZZgFc2q1MFs5ULW/DZUbxJnp8+utvJK
         2eabLgfMUM0jsPtzrefE/XbSRz1gFFDE6/VMbdobwOptxQlk2q2WWYOsmnGX7XpjjmRC
         Q8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpVZ9ErILW2s2TLRWRMEyXqH+tdaxrwrClR4yhCM63A=;
        b=UohfVu1mTTUTJMSm8ja00PK715L41pv9KwjDc2784C/aCcvw+RcAEJUXFEtIBXJBU7
         cbQQcwrCSnICKpPZWjn4tZOeNOY8ek5QCTQgoPmFQJU5t/hl4g1ECc+LpIvCqei2fK2b
         3XA10z+Cy2s+Av9NKmw0myNgSckutmOvHIoaWM/HZkt/3eF3RNQmmNLGszPTUgHJ6yJE
         Cz+2zXohFDhiNfYt2OOhF8I8LH2kUlYirPoK9MkIXHNkdqvc6GBKvNdCTZaZWdefoQgl
         tqDiRSS1jj2W+sBhpuiGd7lI1jivQnH9x54WBlhoHHIOIANASpE7G70mfkIJQCZsiPyj
         YhHA==
X-Gm-Message-State: AGi0PuYIwuciP8ZMBLaRgWlBPAwfQuQP0woWjjVVFNewvwKJ14pS9K+v
        wlsztFY6pROJeuoFCjW6tTSBhwu0C1TqloJt0cU=
X-Google-Smtp-Source: APiQypL4Y08BAWHfAY/2dYCM7ExuzW0M0wfbUZ+BIhhJm+lWHaDHhlM/7TKnj9MZBb+5KburSX2TNh1aizfyolz0rxc=
X-Received: by 2002:aca:2801:: with SMTP id 1mr2200732oix.141.1587635822199;
 Thu, 23 Apr 2020 02:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-6-git-send-email-wanpengli@tencent.com> <99d81fa5-dc37-b22f-be1e-4aa0449e6c26@redhat.com>
In-Reply-To: <99d81fa5-dc37-b22f-be1e-4aa0449e6c26@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 23 Apr 2020 17:56:51 +0800
Message-ID: <CANRm+CyyKwFoSns31gK=_v0j1VQrOwDhgTqWZOLZS9iGZeC3Gw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: VMX: Handle preemption timer fastpath
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

On Thu, 23 Apr 2020 at 17:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/04/20 11:01, Wanpeng Li wrote:
> > +bool kvm_lapic_expired_hv_timer_fast(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_lapic *apic = vcpu->arch.apic;
> > +     struct kvm_timer *ktimer = &apic->lapic_timer;
> > +
> > +     if (!apic_lvtt_tscdeadline(apic) ||
> > +             !ktimer->hv_timer_in_use ||
> > +             atomic_read(&ktimer->pending))
> > +             return 0;
> > +
> > +     WARN_ON(swait_active(&vcpu->wq));
> > +     cancel_hv_timer(apic);
> > +
> > +     ktimer->expired_tscdeadline = ktimer->tscdeadline;
> > +     kvm_inject_apic_timer_irqs_fast(vcpu);
> > +
> > +     return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_lapic_expired_hv_timer_fast);
>
> Please re-evaluate if this is needed (or which parts are needed) after
> cleaning up patch 4.  Anyway again---this is already better, I don't
> like the duplicated code but at least I can understand what's going on.

Except the apic_lvtt_tscdeadline(apic) check, others are duplicated,
what do you think about apic_lvtt_tscdeadline(apic) check?

    Wanpeng
