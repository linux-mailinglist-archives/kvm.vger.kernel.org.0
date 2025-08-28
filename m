Return-Path: <kvm+bounces-56108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A54B39DC1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 14:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BF2F7C32BC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7421B30FF37;
	Thu, 28 Aug 2025 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aruokTaf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B1230FC33
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385419; cv=none; b=YFQ93EXUibyL5Z8UFV00Iu+Ok7Gz/zYOj3sFC0L69jL8rcoUBoNT4Ai8i4al4+WSn1ddpYFKRAUeEr/6MwQu/4NhqiuUMIzmyAUAyc3WnTfrCqKb8QHZUSfzm/ZNYrMpE+BniNYegrOuArnsyps/eyAN6UUFog4FL2wg/VKy1J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385419; c=relaxed/simple;
	bh=F9B87foFu5ArbaO6Wj5uzuuQ1mnMFqS0rUW4rnQy1/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t/JUu77PPLdUgEfT7uRDTjl77Q6HjV3aWT3QwFmGAja7Aj7kM8COa+dw1R6IVvKvbyuU3bMLZgWhlq8UAE9V+QG/UVNsaYAxAW5tw1GIcY7DXHipso+XA/JEvJAw/uxXa6ongq8S8DdgokULJ0uFauawMS/ca82tgmhaj5NAyVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aruokTaf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756385416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
	b=aruokTafr2v2Fmm28ssyUu4JSW0VmA+uSAdALjQWsmiFZNWfVsD0x7qljaFpYUpDXS9aJ0
	LgBKdZ7+K13lQJq9xkbheGH5D7TMmyh5XqzOZ69s9bfKSI6wSsksfkFIIAJTbq4DOiM5OQ
	KGPuAU8pi1WitLjHlOH+jcK0xMFU0jo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-HNrxxn1RPPmCNRtwHGhXDg-1; Thu, 28 Aug 2025 08:50:15 -0400
X-MC-Unique: HNrxxn1RPPmCNRtwHGhXDg-1
X-Mimecast-MFC-AGG-ID: HNrxxn1RPPmCNRtwHGhXDg_1756385414
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ccfd9063a0so318120f8f.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 05:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756385414; x=1756990214;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
        b=KAxtwWcINccIwSp+GBr6GQviSv4xQgaMOw1ScN3tedZNN1Vol9drUTnHIDiRwiDZyB
         F3dpb1jdxSKj7lSMq6kTxLs59mpS3yOHm45a3qVkb2KVm09bQwxVcm6KTZEwgRTper6e
         P58YI4YP9p79HjEVqhbCQ6Rz30YGVsRwmU/ZdEqLHwORG0E550wXdjkOXSZGOmpDmAgm
         YRBeXq9d5RO6XF3LoOC8oR+FHGzCQ27AxD33ARhAzkVn06EGLg/OEeElFYbvnQ4EuZri
         X2PK6KFOU+QvuypKW2hCdzioF25ZmdRAtgk0n3C+FfaHgrU9wmFCuCdlDilTeMj9K5Vx
         SYQw==
X-Forwarded-Encrypted: i=1; AJvYcCUs7cbuXqdURliLUkynKU1+oAjlXmNO4bZYkcG9hmbaai2+9+NyvGCjFwg8PNE3DaH/aQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsoAcqZ+Vqz7PCdoTojjfSalT/lh2PbDNz5R6EgzCgYDdMT1Kg
	/ixqG0YoBwpw3EdPbUVtJhWYrNeiy6HVBDfdkgIINf0gSikxt6EKs7V9dycRq5Cog8ZIZUu5bKU
	kOY9SpnuU/w1grUOTxk4kqVjuOTJLZTIEn6LhdEjjpus0Y4+qRxEzJAvSf05/M1kv5BM=
X-Gm-Gg: ASbGnctZfzQIL//goIq64HEgj0rDLOc6zPDYLqfz2aA72ODd/VyiG2ePbb57SNT/w9Q
	3qBDlKhQy+z0ozPltrGm6eZ+7iMYfphaGgHIk7J47eS0i0Yx6tD4zv0qZtrXo4rVGHBAbPJjJsg
	Qe1VtBmFdbCs2lW/euR5S7MgTGdwmfCqXWTfI6RCq2M4gTQC0seuN1Jvl+px2XMlOTtp1xtBxZm
	hP7w57buL9MZ0aDRpNgRiLyV8Haw7ohl1HlDAYE3xnIf5DXZ0c46HprD0moyn+jzLS/xHlr/ITx
	2BDQyGAWlVggWs40FvOnjjhFFQTW9xGpJi35SoXmEovEWWSKx8bugQ94ytV8fcjZlfIJse8oBlU
	ChZpYR2f+IE7ZWdd2Vjsu4O/GDGCZxnto/hFgrPKeUWsoe9cLFNUJyYiJMfbbFz9HG8U=
X-Received: by 2002:a5d:5d01:0:b0:3c7:36f3:c358 with SMTP id ffacd0b85a97d-3c736f3c59cmr13147585f8f.32.1756385414247;
        Thu, 28 Aug 2025 05:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2soHNJz3uNCh9kCpxwV5zoV5iezSYMFN+6bV3UPfCImuAc7IMpQupU9NYnIVeAMq/TCo6Vg==
X-Received: by 2002:a5d:5d01:0:b0:3c7:36f3:c358 with SMTP id ffacd0b85a97d-3c736f3c59cmr13147562f8f.32.1756385413775;
        Thu, 28 Aug 2025 05:50:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba44fsm24519526f8f.5.2025.08.28.05.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 05:50:13 -0700 (PDT)
Message-ID: <a777f88b-ea12-4aad-88da-2e7011e151b8@redhat.com>
Date: Thu, 28 Aug 2025 14:50:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] Direct Map Removal Support for guest_memfd
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 11:39, Roy, Patrick wrote:
> [ based on kvm/next ]
> 
> Unmapping virtual machine guest memory from the host kernel's direct map is a
> successful mitigation against Spectre-style transient execution issues: If the
> kernel page tables do not contain entries pointing to guest memory, then any
> attempted speculative read through the direct map will necessarily be blocked
> by the MMU before any observable microarchitectural side-effects happen. This
> means that Spectre-gadgets and similar cannot be used to target virtual machine
> memory. Roughly 60% of speculative execution issues fall into this category [1,
> Table 1].
> 

As discussed, I'll be maintaining a guestmemfd-preview branch where I 
just pile patch sets to see how it will all look together.

It's currently based on kvm/next where "stage 1" resides, and has "Add 
NUMA mempolicy support for KVM guest-memfdAdd NUMA mempolicy support for 
KVM guest-memfd" [1] applied.

There are some minor conflicts with [1] in the "KVM: guest_memfd: Add 
flag to remove from direct map" patch, I tried to resolve them, let's 
see if I messed up.

https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=guestmemfd-preview

[1] https://lkml.kernel.org/r/20250827175247.83322-2-shivankg@amd.com

-- 
Cheers

David / dhildenb


