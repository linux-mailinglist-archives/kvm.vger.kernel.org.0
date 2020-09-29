Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C79C27D795
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 22:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgI2UHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 16:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgI2UHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 16:07:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786E3C061755
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 13:07:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id j11so17043309ejk.0
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u1h2fvvT4OPp+mDt9BSuEIwI1NU5rX5oD8xSPHyS3oE=;
        b=t0WcvVombLhwdXdTCcUWhl2itrZyb/IumcAxL3uVxGyb+WGHU7Uoz2ogoqkVeZAGQG
         gW2aYszOTJ2aNsbB+Z7NeadAmAPSpjGCuOEUp39eBda8VphQlH9gIWkuTtSj77LJ420/
         vF54QA5aweY79WlMUb7c3cN0o9CvJGUE+WTyQte3ECfZObuWUpdj9EPiWNEYkwgpj7GH
         ascElJ35lrz2DMJ0n/C6k96ywcVccRucu9kHhvLPb3qgPv1z0IcZoajuknEAnKVtrnzt
         ViwIn7o/SNtjAmnE92xgSNB+qc6WQwHs3Wp8lIFhQqnKMy71Vse1JvjQELUunP9Uqndf
         0miw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u1h2fvvT4OPp+mDt9BSuEIwI1NU5rX5oD8xSPHyS3oE=;
        b=Elf7fDBcWwwAvFZCJ3I2borW8jVvK+u1JBwMT619aC7hwvaVW66mhPQVLoY1X3DvEQ
         5bH1Ad9goHWDZ6aW5JMHVxRFQrROu882bxCUqeLclTdeP+9KqT2Hf0E+e900D9af8vkr
         EFzf1fOHseKH6KFRN82/XcMXVGlfAcwBsZlRRUaL5y9EDk2XMHKSOYccBfQvnhRq/XFI
         PIRMYhz+YnZcX3L5aTA8RZfABzucP+qN1I8j1j7FEM8XMaBm8uW/J13CvrWMcQjrgttL
         wfN5bORqcs1yPzCguegOGgWfo5yd14DlhuW99Rtsq42P3cTNDLEMnirT+6Vwa/+u1lgr
         bHIQ==
X-Gm-Message-State: AOAM530/W9mdHYORSjgK99TkVP5bkEyql+tNAGVrIPZUEcShzggC4v3d
        41Hukx+Ng6075cxK/k6aDlbIGVwQRvIW/Az2HqtplQ==
X-Google-Smtp-Source: ABdhPJzNvPmfpqeFF5weiJ06WOCbfrwLMo30g1vXELPjVSGmAHTe0OlZZUhZENuMjibdqJ8Ah+loAU7hXvzaKksnKQA=
X-Received: by 2002:a17:906:d936:: with SMTP id rn22mr5774019ejb.4.1601410020098;
 Tue, 29 Sep 2020 13:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-18-philmd@redhat.com>
In-Reply-To: <20200316160634.3386-18-philmd@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 29 Sep 2020 21:06:48 +0100
Message-ID: <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
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

On Mon, 16 Mar 2020 at 16:08, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> When building a KVM-only QEMU, the 'virt' machine is a good
> default :)
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  hw/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index d0903d8544..8e801cd15f 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -1,5 +1,6 @@
>  config ARM_VIRT
>      bool
> +    default y if KVM
>      imply PCI_DEVICES
>      imply TEST_DEVICES
>      imply VFIO_AMD_XGBE

What does this actually do ? Why should the choice of
accelerator affect what boards we pull in by default?
I can see why you'd want to disable boards that only
work with accelerators we don't enable, ie don't build
TCG-only boards unless CONFIG_TCG, but this is the other
way around...

thanks
-- PMM
