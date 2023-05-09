Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE166FC4BF
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbjEILOo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 9 May 2023 07:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjEILOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:14:42 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FEA46AC
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 04:14:38 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pwLIa-0003Kj-NG; Tue, 09 May 2023 13:14:28 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Stefan Roesch <shr@devkernel.io>,
        Joey Gouly <joey.gouly@arm.com>,
        Jordy Zomer <jordyzomer@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH -next v19 20/24] riscv: Add prctl controls for userspace vector
 management
Date:   Tue, 09 May 2023 13:14:26 +0200
Message-ID: <2629220.BddDVKsqQX@diego>
In-Reply-To: <20230509103033.11285-21-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-21-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

need to poke this more, but one issue popped up at first compile.

Am Dienstag, 9. Mai 2023, 12:30:29 CEST schrieb Andy Chiu:
> This patch add two riscv-specific prctls, to allow usespace control the
> use of vector unit:
> 
>  * PR_RISCV_V_SET_CONTROL: control the permission to use Vector at next,
>    or all following execve for a thread. Turning off a thread's Vector
>    live is not possible since libraries may have registered ifunc that
>    may execute Vector instructions.
>  * PR_RISCV_V_GET_CONTROL: get the same permission setting for the
>    current thread, and the setting for following execve(s).
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>


> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 960a343799c6..16ccb35625a9 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -9,6 +9,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/uaccess.h>
> +#include <linux/prctl.h>
>  
>  #include <asm/thread_info.h>
>  #include <asm/processor.h>
> @@ -19,6 +20,8 @@
>  #include <asm/ptrace.h>
>  #include <asm/bug.h>
>  
> +static bool riscv_v_implicit_uacc = !IS_ENABLED(CONFIG_RISCV_V_DISABLE);
> +
>  unsigned long riscv_v_vsize __read_mostly;
>  EXPORT_SYMBOL_GPL(riscv_v_vsize);
>  
> @@ -91,11 +94,51 @@ static int riscv_v_thread_zalloc(void)
>  	return 0;
>  }
>  
> +#define VSTATE_CTRL_GET_CUR(x) ((x) & PR_RISCV_V_VSTATE_CTRL_CUR_MASK)
> +#define VSTATE_CTRL_GET_NEXT(x) (((x) & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK) >> 2)
> +#define VSTATE_CTRL_MAKE_NEXT(x) (((x) << 2) & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK)
> +#define VSTATE_CTRL_GET_INHERIT(x) (!!((x) & PR_RISCV_V_VSTATE_CTRL_INHERIT))
> +static inline int riscv_v_get_cur_ctrl(struct task_struct *tsk)
> +{
> +	return VSTATE_CTRL_GET_CUR(tsk->thread.vstate_ctrl);
> +}
> +
> +static inline int riscv_v_get_next_ctrl(struct task_struct *tsk)
> +{
> +	return VSTATE_CTRL_GET_NEXT(tsk->thread.vstate_ctrl);
> +}
> +
> +static inline bool riscv_v_test_ctrl_inherit(struct task_struct *tsk)
> +{
> +	return VSTATE_CTRL_GET_INHERIT(tsk->thread.vstate_ctrl);
> +}
> +
> +static inline void riscv_v_set_ctrl(struct task_struct *tsk, int cur, int nxt,
> +				    bool inherit)
> +{
> +	unsigned long ctrl;
> +
> +	ctrl = cur & PR_RISCV_V_VSTATE_CTRL_CUR_MASK;
> +	ctrl |= VSTATE_CTRL_MAKE_NEXT(nxt);
> +	if (inherit)
> +		ctrl |= PR_RISCV_V_VSTATE_CTRL_INHERIT;
> +	tsk->thread.vstate_ctrl = ctrl;
> +}
> +
> +bool riscv_v_user_allowed(void)
> +{
> +	return riscv_v_get_cur_ctrl(current) == PR_RISCV_V_VSTATE_CTRL_ON;
> +}

EXPORT_SYMBOL(riscv_v_user_allowed);

kvm is allowed to be built as module, so you could end up with:

ERROR: modpost: "riscv_v_user_allowed" [arch/riscv/kvm/kvm.ko] undefined!
make[2]: *** [../scripts/Makefile.modpost:136: Module.symvers] Fehler 1
make[1]: *** [/home/devel/hstuebner/00_git-repos/linux-riscv/Makefile:1978: modpost] Fehler 2
make[1]: Verzeichnis „/home/devel/hstuebner/00_git-repos/linux-riscv/_build-riscv64“ wird verlassen
make: *** [Makefile:226: __sub-make] Fehler 2


Heiko



