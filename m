Return-Path: <kvm+bounces-14235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2DD8A0BF4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C966B2444A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC23143C72;
	Thu, 11 Apr 2024 09:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bcKx4NoU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB00B142642
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712826601; cv=none; b=ejh/0MGtDMbrRopvVsJzBiRTC2qn4DKe7m7+smD3V0QxrbPXrjizKoRFDHcJxveAnAWWRmHCHiJwLc3hb4O6fulfHhnYJTLj+1GT+srUPlZHuYczu/qHPjiqP0aCmDpBHMVSegoHHrWy9n+Wv57aSSB8Ap8tRntEUGljJdogU6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712826601; c=relaxed/simple;
	bh=LomA8GUpI8sdRKFCa3Um4GsXgiOUnaIWKblSEHMm5+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uz+HnT9TmsK5uSqjLSOtWbEYYflsYpNlgly1xXFm7WnbVkm7PqC23Vp3L3kGGWARIwiydhELSpDuG5FC/MprboE+P4PueBV+sEorwg/qYUUYvcVSGeGLM7HQSMTtsO9ewDyTKG6WKrPkf93lM6CjU4WCKeW/ayWrxSNeMPVdCsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bcKx4NoU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712826598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ADOmSHZc9jJY811In7b/HhEVg4Kn+fgkt58atONJ6W8=;
	b=bcKx4NoUlgEm2cFbAKmPF+2TFUTyRPuYwjZ9zmTShuLwW1IsthUD8wXa3ygpuFyS4CLigQ
	pJwho2AnetBuqxRWPm2np1yw/pdmE/V3NDFwMcT2fJSuvASe/2A6JlwJocICe6reQwzdjf
	t1VODgz2EJHKkxjNW6mX4tX95O+MdCk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-Mw-MClfaO1qaWlJcuSTeIQ-1; Thu, 11 Apr 2024 05:09:56 -0400
X-MC-Unique: Mw-MClfaO1qaWlJcuSTeIQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d86a38bb94so56118601fa.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 02:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712826595; x=1713431395;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ADOmSHZc9jJY811In7b/HhEVg4Kn+fgkt58atONJ6W8=;
        b=B87FR4Xbou75wHOQj+nZLaO54CV+h8C6NwDjh6DAbmEORjGog3usrBfsNb1MozuuoY
         CF9qWcAvfXcsGPUs+YcsMeAUTrw2vumrptcOfyt4oCQf1wrsnemQ2plakgXbZeygE6T8
         KI+w6vlbwNb57gfuyVeIBdjLfaF0gEIMFoYAASSoRkpcYXFCEURyBzEnxzQ983AYaOKK
         S6AbFKOfYgb2bTzWL7wBFdwNvlTFywV+M2htiOXtdPa+misNA6v2JCceiud/MsP8sD0W
         RPTpUfldZlRzf1YF80nDi1NEBEXCwrWqkSZEv/b20RvrSSET7X2mcTlK+CMhs8lJG3bf
         +Nbw==
X-Forwarded-Encrypted: i=1; AJvYcCWiBjlTHnzNeeWh+c4TKz4Zwy6VRJQiA/CK5/nZTgF8aLqb3+sHPZC5iwnV1W9N/YqQN9pwb8X0bDZQFhayTL4pZWVk
X-Gm-Message-State: AOJu0Yw83GaIY+9TLxCGQpSweG1zwtG/F0ig7C4INZIjT3I0fXHnOtbk
	yKY0x8RrRb+H+whcX89q2WqCNdHImhpLPUN0pm4bzgDo8+v5nQ2zvL5D2lCRe+azMn1oHvOx0Wx
	hRnx8hdjPHbPN0EeMZ33wkKTGlQC8h4YaJ4CMn5XDemr19mZJhg==
X-Received: by 2002:ac2:523b:0:b0:516:d1cf:d9d9 with SMTP id i27-20020ac2523b000000b00516d1cfd9d9mr3036813lfl.62.1712826595224;
        Thu, 11 Apr 2024 02:09:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKq69vpbjUyHLI5sFvQeq5wScDoQZLVHjh0UQWSdbhfYa9gG6R3lz0e5WIE85A3e2lxqDHlw==
X-Received: by 2002:ac2:523b:0:b0:516:d1cf:d9d9 with SMTP id i27-20020ac2523b000000b00516d1cfd9d9mr3036792lfl.62.1712826594756;
        Thu, 11 Apr 2024 02:09:54 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:4300:430f:1c83:1abc:1d66? (p200300cbc7244300430f1c831abc1d66.dip0.t-ipconnect.de. [2003:cb:c724:4300:430f:1c83:1abc:1d66])
        by smtp.gmail.com with ESMTPSA id u7-20020adfeb47000000b0033ec9ddc638sm1285725wrn.31.2024.04.11.02.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 02:09:54 -0700 (PDT)
Message-ID: <272c0f71-e817-44a6-8798-0a1535427ba9@redhat.com>
Date: Thu, 11 Apr 2024 11:09:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/5] s390/uv: convert gmap_make_secure() to work on
 folios
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
 <20240404163642.1125529-3-david@redhat.com>
 <20240410193150.655df790@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240410193150.655df790@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[...]

>> +	if (rc == -E2BIG) {
>> +		/*
>> +		 * Splitting might fail with -EBUSY due to unexpected folio
>> +		 * references, just like make_folio_secure(). So handle it
>> +		 * ahead of time without the PTL being held.
>> +		 */
>> +		folio_lock(folio);
>> +		rc = split_folio(folio);
> 
> if split_folio returns -EAGAIN...
> 
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	}
>> +
>>   	if (rc == -EAGAIN) {
> 
> ... we will not skip this ...
> 
>>   		/*
>>   		 * If we are here because the UVC returned busy or partial
>>   		 * completion, this is just a useless check, but it is safe.
>>   		 */
>> -		wait_on_page_writeback(page);
>> -		put_page(page);
>> +		folio_wait_writeback(folio);
>> +		folio_put(folio);
> 
> ... and we will do one folio_put() too many
> 
>>   	} else if (rc == -EBUSY) {
>>   		/*
>>   		 * If we have tried a local drain and the page refcount
> 
> are we sure that split_folio() can never return -EAGAIN now and in the
> future too?

Yes, and in contrast to documentation, that can actually happen! The 
documentation is even wrong: we return -EAGAIN if there are unexpected 
folio references (e.g., pinned), thanks for raising that.

> 
> maybe just change it to  } else if (...   ?


I think I'll make it all clearer by handling split_folio() return values 
separately.

-- 
Cheers,

David / dhildenb


