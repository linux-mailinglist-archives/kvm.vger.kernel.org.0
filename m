Return-Path: <kvm+bounces-10626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB8086E005
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45BAE28492A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FDA6BFC9;
	Fri,  1 Mar 2024 11:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgVpLhSS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F91B1E4BD
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 11:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709291822; cv=none; b=Om+a50awyAWGlsMHh0u5dbMPkU7VsO1cEQitNo9DaWShO6Pj+AKUuLFm9x+cf5G6YS4ECGIDtwRwxWFhCsO362uS3oQSrY/pyVU2/VLK4XsSidY+/Np0lg8+qyIqA0k+C0554mCqg17izNTxjLnlm1yTiX945hALZOr28bTRfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709291822; c=relaxed/simple;
	bh=2F5INcybYSBlsTuC5lQQe/pcELvA6BCsUmGtOzzVYcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f62WqGmVSUnxuObdtt0C0fqM5gLm+TJQd0LuwCDjAZxTMASUcDBm9uEMg5b+Ks20cDvWB6mALiAru0fg9siQ7DNjRLhycK/vdc0kc7f8CZIHoNw52hU2Jyw8B5oRJRGNRlAviqAL+RzrVkLGJf3M9k8FhHgJJ6E40AW5pqVD/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgVpLhSS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709291820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l7h8L36t6ZHKdWAqV7lhkUriHsYrS8uCVVI7qYoH0Mk=;
	b=dgVpLhSSFFnAWvFeG8IeypAzoEg1I7YbQI3dIK2aOTnRJ7041sbABK5jfh5GurLjURM9BL
	a6+eerz8f8YEc8nx3E/285FpzUhL9SrhCBlZJwc2cSUFoGaT+mXUxjIujV31vn+lpc3G+N
	m+LFPESvJLs3qMAxXPJoLxsCf/wxDmE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-KmymBJAvNgCHTK8GztlJvQ-1; Fri, 01 Mar 2024 06:16:58 -0500
X-MC-Unique: KmymBJAvNgCHTK8GztlJvQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-412c715a278so2681565e9.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 03:16:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709291818; x=1709896618;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7h8L36t6ZHKdWAqV7lhkUriHsYrS8uCVVI7qYoH0Mk=;
        b=G18cjSFozAHcqLwn+YhWSX/aeDWW6EuFYarpKThwnsULoKMWpuwr41yRjHkuqqn6zc
         6hi5U6g6ztn7lx/ZXVjxB9jzGIIdSvfYG8ON3ydmkEATq3pRTMQd3I+AQTmcm6Vl5q3e
         qUv77APfG+2V38MbQ+/534ysw5UALRjo0JlkLBqouN5qAXXrwje7NgN0geffXvjjwOkm
         No3JhOXNJDM+ZSd4GDYhsHgGrvAGD9Lbt3DgFSPWQ3sdJmRyFRJnqLPNjmBF2ulRK18I
         qnEQ1TI+oghiuBk2X7k41vt7WJ9CUHEGlEvt+OLiHCaqBIsa+xV5Tv7Zh3wxpWo8c4pO
         rw5g==
X-Forwarded-Encrypted: i=1; AJvYcCWvCiRQMg9v8AXlm13yJMhrDuFGS5CRDGL4mixUOmxThRp1J5Fif6nKrbW5jv0qBgLghOqOIh0Wj7lUV/n4CZUplIdm
X-Gm-Message-State: AOJu0Yyvp41XnXmUp8DBGZiwPQyXzbhBqFNGIP6nMv3il/mSb8vxvh8r
	OSRpYAmLv0vizSP+7UI/afLsSWv/RlAzXFC03yktes3CYXYabSszSZtZCb0NxWDPl6MLnP/gWgx
	G0nOBAZi6Ee/wrkj6OsxjVg5S66QSXFfwaGIz1i60p+Cl9f8V9w==
X-Received: by 2002:a5d:4e81:0:b0:33d:a190:f0c with SMTP id e1-20020a5d4e81000000b0033da1900f0cmr1064036wru.16.1709291817525;
        Fri, 01 Mar 2024 03:16:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFp1isGyPm2fiySEuFOLcKwywN+DApFjRV+WU0CQMIn4Sv8KZcSZoBBQS3Ta/UefMvGZlkiSA==
X-Received: by 2002:a5d:4e81:0:b0:33d:a190:f0c with SMTP id e1-20020a5d4e81000000b0033da1900f0cmr1063994wru.16.1709291817058;
        Fri, 01 Mar 2024 03:16:57 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3200:77d:8652:169f:b5f7? (p200300cbc7133200077d8652169fb5f7.dip0.t-ipconnect.de. [2003:cb:c713:3200:77d:8652:169f:b5f7])
        by smtp.gmail.com with ESMTPSA id cc6-20020a5d5c06000000b0033dd4673a4asm4408594wrb.71.2024.03.01.03.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 03:16:56 -0800 (PST)
Message-ID: <d8e6c848-e26a-4014-b0c2-f3a21fb4e636@redhat.com>
Date: Fri, 1 Mar 2024 12:16:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>, Quentin Perret <qperret@google.com>,
 Matthew Wilcox <willy@infradead.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
 <20240229114526893-0800.eberman@hu-eberman-lv.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240229114526893-0800.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> I don't think that we can assume that only a single VMA covers a page.
>>
>>> But of course, no rmap walk is always better.
>>
>> We've been thinking some more about how to handle the case where the
>> host userspace has a mapping of a page that later becomes private.
>>
>> One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
>> to the host with a meaningful exit reason) until the host unmaps that
>> page, and check for the refcount to the page as you mentioned earlier.
>> This is essentially what the RFC I sent does (minus the bugs :) ) .
>>
>> The other idea is to use the rmap walk as you suggested to zap that
>> page. If the host tries to access that page again, it would get a
>> SIGBUS on the fault. This has the advantage that, as you'd mentioned,
>> the host doesn't need to constantly mmap() and munmap() pages. It
>> could potentially be optimised further as suggested if we have a
>> cooperating VMM that would issue a MADV_DONTNEED or something like
>> that, but that's just an optimisation and we would still need to have
>> the option of the rmap walk. However, I was wondering how practical
>> this idea would be if more than a single VMA covers a page?
>>
> 
> Agree with all your points here. I changed Gunyah's implementation to do
> the unmap instead of erroring out. I didn't observe a significant
> performance difference. However, doing unmap might be a little faster
> because we can check folio_mapped() before doing the rmap walk. When
> erroring out at mmap() level, we always have to do the walk.

Right. On the mmap() level you won't really have to walk page tables, as 
the the munmap() already zapped the page and removed the "problematic" VMA.

Likely, you really want to avoid repeatedly calling mmap()+munmap() just 
to access shared memory; but that's just my best guess about your user 
space app :)

> 
>> Also, there's the question of what to do if the page is gupped? In
>> this case I think the only thing we can do is refuse to run the guest
>> until the gup (and all references) are released, which also brings us
>> back to the way things (kind of) are...
>>
> 
> If there are gup users who don't do FOLL_PIN, I think we either need to
> fix them or live with possibility here? We don't have a reliable
> refcount for a folio to be safe to unmap: it might be that another vCPU
> is trying to get the same page, has incremented the refcount, and
> waiting for the folio_lock.

Likely there could be a way to detect that when only the vCPUs are your 
concern? But yes, it's nasty.

(has to be handled in either case :()

Disallowing any FOLL_GET|FOLL_PIN could work. Not sure how some 
core-kernel FOLL_GET users would react to that, though.

See vma_is_secretmem() and folio_is_secretmem() in mm/gup.c, where we 
disallow any FOLL_GET|FOLL_PIN of secretmem pages.

We'd need a way to teach core-mm similarly about guest_memfd, which 
might end up rather tricky, but not impossible :)

> This problem exists whether we block the
> mmap() or do SIGBUS.

There is work on doing more conversion to FOLL_PIN, but some cases are 
harder to convert. Most of O_DIRECT should be using it nowadays, but 
some other known use cases don't.

The simplest and readily-available example is still vmsplice(). I don't 
think it was fixed yet to use FOLL_PIN.

Use vmsplice() to pin the page in the pipe (read-only). Unmap the VMA. 
You can read the page any time later by reading from the pipe.

So I wouldn't bet on all relevant cases being gone in the near future.

-- 
Cheers,

David / dhildenb


