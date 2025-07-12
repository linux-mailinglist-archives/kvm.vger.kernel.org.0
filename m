Return-Path: <kvm+bounces-52232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11590B02C30
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 19:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92ACC4E385B
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 17:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455EF28A419;
	Sat, 12 Jul 2025 17:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fgWoQDHH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2B6287245
	for <kvm@vger.kernel.org>; Sat, 12 Jul 2025 17:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752341898; cv=none; b=PsoHRArKlBYVpojK+Y/Zgll0aa/MW4OTtElwMo5AAYXipcXOmO9vsR5ya7imDVeaIF3jtrUkenLtSz0MkpNqqz+S6opANosv/GD3R9vOD/6zOZ7Pk9aidYLoFMYFMgf7Y7+VDMi7xxNZ9UsP1QgCYmxDERRjYD950DKnFJ1uzDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752341898; c=relaxed/simple;
	bh=CIsoW6negRSHBNMbMwVYgOZOquPv5s9MF7IMD32fmDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UP+GUlMr6UYtRIyGpYLzK3KTaOm55es6UdvKW9oT7m4EJdfRAMOqnRHK7LZL/iUud+gwCY5YZb8hLzib2YpLcr+R0ho8y/SeArhtpP4ApYnsFpoCYnDlIx/cWM6t5w+QPQQj1wJBGOHfb+RrOhCq6j8+wsUQ0NexfZEr+BBewWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fgWoQDHH; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2357c61cda7so120085ad.1
        for <kvm@vger.kernel.org>; Sat, 12 Jul 2025 10:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752341895; x=1752946695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fuujDqaQx6OHLyap4BpfcTFKLHlqSEv1YVCxl1pX/c=;
        b=fgWoQDHHUI6VCQ4VhKL256ng1IC2AdiQZQ0LQ86LFteAG4oS3J0Jdy3ECoZ7OoRjR8
         dYVEDlZA5E7fQuLo21nso93jiW11g/r170Nzmrg7iy6eAczSKO/iz//N1zbWQQ7LmxHa
         FIrFYufoK9nPoSpfNkf+RL4HaMnyn1tE4sgQ3j07eWs2Qc0OqUwTs3dXkfKe4D+RsWKl
         5t4jZW97QI83/qpegVpclT+Txb6QMN4dF16gVNQ5IIXjY/E4vQZyAc3kn1/pLpA27P6s
         WAcTalCJbC/CCBR7aF6k9qnFV32P7mRWDKywjd6AAaJAbdxg9Fl0IGRZU85oDaG9YmSX
         /usQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752341895; x=1752946695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fuujDqaQx6OHLyap4BpfcTFKLHlqSEv1YVCxl1pX/c=;
        b=s8Yn/OV+gAd1CLs2kK6ibqcwU92Rg/S7GFucRAo3ybnVoawBDj9YJOLEI1FSJbO5Dn
         T3mRC0oekTGRM/mFSAeT/h1wUmMOTsS2CoMyd6gi6ovf9K9PDG4YAvTUQbEHwRGwTuNy
         FpiLmQvVaaxREEapgXD3SKKfFIvW3q0Lcododtv+ui5cteffoEIY7P7a2X/2ekp9lYxp
         h4C3rDvSSJb+O9//T770qcYH1+ynIIvR2qaXSG8MU4wWz6a0sgHSMO8idBZuBI+w7YXM
         Yvbiyfp/31qBz4ZA9ujW+OXyt2SZnrHmnSaESorHsFFmqvzi2k7HrsheVzpP16LDIGK8
         jFew==
X-Forwarded-Encrypted: i=1; AJvYcCXi86pk4Nf6Tcy3l7PQeYzJdvPgyH5S+y06lfirmz9VCc7NREGBx5Cf66tcS0kVb3GUb44=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj+/cqB4E+vmwaInn68ezUIyt5zKK5QNq1pKibwST41Y9AfKeg
	y12Unjgj5YrDekIX4RF0pRWUFAeJ6av4AGCJI9U9X5WtrkPb9jGX4TfpBUjG+g9u8y0ObZCB0uU
	A8hnYsMq1nudB51/9oiFlJfXo7ovtWMnNvMfGpacn
X-Gm-Gg: ASbGnctl2dvOgO3l3NfFOfTIiUmvmPIHu3n9ZTjoqezE0u0Cs7p4Frpo2jdQsY/bAHs
	y+CpUl77kXoPEb8No3dIldul0RjUcU4+JR7ZXGLnVjgkn3OUK8I55v30x4sMaw7yHwvWxASlhpK
	MPZJpQDbEisE8BwjaNFMe1NPdPLOR4L7mK5cbLLVb0bJK0MAK2lh+j2VyGM0QOVjmcW5htmWDPa
	CKXWdhajW6RjVVhF0jGLrQqicpcTKPGNrXXUQaVcmBT8H8vYC8=
X-Google-Smtp-Source: AGHT+IGAqWu1DGMbWjH0/2U+cZ9+ZzEcCYnI9VhTIeknxHrrYXHWqYhdWNsKIuqG2rmHdTiSyYjUDWLtmTq56SxZYE0=
X-Received: by 2002:a17:903:fad:b0:231:ed22:e230 with SMTP id
 d9443c01a7336-23df7b2c48bmr1248235ad.15.1752341894575; Sat, 12 Jul 2025
 10:38:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com> <CAGtprH9NOdN9VZWkWLjYcTixrN1+dgWfC3rcdmv9rQBkriZrdQ@mail.gmail.com>
In-Reply-To: <CAGtprH9NOdN9VZWkWLjYcTixrN1+dgWfC3rcdmv9rQBkriZrdQ@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sat, 12 Jul 2025 10:38:01 -0700
X-Gm-Features: Ac12FXzcEfAGKe3hL7rXr_HBU-6nL6kTZLckW9PQ7tEbTEw-NPkHUDBcGjGyWkc
Message-ID: <CAGtprH8+x5Z=tPz=NcrQM6Dor2AYBu3jiZdo+Lg4NqAk0pUJ3w@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 11:46=E2=80=AFAM Vishal Annapurve <vannapurve@googl=
e.com> wrote:
>
> On Fri, Jul 11, 2025 at 8:40=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Jul 11, 2025, Michael Roth wrote:
> > > On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > > > Besides, it can't address the 2nd AB-BA lock issue as mentioned in =
the patch
> > > > log:
> > > >
> > > > Problem
> > > > =3D=3D=3D
> > > > ...
> > > > (2)
> > > > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_loc=
k,
> > > > resulting in the following lock sequence in tdx_vcpu_init_mem_regio=
n():
> > > > - filemap invalidation lock --> mm->mmap_lock
> > > >
> > > > However, in future code, the shared filemap invalidation lock will =
be held
> > > > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > > > - mm->mmap_lock --> filemap invalidation lock
> > >
> > > I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> > > KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming i=
t).
> >
> > Irrespective of shared faults, I think the API could do with a bit of c=
leanup
> > now that TDX has landed, i.e. now that we can see a bit more of the pic=
ture.
> >
> > As is, I'm pretty sure TDX is broken with respect to hugepage support, =
because
> > kvm_gmem_populate() marks an entire folio as prepared, but TDX only eve=
r deals
> > with one page at a time.  So that needs to be changed.  I assume it's a=
lready
> > address in one of the many upcoming series, but it still shows a flaw i=
n the API.
> >
> > Hoisting the retrieval of the source page outside of filemap_invalidate=
_lock()
> > seems pretty straightforward, and would provide consistent ABI for all =
vendor
>
> Will relying on standard KVM -> guest_memfd interaction i.e.
> simulating a second stage fault to get the right target address work
> for all vendors i.e. CCA/SNP/TDX? If so, we might not have to maintain
> this out of band path of kvm_gmem_populate.

I think the only different scenario is SNP, where the host must write
initial contents to guest memory.

Will this work for all cases CCA/SNP/TDX during initial memory
population from within KVM:
1) Simulate stage2 fault
2) Take a KVM mmu read lock
3) Check that the needed gpa is mapped in EPT/NPT entries
4) For SNP, if src !=3D null, make the target pfn to be shared, copy
contents and then make the target pfn back to private.
5) For TDX, if src !=3D null, pass the same address for source and
target (likely this works for CCA too)
6) Invoke appropriate memory encryption operations
7) measure contents
8) release the KVM mmu read lock

If this scheme works, ideally we should also not call RMP table
population logic from guest_memfd, but from KVM NPT fault handling
logic directly (a bit of cosmetic change). Ideally any outgoing
interaction from guest_memfd to KVM should be only via invalidation
notifiers.





>
> > flavors.  E.g. as is, non-struct-page memory will work for SNP, but not=
 TDX.  The
> > obvious downside is that struct-page becomes a requirement for SNP, but=
 that
> >
>
> Maybe you had more thought here?

