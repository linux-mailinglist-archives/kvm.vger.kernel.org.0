Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B857A765
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfG3MA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:00:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38621 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbfG3MAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:00:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so65471661wrr.5
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n/JJxoSHKvaru38fIGlmwaHlnuxMxh6jpy0Kuq5lmmE=;
        b=Sl72/4E2kqtDZ2CQIMMfomIbhFZDZDSCqUCB+R4H7uJSODB8IQnLn5GgZEZ5fShul4
         b8zn3xuhCVjR16uUHRlBKI+jKBAUgRYXeMtoFwC8z+gIlDJZVWCP3jM504guxcVTvzLP
         fYQwNm74kcCX4M7eMly/p7M+P9RiJW9QBkMOutLsLrApJDeWgjwJ/iDNbb/gZufDTAGU
         rNoKlvBwDliEOVi3jOqIklKVRYOQVQTzoGeOwWLK6zKLI7UKqD991GvjbFAD09/D1HXg
         ONKN2qH0FVKuNIRfa8SpTV62TzfkoXcJhFg6zQjdpI/jBmCaPoInWqiPyYf+LGwBSfyW
         ug6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n/JJxoSHKvaru38fIGlmwaHlnuxMxh6jpy0Kuq5lmmE=;
        b=uZhczM4DriLHo/JNkrs99eCFXxA3+WZs4zFoJDBwiM67Z4Vz30ViwHAG/4h6/BG9dZ
         UGRDBPWiNtl77FfLlmCHGfQ8ffaw5M4B4DzYyYsBvOUW1ZnkX/CF+ZH4sDlMSNglsCWW
         iaIJ5lnvH+as3uAg+N4bygUdd0kWdcXqCKldw+KVumRFimaDcf2MP4K9F06LncNWXRX0
         FKlakSO3pTwmkOqDln9DG5cyKYQ1iILFJ3Pyn8Wcyypmg/k31MK9Z8bU9J7/VcWGqmTm
         koPAGEMdgenAcPODMi+hN6vyNi0+pD4aKFVlHA7R4G+Vx4r6gR9lkW/9wMVr0KDe/jNY
         MFjg==
X-Gm-Message-State: APjAAAUhUANpWnop+0ptikwI87oPEKU4gZLi7aJziaXpB6wbyou3P+uI
        XsGZOH06jqgL8ROmvfURxfQI0Nx6WQRCwYunFmU=
X-Google-Smtp-Source: APXvYqwdGj8tn+Lc+jdWqVTEGuaT6OEVtpsGQreyIcF1DxNxjXt75IZwoWbIPt3vCU8A0lK4eiedRhBfqabA/jYv85k=
X-Received: by 2002:a5d:6b11:: with SMTP id v17mr50383530wrw.323.1564488022522;
 Tue, 30 Jul 2019 05:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-6-anup.patel@wdc.com>
 <9f9d09e5-49bc-f8e3-cfe1-bd5221e3b683@redhat.com>
In-Reply-To: <9f9d09e5-49bc-f8e3-cfe1-bd5221e3b683@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 17:30:10 +0530
Message-ID: <CAAhSdy3JZVEEnPnssALaxvCsyznF=rt=7-d5J_OgQEJv6cPhxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 05/16] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
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

On Tue, Jul 30, 2019 at 4:47 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> First, something that is not clear to me: how do you deal with a guest
> writing 1 to VSIP.SSIP?  I think that could lead to lost interrupts if
> you have the following sequence
>
> 1) guest writes 1 to VSIP.SSIP
>
> 2) guest leaves VS-mode
>
> 3) host syncs VSIP
>
> 4) user mode triggers interrupt
>
> 5) host reenters guest
>
> 6) host moves irqs_pending to VSIP and clears VSIP.SSIP in the process

This reasoning also apply to M-mode firmware (OpenSBI) providing timer
and IPI services to HS-mode software. We had some discussion around
it in a different context.
(Refer, https://github.com/riscv/opensbi/issues/128)

The thing is SIP CSR is supposed to be read-only for any S-mode SW. This
means HS-mode/VS-mode SW modifications to SIP CSR should have no
effect.

For HS-mode, only certain bits are writable from M-mode such as SSIP
and in-future even this will go away when we have specialized HW to
trigger S-mode IPIs without going through M-mode firmware.

For VS-mode, only HS-mode controls the pending bits writes to VSIP CSR.

If above is honored correctly by HW then the use-case you mentioned above
is not possible because Guest writing 1 to SIP.SSIP will be ignored.

It is possible that we have buggy HW which does allow Guest write to SIP
CSR bits then our current approach is to just overwrite VSIP whenver it
is different from irq_pending bits before entering Guest.

Do you still an issue here?

Regards,
Anup

>
> Perhaps irqs_pending needs to be split in two fields, irqs_pending and
> irqs_pending_mask, and then you can do this:
>
> /*
>  * irqs_pending and irqs_pending_mask have multiple-producer/single-
>  * consumer semantics; therefore bits can be set in the mask without
>  * a lock, but clearing the bits requires vcpu_lock.  Furthermore,
>  * consumers should never write to irqs_pending, and should not
>  * use bits of irqs_pending that weren't 1 in the mask.
>  */
>
> int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
> {
>         ...
>         set_bit(irq, &vcpu->arch.irqs_pending);
>         smp_mb__before_atomic();
>         set_bit(irq, &vcpu->arch.irqs_pending_mask);
>         kvm_vcpu_kick(vcpu);
> }
>
> int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
> {
>         ...
>         clear_bit(irq, &vcpu->arch.irqs_pending);
>         smp_mb__before_atomic();
>         set_bit(irq, &vcpu->arch.irqs_pending_mask);
> }
>
> static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> {
>         ...
>         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> }
>
> and kvm_riscv_vcpu_flush_interrupts can leave aside VSIP bits that
> aren't in vcpu->arch.irqs_pending_mask:
>
>         if (atomic_read(&vcpu->arch.irqs_pending_mask)) {
>                 u32 mask, val;
>
>                 mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
>                 val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
>
>                 vcpu->arch.guest_csr.vsip &= ~mask;
>                 vcpu->arch.guest_csr.vsip |= val;
>                 csr_write(CSR_VSIP, vsip);
>         }
>
> Also, the getter of CSR_VSIP should call
> kvm_riscv_vcpu_flush_interrupts, while the setter should clear
> irqs_pending_mask.
>
> On 29/07/19 13:56, Anup Patel wrote:
> > +     kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> > +     kvm_vcpu_kick(vcpu);
>
> The request is not needed as long as kvm_riscv_vcpu_flush_interrupts is
> called *after* smp_store_mb(vcpu->mode, IN_GUEST_MODE) in
> kvm_arch_vcpu_ioctl_run.  This is the "request-less vCPU kick" pattern
> in Documentation/virtual/kvm/vcpu-requests.rst.  The smp_store_mb then
> orders the write of IN_GUEST_MODE before the read of irqs_pending (or
> irqs_pending_mask in my proposal above); in the producers, there is a
> dual memory barrier in kvm_vcpu_exiting_guest_mode(), ordering the write
> of irqs_pending(_mask) before the read of vcpu->mode.
>
> Similar to other VS* CSRs, I'd rather have a ONE_REG interface for VSIE
> and VSIP from the beginning as well.  Note that the VSIP setter would
> clear irqs_pending_mask, while the getter would call
> kvm_riscv_vcpu_flush_interrupts before reading.  It's up to userspace to
> ensure that no interrupt injections happen between the calls to the
> getter and the setter.
>
> Paolo
>
> > +             csr_write(CSR_VSIP, vcpu->arch.irqs_pending);
> > +             vcpu->arch.guest_csr.vsip = vcpu->arch.irqs_pending;
> > +     }
>
