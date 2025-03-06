Return-Path: <kvm+bounces-40256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FC0A55073
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DDEA171587
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F541212FAA;
	Thu,  6 Mar 2025 16:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SAu/CDLE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D3A208973
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278199; cv=none; b=W3o9IVucw/pVSLnFKcu5LOgAhjCaknyKpdEZycAWGcJWRleCE7CQ92uNSmFz1lzAp5cj880cHMWSVko83qwoEqtT3mMnZACsoTp50df1ucmviy/bYlUxkork7ZHuoYya1FFCI9MygL/oxKn0agP4zKk0OmrK4liXQLOdeXismYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278199; c=relaxed/simple;
	bh=yrQcYWG5E4P+ll3FqTuwnK8/wWZWg8VhRLCxv/vABrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKL32Om8HqU8oe6uNuZygCyQqIgMHMzptAtZmCJg23ZVVLwjJBUEDUBjK5CzMlOixqRwA01IIO0z6AmEK1O7rTkjpg86pzc+eGiD8d9OOZOOI4pC/jqFyFOz75UqH423BeyPGiRCvhvlNR4kbgvm6OeHbLnWAytOfIWdCiTN7TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SAu/CDLE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223959039f4so18254345ad.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 08:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741278197; x=1741882997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6PlerNKSjJtX4hzeX+y+ge8P8T27t3fwfERe3UKI/Q=;
        b=SAu/CDLEpgrkcjzGmOlpBkQd7hZ8y9tsVKj+S7eNZpDrTGNP5rGnA55/8iPB/9+hsX
         VghA6ipvbIP50QkC5+pgKlz4nMmap/uaWcdzsJanfethMl3EoKdAiR9f4x60h65k1Hsn
         umUw56jAHXAMa2rW6JaYZIpEddNEZFt9fWC9m7NL6t7aqeb0jiQgUD/G+zZSZBlqaf5/
         E7J+X7+mQq4WMJrYCh1FjfPpGZZC9ABU4zJG04fVONug+sJ+xUv2fOVbvIIIrMwOMBY/
         HDWgDLcAQ/67+JixYM3DlMedebE6NiwpEpXnhtNsTc23iofkzI13CM5HDvpeb02mRWXb
         UbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741278197; x=1741882997;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6PlerNKSjJtX4hzeX+y+ge8P8T27t3fwfERe3UKI/Q=;
        b=ZAM2GCD5BmJeaDM+mUXvQuCzBm+npW3zRjupGQtgiuQZOLDALlorhXClylgLAD8Ktt
         gGTZdqm/zRQ+DY3OXTA2ZqzsmkuXpyb7qePDzp/UxS5X5FrvXDznW8HHaBmT/iSYxGde
         P1lwVI20CPPFAwi2KXEkVI9AjHht/1QLrPWHZEjQoBcYfUxEoOIaOy4O3JfZ5ngIR3bs
         kKhHk4p8Nig+AS5dkgPvlIYVWMKluSfOmQrZgvh2wOiyEEHZHr5ov4UVRg/Fh9bPc4Hi
         6V0ESud55Fce0lLccIOfe95oHX4d2/x0+S/6GTwL3V+/yE+3hDD7bEhwahqR+ANES6HL
         Vb8g==
X-Gm-Message-State: AOJu0YzFJD8m9pHL3ECYl3os9tZVnY8kr/CMs6IQAvLdWnXPHvhOwRhA
	znSclGB+0Y0kqSrBsYctcuhNTv1uAZJ5PpwWPPIanZHJ+FzbkHDFfnIl9v+f3Xg=
X-Gm-Gg: ASbGnctPPcIUdwHX60qZ8/aCw2RRwW79HthA4itiHpUCt1Xa7p3vywkISa1JG8XOl22
	m3F2D4Q+y2QUKjJbawQYWlgFI/qQr+oCi6EAvlEHrcr/j+EsVOo2i4lLk93o6k/nwzAVVbrABCj
	z4yLIIiIy3szZVSCOMG5ZALAkJme0CUxfiStdM1ROdMHXVwM4qGGwfqngdeMvI4tNzDtXP0rBWo
	uVlxd266VM3kHzQwdiwEyBfLhVU6RbwL6d1h13xRzS+jWaOeKJBYJ6ElLN0Ph+ToDqQl+vOBTzF
	hN4yHUPXAPPrm5jG+LppKKyicPT+2+1mgr462JaONwQxFPuL4wg2mKjO3g==
X-Google-Smtp-Source: AGHT+IGPukPJ1Cveg09G9PPBBGq/K9XkdCaNM6ATjpnSL1yJJBCPMSzv39EZqWf5lFyewJx8dLFfTg==
X-Received: by 2002:a17:903:1c9:b0:21f:507b:9ad7 with SMTP id d9443c01a7336-223f1c973d0mr129475305ad.25.1741278196907;
        Thu, 06 Mar 2025 08:23:16 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e8587sm14415125ad.62.2025.03.06.08.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:23:16 -0800 (PST)
Message-ID: <35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
Date: Thu, 6 Mar 2025 08:23:15 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, philmd@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
 <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/25 08:19, Richard Henderson wrote:
> On 3/5/25 22:41, Pierrick Bouvier wrote:
>> Replace TARGET_PAGE.* by runtime calls
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    hw/hyperv/syndbg.c    | 7 ++++---
>>    hw/hyperv/meson.build | 2 +-
>>    2 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
>> index d3e39170772..f9382202ed3 100644
>> --- a/hw/hyperv/syndbg.c
>> +++ b/hw/hyperv/syndbg.c
>> @@ -14,7 +14,7 @@
>>    #include "migration/vmstate.h"
>>    #include "hw/qdev-properties.h"
>>    #include "hw/loader.h"
>> -#include "cpu.h"
>> +#include "exec/target_page.h"
>>    #include "hw/hyperv/hyperv.h"
>>    #include "hw/hyperv/vmbus-bridge.h"
>>    #include "hw/hyperv/hyperv-proto.h"
>> @@ -188,7 +188,8 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
>>                                    uint64_t timeout, uint32_t *retrieved_count)
>>    {
>>        uint16_t ret;
>> -    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
>> +    const size_t buf_size = qemu_target_page_size() - UDP_PKT_HEADER_SIZE;
>> +    uint8_t *data_buf = g_alloca(buf_size);
>>        hwaddr out_len;
>>        void *out_data;
>>        ssize_t recv_byte_count;
> 
> We've purged the code base of VLAs, and those are preferable to alloca.
> Just use g_malloc and g_autofree.
>

I hesitated, due to potential performance considerations for people 
reviewing the patch. I'll switch to heap based storage.

> 
> r~


