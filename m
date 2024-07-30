Return-Path: <kvm+bounces-22658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CDE940EC9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 261EF1C2263B
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC0C197A66;
	Tue, 30 Jul 2024 10:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JtUTqNJk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C77187878
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 10:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722334670; cv=none; b=N9odnML+BhGrKKeb8W1gZNKqIyIzJlAw+KJlD8nr2zpcG4ONlybfZX3ojmTGfMBHGrza9ptk+rZXiqjawnWKHy9HrRqIGlAtP1jyO/DYhiqdBwBzvBwd4s5XHigpjhU2x8wTmFlLwswsJv2nKonv5Ddtiev8+7aG37sT6wWnozE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722334670; c=relaxed/simple;
	bh=iNcv7NMi5eQwkUBbwceXg1bU0C6jvh9VNi8yqX7p7Ws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfZVj2boMAN2V53V/YCo2RDan6//tGxMMT0wK73gg1IUDw3dNrQh2SrzHEF1E438Rns3ctQ2Rn9rVg/cuKJsyUU7lX7wXrlZGUATBgKD4Tb/C2BRw0dbDyT8RGcL3+/wCjs13nPnQM1aTIq6DeKubqCJIwGRCn7WMSAgck8ehX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JtUTqNJk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722334667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zHRUb9ZKLORwY2zU7h4UGQhjsrDz/4w8N8RZFuBzYHM=;
	b=JtUTqNJkvp+eAEMI4GgwXh26EMpH95IB3kz7NaJyalIqV5BAV1dyx/qxfE2TEuP5qeEfoQ
	9cc0eUxt1nbOCbfCwuzjzQLgR6vvmXsU6V2XIPpBguOkZxxgCcDYGQvt6/3D8dCK3rDMFn
	nAWlFrCRW638Q5ude3Fy70FsOEdOXno=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-uQzzyjnMOYq5qYqjlb_Tww-1; Tue, 30 Jul 2024 06:17:46 -0400
X-MC-Unique: uQzzyjnMOYq5qYqjlb_Tww-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4281310bf7aso26447715e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 03:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722334665; x=1722939465;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zHRUb9ZKLORwY2zU7h4UGQhjsrDz/4w8N8RZFuBzYHM=;
        b=GcUiIGhpw1MNFuOq50wcLomSjIxxSMKY7bjPIYMqZMpNyX28cL+98ZTcIJilflD/EC
         K49UhFbdLF02tJtTXTg1c4HSllLRcBtRgvfeNYTYeMPmQhfuMBa3m5ZSPzdM7aXKNDXm
         mhm5ZFIL5CpDAjyasy28oTDqxr6LcZPkdfPbBJFU/TuEjniwrVrbGMeB9lGOyK/V4Hf1
         lmZ3fwnUfF6iwj0YhvwPQrvj/BzLrIXuVgqJ58hWOeeVJAd6ln11zMFENLkugDucgSbU
         OtcFowfv4Nzsqv7BCRwwtBDa5nI7KkfaKw9d409GPY5wXTmAlw/Ql9bbrAv/c9eXmBDQ
         4ohg==
X-Forwarded-Encrypted: i=1; AJvYcCUyTXvHFFSer1IxgVjsZN5Un4o/xLSJL4KQm/ieYVTvJyWwsBL3m/7Kf7O/PbzzHl+zvaFlOZVZk9Etlj0TfOC5gACW
X-Gm-Message-State: AOJu0YwkuDbDUGcR0QyNju34n3aNjj4L88y0ws37LkGJ/ntFQZVlPPJl
	KG1JS2ZtpfZBv8oQfALH7SW5XWZfup4K+Gk93i4YkWnVJWfm7DY5b6i8NFcRnxHLjPNfWvXDp2Q
	cSqaauKWtQ/rV4nL2GIyCkUMRFu4I0q4iviRWqMAJKoA0pWjyvQ==
X-Received: by 2002:a05:600c:1d1f:b0:424:ad14:6b79 with SMTP id 5b1f17b1804b1-42811d6dbfbmr70600755e9.8.1722334665200;
        Tue, 30 Jul 2024 03:17:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaV3qdlWbx8GtSBR66ch3gw4ikSw7LdpBZJNqVhSBuZwL0kQOQs9tiBzue/s+Uc3umEEsqRQ==
X-Received: by 2002:a05:600c:1d1f:b0:424:ad14:6b79 with SMTP id 5b1f17b1804b1-42811d6dbfbmr70600525e9.8.1722334664689;
        Tue, 30 Jul 2024 03:17:44 -0700 (PDT)
Received: from [192.168.3.141] (p4ff233ea.dip0.t-ipconnect.de. [79.242.51.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4280d37bb88sm152794745e9.38.2024.07.30.03.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 03:17:44 -0700 (PDT)
Message-ID: <1195d9ce-3f16-4b11-b6d2-88f593a25e0d@redhat.com>
Date: Tue, 30 Jul 2024 12:17:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] Unmapping guest_memfd from Direct Map
To: Patrick Roy <roypat@amazon.co.uk>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, seanjc@google.com,
 pbonzini@redhat.com, akpm@linux-foundation.org, dwmw@amazon.co.uk,
 rppt@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 willy@infradead.org, graf@amazon.com, derekmn@amazon.com,
 kalyazin@amazon.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dmatlack@google.com, tabba@google.com,
 chao.p.peng@linux.intel.com, xmarcalx@amazon.co.uk
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <e12b91ef-ca0c-4b77-840b-dcfb2c76a984@kernel.org>
 <7e175521-38bb-49f0-b1fb-8820f8708c9c@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <7e175521-38bb-49f0-b1fb-8820f8708c9c@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.07.24 08:55, Patrick Roy wrote:
> 
> 
> On Mon, 2024-07-22 at 13:28 +0100, "Vlastimil Babka (SUSE)" wrote:
>>> === Implementation ===
>>>
>>> This patch series introduces a new flag to the `KVM_CREATE_GUEST_MEMFD`
>>> to remove its pages from the direct map when they are allocated. When
>>> trying to run a guest from such a VM, we now face the problem that
>>> without either userspace or kernelspace mappings of guest_memfd, KVM
>>> cannot access guest memory to, for example, do MMIO emulation of access
>>> memory used to guest/host communication. We have multiple options for
>>> solving this when running non-CoCo VMs: (1) implement a TDX-light
>>> solution, where the guest shares memory that KVM needs to access, and
>>> relies on paravirtual solutions where this is not possible (e.g. MMIO),
>>> (2) have KVM use userspace mappings of guest_memfd (e.g. a
>>> memfd_secret-style solution), or (3) dynamically reinsert pages into the
>>> direct map whenever KVM wants to access them.
>>>
>>> This RFC goes for option (3). Option (1) is a lot of overhead for very
>>> little gain, since we are not actually constrained by a physical
>>> inability to access guest memory (e.g. we are not in a TDX context where
>>> accesses to guest memory cause a #MC). Option (2) has previously been
>>> rejected [1].
>>
>> Do the pages have to have the same address when they are temporarily mapped?
>> Wouldn't it be easier to do something similar to kmap_local_page() used for
>> HIMEM? I.e. you get a temporary kernel mapping to do what's needed, but it
>> doesn't have to alter the shared directmap.
>>
>> Maybe that was already discussed somewhere as unsuitable but didn't spot it
>> here.
> 
> For what I had prototyped here, there's no requirement to have the pages
> mapped at the same address (I remember briefly looking at memremap to
> achieve the temporary mappings, but since that doesnt work for normal
> memory, I gave up on that path). However, I think guest_memfd is moving
> into a direction where ranges marked as "in-place shared" (e.g. those
> that are temporarily reinserted into the direct map in this RFC)  should
> be able to be GUP'd [1]. I think for that the direct map entries would
> need to be present, right?

Yes, we'd allow GUP. Of course, one could think of a similar extension 
like secretmem that would allow shared memory to get mapped into user 
page tables but would disallow any GUP on (shared) guest_memfd memory.

-- 
Cheers,

David / dhildenb


