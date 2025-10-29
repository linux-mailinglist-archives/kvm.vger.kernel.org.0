Return-Path: <kvm+bounces-61397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B1EC1B52B
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 15:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 148565C61B4
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCB1283142;
	Wed, 29 Oct 2025 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WP8oJPjE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D93548EE
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746585; cv=none; b=VlcFXXtjJmbLMLJHmr9BylGuM1dKSGCcqlAoiKyYKZvAW3JgYHJ7KMyLncPjbc6rIq5GoZF89ZKWAV0lzq+FIx5AtToxvAwY3SdAKnQBu2JlNWjgEjAHQpd30M2mPpdVaD+nOZriyKGwbz+EYyZKcK4eKd10DoErdLWVVZ8mfwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746585; c=relaxed/simple;
	bh=yJFe02mQTayTg3e4UiCyzVPf1kc7DRlcXkw6+ZW1Co0=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=lg8sdsPGuQmllH+EM9Cl8+radtDJTw3PXMla+GxsDl/I0zL1tYBIcObABulUz9GWUDUiYR7W2+cOmlI7Iv7woUKw8rgaOQQMynRYqkH2MX2lWQ5lBMB7rTKxszPV/NduGhiXKLpSOrck0TKd1CweeLoN6OYX+MNO/jd/DVhNzKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WP8oJPjE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761746583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=cnslAE1BZQVrAKABEOK7rtluaysr6PV5JU1KbGuTZi4=;
	b=WP8oJPjE9mMdHUUJ9rEqYcIMQFhGAQhHM99QCF3WqWrKHvX2QiMBGiSJBcSevzHCaGFmsU
	jLmjSA3C7vqGmhkdG0Mc5SNWGcilS+RVOb8DrTuq/Mx2zkSRoSildfAlnlhTVx0EPPz9Ba
	/+Onxk7SyD6xWoYpeJG/VICc6IKWccc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-D-KV2wqKMHypGq1DHyQavA-1; Wed, 29 Oct 2025 10:03:00 -0400
X-MC-Unique: D-KV2wqKMHypGq1DHyQavA-1
X-Mimecast-MFC-AGG-ID: D-KV2wqKMHypGq1DHyQavA_1761746579
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-63c299835ebso811968a12.0
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 07:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761746579; x=1762351379;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cnslAE1BZQVrAKABEOK7rtluaysr6PV5JU1KbGuTZi4=;
        b=CkcI6Sp/bdifodkRp58wN1uBr8WIM3qA//MU+YhkwvvAGqtep+3qBsNhuIX2g1qrsK
         CbqtKcEvmKRpqX//BhpjR2H3kI2VeiiseWs9u23QQcbKm/BF8rVN6963e+i6GMNSg4ch
         /ysBwobReFrGtIQD2Ay1uEOzs4kEJ8d+16E5Vm3g82j1Q6AtMgPA+4j/m23PVPvWUAHy
         UXRskwzkVgKG+OE0/HfwesoQOWiCLYFXWx4tnVQULplnmqikI6S1itd+1b6A+Fr5Em1s
         1OpgeKJWWQfvKj+k0YpztOiqraTEmOI8FjV6KWnJjEiDCHUXX9Idklcvz1p69u0PBm6X
         q1XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSVSTw6vJ/kncdYlN2eUwIyTnlYPp82N/dKkh7ZakZT73rUApMO6EozOv+EQkpilu+T7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe0ap31fpT+skdXERSUyDa3nYTDs2sdtfZkdzrfFlY/UiR12EZ
	YeK2+JomRFkYK18887WRv9Ij4S0UGc0NXD7oR9gvhXGkj0Pvq3HSQBUV7N7VU31mhPN0uz0kdPm
	gLsqINoRXMhS0qMyhb2jzsLZIOdvtZOBXpH6/TRQWi235hexmyAYPwAEE4CYGrn7L
X-Gm-Gg: ASbGncsCB1J30rJQuiU8DX6cWl4nQ+rzsLwCIuVUD1T5EtPMAEDEtHmbwLB5bMTU0iT
	sDJHHEPDIRbyQof3U+msw1RXL2napg8kLnZM7KLlMBQ9LdiXD1L/fHtGtoAKZe8hTLtg3ukHNyD
	7LCmoVHniBJUJv57oxdXLMtT/PSWGrijoCPRJPd/hmLpUCzNCMP3UJw/LeWlpIsVUbhS9og9MYN
	GRcAeSo8jaLZ9Pz23o8CmnSSe1lSIhQSljO028Is93xF27URFn2wpvqRz4fwH1O+i8I+9kN/2E5
	UfRabsOTf3XG/LmlQVTKP+Y5SMZDOGg1KOYQttLEwpe+ZDVNIX9YvL9INFBH+bG5j4oiifkx52S
	ciNXJ1yUNLOmBwa4RMG5aqQ==
X-Received: by 2002:a05:6402:208b:20b0:631:6acd:fa3a with SMTP id 4fb4d7f45d1cf-63f4bca1889mr4779520a12.4.1761746578993;
        Wed, 29 Oct 2025 07:02:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzL9nsIzjqYVEDAPqxer68RLicZll6N15l3UlZtS3k0Ux6XvHSf70IZUbFQ651og2L846wOQ==
X-Received: by 2002:a05:6000:613:b0:407:d776:4434 with SMTP id ffacd0b85a97d-429a83e5134mr6401396f8f.30.1761746241529;
        Wed, 29 Oct 2025 06:57:21 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e2358cdsm51810715e9.16.2025.10.29.06.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 06:57:20 -0700 (PDT)
Message-ID: <f289e9f9-7c6b-4451-b78e-f22473c1d006@redhat.com>
Date: Wed, 29 Oct 2025 14:57:19 +0100
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-10-29
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-10-29 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll definitely have Ackerley give us an overview of 
work-in-progress HugeTLB support and likely we will talk about the 
in-place conversion patches that are already on the list! Further, 
Michael wants to talk about using the SWIOTLB for all most/shared pages 
we touched upon in the last meeting.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David / dhildenb



