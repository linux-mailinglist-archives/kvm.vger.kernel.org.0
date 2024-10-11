Return-Path: <kvm+bounces-28616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DBF799A2DA
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCD821F252FC
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFAD217305;
	Fri, 11 Oct 2024 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0NNPEe0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364B0216A1B
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728646771; cv=none; b=hKLGZYvw/maCQKA/xSH2+Ec0/DBd6AgJhrye2mbcZsCVS0e5X84PDV5dhiqnUFt5VuvmH6sT5IcAWpddsq6IJg0nNuKO9DLsMDfxiMLdyX1w3bYEs1aAtiqd2gaUSDQJxTF7nyvycY9tcFsBekWnA06ISy+2CV3nd93K5susZqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728646771; c=relaxed/simple;
	bh=uxWda1jjE01Hiq2/GdvI3YwRYiUh/JwIj8EBT53/D/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7QggoL6rGdDmOqeGxNTh0AHFzMtwJqOk0yO/eFYNULUpiumJyONGQ0mWZP+Arl+I4DburB3GzH0UOCmhI8wt2y4urptCFGQOZ39LusMOT3v+pY4ma5M76ds93a4q6AyPe5jga3h3EYgrqMi3MRC5gOKQKO/FdXbdvHavjrKVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I0NNPEe0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728646769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YSwa3uEpPswNDcoEbeNVSsH+ZHhyvprVjcqw1gIKnUA=;
	b=I0NNPEe0tAVl2WiqAYi7RdGrQBqEAXAdrIQVsrLM9Ogkabxj1ZSJt558gBGe2uMHVQB9V/
	hDNiBIN+U1BIJQxMZLYD1nSL3LLEYL8BksEWog8P08reMDpaSVvimtdmBzgSR0O/N9LfOp
	oUGLionYLOcUhSuE6bBVV4vZOaXDcDo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-EpevZq_5MuW1GnP8zmTjgA-1; Fri, 11 Oct 2024 07:39:28 -0400
X-MC-Unique: EpevZq_5MuW1GnP8zmTjgA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42cb374f0cdso10947355e9.0
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 04:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728646767; x=1729251567;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSwa3uEpPswNDcoEbeNVSsH+ZHhyvprVjcqw1gIKnUA=;
        b=gs42RaCadbU7Wv+f6Ceh51eozc4vujtO5RDppk9sTxsJdQE0q7uszhhDMO4sTlYj45
         ghkqN/jM4W8pZs5DrZUa8uEaM3NwzP4UNUAMsQwpBRv/ATOntyOSrSwuR3nTfYa6PySS
         X+iG8ZFyxZmxQ5rbZPQfiJo9lbp/tR9D6K00oUtXmUXzarQN7sbnpipXUObVebwLgspL
         YJJkmJIPCIyZWnu6Gf/d9b1/bUbnNr3LPL2z3yg4dwxektfAwcgjtDzYJHwJJOe32D0X
         MgfQPdOKlHOg+qsXfciAjdJEe+ppQDH5DllbopCm+zHZBfb8smEROKDi/G27w849aWqB
         ECow==
X-Forwarded-Encrypted: i=1; AJvYcCWE5OqS+/JL9UPW5StVcusVj/k+j1ItKgh6QDt+ha4idUi9qujCLZyPiLm9GbhtzHZPDr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKmUIB6Xega4hW8DqkHrl9XaTlUc/oebAsNPNzyPHR6AICKyZo
	R4b1G+dys4Rgs4/i8TUj8ek2c+vcTeCpucZivqhcYcG+Y2tFICPsCrpIdN22Wyy52zLUk712EXs
	mSJ4wbtrWSOk1JldDLQ9TjntKm3N/281QnAPxpWmnGYI+kQHtLQ==
X-Received: by 2002:a05:600c:b9a:b0:42f:84ec:3f9 with SMTP id 5b1f17b1804b1-4311d884328mr20904595e9.3.1728646766777;
        Fri, 11 Oct 2024 04:39:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXRS8eHd5J8kgixq2jF5sP0vcpuDVeq0dVlxRTUowv7C4+G18bwN/KWrHQGRJVOzJAbCnurA==
X-Received: by 2002:a05:600c:b9a:b0:42f:84ec:3f9 with SMTP id 5b1f17b1804b1-4311d884328mr20904325e9.3.1728646766313;
        Fri, 11 Oct 2024 04:39:26 -0700 (PDT)
Received: from [192.168.0.7] (ip-109-42-51-26.web.vodafone.de. [109.42.51.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf5181fsm72311515e9.25.2024.10.11.04.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 04:39:25 -0700 (PDT)
Message-ID: <33c40562-fd22-4517-9f56-1039289a55e5@redhat.com>
Date: Fri, 11 Oct 2024 13:39:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] mm: don't install PMD mappings when THPs are
 disabled by the hw/process/vma
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20241011102445.934409-1-david@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20241011102445.934409-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/2024 12.24, David Hildenbrand wrote:
> During testing, it was found that we can get PMD mappings in processes
> where THP (and more precisely, PMD mappings) are supposed to be disabled.
> While it works as expected for anon+shmem, the pagecache is the problematic
> bit.
> 
> For s390 KVM this currently means that a VM backed by a file located on
> filesystem with large folio support can crash when KVM tries accessing
> the problematic page, because the readahead logic might decide to use
> a PMD-sized THP and faulting it into the page tables will install a
> PMD mapping, something that s390 KVM cannot tolerate.
> 
> This might also be a problem with HW that does not support PMD mappings,
> but I did not try reproducing it.
> 
> Fix it by respecting the ways to disable THPs when deciding whether we
> can install a PMD mapping. khugepaged should already be taking care of
> not collapsing if THPs are effectively disabled for the hw/process/vma.
> 
> An earlier patch was tested by Thomas Huth, this one still needs to
> be retested; sending it out already.

I just finished testing your new version of these patches here, and I can 
confirm that they are fixing the problem that I was facing, so:

Tested-by: Thomas Huth <thuth@redhat.com>

FWIW, the problem can be reproduced by running a KVM guest on a s390x host 
like this:

qemu-system-s390x -accel kvm -nographic -m 4G -d guest_errors \
   -M s390-ccw-virtio,memory-backend=mem-machine_mem \
   -object 
memory-backend-file,size=4294967296,prealloc=true,mem-path=$HOME/myfile,share=true,id=mem-machine_mem

Without the fix, the guest crashes immediatly before being able to execute 
the first instruction. With the fix applied, you can still see the first 
messages of the guest firmware, indicating that the guest started successfully.

Thank you very much for the fix, David!

  Thomas


