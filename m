Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4104981945
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 14:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfHEM1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 08:27:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38233 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbfHEM1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 08:27:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so84218920wrr.5
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 05:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9vjnriQzTp+3fhGfRWD4sJQPpUsfPg2DbYoNAsu2SiI=;
        b=w4+AecEmFQ/isfLzRPwHz/5MZljTohJlWFNeug8MdHi82X9VKPhe2ZyRzjWlJCvepw
         kiniiAn5l66EGF3UK+orcy9NcLV/dmSLcCGmna4yi0GF+i5dlXhqrxaPH9KubY6FHjLD
         99EpBHJsVCkZSJoOyTaWRD/ilyziUyk+nwPk0RUQNGwqFtyKJh13sW08S3edQKCVQCth
         hXeCoblZKRkBPCTcvTHLXaFhtdFGztMlOBo56CnAVX+z7v0wWKGwWN9zmif9kthuQeXJ
         pVWvaRXUT6j8dcd4c9QdaTp337ImgbfM8u4W9iSkzJGgF+BBdaFvp1PMRW7Na8yEVZk+
         giDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vjnriQzTp+3fhGfRWD4sJQPpUsfPg2DbYoNAsu2SiI=;
        b=KbuYh8CT7g4QP0UN4bxrSVsTj8DzSZUqIcln7nzWS0RF5Tn/xDyciI810236zwjVLj
         OMM9krd0K7rM7teg5FM9RP3aer5U9ZDis6G5rMPcj9TDvzkiJ+7c6uR7FYFW1vEdnwtQ
         0BmblAZXofIyBQBLyA4bgSS4JtUip8xMluEVr1DcjdB9PABJ/Q8/FPEmSPIxW3NI/yu5
         xlPyDAHIy5NE1R4wuaj5SN8ishZKccaSr9lsaUMj/0PljO0/LCQ+9lt107EGQ7cC6T3E
         kwdBzYEfFxk2GrnBMiC/my+iYtIPd3yMoPNtgSgS7pqjyMAibhBF2DZNSYT91aaH+C6/
         EwlA==
X-Gm-Message-State: APjAAAW0cR5Y3cwOe0Gw7j3VFif0xmAIqGUPciarsCdbpGe7V7NyGxgm
        FQU9aa3MfyGUALhHO5KqRzLh9d9N+g97bH0HIFc=
X-Google-Smtp-Source: APXvYqz/HgV3blyNJGsp03Z7QumAb6XXL7e/qsJ596wIug7Wl/foiSB6qgn4qCCaL+3bGAF5TklCThDKf6RqGhrKNGc=
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr152697746wra.328.1565008052530;
 Mon, 05 Aug 2019 05:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-7-anup.patel@wdc.com>
 <98eaa917-8270-ecdc-2420-491ed1c903d8@redhat.com>
In-Reply-To: <98eaa917-8270-ecdc-2420-491ed1c903d8@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 17:57:20 +0530
Message-ID: <CAAhSdy2rYy+hAaQROYqjDQPKDq1DvROLMjOuWamn6333W-rrpg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 06/19] RISC-V: KVM: Implement VCPU interrupts and
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

On Fri, Aug 2, 2019 at 1:47 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 09:47, Anup Patel wrote:
> > +     /* VCPU interrupts */
> > +     unsigned long irqs_pending;
> > +     unsigned long irqs_pending_mask;
> > +
>
> This deserves a comment on the locking policy (none for producer,
> vcpu_lock for consumers).

Yes, I will certainly add comments about our approach in
asm/kvm_host.h

Regards,
Anup
