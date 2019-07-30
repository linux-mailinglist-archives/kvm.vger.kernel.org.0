Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871D57A7B9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbfG3MJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:09:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34629 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfG3MJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:09:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so65530370wrm.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NEXRKVgiAewSzMHKuc4kYp85srZxayAyjwnb+cltz/A=;
        b=hk/KqKIGVmzsttbZR/gwF2OK0U4nrpMkMwgRfr4Suo1MJW2IsOPukKgv1lmqoSVUg0
         NBSR/3ku96WkmFUeRHx/6fqdNY7BtJP9EegEJVfs9eQkmvAITRarqhgmAJhPrrrTFwtK
         /NYeHp4JADVMdK6Z5mZH+maD5ERJmoTMxpKWubgggtX482hx5c1a8qUXN4ztkebaAXg5
         5CnI4ELBh+DDI08aHsI6B3hNBiuGKudfjO10f7xXoGTtPSHG3Hvq87Qao7/eUZESPJ9k
         UcWs5FBuqtax0X+W+DgUz2Xdw9l11bk1qBXgPXxW+q0MIdDYe4uoZ9W2FPiCToTeK7v1
         yeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NEXRKVgiAewSzMHKuc4kYp85srZxayAyjwnb+cltz/A=;
        b=XdAYrQSybgRe6av2APyAEkYOnCArVUdwXIaXoCJxyA8e7vB3Mg2alMD54ScPPC7Tr7
         yzqQTKPE2sF6aSyI581fuYDalhLkD5jqJbsHZ886O2QEDBFc7pb0sRotXV+4esetVpnZ
         eXrruUfBXVsCPhTZAxFbGNKFM62HeUF1kdL+4uUUTJP+IhjBRkVJ5HX4fhi8JQZkD+f/
         SY8VO6gsEam0Kdj23mVp+yrjxcjNQ46KtlqgEdNjjVlFAJ6roroXoGzvy4HojpJkCtE/
         Ae/jjTJXUd1Nq9sGFJyiRHFE5XURH0oFY9b0gDjmHqSEVnhYigMufy5HEmz3qCgi08xD
         rPkQ==
X-Gm-Message-State: APjAAAXyShIH3hHQU/BZbXsvKueC9NI8tnilBtaeyg8PgPsWaWJhmJRF
        MjNiXSWNBu51TY7ROX43fwgdCADRYOZPsaf3d7E=
X-Google-Smtp-Source: APXvYqy9j4zSHu4dp1+U/CdhnB7i3Hnbv00SVhZJbG6jzJT/h0YFIWOh4Y833SEXLrNLULQLDFdnZOtStWSu9W/tgKA=
X-Received: by 2002:a5d:6b11:: with SMTP id v17mr50422046wrw.323.1564488543296;
 Tue, 30 Jul 2019 05:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-7-anup.patel@wdc.com>
 <3caa5b31-f5ed-98cd-2bdf-88d8cb837919@redhat.com> <536673cd-3b84-4e56-6042-de73a536653f@redhat.com>
In-Reply-To: <536673cd-3b84-4e56-6042-de73a536653f@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 17:38:51 +0530
Message-ID: <CAAhSdy2jo6N4c9-_-hj=81mXjHjP8mvZy_8jOdRZELCyU9Y8Aw@mail.gmail.com>
Subject: Re: [RFC PATCH 06/16] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG
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

On Tue, Jul 30, 2019 at 3:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/07/19 10:43, Paolo Bonzini wrote:
> > On 29/07/19 13:56, Anup Patel wrote:
> >> The PC register represents program counter whereas the MODE
> >> register represent VCPU privilege mode (i.e. S/U-mode).
> >>
> > Is there any reason to include this pseudo-register instead of allowing
> > SSTATUS access directly in this patch (and perhaps also SEPC)?
>
> Nevermind, I was confused - the current MODE is indeed not accessible as
> a "real" CSR in RISC-V.

Yes, you got it right.

>
> Still, I would prefer all the VS CSRs to be accessible via the get/set
> reg ioctls.

We had implemented VS CSRs access to user-space but then we
removed it to keep this series simple and easy to review. We thought
of adding it later when we deal with Guest/VM migration.

Do you want it to be added as part of this series ?

Regards,
Anup
