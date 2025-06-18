Return-Path: <kvm+bounces-49807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F8EADE28B
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:29:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55DC81768A8
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B841EF0BE;
	Wed, 18 Jun 2025 04:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XfSz8sfv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D9382866
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220772; cv=none; b=tJUIEGncdq2gWMLF9Dz3x+0ZKMHKggnyGTQ9Vl9PQ71LWfKwvYmf1wS1FHBbeUZhdz3v7GacgFFLkPChO5dGk1b+wCBpMJv7PG00XTgFDpPc6Ow0TDECjlktFy7z/+l95Z9VNkOc0I/rxKQs5dg4v9sqbavLEF7cSLhDdMPdzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220772; c=relaxed/simple;
	bh=lI69zE+HuIKKtCaYZnqekdCVR8WTP71AqBDR5kMK5XQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UPhQh4Y2R2qyvquWODQwkTN5oEu78df0hRjjgQu5k/XPLl5yrrKsBCHe4s39BUmCODT/kgDf7Bu8u51pozOqIIpcjn3z+JAWIsR7PWuB7ExdI+pPUgXhmNauZful8b72kLp2VbJXYe8aE6sXz83LCabBNc6yBRGwjBYt1xc68VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XfSz8sfv; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2348ac8e0b4so60555ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220769; x=1750825569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tp1jyo90kZaLC1u6LukpSmdED/ZzsLDnZlIOZr8fbC8=;
        b=XfSz8sfvV38L4O/xhIXQpxCqAcLL8Kkolhl7SVh7wiBsgIvsm05yVvhxijbD0GZdMB
         FDrE6CnCxri29aogMMdOWVJdQUyoYk0oLMKNuK6G9lH6k6V7maTaUfK9FFlg/bs+sDTW
         KvKmtxd2cyOHXuLEm9S8gERZyrxz8UZSgLcq75lz6wWWo+FuXSr7QUeYp/LsHO+g24yl
         g/32FtBwlsjxS6CNwFCeIrK987QBRprNpXT21Pn+HqXUQWT+zxYaEBbArQ2oj2ftvN4Z
         /yBOwhOvSorgCfbpChLiQhj0BtEiN+LnHP5ZAPS+mYa1bstk52Az6z5t37P23+k6Ge7k
         7YUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220769; x=1750825569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tp1jyo90kZaLC1u6LukpSmdED/ZzsLDnZlIOZr8fbC8=;
        b=nqySUgjbaM60hDeDqUSWzwe++0zOym14xNJoF1N0TQnZwVSVfI3Vi1h2yKkDXk+L9J
         4i7JqdwE84Dlxe+hqH7yzwNKGRewhdEd8nIIV0qaAQVqvTriyVFDHXpRBUJxEXwklQr7
         W+qzRlOMtChpKQCvNoIH5pMa/MTKseBlCes9q+fBEUmM6D1BFksmY9EmSPil1PRy5A3u
         /M130Oeu45+GwYns8Ko9bx1MqwOplqQz7QI4uXi3KM6HMpiU/DtpBQrFBuvOuDhMw3c1
         EXel5Ng7GH+GsyokNhVjCaef5Vh4lrFhm7GuNAINM1jqSTtMOK0mcDcfpO9kVn1dbNW7
         ZB1w==
X-Forwarded-Encrypted: i=1; AJvYcCXTcN+4lEe5Q7N0KdpHS+q8zetRfBbGvczJ0FSd40RnvQfbRFIEh3j2oSPj6gGkv5K3/hQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRLNHb43vzzgmfWWC8nUdCAj1dGqxLVhqeGwsMTlEtkKyH/Gh+
	BJXTDmUN6xAfNsyeaKhGCIO7vyU0ftv6PdhrWWOiEkxxS4GEjExr+quGJRWnVVPaElyJ1k+pSIY
	Fadj8qOYp2Gxu+C9BPnUAJV9lCGAk8Vyax4CLGfbS
X-Gm-Gg: ASbGnct5cWdcBciAhmT5cx1gv/Je2NRDWAd8J8/Z0n6xffHj2R/Pq6ooym9LeaSRAPN
	wTto7Mj5NnNsPSUoWNWCbaUbqh1PzTOrJXMf80QA/QTH8tbW7p2lZyVW74vV9KplgIBo5a8dK+n
	zTnWVXoRRGKM6c0XzUpJ9wm2VGV0mPA/J+9NTycqInJA==
X-Google-Smtp-Source: AGHT+IGG8jYryP+XneMDoForwJFusLHsIh0W4ht5hK3CBKqDPBlWHrfl1TqTGheWXVWHujfmaiqHprZZAAtTj1EpgY4=
X-Received: by 2002:a17:902:d48f:b0:223:2630:6b86 with SMTP id
 d9443c01a7336-2366eef035dmr10440905ad.7.1750220769064; Tue, 17 Jun 2025
 21:26:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com> <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com> <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com> <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <aFE8H0J7w+JEnxSq@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFE8H0J7w+JEnxSq@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 17 Jun 2025 21:25:56 -0700
X-Gm-Features: AX0GCFt8tS_p3diVdvc5iXbvtFlyG4ZWV-vKzK0bu9uyb_vCT3wr0SvQzh_Va40
Message-ID: <CAGtprH-X=zcw3CLgo4P0-nTuQsDk+8apeZr+Y6sRaz5LSMDM=w@mail.gmail.com>
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

On Tue, Jun 17, 2025 at 3:00=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Tue, Jun 17, 2025 at 01:09:05AM -0700, Vishal Annapurve wrote:
> > On Mon, Jun 16, 2025 at 11:55=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com=
> wrote:
> > >
> > > On Mon, Jun 16, 2025 at 08:51:41PM -0700, Vishal Annapurve wrote:
> > > > On Mon, Jun 16, 2025 at 3:02=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.=
com> wrote:
> > > > >
> > > > > On Wed, Jun 11, 2025 at 07:30:10AM -0700, Vishal Annapurve wrote:
> > > > > > On Wed, Jun 4, 2025 at 7:45=E2=80=AFPM Yan Zhao <yan.y.zhao@int=
el.com> wrote:
> > > > > > >
> > > > > > > We need to restore to the previous status (which includes the=
 host page table)
> > > > > > > if conversion can't be done.
> > > > > > > That said, in my view, a better flow would be:
> > > > > > >
> > > > > > > 1. guest_memfd sends a pre-invalidation request to users (use=
rs here means the
> > > > > > >    consumers in kernel of memory allocated from guest_memfd).
> > > > > > >
> > > > > > > 2. Users (A, B, ..., X) perform pre-checks to determine if in=
validation can
> > > > > > >    proceed. For example, in the case of TDX, this might invol=
ve memory
> > > > > > >    allocation and page splitting.
> > > > > > >
> > > > > > > 3. Based on the pre-check results, guest_memfd either aborts =
the invalidation or
> > > > > > >    proceeds by sending the actual invalidation request.
> > > > > > >
> > > > > > > 4. Users (A-X) perform the actual unmap operation, ensuring i=
t cannot fail. For
> > > > > > >    TDX, the unmap must succeed unless there are bugs in the K=
VM or TDX module.
> > > > > > >    In such cases, TDX can callback guest_memfd to inform the =
poison-status of
> > > > > > >    the page or elevate the page reference count.
> > > > > >
> > > > > > Few questions here:
> > > > > > 1) It sounds like the failure to remove entries from SEPT could=
 only
> > > > > > be due to bugs in the KVM/TDX module,
> > > > > Yes.
> > > > >
> > > > > > how reliable would it be to
> > > > > > continue executing TDX VMs on the host once such bugs are hit?
> > > > > The TDX VMs will be killed. However, the private pages are still =
mapped in the
> > > > > SEPT (after the unmapping failure).
> > > > > The teardown flow for TDX VM is:
> > > > >
> > > > > do_exit
> > > > >   |->exit_files
> > > > >      |->kvm_gmem_release =3D=3D> (1) Unmap guest pages
> > > > >      |->release kvmfd
> > > > >         |->kvm_destroy_vm  (2) Reclaiming resources
> > > > >            |->kvm_arch_pre_destroy_vm  =3D=3D> Release hkid
> > > > >            |->kvm_arch_destroy_vm  =3D=3D> Reclaim SEPT page tabl=
e pages
> > > > >
> > > > > Without holding page reference after (1) fails, the guest pages m=
ay have been
> > > > > re-assigned by the host OS while they are still still tracked in =
the TDX module.
> > > >
> > > > What happens to the pagetable memory holding the SEPT entry? Is tha=
t
> > > > also supposed to be leaked?
> > > It depends on if the reclaiming of the page table pages holding the S=
EPT entry
> > > fails. If it is, it will be also leaked.
> > > But the page to hold TDR is for sure to be leaked as the reclaiming o=
f TDR page
> > > will fail after (1) fails.
> > >
> >
> > Ok. Few questions that I would like to touch base briefly on:
> > i) If (1) fails and then VM is marked as bugged, will the TDX module
> > actually access that page in context of the same VM again?
> In TDX module, the TD is marked as TD_TEARDOWN after step (2) when hkid i=
s
> released successfully.
> Before that, TD is able to access the pages even if it is marked as buggy=
 by KVM.
>
> After TD is marked as TD_TEARDOWN, since (1) fails, the problematic guest
> private pages are still tracked in the PAMT entries.
> So, re-assignment the same PFN to other TDs will fail.
>
> > ii) What all resources should remain unreclaimed if (1) fails?
> >      * page backing SEPT entry
> >      * page backing PAMT entry
> >      * TDMR
> >     If TDMR is the only one that fails to reclaim, will the TDX module
> > actually access the physical memory ever after the VM is cleaned up?
> > Otherwise, should all of these be made unreclaimable?
> From my understanding, they are
> - guest private pages
> - TDR page
> - PAMT entries for guest private pages and TDR page
>
>
> > iii) Will it be safe for the host to use that memory by proper
> > WBINVD/memory clearing sequence if TDX module/TD is not going to use
> > that memory?
> I'm not sure. But it should be impossible for host to re-assign the pages=
 to
> other TDs as long as PAMT entries are not updated.
>
>
> > > > > > 2) Is it reliable to continue executing the host kernel and oth=
er
> > > > > > normal VMs once such bugs are hit?
> > > > > If with TDX holding the page ref count, the impact of unmapping f=
ailure of guest
> > > > > pages is just to leak those pages.
> > > > >
> > > > > > 3) Can the memory be reclaimed reliably if the VM is marked as =
dead
> > > > > > and cleaned up right away?
> > > > > As in the above flow, TDX needs to hold the page reference on unm=
apping failure
> > > > > until after reclaiming is successful. Well, reclaiming itself is =
possible to
> > > > > fail either.
> > > > >
> > > > > So, below is my proposal. Showed in the simple POC code based on
> > > > > https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem=
-conversions-hugetlb-2mept-v2.
> > > > >
> > > > > Patch 1: TDX increases page ref count on unmap failure.
> > > >
> > > > This will not work as Ackerley pointed out earlier [1], it will be
> > > > impossible to differentiate between transient refcounts on private
> > > > pages and extra refcounts of private memory due to TDX unmap failur=
e.
> > > Hmm. why are there transient refcounts on private pages?
> > > And why should we differentiate the two?
> >
> > Sorry I quoted Ackerley's response wrongly. Here is the correct referen=
ce [1].
> >
> > Speculative/transient refcounts came up a few times In the context of
> > guest_memfd discussions, some examples include: pagetable walkers,
> > page migration, speculative pagecache lookups, GUP-fast etc. David H
> > can provide more context here as needed.
> GUP-fast only walks page tables for shared memory?
> Can other walkers get a private folio by walking shared mappings?

No, they can't. There can be walkers that parse direct map entries.

>
> On those speculative/transient refcounts came up, can't the
> kvm_gmem_convert_should_proceed() wait in an interruptible way before ret=
urning
> failure?

These refcounts can land any time on any of the ranges, so guest_memfd
implementation to bail out on errors will need to be time bound for
each folio and will need traversal of each folio even before actual
restructuring. That increases the complexity and latency of conversion
operation.

>
> The wait will anyway happen after the conversion is started, i.e.,
> in filemap_remove_folio_for_restructuring().
>        while (!folio_ref_freeze(folio, filemap_refcount)) {
>                 /*
>                  * At this point only filemap refcounts are expected, hen=
ce okay
>                  * to spin until speculative refcounts go away.
>                  */
>                 WARN_ONCE(1, "Spinning on folio=3D%p refcount=3D%d", foli=
o, folio_ref_count(folio));
>         }
>
>
> BTW, I noticed that there's no filemap_invalidate_lock_shared() in
> kvm_gmem_fault_shared() in
> https://lore.kernel.org/all/20250611133330.1514028-9-tabba@google.com/.
>
> Do you know why?

It will land when guest_memfd in-place conversion support will be posted.

>
> > Effectively some core-mm features that are present today or might land
> > in the future can cause folio refcounts to be grabbed for short
> > durations without actual access to underlying physical memory. These
> > scenarios are unlikely to happen for private memory but can't be
> > discounted completely.
> >
> > Another reason to avoid relying on refcounts is to not block usage of
> > raw physical memory unmanaged by kernel (without page structs) to back
> > guest private memory as we had discussed previously. This will help
> > simplify merge/split operations during conversions and help usecases
> > like guest memory persistence [2] and non-confidential VMs.
> Ok.
> Currently, "letting guest_memfd know exact ranges still being under use b=
y the
> TDX module due to unmapping failures" is good enough for TDX, though full
> tracking of each GFN is even better.
>
>
> > [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.go=
oglers.com/
> > [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon=
.com/
> >
> > >
> > >
> > > > [1] https://lore.kernel.org/lkml/diqzfrgfp95d.fsf@ackerleytng-ctop.=
c.googlers.com/
> > > >
> > > > > Patch 2: Bail out private-to-shared conversion if splitting fails=
.
> > > > > Patch 3: Make kvm_gmem_zap() return void.
> > > > >
> > > > > ...
> > > > >         /*
> > > > >
> > > > >
> > > > > If the above changes are agreeable, we could consider a more ambi=
tious approach:
> > > > > introducing an interface like:
> > > > >
> > > > > int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
> > > > > int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);
> > > >
> > > > I don't see any reason to introduce full tracking of gfn mapping
> > > > status in SEPTs just to handle very rare scenarios which KVM/TDX ar=
e
> > > > taking utmost care to avoid.
> > > >
> > > > That being said, I see value in letting guest_memfd know exact rang=
es
> > > > still being under use by the TDX module due to unmapping failures.
> > > > guest_memfd can take the right action instead of relying on refcoun=
ts.
> > > >
> > > > Does KVM continue unmapping the full range even after TDX SEPT
> > > > management fails to unmap a subrange?
> > > Yes, if there's no bug in KVM, it will continue unmapping the full ra=
nges.

