Return-Path: <kvm+bounces-56691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF62B425FC
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 17:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF6E91BC07D7
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 15:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016EA28A73F;
	Wed,  3 Sep 2025 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WaYTMnN3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BF21D5B3
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756914685; cv=none; b=mW9bb9P/U3tv7R/QPMjBTVt952I9yNr0qOFdTEvcjCfVH49KuyKLPDlBGJkDpeYp7c+S8cBLqlD9tWLW7LQ3mGAxCqSNrEnpaNYbORGdfKHrLZHFVH/pJ0dNvsLukTg3+jI2/NO+MX0kiAC3DIXYuN3uhY0aYW3viW38JE99qCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756914685; c=relaxed/simple;
	bh=ihBSYH03VzHM77PsBLbgSgiboVXS2xL0lw7aHu8s8zc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=nlzEpmuiZszTyaXrc9sAwieOXjzQPNtXWnImdkYxz01ZV7WQsd0GKnTl5fixHg4kuA4qat/jODgKC0gfvmKFKDjvT2SWAWZlx7OhdUjAtxfESdichoGtORa/ok9HFJqWE8rKDb40rdpfvdsV5b/5hQYr5xSVXN6cF4mkqJ/AdG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WaYTMnN3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756914683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6pPz1Dn3KwcDP1NsdH5IyFFzXwAHxlthoHdtCNvU5f4=;
	b=WaYTMnN31j1wsjZltQK7CO1j96lCiZQL/Qmnz7eSlfMWwMNxoo/BjwCdgGMqRnmFYwtxXo
	ZpyG5BZmULR1ZmmnHoIyVYy4M2CFxPnBu0yyEjDyLxV7NnZMg1mI2IGcESG4ykCbrf8kY6
	Da3kKbXcTqplyN0etB0lpfoOWGhhC7c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-FlcbdacROj2sSJ-4Yo7rAw-1; Wed, 03 Sep 2025 11:51:21 -0400
X-MC-Unique: FlcbdacROj2sSJ-4Yo7rAw-1
X-Mimecast-MFC-AGG-ID: FlcbdacROj2sSJ-4Yo7rAw_1756914680
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dacc10dd30so67731f8f.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 08:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756914680; x=1757519480;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pPz1Dn3KwcDP1NsdH5IyFFzXwAHxlthoHdtCNvU5f4=;
        b=jV17Nk0L8bf/BLIyIgOEGctiYKxfoCNnyllgHt3fkTSizSwbKExdaD0vj4hR/9lMBu
         vGkiJlhSB9Jh593HMbK1Mq2KVB4+XVxTvmfam3A/BDV2xFMnNCotK8jsDstdDI/i7nSA
         4G3ACWEUAkSnUfoTq0nc0j+Ofqg8QtlfFkDK9ofpnBfiyekkhqxi5gLzxHjHrSxRxBIT
         P5rG5r1RFe18dYTbrDECMqNtANo6pQp8Xl9O//CLHyJyzXER8F2SdkYtYsSAb9xmaPRF
         1ZKL3ulSLiOxUt7XJ4N47PGqyRQm4yFRbRAu76jP1J2MnE5sK2z05qlGBluSAQxFWvrW
         H8cg==
X-Forwarded-Encrypted: i=1; AJvYcCWplwVpKOyL3K/zia0tna/JljFJcvod8Hp5R8SXhEmCM9e+ilMeu817FaXv1lVU8QC3bpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKMCWM4YvANdYeSRvhp61fHefDAvR0m7fivz4jGoAUojrIN3Y4
	YChz5Av5NKfbmEfM2Z4bKCKXsXZ2dS35gacerBCpH+Xv7RHgy5MRWW4oUf9e0tO+qV/YzdUh+hp
	19w7EQzUdwOPvFkxVKVXsCRyZvopIg0Vaw4NteqNPWoDmBLGuaQL40+TU7W8DuJt2
X-Gm-Gg: ASbGncsLROhPCUGtzVxzs6Q+CAvmTVevUq21NNe7pDKi+kIDgpUoXdpoNT+oHkV3Ii+
	Ynu54IwBnJ3CuI5MQ8GMym8wQwaNmtbAVdfdeokrzaDExLabrysxGuHh16aPh4SJsPfepItVLMa
	lWh83hVrzWISIiDMnyAPTZDIi9canF83Vhtr8YN7oHJqjya1PuesU2kz4vZrykbF7HOgQT4j8Xz
	3chCi246UyHZ/DUUMchCUS3/SK4Eyj9mBetNH32yAYw8A7NJKufxZelYCNAKJbABJx0+b71e0A7
	Qm4Kf13P8V4cKPWJsMCCK1DEkz/Jvwc7ZlQCP7JqYCveFfyveNf7Gh+W0tPRLQuQOHF2OmnMmLn
	Vw4HzD92CzhW/9sJRvaDVHcS70a7ef+kOCIlHGUmLJ3FHdD0CZMzUuiWUDNtKQwyxhqQ=
X-Received: by 2002:a05:6000:25c7:b0:3ce:9872:fd3 with SMTP id ffacd0b85a97d-3d1de5b0cd7mr13182362f8f.34.1756914680145;
        Wed, 03 Sep 2025 08:51:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjvLcrw1GI/BKKHqQpqdWRD2zuwbafhFNRbxschxHG7ifowWJiWnizddECBTDKy8c3BUMZQw==
X-Received: by 2002:a05:6000:25c7:b0:3ce:9872:fd3 with SMTP id ffacd0b85a97d-3d1de5b0cd7mr13182316f8f.34.1756914679719;
        Wed, 03 Sep 2025 08:51:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e92a42asm242463365e9.20.2025.09.03.08.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 08:51:19 -0700 (PDT)
Message-ID: <586a6b30-f4e2-494a-b83e-08c1b01b4197@redhat.com>
Date: Wed, 3 Sep 2025 17:51:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-09-04
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <5d1bf8ef-5f30-4962-bbd3-d698c0e9b7fe@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5d1bf8ef-5f30-4962-bbd3-d698c0e9b7fe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.09.25 09:06, David Hildenbrand wrote:
> Hi everybody,
> 
> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
> 2025-09-04 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Change of plans: Fuad reminded me that tomorrow is KVM forum (guess 
who's not going ;) ), so it's probably best to skip this one.

Talk to you in two weeks then!

-- 
Cheers

David / dhildenb


