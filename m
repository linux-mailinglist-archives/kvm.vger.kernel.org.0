Return-Path: <kvm+bounces-60175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D564FBE4CBE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 423B2359D9D
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F113346B5;
	Thu, 16 Oct 2025 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j937UfbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455213346A5
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634668; cv=none; b=JovSGL/MeKBQq0x0V9Y328Mh/BXiQ18TYoj0RZlS5jFo9veAlN30ruNLuBZjBJGB1BBuSlwV4ldZ3IyNW82FTbvKfPuBD6PfQggME+jilyQ4+fZHPeUSygvra8RSDyp+VyNfp7y03UTsLm8SEd3WSf9OuDzE1ocg/lyJvinW1ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634668; c=relaxed/simple;
	bh=BNySWbUNMfg9xDO5zn1/58eWf6iCqvEMSwfuqSkyRnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LiaYLdOjJXJdkyKQpsyY4VpvFrtb1PXxloUpnaShL1djXW29vidPwrWluu5hJPQ7o2gRjj0B30yYbuciR3rSQVMbSM3WfHjyNK5Tt/fyHTsSsNt2whQBGI9EOZSY4uK2/Vs6Kp4xBVpZgXELV3imLdVl+QBjDqRGPm4smsc+dY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j937UfbZ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-781251eec51so948173b3a.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634666; x=1761239466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K39YbJ8V0SFQMeOuwPXO7YyEdomsHJKYwlcAPQMmelY=;
        b=j937UfbZoRM8y2N7VHMYjwp04wLmEqH1vsJCkkpJCOLG/V2qOIAJ8Dr/Dtn4z5L0Ns
         6W4gAMutDhok8M7NulLUpDAzazpxsJiiCd7HxH+4o9Z87tF5BZ94olKI+BaiOM93rq/c
         FBMX2dblFGGnNiz/tcO5GM4iN2IUHqyCzNCh8u+uZqVahmf44Y3pX8FhAKi4G55Nga4m
         xgVmh0aPWdnz5HUWFNJrR2tX1xcRCX4CRzgyQxxhfXx3RpbSv8BsP0C84dknv68M2gX0
         5mIPQwQY+9bp8VesFilNxhA73/qkGRHHBB6uUd++QYVgnyRUEmQlKqpKr/CUQEfsT7k+
         6JfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634666; x=1761239466;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K39YbJ8V0SFQMeOuwPXO7YyEdomsHJKYwlcAPQMmelY=;
        b=anQqxfvmY3LrJhpGlDoXqXIUFPDDokYMA0oVqS5UEpB+3NbkCX51KATfHP8Ofq/uZu
         MwaY7liyL4ZiEC6KH5V6WbG+CnwrPRJSGbNs/xCKPjKpsDQ0qqUn8LPxomlX122Quo3C
         0LY6HxpJhn67K9rbYL/9UCUaxXT8PYkWeBrbLCK2v7NhQnoCcUG8X5keDZJc1WC38kd9
         TyxQq3W0zSyyDsUw3wBgm2dLOyBQuRoyHHWxrTPu3tQ+JUbopo5Sc33KCoGb+YZ6WHUz
         /s+unKl/E7ezdsUJD+Y4gyN/oYXaaTC0qWv3zr/2qKYTLuuBztuJDGI9hjg/A6Sw5y92
         GX9g==
X-Forwarded-Encrypted: i=1; AJvYcCU8lHCJTTnEdfPt25EHg3t/vDFKbU2JUfM+/6vLDIb+vgCeXBb2Swx+fxZDJ0SiRUuyzMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjbXa1qrxdqyX+bqYdbDiVZQmtx71M6QHr70I7Vo/0keVgJF45
	/GNyfNAoETiATHPXvl3oaPJUyqKk1OEakvmNxfCaphxC76LFl/4wWeCJ8VQ/VqkjRE0=
X-Gm-Gg: ASbGncvK8+iXhg4V1AEoBPltZrAtdtydamwmDAsUx+KIcQGMpqaIfBwTR0Dgoancj2k
	wXbuZyCM3SKG1GV9SFd+hv8kRBxPqtXwFbhiTEcbdehL+zsyZiv2+CT5p5YcIv+e2jBvwnwdzxz
	OWRkPtbfmgtPG/HlYGRdTqz3n0MmnKxLwT9NEX11GxLItxYY2uGdVBoQRARqUyZysgQgfgSIW93
	5CoyWwUwMlSz0VwJBzmPBqmPO8/21ti5g4MaishfCm7d4o9t4yZfCuMVSO4TCvLh3p9wc9dCyKe
	VT9SNW5zO0RBPw090uqDF+B9OhFOKCq4yb/RRK7l6pB/DhZN/WYu5hsJFVR8GS2KWa0zB28R+Y2
	FZwIeTukvovQOu0QM/UrXSw+KbtuK1ZYxy8tjsY6ptQbJMx+zRjLZKQpxiTuDELYfG8gUKclS5m
	lBuOMS8kGBxd+I
X-Google-Smtp-Source: AGHT+IEVtlrZhg/XjQQtIqOB96+jdcBFExfh4wze5+8/y99XoPAXoumLttosjY3oO+kv5n+KGFMDlw==
X-Received: by 2002:a05:6a21:3399:b0:32d:b946:dc55 with SMTP id adf61e73a8af0-334a85398b9mr843561637.22.1760634666520;
        Thu, 16 Oct 2025 10:11:06 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-79cf0a052b8sm14518427b3a.67.2025.10.16.10.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:11:06 -0700 (PDT)
Message-ID: <1de38eaa-28f8-4b56-9673-624f6c9b8b10@linaro.org>
Date: Thu, 16 Oct 2025 10:11:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/24] docs: arm: update virt machine model description
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
 <20251016165520.62532-17-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-17-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> Update the documentation to match current QEMU.
> 
> Remove the mention of pre-2.7 machine models as those aren't provided
> anymore.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   docs/system/arm/virt.rst | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


