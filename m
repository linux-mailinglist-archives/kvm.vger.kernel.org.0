Return-Path: <kvm+bounces-49393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD46AD8446
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17DD93A2724
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411D32DECB2;
	Fri, 13 Jun 2025 07:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UckNfmUL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34B2C326C
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749800186; cv=none; b=T7zrBy/yds3OHmmk1BXJOwtLG77iv9jIHm/04gdMNU4mnJTDnoQyYb5cjvqY1ge+jL8lSUiOFsVb9o2OtPpcvENjy9fEMkqTVQhz8LPzAdi8CVCmOCpyNYuj7WYLZxp56l5/3F0iX5kUi660EG2mezaBpHhNnIF7hGm/mhzGeVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749800186; c=relaxed/simple;
	bh=MYkmShockohUTQhDi1qsEgwAUV9MPUwgnh3IAatCIgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mfesUxQ7Ys2Hb7mzm2WPs2DjU+iNHyLD8ooXynsmRTh2hi0XX3BTa70Bc87SBRbg0uQfxbNd1TycEQDBORfX0mcXCKkROtnL8kjLyE/Aqk16AqyuJGSBCOym0JdA5ATQxblCgNrfGVo5vU1XzEZ2IdonIbuT/WcgPc4/E+zgGoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UckNfmUL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749800183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g/KSy3wr0YzCsYvT1z88yXOYsPTy06KTgQEl479p0xk=;
	b=UckNfmULVW4NtsEPwZF9QPueoov+OJQ7SmpHk0ZWw18HI83IZESqou1BxamchZC+ywX2i9
	RAjGvQBor1sD03kcVpBZUZaXdcSj8oZBXmRW004xCv+RywAHIanEXxSpat7M+cnOx6Gx28
	i+YWFYkPw0EAurRu7gFMu4KfIoX0vAI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-hJmx2PiAMx6toNO08IAWNw-1; Fri, 13 Jun 2025 03:36:22 -0400
X-MC-Unique: hJmx2PiAMx6toNO08IAWNw-1
X-Mimecast-MFC-AGG-ID: hJmx2PiAMx6toNO08IAWNw_1749800181
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so806770f8f.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 00:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749800181; x=1750404981;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g/KSy3wr0YzCsYvT1z88yXOYsPTy06KTgQEl479p0xk=;
        b=G0BIqDfCZh4fcm6K1HUD7OGKSCnokJtuti9vk1bO38Cuc2jLe03VvPiGqp61cg265i
         Q6XjizDQXmErR1jtztJz8XxkKr/cwjW0+R51b1OvnGBi26FzKVtgCSD0BFetW4Z+rfv3
         4UDntw9nVZH8NNCauelOCur7AsCXY6OTCWDbdTrMhIYlXEwbPGCNbT3zfv5+T0mK/8CB
         jtL9ZyqyIup9Mz5iI6tNO4h18U8/WO3PZrudsj/Ctv4Sy/iYJxt/GGeKp5XidlpY2JeY
         ozP57GAgM/Ihho8OIRZKBzhFzgyiNaIkxjT0WEirg/J5HJ11ED007bO5dd05ekRLDYRz
         arow==
X-Forwarded-Encrypted: i=1; AJvYcCVRj1cqEAk7jWGO8iHozj5/PS9O4XtKYSLUMLowCMzV3hgaLzqgOzeBrIvS71tPTBVv1L0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmJXq+qxPbR/2WqKdQJlQ5qwMH0yhGv0+f8kFGD8Uoq0SIiFvw
	iXMaOlSoxIsi48Kw2THNNKdMbtxoReX2MaH6oLrnLxFJHeIUGCQW0Qnb5it+av5eFfY0wKclZBy
	AAxpO2WNwCYvG9ICnfNQlYSg7PZ8c4Ddx6rUsgDBwt24BwD32Kgo+5Q==
X-Gm-Gg: ASbGncswm1CSE5f2H1qCNomptBwxCJ689o0406IMR7PPu8Cy3pRDLJnAU4Ocj2/jJZr
	FxHVcGqBALGBXhUst1X/FyI4LG1fsL64o0t7FOtK3h2Ol5HWyXnjU6PYHhEl8NHChBScexQ/KdN
	vJUy5fA0cDdoMuGDgBm6re5JNm5d+vQZ+dXXUC1C2T+bwa5Urp7kUW9ljdofhPXtn8c4Tz50XZy
	KI52ovGQlDtCbjkA/DNn0aLEHUukV9fTZwY5GD5D4Bg3HvK27mdJXTZXb5kxazxjU5jX5CvYRmv
	Hm+6btTt9mhyAUaySxSebxzNKBp/6DL5dzJT92KJQ64cj0uFwdeypC7m/bjqjB7RNRdmDTSPSLS
	ngNk6BfBGhYinp73v2qlw4e9Ibnlr4mySbBRS266qeHFFv/jH+g==
X-Received: by 2002:a05:6000:200d:b0:3a4:dd02:f565 with SMTP id ffacd0b85a97d-3a5686e46dcmr1695328f8f.3.1749800180756;
        Fri, 13 Jun 2025 00:36:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3E5xAucf59QCGzaz7TSQ1Q2JsqiFiIEKcGbgyzY70RtwYOnTLFta6yG1DaZATOftTdpFeSQ==
X-Received: by 2002:a05:6000:200d:b0:3a4:dd02:f565 with SMTP id ffacd0b85a97d-3a5686e46dcmr1695304f8f.3.1749800180358;
        Fri, 13 Jun 2025 00:36:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4? (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b18f96sm1535136f8f.66.2025.06.13.00.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 00:36:19 -0700 (PDT)
Message-ID: <12f88382-e1eb-4e40-9e47-dafb79a7f102@redhat.com>
Date: Fri, 13 Jun 2025 09:36:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 0/5] KVM: guest_memfd: Support in-place conversion
 for CoCo VMs
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tabba@google.com, vannapurve@google.com,
 ackerleytng@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com,
 pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org,
 pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com,
 aik@amd.com
References: <20250613005400.3694904-1-michael.roth@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250613005400.3694904-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.25 02:53, Michael Roth wrote:
> This patchset is also available at:
> 
>    https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1
> 
> and is based on top of the following patches plucked from Ackerley's
> HugeTLBFS series[1], which add support for tracking/converting guest_memfd
> pages between private/shared states so the same physical pages can be used
> to handle both private/shared accesses by the guest or by userspace:
> 
>    KVM: selftests: Update script to map shared memory from guest_memfd
>    KVM: selftests: Update private_mem_conversions_test to mmap guest_memfd
>    KVM: selftests: Add script to exercise private_mem_conversions_test
>    KVM: selftests: Test conversion flows for guest_memfd
>    KVM: selftests: Allow cleanup of ucall_pool from host
>    KVM: selftests: Refactor vm_mem_add to be more flexible
>    KVM: selftests: Test faulting with respect to GUEST_MEMFD_FLAG_INIT_PRIVATE
>    KVM: selftests: Test flag validity after guest_memfd supports conversions
>    KVM: guest_memfd: Add CAP KVM_CAP_GMEM_CONVERSION
>    KVM: Query guest_memfd for private/shared status
>    KVM: guest_memfd: Skip LRU for guest_memfd folios
>    KVM: guest_memfd: Introduce KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
>    KVM: selftests: Update guest_memfd_test for INIT_PRIVATE flag
>    KVM: guest_memfd: Introduce and use shareability to guard faulting
>    KVM: guest_memfd: Make guest mem use guest mem inodes instead of anonymous inodes
>    fs: Refactor to provide function that allocates a secure anonymous inode
> 
>    "[RFC PATCH v2 00/51] 1G page support for guest_memfd"
>    https://lore.kernel.org/lkml/cover.1747264138.git.ackerleytng@google.com/
> 
> which is in turn based on the following series[2] from Fuad which implements
> the initial support for guest_memfd to manage shared memory and allow it to
> be mmap()'d into userspace:
> 
>    "[PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the host for software protected VMs"
>    https://lore.kernel.org/kvm/20250611133330.1514028-1-tabba@google.com/
> 
> (One of the main goals of posting this series in it's current form is to
> identify the common set of dependencies to enable in-place conversion
> support for SEV-SNP, TDX, and pKVM, which have been coined "stage 2"
> according to upstreaming plans discussed during guest_memfd bi-weekly calls
> and summarized by David here[3] (Fuad's series[2] being "stage 1"),
> so please feel free to chime in here if there's any feedback on whether
> something like the above set of dependencies is a reasonable starting point
> for "stage 2" and how best to handle setting up a common tree to track this
> dependency.)

If nobody else volunteers, I can soon start maintaining a guest_memfd 
preview tree. I suspect a good starting point would be once stage-2 is 
posted separately.

-- 
Cheers,

David / dhildenb


