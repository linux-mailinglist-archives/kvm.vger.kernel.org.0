Return-Path: <kvm+bounces-10230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 765D686ACB5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E14DDB24391
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A79B12EBF0;
	Wed, 28 Feb 2024 11:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jLFxQ/rU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941BB44C6E
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709118699; cv=none; b=PSCoX3MAxoR/TzcpkD7wqwX/+xYR7P/TfAgj8YclmlkRVkQ92rPd9gMfYD7cyiwgbh7yV4uDTBmMeXyhUJVXXuO12Eq3Ahf3P28RzS9t9et3Q9LBkUioiSxRSiL4Ga8hTANlNkB4A+XuvZzlE8+156Ck605u4JxPe7olznMTK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709118699; c=relaxed/simple;
	bh=N69/suQ4MaSCYmrP4WB8YtYlGmUS63cenW87j39hg6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sAC6o5dnrYNm7kd/juaq6ah9RXL5OCjbqj+nwJmXvbqUtJhlcAw0IdWGNror6E/I8PeUsrA00NkBv7FB5iZTfYe7g8t2ElMVskqWvBCszBugpmw+/nbKqudnr2CTNOXhesIYtN40Wwf99aC9EM4+jLCycVrLs6dGuTiNC48zMU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jLFxQ/rU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709118696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aUQ9sWDupyMNgIyawFwqXCHJWRUg3SyzP5KUns9QT5Y=;
	b=jLFxQ/rUFQvKvTE5QCYabOXE6DgdcN8ZGePQGpjffVWHlrkvqowsc4SxpAitrAilvR/i4X
	sNlVWfHofb2FBT4+Jv2vP4jLnFsRKnu3PiqiskGPbkuhywqSj38ah4LVO+kjpzIcCJ8Y1a
	OHwFmc+jJn0XIDy/9LA6ETOzyM6eG0s=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-KJHa3Ve2PSGCnWEGycFFSw-1; Wed, 28 Feb 2024 06:11:34 -0500
X-MC-Unique: KJHa3Ve2PSGCnWEGycFFSw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d2bac6e205so6933531fa.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 03:11:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709118693; x=1709723493;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUQ9sWDupyMNgIyawFwqXCHJWRUg3SyzP5KUns9QT5Y=;
        b=eAmXZSROPOWvRrRw6jt2oDzmDoAv7njunMR9DMDsdlsrgK6CM33Uwj8ABGhjRyTpco
         xHI5VKQBG9FuIOt5hEpNTkq+PIswsgz3z8v/VQj5+Og5/TUfu7Zmt6+HQeWxNKnyEaUz
         e1y2ixb/A+B/o/szhPSiW5gMuMw0zzI6Pv675FFIvB9sDM/8t6nUBqEkF7uXa8dx3pdv
         fDZpYiVGLpLavJys4P67KJOIkxWqGN7Dm9fgwwIvwExsF3G2ENZQ+45X1OMPhwWjXSlw
         pysuBGToVKmpdvhOYMOlJh9mKCbAci1bJvAf/O9SGqajaFnv352YzW4BaO9IH8kHwTsp
         Dtuw==
X-Forwarded-Encrypted: i=1; AJvYcCWUTLjmNFfOsSJrkU9tIFgx4PPMc4dYc1Veery8yc4veaf0ghB7iwjGWkJfwc5yVK4MVXlUekaWOnW84XAqI4QoZMRw
X-Gm-Message-State: AOJu0YzFH64S4EFD67LsGLrj4pex9A2jQKWzjmmrKUC7y7g0qrkdAujo
	6Nu24YPu11l0t2PDTBhyVCR1F6v2Rn+6fqWftS1kVBpvrYBCfCf3Ac2LJU5jOjBR66VJeF+FJAb
	lZoWfL/tLZkwKG5Rarxv/2pr9zLLWHg/RaczaLCp20F9c36VWVQ==
X-Received: by 2002:a2e:a7c6:0:b0:2d2:3b18:6ffd with SMTP id x6-20020a2ea7c6000000b002d23b186ffdmr9973339ljp.41.1709118693359;
        Wed, 28 Feb 2024 03:11:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqOhbD2iOLY+ugTcvnejnosxm0uWRyxRkcMKFvjB5ZSJwMYQ9xMyT7/OZhG22VLJQSEK3wcA==
X-Received: by 2002:a2e:a7c6:0:b0:2d2:3b18:6ffd with SMTP id x6-20020a2ea7c6000000b002d23b186ffdmr9973300ljp.41.1709118692897;
        Wed, 28 Feb 2024 03:11:32 -0800 (PST)
Received: from [10.32.64.237] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id q16-20020adffed0000000b0033ce06c303csm14185846wrs.40.2024.02.28.03.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 03:11:32 -0800 (PST)
Message-ID: <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
Date: Wed, 28 Feb 2024 12:11:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Quentin Perret <qperret@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zd8PY504BOwMR4jO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.02.24 11:48, Quentin Perret wrote:
> On Tuesday 27 Feb 2024 at 15:59:37 (+0100), David Hildenbrand wrote:
>>>
>>> Ah, this was something I hadn't thought about. I think both Fuad and I
>>> need to update our series to check the refcount rather than mapcount
>>> (kvm_is_gmem_mapped for Fuad, gunyah_folio_lend_safe for me).
>>
>> An alternative might be !folio_mapped() && !folio_maybe_dma_pinned(). But
>> checking for any unexpected references might be better (there are still some
>> GUP users that don't use FOLL_PIN).
> 
> As a non-mm person I'm not sure to understand to consequences of holding
> a GUP pin to a page that is not covered by any VMA. The absence of VMAs
> imply that userspace cannot access the page right? Presumably the kernel
> can't be coerced into accessing that page either? Is that correct?

Simple example: register the page using an iouring fixed buffer, then 
unmap the VMA. iouring now has the page pinned and can read/write it 
using an address in the kernel vitual address space (direct map).

Then, you can happily make the kernel read/write that page using 
iouring, even though no VMA still covers/maps that page.

[...]

>> Instead of
>>
>> 1) Converting a page to private only if there are no unexpected
>>     references (no mappings, GUP pins, ...) and no VMAs covering it where
>>     we could fault it in later
>> 2) Disallowing mmap when the range would contain any private page
>> 3) Handling races between mmap and page conversion
> 
> The one thing that makes the second option cleaner from a userspace
> perspective (IMO) is that the conversion to private is happening lazily
> during guest faults. So whether or not an mmapped page can indeed be
> accessed from userspace will be entirely undeterministic as it depends
> on the guest faulting pattern which userspace is entirely unaware of.
> Elliot's suggestion would prevent spurious crashes caused by that
> somewhat odd behaviour, though arguably sane userspace software
> shouldn't be doing that to start with.

The last sentence is the important one. User space should not access 
that memory. If it does, it gets a slap on the hand. Because it should 
not access that memory.

We might even be able to export to user space which pages are currently 
accessible and which ones not (e.g., pagemap), although it would be racy 
as long as the VM is running and can trigger a conversion.

> 
> To add a layer of paint to the shed, the usage of SIGBUS for
> something that is really a permission access problem doesn't feel

SIGBUS stands for "BUS error (bad memory access)."

Which makes sense, if you try accessing something that can no longer be 
accessed. It's now inaccessible. Even if it is temporarily.

Just like a page with an MCE error. Swapin errors. Etc. You cannot 
access it.

It might be a permission problem on the pKVM side, but it's not the 
traditional "permission problem" as in mprotect() and friends. You 
cannot resolve that permission problem yourself. It's a higher entity 
that turned that memory inaccessible.

> appropriate. Allocating memory via guestmem and donating that to a
> protected guest is a way for userspace to voluntarily relinquish access
> permissions to the memory it allocated. So a userspace process violating
> that could, IMO, reasonably expect a SEGV instead of SIGBUS. By the
> point that signal would be sent, the page would have been accounted
> against that userspace process, so not sure the paging examples that
> were discussed earlier are exactly comparable. To illustrate that
> differently, given that pKVM and Gunyah use MMU-based protection, there
> is nothing architecturally that prevents a guest from sharing a page
> back with Linux as RO. 

Sure, then allow page faults that allow for reads and give a signal on 
write faults.

In the scenario, it even makes more sense to not constantly require new 
mmap's from user space just to access a now-shared page.

> Note that we don't currently support this, so I
> don't want to conflate this use case, but that hopefully makes it a
> little more obvious that this is a "there is a page, but you don't
> currently have the permission to access it" problem rather than "sorry
> but we ran out of pages" problem.

We could user other signals, at least as the semantics are clear and 
it's documented. Maybe SIGSEGV would be warranted.

I consider that a minor detail, though.

Requiring mmap()/munmap() dances just to access a page that is now 
shared from user space sounds a bit suboptimal. But I don't know all the 
details of the user space implementation.

"mmap() the whole thing once and only access what you are supposed to 
access" sounds reasonable to me. If you don't play by the rules, you get 
a signal.

But I'm happy to learn more details.

-- 
Cheers,

David / dhildenb


