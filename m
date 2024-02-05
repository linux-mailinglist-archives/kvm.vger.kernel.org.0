Return-Path: <kvm+bounces-7985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1B98498CF
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CB7D282652
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 11:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03AA18C38;
	Mon,  5 Feb 2024 11:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="frWlSQHh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460DC18641
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707132529; cv=none; b=HcjJe3wBRnvbc/yLqepBBF8kNttF1s8Xauh0hbtjKBXPsgOGfEnSQhv3T932gwFjN+KDSfw9ONofZfS6udZzZcZsDkOJB8rl4i7FAnYITRO8Kp/FbgLwUyHQtS25ZVnP0JpIHBNE388pE/ZnDBrXBOtQzCCTC6WgMTofqxtJrAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707132529; c=relaxed/simple;
	bh=2VJYWwkj282qmW4tJsn+V5pmShFHwuBYTY12vqnTrB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TzELBgrKkgngfsPv+Ryy8BgGqUNg0sACKphf0OyyDpvsWpF0EiXM+yAeSL8+6dUZSdOgKGU7fmmB+WD7ke2bYhdX6+ibEl9QtQPSG7nyoXgb/ZeVABV34rDXVdXQKBVv1DmRO9f7KPeLZfupeKXDvMuk1oSwB8t1f8f8KR8ytUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=frWlSQHh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707132527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nUaMZZu+Dp9dwRrEKB8bV8ysB1e4sCJY0FwagGA5ceE=;
	b=frWlSQHhUaIrxA4ECNnKETP3hwojUlGTqcXbrTi/xW2BejpbPE/mZE3CAQhZ2yO3b404j7
	OatKDvfPpv5Ht1wApKPuw1/mnOxR/Egc66+ZkfGC4cCtT6HuBHIbKvj3P3B8UGesKYVGXw
	hD5sEj4ht1MXwfWlvrVwcIlIjpVELoI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-8zyLaBLvMrezdvWQwNWdUg-1; Mon, 05 Feb 2024 06:28:45 -0500
X-MC-Unique: 8zyLaBLvMrezdvWQwNWdUg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-68c4f4411f8so63552376d6.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 03:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707132525; x=1707737325;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nUaMZZu+Dp9dwRrEKB8bV8ysB1e4sCJY0FwagGA5ceE=;
        b=OVWxOSJHZNBXOc4Urr1x8Yufpq3WIYqhm0uYEVLl9Fgrqrw0fGNCZZwsnVsdkj+BK8
         gOBP6+mVjViknmhX1hCTjDnWZsJ0etMCkLe4BZfKlfk1nEFYz2n9gF0EUUjSPQ41keLg
         OA7H8LWFHQpaKdQM+iBp7A6QtsFL16CWsqHpY8rTx4R7JxzJ+yDPeMY3KDW3lR5wDBEO
         jThJuv9fWRQC3/RnSK1T0f0jZrCLZ/5cHjz36RzLlhf5bqc2PHlCAWXHcOgu9kik4lWR
         +wwab1zjDwAUvSK0Z+4sk+XgDQ1+M0JQY4gwvD/PJEnltTXBEtCKh+HsSlN6g1/aHtdi
         3Gng==
X-Gm-Message-State: AOJu0YzxkQjK818WeMNCz1neYyN1tJYCwcF8GQ5cQfWgnXUVMOoHNxbq
	jqA7idwU86MdcsKoHoXwWWDaYuyYIjdkHHkmCOqJoRNeOodTcdaD4T0fKSomStegCI7H9T+lP6s
	9E8oxxR6+iw8TBYMwgCywAuDp734WaCWePjYiMNbS1wlhCf8nFw==
X-Received: by 2002:a05:6214:1bca:b0:68c:5aec:a777 with SMTP id m10-20020a0562141bca00b0068c5aeca777mr10444485qvc.15.1707132525316;
        Mon, 05 Feb 2024 03:28:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8EaWM4B1y1ZetAAd55Aml2aHxbapztaFPxB73e0x4SKOBYmOWyWuKnTkcVyTF/NaB0tj2yA==
X-Received: by 2002:a05:6214:1bca:b0:68c:5aec:a777 with SMTP id m10-20020a0562141bca00b0068c5aeca777mr10444456qvc.15.1707132525076;
        Mon, 05 Feb 2024 03:28:45 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXWPIeAmM4zXqyigLA0WaHjYvNc0iltB6bnBBy8QYvhZLHNBXkjYjHaucBRdJYPH0szT+kDLlvclxWkY5zxZP8lUzEhIXYmjGPkzkA3KlO3Qa2uRQXc9nXwApYOePPqxPh993CX+Ykh5jamYbUskGrr02J+wyVcxl+9yb35OMqMi48kHAZwZg/zppBC1scp8eyLC2fKAfLNawWG2xo2EawCIJYSrvkvLjxiVxsXNPOaclgOUBS2Qog+pId8rXLYpWHB/fFohXulmw0J7f8DgDSfPwPFRsOMVxURBnWOEI/X6tZAL8cEaDB2EZWPlvaEINY5yy9woLltLnE7jzYIZZGeRsspWNDvJgBPDqwzOYxDi3TAFncm1h9WOVQaLnZ8ZjiLaU40OkuC4ZMzb0k4f2AVGD5RBXnICUYtufL9szNSrdRZocVbgybUdJqs2dg617ubop/j5uGuX1VCXNWQ1YgZ2Su7HbPkAQ/hZidUC3/U
Received: from [192.168.0.9] (ip-109-43-177-196.web.vodafone.de. [109.43.177.196])
        by smtp.gmail.com with ESMTPSA id nz10-20020a0562143a8a00b0068c7664112bsm3658473qvb.52.2024.02.05.03.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 03:28:44 -0800 (PST)
Message-ID: <003f43ab-cce9-408d-8354-b7884f513ad1@redhat.com>
Date: Mon, 5 Feb 2024 12:28:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 1/9] (arm|powerpc|s390x): Makefile: Fix
 .aux.o generation
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-2-npiggin@gmail.com>
 <20240202-2f93f59553cec386791f7629@orel>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240202-2f93f59553cec386791f7629@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 02/02/2024 10.30, Andrew Jones wrote:
> On Fri, Feb 02, 2024 at 04:57:32PM +1000, Nicholas Piggin wrote:
>> Using all prerequisites for the source file results in the build
>> dying on the second time around with:
>>
>> gcc: fatal error: cannot specify ‘-o’ with ‘-c’, ‘-S’ or ‘-E’ with multiple files
>>
>> This is due to auxinfo.h becoming a prerequisite after the first
>> build recorded the dependency.

D'oh, of course I only tried to run "make" once when testing that patch :-/

>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index 54cb4a63..c2ee568c 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -71,7 +71,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>>   
>>   ifeq ($(CONFIG_EFI),y)
>>   %.aux.o: $(SRCDIR)/lib/auxinfo.c
>> -	$(CC) $(CFLAGS) -c -o $@ $^ \
>> +	$(CC) $(CFLAGS) -c -o $@ $< \
>>   		-DPROGNAME=\"$(@:.aux.o=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
> 
> There are two instances of the %.aux.o target in arm/Makefile.common. We
> need to fix both. We can actually pull the target out of the two arms of
> the CONFIG_EFI if-else, though, by changing the .efi/.flat to .$(exe).

I went ahead and pushed this patch with the trivial fix for the else-branch 
to the repo to unbreak the build. If you think it's worthwhile to unify the 
target, please provide a patch to do so, thanks!

  Thomas


