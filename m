Return-Path: <kvm+bounces-45286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17474AA832D
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 843C71890E4E
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83D31E47BA;
	Sat,  3 May 2025 22:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NpKROMRq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6453E17A5BD
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746310295; cv=none; b=u3iWbeSO2nRzIN1kwDUeNy/5IWDhO68yfY8bc0a1/CiJGtRSGUnSmJCFV4VibD3FEe2q2PoMU9IrZZRvKUiny9R8pKCvYGg1yvbuZWhqUBlt8nm5RQNsPua10HOszQTttx8a+IIHLomMbaidm950ki3GHAa01TfoPNN7y3cDAkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746310295; c=relaxed/simple;
	bh=f6P5jwBESQP83E7Iep44eIzWklEUfRRX7sMeE8INR7g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eO2yNPfWeLk+nPSuXR9/m6HXVpsnJKPUqKc+TiZxkC7Zq4fUCT+qOPwBzYZJTR2tj1i8hCh58jjlxqs8+5NKtoyWIN+6GMSKKHGappsPoneiW7u61yeTgXfw8rS3SfwDpZ13p/XB7u6ZmQugubFsWqDVHB6Zq6NhqW/Bu5PXjrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NpKROMRq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2254e0b4b79so49613885ad.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746310292; x=1746915092; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T7LctirqTNATR4ocbX59fsgCBPnDuKRYJ8DURr+ffWs=;
        b=NpKROMRqmvice0rBVzFdzPLM6LEIsWQECg39XiCTWq0JEfJer56K+HFuM0YaIMfJTS
         SiiPBIDzyjffIwaFw9Vk8vflBeM3WRjbCDP2ZRRf/CUuLIKe2iClZPsI+xzLjtIyZGQJ
         bromGvMHBZ7ngqi6lX7ZNioP/ZTFJ30ef8NcwJVA54gt+dT+u1/tmh+1egOnOXin5Idc
         TZyJlM3icgZRgAacRf/SZLj0Pa4ObYrPgS+xVH7XqgM8W6i+WPVJGT1aYRNp4rs1Lr0+
         OT7FFM0LW/e5jwSsVJb9UZM7yMTir88P0jucdGu6oz3O/GqRzL12zdwYh2WOryfgNN4Z
         LgLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746310292; x=1746915092;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7LctirqTNATR4ocbX59fsgCBPnDuKRYJ8DURr+ffWs=;
        b=mIoXxkQabLCuxZQdhJMO2wYf7Kn3nejxuY37FXNrAnBRYICjTU6ioUBYzX5hcEPT8v
         NFip+vboG+IXmY1FXrpuzkfDT635YZhamrNAOSqE6yxFbHfhya4ZCZ8df4JdXdrpudnB
         BVurRydJ04caPuhhqvpUbb+yuSd/svSanlGzgvQtYCoPQymlocnn6KRAF1fjfsC0xVyY
         dsLOLYlc/AFoXdLplEudrHFP2EZhO6v0hhXIlfzIGgtO1PeHiGZpl/RRP5YTuNjF+nCn
         Zuqkngi1I23y0UO+YTmg9pEe9m0Sa3fDm7NwHfgDyONLw3ZkoS5wG+ogLtZcMQn/Lgc6
         BPIA==
X-Forwarded-Encrypted: i=1; AJvYcCVXOx8VSfmW7MpAwKK8QlQqce6bfbKVmwj8uXF6epCR+ZLUjgmbMPUUgS3pJjEMnnG0Zv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJO/8JHkKkfJH1nuHGNPR59/7+c+sQmNX0+g7qdBHtMOVvGchw
	tyddbZ65mUzheBv5aBOm2Dr4U+aOQpaF1agIcklMcNmpOmsb3jBK5kT/P3w8g68=
X-Gm-Gg: ASbGncs7yncd7LhNhFEHnfNAe13Q6N447sqluJ6OOHfUPmtCLRznb/TJkEi+WSwCLFr
	QtKDMuotRUcJ/2WFlYauTr94IHsQlUDqCKifYqnW4e5nXsCW09pnBRtwG1B7hBC373REEfNvXJl
	fO4Ntey1OjCpk8po0/3iPL/t5PG9xHzyf/WePgy9oMmezXk9y1JW7BiMq+hQCYd1N6iIz2JiO4U
	dm7r5H4G7Ijet8xnMx8pHodBmNNVVseOYnx+BPiwF1aOlYp+Mc1///WVZpl9cfxl+orZRB+JHuk
	pcWW5GugCBAXo8Xkdhdq71smjbX+/9sbLQxevsYTaAS7tpPOlaO+CjCeGr1jIF1N
X-Google-Smtp-Source: AGHT+IGKZOl9sWhuTSlWLAe3uWJrr+qu/WKjiaqq1BSWM3eRAc1/owPtZQjoqVpboGxgTa1PqGq1pg==
X-Received: by 2002:a17:902:f64a:b0:223:faf3:b9c2 with SMTP id d9443c01a7336-22e1ea6a954mr30930175ad.27.1746310292542;
        Sat, 03 May 2025 15:11:32 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a4748e813sm5644044a91.24.2025.05.03.15.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:11:32 -0700 (PDT)
Message-ID: <4abc3e82-acfe-4877-9f92-66e134d19d56@linaro.org>
Date: Sat, 3 May 2025 15:11:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/33] target/arm/helper: extract common helpers
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-16-pierrick.bouvier@linaro.org>
 <8f480fa1-609f-4b90-b6e7-02a76d2767d2@linaro.org>
 <00710aa1-2a44-4778-83da-05cc125506e1@linaro.org>
In-Reply-To: <00710aa1-2a44-4778-83da-05cc125506e1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 8:24 AM, Pierrick Bouvier wrote:
> On 5/1/25 8:06 AM, Richard Henderson wrote:
>> On 4/30/25 23:23, Pierrick Bouvier wrote:
>>> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
>>> ---
>>>     target/arm/helper.h     | 1152 +-------------------------------------
>>>     target/arm/tcg/helper.h | 1153 +++++++++++++++++++++++++++++++++++++++
>>>     2 files changed, 1155 insertions(+), 1150 deletions(-)
>>>     create mode 100644 target/arm/tcg/helper.h
>>
>> Why?
>>
> 
> It allows later commits to include only the "new" tcg/helper.h, and thus
> preventing to pull aarch64 helpers (+ target/arm/helper.h contains a
> ifdef TARGET_AARCH64).
> 
> As well, for work on target/arm/tcg/, we'll need to have aarch64 helpers
> splitted from common ones.
> 
> Makes more sense?
> 

Added a better description to commit message.

>> r~
> 


