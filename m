Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55613B2202
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFWUuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWUt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 16:49:59 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2366C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:47:40 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso3282879oto.12
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jIKGdZneSKaUNLACnmOaJDKvcXdM8mWNUUPaWnGsATk=;
        b=Nw5Vc0HAWfdvfs0v7ercnzlGpS11kFec7T5YSYKTaelvNawYb4kRldw6Nf61q6TdXk
         Z74nMnXgKhWOX6J8yHMnimH4Mi7IYw7aSg3u4c/lqk99yO85em5IzWRvIdjWD9Df+xjv
         vG4Uc2SLk7f+fV4b0/Fpmjo2BnxEAJ+ZlcGkadu2zZwQLBclyVSTwONpCbJFFIIiZsfv
         xiczLWd2MFFGMPtObxWOYcraJWKKqiKjGe92TOqhIWDOJIGYrUjwnGCqfZi8iL9s2HI2
         6wejFNdC2q8J1vc590RPbdqZ5UBJDFit4nNW1UOk6Sr+qXxMCv7IpfkwSILHy2NfYh70
         MLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jIKGdZneSKaUNLACnmOaJDKvcXdM8mWNUUPaWnGsATk=;
        b=SlVZQC0Te/tIykqKz+DsXI4rz5yuvMbK7djVzF1SBUI7XvMWMwxGv6P/3U4S8qtcjk
         y6wIJByYbLqexEH+l0dRDim1/umafC7Ci3O++L+PXijrwJsGRc4hpJaaErEFQr7wayhn
         AHh4iJy6xVJwYLtlj1LnqC9Ie3nAfikt87YAgkeZ2lbFNOnzs1qxCZFqcUA01tmEJfns
         o61c3WyLV3IxLPfIYovcEUHqTrhy4DVn2NMFajGrVNZQvAfbMd/hG1QlKtqf0Y+dimZt
         /GcHoNAf00Vh1KGxAbhzO6MJfmA4+M2eS63Sx25r2KylvAVIJSmNn1WLyouHgp4KOVkU
         Xf/Q==
X-Gm-Message-State: AOAM531bXjmFXdlL9xkpEG6+FqpF7s1tYPMAIbsm1bjJRaLqS+X9hHCa
        640EspJtnrYtUW5EgFF7Fsp+qlePAJkHf8tX0gtJ9g==
X-Google-Smtp-Source: ABdhPJwkKSWvUPd+BlAlj4YgekreAllWw+PAzn/RTwQtzzgs1D2mYFKm1K7IZ7v5z6HJcn9krPM0tkj3fusWcPQWU/Q=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr1615921oth.241.1624481260046;
 Wed, 23 Jun 2021 13:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210623203426.1891402-1-aaronlewis@google.com>
In-Reply-To: <20210623203426.1891402-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Jun 2021 13:47:28 -0700
Message-ID: <CALMp9eRHR1x=+diFKM+FbO1_h-Vk+tNN9_ECuNc3THot4shrdg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: disable the narrow guest module parameter on unload
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, mgamal@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 1:35 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When the kvm_intel module unloads the module parameter
> 'allow_smaller_maxphyaddr' is not cleared because it is also used in the

...because the backing variable is defined in the

(Or something like that.)

> kvm module.  As a result, if the module parameter's state was set before
> kvm_intel unloads, it will also be set when it reloads.  Explicitly
> clear the state in vmx_exit() to prevent this from happening.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2a779b688e6..fd161c9a83fd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7996,6 +7996,8 @@ static void vmx_exit(void)
>         }
>  #endif
>         vmx_cleanup_l1d_flush();
> +
> +       allow_smaller_maxphyaddr = false;
>  }
>  module_exit(vmx_exit);

This seems reasonable to me. Another option is to move the backing
variable to the kvm_intel module, given the recent suggestion that it
should never be enabled for AMD.

Reviewed-by: Jim Mattson <jmattson@google.com>
