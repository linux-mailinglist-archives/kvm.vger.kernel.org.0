Return-Path: <kvm+bounces-58982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA81BA8ECC
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 136BA1896A7A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548CB2FDC31;
	Mon, 29 Sep 2025 10:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gfE83TzP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23623ABBD
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759143102; cv=none; b=KFeCThlbypzFkOM1RZjbiOFd5v6HSerN6jOBGvpa8BQui1EyMk5dETWyo2R5fu84qcyIrYRPZqshs/lxoEK8jTgO0n65riitgzwGWMhCtIdGV9UrQhoc4jl7ENzeCvvjLEqQxZGFrtZ8gfGmzQyU4KzW/YIER1PI3jx6KYvr5j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759143102; c=relaxed/simple;
	bh=LzEZ2/dhCjTWdQftkSSjdob7yAZT7nHLYi+hulrrV30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szixCzdQslDAhzb59C93ljfaZqkxx152QF7AjmsdpL1rpXWdK2INoX0n7oqcpXImR7bOYQA+Oa1ys8n4x2apODJ4Myuwt3NY7a10K/tpH5wEa6GpPmFYBJCCRra1j8mUeRUS+WOcO2tv3T3fbBqfT1sD0wTQfdxFCTgImrxlAZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gfE83TzP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so4218137a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 03:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759143100; x=1759747900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pQyMa9IZafjPV4fHO2pn7TEdK9WnUbPn3gYDAoIk10w=;
        b=gfE83TzPs6TmyrnYxLpp7bahvVoH/v6cnIxbK9jTjdz+BH/7cNj2rTSODtHwTJbLdT
         L/6nhgHcJ5QQWZhi7Gp+026vMmFu7Bso6v7/mTYujl3JjKrt8Ofyzyp+0dkHpxNNCqLu
         iLneWxG2QLiVTfrb1AuCg6PuSiqT6ltcCsw8fdYidenkCk7oGy1CuD2VY2e0ipzhW/QY
         qZx3AsafUR1dXglpatoAfPvt8XWQddSZKrgRKzxQVo5SNnFRup1W31awYR3bmRzi/p0z
         FcvtIyxKfvFoRnzbHiQqI08efaykXfPmuoOxoArE2yRo9EYpoEWGyw7+gs18/yOj68Qr
         5wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759143100; x=1759747900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pQyMa9IZafjPV4fHO2pn7TEdK9WnUbPn3gYDAoIk10w=;
        b=pcfklpC0vAOJDmsP7IAWB1OmAb4juYwj5nWY1s7ke330Zj4yuvRe+eaReMyW0Klhua
         uTcurO0UsO4V399uOPgeGkouFVeiOZbQsJU/9xqGQxnxJ5yPzuMkdjjNs+Mspf+etzSi
         vplZrAXx48dvcMynsJFzRsxAVL5OiuO0gKM8SCObDiAonaMDwHj14Qoc3M37d+JttTbB
         O6bgdshMg2PIga42AkXN81WW9eRFb2TaBEazEymBnkPkGFGmctT/z/xmkbUXlYwaEKHs
         476fVZ9ntuZjVJv2+4Nt49zCC/sPHrBB5JoVsxskwLqT52FYm1BUwVs+w43dtvmWntDL
         GVcw==
X-Forwarded-Encrypted: i=1; AJvYcCXS8M5v1i15yGGjcF6F53v4wz0VWKtDmTCXOR0fj5DGUtwTJZYHvQaMcpzQwGeh9l1AaOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2cHQqmIIbHaCRG4NtwM1C+fBK4doJGKW7bcwKcEa1Z1edNCSw
	yRSLi9s9AXQypkKOVw9RwNd2qEak/PBTV7kFN6uSmX31/7qHmrV7JfQiZ3PuJ0IAunMc6c7hS2j
	2XdfQ+20qJFZ818jdlnWGGXJMMw==
X-Google-Smtp-Source: AGHT+IFxJJNxe7laPnxH4NpYyZ4avyYjDRc1ZldL5pKLhexm/Zv9qltc/dxoYUE4isWavpY6yHz7A+0cmp5pTsD8pQ==
X-Received: from pjbci3.prod.google.com ([2002:a17:90a:fc83:b0:330:62e1:cda6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5548:b0:335:2bdc:1cfa with SMTP id 98e67ed59e1d1-3352bdc1ea4mr12877758a91.24.1759143100344;
 Mon, 29 Sep 2025 03:51:40 -0700 (PDT)
Date: Mon, 29 Sep 2025 10:51:39 +0000
In-Reply-To: <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com>
Message-ID: <diqz4isl351g.fsf@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Patrick Roy <patrick.roy@linux.dev>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

>                           GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>>>>
>>>> At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
>>>> GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
>>>> checking for that, at least until we have in-place conversion? Having
>>>> only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
>>>> isn't a useful combination.
>>>>
>>>
>>> I think it's okay to have the two flags be orthogonal from the start.
>> 
>> I think I dimly remember someone at one of the guest_memfd syncs
>> bringing up a usecase for having a VMA even if all memory is private,
>> not for faulting anything in, but to do madvise or something? Maybe it
>> was the NUMA stuff? (+Shivank)
>
> Yes, that should be it. But we're never faulting in these pages, we only 
> need the VMA (for the time being, until there is the in-place conversion).
>

Yup, Sean's patch disables faulting if GUEST_MEMFD_FLAG_DEFAULT_SHARED
is not set, but mmap() is always enabled so madvise() still works.

Requiring GUEST_MEMFD_FLAG_DEFAULT_SHARED to be set together with
GUEST_MEMFD_FLAG_MMAP would still allow madvise() to work since
GUEST_MEMFD_FLAG_DEFAULT_SHARED only gates faulting.

To clarify, I'm still for making GUEST_MEMFD_FLAG_DEFAULT_SHARED
orthogonal to GUEST_MEMFD_FLAG_MMAP with no additional checks on top of
whatever's in this patch. :)

> -- 
> Cheers
>
> David / dhildenb

