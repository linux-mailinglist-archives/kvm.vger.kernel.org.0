Return-Path: <kvm+bounces-56672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A310B415CF
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FDB31B256C2
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 07:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B952D94AD;
	Wed,  3 Sep 2025 07:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IS+gH1to"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EFD1F92E
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756883192; cv=none; b=u2FclGCZFZkHn2hr9oWzwmlmF2Vs77LNx/bn4dB66CfsAAgukMnfmbL+j5X+4g4ElVmUfXYoBdtGIFJKVpKspaMzvvOPPP3QqD/vLzCMSEvGcn7Ctf7B+Othq8hvfCJZGATeRAogvF8CeFcNFKxZ10AgbcMaECybEo9ZjR3VT5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756883192; c=relaxed/simple;
	bh=9lzmYu0UhdH9x6Ij5HiUFbfAcV9RFXPgLIe2VogC7mc=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=ggpqY3sjWfsGdt653aYfkU5dFwxjGnjdQh/Ui/L5wd35M8HkV3WgYhR0K2NdZrp4ijKebdV5ZbosP6Np2AoqAFFc68llzogpd0hnLFk2vId/DUUuaUDT5VQmBtq7LGopYMttU3h6pHeH3sRGvVa5aERe4cQNQr9NDnLd/yeqz2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IS+gH1to; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756883190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=Y+D9yxWlv3zb+s719T1nYvszUA6hn5AyB9vVNM3BJTI=;
	b=IS+gH1tocv9t/Q8hIbETU1xakH1y8MokvLJRDGPRCTs+u5VzskVg64/5Nvl4hruDQOvLDo
	dTkmz7WF2ZpOkgkBgD1FGNMveTZfs3IQNfVK/xRqCnbK5VJgmI5bYSegxuFRqvI4Ya3Cnk
	JWfDe0y4OeWDsTarc6SkAi1CKaSH5yw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-4X1Y9d7LM_u74DTMygX2XQ-1; Wed, 03 Sep 2025 03:06:26 -0400
X-MC-Unique: 4X1Y9d7LM_u74DTMygX2XQ-1
X-Mimecast-MFC-AGG-ID: 4X1Y9d7LM_u74DTMygX2XQ_1756883185
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b9912a07dso7995865e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 00:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756883185; x=1757487985;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y+D9yxWlv3zb+s719T1nYvszUA6hn5AyB9vVNM3BJTI=;
        b=d9F4UtYQj9Aqzv0pwjyNxv62Cs4kl3LpRwuYWCJm/rOrXrAH/wpOOfv8XfWDQrVCNz
         dj8s+EMjnKgebgczCriCMmYIEwSOtv8JlWnaB8QTeMy5aQmehmBklw3EkX7mODFeGzWb
         GodIxvT+/lVNqKh9Wh30xTC2y4lpFNAMOycmzIj57hOWUFiwfV2FdK3V1GCYO3rbNN4p
         PgIJdvxHdStHmkSEjv205QX+DInXU/xCIeHLoS+pt3Z2SRTQ9vW4uJ3go/wdcI254W6k
         PgDZCtBz+DD/Q5ebaQtwrA0oQg51NKt7Uzt88pJ2QO6/P8M5neEQbIrakI2ewNDy/bCA
         SQ/w==
X-Forwarded-Encrypted: i=1; AJvYcCUadvuGMng4SqruFTvYZPLpVERnGtOeVKnOcCnKf51wXQLcqJwg/2Vv3TB69jM5KOeWvHc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7gukF7EXHOg55rjwzheMzkCaXRrIC9Q0MiA0AL1pYtkDpDAw+
	YOrgMXO32ZWzMeirvHvrIeHoqBX649o/jG/XrL1FK5RUjqGOONaCF6vMrJYKKTke5uEzwJfuuHn
	jiGC0nf1CP+ZMLCyu7k7j4/JCyCg7Z1+k0LsdXlF9fbv6JymNG+MfcG4hm5+L54R/
X-Gm-Gg: ASbGncsSmYdqQ1wVB19p00/m0JOfnjkDW5/B7oK43vkyl4eMxNE9M6ot2KuCnUut1HY
	SjxwW5u113ZK6wITXxfi6fuTHmOzGRDdR0u9DAxpeghAejP0Gb7YC56WfLkPhrWaWGgnGm5+gYx
	epG07J9u03XR2ocKU20GQ1Wn5OlrI6aW7yKNNP4ciRkYqxtim6pTLUg06QZsLQnBfU/pGLOEYM0
	j563ExQw0DeRJ3OQLeboIxZ1cdTHVVC+rAwy2ZZwmPxzQ5bcHlamOXVzL1MURJBLcrjtIsT/NC1
	GSSsAodfsao9FtFXzsxBXlDvEwCBmreMEelOOEvW3x5M7mkkEbUENPlaDQFPpC1svnvYu/mrDw2
	FXrWC2+sV3Zodek9X8ai37fypAGKxiCNl1k5q86a7J260E8XhcqCivTxfkM526rlH4Hs=
X-Received: by 2002:a05:600c:c04b:10b0:45b:98d4:5eb7 with SMTP id 5b1f17b1804b1-45b98d4615amr24361185e9.18.1756883185150;
        Wed, 03 Sep 2025 00:06:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpb9iES46gU1k0+ZA3uuV/BrR4IgrWcnRm7j0/2AFuzurkhW8jQEYi9qDtb+tVBa+08wt9oQ==
X-Received: by 2002:a05:600c:c04b:10b0:45b:98d4:5eb7 with SMTP id 5b1f17b1804b1-45b98d4615amr24360835e9.18.1756883184533;
        Wed, 03 Sep 2025 00:06:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d1319sm246236485e9.5.2025.09.03.00.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:06:24 -0700 (PDT)
Message-ID: <5d1bf8ef-5f30-4962-bbd3-d698c0e9b7fe@redhat.com>
Date: Wed, 3 Sep 2025 09:06:22 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-09-04
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-09-04 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

I suspect that we will continue our discussions around "stage 2" and 
whatever comes after that :)

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David



