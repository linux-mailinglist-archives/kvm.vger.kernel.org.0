Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00543D7D3F
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhG0SPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhG0SPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:15:43 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E56C061757
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:15:43 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id f11so17052114ioj.3
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QxSRxzOFeQLJ5uc7MIkOgYLNBbQgZnMB/yjqTh8ePgU=;
        b=Bym1wunwfstrr63zMR1hqtoB3FszMKZsqFKAsR5keV57Y/pk095YIvGa2EaVOGDwzy
         HA59zTr0LqlZCxQlPMCQE8rv0T25vvEzD6u/jlqxFOTTsyk7Nyyso9XNmByzHOOEYy0/
         et4Lg9kkXoYW3NOB1hjsFvgavNeEjvdPr5FopT/nr7Tvk8HWxV8UPhBCptQ66qDlcwBD
         QpMC7rlES6YbiVmQa9FB8ZU1vA71X/6HADWFTTlmBaKpsOYnJpldH+7cfgRIU2xVeKeP
         /NQvVdC2yBiAEHR0F0bZE1FPu8psiRSqlb9uA20rLJtUI3y86ejtbSMI6wb4c35VsO75
         OB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QxSRxzOFeQLJ5uc7MIkOgYLNBbQgZnMB/yjqTh8ePgU=;
        b=t19xhsgz4HXsQaab7n56mPVOyMWtAEK4iJL/x0ncO85kmJuGcM0Ntipmu0+b0rPsVE
         a1UUAvZ53U+kjUn2lcmhC5kqXhRNOTGx0T+JIl6Ku6F93hbiC2wc2x+MmFw5YA4+vRl4
         8Tkzh1YvFVXyf/Bq1SAAIF4T4GdSLxzhnLEwWKFtHco0CmC5rsiwdD6dj3q8NIAwd5Ob
         KCevg9r9uo6W/P26rxseKPoGoubxDN6P1hhMlYwni7TtZczlAoeHxxgGdRPxAY6lP+mu
         qZTYB1eYvDl2H9O23KTRmXISlVr4o60KYODrwLP/2/IrIy16ORgtJWI/5OX6RJRTVMTZ
         C/sg==
X-Gm-Message-State: AOAM530C7l+Ju/2wWCXKzVYUUnR/CksQXXyvIf2wRWON+2vu4UyeZHrS
        jKHvkAo3FxHnEazZ9/CN7Gx95iYWjJQqYiYd2W4=
X-Google-Smtp-Source: ABdhPJzUSjetnYAABFeCoz/YaFNREbPQK0pwGxyQY21CxJ5ebEo5rT+vJVjZNMgA4Rs89th3Ae1LHJCLiCO3+up5Uno=
X-Received: by 2002:a6b:e70f:: with SMTP id b15mr20714387ioh.67.1627409742845;
 Tue, 27 Jul 2021 11:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210727111247.55510-1-lirongqing@baidu.com>
In-Reply-To: <20210727111247.55510-1-lirongqing@baidu.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 27 Jul 2021 20:15:31 +0200
Message-ID: <CAM9Jb+hWS5=Oib-NuKWTL=sfg=BQ-usdRV-H-mj6hLFVF6NYnQ@mail.gmail.com>
Subject: Re: [PATCH][v2] KVM: use cpu_relax when halt polling
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> SMT siblings share caches and other hardware, and busy halt polling
> will degrade its sibling performance if its sibling is working
>
> Sean Christopherson suggested as below:
>
> "Rather than disallowing halt-polling entirely, on x86 it should be
> sufficient to simply have the hardware thread yield to its sibling(s)
> via PAUSE.  It probably won't get back all performance, but I would
> expect it to be close.
> This compiles on all KVM architectures, and AFAICT the intended usage
> of cpu_relax() is identical for all architectures."

For sure change to cpu_relax() is better.
Was just curious to know if you got descent performance improvement compared
to previously reported with Unixbench.

Thanks,
Pankaj
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff v1: using cpu_relax, rather that stop halt-polling
>
>  virt/kvm/kvm_main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7d95126..1679728 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3110,6 +3110,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>                                         ++vcpu->stat.generic.halt_poll_invalid;
>                                 goto out;
>                         }
> +                       cpu_relax();
>                         poll_end = cur = ktime_get();
>                 } while (kvm_vcpu_can_poll(cur, stop));
>         }
> --
> 2.9.4
>
