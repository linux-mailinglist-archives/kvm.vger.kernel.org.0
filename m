Return-Path: <kvm+bounces-41699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64050A6C1F3
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:00:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D5F317F9C1
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C930522E41B;
	Fri, 21 Mar 2025 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C719wzC8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637741E47CC
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580020; cv=none; b=de9s5lCRyypccVycHhX6ztlpnlPY/VZPm/+3isHSs6CHKDQiUv0XIisiumk7sMsfe8xZE87uPfnhlAG+/CjEFXNusjxjcpy6PQTl6oQ/DTYAs8yyWbfecygk+/II9uRwAi+AaVkfgSsO/591Jom3auVrvSZkW/9DlvNo/kOaa0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580020; c=relaxed/simple;
	bh=gQuiKn0yh1uLAeHkc3Iju/buV1pdLI8cljfiZqvaNrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qsE/N4JRNyvtKnXxtQyx0NDhhe0prix8vsRxM4ny1v1bbsjU5fgO9J69b1ML8oqzmmnVEioSP4XnqkABBJLgA7wdAzC3kPo4XQZxNL5Bju4hSnvqnjCjXmPk50nJnPHtTJCQteuL+aClNz/atcWj4xNreZPNgOZ//zcWN2jU9JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C719wzC8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-223a7065ff8so16484625ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580018; x=1743184818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NqUath6DYeiXFaEb/UtEorokAMpBsE3LelLAqtNlKlo=;
        b=C719wzC8Wlq4ZTYV5uic0dGuAoWuopmBuWPb8Y/298Ber+Fts7a07qUP1AVYfDxniT
         Cbr63Td7UmnpO1hBtLplRlZkXJ+OEq+3u+9IIdaWVYVuF7xeN/3g86BY2UIl67z0KtEU
         /ovFhulKxSBFrDS5ovoxmoQuC7DhjSoDF4JuOPRbaKHkeK92CCNvyVYfP2O2PX5oOgYK
         l/yUbLPtafjJdWs3+JfL7I6l0w+wfKTXc4HzavGbJBcbolkXo5IPzoL7YiAFUZr5Rsfo
         b41aAANfdKCFsJ5TlyHm2M3Q5G6Mo/ol+3uv5f/AxkM0MGco+tQQPlhEjcADRt79BLOR
         6LHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580018; x=1743184818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqUath6DYeiXFaEb/UtEorokAMpBsE3LelLAqtNlKlo=;
        b=FY06OI5ri1e6bhFn0Iq6S6I+EmbY2CnCqUJ/MuhuBQPRChW2BoNM24v9til7Ans1KZ
         18oHbfQtlAROyqUByAg2RlDb+w4XxOPxwqRsl8c9m8/PV9xdeM8F5z9b5hpXUF3jKzrw
         1K/hQGDQJBKU1CUY6ei7nUOd8eA5c6Q8XBva0hdkYTaxDW8BeT7x8ZyNiGonFhh0suOz
         iE/94acEgQzygHK0O0nEwfnDIFnfynXpwLrX6ZnurZuZqNzbBJZTeDvOhSxuYMekNNAI
         RluzjdxQLJoneX5VZeyVWOUChYQ5U1RG+gGHW6rrCo5eXLDK3hR2YAbn0/KoWm656SIG
         2Xqg==
X-Gm-Message-State: AOJu0YwNkD8XlduaCPa+ZG6sWW+WMIsSxKj0EhZ7f3BmAhH3uFEEYCnT
	hhF5ez5n7MbBmrQwgDMLwE9IcPyQStJZf6QDyqqBImX4f2EOVN1q44Iai7nFoKk=
X-Gm-Gg: ASbGncuOZicNJPQ6lmLdZW8SmASGTVHIHECYjMQxjYCY4l4Z/t8tFRRkhAkKj2maEYx
	V3SpIq7Fyzd+nSRCEakUTraLkdflH24nYJra0gF+IAlU2m2cnpSmJkR3hnCaNUrwtfLhq6F88Xk
	rrRjbkIipntfOGZYnRulEEiX+qevMxLD8Qig0Ui0Jy1rmmRMfrmyNmiff5FVPi8CqSNrpfiznxf
	YI9fheq2aaSycRXTby5GgFdqjFtE8X4Cqw3fV/FKXxwfIin+qxKtkWXmwnNO7VP4CzXIGEsvT5i
	wOUAXry4RsiNQVxpBedKevD+mkPzuFBrug5xhz+J6So1z7v336xnIRobTWVK2/r1TJDglDMazhA
	d6SsdzenY
X-Google-Smtp-Source: AGHT+IG+KnpKpR0jVp7IgTlzKnHiFoDpZhKDkqzftkZ4oAq96lTlohIvKcSdyzoZP3EgZGNch64EpQ==
X-Received: by 2002:a05:6a20:7f9e:b0:1f5:9ffc:274a with SMTP id adf61e73a8af0-1fe42f55950mr7582645637.23.1742580018455;
        Fri, 21 Mar 2025 11:00:18 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a28003b2sm2072742a12.28.2025.03.21.11.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:00:18 -0700 (PDT)
Message-ID: <2529af4c-9341-4515-a697-8c0e4a1f2dbb@linaro.org>
Date: Fri, 21 Mar 2025 11:00:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/30] exec/cpu-all: remove hw/core/cpu.h include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-12-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index d4705210370..d4d05d82315 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -20,7 +20,6 @@
>   #define CPU_ALL_H
>   
>   #include "exec/cpu-common.h"
> -#include "hw/core/cpu.h"
>   
>   #include "cpu.h"
>   

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

