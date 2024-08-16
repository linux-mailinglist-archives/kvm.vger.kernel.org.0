Return-Path: <kvm+bounces-24407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D83D2955037
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 628771F277ED
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF081C37B7;
	Fri, 16 Aug 2024 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B4Hn31V8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189DC1C3792
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723830304; cv=none; b=JmSXXnKCi0QRE2JWg0BDT/7D9zlDhzDb/Im6gUsfumNhpo2Z4JANGaj7uNe3Rv/oa6Jyx9hBSv6CX+KHmpikmmi8Np4sFFO9zr8I/4XBN98smFfZGeCJ42nBhsxZcJTUmHGzriaGFOvuU11rLw+reT6dWAa1XPHB5NwZpUYAYko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723830304; c=relaxed/simple;
	bh=5Q1HgjloIR0MpwBSSkUVVWkbj04/nU+bFDjCRNPuhA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LSUdguZxffByRpqdebhiIxnyHBAWvQhCg/9vbGCpLAJCjASV61BBeJHU6rVb5STxqJIVp40xhp1mshAk762+5XWVqskB1RODHWu2LcFFY5UTGEHABoAHUYzeaFko8Iv08C4bh2bwBgyvL7apVaikcj8HPUz6ghRXV1QpgamzlMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B4Hn31V8; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ad9ffa0d77so42146847b3.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723830302; x=1724435102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vLqQ0W+kiaSmHiEqBrEtQ8fcmXJFfIb+9LXgj3vFom8=;
        b=B4Hn31V87GZQ/zp1/MHdTkicOLR7IZGJSCJkrKOj7/TzObmKcJ4pN6NoWKeYc+B5Zb
         butWqSxkfVPYHYAJTfjayFp93a69P5MMpBZJcbiNLJ2pOEg6j1qhq/uM0enFDwStlYcY
         R6Q6Z8mlufuitY/pnfNDZayp+4mRQTFePKl1ivPFWh0DtjtDig170CC9HPCT0WDyxwv8
         jHotshxkXQyOAeQ5or9+L7BbNIR+RBlrG3e7AZvTGX7wVDic9k6cud9Rkf1q0j5CRInJ
         Klz7bJKGoWW2Lm6w1JVY+vyqzuuHHEcYb+8FWV8+GZnBzLDWAdcnyAJyoWD4c0XDnZ1J
         Fy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723830302; x=1724435102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLqQ0W+kiaSmHiEqBrEtQ8fcmXJFfIb+9LXgj3vFom8=;
        b=ZGLnRGOehj+weWPnkANMeK7eBC57kgQa+3DE/WgVUBVAOh3YdHAejjaOMzJ2s85gnK
         XuQvL0JhneObMBz/ODTZvNDJvMo1qlqT1c04thkZBRsge/AVMEUCJ2vIhilEPog/UOsx
         KiYR9RibvfzXH0bhpGNiVc8GSK93zCSZe5MlZnJ1KUJya0i0tFf/cku9qMA6g/6UXs+t
         fKknQMoJ3LkeOv7QBngW9XrtQxprVbwsNSBEH0m79V/E2LJ5n0ZShgPfLmYg69RZiwRB
         zfYiVjdkfoFZ04YpV253wzXFLmigWQV5csaTIDNJB8RFqMpsyRo66HPhYOJFWeZYySrp
         SAgw==
X-Forwarded-Encrypted: i=1; AJvYcCXSZuJDG6bGNi2QQNTBft7FGgT8Kw3QlWMDXxGkxRCc/aAavxRm1DsDCCapq4k/RiL1aiJkCqUfJyUjorBTDlD/3Js1
X-Gm-Message-State: AOJu0YxSKTBRLljaTYsDb5fJaY6c7cwa9/Lj5a6N9QDSnELnQiyqPlOh
	aB/ZM4DcPOtIuQ+3DCb3QUIAX+1RuF2tSBIpqWWPSRtI2BrFZqZ254tdpVwBDeVDTIesTj1/Yv5
	MooAQNh4241z18rlAEB+c0g==
X-Google-Smtp-Source: AGHT+IEi4/I6TDzoHhlZG83qsUH/gsU5TYse1nTv7CQbUM47gB6I7o2YM+wF22moMbfN4T1ecnVRfVCm4hd5c3ZkMQ==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:688d:b0:699:d8dc:668d with
 SMTP id 00721157ae682-6b1bb2899d5mr1670697b3.5.1723830302029; Fri, 16 Aug
 2024 10:45:02 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:45:00 +0000
In-Reply-To: <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com> <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com> <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
Message-ID: <diqzjzggmkf7.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Patrick Roy <roypat@amazon.co.uk>, qperret@google.com, linux-coco@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"


David Hildenbrand <david@redhat.com> writes:

> On 15.08.24 09:24, Fuad Tabba wrote:
>> Hi David,
>
> Hi!
>
>> 
>> On Tue, 6 Aug 2024 at 14:51, David Hildenbrand <david@redhat.com> wrote:
>>>
>>>>
>>>> -     if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>>> +     if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
>>>>                r = guest_memfd_folio_private(folio);
>>>>                if (r)
>>>>                        goto out_err;
>>>> @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
>>>>
>>>> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
>>>> +{
>>>> +     unsigned long gmem_flags = (unsigned long)file->private_data;
>>>> +     unsigned long i;
>>>> +     int r;
>>>> +
>>>> +     unmap_mapping_folio(folio);
>>>> +
>>>> +     /**
>>>> +      * We can't use the refcount. It might be elevated due to
>>>> +      * guest/vcpu trying to access same folio as another vcpu
>>>> +      * or because userspace is trying to access folio for same reason
>>>
>>> As discussed, that's insufficient. We really have to drive the refcount
>>> to 1 -- the single reference we expect.
>>>
>>> What is the exact problem you are running into here? Who can just grab a
>>> reference and maybe do nasty things with it?
>> 
>> I was wondering, why do we need to check the refcount? Isn't it enough
>> to check for page_mapped() || page_maybe_dma_pinned(), while holding
>> the folio lock?

Thank you Fuad for asking!

>
> (folio_mapped() + folio_maybe_dma_pinned())
>
> Not everything goes trough FOLL_PIN. vmsplice() is an example, or just 
> some very simple read/write through /proc/pid/mem. Further, some 
> O_DIRECT implementations still don't use FOLL_PIN.
>
> So if you see an additional folio reference, as soon as you mapped that 
> thing to user space, you have to assume that it could be someone 
> reading/writing that memory in possibly sane context. (vmsplice() should 
> be using FOLL_PIN|FOLL_LONGTERM, but that's a longer discussion)
>

Thanks David for the clarification, this example is very helpful!

IIUC folio_lock() isn't a prerequisite for taking a refcount on the
folio.

Even if we are able to figure out a "safe" refcount, and check that the
current refcount == "safe" refcount before removing from direct map,
what's stopping some other part of the kernel from taking a refcount
just after the check happens and causing trouble with the folio's
removal from direct map?

> (noting that also folio_maybe_dma_pinned() can have false positives in 
> some cases due to speculative references or *many* references).

Are false positives (speculative references) okay since it's better to
be safe than remove from direct map prematurely?

>
> -- 
> Cheers,
>
> David / dhildenb

