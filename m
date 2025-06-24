Return-Path: <kvm+bounces-50433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD3EAE58AA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 02:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 034863BEDC2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516F7158535;
	Tue, 24 Jun 2025 00:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TCnTzvh/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CF835948
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 00:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750725507; cv=none; b=bzbUVP9wol4AZnREqNiBtuNqaINpnEgEfw+MZQ4IC3PH5SuwclkVhDVYxaNCykqqtamebNFGFBzJlOyRC3vQboM8Ri4G0MaCUKXGqmwvflKKDoY+CHfMIvRx61X2VqJupIqWCF+YoHLZx1RkVjd/42jQjgnjlsAF7QALEgpqeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750725507; c=relaxed/simple;
	bh=NiQRuIcHsQ0Cgvtb3vovHjrFy7PBOudeCtb9v3hkTEA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZEMGxISFiLI8dxrQij5NkB9jft9vK0QOVx5YYpcHmPyyfWYM97Jz6ZvgndCgz6RydTmwa2OiKONlrTVQ3BoJcxcqUciyObVTsyZEK5UDamFDj6nLObalLRzOx9ohUbUPCJ+kSangBzKBFvgrqt3q+mkvyL8ys7g/tas4q+o7gh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TCnTzvh/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso4733013a91.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 17:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750725505; x=1751330305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eAlXIseVh19piNu6gk6mEwFZ2IjANsPe2ugycEc3BFc=;
        b=TCnTzvh/3VHxh1TLQOsXGhwlFaclPYPnLkaLqhWI9DO4MS7SylQq69i+zowPBGySK1
         IiJ54TsT3vmJVbWYKUXyA/FQB5vFOcQY6S6157P/N8W6XOVmNChDhJyf2beFytnOYpRm
         Ss9vJlNcmix1q/oFnScSmEYm0h0hmlyststnoggSOS+4OBKyu1q4fNhWVVWbDw5Y5hJc
         Q2yluKh27urqzDTaWzcMXi+3RBjgXh/FzUv1E5Hya3p7SPxubJzW81MgsDLYIbUKpjch
         pwldTS2YXCr4fdSN3Ein0eRedq8rAr1+dcRCv4fvEHaHP1xUGksUOZ2srB6c400VaBOZ
         p2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750725505; x=1751330305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAlXIseVh19piNu6gk6mEwFZ2IjANsPe2ugycEc3BFc=;
        b=joBMBPwJ/1hJjN4TwqUYHiUanb7LqUQfl4/nJsa5CAttrvkIFYhTOmlQR7TWcGymWj
         QJu/dx885GFV4vGXY84XHP1PA07Qai8jU8Kt9E2DJUYBJbQ+lwjgl5Eh6Uz51UrZZPJA
         EmuifvFHVVsJs04Y/e0w1A8gzwoO1HwSqtVPjH52mNU8Z6MJEX0V31DsdI/d7WTMdaio
         fZ5HuPG5MoLCIimo6YZ7GmSeimDdfi5YMfzAf92f0SAgmb+kNXEfwdIIZQWPCwSOpi7B
         1Yh1x6Pw2e+UNWvYpLOFz/G0hpbxxA75fuEVxmFH6P3m1HEee2ShJ9qOEZmBP1118Oul
         RtyA==
X-Gm-Message-State: AOJu0Yysq9oJefrsHiPzldzVk0fbMzdh4PHwKsY4TAwAHv30eWt61HPC
	NR8E6YpsWcI04/V3eGEvsI/+oGjnNnUVaD3rF/1NuXv55wk7nQz/Ky+y0YhlmPR+VwUQm4NSLid
	7u3qyfg==
X-Google-Smtp-Source: AGHT+IHHRf87rQwnQulOsm3e/FzPSQBtizfZ6M0H4DR+wWAWS91/f1ukDkOeZDacaT2Hyk/M5EpK972/7Sc=
X-Received: from pjboi14.prod.google.com ([2002:a17:90b:3a0e:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3802:b0:312:e8ed:758
 with SMTP id 98e67ed59e1d1-3159d64cb4cmr23739595a91.13.1750725505137; Mon, 23
 Jun 2025 17:38:25 -0700 (PDT)
Date: Mon, 23 Jun 2025 17:38:23 -0700
In-Reply-To: <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740036492.git.naveen@kernel.org> <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
Message-ID: <aFnzf4SQqc9a2KcK@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 20, 2025, Naveen N Rao (AMD) wrote:
> KVM allows VMMs to specify the maximum possible APIC ID for a virtual
> machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
> structures related to APIC/x2APIC. Utilize the same to set the AVIC
> physical max index in the VMCB, similar to VMX. This helps hardware
> limit the number of entries to be scanned in the physical APIC ID table
> speeding up IPI broadcasts for virtual machines with smaller number of
> vcpus.
> 
> The minimum allocation required for the Physical APIC ID table is one 4k
> page supporting up to 512 entries. With AVIC support for 4096 vcpus
> though, it is sufficient to only allocate memory to accommodate the
> AVIC physical max index that will be programmed into the VMCB. Limit
> memory allocated for the Physical APIC ID table accordingly.

Can you flip the order of the patches?  This seems like an easy "win" for
performance, and so I can see people wanting to backport this to random kernels
even if they don't care about running 4k vCPUs.

Speaking of which, is there a measurable performance win?

> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/kvm/svm/avic.c | 53 ++++++++++++++++++++++++++++++-----------
>  arch/x86/kvm/svm/svm.c  |  6 +++++
>  arch/x86/kvm/svm/svm.h  |  1 +
>  3 files changed, 46 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1fb322d2ac18..dac4a6648919 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -85,6 +85,17 @@ struct amd_svm_iommu_ir {
>  	void *data;		/* Storing pointer to struct amd_ir_data */
>  };
>  
> +static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool is_x2apic)

Formletter incoming...

Do not use "inline" for functions that are visible only to the local compilation
unit.  "inline" is just a hint, and modern compilers are smart enough to inline
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

> +{
> +	u32 avic_max_physical_id = is_x2apic ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;

Don't use a super long local variable.  For a helper like this, it's unnecessary,
e.g. if the reader can't understand what arch_max or max_id is, then spelling it
out entirely probably won't help them.

And practically, there's a danger to using long names like this: you're much more
likely to unintentionally "shadow" a global variable.  Functionally, it won't be
a problem, but it can create confusion.  E.g. if we ever added a global
avic_max_physical_id, then this code would get rather confusing.

> +
> +	/*
> +	 * Assume vcpu_id is the same as APIC ID. Per KVM_CAP_MAX_VCPU_ID, max_vcpu_ids
> +	 * represents the max APIC ID for this vm, rather than the max vcpus.
> +	 */
> +	return min(kvm->arch.max_vcpu_ids - 1, avic_max_physical_id);
> +}
> +
>  static void avic_activate_vmcb(struct vcpu_svm *svm)
>  {
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  	 */
>  	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
>  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> -		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
> +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);

Don't pass hardcoded booleans when it is at all possible to do something else.
For this case, I would either do:

  static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
  {
	u32 arch_max;
	
	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
		arch_max = x2avic_max_physical_id;
	else
		arch_max = AVIC_MAX_PHYSICAL_ID;

	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
  }

  static void avic_activate_vmcb(struct vcpu_svm *svm)
  {
	struct vmcb *vmcb = svm->vmcb01.ptr;
	struct kvm_vcpu *vcpu = &svm->vcpu;

	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);

	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
	vmcb->control.avic_physical_id |= avic_get_max_physical_id(vcpu);

	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;

	/*
	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
	 * accesses, while interrupt injection to a running vCPU can be
	 * achieved using AVIC doorbell.  KVM disables the APIC access page
	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
	 * AVIC in hybrid mode activates only the doorbell mechanism.
	 */
	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic)) {
		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
		/* Disabling MSR intercept for x2APIC registers */
		svm_set_x2apic_msr_interception(svm, false);
	} else {
		/*
		 * Flush the TLB, the guest may have inserted a non-APIC
		 * mapping into the TLB while AVIC was disabled.
		 */
		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);

		/* Enabling MSR intercept for x2APIC registers */
		svm_set_x2apic_msr_interception(svm, true);
	}
  }

or


  static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu, u32 arch_max)
  {
	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
  }

  static void avic_activate_vmcb(struct vcpu_svm *svm)
  {
	struct vmcb *vmcb = svm->vmcb01.ptr;
	struct kvm_vcpu *vcpu = &svm->vcpu;
	u32 max_id;

	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;

	/*
	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
	 * accesses, while interrupt injection to a running vCPU can be
	 * achieved using AVIC doorbell.  KVM disables the APIC access page
	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
	 * AVIC in hybrid mode activates only the doorbell mechanism.
	 */
	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic)) {
		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
		max_id = avic_get_max_physical_id(vcpu, x2avic_max_physical_id);

		/* Disabling MSR intercept for x2APIC registers */
		svm_set_x2apic_msr_interception(svm, false);
	} else {
		max_id = avic_get_max_physical_id(vcpu, AVIC_MAX_PHYSICAL_ID);
		/*
		 * Flush the TLB, the guest may have inserted a non-APIC
		 * mapping into the TLB while AVIC was disabled.
		 */
		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);

		/* Enabling MSR intercept for x2APIC registers */
		svm_set_x2apic_msr_interception(svm, true);
	}

	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
	vmcb->control.avic_physical_id |= max_id;
  }


I don't think I have a preference between the two?

>  		/* Disabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, false);
>  	} else {
> @@ -114,7 +125,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
>  
>  		/* For xAVIC and hybrid-xAVIC modes */
> -		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, false);
>  		/* Enabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, true);
>  	}
> @@ -174,6 +185,12 @@ int avic_ga_log_notifier(u32 ga_tag)
>  	return 0;
>  }
>  
> +static inline int avic_get_physical_id_table_order(struct kvm *kvm)

Heh, we got there eventually ;-)

> +{
> +	/* Limit to the maximum physical ID supported in x2avic mode */
> +	return get_order((avic_get_max_physical_id(kvm, true) + 1) * sizeof(u64));
> +}
> +
>  void avic_vm_destroy(struct kvm *kvm)
>  {
>  	unsigned long flags;
> @@ -186,7 +203,7 @@ void avic_vm_destroy(struct kvm *kvm)
>  		__free_page(kvm_svm->avic_logical_id_table_page);
>  	if (kvm_svm->avic_physical_id_table_page)
>  		__free_pages(kvm_svm->avic_physical_id_table_page,
> -			     get_order(sizeof(u64) * (x2avic_max_physical_id + 1)));
> +			     avic_get_physical_id_table_order(kvm));
>  
>  	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
>  	hash_del(&kvm_svm->hnode);
> @@ -199,22 +216,12 @@ int avic_vm_init(struct kvm *kvm)
>  	int err = -ENOMEM;
>  	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
>  	struct kvm_svm *k2;
> -	struct page *p_page;
>  	struct page *l_page;
> -	u32 vm_id, entries;
> +	u32 vm_id;
>  
>  	if (!enable_apicv)
>  		return 0;
>  
> -	/* Allocating physical APIC ID table */
> -	entries = x2avic_max_physical_id + 1;
> -	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
> -			     get_order(sizeof(u64) * entries));
> -	if (!p_page)
> -		goto free_avic;
> -
> -	kvm_svm->avic_physical_id_table_page = p_page;
> -
>  	/* Allocating logical APIC ID table (4KB) */
>  	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  	if (!l_page)
> @@ -265,6 +272,24 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>  		avic_deactivate_vmcb(svm);
>  }
>  
> +int avic_alloc_physical_id_table(struct kvm *kvm)
> +{
> +	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
> +	struct page *p_page;
> +
> +	if (kvm_svm->avic_physical_id_table_page || !enable_apicv || !irqchip_in_kernel(kvm))
> +		return 0;
> +
> +	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
> +			     avic_get_physical_id_table_order(kvm));
> +	if (!p_page)
> +		return -ENOMEM;
> +
> +	kvm_svm->avic_physical_id_table_page = p_page;
> +
> +	return 0;
> +}
> +
>  static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>  				       unsigned int index)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8aa0f36850f..3cb23298cdc3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1423,6 +1423,11 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
>  	svm->vmcb = target_vmcb->ptr;
>  }
>  
> +static int svm_vcpu_precreate(struct kvm *kvm)
> +{
> +	return avic_alloc_physical_id_table(kvm);

Why is allocation being moved to svm_vcpu_precreate()?

