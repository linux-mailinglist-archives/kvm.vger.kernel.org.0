Return-Path: <kvm+bounces-31684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 131A79C6434
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C448E28216B
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD94721A4A7;
	Tue, 12 Nov 2024 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KN4PoPzt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7B1EC006
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 22:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731450266; cv=none; b=r4EbU6gLVZowgQxzh83EqHG9eZg+ZjXS++F11Lfid6P70yeAz2En+HsZq6IFHOsyEqZCkNuKNT9X7YaMk+O95G08mbRSS9eNEKVaaMQc1tzIo+qzq8Vj/ZjHT+Dx1mnUXqzCYHhF4icXPHmddK9RRXkOxWIMp+04t8qzRkiVqE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731450266; c=relaxed/simple;
	bh=7te3CI0/npam2SyJ7S0gekbV9ckrDnLMQZbKoIuo+1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YV1Ii63PQvGDlKCO+NAX/KR4QCrpgnfiXyUSaRx8tdUylQg1s/7MytOAGyc3oSLg9IACdCWFRJLtpwQ8R3+RKTRm0kdyTRLT9P10gmSrYsD8DQJZfrP6+eX3USgKawZuDCbsbS2FpXYRZAuuEn0FhzF1Y3eCIx71MQqFXHFq8DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KN4PoPzt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731450262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fCIOP1bkYsLx4G3BTsPbOttcnEMUAhgczcADWOOaNmU=;
	b=KN4PoPztC1tGZkpmBfo22hRnrMKK+Pvw+Uyqb370Kvf8snFEpvGokBQhrTc13g4uXdrH+G
	TYd7n3OtDq/ovpXU2AJo2VXzuNrn7I9b8/UkDWEjDopMDp//Rqa0MhsiTYXvjpS9EdbYHK
	8FcqZwQDs3iaQryNo5m7gnQDwTsvpmE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-nj0915rPMQGZzGNJBqf2Qg-1; Tue, 12 Nov 2024 17:24:19 -0500
X-MC-Unique: nj0915rPMQGZzGNJBqf2Qg-1
X-Mimecast-MFC-AGG-ID: nj0915rPMQGZzGNJBqf2Qg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43154a0886bso43870775e9.0
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 14:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731450258; x=1732055058;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fCIOP1bkYsLx4G3BTsPbOttcnEMUAhgczcADWOOaNmU=;
        b=rF8J1UTJLFzJ56Y55LA9IXQxvm6BnA4Nc/8TaFAv7q+cYGA/NbaAij+IWhGiZv52Ef
         mJyLofw54SlvF5dARBjSnH0aQWD2T8YcBFTHBqvz0+sddkprI7rRnLvzQVJqU0OxHtB8
         0txH/UDnQDRRbeRlBknqv/HDhpr5E+6FEUq+sI4lfJq9IWGd4UvTCI+gCrQNy/Eu6nwO
         foiDQxEfFN9bl3RvE7pUXW8wQW3SPCcVRLrj7iP+qQUQqklTF19Wcgc36vGGfSWslewD
         oWFTysVmK4ihW/Bmo4nwEAzCU+w8vxQrXE2fZCUgpYQ9Y4Q0cP/0PONqkcVPKxch+3+8
         hgDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqOx8B0rdMZr/sw10oheDFd+8K4GMTd9fw4V4socn/vxQE8Co7CyRH82Rw6fkOLSS3Ky8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6IOMYnExQRXPQSWOhbrvRXKlNPtib3vKi8SjUiSDfn+QEhXOh
	5OfG8S2tTypVHV+04UAMpMX9s/EJtEpJplGjrp9f5Q+BA2tNC4jod6WUmIXaLF0Rd39OXJBzzzr
	OK/RJ0BZ+FH2kFj0ypUhSJBnm3p8KdMbpeYUtRs1OYNFc8+vovGvXCgLcaA==
X-Received: by 2002:a05:600c:a04:b0:428:1b0d:8657 with SMTP id 5b1f17b1804b1-432b7517a5cmr155280565e9.22.1731450258478;
        Tue, 12 Nov 2024 14:24:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEW+/fTCwuLY3emJFf9LkjxjmK0ue2mqKaL5MpaEGKJoYVSxqo586sIsglbq7vQKAolutjEEQ==
X-Received: by 2002:a05:600c:a04:b0:428:1b0d:8657 with SMTP id 5b1f17b1804b1-432b7517a5cmr155280405e9.22.1731450258100;
        Tue, 12 Nov 2024 14:24:18 -0800 (PST)
Received: from ?IPV6:2003:cb:c739:8e00:7a46:1b8c:8b13:d3d? (p200300cbc7398e007a461b8c8b130d3d.dip0.t-ipconnect.de. [2003:cb:c739:8e00:7a46:1b8c:8b13:d3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d48c731dsm4281965e9.2.2024.11.12.14.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 14:24:16 -0800 (PST)
Message-ID: <093dd833-d03a-4149-8928-0f31e84a3e03@redhat.com>
Date: Tue, 12 Nov 2024 23:24:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] hostmem: Handle remapping of RAM
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-7-william.roche@oracle.com>
 <3ed8c7c2-8059-4d51-a536-422c394f34e5@redhat.com>
 <b6bdff02-4ebe-466f-93af-dda572505995@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b6bdff02-4ebe-466f-93af-dda572505995@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12.11.24 19:17, William Roche wrote:
> On 11/12/24 14:45, David Hildenbrand wrote:
>> On 07.11.24 11:21, “William Roche wrote:
>>> From: David Hildenbrand <david@redhat.com>
>>>
>>> Let's register a RAM block notifier and react on remap notifications.
>>> Simply re-apply the settings. Warn only when something goes wrong.
>>>
>>> Note: qemu_ram_remap() will not remap when RAM_PREALLOC is set. Could be
>>> that hostmem is still missing to update that flag ...
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>>    backends/hostmem.c       | 29 +++++++++++++++++++++++++++++
>>>    include/sysemu/hostmem.h |  1 +
>>>    2 files changed, 30 insertions(+)
>>>
>>> diff --git a/backends/hostmem.c b/backends/hostmem.c
>>> index bf85d716e5..fbd8708664 100644
>>> --- a/backends/hostmem.c
>>> +++ b/backends/hostmem.c
>>> @@ -361,11 +361,32 @@ static void
>>> host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
>>>        backend->prealloc_threads = value;
>>>    }
>>> +static void host_memory_backend_ram_remapped(RAMBlockNotifier *n,
>>> void *host,
>>> +                                             size_t offset, size_t size)
>>> +{
>>> +    HostMemoryBackend *backend = container_of(n, HostMemoryBackend,
>>> +                                              ram_notifier);
>>> +    Error *err = NULL;
>>> +
>>> +    if (!host_memory_backend_mr_inited(backend) ||
>>> +        memory_region_get_ram_ptr(&backend->mr) != host) {
>>> +        return;
>>> +    }
>>> +
>>> +    host_memory_backend_apply_settings(backend, host + offset, size,
>>> &err);
>>> +    if (err) {
>>> +        warn_report_err(err);
>>
>> I wonder if we want to fail hard instead, or have a way to tell the
>> notifier that something wen wrong.
>>
> 
> It depends on what the caller would do with this information. Is there a
> way to workaround the problem ? (I don't think so)

Primarily only preallocation will fail, and that ...

> Can the VM continue to run without doing anything about it ? (Maybe?)
> 

... will make crash the QEMU at some point later (SIGBUS), which is very 
bad.

> Currently all numa notifiers don't return errors.
> 
> This function is only called from ram_block_notify_remap() in
> qemu_ram_remap(), I would vote for a "fail hard" in case where the
> settings are mandatory to continue.

"fail hard" is likely the best approach for now.

-- 
Cheers,

David / dhildenb


