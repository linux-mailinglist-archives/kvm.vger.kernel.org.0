Return-Path: <kvm+bounces-34842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE26A06686
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7DB21678F3
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF509204090;
	Wed,  8 Jan 2025 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gLb5C/8t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7CC204088
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736368951; cv=none; b=jkT3w/N2PF4AD9cje+zRIeajqSqPUjGwd82MIhrr7W1Vq+A1xUHSiMP8MDOu+t/Z0byH2rmn+UEFOGQhLb7V00y/cyG5rv2/4FUfNkF9zAk2dfpFyvfel8m5OOu7W/CXOb4IqXx66BsQAvd3PiFVUAw8+O2Q6DWzDaUy5oc1in4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736368951; c=relaxed/simple;
	bh=v9XmVcmIqRJmFOmjJnpHJ+EMu+AWj/NmAFq9ffu/hxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMZL/7F+/Pp3FaJYOHOcrH4pB/YgRyaAdGN+kioSaZ5F63lnQsyUToYWKIC8OrBKq48p8y68w8Y2m45II8grQwmLU4lgDLCuzOvnZXMdpmvrdauImYA77k3OoHijmhu98hfQPftUk8xrOBo3pMt/TYRkmCwURymsTswA4r98W6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gLb5C/8t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736368948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m5WxHXaJxUUdIZdur2Wt+oXmwhkWvdvO5bnOeTcr6To=;
	b=gLb5C/8t4VWB/Z2ytH7VZm1AVmnkz0+u4ohx7Tgi0xti98V1EN3a2gAnjIxkDrvUJMm5PD
	C5R7B1ePTLGFMpJvjF1m3f5jc86j7iEKbeNcTDLaE9sFqZwkE6CmrFshRKf+usU6Eo2XSZ
	pFzh2PDous0nqZO9XvbaBnojJTRuVQs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-Dxom3aVXOl-o-jHRybHNYg-1; Wed, 08 Jan 2025 15:42:27 -0500
X-MC-Unique: Dxom3aVXOl-o-jHRybHNYg-1
X-Mimecast-MFC-AGG-ID: Dxom3aVXOl-o-jHRybHNYg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38639b4f19cso123535f8f.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 12:42:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736368946; x=1736973746;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m5WxHXaJxUUdIZdur2Wt+oXmwhkWvdvO5bnOeTcr6To=;
        b=gRvf7pLP+QeZZ03Ma9T3C819KiO2yjUTcEu+QuNKGbHn84hE9VqUJ3HmX1wzij3Mbg
         y/R6PQD9YffwN+sm6ZOQNP6v28IErnILHNNCfiC77R2h6KK9q2rKqgPkl0eV2Fot/tdX
         Ksoj2zz3AnDbw/DMwvviXgZ1v8sJ7bG/E71kEoH+ItHmAVofC8YoZF4KlTTMxbgZt9vR
         h/86ZFjy0X3CICN1r1Bnb1JNv/SkRpcWe1GcJ1haK39+NBRc7BCEMWmS8gHpEQgFWGWg
         JYihN2YtA+TnNbg6ZEpnu30EfKjiU3ukY1zsMGgEpsVprOMHUElfGT8OrLW4itcUpoiM
         mhbA==
X-Forwarded-Encrypted: i=1; AJvYcCXOnAZPt4dRQx/6a3ocgPpwEOeyFQn5yvcDVuMmWCPhO2CMk8BpdwiZrZtioEJDK4RJLMU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+D/LZZ5sp+37TtIbWHT0G02p46NrPYQKm0fOsAnbxIMxb752N
	4qtom/5HSZrBFVbAD9rLUrK/DljtcjTHJnMg3EEpJ2pT5OyODL/Qr+bY1IkAyv490sHOLsx/hgk
	ifm4ziJnelEv2ud3T2PBSRqDJTajtr68RAhlN0abXg5v1jXk0gQ==
X-Gm-Gg: ASbGnctNh+5/wko1tjBpAJgI3c64/F9Vlr7X9PhYeNYV1LlAxpIzJA3Scisd1raGPvY
	ZQDhV9kFSvQvnOJ1YSRvJt9ItSDEbgYDWYw9sti5CJEdcWtxlikYt6sTgT8phxDE6q+bA8pUwmk
	imsYbIdyS11jhklIaV6l5O+pAXMkF1+1daNvgiDPGtFkCiFSWve1uBzMgnu6AaOOZUU5EhRQhBU
	YvcfokHzCq+uAHRPG6+BA/nIGDY1ToNbnPbQaCM1RexQm5YUSJKwAPg3mp+S1+roJd859sV+cox
	QcrLCdPyWw==
X-Received: by 2002:a05:6000:2a9:b0:385:e394:37ed with SMTP id ffacd0b85a97d-38a87305463mr3089185f8f.18.1736368945819;
        Wed, 08 Jan 2025 12:42:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEueLrN9uq8JwA6bCu0tpMtZKPik/JRr5dYeXJOKC8Wt7y5lE82z+2xw7OHnkBJwRoBA04ZRA==
X-Received: by 2002:a05:6000:2a9:b0:385:e394:37ed with SMTP id ffacd0b85a97d-38a87305463mr3089168f8f.18.1736368945506;
        Wed, 08 Jan 2025 12:42:25 -0800 (PST)
Received: from [192.168.3.141] (p4ff23c51.dip0.t-ipconnect.de. [79.242.60.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c832e69sm53202767f8f.35.2025.01.08.12.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 12:42:24 -0800 (PST)
Message-ID: <c3291cdb-f9aa-457c-abff-ce7394edc5ea@redhat.com>
Date: Wed, 8 Jan 2025 21:42:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] KVM: s390: vsie: vsie page handling fixes + rework
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20250107154344.1003072-1-david@redhat.com>
 <20250108192117.51a2d2cb@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250108192117.51a2d2cb@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.01.25 19:21, Claudio Imbrenda wrote:
> On Tue,  7 Jan 2025 16:43:40 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> We want to get rid of page->index, so let's make vsie code stop using it
>> for the vsie page.
>>
>> While at it, also remove the usage of page refcount, so we can stop messing
>> with "struct page" completely.
>>
>> ... of course, looking at this code after quite some years, I found some
>> corner cases that should be fixed.
>>
>> Briefly sanity tested with kvm-unit-tests running inside a KVM VM, and
>> nothing blew up.
> 
> I like this! (aside from a very tiny nit in patch 4)

Thanks for the review!

> 
> if a v2 is not needed, I'll put the split line in patch 4 back together
> myself when picking, no need to send a v2 just for that.

Yeah, that might be a case where "significantly increases readability" 
might still apply.

-- 
Cheers,

David / dhildenb


