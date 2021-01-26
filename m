Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3480303C68
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 13:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405481AbhAZMBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 07:01:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405206AbhAZMBb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 07:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611662399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0K+uxPNJ6B3Dq1KRGq+oPPt+0m7OL0bJ7iaA9EZ6ZgM=;
        b=bi8m2JZ+8GoT33FjE+ojG//yGmkbosWHa1KiEU4f4d+89uAjrQjZVQbaxjaVddxJhFY9JD
        EBEX+GbLAKVz+YRT91J/5ZtpyewE6aEiStU20PfAm14l6xuJs/Dnx0RH5Y5TsRSApBuZ3b
        DJVxe12AQbCaHu1oGHQ2dL7vH6TrfcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-w5tS4UMfMiCqw4OIpTAjVw-1; Tue, 26 Jan 2021 06:59:58 -0500
X-MC-Unique: w5tS4UMfMiCqw4OIpTAjVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AACF180A086;
        Tue, 26 Jan 2021 11:59:56 +0000 (UTC)
Received: from starship (unknown [10.35.206.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71B6460C62;
        Tue, 26 Jan 2021 11:59:49 +0000 (UTC)
Message-ID: <b636e2d15ab17302265ef932575f26647b7a959f.camel@redhat.com>
Subject: Re: [PATCH v3 4/4] KVM: SVM: Support #GP handling for the case of
 nested on nested
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Tue, 26 Jan 2021 13:59:48 +0200
In-Reply-To: <20210126081831.570253-5-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
         <20210126081831.570253-5-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 03:18 -0500, Wei Huang wrote:
> Under the case of nested on nested (L0->L1->L2->L3), #GP triggered by
> SVM instructions can be hided from L1. Instead the hypervisor can
> inject the proper #VMEXIT to inform L1 of what is happening. Thus L1
> can avoid invoking the #GP workaround. For this reason we turns on
> guest VM's X86_FEATURE_SVME_ADDR_CHK bit for KVM running inside VM to
> receive the notification and change behavior.
> 
> Similarly we check if vcpu is under guest mode before emulating the
> vmware-backdoor instructions. For the case of nested on nested, we
> let the guest handle it.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f9233c79265b..83c401d2709f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -929,6 +929,9 @@ static __init void svm_set_cpu_caps(void)
>  
>  		if (npt_enabled)
>  			kvm_cpu_cap_set(X86_FEATURE_NPT);
> +
> +		/* Nested VM can receive #VMEXIT instead of triggering #GP */
> +		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>  	}
>  
>  	/* CPUID 0x80000008 */
> @@ -2198,6 +2201,11 @@ static int svm_instr_opcode(struct kvm_vcpu *vcpu)
>  
>  static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
>  {
> +	const int guest_mode_exit_codes[] = {
> +		[SVM_INSTR_VMRUN] = SVM_EXIT_VMRUN,
> +		[SVM_INSTR_VMLOAD] = SVM_EXIT_VMLOAD,
> +		[SVM_INSTR_VMSAVE] = SVM_EXIT_VMSAVE,
> +	};
>  	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
>  		[SVM_INSTR_VMRUN] = vmrun_interception,
>  		[SVM_INSTR_VMLOAD] = vmload_interception,
> @@ -2205,7 +2213,14 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
>  	};
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	return svm_instr_handlers[opcode](svm);
> +	if (is_guest_mode(vcpu)) {
> +		svm->vmcb->control.exit_code = guest_mode_exit_codes[opcode];
> +		svm->vmcb->control.exit_info_1 = 0;
> +		svm->vmcb->control.exit_info_2 = 0;
> +
> +		return nested_svm_vmexit(svm);
> +	} else
> +		return svm_instr_handlers[opcode](svm);
>  }
>  
>  /*
> @@ -2239,7 +2254,8 @@ static int gp_interception(struct vcpu_svm *svm)
>  		 * VMware backdoor emulation on #GP interception only handles
>  		 * IN{S}, OUT{S}, and RDPMC.
>  		 */
> -		return kvm_emulate_instruction(vcpu,
> +		if (!is_guest_mode(vcpu))
> +			return kvm_emulate_instruction(vcpu,
>  				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
>  	} else
>  		return emulate_svm_instr(vcpu, opcode);

To be honest I expected the vmware backdoor fix to be in a separate patch,
but I see that Paulo already took these patches so I guess it is too late.

Anyway I am very happy to see this workaround merged, and see that bug
disappear forever.

Best regards,
	Maxim Levitsky

