Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA11ADECB
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbgDQNzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730732AbgDQNzK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 09:55:10 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B23C061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:55:09 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id x17so470131ooa.3
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1qGKkVLPIOtw/YCvUqno/ATBMMnNSopURWMtrEnMW9Q=;
        b=InB76e91InNRl4vyHbco2mX3gA95gKqUTLdjn05M2oFYDqF0CAuDPCwlzLNBuuZPfI
         4MKNCkdc40czeE3rueAak70LjGNoLyRag7RpIRPyQwmMXeWyKPR2d6sJRS+POCliPBsW
         Rm0Otziqg0VNrXQr2qN4xCpCOTtIpXXscyHyMey40TvFMEg04ZRYX+dfMwvUxUhFAbo5
         uRlZZekevrWmmnaOTvmg7fD7EaXijbyDsqmo+14ew/gwczaCinlSK7bS22iQH7QSDR1/
         xFf7EuUz1RwtwotdZwc6FI6wA1IN10u4ASDroMW+WzT10O5bFQiJ3komlt10ZbLzNOMf
         84pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1qGKkVLPIOtw/YCvUqno/ATBMMnNSopURWMtrEnMW9Q=;
        b=Yr7LNhsvlGL1WZFiXq5qihS8M4Mn883yMTeJ7bPkjMBnqVYEoES2gSGetf4ZqadiSF
         +WmJ8Nq1JK2B4Z7dNzVmvhdaBhhL8nBa90fKAtMv6jFEMSOkE9KgIgc6eyJJnrQrWA4p
         iGDbG3JXHlHlOuluksuI0V8WW91PDibpkJ8k8sqS2cA5GYfRWJDk+mzFwRTLvfNNT/L1
         sdRfKqY4Pb3ygx6trvUlHKO4PymGte4jw3rpXu5wTb7i3bfwDoKgQrmerFHjBE7ev3/O
         7mKnPy3s0UIWXczLNrKLDk/gd+I6jZLhDfh5GblgZazkujgzxnaYEAOQ5lTKn1VwuoVd
         XlkQ==
X-Gm-Message-State: AGi0PuY+kcn07vaWQu6xoPjSLrPCNF30GVO+tfHT4PgmgnVBy2hZl+yq
        nh3QB7rD9EiYaV9tWsKdI3Cpox1Gl3ybjGxxATnMiw==
X-Google-Smtp-Source: APiQypIDTfiyQpnk189V+b3jR/JVtVNY8V+qgHsx26aO/iXmbTcjjwPHPe0X0jHHcFoDSvwMFPKVRIFx8YqySqhqrdU=
X-Received: by 2002:a4a:890b:: with SMTP id f11mr2576302ooi.85.1587131708881;
 Fri, 17 Apr 2020 06:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-4-philmd@redhat.com>
 <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org> <CAFEAcA8K-njh=TyjS_4deD4wTjhqnc=t6SQB1DbKgWWS5rixSQ@mail.gmail.com>
 <5d9606c9-f812-f629-e03f-d72ddbce05ee@redhat.com>
In-Reply-To: <5d9606c9-f812-f629-e03f-d72ddbce05ee@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 17 Apr 2020 14:54:57 +0100
Message-ID: <CAFEAcA-4+Jcfxc5dax8exV+kBJKYEnWZ2d-V1A6sm6uJafZdPg@mail.gmail.com>
Subject: Re: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 at 14:49, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> On 3/16/20 9:11 PM, Peter Maydell wrote:
> > On Mon, 16 Mar 2020 at 19:36, Richard Henderson
> > <richard.henderson@linaro.org> wrote:
> >> I'm not 100% sure how the system regs function under kvm.
> >>
> >> If they are not used at all, then we should avoid them all en masse an=
 not
> >> piecemeal like this.
> >>
> >> If they are used for something, then we should keep them registered an=
d change
> >> the writefn like so:
> >>
> >> #ifdef CONFIG_TCG
> >>      /* existing stuff */
> >> #else
> >>      /* Handled by hardware accelerator. */
> >>      g_assert_not_reached();
> >> #endif
>
> I ended with that patch because dccvap_writefn() calls probe_read()
> which is an inlined call to probe_access(), which itself is only defined
> when using TCG. So with KVM either linking fails or I get:
>
> target/arm/helper.c: In function =E2=80=98dccvap_writefn=E2=80=99:
> target/arm/helper.c:6898:13: error: implicit declaration of function
> =E2=80=98probe_read=E2=80=99;
>       haddr =3D probe_read(env, vaddr, dline_size, mem_idx, GETPC());
>               ^~~~~~~~~~

IN this particular case, DC CVAP is really a system insn rather
than a 'register'; our register struct for it is marked up as
ARM_CP_NO_RAW, which means we'll effectively ignore it when
running KVM (it will not be migrated, have its state synced
against the kernel, or be visible in gdb). If dccvap_writefn()
ever gets called somehow that's a bug, so having it end up
with an assert is the right thing.

> I'll use your suggestion which works for me:

Your suggested patch isn't quite the same as RTH's suggestion,
because it puts the assert inside a stub probe_read()
implementation rather than having the ifdef at the level
of the writefn body. I have no opinion on whether one or
the other of these is preferable.

thanks
-- PMM
