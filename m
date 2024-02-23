Return-Path: <kvm+bounces-9549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D773286185A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C7BE283EC6
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4B81292D5;
	Fri, 23 Feb 2024 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="slKyzBlr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC36E22329
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706804; cv=none; b=CioXCicl3Ywkkrhs6sdTMDvbaFd4m2I/cGDsdZLYJsDNFtbrIFtjEEJbvwTzN28LxEKOJeSG5CB0L2rS5YNsfpOOh0qKqASIiuKWRBxtqzuS6Xv6Wn4IzzL5EBD7+HqYdaK+ZbmxTIqymQ2XLI8BUYu8zJD8fGcE2wFM6nVGwVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706804; c=relaxed/simple;
	bh=UcvDafUh2QDdP5ODtPAmMXLmepE2Ecno7xfGvkqB9kI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kWsIdED82vUzm6OEzj4wBJozCRSe7eU46htWb+6n+dvdvffFJeQjNML0P3F8GaMcDqs9mYKR2L3sXnTBNzkOmOQigoW6m1PMageE302cYEfzIF9Wu5jEiecUy4yh3vDh9eKzh3JxJ89RbsBS7nFUlYQVMksomE14H+eSDHs3boI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=slKyzBlr; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608ab197437so17187447b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708706801; x=1709311601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDZLY+1R91be6hXCSYVgTQ61KoEqdDMYEkzpyOE6s74=;
        b=slKyzBlr4+v7Ypr9+laD4EzDJngZ9dZhQBwNFeky4GMR/DEtDlrU70l6PSa47/711P
         wdlxvaym8/hDLM3IlgN10LT3KXRdujTsrgO0bSUuFXjn0KDS+xHGwtBRP3SyqF6sHj+h
         AA8BhD+JbdHAOd475bskI9ym9/pih6We6Dj8liP/iI2IwT5B3xfkOpF2JZoev4D0Xy+R
         njlqguZyb9ZH5lhP92DEHdS5vUsAPQbvd5wGpq+DLr1PKjsy3w4Ue8L1jF8srCUB9io3
         3J4RqgiVMxYRIf1cvfSSuQDp3KsTu/MwxGEb+/Bw8jA3ttZ6BHzsqA+F0CLQZ71vyUr8
         Lmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708706801; x=1709311601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDZLY+1R91be6hXCSYVgTQ61KoEqdDMYEkzpyOE6s74=;
        b=I5QMetXQ9FuTudn9us3nRVl9Pa+tG8f1DFo35QOzQNa2VBBSQSf0B24G2bQT6xTnLy
         OxvHJwdkxEUgXJri2tnZ8bHPYl+QhgtXeUyCDh66tPmo1/l4hBfOLYC+mJjRaBwG14Ds
         uKxVkwiWBwq4ofhQb55B1jJY6JMdUIhfVEGcG0CGboF9uS9JBFukHdV2FFUrvHnnDyNP
         J5T+RIAo8UQZIcKIN0k3bGnz5qORBIHzwO1tZCAUQNGWIdTdaysuP3v59EYgotRLF1ER
         JbGtq626vdIJpB6zgfKWEKv/5gPkBwqLjdNRXgM3l1ojEMUOcogKuYKJ6I82jd1WUKqP
         T7gg==
X-Forwarded-Encrypted: i=1; AJvYcCV+oNys51luFx+D6gfkMm635YgL4kWKRUrFuu5+RR1maOkQKU+OEpDlvMsJax6131FuS2134Imojmk7/mt6eyTTlmB3
X-Gm-Message-State: AOJu0Yz0me5wiVAvGbUPuSzZeZHjKmCz1y9Jp7ewSe61knSU4vGzuhc0
	PBQW/3X3FazLu3f861EauPJYrDvb3gyej8vUgnW8kVTXIHSzOnL2YBvBM5IgdGFC0DZQ4nGHJ1T
	NZw==
X-Google-Smtp-Source: AGHT+IHMhssa9VRUyAoJ+IUroeeIsCZaesVn8kPl1BvmvavzVCfKWZEmyKKDcXK+5cTrwrYcmNE2sWLeeFc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d74d:0:b0:608:ba07:3093 with SMTP id
 z74-20020a0dd74d000000b00608ba073093mr79184ywd.1.1708706800867; Fri, 23 Feb
 2024 08:46:40 -0800 (PST)
Date: Fri, 23 Feb 2024 08:46:39 -0800
In-Reply-To: <20240223104009.632194-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-8-pbonzini@redhat.com>
Message-ID: <ZdjL783FazB6V6Cy@google.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: define standard behavior for bits 0/1
 of VM type
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> Some VM types have characteristics in common; in fact, the only use
> of VM types right now is kvm_arch_has_private_mem and it assumes that
> _all_ VM types have private memory.
> 
> So, let the low bits specify the characteristics of the VM type.  As
> of we have two special things: whether memory is private, and whether
> guest state is protected.  The latter is similar to
> kvm->arch.guest_state_protected, but the latter is only set on a fully
> initialized VM.  If both are set, ioctls to set registers will cause
> an error---SEV-ES did not do so, which is a problematic API.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  9 +++-
>  arch/x86/kvm/x86.c              | 93 +++++++++++++++++++++++++++------
>  2 files changed, 85 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0bcd9ae16097..15db2697863c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2135,8 +2135,15 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  		       int tdp_max_root_level, int tdp_huge_page_level);
>  
> +
> +/* Low bits of VM types provide confidential computing capabilities.  */
> +#define __KVM_X86_PRIVATE_MEM_TYPE	1
> +#define __KVM_X86_PROTECTED_STATE_TYPE	2
> +#define __KVM_X86_VM_TYPE_FEATURES	3
> +static_assert((KVM_X86_SW_PROTECTED_VM & __KVM_X86_VM_TYPE_FEATURES) == __KVM_X86_PRIVATE_MEM_TYPE);

Aliasing bit 0 to KVM_X86_SW_PROTECTED_VM is gross, e.g. this

 #define KVM_X86_DEFAULT_VM     0
 #define KVM_X86_SW_PROTECTED_VM        1
+#define KVM_X86_SEV_VM         8
+#define KVM_X86_SEV_ES_VM      10
 
is _super_ confusing and bound to cause problems.

Oh, good gravy, you're also aliasing __KVM_X86_PROTECTED_STATE_TYPE into SEV_ES_VM.
Curse you and your Rami Code induced decimal-based bitwise shenanigans!!!

I don't see any reason to bleed the flags into KVM's ABI.  Even shoving the flags
into kvm->arch.vm_type is unncessary.  Aha!  As is storing vm_type as an "unsigned
long", since (a) it can't ever be bigger than u32, and (b) in practice a u8 will
suffice since as Mike pointed out we're effectively limited to 31 types before
kvm_vm_ioctl_check_extension() starts returning error codes.

So I vote to skip the aliasing and simply do:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff23712f1f3f..27265ff5fd29 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1279,7 +1279,9 @@ enum kvm_apicv_inhibit {
 };
 
 struct kvm_arch {
-       unsigned long vm_type;
+       u8 vm_type;
+       bool has_private_memory;
+       bool has_protected_state;
        unsigned long n_used_mmu_pages;
        unsigned long n_requested_mmu_pages;
        unsigned long n_max_mmu_pages;

and then just use straight incrementing values for types, i.e.

#define KVM_X86_DEFAULT_VM	0
#define KVM_X86_SW_PROTECTED_VM	1
#define KVM_X86_SEV_VM		2
#define KVM_X86_SEV_ES_VM	3

It'll require a bit of extra work in kvm_arch_init_vm(), but I think the end result
will be signifincatly easier to follow.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8746530930d5..e634e5b67516 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5526,21 +5526,30 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> -					     struct kvm_debugregs *dbgregs)
> +static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> +					    struct kvm_debugregs *dbgregs)
>  {
>  	unsigned long val;
>  
> +	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	memset(dbgregs, 0, sizeof(*dbgregs));
>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>  	kvm_get_dr(vcpu, 6, &val);
>  	dbgregs->dr6 = val;
>  	dbgregs->dr7 = vcpu->arch.dr7;
> +	return 0;
>  }

>  static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
> @@ -5622,6 +5645,10 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>  {
>  	int i, r = 0;
>  
> +	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	if (!boot_cpu_has(X86_FEATURE_XSAVE))
>  		return -EINVAL;
>  
> @@ -6010,7 +6037,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_GET_DEBUGREGS: {
>  		struct kvm_debugregs dbgregs;
>  
> -		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> +		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> +		if (r < 0)

I would strongly prefer to just do

		if (r)

as "r < 0" implies that postive return values are possible/allowed.

That said, rather than a mix of open coding checks in kvm_arch_vcpu_ioctl() versus
burying checks in helpers, what about adding a dedicated helper to take care of
everything in one shot?  E.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bc69b0c9822..f5ca78e75eec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5864,6 +5864,16 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
        }
 }
 
+static bool kvm_ioctl_accesses_guest_state(unsigned int ioctl)
+{
+       switch (ioctl) {
+       case <...>:
+               return true;
+       default:
+               return false:
+       }
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
                         unsigned int ioctl, unsigned long arg)
 {
@@ -5878,6 +5888,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
                void *buffer;
        } u;
 
+       if (vcpu->kvm->arch.has_protected_state &&
+           vcpu->arch.guest_state_protected &&
+           kvm_ioctl_accesses_guest_state(ioctl))
+               return -EINVAL;
+
        vcpu_load(vcpu);
 
        u.buffer = NULL;

It'll be a much smaller diff, and hopefully easier to audit, too.

