Return-Path: <kvm+bounces-28813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D9F99D79F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 21:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6024B284141
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD631CCB51;
	Mon, 14 Oct 2024 19:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WnMCbWtt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC93C1CC158
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728934962; cv=none; b=D2WvbRBwWglsIpuS4sOxVDG2I21P2TfPNwIJQKLKcFfhSvZssy/Q2GcgSATphgsNnguYSHIyGxv05BLNt4owQTbmUhmc+dw7Vnrq87/O7zB6qumdQUTqFiYt1de+eK5oUeYX9p63iZna/0EOaItDgN2xJP2DthfliGMSurMTtP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728934962; c=relaxed/simple;
	bh=nSN91k0MDx/3jclGR0DMRDh9nWAKkddvoKTi4MHkZc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WY6T2/A0kJjHVfNF4CEEHDMxZqFbvwB3StpL6RNpTc7wK8Wf/vA0mAOiiI/1ZIyslewZha5Lde8GKGvM8RmRLUTwrGMrjue/ooWlJGGy9EdPZ4Cpwnp0w40GzvCBfOPd+hbS7fsj/XC1U0gpAt/brE99LlHMbUzwJsOv5iqINQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WnMCbWtt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728934958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=30ySL8mOnC3+G7jE5IBbcnE7C3MkhR8Ag1bijqKHz78=;
	b=WnMCbWttxIcAt2BEwvZtev0L8B4Fa6YV3scWc/B/onqHdgX+ckKtbO6CADBuzWIPEV/0wg
	bDoJZQonXsYk7QR3IsxKN/N1Ry4WmOqkuEPs6bbaBcLZOCNL+qyD5SQpS3j9W0JmW105w0
	8DSLoBtYc7RdozRKlWz7zQSbJvoKodc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-tLBqBSfpNROt4tlySemgYg-1; Mon, 14 Oct 2024 15:42:37 -0400
X-MC-Unique: tLBqBSfpNROt4tlySemgYg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d4d51b4efso1741956f8f.3
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 12:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728934956; x=1729539756;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=30ySL8mOnC3+G7jE5IBbcnE7C3MkhR8Ag1bijqKHz78=;
        b=Fh98GOcbmE7NG8cTTUSr3ZXyWVRe8dWQVnzKV9b8bSWDwEqW+jOrQ6MYPkaYPPkJGl
         Z5omOeM14zQtxbDqMuNujfJAGAXjP6jOmqi4dKJhxF6sLCKb0Cte/ZaY9fjkHmtotvGO
         t/5UgDpQzzCFiAsJ/0RLGElvBRhrY/ADC7MLOHCK+2ZDQcw7+37Rd8WDl/01lGNl0pd0
         mHy3xG0oDzGqnn/nFLlFr+R0ToW5st5+3eioWvS7FVT+DwPg3pkt4IfJKE9hUOXeiyeJ
         6bgAK+3s/xgqahtq1xU9yC/Jl26Y776R+Wd5Ozpigsm3LNaMk6lHmC7vlDQXLV0Jlo79
         uTjw==
X-Forwarded-Encrypted: i=1; AJvYcCXr56xqEV07GsM3F9RR9YePTqIVRpGGTfMcovhhF6IVifjhVVSzcqlqdCGewgiycU9A60I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOdh7PAb9gygs5FmsCr75IODJ/+VtO/ifkcHpOnb87blQs79mg
	qvmRBWxkJ9vDuHA2oMNoKWv8+l9D/rE0AzJB//PpkMe7XTCFnAzs14k4HPy/wJ5lRoLum9ww6CL
	r5G9FgcWt17mf3tWy8a8HfP7MwuPLtn7luZrVDy3JCT6iDaH+aQ==
X-Received: by 2002:a5d:4dc6:0:b0:37d:4818:f8b1 with SMTP id ffacd0b85a97d-37d5529b195mr9208878f8f.39.1728934956341;
        Mon, 14 Oct 2024 12:42:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHg9eyNRc80Vvm3HusKUJW8fJac5WJyw4VreDan/GeWLXPz1wjvXZOk8pOZkz4a6HZCd2pEoA==
X-Received: by 2002:a5d:4dc6:0:b0:37d:4818:f8b1 with SMTP id ffacd0b85a97d-37d5529b195mr9208853f8f.39.1728934955884;
        Mon, 14 Oct 2024 12:42:35 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71e:600:9fbb:f0bf:d958:5c70? (p200300cbc71e06009fbbf0bfd9585c70.dip0.t-ipconnect.de. [2003:cb:c71e:600:9fbb:f0bf:d958:5c70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6bfc8csm12271623f8f.45.2024.10.14.12.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 12:42:35 -0700 (PDT)
Message-ID: <59199850-f9cd-4249-92b5-40904facc11b@redhat.com>
Date: Mon, 14 Oct 2024 21:42:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT) to
 support QEMU/KVM memory devices
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
 <20241014184339.10447-E-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241014184339.10447-E-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.10.24 20:43, Heiko Carstens wrote:
> On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:
>> To support memory devices under QEMU/KVM, such as virtio-mem,
>> we have to prepare our kernel virtual address space accordingly and
>> have to know the highest possible physical memory address we might see
>> later: the storage limit. The good old SCLP interface is not suitable for
>> this use case.
>>
>> In particular, memory owned by memory devices has no relationship to
>> storage increments, it is always detected using the device driver, and
>> unaware OSes (no driver) must never try making use of that memory.
>> Consequently this memory is located outside of the "maximum storage
>> increment"-indicated memory range.
>>
>> Let's use our new diag500 STORAGE_LIMIT subcode to query this storage
>> limit that can exceed the "maximum storage increment", and use the
>> existing interfaces (i.e., SCLP) to obtain information about the initial
>> memory that is not owned+managed by memory devices.
>>
>> If a hypervisor does not support such memory devices, the address exposed
>> through diag500 STORAGE_LIMIT will correspond to the maximum storage
>> increment exposed through SCLP.
>>
>> To teach kdump on s390 to include memory owned by memory devices, there
>> will be ways to query the relevant memory ranges from the device via a
>> driver running in special kdump mode (like virtio-mem already implements
>> to filter /proc/vmcore access so we don't end up reading from unplugged
>> device blocks).
>>
>> Tested-by: Mario Casquero <mcasquer@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/s390/boot/physmem_info.c        | 46 ++++++++++++++++++++++++++--
>>   arch/s390/include/asm/physmem_info.h |  3 ++
>>   2 files changed, 46 insertions(+), 3 deletions(-)
> 
> ...
> 
>> +static int diag500_storage_limit(unsigned long *max_physmem_end)
>> +{
>> +	register unsigned long __nr asm("1") = 0x4;
>> +	register unsigned long __storage_limit asm("2") = 0;
>> +	unsigned long reg1, reg2;
>> +	psw_t old;
> 
> In general we do not allow register asm usage anymore in s390 code,
> except for a very few defined places. This is due to all the problems
> that we've seen with code instrumentation and register corruption.

Makes sense. Note that I was inspired by GENERATE_KVM_HYPERCALL_FUNC 
that also still uses register asm usage.

> 
> The patch below changes your code accordingly, but it is
> untested. Please verify that your code still works.

Below LGTM, I'll give it a churn, thanks!

-- 
Cheers,

David / dhildenb


