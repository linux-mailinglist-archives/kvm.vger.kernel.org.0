Return-Path: <kvm+bounces-34761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB08AA05889
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D5CE18820AB
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 10:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FAE1F7554;
	Wed,  8 Jan 2025 10:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZD6owYr8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63261F8EEA
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333130; cv=none; b=cE7fxDNajNqUmRTabFqa9StW9E87a6rgrliTIp73zGCYVjl4+fHXxbUsCT9+tqPwo/LRwHUQmCmkyS/SfiOIZXZ7elRM8yre04CtSvdbocYbytaIGGVWnpBLWUPUoXGYCrOh4awcnhwNMGIGz4DDTS2lpyNt/BcbPDdl93LgZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333130; c=relaxed/simple;
	bh=JiugvDAAA85qhwFmwtsAyrdf2/LVZ4u+LHjiQRMr2PE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=CxJpJJ5JVuSK9NPq5HIWKn+8gC7Buwc9/xv/TvgpK+69UngWE8eaGRe2sDmaSoiUxIABvMQiiDq6mitb8RjWvymiWUbJIbiOMKx2RbbYUw9/qQH+9b4qlatPQkrfuOjTPjZm70gHccv1dwN7kwsP8hVXzOoFJfL4rag5H0Rzlek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZD6owYr8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736333127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/KQBymtXDLNx5d22xwoamuR2JCGgbN9RBDKmSHY+brU=;
	b=ZD6owYr8HWA1iv3veVHksMgyZkC3ftEz+DVV6f/0zVDj73tzMGDX3SYgFT7lwTqJ2NV6/5
	6dq0yjDw9Bw2SQrFyCc80Jb/6zw1m3mmCjMuB4qrLmOMgc7PrB17eeBZcxLzQWqkswsx5e
	VTpdGPSLgEAUkSOup4n/sIGhO6zuf5Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-4au6bTUsPkG4h8AdoLL8Bg-1; Wed, 08 Jan 2025 05:45:26 -0500
X-MC-Unique: 4au6bTUsPkG4h8AdoLL8Bg-1
X-Mimecast-MFC-AGG-ID: 4au6bTUsPkG4h8AdoLL8Bg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43673af80a6so110187065e9.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 02:45:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736333125; x=1736937925;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KQBymtXDLNx5d22xwoamuR2JCGgbN9RBDKmSHY+brU=;
        b=qGHYgsmOuQ9j4J7Be99b+jOxtf9VxIGy6X6WH1hXjNTOsNlheLDuclZ4uQKHS0iemE
         imyfygupkVU+uDRxOF2w57s4cLJOCTMrE8O8K19aOLWlxyZ8dLDvbhKLMHC9SA2rYVef
         IpraAQUBbgwVjLBqbI9uIkLiDy9flIyyyf/12LYceNI6Sfm+RJLfM7WcOsWGHIUbtN7C
         oZmnp5CXUUdY29b6/NaXaJaxLV6Syw3HFAMt2y3qYOs3PnSSpnjOPjaFlrVMG751Oplp
         YhahLUQAKy+J9sZZ6JTlSOfw108fVd1+6A6rmuGPW9X1JDHMrZVGDwTpGdgTMdyWwE6O
         TcqA==
X-Forwarded-Encrypted: i=1; AJvYcCV2nGjBb3w52zLtKRACkwdWuOHdaiG93HkXgQwtGR18WKe8t5Mf3gEmEmQJQbCD1QsXkWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCYVeBGrIDH5u+y+PgqaH8oTV48UiOisp4K5b7hak2uGgayZ2u
	LWQb+gzLbwwSu2luBfKt9XKpNRvOwOE/TuZlDzuyTBAu/03NGvRNVLW08vVw1wuhhcUJXSplPXE
	TM3uCcN8ZEB1iayuzqzdHpNAw1Ly4w1JUMO3Z8QZfxGRk3/cqNA==
X-Gm-Gg: ASbGncu9we9Ro76CjDGtibAeL2WrJfduqNr/tj2It1DgVej6W9OPi/1iG+D/7bbwe3k
	qbtnf3h/9k6zB5b/ZTD7G1jbbChzwiYL3GWxlCCE+GnhhiZ4Y3+balzStYn0ymvBb4hgGaV3sYY
	v1UUmG/CoXitGvRnfVeaWNRuLeb1WiiLo7CqrqetGiPxUr8zmENklW6VJNNSRlgFJDtOR5ZXi0e
	KWSEGNORFbKPd5vfvYZ5hgTEnBYwTGgSzrXz7z7DoyENMARhFViPIot/TGI/IOwg/Q9zFG0hzqV
	wPI2NA0rhNmKu9gfJh1HKBwDjjPxdpuZZzScC4YlHoCFRDdZjkBgVJSf3iAcbJlR9vWSInEYVs6
	VyLPwoA==
X-Received: by 2002:a05:600c:1c87:b0:434:f5d1:f10f with SMTP id 5b1f17b1804b1-436e26cfe50mr19195175e9.17.1736333125023;
        Wed, 08 Jan 2025 02:45:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH914shY9ADO/VPsI2UouSF5seu5UhG3vdUwstpLjiL7ferCzKbZRcGgmbRhIrbRjiS71AjLg==
X-Received: by 2002:a05:600c:1c87:b0:434:f5d1:f10f with SMTP id 5b1f17b1804b1-436e26cfe50mr19194725e9.17.1736333124432;
        Wed, 08 Jan 2025 02:45:24 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436dd11ddfdsm29945505e9.1.2025.01.08.02.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 02:45:22 -0800 (PST)
Message-ID: <0733555b-886e-42c4-ac06-fbd0a324e186@redhat.com>
Date: Wed, 8 Jan 2025 11:45:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-01-09
From: David Hildenbrand <david@redhat.com>
To: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
 <3a544ba8-85cd-4b91-940f-85f6f07f2085@redhat.com>
 <b9567cbf-8ad7-440a-8768-f4e7dbd2b5f7@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b9567cbf-8ad7-440a-8768-f4e7dbd2b5f7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Happy New Year! I just returned from PTO, so I'm a bit late with the 
invitation ...

We'll have our next guest_memfd upstream call tomorrow,  Thursday, 
2025-01-09 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

We don't have a lot yet on the agenda, so maybe this meeting will be 
less packed? :)

In this meeting we'll likely talk about:
  * Fuad's updated "restricted mapping" series from 2024-12-13. Hopefully
    Fuad can give us an overview :)
  * Michael's 2MN THP series (although Michael will likely not be around)

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


