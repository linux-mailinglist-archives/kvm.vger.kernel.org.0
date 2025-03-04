Return-Path: <kvm+bounces-40016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF4AA4DD41
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34C623B18C4
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 11:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37736201021;
	Tue,  4 Mar 2025 11:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9fAkHOL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36071FFC68
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741089546; cv=none; b=qK/LP9aF3ZQmlTa5J7adTwPZV1bjYTnNTiorIjxdwJxq0VlLfc/0MbOwe0HdY3TczGer8Q+YszDxDlaYCyolAckoyDxySdve7y07pqTr6idjoUHDmlBYNqLrEm2BKfI9znccFfFNBg4TZk17t4eELcIXjCzyO80Yf+fuUpvi+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741089546; c=relaxed/simple;
	bh=L0yZI1Kq77rzCbf+eJXPv1Z37F2/dQQ/oBiMcvhkljU=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=taAEqEjmi/DPJxhupFYR8lBkQZXxh8nqh1paD3qvuaj27EHOYUYmnCXnKkFN0HzJ9dWAb5uHEs1VE5zkz4txWg4W/2qoEBcEF/N6e5NxxQsRTmzd3fduRnyQR6FjcgUCigVQWXXyyyIVkXbf7n3v4GbDI03tLzh9tW74MzUSSvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9fAkHOL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741089543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=p5vMcH1m85r4ZyF4VX5xnFddJDrUGh6ySD+hcMeUnC4=;
	b=g9fAkHOL9amhTzQvEF3qYlf5c5ThnssXSfau+vQzvzo0heZ9lI18Cf4korz5EDEMkxYRHX
	w5zCCcyI8/vd8Q2dGeYrMu80gZ6df+j2x4/gVo8RBukGomw3ajLngfnhILBN2kfxi7XWSa
	9tBNBTRhsBVO+LHSuIUgU/QxLqf47fA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-1JwAVyVoM8aHsWfc9up0nQ-1; Tue, 04 Mar 2025 06:59:02 -0500
X-MC-Unique: 1JwAVyVoM8aHsWfc9up0nQ-1
X-Mimecast-MFC-AGG-ID: 1JwAVyVoM8aHsWfc9up0nQ_1741089541
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4394c747c72so21847655e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 03:59:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741089541; x=1741694341;
        h=content-transfer-encoding:organization:autocrypt:subject:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5vMcH1m85r4ZyF4VX5xnFddJDrUGh6ySD+hcMeUnC4=;
        b=GQR7Zxu9w7u5aIpYwtZZ8EQSPXzpWRIxRW1QxaCe494CdP64buTyv3u63aNEFSUU3N
         cY0OlArxzB9Ml70VywmhvlkvbbHMbcawgqlpTY4LR8JWH/TIOrBZrUQ4VlMkzWNmhRnT
         IXohSGdoRFRvcl7I36A18MqQcfOBa1bwuYOxqZeiWegHsYPikvzzOFUnfKPn7u1OBe0i
         GJCN7E0MHyTLLOg/u4M5NvyQraT01LwA5G50xzV1KEyhz1iN/cZtEd9BI6MfylZDpTIZ
         1N6PibdcG1/HNMKDsvEAfFKACUaBvZ+ENKqYfGtQors/SwZmiQQHq1PPaDO0pHPogeGJ
         apkA==
X-Forwarded-Encrypted: i=1; AJvYcCWQX+apeblSranBw1MzdF0HuHJzU8aUw4HJ1CAFBItZN0hbNdT+NraiRj2ZEmgjT79Tox4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsgwzdOOivTg+fwHcRqXrwA4k+OxoZBwY7edWbEVQfWMwNfW9f
	aJ39auOAi3CsyBRSWwctWYLiALQpYMXfgav0BsFqtnhCdta0Zx2wt+PQiQDeWznZ1ijU/0no4ox
	upE0iJPxfCFdfur6rHQdY+asHo8TDZ1QhB57h77Ca2pITFLD08g==
X-Gm-Gg: ASbGncsCiAvMZCWx+KaGx2+xtQBeK0tUXjX7enyEVpTLdJ4rE/fPPRreSH5QQN6JW5s
	H+Rep/+cgcxp8wAqwXqVOcf6jKVZy0qnLBmpRpOIE6/EHadFjgcuRMU1u3NRUSbOXxnJwBTw+ka
	1dNoGV3orZppOuB2/WFJG6a/YoNDy5L0cCqkuuwtefcncmKoAtCUB21Pa8Kbsn5kLQQ+hIwsSdZ
	GvOgo7M600nAewJey6r9DSWuKNgEmUlkkeETPs9pF+E2nrC/sWIWqFV5tuQgzI1iEJT6IJ+/nV3
	/Mt+Tl/wNS3oRPKAonPENZgAy0LxX2JRvahQP1qoiDyOuzeE6q+ZU6L8jW01guD2fL3Wi/wvhkG
	y/ZNHEiDUzEhduo8rQqNMR/1/EifhjzBj+QnW4T+tygA=
X-Received: by 2002:a05:600c:a01:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-43ba66e6c78mr131423335e9.9.1741089540826;
        Tue, 04 Mar 2025 03:59:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGu0t40JlGkFkz4HQS+HBzdnYvZ/WPD+O3bqAfzkChgxRu3omrc/htkDz6Y3BmgBxEUv9IVFA==
X-Received: by 2002:a05:600c:a01:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-43ba66e6c78mr131422875e9.9.1741089540291;
        Tue, 04 Mar 2025 03:59:00 -0800 (PST)
Received: from ?IPV6:2003:cb:c736:1000:9e30:2a8a:cd3d:419c? (p200300cbc73610009e302a8acd3d419c.dip0.t-ipconnect.de. [2003:cb:c736:1000:9e30:2a8a:cd3d:419c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bc1b5db02sm71945065e9.19.2025.03.04.03.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 03:58:59 -0800 (PST)
Message-ID: <4e1aa924-f463-41af-bf2f-ab68f143239b@redhat.com>
Date: Tue, 4 Mar 2025 12:58:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-03-06
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

our next guest_memfd upstream call is scheduled for Thursday,
2025-03-06 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll focus on:
  * guest_memfd without struct pages

... and talk about some of the latest upstream proposals.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David / dhildenb


