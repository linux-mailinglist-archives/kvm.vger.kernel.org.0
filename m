Return-Path: <kvm+bounces-68233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7717FD27B40
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 859E2305C4DC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2774C3C1FDF;
	Thu, 15 Jan 2026 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ap2KEeHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F953C1FCF
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500842; cv=pass; b=uFfeHwqcT37jKygEMHR+VupOeIsJgXolrB+u0ls4huwAh5CoZQpVBojzHm9HuvsS1dQ1DQITOZTC4gtRASM3c9YEw6kip7fxKmgkMTHoi9lPFylMtsnflBc9ENczJP4aZqdhmHyvzxQ5tI5Kxnpu2KECsqPY986uAsJkMg2JcsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500842; c=relaxed/simple;
	bh=yZFI4/ItU0VjZ/966VFXXZ++AOqCW4LQRyI7osYy944=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=atJ53hzKTR+addvOTWn1MlG3fM5cWb1q/0WobF26nl58e459WJMRkCA7EBs1HkcNNqmERILJZvHcoKwrtklvM3fJtDWcg3h+3znZcu1m5soGH9jnzjSP3Asx9BLu9q1lbNagCUKELrgjDkavuzK/YXODuKLxXP564gj3KFF5BR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ap2KEeHs; arc=pass smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5637b96211aso1075614e0c.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768500839; cv=none;
        d=google.com; s=arc-20240605;
        b=GMdMfMy0V1GA9w1AkpM8EbJu2qB8/lTPkdCxU3/27X61lbVeSdVullxDoUTysqnkp/
         ifFHWoilMONTRVQOGbis/1KfLxWfbmmsFcf+sFknaToBhaai/x2SFddcEArfr7FkadXs
         RzOyWaRdrM1yuLhU+1DeIn6BM/ha9sPjJmRpLEfJtIz427oG539RyVCFYm4cDFFsrlr2
         DxlUPzjOEqACXhzHe56Bvp1tQYr6jDeBp7PwV4Z6Cwa6Glk2vJypDlh8Rb4FbosCsWpb
         YQwzbDdvTC/8LvDVRWjBIkklglhDv4BlH+yUBgTp+V9Xg2coxfUsMhSXrVvAgu08G5wN
         rpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=THW1AYc40AbtlCiXnGDVyVMD3rqCp5iY5wWFFFterBw=;
        fh=EbgfIogE5cnV/5DDRN2xv+VrVjYfdJSW9AdnvT1HT+k=;
        b=bvo3vn+3eIfs1hwEj8A+cODoPklvsQpsKxCf6XDhxnovuQjw9x5JiWtkFBrPDZ2+dm
         9hMdMdlMhUedAZVkoIS25kNouDpeOIdU2xbgUgwxPhjg75TDgQq+9f8QZ+/47+b5ZqiX
         CQVFsTwz0fgtmZvP9Mo+EqdQ6uJymcXa3/pP/19yc+fMC5MGEBfdKU05vZhKOM7DHVyX
         HH7nvotbcaB4LM7pNxxP7ce7D/+7IOad0oM55+8z5JLQcUZdILZNWmLarSkTd+y22+nJ
         r4jgqqe85zkBb3eCTuzdmR63PNgyGXMkmRjQI4oVXZHXR6rcDlKgJFPeLjqL0tauIJGp
         Q/lQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500839; x=1769105639; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=THW1AYc40AbtlCiXnGDVyVMD3rqCp5iY5wWFFFterBw=;
        b=Ap2KEeHs1hljy6vFGeqVQYsded70yUxD6rn3T/pdW0oSlvACQPG+Ti3bKFz7gFClNc
         RMqz0HJCyQLtjLGX/knv4GSRbV55b/i64M2nh5mBQkRTbANYTA8IdTQNPgll9BkOWKhh
         nX2HRJS8CqX53AH4Z+VNb/KByD2bYu/JYRY6SILN8vFkZCLut0qyWE1g0LsjeLJn3JxL
         BtzyCPlLDxT3ZznoYkag2JuLGhj1u6RiEqSCoHuNWcsvdzD8MjdUsYo9TlxMSEiBLlCW
         y2S/eL5Z00mBWE2D7IiRs0UTpSt9F42h3i2nuVlGVxornCSIBnXtU+VRu7XZZb4imMGu
         oDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500839; x=1769105639;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=THW1AYc40AbtlCiXnGDVyVMD3rqCp5iY5wWFFFterBw=;
        b=lmPQV0wvDJ+heB285HKt+2qhp0Z5Sr2hPBwffi/A1vovXEUfxqmghnE5R99f7ISFPn
         7brAi1IWVQexQVfJZeCvjh1M5J3QlidDKAtqB6Lbz3dhKDmW1zvM9R0sLdOcJbmMITsm
         eOxsehhDB5N/pWeFRGvGxjkSUA+GbP1RgUztEcdOPevfVT4Mc43m5VDMNHxYF5yMRko0
         /sw75hXQSd+ACQEC/uCzornHBZoXq9nq6y7t1O0nmxyVQZhK3sJ4c3OLAz27BvkUdfs5
         IOSdSxUlp8H7hnXGGfvdA+h3Br5ov+RvirsLYjOKeq8c+oVqTVmD3eEEBqwmY3Qhv9AA
         BDnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsYzOxhvzABka++0Nga7mV+GkF7lyUEomy8envFWj7SkIA+m8ignco/KBkisIaqJQ7N+s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0jKDihGK7dfEMBfpZWWUniq3YiuRV7pVp094fWsL4JJbjCYcT
	wePrx9WKl72qj+S7JlFGYVUAAwL37kSD6mcJFxYLxG0AgXzAr2RUwaBNoVE+9VaJ3/RhgTdIHyE
	c/Xj67wcpbssIS1HC6syr1Ojq2gZSLkg6A4vn6V4HoB43fwAJ/WHLoy9GbpE=
X-Gm-Gg: AY/fxX4bGh280qInyPXENyQwE5StP7bVO+OI8ZQ8CuFgUasxvdwSygvcyJkc1X9SrGk
	UOqOHFro7XAp3gMnHE7MRVyv4SZvTwjii3yw3VPMx1XC93qgYsMe5bRyOyEdJRzuSMKoy45wEzs
	csbmI2jGGMXANAKSHEm+DooVQoqMTembSHGhLEqHajGE2b3aDBu4MEiKWMmK+LUTaMfKTshhI+u
	pbC7eoOLYZQMflWa39ACwTQ9TZ9QJpdoGH78Wpj+4kKLO4vHdNOkUYw8HSCMwkzWvsbmvALz/2H
	dJ8aHUPwOfvwBHiHGDDsKSstqQ==
X-Received: by 2002:a05:6102:a48:b0:5db:cfb2:e610 with SMTP id
 ada2fe7eead31-5f1a55dce21mr211044137.41.1768500838995; Thu, 15 Jan 2026
 10:13:58 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 10:13:58 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 10:13:58 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aWhaK+ikw8QkH4hU@yzhao56-desk.sh.intel.com>
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <CAEvNRgG40xtobd=ocReuFydJ-4iFwAQrdTPcjsVQPugMaaLi_A@mail.gmail.com> <aWhaK+ikw8QkH4hU@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 10:13:58 -0800
X-Gm-Features: AZwV_QgJWa5xE7L7BcNYbcYrcLnI3mZbKkK_YSll-kBeBO63P1k4Zv4BKXAljiQ
Message-ID: <CAEvNRgGrPr3f9qpfW3KHx-fFLqYOL4u2pQkMUDqfC2-Lh63ePQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, Jan 14, 2026 at 10:45:32AM -0800, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> >> So, out of curiosity, do you know why linux kernel needs to unmap mappings from
>> >> both primary and secondary MMUs, and check folio refcount before performing
>> >> folio splitting?
>> >
>> > Because it's a straightforward rule for the primary MMU.  Similar to guest_memfd,
>> > if something is going through the effort of splitting a folio, then odds are very,
>> > very good that the new folios can't be safely mapped as a contiguous hugepage.
>> > Limiting mapping sizes to folios makes the rules/behavior straightfoward for core
>> > MM to implement, and for drivers/users to understand.
>> >
>> > Again like guest_memfd, there needs to be _some_ way for a driver/filesystem to
>> > communicate the maximum mapping size; folios are the "currency" for doing so.
>> >
>> > And then for edge cases that want to map a split folio as a hugepage (if any such
>> > edge cases exist), thus take on the responsibility of managing the lifecycle of
>> > the mappings, VM_PFNMAP and vmf_insert_pfn() provide the necessary functionality.
>> >
>>
>> Here's my understanding, hope it helps: there might also be a
>> practical/simpler reason for first unmapping then check refcounts, and
>> then splitting folios, and guest_memfd kind of does the same thing.
>>
>> Folio splitting races with lots of other things in the kernel, and the
>> folio lock isn't super useful because the lock itself is going to be
>> split up.
>>
>> Folio splitting wants all users to stop using this folio, so one big
>> source of users is mappings. Hence, get those mappers (both primary and
>> secondary MMUs) to unmap.
>>
>> Core-mm-managed mappings take a refcount, so those refcounts go away. Of
>> the secondary mmu notifiers, KVM doesn't take a refcount, but KVM does
>> unmap as requested, so that still falls in line with "stop using this
>> folio".
>>
>> I think the refcounting check isn't actually necessary if all users of
>> folios STOP using the folio on request (via mmu notifiers or
>> otherwise). Unfortunately, there are other users other than mappers. The
>> best way to find these users is to check the refcount. The refcount
>> check is asking "how many other users are left?" and if the number of
>> users is as expected (just the filemap, or whatever else is expected),
>> then splitting can go ahead, since the splitting code is now confident
>> the remaining users won't try and use the folio metadata while splitting
>> is happening.
>>
>>
>> guest_memfd does a modified version of that on shared to private
>> conversions. guest_memfd will unmap from host userspace page tables for
>> the same reason, mainly to tell all the host users to unmap. The
>> unmapping also triggers mmu notifiers so the stage 2 mappings also go
>> away (TBD if this should be skipped) and this is okay because they're
>> shared pages. guest usage will just map them back in on any failure and
>> it doesn't break guests.
>>
>> At this point all the mappers are gone, then guest_memfd checks
>> refcounts to make sure that guest_memfd itself is the only user of the
>> folio. If the refcount is as expected, guest_memfd is confident to
>> continue with splitting folios, since other folio accesses will be
>> locked out by the filemap invalidate lock.
>>
>> The one main guest_memfd folio user that won't go away on an unmap call
>> is if the folios get pinned for IOMMU access. In this case, guest_memfd
>> fails the conversion and returns an error to userspace so userspace can
>> sort out the IOMMU unpinning.
>>
>>
>> As for private to shared conversions, folio merging would require the
>> same thing that nobody else is using the folios (the folio
>> metadata). guest_memfd skips that check because for private memory, KVM
>> is the only other user, and guest_memfd knows KVM doesn't use folio
>> metadata once the memory is mapped for the guest.
> Ok. That makes sense. Thanks for the explanation.
> It looks like guest_memfd also rules out concurrent folio metadata access by
> holding the filemap_invalidate_lock.
>
> BTW: Could that potentially cause guest soft lockup due to holding the
> filemap_invalidate_lock for too long?

Yes, potentially. You mean because the vCPUs are all blocked on page
faults, right? We can definitely optimize later, perhaps lock by
guest_memfd index ranges.

