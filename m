Return-Path: <kvm+bounces-45601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0897AAC7D9
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6D74B20374
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D5D280319;
	Tue,  6 May 2025 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HMb/HbS6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5B026C3AC
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541464; cv=none; b=TT1OrEYcn3Hp2R2tzQOhStUWuhHyr8AAffjD5tSknEsEK2/IU9B0HG11zav+ZpdfbPct2hzt+LpNF+lFotKRetpg1AtK/FC/S5T3JKrIRVlkdhJiJPsQYG3ZEWBETMPHMuMY13ArFz2OwYQRzKMHv+P0e7KR0mLVzgTw1tGNAgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541464; c=relaxed/simple;
	bh=at31ltFAD8TCQmNeIpNOaCYk+bc/VbIqmWjvmTX1L1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcOecz2y6wt2VtyrTG43tpc7GrzUpreOKHq2V15q7iCD2wh0TkwuCt5dW2/nNfCs028zWIcEOS7LfCbdQ9Nmzh2dMq45o84dwkJaURHXCKlSVn9p/LCFT845nXGms78FoO8HiBRQ9yuKOs+r4BgCL2jtLUwNC+fZhCXFc+BQNcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HMb/HbS6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22e033a3a07so60456045ad.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746541462; x=1747146262; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wp48SLQzCDDOEhX90luVeiVR92Yj3/LBSHBEPyNAS4c=;
        b=HMb/HbS6Dqtq9jrWP2t4+9aL4L7irU4nmIqE5XZnC7jaeQ0eP0gjHo5OPxkapIGwiq
         FSiXyc49nos9F1YvAg82NCbyBH2eDgwe4nuizzrXUsIYJEBK9tLW4P1/UHnKnhdwBtEN
         NS+FOoo7EVOIi4GR4P7hFdxBipljnTYlEpEsqkyZcHdFHrNIzz71vr3xQ5qdUqIj2kCZ
         VjQkFE+eP0krOnuSeL8JI6uAFF/Ryv8sMeoIMWUwL/QeZ15xE2rkNNtES6EWR9zkI6+r
         MV+CQkh1BZcPUBhX1HPgkiJvc5fyW75O97Pun/iTU73Wu9G9sr8KsUpXZeLLU8NjCVwY
         RgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746541462; x=1747146262;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wp48SLQzCDDOEhX90luVeiVR92Yj3/LBSHBEPyNAS4c=;
        b=DwNiGNrDW6CC77DyzW06Iunv9K6xq1kzndtCLtqMlHGmevNmX2SYEPXEdThcJdejJ7
         E6bgzXrNuJNpHjx53jYhBy6sci5kIE5tNd8VcP2nvxhmq6fI9vATfRsfjlUnLMpZI2mq
         9ljWpXleYlnrmC5D4ixmvuk6tsSq2MtBpuUxwNT33UV8qZ6rv/ZOo9M/jekGoS/yaZGq
         UpIKW8OSDJimAa7Py9lOkjbtb69bhaWTLee5mteQkQHkYZA90e8JmQOtTn0tYjxMxRpY
         hj23Kzj8HhIZ5Y5dj9cR0Qp/Rwyvso0QaYQfbXPUvaXEJa1TilO4Ava9OgK0ctx29tpx
         DpYA==
X-Forwarded-Encrypted: i=1; AJvYcCXt94DRLbfibdpwgAFF80XnosCa12a3M6sQAQLXeuiz7Rf4OleuwULkVTTt8fc5m2gpva8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQUQOQig8bRz9PbFQSlT39CvfC6VLeZs25rERboRn6+hF41+98
	i1el1dItB25CJFn86u6IBrb3Zn0HSBKYeSg/nab0HNHMeq9aCbQ9/GVB+BtWxNY=
X-Gm-Gg: ASbGnctV+FtLhfCh7xVJ8R74fAvW5ErLBp2uWoq+S8oJ7CZqaAWDeyeyg7/Oh7ixQ7a
	tsL3QbeB1LPB5upHxxcPoeo8OBz87ni0RFHI3rnqiZS34XdLkP8dU1Vb6XHKXA0ywN6wQX/+Rni
	3WLFGZkdIJXCGOuYve83ukskT85c6ufAmsGQmF0fzijjEsSaa4O99UhjC4pg73zJMDvxv3EMnJD
	8iHkbS5oeLt/nibKufAclIk2Spdurpovxw7XQCGuWrN9j7yW2va2bz4lR5In6kiCtUca46bGkga
	Og2XR+7rM0LTxdv+Vrp/G9p/KfuPkUnTtCzKzdlP55o+l7ugz0dcJFE44UsYkn14f3OcsM2dDRr
	0Il0lHEs=
X-Google-Smtp-Source: AGHT+IG+1RetG7RJ3eDdo4fn/r93QL0JzzajDVJf57zZrejNoeQdLPPkA/gRRtthzFbovHmaOzdEAA==
X-Received: by 2002:a17:902:f683:b0:223:f408:c3cf with SMTP id d9443c01a7336-22e36209873mr41616515ad.21.1746541462410;
        Tue, 06 May 2025 07:24:22 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e4537d437sm12590805ad.184.2025.05.06.07.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 07:24:22 -0700 (PDT)
Message-ID: <4249c085-8879-4e20-b2a9-5e4c0032c62e@linaro.org>
Date: Tue, 6 May 2025 07:24:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 41/50] target/arm/tcg/vec_internal: use forward
 declaration for CPUARMState
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Peter Maydell <peter.maydell@linaro.org>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
 <20250505232015.130990-42-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505232015.130990-42-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 16:20, Pierrick Bouvier wrote:
> Needed so this header can be included without requiring cpu.h.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/vec_internal.h | 2 ++
>   1 file changed, 2 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

