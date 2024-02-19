Return-Path: <kvm+bounces-9010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 002E6859C76
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250491C2166F
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 06:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064AA20328;
	Mon, 19 Feb 2024 06:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cLdnaeVA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E8C20303
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708325971; cv=none; b=lonkJ8Zq5NBfAs7kQnFgOj0MdIYs0jra2Nh6hHD9KYU3nY/cDJcIfFsXb33J4aBJbBeGeQ7hdrQ91SEgC7EwRY3fYKpdLH0cVE3coCdAixzpOKZmsMY6/WZ0kqDxbRJ8KzFuAQMUrB/wkEyGpdIfyh8Uek7Wvkev4xy7Cx034xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708325971; c=relaxed/simple;
	bh=pnDgn1er2Ravf+AmiLpvwrN35AQML3UDFHcrcTpZMOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mbg32ZoQC2G+GxvnKlV+R9vJKUc7USSSL8B0UUYhu6/jjdaYnUidxrYoHP30YuuVO23+86TbWWuCRPCOooDwTppfoAoPCRt1smiteOKDjMfOBxenZDqEL3PUHkQQCqkQru8aSPmkh1B6+SvBC4J3mDUwVaGq5T+/ZT9w4mSTJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cLdnaeVA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708325968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9lAmpJMZGjRI05pN4Ggw5rJdGick7SVDlwHgWjYBno8=;
	b=cLdnaeVA9GpeTjOtviCnAVTWSXiToTgH0jJRSfSmKiPJ7P5Ob1uD1Bh3lUkzvSVG+Asvoh
	riqsme2yoswSwl33z1Nsq0+zaFgPap/+vUvoYDlZRd67vtaWwkEzIkAoqP/dDiAORKstn7
	Ey9v5kItW3S3ZXrO8BYnKjButsREP9U=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-bBTWiLffPiCYE8xQpyujbg-1; Mon, 19 Feb 2024 01:59:27 -0500
X-MC-Unique: bBTWiLffPiCYE8xQpyujbg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-68f75058f07so5015246d6.0
        for <kvm@vger.kernel.org>; Sun, 18 Feb 2024 22:59:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708325967; x=1708930767;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9lAmpJMZGjRI05pN4Ggw5rJdGick7SVDlwHgWjYBno8=;
        b=Kr297eXz1WYmYNe22Er0behELUKm7txelUs55YmenG+o7xVzFQxaDQidoO7GrISWYo
         wz6KEzfVWEvymQcvdidmE9ib34tiMx2ryLODywRq5nTje4tQr4oVjY03kxH0V4FeS4Sv
         htpuQmOOlvUCeoTiSIobof95G5MXv60093BKmkLdwFanTawaOsME1mOhI7CdNhoThsXG
         dABHd6C56ftbzdL8+jDoCQKnTzkE3DxulTPhK94Zyix+din0dkqexIxN0hZR1bxAlC5/
         W1iMgYMzj19y1OKsXMh2x+tJfwFz2Z9Y7JH7IoJfIitqiB/4NhDlTpfzigGGmEfEYIeD
         F1Lw==
X-Forwarded-Encrypted: i=1; AJvYcCXRlDpzW1+Gl/D0Tn2G+S2UirwcaMtXI1s/Ib0E2tha61vbn13fYZhazAY98Z4kfjtCQaWu4/LntNEVSuhyBIkDvyK4
X-Gm-Message-State: AOJu0YxlohpmrqZHBvhbSpOBHk0SxFi+Yzc3hu79dOxlSlE8OBu/ywGE
	DCIY8BG6R26p3oYel22hUVUzliM8Xq3E9WR1ckkoTjUqe20ZAyAgwUTUaLfd267S92qUgAtzSRh
	P9+FAQCy2XHCOPkyg2IKBq1wEdhD/qKzHku0OqZNDNc1YyQZALg==
X-Received: by 2002:ad4:5743:0:b0:68f:280f:14cc with SMTP id q3-20020ad45743000000b0068f280f14ccmr14447397qvx.35.1708325966718;
        Sun, 18 Feb 2024 22:59:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgnlRSnONDJ53KL8ZFuXHJRZyEF/cTiDyOAL0DWKWXtHHXKufuUWM4qHXKB1yOHdRCHIt4sQ==
X-Received: by 2002:ad4:5743:0:b0:68f:280f:14cc with SMTP id q3-20020ad45743000000b0068f280f14ccmr14447386qvx.35.1708325966485;
        Sun, 18 Feb 2024 22:59:26 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-48.web.vodafone.de. [109.43.177.48])
        by smtp.gmail.com with ESMTPSA id od15-20020a0562142f0f00b0068f752195b5sm447274qvb.86.2024.02.18.22.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 22:59:26 -0800 (PST)
Message-ID: <4986756f-6230-421b-9601-054c6c2969e8@redhat.com>
Date: Mon, 19 Feb 2024 07:59:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar() multiple
 times
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones
 <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev
References: <20240216140210.70280-1-thuth@redhat.com>
 <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/02/2024 11.43, Nicholas Piggin wrote:
> On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
>> getchar() can currently only be called once on arm since the implementation
>> is a little bit too  naïve: After the first character has arrived, the
>> data register never gets set to zero again. To properly check whether a
>> byte is available, we need to check the "RX fifo empty" on the pl011 UART
>> or the "RX data ready" bit on the ns16550a UART instead.
>>
>> With this proper check in place, we can finally also get rid of the
>> ugly assert(count < 16) statement here.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> Nice, thanks for fixing this up.
> 
> I see what you mean about multi-migration not waiting. It seems
> to be an arm issue, ppc works properly.

Yes, it's an arm issue. s390x also works fine.

> This patch changed things
> so it works a bit better (or at least differently) now, but
> still has some bugs. Maybe buggy uart migration?

I'm also seeing hangs when running the arm migration-test multiple times, 
but also without my UART patch here - so I assume the problem is not really 
related to the UART?

  Thomas



