Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF39068BBD9
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBFLkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBFLjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:39:49 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348FE18160
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:39:48 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d14so10050636wrr.9
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yxzMPrwnyqWp6qKpL6XTSw4wFu9F5I517L3JAuCJApU=;
        b=Crzp8xLuv7vT33BW1lcCwxVyCXJh13+Sj0SmcbG4cQ0iS4+cvnv6p++jThCsYpCCJx
         CjXjujdctL/ZJ0/AvA57gMp/sojIhlCnHvIg5jTODtxLRh4ra/xp7swC7s8NERK/bM8o
         cSphxjC3CdKqTBEaX/u/MJr2VLb97A4tLC01opt3e/U4sYa+vXKSutM57KsOm22/n0sf
         Dev/VFRdLJOgyHwYW8YVp1I1bWDy/QQjylHspAV6nchTHllwi1S4+y/uQkcBZNzSvhjF
         deVlzj81QzQlH2WXH7DvY7BI5CdzLIOzymc6O2tyWphRPK/ARcS+PYHCQdXEimoxvacM
         Nilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxzMPrwnyqWp6qKpL6XTSw4wFu9F5I517L3JAuCJApU=;
        b=EbKF+6cjUlms6vDs0vD7s085S/jK54AEEGR4Eh2p5ROeHgjIZq4WFwQAjeN0Ul4dl+
         z20cSy9Za6xrLpnO2Km9P51Rqrjeun472M31RugFhWnGwcbZGQu75jIphWnLJKGoCIT+
         s89G5WnClhIeX/RarJtm0gC6jBZ1cvNOHTrvat2jzjoJInRCvHdP3pNYn9qnbgJPsq7t
         x+/hH/Ee4NfgnEDOrvHljrWH/c1+GuULHvGpSkvkDfNE2DZ/uK05TZzJi0+x7RBhY31G
         e49A49BXEAi0YDcUztCZ5Pczj0GzJI1EQHNYLwFMFPTfLPvm5VMMFhI4YE4XJ6bM632O
         0MRw==
X-Gm-Message-State: AO0yUKWChxYnH1Pf+PfoCDDWW8enROlyNxCBD3mDMJDtr4JAzRwbu3Xc
        T7TT4B2jNGpQRDf3rXurXVtcYQ==
X-Google-Smtp-Source: AK7set8EeWOQhsQ+26/dKWjAyn5DbZeAsswW9JlVKBEJPnGzws25EDsSang7NTSzwB5drrDcKSOo2w==
X-Received: by 2002:adf:dc43:0:b0:2bd:e8b2:4da8 with SMTP id m3-20020adfdc43000000b002bde8b24da8mr15920355wrj.35.1675683586696;
        Mon, 06 Feb 2023 03:39:46 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm8900334wri.103.2023.02.06.03.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 03:39:46 -0800 (PST)
Date:   Mon, 6 Feb 2023 12:39:45 +0100
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
Message-ID: <20230206113945.vcnrokltvzgifsqu@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-8-atishp@rivosinc.com>
 <20230202170345.uwi72dauzunlzxex@orel>
 <CAOnJCUJfc8y729GiUdtqhv+PZu8v9rH+kfpwPwdW=GQPEs9FNw@mail.gmail.com>
 <CAOnJCUKn_pLKqYO71S6MrZd=rnTdSShZk+XksX2uxTiVtthmTA@mail.gmail.com>
 <20230206092204.aiyo43uxlm4xdmgn@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206092204.aiyo43uxlm4xdmgn@orel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 10:22:04AM +0100, Andrew Jones wrote:
> On Sat, Feb 04, 2023 at 11:37:47PM -0800, Atish Patra wrote:
> > On Fri, Feb 3, 2023 at 12:47 AM Atish Patra <atishp@atishpatra.org> wrote:
> > >
> > > On Thu, Feb 2, 2023 at 9:03 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > > >
> > > > On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
> > > > > This patch only adds barebone structure of perf implementation. Most of
> > > > > the function returns zero at this point and will be implemented
> > > > > fully in the future.
> > > > >
> > > > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > > > ---
> > > > >  arch/riscv/include/asm/kvm_host.h     |   4 +
> > > > >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  78 +++++++++++++++
> > > > >  arch/riscv/kvm/Makefile               |   1 +
> > > > >  arch/riscv/kvm/vcpu.c                 |   7 ++
> > > > >  arch/riscv/kvm/vcpu_pmu.c             | 136 ++++++++++++++++++++++++++
> > > > >  5 files changed, 226 insertions(+)
> > > > >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > >  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> > > > >
> > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > > > > index 93f43a3..b90be9a 100644
> > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > @@ -18,6 +18,7 @@
> > > > >  #include <asm/kvm_vcpu_insn.h>
> > > > >  #include <asm/kvm_vcpu_sbi.h>
> > > > >  #include <asm/kvm_vcpu_timer.h>
> > > > > +#include <asm/kvm_vcpu_pmu.h>
> > > > >
> > > > >  #define KVM_MAX_VCPUS                        1024
> > > > >
> > > > > @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
> > > > >
> > > > >       /* Don't run the VCPU (blocked) */
> > > > >       bool pause;
> > > > > +
> > > > > +     /* Performance monitoring context */
> > > > > +     struct kvm_pmu pmu_context;
> > > > >  };
> > > > >
> > > > >  static inline void kvm_arch_hardware_unsetup(void) {}
> > > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > new file mode 100644
> > > > > index 0000000..e2b4038
> > > > > --- /dev/null
> > > > > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > @@ -0,0 +1,78 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > > +/*
> > > > > + * Copyright (c) 2023 Rivos Inc
> > > > > + *
> > > > > + * Authors:
> > > > > + *     Atish Patra <atishp@rivosinc.com>
> > > > > + */
> > > > > +
> > > > > +#ifndef __KVM_VCPU_RISCV_PMU_H
> > > > > +#define __KVM_VCPU_RISCV_PMU_H
> > > > > +
> > > > > +#include <linux/perf/riscv_pmu.h>
> > > > > +#include <asm/kvm_vcpu_sbi.h>
> > > > > +#include <asm/sbi.h>
> > > > > +
> > > > > +#ifdef CONFIG_RISCV_PMU_SBI
> > > > > +#define RISCV_KVM_MAX_FW_CTRS        32
> > > > > +
> > > > > +#if RISCV_KVM_MAX_FW_CTRS > 32
> > > > > +#error "Maximum firmware counter can't exceed 32 without increasing the RISCV_MAX_COUNTERS"
> > > >
> > > > "The number of firmware counters cannot exceed 32 without increasing RISCV_MAX_COUNTERS"
> > > >
> > > > > +#endif
> > > > > +
> > > > > +#define RISCV_MAX_COUNTERS      64
> > > >
> > > > But instead of that message, what I think we need is something like
> > > >
> > > >  #define RISCV_KVM_MAX_HW_CTRS  32
> > > >  #define RISCV_KVM_MAX_FW_CTRS  32
> > > >  #define RISCV_MAX_COUNTERS     (RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
> > > >
> > > >  static_assert(RISCV_MAX_COUNTERS <= 64)
> > > >
> > > > And then in pmu_sbi_device_probe() should ensure
> > > >
> > > >   num_counters <= RISCV_MAX_COUNTERS
> > > >
> > > > and pmu_sbi_get_ctrinfo() should ensure
> > > >
> > > >   num_hw_ctr <= RISCV_KVM_MAX_HW_CTRS
> > > >   num_fw_ctr <= RISCV_KVM_MAX_FW_CTRS
> > > >
> > > > which has to be done at runtime.
> > > >
> > >
> > > Sure. I will add the additional sanity checks.
> > >
> > 
> > As explained above, I feel we shouldn't mix the firmware number of
> > counters that the host gets and it exposes to a guest.
> > So I have not included this suggestion in the v5.
> > I have changed the num_fw_ctrs to PMU_FW_MAX though to accurately
> > reflect the firmware counters KVM is actually using.
> 
> Sounds good

I just looked at v5. IMO, much of what I proposed above still makes
sense, since what I'm proposing is that the relationship between
RISCV_KVM_MAX_HW_CTRS, RISCV_KVM_MAX_FW_CTRS, RISCV_MAX_COUNTERS, and 64
(our current max bitmap size) be explicitly checked. So, even if we want
RISCV_KVM_MAX_FW_CTRS to be SBI_PMU_FW_MAX, it'd be good to have

#define RISCV_KVM_MAX_HW_CTRS  32

(And a runtime check confirming num_hw_ctrs + 1 <= RISCV_KVM_MAX_HW_CTRS,
 and then either silently capping or issuing a warning and capping)

And, to be sure the sum of RISCV_KVM_MAX_FW_CTRS and RISCV_KVM_MAX_HW_CTRS
doesn't exceed the size of the bitmap

#define RISCV_KVM_MAX_FW_CTRS	SBI_PMU_FW_MAX
#define RISCV_MAX_COUNTERS	(RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
static_assert(RISCV_MAX_COUNTERS <= 64)

Thanks,
drew

> 
> > I don't know if there is any benefit of static_assert over #error.
> > Please let me know if you feel strongly about that.
> 
> One "normal" line vs. three #-lines?
> 
> Thanks,
> drew
