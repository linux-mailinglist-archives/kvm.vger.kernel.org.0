Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522747A9BC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 15:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfG3Nfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 09:35:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52256 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfG3Nfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 09:35:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so57173383wms.2
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 06:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NG5L1QTdBmlmtrEe2guVH/gymGPjaWoNXWl+si7exOk=;
        b=XSdmFwgubGe6ca2jGD5P1QJGT8CMbYWIzlLpz6Eoj+crQJqBbRxtfRD03xHciSbZGR
         HgUyaRoMJGBJUl9AwrhDY+LY7BICoqGRLUutuIVrFlpmCSbb/YaPHn24DdtSWT8nSQNJ
         HNbIoQ24ijM0pkBajjUiUloMmrG1qV2j02BgwU/pfsCZOMg8nrkLHj5PugJjNWUI08i6
         46IURZmK0iph3Xtai5f296l4eygKizR6AshPA/dYIsTcknbdn5XbSr701seqEAcIstYg
         ECXNyvnLr3qFLKD8U3sno1GkJ0fpfMp6BHMaI5Cx9/og+JT02Rb8tm2Ntr6rNFYwen4k
         M4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NG5L1QTdBmlmtrEe2guVH/gymGPjaWoNXWl+si7exOk=;
        b=AmFqESA80uotLY5DOqPRFcuV24Lcp08FhYkowjJWfEkgxrMyitbWM8rqplZ+zki+il
         sbVDruipsRPmCZNV+DfZwA+P2L09xRaQbITI6ldxG10GBQAPvB7ql/US4yj0fCiRNTM/
         w+boffIFLz1zGmJIeuTKO6DhchcdsXeJkzG8iKb5YOXdPLwYlJzUYUefDp8pQQ4TmPui
         HQKDI5XN7ZbxQlYWW6cDW8gvYtrx4uyhUVCIV2jI6BnckYVS6T6AILwPQgXzElcyTsQA
         77k19OR19CwIFcaJAbnICE7m1MGpRvyDTi2Rk5HXYeKmWcZYvdOzNC1T2eacjairaHpd
         2l4Q==
X-Gm-Message-State: APjAAAV0+uc7szFhx927DnmHdCGGTqjdsCid/4m5D5/3fYp0ItaFTkVG
        NJ1avkwDz8OpcV9m3bxZe8bMzAMX1YY2rlTHRcM=
X-Google-Smtp-Source: APXvYqxccJmasmD750CGSJBvzrIk3e3w01M+2BaH0U+cbtfDEGerCX82OKGoBEM5uz4uOjwIh9jycbWjkeugcNuIUi8=
X-Received: by 2002:a1c:9d53:: with SMTP id g80mr100562254wme.103.1564493752815;
 Tue, 30 Jul 2019 06:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-6-anup.patel@wdc.com>
 <9f9d09e5-49bc-f8e3-cfe1-bd5221e3b683@redhat.com> <CAAhSdy3JZVEEnPnssALaxvCsyznF=rt=7-d5J_OgQEJv6cPhxQ@mail.gmail.com>
 <66c4e468-7a69-31e7-778b-228908f0e737@redhat.com> <CAAhSdy3b-o6y1fsYi1iQcCN=9ZuC98TLCqjHCYAzOCx+N+_89w@mail.gmail.com>
 <828f01a9-2f11-34b6-7753-dc8fa7aa0d18@redhat.com>
In-Reply-To: <828f01a9-2f11-34b6-7753-dc8fa7aa0d18@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 19:05:40 +0530
Message-ID: <CAAhSdy19_dEL7e_sEFYi-hXvhVerm_cr3BdZ-TRw0aTTL-O9ZQ@mail.gmail.com>
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

On Tue, Jul 30, 2019 at 6:48 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/07/19 14:45, Anup Patel wrote:
> > Here's some text from RISC-V spec regarding SIP CSR:
> > "software interrupt-pending (SSIP) bit in the sip register. A pending
> > supervisor-level software interrupt can be cleared by writing 0 to the SSIP bit
> > in sip. Supervisor-level software interrupts are disabled when the SSIE bit in
> > the sie register is clear."
> >
> > Without RISC-V hypervisor extension, the SIP is essentially a restricted
> > view of MIP CSR. Also as-per above, S-mode SW can only write 0 to SSIP
> > bit in SIP CSR whereas it can only be set by M-mode SW or some HW
> > mechanism (such as S-mode CLINT).
>
> But that's not what the spec says.  It just says (just before the
> sentence you quoted):
>
>    A supervisor-level software interrupt is triggered on the current
>    hart by writing 1 to its supervisor software interrupt-pending (SSIP)
>    bit in the sip register.

Unfortunately, this statement does not state who is allowed to write 1
in SIP.SSIP bit.

I quoted MIP CSR documentation to highlight the fact that only M-mode
SW can set SSIP bit.

In fact, I had same understanding as you have regarding SSIP bit
until we had MSIP issue in OpenSBI.
(https://github.com/riscv/opensbi/issues/128)

>
> and it's not written anywhere that S-mode SW cannot write 1.  In fact
> that text is even under sip, not under mip, so IMO there's no doubt that
> S-mode SW _can_ write 1, and the hypervisor must operate accordingly.

Without hypervisor support, SIP CSR is nothing but a restricted view of
MIP CSR thats why MIP CSR documentation applies here.

I think this discussion deserves a Github issue on RISC-V ISA manual.

If my interpretation is incorrect then it would be really strange that
HART in S-mode SW can inject IPI to itself by writing 1 to SIP.SSIP bit.

>
> In fact I'm sure that if Windows were ever ported to RISC-V, it would be
> very happy to use that feature.  On x86, Intel even accelerated it
> specifically for Microsoft. :)

That would be indeed very strange usage.  :)

Regards,
Anup
