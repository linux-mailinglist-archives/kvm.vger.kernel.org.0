Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3B9D94E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 00:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfHZWjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 18:39:06 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44396 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfHZWjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 18:39:06 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so33113840iog.11
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 15:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vj/S7jjU3jKgz2U6enZ47KqQXxikDOW/jPjW399kyoI=;
        b=ARF98h46F8hh8FwqXVk3FW5RpGS3C8xLe5uDOIMF0/zLBZiHiMMBET3go9L9Ei9FGV
         oJ7t6gxblz6nNUwYfdIFIdglH9eogyzpmqjnW3sVCnM3U0PjaXpHoAECOStbd3YLRgkB
         NuU6Ph+If4flYXB6c+546VO57oCKHIABwRlF00bu/4BXZwhPieVg1bLnbs8WM3rfON/B
         aKH65KkNYnYQTW6Y2Z2J54j6atwdY0/dVq9hgjtBk5SPg3AQYx7jVUSjURNxnc+YBj93
         Lz19jTSTwS1MhWd6FhIfxgNoOsjlBq4AadttmwRwUjtkjePH4wPniZIl/ETubLgAVKXS
         S7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vj/S7jjU3jKgz2U6enZ47KqQXxikDOW/jPjW399kyoI=;
        b=Wz8OQTaffTPRJBRAU7wl5+dT2p+BDPpO7c4IfKdI9xUoD8U7fVg/wmNveZy5foqFQv
         vQRepGq5oHVr7ElWQHkvc6yZV3xKcEIaorP486CLVynFe4HCsPuB6njlfGDTGlxFpHwg
         TE3rS7HTmVXcofxazFcCfrxfYA1fhj9oILNWjm9EkHcx0IdzMia7gAogT/81J3ZYvA5l
         zqd/7XXC9SoPE1psOwQGBiPbuC8/+6c4hORJzLyCrilteEkkGdADJDQs1o2HrOGQnGxd
         WxxS2cezAxwzUjI6vo0GXYqm54Q2NQ5gnwOkmPxbUIemfufTKXHI90RgsWg5K45VF/rJ
         /vkQ==
X-Gm-Message-State: APjAAAUHvSC/IQAWYBh9wRBL7Iaod9o2SoVlREoZnthDbn8VA2Vt5sIz
        Y2XLzx9rRUAjv5JDTfZPvQcaZKka8oETnJCzIXTZW38aaGU=
X-Google-Smtp-Source: APXvYqxVTl/tvpfHFvfq0vMkd5JKGOw3Y6C0GYxPqXqBqIbAIVgybKrnPQe6jpt+gHmXF+Pgw1LlEM48NKHoJiOnNLw=
X-Received: by 2002:a6b:4e14:: with SMTP id c20mr2768374iob.26.1566859145261;
 Mon, 26 Aug 2019 15:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com> <CALMp9eTDtZo73fCBF+ygPmT2ZmDr5-uSfZrtQSveWQBfMNPnEg@mail.gmail.com>
 <F8517F7A-7F66-4E4A-B4C2-9FB4B628F945@oracle.com>
In-Reply-To: <F8517F7A-7F66-4E4A-B4C2-9FB4B628F945@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 26 Aug 2019 15:38:54 -0700
Message-ID: <CALMp9eTUFVHkWKjDF_xw=yT2EsAuYJ7uDz7YNSX1jjdst7vwZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU states
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 3:04 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 27 Aug 2019, at 0:17, Jim Mattson <jmattson@google.com> wrote:

> > Suppose that L0 just finished emulating an L2 instruction with
> > EFLAGS.TF set. So, we've just queued up a #DB trap in
> > vcpu->arch.exception. On this emulated VM-exit from L2 to L1, the
> > guest pending debug exceptions field in the vmcs12 should get the
> > value of vcpu->arch.exception.payload, and the queued #DB should be
> > squashed.
>
> If I understand correctly you are discussing a case where L2 exited to L0=
 for
> emulating some instruction when L2=E2=80=99s RFLAGS.TF is set. Therefore,=
 after x86
> emulator finished emulating L2 instruction, it queued a #DB exception.

Right. For example, L0 really likes to emulate L2's MOV-to-CR instructions.

For added complication, what if the emulated instruction is in the
shadow of a POPSS that triggered a data breakpoint? Then there will be
existing pending debug exceptions in vmcs02 that need to be merged
with DR6.BS. (This isn't anything new with your change, though.)

> Then before resuming L2 guest, some other vCPU send an INIT signal
> to this vCPU. When L0 will reach vmx_check_nested_events() it will
> see pending INIT signal and exit on EXIT_REASON_INIT_SIGNAL
> but nested_vmx_vmexit() will basically drop pending #DB exception
> in prepare_vmcs12() when it calls kvm_clear_exception_queue()
> because vmcs12_save_pending_event() only saves injected exceptions.
> (As changed by myself a long time ago)
>
> I think you are right this is a bug.
> I also think it could trivially be fixed by just making sure vmx_check_ne=
sted_events()
> first evaluates pending exceptions and only then pending apic events.
> However, we also want to make sure to request an =E2=80=9Cimmediate-exit=
=E2=80=9D in case
> eval of pending exception require emulation of an exit from L2 to L1.

Hmmm. Any exception other than a #DB trap should take precedence over
the INIT. However, the INIT takes precedence over a #DB trap. But
maybe you can fudge the ordering, because there is no way for the
guest to tell which came first?

What about a single-step trap on VMXOFF, with the INIT latched? In
that case, the guest could tell that the INIT was latched before the
VMXOFF, so the INIT must take precedence. Do we get that ordering
right?
