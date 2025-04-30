Return-Path: <kvm+bounces-44978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C717AAA547C
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 21:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8335F7AF225
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 19:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4939F26FD83;
	Wed, 30 Apr 2025 19:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wEEWtlfj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EEE2AF14
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746040008; cv=none; b=h8Hp/qwj2bRWJqDbXzIvoRRGJ2ocaxbPfy6RVMCVDqGIY/OxSHpi/uGPLlqR3c+xi6BcU1L5R1buEf9qVz8Wpbf9pJAmgkkqQWQi0YixYaK82aahaUVVFd33G8n+A5um3T0wCoQG+0SML469J7BZB7WOIC9fuHG/CxwtNwkxCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746040008; c=relaxed/simple;
	bh=jLVbmka96YF1wBjsPjIUG3zcqUCjAExuWf+raYYrrDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H97yei0rHS5llR0QqcMMpGexc3gkrOlRHgnUBEF/KIxqQBodA/ruaEHxf0KeMGASsycwaOaugQcmTeuska7Y0aoMPRMt/H0XbGzEMPpZtET29Zs5HsIawNNe7i9reROMCf78OuBF4uMVOUPKMZlmpawctcATvL7VLUycAYeoii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wEEWtlfj; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22438c356c8so2074445ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746040006; x=1746644806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9n3Gc+fzJYrA8p18MsMkLFMsPX3ZwWCDB/5xmmls/q4=;
        b=wEEWtlfj8Ob4YhSF8UeIBYDvZ0SYy7Zwklv+jLUSasKw0vMOPlEg7sh5kKcNCMzL0c
         WhpihFtvEa6t/kYH6E8wo3O7H6PPHtR3jipHRctUrIz+CtNvt11gda0VLYlY2O5PWSB7
         hIqjpayCX+5I9I+kSvsDuLB1MbhjUCX9UPL0E4ZoHOSsGTFRSAffqjjqhEX+J+jL6bS6
         eesxv/oGzES21zPZDhoxjcbyiug8PkLp20u32ZUG/BlqDr0I385sGRDpuzK4aH7Wzdk+
         7zbT/cdkD09G/1AkBoCOVb6VjZahHFIbwGZsozmbv4/bbejIqEKjdpkNZBbaqqf2IQMO
         ye3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746040006; x=1746644806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9n3Gc+fzJYrA8p18MsMkLFMsPX3ZwWCDB/5xmmls/q4=;
        b=SbmW6+hBcvstHAksYOK/PqKF1fgCwvGM2lTZ+/kaZpvP7ukzVUiFyUhukD7JBif743
         Ry08b8wvMVEXJX2DLtkkvgRr1ciTo4new3GQDiVnOTRtnxGjPOX8r9vIrEo7d1bmmvoE
         IbXhrBQ8UT8VuhsaassYclz/qUbzNm3vR4ljRmw9q+SgfmkvrIXlazz7cOrf1QDgh3Xb
         Fvy4x1TFGygWbixc0mNxuErgl428prQ3OTzddDcZ3pxzXloaz2evgRNlOzhEgRMaeug4
         uSFGTy9ndN1P5DHn4jLkzvAnbLuk3HgWkcYLlJ943nYRv/us2brd8BMVXylNCzMEPhVG
         Wvcw==
X-Forwarded-Encrypted: i=1; AJvYcCVVyxJiwMf9Qr7wHrzdcJJ2VSfDYz+vFEjiBvlKejjSEk7H9Gj4ZalPFzAYqcJWvAlA/G8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz84RGTzATj0EuzRzDfWnh0S0NiBW5Dg5NNb+yXg9CVxJ1mL2cS
	XK+D19FB4SPrFXpV7RYam53MweuQnnThnYkNtOwdE3T9Km0Re451N1VE579C+s0=
X-Gm-Gg: ASbGncuScsSGl9cXZKVn+ZAYfgg8/G9f4dxAXTUkDrpymDImcYenC7pktRu93CjDN/C
	nCYIA9LtL3DoWQhi2j6DoNpQd7pjXxnB/2bPT0CSOJ0VSesFS/63KOCEFAC8tGE+gsXO/8VANhQ
	nBV0LWavpxRHkiyA+t++HsGMWU8ZLUt1mo0wBw4OUlyUeAtopQE5sTy2dvTJO3WC/no0lWh5pq/
	uUY5maFuV8Sk2gvN1POqO7HQIi3QqxKtsWho1MgJo9wDdBhlD3uZmQuoLznWu9micUgEz4564Sm
	B9wQde2VJdw6OHVAuUGO/e3NRIdMRJKQuM9s97Abw+Zp6xgEfb/jeA==
X-Google-Smtp-Source: AGHT+IEwJ9DmS6F4g37/Yr0JrWeK1e551wHd0iG5IlA+XAM9kxsLyaRa9Hjrx30O81QJwrT30x9ysQ==
X-Received: by 2002:a17:903:2acc:b0:224:10a2:cae1 with SMTP id d9443c01a7336-22df356f9d7mr61399055ad.37.1746040006067;
        Wed, 30 Apr 2025 12:06:46 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f76f4680sm11028282a12.14.2025.04.30.12.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 12:06:45 -0700 (PDT)
Message-ID: <037f7d2b-91cf-4798-a6ae-ba3cbeebf2b6@linaro.org>
Date: Wed, 30 Apr 2025 12:06:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] target/arm/cpu: remove TARGET_AARCH64 in
 arm_cpu_finalize_features
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-11-pierrick.bouvier@linaro.org>
 <8520456e-3e44-4028-976a-45d683610a8e@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <8520456e-3e44-4028-976a-45d683610a8e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 11:47 AM, Richard Henderson wrote:
> On 4/30/25 07:58, Pierrick Bouvier wrote:
>> new file mode 100644
>> index 00000000000..fda7ccee4b5
>> --- /dev/null
>> +++ b/target/arm/cpu32-stubs.c
>> @@ -0,0 +1,24 @@
>> +#include "qemu/osdep.h"
>> +#include "target/arm/cpu.h"
> 
> Need license comment.  Otherwise,
>

I'll add it, thanks.

> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> r~


