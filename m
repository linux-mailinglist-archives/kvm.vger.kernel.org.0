Return-Path: <kvm+bounces-49685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FFFADC451
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 10:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A9971884284
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 08:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11A929346F;
	Tue, 17 Jun 2025 08:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mg3+k2aX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D5292B4C
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 08:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750147761; cv=none; b=s8s9S5jhww7Wn7bCX1pr239XaSvlSh3s3rFjFWdst3F+CJ+RLABulu/GuT0Yng3lU7LhnpgBKxHpbqfFLpKZYHVEFwDryfYhVLK+X5pNlMQ8NpbCRR1IN9P2AaWhyjuTgE7my2GBCAvrEAfi6qYMC7P64T7kbzFBAR9GAy6WGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750147761; c=relaxed/simple;
	bh=KkafitbfxZnQ+TXNYKX6tIA3qwe4BQ/wugJU4xzZKr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a958qrXjIF/OMgvWC4tuznzT6UjS1eTDRWcu4hCV5boeJ6h1ifQusVV7KrQ29F3Ve0+AgtPxvIH0byx90wKRxEOrrN8zn+fY9mYLCSW8nXkGewkrbSOSJsVmrEH8kPO9Lkkprg1d/i/ZjWtvhva+tKTCpjNhmAArEli43XdUWMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mg3+k2aX; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-235e389599fso149335ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 01:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750147758; x=1750752558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K96lYH3E6ATNSom1EVn/oY1Xxk02NfoLGQNJ23f8GYs=;
        b=mg3+k2aXRxk0GLAORZACFyVxycSRjIfQEKZn4Gk6lKReOQmUvYngNH3yt+qFsrOmYN
         H+CfB1LgdRXL09Sni85PGy1ewgasJ5J7TKmmxe7nqLCK37GpLT0CtGjX0+qGmN89nuRX
         9HC8mNBQhGUDjyTfw6FBPa3emhieC0vScPt6ExTp6y1UDuLAxLhR+SuV4p7MOmk2x65v
         5V4IPtUmAjv1uhmu6Pqg8k8BEtQl5hWkHVS7VTPbNWpcKBaqaVcFC3+NCMgNKeT/j5HZ
         SeaO+9GUulWnwFvZeMjW8xh0Y89EXpsfOHdyrpPkjJS1dFzR7nOTMP4PxEiHsq2AJppR
         1EvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750147758; x=1750752558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K96lYH3E6ATNSom1EVn/oY1Xxk02NfoLGQNJ23f8GYs=;
        b=wnVHCGjvc3KDVIDHURkAHIxuRQXWZYgBD6El3Nztr+r6cDWF/FlHsGeosYBMFdYQgi
         vovyNaJAqRWIzbfVnjsGD1SG/FbYg+entM/EpcBhNOhWeugYVnnG7DKBzmmhGC47veSO
         bwPzWYkiKbczymaSzCATVnTjfCtKyD49NjS4S1Ieq9fcLuObv06jVUp7MIPWHUJJu3xt
         dzcAZwyWaqfWgKhiVaqvggX9xmYbN4eKMuvXWfJkmmhplurc1OHfk+3gi0Fni39cUKDF
         X+YynqEXu1REjFNCO5g5m2gb31yYMewVMsbuHAY/wvR/qp5sV1cdzEJ+5yFDSS21LF+Q
         wHZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX91acdxXNiFpmWT+YPWB4uJ5ULAuXt2RQGZfFPgYCc+iUG3WxvdRmDNMA8Qyu1y8QzVzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTZM3dHRR1eaUG8zqdAez05BgNyuQj3ITAqqu36l/YddPm92fg
	Yg12DGbnvmrTK9zfqSkPa5LUYrWj8Le6GUp2Okwe3TtGfUsSXwfgA80+rredSNvbuPc/+ysVOdw
	+kSSS1KiwPCzj0JEpvpgdCSX8t8sIcFqnOoioMV+a
X-Gm-Gg: ASbGncsB1V9X6PmtMvWBcI6CkVJwPv60tmbxseZDBImVBRaJ1IE53iE+cz6ZqenQ3db
	MiGyonbRRWSwhk6bnG0iMJgwpLBs4zMaX6d274hLpVAgfkx6nlJ0Hs4DnGZRWTqJYfPO93WU/kE
	K4Ntt08KUNEOQWYC3mJWzpek/CKP7YGzRvXxix+/qfeQ==
X-Google-Smtp-Source: AGHT+IG2betNC8At51eO9yYFOh+F0z+U752f1twVtVeRmC9ioMHP8IMN3Sy1z3kpv2PbBCdhAcaOkuaV4iikO4uTDA0=
X-Received: by 2002:a17:902:ef08:b0:215:65f3:27ef with SMTP id
 d9443c01a7336-2366c5a25dfmr7701555ad.12.1750147757705; Tue, 17 Jun 2025
 01:09:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com> <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com> <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 17 Jun 2025 01:09:05 -0700
X-Gm-Features: AX0GCFu5BeL5DrkBrqooR4aSvAssJM7-8t1ESGKGa90paS289VLNrATDVGTKJhc
Message-ID: <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kirill.shutemov@intel.com, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 11:55=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>
> On Mon, Jun 16, 2025 at 08:51:41PM -0700, Vishal Annapurve wrote:
> > On Mon, Jun 16, 2025 at 3:02=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > On Wed, Jun 11, 2025 at 07:30:10AM -0700, Vishal Annapurve wrote:
> > > > On Wed, Jun 4, 2025 at 7:45=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.c=
om> wrote:
> > > > >
> > > > > We need to restore to the previous status (which includes the hos=
t page table)
> > > > > if conversion can't be done.
> > > > > That said, in my view, a better flow would be:
> > > > >
> > > > > 1. guest_memfd sends a pre-invalidation request to users (users h=
ere means the
> > > > >    consumers in kernel of memory allocated from guest_memfd).
> > > > >
> > > > > 2. Users (A, B, ..., X) perform pre-checks to determine if invali=
dation can
> > > > >    proceed. For example, in the case of TDX, this might involve m=
emory
> > > > >    allocation and page splitting.
> > > > >
> > > > > 3. Based on the pre-check results, guest_memfd either aborts the =
invalidation or
> > > > >    proceeds by sending the actual invalidation request.
> > > > >
> > > > > 4. Users (A-X) perform the actual unmap operation, ensuring it ca=
nnot fail. For
> > > > >    TDX, the unmap must succeed unless there are bugs in the KVM o=
r TDX module.
> > > > >    In such cases, TDX can callback guest_memfd to inform the pois=
on-status of
> > > > >    the page or elevate the page reference count.
> > > >
> > > > Few questions here:
> > > > 1) It sounds like the failure to remove entries from SEPT could onl=
y
> > > > be due to bugs in the KVM/TDX module,
> > > Yes.
> > >
> > > > how reliable would it be to
> > > > continue executing TDX VMs on the host once such bugs are hit?
> > > The TDX VMs will be killed. However, the private pages are still mapp=
ed in the
> > > SEPT (after the unmapping failure).
> > > The teardown flow for TDX VM is:
> > >
> > > do_exit
> > >   |->exit_files
> > >      |->kvm_gmem_release =3D=3D> (1) Unmap guest pages
> > >      |->release kvmfd
> > >         |->kvm_destroy_vm  (2) Reclaiming resources
> > >            |->kvm_arch_pre_destroy_vm  =3D=3D> Release hkid
> > >            |->kvm_arch_destroy_vm  =3D=3D> Reclaim SEPT page table pa=
ges
> > >
> > > Without holding page reference after (1) fails, the guest pages may h=
ave been
> > > re-assigned by the host OS while they are still still tracked in the =
TDX module.
> >
> > What happens to the pagetable memory holding the SEPT entry? Is that
> > also supposed to be leaked?
> It depends on if the reclaiming of the page table pages holding the SEPT =
entry
> fails. If it is, it will be also leaked.
> But the page to hold TDR is for sure to be leaked as the reclaiming of TD=
R page
> will fail after (1) fails.
>

Ok. Few questions that I would like to touch base briefly on:
i) If (1) fails and then VM is marked as bugged, will the TDX module
actually access that page in context of the same VM again?
ii) What all resources should remain unreclaimed if (1) fails?
     * page backing SEPT entry
     * page backing PAMT entry
     * TDMR
    If TDMR is the only one that fails to reclaim, will the TDX module
actually access the physical memory ever after the VM is cleaned up?
Otherwise, should all of these be made unreclaimable?
iii) Will it be safe for the host to use that memory by proper
WBINVD/memory clearing sequence if TDX module/TD is not going to use
that memory?

>
>
> > > > 2) Is it reliable to continue executing the host kernel and other
> > > > normal VMs once such bugs are hit?
> > > If with TDX holding the page ref count, the impact of unmapping failu=
re of guest
> > > pages is just to leak those pages.
> > >
> > > > 3) Can the memory be reclaimed reliably if the VM is marked as dead
> > > > and cleaned up right away?
> > > As in the above flow, TDX needs to hold the page reference on unmappi=
ng failure
> > > until after reclaiming is successful. Well, reclaiming itself is poss=
ible to
> > > fail either.
> > >
> > > So, below is my proposal. Showed in the simple POC code based on
> > > https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-con=
versions-hugetlb-2mept-v2.
> > >
> > > Patch 1: TDX increases page ref count on unmap failure.
> >
> > This will not work as Ackerley pointed out earlier [1], it will be
> > impossible to differentiate between transient refcounts on private
> > pages and extra refcounts of private memory due to TDX unmap failure.
> Hmm. why are there transient refcounts on private pages?
> And why should we differentiate the two?

Sorry I quoted Ackerley's response wrongly. Here is the correct reference [=
1].

Speculative/transient refcounts came up a few times In the context of
guest_memfd discussions, some examples include: pagetable walkers,
page migration, speculative pagecache lookups, GUP-fast etc. David H
can provide more context here as needed.

Effectively some core-mm features that are present today or might land
in the future can cause folio refcounts to be grabbed for short
durations without actual access to underlying physical memory. These
scenarios are unlikely to happen for private memory but can't be
discounted completely.

Another reason to avoid relying on refcounts is to not block usage of
raw physical memory unmanaged by kernel (without page structs) to back
guest private memory as we had discussed previously. This will help
simplify merge/split operations during conversions and help usecases
like guest memory persistence [2] and non-confidential VMs.

[1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.google=
rs.com/
[2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon.com=
/

>
>
> > [1] https://lore.kernel.org/lkml/diqzfrgfp95d.fsf@ackerleytng-ctop.c.go=
oglers.com/
> >
> > > Patch 2: Bail out private-to-shared conversion if splitting fails.
> > > Patch 3: Make kvm_gmem_zap() return void.
> > >
> > > ...
> > >         /*
> > >
> > >
> > > If the above changes are agreeable, we could consider a more ambitiou=
s approach:
> > > introducing an interface like:
> > >
> > > int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
> > > int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);
> >
> > I don't see any reason to introduce full tracking of gfn mapping
> > status in SEPTs just to handle very rare scenarios which KVM/TDX are
> > taking utmost care to avoid.
> >
> > That being said, I see value in letting guest_memfd know exact ranges
> > still being under use by the TDX module due to unmapping failures.
> > guest_memfd can take the right action instead of relying on refcounts.
> >
> > Does KVM continue unmapping the full range even after TDX SEPT
> > management fails to unmap a subrange?
> Yes, if there's no bug in KVM, it will continue unmapping the full ranges=
.

