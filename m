Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C66B2F4A5C
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbhAMLht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbhAMLhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 06:37:48 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52647C061575
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 03:37:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b6so1070273edx.5
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 03:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4F1rmmgzkcYAHDbt+LpZar8xaojmFJxb7Xqq4gkK6BM=;
        b=SgFzl6SCUKomp9/rXHcmO68qwJXKInafIEhap905AWHxVCUbi0RORFtSY3nUFR7OuQ
         oqeRZ2ySroRQdds2GbD/kcS8T8i47oKm7B+/69CvcqnzZwV2nAMx1pqFYh3UZ2s7skNd
         ym6wsO2JqG+M9zZWX47cqQuI3cPKzUi5nMfYXNM1JItICkmFXeolebL8JvRaKdTYaPD2
         Jhggtnby6OkCeS3FLwjih6uL9behMY3eaB/nQOI+A/l/WXRNoWler+VAfr13XBL6C/q/
         q88viu81oItwi/KcfZofbMI2gI87hC6j/74P2WvZcrbAUkJZne78cabvLkEoor4tVGqP
         If7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4F1rmmgzkcYAHDbt+LpZar8xaojmFJxb7Xqq4gkK6BM=;
        b=KI7GfGloxZKpApMhOjcpAx3ATA6qcXX2WarLSfozTxVfGKzRDvUKuS9hRU1cxuqDd2
         wH3K3N6wY35ApteNF3wsCcgPi9mZb4Z90WVb4CemLMgCfkf0Aqcy/95hs6nkqp+XGsJQ
         xEBDJFDb5gRXs4omx2LIkmeuz9ZPVd24wU+QwdErubF1HfU0MpR9YNZdXH06NlUz0HVC
         2T7x0RkT4/oDvdUR7L5tFqy2MPKb0vi/ee1oM5oUG4RG/Rgvn+Fo4x8Um5OqpoI2tWsz
         qxiM9DKMCJLK7uVmKtGRH//G/1LpXaOVJXv7KghnahdzKsMCDLB+sBEASU37XGrs5zTv
         YptQ==
X-Gm-Message-State: AOAM5326yIyxQ3UAqYyXc/JUKbggw2Ns/MSctqvTUpGPaAIaTMfcIey7
        Qp8lF7VIPALvAPGVGLYs+5O0nY20Cp8ec2/XVaOP9A==
X-Google-Smtp-Source: ABdhPJzj1xn+B3XyIrFGeol6n1IV8bxn06RSlnQBWgrWcSTcm2KSF8hdIlmMGd/QNyTk+WmtLOQgg5A2jbtfLMcPXZs=
X-Received: by 2002:aa7:d915:: with SMTP id a21mr1389742edr.251.1610537827012;
 Wed, 13 Jan 2021 03:37:07 -0800 (PST)
MIME-Version: 1.0
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
 <20201221005318.11866-4-jiaxun.yang@flygoat.com> <fb676594-d25d-5f13-ef1e-0e4a7e77ca63@redhat.com>
In-Reply-To: <fb676594-d25d-5f13-ef1e-0e4a7e77ca63@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 13 Jan 2021 11:36:55 +0000
Message-ID: <CAFEAcA_B_-FXnKOF2=_knv6UntTVDA6oVLzdpX=DpC0smC=ZPw@mail.gmail.com>
Subject: Re: [PATCH 3/9] configure/meson: Only check sys/signal.h on non-Linux
To:     Thomas Huth <thuth@redhat.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        QEMU Trivial <qemu-trivial@nongnu.org>,
        Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc <qemu-ppc@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qemu-block <qemu-block@nongnu.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 at 07:06, Thomas Huth <thuth@redhat.com> wrote:
>
> On 21/12/2020 01.53, Jiaxun Yang wrote:
> > signal.h is equlevant of sys/signal.h on Linux, musl would complain
> > wrong usage of sys/signal.h.
> >
> > In file included from /builds/FlyGoat/qemu/include/qemu/osdep.h:108,
> >                   from ../tests/qemu-iotests/socket_scm_helper.c:13:
> > /usr/include/sys/signal.h:1:2: error: #warning redirecting incorrect #include <sys/signal.h> to <signal.h> [-Werror=cpp]
> >      1 | #warning redirecting incorrect #include <sys/signal.h> to <signal.h>
> >        |  ^~~~~~~
> >
> > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > ---
> >   meson.build | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/meson.build b/meson.build
> > index 372576f82c..1ef8722b3a 100644
> > --- a/meson.build
> > +++ b/meson.build
> > @@ -841,7 +841,10 @@ config_host_data.set('HAVE_DRM_H', cc.has_header('libdrm/drm.h'))
> >   config_host_data.set('HAVE_PTY_H', cc.has_header('pty.h'))
> >   config_host_data.set('HAVE_SYS_IOCCOM_H', cc.has_header('sys/ioccom.h'))
> >   config_host_data.set('HAVE_SYS_KCOV_H', cc.has_header('sys/kcov.h'))
> > -config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
> > +if targetos != 'linux'
> > +  # signal.h is equlevant of sys/signal.h on Linux
> > +  config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
> > +endif
>
> Seems like it sys/signal.h was introduced for OpenBSD once (see commit
> 128ab2ff50a), so this new check should be fine.

The right way to fix this would be to apply
https://patchew.org/QEMU/20201027003848.10920-1-mforney@mforney.org/
which got reviewed but never applied (it might need a respin to work
with meson) which simply removes the sys/signal.h include and the
"does the header exist" test entirely -- there is no platform which
needs sys/signal.h.

thanks
-- PMM
