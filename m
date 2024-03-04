Return-Path: <kvm+bounces-10771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FCB86FC01
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D4C01F22CAE
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6699C19474;
	Mon,  4 Mar 2024 08:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZMlJdN2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37419472
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709541365; cv=none; b=tVyYLHo5VD3j/cqWybZTsSOMZzCQzkv2pqQcS7iPKq9XBLULXlWdTbpZYpxPvPjdbNC1W5H0Fe5p7N5iX4g8lrCLFT/nt+hnD/G3iKZhVjs4P7yI2JTIVXqUh28ebXRBwF73RVWtuSnIdrw4Kz32lVZ71jZZx5GhqAGcheL1/zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709541365; c=relaxed/simple;
	bh=Mh4UvcKsaHrEvUTT9JiNeQiiE0+7QWlgZQU5/uzGMC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IEdpmgVyyJe+pJ6VtJs/kIkCDHqqXa5Qyjm1PkgFltdkTi0Kc+Bc6Ns/lsYEB73LZ47QchnUtoLEJWvS0rBHDUeOcmhlr6LKL5ljiWr4n5/OtgjNMqgrl6I8SrKa4U5M4IBHPRlyKiK5k6AgCgrsmVDoMWIyU1ELid48gU90YlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZMlJdN2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709541363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8l1qW4mHeKlfZ8pDWB0WfT5UvfnnAo5TNHH0a61X7io=;
	b=cZMlJdN2mKJ4vklTwVAwh2n008X30e0TZAvSTrmMxpKX7jjP7FhJZ7Llf8hgorbD78i5uQ
	mYvHJCSF5H/1SrUPB0w2jGD+yTGG68zp1m6i+U8aaKmTNSBObSTigDjxuoQAb6uj4u/Z8G
	3Bbk31iz17o0WUEfq721qnGPgE9OKqg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-Sw-1xTFBMme0fxBhVFwTyQ-1; Mon, 04 Mar 2024 03:36:01 -0500
X-MC-Unique: Sw-1xTFBMme0fxBhVFwTyQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d29de76abso2044970f8f.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 00:36:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709541360; x=1710146160;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8l1qW4mHeKlfZ8pDWB0WfT5UvfnnAo5TNHH0a61X7io=;
        b=eqUAzdpIVVvWnhIGNI80n0KkYvGKz2SLlQzs6RLqa/oQRfBsi7vZl3PgALTBwPAUIP
         agdKU8EGupe/dRFUHSYNDUS0flgfUhTyxiOE7XHCLwb2e4ZBEhbPWRQBgNpsN3WeZeys
         t91AMmr2+0frMRDt85uBrKHsPlexD3NYr/Gx8F5j8vlEwwJYKb/VZ+qw436v31+bHRhv
         UobxbpIwnvRpHccZmK3WNrNIziAaOjiV1XIqzeEGPxV0LYB69bdB2VNBe6DOIVEjIde7
         umyEZVcMRJqgWhhHzNpSXubaPRTVtIKf1/lFxbgF0g6FmQET3mNp1j2Tcn0FSizQO9QP
         SKig==
X-Gm-Message-State: AOJu0Yyt0CPtiuqi+hdaJ1HoHdjHLnxCxiEVAck2tB2QaNDNaRNBQj5R
	RhPuR7CN6P3wNyAqFVdb9mb4Eb4IUoINhQ3aD/3LSb2D6H99lfl3+t2gi+iYdPjsjuUob58N/Ip
	4lZvDxJ2GKnFonFz0qSm4ev3yPGq9EHxtBg6dGvVUBD8K6fRg7A==
X-Received: by 2002:a5d:4d8c:0:b0:33e:1deb:acb1 with SMTP id b12-20020a5d4d8c000000b0033e1debacb1mr7000602wru.36.1709541359895;
        Mon, 04 Mar 2024 00:35:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrosOCKEFcQxQ41nk43+n4PGycTjQT+a6leF8nDjkW29WScSa2J3HyZOmf9sWA0jwr6f0LTw==
X-Received: by 2002:a5d:4d8c:0:b0:33e:1deb:acb1 with SMTP id b12-20020a5d4d8c000000b0033e1debacb1mr7000587wru.36.1709541359498;
        Mon, 04 Mar 2024 00:35:59 -0800 (PST)
Received: from ?IPV6:2003:cb:c733:f100:75e7:a0a4:9ac2:1abb? (p200300cbc733f10075e7a0a49ac21abb.dip0.t-ipconnect.de. [2003:cb:c733:f100:75e7:a0a4:9ac2:1abb])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d50ce000000b0033b66c2d61esm11535579wrt.48.2024.03.04.00.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 00:35:59 -0800 (PST)
Message-ID: <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
Date: Mon, 4 Mar 2024 09:35:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE instruction on host intercepts
To: Eric Farman <farman@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>
References: <20240301204342.3217540-1-farman@linux.ibm.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240301204342.3217540-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.03.24 21:43, Eric Farman wrote:
> It's possible that SIE exits for work that the host needs to perform
> rather than something that is intended for the guest.
> 
> A Linux guest will ignore this intercept code since there is nothing
> for it to do, but a more robust solution would rewind the PSW back to
> the SIE instruction. This will transparently resume the guest once
> the host completes its work, without the guest needing to process
> what is effectively a NOP and re-issue SIE itself.

I recall that 0-intercepts are valid by the architecture. Further, I 
recall that there were some rather tricky corner cases where avoiding 
0-intercepts would not be that easy.

Now, it's been a while ago, and maybe I misremember. SoI'm trusting 
people with access to documentation can review this.

-- 
Cheers,

David / dhildenb


