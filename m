Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271A027D7C0
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 22:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgI2ULq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 16:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgI2ULq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 16:11:46 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28749C061755
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 13:11:46 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gr14so17065861ejb.1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 13:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=73MxEsPtUT/TTCdrgP6iPP4/Lq4sm/5f1xzmLyh6hxA=;
        b=ggxhdLxCcavZ37JWVQnppWDOQKG1qFmxrrJTXv2OCkUF5/4r6+TJGKFxoXwaqduF9D
         6qWtqG6zl2kmkzE7lPX96g5ScHb4lB7arVx+fYXAPR0RVB3q7RJXKRLX6gTuA649f27t
         jUgxK/HMOVu48tiF7jgMaAK/mr/dI71tC9Ijb0H+pxCjuuaSuScQ43hLgmiJJyv547rw
         QIvi5b+16P9Up6iGBm/QoVJBf2GQNZXhGk2RzT5RacStnF51hlJ3n3LDYcub6+CIfoGa
         MjHJe+SYfRlmsZrFI91Lh1ENWcZrKnrEl+MVtDQcOMSt1oAYbykPKBh9maC/8DatLmTw
         nQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=73MxEsPtUT/TTCdrgP6iPP4/Lq4sm/5f1xzmLyh6hxA=;
        b=VqYSCi/Ld4PNYHHMQvv/IXzunOlEl66goXxuE0I/4NcqWu3Hg66PojgI/gtXUto188
         uj/scgKNL7oIdCSiwAGIbBzgSbwDEtndD7e/XY074AFIhYCskQCtLl8Vu1bLoNLipA+9
         +V+A8d1NsMxybNI7d7/YNHCPHIHUQFF5+Lf4rT5RdhZ38dZKA75UwBGAdU4t58vgH1Wp
         ZKsvw3U+Z8pkX7sE6I0jIPC5OjNl9jKezfBjVhXhPNcqksS9L+YzNRE1LxAceGp3fT1K
         hgQdYjg149hFkPZy1DwrfSl02O8izYy20YhieuXQQiJuCUyKmqW7L+ZUs/uYnw6dy7KU
         vpOA==
X-Gm-Message-State: AOAM532aYWtSsXIF/3Pzg3rLMIYkfwODzNCOu5lFNaMZyG5W9KcMwtvE
        3M9eH8KxV4Dtlu4wc7ggxBkcGZ9UjuebIYUzemFTLQ==
X-Google-Smtp-Source: ABdhPJyg+ZLsFEMn4YKZQIGAM4gNsSD24gIeZvsuq9F+1zA0aKU9tg0AxMmILZyBdUSEqXkHWTobmd3jnYwL0+Xng5I=
X-Received: by 2002:a17:906:4a53:: with SMTP id a19mr5876763ejv.56.1601410304552;
 Tue, 29 Sep 2020 13:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-18-philmd@redhat.com>
 <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
In-Reply-To: <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 29 Sep 2020 21:11:33 +0100
Message-ID: <CAFEAcA-u53dVdv8EJdeeOWxw+SfPJueTq7M6g0vBF5XM2Go4zw@mail.gmail.com>
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 at 21:06, Peter Maydell <peter.maydell@linaro.org> wrot=
e:
>
> On Mon, 16 Mar 2020 at 16:08, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.=
com> wrote:
> >
> > When building a KVM-only QEMU, the 'virt' machine is a good
> > default :)
> >
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> > ---
> >  hw/arm/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> > index d0903d8544..8e801cd15f 100644
> > --- a/hw/arm/Kconfig
> > +++ b/hw/arm/Kconfig
> > @@ -1,5 +1,6 @@
> >  config ARM_VIRT
> >      bool
> > +    default y if KVM
> >      imply PCI_DEVICES
> >      imply TEST_DEVICES
> >      imply VFIO_AMD_XGBE
>
> What does this actually do ? Why should the choice of
> accelerator affect what boards we pull in by default?

Put another way, our current default is "build everything",
so "default y if ..." on a board is a no-op...

-- PMM
