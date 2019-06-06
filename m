Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F043536BAA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 07:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfFFFcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 01:32:46 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45709 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfFFFcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 01:32:46 -0400
Received: by mail-oi1-f196.google.com with SMTP id m206so696962oib.12;
        Wed, 05 Jun 2019 22:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xwixYjl7EOcfYmOy8V+Kh6ZtdFLnskr45gzN6k9owSM=;
        b=Dj5FrsILS33NaAsTT8q/wpah92fIjhC7Lq8xEtZN6DCxVsMfc+QbPshzQ+kocsQ9RS
         GMPGXtllHMWTaF26VdzxQXiCPwVBZA6c8BgWoKArt3sAgCwfNtxmI3P44dAzA68m1ZWe
         6yhl+j6QlbJ9KEZYzw0QIHKVWcMU8GSQsgRLK2U89RTgX7ZNUBh83MJVnGKxLDc88bdz
         y1S15UWZWf04TKa4wZXC1xOKl1H2ebxljFqL44+69fZmZtZ8WF1KS00tQRpMknBMw5GA
         fypDRz8fnn4kG81qesoY9kOP8mjs6NzjQCRGcSLpc0NA+hj130z+8HmC/W+SdHZ5d3/N
         BfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xwixYjl7EOcfYmOy8V+Kh6ZtdFLnskr45gzN6k9owSM=;
        b=p1+g5l6SCpKf0yJfFt3ZWzoITYB8Z/99VO6FPxZ3YxPG9NoSUuTizhDlBJis8WC1gq
         b9nkhPeOwgpFWfrrCV1xDP6/AkexvSH9Ze8cFTdX5fCaYQ1EFOBCCtUAFSkRYlC/TWy9
         kSIU2Lo1dY3aceyeNFj1+BLzwKacvyD8uLSN9x0wX6BthQeqyNnlB+FNp29BGiXjEMXK
         aUJYo8v4XOedYXykWI9+xUsypIFjFRTZlqzQytbvfrmOc66P/JvnwZJcfEcBPP3YdGi3
         EFH3d2c23l7O8XoyTBQV6B3fcDJ5ZFbqmYi8zzIEGKifIfD5UuI0gxFtxm5aScV+slQK
         yEPA==
X-Gm-Message-State: APjAAAWLk6lAFow3FNKErtEDFDYUPcsDwo2RUbr8armfkI/71Glf4tJ1
        IgdJguLravm3urouBuytazePpHxoely41uIe8Y4=
X-Google-Smtp-Source: APXvYqwgRpzFZo9A5G2I8J8KzwmgzxOVaz9cb2wtcByP+yzE4hDJHk8MAF0kjjhy9RJAGNCKqnMEOjylHuboRXdTfMs=
X-Received: by 2002:aca:544b:: with SMTP id i72mr6013510oib.174.1559799165306;
 Wed, 05 Jun 2019 22:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
 <1559729351-20244-3-git-send-email-wanpengli@tencent.com> <16c54182-7198-f476-080b-5876cd871e42@redhat.com>
In-Reply-To: <16c54182-7198-f476-080b-5876cd871e42@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 6 Jun 2019 13:33:10 +0800
Message-ID: <CANRm+Cyzf_P_npJMBDbHN1g+GDfKsNR23bNWXMuUCtFq_caQnQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: LAPIC: lapic timer is injected by posted interrupt
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Jun 2019 at 20:30, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/06/19 12:09, Wanpeng Li wrote:
> > +static void apic_timer_expired_pi(struct kvm_lapic *apic)
> > +{
> > +     struct kvm_timer *ktimer = &apic->lapic_timer;
> > +
> > +     kvm_apic_local_deliver(apic, APIC_LVTT);
> > +     if (apic_lvtt_tscdeadline(apic))
> > +             ktimer->tscdeadline = 0;
> > +     if (apic_lvtt_oneshot(apic)) {
> > +             ktimer->tscdeadline = 0;
> > +             ktimer->target_expiration = 0;
> > +     }
> > +}
>
> Please rename this function to kvm_apic_inject_pending_timer_irqs and
> call it from kvm_inject_apic_timer_irqs.
>
> Then apic_timer_expired can just do
>
>         if (atomic_read(&apic->lapic_timer.pending))
>                 return;
>
> +       if (unlikely(posted_interrupt_inject_timer(apic->vcpu))) {
> +               kvm_apic_inject_pending_timer_irqs(apic);
> +               return;
> +       }

Do it in v2.

Regards,
Wanpeng Li
