Return-Path: <kvm+bounces-47881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9591AC69D6
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 658F43B3594
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 12:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A79D28641F;
	Wed, 28 May 2025 12:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfDn8l2h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416D22110
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748436866; cv=none; b=tlOTbZXkoJcIeDUyvZKjAkzWlYgzwgpW5vbzoxPf2vVLx0U4CzJnl7FdA9gBUO/usQjEG+wzv4fow66FElDmpgSnFErPYvoO46TjvMoavUqaWF7awI70nnxQ3HtFzgYb4Z0mDUrIQLJPcflg9MoVQzeKKg+KvJgw5r2RlopYX74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748436866; c=relaxed/simple;
	bh=4kzUi/76sU4TOqttKuHGINwdxexMyc5EKBLODsQjbIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d19w4LUtWa+DsTCJ+egS/WTbNTSJWo0H+/kqyNkUED0tyrcfKIzAI2i5r2H5cPCKJ7IntnmAa67uTum9SpZ4jrf8xdwTOlvrHqk9N1vu1U+c6TgUuyegt3DgIWHtjXALBRZ+EOVUpBP3EgXzB5AfKNCGVQch78b3AQuU27sTBnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfDn8l2h; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310a0668968so4159118a91.0
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 05:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748436864; x=1749041664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xuuvC7M6sC9txYVcxiKR7Nz7uk/ZLoX9CRoOMl5AG9g=;
        b=SfDn8l2hz+9fZu0Gd0vx2BgA0Dw904zl0x1+/FLzUrd9wBxGOhpRr3JCZkN02wyY/N
         gIRkJLJ09jR8MSpCPZY1ELkZu+rlZ5UkUNAJ1ujBianemAoDJ4yYynTl75gXWst+lDQl
         2E7cYi7AmAwdxyj7kMdvEudVBpeZ0qvGJnlPyx0vMSSdeyHRW4hgAS5sznrPiFOzUekS
         GfuLStDxAKzQPkIlCaYER05LYGgBpVQW+qMYcPT8sGydr9tOn/KShx2uc6QqK/xAAIsA
         rZDGOZzxsMi7tYAuD3WxoKNXcb0PqBlqEWn56n/KrURGIl00xz8K0++Uzh1kRcLPLtht
         XccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748436864; x=1749041664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xuuvC7M6sC9txYVcxiKR7Nz7uk/ZLoX9CRoOMl5AG9g=;
        b=g20CbKd/RejrsSIvKn0NfCKnjMQKvlygAkoIFYBco284Mzzp7VKpr5Roe4wZF/TwY5
         7+YVDqqDfMOVRnjbiEYo+zEsB0kfBYOCgNrJ0BXaRDnlwYunafEkkMoIz8DLbhfyKJIO
         qcWRzpS3HyGshfyqHjl9gEbLpP3TbkHlulOgo9zpXXRRPYpWfoRGzBJu9kTp3N1wezWv
         TEas1d4s9UsoKgjtGgi/xCHeLnz2qqU8R2BJX43n4AJsBsSDHeOkZanSSX9govCxVxUG
         l94wBSpb0uxE8nV7oi/Xn0j9eftYSBLpmRXo7+sqLI9zHqXMMRJPB9WCOd6mO3Awwylt
         CJyA==
X-Forwarded-Encrypted: i=1; AJvYcCUNWVqtdiz+OFc+U8tTNnKWJ+aEr50JnK+WhbFB8Tjd8gFl1lV1E/z8LA51LD1rToWmUMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwViyrMCMmP0QTCtRQu14Sl/fWL1KUvrtT4m9C+PECemoJI+xAi
	/tZkrZpZwnyj9aN76HrEoDrRm5Mgq9Js3y8KqRN1+kDjmHLyWFdCQiFTdCB1RLMoSWN+J1nv7Qv
	ijucPHw==
X-Google-Smtp-Source: AGHT+IHklk6ygB6BrAMAW+vre57cickd20wXmOPZTFQC5U6g6cHQDuc5vbvNaOVhN+qmRiCUV+DfgdMkufQ=
X-Received: from pjuj14.prod.google.com ([2002:a17:90a:d00e:b0:311:4201:4021])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3911:b0:311:f30b:c18
 with SMTP id 98e67ed59e1d1-311f30b0ff9mr2383545a91.4.1748436864587; Wed, 28
 May 2025 05:54:24 -0700 (PDT)
Date: Wed, 28 May 2025 05:54:22 -0700
In-Reply-To: <7cc5cd92-1854-4e0e-93b7-e4eee5991334@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com> <20250523001138.3182794-3-seanjc@google.com>
 <7cc5cd92-1854-4e0e-93b7-e4eee5991334@intel.com>
Message-ID: <aDcHfuAbPMrhI9As@google.com>
Subject: Re: [PATCH v4 2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 28, 2025, Xiaoyao Li wrote:
> On 5/23/2025 8:11 AM, Sean Christopherson wrote:
> > Dynamically allocate the (massive) array of hashed lists used to track
> > shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
> > all on its own, and is *exactly* an order-3 allocation.  Dynamically
> > allocating the array will allow allocating "struct kvm" using kvmalloc(),
> > and will also allow deferring allocation of the array until it's actually
> > needed, i.e. until the first shadow root is allocated.
> > 
> > Opportunistically use kvmalloc() for the hashed lists, as an order-3
> > allocation is (stating the obvious) less likely to fail than an order-4
> > allocation, and the overhead of vmalloc() is undesirable given that the
> > size of the allocation is fixed.
> > 
> > Cc: Vipin Sharma <vipinsh@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  4 ++--
> >   arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++++++++++++++-
> >   arch/x86/kvm/x86.c              |  5 ++++-
> >   3 files changed, 28 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 330cdcbed1a6..9667d6b929ee 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1343,7 +1343,7 @@ struct kvm_arch {
> >   	bool has_private_mem;
> >   	bool has_protected_state;
> >   	bool pre_fault_allowed;
> > -	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> > +	struct hlist_head *mmu_page_hash;
> >   	struct list_head active_mmu_pages;
> >   	/*
> >   	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
> > @@ -2006,7 +2006,7 @@ void kvm_mmu_vendor_module_exit(void);
> >   void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
> >   int kvm_mmu_create(struct kvm_vcpu *vcpu);
> > -void kvm_mmu_init_vm(struct kvm *kvm);
> > +int kvm_mmu_init_vm(struct kvm *kvm);
> >   void kvm_mmu_uninit_vm(struct kvm *kvm);
> >   void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index cbc84c6abc2e..41da2cb1e3f1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3882,6 +3882,18 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >   	return r;
> >   }
> > +static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
> > +{
> > +	typeof(kvm->arch.mmu_page_hash) h;
> 
> Out of curiousity, it is uncommon in KVM to use typeof() given that we know
> what the type actually is. Is there some specific reason?

I'm pretty sure it's a leftover from various experiments.  IIRC, I was trying to
do something odd and was having a hard time getting the type right :-)

I'll drop the typeof() in favor of "struct hlist_head *", using typeof here isn't
justified and IMO makes the code a bit harder to read.

