Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B45A2FEDCE
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbhAUO6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:58:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbhAUO6D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 09:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611240996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8nCcl62e6GfJVT0Q+3a0+mnSZi/+Kdfk1t5E0aKT7a0=;
        b=f6nY/lVqirZIK/epavrjAhAAb6AAWlz+smeF80+tcnQ4ZocfPE+3JfXEJgreBGwHrogzN9
        KQpPF7COXlbDSL185lLLj06HNLCXhB6RKkonaaQakmZEXjYgoXgvZ/Pls+jDWbp70qZ7E3
        vo8hXYq+OHFGdttVxjd/tJ0jHi2VIgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-z2uOodC7PMq_brP9sYullA-1; Thu, 21 Jan 2021 09:56:33 -0500
X-MC-Unique: z2uOodC7PMq_brP9sYullA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58BEA10151EC;
        Thu, 21 Jan 2021 14:56:31 +0000 (UTC)
Received: from work-vm (ovpn-115-101.ams2.redhat.com [10.36.115.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05C066E51B;
        Thu, 21 Jan 2021 14:56:24 +0000 (UTC)
Date:   Thu, 21 Jan 2021 14:56:22 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, mlevitsk@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        luto@amacapital.net
Subject: Re: [PATCH v2 4/4] KVM: SVM: Support #GP handling for the case of
 nested on nested
Message-ID: <20210121145622.GH3072@work-vm>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
 <20210121065508.1169585-5-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121065508.1169585-5-wei.huang2@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Wei Huang (wei.huang2@amd.com) wrote:
> Under the case of nested on nested (e.g. L0->L1->L2->L3), #GP triggered
> by SVM instructions can be hided from L1. Instead the hypervisor can
> inject the proper #VMEXIT to inform L1 of what is happening. Thus L1
> can avoid invoking the #GP workaround. For this reason we turns on
> guest VM's X86_FEATURE_SVME_ADDR_CHK bit for KVM running inside VM to
> receive the notification and change behavior.

Doesn't this mean a VM migrated between levels (hmm L2 to L1???) would
see different behaviour?
(I've never tried such a migration, but I thought in principal it should
work).

Dave


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
> -- 
> 2.27.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

