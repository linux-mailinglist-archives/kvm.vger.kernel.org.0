Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2431F90D
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBSMJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBSMI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 07:08:59 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6A9C061574
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 04:08:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v22so9446830edx.13
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 04:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rnkn7mbM56SteQutXvRxji6jtVMYcThd8dUUo2XhtOE=;
        b=ELXA41CKlOXTN1/9N7Ts9CcJHRq/Kx13l/8BE4BziuJKhXr1/wWwWFHmFyUqcfwNqs
         hG7c2ic8cC+Q5l8dCzvH2ioxtvIbxgG85e1aFkXUS/NCcVpIo+1F9Ygkxrt36CeLFqkZ
         5r+542tbF2ZxAjnV2bLBL6aHXOgPZXTQqEWDTM9qeiDe+GA9Xh7CakA+SJfGSSB0cbNZ
         UBk8LVUgT8suW7aa/Fsv8LWB9ciPWNDrV0biKm1PCeOmr0KoZ2kkkfslUnL+oE3lk+1a
         wJN7v/S3daAyHONr0dvfgAGgA80LcjPaMCVAdG4d7+cJZ6vxcIuF0Z1BVL13tpsM8jbz
         bG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rnkn7mbM56SteQutXvRxji6jtVMYcThd8dUUo2XhtOE=;
        b=q6DxJvKT8fv713M5QdRAHYqBnKeEa7auyC3T9EcH8sSIVesuyIBCrfcLgbx978ujwN
         VsINZgbuLdJ6583rGYITDQmIH7w11Z/TkX/cMDrShZTbJcpM+2jXBTHLXbNGZtyyJDJc
         oOnTV/J+3uRxh45SaS6EA5YkNpt1lyBJmh1iJhiF07u7lFz1pxTXEO1ZZGDjL1aiwyXH
         NUFBjxLxqfQwIR3FA5V74z3/95rtO76KbN5NL9V89gS2CfVgHPPGW0uPRbL0SfuFYZFJ
         vDHeGjJXnJFFL8tnrR0IjDznzzejMnbriHYksrdVriSiY0pGBomiB9vo1cDyR7DUPK8H
         smLg==
X-Gm-Message-State: AOAM532bofNz7Gl9/NDqnAi0HSf/LTj/pdn4nVL4YgK20EhUjcCyCi1e
        vD1MRx24QfSSBjT1k6+DjGULwF25iuD9p92BLAgFLg==
X-Google-Smtp-Source: ABdhPJx5PDdFuTeJWwNR+YNIQtZ7qwv2WTUigwRfVG4qQBVImGyqqTnw7XwIshfI5fI8sFOL12fb2yxRS1qvjUU5KfM=
X-Received: by 2002:a05:6402:545:: with SMTP id i5mr5364744edx.44.1613736496919;
 Fri, 19 Feb 2021 04:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20210219114428.1936109-1-philmd@redhat.com> <20210219114428.1936109-3-philmd@redhat.com>
 <YC+nxWnB+eaiq736@redhat.com>
In-Reply-To: <YC+nxWnB+eaiq736@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 19 Feb 2021 12:08:05 +0000
Message-ID: <CAFEAcA-A=TG43w2yNfrDwCgYYNZBEa25cM_yYgREfQyKa=PZEQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] hw/boards: Introduce 'kvm_supported' field to MachineClass
To:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        kvm-devel <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x <qemu-s390x@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 at 11:58, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
> Is the behaviour reported really related to KVM specifically, as opposed
> to all hardware based virt backends ?
>
> eg is it actually a case of some machine types being  "tcg_only" ?

Interesting question. At least for Arm the major items are:
 * does the accelerator support emulation of EL3/TrustZone?
   (KVM doesn't; this is the proximate cause of the assertion
   failure if you try to enable KVM for the raspi boards.)
 * does the board type require a particular CPU type which
   KVM doesn't/can't support?
Non-KVM accelerators could at least in theory have different answers
to those questions, though in practice I think they do not.

I think my take is that we probably should mark the boards
as 'tcg-only' vs 'not-tcg-only', because in practice that's
the interesting distinction. Specifically, our security policy
https://qemu.readthedocs.io/en/latest/system/security.html
draws a boundary between "virtualization use case" and
"emulated", so it's really helpful to be able to say clearly
"this board model does not support virtualization, and therefore
any bugs in it or its devices are simply outside the realm of
being security issues" when doing analysis of the codebase or
when writing or reviewing new code.

If we ever have support for some new accelerator type where there's
a board type distinction between KVM and that new accelerator and
it makes sense to try to say "this board is supported by the new
thing even though it won't work with KVM", the folks interested in
adding that new accelerator will have the motivation to look
into exactly which boards they want to enable support for and
can add a funky_accelerator_supported flag or whatever at that time.

Summary: we should name this machine class field
"virtualization_supported" and check it in all the virtualization
accelerators (kvm, hvf, whpx, xen).

thanks
-- PMM
