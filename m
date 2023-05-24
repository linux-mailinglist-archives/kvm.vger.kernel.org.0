Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEFC70EA6F
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 02:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbjEXAtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 20:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEXAtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 20:49:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D920C2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:01 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ae557aaf1dso2864705ad.2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1684889341; x=1687481341;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z8Q5fkMlc8by1KD06IeJCEUWvcQpGPxJr1LDoSieL3c=;
        b=jdZu5vla5Uo2tOVGR8Asn7q4X5WTXomqzaOebqQ75ZPg+ssH7vMffZ6PEhyxIz1C3Q
         Rfk9hNWbw8peUbG38Mog307milNRPMsGuQqL3Ub+xnNE0u8H5/XJXZimy4JFtOq2GZ+m
         a3xGAyd/ByUMDGQ/sX9ScJgHrKmzGEeymBTa5Pe6zw7+YOQWPsPxyrIYDyTUOwt65IBB
         HsLBPZsxMvxHCiFQnbGaWm1lZ/56D6SrNHLKOwXTSYPMqOnBo81U/LBqGlQ13QOeZeuZ
         ++sbcujNISe0nVvF8xshsGIqXVXDjEOmqNc1yz6e/T2Dmi1itqcdCz8peSjjUhANcA5K
         pj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684889341; x=1687481341;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8Q5fkMlc8by1KD06IeJCEUWvcQpGPxJr1LDoSieL3c=;
        b=Wq3vTnWXVHNen57A/Gl+FGY6BpWlHSuOiryjmA9yM4rPoqrKqmDI1HChncpQHf+d9o
         KfPDVszJDbW9lgJ5XVHR85n6h2hiGGrXVlbR3G/PY29yptvfJYR1MPPRBx/9mnWnlYDU
         cqIc0ehyKQhgJGdXAsP6yw+Q2CZhUiiJ0USS+EYkq2KQUh7tXm/SjlKWXvYymBVes46A
         SGRg76dh9oZ0by36oItbrHE2tHEBQUHHHtEFhkxhzcqvBkLE7CeCp5NqhU0jtb/Eu2Wb
         O1zy2IXaX6TOZC+wHTJ8dX6GNEkVhCtEUW7mEoqpPo+nTj7XZ2+4zOZQpq/2Ap++uk5R
         lEwQ==
X-Gm-Message-State: AC+VfDyuoun5ZY1EmWwvOM4EnEnsWbTXg3lVv6YXHgl/KQi0QQg+tfre
        08QYz/N4AXDfKwc2Rqp5vV+8hA==
X-Google-Smtp-Source: ACHHUZ6Nd4bmihlt6wCOZDvRQj8f70TyLJ4oD3F6CpGsBs1OFkQEoAdWm2PYlWgcTqINU/EchycIZQ==
X-Received: by 2002:a17:903:41cf:b0:1ae:2e0e:dfcf with SMTP id u15-20020a17090341cf00b001ae2e0edfcfmr16923403ple.2.1684889340781;
        Tue, 23 May 2023 17:49:00 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902b28200b0019ee045a2b3sm7328709plr.308.2023.05.23.17.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 17:49:00 -0700 (PDT)
Date:   Tue, 23 May 2023 17:49:00 -0700 (PDT)
X-Google-Original-Date: Tue, 23 May 2023 17:26:55 PDT (-0700)
Subject:     Re: [PATCH -next v20 09/26] riscv: Introduce struct/helpers to save/restore per-task Vector state
In-Reply-To: <20230518161949.11203-10-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu, guoren@kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-ea968659-052d-429b-861e-1f616337f802@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 09:19:32 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> Add vector state context struct to be added later in thread_struct. And
> prepare low-level helper functions to save/restore vector contexts.
>
> This include Vector Regfile and CSRs holding dynamic configuration state
> (vstart, vl, vtype, vcsr). The Vec Register width could be implementation
> defined, but same for all processes, so that is saved separately.
>
> This is not yet wired into final thread_struct - will be done when
> __switch_to actually starts doing this in later patches.
>
> Given the variable (and potentially large) size of regfile, they are
> saved in dynamically allocated memory, pointed to by datap pointer in
> __riscv_v_ext_state.
>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Guo Ren <guoren@kernel.org>
> Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/include/asm/vector.h      | 95 ++++++++++++++++++++++++++++
>  arch/riscv/include/uapi/asm/ptrace.h | 17 +++++
>  2 files changed, 112 insertions(+)
>
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
> index df3b5caecc87..3c29f4eb552a 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -11,8 +11,10 @@
>
>  #ifdef CONFIG_RISCV_ISA_V
>
> +#include <linux/stringify.h>
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
> +#include <asm/asm.h>
>
>  extern unsigned long riscv_v_vsize;
>  int riscv_v_setup_vsize(void);
> @@ -22,6 +24,26 @@ static __always_inline bool has_vector(void)
>  	return riscv_has_extension_unlikely(RISCV_ISA_EXT_v);
>  }
>
> +static inline void __riscv_v_vstate_clean(struct pt_regs *regs)
> +{
> +	regs->status = (regs->status & ~SR_VS) | SR_VS_CLEAN;
> +}
> +
> +static inline void riscv_v_vstate_off(struct pt_regs *regs)
> +{
> +	regs->status = (regs->status & ~SR_VS) | SR_VS_OFF;
> +}
> +
> +static inline void riscv_v_vstate_on(struct pt_regs *regs)
> +{
> +	regs->status = (regs->status & ~SR_VS) | SR_VS_INITIAL;
> +}
> +
> +static inline bool riscv_v_vstate_query(struct pt_regs *regs)
> +{
> +	return (regs->status & SR_VS) != 0;
> +}
> +
>  static __always_inline void riscv_v_enable(void)
>  {
>  	csr_set(CSR_SSTATUS, SR_VS);
> @@ -32,13 +54,86 @@ static __always_inline void riscv_v_disable(void)
>  	csr_clear(CSR_SSTATUS, SR_VS);
>  }
>
> +static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state *dest)
> +{
> +	asm volatile (
> +		"csrr	%0, " __stringify(CSR_VSTART) "\n\t"
> +		"csrr	%1, " __stringify(CSR_VTYPE) "\n\t"
> +		"csrr	%2, " __stringify(CSR_VL) "\n\t"
> +		"csrr	%3, " __stringify(CSR_VCSR) "\n\t"
> +		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl),
> +		  "=r" (dest->vcsr) : :);
> +}
> +
> +static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_state *src)
> +{
> +	asm volatile (
> +		".option push\n\t"
> +		".option arch, +v\n\t"
> +		"vsetvl	 x0, %2, %1\n\t"
> +		".option pop\n\t"
> +		"csrw	" __stringify(CSR_VSTART) ", %0\n\t"
> +		"csrw	" __stringify(CSR_VCSR) ", %3\n\t"
> +		: : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
> +		    "r" (src->vcsr) :);
> +}
> +
> +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to,
> +					 void *datap)
> +{
> +	unsigned long vl;
> +
> +	riscv_v_enable();
> +	__vstate_csr_save(save_to);
> +	asm volatile (
> +		".option push\n\t"
> +		".option arch, +v\n\t"
> +		"vsetvli	%0, x0, e8, m8, ta, ma\n\t"
> +		"vse8.v		v0, (%1)\n\t"
> +		"add		%1, %1, %0\n\t"
> +		"vse8.v		v8, (%1)\n\t"
> +		"add		%1, %1, %0\n\t"
> +		"vse8.v		v16, (%1)\n\t"
> +		"add		%1, %1, %0\n\t"
> +		"vse8.v		v24, (%1)\n\t"
> +		".option pop\n\t"
> +		: "=&r" (vl) : "r" (datap) : "memory");
> +	riscv_v_disable();
> +}
> +
> +static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_from,
> +					    void *datap)
> +{
> +	unsigned long vl;
> +
> +	riscv_v_enable();
> +	asm volatile (
> +		".option push\n\t"
> +		".option arch, +v\n\t"
> +		"vsetvli	%0, x0, e8, m8, ta, ma\n\t"
> +		"vle8.v		v0, (%1)\n\t"
> +		"add		%1, %1, %0\n\t"
> +		"vle8.v		v8, (%1)\n\t"
> +		"add		%1, %1, %0\n\t"
> +		"vle8.v		v16, (%1)\n\t"
> +		"add		%1, %1, %0\n\t"
> +		"vle8.v		v24, (%1)\n\t"
> +		".option pop\n\t"
> +		: "=&r" (vl) : "r" (datap) : "memory");
> +	__vstate_csr_restore(restore_from);
> +	riscv_v_disable();
> +}
> +
>  #else /* ! CONFIG_RISCV_ISA_V  */
>
>  struct pt_regs;
>
>  static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
>  static __always_inline bool has_vector(void) { return false; }
> +static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
>  #define riscv_v_vsize (0)
> +#define riscv_v_vstate_off(regs)		do {} while (0)
> +#define riscv_v_vstate_on(regs)			do {} while (0)
>
>  #endif /* CONFIG_RISCV_ISA_V */
>
> diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
> index 882547f6bd5c..586786d023c4 100644
> --- a/arch/riscv/include/uapi/asm/ptrace.h
> +++ b/arch/riscv/include/uapi/asm/ptrace.h
> @@ -77,6 +77,23 @@ union __riscv_fp_state {
>  	struct __riscv_q_ext_state q;
>  };
>
> +struct __riscv_v_ext_state {
> +	unsigned long vstart;
> +	unsigned long vl;
> +	unsigned long vtype;
> +	unsigned long vcsr;
> +	void *datap;
> +	/*
> +	 * In signal handler, datap will be set a correct user stack offset
> +	 * and vector registers will be copied to the address of datap
> +	 * pointer.
> +	 *
> +	 * In ptrace syscall, datap will be set to zero and the vector
> +	 * registers will be copied to the address right after this
> +	 * structure.
> +	 */
> +};
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* _UAPI_ASM_RISCV_PTRACE_H */

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
