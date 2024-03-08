Return-Path: <kvm+bounces-11417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E426B876DDF
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 00:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D44F1C21428
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297B93F9F8;
	Fri,  8 Mar 2024 23:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WRAxvtG5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293353BBC7
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 23:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709940492; cv=none; b=gCLcZc4x0zOkg41BrX3zP2b7oq9VOAtqWs2J6c+cSOiilj/akE3xses5ljD3uODjh3P40z9FBciXPipuAhotLUNZzrm3/2QYZGWtFwBg2Y3ZWNt6VpK4uF4buL0oCHaRYNV4iYRDZ44wrBUO8pD1htyfwrp8+TU0OM5jOcnL9b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709940492; c=relaxed/simple;
	bh=BpN4iQW4PFrq3WVtA7bWTxphTlwS/fKO8mFIPGOtpZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JPySl+1lIOZmgHXvET3yCt9CNFtWhON9jWdt/d4AIKoKHrg4s8AXvmYAcndPqrV1e2OXEBr9nqsWlsmmYzjIXraWLFhy0ZNcxgRVpGuL4e6aMZMzbX+mOOYSfYjpKOXDGaYFMFsPjk/qQ+N6k3h4qf+2cdNl1OGQzwml8RB7zZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WRAxvtG5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e5d7659f7bso1078452b3a.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 15:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709940489; x=1710545289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N25dHtdFBFZm2u6EyvcAjsvLHySdv26qbRgS6+X49N0=;
        b=WRAxvtG5vRvZT1YNgSI3niXFlBqKbkMll4cCmp0t2El7oTO7DAnbQPbVBh32wrJUSe
         cv9yJIe7ue5azDN59RnFZjVgj5USUN66eJgB+2HNRyjl1nbVaqMWAEHjJH4AiSKxBvXW
         EneuvUgimHyFAO4GERAM4m9qku9haemxByAN/taS6tgkzVX+sscMoTIzkxZO/7ax7C02
         CclO62pZPcPddmFvlJdaCtqZ+PVmVCZTMEszjPwwj++mZ1ABTQ98C8oPezyAE+BpxAXN
         uRvN8UxwpmpqSZQo4PqOPTRwd8ramGkQdzmS234re6X+XsxGK+6yIGYjwtj5ap17wOXk
         UuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709940489; x=1710545289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N25dHtdFBFZm2u6EyvcAjsvLHySdv26qbRgS6+X49N0=;
        b=mE3tl1Ea71UV94xCGFOukBPxDwIlUMDKZsjeGTW9t9gEQVd2UhD7YN90Lz5Yml2p1r
         Kklj4hPOlg13vU9mdC/flqhUemxzMMLAItV6OP6uKQslPzk0fD03/6cKGVSc7oh+r/Jh
         g24MGS8cBAe5EZN34BKeMvYpyQiqNjDXB381J68GwjJDnawFCpxDAOeotn69hG/IpL3G
         9L4WcM2xJ8G9Nwa94v1Su6Qa//FvMjAqSKRQBb2gROSNoMtsG3zNccfoyBVJQpgJCjIS
         ynz3efY2WbEqg5CDGBP47vqkXFpFysb32DxM/k6n16U7ulUz+pMrkv9492z0wPUTgzxc
         1xmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWG+vgYS/09gHdTUE/hDqBXjpcIMbYe7+OJwe7fSlSUOYt9kJhRkZALDV/rga2VC9+yf0t7D6dc/QXLoyJ69a8wGYX+
X-Gm-Message-State: AOJu0YybjbzAZ0G77b4hu/QU0y0W1lxYYrrjLNj+M5YjHcwQ8tH7OHjq
	d+H+hAdGTB6r31qyypxj3b1p4ptpFlt0Ep03QFEL5HQ1MCJotLE2RU0AzjVOy3CmPuiFUW2RAFX
	9gg==
X-Google-Smtp-Source: AGHT+IGN3zZ+AWtJsEXlh5PO0OTuMsdAAMR54BndbvnDsWJGS/ngLorn4ve0GCie0y+F/f1QDNXI6IGNe7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1817:b0:6e6:508e:395c with SMTP id
 y23-20020a056a00181700b006e6508e395cmr23698pfa.3.1709940489438; Fri, 08 Mar
 2024 15:28:09 -0800 (PST)
Date: Fri, 8 Mar 2024 15:28:08 -0800
In-Reply-To: <ZeqZ+BDTN5bIx0rm@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-10-seanjc@google.com>
 <ZeqZ+BDTN5bIx0rm@yilunxu-OptiPlex-7050>
Message-ID: <ZeufCK2Yj_8Bx7EV@google.com>
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 08, 2024, Xu Yilun wrote:
> On Tue, Feb 27, 2024 at 06:41:40PM -0800, Sean Christopherson wrote:
> > Prioritize private vs. shared gfn attribute checks above slot validity
> > checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> > userspace if there is no memslot, but emulate accesses to the APIC access
> > page even if the attributes mismatch.
> > 
> > Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
> > Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> > Cc: Chao Peng <chao.p.peng@linux.intel.com>
> > Cc: Fuad Tabba <tabba@google.com>
> > Cc: Michael Roth <michael.roth@amd.com>
> > Cc: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 9206cfa58feb..58c5ae8be66c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4365,11 +4365,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  			return RET_PF_EMULATE;
> >  	}
> >  
> > -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> > -		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > -		return -EFAULT;
> > -	}
> > -
> >  	if (fault->is_private)
> >  		return kvm_faultin_pfn_private(vcpu, fault);
> >  
> > @@ -4410,6 +4405,16 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> >  	smp_rmb();
> >  
> > +	/*
> > +	 * Check for a private vs. shared mismatch *after* taking a snapshot of
> > +	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
> > +	 * invalidation notifier.
> 
> I didn't see how mmu_invalidate_seq influences gfn attribute judgement.
> And there is no synchronization between the below check and
> kvm_vm_set_mem_attributes(), the gfn attribute could still be changing
> after the snapshot.

There is synchronization.  If kvm_vm_set_mem_attributes() changes the attributes,
and thus bumps mmu_invalidate_seq, after kvm_faultin_pfn() takes its snapshot,
then is_page_fault_stale() will detect that an invalidation related to the gfn
occured and resume the guest *without* installing a mapping in KVM's page tables.

I.e. KVM may read the old, stale gfn attributes, but it will never actually
expose the stale attirubtes to the guest.

