Return-Path: <kvm+bounces-60478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED94BBEF696
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B33D13BAEC6
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF34E2D12EC;
	Mon, 20 Oct 2025 06:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="amdaBoww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367AE2BE034
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 06:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760940489; cv=none; b=kIUxrl+g7LjRvXomzN1DZhurV4PWwr5tA0yYnj1z8P9vnBOjrNxoSAfoEf0OOGJZBX5H1EDq/vgFK2goJhPN1lv/p+UEK/4/CztCL42FDkd7+AIZY5VW6iiSdsRgKFN5XmhNmwtCIYi4kBZ45fqBT4RN0xhzuAe/SOvUzLDZau4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760940489; c=relaxed/simple;
	bh=hGsLKgjycVvOLPSA2attqM7qEkYaoAMdXm2cgr+5CSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnC3g/3SZfhsaCOz3nbifGsIxcS6vbGFqKcBvEYB/+nylOjdmYqu/hi9stxNEhtujdE4Tjm8NYppwTYC9U8FAw9mhgOcjEQvPs48eT3KlqAxfs5NzjjvO1xJwH4KfGqOMQVM+0iQ6GZ+yDNSLBjzpdXX+3wVKamg5bu/Jv6yGtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=amdaBoww; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-426ed6f4db5so2642067f8f.0
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 23:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760940483; x=1761545283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZwHQQYPzgk/Oa/BCwkfGIIoOepu1MaY1kSob23Fku+s=;
        b=amdaBowwwcDh6BTckHnCwDPcNKMlYxV3s99LM0ZCh14EphC+nu422hHQB4WeiGjvRy
         p1BBOcODI+AcVEcSx1Sg+/wTr97ICSAsNZlSX7XHp243XfLTrulJ7PjjlDeqfvpD/eUC
         R/2wwPZZukM7mABMRaLgCzgeOlN3NpwE9Zm5ObKYusOwljXEnzTrF683LmDYleyVGW1E
         jlGSuLfFmqfoZx8B3X1tTjBiqVLLHRBg9j3fE8WGln0rCQCzNlKZL1dEdwSXkR1RxMmI
         nRodKJNM4jO0qoXlwQsRABTFUWB8cYAMYrKKUNC6Y7Vyinu4o09lCEAs9GZKzq7gRQcO
         OPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760940483; x=1761545283;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwHQQYPzgk/Oa/BCwkfGIIoOepu1MaY1kSob23Fku+s=;
        b=JqCxvX/nsJSXUiA069RU4h7cW8rY2rSiNLIXlIt2Tzw8zUmnornUdzRKQjyOdkO9LP
         K0DTif+Wx3RozMXmkHFbQcX2nhyV5GkGVdor+HcxbIZBC032bZNy2uNe0jVo9RJ2czNM
         JFh8C/7ukh+9eQb3PeFHsBwNiIJsK3//MwMieTUqlAKMl034W4VnkwUetxn6kfuAWnnL
         EOroA+g3u4AGXHDbjZ/nL7qN/rSvHyky9iYC0cgjsMZ26CN9V9gO34r0Mpu+3H46u1D/
         n9s+4d2OnY+BfiZaETg/zJMxoP4jXf49IdMVIcXm88egi9j9aPWwJ6N3dlsew4QWoAhk
         aAew==
X-Forwarded-Encrypted: i=1; AJvYcCUMOH72UPzewSHrBnM+2J2e+IBmGzYtj9YVq52ncKFcFh/xthDivuYrFgWQscWADfOim9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YypuQOUqSxfwrjwkyOnHVF1Ferio9RtDHuYtxTGiJ0Cz6cqTDJT
	8C+CbY5wsNo7HUjlDEqahkWgN55gsjFNOP1HkcuVNsTSDvAP7KyCbwnIAdhulPd70+0=
X-Gm-Gg: ASbGncsohUhqG6uPm1AfGg3dh2ZhAfGXAuShX3ocKOf1k2nEProhXJ4XykN1NFF2aLW
	+IVWBcZ8zD+T9DxEHUPSmssLdkAFEuKrKVrik3BYYYTObLG9+Ybwb5epSFgMAyeXG5eO5DWZCrG
	V3ZfOCrrACMXzsHEB1NXCwRzAk6x71HbTuULICARTPuPmRAb6xvoPxMqr12uT5195+HqEShURor
	IMNGK3DJjpldllbDWqc/ljpBjOJ9mifUQb7GBU2bhdr4ZPAnver3pz/PMyAXPsupOg2wE99kwwg
	n/SHQuqg8VhDib7VNa9YKfwNtq3BXh0A0KhdbMkINgoWTk0LWOoCa7MekjEwskDP+LrEWPWzBUo
	gDgb6DnI7Lkm+4GIhRyCYNBc5ApEJi09GNJpPydgW5O6rhYh4yLJ1oydq1ObkWvnY9sl3geSOdz
	NShrmaOEOu6q6MbHZS2GsEKeXG2Fvpk3L8wxMbhXpzJZ7DPxeaw3iKfw==
X-Google-Smtp-Source: AGHT+IHjUNCCBhruE03uT+DvimIwUC22UlsWHmljQFlz6N07Wo8DHb7vK09xeZ+F1g8Aw6DM/S1xhg==
X-Received: by 2002:a05:6000:4b08:b0:427:55e:9a50 with SMTP id ffacd0b85a97d-427055e9a5fmr10418916f8f.22.1760940483383;
        Sun, 19 Oct 2025 23:08:03 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a78csm13382381f8f.26.2025.10.19.23.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 23:08:02 -0700 (PDT)
Message-ID: <4bf69cb3-b394-438d-8f86-eebb85f8280e@linaro.org>
Date: Mon, 20 Oct 2025 08:08:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/10] hw/ide/ide-internal: Move dma_buf_commit() into
 ide "namespace"
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-7-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-7-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:02, Bernhard Beschow wrote:
> The identifier suggests that it is a generic DMA function while it is tied
> to IDE. Fix this by adding an "ide_" prefix.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/ide/ide-internal.h |  2 +-
>   hw/ide/ahci.c         |  8 ++++----
>   hw/ide/core.c         | 10 +++++-----
>   3 files changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


