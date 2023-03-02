Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F66A80E1
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjCBLOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCBLN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:13:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7A341B4D
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:13:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C86561584
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341EFC4339C;
        Thu,  2 Mar 2023 11:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677755582;
        bh=78a13yEpeA5Ldcu7G0xUrs9jQbTgpI/ZVXJxl6apOi0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=GHuu/UJ3xuwVyb2/hnG6qeRyFi+RH8qFcK805GHVNSg88LVuhf48SIZ55kUARSxBz
         TqeUjyxV8iEvvkkGywqVkEzY7AbeEfVJRKjrpNzIQ7Y4PwGaWIeV0/PWKoaUs8pNmu
         rORCVo3bA2M0KZMkk07U3Rj8In9+4I5GIc9ToDhcHT2M91CjxpkTK2CFYX7hgjdLPp
         zhsjuu/cH25uMnFzwpj+h+e6RLY2Q7qRsyuFcjrvNKnQ2hEVC2PvDrGsJIpXKfc1fB
         MTP/d61Ep7OwY+x2kwCrBbnghMk4hgQ/2ZS3BgmjQvu62nJTo3ytZAhnsqdMsoQl0v
         P5fjQTmlDJK1g==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v14 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
In-Reply-To: <20230224170118.16766-9-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-9-andy.chiu@sifive.com>
Date:   Thu, 02 Mar 2023 12:12:59 +0100
Message-ID: <87r0u74dac.fsf@all.your.base.are.belong.to.us>
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

Andy Chiu <andy.chiu@sifive.com> writes:

> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 692d3ee2d2d3..9c025f2efdc3 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -31,11 +54,72 @@ static __always_inline void riscv_v_disable(void)
>  	csr_clear(CSR_SSTATUS, SR_VS);
>  }
>=20=20
> +static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state=
 *dest)
> +{
> +	asm volatile (
> +		"csrr	%0, " CSR_STR(CSR_VSTART) "\n\t"
> +		"csrr	%1, " CSR_STR(CSR_VTYPE) "\n\t"
> +		"csrr	%2, " CSR_STR(CSR_VL) "\n\t"
> +		"csrr	%3, " CSR_STR(CSR_VCSR) "\n\t"
> +		: "=3Dr" (dest->vstart), "=3Dr" (dest->vtype), "=3Dr" (dest->vl),
> +		  "=3Dr" (dest->vcsr) : :);
> +}
> +
> +static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_st=
ate *src)
> +{
> +	asm volatile (
> +		"vsetvl	 x0, %2, %1\n\t"
> +		"csrw	" CSR_STR(CSR_VSTART) ", %0\n\t"
> +		"csrw	" CSR_STR(CSR_VCSR) ", %3\n\t"
> +		: : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
> +		    "r" (src->vcsr) :);
> +}
> +
> +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *sav=
e_to, void *datap)
> +{
> +	riscv_v_enable();
> +	__vstate_csr_save(save_to);
> +	asm volatile (
> +		"vsetvli	t4, x0, e8, m8, ta, ma\n\t"
> +		"vse8.v		v0, (%0)\n\t"
> +		"add		%0, %0, t4\n\t"
> +		"vse8.v		v8, (%0)\n\t"
> +		"add		%0, %0, t4\n\t"
> +		"vse8.v		v16, (%0)\n\t"
> +		"add		%0, %0, t4\n\t"
> +		"vse8.v		v24, (%0)\n\t"
> +		: : "r" (datap) : "t4", "memory");
> +	riscv_v_disable();
> +}
> +
> +static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *=
restore_from,
> +				    void *datap)
> +{
> +	riscv_v_enable();
> +	asm volatile (
> +		"vsetvli	t4, x0, e8, m8, ta, ma\n\t"
> +		"vle8.v		v0, (%0)\n\t"
> +		"add		%0, %0, t4\n\t"
> +		"vle8.v		v8, (%0)\n\t"
> +		"add		%0, %0, t4\n\t"
> +		"vle8.v		v16, (%0)\n\t"
> +		"add		%0, %0, t4\n\t"
> +		"vle8.v		v24, (%0)\n\t"
> +		: : "r" (datap) : "t4");

Nit/question: For both enable/disable; Any reason to clobber t4, instead
of using a scratch reg?

Bj=C3=B6rn
