Return-Path: <kvm+bounces-22713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0620E94236A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 01:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E4951F24CA3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 23:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9989F19412F;
	Tue, 30 Jul 2024 23:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fqryzt65"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1440218CC03
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 23:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382273; cv=none; b=SscPDS0CjOYI1bD98hRXueePXoTXU+ixS3ROzGweLA9wLCcuhfvoeSVNyI98txteAr0lpQCS3pUO9Z4h9dqlDpmIlefp5Hcj7W+oNZObDIAr6R6L+WAjTdRE4irdlmDtrKeQ4PdeukCVtAbYVJdKbpaNi26F7NjftN1A/AgFv6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382273; c=relaxed/simple;
	bh=QkGvdR+ItcZxMyQu3kSjm50qT6uU5ENMYoz0Fuoj754=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LcbP7imq5M0PQSHNlAfsetrgbjtTvPdREVpfcaih72cp3J4nw8Xs7jk6dw1ZV9qWafkgPueaBfkOUaq0LMSHTg/PGwJR/8HYYPh9BLlJb19cbT4ZYZPUGPb+MHRaYqeOihdg2K0xcBFiRY0G6t/OEKytYG8dPyaYntXQsxiRhGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fqryzt65; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66480c1a6b5so113833127b3.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 16:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722382270; x=1722987070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ay6wLs2JALdJRjG2Jl8mKWpqChoz9bwLuBE0bA+gW2Q=;
        b=Fqryzt65+I1Owmn+XIlFK3GxAmQ8tkwxb/2yA6w9iX3OuLgGY93CbiOsisLz7GvCLp
         qkJK48mcPb2Y4gb1PTXtEht1GJLP1FYEcx3NpeazxzXK5+JkCEUtXlap11mRCffgZr+I
         m1gQJxH37i1Lni2IeWqHjGBoEesRGQ1JKVaWRl0hRMAkA1Z55TxCKE4XXIWETfSb/4gG
         Y55WC6CP/oDrjKpka1MBbc1lRwNvU8OILU53rppcjLkMFjK+5qL1pQDzA1tx2Ht7BohF
         4n1wLJlT1yVKCkf0x0OL4JhWhxrm1xS6efm6fD2aNh7Il9DHoRSX0GIqtTuJlEAn8VGf
         Jh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722382270; x=1722987070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ay6wLs2JALdJRjG2Jl8mKWpqChoz9bwLuBE0bA+gW2Q=;
        b=ULcUweVVJ0JPXy4dJy397CZ9osrK1zoOzGGlWNt3vJ0Uw73BhACo3Y8oJ1zsrdLGPq
         eG46I2v2+UnIJtWHieHoA0h1SvMuYrtcV3b71F7tf+VBg5FnclL97964ALbYYVtKoYBX
         yYkL/l9ezjGkYYa3uFsiJtuaDBWgCgEWgdj6hdf5GSDVdVLq3CxVf/e7rqmaqD3STCf9
         ZmkskYITpe4AJ3d5pcGYnO2r8sD7WdwZtsoOggQ6ITUIWOpx9wiafi+T9VSP7kvLB2Ws
         DCM101WdGYY7oSE15j1Lz079RBouaj3w93srA07G3v8pmMQXAwQEDlrVb2fB9uCLVsZD
         ULcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGTOWTq3Bg18TIwKQIRx6dbzEUJlkVJcLVng3/bCzfosV0venYfn7MIYhowlrzkP09xKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFeoKEBZJ+ecx/fn+X2nw1ff7WVeZ80+5IKjn1NzrIectcjWZb
	WYB/hlv4Oyc1ugnRc5XvY72wajr2369RIhOHzfFMxrC7G3vFGcQ9ODum0mdNrCUo1Y8JqwZZOsT
	JCg==
X-Google-Smtp-Source: AGHT+IG2mF1GG8LrNAxvn4DKukVTRXcvlSZNShOVmgdijzgOOvZgMl6gWvwTJgbmd/3+mdcfqSeUDOejeB4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b04a:0:b0:62c:dce9:6238 with SMTP id
 00721157ae682-67a051ee096mr1032047b3.1.1722382270046; Tue, 30 Jul 2024
 16:31:10 -0700 (PDT)
Date: Tue, 30 Jul 2024 16:31:08 -0700
In-Reply-To: <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730155646.1687-1-will@kernel.org> <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
Message-ID: <Zql3vMnR86mMvX2w@google.com>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
From: Sean Christopherson <seanjc@google.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Michal Luczaj wrote:
> On 7/30/24 17:56, Will Deacon wrote:
> > If the xa_store() fails in kvm_vm_ioctl_create_vcpu() then we shouldn't
> > drop the reference to the 'struct kvm' because the vCPU fd has been
> > installed and will take care of the refcounting.
> > 
> > This was found by inspection, but forcing the xa_store() to fail
> > confirms the problem:
> > 
> >  | Unable to handle kernel paging request at virtual address ffff800080ecd960
> >  | Call trace:
> >  |  _raw_spin_lock_irq+0x2c/0x70
> >  |  kvm_irqfd_release+0x24/0xa0
> >  |  kvm_vm_release+0x1c/0x38
> >  |  __fput+0x88/0x2ec
> >  |  ____fput+0x10/0x1c
> >  |  task_work_run+0xb0/0xd4
> >  |  do_exit+0x210/0x854
> >  |  do_group_exit+0x70/0x98
> >  |  get_signal+0x6b0/0x73c
> >  |  do_signal+0xa4/0x11e8
> >  |  do_notify_resume+0x60/0x12c
> >  |  el0_svc+0x64/0x68
> >  |  el0t_64_sync_handler+0x84/0xfc
> >  |  el0t_64_sync+0x190/0x194
> >  | Code: b9000909 d503201f 2a1f03e1 52800028 (88e17c08)
> > 
> > Add a new label to the error path so that we can branch directly to the
> > xa_release() if the xa_store() fails.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Michal Luczaj <mhal@rbox.co>
> > Cc: Alexander Potapenko <glider@google.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  virt/kvm/kvm_main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d0788d0a72cc..b80dd8cead8c 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >  
> >  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> >  		r = -EINVAL;
> > -		goto kvm_put_xa_release;
> > +		goto err_xa_release;
> >  	}
> >  
> >  	/*
> > @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >  
> >  kvm_put_xa_release:
> >  	kvm_put_kvm_no_destroy(kvm);
> > +err_xa_release:
> >  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
> >  unlock_vcpu_destroy:
> >  	mutex_unlock(&kvm->lock);
> 
> My bad for neglecting the "impossible" path. Thanks for the fix.
> 
> I wonder if it's complete. If we really want to consider the possibility of
> this xa_store() failing, then keeping vCPU fd installed and calling
> kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.

Yeah, the vCPU is exposed to userspace, freeing its assets will just cause
different problems.  KVM_BUG_ON() will prevent _new_ vCPU ioctl() calls (and kick
running vCPUs out of the guest), but it doesn't interrupt other CPUs, e.g. if
userspace is being sneaking and has already invoked a vCPU ioctl(), KVM will hit
a use-after-free (several of them).

As Michal alluded to, it should be impossible for xa_store() to fail since KVM
pre-allocates/reserves memory.  Given that, deliberately leaking the vCPU seems
like the least awful "solution".

