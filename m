Return-Path: <kvm+bounces-28450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABE8998A66
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC92D2885CB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E7C192B78;
	Thu, 10 Oct 2024 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJaKV3d3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB731BF7EE
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728571119; cv=none; b=Jjicv5gAi/ZeOzJ3kwPnOFlJvjoh5Rz9SlKVpvA0ZRsR68LiKcV8SS8MdRED2SRySKesuGy+TSPL5xQTTNBfH6PRgn1pwdLIHSWyNOBL5oV5IEJ3rgY1al8TyhIgIe9Qy34esLUGw3wXAFgfUgK9jXwf6sEPORMg90XoEg+wAZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728571119; c=relaxed/simple;
	bh=3fTxEPbifHUu4W2PjvRf3bEFoNEQuadJkSqIIVLLoIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YrQ87/QE39q7DtXgpwxVWjxXw/YidWzyodFfNRwJM9Gtl7+/TKVCGAKUek0sYT3urV5DhBY4MPwvjol2Uh2oquJDHSf+/sFuC8m47uMhOqqPJzKkqtqN+bovQuqIUjVl8M97HApvs6sNCgR8O2UiMetK9TVld+eKMCKxqDqx0uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJaKV3d3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728571117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oFmucd1tjbMXpH6BhRFfMWHmuMpN8IUvUiP9/Gf7lMI=;
	b=gJaKV3d3I7tQyVgS0QIo8or/VqZFgzLGXDT5fBtYWnN7R3GxTsOhbWCqQYmFmtsQC52QBB
	+f3Jnr9COcZeJ6bgWOCuslRVZ7g5wL8TfqoHJ++FevT71/rWafXKNa59VbKzmHAuCcZpNT
	NZutUEotJUyZCtsRR7/t/sW4zIc/6OA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-AvgNfwNCMyW0u46DMqy3nw-1; Thu, 10 Oct 2024 10:38:35 -0400
X-MC-Unique: AvgNfwNCMyW0u46DMqy3nw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42cc4345561so4998795e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 07:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728571114; x=1729175914;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oFmucd1tjbMXpH6BhRFfMWHmuMpN8IUvUiP9/Gf7lMI=;
        b=ifYqx54muB8n/D+yFCHHzNpQOPhewvg8F5afdQcUsw1LzwT3f6uiKP6mLtl75kL9iO
         sCBhgwP6nvUeqakx+UAXcldugHHHgnFZ36KS5EWOoMx0ktDIaYI80Hz00b3/m7jlKTx7
         1QeU0YJKSFE1eq0MzW7OCuSqHg29qW+7tQ6naVeq+fqOR/lJRicFOoGivp4G8uqTsmBN
         nmu8jsiQ9t0NHl65RlV44liuTjmRSFByDC/c+o9d2JW4XleYuw6Zeb6m7RA5SnGlkpet
         8O2TiMSSv3aWibueKQuFGtwXkaGFL7zqIja5zf270ka0dcZSh9zsaoiOaZ2z1PSh1HY8
         Cxcw==
X-Forwarded-Encrypted: i=1; AJvYcCVI6Bn6liUHa9jYzhLL0qTen2XqdT4G9Lx5Ev+7F+e8Cclr8D/r41LNf/TX0LfT0qshvv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzCtnn+U+JRLuGESjEF5IqBQFHYUMPfgU9xWIJn9+YgcRm8LoH
	NJrBfm7M297C+mOLwBbJBMTb0A+zLQWWYtAgwvsJ06KovTvnB2ptR/xWlxeSdXJDzVJZD5aqQNT
	W/CTo3x7eZ8aArNQlZMXC4X25GZaRXMfncjXqyS5jS29DtpTnKw==
X-Received: by 2002:a05:600c:1c29:b0:430:5760:2fe with SMTP id 5b1f17b1804b1-430d6faa3dbmr48675335e9.22.1728571114530;
        Thu, 10 Oct 2024 07:38:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDKwax8aPzg4JvG645MP+BM3IF8TA3D8StC0EHtjWYq3PRY/ARmocoalcP37NxleH8+J0vFg==
X-Received: by 2002:a05:600c:1c29:b0:430:5760:2fe with SMTP id 5b1f17b1804b1-430d6faa3dbmr48675115e9.22.1728571114102;
        Thu, 10 Oct 2024 07:38:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c742:9200:eb2e:74f9:6f5c:3040? (p200300cbc7429200eb2e74f96f5c3040.dip0.t-ipconnect.de. [2003:cb:c742:9200:eb2e:74f9:6f5c:3040])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431182d790fsm18132815e9.6.2024.10.10.07.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 07:38:33 -0700 (PDT)
Message-ID: <b5c4d379-7b6f-4bad-bc62-8e9ee630f503@redhat.com>
Date: Thu, 10 Oct 2024 16:38:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: Fuad Tabba <tabba@google.com>
Cc: linux-coco@lists.linux.dev, KVM <kvm@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
 <CA+EHjTx_OumyOk1zZrUh1uwkBncsXZxMKD6Z_j4WjZrd+2LVLw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTx_OumyOk1zZrUh1uwkBncsXZxMKD6Z_j4WjZrd+2LVLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.10.24 16:30, Fuad Tabba wrote:
> On Thu, 10 Oct 2024 at 14:41, David Hildenbrand <david@redhat.com> wrote:
>>
>> Ahoihoi,
>>
>> while talking to a bunch of folks at LPC about guest_memfd, it was
>> raised that there isn't really a place for people to discuss the
>> development of guest_memfd on a regular basis.
>>
>> There is a KVM upstream call, but guest_memfd is on its way of not being
>> guest_memfd specific ("library") and there is the bi-weekly MM alignment
>> call, but we're not going to hijack that meeting completely + a lot of
>> guest_memfd stuff doesn't need all the MM experts ;)
>>
>> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
>> development of guest_memfd, in particular:
>>
>> (1) Organize development: (do we need 3 different implementation
>>       of mmap() support ? ;) )
>> (2) Discuss current progress and challenges
>> (3) Cover future ideas and directions
>> (4) Whatever else makes sense
>>
>> Topic-wise it's relatively clear: guest_memfd extensions were one of the
>> hot topics at LPC ;)
>>
>> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
>> starting Thursday next week (2024-10-17).
>>
>> We would be using Google Meet.
>>
>>
>> Thoughts?
> 
> That works for me, thanks!
> 
> One thing to note, we're coming up to the period where the US/Europe
> move away from daylight savings, but not at the same time. Just
> something to keep in mind :)

Right, I'm located in Germany, so it will be a different "late" for me. 
(see how nice I am to US people :P )

-- 
Cheers,

David / dhildenb


