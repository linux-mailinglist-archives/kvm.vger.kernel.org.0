Return-Path: <kvm+bounces-46676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E12C4AB836B
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE7F93B07C9
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A042297A7F;
	Thu, 15 May 2025 09:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYABw1fO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA74297A58
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 09:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747303095; cv=none; b=mWSyxO0+H515UQAO6sg0sMJ4dABP14vTGkdJ6IYGn3HW43AdiKkybqf4MGxlzcn2CoELp/3bx0CbcP/K11Ub6iwKm6Y37siPF3aHqhburrQ21XW5X/aG+IIOk1odS8LLVhbuuN5UcO3oVnvswOA3pBXwWsmxJUPfSiE9YZ3hAGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747303095; c=relaxed/simple;
	bh=WMbyjKOYZKjUsunAus/iE7CaOUThNQmodpnmYOlPdsc=;
	h=Message-ID:Date:MIME-Version:From:Cc:Subject:To:Content-Type; b=mfW4yQLaofybOJAyLtNPxiaZpY61L/D5c13366i5keNiBzfD8je3u1l1HSBYhQ/WYoycHhUANYrZCTDI/o4skbxelQRyWK/unHfjTJmdTlyztNHw/2XW4xGxvscMUG9Xhg6bbFB57ksvjwn6S/kyGL1Qlpmz+SBMUrR9e5taMWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bYABw1fO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747303092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=pTGqGXVw8z80rGktDR9uqeOqFeSCceq/wKqHsvtbKIw=;
	b=bYABw1fOqOOfKCseGnhnwl/NHxzH8akmFIkMLPnCdNBB1E2s8wuaxJJFQ7Q0HYGJtwIFOT
	dmMSYgyuoy1EQiS7gZWHy0fL/cuzCcdAcQDwcQQHwPeFqQ3eLSVreCj+/Cpo11bpOucVW4
	kL+026zhKc7H7L+gkIaeDyeOWjp88lM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-Yjt8ilSZPb6n6M4REZ5KxQ-1; Thu, 15 May 2025 05:58:11 -0400
X-MC-Unique: Yjt8ilSZPb6n6M4REZ5KxQ-1
X-Mimecast-MFC-AGG-ID: Yjt8ilSZPb6n6M4REZ5KxQ_1747303090
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d4d15058dso6633525e9.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 02:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747303090; x=1747907890;
        h=content-transfer-encoding:to:subject:cc:organization:autocrypt:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pTGqGXVw8z80rGktDR9uqeOqFeSCceq/wKqHsvtbKIw=;
        b=Dl3sf1pGz3GifD/w9kUcXulH1Obzeh8q4QY0AVPBflfc2VAtTYWTAqHHH2d3AcEAca
         JsaqAPU03YfO6EdiE0zewHLEHjZLVg1A+WkHUfGUA0G/+42NthUYgfUbmzyqRS40vdFd
         U0MWivgJYhCBAq3lkl+bn78zr+UwJ/SWLpf4kOAn2rOL7hPe9rFN/geW8JnTXFneFhIw
         oS9O5PgiN/El8wCD2Cw6bvy+4H9t8RJfes58K/dcfdLgUEmZIU4IkccFJNPVV/T9CHq3
         Rp2q5BFK9vLZOOko+9kjWaGfx3NDQQGU/ZTCx/pyrkPmtgMpzf1qmQIhRlYQ8Oig29w9
         iQMA==
X-Forwarded-Encrypted: i=1; AJvYcCUS6i03Kp58O8q4M9f7llQ5oDlllVqfJeUaftvja5IwI7DvfsWPq9fwCg/EipyVvEAu/U0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMU+XnzPYrwkHd4FnA3m5ape8NJQe8Q9brDZOXOowLpUl31dJz
	ukgfcomh71OjddoWI44nJC2g6GQHP83H9xwHTAAACGWjaXFePW6D3FrIg18nSyrI8/VJJrdqrxf
	I7tphOSDKaZcBYTlEIa0gqu5I9ptpbyhSsOg2tDzYPmtmZ15T1w==
X-Gm-Gg: ASbGncssv2HiDVuGlfnF5LzzHQwkPxED5VUvZhX5yEtuQmmHVbmH4SmapsWH/Xo83SC
	FzcH4pU00toxMgF8RccYZUKQG4SBiO0JJFu4DjLJanyS2eoSxgIIC/1AWDzrGx6pUW8tNCp0TKp
	8jqGmSuGh7SXbGeq/rYIO5kivtrp5DWv/K7lzkR5qTppZoRu7jfE70Rbf4+bhi0PiGH8eju6Jgf
	laDLB2VLwGndtv0BvqwkPyIUr35wBkynR42VoYunmCjGP1xlwt2LJf726drFGzLzwp8UIFOmfBO
	oY24X5n5UyBd4vuD+NwwXcTPeV44sfKxZhwfXI6u4TgVOP5NEoT4VpH4vHUxWGghIJEzWEdFTKF
	3O3nZQYzLGgKIjxgL79iQQiL+TrbffaPeAnAV4Ro=
X-Received: by 2002:a05:600c:3b85:b0:442:f12f:bd9f with SMTP id 5b1f17b1804b1-442f2178431mr53187715e9.27.1747303089967;
        Thu, 15 May 2025 02:58:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/+zH4hXXxDYKXmH9e7v7sDqIDgpWi4J6S+8+V8DNyJGvt2Kf7Y50xBY8atc/g20ZfKeT/hw==
X-Received: by 2002:a05:600c:3b85:b0:442:f12f:bd9f with SMTP id 5b1f17b1804b1-442f2178431mr53187415e9.27.1747303089470;
        Thu, 15 May 2025 02:58:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4a:8900:884a:b3af:e3c9:ec88? (p200300d82f4a8900884ab3afe3c9ec88.dip0.t-ipconnect.de. [2003:d8:2f4a:8900:884a:b3af:e3c9:ec88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f3951494sm66106625e9.22.2025.05.15.02.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 02:58:09 -0700 (PDT)
Message-ID: <c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com>
Date: Thu, 15 May 2025 11:58:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Cc: gshan@redhat.com, ackerleytng@google.com, kalyazin@amazon.com,
 pankaj.gupta@amd.com, papaluri@amd.com, peterx@redhat.com,
 seanjc@google.com, shivankg@amd.com, tabba@google.com,
 vannapurve@google.com, shan.gavin@gmail.com,
 aneeshkumar.kizhakeveetil@arm.com, ashish.kalra@amd.com,
 dan.j.williams@intel.com, ddutile@redhat.com, quic_eberman@quicinc.com,
 michael.roth@amd.com, roypat@amazon.co.uk, suzuki.poulose@arm.com,
 vbabka@suse.com, yuzhao@google.com, rppt@kernel.org, jgowans@amazon.com,
 Nikita Kalyazin <kalyazin@amazon.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: [Overview] guest_memfd extensions and dependencies 2025-05-15
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

as requested, a quick overview of guest_memfd extensions and their 
relationship/dependencies; this also highlights the order in which 
patches should likely go upstream (current state). Some things will 
likely change, especially the further we go down the dependency chain :)

TL;DR

A
|       +-- Expected dependency
|       |
|       v
+--B--E--F--G
|
+--C
|
+--D
|
+--H--I

As we post stuff that depends on something that is not upstream yet, we 
should (1) tag it as RFC and (2) provide a branch that contains all 
relevant patches.



(A) "Stage 1": Basic mmap support (Fuad) [1]

Allow guest_memfd to mmap'ed and contain "shared" memory. No in-place 
conversion support: either all-shared or all-private. Shared pages can 
be faulted in.


(B) "Stage 2": In-place conversion support (Fuad) [2]

Allow guest_memfd to contain a mixture of shared and private pages, and
converting between shared<->private in-place. Memory attributes 
(shared/private) are managed by guest_memfd instead of KVM.

Depends on (A).


(C) Direct-map removal support (Patrick) [3]

Allow for removal of the directmap of guest_memfd pages/folios.

Depends on (A)


(D) NUMA mempolicy support (Shivank) [4]

Configure the "shared mempolicy" similar to shmem using the VMA.

Depends on (A). But we'll have to be able to mmap any guest_memfd -- 
just all faults must fail for ones that don't support shared memory, so 
might require some tweaks on top of (A).


(E) 1G huge page support (via hugetlb) (Ackerley) [5]

Add support for huge pages obtained from hugetlb, splitting large folios 
to small folios whenever we convert to shared. Need to reassemble large 
folios before handing them back to hugetlb.

I *assume* that further changes are required to make Intel / AMD CoCo 
VMs make use of it -- essentially what (F) and (G) also deal with.

Depends on (B)


(F) AMD huge page support (via the buddy) (Michael) [6]

Add support for huge pages / large folios that we allocate from the 
buddy + preparedness tracking for AMD. In theory, we could add this 
support for "private only" memory, but likely we will just do it 
properly and base it on in-place conversion support.

So, expected to depend on (B), but likely depends to some degree on 
infrastructure being added in (E)


(G) Intel TDX huge page support (via the buddy) (Yan) [7]

Similar to (F) but for TDX.

Depends on (F).


(H) write() support (Nikita) [8]

Allow for using write() to more efficiently preallocate/populate memory 
for "all shared memory" VMs.

Depends on (A)


(I) UFFD-missing support (Nikita) [9]

Support userfaultfd-missing fault handling for guest_memfd.

Depends on (I), but likely could be based on (A) only.



I'm not listing the "factor out guest_memfd from KVM to mm/guestmem.c" / 
"guestmem library" / "guestmem shim" for now [10] as it will likely be 
covered by one of the other items as required.

Also, there is a lot of other planned work ("all shared" VMs can allow 
for not splitting large folios because there is no in-place conversion, 
guest_memfs, ... ).


[1] https://lkml.kernel.org/r/20250513163438.3942405-1-tabba@google.com
[2] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[3] https://lkml.kernel.org/r/20250221160728.1584559-1-roypat@amazon.co.uk
[4] 
https://lore.kernel.org/linux-mm/20250408112402.181574-1-shivankg@amd.com/
[5] 
https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/#u
[6] 
https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com/T/#u
[7] 
https://lore.kernel.org/all/20250424030033.32635-1-yan.y.zhao@intel.com/T/#u
[8] 
https://lore.kernel.org/kvm/20250303130838.28812-1-kalyazin@amazon.com/T/
[9] 
https://lore.kernel.org/all/20250303133011.44095-1-kalyazin@amazon.com/T/#u
[10] 
https://lore.kernel.org/all/20241113-guestmem-library-v3-0-71fdee85676b@quicinc.com/T/#u

-- 
Cheers,

David / dhildenb


