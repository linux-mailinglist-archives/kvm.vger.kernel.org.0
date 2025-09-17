Return-Path: <kvm+bounces-57825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2F5B7CFEB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 806DF3A5B0E
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3976A3090EF;
	Wed, 17 Sep 2025 08:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UJ7zy5Ge"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B6F31BC8D;
	Wed, 17 Sep 2025 08:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758097205; cv=none; b=AgO3sNMTZ0aXN1MjrV0UAJtB3tsaJNDMb0BafHbPcBqONJVsSensltmLZoCtw+kURM4f7DSOJ+CjEDYQK39iR6aTdEJ1nrwx5/xqMpdPb/rPYK8eA/WVZTrNAHXWxE6ANcDdx6dQV0CRASD68kO32PDNhfH9C2gsnwxNwI0cMWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758097205; c=relaxed/simple;
	bh=So+LvTMBvZJ/yLBfQqfxuFpdLCw8Umq6IiCkx+94J3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTV7BGWQPS5/xK9W1GUobl1v5Dtp7mggZfMO9j603XzwpxIW2enmrluB8BSeI8dD4YlG1NA6TMe3Q+wnmEAVD2h4ezKxL0AEf8SLFEeU7XX5M+ZqsgtuA2hV6+DcbfmnWzDnVouj+3gBwJg3FsmH/cGeyXuRbn8sseKT/DDmgPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UJ7zy5Ge; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758097204; x=1789633204;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=So+LvTMBvZJ/yLBfQqfxuFpdLCw8Umq6IiCkx+94J3s=;
  b=UJ7zy5GeIkcxyiKhxOTJ1zN+G4XeIMxzIVjucvrbs84pGyqkWPoorP2h
   qQIot4JQa0Z6ZgmW/F70qx9VEPoCxsSJ+9uvIhaWAg4ce/D3LFi2qfxKw
   cD9CYCeoRlHrtEl3YIXMkU/XrkOS8JXIOYZdkDG//NazV51eLeo1/Qun7
   aFuV0Vj2uTMj3aGWe7uJPC4N5hCfOjZMkeo8ZvZY0tKx6aJ7ZLkNn6BES
   nms3V8Fm4pVp1z0xu/MD/E9e2Y3oxiaasEQh1XNBIzTnOrQPzhpinMt1H
   mutgCJ7rQ43Kw+/f+luG92n72xhWJbkMOvD1bMRFQvVcKPN+uGnJYUCeH
   Q==;
X-CSE-ConnectionGUID: F5EkdrNUQQ20RInoK46xAQ==
X-CSE-MsgGUID: uCsXhBzHRz2lPox2QfdPdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="59439357"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="59439357"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:20:03 -0700
X-CSE-ConnectionGUID: Ud3xW+D9QoGOURA/lLO8XA==
X-CSE-MsgGUID: xIjvrPOhT2SFelvQZnJQ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="180442642"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:20:00 -0700
Message-ID: <55ab5774-0fcc-469a-8edc-59512def2bae@intel.com>
Date: Wed, 17 Sep 2025 16:19:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-19-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-19-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
> affected by Shadow Stacks and/or Indirect Branch Tracking when said
> features are enabled in the guest, as fully emulating CET would require
> significant complexity for no practical benefit (KVM shouldn't need to
> emulate branch instructions on modern hosts).  Simply doing nothing isn't
> an option as that would allow a malicious entity to subvert CET
> protections via the emulator.
> 
> Note!  On far transfers, do NOT consult the current privilege level and
> instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
> Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
> can be in play for the target privilege level, i.e. checking the current
> privilege could get a false negative, and KVM doesn't know the target
> privilege level until emulation gets under way.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Cc: Mathias Krause <minipli@grsecurity.net>
> Cc: John Allen <john.allen@amd.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/emulate.c | 58 ++++++++++++++++++++++++++++++++++--------
>   1 file changed, 47 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 542d3664afa3..e4be54a677b0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -178,6 +178,8 @@
>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> +#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
> +#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
>   
>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>   
> @@ -4068,9 +4070,9 @@ static const struct opcode group4[] = {
>   static const struct opcode group5[] = {
>   	F(DstMem | SrcNone | Lock,		em_inc),
>   	F(DstMem | SrcNone | Lock,		em_dec),
> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> +	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk, em_call_near_abs),
> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk, em_call_far),
> +	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),

>   	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),

It seems this entry for 'FF 05' (Jump far, absolute indirect) needs to 
set ShadowStack and IndirBrnTrk as well?

>   	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
>   };
> @@ -4332,11 +4334,11 @@ static const struct opcode opcode_table[256] = {
>   	/* 0xC8 - 0xCF */
>   	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
>   	I(Stack | IsBranch, em_leave),
> -	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
> -	I(ImplicitOps | IsBranch, em_ret_far),
> -	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
> +	I(ImplicitOps | SrcImmU16 | IsBranch | ShadowStack, em_ret_far_imm),
> +	I(ImplicitOps | IsBranch | ShadowStack, em_ret_far),
> +	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | ShadowStack, intn),
>   	D(ImplicitOps | No64 | IsBranch),
> -	II(ImplicitOps | IsBranch, em_iret, iret),
> +	II(ImplicitOps | IsBranch | ShadowStack, em_iret, iret),
>   	/* 0xD0 - 0xD7 */
>   	G(Src2One | ByteOp, group2), G(Src2One, group2),
>   	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
> @@ -4352,7 +4354,7 @@ static const struct opcode opcode_table[256] = {
>   	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
>   	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
>   	/* 0xE8 - 0xEF */
> -	I(SrcImm | NearBranch | IsBranch, em_call),
> +	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
>   	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
>   	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
>   	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
> @@ -4371,7 +4373,7 @@ static const struct opcode opcode_table[256] = {
>   static const struct opcode twobyte_table[256] = {
>   	/* 0x00 - 0x0F */
>   	G(0, group6), GD(0, &group7), N, N,
> -	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
> +	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk, em_syscall),
>   	II(ImplicitOps | Priv, em_clts, clts), N,
>   	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
>   	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
> @@ -4402,8 +4404,8 @@ static const struct opcode twobyte_table[256] = {
>   	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
>   	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
>   	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
> -	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
> -	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
> +	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk, em_sysenter),
> +	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
>   	N, N,
>   	N, N, N, N, N, N, N, N,
>   	/* 0x40 - 0x4F */
> @@ -4941,6 +4943,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	if (ctxt->d == 0)
>   		return EMULATION_FAILED;
>   
> +	/*
> +	 * Reject emulation if KVM might need to emulate shadow stack updates
> +	 * and/or indirect branch tracking enforcement, which the emulator
> +	 * doesn't support.
> +	 */
> +	if (opcode.flags & (ShadowStack | IndirBrnTrk) &&
> +	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
> +		u64 u_cet = 0, s_cet = 0;
> +
> +		/*
> +		 * Check both User and Supervisor on far transfers as inter-
> +		 * privilege level transfers are impacted by CET at the target
> +		 * privilege levels, and that is not known at this time.  The
> +		 * the expectation is that the guest will not require emulation
> +		 * of any CET-affected instructions at any privilege level.
> +		 */
> +		if (!(opcode.flags & NearBranch))
> +			u_cet = s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
> +		else if (ctxt->ops->cpl(ctxt) == 3)
> +			u_cet = CET_SHSTK_EN | CET_ENDBR_EN;
> +		else
> +			s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
> +
> +		if ((u_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet)) ||
> +		    (s_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet)))
> +			return EMULATION_FAILED;
> +
> +		if ((u_cet | s_cet) & CET_SHSTK_EN && opcode.flags & ShadowStack)
> +			return EMULATION_FAILED;
> +
> +		if ((u_cet | s_cet) & CET_ENDBR_EN && opcode.flags & IndirBrnTrk)
> +			return EMULATION_FAILED;
> +	}

I'm not sure other than 'jmp far' case I pointed above, if any more 
instruction/case that are protected by shadow stack or IBT are missed.
(I'm not really good at identifying all of them. Just identify one case 
drains my energy)

At least, the part to return EMULATION_FAILED for the cases where shadow 
stack/IBT protection is needed looks good to me. So, for this part:

Reviewed-by: Xiaoyao Li <xiaoyao.li@Intel.com>

>   	ctxt->execute = opcode.u.execute;
>   
>   	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&


