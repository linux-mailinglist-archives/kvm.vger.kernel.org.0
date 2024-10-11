Return-Path: <kvm+bounces-28619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D58099A2E7
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F3501C20D9C
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F97216A0E;
	Fri, 11 Oct 2024 11:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/t+6sWF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B5C1F9415
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728646989; cv=none; b=KLpRCNUgnIeIFaoUDcbrqLphKCMeOD0JyeUuZzeXFs6iBgtitW+XIn+GhaxWMg7kpTEUUUXNUxgseED99AuZjnR6SAMBx3Ye6esPshA3Ddwk8x09jO1z2a7lgX8U3OCg/RJF7dAYWgDLgE9boczqMEAFx0Ko4Y4PoNt6r5wP2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728646989; c=relaxed/simple;
	bh=Sgjt5w22q19mO2o1fLrQoj/QK7UMPU3VPOx1oyeFQFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XLhYp3nzUy9w+wYaYGY3oFutHY3s+BR3Y/Lh+KQamECL1I46Fw7Re7tC7QKAEDQHHNP0n6OlMoZRIWS2MMqLixw0QVkbrfDhWHICib3hRSyuNU0yUR+nouPPJEXfmzae721mB/+Gn9h/8tnd11wTrMNQrsGnxcE8QwwOQIF0KqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/t+6sWF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728646986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HUQa3KwdmY0rbn3/U0pdq3jH3GxVh1Y2Q3vqDK3K2Pc=;
	b=Z/t+6sWFlDE+1CcDl3EKsdO/PJdYHM+5ss3hJ4Jn7kdy4bkN99TdRlGTu5lPw4nFMOrpma
	+a6HQ0XQp1O15t2Ng1of5ip+FLFiGnB4JIYMaH9WM8+e9D/t/qWRQ6Iu0gmy0USKJwt3lU
	xKsrV3JOH0IoY28dpjR9v3DJUPsBgJI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-CmaTEkieNwaWJWqxkFLxig-1; Fri, 11 Oct 2024 07:43:05 -0400
X-MC-Unique: CmaTEkieNwaWJWqxkFLxig-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43119e2a879so10126855e9.3
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 04:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728646984; x=1729251784;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HUQa3KwdmY0rbn3/U0pdq3jH3GxVh1Y2Q3vqDK3K2Pc=;
        b=jqEeNoIpchuOK+LHbV9SEUFzOHD3YS06w7n7X6kY7yBOqI6jXbW2H1+A0yMB+GlYwU
         59tlmRHLOEPi/Qj/oa1y22icHL/6eo0V4E0B2dcV1VG2kwNUVKztAY8tE/mYpFzN7ZZK
         eWTbp2WMbTOzhVuWZZKugm1o2KBzvbHNvhy+NZBJcxJBOgAy1wrNxz7tdwupNHpW+Wrw
         b/I1rAD13VtCQ2C3LRzWHNKyYGSzd29GrJ3HIKAWiUiRkVJYScoSJjMP06/IjZeoE8dW
         tqCtxTR6WpRZIQaV557KBVXG6oOsIgPuB16AXNNcVWfqa1IfLGh4+updEfQSZBRSh3VO
         EmvA==
X-Forwarded-Encrypted: i=1; AJvYcCV2VEiKjUvQ0niWLxLfGgkqXm4v0FpyLYTvZTyPcaE8gf9ZGzus4CFmxlT4OrZGr7Fa5Ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDKCK1xG8+u10dTiK9dDSRwr3xsByXs1rv5C/hFRcnUbb9PAx9
	6t5drRMQC7bjd8q6+gnt8zR4qsR69G2GSX8uJbVD5TgKKtGRKxKgaFxJNtak7RsMu3ixb5s8JSN
	k9D5WVw7I8sT3dZffTfUKRtSQEfM5p0+WBHvVOhCPu0xPYhjzdg==
X-Received: by 2002:adf:a313:0:b0:37d:41cd:ba4e with SMTP id ffacd0b85a97d-37d5529cb36mr1540617f8f.48.1728646983887;
        Fri, 11 Oct 2024 04:43:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/F6JN+8iAXfL0V9ur+rvXeWlba4pACwoQU4P3Lokk5TwcPnGkxoE62KIlS+2BBSebuXYh+A==
X-Received: by 2002:adf:a313:0:b0:37d:41cd:ba4e with SMTP id ffacd0b85a97d-37d5529cb36mr1540607f8f.48.1728646983480;
        Fri, 11 Oct 2024 04:43:03 -0700 (PDT)
Received: from ?IPV6:2003:cb:c749:9100:c078:eec6:f2f4:dd3b? (p200300cbc7499100c078eec6f2f4dd3b.dip0.t-ipconnect.de. [2003:cb:c749:9100:c078:eec6:f2f4:dd3b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b7ef213sm3727034f8f.99.2024.10.11.04.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 04:43:03 -0700 (PDT)
Message-ID: <cced8b33-f1f6-4bea-ac7f-08be729bd710@redhat.com>
Date: Fri, 11 Oct 2024 13:43:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] mm: don't install PMD mappings when THPs are
 disabled by the hw/process/vma
To: Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20241011102445.934409-1-david@redhat.com>
 <33c40562-fd22-4517-9f56-1039289a55e5@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <33c40562-fd22-4517-9f56-1039289a55e5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.10.24 13:39, Thomas Huth wrote:
> On 11/10/2024 12.24, David Hildenbrand wrote:
>> During testing, it was found that we can get PMD mappings in processes
>> where THP (and more precisely, PMD mappings) are supposed to be disabled.
>> While it works as expected for anon+shmem, the pagecache is the problematic
>> bit.
>>
>> For s390 KVM this currently means that a VM backed by a file located on
>> filesystem with large folio support can crash when KVM tries accessing
>> the problematic page, because the readahead logic might decide to use
>> a PMD-sized THP and faulting it into the page tables will install a
>> PMD mapping, something that s390 KVM cannot tolerate.
>>
>> This might also be a problem with HW that does not support PMD mappings,
>> but I did not try reproducing it.
>>
>> Fix it by respecting the ways to disable THPs when deciding whether we
>> can install a PMD mapping. khugepaged should already be taking care of
>> not collapsing if THPs are effectively disabled for the hw/process/vma.
>>
>> An earlier patch was tested by Thomas Huth, this one still needs to
>> be retested; sending it out already.
> 
> I just finished testing your new version of these patches here, and I can
> confirm that they are fixing the problem that I was facing, so:
> 
> Tested-by: Thomas Huth <thuth@redhat.com>
> 
> FWIW, the problem can be reproduced by running a KVM guest on a s390x host
> like this:
> 
> qemu-system-s390x -accel kvm -nographic -m 4G -d guest_errors \
>     -M s390-ccw-virtio,memory-backend=mem-machine_mem \
>     -object
> memory-backend-file,size=4294967296,prealloc=true,mem-path=$HOME/myfile,share=true,id=mem-machine_mem
> 
> Without the fix, the guest crashes immediatly before being able to execute
> the first instruction. With the fix applied, you can still see the first
> messages of the guest firmware, indicating that the guest started successfully.
> 
> Thank you very much for the fix, David!

Thanks for the quick test, Thomas!

-- 
Cheers,

David / dhildenb


