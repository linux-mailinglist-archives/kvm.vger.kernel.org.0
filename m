Return-Path: <kvm+bounces-65909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9DECBA14E
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBF863011024
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF831D45E8;
	Sat, 13 Dec 2025 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pknYQnCM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63E2AF1D
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584066; cv=none; b=Pmn+YMcJ+eIZb6JYS1Vl1Tc/f63UdhxaFsD5O2Vu373sJ+u+TnFfAq+B0YXHTIGYvoMV/TArcD1KUjOqav2Zfk4j/sY720l+FDLX7jzZs4VKeUe1Bx9+aVz5kPLI30kJ3TbI3FMnu+UnUMUX6U2GR/MsHZbzxQ1f4TjFhtbe9Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584066; c=relaxed/simple;
	bh=K6Ndkyqt4qgLN3rt//PyC6snpWHY/R/b0W/n+LIpL9w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SJB2tOTcoYx0Y/eY9L9PJMn9NKT2qpn7AzlYVqERokpkMnoA4p1k3LooF3udQt5XFrthX1jBkMV655oaMs98w/CqakvbrTTjBsvhPWDnxuIT/JHZSENMKPlI33VD2AJt2uhnblKfP7haPeVbes1L2IoGDZyYG1S7FVtBWK3LLyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pknYQnCM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34a8cdba421so2215214a91.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765584064; x=1766188864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WNFpi/IbU1R2ZtuGr98e3BDN0RsW+hF16llJxBL29iY=;
        b=pknYQnCM4+MpCpbAro1OS2kEwOjoJf0wiUSl54vPLP6R0kMLD4jKGfmzCiyH8pHbS7
         HTuEW/CkSX9+FkAXSwULLB8WU3w4jCrUdr1VMPXeXbBF1Q6Jfxy7ska63VEo1CS4GD49
         4G0ElCFFEDiMg4QX4h9dxjpLLj4wF9AAu/pAi05NR7u9Kzy+T1RnNW3wjNqAheg5DvEZ
         fvTlVQden50u6Ynen/e2qsB9ADisAWkVRS2BauMF86cjWc+kad7PGAA5JdsOzqo3zQne
         p5DlKC58SqiqN4NGAse6BxCFXnJQ91nnQVdoVEK4MlyfVOPxdaWof3qi5gBLtTDpautE
         /GNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584064; x=1766188864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNFpi/IbU1R2ZtuGr98e3BDN0RsW+hF16llJxBL29iY=;
        b=sjOFUrPJzXG6ZxNR6Ry4mr+rsiA7mPRDFThK13TKyfwQX4JN8mA0TENpdM46rNU2Hz
         z0nCgDfqiH3skgKfd22usWRqoawGPCc6ESP9XA7yYgukfTN1gX4hbB32BjrELpNX1Ooo
         VPAIyw11d2TTEaPJBUHo9gXuHD30AZxeozj809P8N//Ffjeg6rh+lyRY1OtPqubg908I
         fly5rI/JVTk3I4U3TfBmGgQl5lk6+RcIemDr92cBCaLmN6phZLth8/QLOsKe0lbLaJ6u
         vLN+mUmMZUdW7KnTEqtSONVe7B4qQJG3jvpn4hJH7uaJYgB58EA9jjq3vKyRKS6Slq0F
         dNRw==
X-Forwarded-Encrypted: i=1; AJvYcCUocY+3c3qeAzKoZg8iy2dRjC+PZeYyxwLeTmCB8ZAtR32lUlIdf9Zs7Pdzu55hYkBMtsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5lpx9Rw8fN1GeyHwTcbXVIJNno6B0V4QgvvjHSk4Pqk2E52fU
	oTmGrKDtnWAewA5nt/jaIIGAqbgGFnWVFkWgN4aNrapsbtG5ItTuoWYUYBIVgEddJpgA92dzMSc
	e6Qj7oQ==
X-Google-Smtp-Source: AGHT+IEXmTnJ2kunCHo9AYyhNOsbaF9z1r99dtYCc3iC2wGUKr/5L5dyKzlksUg7UjhPmhdXu+x/vrIINXI=
X-Received: from pjl6.prod.google.com ([2002:a17:90b:2f86:b0:349:2cdf:d8c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4f:b0:340:9cf1:54d0
 with SMTP id 98e67ed59e1d1-34abd7a93f1mr2920816a91.1.1765584064324; Fri, 12
 Dec 2025 16:01:04 -0800 (PST)
Date: Fri, 12 Dec 2025 16:01:02 -0800
In-Reply-To: <lbbd3hbglrlnsxwqb2t6cri7peqcjrrxqtfqdcnhqo5njlgava@v56im3yjgllf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-12-yosry.ahmed@linux.dev> <aThKPT9ItrrDZdSd@google.com>
 <cqoepoowhgkauskf7enfmqo7gxn3onaqwuoxtv6yfpf6ilbzeo@afeqsa4juzkx> <lbbd3hbglrlnsxwqb2t6cri7peqcjrrxqtfqdcnhqo5njlgava@v56im3yjgllf>
Message-ID: <aTysvq7v7Zp0_4xz@google.com>
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 11, 2025, Yosry Ahmed wrote:
> On Thu, Dec 11, 2025 at 07:25:21PM +0000, Yosry Ahmed wrote:
> > On Tue, Dec 09, 2025 at 08:11:41AM -0800, Sean Christopherson wrote:
> > > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > > Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> > > > the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> > > > simplifies the flow of nested_svm_vmrun() and removes all jumps to
> > > > cleanup labels.
> > > > 
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
> > > >  1 file changed, 13 insertions(+), 15 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index a48668c36a191..89830380cebc5 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> > > >  
> > > >  	nested_svm_hv_update_vm_vp_ids(vcpu);
> > > >  
> > > > +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> > > 
> > > This is silly, just do:
> > > 
> > > 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
> > > 	    nested_svm_merge_msrpm(vcpu)) {
> > > 		svm->nested.nested_run_pending = 0;
> > > 		svm->nmi_l1_to_l2 = false;
> > > 		svm->soft_int_injected = false;
> > > 
> > > 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> > > 		svm->vmcb->control.exit_code_hi = -1u;
> > > 		svm->vmcb->control.exit_info_1  = 0;
> > > 		svm->vmcb->control.exit_info_2  = 0;
> > > 
> > > 		nested_svm_vmexit(svm);
> > > 	}
> > 
> > Actually, if we go with the approach of making all VMRUN failures
> > happen before preparing the VMCB02 (as discussed in the other thread),
> > then we will want to call nested_svm_merge_msrpm() from within
> > enter_svm_guest_mode().
> 
> We can also just call nested_svm_merge_msrpm() before
> enter_svm_guest_mode(), which seems to work. 

That's likely unsafe, nested_vmcb_check_controls() checks fields that are consumed
by nested_svm_merge_msrpm().

> > Otherwise, we either have a separate failure path for
> > nested_svm_merge_msrpm(), or we make all VMRUN failures happen after
> > preparing the VMCB02 and handled by nested_svm_vmexit().
> > 
> > I like having a separate exit path for VMRUN failures, and it makes more
> > sense to do the consistency checks on VMCB12 before preparing VMCB02.
> > But I understand if you prefer to keep things simple and move all
> > failures after VMCB02.
> > 
> > I already have it implemented with the separate VMRUN failure path, but
> > I don't wanna spam you with another series if you prefer it the other
> > way.

Spam away.

