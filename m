Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BAE6430BF
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiLEStP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 5 Dec 2022 13:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLEStO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:49:14 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED881B783;
        Mon,  5 Dec 2022 10:49:10 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1p2GWV-0005nw-0L; Mon, 05 Dec 2022 19:49:03 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Jisheng Zhang <jszhang@kernel.org>, Conor Dooley <conor@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Date:   Mon, 05 Dec 2022 19:49:01 +0100
Message-ID: <10190559.nUPlyArG6x@diego>
In-Reply-To: <Y446PdlUPGw5iB71@spud>
References: <20221204174632.3677-1-jszhang@kernel.org> <Y44Q/B6THtP38eyL@xhacker> <Y446PdlUPGw5iB71@spud>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Montag, 5. Dezember 2022, 19:36:45 CET schrieb Conor Dooley:
> Heiko, Jisheng,
> 
> On Mon, Dec 05, 2022 at 11:40:44PM +0800, Jisheng Zhang wrote:
> > On Mon, Dec 05, 2022 at 04:31:08PM +0100, Heiko Stübner wrote:
> > > Am Sonntag, 4. Dezember 2022, 18:46:20 CET schrieb Jisheng Zhang:
> > > > Alternatives live in a different section, so offsets used by jal
> > > > instruction will point to wrong locations after the patch got applied.
> > > > 
> > > > Similar to arm64, adjust the location to consider that offset.
> > > > 
> > > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > > ---
> > > >  arch/riscv/include/asm/alternative.h |  2 ++
> > > >  arch/riscv/kernel/alternative.c      | 38 ++++++++++++++++++++++++++++
> > > >  arch/riscv/kernel/cpufeature.c       |  3 +++
> > > >  3 files changed, 43 insertions(+)
> > > > 
> > > > diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
> > > > index c58ec3cc4bc3..33eae9541684 100644
> > > > --- a/arch/riscv/include/asm/alternative.h
> > > > +++ b/arch/riscv/include/asm/alternative.h
> > > > @@ -29,6 +29,8 @@ void apply_module_alternatives(void *start, size_t length);
> > > >  
> > > >  void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
> > > >  				      int patch_offset);
> > > > +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > > > +			       int patch_offset);
> > > >  
> > > >  struct alt_entry {
> > > >  	void *old_ptr;		 /* address of original instruciton or data  */
> > > > diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
> > > > index 292cc42dc3be..9d88375624b5 100644
> > > > --- a/arch/riscv/kernel/alternative.c
> > > > +++ b/arch/riscv/kernel/alternative.c
> > > > @@ -125,6 +125,44 @@ void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
> > > >  	}
> > > >  }
> > > >  
> > > > +#define to_jal_imm(value)						\
> > > > +	(((value & (RV_J_IMM_10_1_MASK << RV_J_IMM_10_1_OFF)) << RV_I_IMM_11_0_OPOFF) | \
> > > > +	 ((value & (RV_J_IMM_11_MASK << RV_J_IMM_11_OFF)) << RV_J_IMM_11_OPOFF) | \
> > > > +	 ((value & (RV_J_IMM_19_12_OPOFF << RV_J_IMM_19_12_OFF)) << RV_J_IMM_19_12_OPOFF) | \
> > > > +	 ((value & (1 << RV_J_IMM_SIGN_OFF)) << RV_J_IMM_SIGN_OPOFF))
> > > > +
> > > > +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > > > +			       int patch_offset)
> > > > +{
> > > 
> > > I think we might want to unfiy this into a common function like
> > > 
> > > 	riscv_alternative_fix_offsets(...)
> > > 
> > > so that we only run through the code block once
> > > 
> > > 	for (i = 0; i < num_instr; i++) {
> > > 		if (riscv_insn_is_auipc_jalr(inst1, inst2)) {
> > > 			riscv_alternative_fix_auipc_jalr(...)
> > > 			continue;
> > > 		}
> > > 
> > > 		if (riscv_insn_is_jal(inst)) {
> > > 			riscv_alternative_fix_jal(...)
> > > 			continue;
> > > 		}
> > > 	}
> > > 
> > > This would also remove the need from calling multiple functions
> > > after patching alternatives.
> > 
> > Yesterday, I also wanted to unify the two instruction fix into
> > one. But that would need to roll back the
> > riscv_alternative_fix_auipc_jalr() to your v1 version. And IMHO,
> > it's better if you can split the Zbb string optimizations series
> > into two: one for alternative improvements, another for Zbb. Then
> > we may get the alternative improvements and this inst extension
> > series merged in v6.2-rc1.
> 
> Heiko, perhaps you can correct me here:
> 
> Last Wednesday you & Palmer agreed that it was too late in the cycle to
> apply any of the stuff touching alternatives?
> If I do recall correctly, gives plenty of time to sort out any
> interdependent changes here.
> 
> Could easily be misremembering, wouldn't be the first time!

You slightly misremembered, but are still correct with the above ;-) .

I.e. what we talked about was stuff for fixes for 6.1-rc, were Palmers
wisely wanted to limit additions to really easy fixes for the remaining
last rc, to not upset any existing boards.

But you are still correct that we also shouldn't target the 6.2 merge window
anymore :-) .

We're after -rc8 now (which is in itself uncommon) and in his -rc7
announcement [0], Linus stated

"[...] the usual rule is that things that I get sent for the
merge window should have been all ready _before_ the merge window
opened. But with the merge window happening largely during the holiday
season, I'll just be enforcing that pretty strictly."

That means new stuff should be reviewed and in linux-next _way before_ the
merge window opens next weekend. Taking into account that people need
to review stuff (and maybe the series needing another round), I really don't
see this happening this week and everything else will get us shouted at
from atop a christmas tree ;-) .

That's the reason most maintainer-trees stop accepting stuff after -rc7


Heiko


[0] https://lkml.org/lkml/2022/11/27/278




