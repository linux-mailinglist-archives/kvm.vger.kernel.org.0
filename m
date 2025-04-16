Return-Path: <kvm+bounces-43418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6744A8B7F8
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 13:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF3CA444D6A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 11:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4FC241698;
	Wed, 16 Apr 2025 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkPTGzZu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED752222AC
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 11:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744804709; cv=none; b=mFB3yCjV//nXpaOHsFkH8E5I2CSdQ3VPT9NC9FlndELcpgBWnAf+2lN2LWtcWnbQtYV1lboJ2pMp/YojuxNCtE5hjmpgcOSS0c9R31g0LZuNnlk69tOmq1AHIZSh9t7TiMTSCZhQsxifYg9vT96m1M1WtJBDqjGRN7rJfouAEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744804709; c=relaxed/simple;
	bh=BH87NPQLzR0N2uAe5RTo9VAQCm7an0kuORRyAO5WWwE=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=K9R6/mzQoqw71MumFXkkEbEEaLbbIM7n87pLmu9JQxK9/rFrfo9Vbn592Vkthpd2jlOlfqBGm9SsvB/+p8t0Jmj9Waf9MJLAAuRnA4oJi6G9MEXXFUJdfpRWvcDfCPWk2+H+tlwBhkIFgGMEKI9PyozjYxd/PfyvpEsXw7pzjac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PkPTGzZu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744804706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=Mp4NY5gTa5O8rModMIUVQJDbbAvIOmyixeqrBhfXZgQ=;
	b=PkPTGzZuYUvVk2c29DkY1WKrMnn0k5WMZRDLlN0DTizVBixYwxR20XmAjQq4WXMpVuDALA
	+rhvQtzOA4Mn7Br6VrNuLZGLD5YUZat6ezO4E0C8sHUvv6TkHGQGTf6wb8MDdFsnZxZaDB
	lJlg+GQs2pZooN6jehtyGhzCvDkEzls=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-t2zprXO9P1y1jERssXnL8g-1; Wed, 16 Apr 2025 07:58:25 -0400
X-MC-Unique: t2zprXO9P1y1jERssXnL8g-1
X-Mimecast-MFC-AGG-ID: t2zprXO9P1y1jERssXnL8g_1744804704
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so51948865e9.1
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 04:58:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744804704; x=1745409504;
        h=content-transfer-encoding:organization:autocrypt:subject:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mp4NY5gTa5O8rModMIUVQJDbbAvIOmyixeqrBhfXZgQ=;
        b=b0aZw7k2Iidbj+gchTtpk9JEhJQ3gcCJoFEggxhex4F9e0KK3IPUdKg3TdCjq8GlSg
         KtgEI4yt32Ni5VYNKnszH1/27J/4z0T9XIT9euiVcFE+zicCu2/YeesrDDD+WRAihm+s
         4/sQGGhdW52v4+GAEi+Uynb7jpwyKyosTtNYmfditT0OkAEi6wpVP9AKToF4dUdrqhgO
         bRT9cmMycu1s2m77oi57CN/YnqQiAil1DDJ4XMJqQcycXRD082OuM/F/U4Tuel5jwsYF
         fqEf+2Y833wY5YNQyGwb9KmV7h2EMqQvUsgWu14uAfc8bsiiuGF8IrYvcuMEBKB0H0QI
         4VLw==
X-Forwarded-Encrypted: i=1; AJvYcCWyXe0NwsahYCMZUFF8FL3dlHNMoKDT8Lmcgf8Ev6sMJl76ubBRnoG7HBY+M00btn26iZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDbR3+5w+VXSuFVweuakdIbubJQlUkVIypq3zuts3/wjAetyg5
	RbKKZtVfy9q3a8ClCKSmFY041+5RNd3/Ufvojy0/zV8LrbKTLB+4MMCrnrhpUqDa8qaw5X8oAhL
	Y+HgN5OMfdmXx8dyCJdBrhIqq/aL7m8EuhtGW4RIrJfGSrht8zQ==
X-Gm-Gg: ASbGnct1ocVmVjo/PVMzk0JMQoYiPniCnvhA5FMSwIj+L3jMyvvf1OtkXTPU9IDGIlr
	OzUQV9gPLtA0tBT3P5fmrK2+ZmKuwM3XfvSM1HTtAFFvy/h99AelKOzCRLgadnmVI09e7pX6n/J
	Ax4KUvRkKPSaLsBgW0UnizDhzKTL/nS8XsOxx3G2A1HbjwaDCX2FMfKzJXL01pjKpkbvXgD+/0/
	ZY3g/U2tf+AoWl3NMnqMgbSzI8h3Vw93NM623K0WKkfMjbL3WEQZ5VKRdDNU23GN6RTbKfOQhxp
	L86j7d8lIsg7pGe3GGjGAwWt2XV8DyeOj9o/9Ue7JiTGQeyzwyFj9+7UyHiP7sygO1ZjcYswdIP
	2pl9oiomY+0BZf0jfx5Iu4nSpSFMPjNezTtNHJQ==
X-Received: by 2002:a05:600c:198b:b0:43d:45a:8fbb with SMTP id 5b1f17b1804b1-4405d6ad1acmr11673985e9.22.1744804703816;
        Wed, 16 Apr 2025 04:58:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF42Ew67th6BgNrQ3pNAl8Tem0TA/2gNSdCc2h3rozeMrLIbvkPdcxVAaqMMafRphJ7MSrRjg==
X-Received: by 2002:a05:600c:198b:b0:43d:45a:8fbb with SMTP id 5b1f17b1804b1-4405d6ad1acmr11673695e9.22.1744804703304;
        Wed, 16 Apr 2025 04:58:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4405b4d11ddsm19208935e9.9.2025.04.16.04.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 04:58:22 -0700 (PDT)
Message-ID: <971a3797-5fc4-4c7f-a856-dca05f9a874e@redhat.com>
Date: Wed, 16 Apr 2025 13:58:20 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-04-17
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

our next guest_memfd upstream call is scheduled for Thursday,
2025-04-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.


If nothing else comes up, let's talk about the next steps to get basic 
mmap support [2] ready for upstream, to prepare for actual in-place 
conversion, direct-map removal and much more.

In particular, let's talk about what "basic mmap support" is, and what 
we can use it for without actual in-place conversion: IIUC "only shared 
memory in guest_memfd" use cases and some cases of software-protected 
VMs can use it.

Also, let's talk about the relationship/expectations between guest_memfd 
and the user (mmap) address when it comes to KVM memory slots that have 
a guest_memfd that supports "shared" memory.


To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] 
https://lore.kernel.org/all/20250318161823.4005529-1-tabba@google.com/T/#u

-- 
Cheers,

David / dhildenb


