Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92E67AA8C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 16:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfG3OI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 10:08:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35002 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbfG3OI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 10:08:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so56759337wmg.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 07:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZH4+xww8GjJmr2iRqeXFgV0mXUwPu2r7QQVWlvDHaVk=;
        b=bWAVGbwhvaJ8OwHmjFMMZ7EunZVDcO9hP1lQ5lgB/Wv6hnTSO7VPe01FRlfHh1/PhS
         sh/oVhMln//XBj6q+I9i93ssy4MewQU5btkt0FKLGCzyDH+vFTtE2Hfxx/TVD2Y2RkVN
         nl3rvrfiK/kp1M1184h8A1R7C29qmDzWMFtLOTI+Z/+Ncx8mOtaeQgTthfgkTKeoBj8d
         GegpU8gOjHYY31m4uXMevSSshdGXo+nuGFOOHwmrXYQiW+0EjM82a/Ao3VvwC7F0qqJq
         Qy0KiEVI1ZEYctqqPhs0OR+fXlKzs3X8P8dwwkU8Aw1yq2qOTHKlSNy8ERzLmzc5X64c
         QD1g==
X-Gm-Message-State: APjAAAXhFttWwjWlr/WqgxOqYwk2rqpBgQgBhqHmb7/itcDgXSgwwi4q
        3u+zM94oHhayVBCXvAHnu/x16w==
X-Google-Smtp-Source: APXvYqz76P7zjl5qWfhGVUvy62IrTslgJOlgUHf8WXPi8LxP5z5ObP6+fp6h+josSRdGuBLS/01xpg==
X-Received: by 2002:a1c:a514:: with SMTP id o20mr108471635wme.149.1564495704002;
        Tue, 30 Jul 2019 07:08:24 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m24sm39374446wmi.39.2019.07.30.07.08.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:08:23 -0700 (PDT)
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
 <66c4e468-7a69-31e7-778b-228908f0e737@redhat.com>
 <CAAhSdy3b-o6y1fsYi1iQcCN=9ZuC98TLCqjHCYAzOCx+N+_89w@mail.gmail.com>
 <828f01a9-2f11-34b6-7753-dc8fa7aa0d18@redhat.com>
 <CAAhSdy19_dEL7e_sEFYi-hXvhVerm_cr3BdZ-TRw0aTTL-O9ZQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <816c70e7-0ea3-1dde-510e-f1d5c6a02dd5@redhat.com>
Date:   Tue, 30 Jul 2019 16:08:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy19_dEL7e_sEFYi-hXvhVerm_cr3BdZ-TRw0aTTL-O9ZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 15:35, Anup Patel wrote:
> On Tue, Jul 30, 2019 at 6:48 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 30/07/19 14:45, Anup Patel wrote:
>>> Here's some text from RISC-V spec regarding SIP CSR:
>>> "software interrupt-pending (SSIP) bit in the sip register. A pending
>>> supervisor-level software interrupt can be cleared by writing 0 to the SSIP bit
>>> in sip. Supervisor-level software interrupts are disabled when the SSIE bit in
>>> the sie register is clear."
>>>
>>> Without RISC-V hypervisor extension, the SIP is essentially a restricted
>>> view of MIP CSR. Also as-per above, S-mode SW can only write 0 to SSIP
>>> bit in SIP CSR whereas it can only be set by M-mode SW or some HW
>>> mechanism (such as S-mode CLINT).
>>
>> But that's not what the spec says.  It just says (just before the
>> sentence you quoted):
>>
>>    A supervisor-level software interrupt is triggered on the current
>>    hart by writing 1 to its supervisor software interrupt-pending (SSIP)
>>    bit in the sip register.
> 
> Unfortunately, this statement does not state who is allowed to write 1
> in SIP.SSIP bit.

If it doesn't state who is allowed to write 1, whoever has access to sip
can.

> I quoted MIP CSR documentation to highlight the fact that only M-mode
> SW can set SSIP bit.
> 
> In fact, I had same understanding as you have regarding SSIP bit
> until we had MSIP issue in OpenSBI.
> (https://github.com/riscv/opensbi/issues/128)
>
>> and it's not written anywhere that S-mode SW cannot write 1.  In fact
>> that text is even under sip, not under mip, so IMO there's no doubt that
>> S-mode SW _can_ write 1, and the hypervisor must operate accordingly.
> 
> Without hypervisor support, SIP CSR is nothing but a restricted view of
> MIP CSR thats why MIP CSR documentation applies here.

But the privileged spec says mip.MSIP is read-only, it cannot be cleared
(as in the above OpenSBI issue).  So mip.MSIP and sip.SSIP are already
different in that respect, and I don't see how the spec says that S-mode
SW cannot set sip.SSIP.

(As an aside, why would M-mode even bother using sip and not mip to
write 1 to SSIP?).

> I think this discussion deserves a Github issue on RISC-V ISA manual.

Perhaps, but I think it makes more sense this way.  The question remains
of why M-mode is not allowed to write to MSIP/MEIP/MTIP.  My guess is
that then MSIP/MEIP/MTIP are simply a read-only view of an external pin,
so it simplifies hardware a tiny bit by forcing acks to go through the
MMIO registers.

> If my interpretation is incorrect then it would be really strange that
> HART in S-mode SW can inject IPI to itself by writing 1 to SIP.SSIP bit.

Well, it can be useful, for example Windows does it when interrupt
handlers want to schedule some work to happen out of interrupt context.
 Going through SBI would be unpleasant if it causes an HS-mode trap.

Paolo

>>
>> In fact I'm sure that if Windows were ever ported to RISC-V, it would be
>> very happy to use that feature.  On x86, Intel even accelerated it
>> specifically for Microsoft. :)
> 
> That would be indeed very strange usage.  :)
> 
> Regards,
> Anup
> 

