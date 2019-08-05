Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCEC81294
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 08:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfHEGze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 02:55:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43688 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfHEGze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 02:55:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so8627090wru.10
        for <kvm@vger.kernel.org>; Sun, 04 Aug 2019 23:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4TTBYe7R89ObYhNrQ7Cl1PDjf+qeeSySCDSm/yvi8hE=;
        b=ZW+9EsnPgnlzTYewisjxT+EOSy6r2aUxK55FB/Fm+mi+AtDooHD4mu+yQ4gb37M10g
         NFW40A+O1T6r5RXaZM/8SExP8R6DwkNY4tOg66IuS30k7+H4zGVIjXQc5CsCiFM2+BMe
         V0+mlrOMXhxPEG24hqd84dDo9gu3cphW0r9/JFlKTTaR+vGq0uS9aklZTp2Wcx8DcdRa
         2kuzuR1HDGS6PxOG/Lzvo154FcmiWh5jjA0bm9vC2WXhhhOramW5aZIV01jvhSj2rdDM
         n+kO58hpipZI6NalfKRWflgcGxRn2DNY40LLNgm/sPPLUvZwPDy7XRixemaSGUe+O/Df
         PYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4TTBYe7R89ObYhNrQ7Cl1PDjf+qeeSySCDSm/yvi8hE=;
        b=D61N9THj3mJg9Lj2eZgYt1snS1YDi+qAUAnVjaxmBCdGpV/aAI0zO+ONZIC9Uqbokg
         MGxyjp2Y7m/loqG34svJH9/NRMXCGDm3NnkjiWXn4fEEHhJwUwQBMlZ1QwfZI/BMtwjS
         kU6ciuH+jr6mtZRTXK/nhWzrQKT9XkWxNF2I7RO0ISxDpENcLn8kyZpIHeoJNJV7cw4r
         IdSRQlHNk4x+hcbHufLMGdzyVUEuBBhy3r7Yf8aml7G7a1Uv8ZWqswgBmmmEBK+WacQh
         slsGXXL+SZmzZDHhWSlAXhwbVzPGnaAkeqS+otfb35nPnB3eZOatzgJZ8U7wjfgSgc4S
         RaOw==
X-Gm-Message-State: APjAAAW8NZ/hADnoHjjIXjUMUJNBCbO1w+/urWfmLNi4oGzmPc2IgDvu
        KTVCTFtpG7wCTyb610nx82dsmQ0s69Ost/MDFkE=
X-Google-Smtp-Source: APXvYqxAjiUTpRBRVnl8zo2WRruaXTltVlSlDaYn0gjxaCM1yH1vbKfeokdHZ8Ie7GExj9eQjB7BsoJu8wlqK+dlYTk=
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr150790179wra.328.1564988131513;
 Sun, 04 Aug 2019 23:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-8-anup.patel@wdc.com>
 <03f60f3a-bb50-9210-8352-da16cca322b9@redhat.com>
In-Reply-To: <03f60f3a-bb50-9210-8352-da16cca322b9@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 12:25:20 +0530
Message-ID: <CAAhSdy3hdWfUCUEK-idoTzgB2hKeAd3FzsHEH1DK_BTC_KGdJw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/19] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG
 ioctls
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

On Fri, Aug 2, 2019 at 2:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 09:47, Anup Patel wrote:
> > +     if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> > +             kvm_riscv_vcpu_flush_interrupts(vcpu, false);
>
> Not updating the vsip CSR here can cause an interrupt to be lost, if the
> next call to kvm_riscv_vcpu_flush_interrupts finds a zero mask.

Thanks for catching this issue. I will address it in v3.

If we think more on similar lines then we also need to handle the case
where Guest VCPU had pending interrupts and we suddenly stopped it
for Guest migration. In this case, we would eventually use SET_ONE_REG
ioctl on destination Host which should set vsip_shadow instead of vsip so
that we force update HW after resuming Guest VCPU on destination host.

>
> You could add a new field vcpu->vsip_shadow that is updated every time
> CSR_VSIP is written (including kvm_arch_vcpu_load) with a function like
>
> void kvm_riscv_update_vsip(struct kvm_vcpu *vcpu)
> {
>         if (vcpu->vsip_shadow != vcpu->arch.guest_csr.vsip) {
>                 csr_write(CSR_VSIP, vcpu->arch.guest_csr.vsip);
>                 vcpu->vsip_shadow = vcpu->arch.guest_csr.vsip;
>         }
> }
>
> And just call this unconditionally from kvm_vcpu_ioctl_run.  The cost is
> just a memory load per VS-mode entry, it should hardly be measurable.
>

I think we can do this at start of kvm_riscv_vcpu_flush_interrupts() as well.

Regards,
Anup
