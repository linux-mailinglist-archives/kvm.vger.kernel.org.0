Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027D0A6520
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 11:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfICJ0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 05:26:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36324 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfICJ0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 05:26:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id p13so17383077wmh.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 02:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=320H5oeQ/ypZcJNziT2UEvpQLvhZJXO4w0Kft3y1blQ=;
        b=L3WvK8Fda9g/OFils619wQfmyD12uuA61bQl/l1rzqQGS+XiG9DZkPmnxECaVW8Yfy
         wVQBiPsO1nsrj3ZPVkgQiKFSudKf8UDs7dBhL8+u0WmTx3kQrQqOcxOGFj6ilF+fPB65
         IFp7XgPkxr7d6suy26EpCfguqH1uex0AHvemIomAJPgK/Q0aIcEvUETkjIbd8VS4WNlb
         +YbWv3qDKgIePZyyNcMUIR22ydth/bTj/ms3hvmWEDY8MwurYOy5NGKvA8WftKI8bcpy
         sH3zMs4IcfX00tZZilYCaxxTN0VMMijcxkDzGD+4OhOE8a4ZGUtbZytBJN/qWz+O3pnY
         EaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=320H5oeQ/ypZcJNziT2UEvpQLvhZJXO4w0Kft3y1blQ=;
        b=ZbNGipWecbAVP7fO8sHFstW6LmAwyVx0oSv3txvWZ192DRQsl8H1tRD57/Zu3xrlYK
         3hq3Rm0IE6d7hTE8kqf7TkCtjqX7HpW1T/Mkht0d4SGX+RPm2Hw5yGee2dEjcFRlxiKs
         FTPoF0cMRK7nfiBTz0jyOY5Utwo0NmRD+Djn+TdGndLjQa39yss9Q++89uJdsEBalbdA
         7D2mP1UtnUngtqaCOyKwUH2Iwc5gJefKQSRIME40w6P3Z2P2Oc7rHepAwA1En5qTkAkZ
         61wSWVlHss2eLewqNTeAB/ACD7Zcditu/rldK8OA33Fn6T1UDPJHX6oPKUkdDVj5EX2M
         WkBQ==
X-Gm-Message-State: APjAAAXt/fMPSbhjWgVSt67yeb4K+Npfiu2bu6rbWa5RxF2nyGJrcUgx
        qNZkuPH0/+5H1puQTOS60+6cdYXXlY9zBVgo/0dVag==
X-Google-Smtp-Source: APXvYqxbRKzXBZDIsULcCQOmd941u33RLDqR7W+BFpNzSkMZsny4p6y2wrdwkuKrl94bbnpxNfsz2eWptRCpwpAu9Is=
X-Received: by 2002:a1c:c909:: with SMTP id f9mr42044895wmb.52.1567502800623;
 Tue, 03 Sep 2019 02:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190829135427.47808-1-anup.patel@wdc.com> <20190829135427.47808-11-anup.patel@wdc.com>
 <20190903085823.s4amn27pewc54hl2@kamzik.brq.redhat.com>
In-Reply-To: <20190903085823.s4amn27pewc54hl2@kamzik.brq.redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 3 Sep 2019 14:56:29 +0530
Message-ID: <CAAhSdy1p3KG-m_Gw4LzeY+ap3reVpx+FNjugnDJEDj_-jhgc2w@mail.gmail.com>
Subject: Re: [PATCH v6 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Andrew Jones <drjones@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

On Tue, Sep 3, 2019 at 2:28 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Aug 29, 2019 at 01:56:18PM +0000, Anup Patel wrote:
> >  int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> > -     /* TODO: */
> > +     u8 data8;
> > +     u16 data16;
> > +     u32 data32;
> > +     u64 data64;
> > +     ulong insn;
> > +     int len, shift;
> > +
> > +     insn = vcpu->arch.mmio_decode.insn;
> > +
> > +     if (run->mmio.is_write)
> > +             goto done;
> > +
> > +     len = vcpu->arch.mmio_decode.len;
> > +     shift = vcpu->arch.mmio_decode.shift;
> > +
> > +     switch (len) {
> > +     case 1:
> > +             data8 = *((u8 *)run->mmio.data);
> > +             SET_RD(insn, &vcpu->arch.guest_context,
> > +                     (ulong)data8 << shift >> shift);
> > +             break;
> > +     case 2:
> > +             data16 = *((u16 *)run->mmio.data);
> > +             SET_RD(insn, &vcpu->arch.guest_context,
> > +                     (ulong)data16 << shift >> shift);
> > +             break;
> > +     case 4:
> > +             data32 = *((u32 *)run->mmio.data);
> > +             SET_RD(insn, &vcpu->arch.guest_context,
> > +                     (ulong)data32 << shift >> shift);
> > +             break;
> > +     case 8:
> > +             data64 = *((u64 *)run->mmio.data);
> > +             SET_RD(insn, &vcpu->arch.guest_context,
> > +                     (ulong)data64 << shift >> shift);
> > +             break;
> > +     default:
> > +             return -ENOTSUPP;
> > +     };
> > +
> > +done:
> > +     /* Move to next instruction */
> > +     vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> > +
>
> As I pointed out in the last review, just moving this instruction skip
> here is not enough. Doing so introduces the same problem that 2113c5f62b74
> ("KVM: arm/arm64: Only skip MMIO insn once") fixes for arm.

Thanks Drew, I had seen your comment previously but forgot
to address it in v6. I will address it in v7.

Regards,
Anup
