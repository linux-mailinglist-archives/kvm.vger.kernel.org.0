Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52186BB3E7
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436953AbfIWMhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 08:37:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52791 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390719AbfIWMhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 08:37:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id x2so9758774wmj.2
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 05:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nT+7rSzFzl9ohdCpEtepkt+of0YH3ZJsWiyLqzd3cYs=;
        b=ORms6xGaws01dtGaiH75TPByIntW6XwOMdAl72molJD1F8b0KU5pBJhP/rEQjYtJOi
         nWR1Sklr0O+2Bw/9iPdAiSoMl/bFWmvM1kD7qBkjIK6wp3ajbnxTVjFtrl/myPrx8CX0
         v1iEzHdPOx7ZnhJjpxrJbEjjejKiJ96AkYmrIMYIKt9pxQnRAkK9AEQK/n27fCliMt3v
         rPg0dOt6Vz86mv+KAH2Y9ny1yLNvVAE9f3DSY4d6ZBwX4HORSDvf2dSXniBTdmF4Y+Rf
         1JsEIueY+/4L2qK25zsedLLl04sgOnB4DX4pzm3xBBpXQ1mJ8Nq5NFthYv2+fZkNL6u0
         QoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nT+7rSzFzl9ohdCpEtepkt+of0YH3ZJsWiyLqzd3cYs=;
        b=hWXTWfWswy8G0FBfdbhvxPVFXRHehCDN+i+v99pflA1R/zBCPLhdwWpnYk5pXD+iE7
         fE2Rp/QxMiOPIbIRR36q2UhT4NnufbVoP3pEuDX3+wFh9IA0q5e98POR44enobqUcSlU
         dCC3VrXn9sV2vwx0XW4wNERlJYteywC212MONCNGmIrMwLleeUltHqJ1pue0dT6esQYO
         MVzjCqCV259AwhR+yqb4AkrYHbIQF9XrajePckWSlyMWJ32S1UjBIRE98nMEP5Z74AIk
         xQ8nmqTwQ4kjZtr224nS9Mavbgbxjq4JgX+JXogMdD1p+UdM1hNZx8pW9+uOoxJXqwW5
         /tLw==
X-Gm-Message-State: APjAAAWu5D8P5+fm5ZCMpDyZys1QWNQ3lL4pMiEJN1nuaWy+8ySjraLH
        MemA/eWSjouFtpfqmLxuC6Pxhes7YmTW16Tb0oCH/Q==
X-Google-Smtp-Source: APXvYqytGAFF6UUTeImuIoUQSKUPZ6j1zL0VHm3CfQoT1frjsg0FIDt5b/rxGFfKRF3Gb42DXvXRPHkhIJ00mZ77V2M=
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr13191518wmg.177.1569242234306;
 Mon, 23 Sep 2019 05:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-8-anup.patel@wdc.com>
 <520eed26-9332-1519-44b1-fb08b6410116@amazon.com>
In-Reply-To: <520eed26-9332-1519-44b1-fb08b6410116@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Sep 2019 18:07:02 +0530
Message-ID: <CAAhSdy0S9jOGUz3ufgMx_8E91VNQZGL3D+q+Hhuj+3ZkwmWkTQ@mail.gmail.com>
Subject: Re: [PATCH v7 06/21] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
To:     Alexander Graf <graf@amazon.com>
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

On Mon, Sep 23, 2019 at 12:14 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.09.19 18:14, Anup Patel wrote:
> > This patch implements VCPU create, init and destroy functions
> > required by generic KVM module. We don't have much dynamic
> > resources in struct kvm_vcpu_arch so thest functions are quite
>
> Since you're respinning for v8 anyway, please s/thest/these/ :)

Sure, I will update.

>
> Alex
>
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>

Regards,
Anup
