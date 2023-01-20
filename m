Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B958867544C
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjATMVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 07:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATMVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 07:21:45 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF3B8B303;
        Fri, 20 Jan 2023 04:21:42 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pIqNP-0003oi-Vu; Fri, 20 Jan 2023 13:20:12 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Guo Ren <guoren@kernel.org>,
        Chris Stillson <stillson@rivosinc.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Alexander Graf <graf@amazon.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barret Rhoden <brho@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Chris Stillson <stillson@rivosinc.com>
Subject: Re: [PATCH v12 06/17] riscv: Reset vector register
Date:   Fri, 20 Jan 2023 13:20:09 +0100
Message-ID: <2331455.NG923GbCHz@diego>
In-Reply-To: <20220921214439.1491510-6-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
 <20220921214439.1491510-6-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Mittwoch, 21. September 2022, 23:43:48 CET schrieb Chris Stillson:
> @@ -431,6 +431,29 @@ ENTRY(reset_regs)
>  	csrw	fcsr, 0
>  	/* note that the caller must clear SR_FS */
>  #endif /* CONFIG_FPU */
> +
> +#ifdef CONFIG_VECTOR
> +	csrr	t0, CSR_MISA
> +	li	t1, COMPAT_HWCAP_ISA_V
> +	and	t0, t0, t1
> +	beqz	t0, .Lreset_regs_done
> +
> +	/*
> +	 * Clear vector registers and reset vcsr
> +	 * VLMAX has a defined value, VLEN is a constant,
> +	 * and this form of vsetvli is defined to set vl to VLMAX.
> +	 */
> +	li	t1, SR_VS
> +	csrs	CSR_STATUS, t1
> +	csrs	CSR_VCSR, x0
> +	vsetvli t1, x0, e8, m8, ta, ma
> +	vmv.v.i v0, 0
> +	vmv.v.i v8, 0
> +	vmv.v.i v16, 0
> +	vmv.v.i v24, 0
> +	/* note that the caller must clear SR_VS */
> +#endif /* CONFIG_VECTOR */
> +
>  .Lreset_regs_done:

Not sure how much they go together, but the #ifdef CONFIG_FPU block above
your new VECTOR block also jumps to the same .Lreset_regs_done, so with
the patch as is the vector-reset block is never reached in the !FPU case.

So maybe making them independent of each other might prevent issues
down the roead.


