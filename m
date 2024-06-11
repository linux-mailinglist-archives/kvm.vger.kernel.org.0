Return-Path: <kvm+bounces-19271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 424A9902D86
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2AC21F22BE0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEA7BE78;
	Tue, 11 Jun 2024 00:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CiLFzm4w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5A17FF
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065323; cv=none; b=aODXyd67I4/7QCLmTDaJMY1uTqqni6WobQ2W29A972b2Uxc1vmKPAWF0+sf9pOJ8UwQ22dZG55B9he/wx8kj9AT8+oy0Pd70esdq/sJ3E+Y9M749WhG0nqSsD2wEYWUkKGwKMRonsqyUZvG3MW2Mm7SoGqABfohA8o4rzrYqBN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065323; c=relaxed/simple;
	bh=oS1Hvez5sA7LSPE446f6TZ4Jeo1f2nqSdvepYSaw6dk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FvuGfPw1D4AB0d8OYS0CcVePyWdHCIs8E4HrKRkQddQFsUt3k4gNok37nre5g4k4wYEF1jK7YnWkWBjTyv+U1PtY5VDboLx2k3fFCVzq0mmIeLfbf3W2j0GxRBd9UjU8wryje4Pexd7gMyeQhXnXe+raZcgtSBHALTaedB74MEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CiLFzm4w; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78acd5bbbso9012558276.1
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065321; x=1718670121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tSfrTQEO+boV0tcg4fzpJ40AhwinPFP7IWz6IBIfER8=;
        b=CiLFzm4wROzC65YN0NiJocwCsp1VYlHntyCc4188A8ghF48vngND7ohMXBPQnM64q7
         LgJ0k3F62HMHUc0C7VDp3nwF0IR/UYTaPJXYLYJdAGnenSfmwbkrrTlIr1+8BAXYJB1Q
         zKq8AA2IN8+hwWfnSL3YwaI7+gVM1wZ1i7w/3tfaRFWI6JbPZYL8k9ObrLufrVU6qrYz
         xd6Sa85Nl4Cb9JGybe9nk8mgzYrTsI71ZeqOoTxk1fNtCS7xBB3+KXEHEV4FuiYebGPY
         lS4EIlw/dSfEqvupO93RwU+bddvGPkCVh7affQPTYLzyV/O6d3q7Jff0lQ0E9JkN492+
         zjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065321; x=1718670121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tSfrTQEO+boV0tcg4fzpJ40AhwinPFP7IWz6IBIfER8=;
        b=iFv2xtJP6MAvWxA9iAhoAyeoaTv3oXEx5NNzTbgKpWHo7/YV69K6cLrUcwuvrQj9vS
         0ZcA/xspVScJ4+E08WRzdhHj4w3EfvszZRaAoWnYkt4uo/e4J8rUnVNG1YVSOwzdL43w
         ut5+hdZ4cnAhLp4l2Nq6+rXEWwo8THYvWBxHYMjvFOWhh0dUueucAbJ5htR2oXYcS7Ma
         FC5Wghe8CBK6Qti7nbwywbU2HIgM0NnBnA7cGXO1tf79MXF9epMh9HDGJGMQaMBZSCBq
         XEDdlNwNx9hLHl03zjEJqE4EtqqAASkdbzIvAcSeQ0HCchVanNGVXZNMoc2mvVHIz7em
         lldQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxU2OZKs6LRI+C0t27rqszYyCYSQPOtaSMh9DGceuCW1sOg0pHVHLfxQvr5a8JEzyu/VESIqpeDuSKeJBOi1Bmq82M
X-Gm-Message-State: AOJu0YzdTsruESrYqqq0niNodt/IBY4ef46aw7E+aBDw2lWLeK9odz/d
	3AgClsV9O8sRLIq1C4LJWwpFoM9M8yJhKQzEgzmLSSbHLd8ES51WYRADK83njhPda9RdqWSI21r
	Vqw==
X-Google-Smtp-Source: AGHT+IGQJBJFkotW2vsOmbzwfrFZdll5ruBgmE5Wy0gcHaY5UPMHPJLdSb7fePIylsTHu3oFBkLPivwSMf0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b13:b0:dfa:b47e:b99f with SMTP id
 3f1490d57ef6-dfb1c346c78mr644443276.2.1718065320730; Mon, 10 Jun 2024
 17:22:00 -0700 (PDT)
Date: Mon, 10 Jun 2024 17:21:59 -0700
In-Reply-To: <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718043121.git.reinette.chatre@intel.com> <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
Message-ID: <ZmeYp8Sornz36ZkO@google.com>
Subject: Re: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 10, 2024, Reinette Chatre wrote:
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 8eb57de0b587..b473f210ba6c 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -23,6 +23,7 @@
>  
>  extern bool host_cpu_is_intel;
>  extern bool host_cpu_is_amd;
> +extern unsigned int tsc_khz;
>  
>  /* Forced emulation prefix, used to invoke the emulator unconditionally. */
>  #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
> @@ -815,6 +816,20 @@ static inline void cpu_relax(void)
>  	asm volatile("rep; nop" ::: "memory");
>  }
>  
> +static inline void udelay(unsigned long usec)

uint64_t instead of unsigned long?  Practically speaking it doesn't change anything,
but I don't see any reason to mix "unsigned long" and "uint64_t", e.g. the max
delay isn't a property of the address space.

> +{
> +	unsigned long cycles = tsc_khz / 1000 * usec;
> +	uint64_t start, now;
> +
> +	start = rdtsc();
> +	for (;;) {
> +		now = rdtsc();
> +		if (now - start >= cycles)
> +			break;
> +		cpu_relax();
> +	}
> +}
> +
>  #define ud2()			\
>  	__asm__ __volatile__(	\
>  		"ud2\n"	\
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index c664e446136b..ff579674032f 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -25,6 +25,7 @@ vm_vaddr_t exception_handlers;
>  bool host_cpu_is_amd;
>  bool host_cpu_is_intel;
>  bool is_forced_emulation_enabled;
> +unsigned int tsc_khz;

Slight preference for uint32_t, mostly because KVM stores its version as a u32.

>  static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
>  {
> @@ -616,6 +617,8 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  {
> +	int r;
> +
>  	vm_create_irqchip(vm);
>  	vm_init_descriptor_tables(vm);
>  
> @@ -628,6 +631,15 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  
>  		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
>  	}
> +
> +	if (kvm_has_cap(KVM_CAP_GET_TSC_KHZ)) {

I think we should make this a TEST_REQUIRE(), or maybe even a TEST_ASSERT().
Support for KVM_GET_TSC_KHZ predates KVM selftests by 7+ years.

> +		r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
> +		if (r < 0)

Heh, the docs are stale.  KVM hasn't returned an error since commit cc578287e322
("KVM: Infrastructure for software and hardware based TSC rate scaling"), which
again predates selftests by many years (6+ in this case).  To make our lives
much simpler, I think we should assert that KVM_GET_TSC_KHZ succeeds, and maybe
throw in a GUEST_ASSERT(thz_khz) in udelay()?

E.g. as is, if KVM_GET_TSC_KHZ is allowed to fail, then we risk having to deal
with weird failures due to udelay() unexpectedly doing nothing.


> +			tsc_khz = 0;
> +		else
> +			tsc_khz = r;
> +		sync_global_to_guest(vm, tsc_khz);
> +	}
>  }
>  
>  void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
> -- 
> 2.34.1
> 

