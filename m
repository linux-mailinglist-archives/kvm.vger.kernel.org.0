Return-Path: <kvm+bounces-61990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C457C3244D
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E5A734AD41
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43170271457;
	Tue,  4 Nov 2025 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l/TbMY2a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09A326CE17
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762276574; cv=none; b=hC5wcAOhsMyDRU52W42T0vOCJeYQwQdyE8eYhN1I461NbKziYwYB+mpPcXcZJhao6PvHCMlDFW5W4BkQYbA1PMkBxbxgYIXtJ9RbJME8TOZrrY/RjCg1LuNLAUfF9yNV2h7hyvbABpfeVhbsrShFoHjm5hP3pwVrzUWYZ+iSXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762276574; c=relaxed/simple;
	bh=74YBZDoQ83xKtptK80/takPjZbLTMjieIiqtSwmNNJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p9aUwk5QpbMfoCZRC1xvN0XOS5rU5SIKO0PKVYHczho86DhJPIQb7G0LGC0a4NuanPDPy2jOO8c8eX6hW6CPuxQqlIc2mhFqqF/o7WFBsoteIfxj0wIlKyE/xM82PNzQN31yZVVBku7uipiR0EcgKuddxAnVbYrNy9FGNpX0yUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l/TbMY2a; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-277f0ea6ee6so64112035ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762276572; x=1762881372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tS4bLkjfdqWxdiK6mwiFizJkIXMdxek1nIt3B9oDobs=;
        b=l/TbMY2a8xpeaTkpchRwNykNVkEdH/f5QackNGVwgOn3WPBPS5dEx11lFp8SNsSRVz
         3sKFOZOmixJCTL1WdfdjdTUuDnk0XXv8jqa0mtf3Py1g1ZjesEmnoPElZOnKsZE56pSc
         Amkfjkls0PHti3HX6fOxMMAExpOywoUj+TQyNfvR3WoIt/aIOlCMuJon+1Gkb4TtBzV3
         1IPRR1x3Ke38BycKUyw174ZmBiv4gdLwCnLtCuVw5kH47weXjRZx3q+A8dEKEQvmFiUK
         We+Vbh7qj+gecpJvGPae4coecubN0IXFAkYo2iUiI7ySF+BMDbhcwpDgbJMfd+MhEzlO
         Ebsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762276572; x=1762881372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tS4bLkjfdqWxdiK6mwiFizJkIXMdxek1nIt3B9oDobs=;
        b=AzVX360xqkg7NH9sClu8v0QGLvrdpQRmafu2uYUHHErwCLwzE199WBSBxLFZ3y2DYX
         E6laRQI2i7AncyrfEO6h3EBwN6wh4PyYfG7asHmfjr+/2tC+boJZjaeaILqdKEabPs9j
         YbMFLAso5jeS40+2yvK/CvdGtCufih69UkRZIpviWUI/caqicZX9GpEWCvPjh2WWL7Wx
         D/JAZOw6NPsMjjplBZjTX9iBrvpEoOYiqfo8eAQ1CzHECrncaqphVz8B//OzvBK/RJX1
         uK1bGSY21MPVDodI7HGU5p91nC+CsgdS8Z4b1ZxRD4QEjmua7Ii0MYeG2KV3QFb/8vgx
         44Ow==
X-Forwarded-Encrypted: i=1; AJvYcCUpy+QW/9rCSCMREc2/Yp7bLTBm0Btrp9/ESxmcbV9Mb0oMsNeuGNlJFsHCfblu9QLCV1k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Fxjc8PeIxEB7j7j5xjy+m+KiPcqRyTik2B5NLs7qdiTQDmyH
	48drquhXsw/WeuErkrO6RAdSCkn6Dq1xqHdxBmpNxtbSPOpq0ut2bLpVVNAVzGuoOEFRemZGrgC
	w/kER7w==
X-Google-Smtp-Source: AGHT+IEb98zdibRUw3q8rz5s7dc2rz9KLXalBcAB3oaxD9YhpNQGD+LumJ8fuqIknfJVxR3bHJsxCZ35FjU=
X-Received: from plhy12.prod.google.com ([2002:a17:902:d64c:b0:295:525b:2186])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41cf:b0:295:3d5d:fe57
 with SMTP id d9443c01a7336-2962ad2add3mr4432015ad.21.1762276572264; Tue, 04
 Nov 2025 09:16:12 -0800 (PST)
Date: Tue, 4 Nov 2025 09:16:08 -0800
In-Reply-To: <ojg5bq2guzb6hk7q7n2przo2ygkra6boavhhq7u5kptygu6jij@5nvgdi3preqg>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030185004.3372256-1-seanjc@google.com> <ojg5bq2guzb6hk7q7n2przo2ygkra6boavhhq7u5kptygu6jij@5nvgdi3preqg>
Message-ID: <aQo02LpJ5IfNzVD3@google.com>
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 03, 2025, Yosry Ahmed wrote:
> On Thu, Oct 30, 2025 at 11:50:03AM -0700, Sean Christopherson wrote:
> > Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
> > code that fills the exit reason and CPU when KVM encounters a VM-Exit that
> > KVM doesn't know how to handle.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm/svm.c          |  7 +------
> >  arch/x86/kvm/vmx/tdx.c          |  6 +-----
> >  arch/x86/kvm/vmx/vmx.c          |  9 +--------
> >  arch/x86/kvm/x86.c              | 12 ++++++++++++
> >  5 files changed, 16 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 48598d017d6f..4fbe4b7ce1da 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2167,6 +2167,7 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
> >  void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
> >  
> >  void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
> > +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason);
> >  
> >  void kvm_enable_efer_bits(u64);
> >  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index f14709a511aa..83e0d4d5f4c5 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3451,13 +3451,8 @@ static bool svm_check_exit_valid(u64 exit_code)
> >  
> >  static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
> >  {
> > -	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
> >  	dump_vmcb(vcpu);
> > -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> > -	vcpu->run->internal.ndata = 2;
> > -	vcpu->run->internal.data[0] = exit_code;
> > -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> > +	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
> >  	return 0;
> >  }
> 
> We can probably drop svm_handle_invalid_exit() entirely now

Hmm, yeah.  I'll do so in a separate follow-up, as I want to do more than just
fold svm_handle_invalid_exit() into svm_invoke_exit_handler().

