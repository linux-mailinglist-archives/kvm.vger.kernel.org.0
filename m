Return-Path: <kvm+bounces-56107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C11CB39D9A
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 14:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 905A81BA48CE
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C90B3101B6;
	Thu, 28 Aug 2025 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eyub1pIA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64BE30FC14
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 12:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385105; cv=none; b=R5ZBTWfrVbzSkUYyb7lByORxgqL5SHKBeyC8Q4RlCZV4EZY7AUjUY/QdXuRtfUO3z8Z8T5V9ftRU+rw1V7zVxHUEI+X+cInvLj2QnGoBoRuNioVWM1McmzKfyRVjFqKTS4QMUkR/oGFM2GppYAiu9aHZrPMMs3r6bVc2aqFJO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385105; c=relaxed/simple;
	bh=ckrs0jgnLQABby4N4xTwzDJiE/afrb24IExIaLQ0rd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmneZFtbCeirKq6Nv0OQJ8dKp5cKQIfPJD6lBxCSZ2Bk32zWdLGB08gH4RjtZBAdi8s2+ujiuPQe8q+QjJSatOAvNszcvg/nkvC9FR27vD4QWk9rWqkHc3xyxQ1NSCrY1jJ98x4rQXmBtO7X4vPiDjamDQSCfnsj47XjXx7J1ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eyub1pIA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756385102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3paW1b5Mw7wLy4xkwmsY2oZkGJtTcOn/fJJ5o0Bou7g=;
	b=eyub1pIAUTRedgRJDTO/2R2addM1hHNB/O0/GYkxP8uyBwtuiorN+TwoOjJsou1bOAX+oJ
	KJ7iX6VG2LzQudcq0nKT+fBbQgj7Al6I2KZ5BkjOwCkzZsLOFIUO2MCcKOpnFOrYOBqrJz
	X7O/TDjyDJMsjy0njeTts6ovZgmI0Lc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-X3pSlZ6nMpKMywBOl_kHFg-1; Thu, 28 Aug 2025 08:45:01 -0400
X-MC-Unique: X3pSlZ6nMpKMywBOl_kHFg-1
X-Mimecast-MFC-AGG-ID: X3pSlZ6nMpKMywBOl_kHFg_1756385100
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so13506885e9.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 05:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756385100; x=1756989900;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3paW1b5Mw7wLy4xkwmsY2oZkGJtTcOn/fJJ5o0Bou7g=;
        b=HPy3xExRrg8DRQdpLsRaT1nGiMS5lGJbEUsG5XHcJ6CwHwddhMMvAUxDqhT+Vv1Y86
         vpXa3trIWWvFOKUODiiMBqrvoLBozyQtihvLzuLq4FA6R6wQAbpVcK5wfeP04PLA1BS1
         qCKytYj7s5qVI2e6Qw8hsTgbnk4QjYOil3kFmQbdueKp82sik0CaQ7jstYjjN8ZR2Fg6
         KJ4r3VM8zn99919jILQ4uhlDlB8qiEN2Fid+Otl/YLLoApUkGIGrSbKbGUlVXhMfjkM+
         YxA0JUccFI7d+/DDJDMoqqtpNu2SnOys0ZlOOhZJjCoQ3yesyhlFKqGqvoEMcelcnQBT
         E81Q==
X-Forwarded-Encrypted: i=1; AJvYcCXI8kDtst2uTj0i/hEla0EeCnNWqtv3NpYYLQ6eRiPYI+eK3ILQg5vO+wAhxKzMWc1+Cd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIRzLKF5mrX6rlT0yYu5W3gSyp/icvBddV/U5p2TNwju5XFdY6
	FBVLfUEguCRz8Z+28Aot3ct3CsqhjwmprcOUN2QkU4jC/QbcDn9YrCqCL7WbPJf7pxf9NW2/ny9
	al56BdGXq+y/mpRKFL0Z44abc7TzU3k0QtTHifluovffblkDWFrGTBg==
X-Gm-Gg: ASbGncvxGTd8ozrDEGYzXH8XdwR4rZVAdmN2TqIHIEmyuw8dt9/GEJjNxAvRL1BgYQG
	r8PqVcSiAInwEgSzGCd9pYrZq8YC36jTdgvh3wJOdr1pfvKe4yPfFN3cQb5Xlykgppp1gJtYNt8
	6uEgsAivHN+ne5vblaCzGztPeYMY0G5knov1p1dTZ9NuDPXHcC4PApUOB0xq1OMatNFj6LgEH0k
	dmvjKc8ltzhKQjJW+pR+diQuyADkrvZNVGEUSh2nZIs6tFx95ofvR6zai1f3Jzb3JOC2stsD/Od
	EI1kmFfM2E06Xny2WY5dvscMCctq3zCbATIPrz9WS7ry56PCSw/AvyCHDe1PrQ2QT/ruTpFvOr6
	TlKMzz5re6V9zaIldfpDqXQ0IytptKltZ1K1k3rr9IhdaFH4jedpJSjP7aNP9NSOUZhU=
X-Received: by 2002:a05:6000:4022:b0:3c6:c737:d39f with SMTP id ffacd0b85a97d-3cbb15c9d73mr7590121f8f.3.1756385099885;
        Thu, 28 Aug 2025 05:44:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF49i8ItUOOotGgNzJSQJ9D9n1u9eFn4Pn8tTpvivzbTh3PK0f+Gzxqf30EOO4tj4ygGNqhOg==
X-Received: by 2002:a05:6000:4022:b0:3c6:c737:d39f with SMTP id ffacd0b85a97d-3cbb15c9d73mr7590040f8f.3.1756385099209;
        Thu, 28 Aug 2025 05:44:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc98998781sm7195784f8f.49.2025.08.28.05.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 05:44:58 -0700 (PDT)
Message-ID: <a6a2a7ef-0019-4975-b9ec-ef19e3fe44f2@redhat.com>
Date: Thu, 28 Aug 2025 14:44:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 0/7] Add NUMA mempolicy support for KVM
 guest-memfd
To: Shivank Garg <shivankg@amd.com>, willy@infradead.org,
 akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org,
 seanjc@google.com, vbabka@suse.cz
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
 xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com,
 josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com,
 jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, ackerleytng@google.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250827175247.83322-2-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.08.25 19:52, Shivank Garg wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> that enabled host-mapping for guest_memfd memory [1] and can be applied
> directly applied on KVM tree [2] (branch kvm-next, base commit: a6ad5413,
> Merge branch 'guest-memfd-mmap' into HEAD)

As discussed, I'll be maintaining a guestmemfd-preview branch where I 
just pile patch sets to see how it will all look together. It's 
currently based on kvm/next where "stage 1" resides:

https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=guestmemfd-preview


-- 
Cheers

David / dhildenb


