Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDFE1B3448
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 03:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgDVBCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 21:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgDVBCE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 21:02:04 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B08DC0610D5;
        Tue, 21 Apr 2020 18:02:04 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a2so447954oia.11;
        Tue, 21 Apr 2020 18:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JwVDsnKQEhm1jAKmC3TdxNUyFpBPqvMfGNXwJrkzeOk=;
        b=GPF42GEk0RargHC4CRBaeWdJMXVEj99sHY6Ia+uZjQfmnnnHP1NWRqo2dY6I8g0L2i
         jk9zOY1Y3LO0iFGZXUbF3rkoGnDQlcN2SK2y7vocOIrn+X9bmAfjPc/fqLPgoWeXiw2/
         sTWwIJPXPgQclVK19R3XVA1RrnVFHvv6j/XqTYBVpk3GBe2HWdXMN/L9TeRPSh+C+1tn
         XZtJcnSzFWqTRIlBdGqo0/rPkgdLl2ZCMMgpo+jwQFh7mlvsxpCDkvxjiQ8y7lJ72WDh
         znpRwf7MftRjr6ml0DtfY69cOhqHHrLQ98a9AbJq3yUKTNx50TIq1PK6HhprIuyAgYKy
         8r2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JwVDsnKQEhm1jAKmC3TdxNUyFpBPqvMfGNXwJrkzeOk=;
        b=dkHHgBTSMH3B1fqONRKmWdcVhVK2wmcBydGG/d9JsF/ANbrAXcya8M4VyrWLIX1fWV
         SbSs4Db50jZ/U+cDgSyNEUIGqoin6HjPaxVL1q03yVJNuyrsJKtIxPNZq0j2oah48eE4
         s3ZpBYnKHhnACrG/bIWTum82D3Gm6O3iPyIWOSHxN+giwgeNXIrtgUWGoNsq2t0rKTMv
         /Wa9fvxHAAqZ0Xlew0wWFJ7lNEkeXBxWi6OGJiS0n2Q+YfG5e3S5t8meBZFIxlq3X/xD
         12x8fl2Z8uZX/+nqTwpTpDIn6oiqEHVeLH3nzxom7bVYsyETVLUiuTCGaLxle0TzPZAS
         Sd7A==
X-Gm-Message-State: AGi0PuZbUvYasMh0i3Dg9o3/jl5xNmS1fJ4NhWtnSYBgtAXhwMEvAvon
        XKwi6pVb7eTSn0R+6kTDVN4ws28CTF/JckJXDrM=
X-Google-Smtp-Source: APiQypLjVzrsl0Anz94XprXcwDt3fBjesJAs6pymEAtm5P7X7L2JfxiWhw73gsMrLIp/3Qq2SpkINTQzTjOfxSPeUgg=
X-Received: by 2002:aca:2801:: with SMTP id 1mr4869738oix.141.1587517323684;
 Tue, 21 Apr 2020 18:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
 <1587468026-15753-3-git-send-email-wanpengli@tencent.com> <68eb0e46-4c2a-0292-3dfa-db2ae2b2b13d@redhat.com>
In-Reply-To: <68eb0e46-4c2a-0292-3dfa-db2ae2b2b13d@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 22 Apr 2020 09:01:52 +0800
Message-ID: <CANRm+CwXhe+TdB8JpQ78qR-sO6FB_cMjqHxj5fSyKEMPkMVm8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Handle preemption timer fastpath
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

On Tue, 21 Apr 2020 at 19:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/04/20 13:20, Wanpeng Li wrote:
> > +
> > +     if (!vmx->req_immediate_exit &&
> > +             !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
> > +             if (!vmx_interrupt_allowed(vcpu) ||

For non-APICv case, we need to request interrupt-window.

> > +                     !apic_lvtt_tscdeadline(apic) ||

Now just add fastpath for tscdeadline mode.

> > +                     vmx->rmode.vm86_active ||
> > +                     is_smm(vcpu) ||
> > +                     !kvm_apic_hw_enabled(apic))

These stuff can be removed, kvm_apic_hw_enable() is check in
vmx_fast_deliver_interrupt().

> > +                     return EXIT_FASTPATH_NONE;
> > +
> > +             if (!apic->lapic_timer.hv_timer_in_use)
> > +                     return EXIT_FASTPATH_CONT_RUN;
> > +
> > +             WARN_ON(swait_active(&vcpu->wq));
> > +             vmx_cancel_hv_timer(vcpu);
> > +             apic->lapic_timer.hv_timer_in_use = false;
> > +
> > +             if (atomic_read(&apic->lapic_timer.pending))
> > +                     return EXIT_FASTPATH_CONT_RUN;

Other two checks are the same in kvm_lapic_expired_hv_timer().

    Wanpeng

> > +
> > +             ktimer->expired_tscdeadline = ktimer->tscdeadline;
> > +             vmx_fast_deliver_interrupt(vcpu);
> > +             ktimer->tscdeadline = 0;
> > +             return EXIT_FASTPATH_CONT_RUN;
> > +     }
> > +
>
> Can you explain all the checks you have here, and why you need something
> more complex than apic_timer_expired (possibly by adding some
> optimizations to kvm_apic_local_deliver)?  This code is impossible to
> maintain.
>
> Paolo
>
