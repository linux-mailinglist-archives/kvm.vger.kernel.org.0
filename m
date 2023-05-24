Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C970EA70
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 02:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbjEXAtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 20:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbjEXAtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 20:49:05 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF76ECD
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:02 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d57cd373fso113878b3a.1
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1684889342; x=1687481342;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZEexR3f7ga3u1+ZUo8U5i5PeRTDCeVutJWe5pd3c2E=;
        b=fxkvw7v1NA8MqRBMj4197nhuNSOgBQ5scBtnezy4uhWfvsVI5rLFMlEP/nyj5B/TeB
         KMAW2V7y9dbYpyyEe59Nrgs3HT0llDOB54WBjelftCgIu8tGPpmjeOxry8OcwJDIXRDh
         8gQ8B78VNDWIYHzuvc2LTd+I4mTQvqXwCPKqCyEXUAohEAvduAUIS4zMHciE45pyvn3N
         R4gBLN9lDLLj3CgPKf7k6LGvHF/pxGvAaL8UmxFHLVXFCBK5FkbIzddtFNot3mKip8zL
         OO/eN7WSBTkpBlss1c1AbzBka201NXTo1gi/g6TCvpbyqpFfMGncZkrGOoIea/pZrx3i
         QkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684889342; x=1687481342;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZEexR3f7ga3u1+ZUo8U5i5PeRTDCeVutJWe5pd3c2E=;
        b=BUETM+CbwnPAX3x6rppyeufqUuEGLegqe7XMuSNSReq8QqNMYpNwANn8LXoFM4BvQn
         yI7ulmBW87IDVrwW2SADUhL9qjLy+KGWQYycnznMb16LIsf+3wFAC8Umu4jDn0PCWk38
         SVwVaMQNH9v6W+cXUMPNNPHgLVmnIvvfCJnX86dSUhTwMUvFBRUXOys3JHA95ToW0Ivv
         Oo+kN9BWLBiti0J8Oc3yOdxu8D8bXYqVNQYj6da9cErGIzNvhgCsSjPD8jOn8Db7U4ZF
         PCNxUwdRC+ywZ4oy5GBDGYYObAGmFkYDkEPvV90CkYB/du9B8KFy2KGdenQAoZcOieCi
         reUQ==
X-Gm-Message-State: AC+VfDwTOWoKfgHJCG2egeKdHVp1hnL3Xy6uuR+MPqnecPafU27FVdE6
        b0mPkAvY3ucvMGq7XpklP/FVxA==
X-Google-Smtp-Source: ACHHUZ4q7vQl/o5VQeHvY+nl2amBxqxF3QxVOIcwyYvRIMFppsrxcLGTWRAhXwdjKdngH9wqdtI/tQ==
X-Received: by 2002:a05:6a20:9189:b0:106:9266:4448 with SMTP id v9-20020a056a20918900b0010692664448mr18159819pzd.16.1684889342075;
        Tue, 23 May 2023 17:49:02 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id q13-20020a62e10d000000b0064d59e194c8sm5214690pfh.115.2023.05.23.17.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 17:49:01 -0700 (PDT)
Date:   Tue, 23 May 2023 17:49:01 -0700 (PDT)
X-Google-Original-Date: Tue, 23 May 2023 17:31:48 PDT (-0700)
Subject:     Re: [PATCH -next v20 12/26] riscv: Add ptrace vector support
In-Reply-To: <20230518161949.11203-13-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, oleg@redhat.com, ebiederm@xmission.com,
        keescook@chromium.org, heiko.stuebner@vrull.eu,
        Conor Dooley <conor.dooley@microchip.com>,
        chenhuacai@kernel.org, frankja@linux.ibm.com,
        zhangqing@loongson.cn, eb@emlix.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com, Arnd Bergmann <arnd@arndb.de>
Message-ID: <mhng-f92fa24d-c8bd-4794-819d-7563c1193430@palmer-ri-x1c9a>
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

On Thu, 18 May 2023 09:19:35 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> This patch adds ptrace support for riscv vector. The vector registers will
> be saved in datap pointer of __riscv_v_ext_state. This pointer will be set
> right after the __riscv_v_ext_state data structure then it will be put in
> ubuf for ptrace system call to get or set. It will check if the datap got
> from ubuf is set to the correct address or not when the ptrace system call
> is trying to set the vector registers.
>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> ---
> Changelog V18:
>  - Use sizeof(vstate->datap) instead of sizeof(void*) (Eike)
> ---
>  arch/riscv/include/uapi/asm/ptrace.h |  7 +++
>  arch/riscv/kernel/ptrace.c           | 70 ++++++++++++++++++++++++++++
>  include/uapi/linux/elf.h             |  1 +
>  3 files changed, 78 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
> index 586786d023c4..e8d127ec5cf7 100644
> --- a/arch/riscv/include/uapi/asm/ptrace.h
> +++ b/arch/riscv/include/uapi/asm/ptrace.h
> @@ -94,6 +94,13 @@ struct __riscv_v_ext_state {
>  	 */
>  };
>
> +/*
> + * According to spec: The number of bits in a single vector register,
> + * VLEN >= ELEN, which must be a power of 2, and must be no greater than
> + * 2^16 = 65536bits = 8192bytes
> + */
> +#define RISCV_MAX_VLENB (8192)
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* _UAPI_ASM_RISCV_PTRACE_H */
> diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> index 23c48b14a0e7..1d572cf3140f 100644
> --- a/arch/riscv/kernel/ptrace.c
> +++ b/arch/riscv/kernel/ptrace.c
> @@ -7,6 +7,7 @@
>   * Copied from arch/tile/kernel/ptrace.c
>   */
>
> +#include <asm/vector.h>
>  #include <asm/ptrace.h>
>  #include <asm/syscall.h>
>  #include <asm/thread_info.h>
> @@ -24,6 +25,9 @@ enum riscv_regset {
>  #ifdef CONFIG_FPU
>  	REGSET_F,
>  #endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	REGSET_V,
> +#endif
>  };
>
>  static int riscv_gpr_get(struct task_struct *target,
> @@ -80,6 +84,61 @@ static int riscv_fpr_set(struct task_struct *target,
>  }
>  #endif
>
> +#ifdef CONFIG_RISCV_ISA_V
> +static int riscv_vr_get(struct task_struct *target,
> +			const struct user_regset *regset,
> +			struct membuf to)
> +{
> +	struct __riscv_v_ext_state *vstate = &target->thread.vstate;
> +
> +	if (!riscv_v_vstate_query(task_pt_regs(target)))
> +		return -EINVAL;
> +
> +	/*
> +	 * Ensure the vector registers have been saved to the memory before
> +	 * copying them to membuf.
> +	 */
> +	if (target == current)
> +		riscv_v_vstate_save(current, task_pt_regs(current));
> +
> +	/* Copy vector header from vstate. */
> +	membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state, datap));
> +	membuf_zero(&to, sizeof(vstate->datap));
> +
> +	/* Copy all the vector registers from vstate. */
> +	return membuf_write(&to, vstate->datap, riscv_v_vsize);
> +}
> +
> +static int riscv_vr_set(struct task_struct *target,
> +			const struct user_regset *regset,
> +			unsigned int pos, unsigned int count,
> +			const void *kbuf, const void __user *ubuf)
> +{
> +	int ret, size;
> +	struct __riscv_v_ext_state *vstate = &target->thread.vstate;
> +
> +	if (!riscv_v_vstate_query(task_pt_regs(target)))
> +		return -EINVAL;
> +
> +	/* Copy rest of the vstate except datap */
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, vstate, 0,
> +				 offsetof(struct __riscv_v_ext_state, datap));
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* Skip copy datap. */
> +	size = sizeof(vstate->datap);
> +	count -= size;
> +	ubuf += size;
> +
> +	/* Copy all the vector registers. */
> +	pos = 0;
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, vstate->datap,
> +				 0, riscv_v_vsize);
> +	return ret;
> +}
> +#endif
> +
>  static const struct user_regset riscv_user_regset[] = {
>  	[REGSET_X] = {
>  		.core_note_type = NT_PRSTATUS,
> @@ -99,6 +158,17 @@ static const struct user_regset riscv_user_regset[] = {
>  		.set = riscv_fpr_set,
>  	},
>  #endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	[REGSET_V] = {
> +		.core_note_type = NT_RISCV_VECTOR,
> +		.align = 16,
> +		.n = ((32 * RISCV_MAX_VLENB) +
> +		      sizeof(struct __riscv_v_ext_state)) / sizeof(__u32),
> +		.size = sizeof(__u32),
> +		.regset_get = riscv_vr_get,
> +		.set = riscv_vr_set,
> +	},
> +#endif
>  };
>
>  static const struct user_regset_view riscv_user_native_view = {
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index ac3da855fb19..7d8d9ae36615 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -440,6 +440,7 @@ typedef struct elf64_shdr {
>  #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
>  #define NT_MIPS_FP_MODE	0x801		/* MIPS floating-point mode */
>  #define NT_MIPS_MSA	0x802		/* MIPS SIMD registers */
> +#define NT_RISCV_VECTOR	0x900		/* RISC-V vector registers */

IIUC we're OK to define note types here, as they're all sub-types of the 
"LINUX" note as per the comment?  I'm not entirely sure, though.

Maybe Arnd knows?

>  #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
>  #define NT_LOONGARCH_CSR	0xa01	/* LoongArch control and status registers */
>  #define NT_LOONGARCH_LSX	0xa02	/* LoongArch Loongson SIMD Extension registers */

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com> # aside from NT_RISCV_VECTOR

Thanks!
