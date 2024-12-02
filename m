Return-Path: <kvm+bounces-32825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 297F79E07D0
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE84E281BCC
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 16:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9341428E0;
	Mon,  2 Dec 2024 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+4qPby1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A84B137C37
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733155219; cv=none; b=UD9jdjKKIvxVc1rQ+tVsF3vm60kl7di+dmk7rP4nIrVbLRroylKBgRkknxQwJiolDy49YiJ8WaeFSpQjdcwFachA5zS9hA/bWK8G8BysdV/nBrKgsVsNzU/0gI+4zrGl5HE9dKRIpLU8Hv9CCQjABSBfoYu2JaoqlbM2Ic+s7Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733155219; c=relaxed/simple;
	bh=fQX89jMGcVONFhApYw7qbVo/J9KcRslXeu7xNLEcnmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XVYNHAQQRAGoLP53GJZC2Rw9J5P71FeJVKo6MbOkeUhuA/5tG1MtK6P+UqI189qfPChAqtKisRB3ojkEOoUhgH6ACbNW87fky1d15cNpQeDN4Ol2ZmeC0GDSswkWdgJGNZrXG3ddY3pwWIY+1reBQQ/OgqKGXiuq7mI51UkAJdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+4qPby1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733155214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z5yIa0WtRtrn8Wu/RsXzZ/EiInFH4pnH8ZIR5t8pGeE=;
	b=T+4qPby1Zbn6k0WGEwH75Dc9fD5AXrVjZJp4tuQQKM5rY8r+ApDlqDXqHxnUTPNCUY5pZy
	y3Q+OHav3kuH/zf+V9iEVoGBuVwRknR4h8vOOfdkR/ixR7h2lJdMS3VQt+VY4V5Ne1LZm5
	p1PySPEB69UNABM3FOueKE5PHTcskh8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-c-VyLexRPseLD2MNOnfDeA-1; Mon, 02 Dec 2024 11:00:09 -0500
X-MC-Unique: c-VyLexRPseLD2MNOnfDeA-1
X-Mimecast-MFC-AGG-ID: c-VyLexRPseLD2MNOnfDeA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-434a4ad78a1so37042745e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 08:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733155208; x=1733760008;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z5yIa0WtRtrn8Wu/RsXzZ/EiInFH4pnH8ZIR5t8pGeE=;
        b=jvsjXm4O42EF2jiwgpoCP33/oq+Qt46A9LRCiQZRl3yWUBXtj538aACSbf6QQ46CDA
         JAZQy9HBZE1sm0KdVypgBU6GeLEmVWJAxymVuXXBz5cnJwK7FNZmYEGHu2T38Z/cOeRj
         YN5DaSWLeeb3iPGM/0jECcKcHAiSp+vE+UWuJyGcQp5zsFJ05FZHcmTAfwe75+Nbnwu8
         diPJVyIjJTI1ztoTQVdGN+YxfRytEhlwpxhXdJJ8g+43IetR0VXuGHiWg4avg2td4l8n
         jNXGFZ6/PbGqoTeezhRSosU5N/uKFPxnGoxls8inmEHT76Ys0YBRhKcgLFKIKZkkxH6f
         dR5A==
X-Forwarded-Encrypted: i=1; AJvYcCUrDMW5HB8hlNOZBRbCfbuzpHkQncq45JvKTuodDbdsl+JaYjrEmXb2Vx+cCXDke7h5MDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYUg8iOnp88ccFNBJ7EOvD2sUxcxMe8JCpAV/BZ7K4lBJZRt45
	MkuTHHh2UmpknJaKc9rJXjv0W5ebB/LE+/tfK4/ZM9yNKwLAiAJb0ZKafldyihKgws3pfrCm68s
	8J+h4wfHWnVF6UrHskHHr8ZjXZycPpHqY4ECMEh0z+OqNroo1Vg==
X-Gm-Gg: ASbGncvpE8RtfCGcM8esxql8JmnxVRiT5U/oKdKvp1nQwckmp67PtuzpXrCVjAiT4jP
	BfBPmhI+YXktT0FBpdGQz25R9GFmvM4LePz1u4o/ogoc5A7k0sL35cuVn9LSRii5H8iG4IZXylp
	XLiK36sh4BJQg2hk/Q4Gzqxi3xKSIIdgJavTyBKTBjVZbbNqfplxO/fs2Rjn6HC0v5SLdy9cQn/
	CT0rzfcdnnKpWhKuu/FE+FSRXdOP8thcxnM1qEIXGnEZ1+gz4xHxTr+WN2Vc5/7AqvfR/n3lkOF
	CVill2BX9hykvFaBQnGFjGXpMyelOKVhCzZXFbn0ETO2D255muX419a8scrABeCRJYwA6/k1RFp
	5tw==
X-Received: by 2002:a05:600c:5490:b0:434:a815:2b5d with SMTP id 5b1f17b1804b1-434a9de43cfmr204559145e9.24.1733155207768;
        Mon, 02 Dec 2024 08:00:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGErtWX691e1crjNUnsnaZcPK2ZKTlN37ROp7uAqSlIVV2JI2jlNosajNJzhSNjlYd9+VuekA==
X-Received: by 2002:a05:600c:5490:b0:434:a815:2b5d with SMTP id 5b1f17b1804b1-434a9de43cfmr204558725e9.24.1733155207404;
        Mon, 02 Dec 2024 08:00:07 -0800 (PST)
Received: from ?IPV6:2003:cb:c73b:ba00:bcff:e7c1:84bd:9486? (p200300cbc73bba00bcffe7c184bd9486.dip0.t-ipconnect.de. [2003:cb:c73b:ba00:bcff:e7c1:84bd:9486])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bec1sm159953105e9.5.2024.12.02.08.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2024 08:00:06 -0800 (PST)
Message-ID: <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
Date: Mon, 2 Dec 2024 17:00:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
 <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.12.24 16:41, William Roche wrote:
> Hello David,

Hi,

sorry for reviewing yet, I was rather sick the last 1.5 weeks.

> 
> I've finally tested many page mapping possibilities and tried to
> identify the error injection reaction on these pages to see if mmap()
> can be used to recover the impacted area.
 > I'm using the latest upstream kernel I have for that:> 
6.12.0-rc7.master.20241117.ol9.x86_64
> But I also got similar results with a kernel not supporting
> MADV_DONTNEED, for example: 5.15.0-301.163.5.2.el9uek.x86_64
> 
> 
> Let's start with mapping a file without modifying the mapped area:
> In this case we should have a clean page cache mapped in the process.
> If an error is injected on this page, the kernel doesn't even inform the
> process about the error as the page is replaced (no matter if the
> mapping was shared of not).
> 
> The kernel indicates this situation with the following messages:
> 
> [10759.371701] Injecting memory failure at pfn 0x10d88e
> [10759.374922] Memory failure: 0x10d88e: corrupted page was clean:
> dropped without side effects
> [10759.377525] Memory failure: 0x10d88e: recovery action for clean LRU
> page: Recovered

Right. The reason here is that we can simply allocate a new page and 
load data from disk. No corruption.

> 
> 
> Now when the page content is modified, in the case of standard page
> size, we need to consider a MAP_PRIVATE or MAP_SHARED
> - in the case of a MAP_PRIVATE page, this page is corrupted and the
> modified data are lost, the kernel will use the SIGBUS mechanism to
> inform this process if needed.
>     But remapping the area sweeps away the poisoned page, and allows the
> process to use the area.
> 
> - In the case of a MAP_SHARED page, if the content hasn't been sync'ed
> with the file backend, we also loose the modified data, and the kernel
> can also raise SIGBUS.
>     Remapping the area recreates a page cache from the "on disk" file
> content, clearing the error.

In a mmap(MAP_SHARED, fd) region that will also require fallocate IIUC.

> 
> In both cases, the kernel indicates messages like:
> [41589.578750] Injecting memory failure for pfn 0x122105 at process
> virtual address 0x7f13bad55000
> [41589.582237] Memory failure: 0x122105: Sending SIGBUS to testdh:7343
> due to hardware memory corruption
> [41589.584907] Memory failure: 0x122105: recovery action for dirty LRU
> page: Recovered
 > >
> Now in the case of hugetlbfs pages:
> This case behaves the same way as the standard page size when using
> MAP_PRIVATE: mmap of the underlying file is able to sweep away the
> poisoned page.
> But the MAP_SHARED case is different: mmap() doesn't clear anything.
> fallocate() must be used.

Yes, I recall that is what I initially said. The behavior with 
MAP_SHARED should be consistent between hugetlb and !hugetlb.


> 
> 
> In both cases, the kernel indicates messages like:
> [89141.724295] Injecting memory failure for pfn 0x117800 at process
> virtual address 0x7fd148800000
> [89141.727103] Memory failure: 0x117800: Sending SIGBUS to testdh:9480
> due to hardware memory corruption
> [89141.729829] Memory failure: 0x117800: recovery action for huge page:
> Recovered
> 
> Conclusion:
> We can't count on the mmap() method only for the hugetlbfs case with
> MAP_SHARED.
> 
> So According to these tests results, we should change the part of the

> qemu_ram_remap() function (in the 2nd patch) to something like:
> 
> +                if (ram_block_discard_range(block, offset +
> block->fd_offset,
> +                                            length) != 0) {
> +                    /*
> +                     * Fold back to using mmap(), but it cannot repair a
> +                     * shared hugetlbfs region. In this case we fail.
> +                     */


But why do we special-case hugetlb here? How would mmap(MAP_FIXED) help 
to discard dirty pagecache data in a mmap(MAD_SHARED, fd) mapping?

-- 
Cheers,

David / dhildenb


