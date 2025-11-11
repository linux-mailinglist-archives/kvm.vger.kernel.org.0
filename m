Return-Path: <kvm+bounces-62810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBC2C4F66C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 19:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BEF7934B476
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC212BE05E;
	Tue, 11 Nov 2025 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUu4JYj4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zr9Lu9M/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CC3254B18
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762885036; cv=none; b=brIAm7F6N6uQKnTU7qDnt1sP7ZHYBDu8CbvR+CkrR+/AfIJGx46O7eYWlOygGxWSihO5s56QZ3o5vi5DuV2NcnRuyz4mgsm1ZYqju7XAoNu5kyTxv+8ylQmdVXO/FNiU32TYxQdL4M2QJwUwxR4MaDMKjXYCe37vHAxiT+3LPiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762885036; c=relaxed/simple;
	bh=6hts3DkE2BzY2m1GKyImcLooh3IaAGH4dYaJezwdHNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oQCJeGR3rePHaTM2ARuTm4PDV2dIrQO7rr4cluBVyFQ/LIq97OwXgxgFpK/f3HQMcOp/U6RTcXUfkHjpiQY6yHfWKfh3aai3zS+kxQy5wOucYkq46KZ7Sql/PaNWIK/XTjH6v+sRnbG8DAXcjF2U2/N8cl6OhHKW5mKJC+msqXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUu4JYj4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zr9Lu9M/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762885034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/CQb3+BDzPWJy0/i2IahQqVF8wIN4ECXKW8e3nuZNe4=;
	b=AUu4JYj4rZTJxhig2dTQIM0I3MZFC8LiIF90qOR87RTjIcnwE9oBKua8tvkWDSCMQCALD1
	ReymL5XIMPyNmkD73AJY9Gur/kwn039OjOSyShNs1HuLpIyNY0JuswAq6Mb6EvegsaERbf
	2xWfGiteXRBMpk+8+MXNoiJL62VW9sg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-54t_W81KO1yahBlZGPZrwA-1; Tue, 11 Nov 2025 13:17:12 -0500
X-MC-Unique: 54t_W81KO1yahBlZGPZrwA-1
X-Mimecast-MFC-AGG-ID: 54t_W81KO1yahBlZGPZrwA_1762885031
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475e032d81bso303455e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 10:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762885031; x=1763489831; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/CQb3+BDzPWJy0/i2IahQqVF8wIN4ECXKW8e3nuZNe4=;
        b=Zr9Lu9M/pb94In43sG4K8NN9vokcW1sS50FD67JP9nOkrTdGKcqZ+xBgUveDVAFtEF
         EyN2OxiGp0FE21t4D0Q56JTgbF3RRY7L6Lr3z58wtaMocFdI7PExgCZ+dAJ7eYqsJr1e
         D2H1Z5XRj+kuGCtBy31VvL3ghEstfZogeDIpUoFMvXWmtRIR4CRThsmjeGTQrnOLMphS
         HKNaeQuUF9JOfRzupQSRMX2Bi7ZGh5zBIveu8b8gn9dOcw83aBZbrCFvZscLVQxnR3tw
         SRHnZ4wbtt39wrWvJUoBDfdB8bRZlMhladWu7eTjl8MxUQ/dSy8vmajKp+18H2uRNfJY
         /oew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762885031; x=1763489831;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/CQb3+BDzPWJy0/i2IahQqVF8wIN4ECXKW8e3nuZNe4=;
        b=pUSJWfxw80C33wuCISoopVJyZDWRT7jS5LC41cM3C3XXLln5YyQxXQ+rGTg3yOH0Df
         ID6nJ0maMYvz+ykbq8iRtRoL8v/oOCXOH0DLWFUKQnBBpuemI0mSJq9JUGcNcvmLVvnl
         r8aZLXOlwI3zenECxeuSGGG/MjdcO2+e/G3AoSxIzLF07Qjil9eUWPbHo56dodmZZLtk
         avmBYy9AUjIW40WVxMhVSukWoiZYB2MJdmRPS+iOAW9JCLALpBbiK2utiea6mi55U15/
         rB4l9j730zxptWhRagXLFeKpElrmSb9vDdIVvFDLVFY1rd+GRfJdhMDk5hM85x/aWfY0
         FkYA==
X-Forwarded-Encrypted: i=1; AJvYcCVIsHo4Ii3tvunIJZtiJbSriDyYlzZtin0fgaQpq+Jzs3AHmXlcEssi9TNlS6HaHR5DUow=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAAV+p/bzoacJE7bRD2tWP8Hug6p8vE0Le7MbqoBkAdAE2oZsn
	0fcPzUcVL/4G5LdOJlxaZwkkpAKS8gNipZranXldyzf+fpCSOvtQHk1KqBO/jSOWF+H5tnFhn0H
	34LAcxNysWZ5TnIJJL1QNLz008RQGX03kVGeHurLjl1IOIWNIMcm+tQ==
X-Gm-Gg: ASbGncunFBRqwM2+KTkb98s1o2s0hWzuQfu4ZW5wwSaXfzNcnkBQy6EXHJ7WvYY+awQ
	XeQGZanE/0YV3NzjDOUikMikT56H5ohXlmDT0V4TYRWyHTJ7e0QQcdjhJXr/wsOIxzWtuW4MHUr
	fmzC213Z5dvnYmg97bfUwidC9AOuHXvivgigXd+sSdvcY9cpk0gBjQWAflUIsHuPLdoDWJ3rJNw
	5wzc9b48qwOwbOH9gtBr+ea6ZqYZB+lYmtyNuvn5R4O06Nyi5nUnPRSUrUMeD6fwHo6rJ0d+08k
	VqtZFlJKzvCqSgfRcohWVPQChyUwh1NM3LD3KqNjIHuGhFX8U+XFOb7zxIjV1hr0JJoH3S7J1w9
	ci9rqPdzVPm+z519tkRX81P3RMVvkS/wE9shpBf4QQQoQOgiyTobjqCaSqC/phSAxszTTIslLKD
	kED9IULQ==
X-Received: by 2002:a05:600c:154d:b0:46e:2801:84aa with SMTP id 5b1f17b1804b1-47786ff92ccmr3683325e9.0.1762885031216;
        Tue, 11 Nov 2025 10:17:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHCTdnGJpaWczOPph/hSzeC9f0d6LpbSd7kzcP0dS1lBXXTVlyKldXpNlmuDp3D5q+KPaASw==
X-Received: by 2002:a05:600c:154d:b0:46e:2801:84aa with SMTP id 5b1f17b1804b1-47786ff92ccmr3683095e9.0.1762885030715;
        Tue, 11 Nov 2025 10:17:10 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47778daf2c3sm158773155e9.10.2025.11.11.10.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 10:17:10 -0800 (PST)
Message-ID: <d6c3e231-fc24-434d-bb5b-7db5852043b3@redhat.com>
Date: Tue, 11 Nov 2025 19:17:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 10/20] KVM: x86: Refactor REX prefix handling in
 instruction emulation
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-11-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251110180131.28264-11-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Restructure how to represent and interpret REX fields. Specifically,
> 
>   * Repurpose the existing rex_prefix field to identify the prefix type
>   * Introduce a new union to hold both REX and REX2 bitfields
>   * Update decoder logic to interpret the unified data type
> 
> Historically, REX used the upper four bits of a signle byte as a fixed
> identifier, with the lower bits encoded. REX2 extends this to two bytes.
> The first byte identifies the prefix, and the second encodes additional
> bits, preserving compatibility with legacy REX encoding.
> 
> Previously, the emulator stored the REX byte as-is, which cannot capture
> REX2 semantics. This refactor prepares for REX2 decoding while preserving
> current behavior.
> 
> No functional changes intended.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>

Good idea; having to add 0x40 to rex_prefix when decoding VEX was too
mysterious, I'll include something like this in my VEX patches.  Here
is the commit message I came up with:

commit fc8aa5c45d558393069a1c89b7a64e059b8f9418
Author: Chang S. Bae <chang.seok.bae@intel.com>
Date:   Mon Nov 10 18:01:21 2025 +0000

     KVM: x86: Refactor REX prefix handling in instruction emulation
     
     Restructure how to represent and interpret REX fields, preparing
     for handling of VEX and REX2.
     
     REX uses the upper four bits of a single byte as a fixed identifier,
     and the lower four bits containing the data. VEX and REX2 extend this so
     that the first byte identifies the prefix and the rest encode additional
     bits; and while VEX only has the same four data bits as REX, eight zero
     bits are a valid value for the data bits of REX2.  So, stop storing the
     REX byte as-is.  Instead, store only the low bits of the REX prefix and
     track separately whether a REX-like prefix wasused.
     
     No functional changes intended.
     
     Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
     Message-ID: <20251110180131.28264-11-chang.seok.bae@intel.com>
     [Extracted from APX series; removed bitfields and REX2-specific
      definitions. - Paolo]
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> ---
>   arch/x86/kvm/emulate.c     | 33 ++++++++++++++++++---------------
>   arch/x86/kvm/kvm_emulate.h | 31 ++++++++++++++++++++++++++++++-
>   2 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 4e3da5b497b8..763fbd139242 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -924,7 +924,7 @@ static void *decode_register(struct x86_emulate_ctxt *ctxt, u8 modrm_reg,
>   			     int byteop)
>   {
>   	void *p;
> -	int highbyte_regs = (ctxt->rex_prefix == 0) && byteop;
> +	int highbyte_regs = (ctxt->rex_prefix == REX_NONE) && byteop;
>   
>   	if (highbyte_regs && modrm_reg >= 4 && modrm_reg < 8)
>   		p = (unsigned char *)reg_rmw(ctxt, modrm_reg & 3) + 1;
> @@ -1080,10 +1080,12 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
>   {
>   	unsigned int reg;
>   
> -	if (ctxt->d & ModRM)
> +	if (ctxt->d & ModRM) {
>   		reg = ctxt->modrm_reg;
> -	else
> -		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
> +	} else {
> +		reg = (ctxt->b & 7) |
> +		      (ctxt->rex.bits.b3 * BIT(3));
> +	}
>   
>   	if (ctxt->d & Sse) {
>   		op->type = OP_XMM;
> @@ -1122,9 +1124,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>   	int rc = X86EMUL_CONTINUE;
>   	ulong modrm_ea = 0;
>   
> -	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
> -	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
> -	base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
> +	ctxt->modrm_reg = ctxt->rex.bits.r3 * BIT(3);
> +	index_reg       = ctxt->rex.bits.x3 * BIT(3);
> +	base_reg        = ctxt->rex.bits.b3 * BIT(3);
>   
>   	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
>   	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
> @@ -2466,7 +2468,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
>   
>   	setup_syscalls_segments(&cs, &ss);
>   
> -	if ((ctxt->rex_prefix & 0x8) != 0x0)
> +	if (ctxt->rex.bits.w)
>   		usermode = X86EMUL_MODE_PROT64;
>   	else
>   		usermode = X86EMUL_MODE_PROT32;
> @@ -4851,7 +4853,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   		case 0x40 ... 0x4f: /* REX */
>   			if (mode != X86EMUL_MODE_PROT64)
>   				goto done_prefixes;
> -			ctxt->rex_prefix = ctxt->b;
> +			ctxt->rex_prefix = REX_PREFIX;
> +			ctxt->rex.raw    = 0x0f & ctxt->b;
>   			continue;
>   		case 0xf0:	/* LOCK */
>   			ctxt->lock_prefix = 1;
> @@ -4865,15 +4868,14 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   		}
>   
>   		/* Any legacy prefix after a REX prefix nullifies its effect. */
> -
> -		ctxt->rex_prefix = 0;
> +		ctxt->rex_prefix = REX_NONE;
> +		ctxt->rex.raw = 0;
>   	}
>   
>   done_prefixes:
>   
> -	/* REX prefix. */
> -	if (ctxt->rex_prefix & 8)
> -		ctxt->op_bytes = 8;	/* REX.W */
> +	if (ctxt->rex.bits.w)
> +		ctxt->op_bytes = 8;
>   
>   	/* Opcode byte(s). */
>   	opcode = opcode_table[ctxt->b];
> @@ -5137,7 +5139,8 @@ void init_decode_cache(struct x86_emulate_ctxt *ctxt)
>   {
>   	/* Clear fields that are set conditionally but read without a guard. */
>   	ctxt->rip_relative = false;
> -	ctxt->rex_prefix = 0;
> +	ctxt->rex_prefix = REX_NONE;
> +	ctxt->rex.raw = 0;
>   	ctxt->lock_prefix = 0;
>   	ctxt->rep_prefix = 0;
>   	ctxt->regs_valid = 0;
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 153c70ea5561..b285299ebfa4 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -317,6 +317,32 @@ typedef void (*fastop_t)(struct fastop *);
>   #define NR_EMULATOR_GPRS	8
>   #endif
>   
> +/*
> + * REX prefix type to distinguish between no prefix, legacy REX, REX2,
> + * or an invalid REX2 sequence.
> + */
> +enum rex_type {
> +	REX_NONE,
> +	REX_PREFIX,
> +	REX2_PREFIX,
> +	REX2_INVALID
> +};
> +
> +/* Unified representation for REX/REX2 prefix bits */
> +union rex_field {
> +	struct {
> +		u8 b3 :1, /* REX2.B3 or REX.B */
> +		   x3 :1, /* REX2.X3 or REX.X */
> +		   r3 :1, /* REX2.R3 or REX.R */
> +		   w  :1, /* REX2.W  or REX.W */
> +		   b4 :1, /* REX2.B4 */
> +		   x4 :1, /* REX2.X4 */
> +		   r4 :1, /* REX2.R4 */
> +		   m0 :1; /* REX2.M0 */
> +	} bits;
> +	u8 raw;
> +};
> +
>   struct x86_emulate_ctxt {
>   	void *vcpu;
>   	const struct x86_emulate_ops *ops;
> @@ -357,7 +383,10 @@ struct x86_emulate_ctxt {
>   	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
>   
>   	bool rip_relative;
> -	u8 rex_prefix;
> +	/* Type of REX prefix (none, REX, REX2) */
> +	enum rex_type rex_prefix;
> +	/* Rex bits */
> +	union rex_field rex;
>   	u8 lock_prefix;
>   	u8 rep_prefix;
>   	/* bitmaps of registers in _regs[] that can be read */


