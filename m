Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A29E7EF8C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 10:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404378AbfHBIoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 04:44:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44621 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbfHBIoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 04:44:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so76288906wrf.11
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 01:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fvZtEUHzSAKzVrV5AOyqmz39HB0VJQNW+QYwyaRSP8=;
        b=eVWg8TPmTdTRpDNDCOsjC4/KOvtHtbA59TBmQpqBTpEAcbGe1sHWV9Ml4O0/GHWjIC
         TIk0QMnDFaqET3emtRhSQaQHsG2RAbId4A2KPGGTXL7s29NqSW0K7GhCoMcmZ+KZ8dKI
         PwC6FuSYrrbGPGJf7mkFuicfKeymU78FbY7saknYYNLWo+vqWdXIxb2vNEl+c/oSo1vJ
         D72TyjVS2XCILOUSIqknYw+d+6Lri7hcad32mztop9cmXfd93VlHjoizzJNNbHW94HmX
         c5BZ/dtEwOAoDlwI85Byw8UHZh49hT1dy6qXDhYaW/bYdZh16X7zSNGwUAWBPXZVo3k4
         lV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fvZtEUHzSAKzVrV5AOyqmz39HB0VJQNW+QYwyaRSP8=;
        b=thAAy65YTTxm8jBisPR0i29pdrJeMUDtXFRTs85gMPyzFo8CmMVARSCREEVqQ1/Ieq
         mCqo/W/CFLvdM3ZALPXg/bzM+upkJux86JVEw9ElCuXCf5AdD85hSJQu0DtbM0OTW7Fn
         d1DQbiFzpUFHZJeQUT4A6h+92GftjPfoL7o+ltMahK/HoaoEIKs9CMnN9+JVhKs36lCk
         o6uNPvw8Si+7qgJ5diwQkdtM+zyf+6WzU9pfKRbNj5J0xxGqH1WOdEbQ1ycIHWQ6sWsr
         O1ByDqP/+YcFpI4gzMJ08v0mFehHxZZcPB0GklgO8oLm+IiDqwo0uSD6D8Sq9AlCpt51
         rGNA==
X-Gm-Message-State: APjAAAWlyZNUcgDI/8S+zbWf+fRjFdoRU1iuwCAXtxXgnOrhSeSEmqca
        yHV+N/EBjHaraqm/InfHCoKpAnnf9HETapa2ejY=
X-Google-Smtp-Source: APXvYqxas7y2Zc7v8qVSPU0beTBrHfoNVyfQR6SsOerqrYpig1rTc8AZXwSt8FqQnA9mXGGMe0nRqgvYh5el8Os44GI=
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr136837207wra.328.1564735442789;
 Fri, 02 Aug 2019 01:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-9-anup.patel@wdc.com>
 <72d8efbf-ec62-ab1e-68bf-e0c5f0bc256e@redhat.com>
In-Reply-To: <72d8efbf-ec62-ab1e-68bf-e0c5f0bc256e@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 2 Aug 2019 14:13:52 +0530
Message-ID: <CAAhSdy2_ZsnT7gSKb624r9wzuJSx+1TnKxgW6srtqvXV1Ri9Aw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/19] RISC-V: KVM: Implement VCPU world-switch
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

On Fri, Aug 2, 2019 at 2:00 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 09:47, Anup Patel wrote:
> > +     /* Save Host SSTATUS, HSTATUS, SCRATCH and STVEC */
> > +     csrr    t0, CSR_SSTATUS
> > +     REG_S   t0, (KVM_ARCH_HOST_SSTATUS)(a0)
> > +     csrr    t1, CSR_HSTATUS
> > +     REG_S   t1, (KVM_ARCH_HOST_HSTATUS)(a0)
> > +     csrr    t2, CSR_SSCRATCH
> > +     REG_S   t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
> > +     csrr    t3, CSR_STVEC
> > +     REG_S   t3, (KVM_ARCH_HOST_STVEC)(a0)
> > +
>
> A possible optimization: if these cannot change while Linux runs (I am
> thinking especially of STVEC and HSTATUS, but perhaps SSCRATCH can be
> saved on kvm_arch_vcpu_load too) you can avoid the csrr and store.

Actual exception vector of Host Linux is different so we switch STVEC
every time.

HSTATUS.SPV is set whenever we come back from Guest world so
while we are in in-kernel run loop with interrupts enabled we can get
external interrupt and HSTATUS.SPV bit can affect SRET of interrupt
handler. To handle this we switch HSTATUS every time.

The world switch code uses SSCRATCH to save vcpu->arch pointer
which is later used on return path. Now, I did not want to restrict Host
Linux from using SSCRATCH for some other purpose hence we
switch SSCRATCH every time.

Regards,
Anup
