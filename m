Return-Path: <kvm+bounces-41460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE49A67FD8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC48819C1FF2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E712063FD;
	Tue, 18 Mar 2025 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gPJg2+0U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC442F36
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337347; cv=none; b=YX+mCcSI0CZt6bC+WXNWjUsXfMguQq6WQROydP8LJpOVUtWoq9N0SQdp4grYTZ2WaOhIgmwn+Jx1yEZYSiXDtIvNlnq6iLk2/o2wbESycl6Gdapj7CvKAkNSRzsYG/LaHONfFyIdbo/RaGfaE9hG/Sls1RRP693FCsGqp7/0rLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337347; c=relaxed/simple;
	bh=I2yy1+tcrb9mlWQhQgaCiFcnRhL5urK93myZhAMPPn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXlcrKeEJ/4Z2MjAyZyPGcVZNNaVPh5x2Pzme+0eUx8y/YPzYHjj1cM83oknlePcbAC+axD+wU11oZnl+uNfUWX7VYqgMCKx8nU6dh9f1UV8DGQDDyKq7fFYnsp8MNpRzifP+A5W/ssxhuMaaEfFnfnjHAh7Fhzuvi5jDtNP48I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gPJg2+0U; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-300fefb8e06so7022263a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742337345; x=1742942145; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OcpXmFjMO3sTuEr069JPwJK2tK4LKUaxYfppJkr+u58=;
        b=gPJg2+0Umo6mi18WZi8s0uKE0usD2zKYf23PEkYT+Q4YHkyocU5PY0wRh6SV0pjpLt
         7JUDDoIzxGnlcz2uPfwf4AYS5XXqIFEDtT+bu1yofPdSheAQ2bbJnCgNXP3Y18sxX2QZ
         AV5k5ygwLxbHPHxIq0wM/9uQWAC0cOMimwb1yaSqr/06B0XcmzXlevnGdtAilZe+ICxJ
         KQqXOdozZwbnfE4kyTYhnJuw6RpiYrCA4sWFP0fWRmhTn/SED7esctYr/gCcAn1TDdJJ
         Xck8VN56nKPRbStCvXFh7ktwkmEN+bNql4GIsghq6NjhLnrByVOG0wNkT1COWWOwdPmT
         po2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742337345; x=1742942145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OcpXmFjMO3sTuEr069JPwJK2tK4LKUaxYfppJkr+u58=;
        b=L23LZhKlxt3yEvdrZr4gyn5Qjci/ws7b34dWPeIu2CHnk2IKoyskmeHnFmSmrSO9m4
         fwV4ItFFT5h2LWjcQYMcwq5IsxpLy7dMMxNa9EsKv+NVAzJ8Vi2btXURYV7O5paupr4l
         HFdDpr5+ZZ7jVAabd0mFcwsXnPhslKrfc2cvDRfiTJHHksrUIaBLt04m/D5qd4Ew68O2
         hSHcALtwi254h+HnOnJMqipV+/RL85mwE7w5mmy8luohIom59RneAXmjlqLAJeF1uhf+
         zcTY1kVlFLeiQcb7aL0Iuwyp09+ctHmniS5E4YuGPzp17x7xrrAyuSDR+u/Q1hU+x5og
         qtbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW58HBSEDsmpBX4I6CNNtBFvdX31rhte9KOUo9lL1pEIaaJF5Ezged99m4F7bv0cev5Fig=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLyOdpb6LBKmFyk/LR2mMP1XgWLNFulmdVanGL7f7WJknSkDkR
	BziYIQKSAZjjYBW/ufiK6u9D9mq5sM8AUUjMqFpL7RsAadUEsdY0SM3CRcFwdB0=
X-Gm-Gg: ASbGncubBaFLkZUZTTcmKRdhEQ7Z8NFfiP1tVNAjKPxI4qa794cGlG03CxCwftgFKu6
	bUnZmBPdJWjIDffp4UcVdlDhKg0JA50ZUVTDOENxn1I8zexYa2ZwCNWjZ0x1S29niHXR9FzjsKn
	BRvGIA+D3NFAZxLzu7y2OZyti+xVI6bT6nXcGIeFre4+9LHJDAvjcixq5CYz9wCBiAnS/4OI+2E
	0yJVpPZZ2t8JJQ5K2x7wVEMGFpBfJElVjfSrJhUPy9PdecMvyLU1W0HXd79bwPXFCkOsCVSJGqw
	0+h61a6X+mETql5TMumPEInk/5iCLZzzT1d+p1pqcTx8XSFDRujt94Ldvw==
X-Google-Smtp-Source: AGHT+IEt60b/xkcu869FuAeLSGYbURqATeqh+waGHDsaBv/jurzyPKhT+Oye2N3wcUB3foD5o0iT/g==
X-Received: by 2002:a17:90a:e70f:b0:2ff:6ac2:c5a6 with SMTP id 98e67ed59e1d1-301be205cd8mr503863a91.31.1742337345425;
        Tue, 18 Mar 2025 15:35:45 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6ba6a08sm100286865ad.154.2025.03.18.15.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:35:45 -0700 (PDT)
Message-ID: <30e72d8d-a4cb-45af-b57e-a0910bbe06a5@linaro.org>
Date: Tue, 18 Mar 2025 15:35:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] exec/cpu-all: restrict BSWAP_NEEDED to target
 specific code
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-2-pierrick.bouvier@linaro.org>
 <2766725c-9287-4ba6-9e14-e84616d5fd17@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2766725c-9287-4ba6-9e14-e84616d5fd17@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 14:41, Richard Henderson wrote:
> On 3/17/25 21:51, Pierrick Bouvier wrote:
>> This identifier is already poisoned, so it can't be used from common
>> code anyway.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    include/exec/cpu-all.h | 6 ++++--
>>    1 file changed, 4 insertions(+), 2 deletions(-)
> 
> I'll give you a
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> because it's quick and correct.  However, there are only 8 actual uses within the entire
> tree (discounting comments), and all could be replaced by
> 

I hesitated to do it and get rid of BSWAP_NEEDED completely, so I'll do 
the replace.

>> +# if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
> 
> 
> r~


