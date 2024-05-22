Return-Path: <kvm+bounces-17935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FFD8CBBD8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7873E1F2248C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 07:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C9B7C6CE;
	Wed, 22 May 2024 07:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yxEbtQ3j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38C37CF3E
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 07:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716362414; cv=none; b=hbccWWdVhRrgJTYbt/INN25DCv+htiXU5o1r8wP6KebihoQBT4ujq+3no5lUJePYG3xwGmih6ojanBGw0MQVWbhQvupnNyUE17BunATDsmdhMAdOwH0SfjXWQSBGgbNALk0pAzLoJLmLZFJNruCPtRHO1S7AP9/8Sdj2FcgMBkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716362414; c=relaxed/simple;
	bh=91UIMoBqJuIXzScrNoeDbzNCRnDbmKh3LQPWGD3QPxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1JCwBeuS8TF+0vcDcSf7vl+yoVsjbLcLLACZpU99I4CWHkJl5DLGK58FiDbilYhF253OJwXOJch3Ww7V8Pft3OmWafkWWT7AHFKIVhFLPaFHdZktkNHltgAtCuLix827IY+QzWIMnH3HF89DzUd4Aa7vi8vp3zL7wXMnshsJu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yxEbtQ3j; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-351c2c48effso99986f8f.3
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 00:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1716362411; x=1716967211; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMBhFPY2RLtVbP9uMG/kHTkoH5FQv+/qbKIQ531cWpY=;
        b=yxEbtQ3jBAiY1LpsMAoWuQU3Vaj6RXjkYDZGyBUphNOwgccUqyjFhXkjlwa8gp45eb
         8o9QXJ8wqST8RsWfjHawpZ2QXwBcX6Bg4aVQrOYeUo5DAf37nwwhoW7t+R0P9NScrCFP
         hEwIygrBPCrpTwdtJQM9MsPOP3qfrawdiQBqCI0Bg0YOVPrBMsBPOqTfCpHpgO0ZCzIW
         XgrUrb8JYI7tmql124H9Ip53DhMDhck6W1wFnYqF8f25BmXEcEjMz828NPw5xIbuzvgn
         l1Iba4rfhlBwFdlG6hBBYLIymcTqItTO8L5RR3GHGzQw478K2W9t6+/q9Uba9ByS0Iil
         jW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716362411; x=1716967211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMBhFPY2RLtVbP9uMG/kHTkoH5FQv+/qbKIQ531cWpY=;
        b=W6GljEWuVwXtgYuF/gySFOwtSRZ/6g8ESc6rMEqmcjyk2uoo/wbyZhOse95eRTDbWH
         NNhqlCCpMcJkPeVjW/zz5oYqnqAkqs2FHooCNqskPMeY6ZAGK0wVbCRZYAtNJzvCMT+f
         7JHj0OakfMCwfA44eN5K3wniXqF3m8GYTZbaNH804wQcukJBy0HriDdZ6IpAxiN04a7d
         OzQ8gc26m4ZTUPKIdiIyA/1ixI4bmJCP7uCFx2aDhpuvv+Blojqa/C4ejO4bG3xRmCSW
         hm/yAYJOdkzAhfg86E9LtbMinVaIMYPWBoXgdIv8LN3QLFRsILjzWNILo/vbhMQrzOeD
         MhwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNljhZ7ToYX2pCSYyEIjbA8PHRf2CMPfweB27yWwaRIX1krJwSVY4JTAweFVD0ElxikL097u5uAYFTlAwIWWzAM+Wy
X-Gm-Message-State: AOJu0YzmJb8Jal0Ct0MYwblpcXmXmkfqSdfsg3s0CN2gO+/a9rgIh+74
	yOyb0aNSZV7F3iI0qJIpjKz1LH8F0MVboPOtXPaUj2mSrm6Mo+MQXxdfk/f8/uU1hXvt6lOoCcL
	vCrA=
X-Google-Smtp-Source: AGHT+IHWVY+wf0lMzIRvSFmzGRBEtlk7+RZmAm7eEQ/Zt8L9I28gKKUkeR8X87R48p3Psaag4VJcvQ==
X-Received: by 2002:adf:f5c3:0:b0:34e:bdf9:32ff with SMTP id ffacd0b85a97d-354d8c7c2a0mr765925f8f.1.1716362411076;
        Wed, 22 May 2024 00:20:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:2d44:5824:d42d:899? ([2a01:e0a:999:a3a0:2d44:5824:d42d:899])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502baad037sm33448437f8f.71.2024.05.22.00.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 May 2024 00:20:10 -0700 (PDT)
Message-ID: <de2c9064-bb01-42b2-9c0f-884dcabf7c40@rivosinc.com>
Date: Wed, 22 May 2024 09:20:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/16] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
To: Conor Dooley <conor@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-9-cleger@rivosinc.com>
 <20240521-spiny-undergrad-efa1a391ad3d@spud>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240521-spiny-undergrad-efa1a391ad3d@spud>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 21/05/2024 21:49, Conor Dooley wrote:
> On Fri, May 17, 2024 at 04:52:48PM +0200, Clément Léger wrote:
> 
>> +static int riscv_ext_zca_depends(const struct riscv_isa_ext_data *data,
>> +				 const unsigned long *isa_bitmap)
>> +{
>> +	return __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) ? 0 : -EPROBE_DEFER;
>> +}
>> +static int riscv_ext_zcd_validate(const struct riscv_isa_ext_data *data,
>> +				  const unsigned long *isa_bitmap)
>> +{
>> +	return __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
>> +	       __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_d) ? 0 : -EPROBE_DEFER;
>> +}
> 
> Could you write the logic in these out normally please? I think they'd
> be more understandable (particular this second one) broken down and with
> early return.

Yes sure. I'll probably make the same thing for zcf_validate as well as
removing the #ifdef and using IS_ENABLED():

static int riscv_ext_zcf_validate(const struct riscv_isa_ext_data *data,
				  const unsigned long *isa_bitmap)
{
	if (IS_ENABLED(CONFIG_64BIT))
		return -EINVAL;

	if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
	    __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_f))
	       return 0;

	return -EPROBE_DEFER;
}

> 
> Otherwise,
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> 
> Cheers,
> Conor.

