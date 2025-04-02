Return-Path: <kvm+bounces-42510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75621A7963B
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4335B16F486
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDAE1EF097;
	Wed,  2 Apr 2025 20:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ovXSfwzX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A34A19CCEC
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 20:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743624401; cv=none; b=AZiZ6eES2utaEqQfDetA6OCq7ToMm/lxDaZT6qUFO7xh5MjC4RfsJzydu53HxcZQ2p//NwHs2760soY+3f1jKGjrbkK1x7Egr/ESErI1F1v9nE2ZfZ4xDkeJsEGxPymu5gksT6xO4Ri7TyWflCjXmPi3eeMltnLmSo99anLp+Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743624401; c=relaxed/simple;
	bh=0Rj9lUikNcQ/VI8OR39S1Bla9AbbScNpGKLGM908KhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqXaQOwX+dx3azDIY7Q/dQkAQk3n3qhB4HbWg/YXQiwVaQdYO/F4roJFwjNpBlUuJZtkU9tPib1GKNq+W1RWiSzt/+OtCoxN6oF4fu1pX2bpK/1qb5blNhB0nMuOw7RBB9C5VtChbSl58ESAPYx955qg5yjrqtDsY0vjb4/4/uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ovXSfwzX; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af5085f7861so159842a12.3
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 13:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743624399; x=1744229199; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gGER60jBODfpJu8rmDeG0AWBSpyUDqOOLEMl7orT4bc=;
        b=ovXSfwzX6dOGzL4w/A2TtFzs8AlY0puAOClSsk4xwjVR/2yljkQpd1m2dIju+SiwWv
         1Igy/jPTrYMeNDdLs/YmifpHtZGcxy+qpyXRWcclEsy+tqxA/ct7cbgKIMFAcszgWH4a
         C5H0NgQW5sZiHQ0234pyeictcGv17nk9V8E777g6sx6TSBvOut7wA+erzeeh9cnh6Kl4
         v3tVH5bGZhp2HVTwCDGqktN47zbcrB36mf9r+2Grg3/PtNTJjhYPhThNVsGaIVrqehvZ
         gAtSMRlxz68r9RwRo1jKhi/iCSzFlWz97W79p0xSf6ZszfB53pXyEOI4zNm5o8r4v0Dd
         I1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743624399; x=1744229199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gGER60jBODfpJu8rmDeG0AWBSpyUDqOOLEMl7orT4bc=;
        b=E0JN7YTnVFqD1yoCSuNxhZvSSlCJkgPo+lGUZkRgDnV1lGU3PxrCaeen08G1zlw0QH
         iR1P+ChEGUk1+L2O4mrws1ZsfTxCnp2HGS3ujLLZ0QLPjBc9nSTPvPzn2juqZNEel5o2
         L6WjM9ByaoiueftjR9l2BIIxTvJnA1uhjN8Op6ueh/RvVQU1ASO1WBPm0BbT+wr1s3hA
         VyMF6vvMcSx8Atno/3HgQ6aRAyYbUJ46FrjDuSv9TnZ9APYgEriG9x4vtTryX8PDzc4A
         JRo0bsonI9IVJo8x8I4N7CO0XL5LQ0hvJu6jonrtVpAvVMFvrdK8BIJbd39VoHmNm/3m
         EOJw==
X-Forwarded-Encrypted: i=1; AJvYcCXvxso4preTnQMf/5EeGNsC78F7S73H0R19QNbqCi5PvNvLNKIC+7TlAsthNDXlPJNjiEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAAvVbZXG0Idb/83D7YfUBUMzTQM5FQMfvk4PWV28lhVwD+5qf
	AWVuwcysYbwUdiJ6k79UYf0YvttdmYULHNbagpG2wpS2q56gvEHBJIGi3PUh9BY=
X-Gm-Gg: ASbGnctV6tb9+zg6OyHuo6kK5R5HCT72r3mW133wwT447mQ1V8H02CwC5YOBIx7u/lg
	UeRAIqv3JHGd93MjIc9hNuXRBK+xEOJj+gKjDx4GdIRP5eA00IhYGVkSvZrWx04+x9oozOBiyRx
	otucy3rqV0n6Tp05CTPDrzEHOLSZYDMp8/xjw7tsjPMODDa3cOnmLJuBAKZoBWb4TJCC6X1Fwrr
	L2amDA4qapioaTgqCrT6WY0j7C3ihaJdmmjDZTQ6ZjMUfADMZ0Y/uu0Q9rQ3VtiqN8PlNY4x1D5
	UMR39yOMrsYz/aBFWo/Df4AKKrsqsk+FYuhj2uxJ4Buu/8rtuzYp8+Z0VP02vjxVtjNQMb9p8nG
	OatuwrPyGTTg9QxZ8J6M=
X-Google-Smtp-Source: AGHT+IHByQEo/y3ttEUvI7Q1rqoMQM1inJLb136EkfcouhY9Hr4tBoK94ajqs1xm9pdBIzhEGiscGA==
X-Received: by 2002:a17:90b:2748:b0:2f9:cf97:56ac with SMTP id 98e67ed59e1d1-3057c9e87cfmr186289a91.0.1743624398689;
        Wed, 02 Apr 2025 13:06:38 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3057c85eb3fsm67390a91.0.2025.04.02.13.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 13:06:38 -0700 (PDT)
Message-ID: <1d13c66a-e932-48c4-801c-9b14890679c5@linaro.org>
Date: Wed, 2 Apr 2025 13:06:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/29] include/exec/cpu-all: move compile time check
 for CPUArchState to cpu-target.c
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
 <20250325045915.994760-4-pierrick.bouvier@linaro.org>
 <e11f5f2e-0838-4f28-88c1-a7241504d28a@linaro.org>
 <319fd6a2-93c1-42ec-866b-86e4d01b4b39@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <319fd6a2-93c1-42ec-866b-86e4d01b4b39@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/2/25 08:25, Pierrick Bouvier wrote:
> On 4/1/25 20:31, Philippe Mathieu-Daudé wrote:
>> With "cpu.h" include:
>> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>
> 
> I can't reproduce this error.
> With this series, cpu.h is pulled transitively from "accel/accel-cpu-target.h". Ideally, 
> it would be better to add it explicitely yes.
> 
> @Richard, could you please amend this commit on tcg-next and add a direct include to cpu.h?

Done.


r~

