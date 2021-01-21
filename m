Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728392FECB9
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbhAUORQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:17:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730895AbhAUOKy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 09:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611238167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iY0F1HjXNJUO6BcUDa/G2LyHIZyKYWvLc6Sl9LmQKQY=;
        b=hQH3UzYbEpsPdU3R6j1NwaOmvC3ToRUXxLm/vAZeaOPHBJQUq5WlzPr6WUS6r36xjN6E3j
        2uTe+at3d0zYO6UJULQxng3XUjl3xz7e2+kmAMgYxEreVHdDCErDrZeZwUUiPM/hs4b/eH
        vLZY0qKdw3wWLDPLN2WXHZyOwzgyok0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-hb7R-ZLcOA-DQ9ni-fqHKA-1; Thu, 21 Jan 2021 09:09:26 -0500
X-MC-Unique: hb7R-ZLcOA-DQ9ni-fqHKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56D1DCC620;
        Thu, 21 Jan 2021 14:09:24 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 601AD6E528;
        Thu, 21 Jan 2021 14:09:16 +0000 (UTC)
Message-ID: <0fb162dbfd082f0a7581fbe942dd51711da9d3aa.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Support #GP handling for the case of
 nested on nested
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Thu, 21 Jan 2021 16:09:15 +0200
In-Reply-To: <20210121065508.1169585-5-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
         <20210121065508.1169585-5-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 01:55 -0500, Wei Huang wrote:
> Under the case of nested on nested (e.g. L0->L1->L2->L3), #GP triggered
> by SVM instructions can be hided from L1. Instead the hypervisor can
> inject the proper #VMEXIT to inform L1 of what is happening. Thus L1
> can avoid invoking the #GP workaround. For this reason we turns on
> guest VM's X86_FEATURE_SVME_ADDR_CHK bit for KVM running inside VM to
> receive the notification and change behavior.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2a12870ac71a..89512c0e7663 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2196,6 +2196,11 @@ static int svm_instr_opcode(struct kvm_vcpu *vcpu)
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
> @@ -2203,7 +2208,14 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
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
> @@ -4034,6 +4046,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	/* Check again if INVPCID interception if required */
>  	svm_check_invpcid(svm);
>  
> +	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM)) {
> +		best = kvm_find_cpuid_entry(vcpu, 0x8000000A, 0);
> +		best->edx |= (1 << 28);
> +	}
> +
>  	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
>  	if (sev_guest(vcpu->kvm)) {
>  		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);

Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

