Return-Path: <kvm+bounces-45452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3473EAA9BFC
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B3B7189FAF2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E284426E142;
	Mon,  5 May 2025 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="liEUyCn4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF2191F95
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471137; cv=none; b=Pt8ja3m4p17j3PEcLKNODXDDYF/ClM5bQUnO3oXyhf1ey0GgA8tjtlEknhMB0VgEVKQRgw9yOTRBhtRZM/gNcfL7Ta+/WDqsrvHPs+uTZuhEvN+HthhEHoJ8J8eH47K/Q+V92UKYpvYIHYPX4l9PRSiFa2Lb4RaPZxx8sOAKnx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471137; c=relaxed/simple;
	bh=7/E0M9aDuBcgv3DKN32vIJi/HeCPr9SKdZ21nIJOM9E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tut2if5iI03/xhUGae2jfxz8azl8Fs35E3RX2fxXBVLvWq1qZZqX3ZgeFwaDdmBSDqyTyKsjkTqsdIHx8G3+nPDfKFPfMacavdgTnYcbbJbKT/lU5DTPwkCbsh3SOAHMraiRNqTLWLrQugKRut6CR8SH/3ux60fBEaGoXPKfpqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=liEUyCn4; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3014678689aso3746579a91.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746471134; x=1747075934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=00bWzvaWCIBwpMCAX5b1llfSuwpHrhqcBu5fE9MIR+c=;
        b=liEUyCn4NxhGYWohefFdSbdE8p9wIzJwMR7fWbfkQrsd2aL3LijeGwcrK2JrGzGq61
         75qx8+AuVb29Q83Z36EdL6MdqRKhoCBsmfhn4m6Hlg4fOia6Rz7ZimOkWcXm8KtPOky4
         66DRIm7ZZnSDDFl8ChupVrPUIKGZh5ipoKHSRDvgiQaOagKza6DhwulqXyetdJ2A8EsG
         he+1uewezwILsdG0Oq/IQfpLDlCMKAo+oKr3zQlaaUA/olTiWXvPxAZ/geHU0Soxu5c5
         CPGdVxgtp+g3xHXQ7iS5tI9fMk/twqJZKSKzKSdAp17qB5bW7KVEj1pNH1zOJvGLEAtG
         +VmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471135; x=1747075935;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=00bWzvaWCIBwpMCAX5b1llfSuwpHrhqcBu5fE9MIR+c=;
        b=A+SpF+3MF3jG31AfzBrd8eanFjEsfvoKdqDYI+AzQFS1OqIn0L8SAGWNFnaxm7Of9A
         XlwMstUDPkykf/OsZn/AbLAD/I5WHxft4naluziRJaEFu0idjzoGUA/Qmt3MxWVi5BZb
         gHfsRxeWyqPdAafCNcpBME5D7gBopBqcdH1e1JL9bmMXzetbpvydbuLOnXtyHaHdk82A
         WfG9AnhzRiglNLF+Ck6iNfV5TsRlKHDeU6bbewLblOKH5hLQ5bGD2DxYjcsPSSNDUnQ5
         fuPjPaTjVcL5oHosU64gNMAZoCuRx0UBhr70E5W1wR8gg9jUBrZmjef/024yqVXpt/Lz
         dzxg==
X-Forwarded-Encrypted: i=1; AJvYcCUWN4KLPKSYqmowrlUPOcTCOhKzdbV2f9UKKy8XjrRMQrIBjXyW8ZAVUab2x6DCD3CVj+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+//wdIcyRU9phxU2hdcBZSZ9R8DtiMXQCCifoY1VBwIxYURW3
	+AI9dXRwFV6TuMAx2d3+okWz8KDfN+6VylWV4Izg3Qxl7CF8v7gE/tZBb5anbtg=
X-Gm-Gg: ASbGncuI5D+TVTKmuU7mkfQl3VgxuqssMa+rsPy7Qyy/29hrkDEOQuTdfm8d9nVTpoq
	XNYg8IrYk1eEThEaoncc12xfVI7z6HR0GE8+Lam0W8zBwJiA61Nas20LYWudQdH3IurS6Oov3IC
	nFUJ5sMeQ0vl4tOPLo45p7FLjpmPj8sK46k3QRqI4ZPjj5YrSVDgVTgxuL61oZ5JE5U19SYFjfK
	1d6IeI2cZJzKZAhwCiKZFu+FOoVsBv/Yqq305H3CR9rnEG1opZLp3TMWqlpSvyWfkwe1nRuUzQI
	RO9thocgr6B3KnNqOeBByo3Dnw3eYxBt+FP4bWyZf3WcE6dWW1st9QRAecvet063W716iV6aagJ
	lo+LUe5I=
X-Google-Smtp-Source: AGHT+IEizPqXMalLaQpsANWhLbP5yYDSnFHw4NZQia9c2v8i7CH2qpEo3yLuK2W8tSkgyFV55N+vNA==
X-Received: by 2002:a17:90b:5486:b0:2ee:af31:a7bd with SMTP id 98e67ed59e1d1-30a7bf6ccdamr673874a91.5.1746471134659;
        Mon, 05 May 2025 11:52:14 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151eb166sm58715695ad.96.2025.05.05.11.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:52:14 -0700 (PDT)
Message-ID: <ee6fc6e0-2c94-4108-a138-920ec3fbf15e@linaro.org>
Date: Mon, 5 May 2025 11:52:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 44/48] target/arm/tcg/neon_helper: compile file twice
 (system, user)
From: Richard Henderson <richard.henderson@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-45-pierrick.bouvier@linaro.org>
 <7ff2dff3-20dd-4144-8905-149f30f665b1@linaro.org>
Content-Language: en-US
In-Reply-To: <7ff2dff3-20dd-4144-8905-149f30f665b1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 11:44, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/tcg/neon_helper.c | 4 +++-
>>   target/arm/tcg/meson.build   | 3 ++-
>>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> Likewise, I think this could be built once.

Likewise re crypto,

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

