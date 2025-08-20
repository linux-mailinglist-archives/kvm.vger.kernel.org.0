Return-Path: <kvm+bounces-55135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13643B2DFF8
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E1D685C36
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D2B320CA1;
	Wed, 20 Aug 2025 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OnirXp4/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF9D26E17F
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701423; cv=none; b=N6aw+sxUn6M19NkrFkWgW8X/nkpO2Pc1xExLbUHvTgMeb5KYIqkz+md5CXK5/eRkrABmFg7OVS3p7EoPUq5uyhHQfQvwdfwCcC/f1FpUCyYYGzyYI0VTPrt2FMxwULFZ1EkkrcLaSyW1JZWSrlNygEaZ3vWU14LNz0ocHni/g2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701423; c=relaxed/simple;
	bh=tvnQ4mm+tXZeMk9LeMz2m7m/7OzfKG5aXmHoWDxySPM=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=S1ZICG5q/JrBN5jZ6SYFQopANM54kWMYrneTh3T80X9PTZm2769BkaVDMWMEYnqA5E6Bp7vbiljCossYmSyuXT6vG+nFquOVsSz6umMu3ynv2F9mXTFUqmaGNjho7fdAX01/ruLKgQdINhxom5n8h6WA4TxEeZ/D4/1dCy0hglc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OnirXp4/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755701419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=UVDesp2YzkDiQhPhj3wNDxcGmY+ZKVXe2qM+mIpLJuQ=;
	b=OnirXp4/P0tQc6JBHr7lK1CC64n4RwVf65ecHshxvN1DzR1yT1InZ7A4usSD68oyNPAEXw
	40q9um5S2fGn/H1h2emfgSIPkuWg35WgdP3TKxRiMFkhrgnCFzDU6zL/7mjYPV0pqQLRWu
	vLuwU07VmI5oCr3KePYYh2mi4yrZVO8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-2Lo7VMJAOsCGdxSRY-mwmw-1; Wed, 20 Aug 2025 10:50:18 -0400
X-MC-Unique: 2Lo7VMJAOsCGdxSRY-mwmw-1
X-Mimecast-MFC-AGG-ID: 2Lo7VMJAOsCGdxSRY-mwmw_1755701417
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c380aa1ac0so8146f8f.0
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 07:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701417; x=1756306217;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UVDesp2YzkDiQhPhj3wNDxcGmY+ZKVXe2qM+mIpLJuQ=;
        b=OmwYMiiJxjItHdjsoTF3myOPBiLsSP+bNcGLxJ/xnmziPhHmy0hWcT1XhXnCeM5MsD
         /k976MSDJ7NpHZdTnTdMT7WhqcBKDr3N9i+AIbBZ2U5mBqNRP83pk974iy2kT8fyCCfW
         b9CHxZTxT2kAbZNfzRoFAtWLAt3L9R3VIBGlyT5EPd906xnplQcQH2IHHEI3WwnDGW3y
         TcCLT4b4SFsOgTJMwyrJExQYwk4jl0iHlQormZ/vIYpi9oTyN7nKoc7MzlxNm4F+FL2Q
         ttLh/U6IXmDf+difVuoTxiaBDJQnvHz+rxQmCuDDLIE+VmWB9WaJVJWl+Q4LaCEAWP87
         18+A==
X-Forwarded-Encrypted: i=1; AJvYcCXAUbQ1zyFQNlwgwLsu6Cj5DHe0ybWKgsg5Y9ksW3zOLxVxgeEMzrbD+aCKvzy7HoE4w1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkVKRmihMeFeOBMW9L/XM7XgVS95CXo8ZiuJx3C/pQn+vtJIm+
	mFbKc6hwvmGSxvu6VvOPfG9deX5+iLdavXOPcVJcQ9M5bYgHMd+6RL4E5pm8t9ynpn5EhEhiqRa
	+NLYASX/R/bc2uEbBjTxD2G1udKfmIg9bY+aKuZOFfasQY8zecaEwkQ==
X-Gm-Gg: ASbGnct6CLFdWu7c7ERI1De54TDlBvx8pJrkHqqmMxXFl0g1SPfFsORcTL49HDjMW0b
	mWFKa4BFkbMzN9WC/ilhQufmiv6CzJ7pN4izFZdaTIADqCl0ukXWt6cB3t5RrXCXOgsyaQUU1ME
	ukeutLVeE4B0MA8sSt+/XfDZ2ErbAmVabE2jThk+obLjxoH2NseLpgxqTfwKj9Cdssjf/S2g2LQ
	ul7ZgZO22qxikDWBUZThUr03szD3YOALrDdaEwy2XdeB8rGpioZYOPptheRckiCShYOTvdtPmt1
	DrB4Oqw2T/o+oIlTO8YRkrNDJrEA71bJc3gBgKFRDm1z7/iY+/CEPpQ2JiR2UmG4kvvrrAHqM2w
	g9o9DDV+nbSXvs0zR3E7XLx2aGrSVLnErPstigpjwnn/e6hWhYgiuWaum4fV9vn1c
X-Received: by 2002:a05:6000:2282:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c32f664611mr2236127f8f.33.1755701416877;
        Wed, 20 Aug 2025 07:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMpI9AfBVahnq7+dVkf+h2VoKoGyjqGXGgZgTRtEbKx9O3Qm4CSoB+Kss7RoTy7Q+a4bVu1g==
X-Received: by 2002:a05:6000:2282:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c32f664611mr2236098f8f.33.1755701416229;
        Wed, 20 Aug 2025 07:50:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f13:de00:e9f1:62b4:5bb:5d83? (p200300d82f13de00e9f162b405bb5d83.dip0.t-ipconnect.de. [2003:d8:2f13:de00:e9f1:62b4:5bb:5d83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c07487978bsm7822833f8f.7.2025.08.20.07.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 07:50:15 -0700 (PDT)
Message-ID: <2255e387-857c-4b5c-b27b-f7f2a6bcaccd@redhat.com>
Date: Wed, 20 Aug 2025 16:50:14 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-08-21
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-08-21 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

For now, nothing "big" on the agenda yet, so we'll see whatever pops up 
(I suspect discussions around huge page support :) ).

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David


