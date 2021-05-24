Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5884E38E6B6
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhEXMiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:38:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232389AbhEXMiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TU9JFGb98TwfxNEATQSa4BRYEe1Afr7B5gEsKljFCxY=;
        b=RXM1evSjhbFiTQ4ot57Qdd6AMJ47sWC3Gjo+sb5fKtVqTzG7iuSXC63LbMSpe0zn1qYOoG
        zUyU/IUMz/YpxClR72sTpWT0jnbKpzxl+4q69ies6wvi+aZsXY/3PjRKLE98Nscpg89aDj
        DIs1RM22mx1LZ+lVdupF+3bMAHGcd7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-cjR2KybPP3iDeSUbNr5fIA-1; Mon, 24 May 2021 08:36:45 -0400
X-MC-Unique: cjR2KybPP3iDeSUbNr5fIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3117F1B18BED;
        Mon, 24 May 2021 12:36:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ECB3189C4;
        Mon, 24 May 2021 12:36:16 +0000 (UTC)
Message-ID: <4b0f9fbea71bd779164e8a703f94fb68ae0d43df.camel@redhat.com>
Subject: Re: [PATCH v2 7/7] KVM: selftests: evmcs_test: Test that
 KVM_STATE_NESTED_EVMCS is never lost
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Mon, 24 May 2021 15:36:15 +0300
In-Reply-To: <20210517135054.1914802-8-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <20210517135054.1914802-8-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> Do KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE for a freshly restored VM
> (before the first KVM_RUN) to check that KVM_STATE_NESTED_EVMCS is not
> lost.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 64 +++++++++++--------
>  1 file changed, 38 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index 63096cea26c6..fcef347a681a 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -121,14 +121,38 @@ void inject_nmi(struct kvm_vm *vm)
>  	vcpu_events_set(vm, VCPU_ID, &events);
>  }
>  
> +static void save_restore_vm(struct kvm_vm *vm)
> +{
> +	struct kvm_regs regs1, regs2;
> +	struct kvm_x86_state *state;
> +
> +	state = vcpu_save_state(vm, VCPU_ID);
> +	memset(&regs1, 0, sizeof(regs1));
> +	vcpu_regs_get(vm, VCPU_ID, &regs1);
> +
> +	kvm_vm_release(vm);
> +
> +	/* Restore state in a new VM.  */
> +	kvm_vm_restart(vm, O_RDWR);
> +	vm_vcpu_add(vm, VCPU_ID);
> +	vcpu_set_hv_cpuid(vm, VCPU_ID);
> +	vcpu_enable_evmcs(vm, VCPU_ID);
> +	vcpu_load_state(vm, VCPU_ID, state);
> +	free(state);
> +
> +	memset(&regs2, 0, sizeof(regs2));
> +	vcpu_regs_get(vm, VCPU_ID, &regs2);
> +	TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
> +		    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
> +		    (ulong) regs2.rdi, (ulong) regs2.rsi);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	vm_vaddr_t vmx_pages_gva = 0;
>  
> -	struct kvm_regs regs1, regs2;
>  	struct kvm_vm *vm;
>  	struct kvm_run *run;
> -	struct kvm_x86_state *state;
>  	struct ucall uc;
>  	int stage;
>  
> @@ -145,10 +169,6 @@ int main(int argc, char *argv[])
>  	vcpu_set_hv_cpuid(vm, VCPU_ID);
>  	vcpu_enable_evmcs(vm, VCPU_ID);
>  
> -	run = vcpu_state(vm, VCPU_ID);
> -
> -	vcpu_regs_get(vm, VCPU_ID, &regs1);
> -
>  	vcpu_alloc_vmx(vm, &vmx_pages_gva);
>  	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
>  
> @@ -160,6 +180,7 @@ int main(int argc, char *argv[])
>  	pr_info("Running L1 which uses EVMCS to run L2\n");
>  
>  	for (stage = 1;; stage++) {
> +		run = vcpu_state(vm, VCPU_ID);
>  		_vcpu_run(vm, VCPU_ID);
>  		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
>  			    "Stage %d: unexpected exit reason: %u (%s),\n",
> @@ -184,32 +205,23 @@ int main(int argc, char *argv[])
>  			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
>  			    stage, (ulong)uc.args[1]);
>  
> -		state = vcpu_save_state(vm, VCPU_ID);
> -		memset(&regs1, 0, sizeof(regs1));
> -		vcpu_regs_get(vm, VCPU_ID, &regs1);
> -
> -		kvm_vm_release(vm);
> -
> -		/* Restore state in a new VM.  */
> -		kvm_vm_restart(vm, O_RDWR);
> -		vm_vcpu_add(vm, VCPU_ID);
> -		vcpu_set_hv_cpuid(vm, VCPU_ID);
> -		vcpu_enable_evmcs(vm, VCPU_ID);
> -		vcpu_load_state(vm, VCPU_ID, state);
> -		run = vcpu_state(vm, VCPU_ID);
> -		free(state);
> -
> -		memset(&regs2, 0, sizeof(regs2));
> -		vcpu_regs_get(vm, VCPU_ID, &regs2);
> -		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
> -			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
> -			    (ulong) regs2.rdi, (ulong) regs2.rsi);
> +		save_restore_vm(vm);
>  
>  		/* Force immediate L2->L1 exit before resuming */
>  		if (stage == 8) {
>  			pr_info("Injecting NMI into L1 before L2 had a chance to run after restore\n");
>  			inject_nmi(vm);
>  		}
> +
> +		/*
> +		 * Do KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE for a freshly
> +		 * restored VM (before the first KVM_RUN) to check that
> +		 * KVM_STATE_NESTED_EVMCS is not lost.
> +		 */
> +		if (stage == 9) {
> +			pr_info("Trying extra KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE cycle\n");
> +			save_restore_vm(vm);
> +		}
>  	}
>  
>  done:


This is a very good test. I do think that in the future we should move save_restore_vm
to common code so that I could test SVM nested migration (and plain VMX nested migration) 
in a similar way.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



