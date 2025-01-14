Return-Path: <kvm+bounces-35364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D58C5A10321
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 10:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B15313A6C6D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6EB128EC97;
	Tue, 14 Jan 2025 09:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Id07uPVQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4285E284A5A
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 09:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736847453; cv=none; b=V8UQgwKMvbB9iAMC96Xl6aqCFRTmbft+oU98m1+3mYY+5ADI2qNXPizE5hz2ZDBiBN17FLrPsXGGIqs6u1Jfj95LaCM8Uai7YouLbbwpp1O3QcPMKnFx3cUeqaeO7dbkqO4i1sMdrl947w9/0sHtF+QUTaO4llTpvOPzpcdJEyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736847453; c=relaxed/simple;
	bh=bxSSQwDA4tkUQvp2I97QdvBvpAZv/bPt3cwtmur404s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VZMlDJOSRNtLdEEcWhBlXQgjJ/K3bsb4aDacgyF9f3vAvZvx7x/Cpt/c84vfgWZx7n32XhegHjZ3vfS/tf9cMFqCmvHLwZOuBKRH5fQyr4bAAlNjxDxZ/DwRpyHi5L4XWZB09AQnBFkWUIj+CL1Z4685feoFeWrSVwm5i64HTwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Id07uPVQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736847451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4unegCf1Wu0YCpS63WtY/VfzJKeqoFkiV5mkzWfDj/Q=;
	b=Id07uPVQnMiYv9geaz+3BxszpPRg17P+o1+1ZmCYli2K66geFuric698b5dMuBd0eOu8Ln
	RvijTyFJC1oJv+u3KqcZ2y3yMybhW0ACf0xwbgROdeiIhPkv6/A7shD2nZcKPZcG4R+QEc
	V1kRTfysUEzfwcTKqVxxRMTa3HCl22s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-u8398Eu1P62WsPeRQcFGPQ-1; Tue, 14 Jan 2025 04:37:29 -0500
X-MC-Unique: u8398Eu1P62WsPeRQcFGPQ-1
X-Mimecast-MFC-AGG-ID: u8398Eu1P62WsPeRQcFGPQ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385d52591d6so2292583f8f.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 01:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736847448; x=1737452248;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4unegCf1Wu0YCpS63WtY/VfzJKeqoFkiV5mkzWfDj/Q=;
        b=EHaHu3h7AffHJD7dYd8z6V1juLNvuj53/ZbuID1pqFS3j05tnAqbOxrIcM8G1o6vVr
         O5EgQoIwxjKAd9LYVQ4DxTNoTy3y6udpKlhpUbErUUPIwplphcu8arQW4UF+1T0Sr67U
         haHzmL3KlR0BbHJM7/pLZtLvM88nB70apNZTAStmHmgTHKxSATDILWAHnMdAqhIa1C1P
         k0ToCGTV288xlNIPrbL2Dn+7XZqgPQ7xLNfAuzxddvLqpzXZZSC1JA7Vu0EMK7umBNwv
         oNU2bnl2oRASG1rc2dC5VgzFFbh7KRiHtB3DIt1Xdlh7+M2WsW4sSaMlD7Tug6TT6uKS
         4klg==
X-Gm-Message-State: AOJu0YzNxfV4ZV/ZeLtA0JoRM8wkZG6Tq6Cz9zJys3U694986UpDO4dG
	Ix8pE0NQflbt5N8/VU/jw/OUCVxH8tr0SNlwnwd8Q1GRg3zgWi17qLAv1595d5c6AjT6h7y+R4V
	/kTdWSxeHMKSY6/KID9Vhhi5FLleGzW526dzMyLd9iULsby/CGA==
X-Gm-Gg: ASbGncuJbXLnH4GCmVFCEDb5CdT27J2LC/fDhtB8V4/cEub7Ps6IlQY+dI4KfZ9jhyP
	CFvjYYbiDS+w48h/ZHgQUBLCYTBXlaYd91pRNhOHM3lrhV+di3Jrt2agxUFKzRJKfAWjxhyKd7j
	VJ/8YgQz1syFv8cLkQI2OHP7Pm/l3zTFnl6vJC1HOGysb7ljgRXltY+27Y6OH9DskghIxkmou9u
	5aaB0iMB5pAfu9zsGcwHM/XaCOFCF6f2Df/vs0ThcW4i5ZWyBrqrFo7WY8LGWihOkNB0HbynpaA
	JId0gXZzULgVPZ5CUBG4UwpxwnknwnyqPvzdMs5LGFeeXBw2EkImtWZmS3bq2+t+Xm/nIBiWrnG
	/HX/j4LMd
X-Received: by 2002:a5d:588e:0:b0:386:4332:cc99 with SMTP id ffacd0b85a97d-38a8b0d61c6mr18692626f8f.17.1736847448446;
        Tue, 14 Jan 2025 01:37:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1R7B7r1cnpdi1vg+SF7dPfwDe3mdJkF7aesF1fW15UEOU9zYrHVCeaEO1rBg7o+/IJOcWZw==
X-Received: by 2002:a5d:588e:0:b0:386:4332:cc99 with SMTP id ffacd0b85a97d-38a8b0d61c6mr18692602f8f.17.1736847448055;
        Tue, 14 Jan 2025 01:37:28 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2dc0bb7sm201505755e9.16.2025.01.14.01.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 01:37:26 -0800 (PST)
Message-ID: <6e42d4d1-2673-4a89-aebf-5b15ac9bde2f@redhat.com>
Date: Tue, 14 Jan 2025 10:37:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] KVM: s390: vsie: vsie page handling fixes + rework
To: Christoph Schlameuss <schlameuss@linux.ibm.com>,
 linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20250107154344.1003072-1-david@redhat.com>
 <D71OMSL3ICG0.2AXYO3UR6MS50@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <D71OMSL3ICG0.2AXYO3UR6MS50@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.01.25 10:18, Christoph Schlameuss wrote:
> On Tue Jan 7, 2025 at 4:43 PM CET, David Hildenbrand wrote:
>> We want to get rid of page->index, so let's make vsie code stop using it
>> for the vsie page.
>>
>> While at it, also remove the usage of page refcount, so we can stop messing
>> with "struct page" completely.
>>
>> ... of course, looking at this code after quite some years, I found some
>> corner cases that should be fixed.
>>
>> Briefly sanity tested with kvm-unit-tests running inside a KVM VM, and
>> nothing blew up.
> 
> Reviewed and tested the whole series.

Thanks a bunch!

-- 
Cheers,

David / dhildenb


