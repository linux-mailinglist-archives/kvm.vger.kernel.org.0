Return-Path: <kvm+bounces-45603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1482FAAC7E9
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B2C11883D5D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69E32820B4;
	Tue,  6 May 2025 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="coI/xIDu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A2B24E014
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541592; cv=none; b=YKYOTQuc/a6lhd1ZCzuyQcxdcNlcdQUCNIc8P7Ok4FSSe5mE/vu3elq0CPGf5AsiPo6XVNcZHP1jak8/19J9MyUK0mdNSNhNgk8WuKgRUOnFc+nHV6BzPYtrL75aUgORZzWKYkjwt50Axn/YmImngeJ1DDIrrfwJebVxTzuZqsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541592; c=relaxed/simple;
	bh=CeXfTtd5TFpFUJdJZ/lilyl4fveXt0aoG215dd9mdLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QxCYa+ZMbqYdXc0D+KZ+pbzMiaVcpvgORRJi/xiwtOSlGAu7PDEie66wzMx+Ak9BzGA+bI1TO668E+3MDXSY/1JDq1BHK7z9gyZnPJzsPaUKJ7RIDxRJzu08WoYLEYwNqK87PjAxCD2DWuuS2J0F3oq+Hz3KsRb89ME/n3aUSX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=coI/xIDu; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so5172666a91.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746541590; x=1747146390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y1IqghFIXeDNluBDDx8gRPCXaqN0Xsj0VQP/eJlEg3g=;
        b=coI/xIDuIfeYlOfIQEqYZ5kfu9KXG002cKYNGEL+Yz517QGfSiBlWqYBt9nnRtZ2vr
         /XvI7dRVOK8fzcYpRh6vHMjsl4nCJbNFB0mD38uwxvIjaNLS1nb0VRiYvj7FWvEFOtPT
         fkSnR0KmGEdIrSaFw8bz/iNdLSZnPCdZNs/10ML5aY+DYrDTNxBToouGHLqrizZWMYxx
         2RCV6DBjpjp9YzLZlLBIdwcHes3oH52H4CepFofn5fwaNPzJhv+3i8VD9+sl9HrgwZd9
         Z1qCzMGS3AARHPSd+uyi86dQoylrr03jIbzP+ZlCpwQQswvpqOf5rTidk1lENUpO31V9
         2okw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746541590; x=1747146390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1IqghFIXeDNluBDDx8gRPCXaqN0Xsj0VQP/eJlEg3g=;
        b=uk81PIsJ7kfyEUn89+/7lInyhNLRPBTOdhS4bW/uP50aeVG+eQlnKzirzOAptrzEpy
         WUU5930hS691YIKu2UlZ9KKK2kJ9hudFHZRogilxM8tHF9hMzC5XU47vWGQCmwxqqD9I
         FsbdAtcIz9/4mBlwg0E90cEFf5EcoGRRSd+0DfHT0lMk8MPuS/z6r7vv047adrJPGnJy
         CGK+hZvgadjJbFVmWZdk857UaSfgHZJ6QYbeXYP0jDjuqCfw5ii4BuLE+RmNEl+AYU/u
         xlAit1nIL1nO+m9tANbaVH6LCjFwdLVdtt21Tg8LX4Upmk59jTJwBhzujd4MYqLynQde
         UIHw==
X-Forwarded-Encrypted: i=1; AJvYcCWrc1z8Z26zCw0nJMduz+JMn++OkAb8VE9xaFzqTeUDc2GqKBm7VMeMiYTclKg1agCrchA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt/Ba9Z/xl4i2gmS1U1LTkIcA+ak+fAs8ttIg66NhPuHXx7YJP
	6Nx//+gmkcYxU/jyEBh2OnUbx9aoSLXgS6nIZHg4jspkwFveVAIpY2HR6CCR2tk=
X-Gm-Gg: ASbGnctazgt52/W6A8TLnpeNUEgLU6M6s6f9Ww70UnycG22fts4Tx2gbGalCYSQ5RID
	91skc4+Hh4k4dD8nQ1CJFSsRJf8CZBOh8+On9Pu36MZLbClv/uGfPeY6EGLBbVXNyBDa+IG5vj/
	FmPEUUfG2ndVcYL9tVzlpleADQv04Zlt54X1e6XXuDvrJzJbbb2+6hFKv1afEvEnM187kYI6vf/
	tsMlXo8AMWUM3X+QvNBQcJovWYGokNR0eiD/H2k39v/U1VgB6loVsjtunjrWMm3Cg/8Ej9m7gq1
	zig426dlmvKRfR/1R5KhR8ChdupHo4n/2Md+W0EG0qrutI+FPCo2b7+J0SLf3hItkHLSRvkxAay
	POKpTiN4=
X-Google-Smtp-Source: AGHT+IFIgZvtnDw7CrIZAa+bkM6EA6FPoMcZ5Jq6srtFkQTcuITa68hlt2YJPQbKlNaXH6f0U8pLNQ==
X-Received: by 2002:a17:90b:4f8e:b0:2ff:692b:b15 with SMTP id 98e67ed59e1d1-30a7fcca2a7mr4974599a91.33.1746541589578;
        Tue, 06 May 2025 07:26:29 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a892f4d93sm1181773a91.1.2025.05.06.07.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 07:26:29 -0700 (PDT)
Message-ID: <a2f65004-da23-475f-a6d7-fc99870dd126@linaro.org>
Date: Tue, 6 May 2025 07:26:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 42/50] target/arm/tcg/crypto_helper: compile file once
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Peter Maydell <peter.maydell@linaro.org>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
 <20250505232015.130990-43-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505232015.130990-43-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 16:20, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/crypto_helper.c | 6 ++++--
>   target/arm/tcg/meson.build     | 5 ++++-
>   2 files changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

