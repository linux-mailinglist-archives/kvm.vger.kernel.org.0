Return-Path: <kvm+bounces-54112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82477B1C6C0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 15:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5615F17D156
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 13:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3034028C033;
	Wed,  6 Aug 2025 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKjPp5jd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C128A707
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754486619; cv=none; b=q7HslY6Kvw8fAVhC1Ln3jlMjZoCUh2yNEiUUxg/Be5Nk33aTHPC3ZqKIC+5hcQ3ZK5CYv8C/dCBk41MANAbLlQYRqiyUZJr+saYTm+bJmY0kjsSTZY2bi6KgyVuPgBbBE79QrM8XXc1UXmZNTj/aXBW+iU6TzcduZTbNDTZosEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754486619; c=relaxed/simple;
	bh=xKvHUcVMdus8Y2N2o/kvq/IOWBmyEiwipo99Vtt9+fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V2NlIctj+Mr6vmBm0g/FB080rhlZZxe4wYL4tsyjMNUTQ41RsLHwEm+S87APAAMrQfzA/U9pFS5hK8heNYFkJ+HsO4U7OeIMcL5rkMBcomR6QnKC26XJftDYxk5WVlhP9OjnQDPRJ5Ps5cu/5DtKhmjW8G4Ds+yUndXa+SUzX5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SKjPp5jd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754486616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GibdnyJgYwGT2zOSKWwwnRAhQRy8R1Ef58gi/0ZslVM=;
	b=SKjPp5jdnmaUf6KYO2VdwghRYGPkgsb3QmcXf8YfgzvmPBRQyxf1Uq+cJnpXjbSW/dC19r
	/+QDxs5VC4akGwT/DVSy4rM0rOxRZyVH/x9IT7lezFdvlVIn4QMd1dULFqf//Bvflft1c7
	pOPbqdzitjwvzuSdlBWgldHQNF/0RJk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-mTF_oBieOxOW9qO7EVhQJA-1; Wed, 06 Aug 2025 09:23:35 -0400
X-MC-Unique: mTF_oBieOxOW9qO7EVhQJA-1
X-Mimecast-MFC-AGG-ID: mTF_oBieOxOW9qO7EVhQJA_1754486614
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78329f180so4756643f8f.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 06:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754486614; x=1755091414;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GibdnyJgYwGT2zOSKWwwnRAhQRy8R1Ef58gi/0ZslVM=;
        b=TR3VP09WYmtMW7gh0+sPyl1exdWl+GO/xuKgC3SvGrCV8LaiIpvkCaCCGposj4LGWs
         ExtdsEwjTx8kacIkaLY98IcEWygmk3C7eNsaTWvvD5KFkMXms2U0BYVZc8IO3VrgvjVR
         FYtHkftyTjJpYq+ZARon2AWIGz6XULqSKaNad3LK7ZKed6f9LGzD4Yt35cUAwLP/XazU
         85Z+lEu/qk1WtQmzhXHDSRZa50+x95gNfKP268MTSC+E+MfoeWqaJLYPqrofdo9M/7tO
         RAFBYXo0js6Q9OIkMkuAVdsoGPYq1SGaZnvKruaaKjFnX0KzsMdLXmj5Ot0za+SLxQdz
         kcPA==
X-Forwarded-Encrypted: i=1; AJvYcCU4nsKEZpqyPqzFMdF7hvjZ/SoF/rogkW2QmnEQT2yuVZLVNHSO3QDEQHu31uVRCQKb8aQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2zhLlAvTkMIx50XE2p026sT1efBzdtLflee0DhQnlqwuMhc5r
	l0J+vGmAjI5SDBVfzhEeWMmX1557d0MmFB5awRYRwAEpz9JAQ6y49i8Xi7d1JFCQ8TvTNlvdk1M
	+ZvPdM5LxBm48Bb//1ShNayUhrSN17uUsup1QmL5OjU1hUgQUiShYIw==
X-Gm-Gg: ASbGncuK2xv95+1HTJi4eIwPklnFGfuhWwuMeb7f2M7hI5LHjmSVAcoaMOPPSaoiqR0
	GFvs9YhKF7G92l5HJciGM3dBMiyBQhGEydQHTPU9Gx+CKBb1+gA/L3MtFJafToAad27Xv4vpkB3
	p7FoN0gXGf8+ieHNsDb35w8euQbtpvmQ2f1SbYk/HHxgtODsTUCBEVtOWf9FxzhZNaiA4ry19qH
	BbZ5301U4Su6BBT1cA+H6HzQLmE+6w9C/DmSg4QF+FAWSjDpOfz9oKPHRQfVVkiO8y2GIrNvASq
	EOrdm99+f+xeopMw3NSjIpxByP9ilBAQ0LLQZSH3ni9w9epfO/wRRcPg6iiyAcOlhE4dms1GZwz
	YxlOAn6bw9VS5RAds9bFdW7BMr+jy4sv8HaxzMMbnFdLXN9mzDt8IqKhgkifeU8inVOU=
X-Received: by 2002:a05:6000:2312:b0:3a6:c923:bc5f with SMTP id ffacd0b85a97d-3b8f4165fb2mr2311591f8f.17.1754486613846;
        Wed, 06 Aug 2025 06:23:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhE3yr6e0kSzNkDnGbw5Lvcze/11Rz3G4A5SpiR+j/QcGSuOrvfC4wzMY9JWJD4WV/6WqIHg==
X-Received: by 2002:a05:6000:2312:b0:3a6:c923:bc5f with SMTP id ffacd0b85a97d-3b8f4165fb2mr2311564f8f.17.1754486613368;
        Wed, 06 Aug 2025 06:23:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e04c7407sm13307627f8f.13.2025.08.06.06.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 06:23:32 -0700 (PDT)
Message-ID: <de629afd-8e58-42e1-80e6-d0d9598bac79@redhat.com>
Date: Wed, 6 Aug 2025 15:23:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
 Li Zhe <lizhe.67@bytedance.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
 <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
 <20250806131625.GQ184255@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250806131625.GQ184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.08.25 15:16, Jason Gunthorpe wrote:
> On Wed, Aug 06, 2025 at 02:35:15PM +0200, David Hildenbrand wrote:
>> On 05.08.25 03:24, Alex Williamson wrote:
>> +/**
>> + * num_pages_contiguous() - determine the number of contiguous pages
>> + *                          that represent contiguous PFNs
>> + * @pages: an array of page pointers
>> + * @nr_pages: length of the array, at least 1
>> + *
>> + * Determine the number of contiguous pages that represent contiguous PFNs
>> + * in @pages, starting from the first page.
>> + *
>> + * In kernel configs where contiguous pages might not imply contiguous PFNs
>> + * over memory section boundaries, this function will stop at the memory
>> + * section boundary.
> 
> Maybe:
> 
> In some kernel configs contiguous PFNs will not have contiguous struct
> pages. In these configurations num_pages_contiguous() will return a
> smaller than ideal number. The caller should continue to check for pfn
> contiguity after each call to num_pages_contiguous().

Yeah, sounds great, thanks!

-- 
Cheers,

David / dhildenb


