Return-Path: <kvm+bounces-18606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F33988D7D52
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84EBCB22741
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F545A0FE;
	Mon,  3 Jun 2024 08:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNhp3WfF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E02943F
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 08:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717403224; cv=none; b=NNW5oceTIjH+XFm4371CqQV/qmyOMJxsJq9lQL8uDgciMxpmKRd7QAE55pw++B9Iq/S92OHPc2cQURC2w3FwIntUARD0MatzgjkI0Vdp40IU/4IF2K7KrjBclnseEYzX4rEmOEYvGUidDRqKe5VOqFCdoGigrAORPdMznq1ogCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717403224; c=relaxed/simple;
	bh=fddEsecCPJy13LZyKX4TPXlRS2qhW9eq9zmnvDnAltE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmBGLL+8xIuzl7gN3hkeZ6i7G9OWRcp0mUSGtjKKrYTVfz62n+uVQzlrAUk6kzoTwXz0vBoTPsdCMJjYYylpKwupFNaroiSSuumpbuLde3mXZTbTkC+OSSzV+FMp6ihc7Fp1aC0nV1r15ZaTpCzCvKMrZeHfZ5cPAiYPwXQL1dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RNhp3WfF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717403219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jG4XNqs090cQFAo1FuSgBrJMRBvov9Pn2ncasg+wDo8=;
	b=RNhp3WfFfSc8Q1EXleJKzORmd88Q8OqVBIv5qwkxvcIpjGuqIt8ohQvxqcxPo/QH3GWmSz
	acj5P4q4JMRTNY4Zz52qc1/3yTfek4nJ1NCSQx+CDW3klsufzS4mBXdD3gjIXmQmoeDXL+
	1wXC3wEwK9i4ENd6drFdWxIrqt0neQI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-nUdil23SNAuPiT-kzrudug-1; Mon, 03 Jun 2024 04:26:57 -0400
X-MC-Unique: nUdil23SNAuPiT-kzrudug-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-627ec18b115so69472917b3.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 01:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717403217; x=1718008017;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jG4XNqs090cQFAo1FuSgBrJMRBvov9Pn2ncasg+wDo8=;
        b=SR6SM6UMn/RVD+ckmy6UlYLHnHdzdVg7QmpiSEUPXmMYh/P/7rV0zuIQDkntSwvxH1
         /R1rGmIeO2eLVrzlZhq74CQQ7AzZOkvKaDKazHkK6xZb8OgYmpctjTonBVYuCRUqveUE
         iFyT8xWEbXfDcMAucRMn0oTtIpGAcK0AnSMpmuAY8GYkln8KxczfrcAxJbO6kz3P3GVU
         BBca/BaHSsCZPQBDHVHFjW+2Q9p/ImRgpYMaxmoU9oRp3fGbh2UQ/nkGhBOGXFNJdIVn
         Solzg0cizlBTnlGm0108XloexuIFVD29vZ20YV0762UP1BdVV4K+jXfQfLmrv30U6FoA
         07KA==
X-Forwarded-Encrypted: i=1; AJvYcCXVWf/JCblKGO0V7kcwCascwX9h+Ze9ZJ2sENr8ad9OUKczIaBx4gCjQX7/rqYokRFkJY42uHWBUaPvnLMzd1MyE2dm
X-Gm-Message-State: AOJu0YzkIIqta0UqXbKiLh/LFZhWFIhje50oN/SZt7+CABwYLUqHJ+de
	a2mJ9zj+9CzxO3ZT+H2HOSKj+rSW3XkT5EaY0RJUtddwWorhNQgZWqcw3H4LP4UvFgRojMdhOwB
	zGxqoy4YpZTGBEe8vpJW9Y+nDQuwxxu6XopG4JoZTxM0ULwVJjQ==
X-Received: by 2002:a81:690b:0:b0:627:788e:94c7 with SMTP id 00721157ae682-62c7969b528mr82197977b3.6.1717403216608;
        Mon, 03 Jun 2024 01:26:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGucdcW0xITxNt5WTcpitpxJIas8S52yrontaW5QUuPTh5nlzmINru6Ow7Kh4Aty5A5qmlhyA==
X-Received: by 2002:a81:690b:0:b0:627:788e:94c7 with SMTP id 00721157ae682-62c7969b528mr82197857b3.6.1717403216195;
        Mon, 03 Jun 2024 01:26:56 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4400db037dcsm11946141cf.66.2024.06.03.01.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 01:26:55 -0700 (PDT)
Message-ID: <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
Date: Mon, 3 Jun 2024 10:26:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240602122559.118345-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2024 14.25, Nicholas Piggin wrote:
> Unless make V=1 is specified, silence make recipe echoing and print
> an abbreviated line for major build steps.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   Makefile                | 14 ++++++++++++++
>   arm/Makefile.common     |  7 +++++++
>   powerpc/Makefile.common | 11 +++++++----
>   riscv/Makefile          |  5 +++++
>   s390x/Makefile          | 18 +++++++++++++++++-
>   scripts/mkstandalone.sh |  2 +-
>   x86/Makefile.common     |  5 +++++
>   7 files changed, 56 insertions(+), 6 deletions(-)

The short lines look superfluous in verbose mode, e.g.:

  [OBJCOPY] s390x/memory-verify.bin
objcopy -O binary  s390x/memory-verify.elf s390x/memory-verify.bin

Could we somehow suppress the echo lines in verbose mode, please?

For example in the SLOF project, it's done like this:

https://gitlab.com/slof/slof/-/blob/master/make.rules?ref_type=heads#L48

By putting the logic into $CC and friends, you also don't have to add 
"@echo" statements all over the place.

  Thomas


