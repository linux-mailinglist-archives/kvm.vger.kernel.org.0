Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6462035D919
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbhDMHj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhDMHjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 03:39:12 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C04C061574;
        Tue, 13 Apr 2021 00:38:52 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id m13so16117187oiw.13;
        Tue, 13 Apr 2021 00:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=024Rs0XBJGzrTJn9+SBx5vZymj7Q4VHq/rycY6e4Vb0=;
        b=ephV7M1m8HfGJjwd9N/jSEFLIbOPBP4VJhYq5xXWxoPPVz0CY3kLlY/fPx4TDiToEl
         64fQrLLSxnqeIr2b7yqaxTHVNBTvutOr0R5rGbQTpySYhfwkJ3ryxzSpiKoX2pR6LYYe
         jfyO2I/PiGMbht0zVI5OpnUSv4KA61j91msJEeujFyeiFFHlcIJvX5kKclKp8MaCuWrn
         c/Crhqa0pvOm2/ivUMypglTNCKCp+z03hlUGPbD3+0ONk4SFf8/DE26TMu+r0v2sII2S
         eIAkVi3rYxx0iDkA4xIDd+5tKSXgz4Blb2HxoDz9sNMPatT2XC8yf/EHvpvMSljiLbZT
         2cPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=024Rs0XBJGzrTJn9+SBx5vZymj7Q4VHq/rycY6e4Vb0=;
        b=RzrmQHhkP+Tf7R86jmbXb1WwgzHAwnPWvdM+dtEFcSN2mEZuuA1EyYvF5jVXqwNTLz
         oG7xwCYw1wZQNYlC0JZw8+3xe+U2ngu+LT45HDy5FrtVc0greIA/kfu4sxHo/1OGye+/
         hUY7397o5yHvEk3slM+zsMv8zaJGy218123bFa74Oj4u3JrLtgd65dgkz6ezj4Wyao63
         whEN6WRAFOBi/jM6UNtdi6he7iZN3A1IWdDiSXGYu1Q7PyvhfFxd3sCndY8ahLlh7WLG
         5QaQ3U+lxJMvdkucocAnL3FJNW53cQn3+bFEYN2wKuqK6E+EGIbSjNAyDv53g7QKjoZk
         NRLA==
X-Gm-Message-State: AOAM533D3ubG4XSKsmkYs7rUVHmXSDQ5LjcBe2/snSszF5MdoG9zaQRl
        TYIY2sEL4BDzqCsIciklX25q8tONOJoX0invyLc=
X-Google-Smtp-Source: ABdhPJwS/KzITtWY+54lBIYyhhWhopJAycSWbf9Reux6PL2xwBofkeoFdKxHpQumHhSmu9XcOCFXbxA02s1b+W/MjYs=
X-Received: by 2002:a54:408a:: with SMTP id i10mr2351312oii.141.1618299532351;
 Tue, 13 Apr 2021 00:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <1618298169-3831-2-git-send-email-wanpengli@tencent.com> <81112cec-72fa-dd8c-21c8-b24f51021f43@de.ibm.com>
In-Reply-To: <81112cec-72fa-dd8c-21c8-b24f51021f43@de.ibm.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 13 Apr 2021 15:38:40 +0800
Message-ID: <CANRm+CwNxcKPKdV4Bxr-5sWJtg_SKZEN5atGJKRyLcVnWVSKSg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] context_tracking: Split guest_enter/exit_irqoff
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 at 15:35, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 13.04.21 09:16, Wanpeng Li wrote:
> [...]
>
> > @@ -145,6 +155,13 @@ static __always_inline void guest_exit_irqoff(void)
> >   }
> >
> >   #else
> > +static __always_inline void context_guest_enter_irqoff(void)
> > +{
> > +     instrumentation_begin();
> > +     rcu_virt_note_context_switch(smp_processor_id());
> > +     instrumentation_end();
> > +}
> > +
> >   static __always_inline void guest_enter_irqoff(void)
> >   {
> >       /*
> > @@ -155,10 +172,13 @@ static __always_inline void guest_enter_irqoff(void)
> >       instrumentation_begin();
> >       vtime_account_kernel(current);
> >       current->flags |= PF_VCPU;
> > -     rcu_virt_note_context_switch(smp_processor_id());
> >       instrumentation_end();
> > +
> > +     context_guest_enter_irqoff();
>
> So we now do instrumentation_begin 2 times?

Similar to context_guest_enter_irqoff() ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN.

    Wanpeng
