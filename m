Return-Path: <kvm+bounces-31321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7F59C259C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D66E41C2372D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D46E1AA1E0;
	Fri,  8 Nov 2024 19:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L60C5nhK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0D4233D79
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 19:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731094437; cv=none; b=vGW8KpfEjWKOTwGWZyjvsqyrfqvfr2rZLlPZ586b1sT5RCh3IAdKwdIlzPbzBnBHv1EtRQxq8eJYEpxdlDgeVBjsjJPTCt2MNRv/kfr5tKppDPs+XoqmNX07nJ4tQZAbg7r2u3KByFi2DtLC1OvRpSLasFjh1Zby7elXOIaqQ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731094437; c=relaxed/simple;
	bh=KweBl36s4/H99uK8UesqyH1H3r6bKOmdFNYxnEq5ADU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDgp7PWvzr/5aISIlkDp6bGr2I9odSUKZtWGzqCPka0jjB4W+2uiGdnbh/X0XsWQaxyaCCJybepaQtdzoQZhE4+5yFpVEBdTs1aDjjGcOH8bPecM+BT2srD/J+ubIEJcTnrwJzcfG6aoi/Ha5BXVzsszf1oSEM8Le/lYqSSBNCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L60C5nhK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731094434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HXUvQ9DDoTuKmTlcnKhUpWVHW2+zg/XnWwIaMSXVfPs=;
	b=L60C5nhKRy5F5hnXiDEA83IG1rydqE53hf+s6hxB5RQEEIByPxy0B5iNQ15t2frXbnTsjw
	T5om+zYWuA6QQAU4mlqwRydd82MQ2s0vXaxmSYnI6Cl4up1AZ1vzerhwcaMAMu13AerwVT
	L7WB75zHpsJICtQajS3MP0GMs1OjSwc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-I1fAOYTXOgG6UgyoIAMbMQ-1; Fri, 08 Nov 2024 14:33:52 -0500
X-MC-Unique: I1fAOYTXOgG6UgyoIAMbMQ-1
X-Mimecast-MFC-AGG-ID: I1fAOYTXOgG6UgyoIAMbMQ
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d4af408dcso1174592f8f.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 11:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731094432; x=1731699232;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HXUvQ9DDoTuKmTlcnKhUpWVHW2+zg/XnWwIaMSXVfPs=;
        b=CXmy9Vo/l2jQRXBxuu8qyOp/c+1FLfh4Cv5TINjOGjasoc2/2RAzRLHFllGU1qrcd8
         REybsNq0TlByEkRKBu5upWY+so98tqKoxOABcgoZ7EIBzrUG6wOmwKZkcc73aE5anX84
         oy7GMAlzPEXUePW1KgzLqBYXNz/YY8yH0ll4KdTy6jqyUJ/xOmBzFdTd7IewLdnPULDe
         0Pt6l8rsJpRfe8cN1YDJzEwU06iUH5CbOv++Qt9J1DqAUgIW1gvfgKCyhNLgzHeYeJkr
         mIq8WrBEkiTcUV4O4aFmNsR15C192Fymj+GdSH4tcR5f4pOvS9e/aCbMJlXHH4Czm2EL
         tXLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWJrnl9X24WPBkYvM2bDTgRMpFEZ0/rEm4Wi1xMr5Rx9+abj8Q/MlDiqjsLInyf8SvOYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvJwRZyhl+xkjZKVQ3YXD6BjUaZX4YK+CiWZ6U4GT+HYOEyAAK
	/GaKB3wNF7e5Zzp7MU09/kAbNqgOQNY8h28hsxWQFDXJ9wDj0RkORwHXa6FaKeFZb0P9nR9/lYa
	TbgclF8YtRy56Gq/vI1PNMIDf0PwxknCWHL2EDFnrjAdRSq8Cbw==
X-Received: by 2002:a05:6000:1564:b0:381:d014:9be0 with SMTP id ffacd0b85a97d-381f186c6a3mr3649574f8f.17.1731094431742;
        Fri, 08 Nov 2024 11:33:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMHDodmRF53aDkZGw6BGZ9F+ccf5Mc+bz5kN7YN38h8pDU+2YBOqvKdtD83yKuSgIuDHnfag==
X-Received: by 2002:a05:6000:1564:b0:381:d014:9be0 with SMTP id ffacd0b85a97d-381f186c6a3mr3649554f8f.17.1731094431330;
        Fri, 08 Nov 2024 11:33:51 -0800 (PST)
Received: from ?IPV6:2003:d8:2f3a:cb00:3f4e:6894:3a3b:36b5? (p200300d82f3acb003f4e68943a3b36b5.dip0.t-ipconnect.de. [2003:d8:2f3a:cb00:3f4e:6894:3a3b:36b5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed9ea7c3sm5912898f8f.80.2024.11.08.11.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 11:33:50 -0800 (PST)
Message-ID: <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
Date: Fri, 8 Nov 2024 20:33:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
To: Jason Gunthorpe <jgg@nvidia.com>, Fuad Tabba <tabba@google.com>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, rppt@kernel.org, jglisse@redhat.com,
 akpm@linux-foundation.org, muchun.song@linux.dev, simona@ffwll.ch,
 airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com,
 willy@infradead.org, jhubbard@nvidia.com, ackerleytng@google.com,
 vannapurve@google.com, mail@maciej.szmigiero.name,
 kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk
References: <20241108162040.159038-1-tabba@google.com>
 <20241108170501.GI539304@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241108170501.GI539304@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.11.24 18:05, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2024 at 04:20:30PM +0000, Fuad Tabba wrote:
>> Some folios, such as hugetlb folios and zone device folios,
>> require special handling when the folio's reference count reaches
>> 0, before being freed. Moreover, guest_memfd folios will likely
>> require special handling to notify it once a folio's reference
>> count reaches 0, to facilitate shared to private folio conversion
>> [*]. Currently, each usecase has a dedicated callback when the
>> folio refcount reaches 0 to that effect. Adding yet more
>> callbacks is not ideal.
> 

Thanks for having a look!

Replying to clarify some things. Fuad, feel free to add additional 
information.

> Honestly, I question this thesis. How complex would it be to have 'yet
> more callbacks'? Is the challenge really that the mm can't detect when
> guestmemfd is the owner of the page because the page will be
> ZONE_NORMAL?

Fuad might have been a bit imprecise here: We don't want an ever growing 
list of checks+callbacks on the page freeing fast path.

This series replaces the two cases we have by a single generic one, 
which is nice independent of guest_memfd I think.

> 
> So the point of this is really to allow ZONE_NORMAL pages to have a
> per-allocator callback?

To intercept the refcount going to zero independent of any zones or 
magic page types, without as little overhead in the common page freeing 
path.

It can be used to implement custom allocators, like factored out for 
hugetlb in this series. It's not necessarily limited to that, though. It 
can be used as a form of "asynchronous page ref freezing", where you get 
notified once all references are gone.

(I might have another use case with PageOffline, where we want to 
prevent virtio-mem ones of them from getting accidentally leaked into 
the buddy during memory offlining with speculative references -- 
virtio_mem_fake_offline_going_offline() contains the interesting bits. 
But I did not look into the dirty details yet, just some thought where 
we'd want to intercept the refcount going to 0.)

> 
> But this is also why I suggested to shift them to ZONE_DEVICE for
> guestmemfd, because then you get these things for free from the pgmap.

With this series even hugetlb gets it for "free", and hugetlb is not 
quite the nail for the ZONE_DEVICE hammer IMHO :)

For things we can statically set aside early during boot and never 
really want to return to the buddy/another allocator, I would agree that 
static ZONE_DEVICE would have possible.

Whenever the buddy or other allocators are involved, and we might have 
granularity as a handful of pages (e.g., taken from the buddy), getting 
ZONE_DEVICE involved is not a good (or even feasible) approach.

After all, all we want is intercept the refcount going to 0.

-- 
Cheers,

David / dhildenb


