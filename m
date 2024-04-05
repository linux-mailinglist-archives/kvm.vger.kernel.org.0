Return-Path: <kvm+bounces-13749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2971489A43C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 20:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82CC2844BA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 18:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D460C17279B;
	Fri,  5 Apr 2024 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+5Eg3rt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D83A171E58
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712342108; cv=none; b=ipviHsRNW32mnTMPijQE955YzIK/XQfWqfO+FmkzW8zvtKrDVuTiUt/fCAQIZQAAO7Tb95rkm1IypMmmDAziCGNXH+HemqIsljNdim0beDH6bnlzFdF2Lal7gkR/0CnQ9XoIfnTDK0ykcJwPllMACWxOAgQCraxtpCHiqpywck4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712342108; c=relaxed/simple;
	bh=6ZjefErhMfmeYuBEs1nM6MSn4jNdNTdaFy6x1mnwXpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k+cJVUFGP/U3UhDPH5cET26jZctn7ht0C4a/Aefhw1G3lM3yp1J/esGKB0q5Yo3A3LcE1a3Lm0BKtjRqkmLfZPjaLnrOfRGlhxOvMMwpzy6LA94BVSOccLT6bovhQG9M1HWnoycGwzU5cMW87qt2PZPbmDEHqzy8Rkr2McOmJQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+5Eg3rt; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c86e6f649aso24726539f.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 11:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712342105; x=1712946905; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qa9OWgSGHy86iFLsGhob6bEBoogAWHpT07UAtRblqpQ=;
        b=Y+5Eg3rtIe7VMYHiZr4x9lRDOR5iCv6ylQgOlmdxWHA1TFq634s31mPcYCe3pHO50U
         +y7Ym+WSNMZtaeUSuJYS0UipUs1FPTTt8HyWAhAfYqksxGn7chdP3M579DhWbFOFcWiH
         ziHV9/x0j8R4Nbfl60wkU5xzg/0E3n4vzq1DA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712342105; x=1712946905;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qa9OWgSGHy86iFLsGhob6bEBoogAWHpT07UAtRblqpQ=;
        b=kHLFUArck4TOfW44OkS4/jCLTnNDCs3IyO59nDMaSGaJ3ZbkC3hfw2urw6n1wORwpN
         dw0wb4kSyrAEvQ8SWvRgjlEpzrdW4bQkF7C2Kg5FEw80aDz9RQq9KEuIIKuCCrTWZW/i
         ikJ8iHOyXp0C+MlwsLDFuI5tySz89nIObcgy2GYSZiT1d+FyHaWvtgJ9tbsKDbF59KPO
         XCnzhUjhZIPiSNuhcPxu/Uy2CmYl/ulWrNweh02qPXoYfYkuUvXVpbSQ/NDNZTw+eXjp
         bJ4C+h7XbpaUGuKEhoEDsklC6QO10ITrlI/x0aBWPMBEzLqABdoqipzh/vnrhzCYSklJ
         D+qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwneX+gaFleq8FDbFACFu6dp/8ixmoyfyVronEibbUr/qpitIFQyc+8NYZdFo649EqcM65/bligaN6t0GsE9Qxc5+g
X-Gm-Message-State: AOJu0Yw7i7UJn6HKM0QC/Vvmq/vFFel+nRwHAklFeM+cgjo10uOfvT4L
	tq2hzLsuCtZfONGmIuUKgfsUdnd309rHu+6kZrqLxAwl3yDgZRa94KieK+rrWls=
X-Google-Smtp-Source: AGHT+IGtByH7WDW3n0zir30+zDOgj0SA2esTzdcEHOquB4Tj3nh/EzZ8FEfaoZ2efToARrGR3C666w==
X-Received: by 2002:a92:dd0a:0:b0:36a:d81:6f35 with SMTP id n10-20020a92dd0a000000b0036a0d816f35mr2112409ilm.2.1712342105467;
        Fri, 05 Apr 2024 11:35:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m15-20020a92c52f000000b003684d4f6b44sm574171ili.4.2024.04.05.11.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 11:35:05 -0700 (PDT)
Message-ID: <040f65b0-5484-47f9-8e43-af5316988c5a@linuxfoundation.org>
Date: Fri, 5 Apr 2024 12:35:03 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] Handle faults in KUnit tests
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>,
 David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
 Alan Maguire <alan.maguire@oracle.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Eric W . Biederman" <ebiederm@xmission.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Marco Pagani <marpagan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Stephen Boyd <sboyd@kernel.org>,
 Thara Gopinath <tgopinath@microsoft.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Zahra Tarkhani <ztarkhani@microsoft.com>,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-um@lists.infradead.org,
 x86@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20240326095118.126696-1-mic@digikod.net>
 <60d96894-a146-4ebb-b6d0-e1988a048c64@linuxfoundation.org>
 <20240405.pahc6aiX9ahx@digikod.net>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240405.pahc6aiX9ahx@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/5/24 12:07, Mickaël Salaün wrote:
> On Fri, Apr 05, 2024 at 10:08:00AM -0600, Shuah Khan wrote:
>> On 3/26/24 03:51, Mickaël Salaün wrote:
>>> Hi,
>>>
>>> This patch series teaches KUnit to handle kthread faults as errors, and
>>> it brings a few related fixes and improvements.
>>>
>>> Shuah, everything should be OK now, could you please merge this series?
>>
>> Please cc linux-kselftest and kunit mailing lists. You got the world cc'ed
>> except for the important ones. :)
> 
> Indeed, I don't know how I missed that... Do you want me to send it
> again?
> 

Yes please resend. I will pull these right away.

thanks,
-- Shuah


