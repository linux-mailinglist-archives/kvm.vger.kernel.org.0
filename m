Return-Path: <kvm+bounces-30257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 337749B857A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E60032850B4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23EE1CCEE8;
	Thu, 31 Oct 2024 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WbzH1DAX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A3193402
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730410886; cv=none; b=SFTbnBWx+HCeTe9KzV53SLiGlbhcqoaWNivorFjjt2tuk5ZuJT+zp2s0zyS4WKW08t2WpE9i2NCI3BONL0aqBsppoqa9G4ZTotMjwe8xWcWPH3bjJu3TNBOmADjdImR5XB2q6ILlzqc/y+c3/jylNBdJfsCpIYWOwe9qREImek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730410886; c=relaxed/simple;
	bh=pPG5DR7tU5m6fxnN1y22SMUllbZm0Wi5JXNaJguSXTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XgkgPTgDjct5+JSAz9HXKS1Qox2drhDkySgT6LuurCEV6kEdvuDL7ncYw922NJTpMWbMsQefeJ/Nfka0iJpCcSgzEju0/Vd6MicdZOV+UWcsrGvWaDaABpuCCLSPLH23I33SRELiOFI4dL8bAZOzktz1r8Eb1HrNHjzKJzrKveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WbzH1DAX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730410880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V9qGJfnpN/vTVlVkacjjN4O4qiIfHH6/DqVZDAH06eM=;
	b=WbzH1DAXsZJx6gdqiNlj3qHDRrekZPlyYV7L7+GlHnoZCJp1SrdQcxW3OVxNLZesWuQdcG
	hmg0vq+c80wlrr/MgjDd0YfwzGnOnxWPNU9O/1De0S7K1Nf08StV0Br1zUglYBAav2xsyh
	bB0tOpZ7UH7bPelmwtE2k3zPyH75Cc8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-NZkR_e1IOOqNtL4rHnBhpg-1; Thu, 31 Oct 2024 17:41:18 -0400
X-MC-Unique: NZkR_e1IOOqNtL4rHnBhpg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315a0f25afso9075315e9.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 14:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730410878; x=1731015678;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V9qGJfnpN/vTVlVkacjjN4O4qiIfHH6/DqVZDAH06eM=;
        b=oconwokzAgHfLtF3UO0fOGKMvsAW1FtmRplMOmgLCrzilT+Fz2DgXzCZgiIszakRPr
         sl9qustcXlkDZ0Nh3W3BLzXgHd14GYnjPL1pdY1G3FWZI1iuWNAek9NcAvp33cXVesME
         PQN5dITZv+RyJqFw2+S+a9XCFFB3Sy3w9029N4DLQQoS21/XkcODDxYMgpUaFoA9KRnG
         Z3KKHvY8hlAWl233MP+kfejcatKUjSZlBXFg8zA0rsqjo3NJ87zB5QW9Hh8uAMKh2mPc
         E8eLQzxhCEsavSAx844TCpPyrgIh2nd6lCYXCbDB6k/HVIuYY0pE6hX4uceDGu+/r+3M
         3bYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwpl+xADtEFZPa6C2Rw/7R/8kGe4YERo38cMbdHTJw5bpOH9ivBY9hjFoQxAylzKpCBzo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0ijNFedxu6Qu0Mj/vcIf2UM7MGajeyp5ZVBz0scyGUXRfuyoX
	nhTTPUeS0MKfOsVPVfZQoLb7etxSAchW15OkQVx326L5wbiR+PsmFf67qSbQuYV7uw93kvYSUPI
	bNHTA/o17EjfvWVfBLesuN+VItRnZ8tMhcsNRTMeqtWZTC3R7Dg==
X-Received: by 2002:a05:600c:1c03:b0:42c:af2a:dcf4 with SMTP id 5b1f17b1804b1-4319ad141admr155838555e9.27.1730410877692;
        Thu, 31 Oct 2024 14:41:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgYJ10fn9ESbtPdeY06XEy8OXmxVaFJq+0h5FOBwp7ViWvcQ1J3QhNm3ZTRU5cp7NnKCHnKQ==
X-Received: by 2002:a05:600c:1c03:b0:42c:af2a:dcf4 with SMTP id 5b1f17b1804b1-4319ad141admr155838355e9.27.1730410877318;
        Thu, 31 Oct 2024 14:41:17 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:ed00:7ddf:1ea9:4f7a:91fe? (p200300cbc70aed007ddf1ea94f7a91fe.dip0.t-ipconnect.de. [2003:cb:c70a:ed00:7ddf:1ea9:4f7a:91fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9a99d3sm69456625e9.38.2024.10.31.14.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 14:41:16 -0700 (PDT)
Message-ID: <148489cc-50cd-42a5-b813-969c6c61ff1e@redhat.com>
Date: Thu, 31 Oct 2024 22:41:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] Documentation: s390-diag.rst: make diag500 a
 generic KVM hypercall
To: Eric Farman <farman@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241025141453.1210600-2-david@redhat.com>
 <7aa84534df1a6637bebd60e628500f6dbad47c05.camel@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <7aa84534df1a6637bebd60e628500f6dbad47c05.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31.10.24 15:56, Eric Farman wrote:
> On Fri, 2024-10-25 at 16:14 +0200, David Hildenbrand wrote:
>> Let's make it a generic KVM hypercall, allowing other subfunctions to
>> be more independent of virtio.
>>
>> While at it, document that unsupported/unimplemented subfunctions result
>> in a SPECIFICATION exception.
>>
>> This is a preparation for documenting a new hypercall.
> 
> s/hypercall/subfunction/ ?

Indeed, thanks! I assume this can be fixed up when applying, unless I 
have to resend for other reasons.

> 
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   Documentation/virt/kvm/s390/s390-diag.rst | 18 +++++++++++-------
>>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> 

Thanks!

-- 
Cheers,

David / dhildenb


