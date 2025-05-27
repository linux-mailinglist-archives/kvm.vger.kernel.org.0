Return-Path: <kvm+bounces-47788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55094AC4EB5
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 14:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12F06189EEE7
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 12:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC414265603;
	Tue, 27 May 2025 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiMkfqH+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA272CCC1
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 12:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748349182; cv=none; b=Xv/Vr1yLjgDwKXvDDI+wvxZBLM5qd/m7m9LOiJLhePG7PsV6OzgzsEGQ59BBvc7VCgd015P/8akhvlHbwZ1TZj28UZA4dUfkmy5kZrg0f0HeJpgp4la+gJHavvhxbZbgg921eShOiLCqqUnj3sosO9pNBYysTzkKkNlYmSedeY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748349182; c=relaxed/simple;
	bh=tSaqhl0rxLhhiPMq46R4DMsAx8zjBsBm4mhI/0YTM1Q=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=kemrOkcxmIhU6xoqmdf909OIE9CKR0WiU0vBl+csZRNKuFrHgeuz5jT5u2WeSmkFWv7XIL5OFiGjtlOZHRXMBiCfxRjBAahU+PiLQWeduIL8ZNV2qMU4DjWMeySoC45qOiDKS2J305DaD+T6CaN5rrcBcsvHJOcx4MmIanhx4i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiMkfqH+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748349179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=/kPxUbgLr47CQ3MfBpzjWpRNVDo8L5yJjWAGTA4uxZM=;
	b=fiMkfqH+aR4D6Fy6pN3nLFsOaCddI6aPWzT5rNE4YAxMFE/7OsoY3dImSe12FmZYEyT7WV
	36K7AHtv6IKwQB4Oborm/ehSIJ4XC6ci5iBXW7ow2P8ZhlUSQSR5zTJDs9kfymn0opTkAT
	YJT3E4ck8aVrHzec3DSpcFa8bGCLKlE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-MYxLQZNOM42KyMdJTEzXlw-1; Tue, 27 May 2025 08:32:57 -0400
X-MC-Unique: MYxLQZNOM42KyMdJTEzXlw-1
X-Mimecast-MFC-AGG-ID: MYxLQZNOM42KyMdJTEzXlw_1748349176
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a36e6b7404so1812767f8f.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 05:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748349176; x=1748953976;
        h=content-transfer-encoding:organization:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/kPxUbgLr47CQ3MfBpzjWpRNVDo8L5yJjWAGTA4uxZM=;
        b=sw1neEKaBQ5/+PVyUfvjU8pQV6iEoj4hjpqECOR/mwcTv02t8WPwkGZYXlCKZsqF+k
         zequvlRFq5gksFHYeK1zl73hqsbt5tOoZdY6XT/SEWVeifR90XNAA2I600e5BqSFAGJA
         5o8o2JeLSsWcNjobdAqLZ2KP24h7UPVOJ2X82hmwVIcVDKSicxkmmhQSx7MDY6bEcG5W
         GAu/V6H4BcpKkJplkU0j9416FZjhpzCecDx1JOD0fXxlP3EcFmyweU2JnHlWFev7dDg2
         BKHf66aFTHgeC3lfOX6NFDWMjUUHbqZbyPAgsMfD8YQ5yfEDOiIyJLhScerli7+XMWXD
         p6UA==
X-Forwarded-Encrypted: i=1; AJvYcCWvwgUrMMnYeBD/0zPnG1FTqOIhYDXCyP3ojfR53f785Om+lwrQNAil8jeVJs1LtodoW94=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUdMkvVOsHeJXrB8LIr05W9hfqYvJLAJdfPZkzaORoHbhkBYPh
	umXEvE+ZAGsHHEPihBHN0kRwC6Udoj0dbAv+P0O0NR7lMPpTmMROW20jFRGTrkHYkxAe7gBtTvW
	vLAmyThyuaCT0mvB/i5KIKH1Ri+3Q7gdLx8EqxXiIqnR/naRmvPWNtg==
X-Gm-Gg: ASbGnct5OJO0MbsDeSdLhh4PGDsOKjS1xh3BmT7KZ8KbBqfMlSbEoNOESR/QaXkGuVG
	1G9lfKzLZngswAwEIlNWs1b+jTAmB1sO0SxzRZ8Qkga21MwFIBjkDmFONBS5UiqDvQcvMCUGXAA
	8Y9wZVdDQmow4fFJ7O54coGd0Spt7kRlzQw54XXUtrUWIejv2pF/8cqDc85Z2ZiQSiB78dzgjLs
	zDqlZFWHsBIydjgOtSIdInjfcOA3MymtuFHUqxkKGAk5BdIeRzSlpBrq3aKwcTCD1MSgFpD7Iqx
	RpCzhM/CcLsc5BqyxYSjTvDcyqVU9SBGckePjMyjRSnM
X-Received: by 2002:a5d:53cd:0:b0:3a4:cf10:2a2 with SMTP id ffacd0b85a97d-3a4cf100d37mr8031533f8f.11.1748349176170;
        Tue, 27 May 2025 05:32:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH74QTlH8BBYgUsfFMFPNYiMSjE1p5/YCiUV+wmYxSUc2meTCS5kkTmQp7vI+MAgBFlG4FD9g==
X-Received: by 2002:a5d:53cd:0:b0:3a4:cf10:2a2 with SMTP id ffacd0b85a97d-3a4cf100d37mr8031481f8f.11.1748349175603;
        Tue, 27 May 2025 05:32:55 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f7bae847sm262697675e9.36.2025.05.27.05.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 05:32:55 -0700 (PDT)
Message-ID: <a2e57221-751a-4290-a8cf-cee0be537dad@redhat.com>
Date: Tue, 27 May 2025 14:32:53 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-05-29
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for Thursday,
2025-05-29 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

I have the following topics in mind:

(a) We'll continue our discussion on how to move forward with
     mmap() support ("stage 1"). So far I assume there are no big
     blockers.
(b) It seems as if there are some discussions to be had around the
     guest_memfd conversion ioctl.
(c) Likely it makes sense to talk about the series "New KVM ioctl to
     link a gmem inode to a new gmem file" [2], particularly, clarifying
     the use case and how it might (or might not) affect other related
     work.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

Cheers,

David

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] https://lore.kernel.org/all/cover.1747368092.git.afranji@google.com/T/#u


