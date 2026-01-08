Return-Path: <kvm+bounces-67458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D0568D05BEE
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 20:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A22D03014D46
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 19:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576EC314A80;
	Thu,  8 Jan 2026 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fCeCM33w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8E031D381
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767899151; cv=none; b=bdUzafQmzOYibPmM5EUbpOOt2vaJUrHTUycQzWG1hAZzBLoENAdmVzViLaVdvYFmK4OTcwY3RJgWW2r04nJAonjmML5eLp2I/XKYg9CIhEImLeqdwyRaVjTetqGhbi25oDttO4/zOK9X8XFkC/R6HV8J2pAaWVYW4UpPyPr8a60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767899151; c=relaxed/simple;
	bh=9BChihpFJb9yMbO79mCxZeVB3F57zGer+Nvh/acZ9lM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgJEBpzNFf+bbyeI03/n2wV/JlkqP4FpbTelB/KG6eynl+hPeNQNR6lbkkzqbkrYBYmHYon8BpOuy0+JLJsH4OP27tL/6nltbbjedVXJJ3VDC0MGzaaNQn036iS1dhl2hcCZgLhwK1qPH9akYsYnXphQT+jujkEKhQL1CQc6M9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fCeCM33w; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-93f6bd3a8f4so1090287241.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 11:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767899147; x=1768503947; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c0rLmXgclHK8nnb12L4AD8zjwxha/k3v7p0/rL5YdXM=;
        b=fCeCM33wcZtOzaQ+k8QLK6XHQPLWEk9AxKFUSx7qE3MQCWy6pjWSyJuNO7/MyQi+uT
         SN8CsPfUdbiW1RZrc7K5Ns3625uZL8KW7FjIy5rb39EGHk6q6aYFbr5edGCQ7cosasBW
         pO6T99tdwuiHjoQ2RHpqsVfe9D5WdeD+TiPvOD56jnW7VBxYNYw4wPx94RBEmwOfrUgx
         caFSne8T9OUEsYFeVPtFClpqf3gtkvAfFvlzF7xPklB7ti/0TLGal0rj2pCQa+Ka5mRo
         8Qk+xdlVp+gI+UTIUMF/2FSmQSmEG7fKM2KzO3A58+G+utrAl6HCgA+4lReHGnok7fjH
         ttkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767899147; x=1768503947;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c0rLmXgclHK8nnb12L4AD8zjwxha/k3v7p0/rL5YdXM=;
        b=QjojImUSgprsHcUStoT9R8JH3yN+6mtEn7O0JRzaoxNRNBxa0PvduFCEWOWAiIzm5A
         oZDasYyOiLyzD/FUvJSoyRJBXq3JxHv7rOfSW/0XgQx8WAaCPF0g4hNHm8SBJ2yf+lLB
         pnirhy4o7JUpTPi02SHgstW35sQ1eWXR6HeunjYy71FddcybS4SYoLJd+dayghFB1eY8
         43XfMJKSBInS9pSNNDwxSs4/YD9MDyCZtYBXmzTatCj4x9gZidVwhIX7kE3G+qT9Pc9F
         0to/pAclUzlPP79WixWd9OIVCe0ZbWjsyn4W95C1CFn3jrgzSOo6cZUkcFEuDom37AC/
         /kww==
X-Forwarded-Encrypted: i=1; AJvYcCX/T2QnmGSWcE0xtKAkAcD2YvjnxxkGqaZYoIQluAebXKGy3CHHrU86+x02HP5FFaTrR8I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHp07oRBUn7/ahLG/e5CGjkHFopTyk4BHy3Zr3TDZwGzNqaFda
	4TINOHAqHf7QWE0RiD5ludw48hm/MHXPTSsXjYYduC3NPJ13TO73UnK8gp72ZhvrLBqSDpIVhj5
	xk2AN8Hkn3eyLHMOM4428g91Kfq2OgQ4QndYSuRDJ
X-Gm-Gg: AY/fxX5puT5gDkZSEg3SneKWDFEB5aF0FPargsgm54Cum6Cum/i5Ck3FBNJA8L14vDs
	9OwCjoBdbSESx4NE+wfm5MqD7uWpe+FVVgCE61zirHNVrLesM9iBE6NvoCBT4892FJoLsMX3ivz
	yHqOg9dn2eboTuoBUoPmgWs498G8NnEdDx5Xlqj9dVgPiGSUpx5qHwT1E5IPkyRy4/OCYiQiQ/2
	xEKO/xhPjAvfeW1tpf0hg+m7SQoe/+xMd+TlAsGR8r+SF8MtOYgxDT0Wkje0vRtQAtCUjFxijRP
	5mOdXeSRVP/ms5zATu9TnVpqfw==
X-Google-Smtp-Source: AGHT+IGNixXUxR3kEzGTN9dZO0g5l/frBi040eKjpkiXE7PGonrbfHytxvCzgU9d+tgzhOHsoiieQ4I6ABLzU4Dzazc=
X-Received: by 2002:a05:6102:1629:b0:5ed:f13:e58a with SMTP id
 ada2fe7eead31-5ed0f13e8b0mr2004421137.37.1767899146708; Thu, 08 Jan 2026
 11:05:46 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 8 Jan 2026 11:05:45 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 8 Jan 2026 11:05:45 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com> <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 8 Jan 2026 11:05:45 -0800
X-Gm-Features: AZwV_QhAO4Ayg3WNV23R32l2YOMQ96czVzOuMvLbv0X9Kgpgg9nuwFfG8gHtvjQ
Message-ID: <CAEvNRgEA69UL_=T+vE6z0wxNf59ie9neSbpyrp58_784C8vL9w@mail.gmail.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Dave Hansen <dave.hansen@intel.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, tabba@google.com, michael.roth@amd.com, david@kernel.org, 
	vannapurve@google.com, sagis@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com, 
	fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com, 
	jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

Dave Hansen <dave.hansen@intel.com> writes:

> On 1/7/26 01:12, Yan Zhao wrote:
> ...
>> However, my understanding is that it's better for functions expecting huge pages
>> to explicitly receive "folio" instead of "page". This way, people can tell from
>> a function's declaration what the function expects. Is this understanding
>> correct?
>
> In a perfect world, maybe.
>
> But, in practice, a 'struct page' can still represent huge pages and
> *does* represent huge pages all over the kernel. There's no need to cram
> a folio in here just because a huge page is involved.
>
>> Passing "start_idx" along with "folio" is due to the requirement of mapping only
>> a sub-range of a huge folio. e.g., we allow creating a 2MB mapping starting from
>> the nth idx of a 1GB folio.
>>
>> On the other hand, if we instead pass "page" to tdh_mem_page_aug() for huge
>> pages and have tdh_mem_page_aug() internally convert it to "folio" and
>> "start_idx", it makes me wonder if we could have previously just passed "pfn" to
>> tdh_mem_page_aug() and had tdh_mem_page_aug() convert it to "page".
>
> As a general pattern, I discourage folks from using pfns and physical
> addresses when passing around references to physical memory. They have
> zero type safety.
>
> It's also not just about type safety. A 'struct page' also *means*
> something. It means that the kernel is, on some level, aware of and
> managing that memory. It's not MMIO. It doesn't represent the physical
> address of the APIC page. It's not SGX memory. It doesn't have a
> Shared/Private bit.
>

I agree that the use of struct pages is better than the use of struct
folios. I think the use of folios unnecessarily couples low level TDX
code to memory metadata (pages and folios) in the kernel.

> All of those properties are important and they're *GONE* if you use a
> pfn. It's even worse if you use a raw physical address.
>

We were thinking through what it would take to have TDs use VM_PFNMAP
memory, where the memory may not actually have associated struct
pages. Without further work, having struct pages in the TDX interface
would kind of lock out those sources of memory. Is TDX open to using
non-kernel managed memory?

> Please don't go back to raw integers (pfns or paddrs).
>

I guess what we're all looking for is a type representing regular memory
(to exclude MMIO/APIC pages/SGX/etc) but isn't limited to memory the
kernel.

Perhaps the best we have now is still pfn/paddrs + nr_pages, and having
the callers of TDX functions handle/ensure the checking required to
exclude unsupported types of memory.

For type safety, would phyrs help? [1] Perhaps starting with pfn/paddrs
+ nr_pages would allow transitioning to phyrs later. Using pages would
be okay for now, but I would rather not use folios.

[1] https://lore.kernel.org/all/YdyKWeU0HTv8m7wD@casper.infradead.org/

>>>> -	tdx_clflush_page(page);
>>>> +	if (start_idx + npages > folio_nr_pages(folio))
>>>> +		return TDX_OPERAND_INVALID;
>>>
>>> Why is this necessary? Would it be a bug if this happens?
>> This sanity check is due to the requirement in KVM that mapping size should be
>> no larger than the backend folio size, which ensures the mapping pages are
>> physically contiguous with homogeneous page attributes. (See the discussion
>> about "EPT mapping size and folio size" in thread [1]).
>>
>> Failure of the sanity check could only be due to bugs in the caller (KVM). I
>> didn't convert the sanity check to an assertion because there's already a
>> TDX_BUG_ON_2() on error following the invocation of tdh_mem_page_aug() in KVM.
>
> We generally don't protect against bugs in callers. Otherwise, we'd have
> a trillion NULL checks in every function in the kernel.
>
> The only reason to add caller sanity checks is to make things easier to
> debug, and those almost always include some kind of spew:
> WARN_ON_ONCE(), pr_warn(), etc...
>
>>>> +	for (int i = 0; i < npages; i++)
>>>> +		tdx_clflush_page(folio_page(folio, start_idx + i));
>>>
>>> All of the page<->folio conversions are kinda hurting my brain. I think
>>> we need to decide what the canonical type for these things is in TDX, do
>>> the conversion once, and stick with it.
>> Got it!
>>
>> Since passing in base "page" or base "pfn" may still require the
>> wrappers/helpers to internally convert them to "folio" for sanity checks, could
>> we decide that "folio" and "start_idx" are the canonical params for functions
>> expecting huge pages? Or do you prefer KVM to do the sanity check by itself?
>
> I'm not convinced the sanity check is a good idea in the first place. It
> just adds complexity.

