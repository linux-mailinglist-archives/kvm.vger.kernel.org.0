Return-Path: <kvm+bounces-62787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF9CC4F0F1
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79FCD189FAE9
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03513730D3;
	Tue, 11 Nov 2025 16:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDAWQdQQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HHeArAuT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2347B3730C8
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 16:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762879054; cv=none; b=Lt+0535PgQOMhe8+TOA2BgbWX6ARiNjUGuJg+etn27tcte7tbdiCsvr5aY+/bUGkkHRKiYDOihi9cgkiJX0bpxbK15AEdOfp2NGlPBzGB5CIrq4XsfNkO30zlSKqOY+bdEcBlcF8iOkydIVET6JKxv6rkoM112O3+oQieaVU26c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762879054; c=relaxed/simple;
	bh=CmB1eUcoNGTFZrhIPIJJSrN0/MRzuZ3tT3YhNKBWw/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K01URD3xM3oUXlehc5D9mpS0XWoFUy4Y/N+JzB+tPWnzMKmCeA6djkJdL3n9g0vJ7+7ohxgh8V6Bf+oBmjQjPEUGjE18Vb6NM3ZtC9B+N6qDPIR+iJJ/ZTEK0fb0X2GDb22/jZbvHdi43NT+q45yf6NREwWBG8VeLLl1AtXbGds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDAWQdQQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HHeArAuT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762879052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HImt604PJ3Z8w/cR0ElYpUFLDlMbNEVlH4hMkZPWNJA=;
	b=gDAWQdQQWEfS9jRiG77kutSdTKlEz9IRljG9MW5Wd/EKCv1Q299JEboYfrdadN5rf6o3Kz
	ubdNdayXLa82yobwnsPZ5ZyYFxiqSZy2LMVkRv1P2ji3Soo7tIUMuY8Mq//NitXgBs8I7H
	gRmGfjAXYyYdjil6mA9SnZXUayCbJ1U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-_NaWypvCP6mn5fhS4HU8ZA-1; Tue, 11 Nov 2025 11:37:30 -0500
X-MC-Unique: _NaWypvCP6mn5fhS4HU8ZA-1
X-Mimecast-MFC-AGG-ID: _NaWypvCP6mn5fhS4HU8ZA_1762879050
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775fcf67d8so39428025e9.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 08:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762879049; x=1763483849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HImt604PJ3Z8w/cR0ElYpUFLDlMbNEVlH4hMkZPWNJA=;
        b=HHeArAuT7dvpVbfe+tUCgt8FhN+JYkBNGnUFqxK8/zLUOj1bYExDM3Gl70AoIBQrLy
         DMtsczCC3XFwHkPwf79CNJ/GxM+S++rOxjMU+XJuzfg3uq6vtzfajNd1K0xLqFIli7sT
         F96sKtPCN/2pRuTkzd73Q3vy14x5E0rUqj9Ga5LJrTWbnnFGTSHj+9XIYYLSOe46Jav7
         N3GiQEBja4kyQCSGNRWiP+c1IJZkUu4lzVigSUdEXKqjqzaNQe3HRynCwnnAuo/HEcPO
         6Fd2wQQIeYyDbGSxA+wyXAMtOz2z4MT8kvAdcTIc9E5n6t6CmpiN/tbgC7cBJd54gkrS
         x8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762879049; x=1763483849;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HImt604PJ3Z8w/cR0ElYpUFLDlMbNEVlH4hMkZPWNJA=;
        b=wTJep8m4orUtCOAUjf05hN6aPSUWIH0txPKHYEukAhErylRAGj06lTkgx1xSz+ySo2
         tY1XACM9WZQc8WXYBAeLoW+4rqTiwORc3UdpioEzykRY17X7gHvKssgD9AiVDqOeeZbx
         rDT3PcX3t/BfzifnevduSoMuZpzo/OGxq+p7i0lC44+oWiQXdJQ08mwp9bB5ouondUpp
         N86s3fjrPMwvZn/lJx8Wj30N9IpAdPSjpSYMmTLgzwdkzC7yGW+hv5jVcuV1GSxplrkP
         7yqet2YRvGyB40YuMG+qo7RKdHSmuJAv73XzDjw9ga5aSc6dGI8f/iBRf+vniS3s44ym
         LddQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf+kolBtW46AKsF14RfwVmfjl5GkhGfceXCojhv+OWujFa3KJMGqdGE58BvTbhRT5uOuA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1kaKLwDc3+vTQ41ctPLMaO5aZTJsSmmE+N312Z67xE14CAGXZ
	w+k4gxuw1DY3joVfKDq9ZbHEKOkRU1gOH8buyh163mECicU8DcxNwcoTaPFOvb8f+L9YF35w4SA
	9gw3E4LYU+v03Xem4Gk5Zwsd6nrWW3OwT0K8yfA4UFxkridp1dvmgww==
X-Gm-Gg: ASbGnctnn17SznITJupN6/ApO+z9oSeOv5aFPrCaQMHCXHXPDHqrYC6UiaMqHnxTA9r
	aJVIfrEq4J4iaNE6KqanvxX+vcWMwX9WlOEh7ydhfTL8Io3a0gfs98Nh4ZcInKz+xOw4ThKJGRH
	DRgObdm26qG5j/RKXBxNujNTrymwRIhCAen65t4nhHJ9Di58SSQXFyj2L2IX2OtRItIkCm8gNQR
	JEvX6WWFCkVT5k1yh1Qt6gltIOnYQdBNl5q7ZrYrzPPYjv7JOrat4R5YMYfZ1KbnaGubtGwzq/k
	291XY9+9i3XvX3s7NO165gmvZRDtjybiKWMhtYKD/ddjdV7SbCWZrPZFSc9O/FKhPTNAen+Tb58
	DWwa2+It+Jfeyoee2ci9hETawghtCU57uBDG/Jb2bvQz5rWpkFHryV72LeQqMPz8LjxogTwHR3G
	tcoFy9uQ==
X-Received: by 2002:a05:600c:4593:b0:475:dd7f:f6cd with SMTP id 5b1f17b1804b1-477870b92f6mr263335e9.35.1762879049505;
        Tue, 11 Nov 2025 08:37:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0FFQqiFEcuP0QuOZESv6esXKON7IZgxgQeWvfeD0418RmgbA8MrtmypbihbYyHq3QGSegyg==
X-Received: by 2002:a05:600c:4593:b0:475:dd7f:f6cd with SMTP id 5b1f17b1804b1-477870b92f6mr263125e9.35.1762879049128;
        Tue, 11 Nov 2025 08:37:29 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4777d9447eesm122367945e9.16.2025.11.11.08.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 08:37:24 -0800 (PST)
Message-ID: <896debcd-f0d3-4f75-b090-c59b0ac1fa57@redhat.com>
Date: Tue, 11 Nov 2025 17:37:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 15/20] KVM: x86: Reject EVEX-prefix instructions in
 the emulator
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-16-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251110180131.28264-16-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Explicitly mark EVEX-prefixed opcodes (0x62) as unsupported, clarifying
> current decoding behavior.
> 
> While new prefixes like REX2 extend GPR handling, EVEX emulation should
> be addressed separately once after VEX support is implemented.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
>   arch/x86/kvm/emulate.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 03f8e007b14e..9bd61ea496e5 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4952,8 +4952,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	if (ctxt->d & ModRM)
>   		ctxt->modrm = insn_fetch(u8, ctxt);
>   
> -	/* vex-prefix instructions are not implemented */
> -	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4) &&
> +	/* VEX and EVEX-prefixed instructions are not implemented */
> +	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4 || ctxt->b == 0x62) &&
>   	    (mode == X86EMUL_MODE_PROT64 || (ctxt->modrm & 0xc0) == 0xc0)) {
>   		ctxt->d = NotImpl;
>   	}

VEX support is coming (will post tomorrow I think) so the patches around 
decode are going to need changes, but nothing major.

Paolo


