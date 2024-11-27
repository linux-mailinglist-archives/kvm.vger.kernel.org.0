Return-Path: <kvm+bounces-32571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C079DABF2
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11ECC2817A8
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7EA200BB3;
	Wed, 27 Nov 2024 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJ+ftQvh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD142200BA3
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732725810; cv=none; b=BqderubFHnZ5m/QSs6aJjydPUvs3tc7WDQg0TV63vki78EKMBG0mwq6YL/itHkbg2eesrsVhEkklL+hOWndYPpNN8gsn+tqhy0BaONAUhdA4GdkWJUCq+y2ZuV+Szp2H45nspl/stAP0dMgqr0/VXDGz/8KPxRzT4YeRg3+zVD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732725810; c=relaxed/simple;
	bh=eDpyj/AW5IHNcY2jQOG5IDshclyv5gQlwt3wqraOgy8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=PQmZsI88HzyVxzhWVqyjAiNu6ASqIAMb2P0dCFd1svXSTO/gAvpxI7SsV/jBRunHYi79lrsdS83ffrui2r503lya99+Ez3csjBWJvsT3pt4+BrRQZremy2S0gx6IxywS2M7zZW5bl4QTgwOzAaYLbOAHSru+/8FJChTZGT6XsTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJ+ftQvh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732725806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QEq1JmDVmj2M7sITA6RewYlgIhtkbkZblAI0t1vMhdY=;
	b=DJ+ftQvhePzk8x89BIcWgPq5eYNPFZdRM9zIw8n2GC0wmHuFEen35kVrAYT4NAf1FHTxYY
	gn0INtuXWxHhkc243KecptT72ZBmJQhNIo8GEaBmlvHwGDZ3a0msE3825pmKxVZ25DRAe8
	+ddXNHT0ZlxUqoAimtawae85vleccDY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-k4M63syaPZidt7jY0mXAfw-1; Wed, 27 Nov 2024 11:43:19 -0500
X-MC-Unique: k4M63syaPZidt7jY0mXAfw-1
X-Mimecast-MFC-AGG-ID: k4M63syaPZidt7jY0mXAfw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38249bf9e82so3879330f8f.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:43:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732725798; x=1733330598;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEq1JmDVmj2M7sITA6RewYlgIhtkbkZblAI0t1vMhdY=;
        b=jOhxZLnZkv9f+WKSc1+5Lyaas6tpgUVfTJjsONLjHrZcnyvivBNuouWYIuAFW7oY0C
         7/dFIU+nm/ORP5/rZADdcDr9ytz/yJbtXLgko2MKSCxoLPW7nPRQqbxRn9L82ZF1sXm0
         jhdHkpfwwawSrAJjRNPrOTACRL3onyN3cHis+8qe7noELMuf37GUBqzNchVzp4MPv79E
         f7eFnwuZxlbRPgZAcGnAIkpFlndNYUwXuUTecyIyhMdapqMM3R3CbfbmydXkNRK1aPV3
         cmmI1EGNFTFQIdBNbCFrVA+dTTw+uEJmIzGld99BcZPMQCVRdz8cmXcZBVQHuUuY+LiR
         4qug==
X-Forwarded-Encrypted: i=1; AJvYcCUWN04kKAeRRjpvcUbmY84AZ4pk2U4Rpd5PnMH7fmwIaJ15KZr7QXJkuEJespPL25VZ8CE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7nPSCbhbh74GrH26y2SrLz2oBrZtfpmw4WndAPsLAt7GFaqkm
	B46DecFJfAF9dtrE+1zh4BuCLrQfzRV9bYzkt8pXoSQMJL+3P1cQbJI1Sy4ABeLEEvBGVjGdG70
	xFC/HtEfzJ+PL9KEnfzd6I3R7tbv+pRJAo5vszHJLOYcYcRtbNA==
X-Gm-Gg: ASbGncsYlTLrg2lHx929jaQxTjvXzXto45O0b0ncYFqEsWy22Z3wCmsnBoWvoFv91/F
	zZcdlzpNLsKmn27a4sJCv2U4ksn/CZ1ObdDi3qCGvDPl0Rw1BUjLhF9hjTFXphHlgyzA4h/DG5x
	D9E9xWPwXAmtenx5/lOlZS006y/ucnPX/Hj4wZv3SZu1VUO5jssJUqZwuF1vKcjZcIRtjv9Egzd
	SmC40Ok7YRAyBHwwSApuisnTzWckrxxuTd+OgTI9J0p1rh/dx1ihLEj+q64JmRDCaFKvgz3dn0f
	X1d1MFfpZfChoBqHsOufJhBN0AQ1Rn/KUuABOPJjIjbXc4nCuxPOlbNl8BjP4AnnK+ROboSdLEy
	ZfQ==
X-Received: by 2002:a05:6000:20c1:b0:382:4a84:67c with SMTP id ffacd0b85a97d-385c6ebab13mr2127562f8f.32.1732725798357;
        Wed, 27 Nov 2024 08:43:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMlQf8YzSnq0HYc9BWB/5qoUxkKtUNYenwtMbzT53NbzCmcxZk5Gr24lNlaj8AsC7WyrSUIA==
X-Received: by 2002:a05:6000:20c1:b0:382:4a84:67c with SMTP id ffacd0b85a97d-385c6ebab13mr2127537f8f.32.1732725797871;
        Wed, 27 Nov 2024 08:43:17 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:be00:66fa:83a6:8803:977e? (p200300cbc70dbe0066fa83a68803977e.dip0.t-ipconnect.de. [2003:cb:c70d:be00:66fa:83a6:8803:977e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fb275bcsm16705160f8f.54.2024.11.27.08.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 08:43:17 -0800 (PST)
Message-ID: <3a544ba8-85cd-4b91-940f-85f6f07f2085@redhat.com>
Date: Wed, 27 Nov 2024 17:43:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2024-12-05
From: David Hildenbrand <david@redhat.com>
To: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

due to Thanksgiving, we'll move the call to next week. As discussed in 
the last meeting, we'll start the meeting 1h earlier.

So the next guest_memfd upstream call will happen Thursday next week, 
2024-12-05 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and 
collect current guest_memfd upstream proposals. If you want an google 
calendar invitation that also covers all future meetings, just write me 
a mail.

In this meeting we'll discuss:
* Persisting guest_memfd across reboot / guest_memfs
* Shared device assignment in QEMU
* guest_memfd population overhead

And we'll continue our discussion on:
* Challenges with supporting huge pages
* Challenges with shared vs. private conversion
* guest_memfd as a "library"

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] 
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David / dhildenb


