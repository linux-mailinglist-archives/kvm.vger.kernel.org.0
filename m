Return-Path: <kvm+bounces-11604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2720878BCA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F2B41C20FA5
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6A210E6;
	Tue, 12 Mar 2024 00:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBcMzKgL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8422365
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 00:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710202088; cv=none; b=jAipRK63aFzF3RuHR8y98YgMEIaf0Qcpe+7S4NZqFNznQgk+eBDRNWt54g/XkwIkd7fom4JvE7JMkBw9x4BHb9Ll9sX+igSu5tz7cSUlSlAVZIJ8FV1z5f/yqU6KjroiSJ2njYOwEWq9ss0FkSGufnq01VKHViemfqhrXlOX2qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710202088; c=relaxed/simple;
	bh=l6rVoLL7b5GYnY86FxsMiWPpqEw2YPCNBuuoZ8f4T38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kUt9jiKPv7Gonkb+dTp62fv8rZ21HUILfyWKH40pipC72sh05ORBkV5eGaco9stmlT2VbIDyA3IdpGgunbBCzn/1b7XLFsYwlzFal4TrEuSP8XrqyGQGz7eakOxjUz/4kdit2hf9xbOVTOAH4+D8iWiQpKAKoZpVbWCC1DbxYQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NBcMzKgL; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60832a48684so74190377b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710202086; x=1710806886; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pum+V0ZuZEgl9/jYMpYphQnY8pqiA+YW9T5jbGt8uRw=;
        b=NBcMzKgLEfN0BungWxGhN6WGxnrtYOf4wVN2zMaDYZ8HpR7p/53fLBVvhCOF4FbBOC
         VuvfO4G+uE077eqJISDKMnTOwZHJKeYthhbFBSKnZLNtZSWh9NiEcNwQ20NkKdPocfDy
         N99HKEIyCNzU54XTJ0pd7Bx9vwH73VsnHfJsD+tfGoCxDne4YLKFSD9uLmm9ziu2y5pY
         KIDBSESjACFonf4khiHuNgsxh+sPE4ZBdYqkiMxR6rzMlfxeSyTh1ZDGH5MmoghD79pJ
         a/mKoFNWXYOH+kTpu8LZbUjkGeCUDFG/6hyFfQHAjXRq2t/14WTQh71dwJvqFj7woLF0
         XaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710202086; x=1710806886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pum+V0ZuZEgl9/jYMpYphQnY8pqiA+YW9T5jbGt8uRw=;
        b=PKd6ynf3wqzC3CIzwwZ6ZjhP1QyqRoBA+dxj0xZZgeehl90CA2EhoJUj/XVBPtwPLw
         r3+KXfV+EezxxaTz0vRf2vnp/+tAh4LJ6RPgm7LzJkPrFcJMH9o0LfG4iUCyugmRNsT2
         63Bi4MsJZsOR8xT2aLw7q83oplH08a8DANEvpa86ZF8oxsFvbltxheSmumwfZ0D20mbK
         UqrYzdM8z2khn2XTwZZCr80pZDjE+VsG39LOpzJh6huXN8xC/SG5wq2dtOTB5BrBcLf4
         dN2/Vx4ZfQjVKYbDGdHJIgjPUPh3ttSTyK1vgvCIkgtkpfn0i8XAJw0Z2DCzWBGu2Ofx
         F02Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlFGlZHGZ8gCPr8ISiBFteDnFUyW2QQS1u2GUnlh2Zn09k2DW2/l3ASQCjxkPLPL9X7a91tsAHGlMmtFa2psCwgIwo
X-Gm-Message-State: AOJu0Yzx6Uu409zkD7IxXpW9y7B4/T3BB1o/oPCvr8pSb/81lEJQ5L8v
	x3IpjO1Z50o667K723mSHsH1EypB9WLkYKMxDpt0dPgCPhXkLoNbABVEbXRbtFBGkQyemXxxw0i
	Jxw==
X-Google-Smtp-Source: AGHT+IEVKzIpLefkYwyffPzY5rPsN9c/eliMN4nhjFt7FymhL9wQsQdn682GY/SO83Yj7xm2vR5Ew7/BGnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4ad:b0:dcc:94b7:a7a3 with SMTP id
 r13-20020a05690204ad00b00dcc94b7a7a3mr418633ybs.12.1710202085872; Mon, 11 Mar
 2024 17:08:05 -0700 (PDT)
Date: Mon, 11 Mar 2024 17:08:04 -0700
In-Reply-To: <Ze6L/Tnrvs7eayqG@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-10-seanjc@google.com>
 <ZeqZ+BDTN5bIx0rm@yilunxu-OptiPlex-7050> <ZeufCK2Yj_8Bx7EV@google.com> <Ze6L/Tnrvs7eayqG@yilunxu-OptiPlex-7050>
Message-ID: <Ze-c5KHDmpz7M6eN@google.com>
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

On Mon, Mar 11, 2024, Xu Yilun wrote:
> On Fri, Mar 08, 2024 at 03:28:08PM -0800, Sean Christopherson wrote:
> > On Fri, Mar 08, 2024, Xu Yilun wrote:
> > > On Tue, Feb 27, 2024 at 06:41:40PM -0800, Sean Christopherson wrote:
> > > > @@ -4410,6 +4405,16 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > > >  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > > >  	smp_rmb();
> > > >  
> > > > +	/*
> > > > +	 * Check for a private vs. shared mismatch *after* taking a snapshot of
> > > > +	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
> > > > +	 * invalidation notifier.
> > > 
> > > I didn't see how mmu_invalidate_seq influences gfn attribute judgement.
> > > And there is no synchronization between the below check and
> > > kvm_vm_set_mem_attributes(), the gfn attribute could still be changing
> > > after the snapshot.
> > 
> > There is synchronization.  If kvm_vm_set_mem_attributes() changes the attributes,
> > and thus bumps mmu_invalidate_seq, after kvm_faultin_pfn() takes its snapshot,
> > then is_page_fault_stale() will detect that an invalidation related to the gfn
> > occured and resume the guest *without* installing a mapping in KVM's page tables.
> > 
> > I.e. KVM may read the old, stale gfn attributes, but it will never actually
> > expose the stale attirubtes to the guest.
> 
> That makes sense!  I was just thinking of the racing for below few lines,
> 
> 	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 		return -EFAULT;
> 	}
> 
> But the guarding is actually for the whole kvm_faultin_pfn(). It is the
> the same mechanism between getting old gfn attributes and getting old pfn.
> 
> I wonder if we could instead add some general comments at
> 
>    fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> 
> about the snapshot and is_page_fault_stale() thing.

Yeah, I'll add a comment.  The only reason not to add a comment is that, ideally,
the comment/documentation would live in common KVM code, not x86.  But this code
already has a few big comments about the mmu_notifier retry logic, one more
definitely won't hurt.

