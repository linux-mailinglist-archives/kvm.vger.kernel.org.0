Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF28702BCF
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241403AbjEOLvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbjEOLtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:49:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB8140DB
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 04:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAAF7614CE
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 11:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3E2C433D2;
        Mon, 15 May 2023 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684150703;
        bh=rhCS5Qn2IGpUsX4JG5+/Jb6H+hQDl5nEdt6l7azXZmw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=H3oB0dadc88ULmPZhuO2HVFub+DmDWMN+D7jv3mGveCV9nkqrq5eh1C1oN1pVO1m2
         CDkkIq7lMa/pmXLGGGnLAxVeY9o+hZ5pg46WUMBz7LcDiyCzbT/NV8tkhhc1vOi4IF
         2ZDXlKsUt3m4DyJsxfDdYeyBD8xgUPbzvQrJ2j6RQMBGIAf6q+f3ucH121vbW3SE+L
         9t/+E3onbryz1C3NKlTUDttRcDS0fPYPeUlmi17b4tBI/rHdm6eDhwTx/OZG8j6+Yo
         jNJYJ3zQjbfTvr8hDcc6n/niXuAftyyXSdmZpYyW32yrUAPm7oW/o0KFmOPigySWpy
         JSjEq94cPcKoA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        David Hildenbrand <david@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>, greentime.hu@sifive.com,
        Albert Ou <aou@eecs.berkeley.edu>,
        Stefan Roesch <shr@devkernel.io>, vineetg@rivosinc.com,
        Josh Triplett <josh@joshtriplett.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Jordy Zomer <jordyzomer@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next v19 20/24] riscv: Add prctl controls for userspace
 vector management
In-Reply-To: <20230509103033.11285-21-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-21-andy.chiu@sifive.com>
Date:   Mon, 15 May 2023 13:38:20 +0200
Message-ID: <87ttwdhljn.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> This patch add two riscv-specific prctls, to allow usespace control the
> use of vector unit:

A more general question; I know that it's only x86 that implements
arch_prctl(), and that arm64 added the SVE prctl kernel/sys.c -- but is
there a reason not to have an arch-specific prctl for riscv?

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
> ---
>  arch/riscv/include/asm/processor.h |  13 ++++
>  arch/riscv/include/asm/vector.h    |   4 ++
>  arch/riscv/kernel/process.c        |   1 +
>  arch/riscv/kernel/vector.c         | 108 +++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c              |   2 +
>  include/uapi/linux/prctl.h         |  11 +++
>  kernel/sys.c                       |  12 ++++
>  7 files changed, 151 insertions(+)
>
> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/=
processor.h
> index 38ded8c5f207..79261da74cfd 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
> @@ -40,6 +40,7 @@ struct thread_struct {
>  	unsigned long s[12];	/* s[0]: frame pointer */
>  	struct __riscv_d_ext_state fstate;
>  	unsigned long bad_cause;
> +	unsigned long vstate_ctrl;
>  	struct __riscv_v_ext_state vstate;
>  };
>=20=20
> @@ -83,6 +84,18 @@ extern void riscv_fill_hwcap(void);
>  extern int arch_dup_task_struct(struct task_struct *dst, struct task_str=
uct *src);
>=20=20
>  extern unsigned long signal_minsigstksz __ro_after_init;
> +
> +#ifdef CONFIG_RISCV_ISA_V
> +/* Userspace interface for PR_RISCV_V_{SET,GET}_VS prctl()s: */
> +#define RISCV_V_SET_CONTROL(arg)	riscv_v_vstate_ctrl_set_current(arg)
> +#define RISCV_V_GET_CONTROL()		riscv_v_vstate_ctrl_get_current()
> +extern unsigned int riscv_v_vstate_ctrl_set_current(unsigned long arg);
> +extern unsigned int riscv_v_vstate_ctrl_get_current(void);
> +#else /* !CONFIG_RISCV_ISA_V */
> +#define RISCV_V_SET_CONTROL(arg)	(-EINVAL)
> +#define RISCV_V_GET_CONTROL()		(-EINVAL)

The else-clause is not needed (see my comment below for kernel/sys.c),
and can be removed.

> +#endif /* CONFIG_RISCV_ISA_V */
> +
>  #endif /* __ASSEMBLY__ */
>=20=20
>  #endif /* _ASM_RISCV_PROCESSOR_H */

> diff --git a/kernel/sys.c b/kernel/sys.c
> index 339fee3eff6a..412d2c126060 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -140,6 +140,12 @@
>  #ifndef GET_TAGGED_ADDR_CTRL
>  # define GET_TAGGED_ADDR_CTRL()		(-EINVAL)
>  #endif
> +#ifndef PR_RISCV_V_SET_CONTROL
> +# define PR_RISCV_V_SET_CONTROL(a)	(-EINVAL)
> +#endif
> +#ifndef PR_RISCV_V_GET_CONTROL
> +# define PR_RISCV_V_GET_CONTROL()	(-EINVAL)

Both SET/GET above should be RISCV_V_{SET,GET}_CONTROL (without the
prefix "PR_"), and nothing else, otherwise...

> +#endif
>=20=20
>  /*
>   * this is where the system-wide overflow UID and GID are defined, for
> @@ -2708,6 +2714,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long,=
 arg2, unsigned long, arg3,
>  		error =3D !!test_bit(MMF_VM_MERGE_ANY, &me->mm->flags);
>  		break;
>  #endif
> +	case PR_RISCV_V_SET_CONTROL:
> +		error =3D RISCV_V_SET_CONTROL(arg2);
> +		break;
> +	case PR_RISCV_V_GET_CONTROL:
> +		error =3D RISCV_V_GET_CONTROL();
> +		break;


...the case here will be weird. ;-)


Bj=C3=B6rn
