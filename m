Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC7496E1B
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 22:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiAVVVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 16:21:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230339AbiAVVVy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jan 2022 16:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642886513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uu/ZUweKKjJVMvOwUFTv/e/eF5a0GpR7aY3c+G2pH8I=;
        b=dcbpanwkk5a7eCj57Oaq1dBkcuUQTedcIse74LB6pnSksOY+5Y36W0Osk8tFjKEgz+iiE5
        EnD6PCHgqMmzXWlBuS6IBUrOUonlUVaxboJLEK/WQhp1s9S4E4BaSgYzAtLU6vLKnwvJD+
        qs+cS8AIS7bf/i1Om3PqPFg8u0XNpSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-3hRQtEFAMoWrcShi4LWqnQ-1; Sat, 22 Jan 2022 16:21:52 -0500
X-MC-Unique: 3hRQtEFAMoWrcShi4LWqnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21D3D18397B3;
        Sat, 22 Jan 2022 21:21:51 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDDD2E716;
        Sat, 22 Jan 2022 21:21:48 +0000 (UTC)
Message-ID: <5c84ef95b457091964c3fd0ceac4bb99900018b3.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: nSVM: skip eax alignment check for non-SVM
 instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Denis Valeev <lemniscattaden@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Date:   Sat, 22 Jan 2022 23:21:47 +0200
In-Reply-To: <Yexlhaoe1Fscm59u@q>
References: <Yexlhaoe1Fscm59u@q>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-01-22 at 23:13 +0300, Denis Valeev wrote:
> The bug occurs on #GP triggered by VMware backdoor when eax value is
> unaligned. eax alignment check should not be applied to non-SVM
> instructions because it leads to incorrect omission of the instructions
> emulation.
> Apply the alignment check only to SVM instructions to fix.
> 
> Fixes: d1cba6c92237 ("KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround")
> 
> Signed-off-by: Denis Valeev <lemniscattaden@gmail.com>
> ---
> This bug breaks nyx-fuzz (https://nyx-fuzz.com) that uses VMware backdoor
> as an alternative way for hypercall from guest user-mode. With this bug
> a hypercall interpreted as a GP and leads to process termination.
> 
>  arch/x86/kvm/svm/svm.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e64f16237b60..b5e4731080ef 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2233,10 +2233,6 @@ static int gp_interception(struct kvm_vcpu *vcpu)
>  	if (error_code)
>  		goto reinject;
>  
> -	/* All SVM instructions expect page aligned RAX */
> -	if (svm->vmcb->save.rax & ~PAGE_MASK)
> -		goto reinject;
> -
>  	/* Decode the instruction for usage later */
>  	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
>  		goto reinject;
> @@ -2254,8 +2250,13 @@ static int gp_interception(struct kvm_vcpu *vcpu)
>  		if (!is_guest_mode(vcpu))
>  			return kvm_emulate_instruction(vcpu,
>  				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
> -	} else
> +	} else {
> +		/* All SVM instructions expect page aligned RAX */
> +		if (svm->vmcb->save.rax & ~PAGE_MASK)
> +			goto reinject;
> +
>  		return emulate_svm_instr(vcpu, opcode);
> +	}
>  
>  reinject:
>  	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);


Oops.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Thanks,
Best regards,
	Maxim Levitsky

