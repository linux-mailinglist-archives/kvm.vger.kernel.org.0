Return-Path: <kvm+bounces-41456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F92FA67FA7
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CD771896473
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B9A1FECD1;
	Tue, 18 Mar 2025 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aIqJY/sE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E25DDC5
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336478; cv=none; b=VgqKvYSLXLPv4YkhLreqBF6xtSwsoRmTRF5gyanwABjD2raiV9+4oH/1/UXHIYtLiRjdsjYoRCovCb2oElVKqlN0A2faG0MYbZbptwhWz/UJmDIJZk9b+jvQRUIOl2G4H7x9WViGRSCtti2nBYhraKmFY3Qywu5MLwxhdPYEFpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336478; c=relaxed/simple;
	bh=uWOdlwzs12si8aRBT+zJ20K8yji5ecJymP6IOyuFGoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJXIQvXuqKppiUUSem2HtyUlnoQZqBVUvA/PnAXq1AhV+bHiA++5fUquu4Zr1RJTUlIi/auH2u6k1uthYO4UMgHAHut0F3YP306Gqsb0GZk+vBc0FulgPGMetU3KFoBV8HrPYw4MsIE6WsMMYMx5WH824VQqrmblMsJP6jXfalI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aIqJY/sE; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225e3002dffso69350575ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742336476; x=1742941276; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oMWyKhFjYGpE1Bc3+5PVG/lcM9O7ug1FTKJVkXkKJkQ=;
        b=aIqJY/sEut7QQaD3+YaNL8pL9B+8ZJ32ZqRCd7pZ5j53USURdALp6yJYp7fJbKsIaw
         Uvz2i4/ZNKDpUkvbTjp+eJEsGW8P3m1PzZODcvLkT74sZ4P2q2WbZqTC9ucD+g3/I08s
         Io6h+ItxXiEQB37HTna4DqxnFKnPkfxjMyqzNzsHjgjfpPuwN/a5mp3uuDDjy0bc9Lwo
         RytfpSYUcG7xnzA2wo2qptMFU2qMEOW1+pXpSly59isuYYDUhYm90WSUG0h7CPnQhWh3
         mNptMYjHB1kOupNdmrCqOM5K4lqCCi45Uj545cqRWFiS5Kz4CoZ2jUeSO5piD+QcJY7N
         bMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742336476; x=1742941276;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMWyKhFjYGpE1Bc3+5PVG/lcM9O7ug1FTKJVkXkKJkQ=;
        b=ln7GN91hGlpZ+6Tz1wtEJAWs2i7WA8aws8+qYGDZ/fQayG4MP8B+yDcMGfWDJnOVQJ
         fXcKAQ5+aWFQKqzMjq5Wrow8cjpmipl9T+4fiytuDj4a45rvxIx6IS87279AfyiPw901
         BppmoDNM5kcP+SbTxIcqisSmlrGxaZiDqjQ2pJ4VBeN3odV00LBEXd0gJkPCuH1lVyb9
         i7qy7BzBsO4nhF/LZYVOK3Soip/TOy9TmdBY+TIH4cLDRj/HxnhWjbJWcbIipnGec4ca
         OO09g0wFASgg/4ca1WTkycVZQvN5egmbBu1kgkCt6HblLOPZlZWugk3O4AUEdR7t7xhb
         Baiw==
X-Forwarded-Encrypted: i=1; AJvYcCVOTnQ6C/N7JDSYG2EbIbWdUt4eCyrJnhHo3HBa1sX/O5GEx1ts8GJ6gyBbf/I58m7kKiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxquqP9GiD8GPDXyasjJXJfu1AGqmlFZy5AwGwdQ8Ky80U1SYPV
	WPW4bWd95cWABjiueMwWiHNVIu34SynBYXvAG7mH39IeLHEebprDEmHgrpq4E/+U6nLgTx2++kJ
	D
X-Gm-Gg: ASbGncutUmuDj4BA7p979zCOTNjb5G+/SosUNs8pbNAm70XY9SEs6/ivwuZB3IHyNY9
	26U+321bIEhODqIUMmbylJfxGAqBfxcMDcqpX+OWNAu/gPgCVdMctnVysx/ZRGpggpi787O19kh
	iurgBj/HlvKZr+TrEs0GtCregmq7G1lXGpVKbNdlfegeS1fCwa48zhRgJjgn92U6lWJdWFB5NuG
	PeFa6ialw/Udnjzbzm2D2+3zGcVAPgiIWICNBKr8axmKhcoJBkoEW2YlnWN191UprgQHhVIGHuC
	xz4pJWYCeNvSqxQXqbt5zx2SWfIB/i415pFPYYzxAPvuG8mCw1K7ZiRSXag0TKCaPc6sQs/HKZb
	oa1wdVLz0
X-Google-Smtp-Source: AGHT+IHyyJCsiABK+wwwJ/lgyfO1ls36ZQt3JXsVmvsivUDUtxpenS401D2LRtb8OdsmEgQFuXJjhg==
X-Received: by 2002:a05:6a00:13a7:b0:730:9801:d3e2 with SMTP id d2e1a72fcca58-7376d5fee6emr654299b3a.8.1742336475698;
        Tue, 18 Mar 2025 15:21:15 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711559269sm10478181b3a.65.2025.03.18.15.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:21:15 -0700 (PDT)
Message-ID: <0c6f23d5-d220-4fa7-957e-8721f1aa732f@linaro.org>
Date: Tue, 18 Mar 2025 15:21:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-5-pierrick.bouvier@linaro.org>
 <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
 <7202c9e9-1002-4cdc-9ce4-64785aac5de4@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <7202c9e9-1002-4cdc-9ce4-64785aac5de4@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/25 15:16, Pierrick Bouvier wrote:
>> This doesn't make any sense to me.  CPU_INCLUDE is defined within the very file that
>> you're trying to include by avoiding "cpu.h".
>>
> 
> Every target/X/cpu.h includes cpu-all.h, which includes "cpu.h" itself, relying on per 
> target include path set by build system.

So, another solution would be to fix the silly include loop?


r~

