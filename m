Return-Path: <kvm+bounces-42398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A321CA7826D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 426A316B1AF
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB1E207DF5;
	Tue,  1 Apr 2025 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVHPBpPL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FF41494DB
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 18:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743533204; cv=none; b=qg9vdkkSXzEoG+KfFDV7mvbYXjmVLKSXLV53Ed2/1XJCJjHFGrzRgvyLRoUPqLSynfoSa4CKl1/aEm8sPRQvsZzk5hs1FlZsayMC6x7npOk+M0bMZWo6IvfbJJEsXGxbAFLsIUrUZWwgvBbokoxazr3wJLQeD3Mk/y6kdj8zHLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743533204; c=relaxed/simple;
	bh=8B6oXazQXaV9pPAnx0jd+2XsiwGquDdkeqxctviJA+A=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=Xb5YiLOR7ZYQFawZThxXuGHjsMsKn9cAp5bUAeRKRuuTiV6pRq/tw05LTzWeL3/m/8haUVoW9jrWeln9uli6SbAOhO/8IcmRFgvhoFFtIrnYk14maRbxr9n0baggpSDCFVSuxyiwvzE0qrDcdQhqzuTRGFVrUN2gRU/awQzZ1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fVHPBpPL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743533202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=kKK1Qrzxrep9nFQ3mmefW/rXw3H/O80pMYOoU3NOBSo=;
	b=fVHPBpPLHgwDmZSbQ8JB161larC7RfodLsM6yaMPyXDF1PmMBrlyJPhTM393NO8zpKxOQ8
	CLWnjRq1EhsNgZKGLDjOlaxkWBdA5lFwXPSYukFItmMw/fS8ISXCt4+daKkY3D2cB2VeBZ
	H7dQBhGswpcdwYaQUMC8QDDGwtrwY2Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-MIBUSw7zO4iDwKNma4oqKA-1; Tue, 01 Apr 2025 14:46:40 -0400
X-MC-Unique: MIBUSw7zO4iDwKNma4oqKA-1
X-Mimecast-MFC-AGG-ID: MIBUSw7zO4iDwKNma4oqKA_1743533200
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912b54611dso3145607f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 11:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743533199; x=1744137999;
        h=content-transfer-encoding:organization:autocrypt:subject:cc:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKK1Qrzxrep9nFQ3mmefW/rXw3H/O80pMYOoU3NOBSo=;
        b=DtSZM3/AlF1re711YoD6gkDy7gYJb15qqz92osBg9RohZk7duyuSm7pyaaryDqtugE
         /KPOhYeG9Yeyy31ttp7QNdg7aOn078UNBhzgXbln+mF+G/SZREWO0OU+412k0ZyHYGuO
         9SGyzkPem3u+sznAFCWaMMMiUM/Ao1s3IvWk6kBnVYAg05SEiHaHp5Fpmck6TNKF+gfh
         4z3UgHdwGch4B9rAiLmC/1d8pxkFBwO2YSF4MstFOzpG2ldwbexmonhKMlI3EPtcyZGA
         WrbzMWWUYNwGecH01jQqMyCs1ioOvGvxjKevGDPEd2q6HPNrQLlT9IBja0AmYM8UjGKx
         q5Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVFkio9r7pf0YV8nCsnJj78/Z+Y+Ugh//lY4K8D+bJM5aAZW/mBrpcf1GKQzo0LqxUvEbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMfJP+MMgwi8yN6sr5L+1G7HZLMv02TJXl8fdSZNi7D1uB0SKu
	A556Iji3gWCSGAueByQIBB6v6ar4CoAXlGixv0sUfBx/e9vrRvu5J7uoUtfJwc70eYJ0M2vUVDA
	ZCzT8rDhhjh2LTlT8EmWfFY/QrVFbbfopKNsLtxXdEXGkRP+4GQ==
X-Gm-Gg: ASbGncuNSzoSRIuVJLlT0u9MfhuEioIQijrfC7nzVsD4xkxfxBMbwE+pk9dnGW4hHBt
	cflrdYSTiQwrc1rA6tofIOWgKNnoFqj8qIiHXwQQ2bP1klfHrn1D+GSJaKzU065sydeOGBuXsmw
	UakY0WF9qJ20S5OdVv/J2JH4hIGzmB8NLDuhVvZM6jB/HpA5DBBb5Jq6/Q6vlbbIXLL/GPGBkTD
	4AWRcMiw7x+Om4ETvbU+7dMBf/c9S9Ypx86ji68QV9tASdx7d4N/ObkgKbI9qORlu6nGeXP5MXP
	E38e5BslVIAiqm3kNA9eNl6nNNdS/mzlNE109FAm2PG3hA==
X-Received: by 2002:a05:6000:1882:b0:390:e311:a8c7 with SMTP id ffacd0b85a97d-39c120c8ddfmr12512789f8f.5.1743533199443;
        Tue, 01 Apr 2025 11:46:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIWn+7qndzlrQxqALUnPSOIr8UBsZEgSJxrYPbKOl0AEFKfLH3IIGslkQuztfDQqSz4JiDPg==
X-Received: by 2002:a05:6000:1882:b0:390:e311:a8c7 with SMTP id ffacd0b85a97d-39c120c8ddfmr12512752f8f.5.1743533198871;
        Tue, 01 Apr 2025 11:46:38 -0700 (PDT)
Received: from [192.168.3.141] (p4ff236cf.dip0.t-ipconnect.de. [79.242.54.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e12bsm15067963f8f.62.2025.04.01.11.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 11:46:38 -0700 (PDT)
Message-ID: <7b3090fb-1816-4761-a7a5-17d49a050645@redhat.com>
Date: Tue, 1 Apr 2025 20:46:36 +0200
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
Cc: gshan@redhat.com, ackerleytng@google.com, kalyazin@amazon.com,
 pankaj.gupta@amd.com, papaluri@amd.com, peterx@redhat.com,
 seanjc@google.com, shivankg@amd.com, tabba@google.com,
 vannapurve@google.com, shan.gavin@gmail.com,
 aneeshkumar.kizhakeveetil@arm.com, ashish.kalra@amd.com,
 dan.j.williams@intel.com, ddutile@redhat.com, quic_eberman@quicinc.com,
 michael.roth@amd.com, roypat@amazon.co.uk, suzuki.poulose@arm.com,
 vbabka@suse.com, yuzhao@google.com, rppt@kernel.org, jgowans@amazon.com
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-04-03
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

our next guest_memfd upstream call is scheduled for Thursday,
2025-04-03 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, I'll share some details from my LSF/MM session, and 
we'll likely talk about the folio_put() callback and how to maybe limit 
it to only specific cases (e.g., handing folios back to hugetlb after 
truncate).

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David / dhildenb


