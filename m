Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25C7A7FC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfG3MQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:16:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54331 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729401AbfG3MQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:16:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so56906200wme.4
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iCWEmw5uxTuTJM5Fn9CAHniCyIMMG4EL6XrLjBjgqU8=;
        b=RcEyHgsukWeHJWoW0g1tULEyN+REkaDBS0hPbWb+PVgj21FsAiJFooBKPafQGCQT4k
         Oe7x3r0UWoYUkKuGQXtHOsZC7ZrYeQsDJQPhCtdqZvkYgnxuNy6VcVzzXe8ww7se6Gc0
         M9g+GzB9ptSlWbp4AsgoGzauTqZB2tLn6pneb3x2VfvezxPKSRD5ctSTCYZI6F7nNg5Q
         kTom1CS4D1/Ew4fjK0ZO9TSBUj9psnOiA1fMRYFpHn0E32yFj3GO0qLecTJ0lRrfMzWF
         jcbyhSInAQWXs8cU/NADw+cye/IMLF+AO67Op9zOMIRAFOVr8/ty82by4n/ajOEjRfIN
         h8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iCWEmw5uxTuTJM5Fn9CAHniCyIMMG4EL6XrLjBjgqU8=;
        b=qUyw9KIcbBRBV53A/i0Rr8B7cGKutETFufOSJKWOtir0UAJ75N5Ok06u9unpDb7rfX
         OwXoUZ/2YtWEy8Qnb9m7m0rTWfCK9CohVg1S7kfbONWUvHp833RC8cYDBDF7Kli2SzO9
         c8bV/V5zpm47D3zSfuv87bYRI33hqwwMlscHPrwvze1zR46H5qFAJ/6Ymg4agqYCTKyn
         VP6sMO0cU6jVRmcsWlVvCIUZQI7U0w01V7s1/BurTdALspiID0ZaEJ+3f77E2HePTUtT
         mPgTrSG7b9EAxt/isxbeTcKD/pRMyqeS6oobRlfI5g27KfNEE9avDN/muNLC8526Q21U
         iWVA==
X-Gm-Message-State: APjAAAVhQllohA/YyQex6RtBv2exc0jgpkK/FykRJ1ZwfqZSMMkSCpqj
        c4iVR9V0r/9e5+fcakVxQUiLsmzYqHjRMA6EVd5AbsYYACc=
X-Google-Smtp-Source: APXvYqwoLi8AAqz+99Z48jcpAPghzt+IGo83CFyDdCeXa8lkuZwKmiu9/wvRi+usFvnPUs5v/7GdZ2sspfW5V98qygc=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr96400937wmg.24.1564488988047;
 Tue, 30 Jul 2019 05:16:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-7-anup.patel@wdc.com>
 <3caa5b31-f5ed-98cd-2bdf-88d8cb837919@redhat.com> <536673cd-3b84-4e56-6042-de73a536653f@redhat.com>
 <CAAhSdy2jo6N4c9-_-hj=81mXjHjP8mvZy_8jOdRZELCyU9Y8Aw@mail.gmail.com> <9f84c328-c5ad-b3cc-df0f-05f113476341@redhat.com>
In-Reply-To: <9f84c328-c5ad-b3cc-df0f-05f113476341@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 17:46:16 +0530
Message-ID: <CAAhSdy0O=q3Sfd=xDw5CwiYoGVRy1DtrXsykZsdRUf9OJAsa3Q@mail.gmail.com>
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

On Tue, Jul 30, 2019 at 5:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/07/19 14:08, Anup Patel wrote:
> >> Still, I would prefer all the VS CSRs to be accessible via the get/set
> >> reg ioctls.
> > We had implemented VS CSRs access to user-space but then we
> > removed it to keep this series simple and easy to review. We thought
> > of adding it later when we deal with Guest/VM migration.
> >
> > Do you want it to be added as part of this series ?
>
> Yes, please.  It's not enough code to deserve a separate patch, and it
> is useful for debugging.

Sure, I will add it in v2 series.

We have skipped Guest FP ONE_REG interface with same rationale.
We should add that as well. Agree ?

Regards,
Anup
