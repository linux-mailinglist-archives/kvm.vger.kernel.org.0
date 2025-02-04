Return-Path: <kvm+bounces-37266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B44A27AA5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E0957A0622
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E55218AA8;
	Tue,  4 Feb 2025 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M2PSk9ju"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB88216E33
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695363; cv=none; b=hKePtzkm0nX+H+k22Xc+qcLSm77QHpynSi/7XEVWCqIWjsW1IVWfwTls78cU77SB+hoGd3t7WyXtzjNsDvXAzvEzy9vsI2+rmQx2ilHdpJbkY/v6lODxc/A0HIW6tOIgOouBJNGk9K75dQzXTbA31Hk1+hihIpR2NNa1qKkRxvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695363; c=relaxed/simple;
	bh=e2kbKtaf+LWCzk+NtK8wv6DviPZAIA1tbGQdpj+VVy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnAZzJwPICWcX1waP386fgA+HSIf5ki9HU6/z15JKuSFcdg6zpp0FlGz2wDlb5bkSzgan8e3MkVXooTX13AaSd4l1Z7Gb8cI8cIpKDx4Hhm3BYHuqa3LzDySW6tL7hZhaDv9ges9y0vT7RD0wNP150j8TA1vivI4VWj0d0kr7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M2PSk9ju; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738695360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xZqfIDUj6lqQGwbPGqD0mO3rFCOZzQtE0HWzdBSsE4s=;
	b=M2PSk9juBxj5BN9ZdN53IqJS5ZcY63jcsapka9gIZKvYTc6LyfQczXkbspaIldwC6Y1LTy
	YJR882wuW3OW/3aEukWM2h0E4cMgoOYcs6E7Qo/9fArV4kq2+awgJbefZ8/GnK+7AyXLig
	TFZLwfDb4LKSAVYxkspjf7UBQyVs8eo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-iEuCO8QmO3O6ZDuIO6EmTA-1; Tue, 04 Feb 2025 13:55:59 -0500
X-MC-Unique: iEuCO8QmO3O6ZDuIO6EmTA-1
X-Mimecast-MFC-AGG-ID: iEuCO8QmO3O6ZDuIO6EmTA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38dafe1699cso794430f8f.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 10:55:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738695356; x=1739300156;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xZqfIDUj6lqQGwbPGqD0mO3rFCOZzQtE0HWzdBSsE4s=;
        b=ijLBn0t0jboxw0OdmeTZArva1j1gAe0y9sFodvhWK72mNzMyW7RuJdUbgtbMqmWJpX
         c3uWErwzRwMQs6hNF9af4/Mhau+60k9F/UilEH9jh0TSYvjBKBbNUepPmRnYuO3MiaGg
         VzRJDOVQ16hCFoUGA8MoM4ggnoUC89d146h2eN6n0xWUrjXOXfsGkGfqOhzxJ4iC41/l
         dFvYGZI6bFyXFbuoukMTYwaXsH+sxdvjWQo6mD6U1ANNmgbq0z/6SF+f3Zg58940ujKS
         yWZBJaZXiIhp0uUiM5PqBd5pBoeYS1Wg3tyPYtHqz4VC3eELGtXB0IMY9Yrs8CO57dhG
         3h9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWezp2lyqkz447ju+bS0FWgxh5+87Q/TNZIXL+OzIOmjT2aCN8JGnqmLIyZuseEUSxMdc4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ4XHDLgrVlSmymlFy+5hNXZEoTrJkUWi0DYDpPnUXnAbzY35K
	oJ2f6RCWENOAj6gYWgjaW9tOeqe2RH60yDNL9QKsFr3NELgMehtGpiBbwyYzY0jvYXqMwxKQ8cM
	YFT7WrbvaJvQ4wvjrmA95s4ZB9RNefPlSe/BN/G58S0/ia+GAiQ==
X-Gm-Gg: ASbGncsyHLa9kschDE3yf+bx82vL2uFDs7ZMsA+Ih50oaF9RnEmnns84DYeDe2C/PO4
	wtED6owSzmMK2NiIhrCnGs1MNpI2/8m9dSMalQu83jfrBilVXF2jYY1EH3iO68pMtoClLeoWVI8
	PsIt0/D8n8Bg/Gu64USV3Y6z6xWFR6W5N/ZXO4k6KmeYWH5A4vG5/tY5PkvxRGbYSNh4rx1azBo
	+UFaPadtk6n4bVzwgOD+QFyhBHaQxz2UiM0HiAJgfL2H+JyXwgxfQ58Y3A9uoJ10PtJvRyxjs+5
	0DC+Apoygn1T4MQolcPxM92r9H4f77rn
X-Received: by 2002:a5d:4e11:0:b0:38b:f4db:d56b with SMTP id ffacd0b85a97d-38c51969acemr22529415f8f.25.1738695356578;
        Tue, 04 Feb 2025 10:55:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQDwE8acQro4vADVGnePhPI5+ArodWqXspLbZhfGXMnVDQ8RoPTC3YDDbO61TNczuXlPdYkw==
X-Received: by 2002:a5d:4e11:0:b0:38b:f4db:d56b with SMTP id ffacd0b85a97d-38c51969acemr22529393f8f.25.1738695356245;
        Tue, 04 Feb 2025 10:55:56 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6602.dip0.t-ipconnect.de. [91.12.102.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dad9a8663sm2337196f8f.6.2025.02.04.10.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 10:55:55 -0800 (PST)
Message-ID: <a6f08213-e4a3-41af-9625-a88417a9d527@redhat.com>
Date: Tue, 4 Feb 2025 19:55:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] hostmem: Handle remapping of RAM
To: Peter Xu <peterx@redhat.com>
Cc: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 pbonzini@redhat.com, richard.henderson@linaro.org, philmd@linaro.org,
 peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
 eduardo@habkost.net, marcel.apfelbaum@gmail.com, wangyanan55@huawei.com,
 zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-7-william.roche@oracle.com>
 <7a899f00-833e-4472-abc5-b2b9173eb133@redhat.com> <Z6JVQYDXI2h8Krph@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z6JVQYDXI2h8Krph@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.02.25 18:58, Peter Xu wrote:
> On Tue, Feb 04, 2025 at 06:50:17PM +0100, David Hildenbrand wrote:
>>>        /*
>>> @@ -595,6 +628,7 @@ static const TypeInfo host_memory_backend_info = {
>>>        .instance_size = sizeof(HostMemoryBackend),
>>>        .instance_init = host_memory_backend_init,
>>>        .instance_post_init = host_memory_backend_post_init,
>>> +    .instance_finalize = host_memory_backend_finalize,
>>>        .interfaces = (InterfaceInfo[]) {
>>>            { TYPE_USER_CREATABLE },
>>>            { }
>>> diff --git a/include/system/hostmem.h b/include/system/hostmem.h
>>> index 5c21ca55c0..170849e8a4 100644
>>> --- a/include/system/hostmem.h
>>> +++ b/include/system/hostmem.h
>>> @@ -83,6 +83,7 @@ struct HostMemoryBackend {
>>>        HostMemPolicy policy;
>>>        MemoryRegion mr;
>>> +    RAMBlockNotifier ram_notifier;
>>>    };
>>
>> Thinking about Peters comment, it would be a nice improvement to have a
>> single global memory-backend notifier that looks up the fitting memory
>> backend, instead of having one per memory backend.
> 
> Yes, this could also avoid O(N**2).

Ah, and now I remember where these 3 patches originate from: virtio-mem 
handling.

For virtio-mem I want to register also a remap handler, for example, to 
perform the custom preallocation handling.

So there will be at least two instances getting notified (memory 
backend, virtio-mem), and the per-ramblock one would have only allowed 
to trigger one (at least with a simple callback as we have today for 
->resize).

-- 
Cheers,

David / dhildenb


