Return-Path: <kvm+bounces-24811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 332E295AF3E
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 09:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 284B61C22D51
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 07:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503B513C3CD;
	Thu, 22 Aug 2024 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RrD4219Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896BD42A9B
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 07:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724311672; cv=none; b=XV2LKZ6JyS30nokKYCXh2qGndshiZ94I9fQcEzbGCmp7LASHKbDneqOnV94pUbSqFHBqnLfzyGxo8Be9cy+A/VUa0BrtQdd8TpAXOnrUpOH8QfhH/uyDW35URMop/M8xvnb5trx05QMcDP/pU+6X8FPmw3vODwCxwkAd7HuGMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724311672; c=relaxed/simple;
	bh=IZgFMZ6L+Ohpy8sZ5uWvwfeZEogPsV9YYDbBK9bwQEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDgKtVSNrYXPzJsjsyD+yWPm2+xseQL7Q9r26Ql1ZAZ46Dl5T1WTJSDvDV+boORAMlCnA63tE0SuvSBqFdN7TT2Qtl49LQsLsZZSku1M42AmtNNjKMDzZH2/G6nb+YHMVdvzj5Zc6h6KZcxAuUEprpVflS68X6VKcrK/bygGHtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RrD4219Z; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724311670; x=1755847670;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IZgFMZ6L+Ohpy8sZ5uWvwfeZEogPsV9YYDbBK9bwQEM=;
  b=RrD4219Z9q5CZuXNSDFexBPzTgiXCf6YGSDo8T4+NHNj6+214yRFjsIl
   wWzW+Or6GG4MlDzlapvZlNKdldHSoF/feI8/DEwok++cwdmyi/zg3qZdX
   L+kWa2dsE1IxDP6+i4iAKlc4fYUcmIzMBw/7hWU5KdowgqVpwS2xhbrVx
   fjPn1KPY+2MBrbXRUrXTrt72QbcgLHD+DrtDdHTrK/C8QWWINW1d8GvRt
   H+GZOBQ+OsCKuh9CVu01RDIYti5gj7bglE8jm3wlcLxDtE9t90DPaLIZm
   ibtB70DffbWvJgFFbrvI4/KiBuabZWSzH5s+Vs7Q0q4tRdkH7g1UxXEqa
   g==;
X-CSE-ConnectionGUID: e0zCd+zfSZG/G8QwFtpNcg==
X-CSE-MsgGUID: J0c53UeDQSi1dsULKZywRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22862547"
X-IronPort-AV: E=Sophos;i="6.10,166,1719903600"; 
   d="scan'208";a="22862547"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 00:27:50 -0700
X-CSE-ConnectionGUID: E4EteH+kSr2LED96zx9qHQ==
X-CSE-MsgGUID: 6490Pw2aRjaVN1F5dqF1CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,166,1719903600"; 
   d="scan'208";a="61344441"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 00:27:48 -0700
Date: Thu, 22 Aug 2024 15:22:35 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, Keith Busch <kbusch@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Xu Liu <liuxu@meta.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
Message-ID: <ZsbnO17DWqpKHkmU@linux.bj.intel.com>
References: <20240820230431.3850991-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820230431.3850991-1-kbusch@meta.com>

On Tue, Aug 20, 2024 at 04:04:31PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Because people would like to use this (see "Link"), interpret the VEX
> prefix and emulate mov instrutions accordingly. The only avx
> instructions emulated here are the aligned and unaligned mov.
> Everything else will fail as before.
> 
> This is new territory for me, so any feedback is appreciated.
> 
> To test, I executed the following program against a qemu emulated pci
> device resource. Prior to this kernel patch, it would fail with
> 
>   traps: vmovdq[378] trap invalid opcode ip:4006b2 sp:7ffe2f5bb680 error:0 in vmovdq[6b2,400000+1000]
> 
> And is successful with this kernel patch.
> 
> Test program, vmovdq.c:
> 
>   #include <x86intrin.h>
>   #include <fcntl.h>
>   #include <stdint.h>
>   #include <stdio.h>
>   #include <string.h>
>   #include <unistd.h>
>   #include <sys/mman.h>
> 
>   static inline void read_avx_reg(__m256i *data)
>   {
>           asm("vmovdqu %%ymm0, %0" : "=m"(*data));
>   }
> 
>   static inline void write_avx_reg(const __m256i *data)
>   {
>           asm("vmovdqu %0, %%ymm0" : : "m"(*data));
>   }
> 
>   int main(int argc, char **argv)
>   {
>           __m256i s, *d;
>           void *map;
>           int fd;
> 
>           if(argc < 2) {
>                   fprintf(stderr, "usage: %s <resource-file>\n", argv[1]);
>                   return 1;
>           }
> 
>           fd = open(argv[1], O_RDWR | O_SYNC);
>           if (fd < 0) {
>                   fprintf(stderr, "failed to open %s\n", argv[1]);
>                   return 1;
>           }
> 
>           map = mmap(0, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>           if (map == MAP_FAILED) {
>                   fprintf(stderr, "failed to mmap %s\n", argv[1]);
>                   return 1;
> 
>           }
> 
>           memset(&s, 0xd0, sizeof(s));
>           d = (__m256i *)map;
> 
>           write_avx_reg(&s);
>           read_avx_reg(d);
> 
>           write_avx_reg(d);
>           read_avx_reg(&s);
> 
>           return 0;
>   }
> 
> Link: https://lore.kernel.org/kvm/BD108C42-0382-4B17-B601-434A4BD038E7@fb.com/T/
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Xu Liu <liuxu@meta.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  arch/x86/kvm/emulate.c     | 136 ++++++++++++++++++++++++++++++++-----
>  arch/x86/kvm/fpu.h         |  62 +++++++++++++++++
>  arch/x86/kvm/kvm_emulate.h |   6 +-
>  3 files changed, 187 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index e72aed25d7212..aad8da15b6b77 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1144,6 +1144,19 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
>  	else
>  		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
>  
> +	if (ctxt->d & Avx) {
> +		op->bytes = ctxt->op_bytes;
> +		if (op->bytes == 16) {
> +			op->type = OP_XMM;
> +			op->addr.xmm = reg;
> +			kvm_read_sse_reg(reg, &op->vec_val);
> +		} else {
> +			op->type = OP_YMM;
> +			op->addr.ymm = reg;
> +			kvm_read_avx_reg(reg, &op->vec_val2);
> +		}
> +		return;
> +	}
>  	if (ctxt->d & Sse) {
>  		op->type = OP_XMM;
>  		op->bytes = 16;
> @@ -1177,13 +1190,24 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  			struct operand *op)
>  {
>  	u8 sib;
> -	int index_reg, base_reg, scale;
> +	int index_reg = 0, base_reg = 0, scale = 0;
>  	int rc = X86EMUL_CONTINUE;
>  	ulong modrm_ea = 0;
>  
> -	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
> -	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
> -	base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
> +	if (ctxt->vex_prefix[0]) {
> +		if ((ctxt->vex_prefix[1] & 0x80) == 0)  /* VEX._R */
> +			ctxt->modrm_reg = 8;
> +		if (ctxt->vex_prefix[0] == 0xc4) {
> +			if ((ctxt->vex_prefix[1] & 0x40) == 0) /* VEX._X */
> +				index_reg = 8;
> +			if ((ctxt->vex_prefix[1] & 0x20) == 0) /* VEX._B */
> +				base_reg = 8;
> +		}
> +	} else {
> +		ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
> +		index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
> +		base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
> +	}
>  
>  	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
>  	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
> @@ -1195,6 +1219,19 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
>  		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
>  				ctxt->d & ByteOp);
> +		if (ctxt->d & Avx) {
> +			op->bytes = ctxt->op_bytes;
> +			if (op->bytes == 16) {
> +				op->type = OP_XMM;
> +				op->addr.xmm = ctxt->modrm_rm;
> +				kvm_read_sse_reg(ctxt->modrm_rm, &op->vec_val);
> +			} else {
> +				op->type = OP_YMM;
> +				op->addr.ymm = ctxt->modrm_rm;
> +				kvm_read_avx_reg(ctxt->modrm_rm, &op->vec_val2);
> +			}
> +			return rc;
> +		}
>  		if (ctxt->d & Sse) {
>  			op->type = OP_XMM;
>  			op->bytes = 16;
> @@ -1808,6 +1845,9 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
>  	case OP_XMM:
>  		kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
>  		break;
> +	case OP_YMM:
> +		kvm_write_avx_reg(op->addr.ymm, &op->vec_val2);
> +		break;
>  	case OP_MM:
>  		kvm_write_mmx_reg(op->addr.mm, &op->mm_val);
>  		break;
> @@ -3232,7 +3272,7 @@ static int em_rdpmc(struct x86_emulate_ctxt *ctxt)
>  
>  static int em_mov(struct x86_emulate_ctxt *ctxt)
>  {
> -	memcpy(ctxt->dst.valptr, ctxt->src.valptr, sizeof(ctxt->src.valptr));
> +	memcpy(ctxt->dst.valptr, ctxt->src.valptr, ctxt->op_bytes);
>  	return X86EMUL_CONTINUE;
>  }
>  
> @@ -4460,6 +4500,23 @@ static const struct opcode twobyte_table[256] = {
>  	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
>  };
>  
> +static const struct gprefix pfx_avx_0f_6f_0f_7f = {
> +	N, I(Avx | Aligned, em_mov), N, I(Avx | Unaligned, em_mov),
> +};
> +
> +static const struct opcode avx_0f_table[256] = {
> +	/* 0x00 - 0x5f */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> +	/* 0x60 - 0x6F */
> +	X8(N), X4(N), X2(N), N,
> +	GP(SrcMem | DstReg | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> +	/* 0x70 - 0x7F */
> +	X8(N), X4(N), X2(N), N,
> +	GP(SrcReg | DstMem | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> +	/* 0x80 - 0xFF */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> +};
> +
>  static const struct instr_dual instr_dual_0f_38_f0 = {
>  	I(DstReg | SrcMem | Mov, em_movbe), N
>  };
> @@ -4724,6 +4781,41 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
>  	return rc;
>  }
>  
> +static struct opcode x86_decode_avx(struct x86_emulate_ctxt *ctxt)
> +{
> +	u8 map, pp, l, v;
> +
> +	if (ctxt->vex_prefix[0] == 0xc5) {
> +		pp = ctxt->vex_prefix[1] & 0x3;	/* VEX.p1p0 */
> +		l = ctxt->vex_prefix[1] & 0x4;	/* VEX.L */
> +		v = ~((ctxt->vex_prefix[1] >> 3) & 0xf) & 0xf; /* VEX.v3v2v1v0 */
> +		map = 1; /* for 0f map */
> +		ctxt->opcode_len = 2;
> +	} else {
> +		map = ctxt->vex_prefix[1] & 0x1f;
> +		pp = ctxt->vex_prefix[2] & 0x3;
> +		l = ctxt->vex_prefix[2] & 0x4;
> +		v = ~((ctxt->vex_prefix[2] >> 3) & 0xf) & 0xf;
> +		ctxt->opcode_len = 3;
> +	}
> +
> +	if (l)
> +		ctxt->op_bytes = 32;
> +	else
> +		ctxt->op_bytes = 16;
> +
> +	switch (pp) {
> +	case 0: ctxt->rep_prefix = 0x00; break;
> +	case 1: ctxt->rep_prefix = 0x66; break;
> +	case 2: ctxt->rep_prefix = 0xf3; break;
> +	case 3: ctxt->rep_prefix = 0xf2; break;
> +	}
> +
> +	if (map == 1 && !v)
> +		return avx_0f_table[ctxt->b];
> +	return (struct opcode){.flags = NotImpl};

Can we check whether the host supports AVX? I.e. if the host does not support
AVX, set NotImpl. I am thinking that if the host does not support AVX, perhaps
the guest executing AVX instructions will cause the host to panic, because the
host will execute AVX instructions during the simulation.

Yeah if the host does not support AVX, it may not report AVX to the guest, but
the guest can always ignore the AVX check, such as the code in the commit.

> +}
> +
>  int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
>  {
>  	int rc = X86EMUL_CONTINUE;
> @@ -4777,7 +4869,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>  	ctxt->op_bytes = def_op_bytes;
>  	ctxt->ad_bytes = def_ad_bytes;
>  
> -	/* Legacy prefixes. */
> +	/* prefixes. */
>  	for (;;) {
>  		switch (ctxt->b = insn_fetch(u8, ctxt)) {
>  		case 0x66:	/* operand-size override */
> @@ -4822,6 +4914,19 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>  				goto done_prefixes;
>  			ctxt->rex_prefix = ctxt->b;
>  			continue;
> +		case 0xc4: /* VEX */
> +			if (mode != X86EMUL_MODE_PROT64)
> +				goto done_prefixes;
> +			ctxt->vex_prefix[0] = ctxt->b;
> +			ctxt->vex_prefix[1] = insn_fetch(u8, ctxt);
> +			ctxt->vex_prefix[2] = insn_fetch(u8, ctxt);
> +			break;
> +		case 0xc5: /* VEX */
> +			if (mode != X86EMUL_MODE_PROT64)
> +				goto done_prefixes;
> +			ctxt->vex_prefix[0] = ctxt->b;
> +			ctxt->vex_prefix[1] = insn_fetch(u8, ctxt);
> +			break;
>  		case 0xf0:	/* LOCK */
>  			ctxt->lock_prefix = 1;
>  			break;
> @@ -4844,10 +4949,10 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>  	if (ctxt->rex_prefix & 8)
>  		ctxt->op_bytes = 8;	/* REX.W */
>  
> -	/* Opcode byte(s). */
> -	opcode = opcode_table[ctxt->b];
> -	/* Two-byte opcode? */
> -	if (ctxt->b == 0x0f) {
> +	if (ctxt->vex_prefix[0]) {
> +		opcode = x86_decode_avx(ctxt);
> +	} else if (ctxt->b == 0x0f) {
> +		/* Two-byte opcode? */
>  		ctxt->opcode_len = 2;
>  		ctxt->b = insn_fetch(u8, ctxt);
>  		opcode = twobyte_table[ctxt->b];
> @@ -4858,18 +4963,16 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>  			ctxt->b = insn_fetch(u8, ctxt);
>  			opcode = opcode_map_0f_38[ctxt->b];
>  		}
> +	} else {
> +		/* Opcode byte(s). */
> +		opcode = opcode_table[ctxt->b];
>  	}
> +
>  	ctxt->d = opcode.flags;
>  
>  	if (ctxt->d & ModRM)
>  		ctxt->modrm = insn_fetch(u8, ctxt);
>  
> -	/* vex-prefix instructions are not implemented */
> -	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4) &&
> -	    (mode == X86EMUL_MODE_PROT64 || (ctxt->modrm & 0xc0) == 0xc0)) {
> -		ctxt->d = NotImpl;
> -	}
> -
>  	while (ctxt->d & GroupMask) {
>  		switch (ctxt->d & GroupMask) {
>  		case Group:
> @@ -5091,6 +5194,7 @@ void init_decode_cache(struct x86_emulate_ctxt *ctxt)
>  	/* Clear fields that are set conditionally but read without a guard. */
>  	ctxt->rip_relative = false;
>  	ctxt->rex_prefix = 0;
> +	memset(ctxt->vex_prefix, 0, sizeof(ctxt->vex_prefix));;
                                                             ^^
Two ; here.

>  	ctxt->lock_prefix = 0;
>  	ctxt->rep_prefix = 0;
>  	ctxt->regs_valid = 0;
> diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
> index 3ba12888bf66a..9bc08c3c53f5d 100644
> --- a/arch/x86/kvm/fpu.h
> +++ b/arch/x86/kvm/fpu.h
> @@ -15,6 +15,54 @@ typedef u32		__attribute__((vector_size(16))) sse128_t;
>  #define sse128_l3(x)	({ __sse128_u t; t.vec = x; t.as_u32[3]; })
>  #define sse128(lo, hi)	({ __sse128_u t; t.as_u64[0] = lo; t.as_u64[1] = hi; t.vec; })
>  
> +typedef u32		__attribute__((vector_size(32))) avx256_t;
> +
> +static inline void _kvm_read_avx_reg(int reg, avx256_t *data)
> +{
> +	switch (reg) {
> +	case 0:  asm("vmovdqa %%ymm0,  %0" : "=m"(*data)); break;
> +	case 1:  asm("vmovdqa %%ymm1,  %0" : "=m"(*data)); break;
> +	case 2:  asm("vmovdqa %%ymm2,  %0" : "=m"(*data)); break;
> +	case 3:  asm("vmovdqa %%ymm3,  %0" : "=m"(*data)); break;
> +	case 4:  asm("vmovdqa %%ymm4,  %0" : "=m"(*data)); break;
> +	case 5:  asm("vmovdqa %%ymm5,  %0" : "=m"(*data)); break;
> +	case 6:  asm("vmovdqa %%ymm6,  %0" : "=m"(*data)); break;
> +	case 7:  asm("vmovdqa %%ymm7,  %0" : "=m"(*data)); break;
> +	case 8:  asm("vmovdqa %%ymm8,  %0" : "=m"(*data)); break;
> +	case 9:  asm("vmovdqa %%ymm9,  %0" : "=m"(*data)); break;
> +	case 10: asm("vmovdqa %%ymm10, %0" : "=m"(*data)); break;
> +	case 11: asm("vmovdqa %%ymm11, %0" : "=m"(*data)); break;
> +	case 12: asm("vmovdqa %%ymm12, %0" : "=m"(*data)); break;
> +	case 13: asm("vmovdqa %%ymm13, %0" : "=m"(*data)); break;
> +	case 14: asm("vmovdqa %%ymm14, %0" : "=m"(*data)); break;
> +	case 15: asm("vmovdqa %%ymm15, %0" : "=m"(*data)); break;
> +	default: BUG();
> +	}
> +}
> +
> +static inline void _kvm_write_avx_reg(int reg, const avx256_t *data)
> +{
> +	switch (reg) {
> +	case 0:  asm("vmovdqa %0, %%ymm0"  : : "m"(*data)); break;
> +	case 1:  asm("vmovdqa %0, %%ymm1"  : : "m"(*data)); break;
> +	case 2:  asm("vmovdqa %0, %%ymm2"  : : "m"(*data)); break;
> +	case 3:  asm("vmovdqa %0, %%ymm3"  : : "m"(*data)); break;
> +	case 4:  asm("vmovdqa %0, %%ymm4"  : : "m"(*data)); break;
> +	case 5:  asm("vmovdqa %0, %%ymm5"  : : "m"(*data)); break;
> +	case 6:  asm("vmovdqa %0, %%ymm6"  : : "m"(*data)); break;
> +	case 7:  asm("vmovdqa %0, %%ymm7"  : : "m"(*data)); break;
> +	case 8:  asm("vmovdqa %0, %%ymm8"  : : "m"(*data)); break;
> +	case 9:  asm("vmovdqa %0, %%ymm9"  : : "m"(*data)); break;
> +	case 10: asm("vmovdqa %0, %%ymm10" : : "m"(*data)); break;
> +	case 11: asm("vmovdqa %0, %%ymm11" : : "m"(*data)); break;
> +	case 12: asm("vmovdqa %0, %%ymm12" : : "m"(*data)); break;
> +	case 13: asm("vmovdqa %0, %%ymm13" : : "m"(*data)); break;
> +	case 14: asm("vmovdqa %0, %%ymm14" : : "m"(*data)); break;
> +	case 15: asm("vmovdqa %0, %%ymm15" : : "m"(*data)); break;
> +	default: BUG();
> +	}
> +}
> +
>  static inline void _kvm_read_sse_reg(int reg, sse128_t *data)
>  {
>  	switch (reg) {
> @@ -109,6 +157,20 @@ static inline void kvm_fpu_put(void)
>  	fpregs_unlock();
>  }
>  
> +static inline void kvm_read_avx_reg(int reg, avx256_t *data)
> +{
> +	kvm_fpu_get();
> +	_kvm_read_avx_reg(reg, data);
> +	kvm_fpu_put();
> +}
> +
> +static inline void kvm_write_avx_reg(int reg, const avx256_t  *data)
> +{
> +	kvm_fpu_get();
> +	_kvm_write_avx_reg(reg, data);
> +	kvm_fpu_put();
> +}
> +
>  static inline void kvm_read_sse_reg(int reg, sse128_t *data)
>  {
>  	kvm_fpu_get();
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 55a18e2f2dcd9..0e12f187e0b57 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -239,7 +239,7 @@ struct x86_emulate_ops {
>  
>  /* Type, address-of, and value of an instruction's operand. */
>  struct operand {
> -	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_MM, OP_NONE } type;
> +	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_YMM, OP_MM, OP_NONE } type;
>  	unsigned int bytes;
>  	unsigned int count;
>  	union {
> @@ -253,13 +253,16 @@ struct operand {
>  			unsigned seg;
>  		} mem;
>  		unsigned xmm;
> +		unsigned ymm;
>  		unsigned mm;
>  	} addr;
>  	union {
>  		unsigned long val;
>  		u64 val64;
>  		char valptr[sizeof(sse128_t)];
> +		char valptr2[sizeof(avx256_t)];
>  		sse128_t vec_val;
> +		avx256_t vec_val2;
>  		u64 mm_val;
>  		void *data;
>  	};
> @@ -347,6 +350,7 @@ struct x86_emulate_ctxt {
>  
>  	bool rip_relative;
>  	u8 rex_prefix;
> +	u8 vex_prefix[3];
>  	u8 lock_prefix;
>  	u8 rep_prefix;
>  	/* bitmaps of registers in _regs[] that can be read */
> -- 
> 2.43.5
> 
> 

