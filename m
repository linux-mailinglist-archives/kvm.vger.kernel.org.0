Return-Path: <kvm+bounces-59772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6883BBCD67A
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 16:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C822019A1C00
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 14:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B802F5A13;
	Fri, 10 Oct 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SYsAKEsq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD32F3C20
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105405; cv=none; b=UVBw2ueLAtO66O5ghWRpviA/5rx7zTiJCHH/F6Q7MUBXt9jI/K7MRcZyLRAljncFXITVInlpz8hg5yoA440Ckm9JampXmtYYVImajKFoPnJ6RWtW6n2lWTCN/7wOVlaYNWGnqf/60+mGX/pOOhx0xYKaO8RkzdAz+lBDHs5VPnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105405; c=relaxed/simple;
	bh=foIQle7lWfC9ERVULKynw7SghJRqe7SMGsHmoTHKmNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zf6/ibr1X/ZmO0WarBpSjMimBvNacMaD0fr5J326X/ZgZ/1ZpWD42qPTOVo8xFmWiocWN2U8W8ogo7NHNZChC/Tbw4gRBE5Cx9MmmqYmKJiVUVMdXAiaMSGArCgaMd5OH1GNFRTd4UiZOEp8ecMPEv+XWKANJlP1p14VMmMN9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SYsAKEsq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760105403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8C022sktUjail169ppgWBfdPS1kZoI3Bm8Yo7CANI3s=;
	b=SYsAKEsqOeVKxxucDbksq1C3HnpYkidxYDfuesXkNRnjhelHmf6Bd4zfWG3X0IoxrOBkP5
	oSZpLQr88JgpzHT/QzyncGpNLHqYUWZd9ZZBcgfiBMVPSaBjl5Fv1R5zeIoavXiHPbq2l3
	vOT1ZsToq9SPYeuPOCXewFP7ELMv0bw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-vLryDIhMML2UcozIZ4OznA-1; Fri, 10 Oct 2025 10:10:01 -0400
X-MC-Unique: vLryDIhMML2UcozIZ4OznA-1
X-Mimecast-MFC-AGG-ID: vLryDIhMML2UcozIZ4OznA_1760105400
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e3af78819so10461115e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760105400; x=1760710200;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8C022sktUjail169ppgWBfdPS1kZoI3Bm8Yo7CANI3s=;
        b=mSGlrPSv/Zi5uceSRAXWYy5nKxP52z4+XFTLgnS/FNSjkfAWGt4+3Otnv6zc3qO9Ma
         3diYNn4nIxyXa7ifl4ejHPp4euvSfvIEnGxKHRWrpMtLst6hBvrasWd9pHu+bTEf/apI
         XiZCepYskULQ3KTiLan1+8Zpp9c669xnKXCWL3eQG8XjtY84qCbAxvbv1MF5rXB5n4Tc
         8ZJ2FTvRSRzHU2lCEsuXQLCwZF/ifhkFxc/60UHkBMKpZOMKV+j78SAZeYwjy+vM0n7u
         FU8CGYFnYvTBsA99akXILGbznQOACe9jzTDy3irIw+a3kIRt6i8+QkpGdZQNjeuTNe+C
         6FvA==
X-Gm-Message-State: AOJu0YwZoKy88n/+uYz3SPAP6ENnhitXx/rh9NTmEuuR1d0H0//6I7bJ
	Ke8Ck0OoD9uSdblJVIAN/2wokCvN5zl8VQiNVr+KZFR+w3h8aRcp1XgVMqGjqK07oL1Tqkny3Qg
	lUu7MiuXyFc1+MfCmee7Ne6eMQlRxowt6e8NwVpYSzclKRjM42dMb6A==
X-Gm-Gg: ASbGncvVAdDzWiFd+tZ/W38kpHxOe/dVVDLPc+V57JG7TBxwOh41LhdlUwuvmcpYrY7
	CwRd2QvC50o8dnCXd7sBywrb+/qAEfCeTuYDUlHe3i9BPMArD/7qKYyBMc6IsKoaVN4gM9lpQOy
	4JhwSBBuMzJdfwyuRMNFxAOF9ohHhHQwAF1RIE0vlTJ4vQ5ihSbYquySNvl3+r+kEOoPsL60Lj8
	vmwL8ACWU148n4KxgJed8mfaBCxetbl81eGwpYh3tMgBdpahZGZDxrTOg9IQSmI9/jkI5WkylLT
	rd0E5hTD+MJ/+6dQFU7rfZYE/9COBxHPRqeD6wIahyximnO7yr10w0z0Y51czXv7eMwMLSZj8rH
	c+1o=
X-Received: by 2002:a05:6000:178f:b0:405:8ef9:ee6e with SMTP id ffacd0b85a97d-4266e7bf1d7mr8416036f8f.25.1760105400461;
        Fri, 10 Oct 2025 07:10:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYaLfXQuHZXqKHMYG4PXPjxgH/q4seV5B8Aq9aeHv+g4RGTpe5MoSUFEIVwzPHH4p7WTVBEw==
X-Received: by 2002:a05:6000:178f:b0:405:8ef9:ee6e with SMTP id ffacd0b85a97d-4266e7bf1d7mr8416017f8f.25.1760105400062;
        Fri, 10 Oct 2025 07:10:00 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e8309sm4350116f8f.50.2025.10.10.07.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 07:09:59 -0700 (PDT)
Message-ID: <4053d56d-2732-457f-9531-07382780e39b@redhat.com>
Date: Fri, 10 Oct 2025 16:09:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] KVM: guest_memfd: Invalidate SHARED GPAs if gmem
 supports INIT_SHARED
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
References: <20251003232606.4070510-1-seanjc@google.com>
 <20251003232606.4070510-4-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251003232606.4070510-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.10.25 01:25, Sean Christopherson wrote:
> When invalidating gmem ranges, e.g. in response to PUNCH_HOLE, process all
> possible range types (PRIVATE vs. SHARED) for the gmem instance.  Since
> since guest_memfd doesn't yet support in-place conversions, simply pivot
> on INIT_SHARED as a gmem instance can currently only have private or shared
> memory, not both.
> 
> Failure to mark shared GPAs for invalidation is benign in the current code
> base, as only x86's TDX consumes KVM_FILTER_{PRIVATE,SHARED}, and TDX
> doesn't yet support INIT_SHARED with guest_memfd.  However, invalidating
> only private GPAs is conceptually wrong and a lurking bug, e.g. could
> result in missed invalidations if ARM starts filtering invalidations based
> on attributes.
> 
> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


