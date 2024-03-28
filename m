Return-Path: <kvm+bounces-12994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 494BD88FC88
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2D8129850E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B597C6C8;
	Thu, 28 Mar 2024 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y8v9Xx6w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE694E1C3
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711620628; cv=none; b=MCazUPAtSAxH1nIDjlyHvm+aAe9AYIgnsV/9SeB6Q3rua/k03xQJWcZrk8QMmd2xAgbuqoMIludqFX6Ga8sAkbTkIWyuFQ+Gn6ZCMT2qlGGl0QVZWjt9t9lYVYfgT/WjcoPFtDoBTquqbSL/LzJG6/ZldDo2+gKV3hYu07tdX9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711620628; c=relaxed/simple;
	bh=b/Wtm7QHudbi6Mcs0lI5n1QIOiQrRafrMMNW8RqO18s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNDWViA6LQ3WGoG/32j9NJGP0955EdN9HOYGFilXep4v1qUUMlReLkN/pil0jeF6CSqzJfOlmlo8O6bcZU5WNI8daD1nmVOoewJW4MJBo+W643IXFeF5xmmwQatPLBg34hBlmyV9jN78Vvt4M4wHqUBOI/yQ2WeL8XpnObGox/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y8v9Xx6w; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-56890b533aaso807560a12.3
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 03:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711620625; x=1712225425; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Puyk1VksZOZMOoSvwfN6vEXC/OypwIzDynZuRboVTDQ=;
        b=Y8v9Xx6wi/I6LmHV31xIQaKaBoEyWvkgfZiAdy17i6WwuwjOfpm2LavZzxJbkVpKki
         kfc7ZZjFqgly3t/OsD9sNOSQlzGvZ9jOQamXYC8cX5Gi0bX29w38U/q9LrsX9uVCD1Tz
         k4LOeW83l5CZxj3ISYLY7eBAX2ioLnPEQvm+fU0YWIBeAc80MCCCSyA+TaOB73E9y+ii
         htE2MxcA0JEB6/wxe52pFJ1IFoo3Fiar4oZezRlq3lx5fo2eLwUvQbBkZGeevbBSo+++
         YTpE487VQgaHRmTXxpMM0S3fVjTe6jKgV387Ex9txCtSxqKQSg/FhbLELp7fs5ZunjzK
         BphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711620625; x=1712225425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Puyk1VksZOZMOoSvwfN6vEXC/OypwIzDynZuRboVTDQ=;
        b=SLpZE1Wuofo47DmybaV8K5zNf24dP4xE29vgtWbal9+DlmbyIJ5fxQVhNkHl3k8DH/
         4aAevo1EnENlRMk3vZ87pnd331CyKledDwCu1MREOPNOYbvFLMYMzJTh6K1aTKRVEGXn
         ZsPs6s5j2YW3ksxSJYhp/7HTyeiBHUT3H2T/B7jukRQ1tIhMaUzVaCYf147un16eBc95
         iSGG2OLrwSTh2wm1IWb6EiNZZU6OdBmYli8JBM8BC4cKNcg7llnRSqLOk8PlNiyCoiYX
         9EmTn1P/C/ho1cs5Q1SGfCwvGjAlD0HiGGOulcxoOip0oVB3qdSd/dCexUGlJogJM7uI
         5b1A==
X-Forwarded-Encrypted: i=1; AJvYcCU+88UUBRgTQFPM+tIKoyEd5wZZkiDwDyaC2JcMvZHzpjUvflc3i6DFsqTUYVlEzWHwCA5dW5t2BY+vsTVZTflbNlTA
X-Gm-Message-State: AOJu0YyI20J3rFQBCZ7MtqtgfZcC4V4+frLcF/XEtdcwvtixlTBHZGnf
	bpc71L6+/CXlY7GVJm4B7AEOiorzEQqOY1rbhiE2MNUnGciZRZxy/NzImtXO5+7Xe/0U07uafmr
	s7GA6
X-Google-Smtp-Source: AGHT+IGXnI9D0/a/dDSyK30CUeRiI6B81YbRt4vqKAzIHpgoErhg2X2EKKArBQHecRRX/nEjQaIWXQ==
X-Received: by 2002:a17:906:f0d0:b0:a4e:e20:df53 with SMTP id dk16-20020a170906f0d000b00a4e0e20df53mr1476586ejb.59.1711620624947;
        Thu, 28 Mar 2024 03:10:24 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id kg26-20020a17090776fa00b00a449026672esm571212ejc.81.2024.03.28.03.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 03:10:23 -0700 (PDT)
Date: Thu, 28 Mar 2024 10:10:20 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	ackerleytng@google.com, mail@maciej.szmigiero.name,
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, keirf@google.com,
	linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <ZgVCDPoQbbXjTBQp@google.com>
References: <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <20240327193454.GB11880@willie-the-truck>
 <d0500f89-df3b-42cd-aa5a-5b3005f67638@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0500f89-df3b-42cd-aa5a-5b3005f67638@redhat.com>

Hey David,

I'll try to pick up the baton while Will is away :-)

On Thursday 28 Mar 2024 at 10:06:52 (+0100), David Hildenbrand wrote:
> On 27.03.24 20:34, Will Deacon wrote:
> > I suppose the main thing is that the architecture backend can deal with
> > these states, so the core code shouldn't really care as long as it's
> > aware that shared memory may be pinned.
> 
> So IIUC, the states are:
> 
> (1) Private: inaccesible by the host, accessible by the guest, "owned by
>     the guest"
> 
> (2) Host Shared: accessible by the host + guest, "owned by the host"
> 
> (3) Guest Shared: accessible by the host, "owned by the guest"

Yup.

> Memory ballooning is simply transitioning from (3) to (2), and then
> discarding the memory.

Well, not quite actually, see below.

> Any state I am missing?

So there is probably state (0) which is 'owned only by the host'. It's a
bit obvious, but I'll make it explicit because it has its importance for
the rest of the discussion.

And while at it, there are other cases (memory shared/owned with/by the
hypervisor and/or TrustZone) but they're somewhat irrelevant to this
discussion. These pages are usually backed by kernel allocations, so
much less problematic to deal with. So let's ignore those.

> Which transitions are possible?

Basically a page must be in the 'exclusively owned' state for an owner
to initiate a share or donation. So e.g. a shared page must be unshared
before it can be donated to someone else (that is true regardless of the
owner, host, guest, hypervisor, ...). That simplifies significantly the
state tracking in pKVM.

> (1) <-> (2) ? Not sure if the direct transition is possible.

Yep, not possible.

> (2) <-> (3) ? IIUC yes.

Actually it's not directly possible as is. The ballooning procedure is
essentially a (1) -> (0) transition. (We also tolerate (3) -> (0) in a
single hypercall when doing ballooning, but it's technically just a
(3) -> (1) -> (0) sequence that has been micro-optimized).

Note that state (2) is actually never used for protected VMs. It's
mainly used to implement standard non-protected VMs. The biggest
difference in pKVM between protected and non-protected VMs is basically
that in the former case, in the fault path KVM does a (0) -> (1)
transition, but in the latter it's (0) -> (2). That implies that in the
unprotected case, the host remains the page owner and is allowed to
decide to unshare arbitrary pages, to restrict the guest permissions for
the shared pages etc, which paves the way for implementing migration,
swap, ... relatively easily.

> (1) <-> (3) ? IIUC yes.

Yep.

<snip>
> > I agree on all of these and, yes, (3) is the problem for us. We've also
> > been thinking a bit about CoW recently and I suspect the use of
> > vm_normal_page() in do_wp_page() could lead to issues similar to those
> > we hit with GUP. There are various ways to approach that, but I'm not
> > sure what's best.
> 
> Would COW be required or is that just the nasty side-effect of trying to use
> anonymous memory?

That'd qualify as an undesirable side effect I think.

> > 
> > > I'm curious, may there be a requirement in the future that shared memory
> > > could be mapped into other processes? (thinking vhost-user and such things).
> > 
> > It's not impossible. We use crosvm as our VMM, and that has a
> > multi-process sandbox mode which I think relies on just that...
> > 
> 
> Okay, so basing the design on anonymous memory might not be the best choice
> ... :/

So, while we're at this stage, let me throw another idea at the wall to
see if it sticks :-)

One observation is that a standard memfd would work relatively well for
pKVM if we had a way to enforce that all mappings to it are MAP_SHARED.
KVM would still need to take an 'exclusive GUP' from the fault path
(which may fail in case of a pre-existing GUP, but that's fine), but
then CoW and friends largely become a non-issue by construction I think.
Is there any way we could enforce that cleanly? Perhaps introducing a
sort of 'mmap notifier' would do the trick? By that I mean something a
bit similar to an MMU notifier offered by memfd that KVM could register
against whenever the memfd is attached to a protected VM memslot.

One of the nice things here is that we could retain an entire mapping of
the whole of guest memory in userspace, conversions wouldn't require any
additional efforts from userspace. A bad thing is that a process that is
being passed such a memfd may not expect the new semantic and the
inability to map !MAP_SHARED. But I guess a process that receives a
handle to private memory must be enlightened regardless of the type of
fd, so maybe it's not so bad.

Thoughts?

Thanks,
Quentin

