Return-Path: <kvm+bounces-37393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E593A2999E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 20:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C9CC188629F
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6B51FECD4;
	Wed,  5 Feb 2025 19:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g99G61vf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9061FF1AC
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 19:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738782019; cv=none; b=GKn4KakffIO0Kq1BJDqu65yL65Ya1H/Mz9KU6XSMwog8Ha9fO/oHWCKkuI5NMdsPKL4H3ZfoYJCZvV3N3TH5tKsMT1JGL5skikxJ4egWDYiqXree8mWRhEQzr2XpSfil6HKGtX4rT6WNgu+eXc04PF3bL8Fs2lwzxfFH4HUjiq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738782019; c=relaxed/simple;
	bh=Xm2ual+19wDgSu/5eZaULH2c0ePkUyOKEbhBOy0r8CA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=cd50wgsbSC0rAnzeKpscfA2k8Hb+qTnHAhEbUaEzHX7ZLNbUxacThxqyqxcbM/gRn2BSPivfKw6B5381GlENMyaqvNBtPqEFhohEslluBb0Y72mnQE3m2PjPfBXyri/CptSIB5y4PNrDuBwz9zLvl9Fev/iJUOo0GnGXB67nv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g99G61vf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738782015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=MnTEmxYLFOJl/4mlhCIKwxUFV097K0d0IrDExUJf7kg=;
	b=g99G61vf+b/zpasg0jeLfg1P8Wq3QO+I6tnwD7p5OMVdag9LuKBHcKC5vsJg9MfcxTwHbb
	YTnfS0SDYX+BdIQqVCbJE2mW3gzsmYZ6zvE4/GOwUu2ZAyJ/38wlO507hzLYFN7i8YbTEm
	sIkbZXHx3FknHwvXOkU+3vW6oAXdeFk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-zQDEh1j3OX6EQuVQjfULhg-1; Wed, 05 Feb 2025 14:00:14 -0500
X-MC-Unique: zQDEh1j3OX6EQuVQjfULhg-1
X-Mimecast-MFC-AGG-ID: zQDEh1j3OX6EQuVQjfULhg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361efc9dc6so437765e9.3
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 11:00:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738782012; x=1739386812;
        h=content-transfer-encoding:to:organization:autocrypt:subject
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MnTEmxYLFOJl/4mlhCIKwxUFV097K0d0IrDExUJf7kg=;
        b=ETnXl/AUW5t62XiKUqQWnkiVHM8n5aRh/u+4HD+61amIHj3N73pLgBwwURhNxQygZM
         utDFMXUUtRnPYHZOZTM6pYPT5sbJCm/It0nWAYqwZEuhJLFr1S8WrkqWyHJLamzEvzSW
         QJJh/tUHuLlwxvDTQjFhh55/gUF+hdF/OnHkI29v8/dd/n+v5GcXzf4xl2B5ap0RT31d
         A3Q1H3tjQhwpj0cjpH0cYj52Yj7vlAtmWAVoOmNzx/MqkWw+8RRcRfXXJs7nFhy+tOXB
         7FkJxPE43qKULO3oW3Grxd4DqKHpzlFJWej9Ln9DSDlP1q3/0TL0fbXvXyEjr71+QtcY
         Vq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtPbiJDFM9Gw9G9SSiBXAHW2cY2YSYvEv1stZMRU9rz06E3BgWQ/ttcMTtNLK408kpkkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6q+OhfmyA/gWeOh2xaOHG+FJ3ghOwNkjAGO6SI44XBtsRmk3/
	CaaGqTSArISPbuWj+JWgXXH4c1RuvfuKYBzDKVHZloCoxM0L6AR85kCqQ+Ht2E3kilixtDozByU
	Urcjx/oL2GPeUNDq2paeGWQu+CDl6BGqUC0IogM4aamIlRDRGqw==
X-Gm-Gg: ASbGnct3xrDKfCKL+hA9BQRSqJOygDIlxgh4g1a8ZygC9qEkYqroPhMx9K8PAVMo5K6
	jE8nEDxsPb8ooIVzDRxi73JsTk3wNi9c+fCBgq3Qo4/hFmogQRAHBv0N4SohrPmpNd1bLJtRP9F
	Y9/ziy9HNXADk8X3c+n+Vx1UpC+6v72NFdcy7mrPQ5T1WC98a77YktJ/w2jZCPUin4jgRdmIbPi
	BD8vs0sDLvGlVV57E0kAWOLEPXZqjBGBhHQhxtDXdtzE5yhNP+JXp4HTFDKyj852VCI+J31hjwZ
	+m93YfaqbzGp9jOtpmvmWKERiTQP9vSiu+9Pg2/TtuCfawhGcd/V1ZAnhLAe0m6d7FHVhp8ekRs
	g+q8kfuY2j/n3i6aJExzjIksKGo0=
X-Received: by 2002:a5d:5983:0:b0:385:fc97:9c76 with SMTP id ffacd0b85a97d-38db4861100mr3390909f8f.3.1738782012082;
        Wed, 05 Feb 2025 11:00:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHi0Zp6oz/B5GAgsxiZFqft/mc+2xtesvghBC2j8Rwf94QOQmWTS0YNmVzMbdpt2+N+GgA16Q==
X-Received: by 2002:a5d:5983:0:b0:385:fc97:9c76 with SMTP id ffacd0b85a97d-38db4861100mr3390866f8f.3.1738782011521;
        Wed, 05 Feb 2025 11:00:11 -0800 (PST)
Received: from ?IPV6:2003:cb:c717:600:ce7e:1bb1:53d:c929? (p200300cbc7170600ce7e1bb1053dc929.dip0.t-ipconnect.de. [2003:cb:c717:600:ce7e:1bb1:53d:c929])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1cf896sm20160606f8f.94.2025.02.05.11.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 11:00:11 -0800 (PST)
Message-ID: <c980f0af-9f98-4bb9-9bfc-6ddd6af20fe9@redhat.com>
Date: Wed, 5 Feb 2025 20:00:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-02-06
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

sorry for sending out this invitation late ... I was/am busy PTO'ing :)

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-02-06 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want a google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll continue the discussion we started last time:
  * guest_memfd without "struct page" (i.e., no memmap at all,
    or dynamically allocated memmap for "shared" pages only)

Further, we'll likely continue our discussion on:
  * State of huge page support
  * State of shared vs. private / mmap support
  * State of shared device assignment support
  * State of "guest_memfd as a library"

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David / dhildenb


