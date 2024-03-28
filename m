Return-Path: <kvm+bounces-12934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A975988F575
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EC77B2363E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C0828DAE;
	Thu, 28 Mar 2024 02:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e0ymFvgF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D053224D0
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594010; cv=none; b=FxYHAuBAMrdWaQuBNkyHjrUHEAwPc3oWm4pEeXZOYvT5u42ziyn1848RQA3MLb99rrkXxU37/1CMWlH5df/z6C/rDrFCzY0XYALCVI9s33VfOmZlDD2MYIGAmRBXgo27Ml0lDfeWp4nxkcI5yTb3PPROTOvDsZ59b/G/glL/yOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594010; c=relaxed/simple;
	bh=9BOoH6hdhq2GMEqJg6PYX/st7Tx9CoXPoI9OyUwcvFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BP4TNuiX3Yhphf16azzzlOnSIyUot+e/yNxNJ6bb+5RoIgoobfZ4pe1bAeLXssrgUYKERMgHpPQLfrVWeRkDZMuhCxwQjcOgU5XRJDV6IBMXbkgAgX/TL9QCVN0X865GFf/DZ5/StBeCxMUzVKdxx56J6xtdEZMBNJaTb+6wzDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e0ymFvgF; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cd62fa20fso10124867b3.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594006; x=1712198806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKiAJm8Q8iB+Wt0WdpshK3b6gxH7JKOQJDiRSonhUcU=;
        b=e0ymFvgF6o7ZcH2D1qSJ7F+ZKFnxpUIs2G4Ty50jeNUPwFCtTGszPXZ/aoJrF+lU34
         UXdXIZeSydALVBTeDtD5DQuOZZgkP4dVH0XWSCwmqX8K7b+PQxf4LOgUPC+brF3w14mE
         VRIvqAQlX3L0Mbz9oR0DSuWeMVzvXkxsTzOFa27ZvTyNAjn42jz5zi545RpU/S3PZR5f
         XhEywfGt1A8t1kTVZ/xXBgRQNLuoQh4yBA5NIHqb4u7NwAuyWWxuneeNot8Fsm3WPKvH
         vooi7BrAi+qhkJUPszmi+tj/r5vOZwORIl66u8BOJH5fikceyA95gIq4Iqgke5YwKwVn
         mjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594006; x=1712198806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MKiAJm8Q8iB+Wt0WdpshK3b6gxH7JKOQJDiRSonhUcU=;
        b=EyhqSaxMrwtYwwarTm/t0L4pOqxnYpf6xrzZ3Md2q8EYws2SftuQOgXK56fUIgItTy
         tXArqORIGyUB7M3AxbdnB6sNOBmGl1aN7r5hPsV6CkMNHOL1itp35/2IoU/Q9hns3du7
         a1+Zdo9jKAagqzvreTEWEMxIV6itdxo2f73oSfbPwP7rNL/XGF0cmDEnh4cy7q6ipBOw
         dngiMs9pXK4p4twFpAoELlzQ02pUkYvW2EPp8gw421ki2ntVE4U7cUEv8AF37MVuGdcL
         mSr46DzXJB+/XEuNFEaNMATw76yNoZfffqcbLguqJwn/sEbyWPNLCELZZ6T6cYY/zWcI
         Lu9w==
X-Forwarded-Encrypted: i=1; AJvYcCW+/E6KZPsDbxhiUwRM/zattEormLJ2Gb8yaJr76sWpoDFU6uGyLzu3qHIDj+WQWx58hN2Z9dHcIkYkq2fJ0FD1R2D6
X-Gm-Message-State: AOJu0YwZqHHavBdwF9v+buHd7YnPZgctOP038vjbfgJTIjJZqqMFRuw+
	5qOUCkKyvPZnnopANRyzz/6CgcJ4On/R5eCbxdNAIkk4Sh3tVmgw+Dw78sen+my6pWPDaf/r17f
	SJi9Q/Cofs4Xtea4vRkD8yw==
X-Google-Smtp-Source: AGHT+IFSCWFJE1auZT8THqm2oY2Dx+YqOporeLaOujsrGmQyE8RcrWBacYp5J1EKOaZWBxZBJ/mkELIRhdBsampHUQ==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a81:f203:0:b0:611:2c40:e8d0 with SMTP
 id i3-20020a81f203000000b006112c40e8d0mr286843ywm.3.1711594006693; Wed, 27
 Mar 2024 19:46:46 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:46:42 +0000
In-Reply-To: <20240314232637.2538648-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-11-seanjc@google.com>
Message-ID: <diqzwmpnkr8t.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 10/18] KVM: selftests: Init IDT and exception handlers for
 all VMs/vCPUs on x86
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Initialize the IDT and exception handlers for all non-barebones VMs and
> vCPUs on x86.  Forcing tests to manually configure the IDT just to save
> 8KiB of memory is a terrible tradeoff, and also leads to weird tests
> (multiple tests have deliberately relied on shutdown to indicate success),
> and hard-to-debug failures, e.g. instead of a precise unexpected exception
> failure, tests see only shutdown.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 --
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 8 ++++++--
>  tools/testing/selftests/kvm/x86_64/amx_test.c             | 2 --
>  tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c   | 2 --
>  tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c         | 2 --
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c      | 6 ------
>  tools/testing/selftests/kvm/x86_64/hyperv_ipi.c           | 3 ---
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 3 ---
>  tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c   | 3 ---
>  tools/testing/selftests/kvm/x86_64/platform_info_test.c   | 3 ---
>  tools/testing/selftests/kvm/x86_64/pmu_counters_test.c    | 3 ---
>  .../testing/selftests/kvm/x86_64/pmu_event_filter_test.c  | 6 ------
>  .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c        | 3 ---
>  tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c     | 3 ---
>  .../selftests/kvm/x86_64/svm_nested_shutdown_test.c       | 3 ---
>  .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c    | 3 ---
>  tools/testing/selftests/kvm/x86_64/ucna_injection_test.c  | 4 ----
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 3 ---
>  .../kvm/x86_64/vmx_exception_with_invalid_guest_state.c   | 3 ---
>  tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c    | 3 ---
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 --
>  tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c      | 3 ---
>  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c      | 2 --
>  23 files changed, 6 insertions(+), 69 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index d6ffe03c9d0b..4804abe00158 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -1129,8 +1129,6 @@ struct idt_entry {
>  	uint32_t offset2; uint32_t reserved;
>  };
>  
> -void vm_init_descriptor_tables(struct kvm_vm *vm);
> -void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
>  void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  			void (*handler)(struct ex_regs *));
>  
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index d6bfe96a6a77..5813d93b2e7c 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -540,7 +540,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  	kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
> -void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
> +static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vm *vm = vcpu->vm;
>  	struct kvm_sregs sregs;
> @@ -585,6 +585,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> +
> +	vcpu_init_descriptor_tables(vcpu);
>  }
>  
>  static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
> @@ -638,7 +640,7 @@ void route_exception(struct ex_regs *regs)
>  		     regs->vector, regs->rip);
>  }
>  
> -void vm_init_descriptor_tables(struct kvm_vm *vm)
> +static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  {
>  	extern void *idt_handlers;
>  	int i;
> @@ -670,6 +672,8 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
>  void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  {
>  	vm_create_irqchip(vm);
> +	vm_init_descriptor_tables(vm);
> +
>  	sync_global_to_guest(vm, host_cpu_is_intel);
>  	sync_global_to_guest(vm, host_cpu_is_amd);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
> index eae521f050e0..ab6c31aee447 100644
> --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> @@ -246,8 +246,6 @@ int main(int argc, char *argv[])
>  	vcpu_regs_get(vcpu, &regs1);
>  
>  	/* Register #NM handler */
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
>  	vm_install_exception_handler(vm, NM_VECTOR, guest_nm_handler);
>  
>  	/* amx cfg for guest_code */
> diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> index f3c2239228b1..762628f7d4ba 100644
> --- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> @@ -110,8 +110,6 @@ static void test_fix_hypercall(struct kvm_vcpu *vcpu, bool disable_quirk)
>  {
>  	struct kvm_vm *vm = vcpu->vm;
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
>  	vm_install_exception_handler(vcpu->vm, UD_VECTOR, guest_ud_handler);
>  
>  	if (disable_quirk)
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
> index 4c7257ecd2a6..4238691a755c 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
> @@ -258,8 +258,6 @@ int main(int argc, char *argv[])
>  	vcpu_args_set(vcpu, 3, vmx_pages_gva, hv_pages_gva, addr_gva2gpa(vm, hcall_page));
>  	vcpu_set_msr(vcpu, HV_X64_MSR_VP_INDEX, vcpu->id);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
>  	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
>  	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index b923a285e96f..068e9c69710d 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -156,9 +156,6 @@ static void guest_test_msrs_access(void)
>  			vcpu_init_cpuid(vcpu, prev_cpuid);
>  		}
>  
> -		vm_init_descriptor_tables(vm);
> -		vcpu_init_descriptor_tables(vcpu);
> -
>  		/* TODO: Make this entire test easier to maintain. */
>  		if (stage >= 21)
>  			vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_SYNIC2, 0);
> @@ -532,9 +529,6 @@ static void guest_test_hcalls_access(void)
>  	while (true) {
>  		vm = vm_create_with_one_vcpu(&vcpu, guest_hcall);
>  
> -		vm_init_descriptor_tables(vm);
> -		vcpu_init_descriptor_tables(vcpu);
> -
>  		/* Hypercall input/output */
>  		hcall_page = vm_vaddr_alloc_pages(vm, 2);
>  		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> index f1617762c22f..c6a03141cdaa 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> @@ -256,16 +256,13 @@ int main(int argc, char *argv[])
>  	hcall_page = vm_vaddr_alloc_pages(vm, 2);
>  	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
>  
> -	vm_init_descriptor_tables(vm);
>  
>  	vcpu[1] = vm_vcpu_add(vm, RECEIVER_VCPU_ID_1, receiver_code);
> -	vcpu_init_descriptor_tables(vcpu[1]);
>  	vcpu_args_set(vcpu[1], 2, hcall_page, addr_gva2gpa(vm, hcall_page));
>  	vcpu_set_msr(vcpu[1], HV_X64_MSR_VP_INDEX, RECEIVER_VCPU_ID_1);
>  	vcpu_set_hv_cpuid(vcpu[1]);
>  
>  	vcpu[2] = vm_vcpu_add(vm, RECEIVER_VCPU_ID_2, receiver_code);
> -	vcpu_init_descriptor_tables(vcpu[2]);
>  	vcpu_args_set(vcpu[2], 2, hcall_page, addr_gva2gpa(vm, hcall_page));
>  	vcpu_set_msr(vcpu[2], HV_X64_MSR_VP_INDEX, RECEIVER_VCPU_ID_2);
>  	vcpu_set_hv_cpuid(vcpu[2]);
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> index 9e2879af7c20..cef0bd80038b 100644
> --- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> @@ -146,9 +146,6 @@ int main(void)
>  
>  	vcpu_clear_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	enter_guest(vcpu);
>  	kvm_vm_free(vm);
>  }
> diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> index 853802641e1e..9c8445379d76 100644
> --- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> @@ -80,9 +80,6 @@ int main(int argc, char *argv[])
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	while (1) {
>  		vcpu_run(vcpu);
>  		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> index 6300bb70f028..9cf2b9fbf459 100644
> --- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> @@ -51,9 +51,6 @@ int main(int argc, char *argv[])
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	msr_platform_info = vcpu_get_msr(vcpu, MSR_PLATFORM_INFO);
>  	vcpu_set_msr(vcpu, MSR_PLATFORM_INFO,
>  		     msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 29609b52f8fa..ff6d21d148de 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -31,9 +31,6 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>  	struct kvm_vm *vm;
>  
>  	vm = vm_create_with_one_vcpu(vcpu, guest_code);
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(*vcpu);
> -
>  	sync_global_to_guest(vm, kvm_pmu_version);
>  	sync_global_to_guest(vm, is_forced_emulation_enabled);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 3c85d1ae9893..5cbe9d331acb 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -337,9 +337,6 @@ static void test_pmu_config_disable(void (*guest_code)(void))
>  	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
>  
>  	vcpu = vm_vcpu_add(vm, 0, guest_code);
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	TEST_ASSERT(!sanity_check_pmu(vcpu),
>  		    "Guest should not be able to use disabled PMU.");
>  
> @@ -876,9 +873,6 @@ int main(int argc, char *argv[])
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	TEST_REQUIRE(sanity_check_pmu(vcpu));
>  
>  	if (use_amd_pmu())
> diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> index 416207c38a17..0d682d6b76f1 100644
> --- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> @@ -60,9 +60,6 @@ int main(int argc, char *argv[])
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	vcpu_args_set(vcpu, 1, kvm_is_tdp_enabled());
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, MAXPHYADDR);
>  
>  	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
> index 32bef39bec21..916e04248fbb 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
> @@ -93,9 +93,6 @@ int main(int argc, char *argv[])
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vm_install_exception_handler(vm, VINTR_IRQ_NUMBER, vintr_irq_handler);
>  	vm_install_exception_handler(vm, INTR_IRQ_NUMBER, intr_irq_handler);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> index f4a1137e04ab..00135cbba35e 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> @@ -48,9 +48,6 @@ int main(int argc, char *argv[])
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vcpu_alloc_svm(vm, &svm_gva);
>  
>  	vcpu_args_set(vcpu, 2, svm_gva, vm->arch.idt);
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> index 2478a9e50743..7b6481d6c0d3 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> @@ -152,9 +152,6 @@ static void run_test(bool is_nmi)
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
>  	vm_install_exception_handler(vm, BP_VECTOR, guest_bp_handler);
>  	vm_install_exception_handler(vm, INT_NR, guest_int_handler);
> diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> index bc9be20f9600..6eeb5dd1e65c 100644
> --- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> @@ -284,10 +284,6 @@ int main(int argc, char *argv[])
>  	cmcidis_vcpu = create_vcpu_with_mce_cap(vm, 1, false, cmci_disabled_guest_code);
>  	cmci_vcpu = create_vcpu_with_mce_cap(vm, 2, true, cmci_enabled_guest_code);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(ucna_vcpu);
> -	vcpu_init_descriptor_tables(cmcidis_vcpu);
> -	vcpu_init_descriptor_tables(cmci_vcpu);
>  	vm_install_exception_handler(vm, CMCI_VECTOR, guest_cmci_handler);
>  	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> index f4f61a2d2464..fffda40e286f 100644
> --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> @@ -531,9 +531,6 @@ KVM_ONE_VCPU_TEST(user_msr, msr_filter_allow, guest_code_filter_allow)
>  
>  	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_allow);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
>  
>  	/* Process guest code userspace exits. */
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
> index fad3634fd9eb..3fd6eceab46f 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
> @@ -115,9 +115,6 @@ int main(int argc, char *argv[])
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	get_set_sigalrm_vcpu(vcpu);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
>  
>  	/*
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index ea0cb3cae0f7..1b6e20e3a56d 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -86,9 +86,6 @@ KVM_ONE_VCPU_TEST(vmx_pmu_caps, guest_wrmsr_perf_capabilities, guest_code)
>  	struct ucall uc;
>  	int r, i;
>  
> -	vm_init_descriptor_tables(vcpu->vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
>  
>  	vcpu_args_set(vcpu, 1, host_cap.capabilities);
> diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> index 725c206ba0b9..f51084061134 100644
> --- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> @@ -410,8 +410,6 @@ int main(int argc, char *argv[])
>  
>  	vm = vm_create_with_one_vcpu(&params[0].vcpu, halter_guest_code);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(params[0].vcpu);
>  	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
>  
>  	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> index 25a0b0db5c3c..95ce192d0753 100644
> --- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> @@ -109,9 +109,6 @@ int main(int argc, char *argv[])
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	run = vcpu->run;
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
> -
>  	while (1) {
>  		vcpu_run(vcpu);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> index d2ea0435f4f7..a7236f17dfd0 100644
> --- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> @@ -553,8 +553,6 @@ int main(int argc, char *argv[])
>  	};
>  	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &vec);
>  
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vcpu);
>  	vm_install_exception_handler(vm, EVTCHN_VECTOR, evtchn_handler);
>  
>  	if (do_runstate_tests) {
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

