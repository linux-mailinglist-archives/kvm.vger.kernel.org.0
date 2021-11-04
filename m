Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7236445CAE
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 00:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhKDXfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 19:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhKDXfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 19:35:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8528FC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 16:33:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x131so2098396pfc.12
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 16:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xQkHlczowz4cF3xI4LESyMCdXvvGR6+A+FIhCOCB1Qk=;
        b=slfdqPT2pINyOKYu5hfJ7xLmo/sMMgsrcuZVf3VWRxJCGqba5c+hHPczMaqRFa8wAn
         wMi+Aff68kV6fg+VOuuiioeBUWPhhFwBy0KIwdKFlt/A/zN3RT3ijw+ybgmWnBKPGrei
         PrC9xqE8tk0O/oJe4KGyJzFt7jA3WZYlwCGLVXYy9NSP+8MedyG3e91mGDr+z4IYYd0F
         s/JaL+do4BHNmMwR9/sOPoqQ3CW0B/dX40XijSj4A0amVgr+GmXz/HEb6XjcXxXRdAZb
         qRLr1Q8GQzIVfWicDe/6HpLCD+seEuGgYn+7rAMjSOt4jDvkG+0N+J0sFFyIZvxhR/da
         Ek9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xQkHlczowz4cF3xI4LESyMCdXvvGR6+A+FIhCOCB1Qk=;
        b=NQ28Hh6QauyEMcm/SmD46Q7AH7I1D51T1Rc6G18+QA2C4xNDVmX0uWYBy/jn/KtB1K
         6H8KWVlQ1Mzh4NcuKmVbARwZ6nejAtz8JMjKoMEoy9OQxhPd+HJUaeG1DMYh0alCY96V
         PfSGOgqQzY5MvT+7/H1TMDLoOnsOKq5yDzZ4eMuGdIu4gFH/V3ZHPhouoknWSrWTPOsu
         DmZp/k4PU1C+vpPECs5rMQvZpPkM0I0aZSccmNMmh/P3JL/7lRm5DrdVyyAU0s4Nv6sZ
         qtHqCP8FewgcNrarHHDMlrp5ofAIxZPqb4gjgxaIJay0xF9EKtZfxP0fTPFssONj6MpM
         Rutg==
X-Gm-Message-State: AOAM530RaWqgvPIGNJFI2KgXfEAfhNbbg1gsAgSqBcZIJDa+uGq9j/R2
        Mn8zB05+erw47bbdJ0i9hx37TA==
X-Google-Smtp-Source: ABdhPJzGtaANm9Q0WaXKWxinP2q1eK7Jl4ZKqm13nWxG+ytoiJ4ZwXPRWA9HtgQr8rsApra+7sHzUw==
X-Received: by 2002:a65:6a0a:: with SMTP id m10mr40722253pgu.82.1636068787912;
        Thu, 04 Nov 2021 16:33:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h11sm6349160pfc.131.2021.11.04.16.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 16:33:07 -0700 (PDT)
Date:   Thu, 4 Nov 2021 23:33:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V11 3/5] KVM: SEV: Add support for SEV-ES intra host
 migration
Message-ID: <YYRtr4xINL4MkwGx@google.com>
References: <20211021174303.385706-1-pgonda@google.com>
 <20211021174303.385706-4-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021174303.385706-4-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021, Peter Gonda wrote:
> ---
>  arch/x86/kvm/svm/sev.c | 50 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2c2f724c9096..d8ce93fd1129 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1605,6 +1605,48 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>  	list_replace_init(&src->regions_list, &dst->regions_list);
>  }
>  
> +static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> +{
> +	int i;
> +	struct kvm_vcpu *dst_vcpu, *src_vcpu;
> +	struct vcpu_svm *dst_svm, *src_svm;

What do you think about following the style of svm_vm_migrate_from(), where the
"dst" is simply "kvm"?  I like that because (a) it shortens all of these lines,
and (b) conveys the idea that the functions are running in the context of "this"
kvm, as opposed to being a third party that operates on an unrelated source and
destination.

> +
> +	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
> +		return -EINVAL;
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		if (!src_vcpu->arch.guest_state_protected)
> +			return -EINVAL;
> +	}
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		src_svm = to_svm(src_vcpu);
> +		dst_vcpu = kvm_get_vcpu(dst, i);
> +		dst_svm = to_svm(dst_vcpu);
> +
> +		/*
> +		 * Transfer VMSA and GHCB state to the destination.  Nullify and
> +		 * clear source fields as appropriate, the state now belongs to
> +		 * the destination.
> +		 */
> +		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;

vcpu_id is an odd thing to copy over.  That's fully controlled by userspace, and
is effectively immutable in KVM.  I don't think SEV-ES should be touching anything
besides SEV-ES state.

> +		dst_svm->sev_es = src_svm->sev_es;

Uber nit, maybe use memcpy() to "pair" with the memset() below?

> +		dst_svm->vmcb->control.ghcb_gpa =
> +			src_svm->vmcb->control.ghcb_gpa;
> +		dst_svm->vmcb->control.vmsa_pa = __pa(dst_svm->sev_es.vmsa);

Oof!  This _looks_ wrong, but it's not because dst_svm->sev_es.vmsa is copied
from the source in that subtle not-memcpy()-memcpy above.  The result of __pa()
absolutely will not change, so I would say just do the obvious

		dst_svm->vmcb->control.vmsa_pa = src_svm->vmcb->control.vmsa_pa;

and not force readers to think too hard.  That also avoids breakage if the order
is changed.

> +		dst_vcpu->arch.guest_state_protected = true;
> +
> +		memset(&src_svm->sev_es, 0, sizeof(src_svm->sev_es));
> +		src_svm->vmcb->control.ghcb_gpa = 0;
> +		src_svm->vmcb->control.vmsa_pa = 0;

'0' is not an invalid (G)PA.  INVALID_PAGE would be the most appropriate.

> +		src_vcpu->arch.guest_state_protected = false;
> +	}
> +	to_kvm_svm(src)->sev_info.es_active = false;
> +	to_kvm_svm(dst)->sev_info.es_active = true;
> +
> +	return 0;
> +}
> +
>  int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>  {
>  	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;

And if we do the above s/dst_//, do it here as well.

> @@ -1633,7 +1675,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>  	if (ret)
>  		goto out_fput;
>  
> -	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> +	if (!sev_guest(source_kvm)) {
>  		ret = -EINVAL;
>  		goto out_source;
>  	}
> @@ -1644,6 +1686,12 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>  	if (ret)
>  		goto out_source_vcpu;
>  
> +	if (sev_es_guest(source_kvm)) {
> +		ret = sev_es_migrate_from(kvm, source_kvm);
> +		if (ret)
> +			goto out_source_vcpu;
> +	}
> +
>  	sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
>  	kvm_for_each_vcpu (i, vcpu, source_kvm) {
>  		kvm_vcpu_reset(vcpu, /* init_event= */ false);
> -- 
> 2.33.0.1079.g6e70778dc9-goog
> 
