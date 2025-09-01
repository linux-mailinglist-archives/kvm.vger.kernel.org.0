Return-Path: <kvm+bounces-56464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A9AB3E770
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 518EC189D793
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5313634165B;
	Mon,  1 Sep 2025 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yg7rOKQr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7333CE81
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756737679; cv=none; b=IkOggu5f8kA+J8wJnHKIfiRFbvT6yTHrwwsaBPXRYSNqPNzNqepcvJplaP2MKuDRpOPOhxWlP3FQFeQSieD3yW0latLzJTo9x1Fxl1pzQJoOHxzuHksWzUcQ+T0GoiOyN3VQwv/AhFV1HkHm+5Gv+1HW3Cfxd5/Bs73gotjNuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756737679; c=relaxed/simple;
	bh=f9lXqsjTqkDsFthbj3Qk7lq43kK3DKNcsQQObC9mSTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uYiCexo9GfefCBfTzyetutjPIYJHftSlZmwlvUf7/QJ3Yvkv4n54RdLzW9C0auNdBttRSqJpC8RQenbFlNPhpRgUzCqhqoqDpQRLfvcAPAeV/uf2P+TuuzSjSBPXICeNpEwkRVubHK2vd/GT3d/JV7biUFYpvDUZmlx8nxd0Rq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yg7rOKQr; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3cf48ec9fa4so2239609f8f.0
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 07:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756737675; x=1757342475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9lTrA3YqOrd5Yin1WTNjJcmVSFDzRrD6u1UwFco2CuI=;
        b=yg7rOKQrEilAGp7GBCxqzcraJk1IPp4/2I+bOxJSiR/nHd4yhdmv9yZzBnPhdbHilI
         /nspzNqjiZdhWbRh30ls2vL2dDHn1dIj1Do+bsxeOjBTCDCI5spYAkEZgm8U6VOWWelb
         +OYyTkrp1dUb3gq6J3DJQJChmYnWqDTQTYY162OK/OwX9nI56DqcVW1bmN6eOogXIlbQ
         4U33wMmiYZQwFWG7DfR5YUbfcmlWoHBKTm7g5NU+ugHmDXG/He4rG1czbyXfB8NvJmyl
         5uhHo48uiDn33nB2FGY8fjiSiL7WjUmIfJ0rJb8oR472Hp8BUbQ3nBuniCs4v0afC3g2
         hxSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756737675; x=1757342475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9lTrA3YqOrd5Yin1WTNjJcmVSFDzRrD6u1UwFco2CuI=;
        b=R6OelpC/fha2cYNnf1gpCqlHqTbt87LeK5xhwOre+eoBMJveevTLPfn2Pomqhw4VJe
         tvGQHsQMQ+A52ZX8YGrbI/U+Ml+R865Y8P9iqCqHVH+CEsq1K7z+7JIftXbQdiLA9M3L
         jpd7+tVMLJbGl4624TW/XgqGWqylixnrltGtTUdhYcQ9yOw+FTffN30E4bMYwI00RAQ3
         ji39xYdLJW1TpgEVLpDEpR6jB0aS+03ibAO78hsTCojrZVKvPF3scfuKsvzQSdF6xfOc
         riuh0KadUS84E4biVnoZJ/Dmz7+clkl3sfhmo6CMSLm94fQsAbN6OV5ExrNxpDI6FfXW
         O2mw==
X-Forwarded-Encrypted: i=1; AJvYcCU7ggE0P9cAZ091QwBI7DCh3r91CMPAXg7yHkwULv05fb/ge047tqCQ41uRb4Dl/4P6iqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgZCsEiT7i6J6gdFY5C8va15NBpwASnOAuzxJdSyQHAYAS9IjV
	RViyzjdE01pn/fpljFe9PDAT74AtvddDy7+HM9qol3PRIneFuzgmIsVehXJc59Znmjg=
X-Gm-Gg: ASbGncvTsT5gBaqZbIyVBxF90dZU/XsPgAPLZEujckVGivahvagmNjMHIstC2og3h6W
	WcQ1SscQbS57n2nUgQgQX54DMXDsNoZF5z5f2M2AY11f9Pyb9VHCzrtc5lbSonc4jXY6KjWk2+u
	JoABPC8+xS/bcJsJD2NxC2JUO4NpjUrnJXIyQ/v7W7DxqZNrE+6LthHpuVJm30E+ZCb+WkOMdWF
	0+PkT2vEHhbfZU3r8nj36v4UagdHGwEf8LRXRottOWrgqMeAwr6eC+tfNJHZN9nPfTDWhj+ss4I
	7knSrDciaPA5ip3vNuko0dund1943lFL+Mj4ucTrgJ5CQFqizcZPxRHIpOX4Ez6iIaqH8+KB2Ai
	FwtCK5NpdlEOClxds2NnCCFuS288iFl4b6RrW5Ljaw8ylS3sPMb7Y62TtZWoPiInL0w==
X-Google-Smtp-Source: AGHT+IFk67GFwME04fXeCsSivmJbor7dQb7ZzOmHJQVVsQfuoBd7PdMSWmXA3rJ/br9KB6hGX+FeBQ==
X-Received: by 2002:a05:6000:1ace:b0:3c4:497f:ecd0 with SMTP id ffacd0b85a97d-3d1de4ba70dmr5071604f8f.31.1756737674653;
        Mon, 01 Sep 2025 07:41:14 -0700 (PDT)
Received: from [192.168.69.207] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9db4sm15711822f8f.47.2025.09.01.07.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 07:41:14 -0700 (PDT)
Message-ID: <7fffe10a-05dc-4e6d-89fd-03d351aac06e@linaro.org>
Date: Mon, 1 Sep 2025 16:41:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] docs/devel/style: Mention alloca() family API is
 forbidden
To: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-ppc@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org,
 Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>
References: <20250901132626.28639-1-philmd@linaro.org>
 <20250901132626.28639-4-philmd@linaro.org>
 <CAAjaMXbDSwXjTFb5nPrK7tWyjbDtxm3mgxOwUK7yMUOG61y6qQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAAjaMXbDSwXjTFb5nPrK7tWyjbDtxm3mgxOwUK7yMUOG61y6qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/9/25 16:05, Manos Pitsidianakis wrote:
> On Mon, Sep 1, 2025 at 4:27 PM Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Suggested-by: Alex Bennée <alex.bennee@linaro.org>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
> 
> Reviewed-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
> 
>>   docs/devel/style.rst | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/docs/devel/style.rst b/docs/devel/style.rst
>> index d025933808e..941fe14bfd4 100644
>> --- a/docs/devel/style.rst
>> +++ b/docs/devel/style.rst
>> @@ -446,8 +446,8 @@ Low level memory management
>>   ===========================
>>
>>   Use of the ``malloc/free/realloc/calloc/valloc/memalign/posix_memalign``
>> -APIs is not allowed in the QEMU codebase. Instead of these routines,
>> -use the GLib memory allocation routines
>> +or ``alloca/g_alloca/g_newa/g_newa0`` APIs is not allowed in the QEMU codebase.
>> +Instead of these routines, use the GLib memory allocation routines
>>   ``g_malloc/g_malloc0/g_new/g_new0/g_realloc/g_free``
>>   or QEMU's ``qemu_memalign/qemu_blockalign/qemu_vfree`` APIs.
>>
>> --
> 
> If you wanna dust off your perl, you could also add this to checkpatch.pl :)

We expect contributors to test their patches before posting :P
(normally it shouldn't build due to -Walloca in the previous patch)

Thanks!


