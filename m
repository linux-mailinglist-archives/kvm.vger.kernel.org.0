Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225A7BC139
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 07:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409010AbfIXFH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 01:07:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36698 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409004AbfIXFH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 01:07:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so339834wrd.3
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 22:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2d47E32C9RUOC5wWI8ATuz+LPjAEghSrUhg7r5IgcGw=;
        b=xk0WaUyL1bcfquknkF16bbwNOlHNKes+nkQlDlLr2dbIuiGGKwWswlpRW/npj90Pbp
         z/MrEp/lBndbQrNq4ws8M1Js64R6OavvHdhzyDhYlGYMQIuFSZ031gDiODKzkZJUykM8
         Oa4zpJXbWUqNf0m7Rfr65UFEO9v0GA4CtOfdmhfn3hal9uv3KrdOEJZ6EdTJlyc5ksZD
         skdeBU7z+mE14MU6hxrVOoI1DonRXai40vjdsmQUsNwmmN12Sm9D5CE5EbNoe9QUb5eJ
         dehyr2pMmM+b3jY5L+j2gihyQn5h2oJzty8UFT8PW2+chfCN9Q9V2sFZUPg+LOTY34Zz
         RwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2d47E32C9RUOC5wWI8ATuz+LPjAEghSrUhg7r5IgcGw=;
        b=MecNAHBbBC9mn60+VH/HIfH4430C2V5gbwGM14VkVXnHXDSvAIsWiqzK3vtLyV+eCt
         vEei04ULI+/803JJ+utbOLmQhx4rQ0BJSntm2RFhztYP0ZJ7WK0NMwIElBtsXreWP+8r
         sQCBWppNkDM81GhmIy6RufLK0yCAguFCMER0E1C/Fo1x2vJAVIOQSZNKDjg9Nx3WYKGH
         Zr/H/aGIif5ESYe+ONsud7SyS7eJGzYGUYxkxqDwkp+8TQg71eVn2+vdMkpPD7PfXYwZ
         azFNIAaKidiEGbHU9EhV4XPg7edM0dXwkXsXL97OlB9xRqWtt7e50prDY2s9DAIspHGS
         LBDA==
X-Gm-Message-State: APjAAAVaAfVY/eS2TF6fmHpmtfzWE4s+SgIM81xVCt6lpJnhvIVgAFoL
        WCh89SRwcAjeFdt0RKbruMey7TM9ANIEGw0tctCObA==
X-Google-Smtp-Source: APXvYqwkgvLZ1ao9vw+cuFq1o7BDXNlJZMaWP1xTU3OzBpsnv6FrdOOWOJg+vki1pWF9gE3sE5XfxFfMzY+7t0S+mXc=
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr634403wro.330.1569301674793;
 Mon, 23 Sep 2019 22:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-12-anup.patel@wdc.com>
 <8c44ac8a-3fdc-b9dd-1815-06e86cb73047@redhat.com> <CAAhSdy1-1yxMnjzppmUBxtSOAuwWaPtNZwW+QH1O7LAnEVP8pg@mail.gmail.com>
 <45fc3ee5-0f68-4e94-cfb3-0727ca52628f@redhat.com>
In-Reply-To: <45fc3ee5-0f68-4e94-cfb3-0727ca52628f@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 Sep 2019 10:37:43 +0530
Message-ID: <CAAhSdy29gi2d9c9tumtO68QbB=_+yUYp+ikN3dQ-wa2e-Lesfw@mail.gmail.com>
Subject: Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
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

On Mon, Sep 23, 2019 at 7:03 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/09/19 15:09, Anup Patel wrote:
> >>> +#ifndef CONFIG_RISCV_ISA_C
> >>> +                     "li %[tilen], 4\n"
> >>> +#else
> >>> +                     "li %[tilen], 2\n"
> >>> +#endif
> >>
> >> Can you use an assembler directive to force using a non-compressed
> >> format for ld and lw?  This would get rid of tilen, which is costing 6
> >> bytes (if I did the RVC math right) in order to save two. :)
> >
> > I tried looking for it but could not find any assembler directive
> > to selectively turn-off instruction compression.
>
> ".option norvc"?

Thanks for the hint. I will try ".option norvc"

Regards,
Anup

>
> Paolo
