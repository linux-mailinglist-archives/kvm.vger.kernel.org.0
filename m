Return-Path: <kvm+bounces-31603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3829C51BB
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6393DB28281
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2226520C028;
	Tue, 12 Nov 2024 09:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uy3RiwD/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F7A20BB39
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 09:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731402615; cv=none; b=qg0ibiqeXXg6QLcpXdwa5FLAOpiBqAHyFgVT4LH8yxMi3LOqN1YEloqS2M+IEIdI0kEk4i30Si8N+5MubwMalahgEA7/135ClXIfDGuywdEiK+YlMhyxfMgcAcbQi++NAZpp8LqXwoDsri3HKrCnr1xXrQNcqHfsPSHcEm62gn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731402615; c=relaxed/simple;
	bh=GYeTMxJ1u/y6upzwyERgqUsqRHUH/9J1MuONHSgUlV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ooat2e0F2wBm2hCwSE1qqewjNUyxjHWJSZ/0KJc+g4GsVtOk8wNp/sjijKnDI5qgvm2/5SkQWz7HZ+BSWU+BKv9fI56vpnXEygEjoEeaXI6yA3XawISRzTxVjbcHjMHz9E9EJi1PkZuMCv0hrdlQVyzShQ6YFbzffDrr0WXzhpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uy3RiwD/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731402612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0abqq4HZmJTT43InWewFIhaF6DjSCEzT4iGToh9hhNU=;
	b=Uy3RiwD/uKCzJo/t/ECCkDEhNCN2QQfX4liC5DVeSCDFCq1CtE4XduN6f0Gvjv+XcGJevF
	fZZnFGpH7loP5J9S+aTIQsTBLcrE73uG1nvL7ov3BKdoAAXK0BecAvOMZKV8fjCmKlsSWR
	Gtbp6R/BZdCUbXMffEx2PYzrPyaeYhs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-zEYlA4iWNPWDoCMtVcoRYw-1; Tue, 12 Nov 2024 04:10:10 -0500
X-MC-Unique: zEYlA4iWNPWDoCMtVcoRYw-1
X-Mimecast-MFC-AGG-ID: zEYlA4iWNPWDoCMtVcoRYw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-432d04b3d40so1901305e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 01:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731402609; x=1732007409;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0abqq4HZmJTT43InWewFIhaF6DjSCEzT4iGToh9hhNU=;
        b=Z4qq/Et38P3ueQrZgZ+YpNHnL5OrwcyYBD9/oqIKanvl/JURZcfTtO7SzzhZvjbnJK
         9Sselt/V8ftgDzy9uEaZbHdjjXR0a4D/V4MhgAtfSAU4KD791phHM3DDBf2au3vXkWcD
         0mnxWtJRhs4osnn2EcdxCy1x4/bHGsrr0qgXUz6A8rknG+R5f7Qzd/8/CAPMJqDW2arb
         rQIZUGkMhLd1ey4DjgrFUY/6PlQ9CrZ6U1kaswcbkrmPoCshn0Oz1TTirX7nC6rlHTS/
         LTDCCgE5n1KYYHFrvC8z8pSmN53zxqSvdGaZvL7EklSXrn06JUzrt1+NYqlkG1KBlToo
         9fQw==
X-Forwarded-Encrypted: i=1; AJvYcCU9CL717WQRgIvLoRbNvjaetH2Q9Kt+xcVc4gZ48j9FThkjSI2gwgS8rhFaM8ymdY+Pd2I=@vger.kernel.org
X-Gm-Message-State: AOJu0YybVwIcLGvJVpQ0+ZUPOp3sFqfCFtFX7Rml0UmZv95SYVeJJriC
	ekm/XZGIMcM6ATmaY4V3yoT3WCYiAMNI4pzZDRvi90rBhnMhvSSa1z78eKzmBLlHn4FoQ+Ive7O
	sI/7DpDYuc7ugOPwLRLtI8E5SUujzIQFL5VtHLrC8CNsre6zd9A==
X-Received: by 2002:a05:6000:1a89:b0:37d:45ab:422b with SMTP id ffacd0b85a97d-38208124c87mr1123725f8f.31.1731402609204;
        Tue, 12 Nov 2024 01:10:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhoEJKfaThyjDpOjkf9H2w8qMdYtKNWB8k1DPpyFyo5lEgerpeKPRk0eEOg+FsUVAPIPX/8A==
X-Received: by 2002:a05:6000:1a89:b0:37d:45ab:422b with SMTP id ffacd0b85a97d-38208124c87mr1123700f8f.31.1731402608775;
        Tue, 12 Nov 2024 01:10:08 -0800 (PST)
Received: from ?IPV6:2003:cb:c739:8e00:7a46:1b8c:8b13:d3d? (p200300cbc7398e007a461b8c8b130d3d.dip0.t-ipconnect.de. [2003:cb:c739:8e00:7a46:1b8c:8b13:d3d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381eda051c6sm14739925f8f.99.2024.11.12.01.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 01:10:08 -0800 (PST)
Message-ID: <e82d7a46-8749-429c-82fa-0c996c858f4a@redhat.com>
Date: Tue, 12 Nov 2024 10:10:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
To: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
 kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, rppt@kernel.org, jglisse@redhat.com,
 akpm@linux-foundation.org, muchun.song@linux.dev, simona@ffwll.ch,
 airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com,
 jhubbard@nvidia.com, ackerleytng@google.com, vannapurve@google.com,
 mail@maciej.szmigiero.name, kirill.shutemov@linux.intel.com,
 quic_eberman@quicinc.com, maz@kernel.org, will@kernel.org,
 qperret@google.com, keirf@google.com, roypat@amazon.co.uk
References: <20241108162040.159038-1-tabba@google.com>
 <20241108170501.GI539304@nvidia.com>
 <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
 <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>
 <ZzLnFh1_4yYao_Yz@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZzLnFh1_4yYao_Yz@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.11.24 06:26, Matthew Wilcox wrote:
> On Mon, Nov 11, 2024 at 08:26:54AM +0000, Fuad Tabba wrote:
>> Thanks for your comments Jason, and for clarifying my cover letter
>> David. I think David has covered everything, and I'll make sure to
>> clarify this in the cover letter when I respin.
> 
> I don't want you to respin.  I think this is a bad idea.

I'm hoping you'll find some more time to explain what exactly you don't 
like, because this series only refactors what we already have.

I enjoy seeing the special casing (especially hugetlb) gone from mm/swap.c.

I don't particularly enjoy overlaying folio->lru, primarily because we 
have to temporarily "evacuate" it when someone wants to make use of 
folio->lru (e.g., hugetlb isolation). So it's not completely "sticky", 
at least for hugetlb.

Overlaying folio->mapping, similar to how "struct movable_operations" 
overlay page->mapping is not an option, because folio->mapping will be 
used for other purposes.


We'd need some sticky and reliable way to tell folio freeing code that 
someone wants to intercept when the refcount of that folio goes to 0, 
and identify who to notify.

Maybe folio->private/page->private could be overlayed? hugetlb only uses 
folio->private for flags, which we could move to some other tail page 
(e.g., simply putting them into flags1).

-- 
Cheers,

David / dhildenb


