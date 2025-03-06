Return-Path: <kvm+bounces-40266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CD1A553C1
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C81C16D075
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D427F25CC9F;
	Thu,  6 Mar 2025 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="alK9l2PM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9221129C
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741283904; cv=none; b=jOoBf5fFF9VzbwtWvEyjmng3ugg8Ikk0RyhS5izJlkq2KHa0sQ74qmnQ2UKUfm1uFgSDQWiD5IaT6c4Tsylzx8GJsyRGGloZ8XX5HDZA6LGpkk6qDcYN00nfECeDjt2jISAY6xB0IR6CqxgwxxhsCHdLPRHYGeaeaFkVCOvnXkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741283904; c=relaxed/simple;
	bh=WWj5epyUIQKgqncLurcxu0mphEKbxmZNQclKu3iX0f4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LAt4psbaAXufNWnw0gW+izKXEQg4noI/8yp2LiGSVtDsqqAhmbuZuXTVm0i4hISi8RX+fcHiv4NHNy7+6WYXdQzPM4S2+1h2qycmgeRzCmop78D3/IzBfWjtQ5pVkDJO68u1vvy1DbI043kqfljo6ebwEwJk9XN725UeGlXYgmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=alK9l2PM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4394a823036so8497525e9.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 09:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741283900; x=1741888700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9VwvtDnWxxWjHWm12aZwqWQ/LW3Ynbl8TGhwNxgYLB4=;
        b=alK9l2PMax8N2hPd73soF1n6bo7mxuHHcS/vjdVhRKGoqS/LboWY7CdqdTIo0XJjRO
         ba31NWovRn+of4hM/DmFqRi2mmIyTZ/W9H7dczzpj5RWCDhISu1FUst97tId/SnaHZ/V
         hcbUUABKcau8GmS3nShIEpnVwkh5d5kqQ8CGbKDK/IJJvcJXHiaY9WGA7sSse1+RkUqI
         ahziHp4dK7sEjORGftqSiNyg0HSIRbp4gOaIHO56uucjLULgKXgNQ8UuwoOXHu7XUFr0
         ZeblHQ6K447pi5l3AL5WHZZDXdb6pcezCpBdOHMWwRo8eEexb6BHAVm/9FLWkzIw+zuc
         44HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741283900; x=1741888700;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9VwvtDnWxxWjHWm12aZwqWQ/LW3Ynbl8TGhwNxgYLB4=;
        b=d7SzwKXhU8ibQNFwnHR9k4Zie6ncy2d0rqTvLYZzTFh+/G7C+TobUKvrV7+m7dSwwS
         B+DHUzK0tazDBoLGAhBYIkZ7yeL3MB1XNNFqmp2lZZQRo/4RoCcKMP6dRzOoFPpoSwic
         aw6rXqIMBt4lb08l3+t/MNKspV0ntyE4D00QMQLgu4UZ52432iMsXSMOgqxfMeEfXPjR
         aFqBsEg0u3vMN8iHULM5nDWribzHCqaIgxC9fsQSNhLEwU/u2gWJ2oMkEIxiRScH9Evw
         GmrF9OhlbT/QvY2DVCfl0i3lDvZ57qFf0Q2WDToH5kLoFc4eAGtFJXqZFMfnMXDp+zin
         Whog==
X-Gm-Message-State: AOJu0Yyv5eWMWSLvT34vyJB39FNuj+41YD9d8R7tqviAVsydrx6Twq4s
	aNBtea+lC7ZbLOLrzxov53AUw97HbA+hPL7nB02+0Q4rIDmo+0EuZPgLeOZ7hqo=
X-Gm-Gg: ASbGncu2mSlbkpm3MtLZhWWU6uI22qV5s4laWPUmv/7P0Ct2FNBUg7lLkn5vUMn3kvG
	Fi4OC0P0ZsmnqnfhgCciR5MSsMuAIZOZy51ZGS8RwTrOT249pT8iTKQJtb4e8xHT6kd6rbExg03
	mG5KS00K6evzoe5VlupM5x29PSKbo8LmWRcs0FYgvCpH9W4gjOg5HB8ew6L7UHOqKOj/pGODGsW
	TM5GXhcgg8UOR5pW9badYxfgDvlASIpfAAlXQAZy3z22V7sJtsN3snc3Uw4J2ewwBnrsor0tWY4
	qQKk+me4mOJyWF7n187o32K24yiX7PExXfRqJNxD6HkaR0TlWJLcaCnAn5+knnTVs1Jkhxd3V5G
	cKtoZLquCpn1x
X-Google-Smtp-Source: AGHT+IEOGtBDdAD18sfYjElHHabFYEAK4hG9FCCt8OtBHu6CQyPWoFisVCQvxBYwOeMEWSSxRTHC6w==
X-Received: by 2002:a05:600c:1d24:b0:439:9b2a:1b2f with SMTP id 5b1f17b1804b1-43c5a63023dmr3243295e9.3.1741283900253;
        Thu, 06 Mar 2025 09:58:20 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435300esm56599785e9.29.2025.03.06.09.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 09:58:19 -0800 (PST)
Message-ID: <d62743f5-ca79-47c0-a72b-c36308574bdd@linaro.org>
Date: Thu, 6 Mar 2025 18:58:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
 <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
 <35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/25 17:23, Pierrick Bouvier wrote:
> On 3/6/25 08:19, Richard Henderson wrote:
>> On 3/5/25 22:41, Pierrick Bouvier wrote:
>>> Replace TARGET_PAGE.* by runtime calls
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    hw/hyperv/syndbg.c    | 7 ++++---
>>>    hw/hyperv/meson.build | 2 +-
>>>    2 files changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
>>> index d3e39170772..f9382202ed3 100644
>>> --- a/hw/hyperv/syndbg.c
>>> +++ b/hw/hyperv/syndbg.c
>>> @@ -14,7 +14,7 @@
>>>    #include "migration/vmstate.h"
>>>    #include "hw/qdev-properties.h"
>>>    #include "hw/loader.h"
>>> -#include "cpu.h"
>>> +#include "exec/target_page.h"
>>>    #include "hw/hyperv/hyperv.h"
>>>    #include "hw/hyperv/vmbus-bridge.h"
>>>    #include "hw/hyperv/hyperv-proto.h"
>>> @@ -188,7 +188,8 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, 
>>> uint64_t outgpa,
>>>                                    uint64_t timeout, uint32_t 
>>> *retrieved_count)
>>>    {
>>>        uint16_t ret;
>>> -    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
>>> +    const size_t buf_size = qemu_target_page_size() - 
>>> UDP_PKT_HEADER_SIZE;
>>> +    uint8_t *data_buf = g_alloca(buf_size);
>>>        hwaddr out_len;
>>>        void *out_data;
>>>        ssize_t recv_byte_count;
>>
>> We've purged the code base of VLAs, and those are preferable to alloca.
>> Just use g_malloc and g_autofree.
>>
> 
> I hesitated, due to potential performance considerations for people 
> reviewing the patch. I'll switch to heap based storage.

OTOH hyperv is x86-only, so we could do:

#define BUFSZ (4 * KiB)

handle_recv_msg()
{
   uint8_t data_buf[BUFSZ - UDP_PKT_HEADER_SIZE];
   ...

hv_syndbg_class_init()
{
   assert(BUFSZ > qemu_target_page_size());
   ...

and call it a day.

