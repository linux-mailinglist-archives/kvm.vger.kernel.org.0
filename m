Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688295232E0
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242135AbiEKMSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242263AbiEKMS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A3156339D
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ME2zsSNaj/BQ01tZRxmP+mYKSskS2M5xFPkqXjK2tao=;
        b=hZx2ODrvOllCZXiR1bwIkI3ETEUeokpoSLm/afqPriwZU0SpWX9MFlPshfj/Hudefg3CcT
        0CZvhnSjyToQLktUSpttxxOr/OnX+ccA3W5x+EchfKNTUb2qxQOGizKbIuctKrzw/nl9y2
        Al/9GLbG8uWJSpl6iGjZSIa9KgbQbwU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-SyecFMT_NWeKzToXEP_maQ-1; Wed, 11 May 2022 08:18:24 -0400
X-MC-Unique: SyecFMT_NWeKzToXEP_maQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 942121C01B25;
        Wed, 11 May 2022 12:18:23 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50942438EDC;
        Wed, 11 May 2022 12:18:21 +0000 (UTC)
Message-ID: <0336b4400be2f94085b85c283c372b3d9efe040f.camel@redhat.com>
Subject: Re: [PATCH v3 31/34] KVM: selftests: evmcs_test: Introduce L2 TLB
 flush test
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:18:20 +0300
In-Reply-To: <20220414132013.1588929-32-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-32-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> Enable Hyper-V L2 TLB flush and check that Hyper-V TLB flush hypercalls
> from L2 don't exit to L1 unless 'TlbLockCount' is set in the
> Partition assist page.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/evmcs.h      |  2 +
>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 52 ++++++++++++++++++-
>  2 files changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> index 9c965ba73dec..36c0a67d8602 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> @@ -252,6 +252,8 @@ struct hv_enlightened_vmcs {
>  #define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK	\
>  		(~((1ull << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT) - 1))
>  
> +#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
> +
>  extern struct hv_enlightened_vmcs *current_evmcs;
>  extern struct hv_vp_assist_page *current_vp_assist;
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index d12e043aa2ee..8d2aa7600d78 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -16,6 +16,7 @@
>  
>  #include "kvm_util.h"
>  
> +#include "hyperv.h"
>  #include "vmx.h"
>  
>  #define VCPU_ID		5
> @@ -49,6 +50,16 @@ static inline void rdmsr_gs_base(void)
>  			      "r13", "r14", "r15");
>  }
>  
> +static inline void hypercall(u64 control, vm_vaddr_t arg1, vm_vaddr_t arg2)
> +{
> +	asm volatile("mov %3, %%r8\n"
> +		     "vmcall"
> +		     : "+c" (control), "+d" (arg1)
> +		     :  "r" (arg2)
> +		     : "cc", "memory", "rax", "rbx", "r8", "r9", "r10",
> +		       "r11", "r12", "r13", "r14", "r15");
> +}

I see duplicated code, I complain ;-)

> +
>  void l2_guest_code(void)
>  {
>  	GUEST_SYNC(7);
> @@ -67,15 +78,27 @@ void l2_guest_code(void)
>  	vmcall();
>  	rdmsr_gs_base(); /* intercepted */
>  
> +	/* L2 TLB flush tests */
> +	hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +		  HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +	rdmsr_fs_base();
> +	hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +		  HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +	/* Make sure we're no issuing Hyper-V TLB flush call again */
> +	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");
> +
>  	/* Done, exit to L1 and never come back.  */
>  	vmcall();
>  }
>  
> -void guest_code(struct vmx_pages *vmx_pages)
> +void guest_code(struct vmx_pages *vmx_pages, vm_vaddr_t pgs_gpa)
>  {
>  #define L2_GUEST_STACK_SIZE 64
>  	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>  
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> +
>  	x2apic_enable();
>  
>  	GUEST_SYNC(1);
> @@ -105,6 +128,14 @@ void guest_code(struct vmx_pages *vmx_pages)
>  	vmwrite(PIN_BASED_VM_EXEC_CONTROL, vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
>  		PIN_BASED_NMI_EXITING);
>  
> +	/* L2 TLB flush setup */
> +	current_evmcs->partition_assist_page = vmx_pages->partition_assist_gpa;
> +	current_evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
> +	current_evmcs->hv_vm_id = 1;
> +	current_evmcs->hv_vp_id = 1;
> +	current_vp_assist->nested_control.features.directhypercall = 1;
> +	*(u32 *)(vmx_pages->partition_assist) = 0;
> +
>  	GUEST_ASSERT(!vmlaunch());
>  	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
>  
> @@ -149,6 +180,18 @@ void guest_code(struct vmx_pages *vmx_pages)
>  	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
>  	current_evmcs->guest_rip += 2; /* rdmsr */
>  
> +	/*
> +	 * L2 TLB flush test. First VMCALL should be handled directly by L0,
> +	 * no VMCALL exit expected.
> +	 */
> +	GUEST_ASSERT(!vmresume());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
> +	current_evmcs->guest_rip += 2; /* rdmsr */
> +	/* Enable synthetic vmexit */
> +	*(u32 *)(vmx_pages->partition_assist) = 1;
> +	GUEST_ASSERT(!vmresume());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH);
> +
>  	GUEST_ASSERT(!vmresume());
>  	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
>  	GUEST_SYNC(11);
> @@ -201,6 +244,7 @@ static void save_restore_vm(struct kvm_vm *vm)
>  int main(int argc, char *argv[])
>  {
>  	vm_vaddr_t vmx_pages_gva = 0;
> +	vm_vaddr_t hcall_page;
>  
>  	struct kvm_vm *vm;
>  	struct kvm_run *run;
> @@ -217,11 +261,15 @@ int main(int argc, char *argv[])
>  		exit(KSFT_SKIP);
>  	}
>  
> +	hcall_page = vm_vaddr_alloc_pages(vm, 1);
> +	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
> +
>  	vcpu_set_hv_cpuid(vm, VCPU_ID);
>  	vcpu_enable_evmcs(vm, VCPU_ID);
>  
>  	vcpu_alloc_vmx(vm, &vmx_pages_gva);
> -	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
> +	vcpu_args_set(vm, VCPU_ID, 2, vmx_pages_gva, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_msr(vm, VCPU_ID, HV_X64_MSR_VP_INDEX, VCPU_ID);
>  
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);

Looks good overall.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



