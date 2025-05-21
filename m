Return-Path: <kvm+bounces-47260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79347ABF279
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 13:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3246A7B39E0
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFBB2620EE;
	Wed, 21 May 2025 11:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4JBxJzie"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107FF2609DB
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825876; cv=none; b=JYD5KBbTbXX9X5JONJaX/1Nrk5V9quMoN+gY+iL/8C17bbOy0J53eUFKFGx77LFCva57tMoIs9MO3Sa3hyKCMJXklmaaeYwPArgJc6H4ztpZQTeeUzcAjskGYKoLxHfGJUZ9+TzAbyqO2p10HGUkL9UGXAHPNPjrYdNCzUGVyaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825876; c=relaxed/simple;
	bh=tQ/q7iXtF5UPGh8+ohOv6KaZ9+fEVRStSIj96suCIB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R9DaHsV9NIiPbAT90sBbmYGOqvrUO0GbSVIBvfX8JtCFt716h7kbupG1RXR0AYV/ZrBGzeBzXXl6P0brAxfgqt/uXC8TTZniWCU0xrI/470AV3cOn66wHJux1viOKc7idxUy/GthsRBBmbiP0T55CNeXPE2WNstARtvjhIAwmTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4JBxJzie; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-47e9fea29easo1646811cf.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 04:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747825874; x=1748430674; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ctqvgl2a53wbdaZxWTIiQHG1DssGpGTbCqmvno6TQ2s=;
        b=4JBxJzieXV4M+/XM1CzLtAPCSME2CcMGJZsxWzk2sHqB7d6VuoNX764w3qez8pln27
         3atpkGykCF03eq88vqbRkPvZL35ytjfSJuJpJ9kjm5Q2d4J1zQYiBLEffXUtY5MK+TkW
         fXXOLaVKkmLz5l1Ixaxh1WDwfBEFNKnntHMu0VXrP7QJr8TxO7QqmY1N1ftkqilWBUyQ
         7cehPPOnlwd/4/daATpNIWG9Rh4WNNc4Frj4gmKvjgk9GwNrVtq30Ftjgaxfg7c+s5T3
         FBqIIL9IhJIpeZf+oTy2lvbhd8BvoL3OlbgT3oAsjEhG6iXg4rqjlj8fsbobdDRtgB94
         LCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747825874; x=1748430674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ctqvgl2a53wbdaZxWTIiQHG1DssGpGTbCqmvno6TQ2s=;
        b=tj20RRbJXAsZFchzurPisHa+JvK52i375o+3jYVlWnb2PE2xNN6BxrbF5fwTPFtzhh
         qw+fSZyKsdQOLUCJQuP1WDKJ3NClusIDrAbWpi9bJJpsdJxqwEQ5KIrLDm9z0rpySijP
         7yPaLDDiuWM+DZw75MIi8xV+gFWPxAcSfgx3YBawZ6P6swKEeRGRWRqqKVnk4u2wHdsD
         xzdcIDHtr8ux0iumIF6Yye1GgwXTKWBFffEopQBL8SRtFnYhwte/paL9vP+Q6XCR7O5f
         ATtRPoHib6zBHVs4ezJtHafWMVptQ7u9pZ0JgXhulD790767Q0EU+SpV8rfq2oadM6x/
         ZFQA==
X-Gm-Message-State: AOJu0YzGWlbOdCxHUPB8TQzOwaySYDyVIiuNhMMqHpGvc3/6/Ydb4yet
	iHzjWSkwOUGhzmMTxo5NmVH5Lg7Fwscg4KOU+FILLlMr4VjA9NZUZUrmZ7xlq+ZrJ+D8K61AOpr
	2BPKxflH1Vp77y38BCfygpp+RcvgvFLju+lCOgkrZ
X-Gm-Gg: ASbGncupJoBDfk5DOla/m11JIdDp/d+Fv7cAFG0BHBx3a+THPNlW/dl+HMZDc/S/6f+
	pu01TlOgrsxDmrvBj2PtOFfGfG54q98EJEVSDtwhLgwFRhiRKgFjXTgEak/JQ8bP3mdORTB7bIP
	9w+LNEHpdndf2nviztAtRCOZ/x83qq8Xy/a8h2Ian43B9h6aGcrssNfxqJ9Iaf6u9TEl1mHs0x
X-Google-Smtp-Source: AGHT+IG9JRLddwi7FWo7PGi8OFQqYZvIkWzFiMZ2eJyY+7GX2T8rNZIySJy/QKfkLbtNb5b9H6nducMJim1V/SX7ZEE=
X-Received: by 2002:a05:622a:13cd:b0:47b:3a5:8380 with SMTP id
 d75a77b69052e-49595c5d9f6mr15353851cf.28.1747825873334; Wed, 21 May 2025
 04:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-14-tabba@google.com>
 <8d6eb79a-a68d-4116-bb42-ed18b0a0d37d@redhat.com>
In-Reply-To: <8d6eb79a-a68d-4116-bb42-ed18b0a0d37d@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 May 2025 12:10:36 +0100
X-Gm-Features: AX0GCFsGsg3FxndHSZGJf7TgUxTEca7xqtxeGk7gRA7wW8yw3Stt3ibiefTaF9w
Message-ID: <CA+EHjTyPp0OzbvvwG6AB+GJ9nSXroeJ6M2EnmERqvQ+sO+4E+Q@mail.gmail.com>
Subject: Re: [PATCH v9 13/17] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Wed, 21 May 2025 at 09:04, David Hildenbrand <david@redhat.com> wrote:
>
> On 13.05.25 18:34, Fuad Tabba wrote:
> > Add arm64 support for handling guest page faults on guest_memfd
> > backed memslots.
> >
> > For now, the fault granule is restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
>
> [...]
>
> > +     if (!is_gmem) {
>
> Should we add a comment somewhere, stating that we don't support VMs
> with private memory, so if we have a gmem, all faults are routed through
> that?

I guess this is related to the other thread we had. This would handle
private memory correctly. It's just that for arm64 as it is, having
private memory isn't that useful.

There might be a use-case where a user would create a
guest_memfd-backed slot that supports private memory, and one that
doesn't, which only the guest would use. I doubt that that's actually
useful, but it would work and behave as expected.

Cheers,
/fuad

> > +             mmap_read_lock(current->mm);
> > +             vma = vma_lookup(current->mm, hva);
> > +             if (unlikely(!vma)) {
> > +                     kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> > +                     mmap_read_unlock(current->mm);
> > +                     return -EFAULT;
> > +             }
> > +
> > +             vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> > +             mte_allowed = kvm_vma_mte_allowed(vma);
>
> --
> Cheers,
>
> David / dhildenb
>

