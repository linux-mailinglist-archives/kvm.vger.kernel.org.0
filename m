Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAD08166D
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 12:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfHEKH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 06:07:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37789 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbfHEKH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 06:07:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so72380065wme.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 03:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tSUXfM1GBDtf8d32fnO2t1HSYdqv9TrCrzBesx2Y2r4=;
        b=WoKh7uXp2eFvRFtfyoLMbFxpofblGAbjiJeO/5jm2jytnH6nWtmyKskqrbx75YeQWG
         V5X7FxP/4rjog38emeYGlmLnkeMOnf/BovPbxPMYUu1xq8C06dJClKqTkSefpyeXPPOR
         dloeYq+6c+Bto8i7g08vh6qO6tGk3b03w48RVdW9q29kxiHA8HgPPAV4mLyCLFVVpCLz
         kGN3tWenMO7frIPuKlDOwk2KIxPb19lqRl/xDfpWxOpa4a5PkBCTuNuc7hBrXfCcpfdY
         xve9XgkFXCe7koQs7AwdgsJb3Ahy04Zm5nfaceawYlnZHHLDT4nMuItmA2DL0whAfhXI
         ly9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tSUXfM1GBDtf8d32fnO2t1HSYdqv9TrCrzBesx2Y2r4=;
        b=qwTrLluaCQ+0E3267kBv+y7a5a6gXNvj9uQBsvwWFaatUpolto9HI4HcO/yfjaDsqF
         z7QFCWbrTuDVEzPpL4Z57qUg7YeelvudVmi6Wvq94mr1vlbHnKs03HMsIVK1z1Y+t8lQ
         3L9SLbinAee1Lz+KQ9btVw1qtel+Wn5gTYawcngM/sgvet+NjYm97vapR2yTWJqqxh8+
         Mj1YDWe/Oe/vOtQ6LUHSscTj/JoNs3Pd2L1PYlWhCwG+RlbqU0QnXV5degZM5TPtAv7x
         GBiM9jhErgsaiyJsaOs28FbLcJfS016u8zvuOTSAVo+ukqCH31cj2aXADdwQmKEeTcAu
         l6eg==
X-Gm-Message-State: APjAAAUc9/nhIo2ZrkqhqUp3GWWMOLNS9TnYXBs+7eF1fxJTAerEjsen
        DbsyH4g4aw03+Qcgpqy9LuruK4nee6Acl+S+No+JYA==
X-Google-Smtp-Source: APXvYqyaxuGvgZY+LJ4vNWfPOtT80YRzrJxZJ6KszUHbn8NrKf0wYNwoLXDFfS7cWakR5cKffBu7arak9gV7Z9wXleg=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr16590824wmg.24.1564999643825;
 Mon, 05 Aug 2019 03:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-12-anup.patel@wdc.com>
 <ef688903-ff49-ffeb-1f95-ef995942d5dc@redhat.com>
In-Reply-To: <ef688903-ff49-ffeb-1f95-ef995942d5dc@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 15:37:12 +0530
Message-ID: <CAAhSdy2y+DfV0b7dG_V43AL_MVz2R+LzEsE0y8YuiJY_EBeabg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 11/19] RISC-V: KVM: Implement VMID allocator
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

On Fri, Aug 2, 2019 at 2:49 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 09:48, Anup Patel wrote:
> > +struct kvm_vmid {
> > +     unsigned long vmid_version;
> > +     unsigned long vmid;
> > +};
> > +
>
> Please document that both fields are written under vmid_lock, and read
> outside it.

Sure, will add comments in asm/kvm_host.h

>
> > +             /*
> > +              * On SMP we know no other CPUs can use this CPU's or
> > +              * each other's VMID after forced exit returns since the
> > +              * vmid_lock blocks them from re-entry to the guest.
> > +              */
> > +             force_exit_and_guest_tlb_flush(cpu_all_mask);
>
> Please use kvm_flush_remote_tlbs(kvm) instead.  All you need to do to
> support it is check for KVM_REQ_TLB_FLUSH and handle it by calling
> __kvm_riscv_hfence_gvma_all.  Also, since your spinlock is global you
> probably should release it around the call to kvm_flush_remote_tlbs.
> (Think of an implementation that has a very small number of VMID bits).

Sure, I will use kvm_flush_remote_tlbs() here.

>
> > +     if (unlikely(vmid_next == 0)) {
> > +             WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
> > +             vmid_next = 1;
> > +             /*
> > +              * On SMP we know no other CPUs can use this CPU's or
> > +              * each other's VMID after forced exit returns since the
> > +              * vmid_lock blocks them from re-entry to the guest.
> > +              */
> > +             force_exit_and_guest_tlb_flush(cpu_all_mask);
> > +     }
> > +
> > +     vmid->vmid = vmid_next;
> > +     vmid_next++;
> > +     vmid_next &= (1 << vmid_bits) - 1;
> > +
> > +     /* Ensure VMID next update is completed */
> > +     smp_wmb();
>
> This barrier is not necessary.  Writes to vmid->vmid need not be ordered
> with writes to vmid->vmid_version, because the accesses happen in
> completely different places.

Yes, your right. There is already a WRITE_ONCE after it.
>
> (As a rule of thumb, each smp_wmb() should have a matching smp_rmb()
> somewhere, and this one doesn't).

Sure, thanks for the hint.

>
> Paolo
>
> > +     WRITE_ONCE(vmid->vmid_version, READ_ONCE(vmid_version));
> > +

Regards,
Anup
