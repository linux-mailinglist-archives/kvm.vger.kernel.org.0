Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CFA812CC
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfHEHMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 03:12:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32853 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfHEHMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 03:12:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so5976425wme.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 00:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RbR9NwuvYbRC7roIhZ22yTnxvDklbtSaOkHnRd59pwA=;
        b=fkloISZ+Sy0hPMWNbFKzEh/r7BhtZqP4GA9lIr/AitoV+f7H+Fa7NB134TAcewDaga
         io6DQRB5IDIoD4C8l3IdKPdVydc3xBbfQTQKNK4pvGQOtEOV7NPS9kLb/ycbLIYQ4ixj
         S+BY0o8SGrF7PrawJsDGnZJA1XjoraSGN7GwBv63aKNlTAXgwRHD16mxFdujm2jDq5nE
         pnxdBIoxB7WYlD0IEyZQsOy0CB7mD1+BhBc4wxNsSVMAYDlxkDIhcx21gpviKA6DUGzT
         DGcGMFNArITF0bDZIC0/1AZ5lXMhi51gYZ8uNmpGsK/l2c/0V6EZBuSAK5qpuKlGM5Sl
         4C7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RbR9NwuvYbRC7roIhZ22yTnxvDklbtSaOkHnRd59pwA=;
        b=PE2ezNTD6Uh8lFrrO7hZJwrsmRNuLE+QAURuaYo+Y/STAGHt8cEvOTh9bNLN3SvdHB
         nA571ZJkz18mOcn55eauQshtrvIP/yPaep/vF00V2CKh1d3a0ZUFAFvUsg1mi1QPiojA
         GzEttGT9aaSz290S+pdjq3O1j0B5/fES2LXtPdJzpeObHshdgtOJrnxG7YknEX51+zrj
         sS/x2SBn4LlDIEsUB4RQhT+bvoALeTdwnvTj9D0MyJFxdqwY2WWx8u8vEd04TLTFinnb
         0cBALPkkihQzgP4nwVyFa/W1SEsvytYvJitTfMI23JiCD+Cd0GR9u2Nl4J3wUi8ZA0jq
         DEkQ==
X-Gm-Message-State: APjAAAVC/PCUFDGg6UTVYVUkULCpHXB06uaKB9zPmOrEmlPtJ17a0Bdn
        DrrrH4JKJugv+nNJtQmj2eeXFICXlan9E9RA1yPEkw==
X-Google-Smtp-Source: APXvYqxEZZ7R692/L4v5lwezCh25EnrYJqzhpkuE8O4sIMjCiDsF/mYrMWwoKnFFt8t13omA8PT+Bmmhx3XjiZllRlI=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr15608477wmg.24.1564989135533;
 Mon, 05 Aug 2019 00:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-11-anup.patel@wdc.com>
 <5b966171-4d11-237d-5a43-dc881efb7d0a@redhat.com>
In-Reply-To: <5b966171-4d11-237d-5a43-dc881efb7d0a@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 12:42:03 +0530
Message-ID: <CAAhSdy0BVqagYTTnaG2hwsxxM51ZZ2QpJbZtQ21v__8UaXCOWA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/19] RISC-V: KVM: Handle WFI exits for VCPU
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
> > +             if (!kvm_riscv_vcpu_has_interrupt(vcpu)) {
>
> This can be kvm_arch_vcpu_runnable instead, since kvm_vcpu_block will
> check it anyway before sleeping.

I think we can skip this check here because kvm_vcpu_block() is
checking it anyway. Agree ??

Regards,
Anup
