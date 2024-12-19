Return-Path: <kvm+bounces-34174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6809F828C
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 18:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06C2A7A3EB2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 17:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1831A726B;
	Thu, 19 Dec 2024 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJjuWYzs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4EA1946DA
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630592; cv=none; b=P7GcE0nkWOavV+0fGMn2HYRh49xRvOXPCmbkv9tIUlU2bHmYCNMKQuyPmW3uSQj+3JKgdyAKJ6F0QifqyKKDZGpUC27MuS9QKHMSSnJ9DBESggbIM7tGLITdDO1Oo7Ii8calN/wtyPsXTPfokGd6e4B73lj0KIyLEJyhZtxCUeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630592; c=relaxed/simple;
	bh=W2AE3efuXPQM2Td61Im0ibq+bjHsOT+eUUp2GvmHqlI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XMoh84kN4VMJ8lGwGLb0DLPoVmFnraa6WA7oMlec2BVK0Pf4RhXTqj0DwFnqYV6gwHLMQ+b5DCkZIfIePHr3Fzxp+KqWP12vjanYqsegCZjnzUYUisAjx30Fa6ZdOQ2rFofjNDl1Sqk0qMxymcX0Qx7EmqhojyDZHgLvSovodfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJjuWYzs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734630589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFYxzBnH9Nmr3/1+Gv4ueOJjpF8J01T/gwryfiZdCzY=;
	b=BJjuWYzs1ryvUKh6i8FCSnlH9Qy/c9ATLmfW3DoInH6n573fpQSUQ+zlr6IudMd2kzC1VU
	2XKdQx3//sz6UdsP+R6T/prRZDAL8Oz6vXRtj3ZOVvhC0HXCv5d95Oyk490PdgperTCZsH
	HLtkfxtwjAWgGHohsR58UwfOvcWQOIo=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-Tc-Igh8ZNgC1QU-GnUETuQ-1; Thu, 19 Dec 2024 12:49:48 -0500
X-MC-Unique: Tc-Igh8ZNgC1QU-GnUETuQ-1
X-Mimecast-MFC-AGG-ID: Tc-Igh8ZNgC1QU-GnUETuQ
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9d075bdc3so17485805ab.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 09:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734630588; x=1735235388;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFYxzBnH9Nmr3/1+Gv4ueOJjpF8J01T/gwryfiZdCzY=;
        b=O/oDyn4Dz8g3azHH9rT2Q4GJGAN8FO2kH2D1OABuIFLkqLG5Uftyc8ttBSE7m3AGNu
         +b3IAFnnra8P/nK04Rq/ChZKemkTlFSBMxw1C3TYj9/uk/+mWUsQJBIzPHoDArz8i2MU
         A0UiFcGlgOTfyfa98VrIIidLbctHs7e7uQnjCheaDjEqVNA9hPElKtHBVcXcf4pbwq1D
         w9kWG70z1b/aKakN0aP+NVFplxfcrm6L5E5Bq5UHgLSn9LbC742l2Dng/cIOCYqT+JDj
         EPFXMlBUQsYhEb9yecYvhAewtUMf5KA0skktnQynqfKaR8a394549Vtg8wusORgyuj91
         O7qA==
X-Forwarded-Encrypted: i=1; AJvYcCUuB8fOqqNM2DioE7aNKUxTETRZj1LvOfwzPZ/6ia8yS/ap8JoIhdXvRf7kuG+VsaPfUY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2la+zPvvGSxd2aRGR8vgt/aNMzLOOrQYWXYqCOheCU+2E3dIb
	YMHcFUYvi+iXMktLtL/KCsKIGC4GgIJhm+qYmzPdFwXm7JTEy7AxWVpW/fkk2cDp04NLO5nNkVR
	AQMswasAseOJcmyyXRuub+hmmiQoTScm+idiJfBi9fkvGrNsETA==
X-Gm-Gg: ASbGncscw3TwktlJcHT9cjFrQ2ew9QxTLoSQMubjFH9kcbVMZUh0QC8qG8i3L09hiuu
	TjkMazaq43SXNws2a0NkvS28TiRyY/OwV6r2y2rPff1wSP/k764bN3s6VWXoJBSlNjjltLGIt1l
	vM7lS8Jh84EBKUtnXQembbtgPYVAQZh6uGqVWPDLGhNuErcAgiZrceRXC5X+3h85bPr9i56ZneS
	FpLOB9OGdBDGWWKcT3HsUr/IqSyk/Gq5vDPt5TmWumNN5OZlTm1db+d
X-Received: by 2002:a05:6e02:742:b0:3a7:fe8c:b012 with SMTP id e9e14a558f8ab-3bdc4659beemr74802575ab.18.1734630587966;
        Thu, 19 Dec 2024 09:49:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFQ5a9tvcbkcwAiXwoc4j7pG79MjTcFmv/Tx/EmA6juS7AFcCVHd4xkdAN74hjjKq0QhgCiA==
X-Received: by 2002:a05:6e02:742:b0:3a7:fe8c:b012 with SMTP id e9e14a558f8ab-3bdc4659beemr74802255ab.18.1734630587644;
        Thu, 19 Dec 2024 09:49:47 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf7ecb9sm370539173.73.2024.12.19.09.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 09:49:47 -0800 (PST)
Message-ID: <4c1c999c29809c683cc79bc8c77cbe5d7eca37b7.camel@redhat.com>
Subject: Re: [PATCH v5 3/3] KVM: x86: add new nested vmexit tracepoints
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Sean Christopherson <seanjc@google.com>, "H. Peter
 Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date: Thu, 19 Dec 2024 12:49:46 -0500
In-Reply-To: <9ff2be87-117a-4f96-af3b-dacb55467449@redhat.com>
References: <20240910200350.264245-1-mlevitsk@redhat.com>
	 <20240910200350.264245-4-mlevitsk@redhat.com>
	 <9ff2be87-117a-4f96-af3b-dacb55467449@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-12-19 at 18:33 +0100, Paolo Bonzini wrote:
> On 9/10/24 22:03, Maxim Levitsky wrote:
> > Add 3 new tracepoints for nested VM exits which are intended
> > to capture extra information to gain insights about the nested guest
> > behavior.
> > 
> > The new tracepoints are:
> > 
> > - kvm_nested_msr
> > - kvm_nested_hypercall
> > 
> > These tracepoints capture extra register state to be able to know
> > which MSR or which hypercall was done.
> > 
> > - kvm_nested_page_fault
> > 
> > This tracepoint allows to capture extra info about which host pagefault
> > error code caused the nested page fault.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/nested.c | 22 +++++++++++
> >   arch/x86/kvm/trace.h      | 82 +++++++++++++++++++++++++++++++++++++--
> >   arch/x86/kvm/vmx/nested.c | 27 +++++++++++++
> >   arch/x86/kvm/x86.c        |  3 ++
> >   4 files changed, 131 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 6f704c1037e51..2020307481553 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -38,6 +38,8 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> >   {
> >   	struct vcpu_svm *svm = to_svm(vcpu);
> >   	struct vmcb *vmcb = svm->vmcb;
> > +	u64 host_error_code = vmcb->control.exit_info_1;
> > +
> >   
> >   	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
> >   		/*
> > @@ -48,11 +50,15 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> >   		vmcb->control.exit_code_hi = 0;
> >   		vmcb->control.exit_info_1 = (1ULL << 32);
> >   		vmcb->control.exit_info_2 = fault->address;
> > +		host_error_code = 0;
> >   	}
> >   
> >   	vmcb->control.exit_info_1 &= ~0xffffffffULL;
> >   	vmcb->control.exit_info_1 |= fault->error_code;
> >   
> > +	trace_kvm_nested_page_fault(fault->address, host_error_code,
> > +				    fault->error_code);
> > +
> 
> I disagree with Sean about trace_kvm_nested_page_fault.  It's a useful 
> addition and it is easier to understand what's happening with a 
> dedicated tracepoint (especially on VMX).
> 
> Tracepoint are not an exact science and they aren't entirely kernel API. 
>   At least they can just go away at any time (changing them is a lot 
> more tricky, but their presence is not guaranteed).  The one below has 
> the slight ugliness of having to do some computation in 
> nested_svm_vmexit(), this one should go in.
> 
> >   	nested_svm_vmexit(svm);
> >   }
> >   
> > @@ -1126,6 +1132,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >   				       vmcb12->control.exit_int_info_err,
> >   				       KVM_ISA_SVM);
> >   
> > +	/* Collect some info about nested VM exits */
> > +	switch (vmcb12->control.exit_code) {
> > +	case SVM_EXIT_MSR:
> > +		trace_kvm_nested_msr(vmcb12->control.exit_info_1 == 1,
> > +				     kvm_rcx_read(vcpu),
> > +				     (vmcb12->save.rax & 0xFFFFFFFFull) |
> > +				     (((u64)kvm_rdx_read(vcpu) << 32)));
> > +		break;
> > +	case SVM_EXIT_VMMCALL:
> > +		trace_kvm_nested_hypercall(vmcb12->save.rax,
> > +					   kvm_rbx_read(vcpu),
> > +					   kvm_rcx_read(vcpu),
> > +					   kvm_rdx_read(vcpu));
> > +		break;
> 
> Here I probably would have preferred an unconditional tracepoint giving 
> RAX/RBX/RCX/RDX after a nested vmexit.  This is not exactly what Sean 
> wanted but perhaps it strikes a middle ground?  I know you wrote this 
> for a debugging tool, do you really need to have everything in a single 
> tracepoint, or can you correlate the existing exit tracepoint with this 
> hypothetical trace_kvm_nested_exit_regs, to pick RDMSR vs. WRMSR?


Hi!

If the new trace_kvm_nested_exit_regs tracepoint has a VM exit number argument, then
I can enable this new tracepoint twice with a different filter (vm_exit_num number == msr and vm_exit_num == vmcall),
and each instance will count the events that I need.

So this can work.

Thanks!
Best regards,
	Maxim Levitsky

> 
> Paolo
> 



