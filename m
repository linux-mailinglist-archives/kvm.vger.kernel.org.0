Return-Path: <kvm+bounces-38403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E74EAA39607
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DD673AEB3F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 08:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2ABC22E41B;
	Tue, 18 Feb 2025 08:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="auVp+vjG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706822CBD3
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739867997; cv=none; b=lqTKqNd2p4s4RAvRsmfY212f5VN32AdiNm7Sk6RJTRbc4Afe+ekZo/bhSdGNjRCQtemr1u0AsY4D0AP0cpAkcMC2lizTAPBn+FtIixqR73sgzGt3En6ferbZ2Alx3PTRADv2BVzOdxyzx5kBKLf7gdxwE3k+/L59RMJw4IZ1WW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739867997; c=relaxed/simple;
	bh=et5c18WD3q6ZkyX+s4ciX19RAZlECzekRRL21x0+Js4=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=O4jKM8ZwU4D4ECFWDvK831SKx+lGhOgho2DXv+/rG1JaL7D5qEN///Vvr18b+gXiLtuR6pDGn+nYxmKSODbur31P3um99GwSM+YylxYT9uCm+yvoKo1A0z7Q06bWid0SzAPHByDTNxBoKiysu/r5t1KPaPmkaHaahaxkmLFiRwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=auVp+vjG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739867993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=1DaYom4VQf/6nnrb8kL2J3xtAjn0Wz/9AJd7VVumUxE=;
	b=auVp+vjGB4yIYGu0pGB4leR942J9YDdTSR4oayE4KlfQRYepzprH/rc4pO/o9jxJ1JXKDH
	W5Pzhytw7lOH7YnYKJYsjy/8EJwt47KBwb1Z2+qXNkeMna4M2UkHcdwuYhdARRRUPYKrK3
	T6xBtlKGsOuSsZ54RE6i0vznxaJWqOc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-AiT5IJ3tNpaQMpqFHxXUDg-1; Tue, 18 Feb 2025 03:39:51 -0500
X-MC-Unique: AiT5IJ3tNpaQMpqFHxXUDg-1
X-Mimecast-MFC-AGG-ID: AiT5IJ3tNpaQMpqFHxXUDg_1739867991
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4398a60b61fso7491995e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 00:39:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739867990; x=1740472790;
        h=content-transfer-encoding:organization:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DaYom4VQf/6nnrb8kL2J3xtAjn0Wz/9AJd7VVumUxE=;
        b=cl8l9SBcID20RlrY7eWBVDbWaCgI7TZdBrVqyg4r7eR9Q7sGfBKLEI+T3O8anURrtU
         wM+tzDN2NU43znJ11MREdzbCe7/a9ps3grlkyKvhS/xLSA/AASHR/TAvkf+DzAl+a5fL
         kpUDHKnvYVNV4sKz9nSrlWkwoT210QO71pVJMtMTm1MaRpu8TxmpebOsNdnlHB63K95R
         Px4aTeby1NXsF8SURs3UhdBrsQ3MMqmD/L1bbVtcoNHhwvUmVzjpu7sBoML+f4RC+EZB
         PvHbstePpSBf+xbsyInt8sw3DBg6wazo2bXa21ZSoVY0MSJZyY8WrCtXpMkSNSfDJ+5v
         TxGg==
X-Forwarded-Encrypted: i=1; AJvYcCUXaSkpReiAUtPpCrc3aHvc9QXW8Wh2o1374XxcvveKRwNQiaC6nefhL8aVJt4W3gs7naM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOSgT77oCYvbcHJukw86YqI6BqcNiZMEyumsZqBPrcyhVnDfyT
	I0R45Iq4ZcCoPbPXf/oBPf0zRg8Ly4Kz8+t7aUwGwBqrUryZuPfcUqZblHox6zY5IomDp5TZOU/
	xKQ4bXpWVB4Y65KBX/KVoYikEbsnXFIvuNB+IWlZZ15ZOkdLKvQ==
X-Gm-Gg: ASbGncsoFhy4ekZSvvK88ZeoY2OeHKotFjwEX8QrgTbTm0eqgwL5W2Q8uguUCYf3NGw
	UQRn2MobJ+1M87bdMOmtsYqc7UoJzKu0fldFEpT3X3GfRCRqXvTXvkgrGdy7d+7pA10qLKRmujz
	+ssXUZuhSZvekmIdV/fKgwEVXJZw8Q6EgHcLl+bF5HYPpwhRDaPo5t9QOHxh3mD3X1MOasz9AqN
	NB12X6Mp6qYblKacCqHNy8Ck/ypEwwq8x7Rh+CWQm3klmTj0B1F3Hs29t1HJ6xmlijA8CLbukDc
	Qq2qBHFQ5IriDT7mOWBeCeJVG4bOjGOjmpwv7QxsLy4eXIlY23QtYtKFnJhYCJgTjxC/m36SHgs
	Zidq7nG6wMGI9HqY1LF/qRErjy3bHMYEp
X-Received: by 2002:a05:600c:1c98:b0:439:88bb:d020 with SMTP id 5b1f17b1804b1-43988bbd44dmr42775585e9.8.1739867990403;
        Tue, 18 Feb 2025 00:39:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiM3bhXjMANfjn+nBh08mSvwkMVgJKRO5Fmhp7MYJfoDBHwEtitS3LqSGG8c3g8fliw6TpeQ==
X-Received: by 2002:a05:600c:1c98:b0:439:88bb:d020 with SMTP id 5b1f17b1804b1-43988bbd44dmr42775225e9.8.1739867989853;
        Tue, 18 Feb 2025 00:39:49 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:fb00:d3ed:5f44:1b2d:12af? (p200300cbc70dfb00d3ed5f441b2d12af.dip0.t-ipconnect.de. [2003:cb:c70d:fb00:d3ed:5f44:1b2d:12af])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439930a9966sm15195615e9.15.2025.02.18.00.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 00:39:48 -0800 (PST)
Message-ID: <40290a46-bcf4-4ef6-ae13-109e18ad0dfd@redhat.com>
Date: Tue, 18 Feb 2025 09:39:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-02-20
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

our next guest_memfd upstream call is scheduled for Thursday,
2025-02-20 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want a google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll discuss:
  * NUMA mempolicy support [2]
  * Preparedness tracking
  * Guest_memfd without struct pages (shared+private, or only private
    parts) [depending on people availability]

Further, we'll continue our discussion on:
  * State of huge page support
  * State of shared vs. private / mmap support
  * State of shared device assignment support
  * State of "guest_memfd as a library"

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] https://lore.kernel.org/all/20250210063227.41125-1-shivankg@amd.com/T/#u

-- 
Cheers,

David / dhildenb


