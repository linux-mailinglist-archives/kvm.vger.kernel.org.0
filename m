Return-Path: <kvm+bounces-53945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FF9B1AB42
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 01:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64171170F40
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 23:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A62291864;
	Mon,  4 Aug 2025 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7EiZ6El"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E83238C08
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754349003; cv=none; b=AF/2rvCnR24mtkHIV5AgGqAQwEpIcYs/XQEpUuRRkPm6l9E1klgQxtsNcTR+iMVvRBZokXIVLcMleZUWPA+THjEmM9TDRjekNb9G9Ha+MrI4CY66/8bcSH5lGnxPBkLPia+iXNof1IpdOqwASRUnfseVGwgPSIm3MwIlo4f2pYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754349003; c=relaxed/simple;
	bh=jGEm0DtgPk8+RabZ/v6woIGn/2BhjebzCgIbNh+Ac80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ErSEe8HnI6bUMAaXm81JsucS32pwfnizkEsnM9VOTd5pOIUQG9+DdihYpTHWdVvsBHCtUcLGaOwj2BTf2MH7GPn6hAZEDvR5g9TZFdKNVkwh6VV4G7uQbEB6tZS7DyDwZHZkin3kEV/po9qI2naV4e3FB/YOA8jObAC+W089W04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X7EiZ6El; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3f71e509d6so6749946a12.0
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 16:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754349001; x=1754953801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tG0zFdwSMEPj6TjvMjIhSWrku59KtpikLJvWaNvieXY=;
        b=X7EiZ6Elq84ytvAMYbzXAelu/Uvw/oj6a7ydvZlyA2EqZc4Y58MfQ1XFQmZ+w9vrrd
         AZdSknweCxEO79fSpO0EoFlmEFQAYSCQhjoQFyh+tYr1jbxw4qHF7ejF40jgXKCo0lAH
         09OmkyQt8RHDP3t57HZ17t25t224yfdOIHULtkuECNsqg44pBW6sEYA7XPAUSwzz5FVO
         U7ulk5RGtcIIfdYnNXPkRH2hsk0ORyQUWLla1pdrB0HKMVKx7bT6IUTKwBmXHZp32+UF
         BtoQ9Ve7JvXu7pF6X6WgzkTcnG0vt0uzjgIVq69pf1zg3VPwmbX3Ow4RROtz+yVEYCfR
         PDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754349001; x=1754953801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tG0zFdwSMEPj6TjvMjIhSWrku59KtpikLJvWaNvieXY=;
        b=XKbel0qcOU+Zjd1cUeboNV92kr2rpyWcsb3xIlHBWjoOxw7d6+TIIEqhxE/ZNzdqOi
         21maAOtsyDnX5NZxooTc3/S5GJEKgo14L7BiUyOKX5q/A8hT31rfo00EUemGvBWgi8ty
         DBJfJACREDk3vXigunQ3v13+W7rYkbldBAOaO6hE/BdIq3E2K4Sp64gKHkM7JpMIKQ9J
         egDu25FhoqRdyo9E5oBDAEWrWCXOX6DRMr2J3XCJNMK5yBf/tEQI86KN+HKIDrh7pb+Y
         fCd5Yu/Loudc5jjTT55OzWTEVaEgB+UWB9/kRR1s4L+EtqxOTfaeK7vCditVsZMLfRy/
         daRg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ6N238qDkK3SCFkO2GqhOUujD+J4WThIZoEEoi9JvpOkgm25WN+/Ub+E66n0E4irFIFU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtbs0k3xPKWUMky4hh9jfwji6iIXiB/kR6hA20SZ1KHXm74rFO
	KngI8SZ7fbmUV/iSSQgoxqb7tEznT7aEL+/kgxrHDNBF4ShNUEbN+/m8o/AGkBW6rTWrRrUI2oj
	v0N3atg==
X-Google-Smtp-Source: AGHT+IE2NsYRZGLMA0DfVkuf5vaTZrSFR4fZkpJO3aIRBFjVMmkA+JR/oFWBMzx7rkrijiPT3c3wcqzhSlk=
X-Received: from pjyf7.prod.google.com ([2002:a17:90a:ec87:b0:31f:1707:80f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3886:b0:31e:f3b7:49d2
 with SMTP id 98e67ed59e1d1-3211611bdf3mr16662659a91.0.1754349000710; Mon, 04
 Aug 2025 16:10:00 -0700 (PDT)
Date: Mon, 4 Aug 2025 16:09:59 -0700
In-Reply-To: <87tt2nm6ie.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com> <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
 <87o6tttliq.fsf@redhat.com> <aHWjPSIdp5B-2UBl@google.com> <87tt2nm6ie.fsf@redhat.com>
Message-ID: <aJE9x_pjBVIdiEJN@google.com>
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB flushes
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	alanjiang@microsoft.com, chinang.ma@microsoft.com, 
	andrea.pellegrini@microsoft.com, Kevin Tian <kevin.tian@intel.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 04, 2025, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > It'll take more work than the below, e.g. to have VMX's construct_eptp() pull the
> > level and A/D bits from kvm_mmu_page (vendor code can get at the kvm_mmu_page with
> > root_to_sp()), but for the core concept/skeleton, I think this is it?
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6e838cb6c9e1..298130445182 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3839,6 +3839,37 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
> >  
> > +struct kvm_tlb_flush_root {
> > +       struct kvm *kvm;
> > +       hpa_t root;
> > +};
> > +
> > +static void kvm_flush_tlb_root(void *__data)
> > +{
> > +       struct kvm_tlb_flush_root *data = __data;
> > +
> > +       kvm_x86_call(flush_tlb_root)(data->kvm, data->root);
> > +}
> > +
> > +void kvm_mmu_flush_all_tlbs_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +       struct kvm_tlb_flush_root data = {
> > +               .kvm = kvm,
> > +               .root = __pa(root->spt),
> > +       };
> > +
> > +       /*
> > +        * Flush any TLB entries for the new root, the provenance of the root
> > +        * is unknown.  Even if KVM ensures there are no stale TLB entries
> > +        * for a freed root, in theory another hypervisor could have left
> > +        * stale entries.  Flushing on alloc also allows KVM to skip the TLB
> > +        * flush when freeing a root (see kvm_tdp_mmu_put_root()), and flushing
> > +        * TLBs on all CPUs allows KVM to elide TLB flushes when a vCPU is
> > +        * migrated to a different pCPU.
> > +        */
> > +       on_each_cpu(kvm_flush_tlb_root, &data, 1);
> 
> Would it make sense to complement this with e.g. a CPU mask tracking all
> the pCPUs where the VM has ever been seen running (+ a flush when a new
> one is added to it)?
> 
> I'm worried about the potential performance impact for a case when a
> huge host is running a lot of small VMs in 'partitioning' mode
> (i.e. when all vCPUs are pinned). Additionally, this may have a negative
> impact on RT use-cases where each unnecessary interruption can be seen
> problematic. 

Oof, right.  And it's not even a VM-to-VM noisy neighbor problem, e.g. a few
vCPUs using nested TDP could generate a lot of noist IRQs through a VM.  Hrm.

So I think the basic idea is so flawed/garbage that even enhancing it with per-VM
pCPU tracking wouldn't work.  I do think you've got the right idea with a pCPU mask
though, but instead of using a mask to scope IPIs, use it to elide TLB flushes.

With the TDP MMU, KVM can have at most 6 non-nested roots active at any given time:
SMM vs. non-SMM, 4-level vs. 5-level, L1 vs. L2.  Allocating a cpumask for each
TDP MMU root seems reasonable.  Then on task migration, instead of doing a global
INVEPT, only INVEPT the current and prev_roots (because getting a new root will
trigger a flush in kvm_mmu_load()), and skip INVEPT on TDP MMU roots if the pCPU
has already done a flush for the root.

Or we could do the optimized tracking for all roots.  x86 supports at most 8192
CPUs, which means 1KiB per root.  That doesn't seem at all painful given that
each shadow pages consumes 4KiB...

