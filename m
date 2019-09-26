Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E6ABE96E
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 02:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbfIZATn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 20:19:43 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38179 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387885AbfIZATn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 20:19:43 -0400
Received: by mail-oi1-f195.google.com with SMTP id m16so552263oic.5;
        Wed, 25 Sep 2019 17:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=loUUyZjlMW8gDrBWiQqFmXL3CqegPpaCHCadrXyJRos=;
        b=ld+FtlfZ1b1r9UIfejJyQwo6Db0jg6Qubr/PsAGM1hRGkFS+oB1lfO51khCEOLkISF
         1OWVa/Z1as53CLoUB2PmObKIf2U/MRBhabPjXcSk/gJrQCiWdMHUHCvJLeHspEBahmk3
         3Kp4mgKZPPoo77JjEj9uqolIv0l867XkaYxaGGhxKaeU0Mm+GOU2/alD3MwXbxVB4FHf
         S2Bowr3HGXHMlsEqrqgDd6EjyjqV3h5NE8/Y5f6/MX4/0OnlUUUCCrlYcyNHTIEh/+/j
         QWEX0sVORLhWzyP+pMseyl9RabBaQJb89Ua6GNRnrSWHgRsAI+QxHUIZtJizVF9V5T2e
         UpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=loUUyZjlMW8gDrBWiQqFmXL3CqegPpaCHCadrXyJRos=;
        b=q4sZg7+ohGeuzef94RRalQD153TQepxsmogX9FjzOt/atsKscQ5XfnA9ju4o38nJdj
         DMlyIPuthlariHHQ+8v3RxEvS6nObfDsak4Y4+AnD1m099092ZF8Q08EFpdNc5vIhQG4
         q3ntYdvkIZKdeNkOOyIOUqvl1Eh8hBRUbLrSbrDsiBOpCg8UGOtq3qJXsm5XMOCs/YGS
         DPeBzQTSgl7SLEZ8lMvoUkeQ31XllOqb6WjS9BouVPCl/OvQotAm6qgfFnoy77rU+7wj
         MR85ndwPYmLP0JUTpRttqNr+jkaLx5KfbnQzh24aSRzMMV9OGvAfLDVXDxAkuMI8kEU+
         RzjQ==
X-Gm-Message-State: APjAAAWOO8h8N/9qdlTL51axS5Aple6/LM2/OCXhr7ZV56oNmT51m157
        JzTRwnHKdrjBxtJGntsueqqL0NLcy4rGcryDhek=
X-Google-Smtp-Source: APXvYqzPmIzV36n78D/TSswsC9mPm4QOCa2Ibw00lGzXTgQ8tJSQeRClrsRG1FnZbdyBmVX8GI/AsjW3e2V5ZjcvB80=
X-Received: by 2002:aca:fd8a:: with SMTP id b132mr577209oii.33.1569457181247;
 Wed, 25 Sep 2019 17:19:41 -0700 (PDT)
MIME-Version: 1.0
References: <1569390424-22031-1-git-send-email-wanpengli@tencent.com> <20190925192949.GM31852@linux.intel.com>
In-Reply-To: <20190925192949.GM31852@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 26 Sep 2019 08:19:28 +0800
Message-ID: <CANRm+CyMOqrOtPJUFN2Ee0dKnZ0AEWZNPv8k_8XeuumBdYchgQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Loose fluctuation filter for auto tune lapic_timer_advance_ns
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Sep 2019 at 03:29, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Sep 25, 2019 at 01:47:04PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > 5000 guest cycles delta is easy to encounter on desktop, per-vCPU
> > lapic_timer_advance_ns always keeps at 1000ns initial value, lets
> > loose fluctuation filter a bit to make auto tune can make some
> > progress.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 3a3a685..258407e 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -67,7 +67,7 @@
> >
> >  static bool lapic_timer_advance_dynamic __read_mostly;
> >  #define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
> > -#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
> > +#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 10000
> >  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
> >  /* step-by-step approximation to mitigate fluctuation */
> >  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> > @@ -1504,7 +1504,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
> >               timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
> >       }
> >
> > -     if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX))
> > +     if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX/2))
>
> Doh, missed that these are two different time domains in the original
> review, i.e. ns vs. cycles.

I try to save one #define in this patch, will fold below in next version.

    Wanpeng

>
> We should use separate defines for the filter since that check is done
> in cycles.  Not sure what names to use to keep things somewhat clear.
>
> Maybe s/ADJUST/EXPIRE for the cycles, and s/ADJUST/NS for the ns ones?
> E.g.:
>
> #define LAPIC_TIMER_ADVANCE_EXPIRE_MIN  100
> #define LAPIC_TIMER_ADVANCE_EXPIRE_MAX  10000
> #define LAPIC_TIMER_ADVANCE_NS_MAX      5000
> #define LAPIC_TIMER_ADVANCE_NS_INIT     1000
>
> >               timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> >       apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> >  }
> > --
> > 2.7.4
> >
