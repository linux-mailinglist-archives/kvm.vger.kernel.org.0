Return-Path: <kvm+bounces-59531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 178ADBBE754
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 17:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E71D9188FC14
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 15:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63EC2D6E59;
	Mon,  6 Oct 2025 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L7RvejTc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1569A276038
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759763652; cv=none; b=oi7HEUFlvnQ5AmFdM+UK2lkleFOq5BXvE09ovBMHH66h0RVfQfyhH7HsENRtFRFhCCu/Nw2nqpDnQwlN3PyekzyDg9oSB8qSgjSZhBAPt6kzO8LyrMjncLm4q5GY0h5Zqo9CmFFP6k3Ja6KKQuSRbD30uLe/VbF389DZL7tukic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759763652; c=relaxed/simple;
	bh=gAKLcpMp/P+so4NQ35Bc/lZEJsMYe0gWw+Y2Njv/ZZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeqZGSnAlUVhdkYiraIr/CKGZfoZEBhBODrOxqWVWHmJN3nd6ddOnSWItY65ISly2nH62LsOpMgy3QVsDjPgqmHGLsraM0jr1U9hc1nno50XgECaWpOmbC8T9L92oncIFNmZX8HvONGnsjPfX/kJBmspwxd3+J3TIcWnAkuM1I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L7RvejTc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso33531495e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 08:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759763647; x=1760368447; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NkzsFlnEIZ6aWHV8z7vfrlidUNvMz/ENDqtv8YbKV4I=;
        b=L7RvejTcqHe6dQ2NXNvxShLGWVK178ylE+xq5awSR2p7jRscxUiWWCuIN/a31HG+kx
         Honfx5wVdHkPYoBDw6ZFElM8HMjAXUcq7Hbys9HRQ3jRV33wfT86Nri0O4jqVQ1a5As5
         7CfkGLSg5zw76AFoMxRtcxbYXKjG1YGg+1jhFeMZeI4OyRoqZXZ+91Z1ALYLJ0zQ4y3k
         f0FJ1gOD7ChK4NcwrFIVwk2wsVGlwFiHujILyANzc/LtvMep8rgZeWXiFdmvUy81rT1d
         SOazeUpdBe+s4/jVCFbfVRqWvpyl7bw5SVdxM2onzbBQAY78yMJyjEVoSaX2LDhZf0YA
         FwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759763647; x=1760368447;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkzsFlnEIZ6aWHV8z7vfrlidUNvMz/ENDqtv8YbKV4I=;
        b=pl65kdXAyFkv97/kQ1PBG8Ee8KhzPQBVi5DSpeVogTL2LFXBPr0I7PAqwtEeQ/8QcX
         N3qFz4IYaKvRJq5Znv0POgEavC1varHn0EkiRIsrdfmrzqmnPWJeyXyU/lY0aKTjDfc0
         CRUEzSq9Dtdg2YVA0I6DY8b4GEEwKPIqjKkg3qgHLTT2ifJb8rw0kYLOjeVDoub9fMgk
         GRz4019uiwbd4UAGWLzdIiMSCVLmrhz39FBJ/2ylc4Pg0nPk0Zmv+0rdvUrV9VJ8EFZ4
         fxUlXdClbGwZagDxof85x1pC5f5lNe3EBx5tg2bK4FZ7I+8n+hkkDQ4GKs1GqawRcHRY
         QTcA==
X-Forwarded-Encrypted: i=1; AJvYcCVvfo9L0goIsjhzhQP4t2j32kUc8LKhflJeFOj2fAy8l4KRqXpiGOqIiuT7KhqOa6gqaWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvXZuUdKZ8lV2m+NbWPCGTtg/GKXQqrx+DMCDHWfppSvMwLr8z
	bQL4ZjS1ilvF4VbEZ02cu8mPVWMJ5s7RIeg53cp7GpP+XTj+Dog5JzdCBFepxxdmSyP+9oRP5MU
	okCJmG2IkFA==
X-Gm-Gg: ASbGncum1nLrckCnJz8krkJAHqmwhtkA+59I+/AOG9n+yyDgf+0q0xjGOKrsXSoyt3K
	KkEwHd1nq50SU0E2YMRjP7x1nA5eEkesYvp0iSa0IdCLu7utmPvkacZ/bfD6pFVWg9mUbb+iJsm
	tPIMlTgXOz3m74o9c420iF7qDUGCqd9cVEgyyMCyW/s4TOJsh4jGCFcn/NgpV7NVJZxrMvef2ER
	TcSK+vYZn0FUqJeifquC29cnxPFtoYaODL48PltKS/MEis0V1ErHZFh81EcnsKks8mkyQwQsk8M
	ZIlNXHBVOKj0rVd0nCYTcNHHhllR5dWFxdDQWU7/b4dFf5cVY36SnyA17OqLuKGQTLb9jabqaKU
	jYS0wjayOkL/uKypUiyKnL+a2BTDXFtICgvRjpZeqJY0yLr+qtvvNlCO2ZCGA60MPLLC8tQADYH
	3t89PcRZyKb7Tgq0CAi2uy9sbytaf6
X-Google-Smtp-Source: AGHT+IHsqTtu/nz4TrQupljwIK/Jnl0R6AC8dkChAQLHq7NV4Z1KP8uuuVsOqMu/UlgPY6Oopw7PFA==
X-Received: by 2002:a05:600c:4510:b0:46e:59bb:63cf with SMTP id 5b1f17b1804b1-46e71140be1mr103691265e9.24.1759763647287;
        Mon, 06 Oct 2025 08:14:07 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723591fcsm161818555e9.10.2025.10.06.08.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 08:14:06 -0700 (PDT)
Message-ID: <d140d66b-60c3-4a21-9c96-7fde767cf900@linaro.org>
Date: Mon, 6 Oct 2025 17:14:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/39] accel: Move cpus_are_resettable() declaration to
 AccelClass
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-14-philmd@linaro.org>
 <78f4e026-9abd-47eb-9540-656094b19762@intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <78f4e026-9abd-47eb-9540-656094b19762@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/7/25 07:36, Xiaoyao Li wrote:
> On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
>> AccelOpsClass is for methods dealing with vCPUs.
>> When only dealing with AccelState, AccelClass is sufficient.
>>
>> Move cpus_are_resettable() declaration to accel/accel-system.c.
> 
> I don't think this is necessary unless a solid justfication provided.
> 
> One straightfroward question against it, is why don't move 
> gdb_supports_guest_debug() to accel/accel-system.c as well in the patch 12.

gdb_supports_guest_debug() is used in both user / system emulation.

> 
>> In order to have AccelClass methods instrospect their state,
>> we need to pass AccelState by argument.
> 
> Is this the essential preparation for split-accel work?

Yes, but also the aim is to better organize and clarify the APIs.

We have a set of generic handlers that work on the AccelState context,
regardless of vCPUs; and another set which works on vCPUs within Accel
and must get the vCPU context by argument.

> 
>> Adapt KVM handler.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> ---
>>   include/qemu/accel.h       |  1 +
>>   include/system/accel-ops.h |  1 -
>>   accel/accel-system.c       | 10 ++++++++++
>>   accel/kvm/kvm-accel-ops.c  |  6 ------
>>   accel/kvm/kvm-all.c        |  6 ++++++
>>   system/cpus.c              |  8 --------
>>   6 files changed, 17 insertions(+), 15 deletions(-)


