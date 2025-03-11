Return-Path: <kvm+bounces-40777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C97A5C5C4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03A3C1887936
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524B425E801;
	Tue, 11 Mar 2025 15:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X52/nesH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FB325C715
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706081; cv=none; b=LaPuXXlwcjTTpUl1HBvAMsBN2TilQT03Ky/DxgIsd8cJOsMVMpkx7kVor9mCRA3yboWzrrN3CK4m0m2CjUdVVDoJVI4T9l7a8uRRMO+w1ZWAnDs/sar4ZM9pH+TEDFUHpNW5v8evrk8tCBoe138ivX0CbNvQobWdeWhQcbZPmxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706081; c=relaxed/simple;
	bh=5O61UgH7Wpz+1B1NSWiM56ya62c8dXi8C60zWJI/wKE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MF0LPH9FYuvurE8gdGC7M2OY//L60FJQnM//0NghHCmiwhvvNwNOFqpRt2IanxYfkvlHQdwBfvnL9vw8f7iz6PVTEipQ8zW8337Lj96xem0umMTxDxUBmBR4Eyjoh43doy784jGZyxqihjIC2vb1TIYCIIrtgHX1YRzfYma1Vhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X52/nesH; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-391342fc148so2738818f8f.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741706078; x=1742310878; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nRRe0V6hTnTEa/ywDXDKo4kqBN5ZydvlC5M+vqDkq1c=;
        b=X52/nesHjDMa3BQoEME1HS/h92mHK3wZGNLp9MOvLXxoVDswa6+HktE/CZ+ZHucPcR
         6+8OIjE5bCvqEeILeLj11N3bJ+x1UhMIcxI/2iIJTYHDPaxXMfso60RG4zhvgnW5Rmai
         jOACMh7tW2diGHR/yGb1CroT7lKH0O/l4nChPTPNqT5tQkN3wCqaayY4Xfn+afkR/BwO
         xxi4GnWH62/uGJqVDadlDhc0QgxIkPA6hKErb4NtKbgCF/L3vn8R788p922lck2psVNr
         qxwTvsA1uYb+S996Uu30+eEBBR+gVpLvKP9E9WhHOWsj2KY96y1RC6NLVIsBx2k2FMf2
         VkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741706078; x=1742310878;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRRe0V6hTnTEa/ywDXDKo4kqBN5ZydvlC5M+vqDkq1c=;
        b=WOESu2xULgJQk7dNBN4iXdYT/uO+LbQTAofDTTxHAUSglCgUjNcFrckB98ZDdtQ2j0
         PPlWgkODkrotxITg98lKW7Q/v4wVueOujzGLamT/8EYDxIZ3orakcYCPC4xLumtjRAoQ
         OvFjTEbgWay0oBZn0qNPtGWxUoJ8PqF/6747ZkX7DjhELJyS6xqbOULMg0JIgOUf3oGT
         eVWyrmFbbmfpznGRoerHp4SRFy+CJHQPMnZUcWgO3ZTgiZgvidhJJnQRcXLtEEK2V82T
         ng6gNs7Go4rMxQiBZ5Lot9kmAFUe4vHzcd79tI3LXtGywr5nGhbxwcihLKo9Kc0XNP84
         X2/g==
X-Forwarded-Encrypted: i=1; AJvYcCU61ApoQ32ppK6/9eZzqZp4+wr+8Ep3B0KwgJLTtLdcrJiknCCHUdmxVyplcGkVn+JNPhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwigrL2orOIcu3utlMPvPbB9p/2HgQjOX6kGEkrDx2Qpd5KiOE/
	ohENqsKtPEN+9OwifYo7sevtBFH3nbLlBM6MOoKJKg4fAbKD9JuniED7dBtizSg=
X-Gm-Gg: ASbGnctUST3YZOaA7Ztm+uu3l9S7bcs2Z4Z3rJmLdUaAlXLwRFHz4zaG9ZfdnAMHeYF
	huVsceH1Pj+bZOc2F18dmk3LfMyt0o6j/A5TNJHzJVjvz8qtcikmrM5KolGkc7GxUAGYZsJO+u9
	EmV+MgTI4HpuTTNJxRhysG1WmLk+sUX7exlWs1c0LmWZhwX0ceN9Wzn/AixHW4Wx8Q9k9qIIPnr
	zknLLiBcsne5Lf0TUO7Lrbt//gZkdPtdf1LzkfFwuX+C2S8rJgSnbqXg28G/H84bCMw9J0fytEZ
	wEQeUHgu+j1pLDeSm0V9ctyyphsCL/SslwR4W88xM33C17pTRMp9lE9xyxM5B+1jsREVZJG7oLq
	D4TYyjYnNcC1Z
X-Google-Smtp-Source: AGHT+IGMZq9Zv5IrDzGNXyfZard2uq17hlvG5nfa9qRcDr6dl5yVlBL8PHub5h9dwcelWjylk5GmVQ==
X-Received: by 2002:a05:6000:18a5:b0:391:13ef:1b1b with SMTP id ffacd0b85a97d-3926469486emr5385934f8f.30.1741706077939;
        Tue, 11 Mar 2025 08:14:37 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d032afc2esm15042685e9.2.2025.03.11.08.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:14:37 -0700 (PDT)
Message-ID: <b5f9e231-8c29-4992-89a0-5cdea7c08b34@linaro.org>
Date: Tue, 11 Mar 2025 16:14:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] hw/hyperv/hyperv.h: header cleanup
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <20250307215623.524987-3-pierrick.bouvier@linaro.org>
 <f957fbdb-c7c3-4a31-a76a-144ff31ea158@linaro.org>
Content-Language: en-US
In-Reply-To: <f957fbdb-c7c3-4a31-a76a-144ff31ea158@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/3/25 16:05, Philippe Mathieu-Daudé wrote:
> On 7/3/25 22:56, Pierrick Bouvier wrote:
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   include/hw/hyperv/hyperv.h | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
>> index d717b4e13d4..63a8b65278f 100644
>> --- a/include/hw/hyperv/hyperv.h
>> +++ b/include/hw/hyperv/hyperv.h
>> @@ -10,7 +10,8 @@
>>   #ifndef HW_HYPERV_HYPERV_H
>>   #define HW_HYPERV_HYPERV_H
>> -#include "cpu-qom.h"
>> +#include "exec/hwaddr.h"
>> +#include "hw/core/cpu.h"
> 
> I don't see where "hw/core/cpu.h" is used.

OK found it:

static inline uint32_t hyperv_vp_index(CPUState *cs)
{
     return cs->cpu_index;
}

First, bringing this huge header for this single use is way overkill,
then I doubt this method deserves to be inlined, third @cpu_index is
an accelerator specific field, often incorrectly used. Maybe in this
case it is OK although, since IIUC we only support HyperV with KVM,
right?

