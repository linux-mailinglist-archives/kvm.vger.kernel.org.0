Return-Path: <kvm+bounces-24472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CCA195575B
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 13:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 510F71C20FF6
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 11:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1162214A0B7;
	Sat, 17 Aug 2024 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZQIk0AT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F9D145A03
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 11:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723892768; cv=none; b=JbOqyWPTqlUTyCYgmDNIEPq6ypl+M/RUZrQ9aN4huQ0iB/aa/WntyulVDvdqHc2Rk1KJsDufZAwu2ClSnClsgjT6yNe6r2acIqHkyxh5PU55gj+LlNKphsG+ZFFYj3XEnSUExFagDv2kJacPHQl5b599T1mMs6woPy9T++am/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723892768; c=relaxed/simple;
	bh=2t9ZIW33qsjQO74KSS/i4PlQGkvUVwgDtFNRsC6viMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LIURS5jugUnMWnoKVxk3q9kBDfeASdP85OZc/Zn7GzIoSBmXx22K1lBKg3YNlbxSP3ycNLcC4RolLiRN+1KOk7Jr8xPxgSq4JD+hrFkZUmSiB9xnumgvduU8zSUo91teZpH7X4F59Rfewuo+TRskHY2lZiSjlv/1XSOjbXlrIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZQIk0AT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723892763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3ZV2elUtsEgp3OpxtfB0D3Lemn84q1RYfwehJnEXN1A=;
	b=eZQIk0AT2YjsZnPa/RiA33THv6qduxshgcl5FHxMaSDvFplGaWLnGhp+m5pAn01cHnFbCp
	4vyYOrS3nHU1HvvVejz1H8ZyyzrwGH6Y0r8SC3anIKhklcNZnssOwgQnGf55tH2tcC26BH
	mAa8TUEin3wD5yVS8TVkWj1ikxMz8jg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-0demOiNSNlCFS4P2OEvjHg-1; Sat, 17 Aug 2024 07:06:01 -0400
X-MC-Unique: 0demOiNSNlCFS4P2OEvjHg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4281f8994adso20731175e9.0
        for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 04:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723892760; x=1724497560;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3ZV2elUtsEgp3OpxtfB0D3Lemn84q1RYfwehJnEXN1A=;
        b=qIQpwHZBFTjPxFtpYp67xmH/pjjyfoysgZDcGE9J3Bv4dU6w4ce0Oa0VH3BvY0uz7r
         eiGSx31HntgVYtCbcwjbqkyZ3n7s0GDSLkMjK9Z26xHIZwaeZBDv0VqVIrJVgNJ9bVwj
         NHIXuTXV5iYRTLiBtGZIJoCo1NVTvCRvvpjurqXl2vT5mU0lhUMx/RDsEp+0ZsMY+dtW
         ePEj9GvdYnE/xYgs/+xOU2wGFiMA9LFAdv0ivm/CCq+Qp1ZBqJ4zV9XYBfynYk6IiOgp
         yMFvG+XWAdsfNWGhNdncbi0Y6TGyGnTAjTk+xCstTMR5lTDUkcYrk2TGpm3PwsrwQ28y
         wCiw==
X-Forwarded-Encrypted: i=1; AJvYcCWP6E3K0+p+BvxmqrRP3oxjKP/yOnik7KJ7qNM8R6HIpJm9XnAUVXGJnUihfC9B7E41eUfimbph0J2n3TaRJmjhkOHw
X-Gm-Message-State: AOJu0YyJbtncYOk7yryzFWclvZLVV+OWlHPXf3hosICLNGWBdGMNknkq
	YLHGy0orQM4Qj+N+pjvBpEdwOKupkuzxpto/D5wg+8ZypziPcjy6x64LX9aaMc/qjzaK/9jHio5
	CLNjzMS5IW1xPRqHsfKo+1llM/vhHJPQAmeqKWRgv0wQHIOemEQ==
X-Received: by 2002:a05:600c:1d07:b0:426:5f02:7b05 with SMTP id 5b1f17b1804b1-429ed7a6156mr33891355e9.2.1723892759918;
        Sat, 17 Aug 2024 04:05:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQWrilOCuYwaOJlB4YOm9r3LJkSAWc7A11KFPnXw/+NboeDRkAXJpzwXOpfbYOEH/C1PZFng==
X-Received: by 2002:a05:600c:1d07:b0:426:5f02:7b05 with SMTP id 5b1f17b1804b1-429ed7a6156mr33891205e9.2.1723892759349;
        Sat, 17 Aug 2024 04:05:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72c:5800:458e:8c41:4802:47f9? (p200300cbc72c5800458e8c41480247f9.dip0.t-ipconnect.de. [2003:cb:c72c:5800:458e:8c41:4802:47f9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed650903sm46716195e9.18.2024.08.17.04.05.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 04:05:58 -0700 (PDT)
Message-ID: <5daf183d-6942-4fcf-a5e2-dee022da89d8@redhat.com>
Date: Sat, 17 Aug 2024 13:05:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/19] mm: New follow_pfnmap API
To: Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com> <Zr_c2C06eusc_b1l@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zr_c2C06eusc_b1l@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.08.24 01:12, Sean Christopherson wrote:
> On Fri, Aug 09, 2024, Peter Xu wrote:
>> Introduce a pair of APIs to follow pfn mappings to get entry information.
>> It's very similar to what follow_pte() does before, but different in that
>> it recognizes huge pfn mappings.
> 
> ...
> 
>> +int follow_pfnmap_start(struct follow_pfnmap_args *args);
>> +void follow_pfnmap_end(struct follow_pfnmap_args *args);
> 
> I find the start+end() terminology to be unintuitive.  E.g. I had to look at the
> implementation to understand why KVM invoke fixup_user_fault() if follow_pfnmap_start()
> failed.

It roughly matches folio_walk_start() / folio_walk_end(), that I 
recently introduced.

Maybe we should call it pfnmap_walk_start() / pfnmap_walk_end() here, to 
remove the old "follow" semantics for good.

> 
> What about follow_pfnmap_and_lock()?  And then maybe follow_pfnmap_unlock()?
> Though that second one reads a little weird.

Yes, I prefer start/end (lock/unlock reads like an implementation 
detail). But whatever we do, let's try doing something that is 
consistent with existing stuff.


-- 
Cheers,

David / dhildenb


