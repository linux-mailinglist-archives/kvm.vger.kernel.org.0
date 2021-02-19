Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF3C31F8B4
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhBSL4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhBSL4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 06:56:49 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AEEC061756
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:56:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id gg8so1200664ejb.13
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RCReoUqVm5VrIgFdBYFHKJpOABQVppR771o1a5NHp3Q=;
        b=kHxpJna0WvF58KRzQ5LVezQqDSSRhYFCs3R6UJBRT/lnCHOijMmxgTr+ixjrGlUkll
         szoQSEibrREs9z3uKY1Cs6Bqmvgmh3wezUHb855L6UUMcWQaGbO3nIX+nuPUMWutzoue
         ldW+OYxruT3+nGWoHMbpZxPnJqt4i0sMnhARPUwsHutuXB/JJrDxUOc4ILfCXOWS2whN
         tX2sD61BzJ3GXUCXE8jaG/3v3H6V/4KSz0qUIMlM6nmjMWWGK2Ytrrn7zaTS0QHNGoSw
         FuGMcs1P/7o2ne313C3mHEfx5Cmuz4Y6GUV95tW3a5/OvYlRvrcSwu0dXYmeR0oCJXmC
         RT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RCReoUqVm5VrIgFdBYFHKJpOABQVppR771o1a5NHp3Q=;
        b=tcYJKG9oVOKomPnS2VkSFq4Wks5N0zuqVmd6g3oCWYjmlccrTB3C3PEV5a3xNddWAe
         wrU1oLGX/ayuH4XqRXdFWV7SLy2Z18X5FB8VC2CyBLUL8mr7EHGeH7YiuI2uWSw9E63O
         eHTb08es7LOZBBxiQU8JxsyTp75NAUwHNL/fh+hb+vPc1sbHnJPiqxvDL4zuZ+P+w0yD
         /shvMURd3Cug5x305uXaalmaHapbO13qSBz7WBiMSOLBQHx03Js5hvCGL/nUwWTTVkQk
         Awm4jOljCia10knHVB4V3NU+iSAj2VS+67EYeOgtLIbHEXbCyF+Pnf9pAn9rwZGJooR0
         2k0w==
X-Gm-Message-State: AOAM530txsXMfLbfmuE/swjpu8//nNGwIX6qULvHoR8y3V/QDTNSZ4rI
        Qudhs2t76PWi4XX8rkR9rlnR8vyYE0zJoG8qCxw+fA==
X-Google-Smtp-Source: ABdhPJyY7rOmAS8HlYaPJjFtH0dM7qx91u1P7MknXc550biwIHD9TpOrNw/CC9jk0EUM4klLZM05EvK6bDkG2owGsMI=
X-Received: by 2002:a17:906:5357:: with SMTP id j23mr8276999ejo.407.1613735767468;
 Fri, 19 Feb 2021 03:56:07 -0800 (PST)
MIME-Version: 1.0
References: <20210219114428.1936109-1-philmd@redhat.com>
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 19 Feb 2021 11:55:56 +0000
Message-ID: <CAFEAcA_66DuWfrftpaodqBZwBhS-VOD9uH=KwvGYC_VcksVFAA@mail.gmail.com>
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        qemu-s390x <qemu-s390x@nongnu.org>, Greg Kurz <groug@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm-devel <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 at 11:44, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
> This series aims to improve user experience by providing
> a better error message when the user tries to enable KVM
> on machines not supporting it.

Thanks for having a look at this; fixing the ugly assertion
failure if you try to enable KVM for the raspi boards has
been vaguely on my todo list but never made it up to the top...

> Philippe Mathieu-Daud=C3=A9 (7):
>   accel/kvm: Check MachineClass kvm_type() return value
>   hw/boards: Introduce 'kvm_supported' field to MachineClass
>   hw/arm: Set kvm_supported for KVM-compatible machines
>   hw/mips: Set kvm_supported for KVM-compatible machines
>   hw/ppc: Set kvm_supported for KVM-compatible machines
>   hw/s390x: Set kvm_supported to s390-ccw-virtio machines
>   accel/kvm: Exit gracefully when KVM is not supported

Don't we also need to set kvm_supported for the relevant
machine types in hw/i386 ?

thanks
-- PMM
