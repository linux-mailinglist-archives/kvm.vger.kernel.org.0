Return-Path: <kvm+bounces-57909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E715B806B5
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B4771C844AF
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DBC335957;
	Wed, 17 Sep 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blDTTlyN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19024332A5E
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758121363; cv=none; b=DuWo4QGVCgTUzlgIK5gom1i+af9uyMdeG6wJUW4Fr0D9hW7fcXma0YN5D+ptPIm2erspQUHpdvmBRShBHAHWPwomnSpkZuDosKJWq7xQ5WAqPTe36y99HG9YSD+o7toXmVxNe6RanF2L3dbZ5SoOPUqqc50PlmD+N+yPU8Rt3oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758121363; c=relaxed/simple;
	bh=ETwcmm8JSn0BgJbSlKE3RKnZqCQXSERLDynaqBiXOuw=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=n73Hx+WEm9djGJhzreStFpky17GZmDCTAj+dQ8SxPX7bw0qHViUBMbJ9cp2cGJyNYa8E3ZZ4G1x9DqA4btoFoUWep1d1OjrBKp8d8Lu/aCVwWa+ZdQVPmCnTcRZF7Ed06pvASRpNDYsA/I/iZHS1VqCL4b5kjxzugguanXGpQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blDTTlyN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758121360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=YYhCdI4Q9hUzoKgBgYNuwcWvhIZyQUxhaAtXakv2Ac0=;
	b=blDTTlyNlUxbMENrvHb6X3XzzDTvfrtfAw32cXjuJifA7hjLi+fdKuHz99GjO6QZAg8VBO
	urUVZpzjrTfwi1BIxGLrGN+WhOzS2KYKleSyP9SPC9WW8GEkqht2S0I5ZXDVUB/C1/diYU
	ufZQeCH/mS+siGGGxZEP/0wZeL4qUmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-bLRdLIYhPZuDAqcnyMdH7w-1; Wed, 17 Sep 2025 11:02:38 -0400
X-MC-Unique: bLRdLIYhPZuDAqcnyMdH7w-1
X-Mimecast-MFC-AGG-ID: bLRdLIYhPZuDAqcnyMdH7w_1758121357
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so42343955e9.0
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 08:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758121357; x=1758726157;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YYhCdI4Q9hUzoKgBgYNuwcWvhIZyQUxhaAtXakv2Ac0=;
        b=sTNpg4HSAxXJezZFZBwx+tc6J+Dqz7gNGnhbdovhc6z7pA49yZPSEPXhqxBcco7xlO
         uCDcVKAwvPCCY/A4hHYwcyUptdDmG5Y5gzdz2lSJszk2YlW3c6G70CqHFK6GYIFoddWE
         g1iXWLkzkn7d7lSkWVXveMMPJ5I6mL1k7XcMRR3vdMpvN9gRnnjdnC3xQS4ErtGxb2Bz
         mqu2Vvcp3fRmHJaPEPd8Lw5p20jRA3TG4ePNTTxFqEwmKbBxTBru11cHCk2+I2HLRj7w
         AqzqHqQ7MqQaXQjfOxxymFZg3x2fwUjetq0lQVnxRAN7ftf3wztCzbPKjlWN/O/O+6m2
         WYXg==
X-Forwarded-Encrypted: i=1; AJvYcCXLwP1chzlfz+Z4NXCIjmgY5c39ZKb1NNIQw9KQtpNE6bGDjtlM/BGI/vs7VIX1mGF8z74=@vger.kernel.org
X-Gm-Message-State: AOJu0YybZVQN2qPDPq/dmUS4S4WQUAqIl11SryO7+XzuS6INp33VmuVB
	QLc9XJZZRPjdPABybB4Lk0QTNmG5b6KgRtQgSA7xPSgVreNFwhvtrn9yUoCwcnBactQW0NrcsBi
	6qUuJLVrPrbxgGp+in44FmdPulJlughf4tjlu7SwEY2SClX/bvl08dg==
X-Gm-Gg: ASbGnctgbkO3VPVTWDDs6eLCP801rt6YlN7LcDmcKhIhbIgVgp/DYLJ32YI4BYWbLtL
	lWgdD3YBsp4iFQCwYVeWmv9tszjApcKCvAnI7Vb8WXEpvtWzlzwqwndwKW6ogb4GCIip9Duxi1s
	R894cXOwD7XXQDefYkAjRDj/3HDF5nY0C+Hy5PTyIRceJ88x7Hdh2lyb/QiU+I3FMvEybMXP+OU
	F+uLyjXeYE5Mx7vdjedTa5sVtAIcOfYWcdYx0m6yuK3BPHwd8Iv95mkgvrmKaKsSLrEPMFbFXxo
	9flC1KkjHCUccEI4TT3a0YaZp+Fu1a+n0GIkW1JzzGKJ+BlTFwi5+p+qGQ67H0eRtgbhEDUOCrm
	zBAWa4XTBIA0yiawE6WvziH/jx/1kqxaSK7FBOJWgKH7hhZPaqXkKltGtxwm/CCYx
X-Received: by 2002:a05:600c:4f03:b0:45f:bef7:670b with SMTP id 5b1f17b1804b1-463699748c5mr11533305e9.3.1758121356151;
        Wed, 17 Sep 2025 08:02:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENQagQHTk2oT9ysMwgYVh+So5rsFAoYrcTyucKX1OXr6gl3RPWUZl+VDYfCpD1fI5KhTXxfw==
X-Received: by 2002:a05:600c:4f03:b0:45f:bef7:670b with SMTP id 5b1f17b1804b1-463699748c5mr11531555e9.3.1758121353883;
        Wed, 17 Sep 2025 08:02:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e98b439442sm15671180f8f.38.2025.09.17.08.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 08:02:32 -0700 (PDT)
Message-ID: <46bc189b-911e-4dfe-bafa-43ffb9200427@redhat.com>
Date: Wed, 17 Sep 2025 17:02:31 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-09-18
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-09-18 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

I suspect that we will talk about

(1) direct-map-removal support (folio_free callback making our life
     harder than it should :) )

(2) the future of preparedness tracking

(3) discussions around "stage 2" and whatever comes after that

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David




