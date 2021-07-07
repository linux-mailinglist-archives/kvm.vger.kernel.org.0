Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE73BE667
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 12:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhGGKij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 06:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhGGKij (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 06:38:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625654159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVNk6OIYC0v/uBOVnfJb+zURrA/rvxARCwRIQsrTqyE=;
        b=KohaVrOHJFhYKUn9/6/qb3zI4SIIpmZOSuH1A03l2ecIoasvJ0v7Nw1B0ad2w3SbwuxWAN
        K92Th5otoMzp7+Vaxp6Kiuhe1nM9IGKMQ42WyYmVH25hJoLP3T8VcF9RMJfM9POzEfxW8D
        t9HTtjoBZK/uHR9O07jfF2iyki2oAHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-6Y8aClxhO22KMcbvAdCOqQ-1; Wed, 07 Jul 2021 06:35:58 -0400
X-MC-Unique: 6Y8aClxhO22KMcbvAdCOqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F1F51084F56;
        Wed,  7 Jul 2021 10:35:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 765555C1D5;
        Wed,  7 Jul 2021 10:35:53 +0000 (UTC)
Message-ID: <6fecea5161f17614f1ca745041243332de45fafb.camel@redhat.com>
Subject: Re: [PATCH 6/6] KVM: selftests: smm_test: Test SMM enter from L2
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Jul 2021 13:35:52 +0300
In-Reply-To: <20210628104425.391276-7-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-7-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 12:44 +0200, Vitaly Kuznetsov wrote:
> Two additional tests are added:
> - SMM triggered from L2 does not currupt L1 host state.
> - Save/restore during SMM triggered from L2 does not corrupt guest/host
>   state.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/smm_test.c | 70 +++++++++++++++++--
>  1 file changed, 64 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index c1f831803ad2..d0fe2fdce58c 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -53,15 +53,28 @@ static inline void sync_with_host(uint64_t phase)
>  		     : "+a" (phase));
>  }
>  
> -void self_smi(void)
> +static void self_smi(void)
>  {
>  	x2apic_write_reg(APIC_ICR,
>  			 APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
>  }
>  
> -void guest_code(void *arg)
> +static void l2_guest_code(void)
>  {
> +	sync_with_host(8);
> +
> +	sync_with_host(10);
> +
> +	vmcall();
> +}
> +
> +static void guest_code(void *arg)
> +{
> +	#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>  	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
> +	struct svm_test_data *svm = arg;
> +	struct vmx_pages *vmx_pages = arg;
>  
>  	sync_with_host(1);
>  
> @@ -74,21 +87,50 @@ void guest_code(void *arg)
>  	sync_with_host(4);
>  
>  	if (arg) {
> -		if (cpu_has_svm())
> -			generic_svm_setup(arg, NULL, NULL);
> -		else
> -			GUEST_ASSERT(prepare_for_vmx_operation(arg));
> +		if (cpu_has_svm()) {
> +			generic_svm_setup(svm, l2_guest_code,
> +					  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +		} else {
> +			GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
> +			GUEST_ASSERT(load_vmcs(vmx_pages));
> +			prepare_vmcs(vmx_pages, l2_guest_code,
> +				     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +		}
>  
>  		sync_with_host(5);
>  
>  		self_smi();
>  
>  		sync_with_host(7);
> +
> +		if (cpu_has_svm()) {
> +			run_guest(svm->vmcb, svm->vmcb_gpa);
> +			svm->vmcb->save.rip += 3;
> +			run_guest(svm->vmcb, svm->vmcb_gpa);
> +		} else {
> +			vmlaunch();
> +			vmresume();
> +		}
> +
> +		/* Stages 8-11 are eaten by SMM (SMRAM_STAGE reported instead) */
> +		sync_with_host(12);
>  	}
>  
>  	sync_with_host(DONE);
>  }
>  
> +void inject_smi(struct kvm_vm *vm)
> +{
> +	struct kvm_vcpu_events events;
> +
> +	vcpu_events_get(vm, VCPU_ID, &events);
> +
> +	events.smi.pending = 1;
> +	events.flags |= KVM_VCPUEVENT_VALID_SMM;
> +
> +	vcpu_events_set(vm, VCPU_ID, &events);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	vm_vaddr_t nested_gva = 0;
> @@ -147,6 +189,22 @@ int main(int argc, char *argv[])
>  			    "Unexpected stage: #%x, got %x",
>  			    stage, stage_reported);
>  
> +		/*
> +		 * Enter SMM during L2 execution and check that we correctly
> +		 * return from it. Do not perform save/restore while in SMM yet.
> +		 */
> +		if (stage == 8) {
> +			inject_smi(vm);
> +			continue;
> +		}
> +
> +		/*
> +		 * Perform save/restore while the guest is in SMM triggered
> +		 * during L2 execution.
> +		 */
> +		if (stage == 10)
> +			inject_smi(vm);
> +
>  		state = vcpu_save_state(vm, VCPU_ID);
>  		kvm_vm_release(vm);
>  		kvm_vm_restart(vm, O_RDWR);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

