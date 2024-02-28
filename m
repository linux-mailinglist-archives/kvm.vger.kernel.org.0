Return-Path: <kvm+bounces-10244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2748B86AF59
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 933541F25760
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342371474CF;
	Wed, 28 Feb 2024 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wx1b9H/H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D1146908
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709124294; cv=none; b=KuXlXC9OId7tQNC3zv5eC4qQhPIPWbdP2i8ZLXD+Ciht57gzTmLaJi4e72om83zGklE7VqkGS9DwjBuFmrNyBWaljQFNeuhudCES+MxD0G3piSogJFDPcZCPU94oBv4Pw9oswVd27mhlA3HvR2eUcZx5+9rj9o+/sQ5nxkVUUDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709124294; c=relaxed/simple;
	bh=pXKCZJwJ4+arWlV96KQRxdkQ6IU4sCiGwJyzykK8u3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUKIip0pi0pbYw/cUni3P1FKVsjg4pmNpGW+wdnYPXlXuGUCrIS7f1pDdE99WbU6cjtrEIhV87hCsXcaGbCd6qeRjtnfXbfDXeE5dG0cbennTmYJ0A9F60WNxGuGTRcjKMP4pLKd9EaUYhj/9yYbBe1eY4bFsAnpHaQicPA3G+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wx1b9H/H; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5643ae47cd3so7081394a12.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 04:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709124291; x=1709729091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XKO94nMA1YtYYpk+BNP1fuJKlQZLG/9h2W7iUjre2sY=;
        b=wx1b9H/HZLWCv/ddtSkbUbatFnlw3co2J+2PMYcuagd0/yl/V9Zvj/WIRieSaW+un2
         U5oqdpNqwmdoeZ4EqJDE+nrZLCVqtRou1bx3gh6yf0wTGn405Qfim/U0R4NqYCyzcg+I
         O3pb2m1+kZ3vr8M38I+4AVR8rTZpjh5Ia1jSD48hsyQQsUNdvNj1rn+z7LJKSRUbOy5V
         LbuOWtX2og5UeSaPg4pbR4Z32Sg2OmRGUUbyh4if8I5wPq+SuHBhcK1cQNmGB9HjdMJB
         Y+lZAuRy7XzWy/EJn3zELw7WD6IKk0TTLCykcPFnjwotWwvN/7RgqvI6Hs9wmhmhSDdB
         lmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709124291; x=1709729091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKO94nMA1YtYYpk+BNP1fuJKlQZLG/9h2W7iUjre2sY=;
        b=Bub1xHz/PZ47CZSOUdjDyTP7xFKTgMmVx2o/hMQMhpce+tyrqJIXKZgsOE0l1/VyCC
         1u/q7SVX+0Tpc7NdgI9AgDiYz1j/CY/bxMCrX+5/sF/JhXtj5vm4F0gqlcycWF+ZqwCT
         3LC7JV4koDJwWIcsTwi6RVkKZoe5DmDhSluo6cjNZ76Tokk2ZGI9bwmt+0gBkiHxM4Nh
         e9pwWT12pGhMsILrOwe/JgXEu8W2lcLIIwNADdMgTYyAPC5g5PW0o7RBOIMaFCMvgha7
         fnLBvhMHZ06k0M8uaRu4ujIdrDYtUPIzA10t9M/nj0fPlGpxFAyyCZIofMCXgPmpGPoD
         r87A==
X-Forwarded-Encrypted: i=1; AJvYcCUVb7AROB1+yHZB1afMC2zxPfM/ESkf2fgr8J47+/wNkbr+glhq8y4SyWGbjRFDvGUiG5ydJSPnE1uChjjn2XAQuflr
X-Gm-Message-State: AOJu0YyHvdizckgmChZRNIFxysXrP0RitFGQhfRfybJM/GLZzC+aua6T
	1kQaJq5JqwynSxh9evKg5Fpxn5YlMPqsZZs3Ud/ZK9ttqi9cw89nGTZ2SfVYVg==
X-Google-Smtp-Source: AGHT+IFCLZvk2INpPsiNJeuTsGQcBnfWl23OygqTc+LqjELiOS3oXuIg0YTp/dWBUHQaq/Li8DlVuw==
X-Received: by 2002:a17:907:209a:b0:a3f:7e2:84cc with SMTP id pv26-20020a170907209a00b00a3f07e284ccmr10084717ejb.6.1709124290580;
        Wed, 28 Feb 2024 04:44:50 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id hu21-20020a170907a09500b00a42eb167492sm1826966ejc.116.2024.02.28.04.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 04:44:50 -0800 (PST)
Date: Wed, 28 Feb 2024 12:44:47 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <Zd8qvwQ05xBDXEkp@google.com>
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>

On Wednesday 28 Feb 2024 at 12:11:30 (+0100), David Hildenbrand wrote:
> On 28.02.24 11:48, Quentin Perret wrote:
> > On Tuesday 27 Feb 2024 at 15:59:37 (+0100), David Hildenbrand wrote:
> > > > 
> > > > Ah, this was something I hadn't thought about. I think both Fuad and I
> > > > need to update our series to check the refcount rather than mapcount
> > > > (kvm_is_gmem_mapped for Fuad, gunyah_folio_lend_safe for me).
> > > 
> > > An alternative might be !folio_mapped() && !folio_maybe_dma_pinned(). But
> > > checking for any unexpected references might be better (there are still some
> > > GUP users that don't use FOLL_PIN).
> > 
> > As a non-mm person I'm not sure to understand to consequences of holding
> > a GUP pin to a page that is not covered by any VMA. The absence of VMAs
> > imply that userspace cannot access the page right? Presumably the kernel
> > can't be coerced into accessing that page either? Is that correct?
> 
> Simple example: register the page using an iouring fixed buffer, then unmap
> the VMA. iouring now has the page pinned and can read/write it using an
> address in the kernel vitual address space (direct map).
> 
> Then, you can happily make the kernel read/write that page using iouring,
> even though no VMA still covers/maps that page.

Makes sense, and yes that would be a major bug if we let that happen,
thanks for the explanation.

> [...]
> 
> > > Instead of
> > > 
> > > 1) Converting a page to private only if there are no unexpected
> > >     references (no mappings, GUP pins, ...) and no VMAs covering it where
> > >     we could fault it in later
> > > 2) Disallowing mmap when the range would contain any private page
> > > 3) Handling races between mmap and page conversion
> > 
> > The one thing that makes the second option cleaner from a userspace
> > perspective (IMO) is that the conversion to private is happening lazily
> > during guest faults. So whether or not an mmapped page can indeed be
> > accessed from userspace will be entirely undeterministic as it depends
> > on the guest faulting pattern which userspace is entirely unaware of.
> > Elliot's suggestion would prevent spurious crashes caused by that
> > somewhat odd behaviour, though arguably sane userspace software
> > shouldn't be doing that to start with.
> 
> The last sentence is the important one. User space should not access that
> memory. If it does, it gets a slap on the hand. Because it should not access
> that memory.
> 
> We might even be able to export to user space which pages are currently
> accessible and which ones not (e.g., pagemap), although it would be racy as
> long as the VM is running and can trigger a conversion.
> 
> > 
> > To add a layer of paint to the shed, the usage of SIGBUS for
> > something that is really a permission access problem doesn't feel
> 
> SIGBUS stands for "BUS error (bad memory access)."
> 
> Which makes sense, if you try accessing something that can no longer be
> accessed. It's now inaccessible. Even if it is temporarily.
> 
> Just like a page with an MCE error. Swapin errors. Etc. You cannot access
> it.
> 
> It might be a permission problem on the pKVM side, but it's not the
> traditional "permission problem" as in mprotect() and friends. You cannot
> resolve that permission problem yourself. It's a higher entity that turned
> that memory inaccessible.

Well that's where I'm not sure to agree. Userspace can, in fact, get
back all of that memory by simply killing the protected VM. With the
approach suggested here, the guestmem pages are entirely accessible to
the host until they are attached to a running protected VM which
triggers the protection. It is very much userspace saying "I promise not
to touch these pages from now on" when it does that, in a way that I
personally find very comparable to the mprotect case. It is not some
other entity that pulls the carpet from under userspace's feet, it is
userspace being inconsistent with itself that causes the issue here, and
that's why SIGBUS feels kinda wrong as it tends to be used to report
external errors of some sort.

> > appropriate. Allocating memory via guestmem and donating that to a
> > protected guest is a way for userspace to voluntarily relinquish access
> > permissions to the memory it allocated. So a userspace process violating
> > that could, IMO, reasonably expect a SEGV instead of SIGBUS. By the
> > point that signal would be sent, the page would have been accounted
> > against that userspace process, so not sure the paging examples that
> > were discussed earlier are exactly comparable. To illustrate that
> > differently, given that pKVM and Gunyah use MMU-based protection, there
> > is nothing architecturally that prevents a guest from sharing a page
> > back with Linux as RO.
> 
> Sure, then allow page faults that allow for reads and give a signal on write
> faults.
> 
> In the scenario, it even makes more sense to not constantly require new
> mmap's from user space just to access a now-shared page.
> 
> > Note that we don't currently support this, so I
> > don't want to conflate this use case, but that hopefully makes it a
> > little more obvious that this is a "there is a page, but you don't
> > currently have the permission to access it" problem rather than "sorry
> > but we ran out of pages" problem.
> 
> We could user other signals, at least as the semantics are clear and it's
> documented. Maybe SIGSEGV would be warranted.
> 
> I consider that a minor detail, though.
>
> Requiring mmap()/munmap() dances just to access a page that is now shared
> from user space sounds a bit suboptimal. But I don't know all the details of
> the user space implementation.

Agreed, if we could save having to mmap() each page that gets shared
back that would be a nice performance optimization.

> "mmap() the whole thing once and only access what you are supposed to
> access" sounds reasonable to me. If you don't play by the rules, you get a
> signal.

"... you get a signal, or maybe you don't". But yes I understand your
point, and as per the above there are real benefits to this approach so
why not.

What do we expect userspace to do when a page goes from shared back to
being guest-private, because e.g. the guest decides to unshare? Use
munmap() on that page? Or perhaps an madvise() call of some sort? Note
that this will be needed when starting a guest as well, as userspace
needs to copy the guest payload in the guestmem file prior to starting
the protected VM.

Thanks,
Quentin

