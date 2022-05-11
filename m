Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD305232F6
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiEKMTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242301AbiEKMTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9EBC73567
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5XtCAnwLhNu7gFR9U60fmOVLexudYij0/1/sWcFMxkY=;
        b=YpwRNRXOyI4xNPTmiyGeHK/HPGMh8UUlx0D+cgiQgIU0Bnr24+459XtBIoTo40JrS48uMD
        SMBNd+da7oBmlUhSDRMdg/tERWKio+iDfI0n52UwXCCiNE7DnjSZYv6Ew9dwpUPMnn31Zq
        zLlFjhDd6yBlBnIK7gxRQifnqT5WNOo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-rue3oaBuOF-DIJ-l_vhFUQ-1; Wed, 11 May 2022 08:19:22 -0400
X-MC-Unique: rue3oaBuOF-DIJ-l_vhFUQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 744F9185A794;
        Wed, 11 May 2022 12:19:21 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DE72438BD8;
        Wed, 11 May 2022 12:19:18 +0000 (UTC)
Message-ID: <b6cc44cb6cb0ac61c4b919406827be532e8b8cd7.camel@redhat.com>
Subject: Re: [PATCH v3 33/34] KVM: selftests: hyperv_svm_test: Introduce L2
 TLB flush test
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:19:18 +0300
In-Reply-To: <20220414132013.1588929-34-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-34-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> Enable Hyper-V L2 TLB flush and check that Hyper-V TLB flush hypercalls
> from L2 don't exit to L1 unless 'TlbLockCount' is set in the Partition
> assist page.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/x86_64/hyperv_svm_test.c    | 60 +++++++++++++++++--
>  1 file changed, 56 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> index 21f5ca9197da..99f0a2ead7df 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> @@ -42,11 +42,24 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS (1U << 31)
>  
> +#define HV_SVM_EXITCODE_ENL 0xF0000000
> +#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH   (1)
> +
>  static inline void vmmcall(void)
>  {
>  	__asm__ __volatile__("vmmcall");
>  }
>  
> +static inline void hypercall(u64 control, vm_vaddr_t arg1, vm_vaddr_t arg2)
> +{
> +	asm volatile("mov %3, %%r8\n"
> +		     "vmmcall"
> +		     : "+c" (control), "+d" (arg1)
> +		     :  "r" (arg2)
> +		     : "cc", "memory", "rax", "rbx", "r8", "r9", "r10",
> +		       "r11", "r12", "r13", "r14", "r15");
> +}

Yes, this code should really be put in a common file :)

> +
>  void l2_guest_code(void)
>  {
>  	GUEST_SYNC(3);
> @@ -62,11 +75,21 @@ void l2_guest_code(void)
>  
>  	GUEST_SYNC(5);
>  
> +	/* L2 TLB flush tests */
> +	hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +		  HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +	rdmsr(MSR_FS_BASE);
> +	hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +		  HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +	/* Make sure we're not issuing Hyper-V TLB flush call again */
> +	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");
> +
>  	/* Done, exit to L1 and never come back.  */
>  	vmmcall();
>  }
>  
> -static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
> +static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
> +						    vm_vaddr_t pgs_gpa)
>  {
>  	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>  	struct vmcb *vmcb = svm->vmcb;
> @@ -75,13 +98,23 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
>  
>  	GUEST_SYNC(1);
>  
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> +	enable_vp_assist(svm->vp_assist_gpa, svm->vp_assist);
>  
>  	GUEST_ASSERT(svm->vmcb_gpa);
>  	/* Prepare for L2 execution. */
>  	generic_svm_setup(svm, l2_guest_code,
>  			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>  
> +	/* L2 TLB flush setup */
> +	hve->partition_assist_page = svm->partition_assist_gpa;
> +	hve->hv_enlightenments_control.nested_flush_hypercall = 1;
> +	hve->hv_vm_id = 1;
> +	hve->hv_vp_id = 1;
> +	current_vp_assist->nested_control.features.directhypercall = 1;
> +	*(u32 *)(svm->partition_assist) = 0;
> +
>  	GUEST_SYNC(2);
>  	run_guest(vmcb, svm->vmcb_gpa);
>  	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> @@ -116,6 +149,20 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
>  	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
>  	vmcb->save.rip += 2; /* rdmsr */
>  
> +
> +	/*
> +	 * L2 TLB flush test. First VMCALL should be handled directly by L0,
> +	 * no VMCALL exit expected.
> +	 */
> +	run_guest(vmcb, svm->vmcb_gpa);
> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
> +	vmcb->save.rip += 2; /* rdmsr */
> +	/* Enable synthetic vmexit */
> +	*(u32 *)(svm->partition_assist) = 1;
> +	run_guest(vmcb, svm->vmcb_gpa);
> +	GUEST_ASSERT(vmcb->control.exit_code == HV_SVM_EXITCODE_ENL);
> +	GUEST_ASSERT(vmcb->control.exit_info_1 == HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH);
> +
>  	run_guest(vmcb, svm->vmcb_gpa);
>  	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
>  	GUEST_SYNC(6);
> @@ -126,7 +173,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
>  int main(int argc, char *argv[])
>  {
>  	vm_vaddr_t nested_gva = 0;
> -
> +	vm_vaddr_t hcall_page;
>  	struct kvm_vm *vm;
>  	struct kvm_run *run;
>  	struct ucall uc;
> @@ -141,7 +188,12 @@ int main(int argc, char *argv[])
>  	vcpu_set_hv_cpuid(vm, VCPU_ID);
>  	run = vcpu_state(vm, VCPU_ID);
>  	vcpu_alloc_svm(vm, &nested_gva);
> -	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
> +
> +	hcall_page = vm_vaddr_alloc_pages(vm, 1);
> +	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
> +
> +	vcpu_args_set(vm, VCPU_ID, 2, nested_gva, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_msr(vm, VCPU_ID, HV_X64_MSR_VP_INDEX, VCPU_ID);
>  
>  	for (stage = 1;; stage++) {
>  		_vcpu_run(vm, VCPU_ID);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


