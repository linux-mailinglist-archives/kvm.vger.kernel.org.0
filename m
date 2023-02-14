Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5FC69595C
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjBNGna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBNGn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:43:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66470EB79
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF167CE1F26
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 06:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C861C433EF;
        Tue, 14 Feb 2023 06:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676357003;
        bh=lq4W396FO+Q3Y2AX/3T1BrpLEZNbnz8ryv/Vmo361xs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VFCrbqIcsVnE5fUmOjjPNWrBldBZeePy7P0Yz2LYjVZLjKBVTrDsCZh1/XFBLHg4p
         1Ql4Wq/1+ylkQvHEV8goFJdarOX0C5r35G6keDIyrMlrMAc/L1IAs67fxxL9f48tMn
         FhkWOJa5RTDP9ctWVydEKvnWaGujrrLUGyO0NlpMd0Iig5Wlvt1TftfCkO9l/vPfvP
         AWyBvPlM1EbpIj2xVDK4hRIyp1FP7ZSp/fOQY7Y4mXWcAvqQUqRFoEcFT7O15RfuGW
         J4sKbRe1zbx+jgHj4n7HKpJ+Ibsb7lZL3CbPWBEbRLpg0h01IwKSg7aX8qY7ZqvdVi
         PxKV6c9orGOYQ==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Vineet Gupta <vineetg@rivosinc.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context
 in the first-use trap
In-Reply-To: <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us>
 <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
Date:   Tue, 14 Feb 2023 07:43:21 +0100
Message-ID: <87sff8ags6.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineet Gupta <vineetg@rivosinc.com> writes:

> On 2/7/23 06:36, Bj=C3=B6rn T=C3=B6pel wrote:
>>> +bool rvv_first_use_handler(struct pt_regs *regs)
>>> +{
>>> +	__user u32 *epc =3D (u32 *)regs->epc;
>>> +	u32 tval =3D (u32)regs->badaddr;
>>> +
>>> +	/* If V has been enabled then it is not the first-use trap */
>>> +	if (vstate_query(regs))
>>> +		return false;
>>> +	/* Get the instruction */
>>> +	if (!tval) {
>>> +		if (__get_user(tval, epc))
>>> +			return false;
>>> +	}
>>> +	/* Filter out non-V instructions */
>>> +	if (!insn_is_vector(tval))
>>> +		return false;
>>> +	/* Sanity check. datap should be null by the time of the first-use tr=
ap */
>>> +	WARN_ON(current->thread.vstate.datap);
>>> +	/*
>>> +	 * Now we sure that this is a V instruction. And it executes in the
>>> +	 * context where VS has been off. So, try to allocate the user's V
>>> +	 * context and resume execution.
>>> +	 */
>>> +	if (rvv_thread_zalloc()) {
>>> +		force_sig(SIGKILL);
>>> +		return true;
>>> +	}
>> Should the altstack size be taken into consideration, like x86 does in
>> validate_sigaltstack() (see __xstate_request_perm()).
>
> For a preexisting alternate stack ?

Yes.

> Otherwise there is no=20
> "configuration" like x86 to cross-check against and V fault implies=20
> large'ish signal stack.
> See below as well.
>
>> Related; Would it make sense to implement sigaltstack_size_valid() for
>> riscv, analogous to x86?
>
> Indeed we need to do that for the case where alt stack is being setup,=20
> *after* V fault-on-first use.
> But how to handle an existing alt stack which might not be big enough to=
=20
> handle V state ?

What I'm getting at is a stricter check at the time of fault
(SIGILL/enable V) handling. If the *existing* altstack is not big
enough, kill the process -- similar to the rvv_thread_zalloc() handling
above.

So, two changes:

1. Disallow V-enablement if the existing altstack does not fit a V-sized
   frame.
2. Sanitize altstack changes when V is enabled.

Other than the altstack handling, I think the series is a good state! It
would great if we could see a v14 land in -next...


Bj=C3=B6rn
