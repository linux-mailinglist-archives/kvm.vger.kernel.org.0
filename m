Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99633DD68F
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhHBNKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:10:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233847AbhHBNKn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 09:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627909834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=meg1NESbxhnzc1879js+2kXhLBJB0oVE1RKNqq+dWI8=;
        b=V2lK+rcQuXJXVGqkT9pBwco83ZxJZ0i+QdaVkus1cGWrV2ycLdMNDe0+V4/JzfxNIe4NnF
        d+Q5dlqq+R6iIPgZkNBJvD13uokZwTnwveFrepUUlTvUea5bOsXPY9hDK3vQkTzqSubmnq
        CuIKOXgCW8rke755rCXR+QNEAMvYxqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-5c_54cPBOC-2jvGmguKDsA-1; Mon, 02 Aug 2021 09:10:30 -0400
X-MC-Unique: 5c_54cPBOC-2jvGmguKDsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C50FB100F764;
        Mon,  2 Aug 2021 13:10:29 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8FBC17567;
        Mon,  2 Aug 2021 13:10:28 +0000 (UTC)
Message-ID: <4792fca66e009a5164a178765c6eb32da7d7d3e7.camel@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: remove useless kvm_clear_*_queue
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Mon, 02 Aug 2021 16:10:27 +0300
In-Reply-To: <20210802125634.309874-1-pbonzini@redhat.com>
References: <20210802125634.309874-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-02 at 08:56 -0400, Paolo Bonzini wrote:
> For an event to be in injected state when nested_svm_vmrun executes,
> it must have come from exitintinfo when svm_complete_interrupts ran:
> 
>   vcpu_enter_guest
>    static_call(kvm_x86_run) -> svm_vcpu_run
>     svm_complete_interrupts
>      // now the event went from "exitintinfo" to "injected"
>    static_call(kvm_x86_handle_exit) -> handle_exit
>     svm_invoke_exit_handler
>       vmrun_interception
>        nested_svm_vmrun
> 
> However, no event could have been in exitintinfo before a VMRUN
> vmexit.  The code in svm.c is a bit more permissive than the one
> in vmx.c:
> 
>         if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
>             exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
>             exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
>             exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
> 
> but in any case, a VMRUN instruction would not even start to execute
> during an attempted event delivery.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 61738ff8ef33..5e13357da21e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -659,11 +659,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		goto out;
>  	}
>  
> -
> -	/* Clear internal status */
> -	kvm_clear_exception_queue(vcpu);
> -	kvm_clear_interrupt_queue(vcpu);
> -
>  	/*
>  	 * Since vmcb01 is not in use, we can use it to store some of the L1
>  	 * state.
100% agree.

As I say, Intel's architects weren't crazy enough to implement an VM IDT gate
(switch to a VM on interrupt....), and so indeed that this isn't possible.
They do have a task gate... thankfully it is legacy.

I would still keep a WARN_ON_ONCE here just in case.

Note that in theory one can force an injected/queued exception with KVM_SET_VCPU_EVENTS
on RIP that points to VMRUN instruction. Its user fault though.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

