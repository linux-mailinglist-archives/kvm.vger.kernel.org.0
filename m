Return-Path: <kvm+bounces-29944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F069B4AAC
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B11D1F23947
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 13:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8032B206044;
	Tue, 29 Oct 2024 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="emWEVDFC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EC61EE017
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 13:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730207633; cv=none; b=ow9+m69eLFzqeet+8PJ7sG+oB6jVYlqln+KsMV853Ep2Z64fobtJ0smBxiYBQRWyaYeHaQ+jVvOZit6KvfYQ8VDZ2l8J+8lN4jyD8lvbgnjVCu3YDoYK5lMDpmIeH5jTfT2YG7HEH/+H/OyTPyZgwEqEmG2dCkzvdFIyTeYWZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730207633; c=relaxed/simple;
	bh=E7Ymmpsvnp+B9nV+LiLPL+Crc+05cK/xqzzIFbF5tRg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=CKYuV2ZmlyHfJ1arZuqjRGCy3tubq896pqmWx7oO/O2m22keVqNyZvN4YyWDV00KYQLMLTe6hwATQPcDhJPUoTgLsPsKD1ltlrLH+XnB/cEOJyryGeJycfL7gYpc250eLxFDnzemm5BZVzVJpyFUKnny8fZxLSKs5Kj134tsojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=emWEVDFC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730207630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=0RMNPSaKB0Da2Ywje02E42emCXYXeihKQkRShAoWqjE=;
	b=emWEVDFCBEjrDBdtnAF1sBQw12VC6/Sznu/UNPqcaHMNODlSDMBxXXRx7+1RgyjZzSOFK0
	0rCBbP/iPXfiiONqxYuNask2/z36JiJTt3FMYtlUJMSb3nCeRcD+N61v2h3MPK20OmZXZ7
	fUrA3v704xDD9oxle1U1lOyenGZOI0Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-HBol9zpJN365QCknj49AiQ-1; Tue, 29 Oct 2024 09:13:48 -0400
X-MC-Unique: HBol9zpJN365QCknj49AiQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d5a3afa84so2863865f8f.3
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 06:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730207627; x=1730812427;
        h=content-transfer-encoding:to:organization:autocrypt:subject:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RMNPSaKB0Da2Ywje02E42emCXYXeihKQkRShAoWqjE=;
        b=PDw9wxlgQXUm4BnyvL9g1l/Fsnjo+khntSB7UP21cPKCtl5teAFuC0Gyn47M5L4G/Z
         fAyqJ25xGLdC5sJvA5QgY4eHWx40doORSIl1B59FnWAVDCjpHV/jX0nB6SCJ+DK8A9mh
         HqHuGwR+ojXijNUW5LKDPQnmXQ66m4TX4StbPH7ZNZSd2qv56xljHbiYx1q43Nt/ZP+s
         PoqBVlLlquUJ86WY5H9srKqitYVI/MryfCK2HgSIbtRJkd9dQbRknGDUrgbysJbNFN5+
         ZMxxFlZnhxa7wIxq43MejKdwq/Mf+/iZvuvhRjAproJD7TSFvySQ5Wsw8THlhlgQJgvw
         MPpA==
X-Forwarded-Encrypted: i=1; AJvYcCViyHwt/6ZIc9sK1YPdAQggBpLCX6RlkWS8GdrF8ZNQ+bypbN/NOplPKw8ZR8l4ooXU5F0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaPWMmPbLxCnKdew6fRxiq5rxZ2w89IBRmfgMOTJkg1XCj1dOY
	ve6RULbeLSCBThGdUYr/v9cYYWR0nYylaybhXBhAaWaeV2UZT9X7KIwZWQAesTepMNVJJgqIYEj
	D3ifvvZ/KazYUEttf1QHJXSf9WBcQjT8rGJrDvfl9VbN71gNPZA==
X-Received: by 2002:adf:e3c8:0:b0:37d:3301:9891 with SMTP id ffacd0b85a97d-38061128d37mr8356630f8f.17.1730207627129;
        Tue, 29 Oct 2024 06:13:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAVxpDeSFnLL/OqbkeRL4JE1eK9kBn5puyXagAAxydcuyrYR/8fUfAsioeloZiiLk9GY3MPA==
X-Received: by 2002:adf:e3c8:0:b0:37d:3301:9891 with SMTP id ffacd0b85a97d-38061128d37mr8356597f8f.17.1730207626700;
        Tue, 29 Oct 2024 06:13:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72d:8500:d87a:ed8e:1e80:5a7e? (p200300cbc72d8500d87aed8e1e805a7e.dip0.t-ipconnect.de. [2003:cb:c72d:8500:d87a:ed8e:1e80:5a7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3bf85sm12603189f8f.42.2024.10.29.06.13.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 06:13:46 -0700 (PDT)
Message-ID: <ae794891-fe69-411a-b82e-6963b594a62a@redhat.com>
Date: Tue, 29 Oct 2024 14:13:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2024-10-31
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
To: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the next guest_memfd upstream call will happen this Thursday, 2024-10-31 
at at 9:00 - 10:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet: 
http://meet.google.com/wxp-wtju-jzw

The meeting notes are linked from the google calendar invitation. If you 
want an invitation that also covers all future meetings, just write me a 
mail.


To put something to discuss onto the agenda, reply to this mail or add 
them to the "Topics/questions for next meeting(s)" section in the 
meeting notes as a comment.

We'll continue our discussion on:
* Challenges with supporting huge pages
* Challenges with shared vs. private conversion (e.g., folio_put()
   callback)
* guest_memfd as a "library"

--

Current upstream proposals floating around:
* mmap support + shared vs. private [2]
* preparations [3] for huge/gigantic page support [4]
* guest_memfd as a "library" to make it independent of KVM [5]

[1] 
https://lkml.kernel.org/r/4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com
[2] https://lkml.kernel.org/r/20241010085930.1546800-1-tabba@google.com
[3] https://lkml.kernel.org/r/cover.1728684491.git.ackerleytng@google.com
[4] https://lkml.kernel.org/r/cover.1728684491.git.ackerleytng@google.com
[5] 
https://lkml.kernel.org/r/20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com

-- 
Cheers,

David / dhildenb


