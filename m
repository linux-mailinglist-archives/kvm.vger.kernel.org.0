Return-Path: <kvm+bounces-8209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCE384C494
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 07:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A30B7B27679
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 06:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E241D1CD2B;
	Wed,  7 Feb 2024 06:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZTm+8dBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565811CD1B
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 06:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707285656; cv=none; b=SwaRM7oO/MVgFlrAwVLKgW6tLACE0VGtLg41OWWRKjSPAMOcQseIdx6MQ/MbA2OLmIvvS3mYC41j7n56I9qL2FYuRtOfyNnSCmHfuMHhLKTHtiwmnNHJA46j3FtZkR9sSjOuPJ3dH6MU4aUKu4oB35rKwY/rJiRSgGaq79AjPIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707285656; c=relaxed/simple;
	bh=zR2nlrfbCKLeUBTLm8BZz1K6BjshVdR3RMIVxY5J4Zs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VcsGaAd3h7DyZrjqec15Ig6tXVyhSY7n+OGsQYBZrzx51dsrO/LXteJ0hShZUmi3yuGzBAiy4pzNSS7yTkPZ7cWug+Cgi7ql0y49AMe4j2/34XkZCDw8+OpenRcKIdvqx2nJM9bAGU+DOz6z/dl/6PsWMsawoXRl5WclJnF0W9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZTm+8dBP; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a2d7e2e7fe0so48304466b.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 22:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707285652; x=1707890452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2PdZRQZrV1iRL9uj91XqvnzzUKZBCaWjr7/54DWT5QY=;
        b=ZTm+8dBPzeYCpSnnnjiu/xEDXW6qtkIBDp4PeIEM9s0Gn+elR+i3V0pypSrOAsbty5
         SXMzwvbJvs2VNT5NFgh82aXXHZucJa0QC/Qo+/2loUpuK7Jmn4lDQZshHc8+nvvmFK0U
         l/9OMV/UXdVtKzekQzQD7J/HTli8ZbeeCWqyIzsCkIIUumrsVWM4UQVnzsqS6qjSvZfm
         LZV1+yOR42k3H86c4OnkH+7rkGL10m/xKLMARPP94fK4I1UbhhmNqPHJxxvPLW8T600M
         xnidGCYTYB8BzqmjMDYE+Zd5698iPA62lIaitsi2TmkUEyds/XnXD5KAjF5cnt2VMPPo
         ZTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707285652; x=1707890452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2PdZRQZrV1iRL9uj91XqvnzzUKZBCaWjr7/54DWT5QY=;
        b=HUSXJOQvSDEVjQ1S0fGmb3vQmV6yl2m37WpsAe1DsMvKrmCH2HIkX3cj9eyBxfUems
         b0iRieFvmbrpFzO57fh9MQT6uyu6jppy0H+X7vPzfMZ8V0HaDvmCmWpI79CmYVzdevyv
         LXGutJvJcmoc0a8Q5BCaWqNzsRm2RSP0SYIMjPCTvOI6BIR5ZMEH6+Dce620Qkoq7J8y
         8gT8wu3XZ570yz8DQClgJwcjvkCIt4nNpq7xDiz4Sv4Hpb8gCBLdXjmQ+jX+ysOiJCke
         /yycjEE1z5ocH+wP4tIjAEyJTKjnMHDnaSrPXvOAxJR1cRpccoZb6+J1kQ9Z9p+RoDsc
         wSuA==
X-Forwarded-Encrypted: i=1; AJvYcCWyc27ypEAjKxHr5QWW/PgBUgQrbPnkG61yUOZypdQpG4Tgxg+M3lqkDhk9sjap+/lH/L1s44awYuvR5x2/YnBnRGAo
X-Gm-Message-State: AOJu0YyLAfV6HiYMvjGfBRINvV8fGZGBDBzMkiPvIZF9qvl6RqjyptkQ
	0A5V0oc3taR/brbDYG+y1vmXel9y5pw/tEVUNQM64HwTpmNEpmb7xdWZ0JnoBv9hz/V8Ttmanrp
	h
X-Google-Smtp-Source: AGHT+IF2tNFW9eK8UTv5s68PzvbbyYPXn0kRif1NVpn9SLDDNEMMuqZ4QrDB6vIzVqGz3Yb2aRoZMA==
X-Received: by 2002:a17:906:507:b0:a38:5a98:3a8a with SMTP id j7-20020a170906050700b00a385a983a8amr1814285eja.30.1707285652606;
        Tue, 06 Feb 2024 22:00:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2ZlchI3VIK6aCNFEb0aXAydCir687lTS4bJ/uXEBHx591UX6knxUTbYCFo5LIv/CCSDQ+9PJ7GCVEZ7rT0PY3vfSEIOWq7K5SwkzLczioUnndgiIxUT1WekvJlOyJwklpJY0rdsHJiZuLmVXmDwbETyZKbQR6FZEo3j5awRR4MwhmdgL0YDk4fP635wVwlhNJe4LnYog/LqysJR+q3fCw6b5Fs/vcFI2jRIe7bWkxEs+dYF3bpmZ8w1TLXd/9A3vXoc+Ng84ciS+AwG4C9E8Y/63W4ErUVc3Krb2YCnInyCO6dyaO/uRuAr9Zgv6FLxkk6GlqdEyZGTbk82u57bk6RPUNzOBF1Nc27h1C0owA2whojL/RZEGof7Ww0ssQ/S3XTWC74N6d41F25kCyH1f+lEJ3zSIk0oty70mV3oPky5m8yzQigMyFudvxFD/lYYiGZ9ixxC5C3snZ+Smm/A0hkpBwbk0BtMpfWBFeLZe+N9r7w0IqtLa0Z0rQrLbqSwfWxvrJE90RPY79K13FfLXqO/M=
Received: from [192.168.69.100] ([176.176.170.22])
        by smtp.gmail.com with ESMTPSA id i17-20020a170906265100b00a38576aefabsm353945ejc.161.2024.02.06.22.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 22:00:52 -0800 (PST)
Message-ID: <7ebf479e-271f-42a8-8df0-f124dc481dca@linaro.org>
Date: Wed, 7 Feb 2024 07:00:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/21] i386: Split topology types of CPUID[0x1F] from
 the definitions of CPUID[0xB]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Yongwei Ma
 <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <20240131101350.109512-11-zhao1.liu@linux.intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240131101350.109512-11-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31/1/24 11:13, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> CPUID[0xB] defines SMT, Core and Invalid types, and this leaf is shared
> by Intel and AMD CPUs.
> 
> But for extended topology levels, Intel CPU (in CPUID[0x1F]) and AMD CPU
> (in CPUID[0x80000026]) have the different definitions with different
> enumeration values.
> 
> Though CPUID[0x80000026] hasn't been implemented in QEMU, to avoid
> possible misunderstanding, split topology types of CPUID[0x1F] from the
> definitions of CPUID[0xB] and introduce CPUID[0x1F]-specific topology
> types.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v3:
>   * New commit to prepare to refactor CPUID[0x1F] encoding.
> ---
>   target/i386/cpu.c | 14 +++++++-------
>   target/i386/cpu.h | 13 +++++++++----
>   2 files changed, 16 insertions(+), 11 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


