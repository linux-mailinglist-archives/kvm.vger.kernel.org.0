Return-Path: <kvm+bounces-38889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 944B7A3FFEC
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57A607ADC2E
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D800253320;
	Fri, 21 Feb 2025 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="quYtZe/2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167D11E98EF
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 19:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167028; cv=none; b=RzL9XnyZqiNEBxu8OXfIxh0m06E556xdRyU1Ce7fXzg8ivanf40+DGO/dK9iYFB/yTFyIuz2Km6NQrmkrHXKk9m86VjyLT4L4Mv8SnbSH7bV4sfseQT1VjA/PNd9rbhPzwBw2tgXFfkmH4I/CxXxwBvOXYz3CqmZVev1ywzWFYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167028; c=relaxed/simple;
	bh=Y3Yyk8b/Cp0hTYaK6EJV+jpxqEoGOW6JM0KIc8TDCkg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uxmGsJ/jUX+GT6SEXD7AWDcv880LQOUYy/30WD9nJkIdPavNH9W5i9YcCf1ytIUPno/bw47/ZdUZ77A9G8YpbQuZxvFCa5wYf2cWtXVCaYrZNSj1np+naBWCitjIc3DSDzMv4VV1W8cMSetjnc/AvTdzk8cYfQZ5q5Vfrxgfbzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=quYtZe/2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1cb0c2cbso8057423a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 11:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740167026; x=1740771826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hQXhIMGXITd1rE+W1Hd1jpvnOAjlNs+uBBSQvISYRG4=;
        b=quYtZe/2pJvvL6QPrqxsFZTQIs4919f5gtqUNt4Ig2rm4bcryFg0CochzB7Dwb/P/g
         1Dgwb/kVgg2MciCRIrbQdLQFtPPGcH0Exnvcd9aQ4iMPkdbJMxqiVdAtKz/3OA7cu5js
         kde6HfSLPo2f77XB2XQe7nI2LEDA1qiQDTYhHLumvvTySgQTYcfxw6dAkTgv1aFbVSTZ
         9L9mjrXyfP5ELBTVGb9ISNW06k5NvWZjcZyjN/Tb0OzoVGPZqyOWWZOItQ51paZTFq29
         zZyCn2wrjQN7JdbDF/+IHmTVWYCd2k9Ve8ewzKFnxakTIQa2uxTiHrHpGHJp8L4itS+K
         8+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740167026; x=1740771826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQXhIMGXITd1rE+W1Hd1jpvnOAjlNs+uBBSQvISYRG4=;
        b=hVhHQYW92LVsbpoS1csq9p5N9on6UJydID0j7Bpa0IGLRQjGpRLbSPPglgzP0TDv6l
         DRQi95TeV92HSHecGRGUqQD5WS3J/skCe5nMppuQzJR1GErCddo/5e1tYo8ylg9tGhzT
         RQ8+vvPGFaRkeXco9ChAapaTS6ieCJHHZSyl8kIQorJVwlf6sYCF9iNtcmw0RL134s9z
         Ss24IOPk4ELHOwXsVvgfvRTqxcv0HrfWmTtIx+SX+M4qJYMXJQ0KLd4D4skueo0tdqtZ
         yVb5fA3vVp2Hf3HgmeuR+hKSFLYw8g8GxhqslXwqvD+5G8Vp7wCY0A/SUDtOR442U78l
         c5wA==
X-Forwarded-Encrypted: i=1; AJvYcCUwRJz5Xb/AhfAsHhCJx8EjLez6qv+FlnWkXYfJn6MB4mPZy8FybEN176CEznd0nYwlXS8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0ye5xJ+WBy5LiOCylX1U95e4ZrzGYDi8+qUSYcRlC9COmu3yg
	KBwKTC4qmqIZWMeU7445ZEnYVFSRlr2/7rCRCZvpQZhjxIsGkxFABn5JOEsk9lODhpSXbyUSSsI
	ehQ==
X-Google-Smtp-Source: AGHT+IG1PT4kPwyWN06txt88MVC++MaYs1d8aNclywXcgh7C2ddpU7iPy0Nkhque7F+Z3hd2xBEyOnkGgbc=
X-Received: from pjur15.prod.google.com ([2002:a17:90a:d40f:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2590:b0:2ee:df70:1ff3
 with SMTP id 98e67ed59e1d1-2fce75e1b18mr8826198a91.0.1740167026450; Fri, 21
 Feb 2025 11:43:46 -0800 (PST)
Date: Fri, 21 Feb 2025 11:43:45 -0800
In-Reply-To: <Z7hdqCqOLJWcR71K@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250220170604.2279312-1-pbonzini@redhat.com> <20250220170604.2279312-21-pbonzini@redhat.com>
 <Z7fO9gqzgaETeMYB@google.com> <Z7hdqCqOLJWcR71K@yzhao56-desk.sh.intel.com>
Message-ID: <Z7jXcelD0MAk7odP@google.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Tony Lindgren <tony.lindgren@linux.intel.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 21, 2025, Yan Zhao wrote:
> On Thu, Feb 20, 2025 at 04:55:18PM -0800, Sean Christopherson wrote:
> > TL;DR: Please don't merge this patch to kvm/next or kvm/queue.

...

> > Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was called")
> > papered over an AVIC case, but there are issues, e.g. with the MSR filters[2],
> > and the NULL pointer deref that's blocking the aforementioned fix is a nVMX access
> > to the PIC.
> > 
> > I haven't fully tested destroying vCPUs before calling vm_destroy(), but I can't
> > see anything in vmx_vm_destroy() or svm_vm_destroy() that expects to run while
> > vCPUs are still alive.  If anything, it's opposite, e.g. freeing VMX's IPIv PID
> > table before vCPUs are destroyed is blatantly unsafe.
> Is it possible to simply move the code like freeing PID table from
> vmx_vm_destroy() to static_call_cond(kvm_x86_vm_free)(kvm) ?

That would fix the potential PID table problem, but not the other issues with
freeing VM state before destroying vCPUs.

> > The good news is, I think it'll lead to a better approach (and naming).  KVM already
> > frees MMU state before vCPU state, because while MMUs are largely VM-scoped, all
> > of the common MMU state needs to be freed before any one vCPU is freed.
> > 
> > And so my plan is to carved out a kvm_destroy_mmus() helper, which can then call
> > the TDX hook to release/reclaim the HKID, which I assume needs to be done after
> > KVM's general MMU destruction, but before vCPUs are freed.
> > 
> > I'll make sure to Cc y'all on the series (typing and testing furiously to try and
> > get it out asap).  But to try and avoid posting code that's not usable for TDX,
> > will this work?
> > 
> > static void kvm_destroy_mmus(struct kvm *kvm)
> > {
> > 	struct kvm_vcpu *vcpu;
> > 	unsigned long i;
> > 
> > 	if (current->mm == kvm->mm) {
> > 		/*
> > 		 * Free memory regions allocated on behalf of userspace,
> > 		 * unless the memory map has changed due to process exit
> > 		 * or fd copying.
> > 		 */
> > 		mutex_lock(&kvm->slots_lock);
> > 		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> > 					0, 0);
> > 		__x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
> > 					0, 0);
> > 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
> > 		mutex_unlock(&kvm->slots_lock);
> > 	}
> > 
> > 	kvm_for_each_vcpu(i, vcpu, kvm) {
> > 		kvm_clear_async_pf_completion_queue(vcpu);
> > 		kvm_unload_vcpu_mmu(vcpu);
> > 	}
> > 
> > 	kvm_x86_call(mmu_destroy)(kvm);
> I suppose this will hook tdx_mmu_release_hkid() ?

Please see my follow-up idea[1] to hook into kvm_arch_pre_destroy_vm().  Turns
out there isn't a hard requirement to unload MMUs prior to destroying vCPUs (at
least, not AFAICT).

[1] https://lore.kernel.org/all/Z7fSIMABm4jp5ADA@google.com

