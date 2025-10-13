Return-Path: <kvm+bounces-59954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEEBBD6C11
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7D19188D7EA
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290D32D8767;
	Mon, 13 Oct 2025 23:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hY0brkGM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B379320D4FC
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398845; cv=none; b=gEOlqmQluB06MkcFhSGNlTBiX3sQOeU3ufFxY57TL4AXE6i4kF29ZhD1s4GvmvnhrL/cW1C8AUDt2chwce55Js4JvrVop5IAHIX3wYoHwoddnd9/C79K8GNVVBIQ6xRhKRu1FOnzwawEeQ+9ryp2WEJAgaysJZKGoj+lhz5R0x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398845; c=relaxed/simple;
	bh=4HbQaiebifP/uaw3gh2CltXpgChOQ3y3FWMK/EHFhFU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kNwSA+xCbDa9+2hLPEcAtl5KEV9uysAb/ZKr7xM+xcktgPju88kAKHn+TFZTuyu0bvTbGHn8Y2W5l37gAw6lkzlKaR9XBQ/ecUfK8eZuE54BdSTLLGwGTFmcW+d4XqB7U7hbQ62LrMGCE5DHzjCurjQbn4+ML5+CdLmw+mh/01g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hY0brkGM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc5bso10716490a91.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760398843; x=1761003643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LuCv42knJSvWPGZCi6YRzjp9+rV6aRxcGwjs0sLZ3EQ=;
        b=hY0brkGMKU+VjVHTBPoXCgRgNBQyExx2u+P69vWgUQzm+sXmKK/4JDygICy/yWY5z9
         17AQUyCGiNOR9p+rv5GyBYokO8pQyKWwVvPAMfKYXDwNkb8xRbF4+4yUbsFzn8AlIYeJ
         zUEL2ihnmYYh2X66/45nTIa6rIYH687NeyVBERPPjdM5zT3KG5Iad/GHn6Iui9o+DNMz
         njztvKeX3GhYu0ErlWxBplSCVqGg5CXrDb9yBaRYAyNSlsZoyaf7C9X+vZiu/SoYBmf1
         3IIkCKlwmxaJdvJknEJeZtRBG/gl5qBWYQ7fVyZDowF5v+pE+ATwDoDmShw5I0rcZJvC
         TH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760398843; x=1761003643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LuCv42knJSvWPGZCi6YRzjp9+rV6aRxcGwjs0sLZ3EQ=;
        b=Wa9XHHw9KmJq57kIx9Uj3e2VuuLbMl1fQjoyBoamqiXbROkjel14FkaFRhPKz1jSnm
         +graHaNjEvDxOFthUYeC/LXG7G74+F174LH0/0PVlr9S2PfcbxMSwasO6XmXGfEt+Uch
         l/CjjG8qUybgZckadbmO6ZCYT23jjZeZZMgx1rj+iIDkwYIce4jlkU6OWA+mG3711Xl/
         L1zMau6UrxDr06yxtOlIW2uY4rMZkrYwS3PTmlbghgJfhic8TKGysPmY1IikNU0KJcg4
         QIDbCCZ78VdB9fk6kPtXo3+WZxFSZ912hD86H6EwnDf4JzMANZneXi5X29uIcFKhSkCJ
         ZPVA==
X-Gm-Message-State: AOJu0Yydt3g8pA2MfFgmVbOUeJ0wZBaHEg+7OXy0YVauiDehYKECu1qB
	VyYCupGeyTWH6or+H+GBCYUhq/DUvba1bMwdRh8y7WFtyDXO+Kvyou0S5UDWRxrTIuEo4jfAovy
	TeGHPHonzgg1R64MaT19/YFDvbg==
X-Google-Smtp-Source: AGHT+IFYL56IzGe+nF5Cx8R9PEtLWE/QJbrRM1U7iHiwqprkpK6S2NIdeMU6jb8l3teFwOpZvQZ2zV9L5qDMdxuAhQ==
X-Received: from pjup11.prod.google.com ([2002:a17:90a:d30b:b0:336:8f7c:2a8e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a8a:b0:32e:8931:b59c with SMTP id 98e67ed59e1d1-33b5139a212mr31781862a91.27.1760398843072;
 Mon, 13 Oct 2025 16:40:43 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:40:41 -0700
In-Reply-To: <diqzy0ptspzl.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com>
 <aN1bXOg3x0ZdTI1D@google.com> <diqz1pnmtg4h.fsf@google.com>
 <aN3KfrWERpXsj3ld@google.com> <diqzy0ptspzl.fsf@google.com>
Message-ID: <diqzjz0yfk06.fsf@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> 
> [...snip...]
> 
>>> >> > The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
>>> >> > union to clarify it's a pgoff instead of an address when used for guest_memfd.
>>> >> >
>>> >> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> >> > index 52f6000ab020..e0d8255ac8d2 100644
>>> >> > --- a/include/uapi/linux/kvm.h
>>> >> > +++ b/include/uapi/linux/kvm.h
>>> >> > @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
>>> >> >  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
>>> >> >  
>>> >> >  struct kvm_memory_attributes {
>>> >> > -       __u64 address;
>>> >> > +       union {
>>> >> > +               __u64 address;
>>> >> > +               __u64 offset;
>>> >> > +       };
>>> >> >         __u64 size;
>>> >> >         __u64 attributes;
>>> >> >         __u64 flags;
>>> >> >
>>> >> 
>>> >> struct kvm_memory_attributes doesn't have room for reporting the offset
>>> >> at which conversion failed (error_offset in the new struct). How do we
>>> >> handle this? Do we reuse the flags field, or do we not report
>>> >> error_offset?
>>> >
>>> > Write back at address/offset
>>> 
>>> I think it might be surprising to the userspace program, when it wants
>>> to check the offset that it had requested and found that it changed due
>>> to an error, or upon decoding the error, be unable to find the original
>>> offset it had requested.
>>
>> It's a somewhat common pattern in the kernel.  Updating the offset+size is most
>> often used with -EAGAIN to say "got this far, try the syscall again from this
>> point".
>>
>
> TIL, thanks!
>
>>> Like,
>>> 
>>>     printf("Error during conversion from offset=%lx with size=%lx, at
>>>            error_offset=%lx", attr.offset, attr.size, attr.error_offset)
>>> 
>>> would be nicer than 
>>> 
>>>     original_offset = attr.offset
>>>     printf("Error during conversion from offset=%lx with size=%lx, at
>>>            error_offset=%lx", original_offset, attr.size, attr.error_offset)
>>>            
>>> > (and update size too, which I probably forgot to do).
>>> 
>>> Why does size need to be updated? I think u64 for size is great, and
>>> size is better than nr_pages since nr_pages differs on different
>>> platforms based on PAGE_SIZE and also nr_pages introduces the question
>>> of "was it hugetlb, or a native page size?".
>>
>> I meant update the number of bytes remaining when updating the offset so that
>> userspace can redo the ioctl without having to update parameters.
>>

Was working through this again, I think the attr.offset returned from
the conversion ioctl is not the same as other syscalls where an updated
offset+size indicates "got this far, try the syscall again from this
point".

For the conversion ioctl, -EAGAIN indicates that a some unexpected
refcount was first found at offset error_offset, but does not imply that
everything up till error_offset had been converted.

This arises when we start to have hugepage support. To restructure
hugepage-by-hugepage, we will iterate hugepage-wise and check for
elevated refcounts.

Suppose we're converting 10 1G pages and on the 3rd hugepage, the 5th
offset has an elevated refcount.

error_offset should be set to the 5th offset in the 3rd hugepage, but
userspace should retry beginning at the offset of the 3rd hugepage with
size 8G.

If the offset returned to userspace is the 3rd hugepage, then we lose
precision. The refcount at the 3rd hugepage could be fine and expected -
it is the page at the 5th offset in the 3rd hugepage that is pinned and
userspace should be unpin.

So perhaps the interface needs to be defined as

If the error is -EAGAIN:
   + offset: the offset to retry from
   + size: the remaining size to retry
   + error_offset: the offset where an unexpected refcount was found

>>> 
>>> [...snip...]
>>> 

