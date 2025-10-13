Return-Path: <kvm+bounces-59950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609C2BD6ADE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFFA3404BF6
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5892FC897;
	Mon, 13 Oct 2025 22:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yUq3hIxc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED9D2D97B5
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760396313; cv=none; b=sJk6KT/lahI7XANx3mZaLePdyfD1po1bpQn4KR9mUi9Mg/Ta3F7Z/zkZioz9LjtR13n/FomiAB/kqKYo/S8TBUuzFz3tXp1/oslWHOnowuAqiALhD4mrNo22ascEDdHDir1M7rVhQ5wpuxgQB+hYtNfSCNwp5PFhEdxMLLj+ICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760396313; c=relaxed/simple;
	bh=OBVPRVnolJIYZ4plwt7wa568FRg7nOQAvuHQFosWrn4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r4TUbx0FITkH6/MB/WsIdj2qcf1qqEdtNtC62gS2wDaPOy8f5fNK2fTNGcOOBlLfHFREjiTV2VkXl9zh9gsjSsDe5FYMQnQPpfSfbST4XT0NZg+vJZTSEsaZMBi4VaUN3y5oMPHyGDJBzxf4at9AOJ0h4DqQdhuz5W3lAFmy4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yUq3hIxc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2698b5fbe5bso111117525ad.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760396312; x=1761001112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgg62F8lpJy3ysdGrDIadd5P5qmpoZpUB7Kr6b42Svo=;
        b=yUq3hIxcW0rZIS2qbIfdjGT+PEHHGTqAML104zNunFWgDW6C/6QLq0cijycuLDYaKs
         OKjkmNk3WpMCTuXKEm75/vd/FTjjnJ2a47OQnVNfQY/qTsMCLSmHQk/8L8Aj/iba4o9F
         g2CJZHHSIvCOHRWEcDXjw1wUT078zu/BuhqfQnC9MJj4mdD3726LXE0p6FyOW+eDTNP3
         ETCOHkUhCPkD99H2ej0vmrBi/twT0BlCevYJVd6b/8hHRhUFtP7DdaRu2GvnD9vd77KD
         1cy+U3AfKNB75aSBDrDf2AzoXJbwnwXtkDQ9CihQ+76ZnwCAd0MIndDc+YU+SwgliGdb
         j+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760396312; x=1761001112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgg62F8lpJy3ysdGrDIadd5P5qmpoZpUB7Kr6b42Svo=;
        b=cW+DdqMoo7Z6PkTNASm0JJlnKBfmosm8lclVeLa/xa8uJv/jHzKdhEP7o02jH1gPKy
         k4uLTr1f4UvwyoBRgNiTvMWDJD59ZgC/nNIFZZQ/CMNrFShkr/WM2am1ZQpTvJoknrDb
         aDZnnvgcMW8QOAVVcKnAJiY3lYAytdEQZkZj3yGz8iME+oGrN8nTTa9AgdoHBxobkxce
         5DmhWp5Qef4F3jPXDfA/J4Jr6Hyl9yn9Fy4W6Gft/JIx8MkNykQIuIkmdevPR27AM3gG
         PTEA7peK/lLbCSnJ+vEfNdGPWsgGU000FRSJereO5A6kt98wDfHAPTsdrRkm2/kpoTsZ
         BfJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVodaEUYp5ilAl3My3PxGYypWIcBua/NXy6HacmKSqQct2zKwhtuPfTvPzEMgljhqS+0/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBpoAZNZlT9UAg3YVpzcsC7sydl8eZUVMRk11LEsPNxgAfHMD/
	q+nE6A515JMoiByIBcKG9oE/sjS9/hgjPSwyE0xasLXgcEt1kEBph2aaEmqs/5Q/s6fax3W0LrJ
	JSdf5PQ==
X-Google-Smtp-Source: AGHT+IFVRSBXCaOg47V3LlEe/hW3xpOG/xZ18xP0dbIvEMR36+z9CDUWRAyHNBZRkitDhAucFbqnHLvEJGU=
X-Received: from pjxu8.prod.google.com ([2002:a17:90a:db48:b0:32e:b34b:92eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d60f:b0:269:ba61:222e
 with SMTP id d9443c01a7336-29027303330mr287660585ad.53.1760396311667; Mon, 13
 Oct 2025 15:58:31 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:58:30 -0700
In-Reply-To: <ivkoh7hdl7fcp5fmehmf3kv6ebqitozunbricyed5tkt7z3ngr@qvmaytpzrskw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
 <20251001145816.1414855-9-yosry.ahmed@linux.dev> <aO1yJHcKC85mo0PQ@google.com>
 <ivkoh7hdl7fcp5fmehmf3kv6ebqitozunbricyed5tkt7z3ngr@qvmaytpzrskw>
Message-ID: <aO2EFiOHSuvmHvq_@google.com>
Subject: Re: [PATCH 08/12] KVM: selftests: Use 'leaf' instead of hugepage to
 describe EPT entries
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, Yosry Ahmed wrote:
> On Mon, Oct 13, 2025 at 02:41:56PM -0700, Sean Christopherson wrote:
> > On Wed, Oct 01, 2025, Yosry Ahmed wrote:
> > > From: Yosry Ahmed <yosryahmed@google.com>
> > > 
> > > The assertions use 'hugepage' to describe a terminal EPT entry, but
> > > 'leaf' is more accruate as a PG_LEVEL_4K EPT entry is a leaf but not a
> > > hugepage.
> > 
> > Yes, it's more accurate, but also less precise.  I'm guessing the assert message
> > and comment talked about hugepages because that's the type of mappings that
> > caused problems at the time.
> 
> Given that it refers to PG_LEVEL_4K entries too, I wouldn't call it less
> precise. All callers actually create 4K mappings so it is never actually
> a hugepage in the current context :D

nested_identity_map_1g()?

> > Ah, actually, I bet the code was copy+pasted from virt_create_upper_pte(), in
> > which case the assumptions about wanting to create a hupage are both accurate
> > and precise.
> > 
> > > The distincion will be useful in coming changes that will pass
> > > the value around and 'leaf' is clearer than hugepage or page_size.
> > 
> > What value?
> 
> 'leaf'. The following changes will pass 'leaf' in as a boolean instead
> of checking 'current_level == target_level' here. So passing in
> 'hugepage' would be inaccurate, and 'page_size' is not as clear (but
> still works).
> 
> > 
> > > Leave the EPT bit named page_size to keep it conforming to the manual.
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  tools/testing/selftests/kvm/lib/x86/vmx.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > index 04c4b97bcd1e7..673756b27e903 100644
> > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > @@ -380,15 +380,15 @@ static void nested_create_pte(struct kvm_vm *vm,
> > >  			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
> > >  	} else {
> > >  		/*
> > > -		 * Entry already present.  Assert that the caller doesn't want
> > > -		 * a hugepage at this level, and that there isn't a hugepage at
> > > -		 * this level.
> > > +		 * Entry already present.  Assert that the caller doesn't want a
> > > +		 * leaf entry at this level, and that there isn't a leaf entry
> > > +		 * at this level.
> > >  		 */
> > >  		TEST_ASSERT(current_level != target_level,
> > > -			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx",
> > > +			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
> > >  			    current_level, nested_paddr);
> > >  		TEST_ASSERT(!pte->page_size,
> > > -			    "Cannot create page table at level: %u, nested_paddr: 0x%lx",
> > > +			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
> > 
> > This change is flat out wrong.  The existing PRESENT PTE _might_ be a 4KiB leaf
> > entry, but it might also be an existing non-leaf page table.
> 
> Hmm if pte->page_size is true then it has to be a leaf page table,
> right?

No, because bit 7 is ignored by hardware for 4KiB entries.  I.e. it can be 0 or
1 depending on the whims of software.  Ugh, this code uses bit 7 to flag leaf
entries.  That's lovely.

> If it's an existing non-leaf page table we shouldn't fail,

Ah, right, current_level can never be less than target_level because the first
assert will fail on iteration-1.

> the assertion here is when we try to override a leaf page table IIUC.
>
> > Instead of hacking on the nested code, can we instead tweak __virt_pg_map() to
> > work with nested TDP?  At a glance, it's already quite close, e.g. "just" needs
> > to be taught about EPT RWX bits and allow the call to pass in the root pointer.
> 
> That would be ideal, I'll take a look. In case I don't have time for
> that unification, can this be a follow-up change?

Part of me wants to be nice and say "yes", but most of me wants to say "no".

Struct overlays for PTEs suck.  At best, they generate poor code and obfuscate
simple logic (e.g. vm->page_size vs pte->page_size is a confusion that simply
should not be possible).  At worst, they lead to hard-to-debug issues like the
one that led to commit f18b4aebe107 ("kvm: selftests: do not use bitfields larger
than 32-bits for PTEs").

eptPageTableEntry obviously isn't your fault, but nptPageTableEntry is. :-D
And I suspect the hardest part of unificiation will be adding the globals to
deal with variable bit positions that are currently being handled by the struct
overlays.

