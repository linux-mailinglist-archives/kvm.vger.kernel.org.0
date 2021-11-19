Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCEA456EC1
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhKSMYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbhKSMYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:24:13 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5240BC061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 04:21:11 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u1so17814000wru.13
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 04:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ij7er2470Y2wPBGgkUoSGjBv9MApKpAoPSAbl3vcFGM=;
        b=JiC1txByfspEffoX8zfmeVfIBE3jhZB/PZ7F1nQhhz92MRm9YRHfoBGSDJGiQTIpOo
         jVaBi+Bw46dyRupANHaLOawHjD3Wn+t0zHAQh1QQfh+/47uRjDQCgvLuwKlf8jV46Rc4
         6jXA2isUv3fxDFTbjHzl1QySpWmSzD0fdCdun4lLxz7kI/YGr81zF+wV7+C0weYrtLjz
         WWBuZoiAaWCGdK9QFghF9gvtPce1anQ5oos66FK+0eVDq63Rs03vdjESnkn8jdiFmxNS
         kdbgCM9EWxfBP7LOefkd02EyRq2q1BMkATbyKXdfw/I9J5sKjQ3z42IC8KfTApRmAmcJ
         GLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ij7er2470Y2wPBGgkUoSGjBv9MApKpAoPSAbl3vcFGM=;
        b=1hwFrRhTZrCj1QfhkG4Oa0RsRvnWtyL9/83lUJAbbPhkgRlALjviwiY/FyXpbKfJ//
         XlUt/fIschTbqKBa9GBJyDziP1z3BW7o2sFlkaOEvzcu/anf1iDGdcM4RSO/R7KErufQ
         BeO3/H9kGjLiBmq8o2y/56brv9wQvvg9n4Ad0yaRzNwC6hDjlNmBdlKwp4c+4Pmfn7Qn
         YgEIv/QzRzdJlAS3bt+e+epYFxKl2OxPZ2AU4VwZnL65iNCtXKPPaDRcbdWtEoGLUIlw
         o/We7HhOUN7THjpSHVsC9JA1S95BMlqcZ4fsKSIg0r9TAKrAATf/d8YUOtPQEBnwDUAG
         s5iA==
X-Gm-Message-State: AOAM532fVSWQIbiEm+7QxeQTnCkGkPoDITT7Fd4Fc/FCbY12k80MCk0I
        WGU3mGUOyZQY4zaYmsskKDgr33Ohp2n64oHxBX9D2A==
X-Google-Smtp-Source: ABdhPJwpDih1Nz/ks8ZhQSJ1ATWfx3j/ZKzyQDFL08MT6G9WVQEczM3Z4uSFbhMCXYw9f5AP4oVpWgv71qyALRREcfA=
X-Received: by 2002:a05:6000:1a45:: with SMTP id t5mr6835921wry.306.1637324469654;
 Fri, 19 Nov 2021 04:21:09 -0800 (PST)
MIME-Version: 1.0
References: <20211117060241.611391-1-anup.patel@wdc.com> <CAOnJCU+KZn2JnZg-FZcJ7PXRpGo5SyOmdUYFeJgBenPO9xxE1w@mail.gmail.com>
In-Reply-To: <CAOnJCU+KZn2JnZg-FZcJ7PXRpGo5SyOmdUYFeJgBenPO9xxE1w@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 19 Nov 2021 17:50:58 +0530
Message-ID: <CAAhSdy0jaPPBNkXkt5-jj+LWCm+XiC0G2udK2C7n1f2TqBPCmg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix incorrect KVM_MAX_VCPUS value
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 1:23 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Tue, Nov 16, 2021 at 10:03 PM Anup Patel <anup.patel@wdc.com> wrote:
> >
> > The KVM_MAX_VCPUS value is supposed to be aligned with number of
> > VMID bits in the hgatp CSR but the current KVM_MAX_VCPUS value
> > is aligned with number of ASID bits in the satp CSR.
> >
> > Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 25ba21f98504..2639b9ee48f9 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -12,14 +12,12 @@
> >  #include <linux/types.h>
> >  #include <linux/kvm.h>
> >  #include <linux/kvm_types.h>
> > +#include <asm/csr.h>
> >  #include <asm/kvm_vcpu_fp.h>
> >  #include <asm/kvm_vcpu_timer.h>
> >
> > -#ifdef CONFIG_64BIT
> > -#define KVM_MAX_VCPUS                  (1U << 16)
> > -#else
> > -#define KVM_MAX_VCPUS                  (1U << 9)
> > -#endif
> > +#define KVM_MAX_VCPUS                  \
> > +       ((HGATP_VMID_MASK >> HGATP_VMID_SHIFT) + 1)
> >
> >  #define KVM_HALT_POLL_NS_DEFAULT       500000
> >
> > --
> > 2.25.1
> >
>
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

I have queued this patch for fixes.

Thanks,
Anup

>
> --
> Regards,
> Atish
