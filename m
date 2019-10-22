Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59BDFCF5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 07:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbfJVFH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 01:07:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37518 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbfJVFH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 01:07:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so14786241wmc.2
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 22:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bTTMrmciHM4aiFMZR2LK71art6dDZteKsZ9m8QnTfYE=;
        b=t5XI80Bi4Lrln9mq+PcmKnh/yO/hMUHXGheJlgPjZHmjiOAKjNpjlwjXrH4e/9yOUp
         mR8jmhWjv/5OpGM8yjQhMT8lwxbmAwBue+sy9/eMu5EVFXjYnAzl3zU2VUOWqfu32NZM
         Z3zKuEf4f89oQkuqGUuY3+NKXqsGn82fXWfMpOdyot1HwqClZ0rZbi6horJoccoHlqBr
         kwilw8JQ+36mVE/vxn2gYkr710UiwpoIXu4c7yr5Z6txLx1fUYfbJjV7PbNxFvpZlrFo
         UqUOOHNXqgUT5BX0UdU1JbK4lADmJtAa4wyL7NBU3sCdNhXQnJrx368cQvjh4NYcUPA4
         8zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bTTMrmciHM4aiFMZR2LK71art6dDZteKsZ9m8QnTfYE=;
        b=kRabyR94Wqh7PVSzSYsuxV2y0hlIUegQZ9r3y2SyE2QmBgCiCiY/7lChf3B2NaKGgs
         Vs/npJhF6MtRhXUIJ+QoCG0/KB/JVGPvTO9apZQeLu/CmeQdGGYHQ5352xIIaNvv5y+l
         RmMyojDCD9ypHUC0jHCowWuq+l2PuC7bkXam5S9QTxgrSpKH5o6TnwZ5GrHPBCkKruZp
         Kanavk1k2RXstwzEn1YLojS9UniFvwRR9x4d16+BXiWHSaM7tjIp9X5Q9usYcLuGygsF
         5G7GJr+L6RlOt2l/TH2Saxfwioc4EXSUChyK8cRtMwvSrOSvkocXH1MZHQhiF/Ejusu/
         Nwlg==
X-Gm-Message-State: APjAAAXMOaPoFQhjGycwlV0zmkjDSQXn3zxwUwgvGCXRzZ2LeumBR8HI
        LxLd/HrCJaCRuUt8Csp9M9ipQZfQ86I+uSXupD8XfQ==
X-Google-Smtp-Source: APXvYqxl6FUWzhNJmV/twRIMg5J5dk1jL54DHL5eRqSLGaUjuAJZJFHphqKMrxpAOmdnSQ0pZAWlWkDR4Yx7NICACVk=
X-Received: by 2002:a1c:9695:: with SMTP id y143mr1119738wmd.103.1571720874948;
 Mon, 21 Oct 2019 22:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160649.24622-1-anup.patel@wdc.com> <20191016160649.24622-21-anup.patel@wdc.com>
 <1d2e9514-235e-183e-b4fc-d3becc9ce471@redhat.com>
In-Reply-To: <1d2e9514-235e-183e-b4fc-d3becc9ce471@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 22 Oct 2019 10:37:43 +0530
Message-ID: <CAAhSdy33b=EcNnNP80dNqAEpSOErfXenNXHD0GhC4yYPB7L3Ow@mail.gmail.com>
Subject: Re: [PATCH v9 20/22] RISC-V: KVM: Fix race-condition in kvm_riscv_vcpu_sync_interrupts()
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

On Mon, Oct 21, 2019 at 10:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/10/19 18:12, Anup Patel wrote:
> > +     /* Read current VSIP and VSIE CSRs */
> > +     vsip = csr_read(CSR_VSIP);
> > +     csr->vsie = csr_read(CSR_VSIE);
> > +
> > +     /* Sync-up VSIP.SSIP bit changes does by Guest */
> > +     if ((csr->vsip ^ vsip) & (1UL << IRQ_S_SOFT)) {
> > +             if (!test_and_set_bit(IRQ_S_SOFT, &v->irqs_pending_mask)) {
> > +                     if (vsip & (1UL << IRQ_S_SOFT))
> > +                             set_bit(IRQ_S_SOFT, &v->irqs_pending);
> > +                     else
> > +                             clear_bit(IRQ_S_SOFT, &v->irqs_pending);
> > +             }
>
> Looks good, but I wonder if this could just be "csr->vsip =
> csr_read(CSR_VSIP)", which will be fixed up by flush_interrupts on the
> next entry.

It's not just "csr->vsip = csr_read(CSR_VSIP" because "irqs_pending"
bitmap has to be in-sync with Guest updates to VSIP because WFI
trap-n-emulate will check for pending interrupts which in-turn checks
"irqs_pending" bitmap.

Regards,
Anup
