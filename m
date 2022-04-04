Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835784F1287
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 12:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355515AbiDDKF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 06:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbiDDKFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 06:05:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26A95BD6
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 03:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649066608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QC9rOv32hNoZyMQxIw0ucfBMj+GvgGFHUYt+HTU2Wyc=;
        b=SsvTyUhlBlEDF1Us2nakp+9OdCdsWqN4DLYGeT/CUd87TgD787Fkddz6uOv9nJzIJtPVYW
        KInRRY59XuimCD1gT1r6SJznito4pvITSAf+mC9hrgKszpvljxMtmakJ2/l4sR1qIUqisi
        /DmPA/JuieTCtFaNSzQuivChRiCi5/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-O6ZcP4W7MSGeCzRw2Wswvw-1; Mon, 04 Apr 2022 06:03:25 -0400
X-MC-Unique: O6ZcP4W7MSGeCzRw2Wswvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D32185A5BC;
        Mon,  4 Apr 2022 10:03:24 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E36EC5355D;
        Mon,  4 Apr 2022 10:03:22 +0000 (UTC)
Message-ID: <2b26dd9569a0ae7a3d1fe1eab08010324d77e245.camel@redhat.com>
Subject: Re: [PATCH 3/8] KVM: SVM: Unwind "speculative" RIP advancement if
 INTn injection "fails"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Mon, 04 Apr 2022 13:03:21 +0300
In-Reply-To: <20220402010903.727604-4-seanjc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
         <20220402010903.727604-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-02 at 01:08 +0000, Sean Christopherson wrote:
> Unwind the RIP advancement done by svm_queue_exception() when injecting
> an INT3 ultimately "fails" due to the CPU encountering a VM-Exit while
> vectoring the injected event, even if the exception reported by the CPU
> isn't the same event that was injected.  If vectoring INT3 encounters an
> exception, e.g. #NP, and vectoring the #NP encounters an intercepted
> exception, e.g. #PF when KVM is using shadow paging, then the #NP will
> be reported as the event that was in-progress.
> 
> Note, this is still imperfect, as it will get a false positive if the
> INT3 is cleanly injected, no VM-Exit occurs before the IRET from the INT3
> handler in the guest, the instruction following the INT3 generates an
> exception (directly or indirectly), _and_ vectoring that exception
> encounters an exception that is intercepted by KVM.  The false positives
> could theoretically be solved by further analyzing the vectoring event,
> e.g. by comparing the error code against the expected error code were an
> exception to occur when vectoring the original injected exception, but
> SVM without NRIPS is a complete disaster, trying to make it 100% correct
> is a waste of time.

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2c86bd9176c6..30cef3b10838 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3699,6 +3699,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>  	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
>  	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
>  
> +	/*
> +	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
> +	 * injecting the soft exception/interrupt.  That advancement needs to
> +	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
> +	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
> +	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
> +	 * be the reported vectored event, but RIP still needs to be unwound.
> +	 */
> +	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
> +	   kvm_is_linear_rip(vcpu, svm->int3_rip))
> +		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
> +
>  	switch (type) {
>  	case SVM_EXITINTINFO_TYPE_NMI:
>  		vcpu->arch.nmi_injected = true;
> @@ -3715,13 +3727,9 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>  		 * but re-execute the instruction instead. Rewind RIP first
>  		 * if we emulated INT3 before.
>  		 */
> -		if (kvm_exception_is_soft(vector)) {
> -			if (vector == BP_VECTOR && int3_injected &&
> -			    kvm_is_linear_rip(vcpu, svm->int3_rip))
> -				kvm_rip_write(vcpu,
> -					      kvm_rip_read(vcpu) - int3_injected);
> +		if (kvm_exception_is_soft(vector))
>  			break;
> -		}
> +
>  		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
>  			u32 err = svm->vmcb->control.exit_int_info_err;
>  			kvm_requeue_exception_e(vcpu, vector, err);


