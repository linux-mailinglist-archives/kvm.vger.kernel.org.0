Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D21F1048DD
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 04:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKUDQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 22:16:45 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43318 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUDQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 22:16:45 -0500
Received: by mail-ot1-f67.google.com with SMTP id l14so1617095oti.10;
        Wed, 20 Nov 2019 19:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W8NJFXMq1hP4Qw4qrsGTgJ6LydZYVSf7XvUILF35TkI=;
        b=e42q5Dt7gHmj9sk3HkUelEJSbwzQa5GeZLVk7+svkiu0ehkrRBfykcQ7JH7/X6HYA4
         I46io4ICsit03LC1b71x8Wt4azLEocRlomjDC7ZBqnF/2uHf8hjdFDUXD1GjPJ4C6Pk5
         KrsXjEKiTB+reJQkXh+sxGCfu1iGhnDnozGVrq0nLC15xL3XqvGQLwuC0aFConcDXfWs
         /WE7bWtY+LdFihCVHTT4zg2eEGo1cAcsnyyzAwbG+PU++U9ZRFGOlhziGvL0nUEE3NC/
         dbnmlEJnWthi9pC7mJLqwYNrlzriPq7xtlaXUjHtUzqwtmEhdcY5wH0ArmZFz7Zts+Be
         Cnhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W8NJFXMq1hP4Qw4qrsGTgJ6LydZYVSf7XvUILF35TkI=;
        b=Lf5kAgzpfOXG12qeMYiSPeeQHEsBVZtg67YO863L7A16TIvFUdXMqzvO7zK7gpXEMk
         sFDEW+YmPpsvSuBzMKFUTAE2gE31QLxhUfhl3ZA/lCrEdH6Pyz2GQJe9ESw20LwrJJv9
         7cSMBK91nmGT/1S8MrqF3kiQWhtLpqwuugzmJHff+JKfd9puuAbxaTLg8Snl7tuZemx6
         2hzBYhwHzd3rdwN55CZLr/DGhabGtDIWz2Zg/xjXdZp+rS0W22PFq7blTvMfJ7Ca9e+G
         0hpz+Xk0Tgvhpu4d8Bvkz+Z3A+Ia7jHauCcLrXC9cTdCHmZJmCui5J8BV4AoGX+znGCY
         wlLQ==
X-Gm-Message-State: APjAAAXPmolPXkdKzZjnXisB9uJkLdA4/3vYvH8/1/Or2JSJ6W8JV5WC
        L/PI1rQ9wgN/7kLgvp2ixT5MD/gbhUVrfW1WFad5Lg==
X-Google-Smtp-Source: APXvYqzhuStBie25VFTE/1Gzpl/ag0wWxervXgFlKbr2I1x3phPpgtQIXbEF2Zfjzsh+WUETR40DR4fRj9afDw+lmrU=
X-Received: by 2002:a9d:b83:: with SMTP id 3mr4524380oth.56.1574306204696;
 Wed, 20 Nov 2019 19:16:44 -0800 (PST)
MIME-Version: 1.0
References: <1574221329-12370-1-git-send-email-wanpengli@tencent.com> <61E34902-0743-4DAF-A7DF-94C0E51CDA08@oracle.com>
In-Reply-To: <61E34902-0743-4DAF-A7DF-94C0E51CDA08@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 21 Nov 2019 11:16:36 +0800
Message-ID: <CANRm+CyyEda_X=+Nzo0QV-75eeVSi0c3E69piG0TrhK-+7sZWg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Liran Alon <liran.alon@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 at 07:37, Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 20 Nov 2019, at 5:42, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in
> > our product observation, multicast IPIs are not as common as unicast
> > IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
>
> Have you also had the chance to measure non-Linux workloads. Such as Wind=
ows?

I ask around, guys not pay attention to IPIs under windows guests before.

>
> >
> > This patch tries to optimize x2apic physical destination mode, fixed
> > delivery mode single target IPI. The fast path is invoked at
> > ->handle_exit_irqoff() to emulate only the effect of the ICR write
> > itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
> > flow reduces the latency of virtual IPIs by avoiding the expensive bits
> > of transitioning from guest to host, e.g. reacquiring KVM's SRCU lock.
> > Especially when running guest w/ KVM_CAP_X86_DISABLE_EXITS capability
> > enabled or guest can keep running, IPI can be injected to target vCPU
> > by posted-interrupt immediately.
>
> May I suggest an alternative phrasing? Something such as:

Great, thanks for better English.

>
> =E2=80=9C=E2=80=9D=E2=80=9D
> This patch introduce a mechanism to handle certain performance-critical W=
RMSRs
> in a very early stage of KVM VMExit handler.
>
> This mechanism is specifically used for accelerating writes to x2APIC ICR=
 that
> attempt to send a virtual IPI with physical destination-mode, fixed deliv=
ery-mode
> and single target. Which was found as one of the main causes of VMExits f=
or
> Linux workloads.
>
> The reason this mechanism significantly reduce the latency of such virtua=
l IPIs
> is by sending the physical IPI to the target vCPU in a very early stage o=
f KVM
> VMExit handler, before host interrupts are enabled and before expensive
> operations such as reacquiring KVM=E2=80=99s SRCU lock.
> Latency is reduced even more when KVM is able to use APICv posted-interru=
pt
> mechanism (which allows to deliver the virtual IPI directly to target vCP=
U without
> the need to kick it to host).
> =E2=80=9C=E2=80=9D=E2=80=9D
>
> >
> > Testing on Xeon Skylake server:
> >
> > The virtual IPI latency from sender send to receiver receive reduces
> > more than 200+ cpu cycles.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> I see you used the code I provided my reply to v2. :)
> I had only some very minor comments inline below. Therefore:
> Reviewed-by: Liran Alon <liran.alon@oracle.com>

Thanks, handle them in v4.

>
> Thanks for doing this optimisation.

Thanks everybody who help make this work nice. :)

    Wanpeng
