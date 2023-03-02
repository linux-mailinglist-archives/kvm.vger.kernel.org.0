Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A866A827F
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjCBMm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCBMm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:42:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27275FF6
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 04:42:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA38AB81218
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 12:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D88CC433EF;
        Thu,  2 Mar 2023 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677760972;
        bh=EEgAdGgMKd7fneB3MrCFQZbHHomNu4DMTJf0w8KbB54=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=K5fUrpjcyUHtyAF6mb07D67mmGoLTz8OwcbL8DE2io5oGi8HLXmeDqhcS0tgglb/u
         kfyicUcUs1bLXzhauAaKvzXglb79FFAEHAZ+hlFejF3q129Eprr+GZUBjtBuBeVdjn
         +MhWVpLwhZpu0eArl7VXllfVwWeB52l7DuW9FiOcfB+IgJVTxa3RoN3anM6S+j0E1+
         avT+eFA9J4u9GL9GQp1XUMcazHj1GZ0uaD4i/rRNv/YU2N4L6Rk9PTisROse2jq0Wl
         NqslYHlKBGwqq2uOy1FIgXUbiR0dL1wRvPHi5Yq3//9FE9IS899zPjSPGhqdTzasVM
         JsYMMjUvTqcag==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko@sntech.de>, Guo Ren <guoren@kernel.org>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn@rivosinc.com>, Wenting Zhang <zephray@outlook.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v14 13/19] riscv: signal: Add sigcontext
 save/restore for vector
In-Reply-To: <20230224170118.16766-14-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-14-andy.chiu@sifive.com>
Date:   Thu, 02 Mar 2023 13:42:49 +0100
Message-ID: <87bklb494m.fsf@all.your.base.are.belong.to.us>
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

> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index 376d2827e736..b9b3e03b2564 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -262,6 +262,8 @@ static void __init parse_dtb(void)
>  #endif
>  }
>=20=20
> +extern void __init init_rt_signal_env(void);
> +
>  void __init setup_arch(char **cmdline_p)
>  {
>  	parse_dtb();
> @@ -299,6 +301,7 @@ void __init setup_arch(char **cmdline_p)
>=20=20
>  	riscv_init_cbom_blocksize();
>  	riscv_fill_hwcap();
> +	init_rt_signal_env();
>  	apply_boot_alternatives();
>  	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
>  	    riscv_isa_extension_available(NULL, ZICBOM))
> diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
> index 0c8be5404a73..76c0480ee4cd 100644
> --- a/arch/riscv/kernel/signal.c
> +++ b/arch/riscv/kernel/signal.c
> @@ -18,9 +18,11 @@
>  #include <asm/signal.h>
>  #include <asm/signal32.h>
>  #include <asm/switch_to.h>
> +#include <asm/vector.h>
>  #include <asm/csr.h>
>=20=20
>  extern u32 __user_rt_sigreturn[2];
> +static size_t riscv_v_sc_size;

__ro_after_init?

>=20=20
>  #define DEBUG_SIG 0
>=20=20
> @@ -62,34 +64,159 @@ static long save_fp_state(struct pt_regs *regs,
>  #define restore_fp_state(task, regs) (0)
>  #endif
>=20=20
> +#ifdef CONFIG_RISCV_ISA_V
> +
> +static long save_v_state(struct pt_regs *regs, void **sc_vec)
> +{
> +	/*
> +	 * Put __sc_riscv_v_state to the user's signal context space pointed
> +	 * by sc_vec and the datap point the address right
> +	 * after __sc_riscv_v_state.
> +	 */
> +	struct __riscv_ctx_hdr __user *hdr =3D (struct __riscv_ctx_hdr *)(*sc_v=
ec);
                                             ^^^
Remove unneccery cast and parenthesis.

> +	struct __sc_riscv_v_state __user *state =3D (struct __sc_riscv_v_state =
*)(hdr + 1);
> +	void __user *datap =3D state + 1;
> +	long err;
> +
> +	/* datap is designed to be 16 byte aligned for better performance */
> +	WARN_ON(unlikely(!IS_ALIGNED((unsigned long)datap, 16)));
> +
> +	riscv_v_vstate_save(current, regs);
> +	/* Copy everything of vstate but datap. */
> +	err =3D __copy_to_user(&state->v_state, &current->thread.vstate,
> +			     offsetof(struct __riscv_v_ext_state, datap));
> +	/* Copy the pointer datap itself. */
> +	err |=3D __put_user(datap, &state->v_state.datap);
> +	/* Copy the whole vector content to user space datap. */
> +	err |=3D __copy_to_user(datap, current->thread.vstate.datap, riscv_v_vs=
ize);
> +	/* Copy magic to the user space after saving  all vector conetext */
> +	err |=3D __put_user(RISCV_V_MAGIC, &hdr->magic);
> +	err |=3D __put_user(riscv_v_sc_size, &hdr->size);
> +	if (unlikely(err))
> +		return err;
> +
> +	/* Only progress the sv_vec if everything has done successfully  */
> +	*sc_vec +=3D riscv_v_sc_size;
> +	return 0;
> +}
> +
> +/*
> + * Restore Vector extension context from the user's signal frame. This f=
unction
> + * assumes a valid extension header. So magic and size checking must be =
done by
> + * the caller.
> + */
> +static long __restore_v_state(struct pt_regs *regs, void *sc_vec)
> +{
> +	long err;
> +	struct __sc_riscv_v_state __user *state =3D (struct __sc_riscv_v_state =
*)(sc_vec);
                                                  ^^^
Remove unneccery cast and parenthesis.

> +	void __user *datap;
> +
> +	/* Copy everything of __sc_riscv_v_state except datap. */
> +	err =3D __copy_from_user(&current->thread.vstate, &state->v_state,
> +			       offsetof(struct __riscv_v_ext_state, datap));
> +	if (unlikely(err))
> +		return err;
> +
> +	/* Copy the pointer datap itself. */
> +	err =3D __get_user(datap, &state->v_state.datap);
> +	if (unlikely(err))
> +		return err;
> +	/*
> +	 * Copy the whole vector content from user space datap. Use
> +	 * copy_from_user to prevent information leak.
> +	 */
> +	err =3D copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsi=
ze);
> +	if (unlikely(err))
> +		return err;
> +
> +	riscv_v_vstate_restore(current, regs);
> +
> +	return err;
> +}
> +#else
> +#define save_v_state(task, regs) (0)
> +#define __restore_v_state(task, regs) (0)
> +#endif
> +
>  static long restore_sigcontext(struct pt_regs *regs,
>  	struct sigcontext __user *sc)

This whole function; return in favor of goto, and remove the labels at
the bottom.

>  {
> +	void *sc_ext_ptr =3D &sc->sc_extdesc.hdr;
> +	__u32 rsvd;
>  	long err;
> -	size_t i;
> -
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
>  	if (unlikely(err))
> -		return err;
> +		goto done;
>  	/* Restore the floating-point state. */
>  	if (has_fpu()) {
>  		err =3D restore_fp_state(regs, &sc->sc_fpregs);
>  		if (unlikely(err))
> -			return err;
> +			goto done;
>  	}
>=20=20
> -	/* We support no other extension state at this time. */
> -	for (i =3D 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++) {
> -		u32 value;
> -
> -		err =3D __get_user(value, &sc->sc_fpregs.q.reserved[i]);
> -		if (unlikely(err))
> +	/* Check the reserved word before extensions parsing */
> +	err =3D __get_user(rsvd, &sc->sc_extdesc.reserved);
> +	if (unlikely(err))
> +		goto done;
> +	if (unlikely(rsvd))
> +		goto invalid;
> +
> +	while (1 && !err) {
> +		__u32 magic, size;
> +		struct __riscv_ctx_hdr *head =3D (struct __riscv_ctx_hdr *)sc_ext_ptr;

Remove unneccery cast.

> +
> +		err |=3D __get_user(magic, &head->magic);
> +		err |=3D __get_user(size, &head->size);
> +		if (err)
> +			goto done;
> +
> +		sc_ext_ptr +=3D sizeof(struct __riscv_ctx_hdr);

sizeof(*head);

> +		switch (magic) {
> +		case END_MAGIC:
> +			if (size !=3D END_HDR_SIZE)
> +				goto invalid;
> +			goto done;
> +		case RISCV_V_MAGIC:
> +			if (!has_vector() || !riscv_v_vstate_query(regs))
> +				goto invalid;
> +			if (size !=3D riscv_v_sc_size)
> +				goto invalid;
> +			err =3D __restore_v_state(regs, sc_ext_ptr);
>  			break;
> -		if (value !=3D 0)
> -			return -EINVAL;
> +		default:
> +			goto invalid;
> +		}
> +		sc_ext_ptr =3D ((void *)(head) + size);

Unneccery parenthesis. "(void *)head + size" is enough

>  	}
> +done:
>  	return err;
> +invalid:
> +	return -EINVAL;
> +}
> +
> +static size_t cal_rt_frame_size(void)
> +{
> +	struct rt_sigframe __user *frame;
> +	size_t frame_size;
> +	size_t total_context_size =3D 0;
> +
> +	frame_size =3D sizeof(*frame);
> +
> +	if (has_vector() && riscv_v_vstate_query(task_pt_regs(current)))
> +		total_context_size +=3D riscv_v_sc_size;
> +	/*
> +	 * Preserved a __riscv_ctx_hdr for END signal context header if an
> +	 * extension uses __riscv_extra_ext_header
> +	 */
> +	if (total_context_size)
> +		total_context_size +=3D sizeof(struct __riscv_ctx_hdr);
> +
> +	frame_size +=3D (total_context_size);

Remove unneccery parenthesis.

> +
> +	frame_size =3D round_up(frame_size, 16);
> +	return frame_size;
> +
>  }
>=20=20
>  SYSCALL_DEFINE0(rt_sigreturn)
> @@ -98,13 +225,14 @@ SYSCALL_DEFINE0(rt_sigreturn)
>  	struct rt_sigframe __user *frame;
>  	struct task_struct *task;
>  	sigset_t set;
> +	size_t frame_size =3D cal_rt_frame_size();
>=20=20
>  	/* Always make any pending restarted system calls return -EINTR */
>  	current->restart_block.fn =3D do_no_restart_syscall;
>=20=20
>  	frame =3D (struct rt_sigframe __user *)regs->sp;
>=20=20
> -	if (!access_ok(frame, sizeof(*frame)))
> +	if (!access_ok(frame, frame_size))
>  		goto badframe;
>=20=20
>  	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
> @@ -138,17 +266,22 @@ static long setup_sigcontext(struct rt_sigframe __u=
ser *frame,
>  	struct pt_regs *regs)
>  {
>  	struct sigcontext __user *sc =3D &frame->uc.uc_mcontext;
> +	void *sc_ext_ptr =3D &sc->sc_extdesc.hdr;

All the casts and parenthesis makes it hard to read. Change to
	struct __riscv_ctx_hdr *sc_ext_ptr =3D &sc->sc_extdesc.hdr;


>  	long err;
> -	size_t i;
>=20=20
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_to_user(&sc->sc_regs, regs, sizeof(sc->sc_regs));
>  	/* Save the floating-point state. */
>  	if (has_fpu())
>  		err |=3D save_fp_state(regs, &sc->sc_fpregs);
> -	/* We support no other extension state at this time. */
> -	for (i =3D 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++)
> -		err |=3D __put_user(0, &sc->sc_fpregs.q.reserved[i]);
> +	/* Save the vector state. */
> +	if (has_vector() && riscv_v_vstate_query(regs))
> +		err |=3D save_v_state(regs, &sc_ext_ptr);

...and cast to (void **) after the change above...

> +	/* Write zero to fp-reserved space and check it on restore_sigcontext */
> +	err |=3D __put_user(0, &sc->sc_extdesc.reserved);
> +	/* And put END __riscv_ctx_hdr at the end. */
> +	err |=3D __put_user(END_MAGIC, &((struct __riscv_ctx_hdr *)sc_ext_ptr)-=
>magic);
> +	err |=3D __put_user(END_HDR_SIZE, &((struct __riscv_ctx_hdr *)sc_ext_pt=
r)->size);

...and change to:
	err |=3D __put_user(END_MAGIC, &sc_ext_ptr->magic);
	err |=3D __put_user(END_HDR_SIZE, &sc_ext_ptr->size);


>  	return err;
>  }
>=20=20
> @@ -172,6 +305,13 @@ static inline void __user *get_sigframe(struct ksign=
al *ksig,
>  	/* Align the stack frame. */
>  	sp &=3D ~0xfUL;
>=20=20
> +	/*
> +	 * Fail if the size of the altstack is not large enough for the
> +	 * sigframe construction.
> +	 */
> +	if (current->sas_ss_size && sp < current->sas_ss_sp)
> +		return (void __user __force *)(-1UL);

Nit: Remove unneccery parenthesis.


Bj=C3=B6rn
