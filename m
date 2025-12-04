Return-Path: <kvm+bounces-65303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 461AECA4EF0
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 19:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05B643069E2E
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 18:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A8F3451CB;
	Thu,  4 Dec 2025 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQQxvYEX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VViG+k1N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AE1345732
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764872222; cv=none; b=i2jDhTujohULZUiq5NjnseeOlxSAMht8FWZAs+EkBCJynaq2wZb8t/ymIXVR6O5YSNBZromjm0kGsjmVqZMeieq7N+uhybuMp8cN4404VWJM3e3ObQeDdzQyAynHYFA1kw5J8xcaAzCvzxPCg/lzG0Jz0/ireKECIsLD51tyBFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764872222; c=relaxed/simple;
	bh=+Cf+AdkktDXW6fhzmlgmL/2n672nbfxqLsKE7gA5OUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dwgcfcTkMeBG/pr+Us4+GM605455eS3cDwONDHIH53f7tm6BlILYrKlm/0+olvbQ8CXqePpatYpRRvfFEBWOrMdUbcAIxH3h93CsfDbk3jsqkBX3N9opWb3qDG6wb2hwAHH1IiHenrwSdnZJie9AyB5BD3pH9E5obv9cKauHt7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQQxvYEX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VViG+k1N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764872218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eirtc4OeV7lF+HDc34TcziSlprrtqsjl7v9RehYvcZU=;
	b=hQQxvYEXzA6mUrhWRNOnMhk/gc1gNE5/PQ4Ssbe10VRcuHiVDBadvF7ZFktKN03y9OkmtP
	hRpruSvlDNG6hmMgPkK8z3wp7V8n0EF3yOuD2s9ZFFtT4qhi41wElKNOGcLgVvE3NrNYte
	93wIXnJYZwskF/0iwk+jGUoRjbRsmqk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-WQwQlfZQMYyBYVmY4KY_hw-1; Thu, 04 Dec 2025 13:16:57 -0500
X-MC-Unique: WQwQlfZQMYyBYVmY4KY_hw-1
X-Mimecast-MFC-AGG-ID: WQwQlfZQMYyBYVmY4KY_hw_1764872216
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42e2e3c2cccso823008f8f.3
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 10:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764872216; x=1765477016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eirtc4OeV7lF+HDc34TcziSlprrtqsjl7v9RehYvcZU=;
        b=VViG+k1NwORalTviBdoccCXllklpjvueayOquPztqqYe5DsnfwDSC3X2YAuR4h6rDQ
         Q2mUBSKbBlsArCCWkoM5+kgzU5Gxd+ItPDjXeG5H9vBO5IS3hltW//YM8N8ST4sfEBok
         MwZhF9LKbtF2aQxPU9d/kTJAkmbmCrBJC0RMD0pOfQTQyU+qrAuHiERFNzumXy4FAZjC
         13tgjAnWEBe43lAFGS8/GwfNkqR7/2R0nUy2kdISc0RE5PWNYsQzk4XdlFj1JjrjeZhN
         zmlRWorQzEQg4MKIcpOAbliBdGaIbQN0btN1e8Rc9cGKQY9jXGOdjLo8KUy95gyhtrKY
         uuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764872216; x=1765477016;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eirtc4OeV7lF+HDc34TcziSlprrtqsjl7v9RehYvcZU=;
        b=FAhkvUt0/x9+f9vpblt+qJvx3b1YojcKOKhd3LpBWdRTS5VzWoVAm3TXI9QKf1LKmJ
         Dh+3vraR1+NFgu9jqmP18jWC98n+E6GxhGzW4qaLSQKWpyi7IFMiDLwv8Tzb0nrzSCBv
         1qHMqaWVV6Z7IXiK75eYWPtp56kTA66SEcSfdFiAoATXFhclbo4aZNTgqbNKB1Jfvtct
         exZtNr0xxkcEHk0cJqLy9aQxYiE7vOiz6lxW0saK3+LXkdFsGAL2N82AQmo+w5YyCd14
         BVvIR9Dp891kR1Uv5osHRwp+1gw5xHe6TNgA97YsezeqBJ/CWo8bSc2mvabVlwFN6uv2
         tJHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfRVdP6S22Mh8QZYZ1KZrYxwo+beKOs+9lrYPP0WThJVHadsxPT8P/DcvMv69IDNRhsGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzopZztDcizzDYYa2o2nwCUby9AGLgCFHYdAXRH0vDJZ4jnrXz
	McZ3spqDqiu4miwfUoirIGygx4tJykNrZRhF6Hj83/mEXThlIsSf8rYstfOl+lDXxjCQHo2WPhb
	YY9MuwPIa+Isf7rX8iIGyegzN3j9w6y09RqQ+ww0UvftYq4rRL1FoEA==
X-Gm-Gg: ASbGncvnlGWQU7NCzKDT5uQQb3+v6Qprt2EqCPL9lnOTnDuSwVedneYLMIy8DNryT0N
	oMlKor6HrdalQJuHAqt722VTln/YnwjrlQrBdYvlMo8oSvOVOqfsRZcg8w3vR4IDGzIMhlMpoC7
	BMZa3i8ywW2cfw1hPD86ZhTivAzyBzuKVyhnsLu8XNtQm/frUXrA1XgccY71x47YLHLElWbxq4X
	UVgTAa735r/9Yr8Hmw5CTp2RV9Ih3ejK/+REDU6WkVRYq14k9aNHonCe7h0A+T/U8oR8WvaHXcC
	nabM7ul1uvfW6AoCeKbtZUcwtQohnGtq8uMmh5bOBGV6wpjb4NVxmSsGUie1lfjgHIOBnVH8m50
	pG5FUWcV2e0B+JverO5ULy6299RAEz5bjSdHeXd9kkJhks5j1
X-Received: by 2002:a05:6000:40cb:b0:429:ca7f:8d70 with SMTP id ffacd0b85a97d-42f731728cbmr7553708f8f.15.1764872216025;
        Thu, 04 Dec 2025 10:16:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHsNa2uHt8wNcyB2Wb02dOnnMd8Uiu88xRl/KelRrPJiBftSyGR+BDd3v8V9I+wEeIzVFlXA==
X-Received: by 2002:a05:6000:40cb:b0:429:ca7f:8d70 with SMTP id ffacd0b85a97d-42f731728cbmr7553657f8f.15.1764872215452;
        Thu, 04 Dec 2025 10:16:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe9032sm4052320f8f.1.2025.12.04.10.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 10:16:54 -0800 (PST)
Message-ID: <e2033095-9bf1-4d9c-9a5b-01148eaffc30@redhat.com>
Date: Thu, 4 Dec 2025 19:16:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] mm/vfio: huge pfnmaps with !MAP_FIXED mappings
To: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
 Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
 David Hildenbrand <david@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Zhi Wang <zhiw@nvidia.com>, David Laight <david.laight.linux@gmail.com>,
 Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Andrew Morton <akpm@linux-foundation.org>
References: <20251204151003.171039-1-peterx@redhat.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 16:09, Peter Xu wrote:
> This series is based on v6.18.  It allows mmap(!MAP_FIXED) to work with
> huge pfnmaps with best effort.  Meanwhile, it enables it for vfio-pci as
> the first user.
> 
> v1: https://lore.kernel.org/r/20250613134111.469884-1-peterx@redhat.com
> 
> A changelog may not apply because all the patches were rewrote based on a
> new interface this v2 introduced.  Hence omitted.
> 
> In this version, a new file operation, get_mapping_order(), is introduced
> (based on discussion with Jason on v1) to minimize the code needed for
> drivers to implement this.  It also helps avoid exporting any mm functions.
> One can refer to the discussion in v1 for more information.
> 
> Currently, get_mapping_order() API is define as:
> 
>    int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);
> 
> The first argument is the file pointer, the 2nd+3rd are the pgoff+len
> specified from a mmap() request.  The driver can use this interface to
> opt-in providing mapping order hints to core mm on VA allocations for the
> range of the file specified.  I kept the interface as simple for now, so
> that core mm will always do the alignment with pgoff assuming that would
> always work.  The driver can only report the order from pgoff+len, which
> will be used to do the alignment.
> 
> Before this series, an userapp in most cases need to be modified to benefit
> from huge mappings to provide huge size aligned VA using MAP_FIXED.  After
> this series, the userapp can benefit from huge pfnmap automatically after
> the kernel upgrades, with no userspace modifications.
> 
> It's still best-effort, because the auto-alignment will require a larger VA
> range to be allocated via the per-arch allocator, hence if the huge-mapping
> aligned VA cannot be allocated then it'll still fallback to small mappings
> like before.  However that's from theory POV: in reality I don't yet know
> when it'll fail especially when on a 64bits system.
> 
> So far, only vfio-pci is supported.  But the logic should be applicable to
> all the drivers that support or will support huge pfnmaps.  I've copied
> some more people in this version too from hardware perspective.
> 
> For testings:
> 
> - checkpatch.pl
> - cross build harness
> - unit test that I got from Alex [1], checking mmap() alignments on a QEMU
>    instance with an 128MB bar.
> 
> Checking the alignments look all sane with mmap(!MAP_FIXED), and huge
> mappings properly installed.  I didn't observe anything wrong.
> 
> I currently lack larger bars to test PUD sizes.  Please kindly report if
> one can run this with 1G+ bars and hit issues.

LGTM, with a 32G BAR :

Using device 0000:02:00.0 in IOMMU group 27
Device 0000:02:00.0 supports 9 regions, 5 irqs
[BAR0]: size 0x1000000, order 24, offset 0x0, flags 0xf
Testing BAR0, require at least 21 bit alignment
[PASS] Minimum alignment 21
Testing random offset
[PASS] Random offset
Testing random size
[PASS] Random size
[BAR1]: size 0x800000000, order 35, offset 0x10000000000, flags 0x7
Testing BAR1, require at least 30 bit alignment
[PASS] Minimum alignment 31
Testing random offset
[PASS] Random offset
Testing random size
[PASS] Random size
[BAR3]: size 0x2000000, order 25, offset 0x30000000000, flags 0x7
Testing BAR3, require at least 21 bit alignment
[PASS] Minimum alignment 21
Testing random offset
[PASS] Random offset
Testing random size
[PASS] Random size


C.

> 
> Alex Mastro: thanks for the testing offered in v1, but since this series
> was rewritten, a re-test will be needed.  I hence didn't collect the T-b.
> 
> Comments welcomed, thanks.
> 
> [1] https://github.com/awilliam/tests/blob/vfio-pci-device-map-alignment/vfio-pci-device-map-alignment.c
> 
> Peter Xu (4):
>    mm/thp: Allow thp_get_unmapped_area_vmflags() to take alignment
>    mm: Add file_operations.get_mapping_order()
>    vfio: Introduce vfio_device_ops.get_mapping_order hook
>    vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
> 
>   Documentation/filesystems/vfs.rst |  4 +++
>   drivers/vfio/pci/vfio_pci.c       |  1 +
>   drivers/vfio/pci/vfio_pci_core.c  | 49 ++++++++++++++++++++++++++
>   drivers/vfio/vfio_main.c          | 14 ++++++++
>   include/linux/fs.h                |  1 +
>   include/linux/huge_mm.h           |  5 +--
>   include/linux/vfio.h              |  5 +++
>   include/linux/vfio_pci_core.h     |  2 ++
>   mm/huge_memory.c                  |  7 ++--
>   mm/mmap.c                         | 58 +++++++++++++++++++++++++++----
>   10 files changed, 135 insertions(+), 11 deletions(-)
> 


