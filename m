Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C22E702BE4
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjEOLy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbjEOLye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:54:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ED45FDE
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 04:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF26D622FA
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 11:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4039C433EF;
        Mon, 15 May 2023 11:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684150979;
        bh=UwXA51cUOqHr2O0y8aV9fxZOLviMaAOAKrM3IfbYbAk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JH6UYS6CPmMu5V8OzIWZoTX4OoNLrR9CWkSPjGLPU7IkYVRVuJ+zArYgUm0bha0Z2
         ZA6TyxrHj4OJbjNKEuaNUoLLO383sGJwpTiqF4emj2nyp0KIvqggU77ckohaOTsMcX
         U5ycecIxk5EqvinxLa9Vj8fUJO4er4/mglb0GVHzXqK42rvTXuoOkA6064a8AL/jj2
         As2z82Q8DSePHOTqplTBFNzgZtN2lYjtdF4gWqd8a3m+PAGc+3z2O+/fI/8Ln79wbQ
         /NiV2MH3r1/cjkjE/NkmaF5zuuNfTYBT8KoqaMLvzEvqlU4PaHQF1AxxTGxlNlEKeV
         dK3lxORxuFBzw==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH -next v19 21/24] riscv: Add sysctl to set the default
 vector rule for new processes
In-Reply-To: <20230509103033.11285-22-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-22-andy.chiu@sifive.com>
Date:   Mon, 15 May 2023 13:42:56 +0200
Message-ID: <87mt25hlbz.fsf@all.your.base.are.belong.to.us>
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

> To support Vector extension, the series exports variable-length vector
> registers on the signal frame. However, this potentially breaks abi if
> processing vector registers is required in the signal handler for old
> binaries. For example, there is such need if user-level context switch
> is triggerred via signals[1].
>
> For this reason, it is best to leave a decision to distro maintainers,
> where the enablement of userspace Vector for new launching programs can
> be controlled. Developers may also need the switch to experiment with.
> The parameter is configurable through sysctl interface so a distro may
> turn off Vector early at init script if the break really happens in the
> wild.
>
> The switch will only take effects on new execve() calls once set. This
> will not effect existing processes that do not call execve(), nor
> processes which has been set with a non-default vstate_ctrl by making
> explicit PR_RISCV_V_SET_CONTROL prctl() calls.
>
> Link: https://lore.kernel.org/all/87cz4048rp.fsf@all.your.base.are.belong=
.to.us/
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
> ---
>  arch/riscv/kernel/vector.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 16ccb35625a9..1c4ac821e008 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -233,3 +233,34 @@ unsigned int riscv_v_vstate_ctrl_set_current(unsigne=
d long arg)
>=20=20
>  	return -EINVAL;
>  }
> +
> +#ifdef CONFIG_SYSCTL
> +
> +static struct ctl_table riscv_v_default_vstate_table[] =3D {
> +	{
> +		.procname	=3D "riscv_v_default_allow",
> +		.data		=3D &riscv_v_implicit_uacc,

Now that riscv_v_implicit_uacc can be changed via sysctl, I'd add
explicit READ_ONCE() to the accesses to make race checkers happy.


Bj=C3=B6rn
