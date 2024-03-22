Return-Path: <kvm+bounces-12507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 419AE8871A1
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:08:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA1431F214AE
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D70D5FBA0;
	Fri, 22 Mar 2024 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hm9rD3HP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DAB1C6AB
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127296; cv=none; b=Uhld5v5cBC8o2OK8MpKFLfQf71/kl1OlkvMKuOLR/gZyi8KyaU7/fVtRC+RPtyAnf8HJbA8/7wxiiqCUxC7LkC4AI0nebYkWmexC1b8vlzyLdA1R8ScfbXaApOWwR9+FDUKbnfXn2J5EXd/0gS1hv72cceIbgZhcfAH8bmLGVwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127296; c=relaxed/simple;
	bh=i3d6IbiPKLGYMRKY4KrbVpWBClhYmxMxJ+bnf/dg4Jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iMCsQW1E9dO/6SGBzlIfFdGDNVe5HdHwC/mxHq0P9+VBHKeMTjTaK6z16JgubJ90gKg292ngWlMRZNPVYLCyzJX3sK+JV8bzGrtx0z79/PZFT6ROC4EZYr8L7T1MEcnOXnG5zuC3/exShJkivWO/nm9PyXE9JwE0NEYuTG4JgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hm9rD3HP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711127293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LvE5YyR9oEgqB//XISQcpQ6kuiyc3YyD+DSR8RdYlDw=;
	b=Hm9rD3HP1oVKSR4/HXMcZxEes6kpoBrVqD7p368EGagoRhY+zwo7lGB+qQRY9p+iPlO9g5
	mz8cRSCqO4QalsaI9NSS+A81BVfplu05mMYPZ/fcwkyaHpnSI8gjJiFam3Rb3YptfYA6Rk
	sPDyIC4A4JGXvnZhK1ivzLA4Rgh1ivk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-c7MW7NSQOy2FvHTCXY0R9A-1; Fri, 22 Mar 2024 13:08:11 -0400
X-MC-Unique: c7MW7NSQOy2FvHTCXY0R9A-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3416632aeffso1141778f8f.1
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 10:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711127290; x=1711732090;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvE5YyR9oEgqB//XISQcpQ6kuiyc3YyD+DSR8RdYlDw=;
        b=PV5rUgbXqnLsLKL/IvJEXUGxz5RiEUZYlPMVn6roLF+Rd+jTvds3tYuOlaV83YejHl
         X5mbHtlNi1ZXqE/cPZgb4abggHx0ZqTvIUH3UYbCBCQ30Sp59JxsRf7HHE9iJsFWEn51
         xmSDGPlfxTtVDrVWTnLrq25v2aGvzt9HFx5Dn1vPpj7xndGpfwS6Ryf6eCLCpeGh/w35
         eTCKPHdi2MbogrXL9idqySauva4ZSIV35yv8KOd8TyCptrEMrnNiFD7tyk7RrsvuybiB
         INqfREG2V2Zy+Trtv27lHAzOTQJg9NdKseJvqhT7sy8Hyb5HEqyfmXBQ2TN5lOLAbJdP
         xwag==
X-Forwarded-Encrypted: i=1; AJvYcCUTzP3AQv+AR2QotBRWmwElNZF/CRk7f6uT4OGQbZKOPlJhiDgQ8uBLgewuiw5UJ4cL5qbzp8+d/TYcOW04TVDwPbew
X-Gm-Message-State: AOJu0YxW+nHDH46imknJ5unCiJz+Hm5ro08skOh6q2UjKSO1OdNwLZts
	ol9mjB3/lD8KDU5YbEL7KeAJ5ghqTL6MgyUAZ5N/1X0LDa6+Ts3g4TXkUfSYAuRXDeallB590P+
	eWO3BdKPYlGrW922LdsFtW0ScRtl+XZjN+tnd/eyRWqXz6JsK4g==
X-Received: by 2002:adf:db4d:0:b0:33e:8b95:62d9 with SMTP id f13-20020adfdb4d000000b0033e8b9562d9mr1930621wrj.23.1711127290507;
        Fri, 22 Mar 2024 10:08:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE59ro9vIk1AgNIKKU/EM1wSd7R+6VplLULkDgkURHvKcZWHB9JPa8NxIqYdxZOfL4Ts1LESA==
X-Received: by 2002:adf:db4d:0:b0:33e:8b95:62d9 with SMTP id f13-20020adfdb4d000000b0033e8b9562d9mr1930605wrj.23.1711127290086;
        Fri, 22 Mar 2024 10:08:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71b:7e00:9339:4017:7111:82d0? (p200300cbc71b7e0093394017711182d0.dip0.t-ipconnect.de. [2003:cb:c71b:7e00:9339:4017:7111:82d0])
        by smtp.gmail.com with ESMTPSA id bk19-20020a0560001d9300b0033e2291fbc0sm2469006wrb.68.2024.03.22.10.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 10:08:09 -0700 (PDT)
Message-ID: <ac0e3000-eb04-4f13-9eaf-fe1eaa2f5497@redhat.com>
Date: Fri, 22 Mar 2024 18:08:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
Content-Language: en-US
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240321215954.177730-1-david@redhat.com>
 <20240321215954.177730-3-david@redhat.com>
 <ed0f05de-0e17-41ec-85b2-be8603b0556a@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ed0f05de-0e17-41ec-85b2-be8603b0556a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.03.24 11:22, Christian Borntraeger wrote:
> 
> 
> Am 21.03.24 um 22:59 schrieb David Hildenbrand:
>> commit fa41ba0d08de ("s390/mm: avoid empty zero pages for KVM guests to
>> avoid postcopy hangs") introduced an undesired side effect when combined
>> with memory ballooning and VM migration: memory part of the inflated
>> memory balloon will consume memory.
>>
>> Assuming we have a 100GiB VM and inflated the balloon to 40GiB. Our VM
>> will consume ~60GiB of memory. If we now trigger a VM migration,
>> hypervisors like QEMU will read all VM memory. As s390x does not support
>> the shared zeropage, we'll end up allocating for all previously-inflated
>> memory part of the memory balloon: 50 GiB. So we might easily
>> (unexpectedly) crash the VM on the migration source.
>>
>> Even worse, hypervisors like QEMU optimize for zeropage migration to not
>> consume memory on the migration destination: when migrating a
>> "page full of zeroes", on the migration destination they check whether the
>> target memory is already zero (by reading the destination memory) and avoid
>> writing to the memory to not allocate memory: however, s390x will also
>> allocate memory here, implying that also on the migration destination, we
>> will end up allocating all previously-inflated memory part of the memory
>> balloon.
>>
>> This is especially bad if actual memory overcommit was not desired, when
>> memory ballooning is used for dynamic VM memory resizing, setting aside
>> some memory during boot that can be added later on demand. Alternatives
>> like virtio-mem that would avoid this issue are not yet available on
>> s390x.
>>
>> There could be ways to optimize some cases in user space: before reading
>> memory in an anonymous private mapping on the migration source, check via
>> /proc/self/pagemap if anything is already populated. Similarly check on
>> the migration destination before reading. While that would avoid
>> populating tables full of shared zeropages on all architectures, it's
>> harder to get right and performant, and requires user space changes.
>>
>> Further, with posctopy live migration we must place a page, so there,
>> "avoid touching memory to avoid allocating memory" is not really
>> possible. (Note that a previously we would have falsely inserted
>> shared zeropages into processes using UFFDIO_ZEROPAGE where
>> mm_forbids_zeropage() would have actually forbidden it)
>>
>> PV is currently incompatible with memory ballooning, and in the common
>> case, KVM guests don't make use of storage keys. Instead of zapping
>> zeropages when enabling storage keys / PV, that turned out to be
>> problematic in the past, let's do exactly the same we do with KSM pages:
>> trigger unsharing faults to replace the shared zeropages by proper
>> anonymous folios.
>>
>> What about added latency when enabling storage kes? Having a lot of
>> zeropages in applicable environments (PV, legacy guests, unittests) is
>> unexpected. Further, KSM could today already unshare the zeropages
>> and unmerging KSM pages when enabling storage kets would unshare the
>> KSM-placed zeropages in the same way, resulting in the same latency.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Nice work. Looks good to me and indeed it fixes the memory
> over-consumption that you mentioned.

Thanks for the very fast review and test!

> 
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> (can also be seen with virsh managedsave; virsh start)
> 
> I guess its too invasive for stable, but I would say it is real fix.

Should we add a Fixes: Tag? I refrained from doing so, treating this 
more like an optimization to restore the intended behavior at least as 
long as the VM does not use storage keys.

-- 
Cheers,

David / dhildenb


