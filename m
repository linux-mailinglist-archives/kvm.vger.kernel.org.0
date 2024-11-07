Return-Path: <kvm+bounces-31139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF519C0BC3
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 17:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EC9A1C20434
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49C0215F6E;
	Thu,  7 Nov 2024 16:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUg8qcvj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D81920CCD1
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730997287; cv=none; b=UvLCtwHfG9aBTRFPP7pR2fgB3fRPQ2cb8mtI2+9UJC8ErsWxtVm+om3YRiHQAaqe481mrxKpd/3/LPsonkjq5NFrVYK2L1axqCHhLyXjFoo7IfRQVFELtm31SRvcZlyADv1AYPwR+IrYbaXhddF7j2L3qRsWcItaiqM3zyIwlVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730997287; c=relaxed/simple;
	bh=OeXPl1FGQ+0FJRm+txocHVQZLSpAGK/pGbJCeVq/YjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qHkL6JDppjVaPZs/QzENNsS3wVYdQBSV9UIvyV1B18fdqE5nFPFBjfDJbuqexS/v12m9BXhfoaMyjzC5Ne+a+Yb8Kiq2J/i8Le6ajXP5a9NCYaa6KqYUbHB1lIEAnko5+f+AsPT8CEDmlDVjCmaL0Fq4Fqo/mcdnjtIkziB10ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUg8qcvj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730997284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/ZhQtCCJ+QeNwkTGhIaEaU8V5oy77KACcRuqKPJDZpI=;
	b=DUg8qcvjWLlzZ4LIFwsqMsZd5A0l0gVtbt/mPzFECAJidQ/+OcOUpmpQZ37amjKL97Hna7
	8kSMzMpWEE14FC3vTyIr+L58is/67wsHy/u9dj+mMsO8lYZTCjpHz6bZAyJRuPUqG7W4P5
	AhE8Sz6Jcypk5F95L41KfWZm+NSnla4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-CABO67YtMAWryyEsbV5g6A-1; Thu, 07 Nov 2024 11:34:43 -0500
X-MC-Unique: CABO67YtMAWryyEsbV5g6A-1
X-Mimecast-MFC-AGG-ID: CABO67YtMAWryyEsbV5g6A
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43151a9ea95so12204275e9.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 08:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730997282; x=1731602082;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/ZhQtCCJ+QeNwkTGhIaEaU8V5oy77KACcRuqKPJDZpI=;
        b=ZSGk8AMxnHLS6HBcjURA3H4T9klQyfoBRLrBdxVVrY9Q+3qFL7DBvkYMjWC19WZIX3
         NdVyS5NwuVFUN+XJQCbmkfk1Ybv15Rlbb6v877rwnw+miTHb4C8p/us3z2EF70zxnarg
         ABSgSfvLVVEpA839rXa6MIT1QBztv4L/9q/z6CeRn21pZqYeNaissE8WLSUsVATuPXFC
         E7NhlvPbSR58LidEuYD4FIHsHd7ZaRrebj8hlo88H/H0JMB3QvjpPCYkFHURqrMq7X5f
         gKtfzTaiJ3vDlex7Ge2Ov0am7ObPSlC+4royyudCk6xb9TNELfUv/xBvGqGXYdBpDKuH
         DdPw==
X-Forwarded-Encrypted: i=1; AJvYcCUcvEoSFdykjK8niWtFDS76eFasXNYJLgBtCpPwtUfF8yChTwMhuPjDmX45Q70bPCpRSZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBPWfRD3uuQI/gbe8cY2zDLd0d2zYTimApxm3Js4hnyrWNJDcl
	qXIeikER6O3ohjzIy6mnfskqYquGYb3WG898AEAHdFG+L8ExUngtmYaPxAU+SHbOK4TlcdIZcig
	QB0nBJnIieUuaxqjoC2UNN5OkiumCQR+mhKRk+OrW4W9IyxVrxA==
X-Received: by 2002:a05:600c:3c82:b0:431:7ccd:ff8a with SMTP id 5b1f17b1804b1-432b686e2femr1500645e9.14.1730997282173;
        Thu, 07 Nov 2024 08:34:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnMEuJ1zS0g37JYfnG48bMO5TvDO+F7XkQt1/ypB8HPW7mSurE6O0zL+TU9r1Pp99uUAfyWg==
X-Received: by 2002:a05:600c:3c82:b0:431:7ccd:ff8a with SMTP id 5b1f17b1804b1-432b686e2femr1500465e9.14.1730997281810;
        Thu, 07 Nov 2024 08:34:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:7900:b88e:c72a:abbd:d3d9? (p200300cbc7087900b88ec72aabbdd3d9.dip0.t-ipconnect.de. [2003:cb:c708:7900:b88e:c72a:abbd:d3d9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6b2c32sm65683325e9.10.2024.11.07.08.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 08:34:41 -0800 (PST)
Message-ID: <ada851da-70c2-424e-b396-6153cecf7179@redhat.com>
Date: Thu, 7 Nov 2024 17:34:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ISSUE] split_folio() and dirty IOMAP folios
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 kvm@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <4febc035-a4ff-4afe-a9a0-d127826852a9@redhat.com>
 <ZyzmUW7rKrkIbQ0X@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZyzmUW7rKrkIbQ0X@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.11.24 17:09, Matthew Wilcox wrote:
> On Thu, Nov 07, 2024 at 04:07:08PM +0100, David Hildenbrand wrote:
>> I'm debugging an interesting problem: split_folio() will fail on dirty
>> folios on XFS, and I am not sure who will trigger the writeback in a timely
>> manner so code relying on the split to work at some point (in sane setups
>> where page pinning is not applicable) can make progress.
> 
> You could call something like filemap_write_and_wait_range()?

Thanks, have to look into some details of that.

Looks like the folio_clear_dirty_for_io() is buried in 
folio_prepare_writeback(), so that part is taken care of.

Guess I have to fo from folio to "mapping,lstart,lend" such that 
__filemap_fdatawrite_range() would look up the folio again. Sounds doable.

(I assume I have to drop the folio lock+reference before calling that)


It's a bit suboptimal that the split_folio() caller has to take care of 
that. But it's similar to waiting for writeback ... now I wonder if we 
should have a helper function that takes care of "simple" cases of -EBUSY.

> 
>> ... or is there a feasible way forward to make iomap_release_folio() not
>> bail out on dirty folios?
>>
>> The comment there says:
>>
>> "If the folio is dirty, we refuse to release our metadata because it may be
>> partially dirty.  Once we track per-block dirty state, we can release the
>> metadata if every block is dirty."
> 
> With the data structures and callbacks we have, it's hard to do.
> Let's see if getting writeback kicked off will be enough to solve the
> problem you're working on.

Let me find some time tomorrow/next week to play with this.

Thanks!

-- 
Cheers,

David / dhildenb


