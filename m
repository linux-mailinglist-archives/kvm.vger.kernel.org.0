Return-Path: <kvm+bounces-51266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBBDAF0DA5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DDD94E4336
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE70F233D8E;
	Wed,  2 Jul 2025 08:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i//tWxRq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F61198E81
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751444136; cv=none; b=j2KgSzqRN3sq92WA70TQ+G9Nq1J2GHISLIe9jlTyVBrgGk5ncm01vm4wZHwy7d0QD/gJI2dLpL0+Fg72OH611rBU1RsrWZ1V0CH1l/3F1Vwa3U7cMWrkos3/UkV/a8ttvT6xrlzlBZDc4sYTvAXTDUDrmVb/F5O2NidwYkkn6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751444136; c=relaxed/simple;
	bh=Ka2UjaphCjNa6EguV7MypeLZuUU8lQh4vdiRaAq0nd8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYs5YIY+K9Umcxu1tpOZ9BwexOYISeDHjTOq3MndDrPHHqyvo0e6AlOgrjA9nr6uq3SNJyll1zlLH627nG/pHbuA4AaphkDMQqK3hHgZgSUQuqnwtRuABPlWZzIatNNMif8q+F4nYrUSHAvm6iduqvquMetCcfF9j6skrZNc8Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i//tWxRq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751444134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S/PeRiI9W057w864aBxmq+mzL1W5cMHbc8FsLBmU7cs=;
	b=i//tWxRqPDMETu0kKWFPWjZpnybmScltIz2Kx5Up5qEMY1FuIXOEKJffO3bZQX3erRSoYN
	+Xcrp84hSYrLCrbWR1gpjI6CATEy8q5oz4P9TC9NSYfcZrUwMd/1pl4AZ0M1NzGDb5GVxH
	+JaNnYf40HGqL9Yna2wBapl8vUBOeIY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-vf2l6cN4NxKRjIQRjtdDjA-1; Wed, 02 Jul 2025 04:15:33 -0400
X-MC-Unique: vf2l6cN4NxKRjIQRjtdDjA-1
X-Mimecast-MFC-AGG-ID: vf2l6cN4NxKRjIQRjtdDjA_1751444132
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d290d542so41690035e9.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 01:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751444132; x=1752048932;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S/PeRiI9W057w864aBxmq+mzL1W5cMHbc8FsLBmU7cs=;
        b=KKddW0FxHbMJI/RrFu3zATW8BPe/cZcg62MWpPuxni30wW/5dCPQKjNDzyjqtgQfiQ
         vSf3c8iqmzZHidoHLomele4s8mJF0u5DRV7uJ3Yt9dFZpgB5M7i6fjQl/wIpROUo/wVX
         USOAjxfbTd3UrzJLRm/jyJN9Cws5zwYE6yG3Syw+Zfr+XD/QuYBHnadqYrQAwhw4IE91
         A6NwT0TJtt2G2rqmZC0xhDLdhhRsVeQ5P6qOCeTqdLbIFiRPUAu5vYXpnyt9I9Xi4POJ
         9gFtVS0WZzR5wLJcBfX4Pc/Q2OQVJKUEUh495QRwFkul56kLeCxw+sTCkAmMgUAlFBgI
         vL3w==
X-Gm-Message-State: AOJu0Ywu89Q5B7CvpUN132ve08L48agvDvv3Z1X0h1tt0XhsQdlnHVOc
	Sd6meU+EjU0OHYrGCm4vtsX1BpfyHJX/ACL058RcmXR+BC3hGv6tyti7JqFIXACLTwN17nv4yu9
	V5AQRsOonPp7d5EoGz836K5n0c5/9G2VFBHyVsovus6z9zIL7Jnd/LA==
X-Gm-Gg: ASbGncve/6jMKEjuc8t7lG9azKE5sB1AeoRYMHMndslKo2qCnjCKMrl+vnnshhc07DV
	XPISLoRVPI7DxlzJ0CtEGXoGTynusyHpy6HsaaNEH7EuiNMX2/tS0GUPHfQIf3YcGQB57yeVQKg
	hWEIOyZVH96hnOoBsbqeD16cxzPMZwuh4r8MVfmJTN1xFnRMn59wndvgqnLLtNfvlWOyBxG9DZC
	aoTVMrjZ+4qqdyCuim6MSA2J00EfKY6qsUJ/GoWXZ/QJqU5uZ7VJP9nLx6viTdyAHi3fDd4GouN
	dgZKSBmwRP1d5rAYP62GeLK0yfen94LiiYOr5YRvM/J2Fz1Tl4q3/NM=
X-Received: by 2002:a05:600c:628c:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-454a370a8b7mr21587275e9.16.1751444131549;
        Wed, 02 Jul 2025 01:15:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEjeoKb0+czmHoAzmLIFMrNEO4FKYLUVYmqyrAcXt4obyK043c7z5NOyTl9xiVAExon27uSQ==
X-Received: by 2002:a05:600c:628c:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-454a370a8b7mr21586865e9.16.1751444131044;
        Wed, 02 Jul 2025 01:15:31 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a390c88sm200260175e9.8.2025.07.02.01.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 01:15:30 -0700 (PDT)
Message-ID: <6508ccf7-5ce0-4274-9afb-a41bf192d81b@redhat.com>
Date: Wed, 2 Jul 2025 10:15:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote() for large folio
To: lizhe.67@bytedance.com, alex.williamson@redhat.com, jgg@ziepe.ca,
 peterx@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250630072518.31846-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250630072518.31846-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.06.25 09:25, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patchset is an consolidation of the two previous patchsets[1][2].
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> The function vfio_unpin_pages_remote() has a similar issue, where executing
> put_pfn() for each pfn brings considerable consumption.
> 
> This patchset optimizes the performance of the relevant functions by
> batching the less efficient operations mentioned before.
> 
> The first patch optimizes the performance of the function
> vfio_pin_pages_remote(), while the remaining patches optimize the
> performance of the function vfio_unpin_pages_remote().
> 
> The performance test results, based on v6.16-rc4, for completing the 16G
> VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
> modifications[4], are as follows.
> 
> Base(6.16-rc4):
> ./vfio-pci-mem-dma-map 0000:03:00.0 16
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.047 s (340.2 GB/s)
> VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.280 s (57.2 GB/s)
> VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.052 s (310.5 GB/s)
> VFIO UNMAP DMA in 0.136 s (117.3 GB/s)
> 
> With this patchset:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.027 s (596.4 GB/s)
> VFIO UNMAP DMA in 0.045 s (357.6 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.288 s (55.5 GB/s)
> VFIO UNMAP DMA in 0.288 s (55.6 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.031 s (508.3 GB/s)
> VFIO UNMAP DMA in 0.045 s (352.9 GB/s)
> 
> For large folio, we achieve an over 40% performance improvement for VFIO
> MAP DMA and an over 66% performance improvement for VFIO DMA UNMAP. For
> small folios, the performance test results show little difference compared
> with the performance before optimization.

Jason mentioned in reply to the other series that, ideally, vfio 
shouldn't be messing with folios at all.

While we now do that on the unpin side, we still do it at the pin side.

Which makes me wonder if we can avoid folios in patch #1 in 
contig_pages(), and simply collect pages that correspond to consecutive 
PFNs.

What was the reason again, that contig_pages() would not exceed a single 
folio?

-- 
Cheers,

David / dhildenb


