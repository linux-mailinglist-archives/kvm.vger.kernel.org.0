Return-Path: <kvm+bounces-64559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 26955C87006
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:20:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 194974EA42E
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492D533B95E;
	Tue, 25 Nov 2025 20:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2jWibM3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D863F31ED65
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 20:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764101985; cv=none; b=pBFZD4DGviJC3Anhf1oNj486Xs2n0EuuLrTfQRo+OMUqT3NHMW/Z0DfxY4pMZnt1jJ5eVkiA16m7mfwK2wJmHDyrEWvDbNQWMEH8L7IO5hkpFI6/JFqzDNHIshnciWcdCuNpd/kvOjWZXYp1LJQn7o+vXvgkk4MVFAWWoJZe4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764101985; c=relaxed/simple;
	bh=TfXLQ7eMP7rkYU5fTK9bIte/OyK7lqXUWNtmDfb3dac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xl6T4MIhZ0tDmscbHV35O0dHLuwYxI5TL7mSmzFEeRLN9mQZtaSI8f9uIybeV9I7NRcododVkjisc7yge20gT/hqldOkbzF86P6Y2BeHjqNF9puqYjALPtInYY6ZNUOMIdtt2YYFSykV4FqO6nB6VjjMOOw9mRa8iA7f5Ol5RGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2jWibM3G; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2980343d9d1so415ad.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 12:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764101983; x=1764706783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHnBbe3Vz2qssfWJEc+r2TwEWDPYjkvuNmONn0WVHOs=;
        b=2jWibM3GQ0Pu7ZHoarxXcg/6fB2y2iHvQgxPbjI0wi6TN9jChR9cye8JnRKkGGT6uN
         kFHUS7kb2wYLSTqmh341wl/AN0gydXDvHiINdQflfXJoCmWDbaoWHVdHTMLn9sCQ2Ywc
         TdogwyRx72yBa4cZsaAJtmgn5+loYBTf5teg1T6otPWn+SSq0iA+2UmHDD2ZLKY3Zkp+
         gTXQ2VpM7TCTlFMxTymEuQ8RCz+9PFq1k6h1WA5E2TBiOnOnD7L1//PU8Kmx+nIIZyzA
         H8WjGHtmY4d5c/r+XwQMw2rVcaF0SxKpqASTg/Cj7qj6jBa+oF+vCnhLqNyI+dDGoc8O
         ++yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764101983; x=1764706783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RHnBbe3Vz2qssfWJEc+r2TwEWDPYjkvuNmONn0WVHOs=;
        b=Suk7iC7tQgRoViM1BAuJFlrjJm3lmrV+M36eV1ePFb49aKPS8T+LePNGrKe6NQNFTc
         N+apeponTxjc4eW/EbQaE7IAX+6TTIeTNGco++ieVxgstN2oQlmC9DT+11WpkXRSaV2q
         Mdy2cYJjJveigzdivBGlYaoJUsIwHc05DFqirWi8DRHqRYVEcabvLUakYauBfrPOvIDN
         A/uDf4iSUfPrAQN8WC3RJXd/R2ma4jj3IgsO3Q/sTItbYgS9zgTU46RSiFW7ZobWZzc0
         xYfsKK+YkV5l8pAxpoInGFI9ZfdWgLEIJS9XdEALSN3tAwqTTOkYs4miCJ2CnXcmN35E
         UjsA==
X-Forwarded-Encrypted: i=1; AJvYcCWjR9GosOr928iJ56G+R1GHYxYesnCCW2v6TcZZQcc8mvddipQUHpDrZLqmLExQyCk8jTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWF7wf4atPv2ka+0CP95axyNEz6Abg80QV2jjwadA0Tc1HkAv5
	HLcSa9devassGWPfPcD1Q9edIQyafuVDUtHrK0+ivUJ4qrYRsvgUbcKwluSHTbUz3OS5D6uYiqW
	MlMkzQ1+ksEW6VXtwkxfVEaaS/dfMrHRiuwZq4TT3oigsFcqrqoeEhLSs
X-Gm-Gg: ASbGncvP2g+X4WQtD1JCrf7TjMwyxlaFGMkUcI5UCx8qc3lFEAKYu3YlvM5hBa1UH8y
	/yiiyjGBjE4i5K1oKosdEsb1oTXIirZ5wfB3s/XtyG5Ui9Agpen/dOxq/pcYZTWoNBACfZP7yeK
	lF0CqR0lDC53ufBYdatvpeXUYe34K835G++duDZUfl7sDw0aLONTPEiyCU1WOEeyG4KpenjI4nA
	JUNCGbilZS1XVXImffAfGYtW0xaUHMsdunaBGx4ans8FcHakdojGCxaWxFPEOGwaxzHfhkYdDHu
	AKKkQQycGO4LXuyXO7L7DRgI
X-Google-Smtp-Source: AGHT+IF779IW4vsIcrs2I3YvHsOxMox3kgZbhhBFciEEFQDtvBW9XhXWERcz3VmUskBP6M6LUqEOOJF1Dsvqi8UvFOM=
X-Received: by 2002:a05:7022:6289:b0:11a:2c18:9e70 with SMTP id
 a92af1059eb24-11dc328a4c5mr20026c88.11.1764101982376; Tue, 25 Nov 2025
 12:19:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 25 Nov 2025 12:19:30 -0800
X-Gm-Features: AWmQ_bkGaBaAKmGuHN0VfSyMJxYxC_cB_ZllFi8Kt1CG5QaGEqyEGvIM4EGFCOo
Message-ID: <CAGtprH9=p03WtA8-cf8xL4F48jdtD046AwRV3bigMjc-JD=0=w@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] TDX: Enable Dynamic PAMT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 4:51=E2=80=AFPM Rick Edgecombe
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

acked-by: Vishal Annapurve <vannapurve@google.com>.

