Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CA570EA71
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 02:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbjEXAtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 20:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEXAtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 20:49:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58100E5
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae6b4c5a53so2267245ad.2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1684889344; x=1687481344;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfuUJPoB12ul6OtX86rLP2+2MSPS4xMkpzQj7DrmdNw=;
        b=0/LRr8x+10ThrzAqwS0166/SGo9u8Y9aJDR5yY8BmLpVgAWiwHD7LZi/deniivkGFp
         2r+OopobYV+6x7WIfvSxW+P9asoVxz1FkGfYbvSt8H7zOO9Fgu+yjt+Cc6uOqxpR9kok
         VW+pTyByNT34cQrvww046PxNOEcIcivlTPD2guB/y4KStOdQ1RbzwfMFyyqhMrZLb9x8
         wSBMa4K2Me+oG7m+eiMA8apET11ydzhVfctrvMhDCtsM/9k+MUFDiQYVJpjTD5yQ1KBr
         4FpJN/o1ezOzqjQQeMP+ceRSNM/8QXLxzZ50hMcnYx4pTGgQ5Pysfw/63rNdIVyeOj/P
         4Ahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684889344; x=1687481344;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfuUJPoB12ul6OtX86rLP2+2MSPS4xMkpzQj7DrmdNw=;
        b=UMYPC+77HZKUy73mVncTFd18MOSzpJLiCx2s0P859sPUyXoI8bUM2o1yBIE2W+ouE2
         JB0ChcLdSuHhP8cor/lEJI96tcpVluWvZ38/AhbKx+wzWsQ6ALLz4pCs2WwC/ImDyChT
         +ctPolq1FyJ7aWI+1Zm8NoolXPDoE77H8m0CRKZXIWuuls+OJcYxX43afGnG5Pf4okky
         uO4xghgRMtJP86Eg12PmCaidcB9loH03erIp8Jh95Vu7nq9DYROCSv1A7f+LRB1H0wzS
         CFpeUP7/nOy9Ss5XD+8v2GUx3DmRoxdwwgvJeUb19y8DHqGugqiZkyS9n4EuyCTWoHV7
         O0lA==
X-Gm-Message-State: AC+VfDwYhWy6sNeJ5EevLiOdO2gQwdeWssnc//B1PpKBsmjOqCmPsc/Y
        9DkxF1+eRou9Bo4Sj8kQSRVauQ==
X-Google-Smtp-Source: ACHHUZ4WnpbMqyRheHMzmPdDanrNFlfeOIxPmDrqDQij3TM0GqXuuRFGtqX9HL+u/3G9k5xUj1bjrQ==
X-Received: by 2002:a17:902:ab93:b0:1af:bba9:16e0 with SMTP id f19-20020a170902ab9300b001afbba916e0mr5647437plr.8.1684889343663;
        Tue, 23 May 2023 17:49:03 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id o15-20020a17090ac70f00b0025063e893c9sm128936pjt.55.2023.05.23.17.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 17:49:03 -0700 (PDT)
Date:   Tue, 23 May 2023 17:49:03 -0700 (PDT)
X-Google-Original-Date: Tue, 23 May 2023 17:42:47 PDT (-0700)
Subject:     Re: [PATCH -next v20 10/26] riscv: Add task switch support for vector
In-Reply-To: <20230518161949.11203-11-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        nick.knight@sifive.com, vincent.chen@sifive.com,
        ruinland.tsai@sifive.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, guoren@kernel.org, heiko.stuebner@vrull.eu,
        wangkefeng.wang@huawei.com, sunilvl@ventanamicro.com,
        Conor Dooley <conor.dooley@microchip.com>, jszhang@kernel.org,
        Bjorn Topel <bjorn@rivosinc.com>, peterz@infradead.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-52fef833-2cdd-40c7-ba64-ef12da3fa853@palmer-ri-x1c9a>
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

On Thu, 18 May 2023 09:19:33 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> This patch adds task switch support for vector. It also supports all
> lengths of vlen.
>
> Suggested-by: Andrew Waterman <andrew@sifive.com>
> Co-developed-by: Nick Knight <nick.knight@sifive.com>
> Signed-off-by: Nick Knight <nick.knight@sifive.com>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/include/asm/processor.h   |  1 +
>  arch/riscv/include/asm/switch_to.h   |  3 +++
>  arch/riscv/include/asm/thread_info.h |  3 +++
>  arch/riscv/include/asm/vector.h      | 38 ++++++++++++++++++++++++++++
>  arch/riscv/kernel/process.c          | 18 +++++++++++++
>  5 files changed, 63 insertions(+)
>
> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
> index 94a0590c6971..f0ddf691ac5e 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
> @@ -39,6 +39,7 @@ struct thread_struct {
>  	unsigned long s[12];	/* s[0]: frame pointer */
>  	struct __riscv_d_ext_state fstate;
>  	unsigned long bad_cause;
> +	struct __riscv_v_ext_state vstate;
>  };
>
>  /* Whitelist the fstate from the task_struct for hardened usercopy */
> diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
> index 4b96b13dee27..a727be723c56 100644
> --- a/arch/riscv/include/asm/switch_to.h
> +++ b/arch/riscv/include/asm/switch_to.h
> @@ -8,6 +8,7 @@
>
>  #include <linux/jump_label.h>
>  #include <linux/sched/task_stack.h>
> +#include <asm/vector.h>
>  #include <asm/hwcap.h>
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
> @@ -78,6 +79,8 @@ do {							\
>  	struct task_struct *__next = (next);		\
>  	if (has_fpu())					\
>  		__switch_to_fpu(__prev, __next);	\
> +	if (has_vector())					\
> +		__switch_to_vector(__prev, __next);	\
>  	((last) = __switch_to(__prev, __next));		\
>  } while (0)
>
> diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
> index e0d202134b44..97e6f65ec176 100644
> --- a/arch/riscv/include/asm/thread_info.h
> +++ b/arch/riscv/include/asm/thread_info.h
> @@ -81,6 +81,9 @@ struct thread_info {
>  	.preempt_count	= INIT_PREEMPT_COUNT,	\
>  }
>
> +void arch_release_task_struct(struct task_struct *tsk);
> +int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
> +
>  #endif /* !__ASSEMBLY__ */
>
>  /*
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
> index 3c29f4eb552a..ce6a75e9cf62 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -12,6 +12,9 @@
>  #ifdef CONFIG_RISCV_ISA_V
>
>  #include <linux/stringify.h>
> +#include <linux/sched.h>
> +#include <linux/sched/task_stack.h>
> +#include <asm/ptrace.h>
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
>  #include <asm/asm.h>
> @@ -124,6 +127,38 @@ static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_
>  	riscv_v_disable();
>  }
>
> +static inline void riscv_v_vstate_save(struct task_struct *task,
> +				       struct pt_regs *regs)
> +{
> +	if ((regs->status & SR_VS) == SR_VS_DIRTY) {
> +		struct __riscv_v_ext_state *vstate = &task->thread.vstate;
> +
> +		__riscv_v_vstate_save(vstate, vstate->datap);
> +		__riscv_v_vstate_clean(regs);
> +	}
> +}
> +
> +static inline void riscv_v_vstate_restore(struct task_struct *task,
> +					  struct pt_regs *regs)
> +{
> +	if ((regs->status & SR_VS) != SR_VS_OFF) {
> +		struct __riscv_v_ext_state *vstate = &task->thread.vstate;
> +
> +		__riscv_v_vstate_restore(vstate, vstate->datap);
> +		__riscv_v_vstate_clean(regs);
> +	}
> +}
> +
> +static inline void __switch_to_vector(struct task_struct *prev,
> +				      struct task_struct *next)
> +{
> +	struct pt_regs *regs;
> +
> +	regs = task_pt_regs(prev);
> +	riscv_v_vstate_save(prev, regs);
> +	riscv_v_vstate_restore(next, task_pt_regs(next));
> +}
> +
>  #else /* ! CONFIG_RISCV_ISA_V  */
>
>  struct pt_regs;
> @@ -132,6 +167,9 @@ static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
>  static __always_inline bool has_vector(void) { return false; }
>  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
>  #define riscv_v_vsize (0)
> +#define riscv_v_vstate_save(task, regs)		do {} while (0)
> +#define riscv_v_vstate_restore(task, regs)	do {} while (0)
> +#define __switch_to_vector(__prev, __next)	do {} while (0)
>  #define riscv_v_vstate_off(regs)		do {} while (0)
>  #define riscv_v_vstate_on(regs)			do {} while (0)
>
> diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> index e2a060066730..b7a10361ddc6 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -24,6 +24,7 @@
>  #include <asm/switch_to.h>
>  #include <asm/thread_info.h>
>  #include <asm/cpuidle.h>
> +#include <asm/vector.h>
>
>  register unsigned long gp_in_global __asm__("gp");
>
> @@ -146,12 +147,28 @@ void flush_thread(void)
>  	fstate_off(current, task_pt_regs(current));
>  	memset(&current->thread.fstate, 0, sizeof(current->thread.fstate));
>  #endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	/* Reset vector state */
> +	riscv_v_vstate_off(task_pt_regs(current));
> +	kfree(current->thread.vstate.datap);
> +	memset(&current->thread.vstate, 0, sizeof(struct __riscv_v_ext_state));
> +#endif
> +}
> +
> +void arch_release_task_struct(struct task_struct *tsk)
> +{
> +	/* Free the vector context of datap. */
> +	if (has_vector())
> +		kfree(tsk->thread.vstate.datap);
>  }
>
>  int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
>  {
>  	fstate_save(src, task_pt_regs(src));
>  	*dst = *src;
> +	/* clear entire V context, including datap for a new task */
> +	memset(&dst->thread.vstate, 0, sizeof(struct __riscv_v_ext_state));
> +
>  	return 0;
>  }
>
> @@ -184,6 +201,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
>  		p->thread.s[0] = 0;
>  	}
>  	p->thread.ra = (unsigned long)ret_from_fork;
> +	riscv_v_vstate_off(childregs);

When is V still on at this point?  If we got here via clone() (or any 
other syscall) it should be off already, so if we need to turn it off 
here then we must have arrived via something that's not a syscall.  I 
don't know what that case is, so it's not clear we can just throw away 
the V state.

>  	p->thread.sp = (unsigned long)childregs; /* kernel sp */
>  	return 0;
>  }
