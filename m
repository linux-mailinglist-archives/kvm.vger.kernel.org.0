Return-Path: <kvm+bounces-35976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBCAA16B03
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F4A01882403
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0DB1B423D;
	Mon, 20 Jan 2025 10:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RO6+LNqQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CEE187872
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737370128; cv=none; b=doVL7OG6wsxH31CHOEG59AN5eGL+u2slsX6vipvBUDNq994c3jQu5suEX8g6Cseb1SFPK3WnDMIde7vzkpWP1HGbfoJ2g6dZDt2wHDsNNnbsSv6pA72nFqMwA+kj1WKNt2UyjdfU2Toi1syVmkTuDlV57NCVOnHmMZ5QOjwphpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737370128; c=relaxed/simple;
	bh=y2unq5/FVGHEpE+sTT3dkLLyeCQWx9q5RIRAq2e8ml0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e3KfwtJ68HsNqieoONy0/MJ/xVK9EtlF1WMNG7ZxcQrKeUN8IwqB7rVRda3InjoN1/f8dq6Xp/G8Yx7vu2G3PYwT7x1/Ilw1d8m4Ju4ep9Guer0Nhtsl9ephP417Hx7xEsTxWwas4ymXfSOHUBD2D8XNT8JrTa0+71o0Qarc6yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RO6+LNqQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737370125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gU7FjcOGy2MbHH0U621psbWRzSPzKHpkMMgkcn2VRYk=;
	b=RO6+LNqQEA+4zEjjHaggx3+7lSV81FFW7uz2ySExYwHbBpJ+sGWGmrJi5gzhxh7sTdRVD6
	ngMdbjlRH+JCYbs6OgKbqM5nlXEu8FcXeLvaii4A19DS1Myp3ZHgtkiYIPfBzp7TpWSu/O
	+mq7at2RDRQiMUV3Vqf0cCGtJvQJpDA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-4LAgK73eOfCx-CHuYMKNFA-1; Mon, 20 Jan 2025 05:48:43 -0500
X-MC-Unique: 4LAgK73eOfCx-CHuYMKNFA-1
X-Mimecast-MFC-AGG-ID: 4LAgK73eOfCx-CHuYMKNFA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-386333ea577so1683974f8f.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 02:48:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737370122; x=1737974922;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gU7FjcOGy2MbHH0U621psbWRzSPzKHpkMMgkcn2VRYk=;
        b=xRyPVPw9wD07ngITv4pf6VaTy924WhXM9ciaruEWZMxOf5ZXE5xLQBFT5Apo0rDC/C
         gU8j+Lv+iqeJIBgzpp4ZSs0k25FBWy+z3vEJvAtTwyOsZNI+QYFk1oL9tA6E6r4UeoJJ
         sqzbM2vQtQrGbkT8Fjv47RTFL/mvv1zKpPu5qo5BGkEkuDgfMLo2PLAYyZoiDN2yQp+J
         lakDHYewjCapQXd+VuQJNxPVPw05EDMsG70TrBVygBTbocVCojP4YORtmq3cqFT0NmrM
         WRqrglhkOc+SI2/ZkbD1rYF7jNeSAoTP7vmtY5GgoVjaayyXhNiGSLdtKoSZ6umyG5l/
         XOfA==
X-Forwarded-Encrypted: i=1; AJvYcCWX4F5Mfj9sJi9Hbn/xLntz5rER1UIkTdobOEmHyTAPHd2rIsyclaiELGeKmUNEnuOzJ6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcGjo124zAYBYAfN89W8kBsHOThfw5ucevooUOBHiys55YRPGX
	Y6E0RUxW8wPliS+eWzcnVTxNUGVSW9AacjqkQ30rThJe1VFXaiEQtG51K3qGbCsLXdVt+Ls3iDi
	TlZzdhFoFNURylAclxfC946MMj9MWfuABKI4xEjb83tiEfaXGFA==
X-Gm-Gg: ASbGnctpAu6GsYo4PzJ/CLb5SvZZsPB5bF2cclJ+yvJNnGL9OrZO8xKb4ghDoL1siqz
	dOHqqnm1UXZugwxstL+iftPesHOpI4imqUYxA7eJPnXbAuYOvpXnW2SGRfsVH3VLM/LW0/ePyNe
	PJmiK5EhIXEZ/0g07RAf+I3Uj9AlrcA4WL4jXqVevnfGjOExYAQO61EEeGIcq4CceJVU5wPl1Td
	ilyOaRJNXByssJi2xvPWuhc33r46CcPE+WVewIY1TGN9NhXwuYw3d/9BX2Ht9mXv2YL4B7Z1KGH
	XlCt4HwJhqDrcMO8UG0KZr4SIL9bFsPCs3XzO3VXuS/LhMyY59wUn0qY85RCIz7YU9w43OJLlTp
	iFWpbRtCrwYnEyHw9TPMjFA==
X-Received: by 2002:adf:a3ce:0:b0:387:86cf:4e87 with SMTP id ffacd0b85a97d-38bf5685126mr9448268f8f.15.1737370122512;
        Mon, 20 Jan 2025 02:48:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeoSR0RfE1Ok3y4/x04d1sgJx6plyl1VCg6t3PPHIxRKeyKGPYdGQ99BOi6dN+kTy6BWKOGQ==
X-Received: by 2002:adf:a3ce:0:b0:387:86cf:4e87 with SMTP id ffacd0b85a97d-38bf5685126mr9448253f8f.15.1737370122183;
        Mon, 20 Jan 2025 02:48:42 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322ad81sm10132666f8f.52.2025.01.20.02.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 02:48:41 -0800 (PST)
Message-ID: <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>
Date: Mon, 20 Jan 2025 11:48:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sorry, I was traveling end of last week. I wrote a mail on the train and 
apparently it was swallowed somehow ...

>> Not sure that's the right place. Isn't it the (cc) machine that controls
>> the state?
> 
> KVM does, via MemoryRegion->RAMBlock->guest_memfd.

Right; I consider KVM part of the machine.


> 
>> It's not really the memory backend, that's just the memory provider.
> 
> Sorry but is not "providing memory" the purpose of "memory backend"? :)

Hehe, what I wanted to say is that a memory backend is just something to 
create a RAMBlock. There are different ways to create a RAMBlock, even 
guest_memfd ones.

guest_memfd is stored per RAMBlock. I assume the state should be stored 
per RAMBlock as well, maybe as part of a "guest_memfd state" thing.

Now, the question is, who is the manager?

1) The machine. KVM requests the machine to perform the transition, and 
the machine takes care of updating the guest_memfd state and notifying 
any listeners.

2) The RAMBlock. Then we need some other Object to trigger that. Maybe 
RAMBlock would have to become an object, or we allocate separate objects.

I'm leaning towards 1), but I might be missing something.

-- 
Cheers,

David / dhildenb


