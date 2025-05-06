Return-Path: <kvm+bounces-45661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E04A8AACE01
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 21:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFDCD1C08857
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 19:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E41B1FFC49;
	Tue,  6 May 2025 19:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NckfbhH+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4806E1C5D72
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 19:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746559668; cv=none; b=I/9lXm64TMaDKKGJ6WSJvJwvB3ZV9JVIrlwcX05wnNREjCtp2gopczAtcTBFkq/y45HRghR8O+uFWhICp/xWubsX1B1rJf57exFNRDjnIKqMxcysixCgaMFgu5P0cS+vXOob57hqmtiaZbSgix2RRRaejHhR22CeOKLS8UDURyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746559668; c=relaxed/simple;
	bh=WnmemFGsum/NSWAD4/LRqz6X1+7V15M0U8ZSkc+Jfqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m6Z7aOOOx0AwXvYRrlCOD8+zOm4+r5v762uvFy098/a5LDsFQEnHXrsvrlBhA/MPE3aYN8GmxiDPCG6AigPp1hkW+3IEK9INozCPd6ffblcFSeMiO+UpdErEpvitrILmPRxx8NoZvVscIrwl/BaDI8wVzeIYLWqIQZjkjfqu8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NckfbhH+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1c122308dcso6457029a12.3
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 12:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746559664; x=1747164464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FSSDBoDG6KZDkLxr1Y/KOSWZ+T98/cIvH+Cf5kfE58k=;
        b=NckfbhH+9ZvhNanz2xuh7iiSqPsA4IFJ57cZcFsEQjBxskp/EUgXSDZc55FwwnmYhO
         e8UH3cEfCkIJN4K6eWPcwWPQGawr9MlgW1x4Sh7uHqvuSkbwc4BGsuQ5mkJI7GsqXr7E
         VrJF9DVZpVsZySW5F4kuILX3x6aNMlMMt6TyvsI57fEvDm4N8OpcqTQVh9/pnvOIk9tz
         gNmEtJtxG+VcOlU1DvpiG9L89gVdoJ0xYApiZVOVdQ2vzN2RKHCpyIjQmR1wh1K0scfc
         smmFG0dy7E1yeJJLno4+5jIUkLt2rQGWPZwYRVMzxYv6A4a2vaOCqzLW1s1D8CKtcApR
         upBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746559664; x=1747164464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FSSDBoDG6KZDkLxr1Y/KOSWZ+T98/cIvH+Cf5kfE58k=;
        b=tHd06ThsMP8WUdaY3wZiBIARRUGmbNgiJhCqbPX7mNpeNbwLfNtfwcOsMkXgvbm7iN
         J5WS4lUmxOYDuTwCSLrQvYq9K2Rsffytxcpkfp+0u+jtfnBFNTExBX76j11nr0pxrCtr
         j1I97HNq2+DdLqgNvxTSvf6tBJBYG3BMU1LAjxSjjk0bkngx6mzWTVFQzScpp70OobKE
         yCgU2MBHQOqTpOMxdWPQsXRQEMgdQnPcO/86kYjAgAPPCtBdeuT50YJaQFrsscDvYdnf
         Gv7Gfn6RNKVtrjx3adiHjW7rZdLPH8vixGgFdUfj+TxCdiertdGJ8YhuPNbwYDNEOzPx
         AKhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbV8LbA37q5QrCH0lS7IUoW5ulZeuZyy1AS4+Fnu1xMWFM08I6w0mgpB8EyA8GqRdGJ58=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWKWdvhw3K8NR0QMyWqEveXhf+dObK6Z1B4tvO3N6ofUm1h4RN
	nSsr0FIGi5Gv/cT9tltIAtGMV7p9rXCqcOX/jyGp3kVgnhq3WW0Hbnqj0R578W+g9mU78PhJdRb
	cJdOkRmGCXXs7BhxRpXqejw==
X-Google-Smtp-Source: AGHT+IHArh9vt/cOWUAk2BFZyJIck93JKgvf09vbk4gMKZOvp44TSm7FcsTMOmd4xkf8h1T+MfwSLuQ2sBM59d9oqA==
X-Received: from pfbgs18.prod.google.com ([2002:a05:6a00:4d92:b0:739:45ba:a49a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:339e:b0:1f5:8a1d:3905 with SMTP id adf61e73a8af0-2148b426364mr633825637.7.1746559664315;
 Tue, 06 May 2025 12:27:44 -0700 (PDT)
Date: Tue, 06 May 2025 12:27:42 -0700
In-Reply-To: <aBlCSGB86cp3B3zn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com>
Message-ID: <diqzv7qdr13l.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> <snip>
>
> ... we "just" need
> to update that to constrain the max order based on shared vs. private.  E.g. from
> the original guest_memfd hugepage support[*] (which never landed), to take care
> of the pgoff not being properly aligned to the memslot.
>
> +	/*
> +	 * The folio can be mapped with a hugepage if and only if the folio is
> +	 * fully contained by the range the memslot is bound to.  Note, the
> +	 * caller is responsible for handling gfn alignment, this only deals
> +	 * with the file binding.
> +	 */
> +	huge_index = ALIGN(index, 1ull << *max_order);
> +	if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
> +	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
>  		*max_order = 0;
>
> [*] https://lore.kernel.org/all/20231027182217.3615211-18-seanjc@google.com
>

Regarding this alignment check, did you also consider checking at
memslot binding time? Would this [1] work/be better?

[1] https://lore.kernel.org/all/diqz1pt1sfw8.fsf@ackerleytng-ctop.c.googlers.com/





