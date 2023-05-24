Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD47570F887
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 16:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbjEXOVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbjEXOV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 10:21:28 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8114E12E
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 07:21:25 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f4e01eb845so6450671cf.2
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 07:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bluespec-com.20221208.gappssmtp.com; s=20221208; t=1684938084; x=1687530084;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/V+docf4fzDFmrJfaslFi/OmmvL2qnjhhaEwsdcnckw=;
        b=vmSiFJbp6qWKZXxvGz2dQ9+yxEuJt1LyzoKTGIe6iVNd+YRXV7bjxDBAqV+3HpxutV
         gvnhk0Y4KoX5ggLnVaGOrDt78r2E4sLvQ6/w1wftibN2AjpwV00CF5OZQ5zcTbwv0vb9
         SqxyKa/bnSjXnoSjmPC67JzXhGgxoDDzbgfx7GtavwFzqOd9OGpRKxpRjDB38IfLfnrf
         fewezplfcoKbUJjB1uIwpUoasRcOHezvJNiNM+TjdJEBGkRvTcmLRwOaociXwDlf9itL
         hcITyPiCSVrvCRHLFY1ORdCQ3etTjvR++fZd+BAu5fSV9VD3NcTePIbQNdYfRAd4VxTd
         NsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684938084; x=1687530084;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/V+docf4fzDFmrJfaslFi/OmmvL2qnjhhaEwsdcnckw=;
        b=ARovjSEBYmJMk+Go5TIv3AU3SGzE31eO4L2OaLFmMKHOQom2wCrGWukyR1Bi7JxPhJ
         R+bDSea4jLcsm0cWZulf1r1rd3WjyIWbeeUFipCe7WEq6+jxjS7DYbqo7opF/b13xmfk
         YQ+Um7BjSjTmjYB8aaUGE589OvnlmbjaqFMQdixuTYSoEuUrB4VUEJDAf5J8ts2Pz+cY
         g+a7i9pklQehTE5r3H0YnJzNfb0MqztheLhbNxenzv28rRbI8qh13qO69YMVE2gbs5zy
         6ULt1HKrUa1ndeinH5MDzKC+ouU18Dojl1XNhbz1HmtjkWkrzdOShwLFDtPEUGVIiB+n
         Isrg==
X-Gm-Message-State: AC+VfDw2r4yzhMzTdp25fsebSeKXjifhyrm/xAuaDMMsAtK356l/7WyU
        KW3Aa6eStIANajF2d4axKXAW
X-Google-Smtp-Source: ACHHUZ6B563mCO+6UR/zlVT0GBYx2Bq2YFQNqwsQ+CnQwLMpqG9gyks9YQfM2uRYXkIgxEfs4aK+Ew==
X-Received: by 2002:a05:622a:10e:b0:3e6:71d6:5d5d with SMTP id u14-20020a05622a010e00b003e671d65d5dmr26590177qtw.1.1684938084476;
        Wed, 24 May 2023 07:21:24 -0700 (PDT)
Received: from bruce.bluespec.com ([181.214.94.126])
        by smtp.gmail.com with ESMTPSA id ch13-20020a05622a40cd00b003ef573e24cfsm2551977qtb.12.2023.05.24.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 07:21:24 -0700 (PDT)
Date:   Wed, 24 May 2023 10:21:21 -0400
From:   Darius Rad <darius@bluespec.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     andy.chiu@sifive.com, linux-riscv@lists.infradead.org,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, ajones@ventanamicro.com,
        heiko.stuebner@vrull.eu, Conor Dooley <conor.dooley@microchip.com>,
        prabhakar.mahadev-lad.rj@bp.renesas.com, liaochang1@huawei.com,
        jszhang@kernel.org, vincent.chen@sifive.com, guoren@kernel.org,
        Bjorn Topel <bjorn@rivosinc.com>, mnissler@rivosinc.com
Subject: Re: [PATCH -next v20 11/26] riscv: Allocate user's vector context in
 the first-use trap
Message-ID: <ZG4dYQdHqc2ipoZe@bruce.bluespec.com>
Mail-Followup-To: Palmer Dabbelt <palmer@dabbelt.com>, andy.chiu@sifive.com,
        linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        ajones@ventanamicro.com, heiko.stuebner@vrull.eu,
        Conor Dooley <conor.dooley@microchip.com>,
        prabhakar.mahadev-lad.rj@bp.renesas.com, liaochang1@huawei.com,
        jszhang@kernel.org, vincent.chen@sifive.com, guoren@kernel.org,
        Bjorn Topel <bjorn@rivosinc.com>, mnissler@rivosinc.com
References: <20230518161949.11203-12-andy.chiu@sifive.com>
 <mhng-6b818098-ee0c-407f-83eb-75db4ea4ff89@palmer-ri-x1c9a>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <mhng-6b818098-ee0c-407f-83eb-75db4ea4ff89@palmer-ri-x1c9a>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 05:49:04PM -0700, Palmer Dabbelt wrote:
> On Thu, 18 May 2023 09:19:34 PDT (-0700), andy.chiu@sifive.com wrote:
> > Vector unit is disabled by default for all user processes. Thus, a
> > process will take a trap (illegal instruction) into kernel at the first
> > time when it uses Vector. Only after then, the kernel allocates V
> > context and starts take care of the context for that user process.
> > 
> > Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> > Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@linaro.org
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > ---
> > Hey Heiko and Conor, I am dropping you guys' A-b, T-b, and R-b because I
> > added a check in riscv_v_first_use_handler().
> > 
> > Changelog v20:
> >  - move has_vector() into vector.c for better code readibility
> >  - check elf_hwcap in the first-use trap because it might get turned off
> >    if cores have different VLENs.
> > 
> > Changelog v18:
> >  - Add blank lines (Heiko)
> >  - Return immediately in insn_is_vector() if an insn matches (Heiko)
> > ---
> >  arch/riscv/include/asm/insn.h   | 29 ++++++++++
> >  arch/riscv/include/asm/vector.h |  2 +
> >  arch/riscv/kernel/traps.c       | 26 ++++++++-
> >  arch/riscv/kernel/vector.c      | 95 +++++++++++++++++++++++++++++++++
> >  4 files changed, 150 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> > index 8d5c84f2d5ef..4e1505cef8aa 100644
> > --- a/arch/riscv/include/asm/insn.h
> > +++ b/arch/riscv/include/asm/insn.h
> > @@ -137,6 +137,26 @@
> >  #define RVG_OPCODE_JALR		0x67
> >  #define RVG_OPCODE_JAL		0x6f
> >  #define RVG_OPCODE_SYSTEM	0x73
> > +#define RVG_SYSTEM_CSR_OFF	20
> > +#define RVG_SYSTEM_CSR_MASK	GENMASK(12, 0)
> > +
> > +/* parts of opcode for RVF, RVD and RVQ */
> > +#define RVFDQ_FL_FS_WIDTH_OFF	12
> > +#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(3, 0)
> > +#define RVFDQ_FL_FS_WIDTH_W	2
> > +#define RVFDQ_FL_FS_WIDTH_D	3
> > +#define RVFDQ_LS_FS_WIDTH_Q	4
> > +#define RVFDQ_OPCODE_FL		0x07
> > +#define RVFDQ_OPCODE_FS		0x27
> > +
> > +/* parts of opcode for RVV */
> > +#define RVV_OPCODE_VECTOR	0x57
> > +#define RVV_VL_VS_WIDTH_8	0
> > +#define RVV_VL_VS_WIDTH_16	5
> > +#define RVV_VL_VS_WIDTH_32	6
> > +#define RVV_VL_VS_WIDTH_64	7
> > +#define RVV_OPCODE_VL		RVFDQ_OPCODE_FL
> > +#define RVV_OPCODE_VS		RVFDQ_OPCODE_FS
> > 
> >  /* parts of opcode for RVC*/
> >  #define RVC_OPCODE_C0		0x0
> > @@ -304,6 +324,15 @@ static __always_inline bool riscv_insn_is_branch(u32 code)
> >  	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OFF) | \
> >  	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
> > 
> > +#define RVG_EXTRACT_SYSTEM_CSR(x) \
> > +	({typeof(x) x_ = (x); RV_X(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MASK); })
> > +
> > +#define RVFDQ_EXTRACT_FL_FS_WIDTH(x) \
> > +	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
> > +				   RVFDQ_FL_FS_WIDTH_MASK); })
> > +
> > +#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
> > +
> >  /*
> >   * Get the immediate from a J-type instruction.
> >   *
> > diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
> > index ce6a75e9cf62..8e56da67b5cf 100644
> > --- a/arch/riscv/include/asm/vector.h
> > +++ b/arch/riscv/include/asm/vector.h
> > @@ -21,6 +21,7 @@
> > 
> >  extern unsigned long riscv_v_vsize;
> >  int riscv_v_setup_vsize(void);
> > +bool riscv_v_first_use_handler(struct pt_regs *regs);
> > 
> >  static __always_inline bool has_vector(void)
> >  {
> > @@ -165,6 +166,7 @@ struct pt_regs;
> > 
> >  static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
> >  static __always_inline bool has_vector(void) { return false; }
> > +static inline bool riscv_v_first_use_handler(struct pt_regs *regs) { return false; }
> >  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
> >  #define riscv_v_vsize (0)
> >  #define riscv_v_vstate_save(task, regs)		do {} while (0)
> > diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> > index 8c258b78c925..05ffdcd1424e 100644
> > --- a/arch/riscv/kernel/traps.c
> > +++ b/arch/riscv/kernel/traps.c
> > @@ -26,6 +26,7 @@
> >  #include <asm/ptrace.h>
> >  #include <asm/syscall.h>
> >  #include <asm/thread_info.h>
> > +#include <asm/vector.h>
> > 
> >  int show_unhandled_signals = 1;
> > 
> > @@ -145,8 +146,29 @@ DO_ERROR_INFO(do_trap_insn_misaligned,
> >  	SIGBUS, BUS_ADRALN, "instruction address misaligned");
> >  DO_ERROR_INFO(do_trap_insn_fault,
> >  	SIGSEGV, SEGV_ACCERR, "instruction access fault");
> > -DO_ERROR_INFO(do_trap_insn_illegal,
> > -	SIGILL, ILL_ILLOPC, "illegal instruction");
> > +
> > +asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_regs *regs)
> > +{
> > +	if (user_mode(regs)) {
> > +		irqentry_enter_from_user_mode(regs);
> > +
> > +		local_irq_enable();
> > +
> > +		if (!riscv_v_first_use_handler(regs))
> > +			do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
> > +				      "Oops - illegal instruction");
> > +
> > +		irqentry_exit_to_user_mode(regs);
> > +	} else {
> > +		irqentry_state_t state = irqentry_nmi_enter(regs);
> > +
> > +		do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
> > +			      "Oops - illegal instruction");
> > +
> > +		irqentry_nmi_exit(regs, state);
> > +	}
> > +}
> > +
> >  DO_ERROR_INFO(do_trap_load_fault,
> >  	SIGSEGV, SEGV_ACCERR, "load access fault");
> >  #ifndef CONFIG_RISCV_M_MODE
> > diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> > index 120f1ce9abf9..0080798e8d2e 100644
> > --- a/arch/riscv/kernel/vector.c
> > +++ b/arch/riscv/kernel/vector.c
> > @@ -4,10 +4,19 @@
> >   * Author: Andy Chiu <andy.chiu@sifive.com>
> >   */
> >  #include <linux/export.h>
> > +#include <linux/sched/signal.h>
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +#include <linux/sched.h>
> > +#include <linux/uaccess.h>
> > 
> > +#include <asm/thread_info.h>
> > +#include <asm/processor.h>
> > +#include <asm/insn.h>
> >  #include <asm/vector.h>
> >  #include <asm/csr.h>
> >  #include <asm/elf.h>
> > +#include <asm/ptrace.h>
> >  #include <asm/bug.h>
> > 
> >  unsigned long riscv_v_vsize __read_mostly;
> > @@ -34,3 +43,89 @@ int riscv_v_setup_vsize(void)
> > 
> >  	return 0;
> >  }
> > +
> > +static bool insn_is_vector(u32 insn_buf)
> > +{
> > +	u32 opcode = insn_buf & __INSN_OPCODE_MASK;
> > +	u32 width, csr;
> > +
> > +	/*
> > +	 * All V-related instructions, including CSR operations are 4-Byte. So,
> > +	 * do not handle if the instruction length is not 4-Byte.
> > +	 */
> > +	if (unlikely(GET_INSN_LENGTH(insn_buf) != 4))
> > +		return false;
> > +
> > +	switch (opcode) {
> > +	case RVV_OPCODE_VECTOR:
> > +		return true;
> > +	case RVV_OPCODE_VL:
> > +	case RVV_OPCODE_VS:
> > +		width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> > +		if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
> > +		    width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
> > +			return true;
> > +
> > +		break;
> > +	case RVG_OPCODE_SYSTEM:
> > +		csr = RVG_EXTRACT_SYSTEM_CSR(insn_buf);
> > +		if ((csr >= CSR_VSTART && csr <= CSR_VCSR) ||
> > +		    (csr >= CSR_VL && csr <= CSR_VLENB))
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static int riscv_v_thread_zalloc(void)
> > +{
> > +	void *datap;
> > +
> > +	datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
> > +	if (!datap)
> > +		return -ENOMEM;
> > +
> > +	current->thread.vstate.datap = datap;
> > +	memset(&current->thread.vstate, 0, offsetof(struct __riscv_v_ext_state,
> > +						    datap));
> > +	return 0;
> > +}
> > +
> > +bool riscv_v_first_use_handler(struct pt_regs *regs)
> > +{
> > +	u32 __user *epc = (u32 __user *)regs->epc;
> > +	u32 insn = (u32)regs->badaddr;
> > +
> > +	/* Do not handle if V is not supported, or disabled */
> > +	if (!has_vector() || !(elf_hwcap & COMPAT_HWCAP_ISA_V))
> > +		return false;
> > +
> > +	/* If V has been enabled then it is not the first-use trap */
> > +	if (riscv_v_vstate_query(regs))
> > +		return false;
> > +
> > +	/* Get the instruction */
> > +	if (!insn) {
> > +		if (__get_user(insn, epc))
> > +			return false;
> > +	}
> > +
> > +	/* Filter out non-V instructions */
> > +	if (!insn_is_vector(insn))
> > +		return false;
> > +
> > +	/* Sanity check. datap should be null by the time of the first-use trap */
> > +	WARN_ON(current->thread.vstate.datap);
> > +
> > +	/*
> > +	 * Now we sure that this is a V instruction. And it executes in the
> > +	 * context where VS has been off. So, try to allocate the user's V
> > +	 * context and resume execution.
> > +	 */
> > +	if (riscv_v_thread_zalloc()) {
> > +		force_sig(SIGKILL);
> 
> Is SIGKILL too strong?  Maybe we just SIGILL here?  Maybe killing the
> process is the right way to go, though: if we're that out of memory
> something's getting killed, it might as well be whatever's about to get
> confused by vectors disappearing.
> 

SIGILL seems misleading; it's not the instruction that is at fault.  Maybe
SIGSEGV (or SIGBUS), since that's generally what you get if you assume an
allocation succeeds when it doesn't, as that is effectively what this
patchset does by not providing an adequate way to return allocation
failures to the application.

> > +		return true;
> > +	}
> > +	riscv_v_vstate_on(regs);
> > +	return true;
> > +}
> 
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linu
