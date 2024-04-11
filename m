Return-Path: <kvm+bounces-14246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDAF28A14A8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 325F2288AD4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 12:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B9129D11;
	Thu, 11 Apr 2024 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtXzgPur"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DE528FD
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712838642; cv=none; b=MrVU6DAXvlpXrtVuQbZNgZkngU1zDP/5siTTg2ElFHYKwrFH/Yu1Qj3F88RHxm6rPeVWVuYaLleqmdOSEFE1KIe7R+6DFFrcyWoyek+XyUwXbOQmY5Jn/gYx6OlQhHwkpR5r90QZy2PuA4TKyK3XbnqIza1zmI2V574fkudKdT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712838642; c=relaxed/simple;
	bh=19SThbH+HroCA8DKalKKz3GnvI8MQEhAC7iHyh5IYxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8vOtkeowH1qXB0GAKGL/tavmcb494amiNEFTCGGENuZX93I8nyZ0Qky8TlV5SPa57V70QyNtA5WPkj/vJu1y99QT3GikDkQhr4cBbAalb0VGBosrlt75vC8314RLsjFiUKpf0bZOjmb6gupVBR4O/pJZeXBkH2vcDWes7SnvMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtXzgPur; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712838640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y7TwXs97cGKCSPlZat8D9T+J4ssIvDgilxKFcQCp65o=;
	b=gtXzgPur30cNqEZjIAbKAKx9vZbLYPTF/lACA1Mz+ftg3R/0mGrEx3WZLupx1JN8T9iIgI
	TN9fPVvW09zySc6OtDWPT/b/Ae4egr1XXsLTb8pHxBO0Gsu3ae1Mz/7wlA8QopTTmhnhWv
	g3diwpjNIIz3eKKDOGbQSUr+4Wz+O/8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-U0o-u8L-P8KUcMNlXtMBgQ-1; Thu, 11 Apr 2024 08:30:37 -0400
X-MC-Unique: U0o-u8L-P8KUcMNlXtMBgQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d9e4438becso3375251fa.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 05:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712838636; x=1713443436;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y7TwXs97cGKCSPlZat8D9T+J4ssIvDgilxKFcQCp65o=;
        b=Ld3DaLoBreJ129M7mGNlLVS5VfOZ+cW0uSytF6PyDqTRZHCpywkXwGln1rAXR0dAxO
         5r+vb9rXYjZ1XPKZvca8Va362+rYjHUtAEt2OGDPPvSzVERLVbGYUtKeS1DtwbHNjAwJ
         lu5FzKdPaIttnX4d071wW6mwVeaZ8wO2OZiSPIL4208peLWJ0Gd4vKLrB43TzT5cf8Iz
         X5oMpz5MOfkEUo2rhSnJV3KxjjEqi5Su+DZLsJAot40pX1YryS6wrbE/L8qIfzPOTpfk
         4OuuSXXFRexU61W8ju/3dVo814uDpoyGJVHwvlSPtZ8HrzCYKHH2AdSSjYnL3l3Dr0fm
         Y+pw==
X-Forwarded-Encrypted: i=1; AJvYcCXoGsYGZtNFarw7hHyqz3k+hUEJZ1Efsa/JJxGl9C1/3V0hg8504QhqA3B2ziebMLlJ3e/0KPc9TTlMT4cwc8BKsFjJ
X-Gm-Message-State: AOJu0YxMjgWbqcnatKuHlqpArd9/ovpiC/9rbMbPsQd+ZQNwvG5+lj4Z
	bHoBsG3vE7Rt1qkfkMgkvhy7uBeNqxZekzO9Ful9q0LBRSXAmDl+ZOmFUADI579Xv87NETpn+rD
	kPkrRmlPwl8zPxG9s4XAjLcE5UxfUgyqFSAGv4eTl4YPtca4DYw==
X-Received: by 2002:a2e:98c7:0:b0:2d8:dd28:8748 with SMTP id s7-20020a2e98c7000000b002d8dd288748mr2945373ljj.1.1712838636016;
        Thu, 11 Apr 2024 05:30:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNhbKnm91UzHHYzeclwSv0GXVTE0gXbsFHBBDgl8GE19+0m4lF65G2tfbEM69kj3DPzwh/3g==
X-Received: by 2002:a2e:98c7:0:b0:2d8:dd28:8748 with SMTP id s7-20020a2e98c7000000b002d8dd288748mr2945334ljj.1.1712838635554;
        Thu, 11 Apr 2024 05:30:35 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:4300:430f:1c83:1abc:1d66? (p200300cbc7244300430f1c831abc1d66.dip0.t-ipconnect.de. [2003:cb:c724:4300:430f:1c83:1abc:1d66])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c1d8f00b00417e134dd2dsm1142306wms.37.2024.04.11.05.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 05:30:35 -0700 (PDT)
Message-ID: <b9d9af94-5935-4034-bf3f-9ba283df3ede@redhat.com>
Date: Thu, 11 Apr 2024 14:30:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/userfaultfd: don't place zeropages when
 zeropages are disallowed
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240327171737.919590-1-david@redhat.com>
 <20240327171737.919590-2-david@redhat.com>
 <ZhfW7qzAGPQo3mJN@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZhfW7qzAGPQo3mJN@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.04.24 14:26, Alexander Gordeev wrote:
> On Wed, Mar 27, 2024 at 06:17:36PM +0100, David Hildenbrand wrote:
> 
> Hi David,
> ...
>>   static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
>>   				     struct vm_area_struct *dst_vma,
>>   				     unsigned long dst_addr)
>> @@ -324,6 +355,9 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
>>   	spinlock_t *ptl;
>>   	int ret;
>>   
>> +	if (mm_forbids_zeropage(dst_vma->mm))
> 
> I assume, you were going to pass dst_vma->vm_mm here?
> This patch does not compile otherwise.

Ah, I compiled it only on x86, where the parameter is ignored ... and 
for testing the code path I forced mm_forbids_zeropage to be 1 on x86.

Yes, this must be dst_vma->vm_mm.

Thanks!

-- 
Cheers,

David / dhildenb


