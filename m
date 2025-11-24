Return-Path: <kvm+bounces-64430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F31C8266D
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 21:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E2DF3AD91E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F09233723;
	Mon, 24 Nov 2025 20:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EnNCZX+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DF9224AF2
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 20:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764015519; cv=none; b=p8qsCNdT0Bdhm6aWuzhc6+sl+EhawNAH9pZ5E//kZFoYOiGtM8AKJiQ0iUlUqsyJoRCp6YprA+0iZmSuFnumEMxdEXcTra2SSiqHbBBnbSU4jbh/VMUF4OoGdu/uoXwrt6n9in7M3LiJVpMNBrKBhWBz4k+a8wa94HgR/iuzZ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764015519; c=relaxed/simple;
	bh=4gJLxwgwrtbwpNrRsI6kO8/6ERN30OIIDFQpTVLVXLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eYGImz5s1RkIlBH2PTGxTCM4F3jdYVDXCD73RMHxGnEioLjXXkavH6rfviiSRT4bkaCtVnwmx9k4CpXjf/im1SPFHya7PtF0gnzu6ICTSOizXevugFn/JtnEvzIt6cQdCvrEbND7/7Y2J1kpaKMyo5OhqjlUFIly4uTH31uHg0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EnNCZX+P; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee147baf7bso2721cf.1
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 12:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764015516; x=1764620316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trRifxv63geAzANQHmXVqpNbo55yno0zBVWNO2DOSTs=;
        b=EnNCZX+P39l1ItwX7ZfFICAH+ChaUh+XQSrL8r5Hder/sfxVu6e4uazwqzoEkPLcux
         3JdInzONmActq17aRqScj9uHPLNbqPT39C08mUmFyPn9+hOz2MGilNYWpfjqsNNRrMxW
         6u2eOPb8DuICWV8p4CUzTk+2jZaD/q3AEdRkPeZtgkj6fVpNcLf7VLiDl2C3pSIUh9pB
         GyMCD23oR/DlYPapJAmMQ8fAUDEpP9Hs7jBDUPmWgXBMmxC3fYW5lHxNv8MX+6yM/qUs
         w8pa48L0ucJ+dJvjTQwUVX8sor0ZnZeR/HSytct02U1XNdog9loyBG+zJXRAbsF+Vxot
         CLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764015516; x=1764620316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=trRifxv63geAzANQHmXVqpNbo55yno0zBVWNO2DOSTs=;
        b=DAFUCBqkmPMFYNXQQ5H0NJSqzMpRRDn0C4vAB/YQHyGxSmdR8vEqghuDlxvL21IjJT
         JNTGoUZNgkYLFRG0ZxNo1XO+FA8esCcdYI5Ii6jhiKtSLs9xpDzWyL07qDVa/WI3eaGY
         fizZ/H5m688VI1WCckG9nSCxyTZVamm8iekMsG7jL1+ht1T0b0VzGfzy07T0mB/2NcLr
         eJw+lv0IYEqNXVvCjLPYhSVlkLPI9jIHztqWeoQhbdLWY7WEkbjSXv13QPLANypUodzO
         Fje+BWc1rVvBgfMIAgJRDoj+i7oLeZ0srl4cWVYuawwNgaG/CkoTIDVx3hb2+l5kU+Zj
         dRjg==
X-Forwarded-Encrypted: i=1; AJvYcCXalyOMxBfwf8zymapeKNY0PS1mTMmiiGe3n/7Tcme1W5QqJF78mAEg5n+xrEUzJq/kRD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YznhT+pxlFK6GPgCHy6xHSF6igdsOYl91Qua8sQGyWveRNfkABl
	0CtSy/y60XiKVgCPqp+XMRdT6nsDZFuOPIIa2cel5P7GK78qe6mrIxUWTAwEooPFmrxdhOfI4wG
	aiD6tQnhq34Ykg18uua3b/HAxlC1wshp2CLy4urLr
X-Gm-Gg: ASbGncsJThRQpm1fygiw1gt9BTIxZ2fRS6gNBaRQ3T/vwRG8WZa2hcEGNz8NC7FIK5a
	wY2DNC13jfB8twD8U9q4pWwcj+lZD1JlKMh3VIGTQX0FO6EJgYqf6vQ3dokgQxJ6N2VGMyLfxuj
	EczHKI3w0clNV1gscHUkKBlVn1gxlkYqIQdRGVj8FArbfQYP9+nksawlKLXmkEbLeWJIRJM7PeI
	d768fNluASlJ5rL/xJsmORPtNKbciPnuI6M1JyZYF9qVvRgS1v1ige/PguhbrcGz+J7z4WWU19s
	rAWG8XzqvZnGxjH1jEIeSJMy79u/
X-Google-Smtp-Source: AGHT+IEF2X05krJ0w9/K+7Z/MxGjFd5q7r7hUiKQZ72qCZkUQlF8sJzzUjlAvDyOV5iT5v56kUHOVeI7WD4t8IcXydM=
X-Received: by 2002:ac8:58cb:0:b0:4ed:341a:5499 with SMTP id
 d75a77b69052e-4efbdd4159emr101121cf.11.1764015514356; Mon, 24 Nov 2025
 12:18:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 24 Nov 2025 14:18:22 -0600
X-Gm-Features: AWmQ_bnJq7f4oZ5lNbDinGqPZC0jcF0cTNrAk5dwtyuN743Tz159mXcBZea_L3U
Message-ID: <CAAhR5DFXAmgDKy-5dvUCK0AU9Jk58A8mB+N63FTb2oFto_bTpg@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] TDX: Enable Dynamic PAMT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 6:51=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> Hi,
>
> This is 4th revision of Dynamic PAMT, which is a new feature that reduces
> the memory use of TDX. For background information, see the v3
> coverletter[0]. V4 mostly consists of incorporating the feedback from v3.
> Notably what it *doesn=E2=80=99t* change is the solution for pre-allocati=
ng DPAMT
> backing pages. (more info below in =E2=80=9CChanges=E2=80=9D)
>
> I think this series isn=E2=80=99t quite ready to ask for merging just yet=
. I=E2=80=99d
> appreciate another round of review especially looking for any issues in t=
he
> refcount allocation/mapping and the pamt get/put lock-refcount dance. And
> hopefully collect some RBs.
>
> Sean/Paolo, we have mostly banished this all to TDX code except for =E2=
=80=9CKVM:
> TDX: Add x86 ops for external spt cache=E2=80=9D patch. That and =E2=80=
=9Cx86/virt/tdx:
> Add helpers to allow for pre-allocating pages=E2=80=9D are probably the r=
emaining
> possibly controversial parts of your domain. If you only have a short tim=
e
> to spend at this point, I=E2=80=99d point you at those two patches.
>
> Since most of the changes are in arch/x86, I=E2=80=99d think this feature=
 could be
> a candidate for eventually merging through tip with Sean or Paolo=E2=80=
=99s ack.
> But it is currently based on kvm-x86/next in order to build on top of the
> post-populate cleanup series. Next time I=E2=80=99ll probably target tip =
if people
> think that is a good way forward.
>
> Changes
> =3D=3D=3D=3D=3D=3D=3D
> There were two good suggestions around the pre-allocated pages solution
> last time, but neither ended up working out:
>
> 1. Dave suggested to use mempool_t instead of the linked list based
> structure, in order to not re-invent the wheel. This turned out to not
> quite fit. The problems were that there wasn=E2=80=99t really a =E2=80=9C=
topup=E2=80=9D mechanism,
> or an atomic fallback (which matches the kvm cache behavior). This result=
s
> in very similar code being built around mempool that was built around the
> linked list. It was an overall harder to follow solution for not much cod=
e
> savings.
>
> I strongly considered going back to Kiryl=E2=80=99s original solution whi=
ch passed
> a callback function pointer for allocating DPAMT pages, and an opaque
> void * that the callback could use to find the kvm_mmu_memory_cache. I
> thought that readability issues of passing the opaque void * between
> subsystems outweighed the small code duplication in the simple, familiar
> patterned linked list-based code. So I ended up leaving it.
>
> 2. Kai suggested (but later retracted the idea) that since the external
> page table cache was moved to TDX code, it could simply install DPAMT
> pages for the cache at topup time. Then the installation of DPAMT backing
> for S-EPT page tables could be done outside of the mmu_lock. It could als=
o
> be argued that it makes the design simpler in a way, because the external
> page table cache acts like it did before. Anything in there could be simp=
ly
> used.
>
> At the time my argument against this was that whether a huge page would b=
e
> installed (and thus, whether DPAMT backing was needed) for the guest
> private memory would not be known until later, so early install solution
> would need special late handling for TDX huge pages. After some internal
> discussions I at looked how we could simplify the series by punting on TD=
X
> huge pages needs.
>
> But it turns out that this other design was actually more complex and had
> more LOC than the previous solution. So it was dropped, and again, I went
> back to the original solution.
>
>
> I=E2=80=99m really starting to think that, while the overall solution her=
e isn=E2=80=99t
> the most elegant, we might not have much more to squeeze from it. So
> design-wise, I think we should think about calling it done.
>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
> Based on kvm-x86/next (4531ff85d925). Testing was the usual, except I als=
o
> tested with TDX modules that don't support DPAMT, and with the two
> optimization patches removed: =E2=80=9CImprove PAMT refcounters allocatio=
n for
> sparse memory=E2=80=9D and =E2=80=9Cx86/virt/tdx: Optimize tdx_alloc/free=
_page() helpers=E2=80=9D.
>
> [0] https://lore.kernel.org/kvm/20250918232224.2202592-1-rick.p.edgecombe=
@intel.com/
>
>
> Kirill A. Shutemov (13):
>   x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>
>   x86/tdx: Add helpers to check return status codes
>   x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
>   x86/virt/tdx: Allocate reference counters for PAMT memory
>   x86/virt/tdx: Improve PAMT refcounts allocation for sparse memory
>   x86/virt/tdx: Add tdx_alloc/free_page() helpers
>   x86/virt/tdx: Optimize tdx_alloc/free_page() helpers
>   KVM: TDX: Allocate PAMT memory for TD control structures
>   KVM: TDX: Allocate PAMT memory for vCPU control structures
>   KVM: TDX: Handle PAMT allocation in fault path
>   KVM: TDX: Reclaim PAMT memory
>   x86/virt/tdx: Enable Dynamic PAMT
>   Documentation/x86: Add documentation for TDX's Dynamic PAMT
>
> Rick Edgecombe (3):
>   x86/virt/tdx: Simplify tdmr_get_pamt_sz()
>   KVM: TDX: Add x86 ops for external spt cache
>   x86/virt/tdx: Add helpers to allow for pre-allocating pages
>
>  Documentation/arch/x86/tdx.rst              |  21 +
>  arch/x86/coco/tdx/tdx.c                     |  10 +-
>  arch/x86/include/asm/kvm-x86-ops.h          |   3 +
>  arch/x86/include/asm/kvm_host.h             |  14 +-
>  arch/x86/include/asm/shared/tdx.h           |   8 +
>  arch/x86/include/asm/shared/tdx_errno.h     | 104 ++++
>  arch/x86/include/asm/tdx.h                  |  78 ++-
>  arch/x86/include/asm/tdx_global_metadata.h  |   1 +
>  arch/x86/kvm/mmu/mmu.c                      |   6 +-
>  arch/x86/kvm/mmu/mmu_internal.h             |   2 +-
>  arch/x86/kvm/vmx/tdx.c                      | 160 ++++--
>  arch/x86/kvm/vmx/tdx.h                      |   3 +-
>  arch/x86/kvm/vmx/tdx_errno.h                |  40 --
>  arch/x86/virt/vmx/tdx/tdx.c                 | 587 +++++++++++++++++---
>  arch/x86/virt/vmx/tdx/tdx.h                 |   5 +-
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   7 +
>  16 files changed, 854 insertions(+), 195 deletions(-)
>  create mode 100644 arch/x86/include/asm/shared/tdx_errno.h
>  delete mode 100644 arch/x86/kvm/vmx/tdx_errno.h
>
> --
> 2.51.2
>
>

Tested-by: Sagi Shahar <sagis@google.com>

