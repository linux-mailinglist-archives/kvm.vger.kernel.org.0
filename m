Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6996A80B1
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCBLHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCBLH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:07:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47990DBDB
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E487CB81218
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF579C4339C;
        Thu,  2 Mar 2023 11:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677755244;
        bh=GcaMLRcyjV/Llc8qunx3V1WotxdaFI1BmthFPmyxbuU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Yteq9SeP3biOM7woYe5b2LNAyPhrns/cPUflYq+xpTGTL38QxKPgQj2CFRbI4tapq
         4lwycV6NGKsv9UXi8EI+Z77ppjie0keILEm4hv5mhtntBOLfd0QW1tprY2hEaBpQFa
         wXrWeSW3gV0S3MjqHVM+tRokRw3yKluzen1p3+oHa5eVrrNA3axysCjFmgcl2hMBn2
         lOl7w3HODVFFbCHHU8rghxACu7nj1CkY8Ln1vlJnAzMuJHTYlGoK4WxFUI9fGmeCFO
         o64CGn9pGtE51u4RYP3zjBffm647VMPlV1QVhaxA/rLlZBiwF8O1PsoXKtOKITyP80
         YDBECQKB5oSRA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        Jisheng Zhang <jszhang@kernel.org>,
        Nick Knight <nick.knight@sifive.com>, vineetg@rivosinc.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        greentime.hu@sifive.com, Dmitry Vyukov <dvyukov@google.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH -next v14 09/19] riscv: Add task switch support for vector
In-Reply-To: <20230224170118.16766-10-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-10-andy.chiu@sifive.com>
Date:   Thu, 02 Mar 2023 12:07:21 +0100
Message-ID: <87v8jj4djq.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/as=
m/thread_info.h
> index f704c8dd57e0..9e28c0199030 100644
> --- a/arch/riscv/include/asm/thread_info.h
> +++ b/arch/riscv/include/asm/thread_info.h
> @@ -80,6 +80,9 @@ struct thread_info {
>  	.preempt_count	=3D INIT_PREEMPT_COUNT,	\
>  }
>=20=20
> +void arch_release_task_struct(struct task_struct *tsk);
> +int arch_dup_task_struct(struct task_struct *dst, struct task_struct *sr=
c);
> +
>  #endif /* !__ASSEMBLY__ */
>=20=20
>  /*
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 9c025f2efdc3..830f9d3c356b 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -10,6 +10,9 @@
>=20=20
>  #ifdef CONFIG_RISCV_ISA_V
>=20=20
> +#include <linux/sched.h>
> +#include <linux/sched/task_stack.h>
> +#include <asm/ptrace.h>
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
>  #include <asm/asm.h>
> @@ -75,7 +78,8 @@ static __always_inline void __vstate_csr_restore(struct=
 __riscv_v_ext_state *src
>  		    "r" (src->vcsr) :);
>  }
>=20=20
> -static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *sav=
e_to, void *datap)
> +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *sav=
e_to,
> +					 void *datap)

Please avoid code churn like this...=20

>  {
>  	riscv_v_enable();
>  	__vstate_csr_save(save_to);
> @@ -93,7 +97,7 @@ static inline void __riscv_v_vstate_save(struct __riscv=
_v_ext_state *save_to, vo
>  }
>=20=20
>  static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *=
restore_from,
> -				    void *datap)
> +					    void *datap)

...and this.

>  {
>  	riscv_v_enable();
>  	asm volatile (
> @@ -110,6 +114,38 @@ static inline void __riscv_v_vstate_restore(struct _=
_riscv_v_ext_state *restore_
>  	riscv_v_disable();
>  }
>=20=20
> +static inline void riscv_v_vstate_save(struct task_struct *task,
> +				       struct pt_regs *regs)
> +{
> +	if ((regs->status & SR_VS) =3D=3D SR_VS_DIRTY) {
> +		struct __riscv_v_ext_state *vstate =3D &task->thread.vstate;
> +
> +		__riscv_v_vstate_save(vstate, vstate->datap);
> +		__riscv_v_vstate_clean(regs);
> +	}
> +}
> +
> +static inline void riscv_v_vstate_restore(struct task_struct *task,
> +					  struct pt_regs *regs)
> +{
> +	if ((regs->status & SR_VS) !=3D SR_VS_OFF) {
> +		struct __riscv_v_ext_state *vstate =3D &task->thread.vstate;
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
> +	regs =3D task_pt_regs(prev);
> +	riscv_v_vstate_save(prev, regs);
> +	riscv_v_vstate_restore(next, task_pt_regs(next));
> +}
> +
>  #else /* ! CONFIG_RISCV_ISA_V  */
>=20=20
>  struct pt_regs;
> @@ -118,6 +154,9 @@ static __always_inline bool has_vector(void) { return=
 false; }
>  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return f=
alse; }
>  #define riscv_v_vsize (0)
>  #define riscv_v_setup_vsize()	 do {} while (0)
> +#define riscv_v_vstate_save(task, regs)		do {} while (0)
> +#define riscv_v_vstate_restore(task, regs)	do {} while (0)
> +#define __switch_to_vector(__prev, __next)	do {} while (0)
>  #define riscv_v_vstate_off(regs)		do {} while (0)
>  #define riscv_v_vstate_on(regs)			do {} while (0)
>=20=20
> diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> index 8955f2432c2d..5e9506a32fbe 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -24,6 +24,7 @@
>  #include <asm/switch_to.h>
>  #include <asm/thread_info.h>
>  #include <asm/cpuidle.h>
> +#include <asm/vector.h>
>=20=20
>  register unsigned long gp_in_global __asm__("gp");
>=20=20
> @@ -148,12 +149,28 @@ void flush_thread(void)
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
> +	if (has_vector() && tsk->thread.vstate.datap)
                            ^^^^^^^^^^^^^^^^^^^^^^^^
No need to check for !NULL.


Bj=C3=B6rn
