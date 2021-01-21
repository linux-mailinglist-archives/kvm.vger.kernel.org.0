Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A015B2FECAC
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbhAUOKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:10:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730741AbhAUOKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 09:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611238101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMcHKpd5olPCrljEsHJzEDGM/QkJwlfikRtLjhPGiCU=;
        b=WaStizNv69T9NjDUPfWsCa8szM8blNOh81YZuZbv3i3sml2Dad//D7+TQP0/E1XgYz00wt
        YRE76peyY7+JCPImBApos5wkgsj1PfbAH1GKahjHDsQY8vmOY+Q2BGrt/CR84yD58r5P3m
        LN2arVJpJM7WKncoKDh9efhUOAqnXgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-D9xhOjKcOci_lKvsnP6gdg-1; Thu, 21 Jan 2021 09:08:17 -0500
X-MC-Unique: D9xhOjKcOci_lKvsnP6gdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C092A10054FF;
        Thu, 21 Jan 2021 14:08:15 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D4DB100AE34;
        Thu, 21 Jan 2021 14:08:06 +0000 (UTC)
Message-ID: <875c479be58bff8824fef7ef148ae7826c871790.camel@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Add support for VMCB address check
 change
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Thu, 21 Jan 2021 16:08:05 +0200
In-Reply-To: <20210121065508.1169585-4-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
         <20210121065508.1169585-4-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 01:55 -0500, Wei Huang wrote:
> New AMD CPUs have a change that checks VMEXIT intercept on special SVM
> instructions before checking their EAX against reserved memory region.
> This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, #VMEXIT
> is triggered before #GP. KVM doesn't need to intercept and emulate #GP
> faults as #GP is supposed to be triggered.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/svm/svm.c             | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..ea89d6fdd79a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -337,6 +337,7 @@
>  #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
>  #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
>  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
> +#define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6ed523cab068..2a12870ac71a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -313,7 +313,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
>  	/* Enable #GP interception for SVM instructions */
> -	set_exception_intercept(svm, GP_VECTOR);
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SVME_ADDR_CHK))
> +		set_exception_intercept(svm, GP_VECTOR);
>  
>  	return 0;
>  }
> @@ -933,6 +934,9 @@ static __init void svm_set_cpu_caps(void)
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  
> +	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
> +		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
> +
>  	/* Enable INVPCID feature */
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

