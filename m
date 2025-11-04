Return-Path: <kvm+bounces-61993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E828CC3266E
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6AF7B34B76D
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570E833BBD0;
	Tue,  4 Nov 2025 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuZ43735";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="r5317QgB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3BE33BBC9
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278052; cv=none; b=dcqJYrhGFsfLmkUr7aHBUELzej4pl+AQeRoqDlRxjKr8R1ljShYzUxelp5sPnbrpWGSoTwdhHKaKmeSHuHwCEDmziLnqgijdRtAnzR2xBIysJSx/C2gu5PDpwaUZEOzGPU5Jc1zogdCKvLXNIac5huLz5mUxSmgGKhdZ/YilZqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278052; c=relaxed/simple;
	bh=9/V+JtN1C3x8MaOLuLtLksJtuBICm2Ac1ulgOuUH7iY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SzgsqUYYrtacu+Qmi6i8c+W+m40yHhKYkCE758bv8hwzQIsPL/nnZHAH6HXgUFRFmcMWPnegFxSO79/Ph772mKOH7L5o6kqLZ74s5/teDNLarqeL3STpsaiTMEsxVIcA+bySFr3HmHu+zBbQCS5VBkyfDSNYol320ZCkUlBhDAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuZ43735; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=r5317QgB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762278049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NbV6Oebj1HpBMQtd1evkIv+/GOafpt/zOBeftSw66JI=;
	b=ZuZ43735TyIaG0WEeYJntJIEGmwpPTH2L5/lp5puDu6h+qb0nkDNTWukGcwFkUUblZmNA/
	vLySkFioDplrsO1+87dlhZtHWXg3Y/BlS0juNaWGE8nL32xzJkc8sKZIhh+CTyai81H+PG
	X010J8Qb5/YJ4s1ZZmInHRqMrqPDci4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-EhlC5AI4NPmfYGGy68Y1Ng-1; Tue, 04 Nov 2025 12:40:47 -0500
X-MC-Unique: EhlC5AI4NPmfYGGy68Y1Ng-1
X-Mimecast-MFC-AGG-ID: EhlC5AI4NPmfYGGy68Y1Ng_1762278045
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b70b974b818so233944266b.1
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762278045; x=1762882845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NbV6Oebj1HpBMQtd1evkIv+/GOafpt/zOBeftSw66JI=;
        b=r5317QgB7GOLHuQPvdRxUbw5iQ9ZE5bO/WhMQ0QC4mwDJuCPOrS0rm3BxBfBsVlPDL
         ADfIYnliT/YaBQZzB8DIK9ywfyb103nue1j/ERL/tNwi1gtSvOvIfoJBVHh+Hcj+XLyi
         /81UR9vCpRwuDFubF1g9nV479+oUKMqZ8Tny7r93evLKU3fEF+eDBoDZit1UU277w+K1
         go4vqVXO1zIQ4VsCHpZUWqSsBlnxb5fO4ARc3JLRkRm746cbKx393vQyCGVBlOnDMN+N
         nh9vfDdcQlzuGA5l5XDYdJ8HXdhzSUoioz/EbQ3b9kyj58NP24RlS/kybvYmftjbojqo
         xkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278045; x=1762882845;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NbV6Oebj1HpBMQtd1evkIv+/GOafpt/zOBeftSw66JI=;
        b=CTTupenhc6eByBQwgngomchJeI+IAZMxB1ESO1M8+YQriMmauKwBqLxnb47wVhVQi0
         Rw7MyfsXLC5GcX0sRSVudeJw/EXgL7zWKxjv+gMo6oY3jx10RCTtIxoTpzX4Ftgf978v
         RXbHm07sXIx8kXJXx1g8B7Lt88nHk27EeMrsSuP7WEsZorUAN2trzPAOEpi1JmsGAV61
         4qbhU5GWa3aImMH+SkBfZXoB6h8hFv/zc/tKkwSnpcEpKo5N+s//MXDn8BdHc6wChXKS
         WaqRPz3cz2Or/3Ie4iWhYaoTJ9O3G77v/KSNVwJ9pkga880coMrP/ERkbYuhUFGlEhQ/
         2Vow==
X-Forwarded-Encrypted: i=1; AJvYcCWt8lw2HW1uv+QNCSB79cJVXcu8SfYTIqcNAT8gdVs6rlEV1Fpa2og+bQ+q6tpdPAbCNOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Fxk2oOTA1rPPGCyMKv0vYo/xWyn4F0NaNx3ZOYYD8YhYjzKc
	oh7jIFWI0zXFV9Im95rZSIdUpmY/fyLuDzs3TMUmboEaAFf8BVjyOav+cQRMBD/8w1Ljvf278CU
	9t26g9wgyVfRiH8Rbn2AOuptPy9v9dVIarnQ9Xw3TAYr6bU00feJvFw==
X-Gm-Gg: ASbGncvoXgfF6v/xbQn+2+ok7yHQE2an/J1lljTt+tZv84HqmD0xotly352KLX5G53N
	jOzc1E/ZQmtxxw0T+7zAtrS+m7hPBR3PA1KXYAc+zRVQjeJN0y6IFHcrzCyQ4F97tN9rB5x7hmZ
	z2YAqefXohbwzfNdsDDeT8AKbJNoZ285bWoLD237Y7EHMlduqX75d1SQgcqeowfStDOuO1OBl7u
	QltoOEY9x3RqhGLTwOu4dSl4YBTuPzLv4oUenlNGPhnMKp942R/3LBPr5FzhJ3liAqTmvh7+Y1X
	lleSyGzHwohho7JkJrhKSr7xCj4BbQqSy4tjfuWNi5CTL7wgQJNOtOMjeB4BDcQFkArdqPoq5Yv
	/NALDSLTA7Q8I3v/iy7fCUXak9nCiQdxSmnW/QtWKi8Bc8R4DOI1IeII7VSM5PgPZUqlTZL0hf8
	hrZzRo
X-Received: by 2002:a17:906:478e:b0:b3f:33f6:fb57 with SMTP id a640c23a62f3a-b70700ad60dmr1852446966b.9.1762278045287;
        Tue, 04 Nov 2025 09:40:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMuwDLpCcGol7XijHs46PRw1XUB6pY2PrEin7/u5W3BZusaOceEpzO/bp6xBOR6v6i9pyfdw==
X-Received: by 2002:a17:906:478e:b0:b3f:33f6:fb57 with SMTP id a640c23a62f3a-b70700ad60dmr1852443066b.9.1762278044793;
        Tue, 04 Nov 2025 09:40:44 -0800 (PST)
Received: from [192.168.10.48] ([151.95.110.222])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b723fa038e0sm272432766b.54.2025.11.04.09.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 09:40:44 -0800 (PST)
Message-ID: <d9fb8b26-95f7-4929-9168-5413a7904edf@redhat.com>
Date: Tue, 4 Nov 2025 18:40:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
To: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Cc: x86@kernel.org, Keith Busch <kbusch@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>, Xu Liu <liuxu@meta.com>
References: <20240820230431.3850991-1-kbusch@meta.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240820230431.3850991-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 01:04, Keith Busch wrote:
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
>    traps: vmovdq[378] trap invalid opcode ip:4006b2 sp:7ffe2f5bb680 error:0 in vmovdq[6b2,400000+1000]
> 
> And is successful with this kernel patch.

It's been a while but I am going to revive this patch (fix it and resend 
it)...  Here are a couple notes on what can be done.
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
It's easier to do all the VEX decoding straight into rex_prefix in 
x86_decode_avx.

>   	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
>   	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
> @@ -1195,6 +1219,19 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>   		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
>   		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
>   				ctxt->d & ByteOp);
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

The duplication with decode_register_operand sucks, I'll check what can 
be done about it.

>   		if (ctxt->d & Sse) {
>   			op->type = OP_XMM;
>   			op->bytes = 16;
> @@ -1808,6 +1845,9 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
>   	case OP_XMM:
>   		kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
>   		break;
> +	case OP_YMM:
> +		kvm_write_avx_reg(op->addr.ymm, &op->vec_val2);
> +		break;
>   	case OP_MM:
>   		kvm_write_mmx_reg(op->addr.mm, &op->mm_val);
>   		break;
> @@ -3232,7 +3272,7 @@ static int em_rdpmc(struct x86_emulate_ctxt *ctxt)
>   
>   static int em_mov(struct x86_emulate_ctxt *ctxt)
>   {
> -	memcpy(ctxt->dst.valptr, ctxt->src.valptr, sizeof(ctxt->src.valptr));
> +	memcpy(ctxt->dst.valptr, ctxt->src.valptr, ctxt->op_bytes);

The idea here was that copying everything is faster because the size is 
constant.  256 bits starts to be relatively hefty, but still only 4 
words.  Maybe worth adding an "if (ctxt->op_bytes <= 8)".


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

Can't blame you for duplicating the table, as that's the easiest way to 
do it.  I'll check if I can reuse some ideas from QEMU on how to avoid that.

> +static struct opcode x86_decode_avx(struct x86_emulate_ctxt *ctxt)
> +{
> +	u8 map, pp, l, v;

Should check that there are no 0x66/0xf2/0xf3 prefixes.

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
> +}
> +
>   int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
>   {
>   	int rc = X86EMUL_CONTINUE;
> @@ -4777,7 +4869,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	ctxt->op_bytes = def_op_bytes;
>   	ctxt->ad_bytes = def_ad_bytes;
>   
> -	/* Legacy prefixes. */
> +	/* prefixes. */
>   	for (;;) {
>   		switch (ctxt->b = insn_fetch(u8, ctxt)) {
>   		case 0x66:	/* operand-size override */
> @@ -4822,6 +4914,19 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   				goto done_prefixes;
>   			ctxt->rex_prefix = ctxt->b;
>   			continue;
> +		case 0xc4: /* VEX */
> +			if (mode != X86EMUL_MODE_PROT64)
> +				goto done_prefixes;

VEX prefixes can actually be used in 32-bit modes as long as bits 7:6 
are 11 in binary.  Might actually do that, since we don't support 
lds/les instructions at all in the emulator.

Also I'll move all the fetches to x86_decode_avx as well.  Just do a 
"break" here...

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
>   		case 0xf0:	/* LOCK */
>   			ctxt->lock_prefix = 1;
>   			break;
> @@ -4844,10 +4949,10 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	if (ctxt->rex_prefix & 8)
>   		ctxt->op_bytes = 8;	/* REX.W */
>   
> -	/* Opcode byte(s). */
> -	opcode = opcode_table[ctxt->b];
> -	/* Two-byte opcode? */
> -	if (ctxt->b == 0x0f) {
> +	if (ctxt->vex_prefix[0]) {
> +		opcode = x86_decode_avx(ctxt);
> +	} else if (ctxt->b == 0x0f) {
> +		/* Two-byte opcode? */
>   		ctxt->opcode_len = 2;
>   		ctxt->b = insn_fetch(u8, ctxt);
>   		opcode = twobyte_table[ctxt->b];
> @@ -4858,18 +4963,16 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   			ctxt->b = insn_fetch(u8, ctxt);
>   			opcode = opcode_map_0f_38[ctxt->b];
>   		}
> +	} else {
> +		/* Opcode byte(s). */
> +		opcode = opcode_table[ctxt->b];
>   	}
> +
>   	ctxt->d = opcode.flags;

... and call out to x86_decode_avx here for the actual processing of the 
prefix:

	if (ctxt->opcode_len == 1 && ctxt->b == 0xc4 || ctxt->b == 0xc5) {
   		int modrm = insn_fetch(u8, ctxt);
		if (mode == X86EMUL_MODE_PROT64 || (modrm & 0xc0) == 0xc0) {
			opcode = x86_decode_avx(ctxt, ctxt->b, modrm);
	  		modrm = insn_fetch(u8, ctxt);
		}
		ctxt->modrm = modrm;
	} else if (ctxt->d & ModRM)
   		modrm = insn_fetch(u8, ctxt);

Nevertheless, thanks so much for writing this and sorry for dropping it 
on the floor for so long.  It's way overdue.

Paolo


