Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386D536BE8F
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 06:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhD0Enx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 00:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbhD0Env (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 00:43:51 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C62C061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 21:43:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s15so1757734plg.6
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 21:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L/KHE0b9yQxhmyIXZE35ERgi0XKeQwuyEqiuqSbm+MM=;
        b=hffZSpoCi3KBvwODP+2t/DdtmbubisXWP0vnNWLRWS4Y/Cp0n9d0WpV6sq3QbgYxTt
         v04oTjIB7J5TO/GSu15NOFMLDsSwfiKYjzpbyaOsvBmjEHgVkOqQF5i2dBUDZeX0y9EW
         VxVvpQ7Bfg5S5DathfiHWZJpH7cwdeI2VJ4/E5C0fzhTj3uLoECi+A6New3KuKzxdksc
         zh6Ve1N+SZS75XoEiNKEQxAvI7IP/NiFdw5C4E3okszmEUzfivA/upj/nDLNi73Rs1Pl
         lekPrYW/SgMVlu3IpvYype2JS4iIOV5tSaN936p/YyXn0fCFNx2wFzaVfzT4XHTrex/k
         ZfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L/KHE0b9yQxhmyIXZE35ERgi0XKeQwuyEqiuqSbm+MM=;
        b=jsAf5gXM8xbniTErFGfzVoeJBt7h3wTpeexX4qH7yZq7fQjGHFMD2vnlUB7f4agdqd
         Lynj3Qp4Hc9xm24Mfmxp6WhD9geZRg0c1EupZidHGJxQx+wtpNxXKElNcZ/8TeZrXEWy
         9IAYattIGPHpM7q0MFHmozCZ2rZEPJRRVhlBdpmz2z7V8AOVnuEbcEnM4vnADU2ev5QV
         xr8TEVsqlY7wzPLY2vlOY7NNL7xAh2akBCcaB5/KB+9+RKHXzXTaQP77KHLdMQCGp70k
         M61pJz5OJ81vK8WNVsfxlLtsbd/poVZ95uYUB8nilsPqj4NGQ4zHS05vlpIvacFlda29
         5XkQ==
X-Gm-Message-State: AOAM531y1v9Wrf4ITOoKCKFDKcJAazpfaAS8z9BxAGOZ6igIrRhVCQIC
        aFvEnFLQFC3g8BKG7L6fDjanhq9cCOPX4VkRYNxeCQ==
X-Google-Smtp-Source: ABdhPJzlYEz8sQBUvV3rf/9X99n4H6YdHBdvYc8i2an4oSSdUGuNcOJET6+rM2jmO4S1D9sfNFjzfQmSui3IwTaoq2g=
X-Received: by 2002:a17:902:654b:b029:ec:a435:5b5c with SMTP id
 d11-20020a170902654bb02900eca4355b5cmr23318742pln.42.1619498587057; Mon, 26
 Apr 2021 21:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210423223404.3860547-1-seanjc@google.com> <20210423223404.3860547-4-seanjc@google.com>
 <CAAeT=FxhkRhwysd4mQa=iqEaje7R5nHew8ougtoyDEhL2sYxGA@mail.gmail.com> <YIcWvcneHWA9OPxv@google.com>
In-Reply-To: <YIcWvcneHWA9OPxv@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 26 Apr 2021 21:42:51 -0700
Message-ID: <CAAeT=FzVDFVCjYAZyc+QXwtLeOW5UR6AsYZwNT6kFbOwnn=xFQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] KVM: x86: Tie Intel and AMD behavior for
 MSR_TSC_AUX to guest CPU model
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > It looks Table 2-2 of the Intel SDM Vol4 (April 2021) says
> > TSC_AUX is supported:
> >
> >    If CPUID.80000001H:EDX[27] = 1 or CPUID.(EAX=7,ECX=0):ECX[22] = 1
> >
> > Should we also check X86_FEATURE_RDPID before returning 1
> > due to no RDTSCP support ?
>
> Yep.  VMX should also clear RDPID if the ENABLE_RDTSCP control isn't supported.
> That bug isn't fatal because KVM emulates RDPID on #UD, but it would be a
> notieable performance hit for the guest.

Thank you so much for the confirmation and the information.
Understood.


> There is also a kernel bug lurking; vgetcpu_cpu_init() doesn't check
> X86_FEATURE_RDPID and will fail to initialize MSR_TSC_AUX if RDPID is supported
> but RDTSCP is not, and __getcpu() uses RDPID.  I'll verify that's broken and
> send a patch for that one too.

I don't find vgetcpu_cpu_init() or __getcpu() in
https://github.com/torvalds/linux.
I would assume you meant setup_getcpu() and vdso_read_cpunode() instead (?).


> AMD also documents this in Appendix E:
>
>   CPUID Fn0000_0007_EBX_x0 Structured Extended Feature Identifiers (ECX=0)
>   Bits   Field   Name
>   ...
>   22     RDPID   RDPID instruction and TSC_AUX MSR support.

Thank you.  I overlooked that...


Regards,
Reiji
