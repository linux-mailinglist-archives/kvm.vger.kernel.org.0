Return-Path: <kvm+bounces-12666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CB488BC63
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F51EB22238
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B88137C28;
	Tue, 26 Mar 2024 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bvd8MB30"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87162134412
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711441713; cv=none; b=hyfyiU8olb7v5rq4B5mqORDvBncklLRdm68CUhVwSQlK/fwQqOjQiLnwZI5f+jXXiAUiqOqLSP8/3TXLRo83nKeHkR76RgXddzPeGGYB3lNNzgSuePOfdiwd740c2tE0gl5s+g8h1IJoBvP8zHs/T7QoY4/rarsrIuanhvDce3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711441713; c=relaxed/simple;
	bh=Znj+atbMFctim9XGRSLE0mYfaMQuqrWG3FBTk1G3Y74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oRIdf4xcTnYCXV+NiQlEV/GoMzveyOcYgVT1zcSK/XnVbXZdX6bC14H6Fg8O2nhEp2EJBOHvvYUzQow9rB3tOqP2TCk0qc3YY0xogpLyokLhuDGrr9EtujZ3h9nL3n0KNsyB+HkQCoDcYJHZ7rpTOh2I+jotCBj6mBA/pL24VDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bvd8MB30; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711441710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CcCPk+ey5j30y7Fauv13OO5bDxCH8me7JwA7XVw5QRk=;
	b=Bvd8MB30FAN+M00tbDrr8dYCorPkNS9XSMG3xz4hjONGCDuLwip55uT/Uqy2D3KUmNq8dX
	QlMpKIj7eCJVcWqNtVNxdSxfSZl2VydUpo0a0aLl/xQL36iLvlks6i+JiTYJlrB3r0yJ+q
	II8EmNpm5Asix7bLTqKOfZepAt0OFho=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-H4ndCmSSMPWVazbcNgZHhg-1; Tue, 26 Mar 2024 04:28:28 -0400
X-MC-Unique: H4ndCmSSMPWVazbcNgZHhg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4147f17da12so16709435e9.0
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 01:28:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711441707; x=1712046507;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcCPk+ey5j30y7Fauv13OO5bDxCH8me7JwA7XVw5QRk=;
        b=i0Fbhz5T+u1qIJr16yEC3X1GForoXnPV8ulsejtmgsCj92r62I1pXyJyeCUP2wy2mz
         DxWxqxYHTbkNXymbxxhpILBwVam1DoHA+Vj4WtrS154RdnuBRCIJgxqAmZ/dwq+W/68L
         PBtNMmDVI6zwY2Pj2W/7KylEGJ1REQTxDcvPvMjq5UvH2D4c1wGlQYzyCYBhrJ950E4N
         ZVDBAboxjVtHSpw1CngacWftklcNEHixAkKXqtTnv4AiJVhbzE9VVqwUaXYF1wkoUiow
         z+qbwXw77v85GXoq3XHKxt3HJKkJiRN+SduBJh9AELoNrkuDi9c+i6/acCH0MYK37jff
         XBWA==
X-Forwarded-Encrypted: i=1; AJvYcCVzOQYVYXilQxdaUxeO6dLuJ4Gq0jctpKU+vtyPBjjZR4Yp5RfgLuv0amf1xC7tdSH+TDz8iEhljb1Bat8JzfRfvSXd
X-Gm-Message-State: AOJu0Yymyq6IfrQNpkWF3Gq0cjV0nA47q06cTu5QWiIkRbU9xTiAx+zR
	TTGntqoms9SBE8rGH9vMfo2tsKQ0pUEKMMG8crOCV51Q3KQk1N+A5fpalicPWuloO8jmS4T5j8e
	vQ2IfrqWdLaJbRzavPlzYqZsnjgPfliHTQceeInT+CTCDAmMUXg==
X-Received: by 2002:a05:600c:6b0d:b0:413:ef97:45e5 with SMTP id jn13-20020a05600c6b0d00b00413ef9745e5mr366681wmb.21.1711441707206;
        Tue, 26 Mar 2024 01:28:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSu02o6wPGnR3954Rn0BOGe25aFV0kXMv1Z8ftJ/Mn9LseEXTqY1z9Anqz92meTbAagCBuyg==
X-Received: by 2002:a05:600c:6b0d:b0:413:ef97:45e5 with SMTP id jn13-20020a05600c6b0d00b00413ef9745e5mr366658wmb.21.1711441706744;
        Tue, 26 Mar 2024 01:28:26 -0700 (PDT)
Received: from ?IPV6:2003:cb:c741:c700:3db9:94c9:28b0:34f2? (p200300cbc741c7003db994c928b034f2.dip0.t-ipconnect.de. [2003:cb:c741:c700:3db9:94c9:28b0:34f2])
        by smtp.gmail.com with ESMTPSA id f20-20020a05600c155400b0041477f3f99fsm10800948wmg.30.2024.03.26.01.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 01:28:26 -0700 (PDT)
Message-ID: <a6c54afa-b6f7-416a-b70c-072c6f9ea317@redhat.com>
Date: Tue, 26 Mar 2024 09:28:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] s390/mm: shared zeropage + KVM fix and
 optimization
To: Heiko Carstens <hca@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240321215954.177730-1-david@redhat.com>
 <20240321151353.68f9a3c9c0b261887e4e5411@linux-foundation.org>
 <20240326073833.6078-A-hca@linux.ibm.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240326073833.6078-A-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.03.24 08:38, Heiko Carstens wrote:
> On Thu, Mar 21, 2024 at 03:13:53PM -0700, Andrew Morton wrote:
>> On Thu, 21 Mar 2024 22:59:52 +0100 David Hildenbrand <david@redhat.com> wrote:
>>
>>> Based on current mm-unstable. Maybe at least the second patch should
>>> go via the s390x tree, I think patch #1 could go that route as well.
>>
>> Taking both via the s390 tree is OK by me.  I'll drop the mm.git copies
>> if/when these turn up in the linux-next feed.
> 
> Considering the comments I would expect a v2 of this series at some
> time in the future.

Yes, I'm still waiting for more feedback. I'll likely resend tomorrow.

-- 
Cheers,

David / dhildenb


