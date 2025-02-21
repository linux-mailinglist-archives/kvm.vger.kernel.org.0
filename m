Return-Path: <kvm+bounces-38819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD29BA3E97D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2095E4269C7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77DE78F5D;
	Fri, 21 Feb 2025 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G3ilED8N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4429D70807
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740099322; cv=none; b=Vn3kUvYmfGWP3q/w0triHRczJ/2CctKw8rhsDCJVNa3/JspHUff+q9S/HnRWc+C/38serXLQ+FdmmcdhFnsr8bfOAHHDV4viOlSebeZmpgRl2RJCi4F1u/9O5CXlG9LNuBQI/JzCyHOx2V2FtmDhJeuvrd7kz01CXsyD+OWdJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740099322; c=relaxed/simple;
	bh=e+5yrhmneBVshqNqkQclzRo8cBn1bxXJDoR3zvaSEtQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tnd1gPkeyVyBKGEP7dqUftgmNYAY+IQUZ2bnFDL5Cwdb934K+n/JhMWVfnnTN8Z0TgTzxzfxUqqwuXMPw4B9XIHYoe0Oq3vjzfvNEHWvb4A9Gop67QYMNXJnsc2EKTpmTTh3cK51RUC6AAWaNhU0AZc6+m+7dTsUxGvUKAGxTjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G3ilED8N; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05c00so5004315a91.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 16:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740099319; x=1740704119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kOOIJL7djRpCC39YFiZH/04xhbPykeXqRm2/FL5cbg=;
        b=G3ilED8NI+pIfPOreF9pXkaq2Higyo/jGpLOnQz2Lss/qv+NfX9YWJgne8gqEZDASG
         p9wpVRnJ7eSqnaA+pOl0nwuhoHUBFOfzuwtM+1rBAYghJ0fNYjDLy1yeZAlpjvo8iWFU
         S4m0mI6tJz/3jCbUmTSlp8OfvRlQZB4TcnJEvCfof5hjBYV9rue2ADg34khDoea39jZK
         OgYurOWiZX/GNw1jzxKgkqdqREqQcGm/1x6pOQIVLRYD34HswnvZWC6mYBsWl7zdfhSi
         A6jIxQdNNxKHtHL0YxAoVKIboKCbxxSH/a2bB6aJSd7MLfRLVRw5+GCG3XVmtucQBNNc
         r0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740099319; x=1740704119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kOOIJL7djRpCC39YFiZH/04xhbPykeXqRm2/FL5cbg=;
        b=LlirJZjGRLH8/3v/15N9WzbqKEn+EZwGJuAFwkIznX3SwrSmHbYsHUgGUHxnRv0yf4
         91R2NhlFVPnTL7KE//OpmMIHp/fHr94paVDvwMXETUPdKq0GBWahDpdX1paVsM27ZJRy
         duB78H7n2rCT/N/Cqk6t5z9dXDdkbQr2e4bMVCOhaWXTD9t0bXdso7wsR/+SKs5SCvQS
         KGPzTyT0VfY6VLo4J+i0d0SEgDCkHsaZsxQDXYzcTgRESAzYTEzXbggGRUPYt9FGteuT
         2A+yoDVoRAnG+UDTX7vP/EHcBw9C/c1+QfiixZTicp2j1jbGibBNSfj5q/zkYCyZ5d4A
         TBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSqTQI3VR9xX6C8Zeuv3k+L723s6u0DJIeDP6LPXDIXGUYDz9xJLrXVrCKfxZdooGz204=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvy6/BJKqAjyjgUpGZ4HzJVsszHRktoTDcWxxkJzJU4uwvrbjq
	F2fNAGfRryDPdxLvRScJKyDOZo9VhjooTe1bkQpAtMQBWsYWLNv4KPTVjvR4v+dlxT3AxXkiU8p
	7qg==
X-Google-Smtp-Source: AGHT+IEuaCiOOntaC1FGKmHzqSa2ZEJgwgIQf3BqfjgzOP1N0VgyBrNZxMdxAybGdcqFGBDxoPcpnRViAtE=
X-Received: from pjbhl14.prod.google.com ([2002:a17:90b:134e:b0:2fc:2828:dbca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c05:b0:2f5:88bb:12f
 with SMTP id 98e67ed59e1d1-2fce78c9254mr1882909a91.21.1740099319523; Thu, 20
 Feb 2025 16:55:19 -0800 (PST)
Date: Thu, 20 Feb 2025 16:55:18 -0800
In-Reply-To: <20250220170604.2279312-21-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250220170604.2279312-1-pbonzini@redhat.com> <20250220170604.2279312-21-pbonzini@redhat.com>
Message-ID: <Z7fO9gqzgaETeMYB@google.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Tony Lindgren <tony.lindgren@linux.intel.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

TL;DR: Please don't merge this patch to kvm/next or kvm/queue.

On Thu, Feb 20, 2025, Paolo Bonzini wrote:
> @@ -72,8 +94,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
>  	.vm_size = sizeof(struct kvm_vmx),
> -	.vm_init = vmx_vm_init,
> -	.vm_destroy = vmx_vm_destroy,
> +
> +	.vm_init = vt_vm_init,
> +	.vm_destroy = vt_vm_destroy,
> +	.vm_free = vt_vm_free,
>  
>  	.vcpu_precreate = vmx_vcpu_precreate,
>  	.vcpu_create = vmx_vcpu_create,

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 374d89e6663f..e0b9b845df58 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12884,6 +12884,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }

Sorry to throw a wrench in things, but I have a fix that I want to send for 6.14[1],
i.e. before this code, and to land that fix I need/want to destroy vCPUs before
calling kvm_x86_ops.vm_destroy().  *sigh*

The underlying issue is that both nVMX and nSVM suck and access all manner of VM-wide
state when destroying a vCPU that is currently in nested guest mode, and I want
to fix the most pressing issue of destroying vCPUs at a random time once and for
all.  nVMX and nSVM also need to be cleaned up to not access so much darn state,
but I'm worried that "fixing" the nested cases will only whack the biggest mole.

Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was called")
papered over an AVIC case, but there are issues, e.g. with the MSR filters[2],
and the NULL pointer deref that's blocking the aforementioned fix is a nVMX access
to the PIC.

I haven't fully tested destroying vCPUs before calling vm_destroy(), but I can't
see anything in vmx_vm_destroy() or svm_vm_destroy() that expects to run while
vCPUs are still alive.  If anything, it's opposite, e.g. freeing VMX's IPIv PID
table before vCPUs are destroyed is blatantly unsafe.

The good news is, I think it'll lead to a better approach (and naming).  KVM already
frees MMU state before vCPU state, because while MMUs are largely VM-scoped, all
of the common MMU state needs to be freed before any one vCPU is freed.

And so my plan is to carved out a kvm_destroy_mmus() helper, which can then call
the TDX hook to release/reclaim the HKID, which I assume needs to be done after
KVM's general MMU destruction, but before vCPUs are freed.

I'll make sure to Cc y'all on the series (typing and testing furiously to try and
get it out asap).  But to try and avoid posting code that's not usable for TDX,
will this work?

static void kvm_destroy_mmus(struct kvm *kvm)
{
	struct kvm_vcpu *vcpu;
	unsigned long i;

	if (current->mm == kvm->mm) {
		/*
		 * Free memory regions allocated on behalf of userspace,
		 * unless the memory map has changed due to process exit
		 * or fd copying.
		 */
		mutex_lock(&kvm->slots_lock);
		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
					0, 0);
		__x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
					0, 0);
		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
		mutex_unlock(&kvm->slots_lock);
	}

	kvm_for_each_vcpu(i, vcpu, kvm) {
		kvm_clear_async_pf_completion_queue(vcpu);
		kvm_unload_vcpu_mmu(vcpu);
	}

	kvm_x86_call(mmu_destroy)(kvm);
}

void kvm_arch_pre_destroy_vm(struct kvm *kvm)
{
	kvm_mmu_pre_destroy_vm(kvm);
}

void kvm_arch_destroy_vm(struct kvm *kvm)
{
	/*
	 * WARNING!  MMUs must be destroyed before vCPUs, and vCPUs must be
	 * destroyed before any VM state.  Most MMU state is VM-wide, but is
	 * tracked per-vCPU, and so must be unloaded/freed in its entirety
	 * before any one vCPU is destroyed.  For all other VM state, vCPUs
	 * expect to be able to access VM state until the vCPU is freed.
	 */
	kvm_destroy_mmus(kvm);
	kvm_destroy_vcpus(kvm);
	kvm_x86_call(vm_destroy)(kvm);

	...
}

[1] https://lore.kernel.org/all/Z66RC673dzlq2YuA@google.com
[2] https://lore.kernel.org/all/20240703175618.2304869-2-aaronlewis@google.com

