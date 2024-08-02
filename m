Return-Path: <kvm+bounces-23042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D579945E75
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED8501F22DAB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550EF1E4871;
	Fri,  2 Aug 2024 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TEj3uQ4e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3372481AA
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 13:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604486; cv=none; b=diMJC+UkE0SEOLyndnn842lrUo2aVtVNGqmCYgbFFAjwAUTvlP2lTo7nzJ5dVmJM7B4y22JX4lkYdC8tKSX8NX1cmjNbs+4jfInIniWevwiSreZI40aVyaVHXSY6z0z6NQEJYGOs4R7pglzSdlcoDJbJ53Fxa0hHVt3L8VBlipc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604486; c=relaxed/simple;
	bh=djP31OHyJ46oRMwYt/ZcbzD0Yd+pVG2stEfOUFKmTR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bo83SXdVNrcTfw68ffOcsZWhleWTlFhddwEb9kuvW6GYBhj9y8xBwxft5c3Z4ppcGggHmlpm56mZz+SXjA4Pkda9MrGqvqw723Iq7p74q+Svr8SZ+HANOlDrMsSrmBWqH6H3iN9pPJBF91S0T/lZIJVviO7c7yuAmyHwZoUCbz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TEj3uQ4e; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42816ca782dso53032695e9.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 06:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722604483; x=1723209283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f3Ig9qrNqS796eTen6yC/TdSkvMI/5+1PaGFCTS3GZw=;
        b=TEj3uQ4eIvDyE09p98kWCMMmK3FGySHyUH3QqeDC/WeoGcwlX/zMpvWzgYG+WpKiZB
         epkqVvoGD/g1ZuHibvWHKY52IDiwWH4sK9yeHXSauptzn0u3XHpUqryCApnD2NvPxRLj
         QiBJj4iTmY2R9mcIPicKKgauMLaTzFhu4yx6U8wMc5nwRljMtqu6yinURjA1fpNa2QgN
         UR0Q2JvvHW9VeTEmG65ljulhufXANuvYw85PuUJOz1aIhiT0lSORVAEE9meirD9c3cxQ
         PmOAhuygMaDe77Z8V3HFeDDANDW9G+m4MC4ZfSNnEZCnmbGgQd3TIrCaMw/GbSiuzcM1
         6Qgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722604483; x=1723209283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f3Ig9qrNqS796eTen6yC/TdSkvMI/5+1PaGFCTS3GZw=;
        b=Pw7pTni/0Ove5CxvOLRhsUgr+/L77OrZtzvF/CdHPI56BGWcdR9JdDDYO+hWVTAuaC
         DFkiENJ7jMoW9+6brF46u+ww6JVfblbTt3G0g1dagjTLjEfHtA0grBmBPCtsVMXLPo5k
         ycDaPQzk8MX9oc9W/9BK0USp4OaeG6lJbM+TVsP9hmbqC4FB9ADUbrME4rekAC5P17Ct
         eNGscFb8J7OW2P6zptRbFjDZaHLJTwxFR4FkF/xmosFxiCA68ovk5S9/f8Wvn59qF6QN
         ElNVJXu4dnwWGSvbTDDxD4n0oU0IZ2rJRhxQ+lSPXxBODtNzdla8ERkOv+GMu9kCdmDi
         8c9g==
X-Forwarded-Encrypted: i=1; AJvYcCUwQVtttigfiw6rPRpyq/8bEhPe0+yGwVM9tubbqnf+9D7vPaF1egimieYr5KKU4OjWnz9SjZURTzYN+yb/9R/fHmj4
X-Gm-Message-State: AOJu0YwWDi0TjIqDtfdvT2G4Y1JWW+4Fr0sM3q+0O4gnL0HLcWBfvzg1
	Dm8GbvXNZUWEZHYyc+zWzH7NxfmJSDnTUVEoM1xL0MF/nxFuaJcRU3OIQ36By5k=
X-Google-Smtp-Source: AGHT+IFJ5Jrfc3nemcN+4XkWnV3Ou5dWwp24s/GYXu+YmOcgrmVE6SAsu4lL4UQAOfp1KYf9z5Vqvw==
X-Received: by 2002:a05:600c:4f8d:b0:427:b995:5bd0 with SMTP id 5b1f17b1804b1-428e6b7c5a4mr23302515e9.23.1722604482796;
        Fri, 02 Aug 2024 06:14:42 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.211.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428e6e11356sm32059165e9.19.2024.08.02.06.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 06:14:41 -0700 (PDT)
Message-ID: <6874940a-8a89-476d-a8ac-b6622aafe7c6@linaro.org>
Date: Fri, 2 Aug 2024 15:14:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] tests/avocado/kvm_xen_guest.py: cope with asset RW
 requirements
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-7-crosa@redhat.com>
 <20efca0c-982c-4962-8e0c-ea4959557a5e@linaro.org>
 <CA+bd_6K5S9yrD6hsBsTmW4+eJpPsquE8Ud9eHZzptUwDrHcpeQ@mail.gmail.com>
 <a3b0ebf6-47ca-4aad-9489-16458ffd6ff3@linaro.org>
 <CA+bd_6LmuOdQ8ZdLjwt+MCusjQ8ROv23d9PXoF-Ku3j4j73wsg@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CA+bd_6LmuOdQ8ZdLjwt+MCusjQ8ROv23d9PXoF-Ku3j4j73wsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/8/24 17:17, Cleber Rosa wrote:
> On Thu, Aug 1, 2024 at 8:57 AM Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>> I agree those files should not be modified, but I wonder if you
>>> thought about any solution to this? Given that the same user writes
>>> (downloads) those files, do you think setting file permissions between
>>> the download and the use of the files should be done?
>>
>> We want to share a cachedir on development hosts with multiple
>> developers. OK to alter a downloaded file before adding it to
>> the cache; but then once a file is added/hashed it shouldn't be
>> modified IMO.
>>
> 
> I was asking more in terms of what to do before/after the test.  When
> it comes to this type of setup, Avocado's cache was designed to
> support this use case.  You can provide multiple cache dirs in the
> configuration, and some (the first ones, ideally) can be RO (life NFS
> mounts).
> 
> But this is hardly something that can be configured without proper
> user input, so this is not present in the generic "make
> check-avocado".
> 
>> So far this directory is group=RW but we like the ability to track
>> a read-only directory (like owned by a particular user) and adding
>> missing assets to current user cachedir, to avoid duplication of
>> files and waste of network transfer.
>>
> 
> That can be done in avocado.conf, something like:
> 
> [datadir.paths]
> cache_dirs = ['/path/that/is/ro/because/owned/by/someone/else',
> '/home/cleber/avocado/data/cache']
> 
> The asset library will take care of trying to find assets in the RO
> directories, while writing to the RW ones.

Great, thanks!


