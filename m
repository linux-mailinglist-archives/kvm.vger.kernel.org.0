Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550728167A
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 12:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfHEKIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 06:08:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54683 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbfHEKIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 06:08:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so74108418wme.4
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 03:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbNFx4il0vCPP+D1Yz8x0vBctgaZ7/n1Iil30rI0v3c=;
        b=soqdUaOSralN5UpCSAB4aYas5NIxSdLzk1zgv+q/98sdZRE/Uio34RwJkvg1ux7XVs
         5poCzxjYX/nORxXWgj3xE0G83Bz7cFBvE1iIpyBVDkt78RiH8zefcLYFlr0F5jMCd1Ys
         zqaqJQGjdQgEXy5SvmyviyhLNfmFZ5R2Vus7q5cL4v/7rZmpzUkfesNqIBiKd+qA6ASm
         uS8eIqrPz9w1mhrcpTaemqzJWqMdIJQjzP3GuXWRLxnteiDrRBlZKwwPZAquJJGv20z0
         P9m/MxCTFRpkb64kjtVIL9zLa4hPiuJ+vlS9IEovo8tfKl8WuzZtEKHfGmN9d7eBZ9GS
         hh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbNFx4il0vCPP+D1Yz8x0vBctgaZ7/n1Iil30rI0v3c=;
        b=ZgEz2+d7jLa+g+VcPJLrhwiNw1vohxnuMVXDoogkdaD2PY4oAFVKc3paR477ke8u1I
         EDPiLn/eU9QnEHWP0/DvxT6uFC13lMQTqpdkit5efaTfkxxI52vvDvpOTRvtXr6ucop5
         6SCXgNC5v7MQlPICfvfBd3w9btB2oKwHhG77pQmkcutAhSRtNUl5SGg29+bdH3SWbS84
         iwjMU19VhZJUP/Ev2/IqC9T6ROYQm2FE9LAaEdjC2HiaEr8jy4ROdJ5m98Owi9xePboT
         peLNEzWtC0OwLvbR89Tlcv2DnanvFV8WTeeALiVo9gRdcQqVImY98EGY/D6P42S8GJzZ
         Rf1Q==
X-Gm-Message-State: APjAAAW4PBQjEWF02Y7HrKwSGQsfN9WWBArGnOS9ufm78BD1Daudc3Mc
        UqmZdUu2qUg50tDx++qkPEGb1TnoXOkXakIGufbipg==
X-Google-Smtp-Source: APXvYqzl6kVeF2s9w7in3km5UbjnsJP2KDV81u1ARcFGpnOlD6I6q3QS6xKNc4B1wsWV/lZiflA7ohYpAdCiNvg9Bks=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr16598754wmg.24.1564999730931;
 Mon, 05 Aug 2019 03:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-13-anup.patel@wdc.com>
 <949b75ef-5ec6-cdfd-5d5d-5695f35bd20c@redhat.com>
In-Reply-To: <949b75ef-5ec6-cdfd-5d5d-5695f35bd20c@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 15:38:39 +0530
Message-ID: <CAAhSdy33_2Qin5+VWp8AhG95DRu7+16fGgVC1Of=QOkNmCJjHg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 12/19] RISC-V: KVM: Implement stage2 page table programming
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

On Fri, Aug 2, 2019 at 2:44 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/19 09:48, Anup Patel wrote:
> > +     hgatp |= (k->vmid.vmid << HGATP_VMID_SHIFT) & HGATP_VMID_MASK;
>
> This should use READ_ONCE.

Ahh, missed this one. I will update.

Regards,
Anup
