Return-Path: <kvm+bounces-62788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B2DF7C4F14C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 529804F4307
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CBD3730CD;
	Tue, 11 Nov 2025 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="emcRYPBI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZGJz+N6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7493570AA
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762879176; cv=none; b=VVE+6zVVp43SwIXlJYvAHhEZGqTFTq0p33Q0YHdXkRnYS4nweXUXsG+aG5gi96ESwbShn6MbwHZlf9IO3IvjskBMubCfQLe6q1cfyL7iwLPCLXrbekGRh18/NIcX4NFLf1S+Y0d75AMkarLda2YvTK3u3Nn1OUUUwvmAxVhevPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762879176; c=relaxed/simple;
	bh=wi9+MVEzyXv51Z2qk5BA7F+hDTXVHbnwNxVZS1tdKHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kz+TSMem6eZbKP6o36sNxLqljj40YlTQYU5j92lca9BuNPgfUEiWLV36FBWflK9HKZ2paIjSs3w2DRcil2OUFEqFUnpa00+MAEqpATZeQTcklDl1+Ym4OTBb/XiJN3pNc+8JhH0UZiEqmYgZeUtVYC2R6JFoWfpFjrEKZxk45UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=emcRYPBI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZGJz+N6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762879172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bjIoXWyNnXTU6CFqoZWwGE9DyZZqYSh+RJwX/t658jw=;
	b=emcRYPBIM/H+SQKtnkTkCbvFo9GYClakjj9nYVhubnbooBCpScvZnPlYTYjXaT93M4tTGu
	/BPzn9L7ysXb8Le4OChLBpIEKIUc2Cu7Ac0irIaUO0RcFVJDpJeGrKhmI1bTYHSSxUE+RU
	/YfMoeBytWpsxNyRDZIoXTC1brbRkdU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-mgWpE_bAOWqZUWFksa1iPg-1; Tue, 11 Nov 2025 11:39:31 -0500
X-MC-Unique: mgWpE_bAOWqZUWFksa1iPg-1
X-Mimecast-MFC-AGG-ID: mgWpE_bAOWqZUWFksa1iPg_1762879170
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477171bbf51so27600975e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 08:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762879170; x=1763483970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bjIoXWyNnXTU6CFqoZWwGE9DyZZqYSh+RJwX/t658jw=;
        b=RZGJz+N6T1j1y+5Iq5HwU5J2nSdSFzZt8eBJdJGMa0TFKf32kdvcau1JaDmQqvLpPk
         r6PBx0lZU8kImts+1Bo7e07o1171suhGideK11SIJuIdk+NYdPsF4Pyw0cJENfh+J0+E
         d6imJyk1fYFXtxIKDOrTsV5IomUAZZzkQZNlyOmVBjl5zjxA0oLGuZAM79uM9yEcmkJR
         vrDBS5Am3oFgmxHLN3ZOX7Xqw5NAh9WBi6naBpT4+GdSJPKv8Avt532tR5oHS7mcMPTU
         +FdUOi+ns399bLn2GrJovHTnHUg4qLWsHTVztXet33yapWdo2P9+cNfr3uMM/ftaGIHk
         GYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762879170; x=1763483970;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjIoXWyNnXTU6CFqoZWwGE9DyZZqYSh+RJwX/t658jw=;
        b=Vvpl9l1T6KxGpYUHy4+FLItQOfxHSDul0tAAGhC0Zkhrh4ae1T9MSBHt6WOSpSDr78
         wrduIyl7Khz1NVjs0kHcB8iNwoL2FB4XzedGu0j9yVdhl/dtxQ5CE7Buzi02nea5xbvm
         UQWmsNQQXOe1pAhGrUsjGJNBTBUTaHvC+77nqGuBIgar3hpRhrYlQE5iJl+4tYj0tia2
         tcsKQSSAyVJ/FwNuoO6LRjznPlc0KedcjdNBA141kgen4/C6UJN3NoR4b4Hp+VDoXBG0
         5YvgqszjH009pQo0Vv9ktqyWU/WKDZzymIiguIblltgY7rLpRO3pb3TsWjJzSDCsGZMV
         LCFA==
X-Forwarded-Encrypted: i=1; AJvYcCXcA7twrwmf+B8JqnIE4FAF2cLbVPigL0PfNZPAVnCIZsy1Cl5RN4P/NgnxfXhMQsLNXt4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzAcmqiXaJfv9UIW970PQGNaMukqe3WZ4A+dkBuoJxxcwA1Hzw
	PuXf1TA113VlYLLx0K4o1pNJKiveu0liKiAtadJ4QlLNeCYZLooaZJUm4WhXhN1IrA8FoY3smB0
	Rf5DGtCUvHnTzAiNoyyYL20dQIZW5JCNaLKJLzMxRDgDd4t/BOKRCUA==
X-Gm-Gg: ASbGncvmR+520nN39vrf96Q2W9l1SyxU5O8AATernBhnBFWBGqa61lHBg4fSUM3zonn
	VDXodQAY33eHOXE7+nW3HtAcgkt9RlOV7b9hrXTUxNwm6U12GUqqNhdqCibS6bFZTxUUsgIKMPk
	MDB3iAuFHUEl0WBgfILV4fqClBjd1DpIJpgC4wgghvFyaMAEM7CyNEDFMLRA42o/N9zy85YLMA7
	JdPV+/E0z9ODkykMervh8UtnLDBxo652r/sD2KO4og60cDq8of9ZEY64JomWQ+BC4fLal03tUUg
	pU0uChOufZmpaba/YMyRHcs8zPF9KIARV/PiuNxwGU5KA6Sz/jJcKQFppCMVshxYMyXQxayMrU2
	vfDTwRneyvKmG+lePKN+SpMLIuT47ncHm/J4ZpWzJSTafj5wDuBnJczR8gGnQ2Dj+Z4JicJ/ODb
	OWBItTRg==
X-Received: by 2002:a05:600c:1f08:b0:477:3e0b:c0e3 with SMTP id 5b1f17b1804b1-477870c32f2mr362775e9.32.1762879169963;
        Tue, 11 Nov 2025 08:39:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjH6KYSywDziqCu+cKpmbGvHOcpQyVfiAoFBkiY/Bj2n1ic162NAIH9yR8bes6swTTLFDr7Q==
X-Received: by 2002:a05:600c:1f08:b0:477:3e0b:c0e3 with SMTP id 5b1f17b1804b1-477870c32f2mr362555e9.32.1762879169545;
        Tue, 11 Nov 2025 08:39:29 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4775cdc33c8sm376226375e9.2.2025.11.11.08.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 08:39:28 -0800 (PST)
Message-ID: <eb61475f-e5be-4f39-ac62-908453895ad9@redhat.com>
Date: Tue, 11 Nov 2025 17:39:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 14/20] KVM: x86: Emulate REX2-prefixed 64-bit
 absolute jump
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-15-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251110180131.28264-15-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Add support for the new absolute jump, previously unimplemented.
> 
> This instruction has an unusual quirk: the REX2.W bit uses inverted
> polarity. Unlike normal REX or REX2 semantics (where W=1 indicates a
> 64-bit operand size), this instruction uses W=0 to select an 8-byte
> operand size.
> 
> The new InvertedWidthPolarity flag and its helper to interpret the
> W bit correctly, avoiding special-case hacks in the emulator logic.
> 
> Since the ctxt->op_bytes depends on the instruction flags, the size
> should be determined after the instruction lookup.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>

I think this is not needed.  Emulation of non-memory operations, in 
practice, is only needed to support big real mode on very old processors.

We can just add a NoRex bit and apply it to the six reows you touch in 
patch 13.

Paolo

> ---
>   arch/x86/kvm/emulate.c | 27 ++++++++++++++++++++-------
>   1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 58879a31abcd..03f8e007b14e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -179,6 +179,7 @@
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>   #define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
> +#define InvertedWidthPolarity ((u64)1 << 58) /* Instruction uses inverted REX2.W polarity */
>   
>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>   
> @@ -993,6 +994,16 @@ EM_ASM_2W(btc);
>   
>   EM_ASM_2R(cmp, cmp_r);
>   
> +static inline bool is_64bit_operand_size(struct x86_emulate_ctxt *ctxt)
> +{
> +	/*
> +	 * Most instructions interpret REX.W=1 as 64-bit operand size.
> +	 * Some REX2 opcodes invert this logic.
> +	 */
> +	return ctxt->d & InvertedWidthPolarity ?
> +	       ctxt->rex.bits.w == 0 : ctxt->rex.bits.w == 1;
> +}
> +
>   static int em_bsf_c(struct x86_emulate_ctxt *ctxt)
>   {
>   	/* If src is zero, do not writeback, but update flags */
> @@ -2472,7 +2483,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
>   
>   	setup_syscalls_segments(&cs, &ss);
>   
> -	if (ctxt->rex.bits.w)
> +	if (is_64bit_operand_size(ctxt))
>   		usermode = X86EMUL_MODE_PROT64;
>   	else
>   		usermode = X86EMUL_MODE_PROT32;
> @@ -4486,7 +4497,8 @@ static struct opcode rex2_opcode_table[256]  __ro_after_init;
>   static struct opcode rex2_twobyte_table[256] __ro_after_init;
>   
>   static const struct opcode undefined = D(Undefined);
> -static const struct opcode notimpl   = N;
> +static const struct opcode pfx_d5_a1 = I(SrcImm64 | NearBranch | IsBranch | InvertedWidthPolarity, \
> +					 em_jmp_abs);
>   
>   #undef D
>   #undef N
> @@ -4543,6 +4555,7 @@ static bool is_ibt_instruction(struct x86_emulate_ctxt *ctxt)
>   		return true;
>   	case SrcNone:
>   	case SrcImm:
> +	case SrcImm64:
>   	case SrcImmByte:
>   	/*
>   	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
> @@ -4895,9 +4908,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   
>   done_prefixes:
>   
> -	if (ctxt->rex.bits.w)
> -		ctxt->op_bytes = 8;
> -
>   	/* Determine opcode byte(s): */
>   	if (ctxt->rex_prefix == REX2_INVALID) {
>   		/*
> @@ -4936,6 +4946,9 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	}
>   	ctxt->d = opcode.flags;
>   
> +	if (is_64bit_operand_size(ctxt))
> +		ctxt->op_bytes = 8;
> +
>   	if (ctxt->d & ModRM)
>   		ctxt->modrm = insn_fetch(u8, ctxt);
>   
> @@ -5594,6 +5607,6 @@ void __init kvm_init_rex2_opcode_table(void)
>   	undefine_row(&rex2_twobyte_table[0x30]);
>   	undefine_row(&rex2_twobyte_table[0x80]);
>   
> -	/* Mark opcode not yet implemented: */
> -	rex2_opcode_table[0xa1] = notimpl;
> +	/* Define the REX2-specific absolute jump (0xA1) opcode */
> +	rex2_opcode_table[0xa1] = pfx_d5_a1;
>   }


