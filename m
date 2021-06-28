Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A71E3B67E9
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhF1Rqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhF1Rqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 13:46:53 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D2EC061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 10:44:27 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id o13-20020a9d404d0000b0290466630039caso4431181oti.6
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 10:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hteoZM+GD4ovVieM4M7OVaRDXGJH7guuG69T9/rMvbI=;
        b=D7VXTVjQW1c31E/cloKCNnF8KDdXxJMFKQfK1yf5wke0UjHmbbMO4jaPOSIKH6ul25
         AJydFoCP59kLedS6dBni73tnqAfj13Bd9IHCP8bab+0kdlKQpOynb0Gz3ETNllElHmz3
         QT+xp+SXT+GyKx44njbaBnwWd8t5eP0drH6ghJwdzjEPanfX5WpnfBpN0bY3TCXtVR+C
         IvcGLGTzB5o5Kue0UyK2Vpym9DLLPADiJ2yA8FTLea0uQ0vkjURzhpPCAJnVTW085FHQ
         HJJBUWjMbEfKF6JhEQQhopgy/A7i2tani4oGCbzW2Qx2NpHr8jqOUndEd6myiPh8BW3J
         3ujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hteoZM+GD4ovVieM4M7OVaRDXGJH7guuG69T9/rMvbI=;
        b=rEHVrtS1Rp4vLYKEuZApKl1/MXOQVo390RuOBKitnaA0K92qjathgOzZ+JiO6Wo7KQ
         x9v2h18Wr6URSnTa7Qc/vm/d1dNYE9b/0yNgc4o9IWf2TsxZhwej7FQJnj5kHj2r/zsB
         dce2i3WZu9Boad8mfyORCUjnQz2FfA3RoQyJod3awlTnw7+P0vYcsG4/MnlMV+WDRJMz
         bSvVHZaBZpZA4QcPJvZwJyHBfvXNgYjWGKYn8h8UewRZva+iPCbcNQ9V9cbhJ//nZYmt
         NN4VNYc473Wq+t2GK/iqv69+rFZQq+kYsOE9/gyWeioQk7Gzf/v7c99j0D3Fi6Aw4FrB
         9FSw==
X-Gm-Message-State: AOAM532aP3lJj127svs4N1ET2VFqKLtVOhanoPIg/tDWn7+Yz+MH1MXw
        qNt38zD+fVK3FpIzQUss0ftxjDbuN1m4etTDkT2BMQ==
X-Google-Smtp-Source: ABdhPJxRSSxVJjj3DO8+QgGyH7Q4bsKQxGEaReR7Qa3bv3NLQpACxQt1u7YuoOt8vwYSVeEVbQLzoY2Fm6Zf+0EcmaI=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr622966oth.241.1624902266567;
 Mon, 28 Jun 2021 10:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210627233819.857906-1-stsp2@yandex.ru> <CALMp9eQdxTy4w6NBPbXbJEpyatYB_zhiwykRKCpeoC9Cbuv5gw@mail.gmail.com>
 <a6a8fe0b-1bd3-6a1a-22bb-bfc493f2a195@yandex.ru>
In-Reply-To: <a6a8fe0b-1bd3-6a1a-22bb-bfc493f2a195@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 10:44:15 -0700
Message-ID: <CALMp9eSfC0LC4qCUNHv4qfvP=HhErQmVNqmnzfzebpOOMCLjeQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 10:06 AM stsp <stsp2@yandex.ru> wrote:
>
> 28.06.2021 19:19, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > This doesn't work. Kvm has no facilities for converting an injected
> > exception back into a pending exception.
>
> What is the purpose of the
> cancel_injection then?

I believe cancel_injection exists for serializing the vCPU state. If
the vCPU is saved and restored, then you don't want to lose the
'injected' event that is sitting in the VMCS.

>
> >   In particular, if the
> > exception has side effects, such as a #PF which sets CR2, those side
> > effects have already taken place. Once kvm sets the VM-entry
> > interruption-information field, the next VM-entry must deliver that
> > exception. You could arrange to back it out, but you would also have
> > to back out the changes to CR2 (for #PF) or DR6 (for #DB).
> >
> > Cancel_injection *should* leave the exception in the 'injected' state,
>
> But it removes it from VMCS, no?
> I thought "injected=3Dtrue" means
> "injected to VMCS". What is the
> difference between "injected" and
> "pending" if both may or may not
> mean "already in VMCS"?

Pending events have not yet been subject to interception by L1 (if L2
is active). Their side effects have not yet been applied. When a
pending event is processed, if L2 is active, kvm checks L1's exception
bitmap to see if the event should cause an emulated VM-exit from L2 to
L1. If not, the pending event transitions to an injected event and the
side effects are applied. (At this point, the event is essentially
committed.) The event is then written to the VM-entry
interruption-information field to take advantage of hardware
assistance for vectoring through the IDT.

Perhaps 'committed' would have been a better term than 'injected.'

> > and KVM_SET_REGS *should not* clear an injected exception. (I don't
> > think it's right to clear a pending exception either, if that
> > exception happens to be a trap, but that's a different discussion).
> >
> > It seems to me that the crux of the problem here is that
> > run->ready_for_interrupt_injection returns true when it should return
> > false. That's probably where you should focus your efforts.
>
> I tried that already, and showed
> the results to you. :) Alas, you didn't
> reply to those.

I haven't had the time. I was hoping that someone else on the kvm list
would help you.

> But why do you suggest the cpu-specific
> approach? All other CPUs exit to user-space
> only when the exception is _really_ injected,
> i.e. CS/EIP points to the IDT handler.
> I don't see why it should be non-atomic
> just for one CPU. Shouldn't that be atomic
> for all CPUs?

This isn't CPU-specific. Even when using EPT, you can potentially end
up in this state after an EPT violation during IDT vectoring.
