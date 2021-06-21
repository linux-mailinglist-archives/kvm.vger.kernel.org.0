Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD23AF898
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 00:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhFUWgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 18:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhFUWgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 18:36:22 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FC4C061756
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 15:34:07 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id v11-20020a9d340b0000b0290455f7b8b1dcso6426716otb.7
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 15:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DIEaAdhYLn2ObxgkdO43eKzaGE5c/AnFoDKU5gNxSU8=;
        b=tL9OyUZ9F98klGMtms1GaSBPGfqvwqaDJQT8BeJI3mK1ic4rANTyISmdKuEqIxF0bj
         bgL2x6hkRZOWvp1MjplApdvsvuckpFH/xaXSc2n7LZbb6iPfss0o30gr/GiyKnAwT+E4
         rJANrMR9RzMxtGhLdUayiJ1B/fIezx7flO0RLD8kPAubOvk3nimS0CTd91DSuJjXTI5X
         7PyRoswXkplF+NKT3FaZQ4SI8Mo3YhhCsE6zK4i0VsXMtKtIpyBlZcUfQ5Aaknv/HgF4
         acN9lml0hyjcWQIHh2gK6HkAJbsw0EKCIUbdlAPs7zNGGWuFhxqRp4X8g9U06pjLmrOr
         MJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DIEaAdhYLn2ObxgkdO43eKzaGE5c/AnFoDKU5gNxSU8=;
        b=TmCTwhOfYmxVO/y3HGKB2FpaVvq6jbr7pf4Rmi6S6Pt87CmtG0Ak5kM7FhtDa+BKNF
         27ug2qdbiHMLtcoHrfWJZN5Ik3/UYkY558kAlA7EjUWVNsUDUFhZEJFMAUK4+QpP13aX
         9VTQaVGKxp5eYM6l3OyczTp8JbWo1KyZc1hf1A3cSsYI/h7ECAzqqTJjoF6mQEWBppPt
         xlVtLy2OUsFhBGuv3Wdwp4Ny20xHeAg6d/TJvOxhKNWn30kiUgQCd8x1OjoUcn3yN5Mn
         CtAvmW5z4UYxcFdYevfyhZebpffHtiJHFvwQflXlHhh75M6QB4z2ICc9sR0tf8m7hH+c
         Entg==
X-Gm-Message-State: AOAM530qOKUuC9i7x+us3PV6MiisTsUnkw0c2Nqqe5UBsFfjqTxDmX7z
        y0zGZVKiOolF0XQm/rn6qc9vf7C4gnMUkaPsTRg28g==
X-Google-Smtp-Source: ABdhPJxjoZIxSj6dXU/MWzfmmZgYcojQZIOQp5ZQd8mEIzPGeRsOFiE8R9zlwAgGgxkZ/RFDMI36SwJCJzus62C7ppA=
X-Received: by 2002:a05:6830:2011:: with SMTP id e17mr298279otp.295.1624314846280;
 Mon, 21 Jun 2021 15:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com> <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com> <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com> <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
In-Reply-To: <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 21 Jun 2021 15:33:55 -0700
Message-ID: <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on core2duo?)
To:     stsp <stsp2@yandex.ru>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 20, 2021 at 7:34 PM stsp <stsp2@yandex.ru> wrote:
>
> 19.06.2021 00:07, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers=
:
> OK, so this indeed have solved
> the biggest part of the problem,
> thanks again.
>
> Now back to the original problem,
> where I was getting a page fault
> on some CPUs sometimes.
> I digged a bit more.
> It seems I am getting a race of
> this kind: exception in guest happens
> at the same time when the host's
> SIGALRM arrives. KVM returns to
> host with the exception somehow
> "pending", but its still on ring3, not
> switched to the ring0 handler.
>
> Then from host I inject the interrupt
> (which is what SIGALRM asks for),
> and when I enter the guest, it throws
> the pending exception instead of
> executing the interrupt handler.
> I suspect the bug is again on my side,
> but I am not sure how to handle that
> kind of race. I suppose I need to look
> at some interruptibility state to find
> out that the interrupt cannot be injected
> at that time. But I can't find if KVM
> exports the interruptibility state, other
> than guest's IF/VIF flag, which is not
> enough in this case.

Maybe what you want is run->ready_for_interrupt_injection? And, if
that's not set, try KVM_RUN with run->request_interrupt_window set?

> Also I am a bit puzzled why I can't
> see such race on an I7 CPU even
> after disabling the unrestricted_guest.
>
> Any ideas? :)

I'm guessing that your core2duo doesn't have a VMX preemption timer,
and this has some subtle effect on how the alarm interrupts VMX
non-root operation. On the i7, try setting the module parameter
preemption_timer to 0.
