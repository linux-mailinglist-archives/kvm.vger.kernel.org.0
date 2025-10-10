Return-Path: <kvm+bounces-59774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B36BCD6C5
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 16:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3DA4E4FE9BC
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 14:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F202F547F;
	Fri, 10 Oct 2025 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elojs4/C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636902F4A00
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105491; cv=none; b=Vu1MQX1+ptLUxuIvGtezWA6TsktoHddiN4TXb/DIoRGyhB8cPbboytEezFfUoPhOPm887DuKdGnKOi5S6prjgjFCBri+XxGgxaJqx9utM23gtkmi6Q8WcMhBj6vErJovBy3TnfwGOuA631YmM2sbxXUiS5FhYgQTmHnXGEolE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105491; c=relaxed/simple;
	bh=JYnBnCWHkef8RyBvi69YmEV68PI6DXCISPx+R2HIFJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tLfQPqgll7WmjmnEP9yMIAUxocQApzYLmsMEpCEqz+lfvyNHw+i8bzfeRZblB23i1OZqgADQixYHBTw9vwnmNI+3r1VMzx98YaYsDxSi0OB6R2QoBh80H0lOnzmSCErlPDT0EzrR7iRwXsMLS/YjvAnQPodzQe57rb4g604q/Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=elojs4/C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760105489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wbJHZ97LShKz75F6YVPrIwKeljLc2UX59sgdVUiGzTY=;
	b=elojs4/CDK4x8fJUMS/IBAbBkTyVu/JjV0ZAgJtWe04Ve/Nvejm3ZN9pyEhD6MKdpR9VOU
	q4Hbw5DVnx+5XgGYzWQBiOQoy7KvqAdUjVZSyAVzQW5z027bUu46m4lo7HA7lEa45rZxZm
	JhJ2/5Toxrm5VuJ/wd5HcuZ3xrrRzfE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-7XxYTl91NW6iY6KDm2pU8w-1; Fri, 10 Oct 2025 10:11:28 -0400
X-MC-Unique: 7XxYTl91NW6iY6KDm2pU8w-1
X-Mimecast-MFC-AGG-ID: 7XxYTl91NW6iY6KDm2pU8w_1760105487
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so17351965e9.3
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760105486; x=1760710286;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wbJHZ97LShKz75F6YVPrIwKeljLc2UX59sgdVUiGzTY=;
        b=l7s5MInETXiafHzPyyjbREGx3kjJ4KbrVbpZJKojI1x9q3p71D2QzoSfAi1hiN2Zst
         yUchHL+4HSmLQdDc/i+43EHYZcrn4mdilpS9zAYox2l/VGfKOV+4LYQ6D48VAADKF3XF
         0r1/ZoUJBrZKbbVAr38iLFhoxfxDKjhiCv5/GSaEmYMhw0Phcbj0NqI57QpmPiq3l3eJ
         E6sqSmyp1zsXikyOhNUamobPfGWL8ZaSjMjBQoPNPRQeNLoTRwqMef9W4Wp1SwKaFgEr
         LWm+Xg3uhVYn9QeXr3+Fw9kdD42y2FZrs9RhJcLvg3/5oVXKa0gVx1eB3vz/y9JQ5BsM
         eC+g==
X-Gm-Message-State: AOJu0Yy3VTM98H4yJTWXewbRJ4EWMDmcgdZibylIUr5olrN5RykZ62ly
	0woi7tRhxEbjXKNjjvFu2febCTkD7X/Z/tIBzkPErr43P7mW97CGmAYhl/wy+9x7dFetFrpecYo
	hykOfnu/ogYSSATRqj5CvjmTLIQ5jRoMx3IJDNBuKTAeRfIZ6pHPcZg==
X-Gm-Gg: ASbGncsudLWH/Ge0M1o12M0HoMxw1oSbMNBuw6dlpvNrp0HrskdM0U9CuCOjJq8jEXP
	0bd765yfNi4XERZ08RzYYnn11yF5jXJUmTPoxdcxj535BYkTOVjrxSQ+PGApdaI1A4gdyA6NfAB
	NEXXQl6G3eBYOT1nmOlCyk5t9ue1rxleoNywRSNaP4B1aMZY3YzFznexhDHLCyB3wI3EoUpgPZ3
	i/iyRVtV7jRi+bFfj35JX9ie61dyi36q+vHL7Bj8iiFSXBCOp/6A+TuJssQ5jN9v8GjQ4kz/rMX
	SrrI2XqISClKKzNbmzQWekD1C51efGc6S+wI94tYwoFgkFQEqNcdMdFFHH2XshFmmuTli3aOddt
	hYmQ=
X-Received: by 2002:a05:600d:8221:b0:46f:aa02:98b1 with SMTP id 5b1f17b1804b1-46faa02ec6emr62953635e9.21.1760105486677;
        Fri, 10 Oct 2025 07:11:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRROnZFvl2ovceyizR0lS0KdtdpVJX5+dWxkwGf23/+teGdNZWxplYlhTI+5TIKPkXoBbOQQ==
X-Received: by 2002:a05:600d:8221:b0:46f:aa02:98b1 with SMTP id 5b1f17b1804b1-46faa02ec6emr62953415e9.21.1760105486235;
        Fri, 10 Oct 2025 07:11:26 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb479c171sm49893295e9.0.2025.10.10.07.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 07:11:25 -0700 (PDT)
Message-ID: <afb2d4f6-cc5a-4aa3-9194-8822060a0552@redhat.com>
Date: Fri, 10 Oct 2025 16:11:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] KVM: guest_memfd: Allow mmap() on guest_memfd
 for x86 VMs with private memory
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
References: <20251003232606.4070510-1-seanjc@google.com>
 <20251003232606.4070510-6-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251003232606.4070510-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.10.25 01:25, Sean Christopherson wrote:
> Allow mmap() on guest_memfd instances for x86 VMs with private memory as
> the need to track private vs. shared state in the guest_memfd instance is
> only pertinent to INIT_SHARED.  Doing mmap() on private memory isn't
> terrible useful (yet!), but it's now possible, and will be desirable when
> guest_memfd gains support for other VMA-based syscalls, e.g. mbind() to
> set NUMA policy.
> 
> Lift the restriction now, before MMAP support is officially released, so
> that KVM doesn't need to add another capability to enumerate support for
> mmap() on private memory.
> 
> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


