Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1D31285A3
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 00:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLTXpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 18:45:44 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46209 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfLTXpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 18:45:44 -0500
Received: by mail-io1-f68.google.com with SMTP id t26so11054245ioi.13
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 15:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2VVoGEzfR7gG4AluE0EIlluC91OZtoA+xaJXujx9EZA=;
        b=fDddvzBb0bYbEvg2ftxslgpoxEewFZ/Kex/j4djuhoeS4r4YTD+7rhUUiwlFtYhzKi
         Gl1Z7EtniYAfN9Ruc13+zc4x9ruUDseNybwv5OL/Ktnkpe+9zAisaB9r9nDFlW9rm768
         ElCd59YH1eXi5XWW1QYFgml2d8E5PjcXG7gSnQ8IAB800j35JmLYaIYZcXzTEgofbS/a
         M1Vf2qbri5SamAscRWbgoskm+wCaZF4F1JcIO4YSsQ/5ridbpOWbJn7USXR/c3asZswy
         XG7IRinwL+v/9/T+8amRzugQ8lneun6LajG5tkad7ipfvDf3EGC/GHPj02YZ+o11oIf8
         aXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2VVoGEzfR7gG4AluE0EIlluC91OZtoA+xaJXujx9EZA=;
        b=Vz2bLMHH/dAq6BFQfAO5Ao9otMCRaZAXG41hr+Dv/LjrikkuF9q6VMLJBXTp1rePm4
         iEoWIs4GHCLve6x8Vd/pNaTPzudNuXVWmnjSfqhR7JvIipe+YvfrQr6WMJl2nQI+O5mr
         DhQ00U/3QilRYrq8/9H2TdNhlOJM2hAoujSgzlA4+2OjPpKH7IuFVI6Q3sxH9jC1romz
         HQxX31rJ0P3kRqblk3pjIwudMf0UEClOXioxTDi+48C3PssoUWO7KjV3SLHWkQVuD3Bq
         NK6inqg7uSzQ5652/VtLsDkaQBKqq1tSm0PtLq0FgY/JzlN11NuLJNGXWMuhZ8gbd3PG
         SvcA==
X-Gm-Message-State: APjAAAXv0uCmhBqiPBXK0SPuTWO3RxnmEB2T+1NFC9vCNQVygNBYvN5N
        PAZB9KGI2azmNnvEJ84p6sNxlixu/a/MvefYqedMtPa6oXo=
X-Google-Smtp-Source: APXvYqxxsYyzCNu9Eu/1MywB6OE97eDUlHasPK3azbCI8cKUplzk3B6ajOmm1egl8JHy3xYXhJ+Ts/H2KWyVR4H1ma8=
X-Received: by 2002:a5d:8cda:: with SMTP id k26mr12131599iot.26.1576885543547;
 Fri, 20 Dec 2019 15:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com> <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com> <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
In-Reply-To: <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 20 Dec 2019 15:45:32 -0800
Message-ID: <CALMp9eR2GQ_aerH-arOEpa08k8ZdtYCA5ftxHfDCo5fS1r3VtA@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 4:15 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Aug 30, 2019 at 4:07 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >
> >
> > On 08/29/2019 03:26 PM, Jim Mattson wrote:
> > > On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> > > <krish.sadhukhan@oracle.com> wrote:
> > >> According to section "Checks on Guest Control Registers, Debug Registers, and
> > >> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> > >> of nested guests:
> > >>
> > >>      If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
> > >>      field must be 0.
> > > Can't we just let the hardware check guest DR7? This results in
> > > "VM-entry failure due to invalid guest state," right? And we just
> > > reflect that to L1?
> >
> > Just trying to understand the reason why this particular check can be
> > deferred to the hardware.
>
> The vmcs02 field has the same value as the vmcs12 field, and the
> physical CPU has the same requirements as the virtual CPU.

Sadly, I was mistaken. The guest DR7 value is not transferred from
vmcs12 to vmcs02. It is set prior to the vmcs02 VM-entry by
kvm_set_dr(). Unfortunately, that function synthesizes a #GP if any
bit in the high dword of DR7 is set. So, you are correct, Krish: this
field must be checked in software.
