Return-Path: <kvm+bounces-22799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC88943408
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 18:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FC371F21CF0
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 16:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481981BC090;
	Wed, 31 Jul 2024 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RZoIpqTF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9671B3F1A
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722442740; cv=none; b=qRiwR+VDSS+t2P5baNkwxohDokr+0dTst8h0Mq5yrXEa0G0zCORBQ8El4kDanuvUTaF6Gg8SiAmLfSTK56qDfP10ubSoqiQM1JOso1Hic+6WxDM5gRb1DqTC91ychEeF51OYqALC+XQ/5bp+x3NeDpzTfGc9BBi9Lh4rlombMfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722442740; c=relaxed/simple;
	bh=ElAcQ+gpc9rbYRw6zuWtY49Lo01Kky3BFlz2QoDeVlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=haCkNdCvV9Vu6xsneWGdjS6hNRUf1fh6zX6pMrBEolGp8wTKbmqIVoJm1FSmP3qRZsM05kOe/gkR3Y3z1uKEgTTNRveKIpyd3MDRgRjIV5NqeedDAqx6vA/BJ7ydFMgzT2LlWNAuLaR9MFNHGfdwcZaAfLFuUOHzIwQ3mjexsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RZoIpqTF; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d35b705d3so6362762b3a.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722442738; x=1723047538; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KEkAg/E0EBKwZG+0w3Tkn7qnDNz9XXpCm5xfKJGg0ro=;
        b=RZoIpqTFiy3ob5fef0NrGruFZ/sVu9oSCozCwnxWtoxQPaVMY1ga+DevPIc2fLO5qY
         W+D8xou+WrVE+yGJXb3GMWWiAsDBuJGSWh98gAHb3XDsCq4FqVU+MVeTnSbKwNI+qbGq
         zxxNnmTxjpSob/MUVi890c0nofo8x694oYYC6P/ICws+gJ9nl94oecfd7aa45O5Gp+A2
         9Mwd1Xwpxl/UmtjQ9Uw8okkr9xDoj4PSdhnSgWHbYxXWX90KI1w7ByfGTf8hT1er++TZ
         tpzxUtl7qcFPNUUzvIMU+kXbTV/bhw/ll5hsl8MzzuVh6+eGX/lpJAmlGbXslOMmTOgx
         uRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722442738; x=1723047538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEkAg/E0EBKwZG+0w3Tkn7qnDNz9XXpCm5xfKJGg0ro=;
        b=ZzGrPgETMOLtsDgJTnLbdJa8rFOmM+PEE4KxWsGFGcOCq+Sba2NpIA+Af7Xw3r2zlo
         80lXl0OZ7wvFW82AbTZsk7Ydr/klVoo0ppovASy1uL3d325z+qo2lXmgzKcZmJPwhcd6
         Bs7/jnpWlveE96PumtHyQWkMrEWd9U/EQpVKLVrVe08oHMlUiQZ2MbYNMYYzetSp+k+t
         qWOC8sPYCwYM3mWDBvrj7V1vRybhwuupqeX60an/cBYJwzR093pQbP8O+jkzY2lRrj1h
         QCiZdOgb36XeC44VaxL4OTbi/q4gqbBijUovdlwSC/JQ6mfJJOmiT2RuQeosv5O6olwo
         Yznw==
X-Forwarded-Encrypted: i=1; AJvYcCUNS3UP4hChJrxWIUs9bxLKXd4P+1ccQ767BQzkMdVtDRf4dNpTT6fqFI5A4R4qRys5qcR90hyJkyx/d8eGrQEVWzz+
X-Gm-Message-State: AOJu0Yyz3xvRH7DY7+qnI41knbZ3/bqoS08iARHU9QZBf6AU2toKxNmh
	nhQOC78hKslqCyeM/CG5Jd+4h2gSjneD/CDq9I6lnb/2nFcVAmrgJfvSU3ec4Lw0GC6qp1xUWWE
	W7A==
X-Google-Smtp-Source: AGHT+IE3vR/52fbHBcG0mD8gAg08EvW707+6aqhxcpp+uszsjVVLSlqCBB7w2jlGO3uwCGZS192zyStdcJU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1823:b0:70d:3548:bb59 with SMTP id
 d2e1a72fcca58-70ecedefc97mr113184b3a.4.1722442738134; Wed, 31 Jul 2024
 09:18:58 -0700 (PDT)
Date: Wed, 31 Jul 2024 09:18:56 -0700
In-Reply-To: <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730155646.1687-1-will@kernel.org> <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
 <Zql3vMnR86mMvX2w@google.com> <20240731133118.GA2946@willie-the-truck> <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co>
Message-ID: <Zqpj8M3xhPwSVYHY@google.com>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
From: Sean Christopherson <seanjc@google.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 31, 2024, Michal Luczaj wrote:
> On 7/31/24 15:31, Will Deacon wrote:
> > On Tue, Jul 30, 2024 at 04:31:08PM -0700, Sean Christopherson wrote:
> >> On Tue, Jul 30, 2024, Michal Luczaj wrote:
> >>> On 7/30/24 17:56, Will Deacon wrote:
> >>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >>>> index d0788d0a72cc..b80dd8cead8c 100644
> >>>> --- a/virt/kvm/kvm_main.c
> >>>> +++ b/virt/kvm/kvm_main.c
> >>>> @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >>>>  
> >>>>  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> >>>>  		r = -EINVAL;
> >>>> -		goto kvm_put_xa_release;
> >>>> +		goto err_xa_release;
> >>>>  	}
> >>>>  
> >>>>  	/*
> >>>> @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >>>>  
> >>>>  kvm_put_xa_release:
> >>>>  	kvm_put_kvm_no_destroy(kvm);
> >>>> +err_xa_release:
> >>>>  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
> >>>>  unlock_vcpu_destroy:
> >>>>  	mutex_unlock(&kvm->lock);
> >>>
> >>> My bad for neglecting the "impossible" path. Thanks for the fix.
> >>>
> >>> I wonder if it's complete. If we really want to consider the possibility of
> >>> this xa_store() failing, then keeping vCPU fd installed and calling
> >>> kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.
> >>
> >> Yeah, the vCPU is exposed to userspace, freeing its assets will just cause
> >> different problems.  KVM_BUG_ON() will prevent _new_ vCPU ioctl() calls (and kick
> >> running vCPUs out of the guest), but it doesn't interrupt other CPUs, e.g. if
> >> userspace is being sneaking and has already invoked a vCPU ioctl(), KVM will hit
> >> a use-after-free (several of them).
> > 
> > Damn, yes. Just because we haven't returned the fd yet, doesn't mean
> > userspace can't make use of it.
> >
> >> As Michal alluded to, it should be impossible for xa_store() to fail since KVM
> >> pre-allocates/reserves memory.  Given that, deliberately leaking the vCPU seems
> >> like the least awful "solution".
> > 
> > Could we actually just move the xa_store() before the fd creation? I
> > can't immediately see any issues with that...
> 
> Hah, please see commit afb2acb2e3a3 :) Long story short: create_vcpu_fd()
> can legally fail, which must be handled gracefully, which would involve
> destruction of an already xa_store()ed vCPU, which is racy.

Ya, the basic problem is that we have two ways of publishing the vCPU, fd and
vcpu_array, with no way of setting both atomically.  Given that xa_store() should
never fail, I vote we do the simple thing and deliberately leak the memory.

