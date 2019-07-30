Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4CD7A8FB
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfG3Mvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:51:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40940 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfG3Mvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:51:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so56569437wmj.5
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xlyMVEJE1Dy/QWFW2G9NXycH3WhR1tYzSwV5Ut1wIIw=;
        b=QyvteSpZvYEwd3gV2EtvARV1NGAzZRk5lzI2uo4SdM8QoQ36QBtPMGTg3JDRwhcFtR
         RpXL7DNOrvr1lP7GhriG0Fa+aGdcjHMS+hpGS/kuo+pyYMKQGSE/4of7VqDGY+vov/H5
         r7TNVf6EaAi7cC0DnOnJ8wtNZBkHk4vNlcrh1ex5A3pQBSfBT+j2zbjCJPGbIMeZu/pq
         QhcWAsS+vVjtTKy53+LSoBPyGfeqqHaHvqqYScc3s0Jm+WXk5so/EBMKcqspHr9pmK1W
         vBxsbxpgKH/VGIvvIDaorODcrwTeuSmfNl9AykChCaUJi0k828CGXOd2XLSlKY4SXwCU
         Todg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xlyMVEJE1Dy/QWFW2G9NXycH3WhR1tYzSwV5Ut1wIIw=;
        b=RCBlt7YIaqwoNH1UnCnhrFZq2dF0ezW8xg51IYOx0lq6UkCZGijn6hOhIg9YT+4hmS
         dYJsltLID07oV53t3J08th1Je5erNTON2QEQ09wjxaPZ9Ho6OnYdPXjHbVMThCIBquWD
         1/OPyLLTCfGhnX96Ooc84Os3IEYSuBM4F+sjFTrwN1dPx0sS2atD58ibdILUthaiuKMh
         8+LRlu+t/19J7rksWNsUs+kUGVF4LYmCAsO7X/U/4MSNkbxgWVaCFLsjWH4dCXgZxaDy
         7jZLBCuY8hx05OgHIU0MFxWEZ81GAY73wKBHjz76TbsZF6t1nKAwu/yYFURKxW49QZvL
         hDOQ==
X-Gm-Message-State: APjAAAVykMj0ITWGVxs1mwVxYuQbHS7Y6hsJLIUazKr53gr3tDDPdbTE
        qMDuoaJrSW1EzclD/nZmC9L/zCCWLQrINiWvtCA=
X-Google-Smtp-Source: APXvYqxuguKU0X+siFrvn9HOub5fk0XoQDRv8R/r/X/5oWCQQU/kraAMUh75sFlJTua5yk0lVONdEWCEt0D0+4rQl0o=
X-Received: by 2002:a1c:e0c4:: with SMTP id x187mr100750011wmg.177.1564491096568;
 Tue, 30 Jul 2019 05:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-8-anup.patel@wdc.com>
 <cbb1b995-be2f-96a5-9890-63e1941e7f3c@redhat.com>
In-Reply-To: <cbb1b995-be2f-96a5-9890-63e1941e7f3c@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 18:21:24 +0530
Message-ID: <CAAhSdy2KbiEq35NSyKHNjrxbJOeh0U02mmf=bueDuXCEZCyXpg@mail.gmail.com>
Subject: Re: [RFC PATCH 07/16] RISC-V: KVM: Implement VCPU world-switch
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 3:04 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/07/19 13:57, Anup Patel wrote:
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > -     /* TODO: */
> > +     struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > +
> > +     csr_write(CSR_HIDELEG, csr->hideleg);
> > +     csr_write(CSR_HEDELEG, csr->hedeleg);
>
> Writing HIDELEG and HEDELEG here seems either wrong or inefficient to me.
>
> I don't remember the spec well enough, but there are two cases:
>
> 1) either they only matter while the guest runs and then you can set
> them in kvm_arch_hardware_enable.  KVM common code takes care of doing
> this on all CPUs for you.

This is a good suggestion. I will use kvm_arch_hardware_enable() for
programming HIDELEG and HEDELEG CSRs.

>
> 2) or they also matter while the host runs and then you need to set them
> in vcpu_switch.S.

They don't matter in HS-mode so we don't need to access them in
vcpu_switch.S

Regards,
Anup
