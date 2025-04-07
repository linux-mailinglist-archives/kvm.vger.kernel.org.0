Return-Path: <kvm+bounces-42825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B3BA7D8B5
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B2AA3B6FD1
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906F322A813;
	Mon,  7 Apr 2025 08:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNc3XpuT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B3222A4F8
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 08:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744016047; cv=none; b=miZ22aRHy2B3egT8g83W8p1qQp+H66+4p3jZMewrUBwkKXVKp5va2hOsQZaji6GWT6WM4szpOF/QLTzl50hv0wygUmMPc9p4NvdMlrI7K8hHJsnf1rImYtQBqtVZ2pKOM5tVuP9XQj5HB6EA6ZMbuWtijEX22SYZU7gC4Xt6kyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744016047; c=relaxed/simple;
	bh=TANN6f2gSC05mbo+WIMs8oICkZzKx6S4A0qgYF7W2C0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZL8xMc77XKW/OebRuRrh6mRMUbYBwa/YwXFgSkRkfrICoF34959bx4vwTrsgRqxC93gAY4iQsE8QDdwvrYyFE70GsUcHDjw15YEEHvuXrI4QNC4nSn570wk+P0/IYrWa6xOroHlYlVcapAzDF26OFnk/E17mJ4kje68PtkBG6U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNc3XpuT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744016045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k7Uzb3UjBkw5m5b4lvL7h9ht1pG8QEC8Q9QUE3uuc40=;
	b=GNc3XpuTqX/yajAi0eArCRERI9jVMeWniNqwECGTmzjYoE2zY4ScTrvoTsnk29NsIYpZsU
	UEvx/E3UWfVCKN3IyN7fvlNyr4LPpVet0wwIoJ+jt7yG97O0So2FP2OWZhx4UnKHMf27L+
	8c1UuA8r/ul0auoNIE05mconqFtFy3Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-xiRL1w4wMwi26LqyuHW6iw-1; Mon, 07 Apr 2025 04:54:03 -0400
X-MC-Unique: xiRL1w4wMwi26LqyuHW6iw-1
X-Mimecast-MFC-AGG-ID: xiRL1w4wMwi26LqyuHW6iw_1744016043
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43947a0919aso29139595e9.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 01:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744016043; x=1744620843;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k7Uzb3UjBkw5m5b4lvL7h9ht1pG8QEC8Q9QUE3uuc40=;
        b=bzVcKgpSyIpU0E6fjq17BI524ymgM7Xx9ytfYYHtzB94VOlPBMFrUjhUaL24pP/Dpk
         K6D+FDrfQRwZkDP/mfP88HIf/KoC0YKXpzMevKLVhsMuE3MvfkG7DM1qObbrMkCKQLf9
         iOH4JLzCiTOREfiisVf+/3xTkxvEmf3Xj4dr4mNYtJOJj2v/BM+9PuSekBlpYQNMeQwq
         wcHdWL3zKT7gSNpXczZJRQALOIr3aMilKsSwHKl+wcwmXRERt6YfzPjB6i9eMoDMhfCV
         DlT+arQhg0BZ061GNuGOZ2JAjr3hF6BBSgMVWepXYL8AH3JQvv7o03PzCsHXJlkr3XKb
         zHBA==
X-Forwarded-Encrypted: i=1; AJvYcCVPX/uIOSiYEkJ+IfP7N27N7SS3CtV8BaGsdf7YVSIQa33hRqGGj8YO5OgBii4aiKGm1T0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTRwBvG3nGIsbRND3MTrX/RD5KiXKPkenv2+VDpxrnDlYeKFr6
	d+b+jmQdG6jwLp+uqXxpd8ozsWlbmeL2nOIyegCvGvQtWZmhGBUVV9i8IQ8XUD/5okGc50t2rL/
	BqkjAhc4rlMtuPkbE2ZnwRyF6jWoJym23y+xrByBDmNG4DlksCQ==
X-Gm-Gg: ASbGnctU+IrG3DUni2pzGZGiSymJ2kzrwqYoaS0aw71fHTMwgMo7Q9eJrG7ZbUeZfCd
	e0ZXNdxAlyUlDrfV2AUkUtVf0Vjiz3F2nTCWU+d+jGIGc7q2W1nBJVLttuH+ua3OAkOHQLdYrGV
	Do/dz39N8/4QKAxyll8i93uvd7RI6zZOj5e/qSu7Ganjh4ht1Htfkx9Fj59tyScLG7uWCxIDsOT
	xWRkTan+Umm2pNjkOcqrsF8jeTvKt1jCkcdqUAWpIWRjtwLvmZQgSqPhL9ZYLu11EaXveATFeAc
	13mjE8v0Ow6uinqXqg65xVx/S0CxiDEjwqszunhs8qRImEkQ9QzfirBCY91GrC6c6Q6pNdXJhTO
	18gIENV6VY2jDEK1lZbmkYs/cYx/MC4vdB0DXgQkRpbQ=
X-Received: by 2002:a05:600c:1d91:b0:439:9424:1b70 with SMTP id 5b1f17b1804b1-43ecfa18d8fmr140497965e9.30.1744016042778;
        Mon, 07 Apr 2025 01:54:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFY4o2pgToU8K/fkMKcSy66bOlXQkgTor8GLtJJVjDrzBy3Blwf7FrgQSuGJ1CvpjOJy2nf6g==
X-Received: by 2002:a05:600c:1d91:b0:439:9424:1b70 with SMTP id 5b1f17b1804b1-43ecfa18d8fmr140497675e9.30.1744016042399;
        Mon, 07 Apr 2025 01:54:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:3c00:8b01:4fd9:b833:e1e9? (p200300cbc7383c008b014fd9b833e1e9.dip0.t-ipconnect.de. [2003:cb:c738:3c00:8b01:4fd9:b833:e1e9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34a8952sm122676575e9.10.2025.04.07.01.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 01:54:01 -0700 (PDT)
Message-ID: <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
Date: Mon, 7 Apr 2025 10:54:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
 Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
References: <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
 <20250407044743-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407044743-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 10:49, Michael S. Tsirkin wrote:
> On Mon, Apr 07, 2025 at 10:44:21AM +0200, David Hildenbrand wrote:
>>>
>>>
>>>
>>>> Whoever adds new feat_X *must be aware* about all previous features,
>>>> otherwise we'd be reusing feature bits and everything falls to pieces.
>>>
>>>
>>> The knowledge is supposed be limited to which feature bit to use.
>>
>> I think we also have to know which virtqueue bits can be used, right?
>>
> 
> what are virtqueue bits? vq number?

Yes, sorry.

Assume cross-vm as an example. It would make use of virtqueue indexes 
5+6 with their VIRTIO_BALLOON_F_WS_REPORTING.

So whatever feature another device implements couldn't use this feature 
bit or these virtqueue indexes.

(as long the other device never intends to implement 
VIRTIO_BALLOON_F_WS_REPORTING, the virtqueue indexes could be reused. 
But the spec will also be a mess, because virtqueue indexes could also 
have duplicate meanings ... ugh)

-- 
Cheers,

David / dhildenb


