Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0D72C8D8
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 16:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjFLOml convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 12 Jun 2023 10:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjFLOmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 10:42:37 -0400
X-Greylist: delayed 403 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Jun 2023 07:42:33 PDT
Received: from sypressi2.dnainternet.net (sypressi2.dnainternet.net [83.102.40.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B86D9E
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 07:42:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sypressi2.dnainternet.net (Postfix) with ESMTP id 285EF14B87;
        Mon, 12 Jun 2023 17:35:42 +0300 (EEST)
X-Virus-Scanned: DNA Internet at dnainternet.net
X-Spam-Score: 0.02
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_FAIL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
Received: from sypressi2.dnainternet.net ([83.102.40.154])
        by localhost (sypressi2.dnainternet.net [127.0.0.1]) (DNA Internet, port 10041)
        with ESMTP id goenKB_nCimi; Mon, 12 Jun 2023 17:35:27 +0300 (EEST)
Received: from kirsikkapuu2.dnainternet.net (kirsikkapuu2.dnainternet.net [83.102.40.52])
        by sypressi2.dnainternet.net (Postfix) with ESMTP id B3EEC14C0A;
        Mon, 12 Jun 2023 17:33:40 +0300 (EEST)
Received: from basile.localnet (87-92-194-88.rev.dnainternet.fi [87.92.194.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by kirsikkapuu2.dnainternet.net (Postfix) with ESMTPS id 723807E;
        Mon, 12 Jun 2023 17:32:45 +0300 (EEST)
From:   =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andy Chiu <andy.chiu@sifive.com>
Subject: Re: [PATCH -next v21 09/27] riscv: Introduce struct/helpers to save/restore
 per-task Vector state
Date:   Mon, 12 Jun 2023 17:32:40 +0300
Message-ID: <5271851.rBgCu3BfMA@basile.remlab.net>
Organization: Remlab
In-Reply-To: <20230605110724.21391-10-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-10-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le maanantaina 5. kesäkuuta 2023, 14.07.06 EEST Andy Chiu a écrit :
> @@ -32,13 +54,86 @@ static __always_inline void riscv_v_disable(void)
>  	csr_clear(CSR_SSTATUS, SR_VS);
>  }
> 
> +static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state
> *dest) +{
> +	asm volatile (
> +		"csrr	%0, " __stringify(CSR_VSTART) "\n\t"
> +		"csrr	%1, " __stringify(CSR_VTYPE) "\n\t"
> +		"csrr	%2, " __stringify(CSR_VL) "\n\t"
> +		"csrr	%3, " __stringify(CSR_VCSR) "\n\t"
> +		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest-
>vl),
> +		  "=r" (dest->vcsr) : :);
> +}
> +
> +static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_state
> *src) +{
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
> +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state
> *save_to, +					 void *datap)
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

Shouldn't this use `vs8r.v` rather than `vse8.v`, and do away with `vsetvli`? 
This seems like a textbook use case for the whole-register store instruction, 
no?

> +
> +static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state
> *restore_from, +					    void 
*datap)
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

Ditto but `vl8r.v`.

>  #else /* ! CONFIG_RISCV_ISA_V  */
> 
>  struct pt_regs;
> 
>  static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
>  static __always_inline bool has_vector(void) { return false; }
> +static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return
> false; } #define riscv_v_vsize (0)
> +#define riscv_v_vstate_off(regs)		do {} while (0)
> +#define riscv_v_vstate_on(regs)			do {} while (0)
> 
>  #endif /* CONFIG_RISCV_ISA_V */
> 


-- 
Реми Дёни-Курмон
http://www.remlab.net/



