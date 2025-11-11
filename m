Return-Path: <kvm+bounces-62790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 896EBC4F23C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 129914EED6C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AD4377EAA;
	Tue, 11 Nov 2025 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShEA+3qU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nR/Bi2c2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170C1A3BD7
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762880005; cv=none; b=WzHkaVucGXp9QE/G0TyxV7PHNuWW6j28QosfktutCYFIzPG1zA3d3MMLPM6Au9TBFZvpKYVzP+NwaV5UZLmXJ6laABfoI4+rBrfMhKbjIjHWIaklpun+8fL9FW6TH/sJ3ypqVnMzLL6jH3QDjvKTF8hajSSiTHw+W8W6KlbsypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762880005; c=relaxed/simple;
	bh=SS0LZ3kWuX/E6hwB65fRvUu+pViB6WaWPy05xJu0hgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m6i5arJIKr/kK+JgEWOAsvJ0dNyJI2xKM1wkSnIC4nYDPNg8q/ksXOjjJRbezoSX7vrTtWzV5tkjbzQ9LkjkeOaBOIPN1NgW+PwwHhr3zND4Ubb8traPLQb7NCk1S3YWyLA549g5px2tXPpv5A/+k4gGDeP8AKdUVtuiYEemqCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShEA+3qU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nR/Bi2c2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762880003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jv9tA8d7GDzG4uMgQEzEG6S975RuueXPPh6IjnESOqs=;
	b=ShEA+3qUz/B1fl+YsjMX2LMeG+winETTIAQZc6CcRJqvS/xr8W0yzx+do7hbyS9AN7oP0p
	9gRWBei5Y16/4ggTMWmZZXpCVW2BRfSWj+jeQPJd4IUf0NdMmWnz6xTXwzaQOvCAufqx3r
	aJwZpTMZkn59xUyTzx0htfKzuA7nGpI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-gqcP5YpPNRa7Z3_dqOlnvA-1; Tue, 11 Nov 2025 11:53:21 -0500
X-MC-Unique: gqcP5YpPNRa7Z3_dqOlnvA-1
X-Mimecast-MFC-AGG-ID: gqcP5YpPNRa7Z3_dqOlnvA_1762880000
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b72de28c849so348135266b.1
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 08:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762880000; x=1763484800; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jv9tA8d7GDzG4uMgQEzEG6S975RuueXPPh6IjnESOqs=;
        b=nR/Bi2c2/Ax7qDFVXRDI7sfrIVu0mcZ3dHdHBTuz9yqkLhzr6G0EtbmSKXKQxbLzN9
         zA9Hq+prdbowzINXYFhd4GPXvl6/O7w0ymbk+O1LkKevWPpg/GXTHawv+ZrY83El64gK
         9Xm3a2BkabFF+vP3Y1vSSqw2ffazV9xztE3IqQoUWE8Bz2Ub8tVxW3wZGTsVNXGHLtvr
         upMo81dH/v5AACSonPTrXNdlzzjLFNDSAny7o5Vo6VPoGKsNSHazcvqFGVU24j4iSajg
         h9/3faN+1EewGKB3fz6woSEcUDhqJwYXBLyB2p2SLihXdP8DUIhUklH9jlsNdgd2xAkh
         vH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762880000; x=1763484800;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jv9tA8d7GDzG4uMgQEzEG6S975RuueXPPh6IjnESOqs=;
        b=ZHkFmbMVQMIxyj6Y50MzHCgpBePh5hWHUDZJD4brN7aFmVuQ9S8aingCX9QKAKXPwf
         ejGoMQMB33CMqsM+BEJMtyG2/Tpewdd4hie6j35fNH5WpSzG3G7wyYXHtK2OGMFl5xh6
         5mQ1+/gf2jYzT3P5s++ViWEH4CLsLBJy+Ni3AJxCpMwt2eMJHaqjFRTC5KYuTaKAoCNE
         wsdDmY13xTsMzo6dkE2SQMOvHNUIGLlHpLLwftJUj2q4ILqC7FtizB+kLGX2Uhr9jzKI
         AqYcKLn4p5OSPrDYO+Q6swGONuKaDHRWvQ8rNiCf65rvOB0U9y1wA9f6mN+Ax3XTdNCU
         HCaw==
X-Forwarded-Encrypted: i=1; AJvYcCXgDT00w7adR+RukGwpyIgafJUMY3YLhArHn8b3AQMre+2i9wr/3Gy04ChD8ywG2fbE2Fs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1feX6bG0fOubHsBlnMNhBlPlpuNMWbKDIPtSJuXabLI6I4zK6
	ZMhkElqEDAUbaLPT9dJ12zTiU9msvmnZlqSofJdvhWnte5CUdPqh9plG08z6/n0DWulgDclp7d8
	WmENVYa/gIKYTMMSNY1oJnytp5fbLsXyhf57VWAzfmL5mxXuEOpM2vg==
X-Gm-Gg: ASbGncskL0P+8nngO0gs92bjTICRIJzB/1ADqwC9dx8NyAVkTst0csgfAck2UIkor8Y
	88vn6jyncaEVBDflschy9AoUo3MptV449tZYBk/0fws4aUPhFZq9iLenCufAsg48V8Q3Y6o/FNE
	qOeXsLoXdzDugPdja6laWjlx//tEazjGAA9/A35yP8oEpKIRhhcx5HBPPMyeM41lTI5ZcR8q4Z6
	rQlWJJObKxD5LGeE9BSZzNlKWTALR1D3SdBP86SUN0lU9rVewAYDJ+dCiBQ1Cd5XpfQEK3GN2jy
	szcqdTMH591tbMnj2mHifqbZDEOaKSoduX7UM3+EA+IWYaLeT6AdrPqiqxgSSuRmchQY2E0oCy0
	sJA9gxZYAqQoYwCBSV2KaGTUdEskktwNhd294OO9XCaTEH6UjcfRo87+bmpQccNQJClxs4hA8g/
	jEPXvf9g==
X-Received: by 2002:a17:907:6e8e:b0:b73:246d:cf1c with SMTP id a640c23a62f3a-b73246dd6dbmr271551866b.63.1762880000437;
        Tue, 11 Nov 2025 08:53:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOoWeSsqurTLnlYY8Ak3yfURZbQCmmYnmQidXFxGNQNo2oGKJYJXgxY7NErKx33j1+dxvJHA==
X-Received: by 2002:a17:907:6e8e:b0:b73:246d:cf1c with SMTP id a640c23a62f3a-b73246dd6dbmr271549066b.63.1762879999976;
        Tue, 11 Nov 2025 08:53:19 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b72bf97d430sm1451420666b.37.2025.11.11.08.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 08:53:18 -0800 (PST)
Message-ID: <3d93c8bc-8f13-42e1-a9e1-0d27d7e8603b@redhat.com>
Date: Tue, 11 Nov 2025 17:53:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 12/20] KVM: x86: Support REX2-extended register
 index in the decoder
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-13-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251110180131.28264-13-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Update register index decoding to account for the additional bit fields
> introduced by the REX2 prefix.
> 
> Both ModR/M and opcode register decoding paths now consider the extended
> index bits (R4, X4, B4) in addition to the legacy REX bits (R3, X3, B3).
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>

Replying here for both patches 10 and 12, because I think you can merge 
them in one, I'd prefer to avoid bitfields.

You only need a single enum:

enum {
	REX_B = 1,
	REX_X = 2,
	REX_R = 4,
	REX_W = 8,
	REX_M = 0x80,
};

for REX_W/REX_M you access them directly, while for RXB you go through a 
function:

static inline rex_get_rxb(u8 rex, u8 fld)
{
	BUILD_BUG_ON(!__builtin_constant_p(fld));
	BUILD_BUG_ON(fld != REX_B && fld != REX_X && fld != REX_R);

	rex >>= ffs(fld) - 1;	// bits 0+4
	return (rex & 1) + (rex & 0x10 ? 8 : 0);
}

>   	} else {
>   		reg = (ctxt->b & 7) |
> -		      (ctxt->rex.bits.b3 * BIT(3));
> +		      (ctxt->rex.bits.b3 * BIT(3)) |
> +		      (ctxt->rex.bits.b4 * BIT(4));

+		      rex_get_rxb(ctxt->rex, REX_B);

and likewise everywhere else.

>   	}
>   
>   	if (ctxt->d & Sse) {
> @@ -1124,9 +1125,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>   	int rc = X86EMUL_CONTINUE;
>   	ulong modrm_ea = 0;
>   
> -	ctxt->modrm_reg = ctxt->rex.bits.r3 * BIT(3);
> -	index_reg       = ctxt->rex.bits.x3 * BIT(3);
> -	base_reg        = ctxt->rex.bits.b3 * BIT(3);
> +	ctxt->modrm_reg	= (ctxt->rex.bits.r3 * BIT(3)) |
> +			  (ctxt->rex.bits.r4 * BIT(4));
> +	index_reg	= (ctxt->rex.bits.x3 * BIT(3)) |
> +			  (ctxt->rex.bits.x4 * BIT(4));
> +	base_reg	= (ctxt->rex.bits.b3 * BIT(3)) |
> +			  (ctxt->rex.bits.b4 * BIT(4));
>   
>   	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
>   	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;


