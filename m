Return-Path: <kvm+bounces-46496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4F6AB6C50
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 587571650D1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B562E277808;
	Wed, 14 May 2025 13:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcFGULxy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE22798E5
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 13:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747228364; cv=none; b=e9aHDr35NnBqpjQ56031xC07hRTa/DrkXhjFnkEySmKuV4KpKAn0exFi0SiCDcWUTMTDi8+oDu9dhuej0hfeY59/Xd8hFwYZmTcamvxAmpaCqVe8MOhbPR9BhXTMUGnyXI0Rs5KO+dno+Fr4ImwtD8Ms/iWBBrsxcpzvjT8Js2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747228364; c=relaxed/simple;
	bh=sLEdMEdMovKS3zpqUtFGTwiPl90m4zOZfD2cF5JdVW0=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=QxT6L12cP7+jRDNs14EScZmcKGD3HAeGg5RCm0mBjwfBezed4fTkSN8QQAJUnxm1TTdTwn5fDbvs/+7leNWmuPZahoz8PCZ1emSXZFg6xySgG4WjTFqLZvFTuwK+jPrC4NDgHiLKM/J5qeJvi7qEjVeAOV2ijU3INsQrR+r6J+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcFGULxy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747228362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=EdIn2yyAz7EZhD/dsm/ptbslr99u2EeR1xi+jasFHE4=;
	b=fcFGULxyApLh9AisLMI2NYQaQxSzWkcTOExcKAuu6LEg2fMrRE2Ut2eQgr8+cjfJ7M/gcH
	gv014uLVci4lAEp3Ia/phSRLi/kvRewhxeb1FLU4Ejgs5CmzwvbweiQnKmJ0BN4tix/9Ql
	J9U3AK1LYbNm1baChW9fc1gn/DXHHCs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-nhHMWqiXPEWz4DSb1OqRaw-1; Wed, 14 May 2025 09:12:40 -0400
X-MC-Unique: nhHMWqiXPEWz4DSb1OqRaw-1
X-Mimecast-MFC-AGG-ID: nhHMWqiXPEWz4DSb1OqRaw_1747228359
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceeaf1524so4855635e9.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747228359; x=1747833159;
        h=content-transfer-encoding:organization:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EdIn2yyAz7EZhD/dsm/ptbslr99u2EeR1xi+jasFHE4=;
        b=r8wB9nwvJ+gTrIMnwNUDJ31pEC2Ey/MlcDNMQsYAVUdfELUTySlpv5j9QZl+Cve8Di
         q5w0ttfZcWH0idzrDQ2GRBL5SpbY161Kcf1HjPcuui4e/erEcHCmrgTnMpJUXGUmJaE2
         Z9nJdvdEI4yyxYUDIrQ0LdnltAZENvs7AJVxGdRDtxzdCswb4syDv2eTJXIS0LEGAxK9
         dGpVCwnIuvv1jo80SXWn/w4GTTWH8fdMJ0ezG/d94BECHyCPTl5+qb0BOpiL9fVPrnnn
         yzs4kpayecvmuzUKnSNQpfW/5huTPMobvr3JyEs0z1sy+1hZRd2qYTDKRC7hCdOyCvQM
         jZmA==
X-Forwarded-Encrypted: i=1; AJvYcCX9LB08FCWIWBFtpNWTFD/NFOQ9bcTUzM8DcVvFJJV3DwfGiiu5BXowQ555yfpVXLpOGj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdtDva93qhYk5Q0Qn/OgJbLHI6j96+eLWF3PGylcYV1b3x6Qqn
	DGNYUA231bl2PFtDiO1bReiC/iDhQhucnStM/SIkNF0lJ+sJgeAs1pOBWNsa649yLAB4+A/ykp7
	joPqOItVxxU6jTXhX5q5TAODHDclXkAPx6fhzaBSptke33XnrRg==
X-Gm-Gg: ASbGncvjD3g39GA4jik2q2xrwU/EIEVWlmDatOsXuZqhdkH21lkStM/sF12AKZAabLE
	XUepBzzgw1YyLE0aitNocK/WgT5BzsG6ZH6FFGPxyvZ0QT/PqLy5TFPcOAYGXKlvisnAG7EoDqt
	4N+0zgwUCfoG+CeoMwU4zns4EJgnzgHTvns5CCXyAIf3t0Ph8KQNtTvioZQ7eh51/itq3yak4IV
	h4YCjNnFIEvMjeJap2yFwKYSRF1wEj13aeJq7pO4hyV8f0ymxnadaIFEmzAPNxkljz4CWxo0f5N
	MR9tUyeTfrNyKanuh6Kly9oAPcjWPzPBB+qilet6ZNDV0EMR2LeKtq8CE94ohwdJNFnKbdBo/jZ
	b8nDLT8nMfzq6MXp6U+/FdsgcqGY+x35s7f1IMuc=
X-Received: by 2002:a05:600c:4e08:b0:43d:186d:a4bf with SMTP id 5b1f17b1804b1-442f18da6femr28793765e9.0.1747228359264;
        Wed, 14 May 2025 06:12:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9BSS+xn8R8muh0thlFOz6bE90p9V4OXgJI5ArM8SAAuE7j+EXWbkKzPWNgP2QhbJUwAxUsQ==
X-Received: by 2002:a05:600c:4e08:b0:43d:186d:a4bf with SMTP id 5b1f17b1804b1-442f18da6femr28793285e9.0.1747228358646;
        Wed, 14 May 2025 06:12:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f15:6200:d485:1bcd:d708:f5df? (p200300d82f156200d4851bcdd708f5df.dip0.t-ipconnect.de. [2003:d8:2f15:6200:d485:1bcd:d708:f5df])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ebd46aa4sm41276365e9.1.2025.05.14.06.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 06:12:38 -0700 (PDT)
Message-ID: <ac1f220d-5a3b-418a-bb99-5a8193c89322@redhat.com>
Date: Wed, 14 May 2025 15:12:36 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-05-15
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

sorry for the late reply, there is a lot going on on my end.

Our next guest_memfd upstream call is scheduled for Thursday,
2025-05-15 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

We'll continue our discussion from last time on how to move forward with
mmap() support ("stage 1"), discussing any open questions around the 
latest upstream posting from yesterday that might have popped up [2], 
and will probably talk about related follow-up items that are based on 
this work.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] https://lkml.kernel.org/r/20250513163438.3942405-1-tabba@google.com

-- 
Cheers,

David / dhildenb


