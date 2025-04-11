Return-Path: <kvm+bounces-43160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F46BA85F4E
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 15:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E68599C0FA3
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 13:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380A51F0E2B;
	Fri, 11 Apr 2025 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="azBxtfF4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E7C1D5CF2
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744378488; cv=none; b=RPkP2vl1/lrD4wZTQtdWI4PQUXaMqaptCg4c+1WicGLNRdoTT37mYnM1pgazZ87z1q3OOllCmz1ddtgCuf2Ydc79tg81/xkBarKKt0WbgCjlWpaEdpMqKYkSzHTn1Yls2ZUsgCFCOxoe9u2FlNZVD6HVVqFp2j0iftftH73Hy+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744378488; c=relaxed/simple;
	bh=UcltrPAtihOPqHJy0TcHFp7dpHxTFBGioJr6el6XMPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZT7FUWu1cWZTUFslGE2L5OEXEO87UJqR28P4mW4QQL7E5jhMal3+sZHfZtS3mv9yvWs4/DcX4mT2M/EsbuTpKPRA+h5Zlwbk5pcnBvHsL5ZToLt3BRyJesFGZY6NQDwUNaE0rfVxSbxqs5QBGLziYHdG/GvCeME7GY1mi0vPqlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=azBxtfF4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744378485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q1diX5CUrifYi4+JcHpXeRBhIpAuLmf16QCSRCSlhfM=;
	b=azBxtfF4hLZ4lB0yWlEq8/RyecPUPHBFw2R2sEYV99FjWYWslTHY7hDBhdqYFHS5aDicgQ
	j1H3wlxRdhuVqgVxuMQXeVcp0fM+VzG+UuRK+DE2DPrXaMTYGw+U4ptfBOsXnyBIQDUtQt
	bfEPnDO/eCAPhzR5p/TWmAjz+SrXJto=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-4SXZD3PRPDWBRR9BuRSh6A-1; Fri, 11 Apr 2025 09:34:44 -0400
X-MC-Unique: 4SXZD3PRPDWBRR9BuRSh6A-1
X-Mimecast-MFC-AGG-ID: 4SXZD3PRPDWBRR9BuRSh6A_1744378483
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso12462885e9.0
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 06:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744378483; x=1744983283;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q1diX5CUrifYi4+JcHpXeRBhIpAuLmf16QCSRCSlhfM=;
        b=u5vRGjd+Vt8LWGk5MjjgWjc+jw6w0wC33068/tS8r4xo0Kqjpkl+kaIOJDwW24USyx
         rW57NAq82+33om8sXM57btgkh2up4uacBxSNnZoD7z/Pra8fcJIgHRE+5F1rKId/aatF
         7ePIkcXoSKowrc1LgZOEypDaCxmDWVPcZTb+y2T1kSTB3J4U14k9z4W2uoohz+tLmuof
         1Guw7W5SMkvNcsZ72v4R/bQJzX0CVtdP2uvU1a4eSuHN3src1e7qIk7AkOn7gRiWnApI
         BU1XJiqV7hdv5a921/rs9bhQyE1+CxAsqkklJW+oyiKGE9YBpbUBzBsm4PYqv2I+9nid
         cDVA==
X-Forwarded-Encrypted: i=1; AJvYcCXJxnUqnGiSkZELeDOfidHGtxJcocsCIin9S3yrxF5rmD69djn9qBLJ1zAo8AasTY5u+pk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOY1D6zVyM/iAvb4tDQ5etTRS1SIeLaf5G4xto6yLHHSQw13U5
	T9o6CGsCSDnSWRHxG8LevjHPFjj5gwQElr8RwhDuWquv0p3ev3YRLRXJxzDewIx46K7zMBSq/Am
	JQQBS1xJUA+jaVvYIVi3/Vw8t7EeUDIkZEd8FhKX1OCm1Nt1SIg==
X-Gm-Gg: ASbGnctRnhsRGaMnssjV4WtbKRfj8VZQRc+2FKpWjahPLcWrRh5ZTY5+/dGDqC7IG5Y
	w6AQRQqq2n06dLtyy+O7ynAapSRRxX3f5+JW3GauuDCWVGXJeGdDBwL6EPkQ2GuZaYB49fo8vKw
	ILrw2f2S9fkfN5YtH1XRMz4YJc0OaQblbBtT+8V01kULx89GDBF/gw8V2cz99vl01wLxJh5KlIo
	pkg0rakz7vbBdDy6VXdhvyHYzUHT6rntpyNUWHtimQiPRqvC0KSc6pl+lpPenv+ULS+HTEnA3Xo
	vuUCNKJfyP4ZUus9oxw1ur3kuyc/pN3fxWzvLe/pO6oOMI8Fi3dGxF+bltsn43lGPYVij8eKV3Q
	pBWzD7bUq+fSYPi7plXwwKh0c6N2EazroELz5
X-Received: by 2002:a05:600c:46d1:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43f3a93d697mr23899155e9.13.1744378482900;
        Fri, 11 Apr 2025 06:34:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpv5zZwGvmZlPCNWoPQ4wHjs96uuv41Vt52sC7EWmTMIpkIhMU5OXH2rTdIW/xFcjbJ4VK7A==
X-Received: by 2002:a05:600c:46d1:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43f3a93d697mr23898655e9.13.1744378482290;
        Fri, 11 Apr 2025 06:34:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:6800:7ddf:5fc:2ee5:f08a? (p200300cbc72668007ddf05fc2ee5f08a.dip0.t-ipconnect.de. [2003:cb:c726:6800:7ddf:5fc:2ee5:f08a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2066d0fcsm86816925e9.19.2025.04.11.06.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 06:34:41 -0700 (PDT)
Message-ID: <3977aa0c-144f-4a1d-9ca1-927f23d39cef@redhat.com>
Date: Fri, 11 Apr 2025 15:34:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250402203621.940090-1-david@redhat.com>
 <065d46ba-83c1-473a-9cbe-d5388237d1ea@redhat.com>
 <a6f667b2-ef7d-4636-ba3c-cf4afe8ff6c3@linux.ibm.com>
 <20250411124242.123863D16-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250411124242.123863D16-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.04.25 14:42, Heiko Carstens wrote:
> On Fri, Apr 11, 2025 at 01:11:55PM +0200, Christian Borntraeger wrote:
>> Am 10.04.25 um 20:44 schrieb David Hildenbrand:
>> [...]
>>>> ---
>>>
>>> So, given that
>>>
>>> (a) people are actively running into this
>>> (b) we'll have to backport this quite a lot
>>> (c) the spec issue is not a s390x-only issue
>>> (d) it's still unclear how to best deal with the spec issue
>>>
>>> I suggest getting this fix here upstream asap. It will neither making sorting out the spec issue easier nor harder :)
>>>
>>> I can spot it in the s390 fixes tree already.
>>
>> Makes sense to me. MST, ok with you to send via s390 tree?
> 
> Well, it is already part of a pull request:
> https://lore.kernel.org/r/20250411100301.123863C11-hca@linux.ibm.com/

Awesome, thanks!

-- 
Cheers,

David / dhildenb


