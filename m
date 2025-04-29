Return-Path: <kvm+bounces-44762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0166AA0B31
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ACE47AE22E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 12:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AA220969A;
	Tue, 29 Apr 2025 12:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TvyYmUmy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC6820FAB1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 12:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745928436; cv=none; b=PbPkDMQY2S9tTvuoRuAg0rAPc3yx7Pvig89qp612s7V3wHuOgwnzd7zwrrhDOL8EagoXJ3QGsuPr4PQe2RLrPhNQG0lcqb2KEu4xoEvffv1RbBsJDbNrx1phux65DTSPYawIIB+GrRbGwnxges92GS/MfbLjUK7jc4Y+pFbkrEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745928436; c=relaxed/simple;
	bh=cp5tt7YTlh5a1OzGYC9H+R+dJUuQcA+E1rO7w6lMuu0=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=PmSdqosJ55nJR/AwEcKxi1rw6UdX4MAYRUhmpL7A3QvmjoDku72ZgdeWWe9OuCQtNGpe65Gc38Elum8s1E4R7yGTDDDPZ9Cybh5uiuwh3cUCincVAatdNbk2NzprIVlmpr9WJ2KE3laVxrVzuYcS+n9s+Z0sxntHGDWlme2exYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TvyYmUmy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745928432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=kTSkia8KWXtWyL0vhwXQWCGYjRP8DINSUfbTRvk+MAc=;
	b=TvyYmUmyZFPq6PBwQz9XpWGTamNm2oe0GrJb9blS3SEkYRStpsBKKgcacyeWOGd9oVWk6o
	BeYoSTVUWAQR1FmY5mrnC5CWXjazOuVFpd0D03jblQfU/6Cx40/jDYJ9AkKFS8Cc6jE92Z
	ox/A/IaK/vmf7B8wjkH6iqYSCVxU/Hk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-d-_cxqWYN1yd_jUzNEfCLw-1; Tue, 29 Apr 2025 08:07:09 -0400
X-MC-Unique: d-_cxqWYN1yd_jUzNEfCLw-1
X-Mimecast-MFC-AGG-ID: d-_cxqWYN1yd_jUzNEfCLw_1745928428
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39123912ff0so1445415f8f.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745928428; x=1746533228;
        h=content-transfer-encoding:organization:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kTSkia8KWXtWyL0vhwXQWCGYjRP8DINSUfbTRvk+MAc=;
        b=DKBUKw44LY4gn5VgFzEUFePkYveB5eUlT7ZxTC65YBTfDjVh/wNZTxgW985oWjWbRm
         cA9Fy8mnrmC+2PThxXcK9sXA5dxsyHYXeKtxlssX5z90yQh+ny5xLW3Okb+WoVX8CHaP
         4IocInfjS/i7tGcV1IRF41sC+GMAQdD0xQJmdgcokJpoPCAkWWLKXD2t01LYC1lGGznE
         LDp8s7n3n8hKHUBSqnbd50cBVmL3KI4ryGkbDIKrIYjLiWwbk80S3JxE3mb9FWbfIRbn
         vDj30CsDzZ6m+PYD+xGZEmggOd1gS4+JBeJtcJK3104oUZQoj9AQujG+gDiJmVUbx2zL
         ZEgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXBa20fKa+EqqowYUHHTZrFko0ZIoxm5uQC0sHx21rC/PPMBBGVbtmqriIGJAZXYozFgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5CRW0fxuR1KJS/q6Tu+uElQntad392Q56sJouI7/qfoR1wRVZ
	xats/ewvmu/c0DTmxsEyLv0P6f2RiSoN3l18L4inXgXaZAj3AJ0hYGCya8+K3I5jRb74hwQtJia
	1zlDnw3Z0gpAUl+MuyNolP4fVXwVxNISp7rybqCRcGxafkFXV0w==
X-Gm-Gg: ASbGncupPvfkoXWTeO1cDvvo0KxC4Vp7D27I4oP36lHU05GQOYfuuGU07ZK6PblMf9m
	6qzVNvBA09Pv15oRMGsT6Yer29OJuaojHF+okDeKXra7MEStPtR4OUSmM2hAPTeDR39hfWIZHdk
	5rE+zxQBxwLolkcjozLJotfqrDoTK4iRyDvaPGDwG8u0JcGpzzv1ylFoMbElm3zXbJObKWiKFQ0
	q3Kr4EulNRJ++L/Uo2O74mZ3YaTiresthKL22/iTQWVbquyzsEL/QHup98x06pmPtcKqM1dw5eT
	I5YmDH9lYmDfhg1JamVfX6d6HIEhdwmuUHw2ptPSffROibVm6O2LnnhrtDM2eWynId08GYzWb2R
	B+BHEeg8o5C5oSXfpjbkPIF6MoyI3X9CHFrpaRSw=
X-Received: by 2002:adf:f389:0:b0:39c:310a:f87e with SMTP id ffacd0b85a97d-3a0890acf2emr2869267f8f.16.1745928428121;
        Tue, 29 Apr 2025 05:07:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0UQ5x1vTRot8WJ1YmH65lZ8zWcR/rAsdDc3/eCpgfpICMWfIpZVY3UC2Y0UC1TGOs0yaFGA==
X-Received: by 2002:adf:f389:0:b0:39c:310a:f87e with SMTP id ffacd0b85a97d-3a0890acf2emr2869203f8f.16.1745928427628;
        Tue, 29 Apr 2025 05:07:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c73b:fa00:8909:2d07:8909:6a5a? (p200300cbc73bfa0089092d0789096a5a.dip0.t-ipconnect.de. [2003:cb:c73b:fa00:8909:2d07:8909:6a5a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073c8c973sm13821417f8f.5.2025.04.29.05.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 05:07:07 -0700 (PDT)
Message-ID: <4d4a90e9-0325-4df7-a7ec-82e3b29c9731@redhat.com>
Date: Tue, 29 Apr 2025 14:07:05 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-05-01
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

our next guest_memfd upstream call is scheduled for Thursday,
2025-05-01 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

We'll continue our discussion from last time on how to move forward with 
mmap() support and in-place conversion: In that context, Ackerley wants 
to discuss fault handling, validation against sharability during faults 
and some kvm_mem_is_private() logic details.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
-- 
Cheers,

David / dhildenb


