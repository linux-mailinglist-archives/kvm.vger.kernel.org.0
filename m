Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3453E812EF
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 09:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfHEHS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 03:18:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41190 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfHEHS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 03:18:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so80032654wrm.8
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 00:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RUqYiFGRwqZz3baSi7DePLwfU/zHvDjxvxTGgWRnjy4=;
        b=vaSHkIAHMZgvdsmo51ZYrbAryRPsAqLUFYv5jJavndTgROhdJ2YKtLsZZ7C5gyHtvW
         d/v3QIkwaKBrAFuclzEsoay1vDYmjzsPaxL6kALb0MhKAhO2G5JvtGBdNRuHDOhawgi4
         lXTjtmEwRoGoiHPDd7rP98028ijkU/rrmccPlI4+BJUogzjLpnIAfcM/RSF7a0W20G3a
         +lYNkmcxP15Wv0MSZzqX1VmMeIw8oeevNB0gHTpWSvBKIISi5EBHG0ojEi+JIBbaGMD3
         Jrc2jqiRbvWDhyZXhGGFBf5N5Ec8u2CeeK2HmFW6XmZ5yQoLYLGMohbmcA8s+tpwyTkC
         naNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RUqYiFGRwqZz3baSi7DePLwfU/zHvDjxvxTGgWRnjy4=;
        b=paPHVQkP2Wod0AUnboukf26i9lgvv+1zMVAPKTPXy8vwMlmTK2lIjTV44N+49U2d8s
         nd2r3giatu6KO/HUl/qfQJxQl1+gY2M62VQesZ67tRwKXRkHJCwwOYfS4Vd7tKthpfrv
         RGmmU9YCOLSs5Ct1L3MglJsjdHylXLpMjrXdDElRuPf44iwd+AlbCtw8BGosuDnyIcEv
         9XKRG9RUx0KRoJLAknokKuCsxT8Gbh6nSiucMgUgFM+JaOehrKsxmMN0O4rxBwLwKNfW
         bQzjCnD+IuaNPXDahSSBez90mlDFkB2+kNs9QGyy4c4rD3SxzY7+sczSydX+SRDtLcQ/
         5Hcw==
X-Gm-Message-State: APjAAAVbFDcLGWflgSuXxDefpIfEZiEDXGvb210SQJH8GgcV0QLylcXE
        GU0tjbgCaGDBZWwBPSXZZ2vkrP1zyjTHF3nNbys=
X-Google-Smtp-Source: APXvYqw/FM+tBx9ajgV2UsWP4KPKi99Z0fzot3UMGZ6r5xVj6SOPqPddG0DiyAWPBjneacTNTdnwazaj1Hb9o9cCPqQ=
X-Received: by 2002:a5d:4e50:: with SMTP id r16mr24977381wrt.227.1564989504211;
 Mon, 05 Aug 2019 00:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-11-anup.patel@wdc.com>
 <5b966171-4d11-237d-5a43-dc881efb7d0a@redhat.com> <CAAhSdy0BVqagYTTnaG2hwsxxM51ZZ2QpJbZtQ21v__8UaXCOWA@mail.gmail.com>
 <458f6b85-cdb2-5e6b-6730-4875f0e4cdba@redhat.com>
In-Reply-To: <458f6b85-cdb2-5e6b-6730-4875f0e4cdba@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 12:48:12 +0530
Message-ID: <CAAhSdy02bZAbyK4TGzO0jYRCTCFwexzA_iu7GNRh-07NZ6fuFw@mail.gmail.com>
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

On Mon, Aug 5, 2019 at 12:44 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/08/19 09:12, Anup Patel wrote:
> > On Fri, Aug 2, 2019 at 2:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 02/08/19 09:47, Anup Patel wrote:
> >>> +             if (!kvm_riscv_vcpu_has_interrupt(vcpu)) {
> >>
> >> This can be kvm_arch_vcpu_runnable instead, since kvm_vcpu_block will
> >> check it anyway before sleeping.
> >
> > I think we can skip this check here because kvm_vcpu_block() is
> > checking it anyway. Agree ??
>
> Yes, but it's quite a bit faster to do this outside the call.  There's a
> bunch of setup before kvm_vcpu_block reaches that point, and it includes
> mfences too once you add srcu_read_unlock/lock here.

No problem, I will use kvm_arch_vcpu_runnable() here.

Regards,
Anup
