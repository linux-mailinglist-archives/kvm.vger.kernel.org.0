Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7452F60BA
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 13:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbhANMGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 07:06:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbhANMGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 07:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610625881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3tJ36RqztAwI/4mUqJycCjvUbsiIODgTF0FZus4SkE=;
        b=T7bfjLT96d5kLt9+hfG70cQTWFiSd9jmnCgbwqRPF/hRZcens9U9Y10KAo/xW1cj2dcdSt
        CXM7Z9X9GLxcrFD8Jykc6U37XJkH6dt6N54whAMQpgVZ9bEzRdEYA7ftFxU1ZNku7EBdJe
        6axVoKt4gwVq9+XBi1Vgv3rVS/fL3gs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-FHRl8kfFNzS0vchBb2NoGw-1; Thu, 14 Jan 2021 07:04:39 -0500
X-MC-Unique: FHRl8kfFNzS0vchBb2NoGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB4358042B1;
        Thu, 14 Jan 2021 12:04:37 +0000 (UTC)
Received: from starship (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 924B410016F4;
        Thu, 14 Jan 2021 12:04:30 +0000 (UTC)
Message-ID: <e3b48b0d753c9412e8bc163562059ab079984117.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for VMCB address check change
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com
Date:   Thu, 14 Jan 2021 14:04:29 +0200
In-Reply-To: <20210112063703.539893-2-wei.huang2@amd.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
         <20210112063703.539893-2-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-12 at 00:37 -0600, Wei Huang wrote:
> New AMD CPUs have a change that checks VMEXIT intercept on special SVM
> instructions before checking their EAX against reserved memory region.
> This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, KVM
> doesn't need to intercept and emulate #GP faults for such instructions
> because #GP isn't supposed to be triggered.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/svm/svm.c             | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
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
Why ""?

>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 74620d32aa82..451b82df2eab 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -311,7 +311,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
>  	/* Enable GP interception for SVM instructions if needed */
> -	if (efer & EFER_SVME)
> +	if ((efer & EFER_SVME) && !boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
>  		set_exception_intercept(svm, GP_VECTOR);

As mentioned in the review for the other patch I would add a flag that
would enable the workaround for the errata, and I would force it disabled
if X86_FEATURE_SVME_ADDR_CHK is set in CPUID somewhere early in the 
kvm initialization.

And finally that new flag can be used here to enable the #GP interception
in the above code.

>  
>  	return 0;


Best regards,
	Maxim Levitsky

