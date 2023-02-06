Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C11A68B881
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBFJWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBFJWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:22:09 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E1F12F11
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 01:22:06 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id n13so8145787wmr.4
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 01:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h3/29hABhm9XLu3Rv4E2s416ZzobvTLA9/Se1Cqam/I=;
        b=WI4D8Out1HjIQVrO/FV9gjJNBFw7MjrXUgijfPA13egtBA1GHPTZXvsBLROC5JtR8Q
         fbWdPu9tLzA+KlMHzJcHOfwUVbMQ/AkRgQztMcSyfGfkWZFsgFz077cgBGq8Kf9WpAya
         BR/3SwJcYVPatEVrXi927F4xH78Sq0otcGlqBBaDyu3+Vuhui3Lx/sy0zyQlAkek2pRF
         wGA5W6RuODcPJFwKmeZnUTy9lRMCR+zr5rpRVv1jOrnDYUrITHFZcmELB3io5LSAqUh9
         JacHCtXTyUUImDe+M4hG7pVZSOii1zmFJ84qGdsb7+qbFvEn6R5t+oM8OCviytDfrd2i
         JI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3/29hABhm9XLu3Rv4E2s416ZzobvTLA9/Se1Cqam/I=;
        b=A+zy48YelawU3Hc8i4TnpNL9qOjObwsSUTI9FKA/NcT5XazWkaxH/CmkoxSsJNwFoj
         KeApR/YdDNZ/kkZBhVPfzCVJ7ez8wXATw+gZyzYkW5QYUXXaLP6xOan/FjnbCUIy/n3y
         KBkOHzoAS0qvhEDd4M8/Id0+U6BF0PPfy9IMKfinbYyv5IytG0Ju7paUK9Tr8K0NgpV7
         agejU9f0VXQOJpUOBMr7FXpWZ+xLxvj4IXy2Om9ayGOVap7sFtRXF0Qb1k4rcg8b0PB6
         l/3TlMjjfahV2KpAYc4mNfI25eIs+IQ1O5EDzYOVaYuxkmsLjLwJD7fL7eDEgzf0cg7A
         rl0A==
X-Gm-Message-State: AO0yUKX3vfOE9tUK28rB2Q/14AUHh4NjkuaiFXtbWPqoyUBbmWe+mrvM
        LtW5M959yhpghtpw/Rht3ZEGwQ==
X-Google-Smtp-Source: AK7set81zyYOD4pHEoWMQOkNV1bM2HP8Wb+ewmqDF1dAPQAsKrrMrfEeL1eYsVwOIFBZTQL6TkdbNw==
X-Received: by 2002:a05:600c:3c9a:b0:3dc:c5c:b94f with SMTP id bg26-20020a05600c3c9a00b003dc0c5cb94fmr18269461wmb.39.1675675325243;
        Mon, 06 Feb 2023 01:22:05 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c351000b003dc521f336esm10868423wmq.14.2023.02.06.01.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 01:22:04 -0800 (PST)
Date:   Mon, 6 Feb 2023 10:22:04 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
Message-ID: <20230206092204.aiyo43uxlm4xdmgn@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-8-atishp@rivosinc.com>
 <20230202170345.uwi72dauzunlzxex@orel>
 <CAOnJCUJfc8y729GiUdtqhv+PZu8v9rH+kfpwPwdW=GQPEs9FNw@mail.gmail.com>
 <CAOnJCUKn_pLKqYO71S6MrZd=rnTdSShZk+XksX2uxTiVtthmTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCUKn_pLKqYO71S6MrZd=rnTdSShZk+XksX2uxTiVtthmTA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 04, 2023 at 11:37:47PM -0800, Atish Patra wrote:
> On Fri, Feb 3, 2023 at 12:47 AM Atish Patra <atishp@atishpatra.org> wrote:
> >
> > On Thu, Feb 2, 2023 at 9:03 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > >
> > > On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
> > > > This patch only adds barebone structure of perf implementation. Most of
> > > > the function returns zero at this point and will be implemented
> > > > fully in the future.
> > > >
> > > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > > ---
> > > >  arch/riscv/include/asm/kvm_host.h     |   4 +
> > > >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  78 +++++++++++++++
> > > >  arch/riscv/kvm/Makefile               |   1 +
> > > >  arch/riscv/kvm/vcpu.c                 |   7 ++
> > > >  arch/riscv/kvm/vcpu_pmu.c             | 136 ++++++++++++++++++++++++++
> > > >  5 files changed, 226 insertions(+)
> > > >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > >  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> > > >
> > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > > > index 93f43a3..b90be9a 100644
> > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > @@ -18,6 +18,7 @@
> > > >  #include <asm/kvm_vcpu_insn.h>
> > > >  #include <asm/kvm_vcpu_sbi.h>
> > > >  #include <asm/kvm_vcpu_timer.h>
> > > > +#include <asm/kvm_vcpu_pmu.h>
> > > >
> > > >  #define KVM_MAX_VCPUS                        1024
> > > >
> > > > @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
> > > >
> > > >       /* Don't run the VCPU (blocked) */
> > > >       bool pause;
> > > > +
> > > > +     /* Performance monitoring context */
> > > > +     struct kvm_pmu pmu_context;
> > > >  };
> > > >
> > > >  static inline void kvm_arch_hardware_unsetup(void) {}
> > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > new file mode 100644
> > > > index 0000000..e2b4038
> > > > --- /dev/null
> > > > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > @@ -0,0 +1,78 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > +/*
> > > > + * Copyright (c) 2023 Rivos Inc
> > > > + *
> > > > + * Authors:
> > > > + *     Atish Patra <atishp@rivosinc.com>
> > > > + */
> > > > +
> > > > +#ifndef __KVM_VCPU_RISCV_PMU_H
> > > > +#define __KVM_VCPU_RISCV_PMU_H
> > > > +
> > > > +#include <linux/perf/riscv_pmu.h>
> > > > +#include <asm/kvm_vcpu_sbi.h>
> > > > +#include <asm/sbi.h>
> > > > +
> > > > +#ifdef CONFIG_RISCV_PMU_SBI
> > > > +#define RISCV_KVM_MAX_FW_CTRS        32
> > > > +
> > > > +#if RISCV_KVM_MAX_FW_CTRS > 32
> > > > +#error "Maximum firmware counter can't exceed 32 without increasing the RISCV_MAX_COUNTERS"
> > >
> > > "The number of firmware counters cannot exceed 32 without increasing RISCV_MAX_COUNTERS"
> > >
> > > > +#endif
> > > > +
> > > > +#define RISCV_MAX_COUNTERS      64
> > >
> > > But instead of that message, what I think we need is something like
> > >
> > >  #define RISCV_KVM_MAX_HW_CTRS  32
> > >  #define RISCV_KVM_MAX_FW_CTRS  32
> > >  #define RISCV_MAX_COUNTERS     (RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
> > >
> > >  static_assert(RISCV_MAX_COUNTERS <= 64)
> > >
> > > And then in pmu_sbi_device_probe() should ensure
> > >
> > >   num_counters <= RISCV_MAX_COUNTERS
> > >
> > > and pmu_sbi_get_ctrinfo() should ensure
> > >
> > >   num_hw_ctr <= RISCV_KVM_MAX_HW_CTRS
> > >   num_fw_ctr <= RISCV_KVM_MAX_FW_CTRS
> > >
> > > which has to be done at runtime.
> > >
> >
> > Sure. I will add the additional sanity checks.
> >
> 
> As explained above, I feel we shouldn't mix the firmware number of
> counters that the host gets and it exposes to a guest.
> So I have not included this suggestion in the v5.
> I have changed the num_fw_ctrs to PMU_FW_MAX though to accurately
> reflect the firmware counters KVM is actually using.

Sounds good

> I don't know if there is any benefit of static_assert over #error.
> Please let me know if you feel strongly about that.

One "normal" line vs. three #-lines?

Thanks,
drew
