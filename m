Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B173F7A7D9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfG3MMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:12:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34034 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfG3MMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:12:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so65542633wrm.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HhV8xTaSmerML9zVZ7qS6UxHrCqZLDARfYvjhVb7WHE=;
        b=RcoaLwd2Vg6Em1OTmg4fGjPVTjlC4fy3J+/JHoAjVDTtWYQg71xqFjLMmzN37Q1muG
         oEJrITxVkiMuienbCLjmaAd9yuvFcFL/nIfFkEct9f6+OeUvziSH41cGF4XmhP/SYe0o
         HrCwyz+QZ/eTHoUO4AK7VPYsKUraS5/gb5uH042VzZKGSqtvZLa7LVPsHFwszVqL5Wcq
         aX/4P1oKYbykHyOICVyS2uQvxgA6wlprrut05nGl+nmx0FdBFSjzQGYQfN5/cXT+59Yb
         a8qFIvjv5DGzLuU3w+ow2p4T5PENR00XdZ+NUbA0aW+x9Tkg9dprvOMMZ/Mnogc9qVBS
         f7pw==
X-Gm-Message-State: APjAAAWVYHLcjaCWIjjS1bmzkOrUr1MqPhtc1Y9jOPkwQSI/6a52ZN6a
        G0DNdw3ZNzkoIeHnE/dqZUrEFQ==
X-Google-Smtp-Source: APXvYqzLXsF6w2xUhox2ex1h6rvuDdDtF/ILVJYVETLp5rg3aTjB58ta3pfCc+xmAu/XbDqGhN+TTA==
X-Received: by 2002:adf:8183:: with SMTP id 3mr128267214wra.181.1564488752845;
        Tue, 30 Jul 2019 05:12:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id a8sm51199553wma.31.2019.07.30.05.12.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:12:32 -0700 (PDT)
Subject: Re: [RFC PATCH 05/16] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
To:     Anup Patel <anup@brainfault.org>
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
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-6-anup.patel@wdc.com>
 <9f9d09e5-49bc-f8e3-cfe1-bd5221e3b683@redhat.com>
 <CAAhSdy3JZVEEnPnssALaxvCsyznF=rt=7-d5J_OgQEJv6cPhxQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <66c4e468-7a69-31e7-778b-228908f0e737@redhat.com>
Date:   Tue, 30 Jul 2019 14:12:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy3JZVEEnPnssALaxvCsyznF=rt=7-d5J_OgQEJv6cPhxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 14:00, Anup Patel wrote:
> On Tue, Jul 30, 2019 at 4:47 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> First, something that is not clear to me: how do you deal with a guest
>> writing 1 to VSIP.SSIP?  I think that could lead to lost interrupts if
>> you have the following sequence
>>
>> 1) guest writes 1 to VSIP.SSIP
>>
>> 2) guest leaves VS-mode
>>
>> 3) host syncs VSIP
>>
>> 4) user mode triggers interrupt
>>
>> 5) host reenters guest
>>
>> 6) host moves irqs_pending to VSIP and clears VSIP.SSIP in the process
> 
> This reasoning also apply to M-mode firmware (OpenSBI) providing timer
> and IPI services to HS-mode software. We had some discussion around
> it in a different context.
> (Refer, https://github.com/riscv/opensbi/issues/128)
> 
> The thing is SIP CSR is supposed to be read-only for any S-mode SW. This
> means HS-mode/VS-mode SW modifications to SIP CSR should have no
> effect.

Is it?  The privileged specification says

  Interprocessor interrupts are sent to other harts by implementation-
  specific means, which will ultimately cause the SSIP bit to be set in
  the recipient hart’s sip register.

  All bits besides SSIP in the sip register are read-only.

Meaning that sending an IPI to self by writing 1 to sip.SSIP is
well-defined.  The same should be true of vsip.SSIP while in VS mode.

> Do you still an issue here?

Do you see any issues in the pseudocode I sent?  It gets away with the
spinlock and request so it may be a good idea anyway. :)

Paolo

> Regards,
> Anup
> 
>>
>> Perhaps irqs_pending needs to be split in two fields, irqs_pending and
>> irqs_pending_mask, and then you can do this:
>>
>> /*
>>  * irqs_pending and irqs_pending_mask have multiple-producer/single-
>>  * consumer semantics; therefore bits can be set in the mask without
>>  * a lock, but clearing the bits requires vcpu_lock.  Furthermore,
>>  * consumers should never write to irqs_pending, and should not
>>  * use bits of irqs_pending that weren't 1 in the mask.
>>  */
>>
>> int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>> {
>>         ...
>>         set_bit(irq, &vcpu->arch.irqs_pending);
>>         smp_mb__before_atomic();
>>         set_bit(irq, &vcpu->arch.irqs_pending_mask);
>>         kvm_vcpu_kick(vcpu);
>> }
>>
>> int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>> {
>>         ...
>>         clear_bit(irq, &vcpu->arch.irqs_pending);
>>         smp_mb__before_atomic();
>>         set_bit(irq, &vcpu->arch.irqs_pending_mask);
>> }
>>
>> static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>> {
>>         ...
>>         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>> }
>>
>> and kvm_riscv_vcpu_flush_interrupts can leave aside VSIP bits that
>> aren't in vcpu->arch.irqs_pending_mask:
>>
>>         if (atomic_read(&vcpu->arch.irqs_pending_mask)) {
>>                 u32 mask, val;
>>
>>                 mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
>>                 val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
>>
>>                 vcpu->arch.guest_csr.vsip &= ~mask;
>>                 vcpu->arch.guest_csr.vsip |= val;
>>                 csr_write(CSR_VSIP, vsip);
>>         }
>>
>> Also, the getter of CSR_VSIP should call
>> kvm_riscv_vcpu_flush_interrupts, while the setter should clear
>> irqs_pending_mask.
>>
>> On 29/07/19 13:56, Anup Patel wrote:
>>> +     kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>> +     kvm_vcpu_kick(vcpu);
>>
>> The request is not needed as long as kvm_riscv_vcpu_flush_interrupts is
>> called *after* smp_store_mb(vcpu->mode, IN_GUEST_MODE) in
>> kvm_arch_vcpu_ioctl_run.  This is the "request-less vCPU kick" pattern
>> in Documentation/virtual/kvm/vcpu-requests.rst.  The smp_store_mb then
>> orders the write of IN_GUEST_MODE before the read of irqs_pending (or
>> irqs_pending_mask in my proposal above); in the producers, there is a
>> dual memory barrier in kvm_vcpu_exiting_guest_mode(), ordering the write
>> of irqs_pending(_mask) before the read of vcpu->mode.
>>
>> Similar to other VS* CSRs, I'd rather have a ONE_REG interface for VSIE
>> and VSIP from the beginning as well.  Note that the VSIP setter would
>> clear irqs_pending_mask, while the getter would call
>> kvm_riscv_vcpu_flush_interrupts before reading.  It's up to userspace to
>> ensure that no interrupt injections happen between the calls to the
>> getter and the setter.
>>
>> Paolo
>>
>>> +             csr_write(CSR_VSIP, vcpu->arch.irqs_pending);
>>> +             vcpu->arch.guest_csr.vsip = vcpu->arch.irqs_pending;
>>> +     }
>>

