Return-Path: <kvm+bounces-41527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09658A69C88
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 00:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8352588125C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578952222D1;
	Wed, 19 Mar 2025 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L+nW/kMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B815321C17B
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 23:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742425583; cv=none; b=PJ3MrJXiC+3S+QOr151BSgCRvxLHZ9RWrpLdIDm5cU3mptP1E7YAC9BXPMxebbV46OZ0EB473NNd3pphmgqpjiBYWVpXc0xK6X7/e7OVkq1m9WKI0hki19iHOJ7DivMmW1PgSsLLLJWb/86oazKfZ5a5izqei72mVspNwbS80T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742425583; c=relaxed/simple;
	bh=CFc/QsAbMl0la7t4iUuUoBsJrZOon/WXhrbyx7xF3eY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pnt7xAOc7FtCQyZG5XcrZ20p18lTu5IM3bfTbcSD0e3VAzHHEoBWLkWYj7mjD1S4i0i/z+qoJ74oDA+/sLT2I3jn4yo3u915DCTr6oorJ/CztUm8u4UMkIx6lumuSHtuCi28vG1GdlQs3nNtL1X6iFpiOh8EjKxryGXQuwXIqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L+nW/kMc; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225477548e1so1571695ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 16:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742425581; x=1743030381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0B7qZzLI8brQRidgeDupLP9VVQOT4B9SqSdemiBIJrM=;
        b=L+nW/kMcg6dERRSLpFjipI0SXuQF7jFG5UWae4PPw+DoT1Uz+GFUOt7MZUWr6N2Qm7
         QPyamU6VLlF81bWbW9rx954MrxYdi6KvH7WJsRnfhoGxHWCJktRMTTGPGJoRTVtWQNHe
         4SXiIQW3SXOQfhPTjBq63WHBXhzIFNJ9eYRzaVMPpqJz29v/XpWgOiyYShTQXV+NQhcN
         VLByzS/wdUUtp7Xmg/2p5Sbj5ho3JWAInxOA+JSFLnaiAW1cx84H0h4E3tued1bhXwGP
         cibJV16lIKlKm1PzAAcgrhf0pnKTPLTW7GkLYzpsmbRDMp4DMRZI4B4KpQhMMBX6cW9n
         +yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742425581; x=1743030381;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0B7qZzLI8brQRidgeDupLP9VVQOT4B9SqSdemiBIJrM=;
        b=ol5Luhckdk/uZ8eZ5PGObdTjCKstkkELGjiTJzeWAxnwphI3hYRibTvRWjT07d3+IG
         5gaAi3J+exMELjM7WPZiNYahzjCiqBD7KpbWm4lA1bjBsb67I3U/vEbFEiGO6U/pJYQZ
         /xPaXPgKhciZdzIFWMi+0O6BxDyjsOe1lSGF76uVYqGykfkJ1psbn/pJO/oWZgSBt3zz
         4JazktsmWaTq6iFiD4zS33/Uudnc6AqrmJDC/VJaL/Dy8mWLbD/WNBO+kCIMoU3OM04S
         DDW+sTCBt+czKD+Q8kuTpOdRK/lbct6vhtaUK3+mr+5AKltnkwCFTPSERtfm2KkLq6T/
         lw2w==
X-Forwarded-Encrypted: i=1; AJvYcCVH9JupS9bjxKhgFBQugvQ49mTAEF6hZ9SVbaW2Ap7iwfQWvysGvByEMtaJpQBegCgWQzg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6aIXdmGgj9JdJB2NX0XY5V3DbfHTVp1aoMrjybWVp4tsFd2eu
	rud7vIwvoZEV3roEaPG5aqpDzQx/tISwzsTivbmt1+SIEd+6vPbNzeoKCCZLmQ8=
X-Gm-Gg: ASbGncvx8IvGmo5q5lblTa48uafq2zcmgKds0I0mBloUpKR0xOiqI2M/lzsXbC8xKhR
	VqMAqZEJxkdjRQ9FHt/y+/E0FYi5Wx30c2WdkJXfkAw2VPPXucSUS5q3Opa/C/1lI8XjPEj7+5t
	oiYWKen/+trPU4CSntJy1qSAtgJTUKO1w8XMzI9hzlTSZkaKjGp2gqk43gcosGXxCWlmFY+Y//v
	tIXWPjRz3rTmC1z69nDrEWg4T4/werjoGJ552c/op6bFdAt0l+ojPXrfuxS9wfwOH+Zb7XX7dhl
	bGDhaYlnbkKIWqwM2A9scX4UARkebw6B7hjdm8m/x0giQwLwbhwfhxzmSbX8b+6TN6ni
X-Google-Smtp-Source: AGHT+IHtNH2/b50JPe298GmK9alO0tYGjRJ7dXzrqpDLLmEgohh2rXtZhg+BmTK0bW8zlb9NoYW0nw==
X-Received: by 2002:a05:6a21:168b:b0:1f5:5b77:3811 with SMTP id adf61e73a8af0-1fd10391437mr2016652637.22.1742425581014;
        Wed, 19 Mar 2025 16:06:21 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9ca18esm9770445a12.16.2025.03.19.16.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 16:06:20 -0700 (PDT)
Message-ID: <0845395e-f306-4fb3-bf4c-9723be4c969d@linaro.org>
Date: Wed, 19 Mar 2025 16:06:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] target/arm/cpu: move KVM_HAVE_MCE_INJECTION to
 kvm-all.c file directly
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-6-pierrick.bouvier@linaro.org>
 <f1ce73a6-717b-4230-95cd-45505fecf039@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <f1ce73a6-717b-4230-95cd-45505fecf039@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 15:19, Richard Henderson wrote:
> On 3/17/25 21:51, Pierrick Bouvier wrote:
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index f89568bfa39..28de3990699 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -13,6 +13,10 @@
>>     *
>>     */
>>    
>> +#ifdef TARGET_AARCH64
>> +#define KVM_HAVE_MCE_INJECTION 1
>> +#endif
>> +
>>    #include "qemu/osdep.h"
>>    #include <sys/ioctl.h>
>>    #include <poll.h>
> 
> I think this define should go after all #includes, emphasizing that it only affects this file.
> 
> I think the #ifdef should use __aarch64__.  KVM is explicitly only for the host, so
> TARGET_AARCH64 really means the host is also AArch64.
> 
> I think you should go ahead and adjust x86_64 either with the same patch or immediately
> afterward.  There are only two users after all.
> 

I'll adjust this for x86_64 in the same patch.

> 
> r~


