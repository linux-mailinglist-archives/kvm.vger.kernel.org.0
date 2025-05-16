Return-Path: <kvm+bounces-46852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EADABA346
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 20:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA5E5507163
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 18:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC1C27FD6F;
	Fri, 16 May 2025 18:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DC4DBjyA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4243727E7E3
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421799; cv=none; b=gpG0z1QbRoCANE/jJyz89f4lsSrf0GpAeq4EN3Tjm1RBH84tkfigKQB1u9vDN0vvM3jAKKdCAymsE+22OVI+EyRqe3PMwVA1UUjlbzgTYCHQz8iKApj/9y4nBeI2bDxF+nycOSfPwQDtSIbWZq0oxoeFbubkceep0K+AwS0KUKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421799; c=relaxed/simple;
	bh=7UqtzUtVmyD7A3rWpGZUDe3v1crBMFvZJX7iNW8CaaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/cxyOGHVd2vIc31dRdNi4H7pimdxTdAOXg6LOXMvLjCPOVOX70O7hFXSaoLOR9NvvSm9pubkiANwypLhmsZN6ZVB2AzU5/XsZXdGKIYcreOI5D1byKnMrUsqMfejt/qID5rPoo8oVfurUCL8R8bTW6g6HgYu0JJpRoITGpdqwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DC4DBjyA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747421797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ifcGTgJelxajCiU2FWoz2x8XggC8WSn+rbLJz+ygqMw=;
	b=DC4DBjyA57Q9TARW0ix2o1JewLqvIbU8dy/QEtsG8P6E9fKRyP4VElIdU1jg+VHaaVMiKy
	YRerSp+jjmfxk1baSw/owIefkegLWgqNpOb5ATxSYxZlEQ62JmfnHSTFWhbIv6jbGyoM57
	MJG+FX5MUPF/qY6AeOq3kgZOjt7t3g8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-MWVFgW29P26IOIZF-GGbQQ-1; Fri, 16 May 2025 14:56:33 -0400
X-MC-Unique: MWVFgW29P26IOIZF-GGbQQ-1
X-Mimecast-MFC-AGG-ID: MWVFgW29P26IOIZF-GGbQQ_1747421792
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a35ec8845cso591695f8f.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 11:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747421792; x=1748026592;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ifcGTgJelxajCiU2FWoz2x8XggC8WSn+rbLJz+ygqMw=;
        b=USJfzwdgrHfNIe2XJ4UbioC415oz01JPpM5GgkxWse1Vrz/nZx3C4AYlLglpX/NXqg
         hUfxC9wRFS++c/YD+wPYR4mf4bauoUwl6J20WaTCYq2v/OE5M5rxkyjUy6gBI3NR8Dit
         biV6KfVuADFwaKyir6UZIvIdT3bGqzrRlN2dYNz0LxWdHBdp0l7SvKO494SFt8aEbrW6
         9H5fljJPrmH+iRJ9KhJ050Gt757DhjAuKefaep84Kf1jlGmLh//hgKFhUUfs4/RPggpn
         rdFclq99TS9YM5erEthZ5ZNE25DqzEBtqDDJgRbcjbfezIM3Q+DDvOLoVcYkiBILs2eE
         FKXw==
X-Forwarded-Encrypted: i=1; AJvYcCUWAKMIj0x3gEvbIUs+wQhIXCmhYTHderSPix9aMgL4a8RtFktxaM2QPw0kdaCSV0ialSA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXKe6+5Fk6+Vg6CYCtpsNYKvNsS0PwOlIgDCsGEINhtsLEHc+f
	qb6YXac9z79+liVrNGrmM6v54ypGZTfmRpDD5WuJQ/biswhn3A7oNQA9euP06NIgu/rTaL+D/mM
	Wo7colA4N8PTGprHT9k9NxvRpfPNX2mYMvSvYNIwSSzzdZjonrmOrWA==
X-Gm-Gg: ASbGnctQxGY1I3Ed7n4HBOgEmxWNKGKkKiy1ER7gFv3gxQ7TPRqRQ22Ql2cXNzqyXER
	ZJteg/2pgCWcBO5TenN0pJczB22/Ofh/tanakhJj5cJ4yxT9yIaAJnCc2iLCXIv1luOdo+rMT4f
	/EBA+MjG+fCWYdrnYJJaBQDFSkMn1s0e1SJNoYPvJfRwqUz8c/ikdZirPYL5quFFXJaXvtTX5n/
	BpUr5td5HYgiL47sCn2fmbRrtn49aUzSbp5X2VQBntLYnJj3PWRJRKNDCYmnUB2J8z/2+iLbYqA
	tkwvzs3v45b4YI41XQD+dKW1SbBJ2mfAi2/l67SX3Q==
X-Received: by 2002:a05:6000:2dc2:b0:3a0:b65b:78ef with SMTP id ffacd0b85a97d-3a35c845c04mr4820395f8f.52.1747421792493;
        Fri, 16 May 2025 11:56:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkqi1Ur9MV4UU247rCekfZQh5zJYD0LlUxflLVxHjPBhdhdSsqXUpzAVzfUm2pO8VCCsxcJA==
X-Received: by 2002:a05:6000:2dc2:b0:3a0:b65b:78ef with SMTP id ffacd0b85a97d-3a35c845c04mr4820376f8f.52.1747421792158;
        Fri, 16 May 2025 11:56:32 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ac29.dip0.t-ipconnect.de. [87.161.172.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d230sm3656530f8f.4.2025.05.16.11.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 11:56:31 -0700 (PDT)
Message-ID: <eb93777b-cb74-41d9-80e9-a700bf693d4e@redhat.com>
Date: Fri, 16 May 2025 20:56:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] s390/uv: handle folios that cannot be split while
 dirty
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Mitterle <smitterl@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
 <20250516191748.3bd0861c@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250516191748.3bd0861c@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.05.25 19:17, Claudio Imbrenda wrote:
> On Fri, 16 May 2025 14:39:43 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>>  From patch #3:
>>
>> "
>> Currently, starting a PV VM on an iomap-based filesystem with large
>> folio support, such as XFS, will not work. We'll be stuck in
>> unpack_one()->gmap_make_secure(), because we can't seem to make progress
>> splitting the large folio.
>>
>> The problem is that we require a writable PTE but a writable PTE under such
>> filesystems will imply a dirty folio.
>>
>> So whenever we have a writable PTE, we'll have a dirty folio, and dirty
>> iomap folios cannot currently get split, because
>> split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
>> will fail in iomap_release_folio().
>>
>> So we will not make any progress splitting such large folios.
>> "
>>
>> Let's fix one related problem during unpack first, to then handle such
>> folios by triggering writeback before immediately trying to split them
>> again.
>>
>> This makes it work on XFS with large folios again.
>>
>> Long-term, we should cleanly supporting splitting such folios even
>> without writeback, but that's a bit harder to implement and not a quick
>> fix.
> 
> picked for 6.16, I think it will survive the CI without issues, since
> I assume you tested this thoroughly

I did test what was known to be broken, but our QE did not run a bigger 
test on it. So giving it some soaking time + waiting for a bit for more 
review might be a good idea!

-- 
Cheers,

David / dhildenb


