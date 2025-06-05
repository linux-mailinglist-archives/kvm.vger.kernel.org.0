Return-Path: <kvm+bounces-48616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A038ACF9D5
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06732166E9D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B09E27FD42;
	Thu,  5 Jun 2025 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePkBBUo6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386E207A0C
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 22:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749163673; cv=none; b=UZoBtTJu1Y5s75cV3RBH4gBsvHHy/D1t93RTqSHNRIn7XcpMt9X3ZXf3mjYXuazjPNGYSLdn3EGHm0Rc7fLH6LVoB+hdUMYIEcKzjXiXWwkAjKM601O2lY7AsWfRnAxP78ijKPdrfVLTbQSir1WkSv8acpU0fjdYOiTfVdyNZAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749163673; c=relaxed/simple;
	bh=cvzViqUXMRfsW6Wx1QCAZBB63ewQpSvnWyRr9Mqmat8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LEDw+BxML80wWHoQGyxQbAnQ+rrU0b/LyJJKK0TMt86QtROcPANnF7eAMb+YX9dB7fDrIEVuXaEWn3VHNpE70+s0FdZvtyd0lyYRhXmYinx3qkmPWtfIDArnnEe2BCJccLKVYM2hLnafY0HNEeUtXkH5K55KhIZuAkUWj998j48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePkBBUo6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747fa83d81dso1315875b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 15:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749163671; x=1749768471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQa4RZKS4Qz47fRGsfEi2gcQhtmL0q5YIoUaqY8Vz5w=;
        b=ePkBBUo6Vl4Swn0w8LSMLDkpWCe0AJWGSc1qqJYNQvVPrzuBeb7IFWhBdU6KL3athJ
         5LHYqFjDdsiy0XFyWyiPUeZqqWhxB90BaWlymq6D9EnZGxZVUlspAsTs6lPETVuqP9A+
         +n7dEDQOsFRxI47MjwDCPWZ1N+2ncELoWbYzcSLrY9P04wjD4wx/QF+VuB0S3JGI3H9T
         DdShmknDW6W/s9uJqOfpXKEk/Iq/Fvhwje9yfMXCGSee26zkNucwL25T06u/pt910UVV
         u181rBJhxR3Vl8/RrBdrcq4PmOpFjtupYJN+9+9k4XcT8Lt5CPzKOBNug6Ow8R9eNFMg
         5I7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749163671; x=1749768471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQa4RZKS4Qz47fRGsfEi2gcQhtmL0q5YIoUaqY8Vz5w=;
        b=sUJO2IhKWtmN+yKafBt85mpKShk2rEzxvMB6j5eU27T/uwALtaEeAC3+XlsUq192ZC
         WWYcVAeEh8PTMYE/igeyE5xkSeLSNAKV5klGSd/5N3UsxM+mOWUmTaCpw9d6ZddtVIIE
         KK7/jVrDgslw8p6WgiIGeDlCxlh9ZMAeWCCT44yRIiPAm7NjdfzIWQOOt420sNhEaWT4
         oUqyt6GelnHVNOp8EynU77/3WAZqSPY5j5pGS3gRVf65ElRRCklC2hyiawEIwotlts4A
         OrZAHiKkphQrdqYwT+O6H6/5XKGkAqoL2dCL/zoJbBCd4AC52mLeFhcc7Mumz4BIgwg0
         uyUw==
X-Forwarded-Encrypted: i=1; AJvYcCVHoUdv9Qlwr/o88OkL6erwwA+3Q1eNJknZJ2lmOKQ+Sr3EWu3Kx/XYp9gksdnAvhnLn0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqbWdHAj8qNw8jt6YiAwQoV+mowoHNsFZMT7/r1nCZOEMCQXI2
	m04w5+BCw/q5yENHSV+ARYOs/zNRYm6nWU2kXnkcLeIJEhtwWqUzOVLcn5Kf0JvBvvUVw8Ai7GO
	q2NxtIQ==
X-Google-Smtp-Source: AGHT+IEbU8/7oKw60IdekSZ2uPK7tOP69qubBrOPVxWkcsFEQioE7o+fXimMV9GAzzkkwAHHPR09XNVnGaA=
X-Received: from pfun18.prod.google.com ([2002:a05:6a00:7d2:b0:746:32ee:a305])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9982:b0:215:dc01:8b1f
 with SMTP id adf61e73a8af0-21ee2618e1cmr1276375637.32.1749163670714; Thu, 05
 Jun 2025 15:47:50 -0700 (PDT)
Date: Thu, 5 Jun 2025 15:47:49 -0700
In-Reply-To: <729bd284-f1df-d384-8db1-37b448b0c1da@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-14-pbonzini@redhat.com>
 <729bd284-f1df-d384-8db1-37b448b0c1da@amd.com>
Message-ID: <aEIelSM6viCxaHj7@google.com>
Subject: Re: [PATCH 13/29] KVM: implement vCPU creation for extra planes
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	roy.hopkins@suse.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 21, 2025, Tom Lendacky wrote:
> On 4/1/25 11:10, Paolo Bonzini wrote:
> > For userspace to have fun with planes it is probably useful to let them
> > create vCPUs on the non-zero planes as well.  Since such vCPUs are backed
> > by the same struct kvm_vcpu, these are regular vCPU file descriptors except
> > that they only allow a small subset of ioctls (mostly get/set) and they
> > share some of the backing resources, notably vcpu->run.
> > 
> > TODO: prefault might be useful on non-default planes as well?
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  Documentation/virt/kvm/locking.rst |   3 +
> >  include/linux/kvm_host.h           |   4 +-
> >  include/uapi/linux/kvm.h           |   1 +
> >  virt/kvm/kvm_main.c                | 167 +++++++++++++++++++++++------
> >  4 files changed, 142 insertions(+), 33 deletions(-)
> > 
> 
> > @@ -4200,8 +4223,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >  	 * release semantics, which ensures the write is visible to kvm_get_vcpu().
> >  	 */
> >  	vcpu->plane = -1;
> > -	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> > -	r = xa_insert(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
> > +	if (plane->plane)
> > +		vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> > +	else
> > +		vcpu->vcpu_idx = plane0_vcpu->vcpu_idx;
> 
> Don't you want the atomic_read() for the plane0 vCPU and use the plane0
> vcpu->idx value for non-zero plane vCPUs?

+1, this looks backwards to me as well.

> 
> > +
> > +	r = xa_insert(&plane->vcpu_array, vcpu->vcpu_idx,
> > +		      vcpu, GFP_KERNEL_ACCOUNT);
> >  	WARN_ON_ONCE(r == -EBUSY);
> >  	if (r)
> >  		goto unlock_vcpu_destroy;
> > @@ -4220,13 +4248,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >  	if (r < 0)
> >  		goto kvm_put_xa_erase;
> >  
> > -	atomic_inc(&kvm->online_vcpus);
> > +	if (!plane0_vcpu)
> 
> It looks like plane0_vcpu will always have value, either from input or
> assigned in an else path earlier in the code. Should this be
> "!plane->plane" ?

Even if plane0_vcpu were viable, my vote is for !plane->plane, because that makes
it much more obvious that only plane0 bumps the count.

