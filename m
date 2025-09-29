Return-Path: <kvm+bounces-59021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D354BAA2DF
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 19:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 575127A12A7
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A01C21CC61;
	Mon, 29 Sep 2025 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1fCmIzGv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0E1F0E2E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759167150; cv=none; b=KIxbXL/ETRWTdEJ/EgD8l3U67aFKolpc26R04JEByJsBQBDNbgfSZfGBqyWI6YwiI6KbeSEuph1Iz7WEH+9O7ELL0MducOxhRQwvSVCtDmNj7t0EDzsSGy+rdWqaAdOlk0xC6Ahaoq3Dp7tlzW6gwfMFRUGwgR+6pbTuiON/Tas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759167150; c=relaxed/simple;
	bh=AhUg1wNJnUNUOaFXK2JklY0vm1VBVormHGNet3yMe6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aQk8n2H/geZEcg+SaDNl6CmltL0Iwh6hq4cglvkUZgy+4XD3BCDFdmBE56AeMCt5QolAnxgXEWxnd766RlmxKDnzXEyluw0nQBk4Ut4ZonkFfBO0fdeGWX84QeBXRSz9QmhaV1h1R6YqIfTYsHcAQOSzukSHFolkJ6CMWXshqLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1fCmIzGv; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7810912fc31so4171893b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759167148; x=1759771948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i5JsbcE+pbrv9WUMt/sTi7gQveEd5VSWsVent3A0wsM=;
        b=1fCmIzGv67V2LnPzHyAnaHJBJJSOS7UqlvvOb9/fh9JpVGSWhdtPXoJF2H43srkxd0
         Yn51hzFUWn5zAhTxh/Aw7GtfLxYZLP94iAH+j1WfMIS3WCxj2hYTj+rAsata3TM/CNz6
         kkZoELUTnrfHhYZx15ltkQ2S292HFZiiXEpVxntz0GeB7xpEp2AelW/vc1u+0zgNsV7x
         /5s2cNd4QtRW103qdQ4KgxE01nosebgDJftotnf70BusU9up5P2Z23ZyFaXOpsmwaYkL
         afu1ebxfGqnKinQh5PuSVLRYIptMn0amq8vHSsio0U0hsxrHvFDGcbWyqyT5m4l1ykjN
         2ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759167148; x=1759771948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5JsbcE+pbrv9WUMt/sTi7gQveEd5VSWsVent3A0wsM=;
        b=pNibkzywD+vgm+W1a41guITOJ7wGjLvggs+m8LaKDbvn+ndyhEV+8/+BDB1CGZDv2Q
         Jo69H91HJTyUYUu9EM9M2CZnZg+vUoPGYqANNPkSoJG65ovifkw/9yCkx0T2DtgrT6+W
         cR4fcLNv2OQvDARlxFMu1g9eLJ7vbMqSPlbUbm9XtwcbdPzNhaZRkYfdMpAA0I1Ilwsz
         v+MsihmKRajL3DuOIKO4HU26kFCRaRvmg0sHsDa8cPVpm6acB87h3Dk245z+KlemjoOn
         JLk/NFvniYwrHmrEPbHA86x+Ubwf4EaG9b8vmrbi7n9UnyNmxNGKqTQ5uAL7R/mLCTCM
         pSog==
X-Forwarded-Encrypted: i=1; AJvYcCWtq49ajOYMG852Hrxl9jmirL7PQL4hWZi394Ib0Jtc7LMPiroM4kU5iCCAC4nhS61/Fcw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzywh0RnjtmOMSJfPygI8mths8XW+4IuJbpiNNcfgjcB8WtjxpV
	Vc/CPP8bhx4PO4Iz5jPALat+1bMtGuO/keSHCkML/0/XXrnTS/TvWvkm5l6f4kaTnHg4Z4Yln81
	ItyI4bA==
X-Google-Smtp-Source: AGHT+IFthVZp9FDHNDiWf7DEdVqLu65/sfmSoZEiv22BhqGqSE2Yu8ZjoyNg35szSSCNiS2WYA6x5zgdoLA=
X-Received: from pgbfm22.prod.google.com ([2002:a05:6a02:4996:b0:b55:70c6:bece])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3392:b0:249:467e:ba4c
 with SMTP id adf61e73a8af0-2e7d7368009mr21819265637.42.1759167148111; Mon, 29
 Sep 2025 10:32:28 -0700 (PDT)
Date: Mon, 29 Sep 2025 10:32:26 -0700
In-Reply-To: <diqztt0l1pol.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-6-seanjc@google.com>
 <diqztt0l1pol.fsf@google.com>
Message-ID: <aNrCqhA_hhUjflPA@google.com>
Subject: Re: [PATCH 5/6] KVM: selftests: Add wrappers for mmap() and munmap()
 to assert success
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 29, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Add and use wrappers for mmap() and munmap() that assert success to reduce
> > a significant amount of boilerplate code, to ensure all tests assert on
> > failure, and to provide consistent error messages on failure.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  .../testing/selftests/kvm/guest_memfd_test.c  | 21 +++------
> >  .../testing/selftests/kvm/include/kvm_util.h  | 25 +++++++++++
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 44 +++++++------------
> >  tools/testing/selftests/kvm/mmu_stress_test.c |  5 +--
> >  .../selftests/kvm/s390/ucontrol_test.c        | 16 +++----
> >  .../selftests/kvm/set_memory_region_test.c    | 17 ++++---
> >  6 files changed, 64 insertions(+), 64 deletions(-)
> >
> > 
> > [...snip...]
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 23a506d7eca3..1c68ff0fb3fb 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -278,6 +278,31 @@ static inline bool kvm_has_cap(long cap)
> >  #define __KVM_SYSCALL_ERROR(_name, _ret) \
> >  	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
> >  
> > +static inline void *__kvm_mmap(size_t size, int prot, int flags, int fd,
> > +			       off_t offset)
> 
> Do you have a policy/rationale for putting this in kvm_util.h as opposed
> to test_util.h? I like the idea of this wrapper but I thought this is
> less of a kvm thing and more of a test utility, and hence it belongs in
> test_util.c and test_util.h.

To be perfectly honest, I forgot test_util.h existed :-)

> Also, the name kind of associates mmap with KVM too closely IMO, but
> test_mmap() is not a great name either.

Which file will hopefully be irrevelant, because ideally it'll be temporary (see
below). But if someone has a strong opinion and/or better idea on the name prefix,
I definitely want to settle on a name for syscall wrappers, because I want to go
much further than just adding an mmap() wrapper.  I chose kvm_ because there's
basically zero chance that will ever conflict with generic selftests functionality,
and the wrappers utilize TEST_ASSERT(), which are unique to KVM selftests.

As for why the current location will hopefully be temporary, and why I want to
settle on a name, I have patches to add several more wrappers, along with
infrastructure to make it super easy to add new wrappers.  When trying to sort
out the libnuma stuff for Shivank's series[*], I discovered that KVM selftests
already has a (very partial, very crappy) libnuma equivalent in
tools/testing/selftests/kvm/include/numaif.h.

Adding wrappers for NUMA syscalls became an exercise in frustration (so much
uninteresting boilerplate, and I kept making silly mistakes), and so that combined
with the desire for mmap() and munmap() wrappers motivated me to add a macro
framework similar to the kernel's DEFINE_SYSCALL magic.

So, I've got patches (that I'll post with the next version of the gmem NUMA
series) that add tools/testing/selftests/kvm/include/kvm_syscalls.h, and
__kvm_mmap() will be moved there (ideally it wouldn't move, but I want to land
this small series in 6.18, and so wanted to keep the changes for 6.18 small-ish).

For lack of a better namespace, and because we already have __KVM_SYSCALL_ERROR(),
I picked KVM_SYSCALL_DEFINE() for the "standard" builder, e.g. libnuma equivalents,
and then __KVM_SYSCALL_DEFINE() for a KVM selftests specific version to handle
asserting success.

/* Define a kvm_<syscall>() API to assert success. */
#define __KVM_SYSCALL_DEFINE(name, nr_args, args...)			\
static inline void kvm_##name(DECLARE_ARGS(nr_args, args))		\
{									\
	int r;								\
									\
	r = name(UNPACK_ARGS(nr_args, args));				\
	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR(#name, r));			\
}

/*
 * Macro to define syscall APIs, either because KVM selftests doesn't link to
 * the standard library, e.g. libnuma, or because there is no library that yet
 * provides the syscall.  These
 */
#define KVM_SYSCALL_DEFINE(name, nr_args, args...)			\
static inline long name(DECLARE_ARGS(nr_args, args))			\
{									\
	return syscall(__NR_##name, UNPACK_ARGS(nr_args, args));	\
}									\
__KVM_SYSCALL_DEFINE(name, nr_args, args)


The usage looks like this (which is odd at first glance, but makes it trivially
easy to copy+paste from the kernel SYSCALL_DEFINE invocations:

KVM_SYSCALL_DEFINE(get_mempolicy, 5, int *, policy, const unsigned long *, nmask,
		   unsigned long, maxnode, void *, addr, int, flags);

KVM_SYSCALL_DEFINE(set_mempolicy, 3, int, mode, const unsigned long *, nmask,
		   unsigned long, maxnode);

KVM_SYSCALL_DEFINE(set_mempolicy_home_node, 4, unsigned long, start,
		   unsigned long, len, unsigned long, home_node,
		   unsigned long, flags);

KVM_SYSCALL_DEFINE(migrate_pages, 4, int, pid, unsigned long, maxnode,
		   const unsigned long *, frommask, const unsigned long *, tomask);

KVM_SYSCALL_DEFINE(move_pages, 6, int, pid, unsigned long, count, void *, pages,
		   const int *, nodes, int *, status, int, flags);

KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
		   const unsigned long *, nodemask, unsigned long, maxnode,
		   unsigned int, flags);

__KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
__KVM_SYSCALL_DEFINE(close, 1, int, fd);
__KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
__KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);

[*] https://lore.kernel.org/all/0e986bdb-7d1b-4c14-932e-771a87532947@amd.com

