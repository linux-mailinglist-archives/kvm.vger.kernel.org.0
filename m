Return-Path: <kvm+bounces-60172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11571BE4CA0
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8947619C43A1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533AE3346A9;
	Thu, 16 Oct 2025 17:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HnXM9M+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC59F334680
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634597; cv=none; b=LgUBRRw3yosWCqiG2qktsDMqAAj+OGXgUKPHyr4idHqDBOOWxkkDFvsM5qn9o5QksBFtjEGcK/FS/ulby6b7TFmx1SKj6YAwyFZg+u89Lr0S8WY4c8aPGN+YkFSUgLvYQa0R3pKs041YTpp+7JQlMYczgfJa8IFJWfKryusKIMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634597; c=relaxed/simple;
	bh=OV5o3yNGwc3PpzbnxbwurpGgW2cDqSOcGMQrrGJuy7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HRppUbT/KXJ25try6/R7MMj8LBXVlt9mVqtvX3TgNmLbwff6oJXqr6D/g3xfHUHf94gtFtWfqQDEOaPSxfntUDhhtfGN6ahtbWYin25TRKzdSwKMsESr3zZA+MTmEtuKlp7GuvQm2ImRo/DpZv5PfAaJQiRT9w9kSUhFWagsvgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HnXM9M+2; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b550eff972eso659090a12.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634595; x=1761239395; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EOjz/c5wST7NIv48Ee5SoeyTWulVxW3RZCbLrT8nAI0=;
        b=HnXM9M+2SYfUX/qKrs3qP2f2YTSwRJBtkQG2pFYoOxfS4rM6TJW8mThQBI6Ljdnb50
         gQiYXNWl4FCXKurUwGKlQYpxWRTW/UfAOG1tEAJpmkBJYkZ2ruv6bJz428VsOoClTmNV
         QG/9DBonAVu3juvtYVEtQup2k24tYlz2ltdoT/p/G3NFgyYdJ2S1yADe9MQw6V5KnXiC
         zClUHWDkSPRwS9EsuFyhiZaLQkragdxcw3KiWth0ztQEQd4IKINUFY79RyQy61ZEp9gC
         8fqjvdMSOne9eeJ6rX3YqOjkVhv1fpS36Ag1MIoy2JECN++gC+uD65R6UNzs52f9DQju
         wZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634595; x=1761239395;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EOjz/c5wST7NIv48Ee5SoeyTWulVxW3RZCbLrT8nAI0=;
        b=dW8cxNxZJC2MqzlHZy73G4ZHLVysfhZMrlc8ZtMiv+FW1cCX2eKJaY7bv89o06xhRU
         ZAR/eE/C0tr44CY64fOvAHH7sUKNU2T77D5SlW/LDD83CCnsbVj1sRCw0Bcp9+p8iM2p
         32o5G1cD73Ps+q0bOCIFHvxXDFTWuRYgzMhRUSPHAQhvgNZb7rERhqPFTkujv6haZVHD
         HjmfAughtSbp40KsfOQjLvKFBTwQgcM8nAgSFksxAwE+OCOrzjlV6g505YqmowktBSiJ
         Re0XvBI51cDt2epIObbzcQWW+nMXUeYZahuWa/zxfeuyWsjVLwepzGToYW43/Sgnuv7c
         hC1w==
X-Forwarded-Encrypted: i=1; AJvYcCU93P1BEYe/CVkrj7Fq41jySgXC9CTcPQoFLEuWk6r56vu41w0/lxnTLpOcyuAWu39rYOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpMsuRmVgyveVZfpsDAECigT3qTH3QjW4KMNCtVclWTgjHs7V3
	XL+d8IocJeOEpp5sMngUnzYGe62ty9SO2/yUaSOCNPugDdsh48W6WYzFTynSMXRNqfI=
X-Gm-Gg: ASbGnctmwOp5WNlU98r+tp5oPqAu4SlmfdYEX0vZVvyaXIByRsFbM/J89wQnd3F8qw3
	wtIDGeRsS8N1V3rBTSIEbFdswipSsQ9Mn7v4sl44jgnlco3lKlYllupk10z9nstMow2P+BkciAq
	Nf2uN/j9UWohxVf8sF7LNwbdWNSkxDIh0mmxSPu0KtId/KDr7fpSaevx935hccxcpIuOr0vq89V
	CkqeWOHVD7yrR9ZrHde5kVf9bC+vywzhBQSgr6kshfNQ5zRHPa8K/U77LMlRkJWQT/Ibf6Yx8Li
	tyxzLIMl2J7NYFjI2glmAZwxcBgE05SowfbZE4UGXXiEIMz3ZjqruZUYsW2am+mM7AFKL7BINnI
	6A37S3ZPEU6CLuZtLPD7Shu/dW3CqgakG7EluI0j8XVp6z4CaYRZCfFqBXMYVukcAxUZGb7B7/O
	/FRQGnzaQCCNvx
X-Google-Smtp-Source: AGHT+IH454vksl/nQZhrGv1L+yzrcpI+GW90VRdH1Rk/iZLfB8lZDs+K/NIsBn3ecKqThpGf0V9tLQ==
X-Received: by 2002:a17:903:19f0:b0:249:1234:9f7c with SMTP id d9443c01a7336-290cba43817mr6208675ad.60.1760634594911;
        Thu, 16 Oct 2025 10:09:54 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099aba4d3sm35792775ad.83.2025.10.16.10.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:09:54 -0700 (PDT)
Message-ID: <d0426753-4ce1-4e37-9086-3609164affdb@linaro.org>
Date: Thu, 16 Oct 2025 10:09:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/24] hw/arm: virt: add GICv2m for the case when ITS
 is not available
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-5-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-5-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> On Hypervisor.framework for macOS and WHPX for Windows, the provided environment is a GICv3 without ITS.
> 
> As such, support a GICv3 w/ GICv2m for that scenario.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/arm/virt-acpi-build.c | 4 +++-
>   hw/arm/virt.c            | 8 ++++++++
>   include/hw/arm/virt.h    | 2 ++
>   3 files changed, 13 insertions(+), 1 deletion(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


