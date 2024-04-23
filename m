Return-Path: <kvm+bounces-15666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D08168AE831
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 620A71F2189F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64536134723;
	Tue, 23 Apr 2024 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4su+mCA8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1EC1353E0
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713879026; cv=none; b=Jmoo5r0YEd1X+uVXl0ouis/qo11RwXuc36stmXSMd26frbKKASRzZ/JS8B3hso8+HmZzqx3St4WIL1t+/VkuFekPz56UaYyy2MXUlncNNExhs51SNsLyQ1oWDuBZ/IAA7KkieG3nP/B4ArWcf5dsT87pb6vEmIa6X67I9rh7ZFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713879026; c=relaxed/simple;
	bh=6pTbD/rwFgxVGs5AwTDlXJJdGPcvc4NdMWrZUI0602M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mEf4mL28CPFD9J0iET20UHIzL0emhc7CxuWU4sJNKnw33w2FlseRbc7e4jbNy8Zx0vYxVDiFNrRSFVgEclgffB4W/UlHUu2d0Y8RMqqxnl+SWBIHYyafbjIqXfjNJ/ULi88OTcMsz3Don2yHMBozxCZshGz0gRrDK6rVMNfZlp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4su+mCA8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-418820e6effso82375e9.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 06:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713879023; x=1714483823; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=todKWq0A6fRWqF4lkMyggTJHDH2kUuFiLTbLrHfjGnc=;
        b=4su+mCA8BPCibIjE3iWB5j3NBAr0vguQ5ClojD99tnERk1mxGs1ZERgx5pPuKoO8c0
         1hrbgJeWV6MmEuVkJKRakupC6/g/APGkfEC6xC5Qr6fLtDx+CtYqN7LltToa8A6JAT0K
         DCVoCh7ZDDf3ofCeTAqBfAttMtAC37bdI7D8KVaYOulerV9vX73cTe/3iz0Ohf+0TcLX
         i88tWzoSx8e+1nzbFT7hPc0Qhrck5hXoiWzQ01RPUdmJ3GU2KsSbysekrbCWQ62Ezg+i
         woUEHvCyRYOutCqmXDDYvE8b8qE/c1Wf09GGTjhU8cAVRzPN3c83Iq6aBGKI6BbUAxSO
         jvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713879023; x=1714483823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=todKWq0A6fRWqF4lkMyggTJHDH2kUuFiLTbLrHfjGnc=;
        b=XPknVRrfBr0TQRs7VtuWpi53jn8EObdT5soC2m78jvAmBfun3eLvr/27P7yH0mmlWu
         iNbqhZpJF7UEUpuRUIzg1d1qNRWNPgweNjAnksaAtWJmjSyyZDRaWjuL0pWbXhXJd892
         MLZt3WOurQpaSjRmptY4bxl6atFm4C/lKDZpM/awNv383q4OnbMgo71ghvAEzKuxCjm2
         kHh5KE/1ETEb01olFMRBiWp3kbDHO8mcfBkaKfKnd1lWLvoGq98R4BIC7C0xEh/heDLv
         BuhInyJSNO6u2fCVSK1IaNxqD3qJPSg+upIfkVZcQAYupcp/+mmMtYtFqMrgGJVTgG+S
         RQWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV78u7cNrG1xjFmg3ZtRwQAlzkWQk2FLP8hiCC1HUpJai3Vtj2yUFJQKclAkzIwFsk4oAuUfMqp8V32SYg7Dldk6CoL
X-Gm-Message-State: AOJu0YxZmL7CT8t96qlJlmozxDZJWxeOqdHXjxdInAbIau9QXiDqAlw5
	A1BjPUOMLhxEKSDveyeg4w+6/N12eDxjJzxXSPo5yX/T4s33zAINpX9Ua2hUu2RbiRzy3DWU3vt
	NHZe41SAG5+tZDdzIAiEKP0pSWnDd4f+8ksrA
X-Google-Smtp-Source: AGHT+IGngt2o95wJJigCa5f9LfX3KcbLUScyf+85yhNWsgWvvy6rSbh+1u95J+el+DxcbjoPvJHC79K4gU36Iv3XydE=
X-Received: by 2002:a05:600c:5125:b0:419:fe44:2786 with SMTP id
 o37-20020a05600c512500b00419fe442786mr207453wms.6.1713879022974; Tue, 23 Apr
 2024 06:30:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com> <ZicA3732THkl-B1u@google.com>
In-Reply-To: <ZicA3732THkl-B1u@google.com>
From: Peter Gonda <pgonda@google.com>
Date: Tue, 23 Apr 2024 07:30:08 -0600
Message-ID: <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
To: Sean Christopherson <seanjc@google.com>
Cc: Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	David Rientjes <rientjes@google.com>, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 6:29=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +Tom, Mike, and Peter
>
> On Thu, Apr 18, 2024, Li RongQing wrote:
> > save_area of per-CPU svm_data are dominantly accessed from their
> > own local CPUs, so allocate them node-local for performance reason
> >
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 6 +++---
> >  arch/x86/kvm/svm/svm.c | 2 +-
> >  arch/x86/kvm/svm/svm.h | 6 +++++-
> >  3 files changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 61a7531..cce8ec7 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3179,13 +3179,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vc=
pu *vcpu, u8 vector)
> >       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
> >  }
> >
> > -struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> > +struct page *snp_safe_alloc_page_node(struct kvm_vcpu *vcpu, int node)
> >  {
> >       unsigned long pfn;
> >       struct page *p;
> >
> >       if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> > -             return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > +             return alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_=
ZERO, 0);
> >
> >       /*
> >        * Allocate an SNP-safe page to workaround the SNP erratum where
> > @@ -3196,7 +3196,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu =
*vcpu)
> >        * Allocate one extra page, choose a page which is not
> >        * 2MB-aligned, and free the other.
> >        */
> > -     p =3D alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> > +     p =3D alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
>
> This made me realize the existing code is buggy.  The allocation for the =
per-CPU
> save area shouldn't be accounted.
>
> Also, what's the point of taking @vcpu?  It's a nice enough flag to say "=
this
> should be accounted", but it's decidely odd.
>
> How about we fix both in a single series, and end up with this over 3-4 p=
atches?
> I.e. pass -1 where vcpu is non-NULL, and the current CPU for the save are=
a.

Looks good to me. Internally we already use GFP_KERNEL for these
allocations. But we had an issue with split_page() and memcg
accounting internally. Yosry submitted the following:

+  if (memcg_kmem_charge(p, GFP_KERNEL_ACCOUNT, 0)) {
+    __free_page(p);
+    return NULL;
+  }

Not sure if this is an issue with our kernel or if we should use
split_page_memcg() here? It was suggested internally but we didn't
want to backport it.

>
> struct page *snp_safe_alloc_page(int cpu)
> {
>         unsigned long pfn;
>         struct page *p;
>         gfp_t gpf;
>         int node;
>
>         if (cpu >=3D 0) {
>                 node =3D cpu_to_node(cpu);
>                 gfp =3D GFP_KERNEL;
>         } else {
>                 node =3D NUMA_NO_NODE;
>                 gfp =3D GFP_KERNEL_ACCOUNT
>         }
>         gfp |=3D __GFP_ZERO;
>
>         if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>                 return alloc_pages_node(node, gfp, 0);
>
>         /*
>          * Allocate an SNP-safe page to workaround the SNP erratum where
>          * the CPU will incorrectly signal an RMP violation #PF if a
>          * hugepage (2MB or 1GB) collides with the RMP entry of a
>          * 2MB-aligned VMCB, VMSA, or AVIC backing page.
>          *
>          * Allocate one extra page, choose a page which is not
>          * 2MB-aligned, and free the other.
>          */
>         p =3D alloc_pages_node(node, gfp, 1);
>         if (!p)
>                 return NULL;
>
>         split_page(p, 1);
>
>         pfn =3D page_to_pfn(p);
>         if (IS_ALIGNED(pfn, PTRS_PER_PMD))
>                 __free_page(p++);
>         else
>                 __free_page(p + 1);
>
>         return p;
> }
>

