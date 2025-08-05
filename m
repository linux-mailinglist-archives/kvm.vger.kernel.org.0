Return-Path: <kvm+bounces-53986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCACB1B39C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:41:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B64F8181C35
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9191C271A6F;
	Tue,  5 Aug 2025 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RhNusIZ2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC8F1D5CEA
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 12:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754397705; cv=none; b=n+RlH2Pbs9qD1l9FpCd1Ftf9UEkYWFMdFLKUrARAarFtPKS+v0o60jepqgC2cOOiWkY7Ar1KHmMzvePodSEycr/bRQ5GwmSLZVd9Jud7oAiyGrDrQg1jo4uTBJNs17gOIiSGXt6EwUcOlkegFWXx7A9b8+k4Jb8jcGFgkm1zOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754397705; c=relaxed/simple;
	bh=4edKX8MFzsIe2nUyt0nx9Wcw7CNGyzbjHNoleZLrPrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=doWeth4k0ZD1Q1MVYursEUyLoYqga1lZC4qnOjpo+miiZwWtfs8DLX+8mRGn50AXE+1cDdSt95ui0HpezFpxZfPXRToZ7ucFb6zoq8CeY4VmMxEhAFyVI37K7+dE5RkJQR4B61a8N8Dt/ZcqeqpEfYJElea6qdEO+/S78iqFKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RhNusIZ2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754397703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7uQFaJ04uOldMqJWhw/ZrijNlur8OaDP5isRSjWvgMQ=;
	b=RhNusIZ2RhYrf5ePdpLvm1anB6mnUVP47tz2iT/rPhH3za4ldqm1IC0GxmHQ74//U+CVPB
	y0YeJHP2tLgFXxci4rJWC2DvpROlnB3pWj2SMyPiUBQPpq2gORqz71mB3OtZjpgzuGrAIo
	zJPTyo2E/j+qks1jUQuDpPH6pMqbsEo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-2K54NZ-nO3GGIILHvU35Lg-1; Tue, 05 Aug 2025 08:41:42 -0400
X-MC-Unique: 2K54NZ-nO3GGIILHvU35Lg-1
X-Mimecast-MFC-AGG-ID: 2K54NZ-nO3GGIILHvU35Lg_1754397701
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b783265641so3495869f8f.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 05:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397701; x=1755002501;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7uQFaJ04uOldMqJWhw/ZrijNlur8OaDP5isRSjWvgMQ=;
        b=aYn4w17RXn0oomWcYD1aDODg2IEaAjUUpUl+M9NrZbpid8kCeWk/ox249uGq8XgQWq
         8qaV1x0LjWwzpaC4WOiZIeBhCWwnn+ppYcaW76WL6pprhBQThI87fWNVy732cXfyPVZK
         WxKj9VlTH/dhGhj7VL6LXHDc5s8F91umc5/IZ6XJQLz60ICyd6Zv+FKd7/ZDwUUbh+O2
         wNhgkHJ22uWF4CXGJt99MbtILwsIOpHsfqHeO/snlAiJvI+JWdzVOoUe+r5cxT+itCo3
         igSPM0BI79w8INO7cL0nOxLWMdmidvvJCywobR75FPXRniR6jYbNuxfpa3bR8/rxNgc5
         GHYg==
X-Forwarded-Encrypted: i=1; AJvYcCWDt8cmIcXDWE9Lf3ufVRPqi6vwVDcdNx4oPgaCNPKIA44WmAYjy3seyteDlzyN5npNlRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzABhxCXLgpWHd+JCa05KFCa6GMkadJUJbpMaIAyRpUfK/ZouIe
	pQPTXvGKeT0E5t2NJJwxbxtAGrFq9rqd3p7WizQ1J8xbI4+GVTrULLa60Hqrmnchf8+wbqtiZPX
	5BuUPyoheaRfcg5wM29rhJ1sDsvsQ34lWsq5zGY4nvDFj2RuUZgFYRrN917biZw==
X-Gm-Gg: ASbGncupua8nTFvAowhzJKH+cih4r9BzB57VjESs26WYvzj9g+IoV3MKD4lGBFyYDYv
	SgnCf10ZMfs2ND5cspxmuXi4aW1AQD3Ri23fNWDlw4FZZxRvxNEDbvRuefPq+wgc3eDpisnFVtt
	epL91urdszbo0K8BILqDBLRFVtmRFSoocVQoibCNMgTwDB9EoDnF+kcTyvoL8KfWxzrHgNAlL6A
	n07Wq7LmwWQD20V9jg7B4iUiFg6NCTvjbUem7EQX4c83LWkXPVW8rfID5Eca6LuNmVKls2qB2zs
	q6t27yDEJll53eznrw6EXt5HYNpZUMx6Tr+y5Smrv4zA4h1xxMLkWaffROlrhiNDOOgpItI=
X-Received: by 2002:a5d:5d10:0:b0:3b7:970d:a565 with SMTP id ffacd0b85a97d-3b8d94c1cbbmr11020611f8f.46.1754397700827;
        Tue, 05 Aug 2025 05:41:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoBs3LRRrnqueBBh8exXTO/EKois18at+tf4gceWomdxr1F6hie41LrH1QETZPlxlL1PfTfA==
X-Received: by 2002:a5d:5d10:0:b0:3b7:970d:a565 with SMTP id ffacd0b85a97d-3b8d94c1cbbmr11020590f8f.46.1754397700399;
        Tue, 05 Aug 2025 05:41:40 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47c516sm19149849f8f.62.2025.08.05.05.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:41:39 -0700 (PDT)
Message-ID: <db30f547-ba98-490c-aaf7-6b141bb1b52a@redhat.com>
Date: Tue, 5 Aug 2025 14:41:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com>
 <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
 <20250805123858.GJ184255@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805123858.GJ184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 14:38, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 02:07:49PM +0200, David Hildenbrand wrote:
>> I don't see an easy way to guarantee that. E.g., populate_section_memmap
>> really just does a kvmalloc_node() and
>> __populate_section_memmap()->memmap_alloc() a memblock_alloc().
> 
> Well, it is really easy, if you do the kvmalloc_node and you get the
> single unwanted struct page value, then call it again and free the
> first one. The second call is guarenteed to not return the unwanted
> value because the first call has it allocated.

So you want to walk all existing sections to check that? :)

That's the kind of approach I would describe with the words Linus used.

-- 
Cheers,

David / dhildenb


