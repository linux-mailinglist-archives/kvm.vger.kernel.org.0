Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A80D0384
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfJHWoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 18:44:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40768 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJHWoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 18:44:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id d26so96792pgl.7
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 15:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=cndTFj74XfBnpDccOgJNuNPCm40+KTjTKNcRCWrYPjw=;
        b=aUN+I7aHqpCATIiPWezqzDamjk8ThMNKPOAH8Kb5p/uylGtO8R904sTEPEcHjiZqO1
         E9ksaYIi5LosvrEDTBy6iocqNbZQY01ubI8SAVGR+utqcOHwY/dNV7fuTclgf+xOjeAP
         4UVEEkjnL6cMjkTGrj+FU1k2nTJhByiFnfIhDljEtEEaG3laR+byCKZ0i3Sgb7G5olhW
         O/2YSL695qdt5OIz7CGKi59ffGOlNsdYLrMjvFwUxmgeFzMoAtAaU+XLtwW+c5PSPz95
         Qr2a9G5kM5lJKLytBXEX21IkkQnh0mxk7p7AnG9+zp9aXFiGzINsGzTpX0vOsDFiF1Zw
         RtKw==
X-Gm-Message-State: APjAAAUcAbSpNW95yMZAnBdgA8yWN9XmpbL8BFiW8JPW7/A5fb6HA/zi
        YoWvJzDaqlP5P2o10astn82Ryw==
X-Google-Smtp-Source: APXvYqzbPROLFSs4T1aXtA6U9+Ji/gPvV5RxYSzWGKITUh5jHj+7ZwDBnJNNvIdmj2qO/A5TfgUBgQ==
X-Received: by 2002:a17:90a:db4a:: with SMTP id u10mr242738pjx.30.1570574675860;
        Tue, 08 Oct 2019 15:44:35 -0700 (PDT)
Received: from localhost ([12.206.222.5])
        by smtp.gmail.com with ESMTPSA id b22sm152902pfo.85.2019.10.08.15.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 15:44:35 -0700 (PDT)
Date:   Tue, 08 Oct 2019 15:44:35 -0700 (PDT)
X-Google-Original-Date: Tue, 08 Oct 2019 15:44:29 PDT (-0700)
Subject:     Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
In-Reply-To: <8c44ac8a-3fdc-b9dd-1815-06e86cb73047@redhat.com>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, rkrcmar@redhat.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>, anup@brainfault.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@sifive.com>
To:     pbonzini@redhat.com
Message-ID: <mhng-610a5897-96ce-44fc-aa0f-82653808dd86@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Sep 2019 04:12:17 PDT (-0700), pbonzini@redhat.com wrote:
> On 04/09/19 18:15, Anup Patel wrote:
>> +	unsigned long guest_sstatus =
>> +			vcpu->arch.guest_context.sstatus | SR_MXR;
>> +	unsigned long guest_hstatus =
>> +			vcpu->arch.guest_context.hstatus | HSTATUS_SPRV;
>> +	unsigned long guest_vsstatus, old_stvec, tmp;
>> +
>> +	guest_sstatus = csr_swap(CSR_SSTATUS, guest_sstatus);
>> +	old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
>> +
>> +	if (read_insn) {
>> +		guest_vsstatus = csr_read_set(CSR_VSSTATUS, SR_MXR);
>
> Is this needed?  IIUC SSTATUS.MXR encompasses a wider set of permissions:
>
>   The HS-level MXR bit makes any executable page readable.  {\tt
>   vsstatus}.MXR makes readable those pages marked executable at the VS
>   translation level, but only if readable at the guest-physical
>   translation level.
>
> So it should be enough to set SSTATUS.MXR=1 I think.  But you also
> shouldn't set SSTATUS.MXR=1 in the !read_insn case.
>
> Also, you can drop the irq save/restore (which is already a save/restore
> of SSTATUS) since you already write 0 to SSTATUS.SIE in your csr_swap.
> Perhaps add a BUG_ON(guest_sstatus & SR_SIE) before the csr_swap?
>
>> +		asm volatile ("\n"
>> +			"csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
>> +			"li %[tilen], 4\n"
>> +			"li %[tscause], 0\n"
>> +			"lhu %[val], (%[addr])\n"
>> +			"andi %[tmp], %[val], 3\n"
>> +			"addi %[tmp], %[tmp], -3\n"
>> +			"bne %[tmp], zero, 2f\n"
>> +			"lhu %[tmp], 2(%[addr])\n"
>> +			"sll %[tmp], %[tmp], 16\n"
>> +			"add %[val], %[val], %[tmp]\n"
>> +			"2: csrw " STR(CSR_HSTATUS) ", %[hstatus]"
>> +		: [hstatus] "+&r"(guest_hstatus), [val] "=&r" (val),
>> +		  [tmp] "=&r" (tmp), [tilen] "+&r" (tilen),
>> +		  [tscause] "+&r" (tscause)
>> +		: [addr] "r" (addr));
>> +		csr_write(CSR_VSSTATUS, guest_vsstatus);
>
>>
>> +#ifndef CONFIG_RISCV_ISA_C
>> +			"li %[tilen], 4\n"
>> +#else
>> +			"li %[tilen], 2\n"
>> +#endif
>
> Can you use an assembler directive to force using a non-compressed
> format for ld and lw?  This would get rid of tilen, which is costing 6
> bytes (if I did the RVC math right) in order to save two. :)
>
> Paolo
>
>> +			"li %[tscause], 0\n"
>> +#ifdef CONFIG_64BIT
>> +			"ld %[val], (%[addr])\n"
>> +#else
>> +			"lw %[val], (%[addr])\n"
>> +#endif
To:          anup@brainfault.org
CC:          pbonzini@redhat.com
CC:          Anup Patel <Anup.Patel@wdc.com>
CC:          Paul Walmsley <paul.walmsley@sifive.com>
CC:          rkrcmar@redhat.com
CC:          daniel.lezcano@linaro.org
CC:          tglx@linutronix.de
CC:          graf@amazon.com
CC:          Atish Patra <Atish.Patra@wdc.com>
CC:          Alistair Francis <Alistair.Francis@wdc.com>
CC:          Damien Le Moal <Damien.LeMoal@wdc.com>
CC:          Christoph Hellwig <hch@infradead.org>
CC:          kvm@vger.kernel.org
CC:          linux-riscv@lists.infradead.org
CC:          linux-kernel@vger.kernel.org
Subject:     Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
In-Reply-To: <CAAhSdy1-1yxMnjzppmUBxtSOAuwWaPtNZwW+QH1O7LAnEVP8pg@mail.gmail.com>

On Mon, 23 Sep 2019 06:09:43 PDT (-0700), anup@brainfault.org wrote:
> On Mon, Sep 23, 2019 at 4:42 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 04/09/19 18:15, Anup Patel wrote:
>> > +     unsigned long guest_sstatus =
>> > +                     vcpu->arch.guest_context.sstatus | SR_MXR;
>> > +     unsigned long guest_hstatus =
>> > +                     vcpu->arch.guest_context.hstatus | HSTATUS_SPRV;
>> > +     unsigned long guest_vsstatus, old_stvec, tmp;
>> > +
>> > +     guest_sstatus = csr_swap(CSR_SSTATUS, guest_sstatus);
>> > +     old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
>> > +
>> > +     if (read_insn) {
>> > +             guest_vsstatus = csr_read_set(CSR_VSSTATUS, SR_MXR);
>>
>> Is this needed?  IIUC SSTATUS.MXR encompasses a wider set of permissions:
>>
>>   The HS-level MXR bit makes any executable page readable.  {\tt
>>   vsstatus}.MXR makes readable those pages marked executable at the VS
>>   translation level, but only if readable at the guest-physical
>>   translation level.
>>
>> So it should be enough to set SSTATUS.MXR=1 I think.  But you also
>> shouldn't set SSTATUS.MXR=1 in the !read_insn case.
>
> I was being overly cautious here. Initially, I thought SSTATUS.MXR
> applies only to Stage2 and VSSTATUS.MXR applies only to Stage1.
>
> I agree with you. The HS-mode should only need to set SSTATUS.MXR.
>
>>
>> Also, you can drop the irq save/restore (which is already a save/restore
>> of SSTATUS) since you already write 0 to SSTATUS.SIE in your csr_swap.
>> Perhaps add a BUG_ON(guest_sstatus & SR_SIE) before the csr_swap?
>
> I had already dropped irq save/restore in v7 series and having BUG_ON()
> on guest_sstatus here would be better.
>
>>
>> > +             asm volatile ("\n"
>> > +                     "csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
>> > +                     "li %[tilen], 4\n"
>> > +                     "li %[tscause], 0\n"
>> > +                     "lhu %[val], (%[addr])\n"
>> > +                     "andi %[tmp], %[val], 3\n"
>> > +                     "addi %[tmp], %[tmp], -3\n"
>> > +                     "bne %[tmp], zero, 2f\n"
>> > +                     "lhu %[tmp], 2(%[addr])\n"
>> > +                     "sll %[tmp], %[tmp], 16\n"
>> > +                     "add %[val], %[val], %[tmp]\n"
>> > +                     "2: csrw " STR(CSR_HSTATUS) ", %[hstatus]"
>> > +             : [hstatus] "+&r"(guest_hstatus), [val] "=&r" (val),
>> > +               [tmp] "=&r" (tmp), [tilen] "+&r" (tilen),
>> > +               [tscause] "+&r" (tscause)
>> > +             : [addr] "r" (addr));
>> > +             csr_write(CSR_VSSTATUS, guest_vsstatus);
>>
>> >
>> > +#ifndef CONFIG_RISCV_ISA_C
>> > +                     "li %[tilen], 4\n"
>> > +#else
>> > +                     "li %[tilen], 2\n"
>> > +#endif
>>
>> Can you use an assembler directive to force using a non-compressed
>> format for ld and lw?  This would get rid of tilen, which is costing 6
>> bytes (if I did the RVC math right) in order to save two. :)
>
> I tried looking for it but could not find any assembler directive
> to selectively turn-off instruction compression.
>
>>
>> Paolo
>>
>> > +                     "li %[tscause], 0\n"
>> > +#ifdef CONFIG_64BIT
>> > +                     "ld %[val], (%[addr])\n"
>> > +#else
>> > +                     "lw %[val], (%[addr])\n"
>> > +#endif
>
> Regards,
> Anup
To:          pbonzini@redhat.com
CC:          anup@brainfault.org
CC:          Anup Patel <Anup.Patel@wdc.com>
CC:          Paul Walmsley <paul.walmsley@sifive.com>
CC:          rkrcmar@redhat.com
CC:          daniel.lezcano@linaro.org
CC:          tglx@linutronix.de
CC:          graf@amazon.com
CC:          Atish Patra <Atish.Patra@wdc.com>
CC:          Alistair Francis <Alistair.Francis@wdc.com>
CC:          Damien Le Moal <Damien.LeMoal@wdc.com>
CC:          Christoph Hellwig <hch@infradead.org>
CC:          kvm@vger.kernel.org
CC:          linux-riscv@lists.infradead.org
CC:          linux-kernel@vger.kernel.org
Subject:     Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
In-Reply-To: <45fc3ee5-0f68-4e94-cfb3-0727ca52628f@redhat.com>

On Mon, 23 Sep 2019 06:33:14 PDT (-0700), pbonzini@redhat.com wrote:
> On 23/09/19 15:09, Anup Patel wrote:
>>>> +#ifndef CONFIG_RISCV_ISA_C
>>>> +                     "li %[tilen], 4\n"
>>>> +#else
>>>> +                     "li %[tilen], 2\n"
>>>> +#endif
>>>
>>> Can you use an assembler directive to force using a non-compressed
>>> format for ld and lw?  This would get rid of tilen, which is costing 6
>>> bytes (if I did the RVC math right) in order to save two. :)
>>
>> I tried looking for it but could not find any assembler directive
>> to selectively turn-off instruction compression.
>
> ".option norvc"?
>
> Paolo
To:          anup@brainfault.org
CC:          pbonzini@redhat.com
CC:          Anup Patel <Anup.Patel@wdc.com>
CC:          Paul Walmsley <paul.walmsley@sifive.com>
CC:          rkrcmar@redhat.com
CC:          daniel.lezcano@linaro.org
CC:          tglx@linutronix.de
CC:          graf@amazon.com
CC:          Atish Patra <Atish.Patra@wdc.com>
CC:          Alistair Francis <Alistair.Francis@wdc.com>
CC:          Damien Le Moal <Damien.LeMoal@wdc.com>
CC:          Christoph Hellwig <hch@infradead.org>
CC:          kvm@vger.kernel.org
CC:          linux-riscv@lists.infradead.org
CC:          linux-kernel@vger.kernel.org
Subject:     Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
In-Reply-To: <CAAhSdy29gi2d9c9tumtO68QbB=_+yUYp+ikN3dQ-wa2e-Lesfw@mail.gmail.com>

On Mon, 23 Sep 2019 22:07:43 PDT (-0700), anup@brainfault.org wrote:
> On Mon, Sep 23, 2019 at 7:03 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 23/09/19 15:09, Anup Patel wrote:
>> >>> +#ifndef CONFIG_RISCV_ISA_C
>> >>> +                     "li %[tilen], 4\n"
>> >>> +#else
>> >>> +                     "li %[tilen], 2\n"
>> >>> +#endif
>> >>
>> >> Can you use an assembler directive to force using a non-compressed
>> >> format for ld and lw?  This would get rid of tilen, which is costing 6
>> >> bytes (if I did the RVC math right) in order to save two. :)
>> >
>> > I tried looking for it but could not find any assembler directive
>> > to selectively turn-off instruction compression.
>>
>> ".option norvc"?
>
> Thanks for the hint. I will try ".option norvc"

It should be something like

    .option push
    .option norvc
    ld ...
    .option pop

which preserves C support for the rest of the file.

>
> Regards,
> Anup
>
>>
>> Paolo
