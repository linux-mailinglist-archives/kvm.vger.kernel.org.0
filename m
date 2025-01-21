Return-Path: <kvm+bounces-36185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7717A18634
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 861731635A2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CD71F7902;
	Tue, 21 Jan 2025 20:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8pamnqp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F11F76D9
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737492125; cv=none; b=FrPiHPFuREcehpXL22uc5sm+oovAlIInNNyv65iMtral3rZ4mq6VXogj+0JPHcTzlpBo04bodGxT/Wuza4H4JhfS/DDs/QCV+2gska4H6OCEr6dwyMcwgQ356+Q++th82YYrtHlM1N9S2PYk1uXYkOx7UztFHnQfZqjl0cj35i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737492125; c=relaxed/simple;
	bh=ZZh7AVYcQE5iGxKtNwYg4YUc4Aql+FSN+h9m1yU7RWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TIdq5WaQDvoZ/YPwdpg7Z3g2Fu8YFLTnzWaf7ydbZ5Ba8CkKqVWcYilqLuiL/3YAWver8CDT6QDxc/KAifbVdsf54LdoxHi9pBRHxwNnC6Yi4XRn+URru7WmlZjLSKso/qRkNlzc0XUwiuupGDZZzVBos8RZPtXgm675YNIGCEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8pamnqp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737492122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bV+nRwACZuxKEgybFrFqH2UzM+9UPRa+IzmD8p7kJqY=;
	b=b8pamnqpR6LeXMhBpT/F6jCwAzG4wjdqMyib1LtxAVfVzqKXqCY/tkXA4Z3bkjBQ1N36R/
	2vAAaK3PvwcJXxGnQqPVvq032HzD0GIOYeterF5uvekICk2huzaHWrDnC+BgeITw7kopZU
	YTLcjMAG1MR54zOoi8+/yvBsTawWtzU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-BpYM1SH9Nxy-pTyVJB-4vw-1; Tue, 21 Jan 2025 15:42:00 -0500
X-MC-Unique: BpYM1SH9Nxy-pTyVJB-4vw-1
X-Mimecast-MFC-AGG-ID: BpYM1SH9Nxy-pTyVJB-4vw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38bf4913669so2441597f8f.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 12:42:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737492119; x=1738096919;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bV+nRwACZuxKEgybFrFqH2UzM+9UPRa+IzmD8p7kJqY=;
        b=CBRQQALn7xJgthQZpH94afmM4Tv06dREUWTnWHS49mJbVt4jNXFuAgV98xOPkHMYkU
         zoMDS/nLEmB7nHXaeiEsuNc3V5tejMaBGpMyC9iMl1DTf/YCjeGwbz6/drmlbW6563eI
         FGNRuVLkT9X1WdCwan+dFrhKq1kTuBST6a94UP98/nZTVz7BpABu6mM4nROxlb56qNV1
         9VvewWPRRY8E/K2MPMmKpRXYoYJWksTMvjqJ3usvq8l/IkL0h8lHJQ5rtp2PVF4W3Xqo
         otKx/kKRnGL0e9gtsXuC5JCFKd065uHd2G76iColxhXOfYnKAneJHBknQF70chI6bkZx
         zbrA==
X-Forwarded-Encrypted: i=1; AJvYcCWc5YoP0d/3NHfP0IfSMnsH8TsWsUB7uD0EOZHTS7jYnS0kqKEHQhvnzNNUDQvjy2Rsotg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDuPQP44S21FmoLswRKWIbvtsiLn1z348xOtwTm7yTlrqOVay/
	qyTbzUE7ssYyOm9cn2hyjJsh4wThs9AodgqSEzS+nO41+Kvr/kmo+v6LiuyL/sJ+KHwRCgslOra
	2hNRoH7N1kF+hEIn9okdPNar6FcIqv61/1Bf+BO3X6P8ML/qkLw==
X-Gm-Gg: ASbGncuXJluL1xDqFMv9PY77rGiaMUePATN4yGmH0bpKtImYIIkZ/GqhB8wpHG0Da9Z
	11YCJH3tTiV2OTD0M5gnRfiuAe35u0r/defboaLhDClGyCVk3kc/WHtPQgqHV/rlW1rMh6C4v4C
	NGGP7S46qHGoEkv4ICCAVRNi/CIWKoTH7lSKGD8Zob8pazJgDDPTIuwv4HNF4GiWWfuD7lEgGJg
	e4MP0GmONhH+ClF+YyS41+8m9/b4k5whoWAA7BHMokvrYFaV5wdOhCo+6whXUncbTkKN3MOqkvv
	LkhBelt6KHJNV7H9M8qxuHmz2gkTJnsQ+45eRMXe+FZSgd0DopGL6M4u3UzBIqMCT4Jsm4/uyd7
	1pFoaQajHztKEXvVwfVcbgg==
X-Received: by 2002:adf:cc90:0:b0:38a:4b8a:e47d with SMTP id ffacd0b85a97d-38bf5674f99mr13452386f8f.26.1737492119319;
        Tue, 21 Jan 2025 12:41:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0/IGfSRFqD5a1cp4PYttFZEQK6OSIhNeNeDTCMSeqJHpzVP1bbzOd8PElCu3iC/ATqtzc0g==
X-Received: by 2002:adf:cc90:0:b0:38a:4b8a:e47d with SMTP id ffacd0b85a97d-38bf5674f99mr13452373f8f.26.1737492118899;
        Tue, 21 Jan 2025 12:41:58 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:6200:16ba:af70:999d:6a1a? (p200300cbc709620016baaf70999d6a1a.dip0.t-ipconnect.de. [2003:cb:c709:6200:16ba:af70:999d:6a1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf327e19fsm14701763f8f.93.2025.01.21.12.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 12:41:57 -0800 (PST)
Message-ID: <bc0b4372-d8ca-4d5c-aee8-6e2521ebb2ec@redhat.com>
Date: Tue, 21 Jan 2025 21:41:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest memfd
 via MachineState
To: Peter Xu <peterx@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-8-michael.roth@amd.com> <Z4_b3Lrpbnyzyros@x1n>
 <fa29f4ef-f67d-44d7-93f0-753437cf12cb@redhat.com> <Z5AB3SlwRYo19dOa@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z5AB3SlwRYo19dOa@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> This "anon" memory cannot be "shared" with other processes, but
>> virtio-kernel etc. can just use it.
>>
>> To "share" the memory with other processes, we'd need memfd/file.
> 
> Ah OK, thanks David.  Is this the planned long term solution for
> vhost-kernel?

I think the basic idea was that the memory backend defines how the 
"non-private" memory is backed, which is the same just like for any 
other non-CC VM.

The "private" memory always comes from guest_memfd.

So for the time being using anon+guest_memfd coresponds to "just a 
simple VM".

Long-term I expect that we use guest_memfd for shared+private, and use 
in-place conversion. Access to "private" memory using the mmap() will 
result in a SIGBUS.

 > > I wonder what happens if vhost tries to DMA to a region that is private
> with this setup.
 > > AFAIU, it'll try to DMA to the fake address of ramblock->host that is
> pointing to by the memory backend (either anon, shmem, file, etc.).  The
> ideal case IIUC is it should crash QEMU because it's trying to access an
> illegal page which is private. But if with this model, it won't crash but
> silently populate some page in the non-gmemfd backend.
> 
> Is that expected?

Yes, it's all just a big mmap() which will populate memory on access -- 
independent of using anon/file/memfd.

Similar to virtio-mem, long-term we'd want a mechanism to check/enforce 
that some memory in there will not be populated on access from QEMU 
(well, and vhost-user processes ...).

In memory_get_xlat_addr() we perform such checks, but it's only used for 
iommu. vhost-kernel likely has no such checks, just like vhost-user etc 
does not.

> 
>>
>>>
>>> When specified gmemfd=on with those, IIUC it'll allocate both the memory
>>> (ramblock->host) and gmemfd, but without using ->host.  Meanwhile AFAIU the
>>> ramblock->host will start to conflict with gmemfd in the future when it
>>> might be able to be mapp-able (having valid ->host).
>>
>> These will require a new guest_memfd memory backend (I recall that was
>> discussed a couple of times).
> 
> Do you know if anyone is working on this one?

So far my understanding is that Google that does shared+private 
guest_memfd kernel part won't be working on QEMU patches. I raised that 
to our management recently, that this would be a good project for RH to 
focus on.

I am not aware of real implementations of the guest_memfd backend (yet).

> 
>>
>>>
>>> I have a local fix for this (and actually more than below.. but starting
>>> from it), I'm not sure whether I overlooked something, but from reading the
>>> cover letter it's only using memfd backend which makes perfect sense to me
>>> so far.
>>
>> Does the anon+guest_memfd combination not work or are you speculating about
>> the usability (which I hopefully addressed above).
> 
> IIUC, if with above solution and with how QEMU interacts memory convertions
> right now, at least hugetlb pages will suffer from double allocation, as
> kvm_convert_memory() won't free hugetlb pages even if converted to private.

Yes, that's why I'm invested in teaching guest_memfd in-place conversion 
alongside huge page support (which fortunately Google engineers are 
doing great work on).

> 
> It sounds like also doable (and also preferrable..) that for each of the VM
> we always stich with pages in the gmemfd page cache, no matter if it's
> shared or private.  For private, we could zap all pgtables and sigbus any
> faults afterwards.  I thought that was always the plan, but I could lose
> many latest informations..

Yes, with the guest_memfd backend (shared+private) that's the plan: 
SIGBUS on invalid access.


-- 
Cheers,

David / dhildenb


