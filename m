Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140D368BC1B
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBFLyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjBFLyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:54:50 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B4113509
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:54:48 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso8551035wms.4
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f32i0UtHmpYTxPyacuTVXQLMyNqvR3s0aoWUZXvnOLk=;
        b=Q5WSa6Sjy/zZV9ruut5vijr1P+Y42JVVn0xvkzpI2EGUIxm1doohtqPcWLEFd4/yy6
         r5c7TWMiRKl2jjF/H8ql65T5E1aipiVedwxtHEYPmFrCyzmK+Sq19W4W3JXpxMRGjdM4
         7cMGpmrKyk6gwQmN02oqWeWKBoKeARUpjKYoFjhL7NF+6Nq8O+/3Kex2S4x1K7rPI4Mc
         s+9IaNsGunC0z8UC3IVBANq5yi5t1qB9ohH/c1cl1YckxrOIEbn6Pq/ia1DUtHyy3uK6
         pQX98u1P6o1OzK2DNVRxzqHdTZOAN9m1g6583Gq74tP31tpt64iYlV3eZNJBeHbZs+gy
         pWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f32i0UtHmpYTxPyacuTVXQLMyNqvR3s0aoWUZXvnOLk=;
        b=ei0rWuZPZYouX4hcGSFmxc457Zzr9IwfVW+TXr6qybMlzFcMC1j5W/HoNis32AD8Ij
         8ICbfBT8FEGm3FWN0NbVu18L4syF59AKwtdmzCx+qJnkSUlRiN1A98uQSZE3GifCvk/K
         TV0LGITglqxxbYkTocLyaCOiGNit8G/bri/gYsEfCiFnuGIEryAK7i5X9cCKzr9+gqP9
         hgLxvkw/GBeAIKKhcq6KJ9fS1Ttx4hxs8ush2Ut0mdHanm1KP3mz5yk5I8PmzKFxt7xS
         EuMzrCVTI47wTkgG1GeuH6x2kdAtqRnClCOIWcLA2uD8BIDfqUthQbsd77OTZPKrYije
         vvLg==
X-Gm-Message-State: AO0yUKUfsS1LAh1OkR+fQF7scMoLrINV6+HTQU3Wy4VlFgI61egUYJBk
        xpjWItW4I/ocEsaf0oERNXdQoQ==
X-Google-Smtp-Source: AK7set8q5TEDigFlaoXKvGEyXmW7/pfWOHSWGReOGdbnXfUkXZCqKPhMWAalL3vq95IQNXfwjr3xIA==
X-Received: by 2002:a05:600c:1c96:b0:3df:9858:c032 with SMTP id k22-20020a05600c1c9600b003df9858c032mr10856043wms.7.1675684486906;
        Mon, 06 Feb 2023 03:54:46 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id bg21-20020a05600c3c9500b003db06493ee7sm17491455wmb.47.2023.02.06.03.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 03:54:46 -0800 (PST)
Date:   Mon, 6 Feb 2023 12:54:45 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 11/14] RISC-V: KVM: Implement trap & emulate for
 hpmcounters
Message-ID: <20230206115445.4deembtvetojslee@orel>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
 <20230205011515.1284674-12-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205011515.1284674-12-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 04, 2023 at 05:15:12PM -0800, Atish Patra wrote:
> As the KVM guests only see the virtual PMU counters, all hpmcounter
> access should trap and KVM emulates the read access on behalf of guests.
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 ++++++++
>  arch/riscv/kvm/vcpu_insn.c            |  4 +-
>  arch/riscv/kvm/vcpu_pmu.c             | 59 ++++++++++++++++++++++++++-
>  3 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 40905db..344a3ad 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -48,6 +48,19 @@ struct kvm_pmu {
>  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
>  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
>  
> +#if defined(CONFIG_32BIT)
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{.base = CSR_CYCLEH,     .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm }, \
> +{.base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
                      ^ should be tabs?

> +#else
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{.base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
                      ^ here too
> +#endif
> +
> +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +				unsigned long *val, unsigned long new_val,
> +				unsigned long wr_mask);
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
>  int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				struct kvm_vcpu_sbi_return *retdata);
> @@ -71,6 +84,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>  struct kvm_pmu {
>  };
>  
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = 0,      .count = 0, .func = NULL },
               ^ and here and aligned with the ones above?

Thanks,
drew
